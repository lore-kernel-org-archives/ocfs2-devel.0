From: Joe Perches <joe@perches.com>
Date: Mon, 17 Dec 2007 19:56:07 -0000
Subject: [Ocfs2-devel] [PATCH] fs/: Spelling fixes
Message-ID: <1197920439-5455-15-git-send-email-joe@perches.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/befs/btree.c            |    2 +-
 fs/befs/datastream.c       |    2 +-
 fs/freevxfs/vxfs_dir.h     |    2 +-
 fs/freevxfs/vxfs_immed.c   |    2 +-
 fs/gfs2/recovery.c         |    2 +-
 fs/ocfs2/alloc.c           |    2 +-
 fs/ocfs2/dir.c             |    2 +-
 fs/ocfs2/ocfs1_fs_compat.h |    2 +-
 fs/ocfs2/suballoc.c        |    2 +-
 fs/reiserfs/bitmap.c       |    6 +++---
 10 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/fs/befs/btree.c b/fs/befs/btree.c
index af5bb93..4202db7 100644
--- a/fs/befs/btree.c
+++ b/fs/befs/btree.c
@@ -232,7 +232,7 @@ befs_bt_read_node(struct super_block *sb, befs_data_stream * ds,
  * @key: Key string to lookup in btree
  * @value: Value stored with @key
  *
- * On sucess, returns BEFS_OK and sets *@value to the value stored
+ * On success, returns BEFS_OK and sets *@value to the value stored
  * with @key (usually the disk block number of an inode).
  *
  * On failure, returns BEFS_ERR or BEFS_BT_NOT_FOUND.
diff --git a/fs/befs/datastream.c b/fs/befs/datastream.c
index aacb4da..11088f4 100644
--- a/fs/befs/datastream.c
+++ b/fs/befs/datastream.c
@@ -236,7 +236,7 @@ befs_count_blocks(struct super_block * sb, befs_data_stream * ds)
 	as in the indirect region code).
 	
 	When/if blockno is found, if blockno is inside of a block 
-	run as stored on disk, we offset the start and lenght members 
+	run as stored on disk, we offset the start and length members 
 	of the block run, so that blockno is the start and len is
 	still valid (the run ends in the same place).
 	
diff --git a/fs/freevxfs/vxfs_dir.h b/fs/freevxfs/vxfs_dir.h
index 3c96d6e..aaf1fb0 100644
--- a/fs/freevxfs/vxfs_dir.h
+++ b/fs/freevxfs/vxfs_dir.h
@@ -41,7 +41,7 @@
  * VxFS directory block header.
  *
  * This entry is the head of every filesystem block in a directory.
- * It is used for free space managment and additionally includes
+ * It is used for free space management and additionally includes
  * a hash for speeding up directory search (lookup).
  *
  * The hash may be empty and in fact we do not use it all in the
