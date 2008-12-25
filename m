From: Mark Fasheh <mfasheh@suse.com>
Date: Thu, 25 Dec 2008 10:04:20 -0800
Subject: [Ocfs2-devel] [PATCH 05/35] ocfs2: block read meta ecc.
In-Reply-To: <1230228290-22803-1-git-send-email-mfasheh@suse.com>
References: <1230228290-22803-1-git-send-email-mfasheh@suse.com>
Message-ID: <1230228290-22803-6-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>, Mark Fasheh <mfasheh@suse.com>

From: Joel Becker <joel.becker@oracle.com>

Add block check calls to the read_block validate functions.  This is the
almost all of the read-side checking of metaecc.  xattr buckets are not checked
yet.   Writes are also unchecked, and so a read-write mount will quickly fail.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/alloc.c        |   17 +++++++++++++++++
 fs/ocfs2/blockcheck.c   |    9 +++++++++
 fs/ocfs2/inode.c        |   18 +++++++++++++++++-
 fs/ocfs2/quota_global.c |   13 +++++++++++--
 fs/ocfs2/suballoc.c     |   31 ++++++++++++++++++++++++++++++-
 fs/ocfs2/xattr.c        |   17 +++++++++++++++++
 6 files changed, 101 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 84a7bd4..6b27f74 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -37,6 +37,7 @@
 
 #include "alloc.h"
 #include "aops.h"
+#include "blockcheck.h"
 #include "dlmglue.h"
 #include "extent_map.h"
 #include "inode.h"
