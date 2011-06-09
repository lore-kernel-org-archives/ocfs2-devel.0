From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Thu, 9 Jun 2011 16:10:27 +0800
Subject: [Ocfs2-devel] [PATCH] remove lockres from purge list when we
 are getting it for creating lock
In-Reply-To: <4DF079A0.9000902@oracle.com>
References: <201106080229.p582TILH031715@acsmt356.oracle.com>
	<4DF0576F.1010002@oracle.com>
	<20110609064048.GA18176@laptop.jp.oracle.com>
	<4DF079A0.9000902@oracle.com>
Message-ID: <20110609081027.GA19758@laptop.jp.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Srini,
Yes, you are right! Agree!

Sunil,
My privious patch which checks if lockres is unhashed can't fix the
problem that "can't find lockres in ast handler". So I vote for Srini's
patch.
what's your comment?

thanks,
wengang.
On 11-06-09 00:43, Srinivas Eeda wrote:
> 
> >>>+		spin_unlock(&tmpres->spinlock);
> >>>+		spin_unlock(&dlm->spinlock);
> >>lockres could still get added to purgelist at this point and we
> >>could still have the same problem? I think, here we need some
> >>mechanism that marks the lockres is in use that would protect it
> >>from adding to the purgelist?
> >Seems there shouldn't be the possibility that the lockres was moved to purge
> >list again.
> I think you are right about that once removed from the purge list it
> will not be put back again on the purgelist in this case :)
> 
> I still think that there is a hole here. Is it possible that the
> spinlocks are released here and right then dlm_thread was walking
> through dirty list and then it could put this on purge list for the
> first time?
> 
> If it's already on purgelist, then we seem to be safe by removing
> it. But what is preventing the lockres getting onto to purge list
> right at this point. locks are added to lockres a little later but
> till then it is not safe?(I think).
> 
> >  We are in the case of a "create lock", there should not be any
> >outstanding convert/unlock request in progress concurrently. If there is one,
> >the there must be lock(s) attached to the lockres. But if there are locks
> >attached, the lockres can't be purged. Also for concurrent "create lock", there
> >is no problem either because there must be a lock attached to the lockres.
> >
> >I think your patch works too. But changing
> >DLM_LOCK_RES_IN_USE
> >to
> >DLM_LOCK_RES_CREATING_LOCK
> >can help understand better.
> I am ok with the name :). The thing we should do here is once we
> found a lockres and moving ahead with create lock request, we should
> be sure it's protected before releasing the spinlocks.
> >I also thought about inflight_locks, but so far I failed to find correct
> >places to drop it.
> >
> >thanks,
> >wengang.
> >>>  		if (res)
> >>>  			dlm_lockres_put(res);
> >>>  		res = tmpres;
