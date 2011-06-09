From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Thu, 9 Jun 2011 14:40:48 +0800
Subject: [Ocfs2-devel] [PATCH] remove lockres from purge list when we
 are getting it for creating lock
In-Reply-To: <4DF0576F.1010002@oracle.com>
References: <201106080229.p582TILH031715@acsmt356.oracle.com>
	<4DF0576F.1010002@oracle.com>
Message-ID: <20110609064048.GA18176@laptop.jp.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Srini,

On 11-06-08 22:17, Srinivas Eeda wrote:
> I think I have seen this problem in ocfs2-1.2 and it was addressed
> by using a new state DLM_LOCK_RES_IN_USE. But we didn't merge into
> mainline as sunil suggested we need to look for a different approach
> 
> http://oss.oracle.com/pipermail/ocfs2-devel/2010-June/006669.html
> http://www.mail-archive.com/ocfs2-devel at oss.oracle.com/msg05733.html

Yes, this is the same problem.
> 
> one comment inline
<..snip>
> >+		spin_unlock(&tmpres->spinlock);
> >+		spin_unlock(&dlm->spinlock);
> lockres could still get added to purgelist at this point and we
> could still have the same problem? I think, here we need some
> mechanism that marks the lockres is in use that would protect it
> from adding to the purgelist?

Seems there shouldn't be the possibility that the lockres was moved to purge
list again. We are in the case of a "create lock", there should not be any
outstanding convert/unlock request in progress concurrently. If there is one,
the there must be lock(s) attached to the lockres. But if there are locks
attached, the lockres can't be purged. Also for concurrent "create lock", there
is no problem either because there must be a lock attached to the lockres. 

I think your patch works too. But changing
DLM_LOCK_RES_IN_USE
to
DLM_LOCK_RES_CREATING_LOCK
can help understand better.

I also thought about inflight_locks, but so far I failed to find correct
places to drop it.

thanks,
wengang.
> >  		if (res)
> >  			dlm_lockres_put(res);
> >  		res = tmpres;
