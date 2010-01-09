From: Andi Kleen <andi@firstfloor.org>
Date: Sat, 9 Jan 2010 12:31:41 +0100
Subject: [Ocfs2-devel]
	+	sysctl-use-rcu-protected-sysctl-for-ocfs-group-add-helper.patch	added
	to -mm tree
In-Reply-To: <20100109074246.GA9760@mail.oracle.com>
References: <201001082354.o08NsLGV021886@imap1.linux-foundation.org>
	<20100109000853.GC24532@mail.oracle.com>
	<20100109064438.GB20773@basil.fritz.box>
	<20100109074246.GA9760@mail.oracle.com>
Message-ID: <20100109113140.GC20773@basil.fritz.box>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Jan 08, 2010 at 11:42:46PM -0800, Joel Becker wrote:
> On Sat, Jan 09, 2010 at 07:44:38AM +0100, Andi Kleen wrote:
> > > NAK until I can figure out how to make it always succeed.  We can't have
> > > umount "succeed" like this.
> > 
> > You can never make a usermode helper execution always succeed. fork()+exec()
> > can always fail for a zillion different reasons, for example memory
> > allocation. Even if you patched these paths to preallocate
> > everything it could still bump into other global process limits.
> 
> 	Sure, usermode helpers can fail for a variety of reasons.  Why
> add one?  Especially a kernel one.  Userspace memory is much more

There are already a multitude of ways the execution of the user mode
helper can fail in the kernel. Just take a look at all the error
conditions in fork.c and exec.c

Besides when memory allocation fails the system is typically in a already
mostly unusable state.

> 
> > > Maybe the solution is GFP_ATOMIC.  Maybe the solution is to lock on the
> > > setting end.  But this isn't it.
> > 
> > There is no solution if you goal is to make it always succeed,
> 
> 	My goal is to surprise the sysadmin as little as possible.

Again if your goal is to make the kernel execution of the user mode
helper never fail then you already missed it.

> > Besides right now you plain just have a race that can potentially
> > crash the kernel when the helper is executed in the wrong
> > window.
> 
> 	Oh, the race needs to be fixed.  I can put a mutex around the
> string, or I can put GFP_ATOMIC into your patch.  I was wondering which
> was preferable.

You can do that, but it doesn't buy you anything over rcu strings 
and in addition would be more custom code.

-Andi
-- 
ak at linux.intel.com -- Speaking for myself only.
