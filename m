From: Tao Ma <tao.ma@oracle.com>
Date: Fri, 27 Mar 2009 07:02:24 +0800
Subject: [Ocfs2-devel] [PATCH 18/42] ocfs2: CoW refcount tree improvement.
In-Reply-To: <49CC86FC.2070906@oracle.com>
References: <49CC86FC.2070906@oracle.com>
Message-ID: <1238108568-23740-18-git-send-email-tao.ma@oracle.com>
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
 fs/ocfs2/refcounttree.c |  118 +++++++++++++++++++++++++++++++++++------------
 fs/ocfs2/refcounttree.h |    3 +-
 3 files changed, 92 insertions(+), 31 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 57f3ee3..8424170 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -6892,7 +6892,7 @@ static int ocfs2_do_truncate(struct ocfs2_super *osb,
 					ocfs2_blocks_to_clusters(osb->sb,
 								 delete_blk),
 					clusters_to_del, meta_ac,
-					&tc->tc_dealloc);
+					&tc->tc_dealloc, 1);
 		else
 			status = ocfs2_truncate_log_append(osb, handle,
 							   delete_blk,
diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index cd33e11..b41bc39 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -583,7 +583,8 @@ static int __ocfs2_decrease_refcount(handle_t *handle,
 				     struct ocfs2_extent_tree *et,
 				     u32 cpos, u32 len,
 				     struct ocfs2_alloc_context *meta_ac,
-				     struct ocfs2_cached_dealloc_ctxt *dealloc)
+				     struct ocfs2_cached_dealloc_ctxt *dealloc,
+				     int delete)
 {
 	int ret = 0, index = 0;
 	struct ocfs2_extent_rec rec;
@@ -598,9 +599,10 @@ static int __ocfs2_decrease_refcount(handle_t *handle,
 		goto out;
 	}
 
-	mlog(0, "Tree owner %llu, decrease refcount start %u, len %u\n",
+	mlog(0, "Tree owner %llu, decrease refcount start %u, "
+	     "len %u, delete %u\n",
 	     (unsigned long long)ocfs2_metadata_cache_owner(et->et_ci),
-	     cpos, len);
+	     cpos, len, delete);
 
 	while (len) {
 		ret = ocfs2_get_refcount_rec(et->et_ci, path, cpos, len,
@@ -612,6 +614,8 @@ static int __ocfs2_decrease_refcount(handle_t *handle,
 
 		r_count = le32_to_cpu(rec.e_refcount);
 		BUG_ON(r_count == 0);
+		if (!delete)
+			BUG_ON(r_count > 1);
 
 		r_len = min((u32)(cpos + len), le32_to_cpu(rec.e_cpos) +
 			      le16_to_cpu(rec.e_leaf_clusters)) - cpos;
@@ -631,12 +635,14 @@ static int __ocfs2_decrease_refcount(handle_t *handle,
 				goto out;
 			}
 
-			ret = ocfs2_cache_cluster_dealloc(dealloc,
+			if (delete) {
+				ret = ocfs2_cache_cluster_dealloc(dealloc,
 					  ocfs2_clusters_to_blocks(sb, cpos),
-							  r_len);
-			if (ret) {
-				mlog_errno(ret);
-				goto out;
+								  r_len);
+				if (ret) {
+					mlog_errno(ret);
+					goto out;
+				}
 			}
 		} else {
 			rec.e_cpos = cpu_to_le32(cpos);
@@ -665,7 +671,8 @@ out:
 int ocfs2_decrease_refcount(struct inode *inode, struct buffer_head *di_bh,
 			    handle_t *handle, u32 cpos, u32 len,
 			    struct ocfs2_alloc_context *meta_ac,
-			    struct ocfs2_cached_dealloc_ctxt *dealloc)
+			    struct ocfs2_cached_dealloc_ctxt *dealloc,
+			    int delete)
 {
 	int ret;
 	struct ocfs2_inode_info *oi = OCFS2_I(inode);
@@ -686,7 +693,7 @@ int ocfs2_decrease_refcount(struct inode *inode, struct buffer_head *di_bh,
 
 	ocfs2_init_refcount_extent_tree(&et, INODE_CACHE(inode), ref_bh);
 	ret = __ocfs2_decrease_refcount(handle, &et,
-					cpos, len, meta_ac, dealloc);
+					cpos, len, meta_ac, dealloc, delete);
 	if (ret)
 		mlog_errno(ret);
 out:
@@ -1281,33 +1288,95 @@ static int ocfs2_make_clusters_writable(handle_t *handle,
 					u32 cpos, u32 p_cluster,
 					u32 num_clusters, unsigned int e_flags)
 {
-	int ret;
-	u32 new_bit, new_len;
+	int ret, delete, index;
+	u32 new_bit, new_len, r_end;
+	unsigned int set_len;
 	struct ocfs2_caching_info *inode_ci = context->di_et.et_ci;
 	struct ocfs2_super *osb =
 			OCFS2_SB(ocfs2_metadata_cache_get_super(inode_ci));
+	struct ocfs2_path *path;
+	struct ocfs2_extent_rec rec;
+
+	mlog(0, "cpos %u, p_cluster %u, num_clusters %u, e_flags %u\n",
+	     cpos, p_cluster, num_clusters, e_flags);
+
+	path = ocfs2_new_path_from_et(&context->ref_et);
+	if (!path) {
+		ret = -ENOMEM;
+		mlog_errno(ret);
+		return ret;
+	}
 
 	while (num_clusters) {
-		ret = __ocfs2_claim_clusters(osb, handle, context->data_ac,
-					     1, num_clusters,
-					     &new_bit, &new_len);
+		ret = ocfs2_get_refcount_rec(context->ref_et.et_ci,
+					     path, p_cluster,
+					     num_clusters, &rec, &index);
 		if (ret) {
 			mlog_errno(ret);
 			break;
 		}
 
-		ret = ocfs2_replace_clusters(handle, context,
-					     cpos, p_cluster, new_bit,
-					     new_len, e_flags);
+		BUG_ON(!rec.e_refcount);
+		r_end = le32_to_cpu(rec.e_cpos) +
+				le16_to_cpu(rec.e_leaf_clusters);
+		set_len = min(p_cluster + num_clusters, r_end) - p_cluster;
+
+		/*
+		 * There are many different situation here.
+		 * 1. If refcount == 1, remove the flag and do COW no delete.
+		 * 2. If refcount > 1, allocate clusters.
+		 *    Here we may not allocate r_len once at a time, so continue
+		 *    until we reach num_clusters.
+		 */
+		if (le32_to_cpu(rec.e_refcount) == 1) {
+			delete = 0;
+			ret = ocfs2_clear_ext_refcount(handle, &context->di_et,
+						       cpos, p_cluster,
+						       set_len, e_flags,
+						       context->meta_ac,
+						       &context->dealloc);
+			if (ret) {
+				mlog_errno(ret);
+				break;
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
+				break;
+			}
+
+			ret = ocfs2_replace_clusters(handle, context,
+						     cpos, p_cluster, new_bit,
+						     new_len, e_flags);
+			if (ret) {
+				mlog_errno(ret);
+				break;
+			}
+			set_len = new_len;
+		}
+
+		ret = __ocfs2_decrease_refcount(handle, &context->ref_et,
+						p_cluster, set_len,
+						context->meta_ac,
+						&context->dealloc, delete);
 		if (ret) {
 			mlog_errno(ret);
 			break;
 		}
 
-		cpos += new_len;
-		num_clusters -= new_len;
+		p_cluster += set_len;
+		cpos += set_len;
+		num_clusters -= set_len;
+		ocfs2_reinit_path(path, 1);
 	}
 
+	ocfs2_free_path(path);
 	return ret;
 }
 
@@ -1392,15 +1461,6 @@ static int ocfs2_replace_cow(struct inode *inode,
 			break;
 		}
 
-		ret = __ocfs2_decrease_refcount(handle, &context.ref_et,
-						p_cluster, num_clusters,
-						context.meta_ac,
-						&context.dealloc);
-		if (ret) {
-			mlog_errno(ret);
-			break;
-		}
-
 		cow_len -= num_clusters;
 		cow_start += num_clusters;
 	}
diff --git a/fs/ocfs2/refcounttree.h b/fs/ocfs2/refcounttree.h
index 8dee13b..e8f4869 100644
--- a/fs/ocfs2/refcounttree.h
+++ b/fs/ocfs2/refcounttree.h
@@ -26,7 +26,8 @@ int ocfs2_remove_refcount_tree(struct inode *inode, struct buffer_head *di_bh);
 int ocfs2_decrease_refcount(struct inode *inode, struct buffer_head *di_bh,
 			    handle_t *handle, u32 cpos, u32 len,
 			    struct ocfs2_alloc_context *meta_ac,
-			    struct ocfs2_cached_dealloc_ctxt *dealloc);
+			    struct ocfs2_cached_dealloc_ctxt *dealloc,
+			    int delete);
 int ocfs2_prepare_refcount_change_for_del(struct inode *inode,
 					  struct buffer_head *di_bh,
 					  u32 clusters, int *credits,
-- 
1.6.2.rc2.16.gf474c
