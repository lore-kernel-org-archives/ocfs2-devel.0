From: Tao Ma <tm@tao.ma>
Date: Thu, 23 Dec 2010 15:30:46 +0800
Subject: [Ocfs2-devel] [PATCH 03/34] ocfs2: Remove EXIT from masklog.
In-Reply-To: <4D12F7E7.1090204@tao.ma>
References: <4D12F7E7.1090204@tao.ma>
Message-ID: <1293089477-5019-3-git-send-email-tm@tao.ma>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Tao Ma <tao.ma@oracle.com>

mlog_exit is used to record the exit status of a function.
But because it is added in so many functions, if we enable it,
the system logs get filled up quickly and cause too much I/O.
So actually no one can open it for a production system or even
for a test.

This patch just try to remove it. So in case of report error, a
mlog_errno is used while if all the errors in the function are
properly reported, mlog_exit is just removed.
for mlog_exit:
1. if all the error paths already use mlog_errno, it is just removed.
   Otherwise, it will be replaced by mlog_errno.
2. if it is used to print some return value, it is replaced with
   mlog(0,...).
mlog_exit_ptr is changed to mlog(0.
All those mlog(0,...) will be replaced with trace events later.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/alloc.c             |   26 +++------------
 fs/ocfs2/aops.c              |   19 ++---------
 fs/ocfs2/buffer_head_io.c    |    7 ++--
 fs/ocfs2/cluster/heartbeat.c |    1 -
 fs/ocfs2/cluster/masklog.c   |    3 +-
 fs/ocfs2/cluster/masklog.h   |   44 --------------------------
 fs/ocfs2/dcache.c            |    3 +-
 fs/ocfs2/dir.c               |   20 ++++++------
 fs/ocfs2/dlm/dlmrecovery.c   |    5 +--
 fs/ocfs2/dlmglue.c           |   71 +++--------------------------------------
 fs/ocfs2/export.c            |    6 ++--
 fs/ocfs2/extent_map.c        |    1 -
 fs/ocfs2/file.c              |   21 +-----------
 fs/ocfs2/inode.c             |   15 +--------
 fs/ocfs2/ioctl.c             |    2 -
 fs/ocfs2/journal.c           |   19 -----------
 fs/ocfs2/localalloc.c        |   35 ++++++++++++---------
 fs/ocfs2/mmap.c              |    2 +-
 fs/ocfs2/namei.c             |   47 ++++++++++++++++++---------
 fs/ocfs2/quota_global.c      |   17 ++++++----
 fs/ocfs2/quota_local.c       |    3 +-
 fs/ocfs2/resize.c            |    6 +--
 fs/ocfs2/slot_map.c          |    1 -
 fs/ocfs2/suballoc.c          |   54 +++++++++++++++++++++----------
 fs/ocfs2/super.c             |   37 ++++++++-------------
 fs/ocfs2/symlink.c           |    7 ++--
 fs/ocfs2/xattr.c             |    2 -
 27 files changed, 159 insertions(+), 315 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index c12e9d8..9ab3f27 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -985,7 +985,7 @@ int ocfs2_num_free_extents(struct ocfs2_super *osb,
 bail:
 	brelse(eb_bh);
 
-	mlog_exit(retval);
+	mlog(0, "retval = %d\n", retval);
 	return retval;
 }
 
@@ -1070,8 +1070,8 @@ bail:
 			brelse(bhs[i]);
 			bhs[i] = NULL;
 		}
+		mlog_errno(status);
 	}
-	mlog_exit(status);
 	return status;
 }
 
@@ -1326,7 +1326,6 @@ bail:
 		kfree(new_eb_bhs);
 	}
 
-	mlog_exit(status);
 	return status;
 }
 
@@ -1407,7 +1406,6 @@ static int ocfs2_shift_tree_depth(handle_t *handle,
 bail:
 	brelse(new_eb_bh);
 
-	mlog_exit(status);
 	return status;
 }
 
@@ -1493,7 +1491,6 @@ static int ocfs2_find_branch_target(struct ocfs2_extent_tree *et,
 bail:
 	brelse(bh);
 
-	mlog_exit(status);
 	return status;
 }
 
@@ -4552,7 +4549,7 @@ static int ocfs2_figure_insert_type(struct ocfs2_extent_tree *et,
 					      ocfs2_et_get_last_eb_blk(et),
 					      &bh);
 		if (ret) {
-			mlog_exit(ret);
+			mlog_errno(ret);
 			goto out;
 		}
 		eb = (struct ocfs2_extent_block *) bh->b_data;
@@ -4716,7 +4713,6 @@ int ocfs2_insert_extent(handle_t *handle,
 bail:
 	brelse(last_eb_bh);
 
-	mlog_exit(status);
 	return status;
 }
 
@@ -4818,7 +4814,6 @@ int ocfs2_add_clusters_in_btree(handle_t *handle,
 	}
 
 leave:
-	mlog_exit(status);
 	if (reason_ret)
 		*reason_ret = reason;
 	return status;
@@ -5029,7 +5024,7 @@ int ocfs2_split_extent(handle_t *handle,
 					      ocfs2_et_get_last_eb_blk(et),
 					      &last_eb_bh);
 		if (ret) {
-			mlog_exit(ret);
+			mlog_errno(ret);
 			goto out;
 		}
 
@@ -5848,7 +5843,6 @@ int ocfs2_truncate_log_append(struct ocfs2_super *osb,
 	ocfs2_journal_dirty(handle, tl_bh);
 
 bail:
-	mlog_exit(status);
 	return status;
 }
 
@@ -5917,7 +5911,6 @@ static int ocfs2_replay_truncate_records(struct ocfs2_super *osb,
 	}
 
 bail:
-	mlog_exit(status);
 	return status;
 }
 
@@ -5992,7 +5985,6 @@ out_mutex:
 	iput(data_alloc_inode);
 
 out:
-	mlog_exit(status);
 	return status;
 }
 
@@ -6020,8 +6012,6 @@ static void ocfs2_truncate_log_worker(struct work_struct *work)
 		mlog_errno(status);
 	else
 		ocfs2_init_steal_slots(osb);
-
-	mlog_exit(status);
 }
 
 #define OCFS2_TRUNCATE_LOG_FLUSH_INTERVAL (2 * HZ)
@@ -6067,7 +6057,6 @@ static int ocfs2_get_truncate_log_info(struct ocfs2_super *osb,
 	*tl_inode = inode;
 	*tl_bh    = bh;
 bail:
-	mlog_exit(status);
 	return status;
 }
 
@@ -6138,9 +6127,9 @@ bail:
 	if (status < 0 && (*tl_copy)) {
 		kfree(*tl_copy);
 		*tl_copy = NULL;
+		mlog_errno(status);
 	}
 
-	mlog_exit(status);
 	return status;
 }
 
@@ -6198,7 +6187,6 @@ int ocfs2_complete_truncate_log_recovery(struct ocfs2_super *osb,
 bail_up:
 	mutex_unlock(&tl_inode->i_mutex);
 
-	mlog_exit(status);
 	return status;
 }
 
@@ -6218,8 +6206,6 @@ void ocfs2_truncate_log_shutdown(struct ocfs2_super *osb)
 		brelse(osb->osb_tl_bh);
 		iput(osb->osb_tl_inode);
 	}
-
-	mlog_exit_void();
 }
 
 int ocfs2_truncate_log_init(struct ocfs2_super *osb)
@@ -6243,7 +6229,6 @@ int ocfs2_truncate_log_init(struct ocfs2_super *osb)
 	osb->osb_tl_bh    = tl_bh;
 	osb->osb_tl_inode = tl_inode;
 
-	mlog_exit(status);
 	return status;
 }
 
@@ -7109,7 +7094,6 @@ bail:
 
 	ocfs2_free_path(path);
 
-	mlog_exit(status);
 	return status;
 }
 
diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 9bff526..177b8b4 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -123,7 +123,6 @@ static int ocfs2_symlink_get_block(struct inode *inode, sector_t iblock,
 bail:
 	brelse(bh);
 
-	mlog_exit(err);
 	return err;
 }
 
@@ -208,7 +207,6 @@ bail:
 	if (err < 0)
 		err = -EIO;
 
-	mlog_exit(err);
 	return err;
 }
 
@@ -323,7 +321,6 @@ out_inode_unlock:
 out:
 	if (unlock)
 		unlock_page(page);
-	mlog_exit(ret);
 	return ret;
 }
 
@@ -402,8 +399,6 @@ static int ocfs2_writepage(struct page *page, struct writeback_control *wbc)
 
 	ret = block_write_full_page(page, ocfs2_get_block, wbc);
 
-	mlog_exit(ret);
-
 	return ret;
 }
 
@@ -484,8 +479,6 @@ static sector_t ocfs2_bmap(struct address_space *mapping, sector_t block)
 bail:
 	status = err ? 0 : p_blkno;
 
-	mlog_exit((int)status);
-
 	return status;
 }
 
