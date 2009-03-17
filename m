From: Mark Fasheh <mfasheh@suse.com>
Date: Tue, 17 Mar 2009 13:01:07 -0700
Subject: [Ocfs2-devel] [PATCH 17/32] ocfs2/dlm: Encapsulate adding and
	removing of mle from dlm->master_list
In-Reply-To: <1237320082-12921-1-git-send-email-mfasheh@suse.com>
References: <1237320082-12921-1-git-send-email-mfasheh@suse.com>
Message-ID: <1237320082-12921-18-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>, Sunil Mushran <sunil.mushran@oracle.com>, Mark Fasheh <mfasheh@suse.com>

From: Sunil Mushran <sunil.mushran@oracle.com>

This patch encapsulates adding and removing of the mle from the
dlm->master_list. This patch is part of the series of patches that
converts the mle list to a mle hash.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/dlm/dlmcommon.h |    3 +++
 fs/ocfs2/dlm/dlmmaster.c |   34 +++++++++++++++++++++++-----------
 2 files changed, 26 insertions(+), 11 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmcommon.h b/fs/ocfs2/dlm/dlmcommon.h
index bb53714..261e265 100644
--- a/fs/ocfs2/dlm/dlmcommon.h
+++ b/fs/ocfs2/dlm/dlmcommon.h
@@ -1008,6 +1008,9 @@ static inline void __dlm_wait_on_lockres(struct dlm_lock_resource *res)
 					  DLM_LOCK_RES_MIGRATING));
 }
 
+void __dlm_unlink_mle(struct dlm_ctxt *dlm, struct dlm_master_list_entry *mle);
+void __dlm_insert_mle(struct dlm_ctxt *dlm, struct dlm_master_list_entry *mle);
+
 /* create/destroy slab caches */
 int dlm_init_master_caches(void);
 void dlm_destroy_master_caches(void);
diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
index 0a28139..0aa4b04 100644
--- a/fs/ocfs2/dlm/dlmmaster.c
+++ b/fs/ocfs2/dlm/dlmmaster.c
@@ -318,6 +318,21 @@ static void dlm_init_mle(struct dlm_master_list_entry *mle,
 	__dlm_mle_attach_hb_events(dlm, mle);
 }
 
+void __dlm_unlink_mle(struct dlm_ctxt *dlm, struct dlm_master_list_entry *mle)
+{
+	assert_spin_locked(&dlm->spinlock);
+	assert_spin_locked(&dlm->master_lock);
+
+	if (!list_empty(&mle->list))
+		list_del_init(&mle->list);
+}
+
+void __dlm_insert_mle(struct dlm_ctxt *dlm, struct dlm_master_list_entry *mle)
+{
+	assert_spin_locked(&dlm->master_lock);
+
+	list_add(&mle->list, &dlm->master_list);
+}
 
 /* returns 1 if found, 0 if not */
 static int dlm_find_mle(struct dlm_ctxt *dlm,
@@ -420,8 +435,7 @@ static void dlm_mle_release(struct kref *kref)
 	assert_spin_locked(&dlm->master_lock);
 
 	/* remove from list if not already */
-	if (!list_empty(&mle->list))
-		list_del_init(&mle->list);
+	__dlm_unlink_mle(dlm, mle);
 
 	/* detach the mle from the domain node up/down events */
 	__dlm_mle_detach_hb_events(dlm, mle);
@@ -843,7 +857,7 @@ lookup:
 		alloc_mle = NULL;
 		dlm_init_mle(mle, DLM_MLE_MASTER, dlm, res, NULL, 0);
 		set_bit(dlm->node_num, mle->maybe_map);
-		list_add(&mle->list, &dlm->master_list);
+		__dlm_insert_mle(dlm, mle);
 
 		/* still holding the dlm spinlock, check the recovery map
 		 * to see if there are any nodes that still need to be 
@@ -1575,7 +1589,7 @@ way_up_top:
 		// "add the block.\n");
 		dlm_init_mle(mle, DLM_MLE_BLOCK, dlm, NULL, name, namelen);
 		set_bit(request->node_idx, mle->maybe_map);
-		list_add(&mle->list, &dlm->master_list);
+		__dlm_insert_mle(dlm, mle);
 		response = DLM_MASTER_RESP_NO;
 	} else {
 		// mlog(0, "mle was found\n");
@@ -1967,7 +1981,7 @@ ok:
 			     assert->node_idx, rr, extra_ref, mle->inuse);
 			dlm_print_one_mle(mle);
 		}
-		list_del_init(&mle->list);
+		__dlm_unlink_mle(dlm, mle);
 		__dlm_mle_detach_hb_events(dlm, mle);
 		__dlm_put_mle(mle);
 		if (extra_ref) {
@@ -3159,10 +3173,8 @@ static int dlm_add_migration_mle(struct dlm_ctxt *dlm,
 			tmp->master = master;
 			atomic_set(&tmp->woken, 1);
 			wake_up(&tmp->wq);
-			/* remove it from the list so that only one
-			 * mle will be found */
-			list_del_init(&tmp->list);
-			/* this was obviously WRONG.  mle is uninited here.  should be tmp. */
+			/* remove it so that only one mle will be found */
+			__dlm_unlink_mle(dlm, tmp);
 			__dlm_mle_detach_hb_events(dlm, tmp);
 			ret = DLM_MIGRATE_RESPONSE_MASTERY_REF;
 			mlog(0, "%s:%.*s: master=%u, newmaster=%u, "
@@ -3181,7 +3193,7 @@ static int dlm_add_migration_mle(struct dlm_ctxt *dlm,
 	mle->master = master;
 	/* do this for consistency with other mle types */
 	set_bit(new_master, mle->maybe_map);
-	list_add(&mle->list, &dlm->master_list);
+	__dlm_insert_mle(dlm, mle);
 
 	return ret;
 }
@@ -3264,7 +3276,7 @@ top:
 		 * list_head while in list_for_each_safe */
 		__dlm_mle_detach_hb_events(dlm, mle);
 		spin_lock(&mle->spinlock);
-		list_del_init(&mle->list);
+		__dlm_unlink_mle(dlm, mle);
 		atomic_set(&mle->woken, 1);
 		spin_unlock(&mle->spinlock);
 		wake_up(&mle->wq);
-- 
1.5.6
