From: Tiger Yang <tiger.yang@oracle.com>
Date: Wed, 12 Jan 2011 15:13:10 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: add fixed metadata file support -v1
Message-ID: <1294816390-17460-1-git-send-email-tiger.yang@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The fixed metadata file created by ocfs2-tools and it can only be read/write by O_DIRECT.
We can't change the metadata of the it, so we can't link, unlink, rename it, and we can't
set attr and xattr on it. The benefit is we don't need cluster lock when we read/write it.

Signed-off-by: Tiger Yang <tiger.yang@oracle.com>
---
 fs/ocfs2/acl.c      |    3 ++
 fs/ocfs2/aops.c     |    4 ++-
 fs/ocfs2/file.c     |   81 +++++++++++++++++++++++++++++++++++++--------------
 fs/ocfs2/mmap.c     |    9 ++++--
 fs/ocfs2/namei.c    |    9 ++++++
 fs/ocfs2/ocfs2_fs.h |    1 +
 fs/ocfs2/xattr.c    |    9 ++++++
 7 files changed, 90 insertions(+), 26 deletions(-)

diff --git a/fs/ocfs2/acl.c b/fs/ocfs2/acl.c
index 704f6b1..c277777 100644
--- a/fs/ocfs2/acl.c
+++ b/fs/ocfs2/acl.c
@@ -492,6 +492,9 @@ static int ocfs2_xattr_set_acl(struct dentry *dentry, const char *name,
 	struct posix_acl *acl;
 	int ret = 0;
 
+	if (OCFS2_I(dentry->d_inode)->ip_attr & OCFS2_FIXEDMETA_FL)
+		return -EPERM;
+
 	if (strcmp(name, "") != 0)
 		return -EINVAL;
 	if (!(osb->s_mount_opt & OCFS2_MOUNT_POSIX_ACL))
diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 0d7c554..7e3371c 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -581,7 +581,9 @@ static void ocfs2_dio_end_io(struct kiocb *iocb,
 	ocfs2_iocb_clear_rw_locked(iocb);
 
 	level = ocfs2_iocb_rw_locked_level(iocb);
-	ocfs2_rw_unlock(inode, level);
+
+	if (!(OCFS2_I(inode)->ip_attr & OCFS2_FIXEDMETA_FL))
+		ocfs2_rw_unlock(inode, level);
 
 	if (is_async)
 		aio_complete(iocb, ret, 0);
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index bdadbae..3b6bf55 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -102,6 +102,10 @@ static int ocfs2_file_open(struct inode *inode, struct file *file)
 	mlog_entry("(0x%p, 0x%p, '%.*s')\n", inode, file,
 		   file->f_path.dentry->d_name.len, file->f_path.dentry->d_name.name);
 
+	if ((oi->ip_attr & OCFS2_FIXEDMETA_FL) &&
+	    ((mode & O_APPEND) || (mode & O_TRUNC)))
+		return -EPERM;
+
 	if (file->f_mode & FMODE_WRITE)
 		dquot_initialize(inode);
 
@@ -210,6 +214,7 @@ int ocfs2_should_update_atime(struct inode *inode,
 		return 0;
 
 	if ((inode->i_flags & S_NOATIME) ||
+	    (inode->i_flags & OCFS2_FIXEDMETA_FL) ||
 	    ((inode->i_sb->s_flags & MS_NODIRATIME) && S_ISDIR(inode->i_mode)))
 		return 0;
 
@@ -1138,6 +1143,9 @@ int ocfs2_setattr(struct dentry *dentry, struct iattr *attr)
 		return 0;
 	}
 
+	if (OCFS2_I(inode)->ip_attr & OCFS2_FIXEDMETA_FL)
+		return -EPERM;
+
 	status = inode_change_ok(inode, attr);
 	if (status)
 		return status;
@@ -2242,6 +2250,10 @@ static ssize_t ocfs2_file_aio_write(struct kiocb *iocb,
 	appending = file->f_flags & O_APPEND ? 1 : 0;
 	direct_io = file->f_flags & O_DIRECT ? 1 : 0;
 
+	/* Fixed metadata file can only be write with O_DIRECT */
+	if (OCFS2_I(inode)->ip_attr & OCFS2_FIXEDMETA_FL && !direct_io)
+		return -EPERM;
+
 	mutex_lock(&inode->i_mutex);
 
 	ocfs2_iocb_clear_sem_locked(iocb);
@@ -2261,10 +2273,13 @@ relock:
 	 */
 	rw_level = (!direct_io || full_coherency);
 
-	ret = ocfs2_rw_lock(inode, rw_level);
-	if (ret < 0) {
-		mlog_errno(ret);
-		goto out_sems;
+	if (!(OCFS2_I(inode)->ip_attr & OCFS2_FIXEDMETA_FL)) {
+		/* Fixed metadata file do not need cluster lock */
+		ret = ocfs2_rw_lock(inode, rw_level);
+		if (ret < 0) {
+			mlog_errno(ret);
+			goto out_sems;
+		}
 	}
 
 	/*
@@ -2277,13 +2292,16 @@ relock:
 		 * other nodes to drop their caches.  Buffered I/O
 		 * already does this in write_begin().
 		 */
-		ret = ocfs2_inode_lock(inode, NULL, 1);
-		if (ret < 0) {
-			mlog_errno(ret);
-			goto out_sems;
-		}
+		if (!(OCFS2_I(inode)->ip_attr & OCFS2_FIXEDMETA_FL)) {
+			/* Fixed metadata file do not need cluster lock */
+			ret = ocfs2_inode_lock(inode, NULL, 1);
+			if (ret < 0) {
+				mlog_errno(ret);
+				goto out_sems;
+			}
 
-		ocfs2_inode_unlock(inode, 1);
+			ocfs2_inode_unlock(inode, 1);
+		}
 	}
 
 	can_do_direct = direct_io;
@@ -2300,7 +2318,8 @@ relock:
 	 * buffered I/O.
 	 */
 	if (direct_io && !can_do_direct) {
-		ocfs2_rw_unlock(inode, rw_level);
+		if (!(OCFS2_I(inode)->ip_attr & OCFS2_FIXEDMETA_FL))
+			ocfs2_rw_unlock(inode, rw_level);
 		up_read(&inode->i_alloc_sem);
 
 		have_alloc_sem = 0;
@@ -2385,7 +2404,7 @@ out_dio:
 	}
 
 out:
-	if (rw_level != -1)
+	if (rw_level != -1 && !(OCFS2_I(inode)->ip_attr & OCFS2_FIXEDMETA_FL))
 		ocfs2_rw_unlock(inode, rw_level);
 
 out_sems:
@@ -2439,6 +2458,9 @@ static ssize_t ocfs2_file_splice_write(struct pipe_inode_info *pipe,
 		   out->f_path.dentry->d_name.len,
 		   out->f_path.dentry->d_name.name);
 
+	if (OCFS2_I(inode)->ip_attr & OCFS2_FIXEDMETA_FL)
+		return -EPERM;
+
 	if (pipe->inode)
 		mutex_lock_nested(&pipe->inode->i_mutex, I_MUTEX_PARENT);
 
@@ -2499,6 +2521,9 @@ static ssize_t ocfs2_file_splice_read(struct file *in,
 		   in->f_path.dentry->d_name.len,
 		   in->f_path.dentry->d_name.name);
 
+	if (OCFS2_I(inode)->ip_attr & OCFS2_FIXEDMETA_FL)
+		return -EPERM;
+
 	/*
 	 * See the comment in ocfs2_file_aio_read()
 	 */
@@ -2547,14 +2572,23 @@ static ssize_t ocfs2_file_aio_read(struct kiocb *iocb,
 		have_alloc_sem = 1;
 		ocfs2_iocb_set_sem_locked(iocb);
 
-		ret = ocfs2_rw_lock(inode, 0);
-		if (ret < 0) {
-			mlog_errno(ret);
-			goto bail;
+		/* Fixed metadata file do not need cluster lock */
+		if (!(OCFS2_I(inode)->ip_attr & OCFS2_FIXEDMETA_FL)) {
+			ret = ocfs2_rw_lock(inode, 0);
+			if (ret < 0) {
+				mlog_errno(ret);
+				goto bail;
+			}
 		}
 		rw_level = 0;
 		/* communicate with ocfs2_dio_end_io */
 		ocfs2_iocb_set_rw_locked(iocb, rw_level);
+	} else {
+		/* Fixed metadata file can only be read with O_DIRECT */
+		if (OCFS2_I(inode)->ip_attr & OCFS2_FIXEDMETA_FL) {
+			ret = -EPERM;
+			goto bail;
+		}
 	}
 
 	/*
@@ -2566,12 +2600,15 @@ static ssize_t ocfs2_file_aio_read(struct kiocb *iocb,
 	 * like i_size. This allows the checks down below
 	 * generic_file_aio_read() a chance of actually working.
 	 */
-	ret = ocfs2_inode_lock_atime(inode, filp->f_vfsmnt, &lock_level);
-	if (ret < 0) {
-		mlog_errno(ret);
-		goto bail;
+	if (!(OCFS2_I(inode)->ip_attr & OCFS2_FIXEDMETA_FL)) {
+		ret = ocfs2_inode_lock_atime(inode, filp->f_vfsmnt,
+					     &lock_level);
+		if (ret < 0) {
+			mlog_errno(ret);
+			goto bail;
+		}
+		ocfs2_inode_unlock(inode, lock_level);
 	}
-	ocfs2_inode_unlock(inode, lock_level);
 
 	ret = generic_file_aio_read(iocb, iov, nr_segs, iocb->ki_pos);
 	if (ret == -EINVAL)
@@ -2591,7 +2628,7 @@ bail:
 		up_read(&inode->i_alloc_sem);
 		ocfs2_iocb_clear_sem_locked(iocb);
 	}
-	if (rw_level != -1)
+	if (rw_level != -1 && !(OCFS2_I(inode)->ip_attr & OCFS2_FIXEDMETA_FL))
 		ocfs2_rw_unlock(inode, rw_level);
 	mlog_exit(ret);
 
diff --git a/fs/ocfs2/mmap.c b/fs/ocfs2/mmap.c
index 7e32db9..76be93c 100644
--- a/fs/ocfs2/mmap.c
+++ b/fs/ocfs2/mmap.c
@@ -182,14 +182,17 @@ static const struct vm_operations_struct ocfs2_file_vm_ops = {
 int ocfs2_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	int ret = 0, lock_level = 0;
+	struct inode *inode = file->f_dentry->d_inode;
 
-	ret = ocfs2_inode_lock_atime(file->f_dentry->d_inode,
-				    file->f_vfsmnt, &lock_level);
+	if (OCFS2_I(inode)->ip_attr & OCFS2_FIXEDMETA_FL)
+		return -EPERM;
+
+	ret = ocfs2_inode_lock_atime(inode, file->f_vfsmnt, &lock_level);
 	if (ret < 0) {
 		mlog_errno(ret);
 		goto out;
 	}
-	ocfs2_inode_unlock(file->f_dentry->d_inode, lock_level);
+	ocfs2_inode_unlock(inode, lock_level);
 out:
 	vma->vm_ops = &ocfs2_file_vm_ops;
 	vma->vm_flags |= VM_CAN_NONLINEAR;
diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index d14cad6..0b79bd2 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -658,6 +658,9 @@ static int ocfs2_link(struct dentry *old_dentry,
 		   old_dentry->d_name.len, old_dentry->d_name.name,
 		   dentry->d_name.len, dentry->d_name.name);
 
+	if (OCFS2_I(inode)->ip_attr & OCFS2_FIXEDMETA_FL)
+		return -EPERM;
+
 	if (S_ISDIR(inode->i_mode))
 		return -EPERM;
 
@@ -815,6 +818,9 @@ static int ocfs2_unlink(struct inode *dir,
 	mlog_entry("(0x%p, 0x%p, '%.*s')\n", dir, dentry,
 		   dentry->d_name.len, dentry->d_name.name);
 
+	if (OCFS2_I(inode)->ip_attr & OCFS2_FIXEDMETA_FL)
+		return -EPERM;
+
 	dquot_initialize(dir);
 
 	BUG_ON(dentry->d_parent->d_inode != dir);
@@ -1072,6 +1078,9 @@ static int ocfs2_rename(struct inode *old_dir,
 		   old_dentry->d_name.len, old_dentry->d_name.name,
 		   new_dentry->d_name.len, new_dentry->d_name.name);
 
+	if (OCFS2_I(old_inode)->ip_attr & OCFS2_FIXEDMETA_FL)
+		return -EPERM;
+
 	dquot_initialize(old_dir);
 	dquot_initialize(new_dir);
 
diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
index bf2e776..50ccc34 100644
--- a/fs/ocfs2/ocfs2_fs.h
+++ b/fs/ocfs2/ocfs2_fs.h
@@ -264,6 +264,7 @@
 #define OCFS2_NOTAIL_FL			FS_NOTAIL_FL	/* file tail should not be merged */
 #define OCFS2_DIRSYNC_FL		FS_DIRSYNC_FL	/* dirsync behaviour (directories only) */
 #define OCFS2_TOPDIR_FL			FS_TOPDIR_FL	/* Top of directory hierarchies*/
+#define OCFS2_FIXEDMETA_FL		(0x00200000)	/* do not update metadata */
 #define OCFS2_RESERVED_FL		FS_RESERVED_FL	/* reserved for ext2 lib */
 
 #define OCFS2_FL_VISIBLE		FS_FL_USER_VISIBLE	/* User visible flags */
diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 67cd439..8e38ab7 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -7255,6 +7255,9 @@ static int ocfs2_xattr_security_set(struct dentry *dentry, const char *name,
 	if (strcmp(name, "") == 0)
 		return -EINVAL;
 
+	if (OCFS2_I(dentry->d_inode)->ip_attr & OCFS2_FIXEDMETA_FL)
+		return -EPERM;
+
 	return ocfs2_xattr_set(dentry->d_inode, OCFS2_XATTR_INDEX_SECURITY,
 			       name, value, size, flags);
 }
@@ -7323,6 +7326,9 @@ static int ocfs2_xattr_trusted_set(struct dentry *dentry, const char *name,
 	if (strcmp(name, "") == 0)
 		return -EINVAL;
 
+	if (OCFS2_I(dentry->d_inode)->ip_attr & OCFS2_FIXEDMETA_FL)
+		return -EPERM;
+
 	return ocfs2_xattr_set(dentry->d_inode, OCFS2_XATTR_INDEX_TRUSTED,
 			       name, value, size, flags);
 }
@@ -7379,6 +7385,9 @@ static int ocfs2_xattr_user_set(struct dentry *dentry, const char *name,
 	if (osb->s_mount_opt & OCFS2_MOUNT_NOUSERXATTR)
 		return -EOPNOTSUPP;
 
+	if (OCFS2_I(dentry->d_inode)->ip_attr & OCFS2_FIXEDMETA_FL)
+		return -EPERM;
+
 	return ocfs2_xattr_set(dentry->d_inode, OCFS2_XATTR_INDEX_USER,
 			       name, value, size, flags);
 }
-- 
1.7.2.1
