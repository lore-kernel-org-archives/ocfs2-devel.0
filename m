From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Thu Jan 17 14:36:45 2008
Subject: [Ocfs2-devel] [PATCH 05/30] ocfs2: Remove data locks
In-Reply-To: <1200609356-17788-1-git-send-email-mark.fasheh@oracle.com>
References: <1200609356-17788-1-git-send-email-mark.fasheh@oracle.com>
Message-ID: <1200609356-17788-6-git-send-email-mark.fasheh@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Mark Fasheh <mark.fasheh@oracle.com>

The meta lock now covers both meta data and data, so this just removes the
now-redundant data lock.

Combining locks saves us a round of lock mastery per inode and one less lock
to ping between nodes during read/write.

We don't lose much - since meta locks were always held before a data lock
(and at the same level) ordered writeout mode (the default) ensured that
flushing for the meta data lock also pushed out data anyways.

Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
---
 fs/ocfs2/aops.c                 |   44 +----------------
 fs/ocfs2/cluster/tcp_internal.h |    5 ++-
 fs/ocfs2/dlmglue.c              |  104 ---------------------------------------
 fs/ocfs2/dlmglue.h              |   11 +----
 fs/ocfs2/file.c                 |   55 ++++++---------------
 fs/ocfs2/inode.c                |    6 --
 fs/ocfs2/inode.h                |    1 -
 fs/ocfs2/mmap.c                 |    9 ---
 fs/ocfs2/super.c                |    1 -
 9 files changed, 22 insertions(+), 214 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 56f7790..5fc27cf 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -305,21 +305,12 @@ static int ocfs2_readpage(struct file *file, struct page *page)
 		goto out_alloc;
 	}
 
-	ret = ocfs2_data_lock_with_page(inode, 0, page);
-	if (ret != 0) {
-		if (ret == AOP_TRUNCATED_PAGE)
-			unlock = 0;
-		mlog_errno(ret);
-		goto out_alloc;
-	}
-
 	if (oi->ip_dyn_features & OCFS2_INLINE_DATA_FL)
 		ret = ocfs2_readpage_inline(inode, page);
 	else
 		ret = block_read_full_page(page, ocfs2_get_block);
 	unlock = 0;
 
-	ocfs2_data_unlock(inode, 0);
 out_alloc:
 	up_read(&OCFS2_I(inode)->ip_alloc_sem);
 out_meta_unlock:
@@ -638,34 +629,12 @@ static ssize_t ocfs2_direct_IO(int rw,
 	if (OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL)
 		return 0;
 
-	if (!ocfs2_sparse_alloc(OCFS2_SB(inode->i_sb))) {
-		/*
-		 * We get PR data locks even for O_DIRECT.  This
-		 * allows concurrent O_DIRECT I/O but doesn't let
-		 * O_DIRECT with extending and buffered zeroing writes
-		 * race.  If they did race then the buffered zeroing
-		 * could be written back after the O_DIRECT I/O.  It's
-		 * one thing to tell people not to mix buffered and
-		 * O_DIRECT writes, but expecting them to understand
-		 * that file extension is also an implicit buffered
-		 * write is too much.  By getting the PR we force
-		 * writeback of the buffered zeroing before
-		 * proceeding.
-		 */
-		ret = ocfs2_data_lock(inode, 0);
-		if (ret < 0) {
-			mlog_errno(ret);
-			goto out;
-		}
-		ocfs2_data_unlock(inode, 0);
-	}
-
 	ret = blockdev_direct_IO_no_locking(rw, iocb, inode,
 					    inode->i_sb->s_bdev, iov, offset,
 					    nr_segs, 
 					    ocfs2_direct_IO_get_blocks,
 					    ocfs2_dio_end_io);
-out:
+
 	mlog_exit(ret);
 	return ret;
 }