diff --git a/fs/freevxfs/vxfs_immed.c b/fs/freevxfs/vxfs_immed.c
index 24b5a77..8a5959a 100644
--- a/fs/freevxfs/vxfs_immed.c
+++ b/fs/freevxfs/vxfs_immed.c
@@ -54,7 +54,7 @@ const struct inode_operations vxfs_immed_symlink_iops = {
 };
 
 /*
- * Adress space operations for immed files and directories.
+ * Address space operations for immed files and directories.
  */
 const struct address_space_operations vxfs_immed_aops = {
 	.readpage =		vxfs_immed_readpage,
diff --git a/fs/gfs2/recovery.c b/fs/gfs2/recovery.c
index beb6c7a..b1cdfa7 100644
--- a/fs/gfs2/recovery.c
+++ b/fs/gfs2/recovery.c
@@ -450,7 +450,7 @@ int gfs2_recover_journal(struct gfs2_jdesc *jd)
 		fs_info(sdp, "jid=%u: Trying to acquire journal lock...\n",
 			jd->jd_jid);
 
-		/* Aquire the journal lock so we can do recovery */
+		/* Acquire the journal lock so we can do recovery */
 
 		error = gfs2_glock_nq_num(sdp, jd->jd_jid, &gfs2_journal_glops,
 					  LM_ST_EXCLUSIVE,
diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index ce62c15..602bf0b 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -3326,7 +3326,7 @@ static int ocfs2_insert_path(struct inode *inode,
 	if (insert->ins_split != SPLIT_NONE) {
 		/*
 		 * We could call ocfs2_insert_at_leaf() for some types
-		 * of splits, but it's easier to just let one seperate
+		 * of splits, but it's easier to just let one separate
 		 * function sort it all out.
 		 */
 		ocfs2_split_record(inode, left_path, right_path,
diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index 63b28fd..63fd06e 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -1215,7 +1215,7 @@ static int ocfs2_expand_inline_dir(struct inode *dir, struct buffer_head *di_bh,
 	down_write(&oi->ip_alloc_sem);
 
 	/*
-	 * Prepare for worst case allocation scenario of two seperate
+	 * Prepare for worst case allocation scenario of two separate
 	 * extents.
 	 */
 	if (alloc == 2)
diff --git a/fs/ocfs2/ocfs1_fs_compat.h b/fs/ocfs2/ocfs1_fs_compat.h
index 0b499bc..dfb313b 100644
--- a/fs/ocfs2/ocfs1_fs_compat.h
+++ b/fs/ocfs2/ocfs1_fs_compat.h
@@ -77,7 +77,7 @@ struct ocfs1_disk_lock
 {
 /*00*/	__u32 curr_master;
 	__u8 file_lock;
-	__u8 compat_pad[3];  /* Not in orignal definition.  Used to
+	__u8 compat_pad[3];  /* Not in original definition.  Used to
 				make the already existing alignment
 				explicit */
 	__u64 last_write_time;
diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index 8f09f52..201f594 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -648,7 +648,7 @@ bail:
  * sync-data inodes."
  *
  * Note: OCFS2 already does this differently for metadata vs data
- * allocations, as those bitmaps are seperate and undo access is never
+ * allocations, as those bitmaps are separate and undo access is never
  * called on a metadata group descriptor.
  */
 static int ocfs2_test_bg_bit_allocatable(struct buffer_head *bg_bh,
diff --git a/fs/reiserfs/bitmap.c b/fs/reiserfs/bitmap.c
index 16b331d..f491ceb 100644
--- a/fs/reiserfs/bitmap.c
+++ b/fs/reiserfs/bitmap.c
@@ -272,7 +272,7 @@ static inline int block_group_used(struct super_block *s, u32 id)
 
 	/* If we don't have cached information on this bitmap block, we're
 	 * going to have to load it later anyway. Loading it here allows us
-	 * to make a better decision. This favors long-term performace gain
+	 * to make a better decision. This favors long-term performance gain
 	 * with a better on-disk layout vs. a short term gain of skipping the
 	 * read and potentially having a bad placement. */
 	if (info->free_count == UINT_MAX) {
@@ -663,7 +663,7 @@ static inline void new_hashed_relocation(reiserfs_blocknr_hint_t * hint)
 
 /*
  * Relocation based on dirid, hashing them into a given bitmap block
- * files. Formatted nodes are unaffected, a seperate policy covers them
+ * files. Formatted nodes are unaffected, a separate policy covers them
  */
 static void dirid_groups(reiserfs_blocknr_hint_t * hint)
 {
@@ -688,7 +688,7 @@ static void dirid_groups(reiserfs_blocknr_hint_t * hint)
 
 /*
  * Relocation based on oid, hashing them into a given bitmap block
- * files. Formatted nodes are unaffected, a seperate policy covers them
+ * files. Formatted nodes are unaffected, a separate policy covers them
  */
 static void oid_groups(reiserfs_blocknr_hint_t * hint)
 {
-- 
1.5.3.7.949.g2221a6
