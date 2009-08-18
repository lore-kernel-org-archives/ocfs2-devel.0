From: Tao Ma <tao.ma@oracle.com>
Date: Tue, 18 Aug 2009 14:19:27 +0800
Subject: [Ocfs2-devel] [PATCH 26/41] ocfs2: Remove inode from
	ocfs2_xattr_bucket_get_name_value.
In-Reply-To: <4A8A47DF.8020707@oracle.com>
References: <4A8A47DF.8020707@oracle.com>
Message-ID: <1250576382-27080-26-git-send-email-tao.ma@oracle.com>
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
index a538ceb..eeb5b7c 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -140,7 +140,7 @@ struct ocfs2_xattr_search {
 	int not_found;
 };
 
-static int ocfs2_xattr_bucket_get_name_value(struct inode *inode,
+static int ocfs2_xattr_bucket_get_name_value(struct super_block *sb,
 					     struct ocfs2_xattr_header *xh,
 					     int index,
 					     int *block_off,
@@ -1101,7 +1101,7 @@ static int ocfs2_xattr_block_get(struct inode *inode,
 		i = xs->here - xs->header->xh_entries;
 
 		if (le16_to_cpu(xb->xb_flags) & OCFS2_XATTR_INDEXED) {
-			ret = ocfs2_xattr_bucket_get_name_value(inode,
+			ret = ocfs2_xattr_bucket_get_name_value(inode->i_sb,
 								bucket_xh(xs->bucket),
 								i,
 								&block_off,
@@ -2297,7 +2297,7 @@ static int ocfs2_calc_xattr_set_need(struct inode *inode,
 		old_in_xb = 1;
 
 		if (le16_to_cpu(xb->xb_flags) & OCFS2_XATTR_INDEXED) {
-			ret = ocfs2_xattr_bucket_get_name_value(inode,
+			ret = ocfs2_xattr_bucket_get_name_value(inode->i_sb,
 							bucket_xh(xbs->bucket),
 							i, &block_off,
 							&name_offset);
@@ -2972,7 +2972,7 @@ static int ocfs2_find_xe_in_bucket(struct inode *inode,
 		if (cmp)
 			continue;
 
-		ret = ocfs2_xattr_bucket_get_name_value(inode,
+		ret = ocfs2_xattr_bucket_get_name_value(inode->i_sb,
 							xh,
 							i,
 							&block_off,
@@ -3216,7 +3216,7 @@ struct ocfs2_xattr_tree_list {
 	size_t result;
 };
 
-static int ocfs2_xattr_bucket_get_name_value(struct inode *inode,
+static int ocfs2_xattr_bucket_get_name_value(struct super_block *sb,
 					     struct ocfs2_xattr_header *xh,
 					     int index,
 					     int *block_off,
@@ -3229,8 +3229,8 @@ static int ocfs2_xattr_bucket_get_name_value(struct inode *inode,
 
 	name_offset = le16_to_cpu(xh->xh_entries[index].xe_name_offset);
 
-	*block_off = name_offset >> inode->i_sb->s_blocksize_bits;
-	*new_offset = name_offset % inode->i_sb->s_blocksize;
+	*block_off = name_offset >> sb->s_blocksize_bits;
+	*new_offset = name_offset % sb->s_blocksize;
 
 	return 0;
 }
@@ -3250,7 +3250,7 @@ static int ocfs2_list_xattr_bucket(struct inode *inode,
 		prefix = ocfs2_xattr_prefix(type);
 
 		if (prefix) {
-			ret = ocfs2_xattr_bucket_get_name_value(inode,
+			ret = ocfs2_xattr_bucket_get_name_value(inode->i_sb,
 								bucket_xh(bucket),
 								i,
 								&block_off,
@@ -4845,7 +4845,7 @@ static int ocfs2_xattr_bucket_set_value_outside(struct inode *inode,
 
 	BUG_ON(!xs->base || !xe || ocfs2_xattr_is_local(xe));
 
-	ret = ocfs2_xattr_bucket_get_name_value(inode, xh,
+	ret = ocfs2_xattr_bucket_get_name_value(inode->i_sb, xh,
 						xe - xh->xh_entries,
 						&block_off,
 						&offset);
@@ -5433,7 +5433,7 @@ static int ocfs2_prepare_refcount_xattr(struct inode *inode,
 		i = xbs->here - xbs->header->xh_entries;
 
 		if (le16_to_cpu(xb->xb_flags) & OCFS2_XATTR_INDEXED) {
-			ret = ocfs2_xattr_bucket_get_name_value(inode,
+			ret = ocfs2_xattr_bucket_get_name_value(inode->i_sb,
 							bucket_xh(xbs->bucket),
 							i, &block_off,
 							&name_offset);
-- 
1.6.2.rc2.16.gf474c