@@ -1769,25 +1738,17 @@ static int ocfs2_write_begin(struct file *file, struct address_space *mapping,
 	 */
 	down_write(&OCFS2_I(inode)->ip_alloc_sem);
 
-	ret = ocfs2_data_lock(inode, 1);
-	if (ret) {
-		mlog_errno(ret);
-		goto out_fail;
-	}
-
 	ret = ocfs2_write_begin_nolock(mapping, pos, len, flags, pagep,
 				       fsdata, di_bh, NULL);
 	if (ret) {
 		mlog_errno(ret);
-		goto out_fail_data;
+		goto out_fail;
 	}
 
 	brelse(di_bh);
 
 	return 0;
 
-out_fail_data:
-	ocfs2_data_unlock(inode, 1);
 out_fail:
 	up_write(&OCFS2_I(inode)->ip_alloc_sem);
 
@@ -1908,7 +1869,6 @@ static int ocfs2_write_end(struct file *file, struct address_space *mapping,
 
 	ret = ocfs2_write_end_nolock(mapping, pos, len, copied, page, fsdata);
 
-	ocfs2_data_unlock(inode, 1);
 	up_write(&OCFS2_I(inode)->ip_alloc_sem);
 	ocfs2_meta_unlock(inode, 1);
 
diff --git a/fs/ocfs2/cluster/tcp_internal.h b/fs/ocfs2/cluster/tcp_internal.h
index 79bd666..b2e832a 100644
--- a/fs/ocfs2/cluster/tcp_internal.h
+++ b/fs/ocfs2/cluster/tcp_internal.h
@@ -38,6 +38,9 @@
  * locking semantics of the file system using the protocol.  It should 
  * be somewhere else, I'm sure, but right now it isn't.
  *
+ * New in version 10:
+ * 	- Meta/data locks combined
+ *
  * New in version 9:
  * 	- All votes removed
  *
@@ -63,7 +66,7 @@
  * 	- full 64 bit i_size in the metadata lock lvbs
  * 	- introduction of "rw" lock and pushing meta/data locking down
  */
-#define O2NET_PROTOCOL_VERSION 9ULL
+#define O2NET_PROTOCOL_VERSION 10ULL
 struct o2net_handshake {
 	__be64	protocol_version;
 	__be64	connector_id;
diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 840aeda..adc8f6e 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -232,12 +232,6 @@ static struct ocfs2_lock_res_ops ocfs2_inode_meta_lops = {
 	.flags		= LOCK_TYPE_REQUIRES_REFRESH|LOCK_TYPE_USES_LVB,
 };
 
-static struct ocfs2_lock_res_ops ocfs2_inode_data_lops = {
-	.get_osb	= ocfs2_get_inode_osb,
-	.downconvert_worker = ocfs2_data_convert_worker,
-	.flags		= 0,
-};
-
 static struct ocfs2_lock_res_ops ocfs2_super_lops = {
 	.flags		= LOCK_TYPE_REQUIRES_REFRESH,
 };
@@ -261,7 +255,6 @@ static struct ocfs2_lock_res_ops ocfs2_inode_open_lops = {
 static inline int ocfs2_is_inode_lock(struct ocfs2_lock_res *lockres)
 {
 	return lockres->l_type == OCFS2_LOCK_TYPE_META ||
-		lockres->l_type == OCFS2_LOCK_TYPE_DATA ||
 		lockres->l_type == OCFS2_LOCK_TYPE_RW ||
 		lockres->l_type == OCFS2_LOCK_TYPE_OPEN;
 }
@@ -405,9 +398,6 @@ void ocfs2_inode_lock_res_init(struct ocfs2_lock_res *res,
 		case OCFS2_LOCK_TYPE_META:
 			ops = &ocfs2_inode_meta_lops;
 			break;
-		case OCFS2_LOCK_TYPE_DATA:
-			ops = &ocfs2_inode_data_lops;
-			break;
 		case OCFS2_LOCK_TYPE_OPEN:
 			ops = &ocfs2_inode_open_lops;
 			break;
@@ -1154,12 +1144,6 @@ int ocfs2_create_new_inode_locks(struct inode *inode)
 		goto bail;
 	}
 
-	ret = ocfs2_create_new_lock(osb, &OCFS2_I(inode)->ip_data_lockres, 1, 1);
-	if (ret) {
-		mlog_errno(ret);
-		goto bail;
-	}
-
 	ret = ocfs2_create_new_lock(osb, &OCFS2_I(inode)->ip_open_lockres, 0, 0);
 	if (ret) {
 		mlog_errno(ret);
@@ -1312,67 +1296,6 @@ out:
 	mlog_exit_void();
 }
 
-int ocfs2_data_lock_full(struct inode *inode,
-			 int write,
-			 int arg_flags)
-{
-	int status = 0, level;
-	struct ocfs2_lock_res *lockres;
-	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
-
-	BUG_ON(!inode);
-
-	mlog_entry_void();
-
-	mlog(0, "inode %llu take %s DATA lock\n",
-	     (unsigned long long)OCFS2_I(inode)->ip_blkno,
-	     write ? "EXMODE" : "PRMODE");
-
-	/* We'll allow faking a readonly data lock for
-	 * rodevices. */
-	if (ocfs2_is_hard_readonly(OCFS2_SB(inode->i_sb))) {
-		if (write) {
-			status = -EROFS;
-			mlog_errno(status);
-		}
-		goto out;
-	}
-
-	if (ocfs2_mount_local(osb))
-		goto out;
-
-	lockres = &OCFS2_I(inode)->ip_data_lockres;
-
-	level = write ? LKM_EXMODE : LKM_PRMODE;
-
-	status = ocfs2_cluster_lock(OCFS2_SB(inode->i_sb), lockres, level,
-				    0, arg_flags);
-	if (status < 0 && status != -EAGAIN)
-		mlog_errno(status);
-
-out:
-	mlog_exit(status);
-	return status;
-}
-
-/* see ocfs2_meta_lock_with_page() */
-int ocfs2_data_lock_with_page(struct inode *inode,
-			      int write,
-			      struct page *page)
-{
-	int ret;
-
-	ret = ocfs2_data_lock_full(inode, write, OCFS2_LOCK_NONBLOCK);
-	if (ret == -EAGAIN) {
-		unlock_page(page);
-		if (ocfs2_data_lock(inode, write) == 0)
-			ocfs2_data_unlock(inode, write);
-		ret = AOP_TRUNCATED_PAGE;
-	}
-
-	return ret;
-}
-
 static void ocfs2_downconvert_on_unlock(struct ocfs2_super *osb,
 					struct ocfs2_lock_res *lockres)
 {
@@ -1404,26 +1327,6 @@ static void ocfs2_downconvert_on_unlock(struct ocfs2_super *osb,
 	mlog_exit_void();
 }
 
-void ocfs2_data_unlock(struct inode *inode,
-		       int write)
-{
-	int level = write ? LKM_EXMODE : LKM_PRMODE;
-	struct ocfs2_lock_res *lockres = &OCFS2_I(inode)->ip_data_lockres;
-	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
-
-	mlog_entry_void();
-
-	mlog(0, "inode %llu drop %s DATA lock\n",
-	     (unsigned long long)OCFS2_I(inode)->ip_blkno,
-	     write ? "EXMODE" : "PRMODE");
-
-	if (!ocfs2_is_hard_readonly(OCFS2_SB(inode->i_sb)) &&
-	    !ocfs2_mount_local(osb))
-		ocfs2_cluster_unlock(OCFS2_SB(inode->i_sb), lockres, level);
-
-	mlog_exit_void();
-}
-
 #define OCFS2_SEC_BITS   34
 #define OCFS2_SEC_SHIFT  (64 - 34)
 #define OCFS2_NSEC_MASK  ((1ULL << OCFS2_SEC_SHIFT) - 1)
@@ -2592,13 +2495,6 @@ int ocfs2_drop_inode_locks(struct inode *inode)
 	status = err;
 
 	err = ocfs2_drop_lock(OCFS2_SB(inode->i_sb),
-			      &OCFS2_I(inode)->ip_data_lockres);
-	if (err < 0)
-		mlog_errno(err);
-	if (err < 0 && !status)
-		status = err;
-
-	err = ocfs2_drop_lock(OCFS2_SB(inode->i_sb),
 			      &OCFS2_I(inode)->ip_meta_lockres);
 	if (err < 0)
 		mlog_errno(err);
diff --git a/fs/ocfs2/dlmglue.h b/fs/ocfs2/dlmglue.h
index 931f6ee..3fd7729 100644
--- a/fs/ocfs2/dlmglue.h
+++ b/fs/ocfs2/dlmglue.h
@@ -49,7 +49,7 @@ struct ocfs2_meta_lvb {
 	__be32       lvb_reserved2;
 };
 
-/* ocfs2_meta_lock_full() and ocfs2_data_lock_full() 'arg_flags' flags */
+/* ocfs2_meta_lock_full() 'arg_flags' flags */
 /* don't wait on recovery. */
 #define OCFS2_META_LOCK_RECOVERY	(0x01)
 /* Instruct the dlm not to queue ourselves on the other node. */
@@ -69,15 +69,6 @@ void ocfs2_dentry_lock_res_init(struct ocfs2_dentry_lock *dl,
 void ocfs2_lock_res_free(struct ocfs2_lock_res *res);
 int ocfs2_create_new_inode_locks(struct inode *inode);
 int ocfs2_drop_inode_locks(struct inode *inode);
-int ocfs2_data_lock_full(struct inode *inode,
-			 int write,
-			 int arg_flags);
-#define ocfs2_data_lock(inode, write) ocfs2_data_lock_full(inode, write, 0)
-int ocfs2_data_lock_with_page(struct inode *inode,
-			      int write,
-			      struct page *page);
-void ocfs2_data_unlock(struct inode *inode,
-		       int write);
 int ocfs2_rw_lock(struct inode *inode, int write);
 void ocfs2_rw_unlock(struct inode *inode, int write);
 int ocfs2_open_lock(struct inode *inode);
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index b75b2e1..c5c183a 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -382,18 +382,13 @@ static int ocfs2_truncate_file(struct inode *inode,
 
 	down_write(&OCFS2_I(inode)->ip_alloc_sem);
 
-	/* This forces other nodes to sync and drop their pages. Do
-	 * this even if we have a truncate without allocation change -
-	 * ocfs2 cluster sizes can be much greater than page size, so
-	 * we have to truncate them anyway.  */
-	status = ocfs2_data_lock(inode, 1);
-	if (status < 0) {
-		up_write(&OCFS2_I(inode)->ip_alloc_sem);
-
-		mlog_errno(status);
-		goto bail;
-	}
-
+	/*
+	 * The inode lock forced other nodes to sync and drop their
+	 * pages, which (correctly) happens even if we have a truncate
+	 * without allocation change - ocfs2 cluster sizes can be much
+	 * greater than page size, so we have to truncate them
+	 * anyway.
+	 */
 	unmap_mapping_range(inode->i_mapping, new_i_size + PAGE_SIZE - 1, 0, 1);
 	truncate_inode_pages(inode->i_mapping, new_i_size);
 
@@ -403,7 +398,7 @@ static int ocfs2_truncate_file(struct inode *inode,
 		if (status)
 			mlog_errno(status);
 
-		goto bail_unlock_data;
+		goto bail_unlock_sem;
 	}
 
 	/* alright, we're going to need to do a full blown alloc size
@@ -413,25 +408,23 @@ static int ocfs2_truncate_file(struct inode *inode,
 	status = ocfs2_orphan_for_truncate(osb, inode, di_bh, new_i_size);
 	if (status < 0) {
 		mlog_errno(status);
-		goto bail_unlock_data;
+		goto bail_unlock_sem;
 	}
 
 	status = ocfs2_prepare_truncate(osb, inode, di_bh, &tc);
 	if (status < 0) {
 		mlog_errno(status);
-		goto bail_unlock_data;
+		goto bail_unlock_sem;
 	}
 
 	status = ocfs2_commit_truncate(osb, inode, di_bh, tc);
 	if (status < 0) {
 		mlog_errno(status);
-		goto bail_unlock_data;
+		goto bail_unlock_sem;
 	}
 
 	/* TODO: orphan dir cleanup here. */
-bail_unlock_data:
-	ocfs2_data_unlock(inode, 1);
-
+bail_unlock_sem:
 	up_write(&OCFS2_I(inode)->ip_alloc_sem);
 
 bail:
@@ -917,7 +910,7 @@ static int ocfs2_extend_file(struct inode *inode,
 			     struct buffer_head *di_bh,
 			     u64 new_i_size)
 {
-	int ret = 0, data_locked = 0;
+	int ret = 0;
 	struct ocfs2_inode_info *oi = OCFS2_I(inode);
 
 	BUG_ON(!di_bh);
@@ -943,20 +936,6 @@ static int ocfs2_extend_file(struct inode *inode,
 	    && ocfs2_sparse_alloc(OCFS2_SB(inode->i_sb)))
 		goto out_update_size;
 
-	/* 
-	 * protect the pages that ocfs2_zero_extend is going to be
-	 * pulling into the page cache.. we do this before the
-	 * metadata extend so that we don't get into the situation
-	 * where we've extended the metadata but can't get the data
-	 * lock to zero.
-	 */
-	ret = ocfs2_data_lock(inode, 1);
-	if (ret < 0) {
-		mlog_errno(ret);
-		goto out;
-	}
-	data_locked = 1;
-
 	/*
 	 * The alloc sem blocks people in read/write from reading our
 	 * allocation until we're done changing it. We depend on
@@ -980,7 +959,7 @@ static int ocfs2_extend_file(struct inode *inode,
 			up_write(&oi->ip_alloc_sem);
 
 			mlog_errno(ret);
-			goto out_unlock;
+			goto out;
 		}
 	}
 
@@ -991,7 +970,7 @@ static int ocfs2_extend_file(struct inode *inode,
 
 	if (ret < 0) {
 		mlog_errno(ret);
-		goto out_unlock;
+		goto out;
 	}
 
 out_update_size:
@@ -999,10 +978,6 @@ out_update_size:
 	if (ret < 0)
 		mlog_errno(ret);
 
-out_unlock:
-	if (data_locked)
-		ocfs2_data_unlock(inode, 1);
-
 out:
 	return ret;
 }
diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 86cf073..8ff201d 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -332,10 +332,6 @@ int ocfs2_populate_inode(struct inode *inode, struct ocfs2_dinode *fe,
 				  OCFS2_LOCK_TYPE_RW, inode->i_generation,
 				  inode);
 
-	ocfs2_inode_lock_res_init(&OCFS2_I(inode)->ip_data_lockres,
-				  OCFS2_LOCK_TYPE_DATA, inode->i_generation,
-				  inode);
-
 	ocfs2_set_inode_flags(inode);
 
 	status = 0;
@@ -1014,7 +1010,6 @@ void ocfs2_clear_inode(struct inode *inode)
 	 * the downconvert thread while waiting to destroy the locks. */
 	ocfs2_mark_lockres_freeing(&oi->ip_rw_lockres);
 	ocfs2_mark_lockres_freeing(&oi->ip_meta_lockres);
-	ocfs2_mark_lockres_freeing(&oi->ip_data_lockres);
 	ocfs2_mark_lockres_freeing(&oi->ip_open_lockres);
 
 	/* We very well may get a clear_inode before all an inodes
@@ -1038,7 +1033,6 @@ void ocfs2_clear_inode(struct inode *inode)
 
 	ocfs2_lock_res_free(&oi->ip_rw_lockres);
 	ocfs2_lock_res_free(&oi->ip_meta_lockres);
-	ocfs2_lock_res_free(&oi->ip_data_lockres);
 	ocfs2_lock_res_free(&oi->ip_open_lockres);
 
 	ocfs2_metadata_cache_purge(inode);
diff --git a/fs/ocfs2/inode.h b/fs/ocfs2/inode.h
index 70e881c..d1c54da 100644
--- a/fs/ocfs2/inode.h
+++ b/fs/ocfs2/inode.h
@@ -35,7 +35,6 @@ struct ocfs2_inode_info
 
 	struct ocfs2_lock_res		ip_rw_lockres;
 	struct ocfs2_lock_res		ip_meta_lockres;
-	struct ocfs2_lock_res		ip_data_lockres;
 	struct ocfs2_lock_res		ip_open_lockres;
 
 	/* protects allocation changes on this inode. */
diff --git a/fs/ocfs2/mmap.c b/fs/ocfs2/mmap.c
index 9875615..a7f0ccc 100644
--- a/fs/ocfs2/mmap.c
+++ b/fs/ocfs2/mmap.c
@@ -181,17 +181,8 @@ static int ocfs2_page_mkwrite(struct vm_area_struct *vma, struct page *page)
 	 */
 	down_write(&OCFS2_I(inode)->ip_alloc_sem);
 
-	ret = ocfs2_data_lock(inode, 1);
-	if (ret < 0) {
-		mlog_errno(ret);
-		goto out_meta_unlock;
-	}
-
 	ret = __ocfs2_page_mkwrite(inode, di_bh, page);
 
-	ocfs2_data_unlock(inode, 1);
-
-out_meta_unlock:
 	up_write(&OCFS2_I(inode)->ip_alloc_sem);
 
 	brelse(di_bh);
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 1996820..064eba0 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1020,7 +1020,6 @@ static void ocfs2_inode_init_once(struct kmem_cache *cachep, void *data)
 
 	ocfs2_lock_res_init_once(&oi->ip_rw_lockres);
 	ocfs2_lock_res_init_once(&oi->ip_meta_lockres);
-	ocfs2_lock_res_init_once(&oi->ip_data_lockres);
 	ocfs2_lock_res_init_once(&oi->ip_open_lockres);
 
 	ocfs2_metadata_cache_init(&oi->vfs_inode);
-- 
1.5.3.6
