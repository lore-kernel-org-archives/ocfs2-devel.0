From: Mark Fasheh <mfasheh@suse.com>
Date: Fri, 19 Dec 2008 13:53:51 -0800
Subject: [Ocfs2-devel] [PATCH 32/45] ocfs2: Wrap inode block reads in a
	dedicated function.
In-Reply-To: <1229723644-13630-1-git-send-email-mfasheh@suse.com>
References: <1229723644-13630-1-git-send-email-mfasheh@suse.com>
Message-ID: <1229723644-13630-33-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>, Mark Fasheh <mfasheh@suse.com>

From: Joel Becker <joel.becker@oracle.com>

The ocfs2 code currently reads inodes off disk with a simple
ocfs2_read_block() call.  Each place that does this has a different set
of sanity checks it performs.  Some check only the signature.  A couple
validate the block number (the block read vs di->i_blkno).  A couple
others check for VALID_FL.  Only one place validates i_fs_generation.  A
couple check nothing.  Even when an error is found, they don't all do
the same thing.

We wrap inode reading into ocfs2_read_inode_block().  This will validate
all the above fields, going readonly if they are invalid (they never
should be).  ocfs2_read_inode_block_full() is provided for the places
that want to pass read_block flags.  Every caller is passing a struct
inode with a valid ip_blkno, so we don't need a separate blkno argument
either.

We will remove the validation checks from the rest of the code in a
later commit, as they are no longer necessary.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/alloc.c      |    2 +-
 fs/ocfs2/aops.c       |   11 +---
 fs/ocfs2/dir.c        |    6 +-
 fs/ocfs2/dlmglue.c    |   12 ++---
 fs/ocfs2/extent_map.c |    2 +-
 fs/ocfs2/file.c       |   21 ++------
 fs/ocfs2/inode.c      |  136 +++++++++++++++++++++++++++++++++++--------------
 fs/ocfs2/inode.h      |   16 +++++-
 fs/ocfs2/journal.c    |    3 +-
 fs/ocfs2/localalloc.c |    8 ++--
 fs/ocfs2/namei.c      |   14 +----
 fs/ocfs2/symlink.c    |    2 +-
 12 files changed, 136 insertions(+), 97 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 5592a2f..9c598ad 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -5658,7 +5658,7 @@ static int ocfs2_get_truncate_log_info(struct ocfs2_super *osb,
 		goto bail;
 	}
 
