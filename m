From: Rusty Lynch <rusty@linux.co.intel.com>
Date: Thu Feb 19 22:13:21 2004
Subject: [Ocfs2-devel] [PATCH]2.6 fixes in file.c
Message-ID: <200402200413.i1K4DFoW004249@penguin.co.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The following is a patch to file.c and proto.h that fixes some
errors that happen when building with a 2.6 kernel.

* proper use of timespec time in various places
* adds a new ocfs_sync_inode() function that for syncing inodes
  in a 2.4 and 2.6 friendly way
* removes more kdev references from the 2.6 code sections

    --rusty

Index: src/file.c
===================================================================
--- src/file.c	(revision 32)
+++ src/file.c	(working copy)
@@ -30,6 +30,7 @@
 static int ocfs_change_file_attrib (ocfs_super * osb, __u64 parent_off, ocfs_inode * oin, __u64 file_size, __u64 file_off, struct iattr *attr, struct inode *inode);
 static int ocfs_truncate_file (ocfs_super * osb, __u64 file_off, __u64 file_size, ocfs_inode * oin, struct inode *inode);
 
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
 #define OCFS_FE_SET_ATTRIBUTES(fe, attr) 				     \
 do {									     \
 	if (attr->ia_valid & ATTR_SIZE)					     \
@@ -41,11 +42,43 @@
 	if (attr->ia_valid & ATTR_MODE)					     \
 		fe->prot_bits = attr->ia_mode & 0007777;		     \
 	if (attr->ia_valid & ATTR_CTIME)				     \
-		fe->create_time = attr->ia_ctime;			     \
+		fe->create_time = attr->ia_ctime.tv_sec;		     \
 	if (attr->ia_valid & ATTR_MTIME)				     \
-		fe->modify_time = attr->ia_mtime;			     \
+		fe->modify_time = attr->ia_mtime.tv_sec;		     \
 } while (0)
+#else /* 2.4.x kernel */
+#define OCFS_FE_SET_ATTRIBUTES(fe, attr) 				     \
+do {									     \
+	if (attr->ia_valid & ATTR_SIZE)					     \
+		fe->file_size = attr->ia_size;				     \
+	if (attr->ia_valid & ATTR_UID)					     \
+		fe->uid = attr->ia_uid;					     \
+	if (attr->ia_valid & ATTR_GID)					     \
+		fe->gid = attr->ia_gid;					     \
+	if (attr->ia_valid & ATTR_MODE)					     \
+		fe->prot_bits = attr->ia_mode & 0007777;		     \
+	if (attr->ia_valid & ATTR_CTIME)				     \
+		fe->create_time = attr->ia_ctime;		             \
+	if (attr->ia_valid & ATTR_MTIME)				     \
+		fe->modify_time = attr->ia_mtime;		             \
+} while (0)
+#endif
 
+static int ocfs_sync_inode(struct inode *inode)
+{
+	int status;
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
+	status = sync_mapping_buffers(inode->i_mapping);
+#else
+	status = fsync_inode_buffers(inode);
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,18)
+	if (!status)	       
+		status = fsync_inode_data_buffers(inode);
+#endif
+#endif
+	return status;
+}
+
 /*
  * ocfs_file_open()
  *
@@ -246,10 +279,10 @@
 	}
 
 	if (truncate_pages) {
-		fsync_inode_buffers(inode);
-#if LINUX_VERSION_CODE >= LinuxVersionCode(2,4,18)
-		fsync_inode_data_buffers(inode);
-#endif
+		status = ocfs_sync_inode(inode);
+		if (status)
+			goto leave;
+
 		if (inode->i_data.nrpages)
 			ocfs_truncate_inode_pages(inode, 0);
 	}
@@ -395,19 +428,14 @@
 		
                 ocfs_up_sem (&(oin->main_res));
                 ocfs_release_oin (oin, true);
-		fsync_inode_buffers(inode);
-#if LINUX_VERSION_CODE >= LinuxVersionCode(2,4,18)
-		fsync_inode_data_buffers(inode);
-#endif
+
+		ocfs_sync_inode(inode);
 		if (inode->i_data.nrpages)
 			ocfs_truncate_inode_pages(inode, 0);
         } else {
                 ocfs_up_sem (&(oin->main_res));
                 ocfs_release_cached_oin (osb, oin);
-		fsync_inode_buffers(inode);
-#if LINUX_VERSION_CODE >= LinuxVersionCode(2,4,18)
-		fsync_inode_data_buffers(inode);
-#endif
+		ocfs_sync_inode(inode);
 		if (inode->i_data.nrpages)
 			ocfs_truncate_inode_pages(inode, 0);
 
@@ -437,15 +465,10 @@
 
 	LOG_ENTRY_ARGS ("(0x%08x, '%*s')\n", file,
                         file->f_dentry->d_name.len, file->f_dentry->d_name.name);
-
-#if LINUX_VERSION_CODE >= LinuxVersionCode(2,4,18)
-	fsync_inode_data_buffers(file->f_dentry->d_inode);
-#endif
-	err = fsync_inode_buffers(file->f_dentry->d_inode);
+	err = ocfs_sync_inode(file->f_dentry->d_inode);
 	LOG_EXIT_STATUS (err);
 	return (err < 0) ? -EIO : 0;
 }				/* ocfs_flush */
