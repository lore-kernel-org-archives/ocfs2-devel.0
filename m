From: Tao Ma <tao.ma@oracle.com>
Date: Mon, 18 Aug 2008 17:38:54 +0800
Subject: [Ocfs2-devel] [PATCH 15/16] Delete all xattr buckets in inode
	removal.
In-Reply-To: <48A929A4.90103@oracle.com>
References: <48A929A4.90103@oracle.com>
Message-ID: <1219052334-10415-13-git-send-email-tao.ma@oracle.com>
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
 fs/ocfs2/xattr.c |   84 +++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 80 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 1de17c8..6e84b36 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -147,6 +147,9 @@ static int ocfs2_xattr_set_entry_index_block(struct inode *inode,
 					     struct ocfs2_xattr_info *xi,
 					     struct ocfs2_xattr_search *xs);
 
+static int ocfs2_delete_xattr_index_block(struct inode *inode,
+					  struct buffer_head *xb_bh);
+
 static inline struct xattr_handler *ocfs2_xattr_handler(int name_index)
 {
 	struct xattr_handler *handler = NULL;
@@ -1527,13 +1530,14 @@ static int ocfs2_xattr_block_remove(struct inode *inode,
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
@@ -4754,3 +4758,75 @@ out:
 	mlog_exit(ret);
 	return ret;
 }
+
+static int ocfs2_delete_xattr_in_bucket(struct inode *inode,
+					struct ocfs2_xattr_bucket *bucket,
+					void *para)
+{
+	int ret = 0;
+	struct ocfs2_xattr_header *xh = bucket->xh;
+	u16 i;
+	struct ocfs2_xattr_entry *xe;
+
+	for (i = 0; i < le16_to_cpu(xh->xh_count); i++) {
+		xe = &xh->xh_entries[i];
+		if (ocfs2_xattr_is_local(xe))
+			continue;
+
+		ret = ocfs2_xattr_bucket_value_truncate(inode,
+							bucket->bhs[0],
+							i, 0);
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
1.5.4.1
