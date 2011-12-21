From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Wed, 21 Dec 2011 10:49:29 +0800
Subject: [Ocfs2-devel] [PATCH][ocfs2/dlm] fix dlm_clean_master_list
Message-ID: <201112210248.pBL2mvw1032148@acsmt357.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This is a fix on dlm_clean_master_list()

During the hash table browsing, we remove mle from hash table then free
the memory on the last reference. So we have to use a _safe() version
of the browsing function when doing that.

This fixes Orabug #12798517

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
---
 fs/ocfs2/dlm/dlmmaster.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
index 11eefb8..86ec9d2 100644
--- a/fs/ocfs2/dlm/dlmmaster.c
+++ b/fs/ocfs2/dlm/dlmmaster.c
@@ -3182,7 +3182,7 @@ void dlm_clean_master_list(struct dlm_ctxt *dlm, u8 dead_node)
 	struct dlm_master_list_entry *mle;
 	struct dlm_lock_resource *res;
 	struct hlist_head *bucket;
-	struct hlist_node *list;
+	struct hlist_node *list, *n;
 	unsigned int i;
 
 	mlog(0, "dlm=%s, dead node=%u\n", dlm->name, dead_node);
@@ -3193,7 +3193,7 @@ top:
 	spin_lock(&dlm->master_lock);
 	for (i = 0; i < DLM_HASH_BUCKETS; i++) {
 		bucket = dlm_master_hash(dlm, i);
-		hlist_for_each(list, bucket) {
+		hlist_for_each_safe(list, n, bucket) {
 			mle = hlist_entry(list, struct dlm_master_list_entry,
 					  master_hash_node);
 
-- 
1.7.6.4