-
 /*
  * ocfs_sync_file()
  *
@@ -455,10 +478,13 @@
 	int err = 0;
 	LOG_ENTRY_ARGS ("(0x%08x, 0x%08x, %d, '%*s')\n", file, dentry, datasync,
                         dentry->d_name.len, dentry->d_name.name);
-#if LINUX_VERSION_CODE >= LinuxVersionCode(2,4,18)
-	fsync_inode_data_buffers(file->f_dentry->d_inode);
-#endif
-	err = fsync_inode_buffers(dentry->d_inode);
+
+	err = ocfs_sync_inode(dentry->d_inode);
+
+	/*
+	 * Shouldn't we be commiting journal entries here?
+	 */
+
 	LOG_EXIT_STATUS (err);
 	return (err < 0) ? -EIO : 0;
 }				/* ocfs_sync_file */
@@ -547,7 +573,7 @@
 		DISK_LOCK_CURRENT_MASTER (fileEntry) = osb->node_num;
 	}
 
-	fileEntry->modify_time = CURRENT_TIME;
+	fileEntry->modify_time = OCFS_CURRENT_TIME;
 
 	DISK_LOCK_SEQNUM (fileEntry) = changeSeqNum;
 	OCFS_FE_SET_ATTRIBUTES(fileEntry, attr);
@@ -1452,7 +1478,7 @@
 	return error;
 }				/* ocfs_setattr */
 
-#ifdef LINUX_2_5
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
 /*
  * ocfs_getattr() (Linux 2.5 version)
  *
@@ -1481,7 +1507,11 @@
 	stat->nlink = inode->i_nlink;
 	stat->uid = inode->i_uid;
 	stat->gid = inode->i_gid;
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
+	stat->rdev = inode->i_rdev;
+#else
 	stat->rdev = kdev_t_to_nr(inode->i_rdev);
+#endif
 	stat->atime = inode->i_atime;
 	stat->mtime = inode->i_mtime;
 	stat->ctime = inode->i_ctime;
Index: src/inc/proto.h
===================================================================
--- src/inc/proto.h	(revision 32)
+++ src/inc/proto.h	(working copy)
@@ -78,9 +78,12 @@
 ssize_t ocfs_file_read (struct file *filp, char *buf, size_t count, loff_t * ppos);
 int ocfs_extend_file (ocfs_super * osb, __u64 parent_off, ocfs_inode * oin, __u64 file_size, __u64 * file_off, ocfs_journal_handle *passed_handle, struct inode *inode, struct iattr *attr);
 int ocfs_setattr (struct dentry *dentry, struct iattr *attr);
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
+int ocfs_getattr (struct vfsmount *mnt, struct dentry *dentry, struct kstat *stat);
+#else
 int ocfs_getattr (struct dentry *dentry, struct iattr *attr);
+#endif
 
-
 int ocfs_find_inode (struct inode *inode, unsigned long ino, void *opaque);
 void ocfs_populate_inode (struct inode *inode, ocfs_file_entry *fe, umode_t mode, void *genptr, bool create_ino);
 void ocfs_read_locked_inode (struct inode *inode, ocfs_file_entry *entry);
@@ -242,7 +245,11 @@
 
 
 int ocfs_empty (struct dentry *dentry);
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
+int ocfs_dentry_revalidate (struct dentry *dentry, struct nameidata *nd);
+#else
 int ocfs_dentry_revalidate (struct dentry *dentry, int flags);
+#endif
 int ocfs_foreach_child (struct dentry *dentry, int (*func)(struct dentry *, void *), void *data);
 
 int ocfs_readdir (struct file *filp, void *dirent, filldir_t filldir);
