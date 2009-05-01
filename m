From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 1 May 2009 16:05:49 -0700
Subject: [Ocfs2-devel] [GIT PULL] ocfs2 fixes
Message-ID: <20090501230548.GD29617@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com, Mark Fasheh <mfasheh@suse.com>, Andrew Morton <akpm@linux-foundation.org>

Linus, et al,
	Here are the outstanding ocfs2 fixes we have for 2.6.30.  The
important ones are journal credit fixes for the new indexed directories.
There's also MAINTAINERS update for my ocfs2 git tree.  Please pull.

Joel


The following changes since commit 612392307cb09e49051225092cbbd7049bd8db93:
  Ryusuke Konishi (1):
        nilfs2: support nanosecond timestamp

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/jlbec/ocfs2.git upstream-linus

Joel Becker (3):
      ocfs2: Fix some printk() warnings.
      ocfs2: Fix a missing credit when deleting from indexed directories.
      ocfs2: Change repository in MAINTAINERS.

Sunil Mushran (1):
      ocfs2: Add missing iput() during error handling in ocfs2_dentry_attach_lock()

Tao Ma (3):
      ocfs2: Reserve 1 more cluster in expanding_inline_dir for indexed dir.
      ocfs2: Fix 2 warning during ocfs2 make.
      ocfs2/trivial: Remove unused variable in ocfs2_rename.

 MAINTAINERS         |    2 +-
 fs/ocfs2/dcache.c   |   15 +++++++++++++++
 fs/ocfs2/dir.c      |    4 ++--
 fs/ocfs2/export.c   |    9 +++++----
 fs/ocfs2/journal.h  |    5 +++--
 fs/ocfs2/namei.c    |    4 ----
 fs/ocfs2/suballoc.c |   21 +++++++++++++--------
 7 files changed, 39 insertions(+), 21 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index c3b2159..7625387 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3335,7 +3335,7 @@ P:	Joel Becker
 M:	joel.becker at oracle.com
 L:	ocfs2-devel at oss.oracle.com (moderated for non-subscribers)
 W:	http://oss.oracle.com/projects/ocfs2/
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mfasheh/ocfs2.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jlbec/ocfs2.git
 S:	Supported
 
 ORINOCO DRIVER
diff --git a/fs/ocfs2/dcache.c b/fs/ocfs2/dcache.c
index 7d60448..b574431 100644
--- a/fs/ocfs2/dcache.c
+++ b/fs/ocfs2/dcache.c
@@ -290,6 +290,21 @@ out_attach:
 	else
 		mlog_errno(ret);
 
+	/*
+	 * In case of error, manually free the allocation and do the iput().
+	 * We need to do this because error here means no d_instantiate(),
+	 * which means iput() will not be called during dput(dentry).
+	 */
+	if (ret < 0 && !alias) {
+		ocfs2_lock_res_free(&dl->dl_lockres);
+		BUG_ON(dl->dl_count != 1);
+		spin_lock(&dentry_attach_lock);
+		dentry->d_fsdata = NULL;
+		spin_unlock(&dentry_attach_lock);
+		kfree(dl);
+		iput(inode);
+	}
+
 	dput(alias);
 
 	return ret;
diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index e71160c..c575230 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -2697,7 +2697,7 @@ static int ocfs2_dx_dir_index_block(struct inode *dir,
 				    u32 *num_dx_entries,
 				    struct buffer_head *dirent_bh)
 {
-	int ret, namelen, i;
+	int ret = 0, namelen, i;
 	char *de_buf, *limit;
 	struct ocfs2_dir_entry *de;
 	struct buffer_head *dx_leaf_bh;
@@ -2934,7 +2934,7 @@ static int ocfs2_expand_inline_dir(struct inode *dir, struct buffer_head *di_bh,
 	 */
 	BUG_ON(alloc > 2);
 
-	ret = ocfs2_reserve_clusters(osb, alloc, &data_ac);
+	ret = ocfs2_reserve_clusters(osb, alloc + dx_alloc, &data_ac);
 	if (ret) {
 		mlog_errno(ret);
 		goto out;
diff --git a/fs/ocfs2/export.c b/fs/ocfs2/export.c
index de3da8e..15713cb 100644
--- a/fs/ocfs2/export.c
+++ b/fs/ocfs2/export.c
@@ -100,7 +100,8 @@ static struct dentry *ocfs2_get_dentry(struct super_block *sb,
 
 	/* If the inode allocator bit is clear, this inode must be stale */
 	if (!set) {
-		mlog(0, "inode %llu suballoc bit is clear\n", blkno);
+		mlog(0, "inode %llu suballoc bit is clear\n",
+		     (unsigned long long)blkno);
 		status = -ESTALE;
 		goto unlock_nfs_sync;
 	}
@@ -114,7 +115,7 @@ check_err:
 	if (status < 0) {
 		if (status == -ESTALE) {
 			mlog(0, "stale inode ino: %llu generation: %u\n",
-			     blkno, handle->ih_generation);
+			     (unsigned long long)blkno, handle->ih_generation);
 		}
 		result = ERR_PTR(status);
 		goto bail;
@@ -129,8 +130,8 @@ check_err:
 check_gen:
 	if (handle->ih_generation != inode->i_generation) {
 		iput(inode);
-		mlog(0, "stale inode ino: %llu generation: %u\n", blkno,
-		     handle->ih_generation);
+		mlog(0, "stale inode ino: %llu generation: %u\n",
+		     (unsigned long long)blkno, handle->ih_generation);
 		result = ERR_PTR(-ESTALE);
 		goto bail;
 	}
diff --git a/fs/ocfs2/journal.h b/fs/ocfs2/journal.h
index 619dd7f..eb7b763 100644
--- a/fs/ocfs2/journal.h
+++ b/fs/ocfs2/journal.h
@@ -437,8 +437,9 @@ static inline int ocfs2_unlink_credits(struct super_block *sb)
 }
 
 /* dinode + orphan dir dinode + inode alloc dinode + orphan dir entry +
- * inode alloc group descriptor + orphan dir index leaf */
-#define OCFS2_DELETE_INODE_CREDITS (3 * OCFS2_INODE_UPDATE_CREDITS + 3)
+ * inode alloc group descriptor + orphan dir index root +
+ * orphan dir index leaf */
+#define OCFS2_DELETE_INODE_CREDITS (3 * OCFS2_INODE_UPDATE_CREDITS + 4)
 
 /* dinode update, old dir dinode update, new dir dinode update, old
  * dir dir entry, new dir dir entry, dir entry update for renaming
diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 2220f93..33464c6 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -1025,10 +1025,8 @@ static int ocfs2_rename(struct inode *old_dir,
 	struct inode *orphan_dir = NULL;
 	struct ocfs2_dinode *newfe = NULL;
 	char orphan_name[OCFS2_ORPHAN_NAMELEN + 1];
-	struct buffer_head *orphan_entry_bh = NULL;
 	struct buffer_head *newfe_bh = NULL;
 	struct buffer_head *old_inode_bh = NULL;
-	struct buffer_head *insert_entry_bh = NULL;
 	struct ocfs2_super *osb = NULL;
 	u64 newfe_blkno, old_de_ino;
 	handle_t *handle = NULL;
@@ -1455,8 +1453,6 @@ bail:
 	brelse(old_inode_bh);
 	brelse(old_dir_bh);
 	brelse(new_dir_bh);
-	brelse(orphan_entry_bh);
-	brelse(insert_entry_bh);
 
 	mlog_exit(status);
 
diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index b4ca591..8439f6b 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -2197,26 +2197,29 @@ static int ocfs2_get_suballoc_slot_bit(struct ocfs2_super *osb, u64 blkno,
 	struct buffer_head *inode_bh = NULL;
 	struct ocfs2_dinode *inode_fe;
 
-	mlog_entry("blkno: %llu\n", blkno);
+	mlog_entry("blkno: %llu\n", (unsigned long long)blkno);
 
 	/* dirty read disk */
 	status = ocfs2_read_blocks_sync(osb, blkno, 1, &inode_bh);
 	if (status < 0) {
-		mlog(ML_ERROR, "read block %llu failed %d\n", blkno, status);
+		mlog(ML_ERROR, "read block %llu failed %d\n",
+		     (unsigned long long)blkno, status);
 		goto bail;
 	}
 
 	inode_fe = (struct ocfs2_dinode *) inode_bh->b_data;
 	if (!OCFS2_IS_VALID_DINODE(inode_fe)) {
-		mlog(ML_ERROR, "invalid inode %llu requested\n", blkno);
+		mlog(ML_ERROR, "invalid inode %llu requested\n",
+		     (unsigned long long)blkno);
 		status = -EINVAL;
 		goto bail;
 	}
 
-	if (le16_to_cpu(inode_fe->i_suballoc_slot) != OCFS2_INVALID_SLOT &&
+	if (le16_to_cpu(inode_fe->i_suballoc_slot) != (u16)OCFS2_INVALID_SLOT &&
 	    (u32)le16_to_cpu(inode_fe->i_suballoc_slot) > osb->max_slots - 1) {
 		mlog(ML_ERROR, "inode %llu has invalid suballoc slot %u\n",
-		     blkno, (u32)le16_to_cpu(inode_fe->i_suballoc_slot));
+		     (unsigned long long)blkno,
+		     (u32)le16_to_cpu(inode_fe->i_suballoc_slot));
 		status = -EINVAL;
 		goto bail;
 	}
@@ -2251,7 +2254,8 @@ static int ocfs2_test_suballoc_bit(struct ocfs2_super *osb,
 	u64 bg_blkno;
 	int status;
 
-	mlog_entry("blkno: %llu bit: %u\n", blkno, (unsigned int)bit);
+	mlog_entry("blkno: %llu bit: %u\n", (unsigned long long)blkno,
+		   (unsigned int)bit);
 
 	alloc_fe = (struct ocfs2_dinode *)alloc_bh->b_data;
 	if ((bit + 1) > ocfs2_bits_per_group(&alloc_fe->id2.i_chain)) {
@@ -2266,7 +2270,8 @@ static int ocfs2_test_suballoc_bit(struct ocfs2_super *osb,
 	status = ocfs2_read_group_descriptor(suballoc, alloc_fe, bg_blkno,
 					     &group_bh);
 	if (status < 0) {
-		mlog(ML_ERROR, "read group %llu failed %d\n", bg_blkno, status);
+		mlog(ML_ERROR, "read group %llu failed %d\n",
+		     (unsigned long long)bg_blkno, status);
 		goto bail;
 	}
 
@@ -2300,7 +2305,7 @@ int ocfs2_test_inode_bit(struct ocfs2_super *osb, u64 blkno, int *res)
 	struct inode *inode_alloc_inode;
 	struct buffer_head *alloc_bh = NULL;
 
-	mlog_entry("blkno: %llu", blkno);
+	mlog_entry("blkno: %llu", (unsigned long long)blkno);
 
 	status = ocfs2_get_suballoc_slot_bit(osb, blkno, &suballoc_slot,
 					     &suballoc_bit);

-- 

"I don't even butter my bread; I consider that cooking."
         - Katherine Cebrian

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
