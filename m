From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 10 Dec 2008 18:25:41 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Checksum and ECC for directory blocks.
In-Reply-To: <20081211021612.GK21455@mail.oracle.com>
References: <1228871395-10273-1-git-send-email-joel.becker@oracle.com>
	<20081211021612.GK21455@mail.oracle.com>
Message-ID: <20081211022541.GN21455@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Use the db_check field of ocfs2_dir_block_trailer to crc/ecc the
dirblocks.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/dir.c      |   33 +++++++++++++++++++++++++++++++--
 fs/ocfs2/dir.h      |    2 ++
 fs/ocfs2/journal.c  |   31 +++++++++++++++++++++++++++++--
 fs/ocfs2/ocfs2_fs.h |    2 +-
 4 files changed, 63 insertions(+), 5 deletions(-)

diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index 06077d0..e03c4ed 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -48,6 +48,7 @@
 #include "ocfs2.h"
 
 #include "alloc.h"
+#include "blockcheck.h"
 #include "dir.h"
 #include "dlmglue.h"
 #include "extent_map.h"
@@ -104,6 +105,17 @@ static inline unsigned int ocfs2_dir_trailer_blk_off(struct super_block *sb)
 
 #define ocfs2_trailer_from_bh(_bh, _sb) ((struct ocfs2_dir_block_trailer *) ((_bh)->b_data + ocfs2_dir_trailer_blk_off((_sb))))
 
+/* XXX ocfs2_block_dqtrailer() is similar but not quite - can we make
+ * them more consistent? */
+struct ocfs2_dir_block_trailer *ocfs2_dir_trailer_from_size(int blocksize,
+							    void *data)
+{
+	char *p = data;
+
+	p += blocksize - sizeof(struct ocfs2_dir_block_trailer);
+	return (struct ocfs2_dir_block_trailer *)p;
+}
+
 /*
  * XXX: This is executed once on every dirent. We should consider optimizing
  * it.
@@ -263,14 +275,31 @@ out:
 static int ocfs2_validate_dir_block(struct super_block *sb,
 				    struct buffer_head *bh)
 {
+	int rc;
+	struct ocfs2_dir_block_trailer *trailer =
+		ocfs2_trailer_from_bh(bh, sb);
+
+
 	/*
-	 * Nothing yet.  We don't validate dirents here, that's handled
+	 * We don't validate dirents here, that's handled
 	 * in-place when the code walks them.
 	 */
 	mlog(0, "Validating dirblock %llu\n",
 	     (unsigned long long)bh->b_blocknr);
 
-	return 0;
+	BUG_ON(!buffer_uptodate(bh));
+
+	/*
+	 * If the ecc fails, we return the error but otherwise
+	 * leave the filesystem running.  We know any error is
+	 * local to this block.
+	 */
+	rc = ocfs2_validate_meta_ecc(sb, bh->b_data, &trailer->db_check);
+	if (rc)
+		mlog(ML_ERROR, "Checksum failed for dinode %llu\n",
+		     (unsigned long long)bh->b_blocknr);
+
+	return rc;
 }
 
 /*
diff --git a/fs/ocfs2/dir.h b/fs/ocfs2/dir.h
index ce48b90..c511e2e 100644
--- a/fs/ocfs2/dir.h
+++ b/fs/ocfs2/dir.h
@@ -83,4 +83,6 @@ int ocfs2_fill_new_dir(struct ocfs2_super *osb,
 		       struct buffer_head *fe_bh,
 		       struct ocfs2_alloc_context *data_ac);
 
+struct ocfs2_dir_block_trailer *ocfs2_dir_trailer_from_size(int blocksize,
+							    void *data);
 #endif /* OCFS2_DIR_H */
diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index 3b54dba..57d7d25 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -415,6 +415,26 @@ static void ocfs2_dq_commit_trigger(struct jbd2_buffer_trigger_type *triggers,
 	ocfs2_block_check_compute(data, size, &dqt->dq_check);
 }
 
+/*
+ * Directory blocks also have their own trigger because the
+ * struct ocfs2_block_check offset depends on the blocksize.
+ */
+static void ocfs2_db_commit_trigger(struct jbd2_buffer_trigger_type *triggers,
+				 struct buffer_head *bh,
+				 void *data, size_t size)
+{
+	struct ocfs2_dir_block_trailer *trailer =
+		ocfs2_dir_trailer_from_size(size, data);
+
+	/*
+	 * We aren't guaranteed to have the superblock here, so we
+	 * must unconditionally compute the ecc data.
+	 * __ocfs2_journal_access() will only set the triggers if
+	 * metaecc is enabled.
+	 */
+	ocfs2_block_check_compute(data, size, &trailer->db_check);
+}
+
 static void ocfs2_abort_trigger(struct jbd2_buffer_trigger_type *triggers,
 				struct buffer_head *bh)
 {
@@ -454,6 +474,13 @@ static struct ocfs2_triggers gd_triggers = {
 	.ot_offset	= offsetof(struct ocfs2_group_desc, bg_check),
 };
 
+static struct ocfs2_triggers db_triggers = {
+	.ot_triggers = {
+		.t_commit = ocfs2_db_commit_trigger,
+		.t_abort = ocfs2_abort_trigger,
+	},
+};
+
 static struct ocfs2_triggers xb_triggers = {
 	.ot_triggers = {
 		.t_commit = ocfs2_commit_trigger,
@@ -555,8 +582,8 @@ int ocfs2_journal_access_gd(handle_t *handle, struct inode *inode,
 int ocfs2_journal_access_db(handle_t *handle, struct inode *inode,
 			    struct buffer_head *bh, int type)
 {
-	/* Right now, nothing for dirblocks */
-	return __ocfs2_journal_access(handle, inode, bh, NULL, type);
+	return __ocfs2_journal_access(handle, inode, bh, &db_triggers,
+				      type);
 }
 
 int ocfs2_journal_access_xb(handle_t *handle, struct inode *inode,
diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
index e6e7cb0..1d92806 100644
--- a/fs/ocfs2/ocfs2_fs.h
+++ b/fs/ocfs2/ocfs2_fs.h
@@ -767,7 +767,7 @@ struct ocfs2_dir_block_trailer {
 	__u8		db_signature[8];	/* Signature for verification */
 	__le64		db_reserved2;
 	__le64		db_free_next;		/* Next block in list (unused) */
-	__le64		db_check;		/* Error checking */
+	struct ocfs2_block_check db_check;	/* Error checking */
 };
 
 /*
-- 
1.5.6.5
