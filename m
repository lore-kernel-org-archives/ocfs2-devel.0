From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Mon Jan 22 11:02:42 2007
Subject: [Ocfs2-devel] [git patches] ocfs2 fixes
Message-ID: <20070122190236.GB5803@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@osdl.org>
Cc: Andrew Morton <akpm@osdl.org>, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org

Hi Linus,
	This update is just a small set of ocfs2 fixes suitable for merging
late in the cycle as they're all either straightforward or trivial.

Please pull from 'upstream-linus' branch of
git://git.kernel.org/pub/scm/linux/kernel/git/mfasheh/ocfs2.git upstream-linus

to receive the following updates:

 fs/ocfs2/export.c   |    5 ---
 fs/ocfs2/inode.c    |   11 ++------
 fs/ocfs2/namei.c    |   69 +++++++++++++++++++++++++++-------------------------
 fs/ocfs2/ocfs2_fs.h |   43 +++++++++++++++++++++++++++++++-
 fs/ocfs2/symlink.c  |    3 --
 5 files changed, 84 insertions(+), 47 deletions(-)

Mark Fasheh:
      ocfs2: Don't print errors when following symlinks
      ocfs2: Directory c/mtime update fixes
      ocfs2: cleanup ocfs2_iget() errors
      ocfs2: Add backup superblock info to ocfs2_fs.h

diff --git a/fs/ocfs2/export.c b/fs/ocfs2/export.c
index 06be6e7..56e1fef 100644
--- a/fs/ocfs2/export.c
+++ b/fs/ocfs2/export.c
@@ -60,14 +60,11 @@ static struct dentry *ocfs2_get_dentry(s
 
 	inode = ocfs2_iget(OCFS2_SB(sb), handle->ih_blkno, 0);
 
-	if (IS_ERR(inode)) {
-		mlog_errno(PTR_ERR(inode));
+	if (IS_ERR(inode))
 		return (void *)inode;
-	}
 
 	if (handle->ih_generation != inode->i_generation) {
 		iput(inode);
-		mlog_errno(-ESTALE);
 		return ERR_PTR(-ESTALE);
 	}
 
diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index e4d9149..28ab56f 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -146,7 +146,6 @@ struct inode *ocfs2_iget(struct ocfs2_su
 	if (is_bad_inode(inode)) {
 		iput(inode);
 		inode = ERR_PTR(-ESTALE);
-		mlog_errno(PTR_ERR(inode));
 		goto bail;
 	}
 
@@ -155,8 +154,7 @@ bail:
 		mlog(0, "returning inode with number %llu\n",
 		     (unsigned long long)OCFS2_I(inode)->ip_blkno);
 		mlog_exit_ptr(inode);
-	} else
-		mlog_errno(PTR_ERR(inode));
+	}
 
 	return inode;
 }
