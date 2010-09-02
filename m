From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Thu, 2 Sep 2010 22:53:26 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2/dlm: remove a potential deadlock
In-Reply-To: <20100902144348.GA5015@laptop.jp.oracle.com>
References: <201009021320.o82CV6Z1009328@rcsinet15.oracle.com>
	<20100902144348.GA5015@laptop.jp.oracle.com>
Message-ID: <20100902145326.GB5015@laptop.jp.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 10-09-02 22:43, Wengang Wang wrote:
> I am taking back this patch since where is another such violation in

Sorry for the typo.
s/where/there

regards,
wengang.
> dlm_flush_asts().
> 
> I will try to fix the both in one combination.
> 
> regards,
> wengang.
> 
> On 10-09-02 21:17, Wengang Wang wrote:
> > /*
> >  *
> >  * spinlock lock ordering: if multiple locks are needed, obey this ordering:
> >  *    dlm_domain_lock
> >  *    struct dlm_ctxt->spinlock
> >  *    struct dlm_lock_resource->spinlock
> >  *    struct dlm_ctxt->master_lock
> >  *    struct dlm_ctxt->ast_lock
> >  *    dlm_master_list_entry->spinlock
> >  *    dlm_lock->spinlock
> >  *
> >  */
> > 
> > There is a violation that locks on dlm_lock_resource->spinlock after locking
> > on dlm_ctxt->ast_lock. The violation is not detected because so far there is
> > only one place where both the two spinlock are taken at the same time. But it
> > is a potential deadlock in future(when the two lock are taken all together in
> > correct order).
> > 
> > This patch fixes the problem by changing the calling order.
> > 
> > Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
> > ---
> >  fs/ocfs2/dlm/dlmthread.c |    6 +++---
> >  1 files changed, 3 insertions(+), 3 deletions(-)
> > 
> > diff --git a/fs/ocfs2/dlm/dlmthread.c b/fs/ocfs2/dlm/dlmthread.c
> > index 2211acf..676ff3e 100644
> > --- a/fs/ocfs2/dlm/dlmthread.c
> > +++ b/fs/ocfs2/dlm/dlmthread.c
> > @@ -671,8 +671,8 @@ static int dlm_thread(void *data)
> >  		 	/* lockres can be re-dirtied/re-added to the
> >  			 * dirty_list in this gap, but that is ok */
> >  
> > -			spin_lock(&dlm->ast_lock);
> >  			spin_lock(&res->spinlock);
> > +			spin_lock(&dlm->ast_lock);
> >  			if (res->owner != dlm->node_num) {
> >  				__dlm_print_one_lock_resource(res);
> >  				mlog(ML_ERROR, "inprog:%s, mig:%s, reco:%s, dirty:%s\n",
> > @@ -691,8 +691,8 @@ static int dlm_thread(void *data)
> >  					  DLM_LOCK_RES_RECOVERING)) {
> >  				/* move it to the tail and keep going */
> >  				res->state &= ~DLM_LOCK_RES_DIRTY;
> > -				spin_unlock(&res->spinlock);
> >  				spin_unlock(&dlm->ast_lock);
> > +				spin_unlock(&res->spinlock);
> >  				mlog(0, "delaying list shuffling for in-"
> >  				     "progress lockres %.*s, state=%d\n",
> >  				     res->lockname.len, res->lockname.name,
> > @@ -713,8 +713,8 @@ static int dlm_thread(void *data)
> >  			/* called while holding lockres lock */
> >  			dlm_shuffle_lists(dlm, res);
> >  			res->state &= ~DLM_LOCK_RES_DIRTY;
> > -			spin_unlock(&res->spinlock);
> >  			spin_unlock(&dlm->ast_lock);
> > +			spin_unlock(&res->spinlock);
> >  
> >  			dlm_lockres_calc_usage(dlm, res);
> >  
> > -- 
> > 1.7.2.2
> > 
> > 
> > _______________________________________________
> > Ocfs2-devel mailing list
> > Ocfs2-devel at oss.oracle.com
> > http://oss.oracle.com/mailman/listinfo/ocfs2-devel
