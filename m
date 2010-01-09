From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 8 Jan 2010 23:42:46 -0800
Subject: [Ocfs2-devel] +
 sysctl-use-rcu-protected-sysctl-for-ocfs-group-add-helper.patch added to
 -mm tree
In-Reply-To: <20100109064438.GB20773@basil.fritz.box>
References: <201001082354.o08NsLGV021886@imap1.linux-foundation.org>
	<20100109000853.GC24532@mail.oracle.com>
	<20100109064438.GB20773@basil.fritz.box>
Message-ID: <20100109074246.GA9760@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Sat, Jan 09, 2010 at 07:44:38AM +0100, Andi Kleen wrote:
> > NAK until I can figure out how to make it always succeed.  We can't have
> > umount "succeed" like this.
> 
> You can never make a usermode helper execution always succeed. fork()+exec()
> can always fail for a zillion different reasons, for example memory
> allocation. Even if you patched these paths to preallocate
> everything it could still bump into other global process limits.

	Sure, usermode helpers can fail for a variety of reasons.  Why
add one?  Especially a kernel one.  Userspace memory is much more
flexible.

> > Maybe the solution is GFP_ATOMIC.  Maybe the solution is to lock on the
> > setting end.  But this isn't it.
> 
> There is no solution if you goal is to make it always succeed,

	My goal is to surprise the sysadmin as little as possible.

> Besides right now you plain just have a race that can potentially
> crash the kernel when the helper is executed in the wrong
> window.

	Oh, the race needs to be fixed.  I can put a mutex around the
string, or I can put GFP_ATOMIC into your patch.  I was wondering which
was preferable.

Joel

-- 

"The one important thing i have learned over the years is the
 difference between taking one's work seriously and taking one's self
 seriously.  The first is imperative and the second is disastrous."
	-Margot Fonteyn

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
