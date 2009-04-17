From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Fri, 17 Apr 2009 13:37:31 -0700
Subject: [Ocfs2-devel] [PATCH 18/26] ocfs2/dlm: Indent
	dlm_cleanup_master_list()
In-Reply-To: <1240000659-6201-1-git-send-email-sunil.mushran@oracle.com>
References: <1240000659-6201-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1240000659-6201-19-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mainline commit 67ae1f0604da3bcf3ed6dec59ac71d07e54a404c

The previous patch explicitly did not indent dlm_cleanup_master_list()
so as to make the patch readable. This patch properly indents the
function.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/dlm/dlmmaster.c |  106 ++++++++++++++++++++++-----------------------
 1 files changed, 52 insertions(+), 54 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
index c50eabe..699c6d0 100644
--- a/fs/ocfs2/dlm/dlmmaster.c
+++ b/fs/ocfs2/dlm/dlmmaster.c
@@ -3320,66 +3320,64 @@ top:
 			mle = hlist_entry(list, struct dlm_master_list_entry,
 					  master_hash_node);
 
-		BUG_ON(mle->type != DLM_MLE_BLOCK &&
-		       mle->type != DLM_MLE_MASTER &&
-		       mle->type != DLM_MLE_MIGRATION);
-
-		/* MASTER mles are initiated locally.  the waiting
-		 * process will notice the node map change
-		 * shortly.  let that happen as normal. */
-		if (mle->type == DLM_MLE_MASTER)
-			continue;
-
+			BUG_ON(mle->type != DLM_MLE_BLOCK &&
+			       mle->type != DLM_MLE_MASTER &&
+			       mle->type != DLM_MLE_MIGRATION);
+
+			/* MASTER mles are initiated locally. The waiting
+			 * process will notice the node map change shortly.
+			 * Let that happen as normal. */
+			if (mle->type == DLM_MLE_MASTER)
+				continue;
+
+			/* BLOCK mles are initiated by other nodes. Need to
+			 * clean up if the dead node would have been the
+			 * master. */
+			if (mle->type == DLM_MLE_BLOCK) {
+				dlm_clean_block_mle(dlm, mle, dead_node);
+				continue;
+			}
 
-		/* BLOCK mles are initiated by other nodes.
-		 * need to clean up if the dead node would have
-		 * been the master. */
-		if (mle->type == DLM_MLE_BLOCK) {
-			dlm_clean_block_mle(dlm, mle, dead_node);
-			continue;
+			/* Everything else is a MIGRATION mle */
+
+			/* The rule for MIGRATION mles is that the master
+			 * becomes UNKNOWN if *either* the original or the new
+			 * master dies. All UNKNOWN lockres' are sent to
+			 * whichever node becomes the recovery master. The new
+			 * master is responsible for determining if there is
+			 * still a master for this lockres, or if he needs to
+			 * take over mastery. Either way, this node should
+			 * expect another message to resolve this. */
+
+			if (mle->master != dead_node &&
+			    mle->new_master != dead_node)
+				continue;
+
+			/* If we have reached this point, this mle needs to be
+			 * removed from the list and freed. */
+			dlm_clean_migration_mle(dlm, mle);
+
+			mlog(0, "%s: node %u died during migration from "
+			     "%u to %u!\n", dlm->name, dead_node, mle->master,
+			     mle->new_master);
+
+			/* If we find a lockres associated with the mle, we've
+			 * hit this rare case that messes up our lock ordering.
+			 * If so, we need to drop the master lock so that we can
+			 * take the lockres lock, meaning that we will have to
+			 * restart from the head of list. */
+			res = dlm_reset_mleres_owner(dlm, mle);
+			if (res)
+				/* restart */
+				goto top;
+
+			/* This may be the last reference */
+			__dlm_put_mle(mle);
 		}
-
-		/* everything else is a MIGRATION mle */
-
-		/* the rule for MIGRATION mles is that the master
-		 * becomes UNKNOWN if *either* the original or
-		 * the new master dies.  all UNKNOWN lockreses
-		 * are sent to whichever node becomes the recovery
-		 * master.  the new master is responsible for
-		 * determining if there is still a master for
-		 * this lockres, or if he needs to take over
-		 * mastery.  either way, this node should expect
-		 * another message to resolve this. */
-		if (mle->master != dead_node &&
-		    mle->new_master != dead_node)
-			continue;
-
-		/* if we have reached this point, this mle needs to
-		 * be removed from the list and freed. */
-		dlm_clean_migration_mle(dlm, mle);
-
-		mlog(0, "%s: node %u died during migration from "
-		     "%u to %u!\n", dlm->name, dead_node,
-		     mle->master, mle->new_master);
-
-		/* If we find a lockres associated with the mle, we've
-		 * hit this rare case that messes up our lock ordering.
-		 * If so, we need to drop the master lock so that we can
-		 * take the lockres lock, meaning that we will have to
-		 * restart from the head of list. */
-		res = dlm_reset_mleres_owner(dlm, mle);
-		if (res)
-			/* restart */
-			goto top;
-
-		/* this may be the last reference */
-		__dlm_put_mle(mle);
-	}
 	}
 	spin_unlock(&dlm->master_lock);
 }
 
-
 int dlm_finish_migration(struct dlm_ctxt *dlm, struct dlm_lock_resource *res,
 			 u8 old_master)
 {
-- 
1.5.6.3
