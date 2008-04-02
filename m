From: Mark Fasheh <mfasheh@suse.com>
Date: Wed,  2 Apr 2008 13:14:53 -0700
Subject: [Ocfs2-devel] [PATCH 43/62] ocfs2/dlm: Move struct
	dlm_master_list_entry to dlmcommon.h
In-Reply-To: <12071674061934-git-send-email-mfasheh@suse.com>
References: <12071673121124-git-send-email-mfasheh@suse.com>
	<1207167318479-git-send-email-mfasheh@suse.com>
	<12071673203909-git-send-email-mfasheh@suse.com>
	<12071673232465-git-send-email-mfasheh@suse.com>
	<12071673263948-git-send-email-mfasheh@suse.com>
	<12071673282579-git-send-email-mfasheh@suse.com>
	<1207167330482-git-send-email-mfasheh@suse.com>
	<12071673321172-git-send-email-mfasheh@suse.com>
	<12071673341888-git-send-email-mfasheh@suse.com>
	<12071673362069-git-send-email-mfasheh@suse.com>
	<12071673391031-git-send-email-mfasheh@suse.com>
	<12071673413492-git-send-email-mfasheh@suse.com>
	<1207167343926-git-send-email-mfasheh@suse.com>
	<12071673461268-git-send-email-mfasheh@suse.com>
	<12071673481928-git-send-email-mfasheh@suse.com>
	<12071673492775-git-send-email-mfasheh@suse.com>
	<12071673511262-git-send-email-mfasheh@suse.com>
	<12071673543752-git-send-email-mfasheh@suse.com>
	<1207167355295-git-send-email-mfasheh@suse.com>
	<12071673571757-git-send-email-mfasheh@suse.com>
	<12071673591158-git-send-email-mfasheh@suse.com>
	<12071673613757-git-send-email-mfasheh@suse.com>
	<1207167363119-git-send-email-mfasheh@suse.com>
	<12071673661674-git-send-email-mfasheh@suse.com>
	<12071673681650-git-send-email-mfasheh@suse.com>
	<12071673701937-git-send-email-mfasheh@suse.com>
	<12071673722691-git-send-email-mfasheh@suse.com>
	<12071673731276-git-send-email-mfasheh@suse.com>
	<12071673753788-git-send-email-mfasheh@suse.com>
	<12071673772233-git-send-email-mfasheh@suse.com>
	<1207167379283-git-send-email-mfasheh@suse.com>
	<12071673821008-git-send-email-mfasheh@suse.com>
	<12071673843208-git-send-email-mfasheh@suse.com>
	<12071673872568-git-send-email-mfasheh@suse.com>
	<12071673882492-git-send-email-mfasheh@suse.com>
	<1207167390414-git-send-email-mfasheh@suse.com>
	<1207167392537-git-send-email-mfasheh@suse.com>
	<12071673941659-git-send-email-mfasheh@suse.com>
	<12071673964014-git-send-email-mfasheh@suse.com>
	<1207167398684-git-send-email-mfasheh@suse.com>
	<12071674013954-git-send-email-mfasheh@suse.com>
	<12071674033903-git-send-email-mfasheh@suse.com>
	<12071674061934-git-send-email-mfasheh@suse.com>
Message-ID: <12071674083120-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>, Sunil Mushran <sunil.mushran@oracle.com>

From: Sunil Mushran <sunil.mushran@oracle.com>

This patch moves some mle related definitions from dlmmaster.c
to dlmcommon.h. Future patches need these definitions to dump mle
debugging information.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
Signed-off-by: Joel Becker <joel.beckeroracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/dlm/dlmcommon.h |   35 +++++++++++++++++++++++++++++++++++
 fs/ocfs2/dlm/dlmmaster.c |   37 -------------------------------------
 2 files changed, 35 insertions(+), 37 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmcommon.h b/fs/ocfs2/dlm/dlmcommon.h
index f7a51ca..d5a86fb 100644
--- a/fs/ocfs2/dlm/dlmcommon.h
+++ b/fs/ocfs2/dlm/dlmcommon.h
@@ -49,6 +49,41 @@
 /* Intended to make it easier for us to switch out hash functions */
 #define dlm_lockid_hash(_n, _l) full_name_hash(_n, _l)
 
+enum dlm_mle_type {
+	DLM_MLE_BLOCK,
+	DLM_MLE_MASTER,
+	DLM_MLE_MIGRATION
+};
+
+struct dlm_lock_name {
+	u8 len;
+	u8 name[DLM_LOCKID_NAME_MAX];
+};
+
+struct dlm_master_list_entry {
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
index 9713346..94cadcb 100644
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
1.5.4.1