@@ -613,7 +606,6 @@ static ssize_t ocfs2_direct_IO(int rw,
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file->f_path.dentry->d_inode->i_mapping->host;
-	int ret;
 
 	/*
 	 * Fallback to buffered I/O if we see an inode without
@@ -626,13 +618,10 @@ static ssize_t ocfs2_direct_IO(int rw,
 	if (i_size_read(inode) <= offset)
 		return 0;
 
-	ret = __blockdev_direct_IO(rw, iocb, inode, inode->i_sb->s_bdev,
-				   iov, offset, nr_segs,
-				   ocfs2_direct_IO_get_blocks,
-				   ocfs2_dio_end_io, NULL, 0);
-
-	mlog_exit(ret);
-	return ret;
+	return __blockdev_direct_IO(rw, iocb, inode, inode->i_sb->s_bdev,
+				    iov, offset, nr_segs,
+				    ocfs2_direct_IO_get_blocks,
+				    ocfs2_dio_end_io, NULL, 0);
 }
 
 static void ocfs2_figure_cluster_boundaries(struct ocfs2_super *osb,
diff --git a/fs/ocfs2/buffer_head_io.c b/fs/ocfs2/buffer_head_io.c
index 024bd45..c23846d 100644
--- a/fs/ocfs2/buffer_head_io.c
+++ b/fs/ocfs2/buffer_head_io.c
@@ -66,6 +66,7 @@ int ocfs2_write_block(struct ocfs2_super *osb, struct buffer_head *bh,
 	 * can get modified during recovery even if read-only. */
 	if (ocfs2_is_hard_readonly(osb)) {
 		ret = -EROFS;
+		mlog_errno(ret);
 		goto out;
 	}
 
@@ -91,11 +92,11 @@ int ocfs2_write_block(struct ocfs2_super *osb, struct buffer_head *bh,
 		 * uptodate. */
 		ret = -EIO;
 		put_bh(bh);
+		mlog_errno(ret);
 	}
 
 	ocfs2_metadata_cache_io_unlock(ci);
 out:
-	mlog_exit(ret);
 	return ret;
 }
 
@@ -374,7 +375,6 @@ int ocfs2_read_blocks(struct ocfs2_caching_info *ci, u64 block, int nr,
 
 bail:
 
-	mlog_exit(status);
 	return status;
 }
 
@@ -413,6 +413,7 @@ int ocfs2_write_super_or_backup(struct ocfs2_super *osb,
 
 	if (ocfs2_is_hard_readonly(osb) || ocfs2_is_soft_readonly(osb)) {
 		ret = -EROFS;
+		mlog_errno(ret);
 		goto out;
 	}
 
@@ -432,9 +433,9 @@ int ocfs2_write_super_or_backup(struct ocfs2_super *osb,
 	if (!buffer_uptodate(bh)) {
 		ret = -EIO;
 		put_bh(bh);
+		mlog_errno(ret);
 	}
 
 out:
-	mlog_exit(ret);
 	return ret;
 }
diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index 4301242..21dfea8 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -1624,7 +1624,6 @@ static int o2hb_populate_slot_data(struct o2hb_region *reg)
 	}
 
 out:
-	mlog_exit(ret);
 	return ret;
 }
 
diff --git a/fs/ocfs2/cluster/masklog.c b/fs/ocfs2/cluster/masklog.c
index b9ff806..41260fb 100644
--- a/fs/ocfs2/cluster/masklog.c
+++ b/fs/ocfs2/cluster/masklog.c
@@ -30,7 +30,7 @@
 
 struct mlog_bits mlog_and_bits = MLOG_BITS_RHS(MLOG_INITIAL_AND_MASK);
 EXPORT_SYMBOL_GPL(mlog_and_bits);
-struct mlog_bits mlog_not_bits = MLOG_BITS_RHS(MLOG_INITIAL_NOT_MASK);
+struct mlog_bits mlog_not_bits = MLOG_BITS_RHS(0);
 EXPORT_SYMBOL_GPL(mlog_not_bits);
 
 static ssize_t mlog_mask_show(u64 mask, char *buf)
@@ -80,7 +80,6 @@ struct mlog_attribute {
 }
 
 static struct mlog_attribute mlog_attrs[MLOG_MAX_BITS] = {
-	define_mask(EXIT),
 	define_mask(TCP),
 	define_mask(MSG),
 	define_mask(SOCKET),
diff --git a/fs/ocfs2/cluster/masklog.h b/fs/ocfs2/cluster/masklog.h
index 72d3599..707e119 100644
--- a/fs/ocfs2/cluster/masklog.h
+++ b/fs/ocfs2/cluster/masklog.h
@@ -82,7 +82,6 @@
 
 /* bits that are frequently given and infrequently matched in the low word */
 /* NOTE: If you add a flag, you need to also update mlog.c! */
-#define ML_EXIT		0x0000000000000002ULL /* func call exit */
 #define ML_TCP		0x0000000000000004ULL /* net cluster/tcp.c */
 #define ML_MSG		0x0000000000000008ULL /* net network messages */
 #define ML_SOCKET	0x0000000000000010ULL /* net socket lifetime */
@@ -122,7 +121,6 @@
 #define ML_CLUSTER	0x0000001000000000ULL /* cluster stack */
 
 #define MLOG_INITIAL_AND_MASK (ML_ERROR|ML_NOTICE)
-#define MLOG_INITIAL_NOT_MASK (ML_EXIT)
 #ifndef MLOG_MASK_PREFIX
 #define MLOG_MASK_PREFIX 0
 #endif
@@ -220,48 +218,6 @@ extern struct mlog_bits mlog_and_bits, mlog_not_bits;
 		mlog(ML_ERROR, "status = %lld\n", (long long)_st);	\
 } while (0)
 
-#if defined(CONFIG_OCFS2_DEBUG_MASKLOG)
-/*
- * We disable this for sparse.
- */
-#if !defined(__CHECKER__)
-#define mlog_exit(st) do {						     \
-	if (__builtin_types_compatible_p(typeof(st), unsigned long))	     \
-		mlog(ML_EXIT, "EXIT: %lu\n", (unsigned long) (st));	     \
-	else if (__builtin_types_compatible_p(typeof(st), signed long))      \
-		mlog(ML_EXIT, "EXIT: %ld\n", (signed long) (st));	     \
-	else if (__builtin_types_compatible_p(typeof(st), unsigned int)	     \
-		 || __builtin_types_compatible_p(typeof(st), unsigned short) \
-		 || __builtin_types_compatible_p(typeof(st), unsigned char)) \
-		mlog(ML_EXIT, "EXIT: %u\n", (unsigned int) (st));	     \
-	else if (__builtin_types_compatible_p(typeof(st), signed int)	     \
-		 || __builtin_types_compatible_p(typeof(st), signed short)   \
-		 || __builtin_types_compatible_p(typeof(st), signed char))   \
-		mlog(ML_EXIT, "EXIT: %d\n", (signed int) (st));		     \
-	else if (__builtin_types_compatible_p(typeof(st), long long))	     \
-		mlog(ML_EXIT, "EXIT: %lld\n", (long long) (st));	     \
-	else								     \
-		mlog(ML_EXIT, "EXIT: %llu\n", (unsigned long long) (st));    \
-} while (0)
-#else
-#define mlog_exit(st) do {						     \
-	mlog(ML_EXIT, "EXIT: %lld\n", (long long) (st));		     \
-} while (0)
-#endif
-
-#define mlog_exit_ptr(ptr) do {						\
-	mlog(ML_EXIT, "EXIT: %p\n", ptr);				\
-} while (0)
-
-#define mlog_exit_void() do {						\
-	mlog(ML_EXIT, "EXIT\n");					\
-} while (0)
-#else
-#define mlog_exit(...)  do { } while (0)
-#define mlog_exit_ptr(...)  do { } while (0)
-#define mlog_exit_void(...)  do { } while (0)
-#endif  /* defined(CONFIG_OCFS2_DEBUG_MASKLOG) */
-
 #define mlog_bug_on_msg(cond, fmt, args...) do {			\
 	if (cond) {							\
 		mlog(ML_ERROR, "bug expression: " #cond "\n");		\
diff --git a/fs/ocfs2/dcache.c b/fs/ocfs2/dcache.c
index 351f3d0..866d767 100644
--- a/fs/ocfs2/dcache.c
+++ b/fs/ocfs2/dcache.c
@@ -117,8 +117,7 @@ valid:
 	ret = 1;
 
 bail:
-	mlog_exit(ret);
-
+	mlog(0, "ret = %d\n", ret);
 	return ret;
 }
 
diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index 7483e9e..65546e3 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -400,7 +400,7 @@ static int inline ocfs2_search_dirblock(struct buffer_head *bh,
 	}
 
 bail:
-	mlog_exit(ret);
+	mlog(0, "ret = %d\n", ret);
 	return ret;
 }
 
@@ -784,7 +784,7 @@ cleanup_and_exit:
 	for (; ra_ptr < ra_max; ra_ptr++)
 		brelse(bh_use[ra_ptr]);
 
-	mlog_exit_ptr(ret);
+	mlog(0, "ret = %p\n", ret);
 	return ret;
 }
 
