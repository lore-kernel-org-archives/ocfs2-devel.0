From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Mon, 5 Jul 2010 17:59:32 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2/dlm: remove potential deadlock -V2
In-Reply-To: <20100625015356.GA3631@laptop.us.oracle.com>
References: <201006211344.o5LDifHO031126@acsinet15.oracle.com>
	<20100625015356.GA3631@laptop.us.oracle.com>
Message-ID: <20100705095932.GA3057@laptop.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Any comment on this?

On 10-06-25 09:53, Wengang Wang wrote:
> Hi,
> 
> Any comment on this?
> 
> regards,
> wengang.
> On 10-06-21 21:43, Wengang Wang wrote:
> > When we need to take both dlm_domain_lock and dlm->spinlock, we should take
> > them in order of: dlm_domain_lock then dlm->spinlock.
> > 
> > There is pathes disobey this order. That is calling dlm_lockres_put() with
> > dlm->spinlock held in dlm_run_purge_list. dlm_lockres_put() calls dlm_put() at
> > the ref and dlm_put() locks on dlm_domain_lock.
> > 
> > Fix:
> > In dlm_run_purge_list, if it could the last ref on the lockres, unlock
> > dlm->spinlock before calling dlm_lockres_put() and lock it back after
> > dlm_lockres_put().
> > 
> > Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
> > ---
> >  fs/ocfs2/dlm/dlmthread.c |   27 +++++++++++++++++++--------
> >  1 files changed, 19 insertions(+), 8 deletions(-)
> > 
> > diff --git a/fs/ocfs2/dlm/dlmthread.c b/fs/ocfs2/dlm/dlmthread.c
> > index d4f73ca..b1bd624 100644
> > --- a/fs/ocfs2/dlm/dlmthread.c
> > +++ b/fs/ocfs2/dlm/dlmthread.c
> > @@ -152,6 +152,7 @@ void dlm_lockres_calc_usage(struct dlm_ctxt *dlm,
> >  	spin_unlock(&dlm->spinlock);
> >  }
> >  
> > +/* returns 1 if the lockres is removed from purge list, 0 otherwise */
> >  static int dlm_purge_lockres(struct dlm_ctxt *dlm,
> >  			     struct dlm_lock_resource *res)
> >  {
> > @@ -217,7 +218,9 @@ static int dlm_purge_lockres(struct dlm_ctxt *dlm,
> >  		     res, master);
> >  		list_del_init(&res->purge);
> >  		spin_unlock(&res->spinlock);
> > +		/* not the last ref, dlm_run_purge_list() holds another */
> >  		dlm_lockres_put(res);
> > +		ret = 1;
> >  		dlm->purge_count--;
> >  	} else
> >  		spin_unlock(&res->spinlock);
> > @@ -232,13 +235,13 @@ static int dlm_purge_lockres(struct dlm_ctxt *dlm,
> >  		spin_unlock(&res->spinlock);
> >  		wake_up(&res->wq);
> >  	}
> > -	return 0;
> > +	return ret;
> >  }
> >  
> >  static void dlm_run_purge_list(struct dlm_ctxt *dlm,
> >  			       int purge_now)
> >  {
> > -	unsigned int run_max, unused;
> > +	unsigned int run_max, unused, removed;
> >  	unsigned long purge_jiffies;
> >  	struct dlm_lock_resource *lockres;
> >  
> > @@ -280,13 +283,21 @@ static void dlm_run_purge_list(struct dlm_ctxt *dlm,
> >  
> >  		/* This may drop and reacquire the dlm spinlock if it
> >  		 * has to do migration. */
> > -		if (dlm_purge_lockres(dlm, lockres))
> > -			BUG();
> > -
> > +		removed = dlm_purge_lockres(dlm, lockres);
> > +		/* If the lockres is removed from purge list, this could be
> > +		 * the last ref. Unlock dlm->spinlock to avoid deadlock
> > +		 * --dlm_lockres_put() does spin_lock on dlm_domain_lock on the
> > +		 * last ref while there, in other path, could be lock requests
> > +		 * in normal order: dlm_domain_lock then dlm->spinlock.
> > +		 */
> > +		if (removed)
> > +			spin_unlock(&dlm->spinlock);
> >  		dlm_lockres_put(lockres);
> > -
> > -		/* Avoid adding any scheduling latencies */
> > -		cond_resched_lock(&dlm->spinlock);
> > +		if (removed)
> > +			spin_lock(&dlm->spinlock);
> > +		else
> > +			/* Avoid adding any scheduling latencies */
> > +			cond_resched_lock(&dlm->spinlock);
> >  	}
> >  
> >  	spin_unlock(&dlm->spinlock);
> > -- 
> > 1.6.6.1
> > 
> > 
> > _______________________________________________
> > Ocfs2-devel mailing list
> > Ocfs2-devel at oss.oracle.com
> > http://oss.oracle.com/mailman/listinfo/ocfs2-devel
