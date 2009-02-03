From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Tue,  3 Feb 2009 12:48:18 -0800
Subject: [Ocfs2-devel] [PATCH 04/10] ocfs2/dlm: Create and destroy the
	dlm->master_hash
In-Reply-To: <1233694104-29710-1-git-send-email-sunil.mushran@oracle.com>
References: <1233694104-29710-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1233694104-29710-5-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This patch adds code to create and destroy the dlm->master_hash.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/dlm/dlmcommon.h |    8 ++++++++
 fs/ocfs2/dlm/dlmdomain.c |   18 ++++++++++++++++++
 2 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmcommon.h b/fs/ocfs2/dlm/dlmcommon.h
index b232aa0..425653f 100644
--- a/fs/ocfs2/dlm/dlmcommon.h
+++ b/fs/ocfs2/dlm/dlmcommon.h
@@ -151,6 +151,7 @@ struct dlm_ctxt
 	unsigned long recovery_map[BITS_TO_LONGS(O2NM_MAX_NODES)];
 	struct dlm_recovery_ctxt reco;
 	spinlock_t master_lock;
+	struct hlist_head **master_hash;
 	struct list_head master_list;
 	struct list_head mle_hb_events;
 
@@ -195,6 +196,13 @@ static inline struct hlist_head *dlm_lockres_hash(struct dlm_ctxt *dlm, unsigned
 	return dlm->lockres_hash[(i / DLM_BUCKETS_PER_PAGE) % DLM_HASH_PAGES] + (i % DLM_BUCKETS_PER_PAGE);
 }
 
+static inline struct hlist_head *dlm_master_hash(struct dlm_ctxt *dlm,
+						 unsigned i)
+{
+	return dlm->master_hash[(i / DLM_BUCKETS_PER_PAGE) % DLM_HASH_PAGES] +
+			(i % DLM_BUCKETS_PER_PAGE);
+}
+
 /* these keventd work queue items are for less-frequently
  * called functions that cannot be directly called from the
  * net message handlers for some reason, usually because
diff --git a/fs/ocfs2/dlm/dlmdomain.c b/fs/ocfs2/dlm/dlmdomain.c
index d8d578f..4531504 100644
--- a/fs/ocfs2/dlm/dlmdomain.c
+++ b/fs/ocfs2/dlm/dlmdomain.c
@@ -304,6 +304,9 @@ static void dlm_free_ctxt_mem(struct dlm_ctxt *dlm)
 	if (dlm->lockres_hash)
 		dlm_free_pagevec((void **)dlm->lockres_hash, DLM_HASH_PAGES);
 
+	if (dlm->master_hash)
+		dlm_free_pagevec((void **)dlm->master_hash, DLM_HASH_PAGES);
+
 	if (dlm->name)
 		kfree(dlm->name);
 
@@ -1534,12 +1537,27 @@ static struct dlm_ctxt *dlm_alloc_ctxt(const char *domain,
 	for (i = 0; i < DLM_HASH_BUCKETS; i++)
 		INIT_HLIST_HEAD(dlm_lockres_hash(dlm, i));
 
+	dlm->master_hash = (struct hlist_head **)
+				dlm_alloc_pagevec(DLM_HASH_PAGES);
+	if (!dlm->master_hash) {
+		mlog_errno(-ENOMEM);
+		dlm_free_pagevec((void **)dlm->lockres_hash, DLM_HASH_PAGES);
+		kfree(dlm->name);
+		kfree(dlm);
+		dlm = NULL;
+		goto leave;
+	}
+
+	for (i = 0; i < DLM_HASH_BUCKETS; i++)
+		INIT_HLIST_HEAD(dlm_master_hash(dlm, i));
+
 	strcpy(dlm->name, domain);
 	dlm->key = key;
 	dlm->node_num = o2nm_this_node();
 
 	ret = dlm_create_debugfs_subroot(dlm);
 	if (ret < 0) {
+		dlm_free_pagevec((void **)dlm->master_hash, DLM_HASH_PAGES);
 		dlm_free_pagevec((void **)dlm->lockres_hash, DLM_HASH_PAGES);
 		kfree(dlm->name);
 		kfree(dlm);
-- 
1.5.6.3