@@ -1198,7 +1198,6 @@ static int __ocfs2_delete_entry(handle_t *handle, struct inode *dir,
 		de = (struct ocfs2_dir_entry *)((char *)de + le16_to_cpu(de->rec_len));
 	}
 bail:
-	mlog_exit(status);
 	return status;
 }
 
@@ -1759,8 +1758,9 @@ int __ocfs2_add_entry(handle_t *handle,
 	 * from ever getting here. */
 	retval = -ENOSPC;
 bail:
+	if (retval)
+		mlog_errno(retval);
 
-	mlog_exit(retval);
 	return retval;
 }
 
@@ -2045,9 +2045,10 @@ int ocfs2_readdir(struct file * filp, void * dirent, filldir_t filldir)
 				      dirent, filldir, NULL);
 
 	ocfs2_inode_unlock(inode, lock_level);
+	if (error)
+		mlog_errno(error);
 
 bail_nolock:
-	mlog_exit(error);
 
 	return error;
 }
@@ -2119,7 +2120,8 @@ int ocfs2_check_dir_for_entry(struct inode *dir,
 bail:
 	ocfs2_free_dir_lookup_result(&lookup);
 
-	mlog_exit(ret);
+	if (ret)
+		mlog_errno(ret);
 	return ret;
 }
 
@@ -2372,7 +2374,6 @@ static int ocfs2_fill_new_dir_el(struct ocfs2_super *osb,
 bail:
 	brelse(new_bh);
 
-	mlog_exit(status);
 	return status;
 }
 
@@ -3225,7 +3226,6 @@ static int ocfs2_do_extend_dir(struct super_block *sb,
 bail:
 	if (did_quota && status < 0)
 		dquot_free_space_nodirty(dir, ocfs2_clusters_to_bytes(sb, 1));
-	mlog_exit(status);
 	return status;
 }
 
@@ -3424,7 +3424,6 @@ bail:
 
 	brelse(new_bh);
 
-	mlog_exit(status);
 	return status;
 }
 
@@ -3571,8 +3570,9 @@ next:
 	status = 0;
 bail:
 	brelse(bh);
+	if (status)
+		mlog_errno(status);
 
-	mlog_exit(status);
 	return status;
 }
 
diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
index 6602b23..f1beb6f 100644
--- a/fs/ocfs2/dlm/dlmrecovery.c
+++ b/fs/ocfs2/dlm/dlmrecovery.c
@@ -727,7 +727,6 @@ static int dlm_remaster_locks(struct dlm_ctxt *dlm, u8 dead_node)
 	if (destroy)
 		dlm_destroy_recovery_area(dlm, dead_node);
 
-	mlog_exit(status);
 	return status;
 }
 
@@ -1496,9 +1495,9 @@ leave:
 			kfree(buf);
 		if (item)
 			kfree(item);
+		mlog_errno(ret);
 	}
 
-	mlog_exit(ret);
 	return ret;
 }
 
@@ -1567,7 +1566,6 @@ leave:
 		dlm_lockres_put(res);
 	}
 	kfree(data);
-	mlog_exit(ret);
 }
 
 
@@ -1986,7 +1984,6 @@ leave:
 			dlm_lock_put(newlock);
 	}
 
-	mlog_exit(ret);
 	return ret;
 }
 
diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index c2f3fa1..7eb4b8d 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -406,8 +406,6 @@ static void ocfs2_build_lock_name(enum ocfs2_lock_type type,
 	BUG_ON(len != (OCFS2_LOCK_ID_MAX_LEN - 1));
 
 	mlog(0, "built lock resource with name: %s\n", name);
-
-	mlog_exit_void();
 }
 
 static DEFINE_SPINLOCK(ocfs2_dlm_tracking_lock);
@@ -752,7 +750,6 @@ void ocfs2_lock_res_free(struct ocfs2_lock_res *res)
 	memset(&res->l_lksb, 0, sizeof(res->l_lksb));
 
 	res->l_flags = 0UL;
-	mlog_exit_void();
 }
 
 static inline void ocfs2_inc_holders(struct ocfs2_lock_res *lockres,
@@ -770,8 +767,6 @@ static inline void ocfs2_inc_holders(struct ocfs2_lock_res *lockres,
 	default:
 		BUG();
 	}
-
-	mlog_exit_void();
 }
 
 static inline void ocfs2_dec_holders(struct ocfs2_lock_res *lockres,
@@ -791,7 +786,6 @@ static inline void ocfs2_dec_holders(struct ocfs2_lock_res *lockres,
 	default:
 		BUG();
 	}
-	mlog_exit_void();
 }
 
 /* WARNING: This function lives in a world where the only three lock
@@ -850,8 +844,6 @@ static inline void ocfs2_generic_handle_downconvert_action(struct ocfs2_lock_res
 		lockres_clear_flags(lockres, OCFS2_LOCK_BLOCKED);
 	}
 	lockres_clear_flags(lockres, OCFS2_LOCK_BUSY);
-
-	mlog_exit_void();
 }
 
 static inline void ocfs2_generic_handle_convert_action(struct ocfs2_lock_res *lockres)
@@ -877,8 +869,6 @@ static inline void ocfs2_generic_handle_convert_action(struct ocfs2_lock_res *lo
 	lockres_or_flags(lockres, OCFS2_LOCK_UPCONVERT_FINISHING);
 
 	lockres_clear_flags(lockres, OCFS2_LOCK_BUSY);
-
-	mlog_exit_void();
 }
 
 static inline void ocfs2_generic_handle_attach_action(struct ocfs2_lock_res *lockres)
@@ -894,8 +884,6 @@ static inline void ocfs2_generic_handle_attach_action(struct ocfs2_lock_res *loc
 	lockres->l_level = lockres->l_requested;
 	lockres_or_flags(lockres, OCFS2_LOCK_ATTACHED);
 	lockres_clear_flags(lockres, OCFS2_LOCK_BUSY);
-
-	mlog_exit_void();
 }
 
 static int ocfs2_generic_handle_bast(struct ocfs2_lock_res *lockres,
@@ -923,8 +911,7 @@ static int ocfs2_generic_handle_bast(struct ocfs2_lock_res *lockres,
 
 	if (needs_downconvert)
 		lockres_or_flags(lockres, OCFS2_LOCK_BLOCKED);
-
-	mlog_exit(needs_downconvert);
+	mlog(0, "needs_downconvert = %d\n", needs_downconvert);
 	return needs_downconvert;
 }
 
@@ -1145,7 +1132,6 @@ static void ocfs2_unlock_ast(struct ocfs2_dlm_lksb *lksb, int error)
 		     "unlock_action %d\n", error, lockres->l_name,
 		     lockres->l_unlock_action);
 		spin_unlock_irqrestore(&lockres->l_lock, flags);
-		mlog_exit_void();
 		return;
 	}
 
@@ -1169,8 +1155,6 @@ static void ocfs2_unlock_ast(struct ocfs2_dlm_lksb *lksb, int error)
 	lockres->l_unlock_action = OCFS2_UNLOCK_INVALID;
 	wake_up(&lockres->l_event);
 	spin_unlock_irqrestore(&lockres->l_lock, flags);
-
-	mlog_exit_void();
 }
 
 /*
@@ -1226,7 +1210,6 @@ static inline void ocfs2_recover_from_dlm_error(struct ocfs2_lock_res *lockres,
 	spin_unlock_irqrestore(&lockres->l_lock, flags);
 
 	wake_up(&lockres->l_event);
-	mlog_exit_void();
 }
 
 /* Note: If we detect another process working on the lock (i.e.,
@@ -1273,7 +1256,6 @@ static int ocfs2_lock_create(struct ocfs2_super *osb,
 	mlog(0, "lock %s, return from ocfs2_dlm_lock\n", lockres->l_name);
 
 bail:
-	mlog_exit(ret);
 	return ret;
 }
 
@@ -1561,7 +1543,6 @@ out:
 				caller_ip);
 	}
 #endif
-	mlog_exit(ret);
 	return ret;
 }
 
@@ -1591,7 +1572,6 @@ static void __ocfs2_cluster_unlock(struct ocfs2_super *osb,
 	if (lockres->l_lockdep_map.key != NULL)
 		rwsem_release(&lockres->l_lockdep_map, 1, caller_ip);
 #endif
-	mlog_exit_void();
 }
 
 static int ocfs2_create_new_lock(struct ocfs2_super *osb,
@@ -1658,7 +1638,6 @@ int ocfs2_create_new_inode_locks(struct inode *inode)
 	}
 
 bail:
-	mlog_exit(ret);
 	return ret;
 }
 
@@ -1674,10 +1653,8 @@ int ocfs2_rw_lock(struct inode *inode, int write)
 	     (unsigned long long)OCFS2_I(inode)->ip_blkno,
 	     write ? "EXMODE" : "PRMODE");
 
-	if (ocfs2_mount_local(osb)) {
-		mlog_exit(0);
+	if (ocfs2_mount_local(osb))
 		return 0;
-	}
 
 	lockres = &OCFS2_I(inode)->ip_rw_lockres;
 
@@ -1688,7 +1665,6 @@ int ocfs2_rw_lock(struct inode *inode, int write)
 	if (status < 0)
 		mlog_errno(status);
 
-	mlog_exit(status);
 	return status;
 }
 
@@ -1704,8 +1680,6 @@ void ocfs2_rw_unlock(struct inode *inode, int write)
 
 	if (!ocfs2_mount_local(osb))
 		ocfs2_cluster_unlock(OCFS2_SB(inode->i_sb), lockres, level);
-
-	mlog_exit_void();
 }
 
 /*
@@ -1733,7 +1707,6 @@ int ocfs2_open_lock(struct inode *inode)
 		mlog_errno(status);
 
 out:
-	mlog_exit(status);
 	return status;
 }
 
@@ -1766,7 +1739,6 @@ int ocfs2_try_open_lock(struct inode *inode, int write)
 				    level, DLM_LKF_NOQUEUE, 0);
 
 out:
-	mlog_exit(status);
 	return status;
 }
 
@@ -1792,7 +1764,7 @@ void ocfs2_open_unlock(struct inode *inode)
 				     DLM_LOCK_EX);
 
 out:
-	mlog_exit_void();
+	return;
 }
 
 static int ocfs2_flock_handle_signal(struct ocfs2_lock_res *lockres,
@@ -2028,8 +2000,6 @@ static void ocfs2_downconvert_on_unlock(struct ocfs2_super *osb,
 
 	if (kick)
 		ocfs2_wake_downconvert_thread(osb);
-
-	mlog_exit_void();
 }
 
 #define OCFS2_SEC_BITS   34
@@ -2089,8 +2059,6 @@ static void __ocfs2_stuff_meta_lvb(struct inode *inode)
 
 out:
 	mlog_meta_lvb(0, lockres);
-
-	mlog_exit_void();
 }
 
 static void ocfs2_unpack_timespec(struct timespec *spec,
@@ -2136,8 +2104,6 @@ static void ocfs2_refresh_inode_from_lvb(struct inode *inode)
 	ocfs2_unpack_timespec(&inode->i_ctime,
 			      be64_to_cpu(lvb->lvb_ictime_packed));
 	spin_unlock(&oi->ip_lock);
-
-	mlog_exit_void();
 }
 
 static inline int ocfs2_meta_lvb_is_trustable(struct inode *inode,
@@ -2184,7 +2150,7 @@ refresh_check:
 
 	status = 1;
 bail:
-	mlog_exit(status);
+	mlog(0, "status %d\n", status);
 	return status;
 }
 
@@ -2202,8 +2168,6 @@ static inline void ocfs2_complete_lock_res_refresh(struct ocfs2_lock_res *lockre
 	spin_unlock_irqrestore(&lockres->l_lock, flags);
 
 	wake_up(&lockres->l_event);
-
-	mlog_exit_void();
 }
 
 /* may or may not return a bh if it went to disk. */
