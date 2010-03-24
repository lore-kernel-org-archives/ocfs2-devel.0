From: Tristan Ye <tristan.ye@oracle.com>
Date: Wed, 24 Mar 2010 09:05:16 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] Ocfs2: Teach truncating and punching-hole
	codes to handle fastsymlink.
Message-ID: <1269392716-24753-1-git-send-email-tristan.ye@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Fast symlink can be treated the same way as inline file for truncating
and hole punching, since the mechanism is quite simliar per se.

Signed-off-by: Tristan Ye <tristan.ye@oracle.com>
---
 fs/ocfs2/alloc.c |   18 ++++++++++++++----
 fs/ocfs2/file.c  |    7 +++++--
 2 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 9f8bd91..a6d6d8e 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -50,6 +50,7 @@
 #include "uptodate.h"
 #include "xattr.h"
 #include "refcounttree.h"
+#include "symlink.h"
 
 #include "buffer_head_io.h"
 
@@ -7668,6 +7669,10 @@ bail:
 
 /*
  * 'start' is inclusive, 'end' is not.
+ *
+ * The name ocfs2_truncate_inline() may be misleading a little bit, since
+ * it handles truncating for fast symlink as well, cause they actually will
+ * be doing one thing per se.
  */
 int ocfs2_truncate_inline(struct inode *inode, struct buffer_head *di_bh,
 			  unsigned int start, unsigned int end, int trunc)
@@ -7684,12 +7689,14 @@ int ocfs2_truncate_inline(struct inode *inode, struct buffer_head *di_bh,
 
 	BUG_ON(start >= end);
 
-	if (!(OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL) ||
+	if ((!(OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL) ||
 	    !(le16_to_cpu(di->i_dyn_features) & OCFS2_INLINE_DATA_FL) ||
-	    !ocfs2_supports_inline_data(osb)) {
+	    !ocfs2_supports_inline_data(osb)) &&
+	    !ocfs2_inode_is_fast_symlink(inode)) {
 		ocfs2_error(inode->i_sb,
 			    "Inline data flags for inode %llu don't agree! "
-			    "Disk: 0x%x, Memory: 0x%x, Superblock: 0x%x\n",
+			    "Disk: 0x%x, Memory: 0x%x, Superblock: 0x%x, "
+			    "and it's not a fast symlink as well.\n",
 			    (unsigned long long)OCFS2_I(inode)->ip_blkno,
 			    le16_to_cpu(di->i_dyn_features),
 			    OCFS2_I(inode)->ip_dyn_features,
@@ -7713,7 +7720,10 @@ int ocfs2_truncate_inline(struct inode *inode, struct buffer_head *di_bh,
 	}
 
 	numbytes = end - start;
-	memset(idata->id_data + start, 0, numbytes);
+	if (ocfs2_inode_is_fast_symlink(inode))
+		memset(di->id2.i_symlink + start, 0, numbytes);
+	else
+		memset(idata->id_data + start, 0, numbytes);
 
 	/*
 	 * No need to worry about the data page here - it's been
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 17947dc..9f6051b 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -60,6 +60,7 @@
 #include "acl.h"
 #include "quota.h"
 #include "refcounttree.h"
+#include "symlink.h"
 
 #include "buffer_head_io.h"
 
@@ -498,7 +499,8 @@ static int ocfs2_truncate_file(struct inode *inode,
 	unmap_mapping_range(inode->i_mapping, new_i_size + PAGE_SIZE - 1, 0, 1);
 	truncate_inode_pages(inode->i_mapping, new_i_size);
 
-	if (OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL) {
+	if ((OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL) ||
+	    ocfs2_inode_is_fast_symlink(inode)) {
 		status = ocfs2_truncate_inline(inode, di_bh, new_i_size,
 					       i_size_read(inode), 1);
 		if (status)
@@ -1450,7 +1452,8 @@ static int ocfs2_remove_inode_range(struct inode *inode,
 	if (byte_len == 0)
 		return 0;
 
-	if (OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL) {
+	if ((OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL) ||
+	    ocfs2_inode_is_fast_symlink(inode)) {
 		ret = ocfs2_truncate_inline(inode, di_bh, byte_start,
 					    byte_start + byte_len, 0);
 		if (ret) {
-- 
1.5.5
