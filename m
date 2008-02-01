From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Fri Feb  1 16:50:01 2008
Subject: [Ocfs2-devel] [PATCH 08/12] ocfs2_dlm: Moves struct
	dlm_master_list_entry to dlmcommon.h
In-Reply-To: <1201913371-1522-1-git-send-email-sunil.mushran@oracle.com>
References: <1201913371-1522-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1201913371-1522-9-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This patch moves some mle related definitions from dlmmaster.c
to dlmcommon.h.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/dlm/dlmcommon.h |   37 +++++++++++++++++++++++++++++++++++++
 fs/ocfs2/dlm/dlmmaster.c |   37 -------------------------------------
 2 files changed, 37 insertions(+), 37 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmcommon.h b/fs/ocfs2/dlm/dlmcommon.h
index 9828722..fb71a32 100644
--- a/fs/ocfs2/dlm/dlmcommon.h
+++ b/fs/ocfs2/dlm/dlmcommon.h
@@ -49,6 +49,43 @@
 /* Intended to make it easier for us to switch out hash functions */
 #define dlm_lockid_hash(_n, _l) full_name_hash(_n, _l)
 
+enum dlm_mle_type {
+	DLM_MLE_BLOCK,
+	DLM_MLE_MASTER,
+	DLM_MLE_MIGRATION
+};
+
+struct dlm_lock_name
+{
+	u8 len;
+	u8 name[DLM_LOCKID_NAME_MAX];
+};
+
+struct dlm_master_list_entry
+{
+	struct list_head list;
+	struct list_head hb_events;
+	struct dlm_ctxt *dlm;
+	spinlock_t spinlock;
+	wait_queue_head_t wq;
+	atomic_t woken;
+	struct kref mle_refs;
+	int inuse;
+	unsigned long maybe_map[BITS_TO_LONGS(O2NM_MAX_NODES)];
+	unsigned long vote_map[BITS_TO_LONGS(O2NM_MAX_NODES)];
+	unsigned long response_map[BITS_TO_LONGS(O2NM_MAX_NODES)];
+	unsigned long node_map[BITS_TO_LONGS(O2NM_MAX_NODES)];
+	u8 master;
+	u8 new_master;
+	enum dlm_mle_type type;
+	struct o2hb_callback_func mle_hb_up;
+	struct o2hb_callback_func mle_hb_down;
+	union {
+		struct dlm_lock_resource *res;
+		struct dlm_lock_name name;
+	} u;
+};
+
 enum dlm_ast_type {
 	DLM_AST = 0,
 	DLM_BAST,
diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
index 4f2bf7c..05c86f2 100644
--- a/fs/ocfs2/dlm/dlmmaster.c
+++ b/fs/ocfs2/dlm/dlmmaster.c
@@ -52,43 +52,6 @@
 #define MLOG_MASK_PREFIX (ML_DLM|ML_DLM_MASTER)
 #include "cluster/masklog.h"
 
-enum dlm_mle_type {
-	DLM_MLE_BLOCK,
-	DLM_MLE_MASTER,
-	DLM_MLE_MIGRATION
-};
-
-struct dlm_lock_name
-{
-	u8 len;
-	u8 name[DLM_LOCKID_NAME_MAX];
-};
-
-struct dlm_master_list_entry
-{
-	struct list_head list;
-	struct list_head hb_events;
-	struct dlm_ctxt *dlm;
-	spinlock_t spinlock;
-	wait_queue_head_t wq;
-	atomic_t woken;
-	struct kref mle_refs;
-	int inuse;
-	unsigned long maybe_map[BITS_TO_LONGS(O2NM_MAX_NODES)];
-	unsigned long vote_map[BITS_TO_LONGS(O2NM_MAX_NODES)];
-	unsigned long response_map[BITS_TO_LONGS(O2NM_MAX_NODES)];
-	unsigned long node_map[BITS_TO_LONGS(O2NM_MAX_NODES)];
-	u8 master;
-	u8 new_master;
-	enum dlm_mle_type type;
-	struct o2hb_callback_func mle_hb_up;
-	struct o2hb_callback_func mle_hb_down;
-	union {
-		struct dlm_lock_resource *res;
-		struct dlm_lock_name name;
-	} u;
-};
-
 static void dlm_mle_node_down(struct dlm_ctxt *dlm,
 			      struct dlm_master_list_entry *mle,
 			      struct o2nm_node *node,
-- 
1.5.2.5
