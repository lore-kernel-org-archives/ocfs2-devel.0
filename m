From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Thu Jan 17 14:37:04 2008
Subject: [Ocfs2-devel] [PATCH 06/30] ocfs2: Rename ocfs2_meta_[un]lock
In-Reply-To: <1200609356-17788-1-git-send-email-mark.fasheh@oracle.com>
References: <1200609356-17788-1-git-send-email-mark.fasheh@oracle.com>
Message-ID: <1200609356-17788-7-git-send-email-mark.fasheh@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Mark Fasheh <mark.fasheh@oracle.com>

Call this the "inode_lock" now, since it covers both data and meta data.
This patch makes no functional changes.

Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
---
 fs/ocfs2/alloc.c      |    8 +++---
 fs/ocfs2/aops.c       |   18 ++++++++--------
 fs/ocfs2/dir.c        |    8 +++---
 fs/ocfs2/dlmglue.c    |   50 ++++++++++++++++++++++----------------------
 fs/ocfs2/dlmglue.h    |   12 +++++-----
 fs/ocfs2/export.c     |    4 +-
 fs/ocfs2/file.c       |   42 +++++++++++++++++++-------------------
 fs/ocfs2/inode.c      |   30 +++++++++++++-------------
 fs/ocfs2/inode.h      |    2 +-
 fs/ocfs2/ioctl.c      |    8 +++---
 fs/ocfs2/journal.c    |   26 +++++++++++-----------
 fs/ocfs2/localalloc.c |    8 +++---
 fs/ocfs2/mmap.c       |    8 +++---
 fs/ocfs2/namei.c      |   54 ++++++++++++++++++++++++------------------------
 fs/ocfs2/suballoc.c   |    4 +-
 fs/ocfs2/super.c      |    6 ++--
 16 files changed, 144 insertions(+), 144 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 23c8cda..e6df06a 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -4731,7 +4731,7 @@ int __ocfs2_flush_truncate_log(struct ocfs2_super *osb)
 
 	mutex_lock(&data_alloc_inode->i_mutex);
 
