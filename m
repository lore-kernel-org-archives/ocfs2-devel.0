From: Tao Ma <tao.ma@oracle.com>
Date: Fri,  3 Apr 2009 07:45:53 +0800
Subject: [Ocfs2-devel] [PATCH 14/42] ocfs2: Add support of decrementing
	refcount for delete.
In-Reply-To: <49D5CAC2.4010201@oracle.com>
References: <49D5CAC2.4010201@oracle.com>
Message-ID: <1238715981-21488-14-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

    Given a physical cpos and length, decrement the refcount
in the tree. If the refcount for any portion of the extent goes
to zero, that portion is queued for freeing.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/refcounttree.c |  115 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/ocfs2/refcounttree.h |    4 ++
 2 files changed, 119 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index 3b6f327..6b42ce8 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -563,3 +563,118 @@ out:
 	ocfs2_free_path(path);
 	return ret;
 }
+
+static int __ocfs2_decrease_refcount(handle_t *handle,
+				     struct ocfs2_extent_tree *et,
+				     u32 cpos, u32 len,
+				     struct ocfs2_alloc_context *meta_ac,
+				     struct ocfs2_cached_dealloc_ctxt *dealloc)
+{
+	int ret = 0, index = 0;
+	struct ocfs2_extent_rec rec;
+	unsigned int r_count = 0, r_len;
+	struct ocfs2_path *path = NULL;
+	struct super_block *sb = ocfs2_metadata_cache_get_super(et->et_ci);
+
+	path = ocfs2_new_path_from_et(et);
+	if (!path) {
+		ret = -ENOMEM;
+		mlog_errno(ret);
+		goto out;
+	}
+
+	mlog(0, "Tree owner %llu, decrease refcount start %u, len %u\n",
+	     (unsigned long long)ocfs2_metadata_cache_owner(et->et_ci),
+	     cpos, len);
+
+	while (len) {
+		ret = ocfs2_get_refcount_rec(et->et_ci, path, cpos, len,
+					     &rec, &index);
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
+
+		r_count = le32_to_cpu(rec.e_refcount);
+		BUG_ON(r_count == 0);
+
+		r_len = min((u32)(cpos + len), le32_to_cpu(rec.e_cpos) +
+			      le16_to_cpu(rec.e_leaf_clusters)) - cpos;
+
+		/*
+		 * Now decrease the refcount:
+		 *
+		 * 1. r_count == 1, remove it from refcount tree and queue
+		 *    clusters for free.
+		 * 2. r_count > 2, split the record.
+		 */
+		if (le32_to_cpu(rec.e_refcount) == 1) {
+			ret = ocfs2_remove_extent(handle, et, cpos, r_len,
+						  meta_ac, dealloc);
+			if (ret) {
+				mlog_errno(ret);
+				goto out;
+			}
+
+			ret = ocfs2_cache_cluster_dealloc(dealloc,
+					  ocfs2_clusters_to_blocks(sb, cpos),
+							  r_len);
+			if (ret) {
+				mlog_errno(ret);
+				goto out;
+			}
+		} else {
+			rec.e_cpos = cpu_to_le32(cpos);
+			rec.e_leaf_clusters = cpu_to_le16(r_len);
+
+			le32_add_cpu(&rec.e_refcount, -1);
+
+			ret = ocfs2_split_extent(handle, et, path, index,
+						 &rec, meta_ac, dealloc);
+			if (ret) {
+				mlog_errno(ret);
+				goto out;
+			}
+		}
+
+		cpos += r_len;
+		len -= r_len;
+		ocfs2_reinit_path(path, 1);
+	}
+
+out:
+	ocfs2_free_path(path);
+	return ret;
+}
+
+int ocfs2_decrease_refcount(struct inode *inode, struct buffer_head *di_bh,
+			    handle_t *handle, u32 cpos, u32 len,
+			    struct ocfs2_alloc_context *meta_ac,
+			    struct ocfs2_cached_dealloc_ctxt *dealloc)
+{
+	int ret;
+	struct ocfs2_inode_info *oi = OCFS2_I(inode);
+	struct buffer_head *ref_bh = NULL;
+	struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
+	struct ocfs2_extent_tree et;
+
+	BUG_ON(!(oi->ip_dyn_features & OCFS2_HAS_REFCOUNT_FL));
+	BUG_ON(!di->i_refcount_loc);
+
+	ret = ocfs2_read_refcount_block(INODE_CACHE(inode),
+					le64_to_cpu(di->i_refcount_loc),
+					&ref_bh);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	ocfs2_init_refcount_extent_tree(&et, INODE_CACHE(inode), ref_bh);
+	ret = __ocfs2_decrease_refcount(handle, &et,
+					cpos, len, meta_ac, dealloc);
+	if (ret)
+		mlog_errno(ret);
+out:
+	brelse(ref_bh);
+	return ret;
+}
diff --git a/fs/ocfs2/refcounttree.h b/fs/ocfs2/refcounttree.h
index 9f4bdac..92fe116 100644
--- a/fs/ocfs2/refcounttree.h
+++ b/fs/ocfs2/refcounttree.h
@@ -23,4 +23,8 @@ int ocfs2_set_refcount_tree(struct inode *inode,
 			    u64 blkno);
 int ocfs2_remove_refcount_tree(struct inode *inode, struct buffer_head *di_bh);
 
+int ocfs2_decrease_refcount(struct inode *inode, struct buffer_head *di_bh,
+			    handle_t *handle, u32 cpos, u32 len,
+			    struct ocfs2_alloc_context *meta_ac,
+			    struct ocfs2_cached_dealloc_ctxt *dealloc);
 #endif /* OCFS2_REFCOUNTTREE_H */
-- 
1.6.2.rc2.16.gf474c
