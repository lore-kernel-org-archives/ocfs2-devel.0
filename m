From: Tao Ma <tao.ma@oracle.com>
Date: Fri,  5 Dec 2008 06:20:54 +0800
Subject: [Ocfs2-devel] [PATCH 1/3] ocfs2/xattr: Remove one extend_trans and
	add its credit in the beginning.
In-Reply-To: <4938C737.9060504@oracle.com>
References: <4938C737.9060504@oracle.com>
Message-ID: <1228429256-9308-1-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Actually, when setting a new xattr value, we know it from the very
beginning, and it isn't like the extension of bucket in which case
we can't figure it out. So remove ocfs2_extend_trans in that function
and calculate it before the transaction. It also relieve acl operation
from the worry about the side effect of ocfs2_extend_trans.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/xattr.c |   23 ++++++++++-------------
 1 files changed, 10 insertions(+), 13 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 7e0d62a..8fb8457 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -1138,7 +1138,7 @@ static int __ocfs2_xattr_set_value_outside(struct inode *inode,
 					   const void *value,
 					   int value_len)
 {
-	int ret = 0, i, cp_len, credits;
+	int ret = 0, i, cp_len;
 	u16 blocksize = inode->i_sb->s_blocksize;
 	u32 p_cluster, num_clusters;
 	u32 cpos = 0, bpc = ocfs2_clusters_to_blocks(inode->i_sb, 1);
@@ -1148,18 +1148,6 @@ static int __ocfs2_xattr_set_value_outside(struct inode *inode,
 
 	BUG_ON(clusters > le32_to_cpu(xv->xr_clusters));
 
-	/*
-	 * In __ocfs2_xattr_set_value_outside has already been dirtied,
-	 * so we don't need to worry about whether ocfs2_extend_trans
-	 * will create a new transactio for us or not.
-	 */
-	credits = clusters * bpc;
-	ret = ocfs2_extend_trans(handle, credits);
-	if (ret) {
-		mlog_errno(ret);
-		goto out;
-	}
-
 	while (cpos < clusters) {
 		ret = ocfs2_xattr_get_clusters(inode, cpos, &p_cluster,
 					       &num_clusters, &xv->xr_list);
@@ -2184,6 +2172,15 @@ static int ocfs2_calc_xattr_set_need(struct inode *inode,
 						    xi->value_len);
 	u64 value_size;
 
+	/*
+	 * Calculate the clusters we need to write.
+	 * No matter whether we replace an old one or add a new one,
+	 * we need this for writing.
+	 */
+	if (xi->value_len > OCFS2_XATTR_INLINE_SIZE)
+		credits += new_clusters *
+			   ocfs2_clusters_to_blocks(inode->i_sb, 1);
+
 	if (xis->not_found && xbs->not_found) {
 		credits += ocfs2_blocks_per_xattr_bucket(inode->i_sb);
 
-- 
1.5.4.GIT