@@ -2284,7 +2248,6 @@ static int ocfs2_inode_lock_update(struct inode *inode,
 bail_refresh:
 	ocfs2_complete_lock_res_refresh(lockres, status);
 bail:
-	mlog_exit(status);
 	return status;
 }
 
@@ -2419,7 +2382,6 @@ bail:
 	if (local_bh)
 		brelse(local_bh);
 
-	mlog_exit(status);
 	return status;
 }
 
@@ -2496,7 +2458,6 @@ int ocfs2_inode_lock_atime(struct inode *inode,
 	} else
 		*level = 0;
 
-	mlog_exit(ret);
 	return ret;
 }
 
@@ -2514,8 +2475,6 @@ void ocfs2_inode_unlock(struct inode *inode,
 	if (!ocfs2_is_hard_readonly(OCFS2_SB(inode->i_sb)) &&
 	    !ocfs2_mount_local(osb))
 		ocfs2_cluster_unlock(OCFS2_SB(inode->i_sb), lockres, level);
-
-	mlog_exit_void();
 }
 
 int ocfs2_orphan_scan_lock(struct ocfs2_super *osb, u32 *seqno)
@@ -2597,7 +2556,6 @@ int ocfs2_super_lock(struct ocfs2_super *osb,
 		ocfs2_track_lock_refresh(lockres);
 	}
 bail:
-	mlog_exit(status);
 	return status;
 }
 
@@ -3057,7 +3015,6 @@ bail:
 			kthread_stop(osb->dc_task);
 	}
 
-	mlog_exit(status);
 	return status;
 }
 
@@ -3086,8 +3043,6 @@ void ocfs2_dlm_shutdown(struct ocfs2_super *osb,
 	osb->cconn = NULL;
 
 	ocfs2_dlm_shutdown_debug(osb);
-
-	mlog_exit_void();
 }
 
 static int ocfs2_drop_lock(struct ocfs2_super *osb,
@@ -3169,7 +3124,6 @@ static int ocfs2_drop_lock(struct ocfs2_super *osb,
 
 	ocfs2_wait_on_busy_lock(lockres);
 out:
-	mlog_exit(0);
 	return 0;
 }
 
@@ -3251,7 +3205,6 @@ int ocfs2_drop_inode_locks(struct inode *inode)
 	if (err < 0 && !status)
 		status = err;
 
-	mlog_exit(status);
 	return status;
 }
 
@@ -3314,7 +3267,6 @@ static int ocfs2_downconvert_lock(struct ocfs2_super *osb,
 
 	ret = 0;
 bail:
-	mlog_exit(ret);
 	return ret;
 }
 
@@ -3362,7 +3314,6 @@ static int ocfs2_cancel_convert(struct ocfs2_super *osb,
 
 	mlog(ML_BASTS, "lockres %s\n", lockres->l_name);
 
-	mlog_exit(ret);
 	return ret;
 }
 
@@ -3552,14 +3503,14 @@ downconvert:
 				     gen);
 
 leave:
-	mlog_exit(ret);
+	if (ret)
+		mlog_errno(ret);
 	return ret;
 
 leave_requeue:
 	spin_unlock_irqrestore(&lockres->l_lock, flags);
 	ctl->requeue = 1;
 
-	mlog_exit(0);
 	return 0;
 }
 
@@ -3800,8 +3751,6 @@ static void ocfs2_set_qinfo_lvb(struct ocfs2_lock_res *lockres)
 	lvb->lvb_blocks = cpu_to_be32(oinfo->dqi_gi.dqi_blocks);
 	lvb->lvb_free_blk = cpu_to_be32(oinfo->dqi_gi.dqi_free_blk);
 	lvb->lvb_free_entry = cpu_to_be32(oinfo->dqi_gi.dqi_free_entry);
-
-	mlog_exit_void();
 }
 
 void ocfs2_qinfo_unlock(struct ocfs2_mem_dqinfo *oinfo, int ex)
@@ -3812,7 +3761,6 @@ void ocfs2_qinfo_unlock(struct ocfs2_mem_dqinfo *oinfo, int ex)
 
 	if (!ocfs2_is_hard_readonly(osb) && !ocfs2_mount_local(osb))
 		ocfs2_cluster_unlock(osb, lockres, level);
-	mlog_exit_void();
 }
 
 static int ocfs2_refresh_qinfo(struct ocfs2_mem_dqinfo *oinfo)
@@ -3889,7 +3837,6 @@ int ocfs2_qinfo_lock(struct ocfs2_mem_dqinfo *oinfo, int ex)
 		ocfs2_qinfo_unlock(oinfo, ex);
 	ocfs2_complete_lock_res_refresh(lockres, status);
 bail:
-	mlog_exit(status);
 	return status;
 }
 
@@ -3968,8 +3915,6 @@ unqueue:
 	if (ctl.unblock_action != UNBLOCK_CONTINUE
 	    && lockres->l_ops->post_unlock)
 		lockres->l_ops->post_unlock(osb, lockres);
-
-	mlog_exit_void();
 }
 
 static void ocfs2_schedule_blocked_lock(struct ocfs2_super *osb,
@@ -3995,8 +3940,6 @@ static void ocfs2_schedule_blocked_lock(struct ocfs2_super *osb,
 		osb->blocked_lock_count++;
 	}
 	spin_unlock(&osb->dc_task_lock);
-
-	mlog_exit_void();
 }
 
 static void ocfs2_downconvert_thread_do_work(struct ocfs2_super *osb)
@@ -4027,8 +3970,6 @@ static void ocfs2_downconvert_thread_do_work(struct ocfs2_super *osb)
 		spin_lock(&osb->dc_task_lock);
 	}
 	spin_unlock(&osb->dc_task_lock);
-
-	mlog_exit_void();
 }
 
 static int ocfs2_downconvert_thread_lists_empty(struct ocfs2_super *osb)
diff --git a/fs/ocfs2/export.c b/fs/ocfs2/export.c
index 2173cc2..190158b 100644
--- a/fs/ocfs2/export.c
+++ b/fs/ocfs2/export.c
@@ -143,7 +143,7 @@ check_gen:
 		mlog_errno(PTR_ERR(result));
 
 bail:
