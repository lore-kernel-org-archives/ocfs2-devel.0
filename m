From: Mark Fasheh <mfasheh@suse.com>
Date: Thu, 25 Dec 2008 10:04:45 -0800
Subject: [Ocfs2-devel] [PATCH 30/35] ocfs2/xattr: Remove extend_trans call
	and add its credits from the beginning
In-Reply-To: <1230228290-22803-1-git-send-email-mfasheh@suse.com>
References: <1230228290-22803-1-git-send-email-mfasheh@suse.com>
Message-ID: <1230228290-22803-31-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>, Tao Ma <tao.ma@oracle.com>, Mark Fasheh <mfasheh@suse.com>

From: Tao Ma <tao.ma@oracle.com>

Actually, when setting a new xattr value, we know it from the very
beginning, and it isn't like the extension of bucket in which case
we can't figure it out. So remove ocfs2_extend_trans in that function
and calculate it before the transaction. It also relieve acl operation
from the worry about the side effect of ocfs2_extend_trans.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/xattr.c |   23 ++++++++++-------------
 1 files changed, 10 insertions(+), 13 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 17028aa..93a1ab4 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -1169,7 +1169,7 @@ static int __ocfs2_xattr_set_value_outside(struct inode *inode,
 					   const void *value,
 					   int value_len)
 {
-	int ret = 0, i, cp_len, credits;
+	int ret = 0, i, cp_len;
 	u16 blocksize = inode->i_sb->s_blocksize;
 	u32 p_cluster, num_clusters;
 	u32 cpos = 0, bpc = ocfs2_clusters_to_blocks(inode->i_sb, 1);
@@ -1179,18 +1179,6 @@ static int __ocfs2_xattr_set_value_outside(struct inode *inode,
 
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
@@ -2233,6 +2221,15 @@ static int ocfs2_calc_xattr_set_need(struct inode *inode,
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
1.5.6
