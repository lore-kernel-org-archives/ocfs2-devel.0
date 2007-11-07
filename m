From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Wed Nov  7 09:41:25 2007
Subject: [Ocfs2-devel] [git patches] ocfs2 fixes
Message-ID: <20071107174120.GD28607@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

Hi Linus,
	Here are some Ocfs2 patches - bug fixes, performance fixes and small
cleanups.
	--Mark

Please pull from 'upstream-linus' branch of
git://git.kernel.org/pub/scm/linux/kernel/git/mfasheh/ocfs2.git upstream-linus

to receive the following updates:

 fs/ocfs2/alloc.c             |    2 +-
 fs/ocfs2/aops.c              |   22 ++++++++++++++++++++++
 fs/ocfs2/cluster/heartbeat.c |    2 +-
 fs/ocfs2/dcache.c            |    2 +-
 fs/ocfs2/dir.c               |    6 +++---
 fs/ocfs2/dlmglue.c           |   25 ++++++++++---------------
 fs/ocfs2/file.c              |   26 +++++++++++++++++++++++++-
 fs/ocfs2/namei.c             |   13 ++++++++++---
 8 files changed, 73 insertions(+), 25 deletions(-)

Adrian Bunk (1):
      [2.6 patch] make ocfs2_find_entry_el() static

Jan Kara (1):
      Fix possibly too long write in o2hb_setup_one_bio()

Mark Fasheh (4):
      ocfs2: Create locks at initially requested level
      ocfs2: Re-order iput in ocfs2_drop_dentry_lock
      ocfs2: Commit journal on sync writes
      ocfs2: fix write() performance regression

Roel Kluin (1):
      Fix priority mistakes in fs/ocfs2/{alloc.c, dlmglue.c}