-	mlog_exit_ptr(result);
+	mlog(0, "result = %p\n", result);
 	return result;
 }
 
@@ -182,7 +182,7 @@ bail_unlock:
 	ocfs2_inode_unlock(dir, 0);
 
 bail:
-	mlog_exit_ptr(parent);
+	mlog(0, "parent %p\n", parent);
 
 	return parent;
 }
@@ -243,7 +243,7 @@ static int ocfs2_encode_fh(struct dentry *dentry, u32 *fh_in, int *max_len,
 	*max_len = len;
 
 bail:
-	mlog_exit(type);
+	mlog(0, "type = %d\n", type);
 	return type;
 }
 
diff --git a/fs/ocfs2/extent_map.c b/fs/ocfs2/extent_map.c
index ed9916a..7d74d17 100644
--- a/fs/ocfs2/extent_map.c
+++ b/fs/ocfs2/extent_map.c
@@ -897,7 +897,6 @@ int ocfs2_read_virt_blocks(struct inode *inode, u64 v_block, int nr,
 	}
 
 out:
-	mlog_exit(rc);
 	return rc;
 }
 
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 480accf..14f335d 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -135,7 +135,6 @@ static int ocfs2_file_open(struct inode *inode, struct file *file)
 	}
 
 leave:
-	mlog_exit(status);
 	return status;
 }
 
@@ -154,8 +153,6 @@ static int ocfs2_file_release(struct inode *inode, struct file *file)
 
 	ocfs2_free_file_private(inode, file);
 
-	mlog_exit(0);
-
 	return 0;
 }
 
@@ -195,7 +192,8 @@ static int ocfs2_sync_file(struct file *file, int datasync)
 	err = jbd2_journal_force_commit(journal);
 
 bail:
-	mlog_exit(err);
+	if (err)
+		mlog_errno(err);
 
 	return (err < 0) ? -EIO : 0;
 }
@@ -278,7 +276,6 @@ int ocfs2_update_inode_atime(struct inode *inode,
 out_commit:
 	ocfs2_commit_trans(OCFS2_SB(inode->i_sb), handle);
 out:
-	mlog_exit(ret);
 	return ret;
 }
 
@@ -300,7 +297,6 @@ static int ocfs2_set_inode_size(handle_t *handle,
 	}
 
 bail:
-	mlog_exit(status);
 	return status;
 }
 
@@ -424,8 +420,6 @@ static int ocfs2_orphan_for_truncate(struct ocfs2_super *osb,
 out_commit:
 	ocfs2_commit_trans(osb, handle);
 out:
-
-	mlog_exit(status);
 	return status;
 }
 
@@ -520,7 +514,6 @@ bail:
 	if (!status && OCFS2_I(inode)->ip_clusters == 0)
 		status = ocfs2_try_remove_refcount_tree(inode, di_bh);
 
-	mlog_exit(status);
 	return status;
 }
 
@@ -713,7 +706,6 @@ leave:
 	brelse(bh);
 	bh = NULL;
 
-	mlog_exit(status);
 	return status;
 }
 
@@ -1269,7 +1261,6 @@ bail:
 			mlog_errno(status);
 	}
 
-	mlog_exit(status);
 	return status;
 }
 
@@ -1295,8 +1286,6 @@ int ocfs2_getattr(struct vfsmount *mnt,
 	stat->blksize = osb->s_clustersize;
 
 bail:
-	mlog_exit(err);
-
 	return err;
 }
 
@@ -1315,7 +1304,6 @@ int ocfs2_permission(struct inode *inode, int mask)
 
 	ocfs2_inode_unlock(inode, 0);
 out:
-	mlog_exit(ret);
 	return ret;
 }
 
@@ -1356,7 +1344,6 @@ static int __ocfs2_write_remove_suid(struct inode *inode,
 out_trans:
 	ocfs2_commit_trans(osb, handle);
 out:
-	mlog_exit(ret);
 	return ret;
 }
 
@@ -2380,7 +2367,6 @@ out_sems:
 
 	if (written)
 		ret = written;
-	mlog_exit(ret);
 	return ret;
 }
 
@@ -2463,7 +2449,6 @@ static ssize_t ocfs2_file_splice_write(struct pipe_inode_info *pipe,
 		balance_dirty_pages_ratelimited_nr(mapping, nr_pages);
 	}
 
-	mlog_exit(ret);
 	return ret;
 }
 
@@ -2494,7 +2479,6 @@ static ssize_t ocfs2_file_splice_read(struct file *in,
 	ret = generic_file_splice_read(in, ppos, pipe, len, flags);
 
 bail:
-	mlog_exit(ret);
 	return ret;
 }
 
@@ -2570,7 +2554,6 @@ bail:
 		up_read(&inode->i_alloc_sem);
 	if (rw_level != -1)
 		ocfs2_rw_unlock(inode, rw_level);
-	mlog_exit(ret);
 
 	return ret;
 }
diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 7bdfcb6..f5c0f34 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -172,7 +172,7 @@ bail:
 	if (!IS_ERR(inode)) {
 		mlog(0, "returning inode with number %llu\n",
 		     (unsigned long long)OCFS2_I(inode)->ip_blkno);
-		mlog_exit_ptr(inode);
+		mlog(0, "inode %p\n", inode);
 	}
 
 	return inode;
@@ -203,7 +203,6 @@ static int ocfs2_find_actor(struct inode *inode, void *opaque)
 
 	ret = 1;
 bail:
-	mlog_exit(ret);
 	return ret;
 }
 
@@ -235,7 +234,6 @@ static int ocfs2_init_locked_inode(struct inode *inode, void *opaque)
 		lockdep_set_class(&OCFS2_I(inode)->ip_alloc_sem,
 				  &ocfs2_file_ip_alloc_sem_key);
 
-	mlog_exit(0);
 	return 0;
 }
 
@@ -381,7 +379,6 @@ void ocfs2_populate_inode(struct inode *inode, struct ocfs2_dinode *fe,
 	if (S_ISDIR(inode->i_mode))
 		ocfs2_resv_set_type(&OCFS2_I(inode)->ip_la_data_resv,
 				    OCFS2_RESV_FLAG_DIR);
-	mlog_exit_void();
 }
 
 static int ocfs2_read_locked_inode(struct inode *inode,
@@ -534,7 +531,6 @@ bail:
 	if (args && bh)
 		brelse(bh);
 
-	mlog_exit(status);
 	return status;
 }
 
@@ -598,7 +594,6 @@ static int ocfs2_truncate_for_delete(struct ocfs2_super *osb,
 out:
 	if (handle)
 		ocfs2_commit_trans(osb, handle);
-	mlog_exit(status);
 	return status;
 }
 
@@ -1078,7 +1073,7 @@ bail_unlock_nfs_sync:
 bail_unblock:
 	ocfs2_unblock_signals(&oldset);
 bail:
-	mlog_exit_void();
+	return;
 }
 
 static void ocfs2_clear_inode(struct inode *inode)
@@ -1177,8 +1172,6 @@ static void ocfs2_clear_inode(struct inode *inode)
 	 */
 	jbd2_journal_release_jbd_inode(OCFS2_SB(inode->i_sb)->journal->j_journal,
 				       &oi->ip_jinode);
-
-	mlog_exit_void();
 }
 
 void ocfs2_evict_inode(struct inode *inode)
@@ -1208,7 +1201,6 @@ int ocfs2_drop_inode(struct inode *inode)
 	else
 		res = generic_drop_inode(inode);
 
-	mlog_exit_void();
 	return res;
 }
 
@@ -1248,8 +1240,6 @@ int ocfs2_inode_revalidate(struct dentry *dentry)
 	}
 	ocfs2_inode_unlock(inode, 0);
 bail:
-	mlog_exit(status);
-
 	return status;
 }
 
@@ -1296,7 +1286,6 @@ int ocfs2_mark_inode_dirty(handle_t *handle,
 
 	ocfs2_journal_dirty(handle, bh);
 leave:
-	mlog_exit(status);
 	return status;
 }
 
diff --git a/fs/ocfs2/ioctl.c b/fs/ocfs2/ioctl.c
index 7a48681..b4f51e9 100644
--- a/fs/ocfs2/ioctl.c
+++ b/fs/ocfs2/ioctl.c
@@ -59,7 +59,6 @@ static int ocfs2_get_inode_attr(struct inode *inode, unsigned *flags)
 	*flags = OCFS2_I(inode)->ip_attr;
 	ocfs2_inode_unlock(inode, 0);
 
-	mlog_exit(status);
 	return status;
 }
 
@@ -125,7 +124,6 @@ bail:
 
 	brelse(bh);
 
-	mlog_exit(status);
 	return status;
 }
 
diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index 7378277..9565091 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -335,7 +335,6 @@ static int ocfs2_commit_cache(struct ocfs2_super *osb)
 	ocfs2_wake_downconvert_thread(osb);
 	wake_up(&journal->j_checkpointed);
 finally:
-	mlog_exit(status);
 	return status;
 }
 
@@ -450,8 +449,6 @@ int ocfs2_extend_trans(handle_t *handle, int nblocks)
 
 	status = 0;
 bail:
