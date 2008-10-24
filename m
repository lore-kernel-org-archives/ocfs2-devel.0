From: Tao Ma <tao.ma@oracle.com>
Date: Fri, 24 Oct 2008 22:24:17 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2/xattr: Fix some typos in xattr
	annotations.
Message-ID: <1224858257-4184-1-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Joel,
	This patch should be simple enough to be in your xattr-28 branch.
And you are free to change them since you are the native speaker. ;)

Fix some typos in xattr's annotations. Thank Coly for pointing them out.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
Cc: Coly Li <coyli@suse.de>
---
 fs/ocfs2/ocfs2_fs.h |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
index f24ce3d..0280edc 100644
--- a/fs/ocfs2/ocfs2_fs.h
+++ b/fs/ocfs2/ocfs2_fs.h
@@ -742,12 +742,12 @@ struct ocfs2_group_desc
  */
 struct ocfs2_xattr_entry {
 	__le32	xe_name_hash;    /* hash value of xattr prefix+suffix. */
-	__le16	xe_name_offset;  /* byte offset from the 1st etnry in the local
+	__le16	xe_name_offset;  /* byte offset from the 1st entry in the
 				    local xattr storage(inode, xattr block or
 				    xattr bucket). */
 	__u8	xe_name_len;	 /* xattr name len, does't include prefix. */
-	__u8	xe_type;         /* the low 7 bits indicates the name prefix's
-				  * type and the highest 1 bits indicate whether
+	__u8	xe_type;         /* the low 7 bits indicate the name prefix's
+				  * type and the highest 1 bit indicates whether
 				  * the EA is stored in the local storage. */
 	__le64	xe_value_size;	 /* real xattr value length. */
 };
@@ -766,7 +766,7 @@ struct ocfs2_xattr_header {
 						   xattr. */
 	__le16	xh_name_value_len;              /* total length of name/value
 						   length in this bucket. */
-	__le16	xh_num_buckets;                 /* bucket nums in one extent
+	__le16	xh_num_buckets;                 /* buckets num in one extent
 						   record, only valid in the
 						   first bucket. */
 	__le64  xh_csum;
@@ -776,7 +776,7 @@ struct ocfs2_xattr_header {
 /*
  * On disk structure for xattr value root.
  *
- * It is used when one extended attribute's size is larger, and we will save it
+ * It is used when one extended attribute's size is large, and we will save it
  * in an outside cluster. It will stored in a b-tree like file content.
  */
 struct ocfs2_xattr_value_root {
-- 
1.5.4.GIT
