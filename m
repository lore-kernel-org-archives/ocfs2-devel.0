From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Tue,  3 Feb 2009 12:48:21 -0800
Subject: [Ocfs2-devel] [PATCH 07/10] ocfs2/dlm: Track number of mles
In-Reply-To: <1233694104-29710-1-git-send-email-sunil.mushran@oracle.com>
References: <1233694104-29710-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1233694104-29710-8-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The lifetime of a mle is limited to the duration of the lockres mastery
process. While typically this lifetime is fairly short, we have noticed
the number of mles explode under certain circumstances. This patch tracks
the number of each different types of mles and should help us determine
how best to speed up the mastery process.

Signed-of-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/dlm/dlmcommon.h |    5 ++++-
 fs/ocfs2/dlm/dlmdomain.c |    5 +++++
 fs/ocfs2/dlm/dlmmaster.c |    5 +++++
 3 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmcommon.h b/fs/ocfs2/dlm/dlmcommon.h
index aa55271..67b3447 100644
--- a/fs/ocfs2/dlm/dlmcommon.h
+++ b/fs/ocfs2/dlm/dlmcommon.h
@@ -52,7 +52,8 @@
 enum dlm_mle_type {
 	DLM_MLE_BLOCK,
 	DLM_MLE_MASTER,
-	DLM_MLE_MIGRATION
+	DLM_MLE_MIGRATION,
+	DLM_MLE_NUM_TYPES
 };
 
 struct dlm_lock_name {
@@ -156,6 +157,8 @@ struct dlm_ctxt
 	struct list_head mle_hb_events;
 
 	/* these give a really vague idea of the system load */
+	atomic_t mle_tot_count[DLM_MLE_NUM_TYPES];
+	atomic_t mle_cur_count[DLM_MLE_NUM_TYPES];
 	atomic_t local_resources;
 	atomic_t remote_resources;
 	atomic_t unknown_resources;
diff --git a/fs/ocfs2/dlm/dlmdomain.c b/fs/ocfs2/dlm/dlmdomain.c
index 869648c..0479bdf 100644
--- a/fs/ocfs2/dlm/dlmdomain.c
+++ b/fs/ocfs2/dlm/dlmdomain.c
@@ -1608,6 +1608,11 @@ static struct dlm_ctxt *dlm_alloc_ctxt(const char *domain,
 	atomic_set(&dlm->remote_resources, 0);
 	atomic_set(&dlm->unknown_resources, 0);
 
+	for (i = 0; i < DLM_MLE_NUM_TYPES; ++i) {
+		atomic_set(&dlm->mle_tot_count[i], 0);
+		atomic_set(&dlm->mle_cur_count[i], 0);
+	}
+
 	spin_lock_init(&dlm->work_lock);
 	INIT_LIST_HEAD(&dlm->work_list);
 	INIT_WORK(&dlm->dispatched_work, dlm_dispatch_work);
diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
index 604552e..acfc928 100644
--- a/fs/ocfs2/dlm/dlmmaster.c
+++ b/fs/ocfs2/dlm/dlmmaster.c
@@ -325,6 +325,9 @@ static void dlm_init_mle(struct dlm_master_list_entry *mle,
 		mle->u.mlename.hash = dlm_lockid_hash(name, namelen);
 	}
 
+	atomic_inc(&dlm->mle_tot_count[mle->type]);
+	atomic_inc(&dlm->mle_cur_count[mle->type]);
+
 	/* copy off the node_map and register hb callbacks on our copy */
 	memcpy(mle->node_map, dlm->domain_map, sizeof(mle->node_map));
 	memcpy(mle->vote_map, dlm->domain_map, sizeof(mle->vote_map));
@@ -467,6 +470,8 @@ static void dlm_mle_release(struct kref *kref)
 	/* detach the mle from the domain node up/down events */
 	__dlm_mle_detach_hb_events(dlm, mle);
 
+	atomic_dec(&dlm->mle_cur_count[mle->type]);
+
 	/* NOTE: kfree under spinlock here.
 	 * if this is bad, we can move this to a freelist. */
 	kmem_cache_free(dlm_mle_cache, mle);
-- 
1.5.6.3