-
-	mlog_exit(status);
 	return status;
 }
 
@@ -665,7 +662,6 @@ static int __ocfs2_journal_access(handle_t *handle,
 		mlog(ML_ERROR, "Error %d getting %d access to buffer!\n",
 		     status, type);
 
-	mlog_exit(status);
 	return status;
 }
 
@@ -739,8 +735,6 @@ void ocfs2_journal_dirty(handle_t *handle, struct buffer_head *bh)
 
 	status = jbd2_journal_dirty_metadata(handle, bh);
 	BUG_ON(status);
-
-	mlog_exit_void();
 }
 
 #define OCFS2_DEFAULT_COMMIT_INTERVAL	(HZ * JBD2_DEFAULT_MAX_COMMIT_AGE)
@@ -854,7 +848,6 @@ done:
 		}
 	}
 
-	mlog_exit(status);
 	return status;
 }
 
@@ -899,7 +892,6 @@ static int ocfs2_journal_toggle_dirty(struct ocfs2_super *osb,
 	if (status < 0)
 		mlog_errno(status);
 
-	mlog_exit(status);
 	return status;
 }
 
@@ -989,7 +981,6 @@ void ocfs2_journal_shutdown(struct ocfs2_super *osb)
 done:
 	if (inode)
 		iput(inode);
-	mlog_exit_void();
 }
 
 static void ocfs2_clear_journal_error(struct super_block *sb,
@@ -1048,7 +1039,6 @@ int ocfs2_journal_load(struct ocfs2_journal *journal, int local, int replayed)
 		osb->commit_task = NULL;
 
 done:
-	mlog_exit(status);
 	return status;
 }
 
@@ -1072,7 +1062,6 @@ int ocfs2_journal_wipe(struct ocfs2_journal *journal, int full)
 		mlog_errno(status);
 
 bail:
-	mlog_exit(status);
 	return status;
 }
 
@@ -1146,7 +1135,6 @@ static int ocfs2_force_read_journal(struct inode *inode)
 bail:
 	for(i = 0; i < CONCURRENT_JOURNAL_FILL; i++)
 		brelse(bhs[i]);
-	mlog_exit(status);
 	return status;
 }
 
@@ -1236,7 +1224,6 @@ void ocfs2_complete_recovery(struct work_struct *work)
 	}
 
 	mlog(0, "Recovery completion\n");
-	mlog_exit_void();
 }
 
 /* NOTE: This function always eats your references to la_dinode and
@@ -1432,7 +1419,6 @@ bail:
 	if (rm_quota)
 		kfree(rm_quota);
 
-	mlog_exit(status);
 	/* no one is callint kthread_stop() for us so the kthread() api
 	 * requires that we call do_exit().  And it isn't exported, but
 	 * complete_and_exit() seems to be a minimal wrapper around it. */
@@ -1469,8 +1455,6 @@ void ocfs2_recovery_thread(struct ocfs2_super *osb, int node_num)
 out:
 	mutex_unlock(&osb->recovery_lock);
 	wake_up(&osb->recovery_event);
-
-	mlog_exit_void();
 }
 
 static int ocfs2_read_journal_inode(struct ocfs2_super *osb,
@@ -1646,7 +1630,6 @@ done:
 
 	brelse(bh);
 
-	mlog_exit(status);
 	return status;
 }
 
@@ -1716,7 +1699,6 @@ static int ocfs2_recover_node(struct ocfs2_super *osb,
 	status = 0;
 done:
 
-	mlog_exit(status);
 	return status;
 }
 
@@ -1826,7 +1808,6 @@ int ocfs2_mark_dead_nodes(struct ocfs2_super *osb)
 
 	status = 0;
 bail:
-	mlog_exit(status);
 	return status;
 }
 
diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
index 5f08c70..36636e1 100644
--- a/fs/ocfs2/localalloc.c
+++ b/fs/ocfs2/localalloc.c
@@ -364,7 +364,8 @@ bail:
 
 	mlog(0, "Local alloc window bits = %d\n", osb->local_alloc_bits);
 
-	mlog_exit(status);
+	if (status)
+		mlog_errno(status);
 	return status;
 }
 
@@ -478,8 +479,6 @@ out:
 
 	if (alloc_copy)
 		kfree(alloc_copy);
