From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Fri, 10 Jun 2011 08:32:50 +0800
Subject: [Ocfs2-devel] [PATCH] remove lockres from purge list when we
 are getting it for creating lock
In-Reply-To: <4DF11229.2070706@oracle.com>
References: <201106080229.p582TILH031715@acsmt356.oracle.com>
	<4DF0576F.1010002@oracle.com> <4DF11229.2070706@oracle.com>
Message-ID: <20110610003250.GA3437@laptop.jp.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 11-06-09 11:34, Sunil Mushran wrote:
> Different issue. That patch plugged a hole when the master was remote.
> In this case the master is local.

I think in my case, the master is remote too. The phenomemon is local
node keeps sending messages infinitely to the master which is dead.
> 
> In this case, the window is very tiny as we not only need the recovery to
> kick-in in the that window, we also need the lockres to be moved to the
> purgelist in that window.
> 
> But it just so happens that ovm via userdlm hits createlock a lot making
> this issue more likely to trigger than with the fs.

Yes, OVM create the lock in every 5 seconds via dlmfs.

thanks,
wengang.
> On 06/08/2011 10:17 PM, Srinivas Eeda wrote:
> >I think I have seen this problem in ocfs2-1.2 and it was addressed by
> >using a new state DLM_LOCK_RES_IN_USE. But we didn't merge into mainline
> >as sunil suggested we need to look for a different approach
> >
> >http://oss.oracle.com/pipermail/ocfs2-devel/2010-June/006669.html
> >http://www.mail-archive.com/ocfs2-devel at oss.oracle.com/msg05733.html
> >
> >one comment inline
> >
> >On 6/8/2011 3:04 AM, Wengang Wang wrote:
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
> >>
> >>I have met such a problem (orabug 12405575).
> >>The lockres is in the purge list already(there is a delay for real purge work)
> >>and the create lock request comes. When we are sending network message to the
> >>owner in dlmlock_remote(), the owner crashed. So we get DLM_RECOVERING as return
> >>value and retries dlmlock_remote(). And before the owner crash, we have purged
> >>the lockres. So the lockres become stale(on lockres->onwer). Thus the code calls
> >>dlmlock_remote() infinitely.
> >>
> >>fix:
> >>we remove the lockres from purge list if it's there in dlm_get_lock_resource()
> >>which is called for only createlock case. So that the lockres can't be purged
> >>when we are in progress of createlock.
> >>
> >>Signed-off-by: Wengang Wang<wen.gang.wang@oracle.com>
> >>---
> >>   fs/ocfs2/dlm/dlmmaster.c |   41 +++++++++++++++++++++++++++++------------
> >>   1 files changed, 29 insertions(+), 12 deletions(-)
> >>
> >>diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
> >>index 11eefb8..511d43c 100644
> >>--- a/fs/ocfs2/dlm/dlmmaster.c
> >>+++ b/fs/ocfs2/dlm/dlmmaster.c
> >>@@ -709,28 +709,27 @@ lookup:
> >>   	spin_lock(&dlm->spinlock);
> >>   	tmpres = __dlm_lookup_lockres_full(dlm, lockid, namelen, hash);
> >>   	if (tmpres) {
> >>-		int dropping_ref = 0;
> >>-
> >>-		spin_unlock(&dlm->spinlock);
> >>-
> >>   		spin_lock(&tmpres->spinlock);
> >>   		/* We wait for the other thread that is mastering the resource */
> >>   		if (tmpres->owner == DLM_LOCK_RES_OWNER_UNKNOWN) {
> >>+			spin_unlock(&dlm->spinlock);
> >>   			__dlm_wait_on_lockres(tmpres);
> >>   			BUG_ON(tmpres->owner == DLM_LOCK_RES_OWNER_UNKNOWN);
> >>+			spin_unlock(&tmpres->spinlock);
> >>+			dlm_lockres_put(tmpres);
> >>+			tmpres = NULL;
> >>+			goto lookup;
> >>   		}
> >>
> >>   		if (tmpres->owner == dlm->node_num) {
> >>   			BUG_ON(tmpres->state&   DLM_LOCK_RES_DROPPING_REF);
> >>   			dlm_lockres_grab_inflight_ref(dlm, tmpres);
> >>-		} else if (tmpres->state&   DLM_LOCK_RES_DROPPING_REF)
> >>-			dropping_ref = 1;
> >>-		spin_unlock(&tmpres->spinlock);
> >>-
> >>-		/* wait until done messaging the master, drop our ref to allow
> >>-		 * the lockres to be purged, start over. */
> >>-		if (dropping_ref) {
> >>-			spin_lock(&tmpres->spinlock);
> >>+		} else if (tmpres->state&   DLM_LOCK_RES_DROPPING_REF) {
> >>+			/*
> >>+			 * wait until done messaging the master, drop our ref to
> >>+			 * allow the lockres to be purged, start over.
> >>+			 */
> >>+			spin_unlock(&dlm->spinlock);
> >>   			__dlm_wait_on_lockres_flags(tmpres, DLM_LOCK_RES_DROPPING_REF);
> >>   			spin_unlock(&tmpres->spinlock);
> >>   			dlm_lockres_put(tmpres);
> >>@@ -739,6 +738,24 @@ lookup:
> >>   		}
> >>
> >>   		mlog(0, "found in hash!\n");
> >>+		/*
> >>+		 * we are going to do a create-lock next. so remove the lockres
> >>+		 * from purge list to avoid the case that we will access on the
> >>+		 * lockres which is already purged out from hash table in
> >>+		 * dlm_run_purge_list() path.
> >>+		 * otherwise, we could run into a problem:
> >>+		 * the owner dead(recovery didn't take care of this lockres
> >>+		 * since it's not in hashtable), and the code keeps sending
> >>+		 * request to the dead node and getting DLM_RECOVERING and
> >>+		 * then retrying infinitely.
> >>+		 */
> >>+		if (!list_empty(&tmpres->purge)) {
> >>+			list_del_init(&tmpres->purge);
> >>+			dlm_lockres_put(tmpres);
> >>+		}
> >>+		
> >>+		spin_unlock(&tmpres->spinlock);
> >>+		spin_unlock(&dlm->spinlock);
> >lockres could still get added to purgelist at this point and we could
> >still have the same problem? I think, here we need some mechanism that
> >marks the lockres is in use that would protect it from adding to the
> >purgelist?
> >>   		if (res)
> >>   			dlm_lockres_put(res);
> >>   		res = tmpres;
> >_______________________________________________
> >Ocfs2-devel mailing list
> >Ocfs2-devel at oss.oracle.com
> >http://oss.oracle.com/mailman/listinfo/ocfs2-devel
> 
