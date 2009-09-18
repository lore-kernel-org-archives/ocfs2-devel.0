From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 17 Sep 2009 18:43:33 -0700
Subject: [Ocfs2-devel] [GIT PULL] ocfs2 changes for 2.6.32
In-Reply-To: <alpine.LFD.2.01.0909170856050.4950@localhost.localdomain>
References: <20090915000417.GC4507@mail.oracle.com>
	<alpine.LFD.2.01.0909141727150.4950@localhost.localdomain>
	<20090915005417.GD4507@mail.oracle.com>
	<alpine.LFD.2.01.0909141828070.4950@localhost.localdomain>
	<20090915040601.GE4507@mail.oracle.com>
	<alpine.LFD.2.01.0909150923180.4950@localhost.localdomain>
	<20090915214530.GA11060@mail.oracle.com>
	<alpine.LFD.2.01.0909152116180.4950@localhost.localdomain>
	<20090916044047.GA30453@mail.oracle.com>
	<alpine.LFD.2.01.0909170856050.4950@localhost.localdomain>
Message-ID: <20090918014333.GD15620@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mark Fasheh <mfasheh@suse.com>, Andrew Morton <akpm@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, ocfs2-devel@oss.oracle.com

On Thu, Sep 17, 2009 at 09:29:14AM -0700, Linus Torvalds wrote:
> Why would anybody want to hide it at all? Why even the libc hiding?
> 
> Nobody is going to use this except for special apps. Let them see what 
> they can do, in all its glory. 

	I expect everyone will use this through cp(1), so that cp(1) can
try to get server-side copy on the network filesystms.
	Speaking of "all its glory", what we have now is:

int sys_copyfileat(int oldfd, const char *oldname, int newfd,
                   const char *newname, int flags, int atflags)

> So I'd suggest something like having two system calls: one to start the 
> operation, and one to control it. And for a filesystem that does atomic 
> copies, the 'start' one obviously would also finish it, so the 'control' 
> it would be a no-op, because there would never be any outstanding ones.
> 
> See what I'm saying? It wouldn't complicate _your_ life, but it would 
> allow for filesystems that can't do it atomically (or even quickly).
> 
> So the first one would be something like
> 
> 	int copyfile(const char *src, const char *dest, unsigned long flags);
> 
> which would return:
> 
>  - zero on success
>  - negative (with errno) on error
>  - positive cookie on "I started it, here's my cookie". For extra bonus 
>    points, maybe the cookie would actually be a file descriptor (for 
>    poll/select users), but it would _not_ be a file descriptor to the 
>    resulting _file_, it would literally be a "cookie" to the actual 
>    copyfile event.

	Actually, if the cookie is a magic file descriptor, you don't
need ctl.  You can play tricks like polling for completoin,
read(magic_fd, &remain, sizeof(loff_t)) for status, and close(magic_fd)
for cancel.  Might be a bit overloaded, though.

> and then for ocfs2 you'd never return positive cookies. You'd never have 
> to worry about it.

	I suspect we'll later take advantage of copyfile's other
modes.  I did reflink as reflink only for the simple fact of doing one
thing and well, not because I think copyfile isn't good.

> Then the second interface would be something like
> 
> 	int copyfile_ctrl(long cookie, unsigned long cmd);
> 
> where you'd just have some way to wait for completion and ask how much has 
> been copied. The 'cmd' would be some set of 'cancel', 'status' or 
> 'uninterruptible wait' or whatever, and the return value would again be
> 
>  - negative (with errno) for errors (copy failed) - cookie released
>  - zero for 'done' - cookie released
>  - positive for 'percent remaining' or whatever - cookie still valid
> 
> and this would be another callback into the filesystem code, but you'd 
> never have to worry about it, since you'd never see it (just leave it 
> NULL).

	I was going to ask about how to fit both calls into one inode
operation, but I see you're giving this as an additional inode
operation.
	This leaves us with a simliar-to-reflink inode copyfile op and a
control op:

    ->copyfile(old_dentry, dir_inode, new_dentry, flags)
    ->copyfile_ctl(int cookie, unsigned int cmd)

	I have to change the flags a little, as my original proposal
didn't handle backoff correctly.

#define COPYFILE_WAIT		0x0001	/* Block until complete */
#define COPYFILE_ATOMIC		0x0002	/* Things copied must be
					   point-in-time and it must
					   fail or succeed completely. */
#define COPYFILE_ALLOW_COW	0x0004	/* The filesystem may share data
					   extents between the source
					   and target in a Copy-on-Write
					   fashion.  If neither
					   COPYFILE_ALLOW_COW nor
					   COPYFILE_REQUIRE_COW are
					   specified, data extents must
					   NOT be shared.  When neither
					   COW flag is provided, most
					   filesystems should return
					   -ENOTSUPP, as userspace can
					   do read-write looping
					   itself */
#define COPYFILE_REQUIRE_COW	0x0008	/* Data extents MUST be shared
					   between the source and target
					   in a Copy-on-Write fashion */
#define COPYFILE_UNPRIV_ATTRS	0x0010	/* Unprivileged attributes
					   should be copied from the
					   source to the target */
#define COPYFILE_PRIV_ATTRS	0x0020	/* Privileged attributes should
					   be copied from the source to
					   the target if the caller has
					   the necessary privileges */
#define COPYFILE_REQUIRE_ATTRS	0x0040	/* Combined with the other
					   attribute flags, the call
					   MUST fail if the caller lacks
					   the necessary privileges to
					   copy ever attribute
					   requested */

#define COPYFILE_SNAPSHOT_ASYNC	(COPYFILE_REQUIRE_COW |
				 COPYFILE_UNPRIV_ATTRS |
				 COPYFILE_PRIV_ATTRS |
				 COPYFILE_ATOMIC)
#define COPYFILE_SNAPSHOT_STRICT_ASYNC	(COPYFILE_SNAPSHOT_ASYNC |
					 COPYFILE_REQUIRE_ATTRS)
#define COPYFILE_SNAPSHOT	(COPYFILE_SNAPSHOT_ASYNC |
				 COPYFILE_WAIT)
#define COPYFILE_SNAPSHOT_STRICT	(COPYFILE_SNAPSHOT_STRICT_ASYNC |
					 COPYFILE_WAIT)

> I dunno. The above seems like a fairly simple and powerful interface, and 
> I _think_ it would be ok for NFS and CIFS. And in fact, if that whole 
> "background copy" ends up being used a lot, maybe even a local filesystem 
> would implement it just to get easy overlapping IO - even if it would just 
> be a trivial common wrapper function that says "start a thread to do a 
> trivial manual copy".

	NFS and CIFS folks, please speak up.

Joel

-- 

"There is no more evil thing on earth than race prejudice, none at 
 all.  I write deliberately -- it is the worst single thing in life 
 now.  It justifies and holds together more baseness, cruelty and
 abomination than any other sort of error in the world." 
        - H. G. Wells

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
