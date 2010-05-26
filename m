From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Wed, 26 May 2010 09:54:17 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2/dlm: remove unreasonable BUG_ON()
In-Reply-To: <4BFC0744.6050804@oracle.com>
References: <201005251058.o4PAhNOK013998@acsinet15.oracle.com>
	<4BFC0744.6050804@oracle.com>
Message-ID: <20100526015417.GA2537@laptop.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 10-05-25 10:22, Sunil Mushran wrote:
> NAK
> 
> How did this lockres get into the dirty list? The dlm only adds locks that
> it owns to that list. And such locks, by definition, can never be in the
> recovery list.

Yes that my description is not good. 

Actually, I hit the BUG_ON(res->owner != dlm->node_num); during some tests.

When an recovery happened, the lockres' that is owned by the "dead" node is
marked as in recovery and the owner is set as unknown. But note that a lockres
owned by this node can also be marked as in recovery(and owner changed to
unknown). That can happen when a migration for the lockres is in progress with
the "dead" node. see dlm_clean_master_list().

So it's that the owner changed from dlm->node_num to unknown when the
lockres is already on the list.

regards,
wengang.

> On 05/25/2010 03:57 AM, Wengang Wang wrote:
> >A node "down" can happen at any time. When that happens, all locres' owned
> >by the "down" node are move to recovery list. They also are marked as in
> >recovery and the owner are set to "unknown" under dlm->spinlock and
> >res->spinlock.
> >
> >Any place shouldn't believe the owner is not changed to "unknown" after
> >dropping the lockres and retaking them.
> >
> >Signed-off-by: Wengang Wang<wen.gang.wang@oracle.com>
> >---
> >  fs/ocfs2/dlm/dlmthread.c |   17 +++++++++--------
> >  1 files changed, 9 insertions(+), 8 deletions(-)
> >
> >diff --git a/fs/ocfs2/dlm/dlmthread.c b/fs/ocfs2/dlm/dlmthread.c
> >index 11a6d1f..cf86b43 100644
> >--- a/fs/ocfs2/dlm/dlmthread.c
> >+++ b/fs/ocfs2/dlm/dlmthread.c
> >@@ -675,15 +675,16 @@ static int dlm_thread(void *data)
> >  			 * dirty_list in this gap, but that is ok */
> >
> >  			spin_lock(&res->spinlock);
> >-			if (res->owner != dlm->node_num) {
> >-				__dlm_print_one_lock_resource(res);
> >-				mlog(ML_ERROR, "inprog:%s, mig:%s, reco:%s, dirty:%s\n",
> >-				     res->state&  DLM_LOCK_RES_IN_PROGRESS ? "yes" : "no",
> >-				     res->state&  DLM_LOCK_RES_MIGRATING ? "yes" : "no",
> >-				     res->state&  DLM_LOCK_RES_RECOVERING ? "yes" : "no",
> >-				     res->state&  DLM_LOCK_RES_DIRTY ? "yes" : "no");
> >+			if (unlikely(res->owner != dlm->node_num)) {
> >+				/*
> >+				 * there is chance that the lockres is marked
> >+				 * as in recovery if a node down happened.
> >+				 */
> >+				if (!(res->state&  DLM_LOCK_RES_RECOVERING)) {
> >+					__dlm_print_one_lock_resource(res);
> >+					BUG();
> >+				}
> >  			}
> >-			BUG_ON(res->owner != dlm->node_num);
> >
> >  			/* it is now ok to move lockreses in these states
> >  			 * to the dirty list, assuming that they will only be
> 
