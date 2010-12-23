From: Tao Ma <tm@tao.ma>
Date: Thu, 23 Dec 2010 15:30:45 +0800
Subject: [Ocfs2-devel] [PATCH 02/34] ocfs2: Remove ENTRY from masklog.
In-Reply-To: <4D12F7E7.1090204@tao.ma>
References: <4D12F7E7.1090204@tao.ma>
Message-ID: <1293089477-5019-2-git-send-email-tm@tao.ma>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Tao Ma <tao.ma@oracle.com>

ENTRY is used to record the entry of a function.
But because it is added in so many functions, if we enable it,
the system logs get filled up quickly and cause too much I/O.
So actually no one can open it for a production system or even
for a test.

So for mlog_entry_void, we just remove it.
for mlog_entry(...), we replace it with mlog(0,...), and they
will be replace by trace event later.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/alloc.c             |   28 +--------------
 fs/ocfs2/aops.c              |   16 ++++-----
 fs/ocfs2/buffer_head_io.c    |   10 ++---
 fs/ocfs2/cluster/heartbeat.c |    2 -
 fs/ocfs2/cluster/masklog.c   |    1 -
 fs/ocfs2/cluster/masklog.h   |   13 +------
 fs/ocfs2/dcache.c            |    4 +-
 fs/ocfs2/dir.c               |   20 +++--------
 fs/ocfs2/dlm/dlmast.c        |   19 ++--------
 fs/ocfs2/dlm/dlmconvert.c    |    6 ++--
 fs/ocfs2/dlm/dlmdomain.c     |    8 ++--
 fs/ocfs2/dlm/dlmlock.c       |   10 ++----
 fs/ocfs2/dlm/dlmmaster.c     |    6 +---
 fs/ocfs2/dlm/dlmrecovery.c   |    4 --
 fs/ocfs2/dlm/dlmthread.c     |    8 ++--
 fs/ocfs2/dlm/dlmunlock.c     |    4 +--
 fs/ocfs2/dlmglue.c           |   78 ------------------------------------------
 fs/ocfs2/export.c            |   12 +++---
 fs/ocfs2/extent_map.c        |    8 ++--
 fs/ocfs2/file.c              |   73 +++++++++++++++++----------------------
 fs/ocfs2/inode.c             |   28 ++++++---------
 fs/ocfs2/journal.c           |   43 ++++++----------------
 fs/ocfs2/localalloc.c        |   26 +++-----------
 fs/ocfs2/mmap.c              |    2 +-
 fs/ocfs2/namei.c             |   74 +++++++++++++++++++---------------------
 fs/ocfs2/quota_global.c      |   14 +++-----
 fs/ocfs2/quota_local.c       |    2 +-
 fs/ocfs2/resize.c            |    8 +---
 fs/ocfs2/slot_map.c          |    2 -
 fs/ocfs2/suballoc.c          |   35 +++---------------
 fs/ocfs2/super.c             |   32 +++--------------
 fs/ocfs2/symlink.c           |    6 ---
 fs/ocfs2/xattr.c             |    4 +-
 33 files changed, 168 insertions(+), 438 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index cd9d1bc..c12e9d8 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -965,8 +965,6 @@ int ocfs2_num_free_extents(struct ocfs2_super *osb,
 	struct buffer_head *eb_bh = NULL;
 	u64 last_eb_blk = 0;
 
-	mlog_entry_void();
-
 	el = et->et_root_el;
 	last_eb_blk = ocfs2_et_get_last_eb_blk(et);
 
@@ -1010,8 +1008,6 @@ static int ocfs2_create_new_meta_bhs(handle_t *handle,
 		OCFS2_SB(ocfs2_metadata_cache_get_super(et->et_ci));
 	struct ocfs2_extent_block *eb;
 
-	mlog_entry_void();
-
 	count = 0;
 	while (count < wanted) {
 		status = ocfs2_claim_metadata(handle,
@@ -1173,8 +1169,6 @@ static int ocfs2_add_branch(handle_t *handle,
 	struct ocfs2_extent_list  *el;
 	u32 new_cpos, root_end;
 
-	mlog_entry_void();
-
 	BUG_ON(!last_eb_bh || !*last_eb_bh);
 
 	if (eb_bh) {
@@ -1353,8 +1347,6 @@ static int ocfs2_shift_tree_depth(handle_t *handle,
 	struct ocfs2_extent_list  *root_el;
 	struct ocfs2_extent_list  *eb_el;
 
-	mlog_entry_void();
-
 	status = ocfs2_create_new_meta_bhs(handle, et, 1, meta_ac,
 					   &new_eb_bh);
 	if (status < 0) {
@@ -1446,8 +1438,6 @@ static int ocfs2_find_branch_target(struct ocfs2_extent_tree *et,
 	struct buffer_head *bh = NULL;
 	struct buffer_head *lowest_bh = NULL;
 
-	mlog_entry_void();
-
 	*target_bh = NULL;
 
 	el = et->et_root_el;
@@ -5795,8 +5785,8 @@ int ocfs2_truncate_log_append(struct ocfs2_super *osb,
 	struct ocfs2_dinode *di;
 	struct ocfs2_truncate_log *tl;
 
-	mlog_entry("start_blk = %llu, num_clusters = %u\n",
-		   (unsigned long long)start_blk, num_clusters);
+	mlog(0, "start_blk = %llu, num_clusters = %u\n",
+	     (unsigned long long)start_blk, num_clusters);
 
 	BUG_ON(mutex_trylock(&tl_inode->i_mutex));
 
@@ -5877,8 +5867,6 @@ static int ocfs2_replay_truncate_records(struct ocfs2_super *osb,
 	struct inode *tl_inode = osb->osb_tl_inode;
 	struct buffer_head *tl_bh = osb->osb_tl_bh;
 
-	mlog_entry_void();
-
 	di = (struct ocfs2_dinode *) tl_bh->b_data;
 	tl = &di->id2.i_dealloc;
 	i = le16_to_cpu(tl->tl_used) - 1;
@@ -5946,8 +5934,6 @@ int __ocfs2_flush_truncate_log(struct ocfs2_super *osb)
 	struct ocfs2_dinode *di;
 	struct ocfs2_truncate_log *tl;
 
-	mlog_entry_void();
-
 	BUG_ON(mutex_trylock(&tl_inode->i_mutex));
 
 	di = (struct ocfs2_dinode *) tl_bh->b_data;
@@ -6029,8 +6015,6 @@ static void ocfs2_truncate_log_worker(struct work_struct *work)
 		container_of(work, struct ocfs2_super,
 			     osb_truncate_log_wq.work);
 
-	mlog_entry_void();
-
 	status = ocfs2_flush_truncate_log(osb);
 	if (status < 0)
 		mlog_errno(status);
@@ -6171,8 +6155,6 @@ int ocfs2_complete_truncate_log_recovery(struct ocfs2_super *osb,
 	struct inode *tl_inode = osb->osb_tl_inode;
 	struct ocfs2_truncate_log *tl;
 
-	mlog_entry_void();
-
 	if (OCFS2_I(tl_inode)->ip_blkno == le64_to_cpu(tl_copy->i_blkno)) {
 		mlog(ML_ERROR, "Asked to recover my own truncate log!\n");
 		return -EINVAL;
@@ -6225,8 +6207,6 @@ void ocfs2_truncate_log_shutdown(struct ocfs2_super *osb)
 	int status;
 	struct inode *tl_inode = osb->osb_tl_inode;
 
-	mlog_entry_void();
-
 	if (tl_inode) {
 		cancel_delayed_work(&osb->osb_truncate_log_wq);
 		flush_workqueue(ocfs2_wq);
@@ -6248,8 +6228,6 @@ int ocfs2_truncate_log_init(struct ocfs2_super *osb)
 	struct inode *tl_inode = NULL;
 	struct buffer_head *tl_bh = NULL;
 
-	mlog_entry_void();
-
 	status = ocfs2_get_truncate_log_info(osb,
 					     osb->slot_num,
 					     &tl_inode,
@@ -7002,8 +6980,6 @@ int ocfs2_commit_truncate(struct ocfs2_super *osb,
 	struct ocfs2_extent_tree et;
 	struct ocfs2_cached_dealloc_ctxt dealloc;
 
-	mlog_entry_void();
-
 	ocfs2_init_dinode_extent_tree(&et, INODE_CACHE(inode), di_bh);
 	ocfs2_init_dealloc_ctxt(&dealloc);
 
diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index f1e962c..9bff526 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -59,8 +59,8 @@ static int ocfs2_symlink_get_block(struct inode *inode, sector_t iblock,
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	void *kaddr;
 
-	mlog_entry("(0x%p, %llu, 0x%p, %d)\n", inode,
-		   (unsigned long long)iblock, bh_result, create);
+	mlog(0, "(0x%p, %llu, 0x%p, %d)\n", inode,
+	     (unsigned long long)iblock, bh_result, create);
 
 	BUG_ON(ocfs2_inode_is_fast_symlink(inode));
 
@@ -136,8 +136,8 @@ int ocfs2_get_block(struct inode *inode, sector_t iblock,
 	u64 p_blkno, count, past_eof;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 
-	mlog_entry("(0x%p, %llu, 0x%p, %d)\n", inode,
-		   (unsigned long long)iblock, bh_result, create);
+	mlog(0, "(0x%p, %llu, 0x%p, %d)\n", inode,
+	     (unsigned long long)iblock, bh_result, create);
 
 	if (OCFS2_I(inode)->ip_flags & OCFS2_INODE_SYSTEM_FILE)
 		mlog(ML_NOTICE, "get_block on system inode 0x%p (%lu)\n",
@@ -278,7 +278,7 @@ static int ocfs2_readpage(struct file *file, struct page *page)
 	loff_t start = (loff_t)page->index << PAGE_CACHE_SHIFT;
 	int ret, unlock = 1;
 
-	mlog_entry("(0x%p, %lu)\n", file, (page ? page->index : 0));
+	mlog(0, "(0x%p, %lu)\n", file, (page ? page->index : 0));
 
 	ret = ocfs2_inode_lock_with_page(inode, NULL, 0, page);
 	if (ret != 0) {
@@ -398,7 +398,7 @@ static int ocfs2_writepage(struct page *page, struct writeback_control *wbc)
 {
 	int ret;
 
-	mlog_entry("(0x%p)\n", page);
+	mlog(0, "(0x%p)\n", page);
 
 	ret = block_write_full_page(page, ocfs2_get_block, wbc);
 
@@ -450,7 +450,7 @@ static sector_t ocfs2_bmap(struct address_space *mapping, sector_t block)
 	int err = 0;
 	struct inode *inode = mapping->host;
 
-	mlog_entry("(block = %llu)\n", (unsigned long long)block);
+	mlog(0, "(block = %llu)\n", (unsigned long long)block);
 
 	/* We don't need to lock journal system files, since they aren't
 	 * accessed concurrently from multiple nodes.
@@ -615,8 +615,6 @@ static ssize_t ocfs2_direct_IO(int rw,
 	struct inode *inode = file->f_path.dentry->d_inode->i_mapping->host;
 	int ret;
 
-	mlog_entry_void();
-
 	/*
 	 * Fallback to buffered I/O if we see an inode without
 	 * extents.
diff --git a/fs/ocfs2/buffer_head_io.c b/fs/ocfs2/buffer_head_io.c
index f9d5d3f..024bd45 100644
--- a/fs/ocfs2/buffer_head_io.c
+++ b/fs/ocfs2/buffer_head_io.c
@@ -55,8 +55,8 @@ int ocfs2_write_block(struct ocfs2_super *osb, struct buffer_head *bh,
 {
 	int ret = 0;
 
-	mlog_entry("(bh->b_blocknr = %llu, ci=%p)\n",
-		   (unsigned long long)bh->b_blocknr, ci);
+	mlog(0, "(bh->b_blocknr = %llu, ci=%p)\n",
+	     (unsigned long long)bh->b_blocknr, ci);
 
 	BUG_ON(bh->b_blocknr < OCFS2_SUPER_BLOCK_BLKNO);
 	BUG_ON(buffer_jbd(bh));
@@ -186,8 +186,8 @@ int ocfs2_read_blocks(struct ocfs2_caching_info *ci, u64 block, int nr,
 	struct buffer_head *bh;
 	struct super_block *sb = ocfs2_metadata_cache_get_super(ci);
 
-	mlog_entry("(ci=%p, block=(%llu), nr=(%d), flags=%d)\n",
-		   ci, (unsigned long long)block, nr, flags);
+	mlog(0, "(ci=%p, block=(%llu), nr=(%d), flags=%d)\n",
+	     ci, (unsigned long long)block, nr, flags);
 
 	BUG_ON(!ci);
 	BUG_ON((flags & OCFS2_BH_READAHEAD) &&
@@ -408,8 +408,6 @@ int ocfs2_write_super_or_backup(struct ocfs2_super *osb,
 	int ret = 0;
 	struct ocfs2_dinode *di = (struct ocfs2_dinode *)bh->b_data;
 
-	mlog_entry_void();
-
 	BUG_ON(buffer_jbd(bh));
 	ocfs2_check_super_or_backup(osb->sb, bh->b_blocknr);
 
diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index 9f26ac9..4301242 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -1603,8 +1603,6 @@ static int o2hb_populate_slot_data(struct o2hb_region *reg)
 	struct o2hb_disk_slot *slot;
 	struct o2hb_disk_heartbeat_block *hb_block;
 
-	mlog_entry_void();
-
 	ret = o2hb_read_slots(reg, reg->hr_blocks);
 	if (ret) {
 		mlog_errno(ret);
diff --git a/fs/ocfs2/cluster/masklog.c b/fs/ocfs2/cluster/masklog.c
index c7fba39..b9ff806 100644
--- a/fs/ocfs2/cluster/masklog.c
+++ b/fs/ocfs2/cluster/masklog.c
@@ -80,7 +80,6 @@ struct mlog_attribute {
 }
 
 static struct mlog_attribute mlog_attrs[MLOG_MAX_BITS] = {
-	define_mask(ENTRY),
 	define_mask(EXIT),
 	define_mask(TCP),
 	define_mask(MSG),
diff --git a/fs/ocfs2/cluster/masklog.h b/fs/ocfs2/cluster/masklog.h
index ea2ed9f..72d3599 100644
--- a/fs/ocfs2/cluster/masklog.h
+++ b/fs/ocfs2/cluster/masklog.h
@@ -82,7 +82,6 @@
 
 /* bits that are frequently given and infrequently matched in the low word */
 /* NOTE: If you add a flag, you need to also update mlog.c! */
-#define ML_ENTRY	0x0000000000000001ULL /* func call entry */
 #define ML_EXIT		0x0000000000000002ULL /* func call exit */
 #define ML_TCP		0x0000000000000004ULL /* net cluster/tcp.c */
 #define ML_MSG		0x0000000000000008ULL /* net network messages */
@@ -123,7 +122,7 @@
 #define ML_CLUSTER	0x0000001000000000ULL /* cluster stack */
 
 #define MLOG_INITIAL_AND_MASK (ML_ERROR|ML_NOTICE)
-#define MLOG_INITIAL_NOT_MASK (ML_ENTRY|ML_EXIT)
+#define MLOG_INITIAL_NOT_MASK (ML_EXIT)
 #ifndef MLOG_MASK_PREFIX
 #define MLOG_MASK_PREFIX 0
 #endif
@@ -222,14 +221,6 @@ extern struct mlog_bits mlog_and_bits, mlog_not_bits;
 } while (0)
 
 #if defined(CONFIG_OCFS2_DEBUG_MASKLOG)
-#define mlog_entry(fmt, args...) do {					\
-	mlog(ML_ENTRY, "ENTRY:" fmt , ##args);				\
-} while (0)
-
-#define mlog_entry_void() do {						\
-	mlog(ML_ENTRY, "ENTRY:\n");					\
-} while (0)
-
 /*
  * We disable this for sparse.
  */
@@ -266,8 +257,6 @@ extern struct mlog_bits mlog_and_bits, mlog_not_bits;
 	mlog(ML_EXIT, "EXIT\n");					\
 } while (0)
 #else
-#define mlog_entry(...)  do { } while (0)
-#define mlog_entry_void(...)  do { } while (0)
 #define mlog_exit(...)  do { } while (0)
 #define mlog_exit_ptr(...)  do { } while (0)
 #define mlog_exit_void(...)  do { } while (0)
diff --git a/fs/ocfs2/dcache.c b/fs/ocfs2/dcache.c
index 895532a..351f3d0 100644
--- a/fs/ocfs2/dcache.c
+++ b/fs/ocfs2/dcache.c
@@ -56,8 +56,8 @@ static int ocfs2_dentry_revalidate(struct dentry *dentry,
 	int ret = 0;    /* if all else fails, just return false */
 	struct ocfs2_super *osb = OCFS2_SB(dentry->d_sb);
 
-	mlog_entry("(0x%p, '%.*s')\n", dentry,
-		   dentry->d_name.len, dentry->d_name.name);
+	mlog(0, "(0x%p, '%.*s')\n", dentry,
+	     dentry->d_name.len, dentry->d_name.name);
 
 	/* For a negative dentry -
 	 * check the generation number of the parent and compare with the
diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index c49f6de..7483e9e 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -367,8 +367,6 @@ static int inline ocfs2_search_dirblock(struct buffer_head *bh,
 	int de_len;
 	int ret = 0;
 
-	mlog_entry_void();
-
 	de_buf = first_de;
 	dlimit = de_buf + bytes;
 
@@ -706,8 +704,6 @@ static struct buffer_head *ocfs2_find_entry_el(const char *name, int namelen,
 	int num = 0;
 	int nblocks, i, err;
 
-	mlog_entry_void();
-
 	sb = dir->i_sb;
 
 	nblocks = i_size_read(dir) >> sb->s_blocksize_bits;
@@ -1166,7 +1162,7 @@ static int __ocfs2_delete_entry(handle_t *handle, struct inode *dir,
 	int i, status = -ENOENT;
 	ocfs2_journal_access_func access = ocfs2_journal_access_db;
 
-	mlog_entry("(0x%p, 0x%p, 0x%p, 0x%p)\n", handle, dir, de_del, bh);
+	mlog(0, "(0x%p, 0x%p, 0x%p, 0x%p)\n", handle, dir, de_del, bh);
 
 	if (OCFS2_I(dir)->ip_dyn_features & OCFS2_INLINE_DATA_FL)
 		access = ocfs2_journal_access_di;
@@ -1632,8 +1628,6 @@ int __ocfs2_add_entry(handle_t *handle,
 	struct buffer_head *insert_bh = lookup->dl_leaf_bh;
 	char *data_start = insert_bh->b_data;
 
-	mlog_entry_void();
-
 	if (!namelen)
 		return -EINVAL;
 
@@ -2028,8 +2022,8 @@ int ocfs2_readdir(struct file * filp, void * dirent, filldir_t filldir)
 	struct inode *inode = filp->f_path.dentry->d_inode;
 	int lock_level = 0;
 
-	mlog_entry("dirino=%llu\n",
-		   (unsigned long long)OCFS2_I(inode)->ip_blkno);
+	mlog(0, "dirino=%llu\n",
+	     (unsigned long long)OCFS2_I(inode)->ip_blkno);
 
 	error = ocfs2_inode_lock_atime(inode, filp->f_vfsmnt, &lock_level);
 	if (lock_level && error >= 0) {
@@ -2114,8 +2108,8 @@ int ocfs2_check_dir_for_entry(struct inode *dir,
 	int ret;
 	struct ocfs2_dir_lookup_result lookup = { NULL, };
 
-	mlog_entry("dir %llu, name '%.*s'\n",
-		   (unsigned long long)OCFS2_I(dir)->ip_blkno, namelen, name);
+	mlog(0, "dir %llu, name '%.*s'\n",
+	     (unsigned long long)OCFS2_I(dir)->ip_blkno, namelen, name);
 
 	ret = -EEXIST;
 	if (ocfs2_find_entry(name, namelen, dir, &lookup) == 0)
@@ -2324,8 +2318,6 @@ static int ocfs2_fill_new_dir_el(struct ocfs2_super *osb,
 	struct buffer_head *new_bh = NULL;
 	struct ocfs2_dir_entry *de;
 
-	mlog_entry_void();
-
 	if (ocfs2_new_dir_wants_trailer(inode))
 		size = ocfs2_dir_trailer_blk_off(parent->i_sb);
 
@@ -3268,8 +3260,6 @@ static int ocfs2_extend_dir(struct ocfs2_super *osb,
 	struct ocfs2_extent_tree et;
 	struct buffer_head *dx_root_bh = lookup->dl_dx_root_bh;
 
-	mlog_entry_void();
-
 	if (OCFS2_I(dir)->ip_dyn_features & OCFS2_INLINE_DATA_FL) {
 		/*
 		 * This would be a code error as an inline directory should
diff --git a/fs/ocfs2/dlm/dlmast.c b/fs/ocfs2/dlm/dlmast.c
index f449991..6526292 100644
--- a/fs/ocfs2/dlm/dlmast.c
+++ b/fs/ocfs2/dlm/dlmast.c
@@ -90,8 +90,6 @@ static int dlm_should_cancel_bast(struct dlm_ctxt *dlm, struct dlm_lock *lock)
 
 void __dlm_queue_ast(struct dlm_ctxt *dlm, struct dlm_lock *lock)
 {
-	mlog_entry_void();
-
 	BUG_ON(!dlm);
 	BUG_ON(!lock);
 
@@ -134,8 +132,6 @@ void __dlm_queue_ast(struct dlm_ctxt *dlm, struct dlm_lock *lock)
 
 void dlm_queue_ast(struct dlm_ctxt *dlm, struct dlm_lock *lock)
 {
-	mlog_entry_void();
-
 	BUG_ON(!dlm);
 	BUG_ON(!lock);
 
@@ -147,8 +143,6 @@ void dlm_queue_ast(struct dlm_ctxt *dlm, struct dlm_lock *lock)
 
 void __dlm_queue_bast(struct dlm_ctxt *dlm, struct dlm_lock *lock)
 {
-	mlog_entry_void();
-
 	BUG_ON(!dlm);
 	BUG_ON(!lock);
 	assert_spin_locked(&dlm->ast_lock);
@@ -167,8 +161,6 @@ void __dlm_queue_bast(struct dlm_ctxt *dlm, struct dlm_lock *lock)
 
 void dlm_queue_bast(struct dlm_ctxt *dlm, struct dlm_lock *lock)
 {
-	mlog_entry_void();
-
 	BUG_ON(!dlm);
 	BUG_ON(!lock);
 
@@ -213,8 +205,6 @@ void dlm_do_local_ast(struct dlm_ctxt *dlm, struct dlm_lock_resource *res,
 	dlm_astlockfunc_t *fn;
 	struct dlm_lockstatus *lksb;
 
-	mlog_entry_void();
-
 	lksb = lock->lksb;
 	fn = lock->ast;
 	BUG_ON(lock->ml.node != dlm->node_num);
@@ -231,8 +221,6 @@ int dlm_do_remote_ast(struct dlm_ctxt *dlm, struct dlm_lock_resource *res,
 	struct dlm_lockstatus *lksb;
 	int lksbflags;
 
-	mlog_entry_void();
-
 	lksb = lock->lksb;
 	BUG_ON(lock->ml.node == dlm->node_num);
 
@@ -250,7 +238,6 @@ void dlm_do_local_bast(struct dlm_ctxt *dlm, struct dlm_lock_resource *res,
 {
 	dlm_bastlockfunc_t *fn = lock->bast;
 
-	mlog_entry_void();
 	BUG_ON(lock->ml.node != dlm->node_num);
 
 	(*fn)(lock->astdata, blocked_type);
@@ -426,9 +413,9 @@ int dlm_send_proxy_ast_msg(struct dlm_ctxt *dlm, struct dlm_lock_resource *res,
 	size_t veclen = 1;
 	int status;
 
-	mlog_entry("res %.*s, to=%u, type=%d, blocked_type=%d\n",
-		   res->lockname.len, res->lockname.name, lock->ml.node,
-		   msg_type, blocked_type);
+	mlog(0, "res %.*s, to=%u, type=%d, blocked_type=%d\n",
+	     res->lockname.len, res->lockname.name, lock->ml.node,
+	     msg_type, blocked_type);
 
 	memset(&past, 0, sizeof(struct dlm_proxy_ast));
 	past.node_idx = dlm->node_num;
diff --git a/fs/ocfs2/dlm/dlmconvert.c b/fs/ocfs2/dlm/dlmconvert.c
index 9f30491..29a886d 100644
--- a/fs/ocfs2/dlm/dlmconvert.c
+++ b/fs/ocfs2/dlm/dlmconvert.c
@@ -128,8 +128,8 @@ static enum dlm_status __dlmconvert_master(struct dlm_ctxt *dlm,
 
 	assert_spin_locked(&res->spinlock);
 
-	mlog_entry("type=%d, convert_type=%d, new convert_type=%d\n",
-		   lock->ml.type, lock->ml.convert_type, type);
+	mlog(0, "type=%d, convert_type=%d, new convert_type=%d\n",
+	     lock->ml.type, lock->ml.convert_type, type);
 
 	spin_lock(&lock->spinlock);
 
@@ -353,7 +353,7 @@ static enum dlm_status dlm_send_remote_convert_request(struct dlm_ctxt *dlm,
 	struct kvec vec[2];
 	size_t veclen = 1;
 
-	mlog_entry("%.*s\n", res->lockname.len, res->lockname.name);
+	mlog(0, "%.*s\n", res->lockname.len, res->lockname.name);
 
 	memset(&convert, 0, sizeof(struct dlm_convert_lock));
 	convert.node_idx = dlm->node_num;
diff --git a/fs/ocfs2/dlm/dlmdomain.c b/fs/ocfs2/dlm/dlmdomain.c
index cc2aaa9..eddbc01 100644
--- a/fs/ocfs2/dlm/dlmdomain.c
+++ b/fs/ocfs2/dlm/dlmdomain.c
@@ -188,7 +188,7 @@ struct dlm_lock_resource * __dlm_lookup_lockres_full(struct dlm_ctxt *dlm,
 	struct hlist_head *bucket;
 	struct hlist_node *list;
 
-	mlog_entry("%.*s\n", len, name);
+	mlog(0, "%.*s\n", len, name);
 
 	assert_spin_locked(&dlm->spinlock);
 
@@ -222,7 +222,7 @@ struct dlm_lock_resource * __dlm_lookup_lockres(struct dlm_ctxt *dlm,
 {
 	struct dlm_lock_resource *res = NULL;
 
-	mlog_entry("%.*s\n", len, name);
+	mlog(0, "%.*s\n", len, name);
 
 	assert_spin_locked(&dlm->spinlock);
 
@@ -533,7 +533,7 @@ static int dlm_exit_domain_handler(struct o2net_msg *msg, u32 len, void *data,
 	unsigned int node;
 	struct dlm_exit_domain *exit_msg = (struct dlm_exit_domain *) msg->buf;
 
-	mlog_entry("%p %u %p", msg, len, data);
+	mlog(0, "%p %u %p", msg, len, data);
 
 	if (!dlm_grab(dlm))
 		return 0;
@@ -1555,7 +1555,7 @@ static int dlm_try_to_join_domain(struct dlm_ctxt *dlm)
 	struct domain_join_ctxt *ctxt;
 	enum dlm_query_join_response_code response = JOIN_DISALLOW;
 
-	mlog_entry("%p", dlm);
+	mlog(0, "%p", dlm);
 
 	ctxt = kzalloc(sizeof(*ctxt), GFP_KERNEL);
 	if (!ctxt) {
diff --git a/fs/ocfs2/dlm/dlmlock.c b/fs/ocfs2/dlm/dlmlock.c
index 69cf369..a0cc7e7 100644
--- a/fs/ocfs2/dlm/dlmlock.c
+++ b/fs/ocfs2/dlm/dlmlock.c
@@ -125,7 +125,7 @@ static enum dlm_status dlmlock_master(struct dlm_ctxt *dlm,
 	int call_ast = 0, kick_thread = 0;
 	enum dlm_status status = DLM_NORMAL;
 
-	mlog_entry("type=%d\n", lock->ml.type);
+	mlog(0, "type=%d\n", lock->ml.type);
 
 	spin_lock(&res->spinlock);
 	/* if called from dlm_create_lock_handler, need to
@@ -224,8 +224,8 @@ static enum dlm_status dlmlock_remote(struct dlm_ctxt *dlm,
 	enum dlm_status status = DLM_DENIED;
 	int lockres_changed = 1;
 
-	mlog_entry("type=%d\n", lock->ml.type);
-	mlog(0, "lockres %.*s, flags = 0x%x\n", res->lockname.len,
+	mlog(0, "type=%d, lockres %.*s, flags = 0x%x\n",
+	     lock->ml.type, res->lockname.len,
 	     res->lockname.name, flags);
 
 	spin_lock(&res->spinlock);
@@ -305,8 +305,6 @@ static enum dlm_status dlm_send_remote_lock_request(struct dlm_ctxt *dlm,
 	int tmpret, status = 0;
 	enum dlm_status ret;
 
-	mlog_entry_void();
-
 	memset(&create, 0, sizeof(create));
 	create.node_idx = dlm->node_num;
 	create.requested_type = lock->ml.type;
@@ -474,8 +472,6 @@ int dlm_create_lock_handler(struct o2net_msg *msg, u32 len, void *data,
 
 	BUG_ON(!dlm);
 
-	mlog_entry_void();
-
 	if (!dlm_grab(dlm))
 		return DLM_REJECTED;
 
diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
index f564b0e..dd2e8f0 100644
--- a/fs/ocfs2/dlm/dlmmaster.c
+++ b/fs/ocfs2/dlm/dlmmaster.c
@@ -426,8 +426,6 @@ static void dlm_mle_release(struct kref *kref)
 	struct dlm_master_list_entry *mle;
 	struct dlm_ctxt *dlm;
 
-	mlog_entry_void();
-
 	mle = container_of(kref, struct dlm_master_list_entry, mle_refs);
 	dlm = mle->dlm;
 
@@ -3106,8 +3104,6 @@ static int dlm_add_migration_mle(struct dlm_ctxt *dlm,
 
 	*oldmle = NULL;
 
-	mlog_entry_void();
-
 	assert_spin_locked(&dlm->spinlock);
 	assert_spin_locked(&dlm->master_lock);
 
@@ -3247,7 +3243,7 @@ void dlm_clean_master_list(struct dlm_ctxt *dlm, u8 dead_node)
 	struct hlist_node *list;
 	unsigned int i;
 
-	mlog_entry("dlm=%s, dead node=%u\n", dlm->name, dead_node);
+	mlog(0, "dlm=%s, dead node=%u\n", dlm->name, dead_node);
 top:
 	assert_spin_locked(&dlm->spinlock);
 
diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
index aaaffbc..6602b23 100644
--- a/fs/ocfs2/dlm/dlmrecovery.c
+++ b/fs/ocfs2/dlm/dlmrecovery.c
@@ -2083,8 +2083,6 @@ static void dlm_finish_local_lockres_recovery(struct dlm_ctxt *dlm,
 	struct hlist_head *bucket;
 	struct dlm_lock_resource *res, *next;
 
-	mlog_entry_void();
-
 	assert_spin_locked(&dlm->spinlock);
 
 	list_for_each_entry_safe(res, next, &dlm->reco.resources, recovering) {
@@ -2607,8 +2605,6 @@ static int dlm_send_begin_reco_message(struct dlm_ctxt *dlm, u8 dead_node)
 	int nodenum;
 	int status;
 
-	mlog_entry("%u\n", dead_node);
-
 	mlog(0, "%s: dead node is %u\n", dlm->name, dead_node);
 
 	spin_lock(&dlm->spinlock);
diff --git a/fs/ocfs2/dlm/dlmthread.c b/fs/ocfs2/dlm/dlmthread.c
index 2211acf..3081362 100644
--- a/fs/ocfs2/dlm/dlmthread.c
+++ b/fs/ocfs2/dlm/dlmthread.c
@@ -122,7 +122,7 @@ int __dlm_lockres_unused(struct dlm_lock_resource *res)
 void __dlm_lockres_calc_usage(struct dlm_ctxt *dlm,
 			      struct dlm_lock_resource *res)
 {
-	mlog_entry("%.*s\n", res->lockname.len, res->lockname.name);
+	mlog(0, "%.*s\n", res->lockname.len, res->lockname.name);
 
 	assert_spin_locked(&dlm->spinlock);
 	assert_spin_locked(&res->spinlock);
@@ -150,7 +150,7 @@ void __dlm_lockres_calc_usage(struct dlm_ctxt *dlm,
 void dlm_lockres_calc_usage(struct dlm_ctxt *dlm,
 			    struct dlm_lock_resource *res)
 {
-	mlog_entry("%.*s\n", res->lockname.len, res->lockname.name);
+	mlog(0, "%.*s\n", res->lockname.len, res->lockname.name);
 	spin_lock(&dlm->spinlock);
 	spin_lock(&res->spinlock);
 
@@ -453,7 +453,7 @@ leave:
 /* must have NO locks when calling this with res !=NULL * */
 void dlm_kick_thread(struct dlm_ctxt *dlm, struct dlm_lock_resource *res)
 {
-	mlog_entry("dlm=%p, res=%p\n", dlm, res);
+	mlog(0, "dlm=%p, res=%p\n", dlm, res);
 	if (res) {
 		spin_lock(&dlm->spinlock);
 		spin_lock(&res->spinlock);
@@ -466,7 +466,7 @@ void dlm_kick_thread(struct dlm_ctxt *dlm, struct dlm_lock_resource *res)
 
 void __dlm_dirty_lockres(struct dlm_ctxt *dlm, struct dlm_lock_resource *res)
 {
-	mlog_entry("dlm=%p, res=%p\n", dlm, res);
+	mlog(0, "dlm=%p, res=%p\n", dlm, res);
 
 	assert_spin_locked(&dlm->spinlock);
 	assert_spin_locked(&res->spinlock);
diff --git a/fs/ocfs2/dlm/dlmunlock.c b/fs/ocfs2/dlm/dlmunlock.c
index 817287c..850aa7e 100644
--- a/fs/ocfs2/dlm/dlmunlock.c
+++ b/fs/ocfs2/dlm/dlmunlock.c
@@ -317,7 +317,7 @@ static enum dlm_status dlm_send_remote_unlock_request(struct dlm_ctxt *dlm,
 	struct kvec vec[2];
 	size_t veclen = 1;
 
-	mlog_entry("%.*s\n", res->lockname.len, res->lockname.name);
+	mlog(0, "%.*s\n", res->lockname.len, res->lockname.name);
 
 	if (owner == dlm->node_num) {
 		/* ended up trying to contact ourself.  this means
@@ -588,8 +588,6 @@ enum dlm_status dlmunlock(struct dlm_ctxt *dlm, struct dlm_lockstatus *lksb,
 	struct dlm_lock *lock = NULL;
 	int call_ast, is_master;
 
-	mlog_entry_void();
-
 	if (!lksb) {
 		dlm_error(DLM_BADARGS);
 		return DLM_BADARGS;
diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index e8d94d7..c2f3fa1 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -397,8 +397,6 @@ static void ocfs2_build_lock_name(enum ocfs2_lock_type type,
 {
 	int len;
 
-	mlog_entry_void();
-
 	BUG_ON(type >= OCFS2_NUM_LOCK_TYPES);
 
 	len = snprintf(name, OCFS2_LOCK_ID_MAX_LEN, "%c%s%016llx%08x",
@@ -729,8 +727,6 @@ void ocfs2_refcount_lock_res_init(struct ocfs2_lock_res *lockres,
 
 void ocfs2_lock_res_free(struct ocfs2_lock_res *res)
 {
-	mlog_entry_void();
-
 	if (!(res->l_flags & OCFS2_LOCK_INITIALIZED))
 		return;
 
@@ -762,8 +758,6 @@ void ocfs2_lock_res_free(struct ocfs2_lock_res *res)
 static inline void ocfs2_inc_holders(struct ocfs2_lock_res *lockres,
 				     int level)
 {
-	mlog_entry_void();
-
 	BUG_ON(!lockres);
 
 	switch(level) {
@@ -783,8 +777,6 @@ static inline void ocfs2_inc_holders(struct ocfs2_lock_res *lockres,
 static inline void ocfs2_dec_holders(struct ocfs2_lock_res *lockres,
 				     int level)
 {
-	mlog_entry_void();
-
 	BUG_ON(!lockres);
 
 	switch(level) {
@@ -846,8 +838,6 @@ static void lockres_clear_flags(struct ocfs2_lock_res *lockres,
 
 static inline void ocfs2_generic_handle_downconvert_action(struct ocfs2_lock_res *lockres)
 {
-	mlog_entry_void();
-
 	BUG_ON(!(lockres->l_flags & OCFS2_LOCK_BUSY));
 	BUG_ON(!(lockres->l_flags & OCFS2_LOCK_ATTACHED));
 	BUG_ON(!(lockres->l_flags & OCFS2_LOCK_BLOCKED));
@@ -866,8 +856,6 @@ static inline void ocfs2_generic_handle_downconvert_action(struct ocfs2_lock_res
 
 static inline void ocfs2_generic_handle_convert_action(struct ocfs2_lock_res *lockres)
 {
-	mlog_entry_void();
-
 	BUG_ON(!(lockres->l_flags & OCFS2_LOCK_BUSY));
 	BUG_ON(!(lockres->l_flags & OCFS2_LOCK_ATTACHED));
 
@@ -895,8 +883,6 @@ static inline void ocfs2_generic_handle_convert_action(struct ocfs2_lock_res *lo
 
 static inline void ocfs2_generic_handle_attach_action(struct ocfs2_lock_res *lockres)
 {
-	mlog_entry_void();
-
 	BUG_ON((!(lockres->l_flags & OCFS2_LOCK_BUSY)));
 	BUG_ON(lockres->l_flags & OCFS2_LOCK_ATTACHED);
 
@@ -916,7 +902,6 @@ static int ocfs2_generic_handle_bast(struct ocfs2_lock_res *lockres,
 				     int level)
 {
 	int needs_downconvert = 0;
-	mlog_entry_void();
 
 	assert_spin_locked(&lockres->l_lock);
 
@@ -1151,8 +1136,6 @@ static void ocfs2_unlock_ast(struct ocfs2_dlm_lksb *lksb, int error)
 	struct ocfs2_lock_res *lockres = ocfs2_lksb_to_lock_res(lksb);
 	unsigned long flags;
 
-	mlog_entry_void();
-
 	mlog(ML_BASTS, "UNLOCK AST fired for lockres %s, action = %d\n",
 	     lockres->l_name, lockres->l_unlock_action);
 
@@ -1233,7 +1216,6 @@ static inline void ocfs2_recover_from_dlm_error(struct ocfs2_lock_res *lockres,
 {
 	unsigned long flags;
 
-	mlog_entry_void();
 	spin_lock_irqsave(&lockres->l_lock, flags);
 	lockres_clear_flags(lockres, OCFS2_LOCK_BUSY);
 	lockres_clear_flags(lockres, OCFS2_LOCK_UPCONVERT_FINISHING);
@@ -1260,8 +1242,6 @@ static int ocfs2_lock_create(struct ocfs2_super *osb,
 	unsigned long flags;
 	unsigned int gen;
 
-	mlog_entry_void();
-
 	mlog(0, "lock %s, level = %d, flags = %u\n", lockres->l_name, level,
 	     dlm_flags);
 
@@ -1416,8 +1396,6 @@ static int __ocfs2_cluster_lock(struct ocfs2_super *osb,
 	unsigned int gen;
 	int noqueue_attempted = 0;
 
-	mlog_entry_void();
-
 	ocfs2_init_mask_waiter(&mw);
 
 	if (lockres->l_ops->flags & LOCK_TYPE_USES_LVB)
@@ -1605,7 +1583,6 @@ static void __ocfs2_cluster_unlock(struct ocfs2_super *osb,
 {
 	unsigned long flags;
 
-	mlog_entry_void();
 	spin_lock_irqsave(&lockres->l_lock, flags);
 	ocfs2_dec_holders(lockres, level);
 	ocfs2_downconvert_on_unlock(osb, lockres);
@@ -1648,8 +1625,6 @@ int ocfs2_create_new_inode_locks(struct inode *inode)
 	BUG_ON(!inode);
 	BUG_ON(!ocfs2_inode_is_new(inode));
 
-	mlog_entry_void();
-
 	mlog(0, "Inode %llu\n", (unsigned long long)OCFS2_I(inode)->ip_blkno);
 
 	/* NOTE: That we don't increment any of the holder counts, nor
@@ -1695,8 +1670,6 @@ int ocfs2_rw_lock(struct inode *inode, int write)
 
 	BUG_ON(!inode);
 
-	mlog_entry_void();
-
 	mlog(0, "inode %llu take %s RW lock\n",
 	     (unsigned long long)OCFS2_I(inode)->ip_blkno,
 	     write ? "EXMODE" : "PRMODE");
@@ -1725,8 +1698,6 @@ void ocfs2_rw_unlock(struct inode *inode, int write)
 	struct ocfs2_lock_res *lockres = &OCFS2_I(inode)->ip_rw_lockres;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 
-	mlog_entry_void();
-
 	mlog(0, "inode %llu drop %s RW lock\n",
 	     (unsigned long long)OCFS2_I(inode)->ip_blkno,
 	     write ? "EXMODE" : "PRMODE");
@@ -1748,8 +1719,6 @@ int ocfs2_open_lock(struct inode *inode)
 
 	BUG_ON(!inode);
 
-	mlog_entry_void();
-
 	mlog(0, "inode %llu take PRMODE open lock\n",
 	     (unsigned long long)OCFS2_I(inode)->ip_blkno);
 
@@ -1776,8 +1745,6 @@ int ocfs2_try_open_lock(struct inode *inode, int write)
 
 	BUG_ON(!inode);
 
-	mlog_entry_void();
-
 	mlog(0, "inode %llu try to take %s open lock\n",
 	     (unsigned long long)OCFS2_I(inode)->ip_blkno,
 	     write ? "EXMODE" : "PRMODE");
@@ -1811,8 +1778,6 @@ void ocfs2_open_unlock(struct inode *inode)
 	struct ocfs2_lock_res *lockres = &OCFS2_I(inode)->ip_open_lockres;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 
-	mlog_entry_void();
-
 	mlog(0, "inode %llu drop open lock\n",
 	     (unsigned long long)OCFS2_I(inode)->ip_blkno);
 
@@ -2043,8 +2008,6 @@ static void ocfs2_downconvert_on_unlock(struct ocfs2_super *osb,
 {
 	int kick = 0;
 
-	mlog_entry_void();
-
 	/* If we know that another node is waiting on our lock, kick
 	 * the downconvert thread * pre-emptively when we reach a release
 	 * condition. */
@@ -2095,8 +2058,6 @@ static void __ocfs2_stuff_meta_lvb(struct inode *inode)
 	struct ocfs2_lock_res *lockres = &oi->ip_inode_lockres;
 	struct ocfs2_meta_lvb *lvb;
 
-	mlog_entry_void();
-
 	lvb = ocfs2_dlm_lvb(&lockres->l_lksb);
 
 	/*
@@ -2145,8 +2106,6 @@ static void ocfs2_refresh_inode_from_lvb(struct inode *inode)
 	struct ocfs2_lock_res *lockres = &oi->ip_inode_lockres;
 	struct ocfs2_meta_lvb *lvb;
 
-	mlog_entry_void();
-
 	mlog_meta_lvb(0, lockres);
 
 	lvb = ocfs2_dlm_lvb(&lockres->l_lksb);
@@ -2205,8 +2164,6 @@ static int ocfs2_should_refresh_lock_res(struct ocfs2_lock_res *lockres)
 	unsigned long flags;
 	int status = 0;
 
-	mlog_entry_void();
-
 refresh_check:
 	spin_lock_irqsave(&lockres->l_lock, flags);
 	if (!(lockres->l_flags & OCFS2_LOCK_NEEDS_REFRESH)) {
@@ -2237,7 +2194,6 @@ static inline void ocfs2_complete_lock_res_refresh(struct ocfs2_lock_res *lockre
 						   int status)
 {
 	unsigned long flags;
-	mlog_entry_void();
 
 	spin_lock_irqsave(&lockres->l_lock, flags);
 	lockres_clear_flags(lockres, OCFS2_LOCK_REFRESHING);
@@ -2260,8 +2216,6 @@ static int ocfs2_inode_lock_update(struct inode *inode,
 	struct ocfs2_dinode *fe;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 
-	mlog_entry_void();
-
 	if (ocfs2_mount_local(osb))
 		goto bail;
 
@@ -2374,8 +2328,6 @@ int ocfs2_inode_lock_full_nested(struct inode *inode,
 
 	BUG_ON(!inode);
 
-	mlog_entry_void();
-
 	mlog(0, "inode %llu, take %s META lock\n",
 	     (unsigned long long)OCFS2_I(inode)->ip_blkno,
 	     ex ? "EXMODE" : "PRMODE");
@@ -2517,7 +2469,6 @@ int ocfs2_inode_lock_atime(struct inode *inode,
 {
 	int ret;
 
-	mlog_entry_void();
 	ret = ocfs2_inode_lock(inode, NULL, 0);
 	if (ret < 0) {
 		mlog_errno(ret);
@@ -2556,8 +2507,6 @@ void ocfs2_inode_unlock(struct inode *inode,
 	struct ocfs2_lock_res *lockres = &OCFS2_I(inode)->ip_inode_lockres;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 
-	mlog_entry_void();
-
 	mlog(0, "inode %llu drop %s META lock\n",
 	     (unsigned long long)OCFS2_I(inode)->ip_blkno,
 	     ex ? "EXMODE" : "PRMODE");
@@ -2617,8 +2566,6 @@ int ocfs2_super_lock(struct ocfs2_super *osb,
 	int level = ex ? DLM_LOCK_EX : DLM_LOCK_PR;
 	struct ocfs2_lock_res *lockres = &osb->osb_super_lockres;
 
-	mlog_entry_void();
-
 	if (ocfs2_is_hard_readonly(osb))
 		return -EROFS;
 
@@ -3054,8 +3001,6 @@ int ocfs2_dlm_init(struct ocfs2_super *osb)
 	int status = 0;
 	struct ocfs2_cluster_connection *conn = NULL;
 
-	mlog_entry_void();
-
 	if (ocfs2_mount_local(osb)) {
 		osb->node_num = 0;
 		goto local;
@@ -3119,8 +3064,6 @@ bail:
 void ocfs2_dlm_shutdown(struct ocfs2_super *osb,
 			int hangup_pending)
 {
-	mlog_entry_void();
-
 	ocfs2_drop_osb_locks(osb);
 
 	/*
@@ -3284,8 +3227,6 @@ int ocfs2_drop_inode_locks(struct inode *inode)
 {
 	int status, err;
 
-	mlog_entry_void();
-
 	/* No need to call ocfs2_mark_lockres_freeing here -
 	 * ocfs2_clear_inode has done it for us. */
 
@@ -3352,8 +3293,6 @@ static int ocfs2_downconvert_lock(struct ocfs2_super *osb,
 	int ret;
 	u32 dlm_flags = DLM_LKF_CONVERT;
 
-	mlog_entry_void();
-
 	mlog(ML_BASTS, "lockres %s, level %d => %d\n", lockres->l_name,
 	     lockres->l_level, new_level);
 
@@ -3385,8 +3324,6 @@ static int ocfs2_prepare_cancel_convert(struct ocfs2_super *osb,
 {
 	assert_spin_locked(&lockres->l_lock);
 
-	mlog_entry_void();
-
 	if (lockres->l_unlock_action == OCFS2_UNLOCK_CANCEL_CONVERT) {
 		/* If we're already trying to cancel a lock conversion
 		 * then just drop the spinlock and allow the caller to
@@ -3416,8 +3353,6 @@ static int ocfs2_cancel_convert(struct ocfs2_super *osb,
 {
 	int ret;
 
-	mlog_entry_void();
-
 	ret = ocfs2_dlm_unlock(osb->cconn, &lockres->l_lksb,
 			       DLM_LKF_CANCEL);
 	if (ret) {
@@ -3443,8 +3378,6 @@ static int ocfs2_unblock_lock(struct ocfs2_super *osb,
 	int set_lvb = 0;
 	unsigned int gen;
 
-	mlog_entry_void();
-
 	spin_lock_irqsave(&lockres->l_lock, flags);
 
 recheck:
@@ -3859,8 +3792,6 @@ static void ocfs2_set_qinfo_lvb(struct ocfs2_lock_res *lockres)
 	struct mem_dqinfo *info = sb_dqinfo(oinfo->dqi_gi.dqi_sb,
 					    oinfo->dqi_gi.dqi_type);
 
-	mlog_entry_void();
-
 	lvb = ocfs2_dlm_lvb(&lockres->l_lksb);
 	lvb->lvb_version = OCFS2_QINFO_LVB_VERSION;
 	lvb->lvb_bgrace = cpu_to_be32(info->dqi_bgrace);
@@ -3879,7 +3810,6 @@ void ocfs2_qinfo_unlock(struct ocfs2_mem_dqinfo *oinfo, int ex)
 	struct ocfs2_super *osb = OCFS2_SB(oinfo->dqi_gi.dqi_sb);
 	int level = ex ? DLM_LOCK_EX : DLM_LOCK_PR;
 
-	mlog_entry_void();
 	if (!ocfs2_is_hard_readonly(osb) && !ocfs2_mount_local(osb))
 		ocfs2_cluster_unlock(osb, lockres, level);
 	mlog_exit_void();
@@ -3937,8 +3867,6 @@ int ocfs2_qinfo_lock(struct ocfs2_mem_dqinfo *oinfo, int ex)
 	int level = ex ? DLM_LOCK_EX : DLM_LOCK_PR;
 	int status = 0;
 
-	mlog_entry_void();
-
 	/* On RO devices, locking really isn't needed... */
 	if (ocfs2_is_hard_readonly(osb)) {
 		if (ex)
@@ -4007,8 +3935,6 @@ static void ocfs2_process_blocked_lock(struct ocfs2_super *osb,
 	 * considered valid until we remove the OCFS2_LOCK_QUEUED
 	 * flag. */
 
-	mlog_entry_void();
-
 	BUG_ON(!lockres);
 	BUG_ON(!lockres->l_ops);
 
@@ -4049,8 +3975,6 @@ unqueue:
 static void ocfs2_schedule_blocked_lock(struct ocfs2_super *osb,
 					struct ocfs2_lock_res *lockres)
 {
-	mlog_entry_void();
-
 	assert_spin_locked(&lockres->l_lock);
 
 	if (lockres->l_flags & OCFS2_LOCK_FREEING) {
@@ -4080,8 +4004,6 @@ static void ocfs2_downconvert_thread_do_work(struct ocfs2_super *osb)
 	unsigned long processed;
 	struct ocfs2_lock_res *lockres;
 
-	mlog_entry_void();
-
 	spin_lock(&osb->dc_task_lock);
 	/* grab this early so we know to try again if a state change and
 	 * wake happens part-way through our work  */
diff --git a/fs/ocfs2/export.c b/fs/ocfs2/export.c
index 19ad145..2173cc2 100644
--- a/fs/ocfs2/export.c
+++ b/fs/ocfs2/export.c
@@ -56,7 +56,7 @@ static struct dentry *ocfs2_get_dentry(struct super_block *sb,
 	int status, set;
 	struct dentry *result;
 
-	mlog_entry("(0x%p, 0x%p)\n", sb, handle);
+	mlog(0, "(0x%p, 0x%p)\n", sb, handle);
 
 	if (blkno == 0) {
 		mlog(0, "nfs wants inode with blkno: 0\n");
@@ -154,8 +154,8 @@ static struct dentry *ocfs2_get_parent(struct dentry *child)
 	struct dentry *parent;
 	struct inode *dir = child->d_inode;
 
-	mlog_entry("(0x%p, '%.*s')\n", child,
-		   child->d_name.len, child->d_name.name);
+	mlog(0, "(0x%p, '%.*s')\n", child,
+	     child->d_name.len, child->d_name.name);
 
 	mlog(0, "find parent of directory %llu\n",
 	     (unsigned long long)OCFS2_I(dir)->ip_blkno);
@@ -197,9 +197,9 @@ static int ocfs2_encode_fh(struct dentry *dentry, u32 *fh_in, int *max_len,
 	u32 generation;
 	__le32 *fh = (__force __le32 *) fh_in;
 
-	mlog_entry("(0x%p, '%.*s', 0x%p, %d, %d)\n", dentry,
-		   dentry->d_name.len, dentry->d_name.name,
-		   fh, len, connectable);
+	mlog(0, "(0x%p, '%.*s', 0x%p, %d, %d)\n", dentry,
+	     dentry->d_name.len, dentry->d_name.name,
+	     fh, len, connectable);
 
 	if (len < 3 || (connectable && len < 6)) {
 		mlog(ML_ERROR, "fh buffer is too small for encoding\n");
diff --git a/fs/ocfs2/extent_map.c b/fs/ocfs2/extent_map.c
index 09e3fdf..ed9916a 100644
--- a/fs/ocfs2/extent_map.c
+++ b/fs/ocfs2/extent_map.c
@@ -841,10 +841,10 @@ int ocfs2_read_virt_blocks(struct inode *inode, u64 v_block, int nr,
 	u64 p_block, p_count;
 	int i, count, done = 0;
 
-	mlog_entry("(inode = %p, v_block = %llu, nr = %d, bhs = %p, "
-		   "flags = %x, validate = %p)\n",
-		   inode, (unsigned long long)v_block, nr, bhs, flags,
-		   validate);
+	mlog(0, "(inode = %p, v_block = %llu, nr = %d, bhs = %p, "
+	     "flags = %x, validate = %p)\n",
+	     inode, (unsigned long long)v_block, nr, bhs, flags,
+	     validate);
 
 	if (((v_block + nr - 1) << inode->i_sb->s_blocksize_bits) >=
 	    i_size_read(inode)) {
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 77b4c04..480accf 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -99,8 +99,8 @@ static int ocfs2_file_open(struct inode *inode, struct file *file)
 	int mode = file->f_flags;
 	struct ocfs2_inode_info *oi = OCFS2_I(inode);
 
-	mlog_entry("(0x%p, 0x%p, '%.*s')\n", inode, file,
-		   file->f_path.dentry->d_name.len, file->f_path.dentry->d_name.name);
+	mlog(0, "(0x%p, 0x%p, '%.*s')\n", inode, file,
+	     file->f_path.dentry->d_name.len, file->f_path.dentry->d_name.name);
 
 	if (file->f_mode & FMODE_WRITE)
 		dquot_initialize(inode);
@@ -143,9 +143,9 @@ static int ocfs2_file_release(struct inode *inode, struct file *file)
 {
 	struct ocfs2_inode_info *oi = OCFS2_I(inode);
 
-	mlog_entry("(0x%p, 0x%p, '%.*s')\n", inode, file,
-		       file->f_path.dentry->d_name.len,
-		       file->f_path.dentry->d_name.name);
+	mlog(0, "(0x%p, 0x%p, '%.*s')\n", inode, file,
+	     file->f_path.dentry->d_name.len,
+	     file->f_path.dentry->d_name.name);
 
 	spin_lock(&oi->ip_lock);
 	if (!--oi->ip_open_count)
@@ -177,9 +177,9 @@ static int ocfs2_sync_file(struct file *file, int datasync)
 	struct inode *inode = file->f_mapping->host;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 
-	mlog_entry("(0x%p, %d, 0x%p, '%.*s')\n", file, datasync,
-		   file->f_path.dentry, file->f_path.dentry->d_name.len,
-		   file->f_path.dentry->d_name.name);
+	mlog(0, "(0x%p, %d, 0x%p, '%.*s')\n", file, datasync,
+	     file->f_path.dentry, file->f_path.dentry->d_name.len,
+	     file->f_path.dentry->d_name.name);
 
 	if (datasync && !(inode->i_state & I_DIRTY_DATASYNC)) {
 		/*
@@ -251,8 +251,6 @@ int ocfs2_update_inode_atime(struct inode *inode,
 	handle_t *handle;
 	struct ocfs2_dinode *di = (struct ocfs2_dinode *) bh->b_data;
 
-	mlog_entry_void();
-
 	handle = ocfs2_start_trans(osb, OCFS2_INODE_UPDATE_CREDITS);
 	if (IS_ERR(handle)) {
 		ret = PTR_ERR(handle);
@@ -291,7 +289,6 @@ static int ocfs2_set_inode_size(handle_t *handle,
 {
 	int status;
 
-	mlog_entry_void();
 	i_size_write(inode, new_i_size);
 	inode->i_blocks = ocfs2_inode_sector_count(inode);
 	inode->i_ctime = inode->i_mtime = CURRENT_TIME;
@@ -375,8 +372,6 @@ static int ocfs2_orphan_for_truncate(struct ocfs2_super *osb,
 	struct ocfs2_dinode *di;
 	u64 cluster_bytes;
 
-	mlog_entry_void();
-
 	/*
 	 * We need to CoW the cluster contains the offset if it is reflinked
 	 * since we will call ocfs2_zero_range_for_truncate later which will
@@ -442,9 +437,9 @@ static int ocfs2_truncate_file(struct inode *inode,
 	struct ocfs2_dinode *fe = NULL;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 
-	mlog_entry("(inode = %llu, new_i_size = %llu\n",
-		   (unsigned long long)OCFS2_I(inode)->ip_blkno,
-		   (unsigned long long)new_i_size);
+	mlog(0, "(inode = %llu, new_i_size = %llu\n",
+	     (unsigned long long)OCFS2_I(inode)->ip_blkno,
+	     (unsigned long long)new_i_size);
 
 	/* We trust di_bh because it comes from ocfs2_inode_lock(), which
 	 * already validated it */
@@ -578,7 +573,7 @@ static int __ocfs2_extend_allocation(struct inode *inode, u32 logical_start,
 	struct ocfs2_extent_tree et;
 	int did_quota = 0;
 
-	mlog_entry("(clusters_to_add = %u)\n", clusters_to_add);
+	mlog(0, "(clusters_to_add = %u)\n", clusters_to_add);
 
 	/*
 	 * This function only exists for file systems which don't
@@ -1113,8 +1108,8 @@ int ocfs2_setattr(struct dentry *dentry, struct iattr *attr)
 	struct dquot *transfer_to[MAXQUOTAS] = { };
 	int qtype;
 
-	mlog_entry("(0x%p, '%.*s')\n", dentry,
-	           dentry->d_name.len, dentry->d_name.name);
+	mlog(0, "(0x%p, '%.*s')\n", dentry,
+	     dentry->d_name.len, dentry->d_name.name);
 
 	/* ensuring we don't even attempt to truncate a symlink */
 	if (S_ISLNK(inode->i_mode))
@@ -1287,8 +1282,6 @@ int ocfs2_getattr(struct vfsmount *mnt,
 	struct ocfs2_super *osb = sb->s_fs_info;
 	int err;
 
-	mlog_entry_void();
-
 	err = ocfs2_inode_revalidate(dentry);
 	if (err) {
 		if (err != -ENOENT)
@@ -1311,8 +1304,6 @@ int ocfs2_permission(struct inode *inode, int mask)
 {
 	int ret;
 
-	mlog_entry_void();
-
 	ret = ocfs2_inode_lock(inode, NULL, 0);
 	if (ret) {
 		if (ret != -ENOENT)
@@ -1336,8 +1327,8 @@ static int __ocfs2_write_remove_suid(struct inode *inode,
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	struct ocfs2_dinode *di;
 
-	mlog_entry("(Inode %llu, mode 0%o)\n",
-		   (unsigned long long)OCFS2_I(inode)->ip_blkno, inode->i_mode);
+	mlog(0, "(Inode %llu, mode 0%o)\n",
+	     (unsigned long long)OCFS2_I(inode)->ip_blkno, inode->i_mode);
 
 	handle = ocfs2_start_trans(osb, OCFS2_INODE_UPDATE_CREDITS);
 	if (IS_ERR(handle)) {
@@ -2226,10 +2217,10 @@ static ssize_t ocfs2_file_aio_write(struct kiocb *iocb,
 	int full_coherency = !(osb->s_mount_opt &
 			       OCFS2_MOUNT_COHERENCY_BUFFERED);
 
-	mlog_entry("(0x%p, %u, '%.*s')\n", file,
-		   (unsigned int)nr_segs,
-		   file->f_path.dentry->d_name.len,
-		   file->f_path.dentry->d_name.name);
+	mlog(0, "(0x%p, %u, '%.*s')\n", file,
+	     (unsigned int)nr_segs,
+	     file->f_path.dentry->d_name.len,
+	     file->f_path.dentry->d_name.name);
 
 	if (iocb->ki_left == 0)
 		return 0;
@@ -2425,10 +2416,10 @@ static ssize_t ocfs2_file_splice_write(struct pipe_inode_info *pipe,
 		.u.file = out,
 	};
 
-	mlog_entry("(0x%p, 0x%p, %u, '%.*s')\n", out, pipe,
-		   (unsigned int)len,
-		   out->f_path.dentry->d_name.len,
-		   out->f_path.dentry->d_name.name);
+	mlog(0, "(0x%p, 0x%p, %u, '%.*s')\n", out, pipe,
+	     (unsigned int)len,
+	     out->f_path.dentry->d_name.len,
+	     out->f_path.dentry->d_name.name);
 
 	if (pipe->inode)
 		mutex_lock_nested(&pipe->inode->i_mutex, I_MUTEX_PARENT);
@@ -2485,10 +2476,10 @@ static ssize_t ocfs2_file_splice_read(struct file *in,
 	int ret = 0, lock_level = 0;
 	struct inode *inode = in->f_path.dentry->d_inode;
 
-	mlog_entry("(0x%p, 0x%p, %u, '%.*s')\n", in, pipe,
-		   (unsigned int)len,
-		   in->f_path.dentry->d_name.len,
-		   in->f_path.dentry->d_name.name);
+	mlog(0, "(0x%p, 0x%p, %u, '%.*s')\n", in, pipe,
+	     (unsigned int)len,
+	     in->f_path.dentry->d_name.len,
+	     in->f_path.dentry->d_name.name);
 
 	/*
 	 * See the comment in ocfs2_file_aio_read()
@@ -2516,10 +2507,10 @@ static ssize_t ocfs2_file_aio_read(struct kiocb *iocb,
 	struct file *filp = iocb->ki_filp;
 	struct inode *inode = filp->f_path.dentry->d_inode;
 
-	mlog_entry("(0x%p, %u, '%.*s')\n", filp,
-		   (unsigned int)nr_segs,
-		   filp->f_path.dentry->d_name.len,
-		   filp->f_path.dentry->d_name.name);
+	mlog(0, "(0x%p, %u, '%.*s')\n", filp,
+	     (unsigned int)nr_segs,
+	     filp->f_path.dentry->d_name.len,
+	     filp->f_path.dentry->d_name.name);
 
 	if (!inode) {
 		ret = -EINVAL;
diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index f935fd6..7bdfcb6 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -131,7 +131,7 @@ struct inode *ocfs2_iget(struct ocfs2_super *osb, u64 blkno, unsigned flags,
 	struct super_block *sb = osb->sb;
 	struct ocfs2_find_inode_args args;
 
-	mlog_entry("(blkno = %llu)\n", (unsigned long long)blkno);
+	mlog(0, "(blkno = %llu)\n", (unsigned long long)blkno);
 
 	/* Ok. By now we've either got the offsets passed to us by the
 	 * caller, or we just pulled them off the bh. Lets do some
@@ -192,7 +192,7 @@ static int ocfs2_find_actor(struct inode *inode, void *opaque)
 	struct ocfs2_inode_info *oi = OCFS2_I(inode);
 	int ret = 0;
 
-	mlog_entry("(0x%p, %lu, 0x%p)\n", inode, inode->i_ino, opaque);
+	mlog(0, "(0x%p, %lu, 0x%p)\n", inode, inode->i_ino, opaque);
 
 	args = opaque;
 
@@ -218,7 +218,7 @@ static int ocfs2_init_locked_inode(struct inode *inode, void *opaque)
 	static struct lock_class_key ocfs2_quota_ip_alloc_sem_key,
 				     ocfs2_file_ip_alloc_sem_key;
 
-	mlog_entry("inode = %p, opaque = %p\n", inode, opaque);
+	mlog(0, "inode = %p, opaque = %p\n", inode, opaque);
 
 	inode->i_ino = args->fi_ino;
 	OCFS2_I(inode)->ip_blkno = args->fi_blkno;
@@ -246,8 +246,8 @@ void ocfs2_populate_inode(struct inode *inode, struct ocfs2_dinode *fe,
 	struct ocfs2_super *osb;
 	int use_plocks = 1;
 
-	mlog_entry("(0x%p, size:%llu)\n", inode,
-		   (unsigned long long)le64_to_cpu(fe->i_size));
+	mlog(0, "(0x%p, size:%llu)\n", inode,
+	     (unsigned long long)le64_to_cpu(fe->i_size));
 
 	sb = inode->i_sb;
 	osb = OCFS2_SB(sb);
@@ -394,7 +394,7 @@ static int ocfs2_read_locked_inode(struct inode *inode,
 	int status, can_lock;
 	u32 generation = 0;
 
-	mlog_entry("(0x%p, 0x%p)\n", inode, args);
+	mlog(0, "(0x%p, 0x%p)\n", inode, args);
 
 	status = -EINVAL;
 	if (inode == NULL || inode->i_sb == NULL) {
@@ -551,8 +551,6 @@ static int ocfs2_truncate_for_delete(struct ocfs2_super *osb,
 	struct ocfs2_dinode *fe;
 	handle_t *handle = NULL;
 
-	mlog_entry_void();
-
 	fe = (struct ocfs2_dinode *) fe_bh->b_data;
 
 	/*
@@ -980,7 +978,7 @@ static void ocfs2_delete_inode(struct inode *inode)
 	sigset_t oldset;
 	struct buffer_head *di_bh = NULL;
 
-	mlog_entry("(inode->i_ino = %lu)\n", inode->i_ino);
+	mlog(0, "(inode->i_ino = %lu)\n", inode->i_ino);
 
 	/* When we fail in read_inode() we mark inode as bad. The second test
 	 * catches the case when inode allocation fails before allocating
@@ -1088,8 +1086,6 @@ static void ocfs2_clear_inode(struct inode *inode)
 	int status;
 	struct ocfs2_inode_info *oi = OCFS2_I(inode);
 
-	mlog_entry_void();
-
 	end_writeback(inode);
 	mlog(0, "Clearing inode: %llu, nlink = %u\n",
 	     (unsigned long long)OCFS2_I(inode)->ip_blkno, inode->i_nlink);
@@ -1204,8 +1200,6 @@ int ocfs2_drop_inode(struct inode *inode)
 	struct ocfs2_inode_info *oi = OCFS2_I(inode);
 	int res;
 
-	mlog_entry_void();
-
 	mlog(0, "Drop inode %llu, nlink = %u, ip_flags = 0x%x\n",
 	     (unsigned long long)oi->ip_blkno, inode->i_nlink, oi->ip_flags);
 
@@ -1226,8 +1220,8 @@ int ocfs2_inode_revalidate(struct dentry *dentry)
 	struct inode *inode = dentry->d_inode;
 	int status = 0;
 
-	mlog_entry("(inode = 0x%p, ino = %llu)\n", inode,
-		   inode ? (unsigned long long)OCFS2_I(inode)->ip_blkno : 0ULL);
+	mlog(0, "(inode = 0x%p, ino = %llu)\n", inode,
+	     inode ? (unsigned long long)OCFS2_I(inode)->ip_blkno : 0ULL);
 
 	if (!inode) {
 		mlog(0, "eep, no inode!\n");
@@ -1271,8 +1265,8 @@ int ocfs2_mark_inode_dirty(handle_t *handle,
 	int status;
 	struct ocfs2_dinode *fe = (struct ocfs2_dinode *) bh->b_data;
 
-	mlog_entry("(inode %llu)\n",
-		   (unsigned long long)OCFS2_I(inode)->ip_blkno);
+	mlog(0, "(inode %llu)\n",
+	     (unsigned long long)OCFS2_I(inode)->ip_blkno);
 
 	status = ocfs2_journal_access_di(handle, INODE_CACHE(inode), bh,
 					 OCFS2_JOURNAL_ACCESS_WRITE);
diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index faa2303..7378277 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -303,8 +303,6 @@ static int ocfs2_commit_cache(struct ocfs2_super *osb)
 	unsigned int flushed;
 	struct ocfs2_journal *journal = NULL;
 
-	mlog_entry_void();
-
 	journal = osb->journal;
 
 	/* Flush all pending commits and checkpoint the journal. */
@@ -425,7 +423,6 @@ int ocfs2_extend_trans(handle_t *handle, int nblocks)
 		return 0;
 
 	old_nblocks = handle->h_buffer_credits;
-	mlog_entry_void();
 
 	mlog(0, "Trying to extend transaction by %d blocks\n", nblocks);
 
@@ -622,12 +619,12 @@ static int __ocfs2_journal_access(handle_t *handle,
 	BUG_ON(!handle);
 	BUG_ON(!bh);
 
-	mlog_entry("bh->b_blocknr=%llu, type=%d (\"%s\"), bh->b_size = %zu\n",
-		   (unsigned long long)bh->b_blocknr, type,
-		   (type == OCFS2_JOURNAL_ACCESS_CREATE) ?
-		   "OCFS2_JOURNAL_ACCESS_CREATE" :
-		   "OCFS2_JOURNAL_ACCESS_WRITE",
-		   bh->b_size);
+	mlog(0, "bh->b_blocknr=%llu, type=%d (\"%s\"), bh->b_size = %zu\n",
+	     (unsigned long long)bh->b_blocknr, type,
+	     (type == OCFS2_JOURNAL_ACCESS_CREATE) ?
+	     "OCFS2_JOURNAL_ACCESS_CREATE" :
+	     "OCFS2_JOURNAL_ACCESS_WRITE",
+	     bh->b_size);
 
 	/* we can safely remove this assertion after testing. */
 	if (!buffer_uptodate(bh)) {
@@ -737,8 +734,8 @@ void ocfs2_journal_dirty(handle_t *handle, struct buffer_head *bh)
 {
 	int status;
 
-	mlog_entry("(bh->b_blocknr=%llu)\n",
-		   (unsigned long long)bh->b_blocknr);
+	mlog(0, "(bh->b_blocknr=%llu)\n",
+	     (unsigned long long)bh->b_blocknr);
 
 	status = jbd2_journal_dirty_metadata(handle, bh);
 	BUG_ON(status);
@@ -775,8 +772,6 @@ int ocfs2_journal_init(struct ocfs2_journal *journal, int *dirty)
 	struct ocfs2_super *osb;
 	int inode_lock = 0;
 
-	mlog_entry_void();
-
 	BUG_ON(!journal);
 
 	osb = journal->j_osb;
@@ -882,8 +877,6 @@ static int ocfs2_journal_toggle_dirty(struct ocfs2_super *osb,
 	struct buffer_head *bh = journal->j_bh;
 	struct ocfs2_dinode *fe;
 
-	mlog_entry_void();
-
 	fe = (struct ocfs2_dinode *)bh->b_data;
 
 	/* The journal bh on the osb always comes from ocfs2_journal_init()
@@ -921,8 +914,6 @@ void ocfs2_journal_shutdown(struct ocfs2_super *osb)
 	struct inode *inode = NULL;
 	int num_running_trans = 0;
 
-	mlog_entry_void();
-
 	BUG_ON(!osb);
 
 	journal = osb->journal;
@@ -1024,8 +1015,6 @@ int ocfs2_journal_load(struct ocfs2_journal *journal, int local, int replayed)
 	int status = 0;
 	struct ocfs2_super *osb;
 
-	mlog_entry_void();
-
 	BUG_ON(!journal);
 
 	osb = journal->j_osb;
@@ -1070,8 +1059,6 @@ int ocfs2_journal_wipe(struct ocfs2_journal *journal, int full)
 {
 	int status;
 
-	mlog_entry_void();
-
 	BUG_ON(!journal);
 
 	status = jbd2_journal_wipe(journal->j_journal, full);
@@ -1124,8 +1111,6 @@ static int ocfs2_force_read_journal(struct inode *inode)
 #define CONCURRENT_JOURNAL_FILL 32ULL
 	struct buffer_head *bhs[CONCURRENT_JOURNAL_FILL];
 
-	mlog_entry_void();
-
 	memset(bhs, 0, sizeof(struct buffer_head *) * CONCURRENT_JOURNAL_FILL);
 
 	num_blocks = ocfs2_blocks_for_bytes(inode->i_sb, inode->i_size);
@@ -1194,8 +1179,6 @@ void ocfs2_complete_recovery(struct work_struct *work)
 	struct ocfs2_quota_recovery *qrec;
 	LIST_HEAD(tmp_la_list);
 
-	mlog_entry_void();
-
 	mlog(0, "completing recovery from keventd\n");
 
 	spin_lock(&journal->j_lock);
@@ -1339,8 +1322,6 @@ static int __ocfs2_recovery_thread(void *arg)
 	int rm_quota_used = 0, i;
 	struct ocfs2_quota_recovery *qrec;
 
-	mlog_entry_void();
-
 	status = ocfs2_wait_on_mount(osb);
 	if (status < 0) {
 		goto bail;
@@ -1461,8 +1442,8 @@ bail:
 
 void ocfs2_recovery_thread(struct ocfs2_super *osb, int node_num)
 {
-	mlog_entry("(node_num=%d, osb->node_num = %d)\n",
-		   node_num, osb->node_num);
+	mlog(0, "(node_num=%d, osb->node_num = %d)\n",
+	     node_num, osb->node_num);
 
 	mutex_lock(&osb->recovery_lock);
 	if (osb->disable_recovery)
@@ -1688,8 +1669,8 @@ static int ocfs2_recover_node(struct ocfs2_super *osb,
 	struct ocfs2_dinode *la_copy = NULL;
 	struct ocfs2_dinode *tl_copy = NULL;
 
-	mlog_entry("(node_num=%d, slot_num=%d, osb->node_num = %d)\n",
-		   node_num, slot_num, osb->node_num);
+	mlog(0, "(node_num=%d, slot_num=%d, osb->node_num = %d)\n",
+	     node_num, slot_num, osb->node_num);
 
 	/* Should not ever be called to recover ourselves -- in that
 	 * case we should've called ocfs2_journal_load instead. */
diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
index ec6adbf..5f08c70 100644
--- a/fs/ocfs2/localalloc.c
+++ b/fs/ocfs2/localalloc.c
@@ -291,8 +291,6 @@ int ocfs2_load_local_alloc(struct ocfs2_super *osb)
 	struct inode *inode = NULL;
 	struct ocfs2_local_alloc *la;
 
-	mlog_entry_void();
-
 	if (osb->local_alloc_bits == 0)
 		goto bail;
 
@@ -388,8 +386,6 @@ void ocfs2_shutdown_local_alloc(struct ocfs2_super *osb)
 	struct ocfs2_dinode *alloc_copy = NULL;
 	struct ocfs2_dinode *alloc = NULL;
 
-	mlog_entry_void();
-
 	cancel_delayed_work(&osb->la_enable_wq);
 	flush_workqueue(ocfs2_wq);
 
@@ -502,7 +498,7 @@ int ocfs2_begin_local_alloc_recovery(struct ocfs2_super *osb,
 	struct inode *inode = NULL;
 	struct ocfs2_dinode *alloc;
 
-	mlog_entry("(slot_num = %d)\n", slot_num);
+	mlog(0, "(slot_num = %d)\n", slot_num);
 
 	*alloc_copy = NULL;
 
@@ -570,8 +566,6 @@ int ocfs2_complete_local_alloc_recovery(struct ocfs2_super *osb,
 	struct buffer_head *main_bm_bh = NULL;
 	struct inode *main_bm_inode;
 
-	mlog_entry_void();
-
 	main_bm_inode = ocfs2_get_system_file_inode(osb,
 						    GLOBAL_BITMAP_SYSTEM_INODE,
 						    OCFS2_INVALID_SLOT);
@@ -640,8 +634,6 @@ int ocfs2_reserve_local_alloc_bits(struct ocfs2_super *osb,
 	struct inode *local_alloc_inode;
 	unsigned int free_bits;
 
-	mlog_entry_void();
-
 	BUG_ON(!ac);
 
 	local_alloc_inode =
@@ -749,7 +741,6 @@ int ocfs2_claim_local_alloc_bits(struct ocfs2_super *osb,
 	struct ocfs2_dinode *alloc;
 	struct ocfs2_local_alloc *la;
 
-	mlog_entry_void();
 	BUG_ON(ac->ac_which != OCFS2_AC_USE_LOCAL);
 
 	local_alloc_inode = ac->ac_inode;
@@ -799,8 +790,6 @@ static u32 ocfs2_local_alloc_count_bits(struct ocfs2_dinode *alloc)
 	u32 count = 0;
 	struct ocfs2_local_alloc *la = OCFS2_LOCAL_ALLOC(alloc);
 
-	mlog_entry_void();
-
 	buffer = la->la_bitmap;
 	for (i = 0; i < le16_to_cpu(la->la_size); i++)
 		count += hweight8(buffer[i]);
@@ -820,7 +809,7 @@ static int ocfs2_local_alloc_find_clear_bits(struct ocfs2_super *osb,
 	void *bitmap = NULL;
 	struct ocfs2_reservation_map *resmap = &osb->osb_la_resmap;
 
-	mlog_entry("(numbits wanted = %u)\n", *numbits);
+	mlog(0, "(numbits wanted = %u)\n", *numbits);
 
 	if (!alloc->id1.bitmap1.i_total) {
 		mlog(0, "No bits in my window!\n");
@@ -903,7 +892,6 @@ static void ocfs2_clear_local_alloc(struct ocfs2_dinode *alloc)
 {
 	struct ocfs2_local_alloc *la = OCFS2_LOCAL_ALLOC(alloc);
 	int i;
-	mlog_entry_void();
 
 	alloc->id1.bitmap1.i_total = 0;
 	alloc->id1.bitmap1.i_used = 0;
@@ -952,9 +940,9 @@ static int ocfs2_sync_local_to_main(struct ocfs2_super *osb,
 	void *bitmap;
 	struct ocfs2_local_alloc *la = OCFS2_LOCAL_ALLOC(alloc);
 
-	mlog_entry("total = %u, used = %u\n",
-		   le32_to_cpu(alloc->id1.bitmap1.i_total),
-		   le32_to_cpu(alloc->id1.bitmap1.i_used));
+	mlog(0, "total = %u, used = %u\n",
+	     le32_to_cpu(alloc->id1.bitmap1.i_total),
+	     le32_to_cpu(alloc->id1.bitmap1.i_used));
 
 	if (!alloc->id1.bitmap1.i_total) {
 		mlog(0, "nothing to sync!\n");
@@ -1148,8 +1136,6 @@ static int ocfs2_local_alloc_new_window(struct ocfs2_super *osb,
 	struct ocfs2_dinode *alloc = NULL;
 	struct ocfs2_local_alloc *la;
 
-	mlog_entry_void();
-
 	alloc = (struct ocfs2_dinode *) osb->local_alloc_bh->b_data;
 	la = OCFS2_LOCAL_ALLOC(alloc);
 
@@ -1243,8 +1229,6 @@ static int ocfs2_local_alloc_slide_window(struct ocfs2_super *osb,
 	struct ocfs2_dinode *alloc_copy = NULL;
 	struct ocfs2_alloc_context *ac = NULL;
 
-	mlog_entry_void();
-
 	ocfs2_recalc_la_window(osb, OCFS2_LA_EVENT_SLIDE);
 
 	/* This will lock the main bitmap for us. */
diff --git a/fs/ocfs2/mmap.c b/fs/ocfs2/mmap.c
index 7e32db9..87438e1 100644
--- a/fs/ocfs2/mmap.c
+++ b/fs/ocfs2/mmap.c
@@ -49,7 +49,7 @@ static int ocfs2_fault(struct vm_area_struct *area, struct vm_fault *vmf)
 	sigset_t oldset;
 	int ret;
 
-	mlog_entry("(area=%p, page offset=%lu)\n", area, vmf->pgoff);
+	mlog(0, "(area=%p, page offset=%lu)\n", area, vmf->pgoff);
 
 	ocfs2_block_signals(&oldset);
 	ret = filemap_fault(area, vmf);
diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index ff5744e..f8c8f94 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -106,8 +106,8 @@ static struct dentry *ocfs2_lookup(struct inode *dir, struct dentry *dentry,
 	struct dentry *ret;
 	struct ocfs2_inode_info *oi;
 
-	mlog_entry("(0x%p, 0x%p, '%.*s')\n", dir, dentry,
-		   dentry->d_name.len, dentry->d_name.name);
+	mlog(0, "(0x%p, 0x%p, '%.*s')\n", dir, dentry,
+	     dentry->d_name.len, dentry->d_name.name);
 
 	if (dentry->d_name.len > OCFS2_MAX_FILENAME_LEN) {
 		ret = ERR_PTR(-ENAMETOOLONG);
@@ -236,9 +236,9 @@ static int ocfs2_mknod(struct inode *dir,
 	sigset_t oldset;
 	int did_block_signals = 0;
 
-	mlog_entry("(0x%p, 0x%p, %d, %lu, '%.*s')\n", dir, dentry, mode,
-		   (unsigned long)dev, dentry->d_name.len,
-		   dentry->d_name.name);
+	mlog(0, "(0x%p, 0x%p, %d, %lu, '%.*s')\n", dir, dentry, mode,
+	     (unsigned long)dev, dentry->d_name.len,
+	     dentry->d_name.name);
 
 	dquot_initialize(dir);
 
@@ -355,9 +355,9 @@ static int ocfs2_mknod(struct inode *dir,
 		goto leave;
 	did_quota_inode = 1;
 
-	mlog_entry("(0x%p, 0x%p, %d, %lu, '%.*s')\n", dir, dentry,
-		   inode->i_mode, (unsigned long)dev, dentry->d_name.len,
-		   dentry->d_name.name);
+	mlog(0, "(0x%p, 0x%p, %d, %lu, '%.*s')\n", dir, dentry,
+	     inode->i_mode, (unsigned long)dev, dentry->d_name.len,
+	     dentry->d_name.name);
 
 	/* do the real work now. */
 	status = ocfs2_mknod_locked(osb, dir, inode, dev,
@@ -617,8 +617,8 @@ static int ocfs2_mkdir(struct inode *dir,
 {
 	int ret;
 
-	mlog_entry("(0x%p, 0x%p, %d, '%.*s')\n", dir, dentry, mode,
-		   dentry->d_name.len, dentry->d_name.name);
+	mlog(0, "(0x%p, 0x%p, %d, '%.*s')\n", dir, dentry, mode,
+	     dentry->d_name.len, dentry->d_name.name);
 	ret = ocfs2_mknod(dir, dentry, mode | S_IFDIR, 0);
 	mlog_exit(ret);
 
@@ -632,8 +632,8 @@ static int ocfs2_create(struct inode *dir,
 {
 	int ret;
 
-	mlog_entry("(0x%p, 0x%p, %d, '%.*s')\n", dir, dentry, mode,
-		   dentry->d_name.len, dentry->d_name.name);
+	mlog(0, "(0x%p, 0x%p, %d, '%.*s')\n", dir, dentry, mode,
+	     dentry->d_name.len, dentry->d_name.name);
 	ret = ocfs2_mknod(dir, dentry, mode | S_IFREG, 0);
 	mlog_exit(ret);
 
@@ -654,9 +654,9 @@ static int ocfs2_link(struct dentry *old_dentry,
 	struct ocfs2_dir_lookup_result lookup = { NULL, };
 	sigset_t oldset;
 
-	mlog_entry("(inode=%lu, old='%.*s' new='%.*s')\n", inode->i_ino,
-		   old_dentry->d_name.len, old_dentry->d_name.name,
-		   dentry->d_name.len, dentry->d_name.name);
+	mlog(0, "(inode=%lu, old='%.*s' new='%.*s')\n", inode->i_ino,
+	     old_dentry->d_name.len, old_dentry->d_name.name,
+	     dentry->d_name.len, dentry->d_name.name);
 
 	if (S_ISDIR(inode->i_mode))
 		return -EPERM;
@@ -812,8 +812,8 @@ static int ocfs2_unlink(struct inode *dir,
 	struct ocfs2_dir_lookup_result lookup = { NULL, };
 	struct ocfs2_dir_lookup_result orphan_insert = { NULL, };
 
-	mlog_entry("(0x%p, 0x%p, '%.*s')\n", dir, dentry,
-		   dentry->d_name.len, dentry->d_name.name);
+	mlog(0, "(0x%p, 0x%p, '%.*s')\n", dir, dentry,
+	     dentry->d_name.len, dentry->d_name.name);
 
 	dquot_initialize(dir);
 
@@ -978,9 +978,9 @@ static int ocfs2_double_lock(struct ocfs2_super *osb,
 	struct buffer_head **tmpbh;
 	struct inode *tmpinode;
 
-	mlog_entry("(inode1 = %llu, inode2 = %llu)\n",
-		   (unsigned long long)oi1->ip_blkno,
-		   (unsigned long long)oi2->ip_blkno);
+	mlog(0, "(inode1 = %llu, inode2 = %llu)\n",
+	     (unsigned long long)oi1->ip_blkno,
+	     (unsigned long long)oi2->ip_blkno);
 
 	if (*bh1)
 		*bh1 = NULL;
@@ -1067,10 +1067,10 @@ static int ocfs2_rename(struct inode *old_dir,
 	/* At some point it might be nice to break this function up a
 	 * bit. */
 
-	mlog_entry("(0x%p, 0x%p, 0x%p, 0x%p, from='%.*s' to='%.*s')\n",
-		   old_dir, old_dentry, new_dir, new_dentry,
-		   old_dentry->d_name.len, old_dentry->d_name.name,
-		   new_dentry->d_name.len, new_dentry->d_name.name);
+	mlog(0, "(0x%p, 0x%p, 0x%p, 0x%p, from='%.*s' to='%.*s')\n",
+	     old_dir, old_dentry, new_dir, new_dentry,
+	     old_dentry->d_name.len, old_dentry->d_name.name,
+	     new_dentry->d_name.len, new_dentry->d_name.name);
 
 	dquot_initialize(old_dir);
 	dquot_initialize(new_dir);
@@ -1501,9 +1501,9 @@ static int ocfs2_create_symlink_data(struct ocfs2_super *osb,
 	 * write i_size + 1 bytes. */
 	blocks = (bytes_left + sb->s_blocksize - 1) >> sb->s_blocksize_bits;
 
-	mlog_entry("i_blocks = %llu, i_size = %llu, blocks = %d\n",
-			(unsigned long long)inode->i_blocks,
-			i_size_read(inode), blocks);
+	mlog(0, "i_blocks = %llu, i_size = %llu, blocks = %d\n",
+	     (unsigned long long)inode->i_blocks,
+	     i_size_read(inode), blocks);
 
 	/* Sanity check -- make sure we're going to fit. */
 	if (bytes_left >
@@ -1610,8 +1610,8 @@ static int ocfs2_symlink(struct inode *dir,
 	sigset_t oldset;
 	int did_block_signals = 0;
 
-	mlog_entry("(0x%p, 0x%p, symname='%s' actual='%.*s')\n", dir,
-		   dentry, symname, dentry->d_name.len, dentry->d_name.name);
+	mlog(0, "(0x%p, 0x%p, symname='%s' actual='%.*s')\n", dir,
+	     dentry, symname, dentry->d_name.len, dentry->d_name.name);
 
 	dquot_initialize(dir);
 
@@ -1713,9 +1713,9 @@ static int ocfs2_symlink(struct inode *dir,
 		goto bail;
 	did_quota_inode = 1;
 
-	mlog_entry("(0x%p, 0x%p, %d, '%.*s')\n", dir, dentry,
-		   inode->i_mode, dentry->d_name.len,
-		   dentry->d_name.name);
+	mlog(0, "(0x%p, 0x%p, %d, '%.*s')\n", dir, dentry,
+	     inode->i_mode, dentry->d_name.len,
+	     dentry->d_name.name);
 
 	status = ocfs2_mknod_locked(osb, dir, inode,
 				    0, &new_fe_bh, parent_fe_bh, handle,
@@ -1845,8 +1845,6 @@ static int ocfs2_blkno_stringify(u64 blkno, char *name)
 {
 	int status, namelen;
 
-	mlog_entry_void();
-
 	namelen = snprintf(name, OCFS2_ORPHAN_NAMELEN + 1, "%016llx",
 			   (long long)blkno);
 	if (namelen <= 0) {
@@ -1998,7 +1996,7 @@ static int ocfs2_orphan_add(struct ocfs2_super *osb,
 	struct ocfs2_dinode *orphan_fe;
 	struct ocfs2_dinode *fe = (struct ocfs2_dinode *) fe_bh->b_data;
 
-	mlog_entry("(inode->i_ino = %lu)\n", inode->i_ino);
+	mlog(0, "(inode->i_ino = %lu)\n", inode->i_ino);
 
 	status = ocfs2_read_inode_block(orphan_dir_inode, &orphan_dir_bh);
 	if (status < 0) {
@@ -2079,8 +2077,6 @@ int ocfs2_orphan_del(struct ocfs2_super *osb,
 	int status = 0;
 	struct ocfs2_dir_lookup_result lookup = { NULL, };
 
-	mlog_entry_void();
-
 	status = ocfs2_blkno_stringify(OCFS2_I(inode)->ip_blkno, name);
 	if (status < 0) {
 		mlog_errno(status);
@@ -2359,8 +2355,8 @@ int ocfs2_mv_orphaned_inode_to_new(struct inode *dir,
 	struct buffer_head *di_bh = NULL;
 	struct ocfs2_dir_lookup_result lookup = { NULL, };
 
-	mlog_entry("(0x%p, 0x%p, %.*s')\n", dir, dentry,
-		   dentry->d_name.len, dentry->d_name.name);
+	mlog(0, "(0x%p, 0x%p, %.*s')\n", dir, dentry,
+	     dentry->d_name.len, dentry->d_name.name);
 
 	status = ocfs2_inode_lock(dir, &parent_di_bh, 1);
 	if (status < 0) {
diff --git a/fs/ocfs2/quota_global.c b/fs/ocfs2/quota_global.c
index 4607923..33397bd 100644
--- a/fs/ocfs2/quota_global.c
+++ b/fs/ocfs2/quota_global.c
@@ -343,8 +343,6 @@ int ocfs2_global_read_info(struct super_block *sb, int type)
 	u64 pcount;
 	int status;
 
-	mlog_entry_void();
-
 	/* Read global header */
 	gqinode = ocfs2_get_system_file_inode(OCFS2_SB(sb), ino[type],
 			OCFS2_INVALID_SLOT);
@@ -596,7 +594,7 @@ static int ocfs2_sync_dquot_helper(struct dquot *dquot, unsigned long type)
 	struct ocfs2_super *osb = OCFS2_SB(sb);
 	int status = 0;
 
-	mlog_entry("id=%u qtype=%u type=%lu device=%s\n", dquot->dq_id,
+	mlog(0, "id=%u qtype=%u type=%lu device=%s\n", dquot->dq_id,
 		   dquot->dq_type, type, sb->s_id);
 	if (type != dquot->dq_type)
 		goto out;
@@ -649,7 +647,7 @@ static int ocfs2_write_dquot(struct dquot *dquot)
 	struct ocfs2_super *osb = OCFS2_SB(dquot->dq_sb);
 	int status = 0;
 
-	mlog_entry("id=%u, type=%d", dquot->dq_id, dquot->dq_type);
+	mlog(0, "id=%u, type=%d", dquot->dq_id, dquot->dq_type);
 
 	handle = ocfs2_start_trans(osb, OCFS2_QWRITE_CREDITS);
 	if (IS_ERR(handle)) {
@@ -688,7 +686,7 @@ static int ocfs2_release_dquot(struct dquot *dquot)
 	struct ocfs2_super *osb = OCFS2_SB(dquot->dq_sb);
 	int status = 0;
 
-	mlog_entry("id=%u, type=%d", dquot->dq_id, dquot->dq_type);
+	mlog(0, "id=%u, type=%d", dquot->dq_id, dquot->dq_type);
 
 	mutex_lock(&dquot->dq_lock);
 	/* Check whether we are not racing with some other dqget() */
@@ -745,7 +743,7 @@ static int ocfs2_acquire_dquot(struct dquot *dquot)
 	int need_alloc = ocfs2_global_qinit_alloc(sb, type);
 	handle_t *handle;
 
-	mlog_entry("id=%u, type=%d", dquot->dq_id, type);
+	mlog(0, "id=%u, type=%d", dquot->dq_id, type);
 	mutex_lock(&dquot->dq_lock);
 	/*
 	 * We need an exclusive lock, because we're going to update use count
@@ -831,7 +829,7 @@ static int ocfs2_mark_dquot_dirty(struct dquot *dquot)
 	handle_t *handle;
 	struct ocfs2_super *osb = OCFS2_SB(sb);
 
-	mlog_entry("id=%u, type=%d", dquot->dq_id, type);
+	mlog(0, "id=%u, type=%d", dquot->dq_id, type);
 
 	/* In case user set some limits, sync dquot immediately to global
 	 * quota file so that information propagates quicker */
@@ -879,8 +877,6 @@ static int ocfs2_write_info(struct super_block *sb, int type)
 	int status = 0;
 	struct ocfs2_mem_dqinfo *oinfo = sb_dqinfo(sb, type)->dqi_priv;
 
-	mlog_entry_void();
-
 	status = ocfs2_lock_global_qf(oinfo, 1);
 	if (status < 0)
 		goto out;
diff --git a/fs/ocfs2/quota_local.c b/fs/ocfs2/quota_local.c
index dc78764..a71d68d 100644
--- a/fs/ocfs2/quota_local.c
+++ b/fs/ocfs2/quota_local.c
@@ -475,7 +475,7 @@ static int ocfs2_recover_local_quota_file(struct inode *lqinode,
 	struct ocfs2_recovery_chunk *rchunk, *next;
 	qsize_t spacechange, inodechange;
 
-	mlog_entry("ino=%lu type=%u", (unsigned long)lqinode->i_ino, type);
+	mlog(0, "ino=%lu type=%u", (unsigned long)lqinode->i_ino, type);
 
 	list_for_each_entry_safe(rchunk, next, &(rec->r_list[type]), rc_list) {
 		chunk = rchunk->rc_chunk;
diff --git a/fs/ocfs2/resize.c b/fs/ocfs2/resize.c
index dacd553..e4a50e3 100644
--- a/fs/ocfs2/resize.c
+++ b/fs/ocfs2/resize.c
@@ -103,8 +103,8 @@ static int ocfs2_update_last_group_and_inode(handle_t *handle,
 	u16 cl_bpc = le16_to_cpu(cl->cl_bpc);
 	u16 cl_cpg = le16_to_cpu(cl->cl_cpg);
 
-	mlog_entry("(new_clusters=%d, first_new_cluster = %u)\n",
-		   new_clusters, first_new_cluster);
+	mlog(0, "(new_clusters=%d, first_new_cluster = %u)\n",
+	     new_clusters, first_new_cluster);
 
 	ret = ocfs2_journal_access_gd(handle, INODE_CACHE(bm_inode),
 				      group_bh, OCFS2_JOURNAL_ACCESS_WRITE);
@@ -281,8 +281,6 @@ int ocfs2_group_extend(struct inode * inode, int new_clusters)
 	u32 first_new_cluster;
 	u64 lgd_blkno;
 
-	mlog_entry_void();
-
 	if (ocfs2_is_hard_readonly(osb) || ocfs2_is_soft_readonly(osb))
 		return -EROFS;
 
@@ -472,8 +470,6 @@ int ocfs2_group_add(struct inode *inode, struct ocfs2_new_group_input *input)
 	struct ocfs2_chain_rec *cr;
 	u16 cl_bpc;
 
-	mlog_entry_void();
-
 	if (ocfs2_is_hard_readonly(osb) || ocfs2_is_soft_readonly(osb))
 		return -EROFS;
 
diff --git a/fs/ocfs2/slot_map.c b/fs/ocfs2/slot_map.c
index ab4e017..a6016e6 100644
--- a/fs/ocfs2/slot_map.c
+++ b/fs/ocfs2/slot_map.c
@@ -475,8 +475,6 @@ int ocfs2_find_slot(struct ocfs2_super *osb)
 	int slot;
 	struct ocfs2_slot_info *si;
 
-	mlog_entry_void();
-
 	si = osb->slot_info;
 
 	spin_lock(&osb->osb_lock);
diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index 5fed60d..2713046 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -389,8 +389,6 @@ static int ocfs2_block_group_fill(handle_t *handle,
 	struct ocfs2_group_desc *bg = (struct ocfs2_group_desc *) bg_bh->b_data;
 	struct super_block * sb = alloc_inode->i_sb;
 
-	mlog_entry_void();
-
 	if (((unsigned long long) bg_bh->b_blocknr) != group_blkno) {
 		ocfs2_error(alloc_inode->i_sb, "group block (%llu) != "
 			    "b_blocknr (%llu)",
@@ -707,8 +705,6 @@ static int ocfs2_block_group_alloc(struct ocfs2_super *osb,
 
 	BUG_ON(ocfs2_is_cluster_bitmap(alloc_inode));
 
-	mlog_entry_void();
-
 	cl = &fe->id2.i_chain;
 	status = ocfs2_reserve_clusters_with_limit(osb,
 						   le16_to_cpu(cl->cl_cpg),
@@ -814,8 +810,6 @@ static int ocfs2_reserve_suballoc_bits(struct ocfs2_super *osb,
 	struct ocfs2_dinode *fe;
 	u32 free_bits;
 
-	mlog_entry_void();
-
 	alloc_inode = ocfs2_get_system_file_inode(osb, type, slot);
 	if (!alloc_inode) {
 		mlog_errno(-EINVAL);
@@ -1189,8 +1183,6 @@ static int ocfs2_reserve_clusters_with_limit(struct ocfs2_super *osb,
 {
 	int status;
 
-	mlog_entry_void();
-
 	*ac = kzalloc(sizeof(struct ocfs2_alloc_context), GFP_KERNEL);
 	if (!(*ac)) {
 		status = -ENOMEM;
@@ -1357,8 +1349,6 @@ static inline int ocfs2_block_group_set_bits(handle_t *handle,
 	void *bitmap = bg->bg_bitmap;
 	int journal_type = OCFS2_JOURNAL_ACCESS_WRITE;
 
-	mlog_entry_void();
-
 	/* All callers get the descriptor via
 	 * ocfs2_read_group_descriptor().  Any corruption is a code bug. */
 	BUG_ON(!OCFS2_IS_VALID_GROUP_DESC(bg));
@@ -1888,8 +1878,6 @@ static int ocfs2_claim_suballoc_bits(struct ocfs2_alloc_context *ac,
 	struct ocfs2_chain_list *cl;
 	struct ocfs2_dinode *fe;
 
-	mlog_entry_void();
-
 	BUG_ON(ac->ac_bits_given >= ac->ac_bits_wanted);
 	BUG_ON(bits_wanted > (ac->ac_bits_wanted - ac->ac_bits_given));
 	BUG_ON(!ac->ac_bh);
@@ -2201,8 +2189,6 @@ int ocfs2_claim_new_inode(handle_t *handle,
 	int status;
 	struct ocfs2_suballoc_result res;
 
-	mlog_entry_void();
-
 	BUG_ON(!ac);
 	BUG_ON(ac->ac_bits_given != 0);
 	BUG_ON(ac->ac_bits_wanted != 1);
@@ -2307,8 +2293,6 @@ int __ocfs2_claim_clusters(handle_t *handle,
 	struct ocfs2_suballoc_result res = { .sr_blkno = 0, };
 	struct ocfs2_super *osb = OCFS2_SB(ac->ac_inode->i_sb);
 
-	mlog_entry_void();
-
 	BUG_ON(ac->ac_bits_given >= ac->ac_bits_wanted);
 
 	BUG_ON(ac->ac_which != OCFS2_AC_USE_LOCAL
@@ -2392,8 +2376,6 @@ static int ocfs2_block_group_clear_bits(handle_t *handle,
 	unsigned int tmp;
 	struct ocfs2_group_desc *undo_bg = NULL;
 
-	mlog_entry_void();
-
 	/* The caller got this descriptor from
 	 * ocfs2_read_group_descriptor().  Any corruption is a code bug. */
 	BUG_ON(!OCFS2_IS_VALID_GROUP_DESC(bg));
@@ -2463,8 +2445,6 @@ static int _ocfs2_free_suballoc_bits(handle_t *handle,
 	struct buffer_head *group_bh = NULL;
 	struct ocfs2_group_desc *group;
 
-	mlog_entry_void();
-
 	/* The alloc_bh comes from ocfs2_free_dinode() or
 	 * ocfs2_free_clusters().  The callers have all locked the
 	 * allocator and gotten alloc_bh from the lock call.  This
@@ -2556,11 +2536,8 @@ static int _ocfs2_free_clusters(handle_t *handle,
 
 	/* You can't ever have a contiguous set of clusters
 	 * bigger than a block group bitmap so we never have to worry
-	 * about looping on them. */
-
-	mlog_entry_void();
-
-	/* This is expensive. We can safely remove once this stuff has
+	 * about looping on them.
+	 * This is expensive. We can safely remove once this stuff has
 	 * gotten tested really well. */
 	BUG_ON(start_blk != ocfs2_clusters_to_blocks(bitmap_inode->i_sb, ocfs2_blocks_to_clusters(bitmap_inode->i_sb, start_blk)));
 
@@ -2756,7 +2733,7 @@ static int ocfs2_get_suballoc_slot_bit(struct ocfs2_super *osb, u64 blkno,
 	struct buffer_head *inode_bh = NULL;
 	struct ocfs2_dinode *inode_fe;
 
-	mlog_entry("blkno: %llu\n", (unsigned long long)blkno);
+	mlog(0, "blkno: %llu\n", (unsigned long long)blkno);
 
 	/* dirty read disk */
 	status = ocfs2_read_blocks_sync(osb, blkno, 1, &inode_bh);
@@ -2816,8 +2793,8 @@ static int ocfs2_test_suballoc_bit(struct ocfs2_super *osb,
 	u64 bg_blkno;
 	int status;
 
-	mlog_entry("blkno: %llu bit: %u\n", (unsigned long long)blkno,
-		   (unsigned int)bit);
+	mlog(0, "blkno: %llu bit: %u\n", (unsigned long long)blkno,
+	     (unsigned int)bit);
 
 	alloc_di = (struct ocfs2_dinode *)alloc_bh->b_data;
 	if ((bit + 1) > ocfs2_bits_per_group(&alloc_di->id2.i_chain)) {
@@ -2869,7 +2846,7 @@ int ocfs2_test_inode_bit(struct ocfs2_super *osb, u64 blkno, int *res)
 	struct inode *inode_alloc_inode;
 	struct buffer_head *alloc_bh = NULL;
 
-	mlog_entry("blkno: %llu", (unsigned long long)blkno);
+	mlog(0, "blkno: %llu", (unsigned long long)blkno);
 
 	status = ocfs2_get_suballoc_slot_bit(osb, blkno, &suballoc_slot,
 					     &group_blkno, &suballoc_bit);
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index cfeab7c..7572a2f 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -441,8 +441,6 @@ static int ocfs2_init_global_system_inodes(struct ocfs2_super *osb)
 	int status = 0;
 	int i;
 
-	mlog_entry_void();
-
 	new = ocfs2_iget(osb, osb->root_blkno, OCFS2_FI_FLAG_SYSFILE, 0);
 	if (IS_ERR(new)) {
 		status = PTR_ERR(new);
@@ -488,8 +486,6 @@ static int ocfs2_init_local_system_inodes(struct ocfs2_super *osb)
 	int status = 0;
 	int i;
 
-	mlog_entry_void();
-
 	for (i = OCFS2_LAST_GLOBAL_SYSTEM_INODE + 1;
 	     i < NUM_SYSTEM_INODES;
 	     i++) {
@@ -517,8 +513,6 @@ static void ocfs2_release_system_inodes(struct ocfs2_super *osb)
 	int i;
 	struct inode *inode;
 
-	mlog_entry_void();
-
 	for (i = 0; i < NUM_GLOBAL_SYSTEM_INODES; i++) {
 		inode = osb->global_system_inodes[i];
 		if (inode) {
@@ -1026,7 +1020,7 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 	char nodestr[8];
 	struct ocfs2_blockcheck_stats stats;
 
-	mlog_entry("%p, %p, %i", sb, data, silent);
+	mlog(0, "%p, %p, %i", sb, data, silent);
 
 	if (!ocfs2_parse_options(sb, data, &parsed_options, 0)) {
 		status = -EINVAL;
@@ -1314,8 +1308,8 @@ static int ocfs2_parse_options(struct super_block *sb,
 	char *p;
 	u32 tmp;
 
-	mlog_entry("remount: %d, options: \"%s\"\n", is_remount,
-		   options ? options : "(none)");
+	mlog(0, "remount: %d, options: \"%s\"\n", is_remount,
+	     options ? options : "(none)");
 
 	mopt->commit_interval = 0;
 	mopt->mount_opt = OCFS2_MOUNT_NOINTR;
@@ -1611,8 +1605,6 @@ static int __init ocfs2_init(void)
 {
 	int status;
 
-	mlog_entry_void();
-
 	ocfs2_print_version();
 
 	status = init_ocfs2_uptodate_cache();
@@ -1663,8 +1655,6 @@ leave:
 
 static void __exit ocfs2_exit(void)
 {
-	mlog_entry_void();
-
 	ocfs2_quota_shutdown();
 
 	if (ocfs2_wq) {
@@ -1687,7 +1677,7 @@ static void __exit ocfs2_exit(void)
 
 static void ocfs2_put_super(struct super_block *sb)
 {
-	mlog_entry("(0x%p)\n", sb);
+	mlog(0, "(0x%p)\n", sb);
 
 	ocfs2_sync_blockdev(sb);
 	ocfs2_dismount_volume(sb, 0);
@@ -1704,7 +1694,7 @@ static int ocfs2_statfs(struct dentry *dentry, struct kstatfs *buf)
 	struct buffer_head *bh = NULL;
 	struct inode *inode = NULL;
 
-	mlog_entry("(%p, %p)\n", dentry->d_sb, buf);
+	mlog(0, "(%p, %p)\n", dentry->d_sb, buf);
 
 	osb = OCFS2_SB(dentry->d_sb);
 
@@ -1871,8 +1861,6 @@ static int ocfs2_mount_volume(struct super_block *sb)
 	int unlock_super = 0;
 	struct ocfs2_super *osb = OCFS2_SB(sb);
 
-	mlog_entry_void();
-
 	if (ocfs2_is_hard_readonly(osb))
 		goto leave;
 
@@ -1927,7 +1915,7 @@ static void ocfs2_dismount_volume(struct super_block *sb, int mnt_err)
 	struct ocfs2_super *osb = NULL;
 	char nodestr[8];
 
-	mlog_entry("(0x%p)\n", sb);
+	mlog(0, "(0x%p)\n", sb);
 
 	BUG_ON(!sb);
 	osb = OCFS2_SB(sb);
@@ -2079,8 +2067,6 @@ static int ocfs2_initialize_super(struct super_block *sb,
 	struct ocfs2_super *osb;
 	u64 total_blocks;
 
-	mlog_entry_void();
-
 	osb = kzalloc(sizeof(struct ocfs2_super), GFP_KERNEL);
 	if (!osb) {
 		status = -ENOMEM;
@@ -2384,8 +2370,6 @@ static int ocfs2_verify_volume(struct ocfs2_dinode *di,
 {
 	int status = -EAGAIN;
 
-	mlog_entry_void();
-
 	if (memcmp(di->i_signature, OCFS2_SUPER_BLOCK_SIGNATURE,
 		   strlen(OCFS2_SUPER_BLOCK_SIGNATURE)) == 0) {
 		/* We have to do a raw check of the feature here */
@@ -2453,8 +2437,6 @@ static int ocfs2_check_volume(struct ocfs2_super *osb)
 						  * recover
 						  * ourselves. */
 
-	mlog_entry_void();
-
 	/* Init our journal object. */
 	status = ocfs2_journal_init(osb->journal, &dirty);
 	if (status < 0) {
@@ -2549,8 +2531,6 @@ finally:
  */
 static void ocfs2_delete_osb(struct ocfs2_super *osb)
 {
-	mlog_entry_void();
-
 	/* This function assumes that the caller has the main osb resource */
 
 	ocfs2_free_slot_info(osb);
diff --git a/fs/ocfs2/symlink.c b/fs/ocfs2/symlink.c
index 9975457..8a81688 100644
--- a/fs/ocfs2/symlink.c
+++ b/fs/ocfs2/symlink.c
@@ -62,8 +62,6 @@ static char *ocfs2_fast_symlink_getlink(struct inode *inode,
 	char *link = NULL;
 	struct ocfs2_dinode *fe;
 
-	mlog_entry_void();
-
 	status = ocfs2_read_inode_block(inode, bh);
 	if (status < 0) {
 		mlog_errno(status);
@@ -88,8 +86,6 @@ static int ocfs2_readlink(struct dentry *dentry,
 	struct buffer_head *bh = NULL;
 	struct inode *inode = dentry->d_inode;
 
-	mlog_entry_void();
-
 	link = ocfs2_fast_symlink_getlink(inode, &bh);
 	if (IS_ERR(link)) {
 		ret = PTR_ERR(link);
@@ -117,8 +113,6 @@ static void *ocfs2_fast_follow_link(struct dentry *dentry,
 	struct inode *inode = dentry->d_inode;
 	struct buffer_head *bh = NULL;
 
-	mlog_entry_void();
-
 	BUG_ON(!ocfs2_inode_is_fast_symlink(inode));
 	target = ocfs2_fast_symlink_getlink(inode, &bh);
 	if (IS_ERR(target)) {
diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 67cd439..81f98b7 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -5538,7 +5538,7 @@ static int ocfs2_xattr_set_entry_bucket(struct inode *inode,
 	int ret;
 	struct ocfs2_xa_loc loc;
 
-	mlog_entry("Set xattr %s in xattr bucket\n", xi->xi_name);
+	mlog(0, "Set xattr %s in xattr bucket\n", xi->xi_name);
 
 	ocfs2_init_xattr_bucket_xa_loc(&loc, xs->bucket,
 				       xs->not_found ? NULL : xs->here);
@@ -5581,7 +5581,7 @@ static int ocfs2_xattr_set_entry_index_block(struct inode *inode,
 {
 	int ret;
 
-	mlog_entry("Set xattr %s in xattr index block\n", xi->xi_name);
+	mlog(0, "Set xattr %s in xattr index block\n", xi->xi_name);
 
 	ret = ocfs2_xattr_set_entry_bucket(inode, xi, xs, ctxt);
 	if (!ret)
-- 
1.7.0.4
