From: Tao Ma <tao.ma@oracle.com>
Date: Fri,  3 Apr 2009 07:46:12 +0800
Subject: [Ocfs2-devel] [PATCH 33/42] ocfs2: Remove inode from
	ocfs2_xattr_bucket_get_name_value.
In-Reply-To: <49D5CAC2.4010201@oracle.com>
References: <49D5CAC2.4010201@oracle.com>
Message-ID: <1238715981-21488-33-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In ocfs2_xattr_bucket_get_name_value, actually we only use
super_block. So use it.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/xattr.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 15d89a7..386fa3a 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -139,7 +139,7 @@ struct ocfs2_xattr_search {
 	int not_found;
 };
 
-static int ocfs2_xattr_bucket_get_name_value(struct inode *inode,
+static int ocfs2_xattr_bucket_get_name_value(struct super_block *sb,
 					     struct ocfs2_xattr_header *xh,
 					     int index,
 					     int *block_off,
@@ -1095,7 +1095,7 @@ static int ocfs2_xattr_block_get(struct inode *inode,
 		i = xs->here - xs->header->xh_entries;
 
 		if (le16_to_cpu(xb->xb_flags) & OCFS2_XATTR_INDEXED) {
-			ret = ocfs2_xattr_bucket_get_name_value(inode,
+			ret = ocfs2_xattr_bucket_get_name_value(inode->i_sb,
 								bucket_xh(xs->bucket),
 								i,
 								&block_off,
@@ -2291,7 +2291,7 @@ static int ocfs2_calc_xattr_set_need(struct inode *inode,
 		old_in_xb = 1;
 
 		if (le16_to_cpu(xb->xb_flags) & OCFS2_XATTR_INDEXED) {
-			ret = ocfs2_xattr_bucket_get_name_value(inode,
+			ret = ocfs2_xattr_bucket_get_name_value(inode->i_sb,
 							bucket_xh(xbs->bucket),
 							i, &block_off,
 							&name_offset);
@@ -2966,7 +2966,7 @@ static int ocfs2_find_xe_in_bucket(struct inode *inode,
 		if (cmp)
 			continue;
 
-		ret = ocfs2_xattr_bucket_get_name_value(inode,
+		ret = ocfs2_xattr_bucket_get_name_value(inode->i_sb,
 							xh,
 							i,
 							&block_off,
@@ -3210,7 +3210,7 @@ struct ocfs2_xattr_tree_list {
 	size_t result;
 };
 
-static int ocfs2_xattr_bucket_get_name_value(struct inode *inode,
+static int ocfs2_xattr_bucket_get_name_value(struct super_block *sb,
 					     struct ocfs2_xattr_header *xh,
 					     int index,
 					     int *block_off,
@@ -3223,8 +3223,8 @@ static int ocfs2_xattr_bucket_get_name_value(struct inode *inode,
 
 	name_offset = le16_to_cpu(xh->xh_entries[index].xe_name_offset);
 
-	*block_off = name_offset >> inode->i_sb->s_blocksize_bits;
-	*new_offset = name_offset % inode->i_sb->s_blocksize;
+	*block_off = name_offset >> sb->s_blocksize_bits;
+	*new_offset = name_offset % sb->s_blocksize;
 
 	return 0;
 }
@@ -3244,7 +3244,7 @@ static int ocfs2_list_xattr_bucket(struct inode *inode,
 		prefix = ocfs2_xattr_prefix(type);
 
 		if (prefix) {
-			ret = ocfs2_xattr_bucket_get_name_value(inode,
+			ret = ocfs2_xattr_bucket_get_name_value(inode->i_sb,
 								bucket_xh(bucket),
 								i,
 								&block_off,
@@ -4843,7 +4843,7 @@ static int ocfs2_xattr_bucket_set_value_outside(struct inode *inode,
 
 	BUG_ON(!xs->base || !xe || ocfs2_xattr_is_local(xe));
 
-	ret = ocfs2_xattr_bucket_get_name_value(inode, xh,
+	ret = ocfs2_xattr_bucket_get_name_value(inode->i_sb, xh,
 						xe - xh->xh_entries,
 						&block_off,
 						&offset);
@@ -5459,7 +5459,7 @@ static int ocfs2_prepare_refcount_xattr(struct inode *inode,
 		i = xbs->here - xbs->header->xh_entries;
 
 		if (le16_to_cpu(xb->xb_flags) & OCFS2_XATTR_INDEXED) {
-			ret = ocfs2_xattr_bucket_get_name_value(inode,
+			ret = ocfs2_xattr_bucket_get_name_value(inode->i_sb,
 							bucket_xh(xbs->bucket),
 							i, &block_off,
 							&name_offset);
-- 
1.6.2.rc2.16.gf474c
