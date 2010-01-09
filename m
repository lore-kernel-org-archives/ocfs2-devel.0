From: Andi Kleen <andi@firstfloor.org>
Date: Sat, 9 Jan 2010 07:44:38 +0100
Subject: [Ocfs2-devel]
	+	sysctl-use-rcu-protected-sysctl-for-ocfs-group-add-helper.patch	added
	to -mm tree
In-Reply-To: <20100109000853.GC24532@mail.oracle.com>
References: <201001082354.o08NsLGV021886@imap1.linux-foundation.org>
	<20100109000853.GC24532@mail.oracle.com>
Message-ID: <20100109064438.GB20773@basil.fritz.box>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Jan 08, 2010 at 04:08:53PM -0800, Joel Becker wrote:
> On Fri, Jan 08, 2010 at 03:54:20PM -0800, akpm at linux-foundation.org wrote:
> > 
> > The patch titled
> >      sysctl: use RCU protected sysctl for ocfs group add helper
> > has been added to the -mm tree.  Its filename is
> >      sysctl-use-rcu-protected-sysctl-for-ocfs-group-add-helper.patch
> 
> NAK until I can figure out how to make it always succeed.  We can't have
> umount "succeed" like this.

You can never make a usermode helper execution always succeed. fork()+exec()
can always fail for a zillion different reasons, for example memory
allocation. Even if you patched these paths to preallocate
everything it could still bump into other global process limits.

> 
> Maybe the solution is GFP_ATOMIC.  Maybe the solution is to lock on the
> setting end.  But this isn't it.

There is no solution if you goal is to make it always succeed,

My change doesn't change this anyways.

Besides right now you plain just have a race that can potentially
crash the kernel when the helper is executed in the wrong
window.

-Andi
