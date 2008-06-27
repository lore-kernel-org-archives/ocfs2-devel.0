From: Tao Ma <tao.ma@oracle.com>
Date: Fri, 27 Jun 2008 15:03:09 +0800
Subject: [Ocfs2-devel] [PATCH 14/15] Delete all xattr buckets in inode
	removal.v2
In-Reply-To: <48648B3E.6050808@oracle.com>
Message-ID: <20080627070309.GA20389@tma-pc2.cn.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In inode removal, we need to iterate all the buckets, remove all
the outside value storage for individual xattr and delete the xattr
buckets.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/xattr.c |   86 +++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 82 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 89c8c16..4d1a895 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -140,6 +140,9 @@ static int ocfs2_xattr_set_entry_index_block(struct inode *inode,
 					     struct ocfs2_xattr_info *xi,
 					     struct ocfs2_xattr_search *xs);
 
+static int ocfs2_delete_xattr_index_block(struct inode *inode,
+					  struct buffer_head *xb_bh);
+
 static inline struct xattr_handler *ocfs2_xattr_handler(int name_index)
 {
 	struct xattr_handler *handler = NULL;
@@ -1456,13 +1459,14 @@ static int ocfs2_xattr_block_remove(struct inode *inode,
 				    struct buffer_head *blk_bh)
 {
 	struct ocfs2_xattr_block *xb;
-	struct ocfs2_xattr_header *header;
 	int ret = 0;
 
 	xb = (struct ocfs2_xattr_block *)blk_bh->b_data;
-	header = &(xb->xb_attrs.xb_header);
-
-	ret = ocfs2_remove_value_outside(inode, blk_bh, header);
+	if (!(le16_to_cpu(xb->xb_flags) & OCFS2_XATTR_INDEXED)) {
+		struct ocfs2_xattr_header *header = &(xb->xb_attrs.xb_header);
+		ret = ocfs2_remove_value_outside(inode, blk_bh, header);
+	} else
+		ret = ocfs2_delete_xattr_index_block(inode, blk_bh);
 
 	return ret;
 }
@@ -4802,3 +4806,77 @@ out:
 	mlog_exit(ret);
 	return ret;
 }
+
+static int ocfs2_delete_xattr_in_bucket(struct inode *inode,
+					struct buffer_head *header_bh,
+					struct ocfs2_xattr_header *xh,
+					void *para)
+{
+	int ret = 0;
+	u16 i, count = le16_to_cpu(xh->xh_count);
+	struct ocfs2_xattr_entry *xe;
+
+	for (i = 0; i < count; i++) {
+		xe = &xh->xh_entries[i];
+		if (xe->xe_local)
+			continue;
+
+		ret = ocfs2_xattr_bucket_value_truncate(inode,
+							header_bh,
+							i, 0,
+							NULL,
+							NULL);
+		if (ret) {
+			mlog_errno(ret);
+			break;
+		}
+	}
+
+	return ret;
+}
+
+static int ocfs2_delete_xattr_index_block(struct inode *inode,
+					  struct buffer_head *xb_bh)
+{
+	struct ocfs2_xattr_block *xb =
+			(struct ocfs2_xattr_block *)xb_bh->b_data;
+	struct ocfs2_extent_list *el = &xb->xb_attrs.xb_root.xt_list;
+	int ret = 0;
+	u32 name_hash = UINT_MAX, e_cpos, num_clusters;
+	u64 p_blkno;
+
+	if (le16_to_cpu(el->l_next_free_rec) == 0)
+		return 0;
+
+	while (name_hash > 0) {
+		ret = ocfs2_xattr_get_rec(inode, name_hash, &p_blkno,
+					  &e_cpos, &num_clusters, el);
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
+
+		ret = ocfs2_iterate_xattr_buckets(inode, p_blkno, num_clusters,
+						  ocfs2_delete_xattr_in_bucket,
+						  NULL);
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
+
+		ret = ocfs2_rm_xattr_cluster(inode, xb_bh,
+					     p_blkno, e_cpos, num_clusters);
+		if (ret) {
+			mlog_errno(ret);
+			break;
+		}
+
+		if (e_cpos == 0)
+			break;
+
+		name_hash = e_cpos - 1;
+	}
+
+out:
+	return ret;
+}
-- 
1.5.4.GIT