-	status = ocfs2_read_block(inode, OCFS2_I(inode)->ip_blkno, &bh);
+	status = ocfs2_read_inode_block(inode, &bh);
 	if (status < 0) {
 		iput(inode);
 		mlog_errno(status);
diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index c22543b..e219f8b 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -68,20 +68,13 @@ static int ocfs2_symlink_get_block(struct inode *inode, sector_t iblock,
 		goto bail;
 	}
 
-	status = ocfs2_read_block(inode, OCFS2_I(inode)->ip_blkno, &bh);
+	status = ocfs2_read_inode_block(inode, &bh);
 	if (status < 0) {
 		mlog_errno(status);
 		goto bail;
 	}
 	fe = (struct ocfs2_dinode *) bh->b_data;
 
-	if (!OCFS2_IS_VALID_DINODE(fe)) {
-		mlog(ML_ERROR, "Invalid dinode #%llu: signature = %.*s\n",
-		     (unsigned long long)le64_to_cpu(fe->i_blkno), 7,
-		     fe->i_signature);
-		goto bail;
-	}
-
 	if ((u64)iblock >= ocfs2_clusters_to_blocks(inode->i_sb,
 						    le32_to_cpu(fe->i_clusters))) {
 		mlog(ML_ERROR, "block offset is outside the allocated size: "
@@ -262,7 +255,7 @@ static int ocfs2_readpage_inline(struct inode *inode, struct page *page)
 	BUG_ON(!PageLocked(page));
 	BUG_ON(!(OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL));
 
-	ret = ocfs2_read_block(inode, OCFS2_I(inode)->ip_blkno, &di_bh);
+	ret = ocfs2_read_inode_block(inode, &di_bh);
 	if (ret) {
 		mlog_errno(ret);
 		goto out;
diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index 026e6eb..5777045 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -231,7 +231,7 @@ static struct buffer_head *ocfs2_find_entry_id(const char *name,
 	struct ocfs2_dinode *di;
 	struct ocfs2_inline_data *data;
 
-	ret = ocfs2_read_block(dir, OCFS2_I(dir)->ip_blkno, &di_bh);
+	ret = ocfs2_read_inode_block(dir, &di_bh);
 	if (ret) {
 		mlog_errno(ret);
 		goto out;
@@ -458,7 +458,7 @@ static inline int ocfs2_delete_entry_id(handle_t *handle,
 	struct ocfs2_dinode *di;
 	struct ocfs2_inline_data *data;
 
-	ret = ocfs2_read_block(dir, OCFS2_I(dir)->ip_blkno, &di_bh);
+	ret = ocfs2_read_inode_block(dir, &di_bh);
 	if (ret) {
 		mlog_errno(ret);
 		goto out;
@@ -636,7 +636,7 @@ static int ocfs2_dir_foreach_blk_id(struct inode *inode,
 	struct ocfs2_inline_data *data;
 	struct ocfs2_dir_entry *de;
 
-	ret = ocfs2_read_block(inode, OCFS2_I(inode)->ip_blkno, &di_bh);
+	ret = ocfs2_read_inode_block(inode, &di_bh);
 	if (ret) {
 		mlog(ML_ERROR, "Unable to read inode block for dir %llu\n",
 		     (unsigned long long)OCFS2_I(inode)->ip_blkno);
diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 6e6cc0a..9f2a7f7 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -2024,7 +2024,7 @@ static int ocfs2_inode_lock_update(struct inode *inode,
 	} else {
 		/* Boo, we have to go to disk. */
 		/* read bh, cast, ocfs2_refresh_inode */
-		status = ocfs2_read_block(inode, oi->ip_blkno, bh);
+		status = ocfs2_read_inode_block(inode, bh);
 		if (status < 0) {
 			mlog_errno(status);
 			goto bail_refresh;
@@ -2032,18 +2032,14 @@ static int ocfs2_inode_lock_update(struct inode *inode,
 		fe = (struct ocfs2_dinode *) (*bh)->b_data;
 
 		/* This is a good chance to make sure we're not
-		 * locking an invalid object.
+		 * locking an invalid object.  ocfs2_read_inode_block()
+		 * already checked that the inode block is sane.
 		 *
 		 * We bug on a stale inode here because we checked
 		 * above whether it was wiped from disk. The wiping
 		 * node provides a guarantee that we receive that
 		 * message and can mark the inode before dropping any
 		 * locks associated with it. */
-		if (!OCFS2_IS_VALID_DINODE(fe)) {
-			OCFS2_RO_ON_INVALID_DINODE(inode->i_sb, fe);
-			status = -EIO;
-			goto bail_refresh;
-		}
 		mlog_bug_on_msg(inode->i_generation !=
 				le32_to_cpu(fe->i_generation),
 				"Invalid dinode %llu disk generation: %u "
@@ -2085,7 +2081,7 @@ static int ocfs2_assign_bh(struct inode *inode,
 		return 0;
 	}
 
-	status = ocfs2_read_block(inode, OCFS2_I(inode)->ip_blkno, ret_bh);
+	status = ocfs2_read_inode_block(inode, ret_bh);
 	if (status < 0)
 		mlog_errno(status);
 
diff --git a/fs/ocfs2/extent_map.c b/fs/ocfs2/extent_map.c
index 2baedac..b686b31 100644
--- a/fs/ocfs2/extent_map.c
+++ b/fs/ocfs2/extent_map.c
@@ -630,7 +630,7 @@ int ocfs2_get_clusters(struct inode *inode, u32 v_cluster,
 	if (ret == 0)
 		goto out;
 
-	ret = ocfs2_read_block(inode, OCFS2_I(inode)->ip_blkno, &di_bh);
+	ret = ocfs2_read_inode_block(inode, &di_bh);
 	if (ret) {
 		mlog_errno(ret);
 		goto out;
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 4636aa6..41001d5 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -402,12 +402,9 @@ static int ocfs2_truncate_file(struct inode *inode,
 		   (unsigned long long)OCFS2_I(inode)->ip_blkno,
 		   (unsigned long long)new_i_size);
 
+	/* We trust di_bh because it comes from ocfs2_inode_lock(), which
+	 * already validated it */
 	fe = (struct ocfs2_dinode *) di_bh->b_data;
-	if (!OCFS2_IS_VALID_DINODE(fe)) {
-		OCFS2_RO_ON_INVALID_DINODE(inode->i_sb, fe);
-		status = -EIO;
-		goto bail;
-	}
 
 	mlog_bug_on_msg(le64_to_cpu(fe->i_size) != i_size_read(inode),
 			"Inode %llu, inode i_size = %lld != di "
@@ -546,18 +543,12 @@ static int __ocfs2_extend_allocation(struct inode *inode, u32 logical_start,
 	 */
 	BUG_ON(mark_unwritten && !ocfs2_sparse_alloc(osb));
 
-	status = ocfs2_read_block(inode, OCFS2_I(inode)->ip_blkno, &bh);
+	status = ocfs2_read_inode_block(inode, &bh);
 	if (status < 0) {
 		mlog_errno(status);
 		goto leave;
 	}
-
 	fe = (struct ocfs2_dinode *) bh->b_data;
-	if (!OCFS2_IS_VALID_DINODE(fe)) {
-		OCFS2_RO_ON_INVALID_DINODE(inode->i_sb, fe);
-		status = -EIO;
-		goto leave;
-	}
 
 restart_all:
 	BUG_ON(le32_to_cpu(fe->i_clusters) != OCFS2_I(inode)->ip_clusters);
@@ -1135,9 +1126,8 @@ static int ocfs2_write_remove_suid(struct inode *inode)
 {
 	int ret;
 	struct buffer_head *bh = NULL;
-	struct ocfs2_inode_info *oi = OCFS2_I(inode);
 
-	ret = ocfs2_read_block(inode, oi->ip_blkno, &bh);
+	ret = ocfs2_read_inode_block(inode, &bh);
 	if (ret < 0) {
 		mlog_errno(ret);
 		goto out;
@@ -1163,8 +1153,7 @@ static int ocfs2_allocate_unwritten_extents(struct inode *inode,
 	struct buffer_head *di_bh = NULL;
 
 	if (OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL) {
-		ret = ocfs2_read_block(inode, OCFS2_I(inode)->ip_blkno,
-				       &di_bh);
+		ret = ocfs2_read_inode_block(inode, &di_bh);
 		if (ret) {
 			mlog_errno(ret);
 			goto out;
diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 7aa00d5..9eb701b 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -214,12 +214,11 @@ static int ocfs2_init_locked_inode(struct inode *inode, void *opaque)
 	return 0;
 }
 
-int ocfs2_populate_inode(struct inode *inode, struct ocfs2_dinode *fe,
-		     	 int create_ino)
+void ocfs2_populate_inode(struct inode *inode, struct ocfs2_dinode *fe,
+			  int create_ino)
 {
 	struct super_block *sb;
 	struct ocfs2_super *osb;
-	int status = -EINVAL;
 	int use_plocks = 1;
 
 	mlog_entry("(0x%p, size:%llu)\n", inode,
@@ -232,25 +231,17 @@ int ocfs2_populate_inode(struct inode *inode, struct ocfs2_dinode *fe,
 	    ocfs2_mount_local(osb) || !ocfs2_stack_supports_plocks())
 		use_plocks = 0;
 
-	/* this means that read_inode cannot create a superblock inode
-	 * today.  change if needed. */
-	if (!OCFS2_IS_VALID_DINODE(fe) ||
-	    !(fe->i_flags & cpu_to_le32(OCFS2_VALID_FL))) {
-		mlog(0, "Invalid dinode: i_ino=%lu, i_blkno=%llu, "
-		     "signature = %.*s, flags = 0x%x\n",
-		     inode->i_ino,
-		     (unsigned long long)le64_to_cpu(fe->i_blkno), 7,
-		     fe->i_signature, le32_to_cpu(fe->i_flags));
-		goto bail;
-	}
+	/*
+	 * These have all been checked by ocfs2_read_inode_block() or set
+	 * by ocfs2_mknod_locked(), so a failure is a code bug.
+	 */
+	BUG_ON(!OCFS2_IS_VALID_DINODE(fe));  /* This means that read_inode
+						cannot create a superblock
+						inode today.  change if
+						that is needed. */
+	BUG_ON(!(fe->i_flags & cpu_to_le32(OCFS2_VALID_FL)));
+	BUG_ON(le32_to_cpu(fe->i_fs_generation) != osb->fs_generation);
 
-	if (le32_to_cpu(fe->i_fs_generation) != osb->fs_generation) {
-		mlog(ML_ERROR, "file entry generation does not match "
-		     "superblock! osb->fs_generation=%x, "
-		     "fe->i_fs_generation=%x\n",
-		     osb->fs_generation, le32_to_cpu(fe->i_fs_generation));
-		goto bail;
-	}
 
 	OCFS2_I(inode)->ip_clusters = le32_to_cpu(fe->i_clusters);
 	OCFS2_I(inode)->ip_attr = le32_to_cpu(fe->i_attr);
@@ -354,10 +345,7 @@ int ocfs2_populate_inode(struct inode *inode, struct ocfs2_dinode *fe,
 
 	ocfs2_set_inode_flags(inode);
 
-	status = 0;
-bail:
-	mlog_exit(status);
-	return status;
+	mlog_exit_void();
 }
 
 static int ocfs2_read_locked_inode(struct inode *inode,
@@ -460,11 +448,14 @@ static int ocfs2_read_locked_inode(struct inode *inode,
 		}
 	}
 
-	if (can_lock)
-		status = ocfs2_read_blocks(inode, args->fi_blkno, 1, &bh,
-					   OCFS2_BH_IGNORE_CACHE);
-	else
+	if (can_lock) {
+		status = ocfs2_read_inode_block_full(inode, &bh,
+						     OCFS2_BH_IGNORE_CACHE);
+	} else {
 		status = ocfs2_read_blocks_sync(osb, args->fi_blkno, 1, &bh);
+		if (!status)
+			status = ocfs2_validate_inode_block(osb->sb, bh);
+	}
 	if (status < 0) {
 		mlog_errno(status);
 		goto bail;
@@ -472,12 +463,6 @@ static int ocfs2_read_locked_inode(struct inode *inode,
 
 	status = -EINVAL;
 	fe = (struct ocfs2_dinode *) bh->b_data;
-	if (!OCFS2_IS_VALID_DINODE(fe)) {
-		mlog(0, "Invalid dinode #%llu: signature = %.*s\n",
-		     (unsigned long long)args->fi_blkno, 7,
-		     fe->i_signature);
-		goto bail;
-	}
 
 	/*
 	 * This is a code bug. Right now the caller needs to
@@ -491,10 +476,9 @@ static int ocfs2_read_locked_inode(struct inode *inode,
 
 	if (S_ISCHR(le16_to_cpu(fe->i_mode)) ||
 	    S_ISBLK(le16_to_cpu(fe->i_mode)))
-    		inode->i_rdev = huge_decode_dev(le64_to_cpu(fe->id1.dev1.i_rdev));
+		inode->i_rdev = huge_decode_dev(le64_to_cpu(fe->id1.dev1.i_rdev));
 
-	if (ocfs2_populate_inode(inode, fe, 0) < 0)
-		goto bail;
+	ocfs2_populate_inode(inode, fe, 0);
 
 	BUG_ON(args->fi_blkno != le64_to_cpu(fe->i_blkno));
 
@@ -1264,3 +1248,79 @@ void ocfs2_refresh_inode(struct inode *inode,
 
 	spin_unlock(&OCFS2_I(inode)->ip_lock);
 }
+
+int ocfs2_validate_inode_block(struct super_block *sb,
+			       struct buffer_head *bh)
+{
+	int rc = -EINVAL;
+	struct ocfs2_dinode *di = (struct ocfs2_dinode *)bh->b_data;
+
+	BUG_ON(!buffer_uptodate(bh));
+
+	if (!OCFS2_IS_VALID_DINODE(di)) {
+		ocfs2_error(sb, "Invalid dinode #%llu: signature = %.*s\n",
+			    (unsigned long long)bh->b_blocknr, 7,
+			    di->i_signature);
+		goto bail;
+	}
+
+	if (le64_to_cpu(di->i_blkno) != bh->b_blocknr) {
+		ocfs2_error(sb, "Invalid dinode #%llu: i_blkno is %llu\n",
+			    (unsigned long long)bh->b_blocknr,
+			    (unsigned long long)le64_to_cpu(di->i_blkno));
+		goto bail;
+	}
+
+	if (!(di->i_flags & cpu_to_le32(OCFS2_VALID_FL))) {
+		ocfs2_error(sb,
+			    "Invalid dinode #%llu: OCFS2_VALID_FL not set\n",
+			    (unsigned long long)bh->b_blocknr);
+		goto bail;
+	}
+
+	if (le32_to_cpu(di->i_fs_generation) !=
+	    OCFS2_SB(sb)->fs_generation) {
+		ocfs2_error(sb,
+			    "Invalid dinode #%llu: fs_generation is %u\n",
+			    (unsigned long long)bh->b_blocknr,
+			    le32_to_cpu(di->i_fs_generation));
+		goto bail;
+	}
+
+	rc = 0;
+
+bail:
+	return rc;
+}
+
+int ocfs2_read_inode_block_full(struct inode *inode, struct buffer_head **bh,
+				int flags)
+{
+	int rc;
+	struct buffer_head *tmp = *bh;
+
+	rc = ocfs2_read_blocks(inode, OCFS2_I(inode)->ip_blkno, 1, &tmp,
+			       flags);
+	if (rc)
+		goto out;
+
+	if (!(flags & OCFS2_BH_READAHEAD)) {
+		rc = ocfs2_validate_inode_block(inode->i_sb, tmp);
+		if (rc) {
+			brelse(tmp);
+			goto out;
+		}
+	}
+
+	/* If ocfs2_read_blocks() got us a new bh, pass it up. */
+	if (!*bh)
+		*bh = tmp;
+
+out:
+	return rc;
+}
+
+int ocfs2_read_inode_block(struct inode *inode, struct buffer_head **bh)
+{
+	return ocfs2_read_inode_block_full(inode, bh, 0);
+}
diff --git a/fs/ocfs2/inode.h b/fs/ocfs2/inode.h
index 2f37af9..b79c371 100644
--- a/fs/ocfs2/inode.h
+++ b/fs/ocfs2/inode.h
@@ -128,8 +128,8 @@ struct inode *ocfs2_iget(struct ocfs2_super *osb, u64 feoff, unsigned flags,
 			 int sysfile_type);
 int ocfs2_inode_init_private(struct inode *inode);
 int ocfs2_inode_revalidate(struct dentry *dentry);
-int ocfs2_populate_inode(struct inode *inode, struct ocfs2_dinode *fe,
-			 int create_ino);
+void ocfs2_populate_inode(struct inode *inode, struct ocfs2_dinode *fe,
+			  int create_ino);
 void ocfs2_read_inode(struct inode *inode);
 void ocfs2_read_inode2(struct inode *inode, void *opaque);
 ssize_t ocfs2_rw_direct(int rw, struct file *filp, char *buf,
@@ -153,4 +153,16 @@ static inline blkcnt_t ocfs2_inode_sector_count(struct inode *inode)
 	return (blkcnt_t)(OCFS2_I(inode)->ip_clusters << c_to_s_bits);
 }
 
+/* Validate that a bh contains a valid inode */
+int ocfs2_validate_inode_block(struct super_block *sb,
+			       struct buffer_head *bh);
+/*
+ * Read an inode block into *bh.  If *bh is NULL, a bh will be allocated.
+ * This is a cached read.  The inode will be validated with
+ * ocfs2_validate_inode_block().
+ */
+int ocfs2_read_inode_block(struct inode *inode, struct buffer_head **bh);
+/* The same, but can be passed OCFS2_BH_* flags */
+int ocfs2_read_inode_block_full(struct inode *inode, struct buffer_head **bh,
+				int flags);
 #endif /* OCFS2_INODE_H */
diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index 99fe9d5..877aaa0 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -1135,8 +1135,7 @@ static int ocfs2_read_journal_inode(struct ocfs2_super *osb,
 	}
 	SET_INODE_JOURNAL(inode);
 
-	status = ocfs2_read_blocks(inode, OCFS2_I(inode)->ip_blkno, 1, bh,
-				   OCFS2_BH_IGNORE_CACHE);
+	status = ocfs2_read_inode_block_full(inode, bh, OCFS2_BH_IGNORE_CACHE);
 	if (status < 0) {
 		mlog_errno(status);
 		goto bail;
diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
index 687b287..19cfb1b 100644
--- a/fs/ocfs2/localalloc.c
+++ b/fs/ocfs2/localalloc.c
@@ -248,8 +248,8 @@ int ocfs2_load_local_alloc(struct ocfs2_super *osb)
 		goto bail;
 	}
 
-	status = ocfs2_read_blocks(inode, OCFS2_I(inode)->ip_blkno, 1,
-				   &alloc_bh, OCFS2_BH_IGNORE_CACHE);
+	status = ocfs2_read_inode_block_full(inode, &alloc_bh,
+					     OCFS2_BH_IGNORE_CACHE);
 	if (status < 0) {
 		mlog_errno(status);
 		goto bail;
@@ -459,8 +459,8 @@ int ocfs2_begin_local_alloc_recovery(struct ocfs2_super *osb,
 
 	mutex_lock(&inode->i_mutex);
 
-	status = ocfs2_read_blocks(inode, OCFS2_I(inode)->ip_blkno, 1,
-				   &alloc_bh, OCFS2_BH_IGNORE_CACHE);
+	status = ocfs2_read_inode_block_full(inode, &alloc_bh,
+					     OCFS2_BH_IGNORE_CACHE);
 	if (status < 0) {
 		mlog_errno(status);
 		goto bail;
diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index ed7ed74..98fd325 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -531,15 +531,7 @@ static int ocfs2_mknod_locked(struct ocfs2_super *osb,
 		goto leave;
 	}
 
-	if (ocfs2_populate_inode(inode, fe, 1) < 0) {
-		mlog(ML_ERROR, "populate inode failed! bh->b_blocknr=%llu, "
-		     "i_blkno=%llu, i_ino=%lu\n",
-		     (unsigned long long)(*new_fe_bh)->b_blocknr,
-		     (unsigned long long)le64_to_cpu(fe->i_blkno),
-		     inode->i_ino);
-		BUG();
-	}
-
+	ocfs2_populate_inode(inode, fe, 1);
 	ocfs2_inode_set_new(osb, inode);
 	if (!ocfs2_mount_local(osb)) {
 		status = ocfs2_create_new_inode_locks(inode);
@@ -1864,9 +1856,7 @@ static int ocfs2_orphan_add(struct ocfs2_super *osb,
 
 	mlog_entry("(inode->i_ino = %lu)\n", inode->i_ino);
 
-	status = ocfs2_read_block(orphan_dir_inode,
-				  OCFS2_I(orphan_dir_inode)->ip_blkno,
-				  &orphan_dir_bh);
+	status = ocfs2_read_inode_block(orphan_dir_inode, &orphan_dir_bh);
 	if (status < 0) {
 		mlog_errno(status);
 		goto leave;
diff --git a/fs/ocfs2/symlink.c b/fs/ocfs2/symlink.c
index cbd03df..ed0a0cf 100644
--- a/fs/ocfs2/symlink.c
+++ b/fs/ocfs2/symlink.c
@@ -84,7 +84,7 @@ static char *ocfs2_fast_symlink_getlink(struct inode *inode,
 
 	mlog_entry_void();
 
-	status = ocfs2_read_block(inode, OCFS2_I(inode)->ip_blkno, bh);
+	status = ocfs2_read_inode_block(inode, bh);
 	if (status < 0) {
 		mlog_errno(status);
 		link = ERR_PTR(status);
-- 
1.5.6