-
-	mlog_exit_void();
 }
 
 /*
@@ -548,7 +547,8 @@ bail:
 		iput(inode);
 	}
 
-	mlog_exit(status);
+	if (status)
+		mlog_errno(status);
 	return status;
 }
 
@@ -614,7 +614,8 @@ out_mutex:
 out:
 	if (!status)
 		ocfs2_init_steal_slots(osb);
-	mlog_exit(status);
+	if (status)
+		mlog_errno(status);
 	return status;
 }
 
@@ -724,7 +725,8 @@ bail:
 	mlog(0, "bits=%d, slot=%d, ret=%d\n", bits_wanted, osb->slot_num,
 	     status);
 
-	mlog_exit(status);
+	if (status)
+		mlog_errno(status);
 	return status;
 }
 
@@ -779,7 +781,8 @@ int ocfs2_claim_local_alloc_bits(struct ocfs2_super *osb,
 	ocfs2_journal_dirty(handle, osb->local_alloc_bh);
 
 bail:
-	mlog_exit(status);
+	if (status)
+		mlog_errno(status);
 	return status;
 }
 
@@ -794,7 +797,7 @@ static u32 ocfs2_local_alloc_count_bits(struct ocfs2_dinode *alloc)
 	for (i = 0; i < le16_to_cpu(la->la_size); i++)
 		count += hweight8(buffer[i]);
 
-	mlog_exit(count);
+	mlog(0, "count %u\n", count);
 	return count;
 }
 
@@ -884,7 +887,7 @@ bail:
 	if (local_resv)
 		ocfs2_resv_discard(resmap, resv);
 
-	mlog_exit(bitoff);
+	mlog(0, "bitoff %d\n", bitoff);
 	return bitoff;
 }
 
@@ -898,8 +901,6 @@ static void ocfs2_clear_local_alloc(struct ocfs2_dinode *alloc)
 	la->la_bm_off = 0;
 	for(i = 0; i < le16_to_cpu(la->la_size); i++)
 		la->la_bitmap[i] = 0;
-
-	mlog_exit_void();
 }
 
 #if 0
@@ -995,7 +996,8 @@ static int ocfs2_sync_local_to_main(struct ocfs2_super *osb,
 	}
 
 bail:
-	mlog_exit(status);
+	if (status)
+		mlog_errno(status);
 	return status;
 }
 
@@ -1120,7 +1122,8 @@ bail:
 		*ac = NULL;
 	}
 
-	mlog_exit(status);
+	if (status)
+		mlog_errno(status);
 	return status;
 }
 
@@ -1212,7 +1215,8 @@ retry_enospc:
 	mlog(0, "window bits = %u\n", le32_to_cpu(alloc->id1.bitmap1.i_total));
 
 bail:
-	mlog_exit(status);
+	if (status)
+		mlog_errno(status);
 	return status;
 }
 
@@ -1308,7 +1312,8 @@ bail:
 	if (ac)
 		ocfs2_free_alloc_context(ac);
 
-	mlog_exit(status);
+	if (status)
+		mlog_errno(status);
 	return status;
 }
 
diff --git a/fs/ocfs2/mmap.c b/fs/ocfs2/mmap.c
index 87438e1..49730b5 100644
--- a/fs/ocfs2/mmap.c
+++ b/fs/ocfs2/mmap.c
@@ -55,7 +55,7 @@ static int ocfs2_fault(struct vm_area_struct *area, struct vm_fault *vmf)
 	ret = filemap_fault(area, vmf);
 	ocfs2_unblock_signals(&oldset);
 
-	mlog_exit_ptr(vmf->page);
+	mlog(0, "%p\n", vmf->page);
 	return ret;
 }
 
diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index f8c8f94..f52e6bf 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -183,7 +183,7 @@ bail_unlock:
 
 bail:
 
-	mlog_exit_ptr(ret);
+	mlog(0, "%p\n", ret);
 
 	return ret;
 }
@@ -468,7 +468,8 @@ leave:
 		iput(inode);
 	}
 
-	mlog_exit(status);
+	if (status)
+		mlog_errno(status);
 
 	return status;
 }
@@ -579,7 +580,8 @@ leave:
 		}
 	}
 
-	mlog_exit(status);
+	if (status)
+		mlog_errno(status);
 	return status;
 }
 
@@ -620,7 +622,8 @@ static int ocfs2_mkdir(struct inode *dir,
 	mlog(0, "(0x%p, 0x%p, %d, '%.*s')\n", dir, dentry, mode,
 	     dentry->d_name.len, dentry->d_name.name);
 	ret = ocfs2_mknod(dir, dentry, mode | S_IFDIR, 0);
-	mlog_exit(ret);
+	if (ret)
+		mlog_errno(ret);
 
 	return ret;
 }
@@ -635,7 +638,8 @@ static int ocfs2_create(struct inode *dir,
 	mlog(0, "(0x%p, 0x%p, %d, '%.*s')\n", dir, dentry, mode,
 	     dentry->d_name.len, dentry->d_name.name);
 	ret = ocfs2_mknod(dir, dentry, mode | S_IFREG, 0);
-	mlog_exit(ret);
+	if (ret)
+		mlog_errno(ret);
 
 	return ret;
 }
@@ -760,7 +764,8 @@ out:
 
 	ocfs2_free_dir_lookup_result(&lookup);
 
-	mlog_exit(err);
+	if (err)
+		mlog_errno(err);
 
 	return err;
 }
@@ -957,7 +962,8 @@ leave:
 	ocfs2_free_dir_lookup_result(&orphan_insert);
 	ocfs2_free_dir_lookup_result(&lookup);
 
-	mlog_exit(status);
+	if (status)
+		mlog_errno(status);
 
 	return status;
 }
@@ -1025,7 +1031,8 @@ static int ocfs2_double_lock(struct ocfs2_super *osb,
 	}
 
 bail:
-	mlog_exit(status);
+	if (status)
+		mlog_errno(status);
 	return status;
 }
 
@@ -1476,7 +1483,8 @@ bail:
 	brelse(old_dir_bh);
 	brelse(new_dir_bh);
 
-	mlog_exit(status);
+	if (status)
+		mlog_errno(status);
 
 	return status;
 }
@@ -1579,7 +1587,8 @@ bail:
 		kfree(bhs);
 	}
 
-	mlog_exit(status);
+	if (status)
+		mlog_errno(status);
 	return status;
 }
 
@@ -1836,7 +1845,8 @@ bail:
 		iput(inode);
 	}
 
-	mlog_exit(status);
+	if (status)
+		mlog_errno(status);
 
 	return status;
 }
@@ -1866,7 +1876,8 @@ static int ocfs2_blkno_stringify(u64 blkno, char *name)
 
 	status = 0;
 bail:
-	mlog_exit(status);
+	if (status < 0)
+		mlog_errno(status);
 	return status;
 }
 
@@ -1979,7 +1990,8 @@ out:
 		iput(orphan_dir_inode);
 	}
 
-	mlog_exit(ret);
+	if (ret)
+		mlog_errno(ret);
 	return ret;
 }
 
@@ -2061,7 +2073,8 @@ static int ocfs2_orphan_add(struct ocfs2_super *osb,
 leave:
 	brelse(orphan_dir_bh);
 
-	mlog_exit(status);
+	if (status)
+		mlog_errno(status);
 	return status;
 }
 
@@ -2121,7 +2134,8 @@ int ocfs2_orphan_del(struct ocfs2_super *osb,
 leave:
 	ocfs2_free_dir_lookup_result(&lookup);
 
-	mlog_exit(status);
+	if (status)
+		mlog_errno(status);
 	return status;
 }
 
@@ -2474,7 +2488,8 @@ leave:
 
 	ocfs2_free_dir_lookup_result(&lookup);
 
-	mlog_exit(status);
+	if (status)
+		mlog_errno(status);
 
 	return status;
 }
diff --git a/fs/ocfs2/quota_global.c b/fs/ocfs2/quota_global.c
index 33397bd..10a49e8 100644
--- a/fs/ocfs2/quota_global.c
+++ b/fs/ocfs2/quota_global.c
@@ -402,7 +402,8 @@ int ocfs2_global_read_info(struct super_block *sb, int type)
 			   msecs_to_jiffies(oinfo->dqi_syncms));
 
 out_err:
-	mlog_exit(status);
+	if (status)
+		mlog_errno(status);
 	return status;
 out_unlock:
 	ocfs2_unlock_global_qf(oinfo, 0);
@@ -621,7 +622,6 @@ static int ocfs2_sync_dquot_helper(struct dquot *dquot, unsigned long type)
 out_ilock:
 	ocfs2_unlock_global_qf(oinfo, 1);
 out:
-	mlog_exit(status);
 	return status;
 }
 
@@ -660,7 +660,6 @@ static int ocfs2_write_dquot(struct dquot *dquot)
 	mutex_unlock(&sb_dqopt(dquot->dq_sb)->dqio_mutex);
 	ocfs2_commit_trans(osb, handle);
 out:
-	mlog_exit(status);
 	return status;
 }
 
@@ -722,7 +721,8 @@ out_ilock:
 	ocfs2_unlock_global_qf(oinfo, 1);
 out:
 	mutex_unlock(&dquot->dq_lock);
-	mlog_exit(status);
+	if (status)
+		mlog_errno(status);
 	return status;
 }
 
@@ -809,7 +809,8 @@ out_dq:
 	set_bit(DQ_ACTIVE_B, &dquot->dq_flags);
 out:
 	mutex_unlock(&dquot->dq_lock);
-	mlog_exit(status);
+	if (status)
+		mlog_errno(status);
 	return status;
 }
 
@@ -866,7 +867,8 @@ out_dlock:
 out_ilock:
 	ocfs2_unlock_global_qf(oinfo, 1);
 out:
-	mlog_exit(status);
+	if (status)
+		mlog_errno(status);
 	return status;
 }
 
@@ -891,7 +893,8 @@ static int ocfs2_write_info(struct super_block *sb, int type)
 out_ilock:
 	ocfs2_unlock_global_qf(oinfo, 1);
 out:
-	mlog_exit(status);
+	if (status)
+		mlog_errno(status);
 	return status;
 }
 
diff --git a/fs/ocfs2/quota_local.c b/fs/ocfs2/quota_local.c
index a71d68d..88ec451 100644
--- a/fs/ocfs2/quota_local.c
+++ b/fs/ocfs2/quota_local.c
@@ -575,7 +575,8 @@ out_put_bh:
 	}
 	if (status < 0)
 		free_recovery_list(&(rec->r_list[type]));
-	mlog_exit(status);
+	if (status)
+		mlog_errno(status);
 	return status;
 }
 
diff --git a/fs/ocfs2/resize.c b/fs/ocfs2/resize.c
index e4a50e3..76b3790 100644
--- a/fs/ocfs2/resize.c
+++ b/fs/ocfs2/resize.c
@@ -82,7 +82,6 @@ static u16 ocfs2_calc_new_backup_super(struct inode *inode,
 		backups++;
 	}
 
-	mlog_exit_void();
 	return backups;
 }
 
@@ -176,7 +175,8 @@ out_rollback:
 		le16_add_cpu(&group->bg_free_bits_count, -1 * num_bits);
 	}
 out:
-	mlog_exit(ret);
+	if (ret)
+		mlog_errno(ret);
 	return ret;
 }
 
@@ -375,7 +375,6 @@ out_mutex:
 	iput(main_bm_inode);
 
 out:
-	mlog_exit_void();
 	return ret;
 }
 
@@ -585,6 +584,5 @@ out_mutex:
 	iput(main_bm_inode);
 
 out:
-	mlog_exit_void();
 	return ret;
 }
diff --git a/fs/ocfs2/slot_map.c b/fs/ocfs2/slot_map.c
index a6016e6..93b449e 100644
--- a/fs/ocfs2/slot_map.c
+++ b/fs/ocfs2/slot_map.c
@@ -510,7 +510,6 @@ int ocfs2_find_slot(struct ocfs2_super *osb)
 		mlog_errno(status);
 
 bail:
-	mlog_exit(status);
 	return status;
 }
 
diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index 2713046..709851f 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -434,7 +434,8 @@ static int ocfs2_block_group_fill(handle_t *handle,
 	 * allocation time. */
 
 bail:
-	mlog_exit(status);
+	if (status)
+		mlog_errno(status);
 	return status;
 }
 
@@ -792,7 +793,8 @@ bail:
 
 	brelse(bg_bh);
 
-	mlog_exit(status);
+	if (status)
+		mlog_errno(status);
 	return status;
 }
 
@@ -884,7 +886,8 @@ static int ocfs2_reserve_suballoc_bits(struct ocfs2_super *osb,
 bail:
 	brelse(bh);
 
-	mlog_exit(status);
+	if (status)
+		mlog_errno(status);
 	return status;
 }
 
@@ -1046,7 +1049,8 @@ bail:
 		*ac = NULL;
 	}
 
-	mlog_exit(status);
+	if (status)
+		mlog_errno(status);
 	return status;
 }
 
@@ -1146,7 +1150,8 @@ bail:
 		*ac = NULL;
 	}
 
-	mlog_exit(status);
+	if (status)
+		mlog_errno(status);
 	return status;
 }
 
@@ -1221,7 +1226,8 @@ bail:
 		*ac = NULL;
 	}
 
-	mlog_exit(status);
+	if (status)
+		mlog_errno(status);
 	return status;
 }
 
@@ -1384,7 +1390,8 @@ static inline int ocfs2_block_group_set_bits(handle_t *handle,
 	ocfs2_journal_dirty(handle, group_bh);
 
 bail:
-	mlog_exit(status);
+	if (status)
+		mlog_errno(status);
 	return status;
 }
 