Srinivas Eeda (1):
      ocfs2: fix rename vs unlink race

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 4ba7f0b..ce62c15 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -3946,7 +3946,7 @@ static int __ocfs2_mark_extent_written(struct inode *inode,
 	struct ocfs2_merge_ctxt ctxt;
 	struct ocfs2_extent_list *rightmost_el;
 
-	if (!rec->e_flags & OCFS2_EXT_UNWRITTEN) {
+	if (!(rec->e_flags & OCFS2_EXT_UNWRITTEN)) {
 		ret = -EIO;
 		mlog_errno(ret);
 		goto out;
diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index c69c1b3..556e34c 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -729,6 +729,27 @@ static void ocfs2_clear_page_regions(struct page *page,
 }
 
 /*
+ * Nonsparse file systems fully allocate before we get to the write
+ * code. This prevents ocfs2_write() from tagging the write as an
+ * allocating one, which means ocfs2_map_page_blocks() might try to
+ * read-in the blocks at the tail of our file. Avoid reading them by
+ * testing i_size against each block offset.
+ */
+static int ocfs2_should_read_blk(struct inode *inode, struct page *page,
+				 unsigned int block_start)
+{
+	u64 offset = page_offset(page) + block_start;
+
+	if (ocfs2_sparse_alloc(OCFS2_SB(inode->i_sb)))
+		return 1;
+
+	if (i_size_read(inode) > offset)
+		return 1;
+
+	return 0;
+}
+
+/*
  * Some of this taken from block_prepare_write(). We already have our
  * mapping by now though, and the entire write will be allocating or
  * it won't, so not much need to use BH_New.
@@ -781,6 +802,7 @@ int ocfs2_map_page_blocks(struct page *page, u64 *p_blkno,
 				set_buffer_uptodate(bh);
 		} else if (!buffer_uptodate(bh) && !buffer_delay(bh) &&
 			   !buffer_new(bh) &&
+			   ocfs2_should_read_blk(inode, page, block_start) &&
 			   (block_start < from || block_end > to)) {
 			ll_rw_block(READ, 1, &bh);
 			*wait_bh++=bh;
diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index 9cc7c04..f02ccb3 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -267,7 +267,7 @@ static struct bio *o2hb_setup_one_bio(struct o2hb_region *reg,
 		current_page = cs / spp;
 		page = reg->hr_slot_data[current_page];
 
-		vec_len = min(PAGE_CACHE_SIZE,
+		vec_len = min(PAGE_CACHE_SIZE - vec_start,
 			      (max_slots-cs) * (PAGE_CACHE_SIZE/spp) );
 
 		mlog(ML_HB_BIO, "page %d, vec_len = %u, vec_start = %u\n",
diff --git a/fs/ocfs2/dcache.c b/fs/ocfs2/dcache.c
index 3094ddb..1957a5e 100644
--- a/fs/ocfs2/dcache.c
+++ b/fs/ocfs2/dcache.c
@@ -318,9 +318,9 @@ out_attach:
 static void ocfs2_drop_dentry_lock(struct ocfs2_super *osb,
 				   struct ocfs2_dentry_lock *dl)
 {
+	iput(dl->dl_inode);
 	ocfs2_simple_drop_lockres(osb, &dl->dl_lockres);
 	ocfs2_lock_res_free(&dl->dl_lockres);
-	iput(dl->dl_inode);
 	kfree(dl);
 }
 
diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index 6a2f143..63b28fd 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -208,9 +208,9 @@ out:
 	return NULL;
 }
 
-struct buffer_head *ocfs2_find_entry_el(const char *name, int namelen,
-					struct inode *dir,
-					struct ocfs2_dir_entry **res_dir)
+static struct buffer_head *ocfs2_find_entry_el(const char *name, int namelen,
+					       struct inode *dir,
+					       struct ocfs2_dir_entry **res_dir)
 {
 	struct super_block *sb;
 	struct buffer_head *bh_use[NAMEI_RA_SIZE];
diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 41c76ff..4e97dcc 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -670,7 +670,7 @@ static inline void ocfs2_generic_handle_attach_action(struct ocfs2_lock_res *loc
 {
 	mlog_entry_void();
 
-	BUG_ON((!lockres->l_flags & OCFS2_LOCK_BUSY));
+	BUG_ON((!(lockres->l_flags & OCFS2_LOCK_BUSY)));
 	BUG_ON(lockres->l_flags & OCFS2_LOCK_ATTACHED);
 
 	if (lockres->l_requested > LKM_NLMODE &&
@@ -980,18 +980,6 @@ again:
 		goto unlock;
 	}
 
-	if (!(lockres->l_flags & OCFS2_LOCK_ATTACHED)) {
-		/* lock has not been created yet. */
-		spin_unlock_irqrestore(&lockres->l_lock, flags);
-
-		ret = ocfs2_lock_create(osb, lockres, LKM_NLMODE, 0);
-		if (ret < 0) {
-			mlog_errno(ret);
-			goto out;
-		}
-		goto again;
-	}
-
 	if (lockres->l_flags & OCFS2_LOCK_BLOCKED &&
 	    !ocfs2_may_continue_on_blocked_lock(lockres, level)) {
 		/* is the lock is currently blocked on behalf of
@@ -1006,7 +994,14 @@ again:
 			mlog(ML_ERROR, "lockres %s has action %u pending\n",
 			     lockres->l_name, lockres->l_action);
 
-		lockres->l_action = OCFS2_AST_CONVERT;
+		if (!(lockres->l_flags & OCFS2_LOCK_ATTACHED)) {
+			lockres->l_action = OCFS2_AST_ATTACH;
+			lkm_flags &= ~LKM_CONVERT;
+		} else {
+			lockres->l_action = OCFS2_AST_CONVERT;
+			lkm_flags |= LKM_CONVERT;
+		}
+
 		lockres->l_requested = level;
 		lockres_or_flags(lockres, OCFS2_LOCK_BUSY);
 		spin_unlock_irqrestore(&lockres->l_lock, flags);
@@ -1021,7 +1016,7 @@ again:
 		status = dlmlock(osb->dlm,
 				 level,
 				 &lockres->l_lksb,
-				 lkm_flags|LKM_CONVERT,
+				 lkm_flags,
 				 lockres->l_name,
 				 OCFS2_LOCK_ID_MAX_LEN - 1,
 				 ocfs2_locking_ast,
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index f92fe91..bbac7cd 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -1891,9 +1891,11 @@ static ssize_t ocfs2_file_aio_write(struct kiocb *iocb,
 	ssize_t written = 0;
 	size_t ocount;		/* original count */
 	size_t count;		/* after file limit checks */
-	loff_t *ppos = &iocb->ki_pos;
+	loff_t old_size, *ppos = &iocb->ki_pos;
+	u32 old_clusters;
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file->f_path.dentry->d_inode;
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 
 	mlog_entry("(0x%p, %u, '%.*s')\n", file,
 		   (unsigned int)nr_segs,
@@ -1949,6 +1951,13 @@ relock:
 		goto relock;
 	}
 
+	/*
+	 * To later detect whether a journal commit for sync writes is
+	 * necessary, we sample i_size, and cluster count here.
+	 */
+	old_size = i_size_read(inode);
+	old_clusters = OCFS2_I(inode)->ip_clusters;
+
 	/* communicate with ocfs2_dio_end_io */
 	ocfs2_iocb_set_rw_locked(iocb, rw_level);
 
@@ -1978,6 +1987,21 @@ out_dio:
 	/* buffered aio wouldn't have proper lock coverage today */
 	BUG_ON(ret == -EIOCBQUEUED && !(file->f_flags & O_DIRECT));
 
+	if ((file->f_flags & O_SYNC && !direct_io) || IS_SYNC(inode)) {
+		/*
+		 * The generic write paths have handled getting data
+		 * to disk, but since we don't make use of the dirty
+		 * inode list, a manual journal commit is necessary
+		 * here.
+		 */
+		if (old_size != i_size_read(inode) ||
+		    old_clusters != OCFS2_I(inode)->ip_clusters) {
+			ret = journal_force_commit(osb->journal->j_journal);
+			if (ret < 0)
+				written = ret;
+		}
+	}
+
 	/* 
 	 * deep in g_f_a_w_n()->ocfs2_direct_IO we pass in a ocfs2_dio_end_io
 	 * function pointer which is called when o_direct io completes so that
diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 7292590..989ac27 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -1105,9 +1105,16 @@ static int ocfs2_rename(struct inode *old_dir,
 		goto bail;
 	}
 
-	if (!new_de && new_inode)
-		mlog(ML_ERROR, "inode %lu does not exist in it's parent "
-		     "directory!", new_inode->i_ino);
+	if (!new_de && new_inode) {
+		/*
+		 * Target was unlinked by another node while we were
+		 * waiting to get to ocfs2_rename(). There isn't
+		 * anything we can do here to help the situation, so
+		 * bubble up the appropriate error.
+		 */
+		status = -ENOENT;
+		goto bail;
+	}
 
 	/* In case we need to overwrite an existing file, we blow it
 	 * away first */
