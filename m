From: Tao Ma <tao.ma@oracle.com>
Date: Thu, 30 Apr 2009 06:58:49 +0800
Subject: [Ocfs2-devel] [PATCH 37/39] ocfs2: Don't merge in 1st refcount ops
	of reflink.
In-Reply-To: <49F95A79.6040806@oracle.com>
References: <49F95A79.6040806@oracle.com>
Message-ID: <1241045931-24607-37-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Actually the whole reflink will touch refcount tree 2 times:
1. It will add the clusters in the extent record to the tree if it
   isn't refcounted before.
2. It will add 1 refcount to these clusters when it add these
   extent records to the tree.

So actually we shouldn't do merge in the 1st operation since the 2nd
one will soon be called and we may have to split it again. Do a merge
first and split soon is a waste of time. So we only merge in the 2nd
round. This is done by adding a new internal __ocfs2_increase_refcount
and call it with "not-merge" for 1st refcount operation in reflink.

This also has a side-effect that we don't need to worry too much about
the metadata allocation in the 2nd round since it will only merge and
no split will happen for those records.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/refcounttree.c |   56 ++++++++++++++++++++++++++++++----------------
 1 files changed, 36 insertions(+), 20 deletions(-)

diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index 4d86659..86d4884 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -705,7 +705,7 @@ static void ocfs2_refcount_rec_merge(struct ocfs2_refcount_block *rb,
 static int ocfs2_change_refcount_rec(handle_t *handle,
 				     struct ocfs2_caching_info *ci,
 				     struct buffer_head *ref_leaf_bh,
-				     int index, int change)
+				     int index, int merge, int change)
 {
 	int ret;
 	struct ocfs2_refcount_block *rb =
@@ -734,7 +734,7 @@ static int ocfs2_change_refcount_rec(handle_t *handle,
 		}
 
 		le16_add_cpu(&rl->rl_used, -1);
-	} else
+	} else if (merge)
 		ocfs2_refcount_rec_merge(rb, index);
 
 	ret = ocfs2_journal_dirty(handle, ref_leaf_bh);