@@ -1474,7 +1481,8 @@ out_rollback:
 		prev_bg->bg_next_group = cpu_to_le64(prev_bg_ptr);
 	}
 
-	mlog_exit(status);
+	if (status)
+		mlog_errno(status);
 	return status;
 }
 
@@ -1860,7 +1868,8 @@ bail:
 	brelse(group_bh);
 	brelse(prev_group_bh);
 
-	mlog_exit(status);
+	if (status)
+		mlog_errno(status);
 	return status;
 }
 
@@ -1972,7 +1981,8 @@ set_hint:
 	}
 
 bail:
-	mlog_exit(status);
+	if (status)
+		mlog_errno(status);
 	return status;
 }
 
@@ -2009,7 +2019,8 @@ int ocfs2_claim_metadata(handle_t *handle,
 	*num_bits = res.sr_bits;
 	status = 0;
 bail:
-	mlog_exit(status);
+	if (status)
+		mlog_errno(status);
 	return status;
 }
 
@@ -2216,7 +2227,8 @@ int ocfs2_claim_new_inode(handle_t *handle,
 	ocfs2_save_inode_ac_group(dir, ac);
 	status = 0;
 bail:
-	mlog_exit(status);
+	if (status)
+		mlog_errno(status);
 	return status;
 }
 
@@ -2347,7 +2359,8 @@ int __ocfs2_claim_clusters(handle_t *handle,
 	ac->ac_bits_given += *num_clusters;
 
 bail:
-	mlog_exit(status);
+	if (status)
+		mlog_errno(status);
 	return status;
 }
 
@@ -2491,7 +2504,8 @@ static int _ocfs2_free_suballoc_bits(handle_t *handle,
 bail:
 	brelse(group_bh);
 
-	mlog_exit(status);
+	if (status)
+		mlog_errno(status);
 	return status;
 }
 
@@ -2563,7 +2577,8 @@ static int _ocfs2_free_clusters(handle_t *handle,
 					 num_clusters);
 
 out:
-	mlog_exit(status);
+	if (status)
+		mlog_errno(status);
 	return status;
 }
 
@@ -2770,7 +2785,8 @@ static int ocfs2_get_suballoc_slot_bit(struct ocfs2_super *osb, u64 blkno,
 bail:
 	brelse(inode_bh);
 
-	mlog_exit(status);
+	if (status)
+		mlog_errno(status);
 	return status;
 }
 
@@ -2821,7 +2837,8 @@ static int ocfs2_test_suballoc_bit(struct ocfs2_super *osb,
 bail:
 	brelse(group_bh);
 
-	mlog_exit(status);
+	if (status)
+		mlog_errno(status);
 	return status;
 }
 
@@ -2887,6 +2904,7 @@ int ocfs2_test_inode_bit(struct ocfs2_super *osb, u64 blkno, int *res)
 	iput(inode_alloc_inode);
 	brelse(alloc_bh);
 bail:
-	mlog_exit(status);
+	if (status)
+		mlog_errno(status);
 	return status;
 }
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 7572a2f..9e41894 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -476,7 +476,8 @@ static int ocfs2_init_global_system_inodes(struct ocfs2_super *osb)
 	}
 
 bail:
-	mlog_exit(status);
+	if (status)
+		mlog_errno(status);
 	return status;
 }
 
@@ -504,7 +505,8 @@ static int ocfs2_init_local_system_inodes(struct ocfs2_super *osb)
 	}
 
 bail:
-	mlog_exit(status);
+	if (status)
+		mlog_errno(status);
 	return status;
 }
 
@@ -534,7 +536,7 @@ static void ocfs2_release_system_inodes(struct ocfs2_super *osb)
 	}
 
 	if (!osb->local_system_inodes)
-		goto out;
+		return;
 
 	for (i = 0; i < NUM_LOCAL_SYSTEM_INODES * osb->max_slots; i++) {
 		if (osb->local_system_inodes[i]) {
@@ -545,9 +547,6 @@ static void ocfs2_release_system_inodes(struct ocfs2_super *osb)
 
 	kfree(osb->local_system_inodes);
 	osb->local_system_inodes = NULL;
-
-out:
-	mlog_exit(0);
 }
 
 /* We're allocating fs objects, use GFP_NOFS */
@@ -1196,7 +1195,6 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 			mlog_errno(status);
 			atomic_set(&osb->vol_state, VOLUME_DISABLED);
 			wake_up(&osb->osb_mount_event);
-			mlog_exit(status);
 			return status;
 		}
 	}
@@ -1210,7 +1208,6 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 	/* Start this when the mount is almost sure of being successful */
 	ocfs2_orphan_scan_start(osb);
 
-	mlog_exit(status);
 	return status;
 
 read_super_error:
@@ -1225,7 +1222,8 @@ read_super_error:
 		ocfs2_dismount_volume(sb, 1);
 	}
 
-	mlog_exit(status);
+	if (status)
+		mlog_errno(status);
 	return status;
 }
 
@@ -1514,7 +1512,6 @@ static int ocfs2_parse_options(struct super_block *sb,
 	status = 1;
 
 bail:
-	mlog_exit(status);
 	return status;
 }
 
@@ -1643,10 +1640,9 @@ leave:
 		ocfs2_quota_shutdown();
 		ocfs2_free_mem_caches();
 		exit_ocfs2_uptodate_cache();
+		mlog_errno(status);
 	}
 
-	mlog_exit(status);
-
 	if (status >= 0) {
 		return register_filesystem(&ocfs2_fs_type);
 	} else
@@ -1671,8 +1667,6 @@ static void __exit ocfs2_exit(void)
 	unregister_filesystem(&ocfs2_fs_type);
 
 	exit_ocfs2_uptodate_cache();
-
-	mlog_exit_void();
 }
 
 static void ocfs2_put_super(struct super_block *sb)
@@ -1681,8 +1675,6 @@ static void ocfs2_put_super(struct super_block *sb)
 
 	ocfs2_sync_blockdev(sb);
 	ocfs2_dismount_volume(sb, 0);
-
-	mlog_exit_void();
 }
 
 static int ocfs2_statfs(struct dentry *dentry, struct kstatfs *buf)
@@ -1741,7 +1733,8 @@ bail:
 	if (inode)
 		iput(inode);
 
-	mlog_exit(status);
+	if (status)
+		mlog_errno(status);
 
 	return status;
 }
@@ -1905,7 +1898,6 @@ leave:
 	if (unlock_super)
 		ocfs2_super_unlock(osb, 1);
 
-	mlog_exit(status);
 	return status;
 }
 
@@ -2354,7 +2346,6 @@ static int ocfs2_initialize_super(struct super_block *sb,
 	}
 
 bail:
-	mlog_exit(status);
 	return status;
 }
 
@@ -2424,7 +2415,8 @@ static int ocfs2_verify_volume(struct ocfs2_dinode *di,
 	}
 
 out:
-	mlog_exit(status);
+	if (status)
+		mlog_errno(status);
 	return status;
 }
 
@@ -2519,7 +2511,8 @@ finally:
 	if (local_alloc)
 		kfree(local_alloc);
 
-	mlog_exit(status);
+	if (status)
+		mlog_errno(status);
 	return status;
 }
 
@@ -2548,8 +2541,6 @@ static void ocfs2_delete_osb(struct ocfs2_super *osb)
 	kfree(osb->uuid_str);
 	ocfs2_put_dlm_debug(osb->osb_dlm_debug);
 	memset(osb, 0, sizeof(struct ocfs2_super));
-
-	mlog_exit_void();
 }
 
 /* Put OCFS2 into a readonly state, or (if the user specifies it),
diff --git a/fs/ocfs2/symlink.c b/fs/ocfs2/symlink.c
index 8a81688..56c1eeb 100644
--- a/fs/ocfs2/symlink.c
+++ b/fs/ocfs2/symlink.c
@@ -72,7 +72,6 @@ static char *ocfs2_fast_symlink_getlink(struct inode *inode,
 	fe = (struct ocfs2_dinode *) (*bh)->b_data;
 	link = (char *) fe->id2.i_symlink;
 bail:
-	mlog_exit(status);
 
 	return link;
 }
@@ -100,7 +99,8 @@ static int ocfs2_readlink(struct dentry *dentry,
 
 	brelse(bh);
 out:
-	mlog_exit(ret);
+	if (ret)
+		mlog_errno(ret);
 	return ret;
 }
 
@@ -136,7 +136,8 @@ bail:
 	nd_set_link(nd, status ? ERR_PTR(status) : link);
 	brelse(bh);
 
-	mlog_exit(status);
+	if (status)
+		mlog_errno(status);
 	return NULL;
 }
 
diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 81f98b7..d57c794 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -5570,7 +5570,6 @@ static int ocfs2_xattr_set_entry_bucket(struct inode *inode,
 
 
 out:
-	mlog_exit(ret);
 	return ret;
 }
 
@@ -5637,7 +5636,6 @@ static int ocfs2_xattr_set_entry_index_block(struct inode *inode,
 		mlog_errno(ret);
 
 out:
-	mlog_exit(ret);
 	return ret;
 }
 
-- 
1.7.0.4
