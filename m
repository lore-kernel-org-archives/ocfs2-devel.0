From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Wed, 13 Jan 2010 15:08:47 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix __ocfs2_cluster_lock()
	dead	lock
In-Reply-To: <20100113032049.GA4045@laptop.oracle.com>
References: <201001060835.o067n0EO000623@rcsinet13.oracle.com>
	<20100107020005.GC20095@mail.oracle.com>
	<20100109180521.GA5148@laptop.oracle.com>
	<20100112015946.GE20285@mail.oracle.com>
	<20100113032049.GA4045@laptop.oracle.com>
Message-ID: <20100113070847.GB4222@laptop.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 10-01-13 11:20, Wengang Wang wrote:
> Hi Joel and David,
> 
> I think the patch to fix the deadlock(or livelock) is not good enough
> yet.
> my original patch is based on that when we have requested the lock, we
> don't allow to downconvert it before we release it.
> but per the communications with Joel and Sunil, I found my base is
> wrong. so my original patch is not good. and Joel's patch has problem
> either.
> 
> On 10-01-11 17:59, Joel Becker wrote:
> > [Cc'd Mark and Dave]
> > Signed-off-by: Joel Becker <joel.becker@oracle.com>
> > ---
> >  fs/ocfs2/dlmglue.c |   29 +++++++++++++++++++++++++++++
> >  1 files changed, 29 insertions(+), 0 deletions(-)
> > 
> > diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
> > index 90682a0..eabe53e 100644
> > --- a/fs/ocfs2/dlmglue.c
> > +++ b/fs/ocfs2/dlmglue.c
> > @@ -1313,6 +1313,7 @@ static int __ocfs2_cluster_lock(struct ocfs2_super *osb,
> >  	unsigned long flags;
> >  	unsigned int gen;
> >  	int noqueue_attempted = 0;
> > +	int lock_attempted = 0;
> >  
> >  	mlog_entry_void();
> >  
> > @@ -1347,6 +1348,25 @@ again:
> >  		goto unlock;
> >  	}
> >  
> > +	if (lock_attempted && (lockres->l_level >= level)) {
> > +		/*
> > +		 * We've attempted to upconvert, and the lock now has
> > +		 * a level we can work with.  If we fell through to the
> > +		 * next checks, we could spin in an upconvert->downconvert
> > +		 * cycle as other nodes pounded us.  Instead, we jump
> > +		 * out and let the caller do some work.  If a downconvert
> > +		 * has come in, it will do its thing as soon as the caller
> > +		 * is done.
> > +		 */
> > +		goto update_holders;
> > +	}
> 
> before update_holders, the lock could be DCed(since no BUSY flag set by
> here).
> 
> and even after update_holders, the lock could be DCed too.
> 
> so that we get ocfs2_cluster_lock()(with holders increased) returned sucessfully
> but actually we don't hold the dlm lock. --thus more than one node is
> considering that they have the (EX) lock.
> 
> that's could be the cause of what is happening observed by David.

I think the main problem is that though the lock is got, the holders
is not updated in time(within BUSY flag protection).
a BUSY flag protects a single ocfs2_dlm_lock(). if a BUSY_INC_HD(also busy with
updating holders) is used to protect a single ocfs2_dlm_lock() + holders
updates against dc thread, so far I think it's the fix. comments?

#patch attached.
-------------- next part --------------
diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index c3ee146..d172c5f 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -1360,6 +1360,8 @@ again:
 		goto update_holders;
 	}
 
+	lockres_clear_flags(lockres, OCFS2_LOCK_BUSY_INC_HD);
+
 	/*
 	 * This is either the first pass or our level wasn't good enough.
 	 * Treat both cases as a first pass.
@@ -1403,7 +1405,7 @@ again:
 		}
 
 		lockres->l_requested = level;
-		lockres_or_flags(lockres, OCFS2_LOCK_BUSY);
+		lockres_or_flags(lockres, OCFS2_LOCK_BUSY|OCFS2_LOCK_BUSY_INC_HD);
 		gen = lockres_set_pending(lockres);
 		spin_unlock_irqrestore(&lockres->l_lock, flags);
 
@@ -1447,6 +1449,8 @@ again:
 update_holders:
 	/* Ok, if we get here then we're good to go. */
 	ocfs2_inc_holders(lockres, level);
+	/* no harm even double clear OCFS2_LOCK_BUSY_INC_HD */
+	lockres_clear_flags(lockres, OCFS2_LOCK_BUSY_INC_HD);
 
 	ret = 0;
 unlock:
@@ -3392,7 +3396,7 @@ static int ocfs2_unblock_lock(struct ocfs2_super *osb,
 	BUG_ON(!(lockres->l_flags & OCFS2_LOCK_BLOCKED));
 
 recheck:
-	if (lockres->l_flags & OCFS2_LOCK_BUSY) {
+	if (lockres->l_flags & (OCFS2_LOCK_BUSY|OCFS2_LOCK_BUSY_INC_HD)) {
 		/* XXX
 		 * This is a *big* race.  The OCFS2_LOCK_PENDING flag
 		 * exists entirely for one reason - another thread has set
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index d963d86..a3d23ef 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -136,6 +136,7 @@ enum ocfs2_unlock_action {
 #define OCFS2_LOCK_PENDING       (0x00000400) /* This lockres is pending a
 						 call to dlm_lock.  Only
 						 exists with BUSY set. */
+#define OCFS2_LOCK_BUSY_INC_HD   (0x00000800) /* busy with increase holders */
 
 struct ocfs2_lock_res_ops;
 
