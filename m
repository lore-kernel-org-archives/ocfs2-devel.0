From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 12 Jan 2010 05:01:30 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix __ocfs2_cluster_lock() dead
 lock
In-Reply-To: <20100112120419.GA4209@laptop.oracle.com>
References: <201001060835.o067n0EO000623@rcsinet13.oracle.com>
	<20100107020005.GC20095@mail.oracle.com>
	<20100109180521.GA5148@laptop.oracle.com>
	<20100112015946.GE20285@mail.oracle.com>
	<20100112035835.GA3675@laptop.oracle.com>
	<20100112111802.GB3821@mail.oracle.com>
	<20100112120419.GA4209@laptop.oracle.com>
Message-ID: <20100112130129.GD3821@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Jan 12, 2010 at 08:04:19PM +0800, Wengang Wang wrote:
> On 10-01-12 03:18, Joel Becker wrote:
> > 	DC thread only waits on PENDING and holders.  If BUSY, it will
> > cancel the upconvert.  If not BUSY, it will schedule a downconvert.
> > There's nothing stopping the downconvert, in other words.
...
> in ocfs2_unblock_lock() there are lines after checking for BUSY flag:
> 
>         if (lockres->l_ops->check_downconvert
>             && !lockres->l_ops->check_downconvert(lockres, new_level))
>                 goto leave_requeue;
...
> if ctl->requeue is set, ocfs2_schedule_blocked_lock() will add the
> lockres to blocked_lock_list. the downconvert will then be rescheduled only
> if ocfs2_wake_downconvert_thread() is called somewhere. 
> in this simple case:
> the "somewhere", I think, is in __ocfs2_cluster_unlock().
> so before __ocfs2_cluster_unlock() is called(surely after
>  __ocfs2_cluster_lock() returns), the downconvert couldn't
> be rescheduled.
> thus __ocfs2_cluster_lock() is waiting for DC to finish and the DC is
> waiting __ocfs2_cluster_unlock() to be called. --deadlock.
> 
> so maybe you don't notice the lockres->l_ops->check_downconvert()?

	I notice it.  I know what it checks.  If the lock is not
currently taken it will return "go ahead and downconvert".  So we
won't requeue, we'll downconvert.  Specifically, look at
ocfs2_check_meta_downconvert().  It merely checks the caching info.  We
can't have any cached data if we don't have the EX yet.
	Sunil has observed the livelock behavior (pinging between UC and
DC) in the wild via traces.  The UC process never leaves
ocfs2_cluster_lock().  Your change fixes that.

Joel

-- 

"I don't even butter my bread; I consider that cooking."
         - Katherine Cebrian

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
