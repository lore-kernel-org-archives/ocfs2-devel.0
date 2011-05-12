From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Thu, 12 May 2011 16:57:05 +0800
Subject: [Ocfs2-devel] [PATCH] o2dlm: check lockres validity in
	createlock
In-Reply-To: <4DCADE48.6020101@oracle.com>
References: <201105110448.p4B4mErr019249@acsmt357.oracle.com>
	<4DCAAD7C.6090007@oracle.com> <4DCADE48.6020101@oracle.com>
Message-ID: <20110512085705.GA19435@laptop.jp.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 11-05-11 12:06, Sunil Mushran wrote:
> On 05/11/2011 08:38 AM, Sunil Mushran wrote:
> >On 05/11/2011 04:47 AM, Wengang Wang wrote:
> >>When we are to purge a lockres, we check if it's unused.
> >>the check includes
> >>1. no locks attached to the lockres.
> >>2. not dirty.
> >>3. not in recovery.
> >>4. no interested nodes in refmap.
> >>If the the above four are satisfied, we are going to purge it(remove it
> >>from hash table).
> >>
> >>While, when a "create lock" is in progress especially when lockres is owned
> >>remotely(spinlocks are dropped when networking), the lockres can satisfy above
> >>four condition. If it's put to purge list, it can be purged out from hash table
> >>when we are still accessing on it(sending request to owner for example). That's
> >>not what we want.
> >Create lock follows master query. And in master query handler we add
> >the node to the refmap. That's the race refmap was created to close.
> >Meaning we should not run into this condition.
> >
> >Which version did this problem reproduce in?
> >
> >>I have met such a problem (orabug 12405575).
> >>The lockres is in the purge list already(there is a delay for real purge work)
> >>and the create lock request comes. When we are sending network message to the
> >>owner in dlmlock_remote(), the owner crashed. So we get DLM_RECOVERING as return
> >>value and retries dlmlock_remote(). And before the owner crash, we have purged
> >>the lockres. So the lockres become stale(on lockres->onwer). Thus the code calls
> >>dlmlock_remote() infinitely.
> 
> 
> Oh a remote master. So ignore my previous reply.
> 
> Yes, I can see the race. But the fix below lets the purge to continue
> and handles it afterwards. A better approach (and more efficient)
> would be to remove the lockres from the purge list itself.
> 
> So the race window is between the first block in dlm_get_lock_resource()
> and dlm_lock_remote().
> 
> See dlm->inflight_locks. Currently we use this when lockres is locally
> mastered. Maybe we could use the same for locally mastered too.

Sunil,

So the only purpose of inflight_locks is to prevent the lockres from
being purged, right?

I think only removing the lockres from the purge list is enough.

If we hack on inflight_locks, we don't need to remove the lockres from purge list,
right?

thanks,
wengang.
> 
