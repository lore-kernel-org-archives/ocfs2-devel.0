From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 17 Sep 2009 09:29:14 -0700 (PDT)
Subject: [Ocfs2-devel] [GIT PULL] ocfs2 changes for 2.6.32
In-Reply-To: <20090916044047.GA30453@mail.oracle.com>
References: <20090914221434.GA4507@mail.oracle.com>
	<alpine.LFD.2.01.0909141614350.4950@localhost.localdomain>
	<20090915000417.GC4507@mail.oracle.com>
	<alpine.LFD.2.01.0909141727150.4950@localhost.localdomain>
	<20090915005417.GD4507@mail.oracle.com>
	<alpine.LFD.2.01.0909141828070.4950@localhost.localdomain>
	<20090915040601.GE4507@mail.oracle.com>
	<alpine.LFD.2.01.0909150923180.4950@localhost.localdomain>
	<20090915214530.GA11060@mail.oracle.com>
	<alpine.LFD.2.01.0909152116180.4950@localhost.localdomain>
	<20090916044047.GA30453@mail.oracle.com>
Message-ID: <alpine.LFD.2.01.0909170856050.4950@localhost.localdomain>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joel Becker <Joel.Becker@oracle.com>
Cc: Mark Fasheh <mfasheh@suse.com>, Andrew Morton <akpm@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, ocfs2-devel@oss.oracle.com



On Tue, 15 Sep 2009, Joel Becker wrote:
> 
> 	Ok.  Where do you see the exposure level?  What I mean is, I
> just defined a vfs op that handles these things, but accessed it via two
> syscalls, sys_snapfile() and sys_copyfile().  We could also just provide
> one system call and allow userspace to use these flags itself, creating
> snapfile(3) and copyfile(3) in libc

Why would anybody want to hide it at all? Why even the libc hiding?

Nobody is going to use this except for special apps. Let them see what 
they can do, in all its glory. 

> > I still worry that especially the non-atomic case will want some kind of 
> > partial-copy updates (think graphical file managers that want to show the 
> > progress of the copy), and that (think EINTR and continuing) makes me 
> > think "that could get really complex really quickly", but that's something 
> > that the NFS/SMB people would have to pipe up on. I'm pretty sure the NFS 
> > spec has some kind "partial completion notification" model, I dunno about 
> > SMB.
> 
> 	I'm really wary of combining a ranged interface with this one.
> Not only does it make no sense for snapshots, but I think it falls down
> in any "create a new inode" scheme entirely.

Oh, I wouldn't suggest a ranged interface, just one that allows for status 
updates and cancelling - _if_ the initial op isn't atomic to begin with. 
There's also the issue of concurrency in IO: maybe you want to start 
several things without necessarily waiting for them (think high-throughput 
"cp -R" on NFS or something like that).

So I'd suggest something like having two system calls: one to start the 
operation, and one to control it. And for a filesystem that does atomic 
copies, the 'start' one obviously would also finish it, so the 'control' 
it would be a no-op, because there would never be any outstanding ones.

See what I'm saying? It wouldn't complicate _your_ life, but it would 
allow for filesystems that can't do it atomically (or even quickly).

So the first one would be something like

	int copyfile(const char *src, const char *dest, unsigned long flags);

which would return:

 - zero on success
 - negative (with errno) on error
 - positive cookie on "I started it, here's my cookie". For extra bonus 
   points, maybe the cookie would actually be a file descriptor (for 
   poll/select users), but it would _not_ be a file descriptor to the 
   resulting _file_, it would literally be a "cookie" to the actual 
   copyfile event.

and then for ocfs2 you'd never return positive cookies. You'd never have 
to worry about it.

Then the second interface would be something like

	int copyfile_ctrl(long cookie, unsigned long cmd);

where you'd just have some way to wait for completion and ask how much has 
been copied. The 'cmd' would be some set of 'cancel', 'status' or 
'uninterruptible wait' or whatever, and the return value would again be

 - negative (with errno) for errors (copy failed) - cookie released
 - zero for 'done' - cookie released
 - positive for 'percent remaining' or whatever - cookie still valid

and this would be another callback into the filesystem code, but you'd 
never have to worry about it, since you'd never see it (just leave it 
NULL).

NOTE! The above is a rough idea - I have not spent tons of time thinking 
about it, or looking at exactly what something like NFS would really want. 
But the _concept_ is simple, and usage should be pretty trivial. A simple 
case would be something like this:

   int copy_file(const char *src, const char *dst)
   {
	/* Start a file copy */
	int cookie = copyfile(src, dst, 0);

	/* Async case? */
	if (cookie > 0) {
		int ret;

		while ((ret = copyfile_ctrl(cookie, COPYFILE_WAIT)) > 0)
			/* nothing */;

		/* Error handling is shared for async/sync */
		cookie = ret;
	}
	if (cookie < 0) {
		perror("copyfile failed");
		return -1;
	}
	return 0;
   }

doesn't that look fairly easy to use?

And the advantage here is that you _can_ - still fairly easily - do much 
more involved things. For example, let's say that you wanted to do a very 
efficient parallel copy, so you'd do something like this:

	#define MAX_PEND 10
	static int pending[MAX_PEND];
	static int nr_pending = 0;

	static int wait_for_completion(int nr_left)
	{
		int ret;

		while (nr_pending > nr_left) {
			int cookie = pending[0], i;

			/* Wait for completion of the oldest entry */
			while ((i = copyfile_ctrl(cookie, COPYFILE_WAIT)) > 0)
				/* nothing */;

			/* Save the "we had an error" case */
			if (i < 0)
				ret = i;

			/* Move the other entries down */
			memmove(pending, pending+1, sizeof(int)*--nr_pending);
		}
		return ret;
	}

	int start_copy(src, dst)
	{
		int cookie, ret;

		cookie = copyfile(src, dst, 0);
		if (cookie <= 0)
			return cookie;

		ret = 0;
		if (nr_pending == MAX_PENDING)
			ret = wait_for_completion(pending, MAX_PENDING/2);

		pending[nr_pending++] = cookie;
		return ret;
	}

	int stop_copy(void)
	{
		return wait_for_completion(pending, 0);
	}

which basically ends up having ten copyfile() calls outstanding (and when 
we hit the limit, we wait for half of them to complete), so now you can do 
an efficient "cp -R" with concurrent server-side IO. And it wasn't so 
hard, was it?

(Ok, so the above would need to be fleshed out to remember the filenames 
so that you can report _which_ file failed etc, but you get the idea).

And again, it wouldn't be any more complicated for your case. Your 
copyfile would always just return 0 or negative for error. But it would be 
_way_ more powerful for filesystems that want to do potentially lots of IO 
for the file copy.

I dunno. The above seems like a fairly simple and powerful interface, and 
I _think_ it would be ok for NFS and CIFS. And in fact, if that whole 
"background copy" ends up being used a lot, maybe even a local filesystem 
would implement it just to get easy overlapping IO - even if it would just 
be a trivial common wrapper function that says "start a thread to do a 
trivial manual copy".

			Linus
