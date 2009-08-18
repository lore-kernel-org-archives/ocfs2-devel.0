From: Tao Ma <tao.ma@oracle.com>
Date: Tue, 18 Aug 2009 14:19:19 +0800
Subject: [Ocfs2-devel] [PATCH 18/41] ocfs2: CoW refcount tree improvement.
In-Reply-To: <4A8A47DF.8020707@oracle.com>
References: <4A8A47DF.8020707@oracle.com>
Message-ID: <1250576382-27080-18-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

During CoW, if the old extent record is refcounted, we allocate
som new clusters and do CoW. Actually we can have some improvement
here. If the old extent has refcount=1, that means now it is only
used by this file. So we don't need to allocate new clusters, just
remove the refcounted flag and it is OK. We also have to remove
it from the refcount tree while not deleting it.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/alloc.c        |    2 +-
 fs/ocfs2/refcounttree.c |  104 +++++++++++++++++++++++++++++++++++------------
 fs/ocfs2/refcounttree.h |    3 +-
 3 files changed, 81 insertions(+), 28 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index b8fc95d..7c879fc 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -6974,7 +6974,7 @@ static int ocfs2_do_truncate(struct ocfs2_super *osb,
 					ocfs2_blocks_to_clusters(osb->sb,
 								 delete_blk),
 					clusters_to_del, meta_ac,
-					&tc->tc_dealloc);
+					&tc->tc_dealloc, 1);
 		else
 			status = ocfs2_truncate_log_append(osb, handle,
 							   delete_blk,
diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index 5adcd6a..a3aeaea 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -2074,7 +2074,8 @@ static int __ocfs2_decrease_refcount(handle_t *handle,
 				     struct buffer_head *ref_root_bh,
 				     u64 cpos, u32 len,
 				     struct ocfs2_alloc_context *meta_ac,
-				     struct ocfs2_cached_dealloc_ctxt *dealloc)
+				     struct ocfs2_cached_dealloc_ctxt *dealloc,
+				     int delete)
 {
 	int ret = 0, index = 0;
 	struct ocfs2_refcount_rec rec;
@@ -2082,9 +2083,10 @@ static int __ocfs2_decrease_refcount(handle_t *handle,
 	struct super_block *sb = ocfs2_metadata_cache_get_super(ci);
 	struct buffer_head *ref_leaf_bh = NULL;
 
-	mlog(0, "Tree owner %llu, decrease refcount start %llu, len %u\n",
+	mlog(0, "Tree owner %llu, decrease refcount start %llu, "
+	     "len %u, delete %u\n",
 	     (unsigned long long)ocfs2_metadata_cache_owner(ci),
-	     (unsigned long long)cpos, len);
+	     (unsigned long long)cpos, len, delete);
 
 	while (len) {
 		ret = ocfs2_get_refcount_rec(ci, ref_root_bh,
@@ -2097,6 +2099,8 @@ static int __ocfs2_decrease_refcount(handle_t *handle,
 
 		r_count = le32_to_cpu(rec.r_refcount);
 		BUG_ON(r_count == 0);
+		if (!delete)
+			BUG_ON(r_count > 1);
 
 		r_len = min((u64)(cpos + len), le64_to_cpu(rec.r_cpos) +
 			      le32_to_cpu(rec.r_clusters)) - cpos;
@@ -2110,7 +2114,7 @@ static int __ocfs2_decrease_refcount(handle_t *handle,
 			goto out;
 		}
 
-		if (le32_to_cpu(rec.r_refcount) == 1) {
+		if (le32_to_cpu(rec.r_refcount) == 1 && delete) {
 			ret = ocfs2_cache_cluster_dealloc(dealloc,
 					  ocfs2_clusters_to_blocks(sb, cpos),
 							  r_len);
@@ -2135,7 +2139,8 @@ out:
 int ocfs2_decrease_refcount(struct inode *inode,
 			    handle_t *handle, u32 cpos, u32 len,
 			    struct ocfs2_alloc_context *meta_ac,
-			    struct ocfs2_cached_dealloc_ctxt *dealloc)
+			    struct ocfs2_cached_dealloc_ctxt *dealloc,
+			    int delete)
 {
 	int ret;
 	u64 ref_blkno;
@@ -2165,7 +2170,7 @@ int ocfs2_decrease_refcount(struct inode *inode,
 	}
 
 	ret = __ocfs2_decrease_refcount(handle, &tree->rf_ci, ref_root_bh,
-					cpos, len, meta_ac, dealloc);
+					cpos, len, meta_ac, dealloc, delete);
 	if (ret)
 		mlog_errno(ret);
 out:
@@ -2883,10 +2888,16 @@ static int ocfs2_make_clusters_writable(struct super_block *sb,
 					u32 cpos, u32 p_cluster,
 					u32 num_clusters, unsigned int e_flags)
 {
-	int ret, credits =  0;
+	int ret, delete, index, credits =  0;
 	u32 new_bit, new_len;
+	unsigned int set_len;
 	struct ocfs2_super *osb = OCFS2_SB(sb);
 	handle_t *handle;
+	struct buffer_head *ref_leaf_bh = NULL;
+	struct ocfs2_refcount_rec rec;
+
+	mlog(0, "cpos %u, p_cluster %u, num_clusters %u, e_flags %u\n",
+	     cpos, p_cluster, num_clusters, e_flags);
 
 	ret = ocfs2_lock_refcount_allocators(sb, p_cluster, num_clusters,
 					     &context->di_et,
@@ -2907,35 +2918,75 @@ static int ocfs2_make_clusters_writable(struct super_block *sb,
 	}
 
 	while (num_clusters) {
-		ret = __ocfs2_claim_clusters(osb, handle, context->data_ac,
-					     1, num_clusters,
-					     &new_bit, &new_len);
+		ret = ocfs2_get_refcount_rec(context->ref_ci,
+					     context->ref_root_bh,
+					     p_cluster, num_clusters,
+					     &rec, &index, &ref_leaf_bh);
 		if (ret) {
 			mlog_errno(ret);
 			goto out_commit;
 		}
 
-		ret = ocfs2_replace_clusters(handle, context,
-					     cpos, p_cluster, new_bit,
-					     new_len, e_flags);
+		BUG_ON(!rec.r_refcount);
+		set_len = min((u64)p_cluster + num_clusters,
+			      le64_to_cpu(rec.r_cpos) +
+			      le32_to_cpu(rec.r_clusters)) - p_cluster;
+
+		/*
+		 * There are many different situation here.
+		 * 1. If refcount == 1, remove the flag and don't COW.
+		 * 2. If refcount > 1, allocate clusters.
+		 *    Here we may not allocate r_len once at a time, so continue
+		 *    until we reach num_clusters.
+		 */
+		if (le32_to_cpu(rec.r_refcount) == 1) {
+			delete = 0;
+			ret = ocfs2_clear_ext_refcount(handle, &context->di_et,
+						       cpos, p_cluster,
+						       set_len, e_flags,
+						       context->meta_ac,
+						       &context->dealloc);
+			if (ret) {
+				mlog_errno(ret);
+				goto out_commit;
+			}
+		} else {
+			delete = 1;
+
+			ret = __ocfs2_claim_clusters(osb, handle,
+						     context->data_ac,
+						     1, set_len,
+						     &new_bit, &new_len);
+			if (ret) {
+				mlog_errno(ret);
+				goto out_commit;
+			}
+
+			ret = ocfs2_replace_clusters(handle, context,
+						     cpos, p_cluster, new_bit,
+						     new_len, e_flags);
+			if (ret) {
+				mlog_errno(ret);
+				goto out_commit;
+			}
+			set_len = new_len;
+		}
+
+		ret = __ocfs2_decrease_refcount(handle, context->ref_ci,
+						context->ref_root_bh,
+						p_cluster, set_len,
+						context->meta_ac,
+						&context->dealloc, delete);
 		if (ret) {
 			mlog_errno(ret);
 			goto out_commit;
 		}
 
-		cpos += new_len;
-		p_cluster += new_len;
-		num_clusters -= new_len;
-	}
-
-	ret = __ocfs2_decrease_refcount(handle, context->ref_ci,
-					context->ref_root_bh,
-					p_cluster, num_clusters,
-					context->meta_ac,
-					&context->dealloc);
-	if (ret) {
-		mlog_errno(ret);
-		goto out_commit;
+		cpos += set_len;
+		p_cluster += set_len;
+		num_clusters -= set_len;
+		brelse(ref_leaf_bh);
+		ref_leaf_bh = NULL;
 	}
 
 	/*
@@ -2958,6 +3009,7 @@ out:
 		ocfs2_free_alloc_context(context->meta_ac);
 		context->meta_ac = NULL;
 	}
+	brelse(ref_leaf_bh);
 
 	return ret;
 }
diff --git a/fs/ocfs2/refcounttree.h b/fs/ocfs2/refcounttree.h
index 949ff45..bc40af1 100644
--- a/fs/ocfs2/refcounttree.h
+++ b/fs/ocfs2/refcounttree.h
@@ -44,7 +44,8 @@ void ocfs2_unlock_refcount_tree(struct ocfs2_super *osb,
 int ocfs2_decrease_refcount(struct inode *inode,
 			    handle_t *handle, u32 cpos, u32 len,
 			    struct ocfs2_alloc_context *meta_ac,
-			    struct ocfs2_cached_dealloc_ctxt *dealloc);
+			    struct ocfs2_cached_dealloc_ctxt *dealloc,
+			    int delete);
 int ocfs2_prepare_refcount_change_for_del(struct inode *inode,
 					  struct buffer_head *di_bh,
 					  u64 phys_blkno,
-- 
1.6.2.rc2.16.gf474c