@@ -1109,7 +1109,7 @@ static int ocfs2_insert_refcount_rec(handle_t *handle,
 				     struct buffer_head *ref_root_bh,
 				     struct buffer_head *ref_leaf_bh,
 				     struct ocfs2_refcount_rec *rec,
-				     int index,
+				     int index, int merge,
 				     struct ocfs2_alloc_context *meta_ac)
 {
 	int ret;
@@ -1161,7 +1161,8 @@ static int ocfs2_insert_refcount_rec(handle_t *handle,
 
 	le16_add_cpu(&rf_list->rl_used, 1);
 
-	ocfs2_refcount_rec_merge(rb, index);
+	if (merge)
+		ocfs2_refcount_rec_merge(rb, index);
 
 	ret = ocfs2_journal_dirty(handle, ref_leaf_bh);
 	if (ret)
@@ -1186,7 +1187,7 @@ static int ocfs2_split_refcount_rec(handle_t *handle,
 				    struct buffer_head *ref_root_bh,
 				    struct buffer_head *ref_leaf_bh,
 				    struct ocfs2_refcount_rec *split_rec,
-				    int index,
+				    int index, int merge,
 				    struct ocfs2_alloc_context *meta_ac,
 				    struct ocfs2_cached_dealloc_ctxt *dealloc)
 {
@@ -1295,7 +1296,8 @@ static int ocfs2_split_refcount_rec(handle_t *handle,
 
 	if (split_rec->r_refcount) {
 		rf_list->rl_recs[index] = *split_rec;
-		ocfs2_refcount_rec_merge(rb, index);
+		if (merge)
+			ocfs2_refcount_rec_merge(rb, index);
 	}
 
 	ret = ocfs2_journal_dirty(handle, ref_leaf_bh);
@@ -1307,12 +1309,12 @@ out:
 	return ret;
 }
 
-int ocfs2_increase_refcount(handle_t *handle,
-			    struct ocfs2_caching_info *ci,
-			    struct buffer_head *ref_root_bh,
-			    u64 cpos, u32 len,
-			    struct ocfs2_alloc_context *meta_ac,
-			    struct ocfs2_cached_dealloc_ctxt *dealloc)
+static int __ocfs2_increase_refcount(handle_t *handle,
+				     struct ocfs2_caching_info *ci,
+				     struct buffer_head *ref_root_bh,
+				     u64 cpos, u32 len, int merge,
+				     struct ocfs2_alloc_context *meta_ac,
+				     struct ocfs2_cached_dealloc_ctxt *dealloc)
 {
 	int ret = 0, index;
 	struct buffer_head *ref_leaf_bh = NULL;
@@ -1350,7 +1352,8 @@ int ocfs2_increase_refcount(handle_t *handle,
 			     "count %u\n", (unsigned long long)cpos, set_len,
 			     le32_to_cpu(rec.r_refcount));
 			ret = ocfs2_change_refcount_rec(handle, ci,
-							ref_leaf_bh, index, 1);
+							ref_leaf_bh, index,
+							merge, 1);
 			if (ret) {
 				mlog_errno(ret);
 				goto out;
@@ -1363,7 +1366,8 @@ int ocfs2_increase_refcount(handle_t *handle,
 			     set_len);
 			ret = ocfs2_insert_refcount_rec(handle, ci, ref_root_bh,
 							ref_leaf_bh,
-							&rec, index, meta_ac);
+							&rec, index,
+							merge, meta_ac);
 			if (ret) {
 				mlog_errno(ret);
 				goto out;
@@ -1381,7 +1385,7 @@ int ocfs2_increase_refcount(handle_t *handle,
 			     set_len, le32_to_cpu(rec.r_refcount));
 			ret = ocfs2_split_refcount_rec(handle, ci,
 						       ref_root_bh, ref_leaf_bh,
-						       &rec, index,
+						       &rec, index, merge,
 						       meta_ac, dealloc);
 			if (ret) {
 				mlog_errno(ret);
@@ -1459,6 +1463,18 @@ out:
 	return ret;
 }
 
+int ocfs2_increase_refcount(handle_t *handle,
+			    struct ocfs2_caching_info *ci,
+			    struct buffer_head *ref_root_bh,
+			    u64 cpos, u32 len,
+			    struct ocfs2_alloc_context *meta_ac,
+			    struct ocfs2_cached_dealloc_ctxt *dealloc)
+{
+	return __ocfs2_increase_refcount(handle, ci, ref_root_bh,
+					 cpos, len, 1,
+					 meta_ac, dealloc);
+}
+
 static int ocfs2_decrease_refcount_rec(handle_t *handle,
 				struct ocfs2_caching_info *ci,
 				struct buffer_head *ref_root_bh,
@@ -1479,7 +1495,7 @@ static int ocfs2_decrease_refcount_rec(handle_t *handle,
 	if (cpos == le64_to_cpu(rec->r_cpos) && cpos + len ==
 	    le64_to_cpu(rec->r_cpos) + le32_to_cpu(rec->r_clusters))
 		ret = ocfs2_change_refcount_rec(handle, ci,
-						ref_leaf_bh, index, -1);
+						ref_leaf_bh, index, 1, -1);
 	else {
 		struct ocfs2_refcount_rec split = *rec;
 		split.r_cpos = cpu_to_le64(cpos);
@@ -1495,7 +1511,7 @@ static int ocfs2_decrease_refcount_rec(handle_t *handle,
 		     le32_to_cpu(rec->r_clusters));
 		ret = ocfs2_split_refcount_rec(handle, ci,
 					       ref_root_bh, ref_leaf_bh,
-					       &split, index,
+					       &split, index, 1,
 					       meta_ac, dealloc);
 	}
 
@@ -2879,9 +2895,9 @@ int ocfs2_add_refcount_flag(struct inode *inode,
 		goto out_commit;
 	}
 
-	ret = ocfs2_increase_refcount(handle, ref_ci, ref_root_bh,
-				      p_cluster, num_clusters,
-				      meta_ac, dealloc);
+	ret = __ocfs2_increase_refcount(handle, ref_ci, ref_root_bh,
+					p_cluster, num_clusters, 0,
+					meta_ac, dealloc);
 	if (ret) {
 		mlog_errno(ret);
 		goto out_commit;
-- 
1.6.2.rc2.16.gf474c
