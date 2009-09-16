From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 15 Sep 2009 21:40:48 -0700
Subject: [Ocfs2-devel] [GIT PULL] ocfs2 changes for 2.6.32
In-Reply-To: <alpine.LFD.2.01.0909152116180.4950@localhost.localdomain>
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
Message-ID: <20090916044047.GA30453@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mark Fasheh <mfasheh@suse.com>, Andrew Morton <akpm@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, ocfs2-devel@oss.oracle.com

On Tue, Sep 15, 2009 at 09:20:47PM -0700, Linus Torvalds wrote:
> On Tue, 15 Sep 2009, Joel Becker wrote:
> >
> > 	Perhaps ->copyfile takes the following flags:
> > 
> > #define ALLOW_COW_SHARED	0x0001
> > #define REQUIRE_COW_SHARED	0x0002
> > #define REQUIRE_BASIC_ATTRS	0x0004
> > #define REQUIRE_FULL_ATTRS	0x0008
> > #define REQUIRE_ATOMIC		0x0010
> > #define SNAPSHOT		(REQUIRE_COW_SHARED |
> > 				 REQUIRE_BASIC_ATTRS |
> > 				 REQUIRE_ATOMIC)
> > #define SNAPSHOT_PRESERVE	(SNAPSHOT | REQUIRE_FULL_ATTRS)
> > 
> > Thus, sys_reflink/sys_snapfile(oldpath, newpath, 0) becomes:
> > ...
> 
> Yes. The above all sounds sane to me.

	Ok.  Where do you see the exposure level?  What I mean is, I
just defined a vfs op that handles these things, but accessed it via two
syscalls, sys_snapfile() and sys_copyfile().  We could also just provide
one system call and allow userspace to use these flags itself, creating
snapfile(3) and copyfile(3) in libc, hiding the details (kind of like
clone being hidden by pthreads, though ignoring that pthreads has
"issues").  Or we could explicitly make this the public API and expect
something like cp(1) to directly use the flags.  Thoughts?

> I still worry that especially the non-atomic case will want some kind of 
> partial-copy updates (think graphical file managers that want to show the 
> progress of the copy), and that (think EINTR and continuing) makes me 
> think "that could get really complex really quickly", but that's something 
> that the NFS/SMB people would have to pipe up on. I'm pretty sure the NFS 
> spec has some kind "partial completion notification" model, I dunno about 
> SMB.

	I'm really wary of combining a ranged interface with this one.
Not only does it make no sense for snapshots, but I think it falls down
in any "create a new inode" scheme entirely.
	btrfs has an ioctl that basically says "link up range x->y of
file 1 to file 2".  Chris is using the underlying machinery to implement
reflink, but I think the concept actually would work nicely as a splice
flag.  If you have two existing files, not creating one, you can just
ask splice to do efficient things with a SPLICE_F_EFFICIENT_COPY for
yoru CIFS COPY-style thing or SPLICE_F_COW_COPY for btrfs- and
ocfs2-style data sharing.

Joel

-- 

"Nothing is wrong with California that a rise in the ocean level
 wouldn't cure."
        - Ross MacDonald

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