@@ -682,12 +683,28 @@ struct ocfs2_merge_ctxt {
 static int ocfs2_validate_extent_block(struct super_block *sb,
 				       struct buffer_head *bh)
 {
+	int rc;
 	struct ocfs2_extent_block *eb =
 		(struct ocfs2_extent_block *)bh->b_data;
 
 	mlog(0, "Validating extent block %llu\n",
 	     (unsigned long long)bh->b_blocknr);
 
+	BUG_ON(!buffer_uptodate(bh));
+
+	/*
+	 * If the ecc fails, we return the error but otherwise
+	 * leave the filesystem running.  We know any error is
+	 * local to this block.
+	 */
+	rc = ocfs2_validate_meta_ecc(sb, bh->b_data, &eb->h_check);
+	if (rc)
+		return rc;
+
+	/*
+	 * Errors after here are fatal.
+	 */
+
 	if (!OCFS2_IS_VALID_EXTENT_BLOCK(eb)) {
 		ocfs2_error(sb,
 			    "Extent block #%llu has bad signature %.*s",
diff --git a/fs/ocfs2/blockcheck.c b/fs/ocfs2/blockcheck.c
index 2bf3d7f..2ce6ae5 100644
--- a/fs/ocfs2/blockcheck.c
+++ b/fs/ocfs2/blockcheck.c
@@ -24,6 +24,8 @@
 #include <linux/bitops.h>
 #include <asm/byteorder.h>
 
+#include <cluster/masklog.h>
+
 #include "ocfs2.h"
 
 #include "blockcheck.h"
@@ -292,6 +294,10 @@ int ocfs2_block_check_validate(void *data, size_t blocksize,
 	if (crc == check.bc_crc32e)
 		goto out;
 
+	mlog(ML_ERROR,
+	     "CRC32 failed: stored: %u, computed %u.  Applying ECC.\n",
+	     (unsigned int)check.bc_crc32e, (unsigned int)crc);
+
 	/* Ok, try ECC fixups */
 	ecc = ocfs2_hamming_encode_block(data, blocksize);
 	ocfs2_hamming_fix_block(data, blocksize, ecc ^ check.bc_ecc);
@@ -301,6 +307,9 @@ int ocfs2_block_check_validate(void *data, size_t blocksize,
 	if (crc == check.bc_crc32e)
 		goto out;
 
+	mlog(ML_ERROR, "Fixed CRC32 failed: stored: %u, computed %u\n",
+	     (unsigned int)check.bc_crc32e, (unsigned int)crc);
+
 	rc = -EIO;
 
 out:
diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 288512c..9370b65 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -38,6 +38,7 @@
 #include "ocfs2.h"
 
 #include "alloc.h"
+#include "blockcheck.h"
 #include "dlmglue.h"
 #include "extent_map.h"
 #include "file.h"
@@ -1262,7 +1263,7 @@ void ocfs2_refresh_inode(struct inode *inode,
 int ocfs2_validate_inode_block(struct super_block *sb,
 			       struct buffer_head *bh)
 {
-	int rc = -EINVAL;
+	int rc;
 	struct ocfs2_dinode *di = (struct ocfs2_dinode *)bh->b_data;
 
 	mlog(0, "Validating dinode %llu\n",
@@ -1270,6 +1271,21 @@ int ocfs2_validate_inode_block(struct super_block *sb,
 
 	BUG_ON(!buffer_uptodate(bh));
 
+	/*
+	 * If the ecc fails, we return the error but otherwise
+	 * leave the filesystem running.  We know any error is
+	 * local to this block.
+	 */
+	rc = ocfs2_validate_meta_ecc(sb, bh->b_data, &di->i_check);
+	if (rc)
+		goto bail;
+
+	/*
+	 * Errors after here are fatal.
+	 */
+
+	rc = -EINVAL;
+
 	if (!OCFS2_IS_VALID_DINODE(di)) {
 		ocfs2_error(sb, "Invalid dinode #%llu: signature = %.*s\n",
 			    (unsigned long long)bh->b_blocknr, 7,
diff --git a/fs/ocfs2/quota_global.c b/fs/ocfs2/quota_global.c
index 5b05f94..d338438 100644
--- a/fs/ocfs2/quota_global.c
+++ b/fs/ocfs2/quota_global.c
@@ -16,6 +16,7 @@
 #include "ocfs2_fs.h"
 #include "ocfs2.h"
 #include "alloc.h"
+#include "blockcheck.h"
 #include "inode.h"
 #include "journal.h"
 #include "file.h"
@@ -88,12 +89,20 @@ struct qtree_fmt_operations ocfs2_global_ops = {
 static int ocfs2_validate_quota_block(struct super_block *sb,
 				      struct buffer_head *bh)
 {
-	struct ocfs2_disk_dqtrailer *dqt = ocfs2_dq_trailer(sb, bh->b_data);
+	struct ocfs2_disk_dqtrailer *dqt =
+		ocfs2_block_dqtrailer(sb->s_blocksize, bh->b_data);
 
 	mlog(0, "Validating quota block %llu\n",
 	     (unsigned long long)bh->b_blocknr);
 
-	return 0;
+	BUG_ON(!buffer_uptodate(bh));
+
+	/*
+	 * If the ecc fails, we return the error but otherwise
+	 * leave the filesystem running.  We know any error is
+	 * local to this block.
+	 */
+	return ocfs2_validate_meta_ecc(sb, bh->b_data, &dqt->dq_check);
 }
 
 int ocfs2_read_quota_block(struct inode *inode, u64 v_block,
diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index 226fe21..7875576 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -35,6 +35,7 @@
 #include "ocfs2.h"
 
 #include "alloc.h"
+#include "blockcheck.h"
 #include "dlmglue.h"
 #include "inode.h"
 #include "journal.h"
@@ -250,8 +251,18 @@ int ocfs2_check_group_descriptor(struct super_block *sb,
 				 struct buffer_head *bh)
 {
 	int rc;
+	struct ocfs2_group_desc *gd = (struct ocfs2_group_desc *)bh->b_data;
+
+	BUG_ON(!buffer_uptodate(bh));
 
-	rc = ocfs2_validate_gd_self(sb, bh, 1);
+	/*
+	 * If the ecc fails, we return the error but otherwise
+	 * leave the filesystem running.  We know any error is
+	 * local to this block.
+	 */
+	rc = ocfs2_validate_meta_ecc(sb, bh->b_data, &gd->bg_check);
+	if (!rc)
+		rc = ocfs2_validate_gd_self(sb, bh, 1);
 	if (!rc)
 		rc = ocfs2_validate_gd_parent(sb, di, bh, 1);
 
@@ -261,9 +272,27 @@ int ocfs2_check_group_descriptor(struct super_block *sb,
 static int ocfs2_validate_group_descriptor(struct super_block *sb,
 					   struct buffer_head *bh)
 {
+	int rc;
+	struct ocfs2_group_desc *gd = (struct ocfs2_group_desc *)bh->b_data;
+
 	mlog(0, "Validating group descriptor %llu\n",
 	     (unsigned long long)bh->b_blocknr);
 
+	BUG_ON(!buffer_uptodate(bh));
+
+	/*
+	 * If the ecc fails, we return the error but otherwise
+	 * leave the filesystem running.  We know any error is
+	 * local to this block.
+	 */
+	rc = ocfs2_validate_meta_ecc(sb, bh->b_data, &gd->bg_check);
+	if (rc)
+		return rc;
+
+	/*
+	 * Errors after here are fatal.
+	 */
+
 	return ocfs2_validate_gd_self(sb, bh, 0);
 }
 
diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index dfc51c3..bc822d6 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -42,6 +42,7 @@
 
 #include "ocfs2.h"
 #include "alloc.h"
+#include "blockcheck.h"
 #include "dlmglue.h"
 #include "file.h"
 #include "symlink.h"
@@ -322,12 +323,28 @@ static void ocfs2_xattr_bucket_copy_data(struct ocfs2_xattr_bucket *dest,
 static int ocfs2_validate_xattr_block(struct super_block *sb,
 				      struct buffer_head *bh)
 {
+	int rc;
 	struct ocfs2_xattr_block *xb =
 		(struct ocfs2_xattr_block *)bh->b_data;
 
 	mlog(0, "Validating xattr block %llu\n",
 	     (unsigned long long)bh->b_blocknr);
 
+	BUG_ON(!buffer_uptodate(bh));
+
+	/*
+	 * If the ecc fails, we return the error but otherwise
+	 * leave the filesystem running.  We know any error is
+	 * local to this block.
+	 */
+	rc = ocfs2_validate_meta_ecc(sb, bh->b_data, &xb->xb_check);
+	if (rc)
+		return rc;
+
+	/*
+	 * Errors after here are fatal
+	 */
+
 	if (!OCFS2_IS_VALID_XATTR_BLOCK(xb)) {
 		ocfs2_error(sb,
 			    "Extended attribute block #%llu has bad "
-- 
1.5.6