@@ -247,7 +245,7 @@ int ocfs2_populate_inode(struct inode *i
 	 * today.  change if needed. */
 	if (!OCFS2_IS_VALID_DINODE(fe) ||
 	    !(fe->i_flags & cpu_to_le32(OCFS2_VALID_FL))) {
-		mlog(ML_ERROR, "Invalid dinode: i_ino=%lu, i_blkno=%llu, "
+		mlog(0, "Invalid dinode: i_ino=%lu, i_blkno=%llu, "
 		     "signature = %.*s, flags = 0x%x\n",
 		     inode->i_ino,
 		     (unsigned long long)le64_to_cpu(fe->i_blkno), 7,
@@ -478,11 +476,8 @@ static int ocfs2_read_locked_inode(struc
 	    S_ISBLK(le16_to_cpu(fe->i_mode)))
     		inode->i_rdev = huge_decode_dev(le64_to_cpu(fe->id1.dev1.i_rdev));
 
-	if (ocfs2_populate_inode(inode, fe, 0) < 0) {
-		mlog(ML_ERROR, "populate failed! i_blkno=%llu, i_ino=%lu\n",
-		     (unsigned long long)fe->i_blkno, inode->i_ino);
+	if (ocfs2_populate_inode(inode, fe, 0) < 0)
 		goto bail;
-	}
 
 	BUG_ON(args->fi_blkno != le64_to_cpu(fe->i_blkno));
 
diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 9637039..f3d7803 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -932,14 +932,15 @@ static int ocfs2_unlink(struct inode *di
 		goto leave;
 	}
 
-	if (S_ISDIR(inode->i_mode)) {
+	dir->i_ctime = dir->i_mtime = CURRENT_TIME;
+	if (S_ISDIR(inode->i_mode))
 		drop_nlink(dir);
-		status = ocfs2_mark_inode_dirty(handle, dir,
-						parent_node_bh);
-		if (status < 0) {
-			mlog_errno(status);
+
+	status = ocfs2_mark_inode_dirty(handle, dir, parent_node_bh);
+	if (status < 0) {
+		mlog_errno(status);
+		if (S_ISDIR(inode->i_mode))
 			inc_nlink(dir);
-		}
 	}
 
 leave:
@@ -1068,6 +1069,7 @@ static int ocfs2_rename(struct inode *ol
 	char orphan_name[OCFS2_ORPHAN_NAMELEN + 1];
 	struct buffer_head *orphan_entry_bh = NULL;
 	struct buffer_head *newfe_bh = NULL;
+	struct buffer_head *old_inode_bh = NULL;
 	struct buffer_head *insert_entry_bh = NULL;
 	struct ocfs2_super *osb = NULL;
 	u64 newfe_blkno;
@@ -1079,7 +1081,7 @@ static int ocfs2_rename(struct inode *ol
 	struct buffer_head *new_de_bh = NULL, *old_de_bh = NULL; // bhs for above
 	struct buffer_head *old_inode_de_bh = NULL; // if old_dentry is a dir,
 						    // this is the 1st dirent bh
-	nlink_t old_dir_nlink = old_dir->i_nlink, new_dir_nlink = new_dir->i_nlink;
+	nlink_t old_dir_nlink = old_dir->i_nlink;
 
 	/* At some point it might be nice to break this function up a
 	 * bit. */
@@ -1139,12 +1141,11 @@ static int ocfs2_rename(struct inode *ol
 	}
 
 	/*
-	 * Though we don't require an inode meta data update if
-	 * old_inode is not a directory, we lock anyway here to ensure
-	 * the vote thread on other nodes won't have to concurrently
-	 * downconvert the inode and the dentry locks.
+	 * Aside from allowing a meta data update, the locking here
+	 * also ensures that the vote thread on other nodes won't have
+	 * to concurrently downconvert the inode and the dentry locks.
 	 */
-	status = ocfs2_meta_lock(old_inode, NULL, 1);
+	status = ocfs2_meta_lock(old_inode, &old_inode_bh, 1);
 	if (status < 0) {
 		if (status != -ENOENT)
 			mlog_errno(status);
@@ -1355,6 +1356,7 @@ static int ocfs2_rename(struct inode *ol
 
 	old_inode->i_ctime = CURRENT_TIME;
 	mark_inode_dirty(old_inode);
+	ocfs2_mark_inode_dirty(handle, old_inode, old_inode_bh);
 
 	/* now that the name has been added to new_dir, remove the old name */
 	status = ocfs2_delete_entry(handle, old_dir, old_de, old_de_bh);
@@ -1384,27 +1386,22 @@ static int ocfs2_rename(struct inode *ol
 		}
 	}
 	mark_inode_dirty(old_dir);
-	if (new_inode)
+	ocfs2_mark_inode_dirty(handle, old_dir, old_dir_bh);
+	if (new_inode) {
 		mark_inode_dirty(new_inode);
+		ocfs2_mark_inode_dirty(handle, new_inode, newfe_bh);
+	}
 
-	if (old_dir != new_dir)
-		if (new_dir_nlink != new_dir->i_nlink) {
-			if (!new_dir_bh) {
-				mlog(ML_ERROR, "need to change nlink for new "
-				     "dir %llu from %d to %d but bh is NULL\n",
-				     (unsigned long long)OCFS2_I(new_dir)->ip_blkno,
-				     (int)new_dir_nlink, new_dir->i_nlink);
-			} else {
-				struct ocfs2_dinode *fe;
-				status = ocfs2_journal_access(handle,
-							      new_dir,
-							      new_dir_bh,
-							      OCFS2_JOURNAL_ACCESS_WRITE);
-				fe = (struct ocfs2_dinode *) new_dir_bh->b_data;
-				fe->i_links_count = cpu_to_le16(new_dir->i_nlink);
-				status = ocfs2_journal_dirty(handle, new_dir_bh);
-			}
-		}
+	if (old_dir != new_dir) {
+		/* Keep the same times on both directories.*/
+		new_dir->i_ctime = new_dir->i_mtime = old_dir->i_ctime;
+
+		/*
+		 * This will also pick up the i_nlink change from the
+		 * block above.
+		 */
+		ocfs2_mark_inode_dirty(handle, new_dir, new_dir_bh);
+	}
 
 	if (old_dir_nlink != old_dir->i_nlink) {
 		if (!old_dir_bh) {
@@ -1455,6 +1452,8 @@ bail:
 		iput(new_inode);
 	if (newfe_bh)
 		brelse(newfe_bh);
+	if (old_inode_bh)
+		brelse(old_inode_bh);
 	if (old_dir_bh)
 		brelse(old_dir_bh);
 	if (new_dir_bh)
@@ -1826,6 +1825,13 @@ static int __ocfs2_add_entry(handle_t *h
 		     (le16_to_cpu(de->rec_len) >= rec_len)) ||
 		    (le16_to_cpu(de->rec_len) >=
 		     (OCFS2_DIR_REC_LEN(de->name_len) + rec_len))) {
+			dir->i_mtime = dir->i_ctime = CURRENT_TIME;
+			retval = ocfs2_mark_inode_dirty(handle, dir, parent_fe_bh);
+			if (retval < 0) {
+				mlog_errno(retval);
+				goto bail;
+			}
+
 			status = ocfs2_journal_access(handle, dir, insert_bh,
 						      OCFS2_JOURNAL_ACCESS_WRITE);
 			/* By now the buffer is marked for journaling */
@@ -1848,7 +1854,6 @@ static int __ocfs2_add_entry(handle_t *h
 			de->name_len = namelen;
 			memcpy(de->name, name, namelen);
 
-			dir->i_mtime = dir->i_ctime = CURRENT_TIME;
 			dir->i_version++;
 			status = ocfs2_journal_dirty(handle, insert_bh);
 			retval = 0;
diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
index b5c6856..c99e905 100644
--- a/fs/ocfs2/ocfs2_fs.h
+++ b/fs/ocfs2/ocfs2_fs.h
@@ -85,7 +85,7 @@ #define OCFS2_CLEAR_RO_COMPAT_FEATURE(sb
 #define OCFS2_CLEAR_INCOMPAT_FEATURE(sb,mask)			\
 	OCFS2_SB(sb)->s_feature_incompat &= ~(mask)
 
-#define OCFS2_FEATURE_COMPAT_SUPP	0
+#define OCFS2_FEATURE_COMPAT_SUPP	OCFS2_FEATURE_COMPAT_BACKUP_SB
 #define OCFS2_FEATURE_INCOMPAT_SUPP	OCFS2_FEATURE_INCOMPAT_LOCAL_MOUNT
 #define OCFS2_FEATURE_RO_COMPAT_SUPP	0
 
@@ -110,6 +110,20 @@ #define OCFS2_FEATURE_INCOMPAT_LOCAL_MOU
 #define OCFS2_FEATURE_INCOMPAT_SPARSE_ALLOC	0x0010
 
 /*
+ * backup superblock flag is used to indicate that this volume
+ * has backup superblocks.
+ */
+#define OCFS2_FEATURE_COMPAT_BACKUP_SB		0x0001
+
+/* The byte offset of the first backup block will be 1G.
+ * The following will be 4G, 16G, 64G, 256G and 1T.
+ */
+#define OCFS2_BACKUP_SB_START			1 << 30
+
+/* the max backup superblock nums */
+#define OCFS2_MAX_BACKUP_SUPERBLOCKS	6
+
+/*
  * Flags on ocfs2_dinode.i_flags
  */
 #define OCFS2_VALID_FL		(0x00000001)	/* Inode is valid */
@@ -566,6 +580,20 @@ static inline int ocfs2_truncate_recs_pe
 
 	return size / sizeof(struct ocfs2_truncate_rec);
 }
+
+static inline u64 ocfs2_backup_super_blkno(struct super_block *sb, int index)
+{
+	u64 offset = OCFS2_BACKUP_SB_START;
+
+	if (index >= 0 && index < OCFS2_MAX_BACKUP_SUPERBLOCKS) {
+		offset <<= (2 * index);
+		offset /= sb->s_blocksize;
+		return offset;
+	}
+
+	return 0;
+
+}
 #else
 static inline int ocfs2_fast_symlink_chars(int blocksize)
 {
@@ -631,6 +659,19 @@ static inline int ocfs2_truncate_recs_pe
 
 	return size / sizeof(struct ocfs2_truncate_rec);
 }
+
+static inline uint64_t ocfs2_backup_super_blkno(int blocksize, int index)
+{
+	uint64_t offset = OCFS2_BACKUP_SB_START;
+
+	if (index >= 0 && index < OCFS2_MAX_BACKUP_SUPERBLOCKS) {
+		offset <<= (2 * index);
+		offset /= blocksize;
+		return offset;
+	}
+
+	return 0;
+}
 #endif  /* __KERNEL__ */
 
 
diff --git a/fs/ocfs2/symlink.c b/fs/ocfs2/symlink.c
index 957d687..03b0191 100644
--- a/fs/ocfs2/symlink.c
+++ b/fs/ocfs2/symlink.c
@@ -158,8 +158,7 @@ static void *ocfs2_follow_link(struct de
 	}
 
 	status = vfs_follow_link(nd, link);
-	if (status && status != -ENOENT)
-		mlog_errno(status);
+
 bail:
 	if (page) {
 		kunmap(page);
