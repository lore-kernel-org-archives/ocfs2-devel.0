From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Mon, 5 Jul 2010 18:00:31 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2/dlm: correct the refmap on recovery
 master
In-Reply-To: <20100625015511.GA3639@laptop.us.oracle.com>
References: <201006101628.o5A0YmQN005612@rcsinet15.oracle.com>
	<20100625015511.GA3639@laptop.us.oracle.com>
Message-ID: <20100705100031.GA3072@laptop.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Any comment?

On 10-06-25 09:55, Wengang Wang wrote:
> Hi,
> 
> Any comment on this?
> 
> regards,
> wengang.
> On 10-06-11 00:25, Wengang Wang wrote:
> > If the dlm recovery goes on the non-master node where purging work is going on, 
> > There could be unexpected reference left on some lockres' on recovery master.
> > That is because we migrated the lockres' to recovery master but didn't send
> > deref requests to it accordingly(was sending to the dead original master or to
> > the "UNKNOWN").
> > 
> > Fix:
> > For the lockres which is in progress of dropping reference, we don't migrate it
> > to recovery master and unhash the lockres in the purge work.
> > For those not in progress of the dropping, delay the purge work until recovery
> > finished so that it can send deref request to the correct master(recovery
> > master) later.
> > 
> > Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
> > ---
> >  fs/ocfs2/dlm/dlmrecovery.c |   17 +++++++++++++++--
> >  fs/ocfs2/dlm/dlmthread.c   |   36 ++++++++++++++++++++++--------------
> >  2 files changed, 37 insertions(+), 16 deletions(-)
> > 
> > diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
> > index f8b75ce..43530ce 100644
> > --- a/fs/ocfs2/dlm/dlmrecovery.c
> > +++ b/fs/ocfs2/dlm/dlmrecovery.c
> > @@ -1997,6 +1997,8 @@ void dlm_move_lockres_to_recovery_list(struct dlm_ctxt *dlm,
> >  	struct list_head *queue;
> >  	struct dlm_lock *lock, *next;
> >  
> > +	assert_spin_locked(&dlm->spinlock);
> > +	assert_spin_locked(&res->spinlock);
> >  	res->state |= DLM_LOCK_RES_RECOVERING;
> >  	if (!list_empty(&res->recovering)) {
> >  		mlog(0,
> > @@ -2336,9 +2338,20 @@ static void dlm_do_local_recovery_cleanup(struct dlm_ctxt *dlm, u8 dead_node)
> >  
> >  				/* the wake_up for this will happen when the
> >  				 * RECOVERING flag is dropped later */
> > -				res->state &= ~DLM_LOCK_RES_DROPPING_REF;
> > +				if (res->state & DLM_LOCK_RES_DROPPING_REF) {
> > +					/*
> > +					 * don't migrate a lockres which is in
> > +					 * progress of dropping ref
> > +					 */
> > +					mlog(ML_NOTICE, "%.*s ignored for "
> > +					     "migration\n", res->lockname.len,
> > +					     res->lockname.name);
> > +					res->state &=
> > +						~DLM_LOCK_RES_DROPPING_REF;
> > +				} else
> > +					dlm_move_lockres_to_recovery_list(dlm,
> > +									  res);
> >  
> > -				dlm_move_lockres_to_recovery_list(dlm, res);
> >  			} else if (res->owner == dlm->node_num) {
> >  				dlm_free_dead_locks(dlm, res, dead_node);
> >  				__dlm_lockres_calc_usage(dlm, res);
> > diff --git a/fs/ocfs2/dlm/dlmthread.c b/fs/ocfs2/dlm/dlmthread.c
> > index d4f73ca..0771420 100644
> > --- a/fs/ocfs2/dlm/dlmthread.c
> > +++ b/fs/ocfs2/dlm/dlmthread.c
> > @@ -92,17 +92,23 @@ int __dlm_lockres_has_locks(struct dlm_lock_resource *res)
> >   * truly ready to be freed. */
> >  int __dlm_lockres_unused(struct dlm_lock_resource *res)
> >  {
> > -	if (!__dlm_lockres_has_locks(res) &&
> > -	    (list_empty(&res->dirty) && !(res->state & DLM_LOCK_RES_DIRTY))) {
> > -		/* try not to scan the bitmap unless the first two
> > -		 * conditions are already true */
> > -		int bit = find_next_bit(res->refmap, O2NM_MAX_NODES, 0);
> > -		if (bit >= O2NM_MAX_NODES) {
> > -			/* since the bit for dlm->node_num is not
> > -			 * set, inflight_locks better be zero */
> > -			BUG_ON(res->inflight_locks != 0);
> > -			return 1;
> > -		}
> > +	int bit;
> > +
> > +	if (__dlm_lockres_has_locks(res))
> > +		return 0;
> > +
> > +	if (!list_empty(&res->dirty) || res->state & DLM_LOCK_RES_DIRTY)
> > +		return 0;
> > +
> > +	if (res->state & DLM_LOCK_RES_RECOVERING)
> > +		return 0;
> > +
> > +	bit = find_next_bit(res->refmap, O2NM_MAX_NODES, 0);
> > +	if (bit >= O2NM_MAX_NODES) {
> > +		/* since the bit for dlm->node_num is not
> > +		 * set, inflight_locks better be zero */
> > +		BUG_ON(res->inflight_locks != 0);
> > +		return 1;
> >  	}
> >  	return 0;
> >  }
> > @@ -158,6 +164,8 @@ static int dlm_purge_lockres(struct dlm_ctxt *dlm,
> >  	int master;
> >  	int ret = 0;
> >  
> > +	assert_spin_locked(&dlm->spinlock);
> > +
> >  	spin_lock(&res->spinlock);
> >  	if (!__dlm_lockres_unused(res)) {
> >  		mlog(0, "%s:%.*s: tried to purge but not unused\n",
> > @@ -216,13 +224,13 @@ static int dlm_purge_lockres(struct dlm_ctxt *dlm,
> >  		     "master = %d\n", res->lockname.len, res->lockname.name,
> >  		     res, master);
> >  		list_del_init(&res->purge);
> > -		spin_unlock(&res->spinlock);
> > +		/* not the last ref */
> >  		dlm_lockres_put(res);
> >  		dlm->purge_count--;
> > -	} else
> > -		spin_unlock(&res->spinlock);
> > +	}
> >  
> >  	__dlm_unhash_lockres(res);
> > +	spin_unlock(&res->spinlock);
> >  
> >  	/* lockres is not in the hash now.  drop the flag and wake up
> >  	 * any processes waiting in dlm_get_lock_resource. */
> > -- 
> > 1.6.6.1
> > 
> > 
> > _______________________________________________
> > Ocfs2-devel mailing list
> > Ocfs2-devel at oss.oracle.com
> > http://oss.oracle.com/mailman/listinfo/ocfs2-devel
