From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 15 Sep 2009 14:45:30 -0700
Subject: [Ocfs2-devel] [GIT PULL] ocfs2 changes for 2.6.32
In-Reply-To: <alpine.LFD.2.01.0909150923180.4950@localhost.localdomain>
References: <20090911200458.GA15416@mail.oracle.com>
	<alpine.LFD.2.01.0909141417180.4950@localhost.localdomain>
	<20090914221434.GA4507@mail.oracle.com>
	<alpine.LFD.2.01.0909141614350.4950@localhost.localdomain>
	<20090915000417.GC4507@mail.oracle.com>
	<alpine.LFD.2.01.0909141727150.4950@localhost.localdomain>
	<20090915005417.GD4507@mail.oracle.com>
	<alpine.LFD.2.01.0909141828070.4950@localhost.localdomain>
	<20090915040601.GE4507@mail.oracle.com>
	<alpine.LFD.2.01.0909150923180.4950@localhost.localdomain>
Message-ID: <20090915214530.GA11060@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mark Fasheh <mfasheh@suse.com>, Andrew Morton <akpm@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, ocfs2-devel@oss.oracle.com

On Tue, Sep 15, 2009 at 09:30:54AM -0700, Linus Torvalds wrote:
> HOW?
> 
> We need to have a per-filesystem interface to that. 

	No argument here.

> But don't you see how _idiotic_ it is to then also having a '->reflink()' 
> function that does _conceptually_ the exact same thing, except it does it 
> by incrementing a usage count instead?
> 
> Do you see why I'm so unhappy to add a ->reflink() function? 

	I got it the first time.  You see reflink() as a copyfile(), and
distinguishing the inode operations doesn't make sense to you.   Quite
frankly, it doesn't to me either.  There is the user<->kernel interface
of the system call, and there is the filesystem interface of the inode
operation.  One inode op that can support multiple variations of
user<->kernel is find with me!
	Let's step back a second.  I'm not married to the name
'reflink'.  I'm not opposed to a copyfile() syscall.  I think I have a
clearer idea of what I see.  More below.

> Would that be a 'reflink()' or not? I have no way of knowing, because you 
> have decided on reflink on a purely ocfs2-specific implementation basis. 
> But I do know that such a filesystem would be perfectly happy to have a 
> 'copyfile' function.

	That's not fair.  I deliberately defined it as something outside
of the ocfs2 implementation.  Apparently I didn't do a good enough job.

> This is why I want the VFS pointers to be about _semantics_, not about 
> some random implementation detail.

	Again, no argument here.  The syscall interface better be
reasonably obvious to the userspace programmer.  The VFS pointer better
be an efficient and clean way to implement the syscall interface.
	I'm seeing three things here:

1. A CoW snapshot of an inode.  This is reflink.  It expressly defines
   metadata as copyable, but data must be shared in a CoW fashion (to
   answer your question about indirect blocks).  You either get a
   snapshot or nothing.  Call it snapfile() if you like.  Don't care.

2. An efficient copy.  This is what you're talking about with CIFS COPY,
   etc.  You want to be guaranteed it does NOT do CoW, because it would
   be great for a naive cp(1) to use it without the ENOSPC surprise of
   CoW.  You'd like the kernel call to fail if you're just going to get
   read-write-loops, because userspace can implement that better.  Maybe
   we have it such that only network filesystems implement this action,
   all the others return -ENOTSUPP, and then glibc handles the
   read-write-loop.  This allows everyone to call copyfile() and get
   what they expected.

3. A space-saving copy.  This is doing CoW linkup of the data storage if
   possible, like a snapshot but without the atomicity guarantee.  It
   has the ENOSPC surprise, but someone using it should know that.
 
	I think it would be great for Linux to provide all three.  I
chose to only attack (1) because I could define it well.  I left (2) and
(3), what I see as copyfile(), for later work.  And I fully expected
that the VFS operation could change later - it's an internal thing,
after all.  I want to get a good user<->kernel interface, because that's
the one that is set in stone.  What I didn't want was to create another
kitchen-sink call, or another POSIXy thing that has a million special
cases that trip folks up.
	I'm glad you've taken an interest, because you're pretty damned
good at architecture.  If we can expand to cover copyfile sanely too,
win-win.  To me, the user<->kernel interface really is two system calls:
reflink/snapfile for (1) and copyfile for (2) & (3).  The kernel VFS
interface I would think you could do in one inode operation.  If you
want to name it ->copyfile, that's fine.
	Perhaps ->copyfile takes the following flags:

#define ALLOW_COW_SHARED	0x0001
#define REQUIRE_COW_SHARED	0x0002
#define REQUIRE_BASIC_ATTRS	0x0004
#define REQUIRE_FULL_ATTRS	0x0008
#define REQUIRE_ATOMIC		0x0010
#define SNAPSHOT		(REQUIRE_COW_SHARED |
				 REQUIRE_BASIC_ATTRS |
				 REQUIRE_ATOMIC)
#define SNAPSHOT_PRESERVE	(SNAPSHOT | REQUIRE_FULL_ATTRS)

Thus, sys_reflink/sys_snapfile(oldpath, newpath, 0) becomes:

  ->copyfile(oldpath, newpath, SNAPSHOT)

and sys_reflink/sys_snapfile(oldpath, newpath, ATTR_PRESERVE) becomes:

  ->copyfile(oldpath, newpath, SNAPSHOT_PRESERVE)

while sys_copyfile(oldpath, newpath, 0) is:

  ->copyfile(oldpath, newpath, 0)

and sys_copyfile(oldpath, newpath, ALLOW_COW) is:

  ->copyfile(oldpath, newpath, ALLOW_COW_SHARED)

	What do you think?  Other ideas?

Joel
-- 

"The lawgiver, of all beings, most owes the law allegiance.  He of all
 men should behave as though the law compelled him.  But it is the
 universal weakness of mankind that what we are given to administer we
 presently imagine we own."
        - H.G. Wells

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
