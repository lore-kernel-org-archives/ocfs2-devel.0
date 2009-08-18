From: Tao Ma <tao.ma@oracle.com>
Date: Tue, 18 Aug 2009 14:19:35 +0800
Subject: [Ocfs2-devel] [PATCH 34/41] ocfs2: Don't merge in 1st refcount ops
	of reflink.
In-Reply-To: <4A8A47DF.8020707@oracle.com>
References: <4A8A47DF.8020707@oracle.com>
Message-ID: <1250576382-27080-34-git-send-email-tao.ma@oracle.com>
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
index b80fa18..4a16574 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -1145,7 +1145,7 @@ static void ocfs2_refcount_rec_merge(struct ocfs2_refcount_block *rb,
 static int ocfs2_change_refcount_rec(handle_t *handle,
 				     struct ocfs2_caching_info *ci,
 				     struct buffer_head *ref_leaf_bh,
-				     int index, int change)
+				     int index, int merge, int change)
 {
 	int ret;
 	struct ocfs2_refcount_block *rb =
@@ -1174,7 +1174,7 @@ static int ocfs2_change_refcount_rec(handle_t *handle,
 		}
 
 		le16_add_cpu(&rl->rl_used, -1);
-	} else
+	} else if (merge)
 		ocfs2_refcount_rec_merge(rb, index);
 
 	ret = ocfs2_journal_dirty(handle, ref_leaf_bh);
@@ -1650,7 +1650,7 @@ static int ocfs2_insert_refcount_rec(handle_t *handle,
 				     struct buffer_head *ref_root_bh,
 				     struct buffer_head *ref_leaf_bh,
 				     struct ocfs2_refcount_rec *rec,
-				     int index,
+				     int index, int merge,
 				     struct ocfs2_alloc_context *meta_ac)
 {
 	int ret;
@@ -1708,7 +1708,8 @@ static int ocfs2_insert_refcount_rec(handle_t *handle,
 
 	le16_add_cpu(&rf_list->rl_used, 1);
 
-	ocfs2_refcount_rec_merge(rb, index);
+	if (merge)
+		ocfs2_refcount_rec_merge(rb, index);
 
 	ret = ocfs2_journal_dirty(handle, ref_leaf_bh);
 	if (ret) {
@@ -1742,7 +1743,7 @@ static int ocfs2_split_refcount_rec(handle_t *handle,
 				    struct buffer_head *ref_root_bh,
 				    struct buffer_head *ref_leaf_bh,
 				    struct ocfs2_refcount_rec *split_rec,
-				    int index,
+				    int index, int merge,
 				    struct ocfs2_alloc_context *meta_ac,
 				    struct ocfs2_cached_dealloc_ctxt *dealloc)
 {
@@ -1880,7 +1881,8 @@ static int ocfs2_split_refcount_rec(handle_t *handle,
 		     le32_to_cpu(split_rec->r_refcount),
 		     (unsigned long long)ref_leaf_bh->b_blocknr, index);
 
-		ocfs2_refcount_rec_merge(rb, index);
+		if (merge)
+			ocfs2_refcount_rec_merge(rb, index);
 	}
 
 	ret = ocfs2_journal_dirty(handle, ref_leaf_bh);
@@ -1892,12 +1894,12 @@ out:
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
@@ -1935,7 +1937,8 @@ int ocfs2_increase_refcount(handle_t *handle,
 			     "count %u\n", (unsigned long long)cpos, set_len,
 			     le32_to_cpu(rec.r_refcount));
 			ret = ocfs2_change_refcount_rec(handle, ci,
-							ref_leaf_bh, index, 1);
+							ref_leaf_bh, index,
+							merge, 1);
 			if (ret) {
 				mlog_errno(ret);
 				goto out;
@@ -1948,7 +1951,8 @@ int ocfs2_increase_refcount(handle_t *handle,
 			     set_len);
 			ret = ocfs2_insert_refcount_rec(handle, ci, ref_root_bh,
 							ref_leaf_bh,
-							&rec, index, meta_ac);
+							&rec, index,
+							merge, meta_ac);
 			if (ret) {
 				mlog_errno(ret);
 				goto out;
@@ -1966,7 +1970,7 @@ int ocfs2_increase_refcount(handle_t *handle,
 			     set_len, le32_to_cpu(rec.r_refcount));
 			ret = ocfs2_split_refcount_rec(handle, ci,
 						       ref_root_bh, ref_leaf_bh,
-						       &rec, index,
+						       &rec, index, merge,
 						       meta_ac, dealloc);
 			if (ret) {
 				mlog_errno(ret);
@@ -2059,6 +2063,18 @@ out:
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
@@ -2079,7 +2095,7 @@ static int ocfs2_decrease_refcount_rec(handle_t *handle,
 	if (cpos == le64_to_cpu(rec->r_cpos) &&
 	    len == le32_to_cpu(rec->r_clusters))
 		ret = ocfs2_change_refcount_rec(handle, ci,
-						ref_leaf_bh, index, -1);
+						ref_leaf_bh, index, 1, -1);
 	else {
 		struct ocfs2_refcount_rec split = *rec;
 		split.r_cpos = cpu_to_le64(cpos);
@@ -2095,7 +2111,7 @@ static int ocfs2_decrease_refcount_rec(handle_t *handle,
 		     le32_to_cpu(rec->r_clusters));
 		ret = ocfs2_split_refcount_rec(handle, ci,
 					       ref_root_bh, ref_leaf_bh,
-					       &split, index,
+					       &split, index, 1,
 					       meta_ac, dealloc);
 	}
 
@@ -3488,9 +3504,9 @@ int ocfs2_add_refcount_flag(struct inode *inode,
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