-	status = ocfs2_meta_lock(data_alloc_inode, &data_alloc_bh, 1);
+	status = ocfs2_inode_lock(data_alloc_inode, &data_alloc_bh, 1);
 	if (status < 0) {
 		mlog_errno(status);
 		goto out_mutex;
@@ -4753,7 +4753,7 @@ int __ocfs2_flush_truncate_log(struct ocfs2_super *osb)
 
 out_unlock:
 	brelse(data_alloc_bh);
-	ocfs2_meta_unlock(data_alloc_inode, 1);
+	ocfs2_inode_unlock(data_alloc_inode, 1);
 
 out_mutex:
 	mutex_unlock(&data_alloc_inode->i_mutex);
@@ -5077,7 +5077,7 @@ static int ocfs2_free_cached_items(struct ocfs2_super *osb,
 
 	mutex_lock(&inode->i_mutex);
 
-	ret = ocfs2_meta_lock(inode, &di_bh, 1);
+	ret = ocfs2_inode_lock(inode, &di_bh, 1);
 	if (ret) {
 		mlog_errno(ret);
 		goto out_mutex;
@@ -5118,7 +5118,7 @@ out_journal:
 	ocfs2_commit_trans(osb, handle);
 
 out_unlock:
-	ocfs2_meta_unlock(inode, 1);
+	ocfs2_inode_unlock(inode, 1);
 	brelse(di_bh);
 out_mutex:
 	mutex_unlock(&inode->i_mutex);
diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 5fc27cf..ac8c390 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -275,7 +275,7 @@ static int ocfs2_readpage(struct file *file, struct page *page)
 
 	mlog_entry("(0x%p, %lu)\n", file, (page ? page->index : 0));
 
-	ret = ocfs2_meta_lock_with_page(inode, NULL, 0, page);
+	ret = ocfs2_inode_lock_with_page(inode, NULL, 0, page);
 	if (ret != 0) {
 		if (ret == AOP_TRUNCATED_PAGE)
 			unlock = 0;
@@ -285,7 +285,7 @@ static int ocfs2_readpage(struct file *file, struct page *page)
 
 	if (down_read_trylock(&oi->ip_alloc_sem) == 0) {
 		ret = AOP_TRUNCATED_PAGE;
-		goto out_meta_unlock;
+		goto out_inode_unlock;
 	}
 
 	/*
@@ -313,8 +313,8 @@ static int ocfs2_readpage(struct file *file, struct page *page)
 
 out_alloc:
 	up_read(&OCFS2_I(inode)->ip_alloc_sem);
-out_meta_unlock:
-	ocfs2_meta_unlock(inode, 0);
+out_inode_unlock:
+	ocfs2_inode_unlock(inode, 0);
 out:
 	if (unlock)
 		unlock_page(page);
@@ -443,7 +443,7 @@ static sector_t ocfs2_bmap(struct address_space *mapping, sector_t block)
 	 * accessed concurrently from multiple nodes.
 	 */
 	if (!INODE_JOURNAL(inode)) {
-		err = ocfs2_meta_lock(inode, NULL, 0);
+		err = ocfs2_inode_lock(inode, NULL, 0);
 		if (err) {
 			if (err != -ENOENT)
 				mlog_errno(err);
@@ -458,7 +458,7 @@ static sector_t ocfs2_bmap(struct address_space *mapping, sector_t block)
 
 	if (!INODE_JOURNAL(inode)) {
 		up_read(&OCFS2_I(inode)->ip_alloc_sem);
-		ocfs2_meta_unlock(inode, 0);
+		ocfs2_inode_unlock(inode, 0);
 	}
 
 	if (err) {
@@ -1723,7 +1723,7 @@ static int ocfs2_write_begin(struct file *file, struct address_space *mapping,
 	struct buffer_head *di_bh = NULL;
 	struct inode *inode = mapping->host;
 
-	ret = ocfs2_meta_lock(inode, &di_bh, 1);
+	ret = ocfs2_inode_lock(inode, &di_bh, 1);
 	if (ret) {
 		mlog_errno(ret);
 		return ret;
@@ -1753,7 +1753,7 @@ out_fail:
 	up_write(&OCFS2_I(inode)->ip_alloc_sem);
 
 	brelse(di_bh);
-	ocfs2_meta_unlock(inode, 1);
+	ocfs2_inode_unlock(inode, 1);
 
 	return ret;
 }
@@ -1870,7 +1870,7 @@ static int ocfs2_write_end(struct file *file, struct address_space *mapping,
 	ret = ocfs2_write_end_nolock(mapping, pos, len, copied, page, fsdata);
 
 	up_write(&OCFS2_I(inode)->ip_alloc_sem);
-	ocfs2_meta_unlock(inode, 1);
+	ocfs2_inode_unlock(inode, 1);
 
 	return ret;
 }
diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index 63b28fd..6b0107f 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -846,14 +846,14 @@ int ocfs2_readdir(struct file * filp, void * dirent, filldir_t filldir)
 	mlog_entry("dirino=%llu\n",
 		   (unsigned long long)OCFS2_I(inode)->ip_blkno);
 
-	error = ocfs2_meta_lock_atime(inode, filp->f_vfsmnt, &lock_level);
+	error = ocfs2_inode_lock_atime(inode, filp->f_vfsmnt, &lock_level);
 	if (lock_level && error >= 0) {
 		/* We release EX lock which used to update atime
 		 * and get PR lock again to reduce contention
 		 * on commonly accessed directories. */
-		ocfs2_meta_unlock(inode, 1);
+		ocfs2_inode_unlock(inode, 1);
 		lock_level = 0;
-		error = ocfs2_meta_lock(inode, NULL, 0);
+		error = ocfs2_inode_lock(inode, NULL, 0);
 	}
 	if (error < 0) {
 		if (error != -ENOENT)
@@ -865,7 +865,7 @@ int ocfs2_readdir(struct file * filp, void * dirent, filldir_t filldir)
 	error = ocfs2_dir_foreach_blk(inode, &filp->f_version, &filp->f_pos,
 				      dirent, filldir, NULL);
 
-	ocfs2_meta_unlock(inode, lock_level);
+	ocfs2_inode_unlock(inode, lock_level);
 
 bail_nolock:
 	mlog_exit(error);
diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index adc8f6e..c365206 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -224,7 +224,7 @@ static struct ocfs2_lock_res_ops ocfs2_inode_rw_lops = {
 	.flags		= 0,
 };
 
-static struct ocfs2_lock_res_ops ocfs2_inode_meta_lops = {
+static struct ocfs2_lock_res_ops ocfs2_inode_inode_lops = {
 	.get_osb	= ocfs2_get_inode_osb,
 	.check_downconvert = ocfs2_check_meta_downconvert,
 	.set_lvb	= ocfs2_set_meta_lvb,
@@ -306,7 +306,7 @@ static inline void ocfs2_recover_from_dlm_error(struct ocfs2_lock_res *lockres,
 static int ocfs2_downconvert_thread(void *arg);
 static void ocfs2_downconvert_on_unlock(struct ocfs2_super *osb,
 					struct ocfs2_lock_res *lockres);
-static int ocfs2_meta_lock_update(struct inode *inode,
+static int ocfs2_inode_lock_update(struct inode *inode,
 				  struct buffer_head **bh);
 static void ocfs2_drop_osb_locks(struct ocfs2_super *osb);
 static inline int ocfs2_highest_compat_lock_level(int level);
@@ -396,7 +396,7 @@ void ocfs2_inode_lock_res_init(struct ocfs2_lock_res *res,
 			ops = &ocfs2_inode_rw_lops;
 			break;
 		case OCFS2_LOCK_TYPE_META:
-			ops = &ocfs2_inode_meta_lops;
+			ops = &ocfs2_inode_inode_lops;
 			break;
 		case OCFS2_LOCK_TYPE_OPEN:
 			ops = &ocfs2_inode_open_lops;
@@ -1138,7 +1138,7 @@ int ocfs2_create_new_inode_locks(struct inode *inode)
 	 * We don't want to use LKM_LOCAL on a meta data lock as they
 	 * don't use a generation in their lock names.
 	 */
-	ret = ocfs2_create_new_lock(osb, &OCFS2_I(inode)->ip_meta_lockres, 1, 0);
+	ret = ocfs2_create_new_lock(osb, &OCFS2_I(inode)->ip_inode_lockres, 1, 0);
 	if (ret) {
 		mlog_errno(ret);
 		goto bail;
@@ -1346,11 +1346,11 @@ static u64 ocfs2_pack_timespec(struct timespec *spec)
 
 /* Call this with the lockres locked. I am reasonably sure we don't
  * need ip_lock in this function as anyone who would be changing those
- * values is supposed to be blocked in ocfs2_meta_lock right now. */
+ * values is supposed to be blocked in ocfs2_inode_lock right now. */
 static void __ocfs2_stuff_meta_lvb(struct inode *inode)
 {
 	struct ocfs2_inode_info *oi = OCFS2_I(inode);
-	struct ocfs2_lock_res *lockres = &oi->ip_meta_lockres;
+	struct ocfs2_lock_res *lockres = &oi->ip_inode_lockres;
 	struct ocfs2_meta_lvb *lvb;
 
 	mlog_entry_void();
@@ -1400,7 +1400,7 @@ static void ocfs2_unpack_timespec(struct timespec *spec,
 static void ocfs2_refresh_inode_from_lvb(struct inode *inode)
 {
 	struct ocfs2_inode_info *oi = OCFS2_I(inode);
-	struct ocfs2_lock_res *lockres = &oi->ip_meta_lockres;
+	struct ocfs2_lock_res *lockres = &oi->ip_inode_lockres;
 	struct ocfs2_meta_lvb *lvb;
 
 	mlog_entry_void();
@@ -1508,12 +1508,12 @@ static inline void ocfs2_complete_lock_res_refresh(struct ocfs2_lock_res *lockre
 }
 
 /* may or may not return a bh if it went to disk. */
-static int ocfs2_meta_lock_update(struct inode *inode,
+static int ocfs2_inode_lock_update(struct inode *inode,
 				  struct buffer_head **bh)
 {
 	int status = 0;
 	struct ocfs2_inode_info *oi = OCFS2_I(inode);
-	struct ocfs2_lock_res *lockres = &oi->ip_meta_lockres;
+	struct ocfs2_lock_res *lockres = &oi->ip_inode_lockres;
 	struct ocfs2_dinode *fe;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 
@@ -1625,7 +1625,7 @@ static int ocfs2_assign_bh(struct inode *inode,
  * returns < 0 error if the callback will never be called, otherwise
  * the result of the lock will be communicated via the callback.
  */
-int ocfs2_meta_lock_full(struct inode *inode,
+int ocfs2_inode_lock_full(struct inode *inode,
 			 struct buffer_head **ret_bh,
 			 int ex,
 			 int arg_flags)
@@ -1660,7 +1660,7 @@ int ocfs2_meta_lock_full(struct inode *inode,
 		wait_event(osb->recovery_event,
 			   ocfs2_node_map_is_empty(osb, &osb->recovery_map));
 
-	lockres = &OCFS2_I(inode)->ip_meta_lockres;
+	lockres = &OCFS2_I(inode)->ip_inode_lockres;
 	level = ex ? LKM_EXMODE : LKM_PRMODE;
 	dlm_flags = 0;
 	if (arg_flags & OCFS2_META_LOCK_NOQUEUE)
@@ -1699,11 +1699,11 @@ local:
 	}
 
 	/* This is fun. The caller may want a bh back, or it may
-	 * not. ocfs2_meta_lock_update definitely wants one in, but
+	 * not. ocfs2_inode_lock_update definitely wants one in, but
 	 * may or may not read one, depending on what's in the
 	 * LVB. The result of all of this is that we've *only* gone to
 	 * disk if we have to, so the complexity is worthwhile. */
-	status = ocfs2_meta_lock_update(inode, &local_bh);
+	status = ocfs2_inode_lock_update(inode, &local_bh);
 	if (status < 0) {
 		if (status != -ENOENT)
 			mlog_errno(status);
@@ -1725,7 +1725,7 @@ bail:
 			*ret_bh = NULL;
 		}
 		if (acquired)
-			ocfs2_meta_unlock(inode, ex);
+			ocfs2_inode_unlock(inode, ex);
 	}
 
 	if (local_bh)
@@ -1757,32 +1757,32 @@ bail:
  * ping locks back and forth, but that's a risk we're willing to take to avoid
  * the lock inversion simply.
  */
-int ocfs2_meta_lock_with_page(struct inode *inode,
+int ocfs2_inode_lock_with_page(struct inode *inode,
 			      struct buffer_head **ret_bh,
 			      int ex,
 			      struct page *page)
 {
 	int ret;
 
-	ret = ocfs2_meta_lock_full(inode, ret_bh, ex, OCFS2_LOCK_NONBLOCK);
+	ret = ocfs2_inode_lock_full(inode, ret_bh, ex, OCFS2_LOCK_NONBLOCK);
 	if (ret == -EAGAIN) {
 		unlock_page(page);
-		if (ocfs2_meta_lock(inode, ret_bh, ex) == 0)
-			ocfs2_meta_unlock(inode, ex);
+		if (ocfs2_inode_lock(inode, ret_bh, ex) == 0)
+			ocfs2_inode_unlock(inode, ex);
 		ret = AOP_TRUNCATED_PAGE;
 	}
 
 	return ret;
 }
 
-int ocfs2_meta_lock_atime(struct inode *inode,
+int ocfs2_inode_lock_atime(struct inode *inode,
 			  struct vfsmount *vfsmnt,
 			  int *level)
 {
 	int ret;
 
 	mlog_entry_void();
-	ret = ocfs2_meta_lock(inode, NULL, 0);
+	ret = ocfs2_inode_lock(inode, NULL, 0);
 	if (ret < 0) {
 		mlog_errno(ret);
 		return ret;
@@ -1795,8 +1795,8 @@ int ocfs2_meta_lock_atime(struct inode *inode,
 	if (ocfs2_should_update_atime(inode, vfsmnt)) {
 		struct buffer_head *bh = NULL;
 
-		ocfs2_meta_unlock(inode, 0);
-		ret = ocfs2_meta_lock(inode, &bh, 1);
+		ocfs2_inode_unlock(inode, 0);
+		ret = ocfs2_inode_lock(inode, &bh, 1);
 		if (ret < 0) {
 			mlog_errno(ret);
 			return ret;
@@ -1813,11 +1813,11 @@ int ocfs2_meta_lock_atime(struct inode *inode,
 	return ret;
 }
 
-void ocfs2_meta_unlock(struct inode *inode,
+void ocfs2_inode_unlock(struct inode *inode,
 		       int ex)
 {
 	int level = ex ? LKM_EXMODE : LKM_PRMODE;
-	struct ocfs2_lock_res *lockres = &OCFS2_I(inode)->ip_meta_lockres;
+	struct ocfs2_lock_res *lockres = &OCFS2_I(inode)->ip_inode_lockres;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 
 	mlog_entry_void();
@@ -2495,7 +2495,7 @@ int ocfs2_drop_inode_locks(struct inode *inode)
 	status = err;
 
 	err = ocfs2_drop_lock(OCFS2_SB(inode->i_sb),
-			      &OCFS2_I(inode)->ip_meta_lockres);
+			      &OCFS2_I(inode)->ip_inode_lockres);
 	if (err < 0)
 		mlog_errno(err);
 	if (err < 0 && !status)
diff --git a/fs/ocfs2/dlmglue.h b/fs/ocfs2/dlmglue.h
index 3fd7729..6dcbc94 100644
--- a/fs/ocfs2/dlmglue.h
+++ b/fs/ocfs2/dlmglue.h
@@ -49,7 +49,7 @@ struct ocfs2_meta_lvb {
 	__be32       lvb_reserved2;
 };
 
-/* ocfs2_meta_lock_full() 'arg_flags' flags */
+/* ocfs2_inode_lock_full() 'arg_flags' flags */
 /* don't wait on recovery. */
 #define OCFS2_META_LOCK_RECOVERY	(0x01)
 /* Instruct the dlm not to queue ourselves on the other node. */
@@ -74,21 +74,21 @@ void ocfs2_rw_unlock(struct inode *inode, int write);
 int ocfs2_open_lock(struct inode *inode);
 int ocfs2_try_open_lock(struct inode *inode, int write);
 void ocfs2_open_unlock(struct inode *inode);
-int ocfs2_meta_lock_atime(struct inode *inode,
+int ocfs2_inode_lock_atime(struct inode *inode,
 			  struct vfsmount *vfsmnt,
 			  int *level);
-int ocfs2_meta_lock_full(struct inode *inode,
+int ocfs2_inode_lock_full(struct inode *inode,
 			 struct buffer_head **ret_bh,
 			 int ex,
 			 int arg_flags);
-int ocfs2_meta_lock_with_page(struct inode *inode,
+int ocfs2_inode_lock_with_page(struct inode *inode,
 			      struct buffer_head **ret_bh,
 			      int ex,
 			      struct page *page);
 /* 99% of the time we don't want to supply any additional flags --
  * those are for very specific cases only. */
-#define ocfs2_meta_lock(i, b, e) ocfs2_meta_lock_full(i, b, e, 0)
-void ocfs2_meta_unlock(struct inode *inode,
+#define ocfs2_inode_lock(i, b, e) ocfs2_inode_lock_full(i, b, e, 0)
+void ocfs2_inode_unlock(struct inode *inode,
 		       int ex);
 int ocfs2_super_lock(struct ocfs2_super *osb,
 		     int ex);
diff --git a/fs/ocfs2/export.c b/fs/ocfs2/export.c
index 535bfa9..1f9e353 100644
--- a/fs/ocfs2/export.c
+++ b/fs/ocfs2/export.c
@@ -95,7 +95,7 @@ static struct dentry *ocfs2_get_parent(struct dentry *child)
 	mlog(0, "find parent of directory %llu\n",
 	     (unsigned long long)OCFS2_I(dir)->ip_blkno);
 
-	status = ocfs2_meta_lock(dir, NULL, 0);
+	status = ocfs2_inode_lock(dir, NULL, 0);
 	if (status < 0) {
 		if (status != -ENOENT)
 			mlog_errno(status);
@@ -126,7 +126,7 @@ static struct dentry *ocfs2_get_parent(struct dentry *child)
 	parent->d_op = &ocfs2_dentry_ops;
 
 bail_unlock:
-	ocfs2_meta_unlock(dir, 0);
+	ocfs2_inode_unlock(dir, 0);
 
 bail:
 	mlog_exit_ptr(parent);
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index c5c183a..432e5f3 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -1025,7 +1025,7 @@ int ocfs2_setattr(struct dentry *dentry, struct iattr *attr)
 		}
 	}
 
-	status = ocfs2_meta_lock(inode, &bh, 1);
+	status = ocfs2_inode_lock(inode, &bh, 1);
 	if (status < 0) {
 		if (status != -ENOENT)
 			mlog_errno(status);
@@ -1077,7 +1077,7 @@ int ocfs2_setattr(struct dentry *dentry, struct iattr *attr)
 bail_commit:
 	ocfs2_commit_trans(osb, handle);
 bail_unlock:
-	ocfs2_meta_unlock(inode, 1);
+	ocfs2_inode_unlock(inode, 1);
 bail_unlock_rw:
 	if (size_change)
 		ocfs2_rw_unlock(inode, 1);
@@ -1124,7 +1124,7 @@ int ocfs2_permission(struct inode *inode, int mask, struct nameidata *nd)
 
 	mlog_entry_void();
 
-	ret = ocfs2_meta_lock(inode, NULL, 0);
+	ret = ocfs2_inode_lock(inode, NULL, 0);
 	if (ret) {
 		if (ret != -ENOENT)
 			mlog_errno(ret);
@@ -1133,7 +1133,7 @@ int ocfs2_permission(struct inode *inode, int mask, struct nameidata *nd)
 
 	ret = generic_permission(inode, mask, NULL);
 
-	ocfs2_meta_unlock(inode, 0);
+	ocfs2_inode_unlock(inode, 0);
 out:
 	mlog_exit(ret);
 	return ret;
@@ -1605,7 +1605,7 @@ static int __ocfs2_change_file_space(struct file *file, struct inode *inode,
 		goto out;
 	}
 
-	ret = ocfs2_meta_lock(inode, &di_bh, 1);
+	ret = ocfs2_inode_lock(inode, &di_bh, 1);
 	if (ret) {
 		mlog_errno(ret);
 		goto out_rw_unlock;
@@ -1613,7 +1613,7 @@ static int __ocfs2_change_file_space(struct file *file, struct inode *inode,
 
 	if (inode->i_flags & (S_IMMUTABLE|S_APPEND)) {
 		ret = -EPERM;
-		goto out_meta_unlock;
+		goto out_inode_unlock;
 	}
 
 	switch (sr->l_whence) {
@@ -1627,7 +1627,7 @@ static int __ocfs2_change_file_space(struct file *file, struct inode *inode,
 		break;
 	default:
 		ret = -EINVAL;
-		goto out_meta_unlock;
+		goto out_inode_unlock;
 	}
 	sr->l_whence = 0;
 
@@ -1638,14 +1638,14 @@ static int __ocfs2_change_file_space(struct file *file, struct inode *inode,
 	    || (sr->l_start + llen) < 0
 	    || (sr->l_start + llen) > max_off) {
 		ret = -EINVAL;
-		goto out_meta_unlock;
+		goto out_inode_unlock;
 	}
 	size = sr->l_start + sr->l_len;
 
 	if (cmd == OCFS2_IOC_RESVSP || cmd == OCFS2_IOC_RESVSP64) {
 		if (sr->l_len <= 0) {
 			ret = -EINVAL;
-			goto out_meta_unlock;
+			goto out_inode_unlock;
 		}
 	}
 
@@ -1653,7 +1653,7 @@ static int __ocfs2_change_file_space(struct file *file, struct inode *inode,
 		ret = __ocfs2_write_remove_suid(inode, di_bh);
 		if (ret) {
 			mlog_errno(ret);
-			goto out_meta_unlock;
+			goto out_inode_unlock;
 		}
 	}
 
@@ -1679,7 +1679,7 @@ static int __ocfs2_change_file_space(struct file *file, struct inode *inode,
 	up_write(&OCFS2_I(inode)->ip_alloc_sem);
 	if (ret) {
 		mlog_errno(ret);
-		goto out_meta_unlock;
+		goto out_inode_unlock;
 	}
 
 	/*
@@ -1689,7 +1689,7 @@ static int __ocfs2_change_file_space(struct file *file, struct inode *inode,
 	if (IS_ERR(handle)) {
 		ret = PTR_ERR(handle);
 		mlog_errno(ret);
-		goto out_meta_unlock;
+		goto out_inode_unlock;
 	}
 
 	if (change_size && i_size_read(inode) < size)
@@ -1702,9 +1702,9 @@ static int __ocfs2_change_file_space(struct file *file, struct inode *inode,
 
 	ocfs2_commit_trans(osb, handle);
 
-out_meta_unlock:
+out_inode_unlock:
 	brelse(di_bh);
-	ocfs2_meta_unlock(inode, 1);
+	ocfs2_inode_unlock(inode, 1);
 out_rw_unlock:
 	ocfs2_rw_unlock(inode, 1);
 
@@ -1774,7 +1774,7 @@ static int ocfs2_prepare_inode_for_write(struct dentry *dentry,
 	 * if we need to make modifications here.
 	 */
 	for(;;) {
-		ret = ocfs2_meta_lock(inode, NULL, meta_level);
+		ret = ocfs2_inode_lock(inode, NULL, meta_level);
 		if (ret < 0) {
 			meta_level = -1;
 			mlog_errno(ret);
@@ -1792,7 +1792,7 @@ static int ocfs2_prepare_inode_for_write(struct dentry *dentry,
 		 * set inode->i_size at the end of a write. */
 		if (should_remove_suid(dentry)) {
 			if (meta_level == 0) {
-				ocfs2_meta_unlock(inode, meta_level);
+				ocfs2_inode_unlock(inode, meta_level);
 				meta_level = 1;
 				continue;
 			}
@@ -1861,7 +1861,7 @@ static int ocfs2_prepare_inode_for_write(struct dentry *dentry,
 		*ppos = saved_pos;
 
 out_unlock:
-	ocfs2_meta_unlock(inode, meta_level);
+	ocfs2_inode_unlock(inode, meta_level);
 
 out:
 	return ret;
@@ -2074,12 +2074,12 @@ static ssize_t ocfs2_file_splice_read(struct file *in,
 	/*
 	 * See the comment in ocfs2_file_aio_read()
 	 */
-	ret = ocfs2_meta_lock(inode, NULL, 0);
+	ret = ocfs2_inode_lock(inode, NULL, 0);
 	if (ret < 0) {
 		mlog_errno(ret);
 		goto bail;
 	}
-	ocfs2_meta_unlock(inode, 0);
+	ocfs2_inode_unlock(inode, 0);
 
 	ret = generic_file_splice_read(in, ppos, pipe, len, flags);
 
@@ -2135,12 +2135,12 @@ static ssize_t ocfs2_file_aio_read(struct kiocb *iocb,
 	 * like i_size. This allows the checks down below
 	 * generic_file_aio_read() a chance of actually working. 
 	 */
-	ret = ocfs2_meta_lock_atime(inode, filp->f_vfsmnt, &lock_level);
+	ret = ocfs2_inode_lock_atime(inode, filp->f_vfsmnt, &lock_level);
 	if (ret < 0) {
 		mlog_errno(ret);
 		goto bail;
 	}
-	ocfs2_meta_unlock(inode, lock_level);
+	ocfs2_inode_unlock(inode, lock_level);
 
 	ret = generic_file_aio_read(iocb, iov, nr_segs, iocb->ki_pos);
 	if (ret == -EINVAL)
diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 8ff201d..00cd5b7 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -321,7 +321,7 @@ int ocfs2_populate_inode(struct inode *inode, struct ocfs2_dinode *fe,
 		 */
 		BUG_ON(le32_to_cpu(fe->i_flags) & OCFS2_SYSTEM_FL);
 
-		ocfs2_inode_lock_res_init(&OCFS2_I(inode)->ip_meta_lockres,
+		ocfs2_inode_lock_res_init(&OCFS2_I(inode)->ip_inode_lockres,
 					  OCFS2_LOCK_TYPE_META, 0, inode);
 
 		ocfs2_inode_lock_res_init(&OCFS2_I(inode)->ip_open_lockres,
@@ -409,7 +409,7 @@ static int ocfs2_read_locked_inode(struct inode *inode,
 	if (args->fi_flags & OCFS2_FI_FLAG_SYSFILE)
 		generation = osb->fs_generation;
 
-	ocfs2_inode_lock_res_init(&OCFS2_I(inode)->ip_meta_lockres,
+	ocfs2_inode_lock_res_init(&OCFS2_I(inode)->ip_inode_lockres,
 				  OCFS2_LOCK_TYPE_META,
 				  generation, inode);
 
@@ -424,7 +424,7 @@ static int ocfs2_read_locked_inode(struct inode *inode,
 			mlog_errno(status);
 			return status;
 		}
-		status = ocfs2_meta_lock(inode, NULL, 0);
+		status = ocfs2_inode_lock(inode, NULL, 0);
 		if (status) {
 			make_bad_inode(inode);
 			mlog_errno(status);
@@ -479,7 +479,7 @@ static int ocfs2_read_locked_inode(struct inode *inode,
 
 bail:
 	if (can_lock)
-		ocfs2_meta_unlock(inode, 0);
+		ocfs2_inode_unlock(inode, 0);
 
 	if (status < 0)
 		make_bad_inode(inode);
@@ -581,7 +581,7 @@ static int ocfs2_remove_inode(struct inode *inode,
 	}
 
 	mutex_lock(&inode_alloc_inode->i_mutex);
-	status = ocfs2_meta_lock(inode_alloc_inode, &inode_alloc_bh, 1);
+	status = ocfs2_inode_lock(inode_alloc_inode, &inode_alloc_bh, 1);
 	if (status < 0) {
 		mutex_unlock(&inode_alloc_inode->i_mutex);
 
@@ -630,7 +630,7 @@ static int ocfs2_remove_inode(struct inode *inode,
 bail_commit:
 	ocfs2_commit_trans(osb, handle);
 bail_unlock:
-	ocfs2_meta_unlock(inode_alloc_inode, 1);
+	ocfs2_inode_unlock(inode_alloc_inode, 1);
 	mutex_unlock(&inode_alloc_inode->i_mutex);
 	brelse(inode_alloc_bh);
 bail:
@@ -704,7 +704,7 @@ static int ocfs2_wipe_inode(struct inode *inode,
 	 * delete_inode operation. We do this now to avoid races with
 	 * recovery completion on other nodes. */
 	mutex_lock(&orphan_dir_inode->i_mutex);
-	status = ocfs2_meta_lock(orphan_dir_inode, &orphan_dir_bh, 1);
+	status = ocfs2_inode_lock(orphan_dir_inode, &orphan_dir_bh, 1);
 	if (status < 0) {
 		mutex_unlock(&orphan_dir_inode->i_mutex);
 
@@ -728,7 +728,7 @@ static int ocfs2_wipe_inode(struct inode *inode,
 		mlog_errno(status);
 
 bail_unlock_dir:
-	ocfs2_meta_unlock(orphan_dir_inode, 1);
+	ocfs2_inode_unlock(orphan_dir_inode, 1);
 	mutex_unlock(&orphan_dir_inode->i_mutex);
 	brelse(orphan_dir_bh);
 bail:
@@ -929,7 +929,7 @@ void ocfs2_delete_inode(struct inode *inode)
 	 * allocation lock here as it won't be needed - nobody will
 	 * have the file open.
 	 */
-	status = ocfs2_meta_lock(inode, &di_bh, 1);
+	status = ocfs2_inode_lock(inode, &di_bh, 1);
 	if (status < 0) {
 		if (status != -ENOENT)
 			mlog_errno(status);
@@ -975,7 +975,7 @@ void ocfs2_delete_inode(struct inode *inode)
 	OCFS2_I(inode)->ip_flags |= OCFS2_INODE_DELETED;
 
 bail_unlock_inode:
-	ocfs2_meta_unlock(inode, 1);
+	ocfs2_inode_unlock(inode, 1);
 	brelse(di_bh);
 bail_unblock:
 	status = sigprocmask(SIG_SETMASK, &oldset, NULL);
@@ -1009,7 +1009,7 @@ void ocfs2_clear_inode(struct inode *inode)
 	/* Do these before all the other work so that we don't bounce
 	 * the downconvert thread while waiting to destroy the locks. */
 	ocfs2_mark_lockres_freeing(&oi->ip_rw_lockres);
-	ocfs2_mark_lockres_freeing(&oi->ip_meta_lockres);
+	ocfs2_mark_lockres_freeing(&oi->ip_inode_lockres);
 	ocfs2_mark_lockres_freeing(&oi->ip_open_lockres);
 
 	/* We very well may get a clear_inode before all an inodes
@@ -1032,7 +1032,7 @@ void ocfs2_clear_inode(struct inode *inode)
 		mlog_errno(status);
 
 	ocfs2_lock_res_free(&oi->ip_rw_lockres);
-	ocfs2_lock_res_free(&oi->ip_meta_lockres);
+	ocfs2_lock_res_free(&oi->ip_inode_lockres);
 	ocfs2_lock_res_free(&oi->ip_open_lockres);
 
 	ocfs2_metadata_cache_purge(inode);
@@ -1176,15 +1176,15 @@ int ocfs2_inode_revalidate(struct dentry *dentry)
 	}
 	spin_unlock(&OCFS2_I(inode)->ip_lock);
 
-	/* Let ocfs2_meta_lock do the work of updating our struct
+	/* Let ocfs2_inode_lock do the work of updating our struct
 	 * inode for us. */
-	status = ocfs2_meta_lock(inode, NULL, 0);
+	status = ocfs2_inode_lock(inode, NULL, 0);
 	if (status < 0) {
 		if (status != -ENOENT)
 			mlog_errno(status);
 		goto bail;
 	}
-	ocfs2_meta_unlock(inode, 0);
+	ocfs2_inode_unlock(inode, 0);
 bail:
 	mlog_exit(status);
 
diff --git a/fs/ocfs2/inode.h b/fs/ocfs2/inode.h
index d1c54da..a61c044 100644
--- a/fs/ocfs2/inode.h
+++ b/fs/ocfs2/inode.h
@@ -34,7 +34,7 @@ struct ocfs2_inode_info
 	u64			ip_blkno;
 
 	struct ocfs2_lock_res		ip_rw_lockres;
-	struct ocfs2_lock_res		ip_meta_lockres;
+	struct ocfs2_lock_res		ip_inode_lockres;
 	struct ocfs2_lock_res		ip_open_lockres;
 
 	/* protects allocation changes on this inode. */
diff --git a/fs/ocfs2/ioctl.c b/fs/ocfs2/ioctl.c
index 87dcece..67c2fb4 100644
--- a/fs/ocfs2/ioctl.c
+++ b/fs/ocfs2/ioctl.c
@@ -27,14 +27,14 @@ static int ocfs2_get_inode_attr(struct inode *inode, unsigned *flags)
 {
 	int status;
 
-	status = ocfs2_meta_lock(inode, NULL, 0);
+	status = ocfs2_inode_lock(inode, NULL, 0);
 	if (status < 0) {
 		mlog_errno(status);
 		return status;
 	}
 	ocfs2_get_inode_flags(OCFS2_I(inode));
 	*flags = OCFS2_I(inode)->ip_attr;
-	ocfs2_meta_unlock(inode, 0);
+	ocfs2_inode_unlock(inode, 0);
 
 	mlog_exit(status);
 	return status;
@@ -52,7 +52,7 @@ static int ocfs2_set_inode_attr(struct inode *inode, unsigned flags,
 
 	mutex_lock(&inode->i_mutex);
 
-	status = ocfs2_meta_lock(inode, &bh, 1);
+	status = ocfs2_inode_lock(inode, &bh, 1);
 	if (status < 0) {
 		mlog_errno(status);
 		goto bail;
@@ -100,7 +100,7 @@ static int ocfs2_set_inode_attr(struct inode *inode, unsigned flags,
 
 	ocfs2_commit_trans(osb, handle);
 bail_unlock:
-	ocfs2_meta_unlock(inode, 1);
+	ocfs2_inode_unlock(inode, 1);
 bail:
 	mutex_unlock(&inode->i_mutex);
 
diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index f2ebe2e..4f440a8 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -336,7 +336,7 @@ int ocfs2_journal_init(struct ocfs2_journal *journal, int *dirty)
 	struct ocfs2_dinode *di = NULL;
 	struct buffer_head *bh = NULL;
 	struct ocfs2_super *osb;
-	int meta_lock = 0;
+	int inode_lock = 0;
 
 	mlog_entry_void();
 
@@ -366,14 +366,14 @@ int ocfs2_journal_init(struct ocfs2_journal *journal, int *dirty)
 	/* Skip recovery waits here - journal inode metadata never
 	 * changes in a live cluster so it can be considered an
 	 * exception to the rule. */
-	status = ocfs2_meta_lock_full(inode, &bh, 1, OCFS2_META_LOCK_RECOVERY);
+	status = ocfs2_inode_lock_full(inode, &bh, 1, OCFS2_META_LOCK_RECOVERY);
 	if (status < 0) {
 		if (status != -ERESTARTSYS)
 			mlog(ML_ERROR, "Could not get lock on journal!\n");
 		goto done;
 	}
 
-	meta_lock = 1;
+	inode_lock = 1;
 	di = (struct ocfs2_dinode *)bh->b_data;
 
 	if (inode->i_size <  OCFS2_MIN_JOURNAL_SIZE) {
@@ -413,8 +413,8 @@ int ocfs2_journal_init(struct ocfs2_journal *journal, int *dirty)
 	status = 0;
 done:
 	if (status < 0) {
-		if (meta_lock)
-			ocfs2_meta_unlock(inode, 1);
+		if (inode_lock)
+			ocfs2_inode_unlock(inode, 1);
 		if (bh != NULL)
 			brelse(bh);
 		if (inode) {
@@ -543,7 +543,7 @@ void ocfs2_journal_shutdown(struct ocfs2_super *osb)
 	OCFS2_I(inode)->ip_open_count--;
 
 	/* unlock our journal */
-	ocfs2_meta_unlock(inode, 1);
+	ocfs2_inode_unlock(inode, 1);
 
 	brelse(journal->j_bh);
 	journal->j_bh = NULL;
@@ -972,9 +972,9 @@ static int ocfs2_replay_journal(struct ocfs2_super *osb,
 	}
 	SET_INODE_JOURNAL(inode);
 
-	status = ocfs2_meta_lock_full(inode, &bh, 1, OCFS2_META_LOCK_RECOVERY);
+	status = ocfs2_inode_lock_full(inode, &bh, 1, OCFS2_META_LOCK_RECOVERY);
 	if (status < 0) {
-		mlog(0, "status returned from ocfs2_meta_lock=%d\n", status);
+		mlog(0, "status returned from ocfs2_inode_lock=%d\n", status);
 		if (status != -ERESTARTSYS)
 			mlog(ML_ERROR, "Could not lock journal!\n");
 		goto done;
@@ -1046,7 +1046,7 @@ static int ocfs2_replay_journal(struct ocfs2_super *osb,
 done:
 	/* drop the lock on this nodes journal */
 	if (got_lock)
-		ocfs2_meta_unlock(inode, 1);
+		ocfs2_inode_unlock(inode, 1);
 
 	if (inode)
 		iput(inode);
@@ -1161,14 +1161,14 @@ static int ocfs2_trylock_journal(struct ocfs2_super *osb,
 	SET_INODE_JOURNAL(inode);
 
 	flags = OCFS2_META_LOCK_RECOVERY | OCFS2_META_LOCK_NOQUEUE;
-	status = ocfs2_meta_lock_full(inode, NULL, 1, flags);
+	status = ocfs2_inode_lock_full(inode, NULL, 1, flags);
 	if (status < 0) {
 		if (status != -EAGAIN)
 			mlog_errno(status);
 		goto bail;
 	}
 
-	ocfs2_meta_unlock(inode, 1);
+	ocfs2_inode_unlock(inode, 1);
 bail:
 	if (inode)
 		iput(inode);
@@ -1276,7 +1276,7 @@ static int ocfs2_queue_orphans(struct ocfs2_super *osb,
 	}	
 
 	mutex_lock(&orphan_dir_inode->i_mutex);
-	status = ocfs2_meta_lock(orphan_dir_inode, NULL, 0);
+	status = ocfs2_inode_lock(orphan_dir_inode, NULL, 0);
 	if (status < 0) {
 		mlog_errno(status);
 		goto out;
@@ -1292,7 +1292,7 @@ static int ocfs2_queue_orphans(struct ocfs2_super *osb,
 	*head = priv.head;
 
 out_cluster:
-	ocfs2_meta_unlock(orphan_dir_inode, 0);
+	ocfs2_inode_unlock(orphan_dir_inode, 0);
 out:
 	mutex_unlock(&orphan_dir_inode->i_mutex);
 	iput(orphan_dir_inode);
diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
index 58ea88b..0de0792 100644
--- a/fs/ocfs2/localalloc.c
+++ b/fs/ocfs2/localalloc.c
@@ -231,7 +231,7 @@ void ocfs2_shutdown_local_alloc(struct ocfs2_super *osb)
 
 	mutex_lock(&main_bm_inode->i_mutex);
 
-	status = ocfs2_meta_lock(main_bm_inode, &main_bm_bh, 1);
+	status = ocfs2_inode_lock(main_bm_inode, &main_bm_bh, 1);
 	if (status < 0) {
 		mlog_errno(status);
 		goto out_mutex;
@@ -286,7 +286,7 @@ out_unlock:
 	if (main_bm_bh)
 		brelse(main_bm_bh);
 
-	ocfs2_meta_unlock(main_bm_inode, 1);
+	ocfs2_inode_unlock(main_bm_inode, 1);
 
 out_mutex:
 	mutex_unlock(&main_bm_inode->i_mutex);
@@ -399,7 +399,7 @@ int ocfs2_complete_local_alloc_recovery(struct ocfs2_super *osb,
 
 	mutex_lock(&main_bm_inode->i_mutex);
 
-	status = ocfs2_meta_lock(main_bm_inode, &main_bm_bh, 1);
+	status = ocfs2_inode_lock(main_bm_inode, &main_bm_bh, 1);
 	if (status < 0) {
 		mlog_errno(status);
 		goto out_mutex;
@@ -424,7 +424,7 @@ int ocfs2_complete_local_alloc_recovery(struct ocfs2_super *osb,
 	ocfs2_commit_trans(osb, handle);
 
 out_unlock:
-	ocfs2_meta_unlock(main_bm_inode, 1);
+	ocfs2_inode_unlock(main_bm_inode, 1);
 
 out_mutex:
 	mutex_unlock(&main_bm_inode->i_mutex);
diff --git a/fs/ocfs2/mmap.c b/fs/ocfs2/mmap.c
index a7f0ccc..3dc18d6 100644
--- a/fs/ocfs2/mmap.c
+++ b/fs/ocfs2/mmap.c
@@ -168,7 +168,7 @@ static int ocfs2_page_mkwrite(struct vm_area_struct *vma, struct page *page)
 	 * node. Taking the data lock will also ensure that we don't
 	 * attempt page truncation as part of a downconvert.
 	 */
-	ret = ocfs2_meta_lock(inode, &di_bh, 1);
+	ret = ocfs2_inode_lock(inode, &di_bh, 1);
 	if (ret < 0) {
 		mlog_errno(ret);
 		goto out;
@@ -186,7 +186,7 @@ static int ocfs2_page_mkwrite(struct vm_area_struct *vma, struct page *page)
 	up_write(&OCFS2_I(inode)->ip_alloc_sem);
 
 	brelse(di_bh);
-	ocfs2_meta_unlock(inode, 1);
+	ocfs2_inode_unlock(inode, 1);
 
 out:
 	ret2 = ocfs2_vm_op_unblock_sigs(&oldset);
@@ -205,13 +205,13 @@ int ocfs2_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	int ret = 0, lock_level = 0;
 
-	ret = ocfs2_meta_lock_atime(file->f_dentry->d_inode,
+	ret = ocfs2_inode_lock_atime(file->f_dentry->d_inode,
 				    file->f_vfsmnt, &lock_level);
 	if (ret < 0) {
 		mlog_errno(ret);
 		goto out;
 	}
-	ocfs2_meta_unlock(file->f_dentry->d_inode, lock_level);
+	ocfs2_inode_unlock(file->f_dentry->d_inode, lock_level);
 out:
 	vma->vm_ops = &ocfs2_file_vm_ops;
 	vma->vm_flags |= VM_CAN_NONLINEAR;
diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 6295fd6..74018ca 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -115,7 +115,7 @@ static struct dentry *ocfs2_lookup(struct inode *dir, struct dentry *dentry,
 	mlog(0, "find name %.*s in directory %llu\n", dentry->d_name.len,
 	     dentry->d_name.name, (unsigned long long)OCFS2_I(dir)->ip_blkno);
 
-	status = ocfs2_meta_lock(dir, NULL, 0);
+	status = ocfs2_inode_lock(dir, NULL, 0);
 	if (status < 0) {
 		if (status != -ENOENT)
 			mlog_errno(status);
@@ -176,7 +176,7 @@ bail_unlock:
 	 * unlink on another node will message us to remove that
 	 * dentry under this lock so otherwise we can race this with
 	 * the downconvert thread and have a stale dentry. */
-	ocfs2_meta_unlock(dir, 0);
+	ocfs2_inode_unlock(dir, 0);
 
 bail:
 
@@ -208,7 +208,7 @@ static int ocfs2_mknod(struct inode *dir,
 	/* get our super block */
 	osb = OCFS2_SB(dir->i_sb);
 
-	status = ocfs2_meta_lock(dir, &parent_fe_bh, 1);
+	status = ocfs2_inode_lock(dir, &parent_fe_bh, 1);
 	if (status < 0) {
 		if (status != -ENOENT)
 			mlog_errno(status);
@@ -322,7 +322,7 @@ leave:
 	if (handle)
 		ocfs2_commit_trans(osb, handle);
 
-	ocfs2_meta_unlock(dir, 1);
+	ocfs2_inode_unlock(dir, 1);
 
 	if (status == -ENOSPC)
 		mlog(0, "Disk is full\n");
@@ -552,7 +552,7 @@ static int ocfs2_link(struct dentry *old_dentry,
 	if (S_ISDIR(inode->i_mode))
 		return -EPERM;
 
-	err = ocfs2_meta_lock(dir, &parent_fe_bh, 1);
+	err = ocfs2_inode_lock(dir, &parent_fe_bh, 1);
 	if (err < 0) {
 		if (err != -ENOENT)
 			mlog_errno(err);
@@ -577,7 +577,7 @@ static int ocfs2_link(struct dentry *old_dentry,
 		goto out;
 	}
 
-	err = ocfs2_meta_lock(inode, &fe_bh, 1);
+	err = ocfs2_inode_lock(inode, &fe_bh, 1);
 	if (err < 0) {
 		if (err != -ENOENT)
 			mlog_errno(err);
@@ -642,10 +642,10 @@ static int ocfs2_link(struct dentry *old_dentry,
 out_commit:
 	ocfs2_commit_trans(osb, handle);
 out_unlock_inode:
-	ocfs2_meta_unlock(inode, 1);
+	ocfs2_inode_unlock(inode, 1);
 
 out:
-	ocfs2_meta_unlock(dir, 1);
+	ocfs2_inode_unlock(dir, 1);
 
 	if (de_bh)
 		brelse(de_bh);
@@ -719,7 +719,7 @@ static int ocfs2_unlink(struct inode *dir,
 		return -EPERM;
 	}
 
-	status = ocfs2_meta_lock(dir, &parent_node_bh, 1);
+	status = ocfs2_inode_lock(dir, &parent_node_bh, 1);
 	if (status < 0) {
 		if (status != -ENOENT)
 			mlog_errno(status);
@@ -744,7 +744,7 @@ static int ocfs2_unlink(struct inode *dir,
 		goto leave;
 	}
 
-	status = ocfs2_meta_lock(inode, &fe_bh, 1);
+	status = ocfs2_inode_lock(inode, &fe_bh, 1);
 	if (status < 0) {
 		if (status != -ENOENT)
 			mlog_errno(status);
@@ -840,13 +840,13 @@ leave:
 		ocfs2_commit_trans(osb, handle);
 
 	if (child_locked)
-		ocfs2_meta_unlock(inode, 1);
+		ocfs2_inode_unlock(inode, 1);
 
-	ocfs2_meta_unlock(dir, 1);
+	ocfs2_inode_unlock(dir, 1);
 
 	if (orphan_dir) {
 		/* This was locked for us in ocfs2_prepare_orphan_dir() */
-		ocfs2_meta_unlock(orphan_dir, 1);
+		ocfs2_inode_unlock(orphan_dir, 1);
 		mutex_unlock(&orphan_dir->i_mutex);
 		iput(orphan_dir);
 	}
@@ -907,7 +907,7 @@ static int ocfs2_double_lock(struct ocfs2_super *osb,
 			inode1 = tmpinode;
 		}
 		/* lock id2 */
-		status = ocfs2_meta_lock(inode2, bh2, 1);
+		status = ocfs2_inode_lock(inode2, bh2, 1);
 		if (status < 0) {
 			if (status != -ENOENT)
 				mlog_errno(status);
@@ -916,14 +916,14 @@ static int ocfs2_double_lock(struct ocfs2_super *osb,
 	}
 
 	/* lock id1 */
-	status = ocfs2_meta_lock(inode1, bh1, 1);
+	status = ocfs2_inode_lock(inode1, bh1, 1);
 	if (status < 0) {
 		/*
 		 * An error return must mean that no cluster locks
 		 * were held on function exit.
 		 */
 		if (oi1->ip_blkno != oi2->ip_blkno)
-			ocfs2_meta_unlock(inode2, 1);
+			ocfs2_inode_unlock(inode2, 1);
 
 		if (status != -ENOENT)
 			mlog_errno(status);
@@ -936,10 +936,10 @@ bail:
 
 static void ocfs2_double_unlock(struct inode *inode1, struct inode *inode2)
 {
-	ocfs2_meta_unlock(inode1, 1);
+	ocfs2_inode_unlock(inode1, 1);
 
 	if (inode1 != inode2)
-		ocfs2_meta_unlock(inode2, 1);
+		ocfs2_inode_unlock(inode2, 1);
 }
 
 static int ocfs2_rename(struct inode *old_dir,
@@ -1034,7 +1034,7 @@ static int ocfs2_rename(struct inode *old_dir,
 	 * won't have to concurrently downconvert the inode and the
 	 * dentry locks.
 	 */
-	status = ocfs2_meta_lock(old_inode, &old_inode_bh, 1);
+	status = ocfs2_inode_lock(old_inode, &old_inode_bh, 1);
 	if (status < 0) {
 		if (status != -ENOENT)
 			mlog_errno(status);
@@ -1143,7 +1143,7 @@ static int ocfs2_rename(struct inode *old_dir,
 			goto bail;
 		}
 
-		status = ocfs2_meta_lock(new_inode, &newfe_bh, 1);
+		status = ocfs2_inode_lock(new_inode, &newfe_bh, 1);
 		if (status < 0) {
 			if (status != -ENOENT)
 				mlog_errno(status);
@@ -1355,14 +1355,14 @@ bail:
 		ocfs2_double_unlock(old_dir, new_dir);
 
 	if (old_child_locked)
-		ocfs2_meta_unlock(old_inode, 1);
+		ocfs2_inode_unlock(old_inode, 1);
 
 	if (new_child_locked)
-		ocfs2_meta_unlock(new_inode, 1);
+		ocfs2_inode_unlock(new_inode, 1);
 
 	if (orphan_dir) {
 		/* This was locked for us in ocfs2_prepare_orphan_dir() */
-		ocfs2_meta_unlock(orphan_dir, 1);
+		ocfs2_inode_unlock(orphan_dir, 1);
 		mutex_unlock(&orphan_dir->i_mutex);
 		iput(orphan_dir);
 	}
@@ -1530,7 +1530,7 @@ static int ocfs2_symlink(struct inode *dir,
 	credits = ocfs2_calc_symlink_credits(sb);
 
 	/* lock the parent directory */
-	status = ocfs2_meta_lock(dir, &parent_fe_bh, 1);
+	status = ocfs2_inode_lock(dir, &parent_fe_bh, 1);
 	if (status < 0) {
 		if (status != -ENOENT)
 			mlog_errno(status);
@@ -1657,7 +1657,7 @@ bail:
 	if (handle)
 		ocfs2_commit_trans(osb, handle);
 
-	ocfs2_meta_unlock(dir, 1);
+	ocfs2_inode_unlock(dir, 1);
 
 	if (new_fe_bh)
 		brelse(new_fe_bh);
@@ -1735,7 +1735,7 @@ static int ocfs2_prepare_orphan_dir(struct ocfs2_super *osb,
 
 	mutex_lock(&orphan_dir_inode->i_mutex);
 
-	status = ocfs2_meta_lock(orphan_dir_inode, &orphan_dir_bh, 1);
+	status = ocfs2_inode_lock(orphan_dir_inode, &orphan_dir_bh, 1);
 	if (status < 0) {
 		mlog_errno(status);
 		goto leave;
@@ -1745,7 +1745,7 @@ static int ocfs2_prepare_orphan_dir(struct ocfs2_super *osb,
 					      orphan_dir_bh, name,
 					      OCFS2_ORPHAN_NAMELEN, de_bh);
 	if (status < 0) {
-		ocfs2_meta_unlock(orphan_dir_inode, 1);
+		ocfs2_inode_unlock(orphan_dir_inode, 1);
 
 		mlog_errno(status);
 		goto leave;
diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index 8f09f52..6df4dbf 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -114,7 +114,7 @@ void ocfs2_free_alloc_context(struct ocfs2_alloc_context *ac)
 
 	if (inode) {
 		if (ac->ac_which != OCFS2_AC_USE_LOCAL)
-			ocfs2_meta_unlock(inode, 1);
+			ocfs2_inode_unlock(inode, 1);
 
 		mutex_unlock(&inode->i_mutex);
 
@@ -412,7 +412,7 @@ static int ocfs2_reserve_suballoc_bits(struct ocfs2_super *osb,
 
 	mutex_lock(&alloc_inode->i_mutex);
 
-	status = ocfs2_meta_lock(alloc_inode, &bh, 1);
+	status = ocfs2_inode_lock(alloc_inode, &bh, 1);
 	if (status < 0) {
 		mutex_unlock(&alloc_inode->i_mutex);
 		iput(alloc_inode);
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 064eba0..7708df3 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -964,7 +964,7 @@ static int ocfs2_statfs(struct dentry *dentry, struct kstatfs *buf)
 		goto bail;
 	}
 
-	status = ocfs2_meta_lock(inode, &bh, 0);
+	status = ocfs2_inode_lock(inode, &bh, 0);
 	if (status < 0) {
 		mlog_errno(status);
 		goto bail;
@@ -988,7 +988,7 @@ static int ocfs2_statfs(struct dentry *dentry, struct kstatfs *buf)
 
 	brelse(bh);
 
-	ocfs2_meta_unlock(inode, 0);
+	ocfs2_inode_unlock(inode, 0);
 	status = 0;
 bail:
 	if (inode)
@@ -1019,7 +1019,7 @@ static void ocfs2_inode_init_once(struct kmem_cache *cachep, void *data)
 	oi->ip_clusters = 0;
 
 	ocfs2_lock_res_init_once(&oi->ip_rw_lockres);
-	ocfs2_lock_res_init_once(&oi->ip_meta_lockres);
+	ocfs2_lock_res_init_once(&oi->ip_inode_lockres);
 	ocfs2_lock_res_init_once(&oi->ip_open_lockres);
 
 	ocfs2_metadata_cache_init(&oi->vfs_inode);
-- 
1.5.3.6
