From: Rusty Lynch <rusty@linux.co.intel.com>
Date: Wed Feb 25 09:43:24 2004
Subject: [Ocfs2-devel] [PATCH]2.6 fixes in inode.c
Message-ID: <200402251541.i1PFff84029171@penguin.co.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The following patch fixes some more 2.6 issues that come out of
porting inode.c

* In 2.6, direct-io is accomplished by just providing a direct_IO
  mechanism in the address_space_operations.  This means there is
  no need to treat direct IO differently in read/write operations.
* There were a couple of more timespec related bumps
* A typo in 2.6 code for handling inode devices
* Several more 2.6 prototype variants that cause compiler
  errors/warnings
* Small changes in the inode structure


diff -urN ocfs2/src/file.c ocfs2_patched/src/file.c
--- ocfs2/src/file.c	2004-02-25 07:23:54.000000000 -0800
+++ ocfs2_patched/src/file.c	2004-02-25 07:25:34.000000000 -0800
@@ -761,11 +761,19 @@
 		}
 	}
 
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
+	/* 
+	 * On a 2.6 kernel, all a filesystem needs to do to support
+	 * direct-io is pass in method for getting blocks via the
+	 * address_space_operations struct
+	 */
+	ret = generic_file_write (filp, buf, count, ppos);
+#else
 	if (filp->f_flags & O_DIRECT)
 		ret = ocfs_rw_direct (WRITE, filp, (char *) buf, count, ppos);
 	else
 		ret = generic_file_write (filp, buf, count, ppos);
-
+#endif
 	if (writingAtEOF) {
 		LOG_TRACE_STR
 		    ("Generic_file_write ok, asking for OIN update now");
@@ -846,11 +854,19 @@
 		}
 	}
 
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
+	/* 
+	 * On a 2.6 kernel, all a filesystem needs to do to support
+	 * direct-io is pass in method for getting blocks via the
+	 * address_space_operations struct
+	 */
+	ret = generic_file_read (filp, buf, count, ppos);
+#else
 	if (filp->f_flags & O_DIRECT)
 		ret = ocfs_rw_direct (READ, filp, buf, count, ppos);
 	else
 		ret = generic_file_read (filp, buf, count, ppos);
-
+#endif
 	if (ret == -EINVAL)
 		LOG_TRACE_STR ("Generic_file_read returned -EINVAL");
 
diff -urN ocfs2/src/inc/ocfs.h ocfs2_patched/src/inc/ocfs.h
--- ocfs2/src/inc/ocfs.h	2004-02-25 07:23:57.000000000 -0800
+++ ocfs2_patched/src/inc/ocfs.h	2004-02-25 07:25:34.000000000 -0800
@@ -206,7 +206,7 @@
 		*t += (__u64)(CURRENT_TIME.tv_nsec) / (__u64) 100;	      \
 	} while (0)
 #define OCFS_CURRENT_TIME   (CURRENT_TIME.tv_sec)
-#define OCFS_SET_INODE_TIME(i, x, y)   i->##x.tv_sec = (y)
+#define OCFS_SET_INODE_TIME(i, x, y)   (i->x.tv_sec = (y))
 #else
 /* time is in 0.1 microsecs */
 #define OcfsQuerySystemTime(t)                                                \
@@ -1134,7 +1134,7 @@
 
 /* Operates on a struct super_block * */
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
-#define OCFS_SET_INODE_DEV(sb, inode)   (inode->i_rdev = sb->sdev)
+#define OCFS_SET_INODE_DEV(sb, inode)   (inode->i_rdev = sb->s_dev)
 typedef struct block_device * ocfs_blockdev;
 typedef dev_t ocfs_dev;
 #define OCFS_NODEV     0
diff -urN ocfs2/src/inc/proto.h ocfs2_patched/src/inc/proto.h
--- ocfs2/src/inc/proto.h	2004-02-25 07:23:57.000000000 -0800
+++ ocfs2_patched/src/inc/proto.h	2004-02-25 07:25:34.000000000 -0800
@@ -244,12 +244,19 @@
 int ocfs_empty (struct dentry *dentry);
 int ocfs_dentry_revalidate (struct dentry *dentry, int flags);
 int ocfs_foreach_child (struct dentry *dentry, int (*func)(struct dentry *, void *), void *data);
-
 int ocfs_readdir (struct file *filp, void *dirent, filldir_t filldir);
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
+struct dentry *ocfs_lookup (struct inode *dir, struct dentry *dentry, struct nameidata *nd);
+#else
 struct dentry *ocfs_lookup (struct inode *dir, struct dentry *dentry);
+#endif
 int ocfs_mknod (struct inode *dir, struct dentry *dentry, int mode, ocfs_dev dev);
 int ocfs_mkdir (struct inode *dir, struct dentry *dentry, int mode);
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
+int ocfs_create (struct inode *dir, struct dentry *dentry, int mode, struct nameidata *nd);
+#else
 int ocfs_create (struct inode *dir, struct dentry *dentry, int mode);
+#endif
 int ocfs_link (struct dentry *old_dentry, struct inode *dir, struct dentry *dentry);
 int ocfs_unlink (struct inode *dir, struct dentry *dentry);
 int ocfs_rename (struct inode *old_dir, struct dentry *old_dentry, struct inode *new_dir, struct dentry *new_dentry);
diff -urN ocfs2/src/inode.c ocfs2_patched/src/inode.c
--- ocfs2/src/inode.c	2004-02-25 07:23:50.000000000 -0800
+++ ocfs2_patched/src/inode.c	2004-02-25 07:25:34.000000000 -0800
@@ -30,25 +30,26 @@
 
 
 static int ocfs_readpage (struct file *file, struct page *page);
-static int ocfs_writepage (struct page *page);
 static int ocfs_prepare_write (struct file *file, struct page *page, unsigned from, unsigned to);
 static int ocfs_commit_write (struct file *file, struct page *page, unsigned from, unsigned to);
 static int ocfs_get_block (struct inode *inode, sector_t iblock, struct buffer_head *bh_result, int create);
-static int ocfs_get_block2 (struct inode *inode, long iblock, long *oblock, int len);
 static int ocfs_extend_allocation(ocfs_super *osb, ocfs_inode *oin, __u64 newsize, bool unlock, struct inode *inode);
 static int ocfs_symlink_get_block (struct inode *inode, sector_t iblock, struct buffer_head *bh_result, int create);
-static int ocfs_bmap(struct address_space *mapping, long block);
-
 
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
+static sector_t ocfs_bmap(struct address_space *mapping, sector_t block);
+static int ocfs_writepage (struct page *page, struct writeback_control *wbc);
 static int ocfs_direct_IO(int rw, struct kiocb *iocb, const struct iovec *iov, loff_t offset, unsigned long nr_segs);
-#elif LINUX_VERSION_CODE >= LinuxVersionCode(2,4,10)
-#if LINUX_VERSION_CODE >= LinuxVersionCode(2,4,20) || defined(SUSE)
+#else /* 2.4 kernel */
+static int ocfs_bmap(struct address_space *mapping, long block);
+static int ocfs_writepage (struct page *page);
+static int ocfs_get_block2 (struct inode *inode, long iblock, long *oblock, int len);
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,20) || defined(SUSE)
 static int ocfs_direct_IO (int rw, struct file *filp, struct kiobuf *iobuf, unsigned long blocknr, int blocksize);
 #else
 static int ocfs_direct_IO (int rw, struct inode *inode, struct kiobuf *iobuf, unsigned long blocknr, int blocksize);
 #endif
-#endif  /* version >= 2.4.10 */
+#endif
 
 #ifdef AIO_ENABLED
 int ocfs_kvec_read(struct file *file, kvec_cb_t cb, size_t size, loff_t pos); 
@@ -65,9 +66,10 @@
 	.commit_write = ocfs_commit_write,
 #if LINUX_VERSION_CODE >= LinuxVersionCode(2,4,10)
 /*
-* we are only adding this here as a dummy basically, just need open with O_DIRECT
-* to succeed, we still call ocfs_rw_direct()
-*/
+ * On a 2.4 system, we are only adding this here as a dummy basically, 
+ * just need open with O_DIRECT to succeed, we still call ocfs_rw_direct().
+ * For a 2.6 system, this is the way a filesystem provides direct-io support. 
+ */
 	.direct_IO = ocfs_direct_IO
 #endif
 };
@@ -256,7 +258,9 @@
 	inode->i_blksize = (__u32) osb->vol_layout.cluster_size;	// sb->s_blocksize;
 	inode->i_blocks = (fe->file_size + sb->s_blocksize) >> sb->s_blocksize_bits;
 	inode->i_mapping->a_ops = &ocfs_aops;
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,0)
 	inode->i_attr_flags |= ATTR_FLAG_NOATIME;
+#endif
 	inode->i_flags |= S_NOATIME;
 	OCFS_SET_INODE_TIME(inode, i_atime, fe->modify_time);
 	OCFS_SET_INODE_TIME(inode, i_mtime, fe->modify_time);
@@ -298,11 +302,7 @@
 		    inode->i_size = fe->file_size;
 		    break;
 	    default:
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
-		    init_special_inode (inode, mode, inode->i_rdev.value);
-#else
 		    init_special_inode (inode, mode, inode->i_rdev);
-#endif
 		    break;
 	}
 
@@ -317,8 +317,7 @@
  * by this point, i_sb, i_dev, i_ino are filled in
  *
  */
-static void ocfs_read_locked_inode (struct inode *inode, 
-				    ocfs_file_entry *entry)
+void ocfs_read_locked_inode (struct inode *inode, ocfs_file_entry *entry)
 {
 	struct super_block *sb;
 	ocfs_super *osb;
@@ -341,10 +340,9 @@
 		inode->i_blkbits = 9;
 		inode->i_blocks = 0;
 		inode->i_mapping->a_ops = &ocfs_aops;
-		inode->i_atime = OCFS_CURRENT_TIME;
-		inode->i_mtime = OCFS_CURRENT_TIME;
-		inode->i_ctime = OCFS_CURRENT_TIME;
-		inode->i_attr_flags |= ATTR_FLAG_NOATIME;
+		inode->i_atime = CURRENT_TIME;
+		inode->i_mtime = CURRENT_TIME;
+		inode->i_ctime = CURRENT_TIME;
 		inode->i_flags |= S_NOATIME;
 		inode->i_op = &ocfs_dir_iops;
 		inode->i_fop = &ocfs_dops;
@@ -372,11 +370,11 @@
 		    mode |= S_IFDIR;
 		    break;
 	    case OCFS_ATTRIB_CHAR:
-		    inode->i_rdev = mk_kdev (entry->dev_major, entry->dev_minor);
+		    inode->i_rdev = MKDEV (entry->dev_major, entry->dev_minor);
 		    mode |= S_IFCHR;
 		    break;
 	    case OCFS_ATTRIB_BLOCK:
-		    inode->i_rdev = mk_kdev (entry->dev_major, entry->dev_minor);
+		    inode->i_rdev = MKDEV (entry->dev_major, entry->dev_minor);
 		    mode |= S_IFBLK;
 		    break;
 	    case OCFS_ATTRIB_FIFO:
@@ -637,7 +635,7 @@
 			fe = OCFS_BH_GET_DATA_READ(args->fe_bh); /* read */
 		ocfs_read_locked_inode(inode, fe);
 		if (args)
-			OCFS_BH_PUT_DATA(fe_bh);
+			OCFS_BH_PUT_DATA(args->fe_bh);
 		unlock_new_inode(inode);
 	}
 
@@ -1033,7 +1031,11 @@
 	return err;
 }				/* ocfs_get_block */
 
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
+static sector_t ocfs_bmap(struct address_space *mapping, sector_t block) 
+#else
 static int ocfs_bmap(struct address_space *mapping, long block) 
+#endif
 {
 	int disk_block = 0;
 	ocfs_super *osb =(ocfs_super *) OCFS_GENERIC_SB_P(mapping->host->i_sb);
@@ -1260,7 +1262,7 @@
 	if (create && vbo_max > oin->alloc_size) {
 		/* WARNING: How much do we really want to extend the file? 
 		   is 'false' the right argument there? */
-		status = ocfs_extend_allocation(osb, oin, vbo_max, false);
+		status = ocfs_extend_allocation(osb, oin, vbo_max, false, inode);
 		if (status < 0) {
 			LOG_ERROR_STR("ocfs_direct_IO_get_blocks: failed to extend the file!");
 			goto bail;
@@ -1271,7 +1273,7 @@
 	/* This figure out the size of the next contiguous block, and
 	 * our logical offset */	
 	/* TODO: Try our damndest to give sizes in multiples of PAGE_SIZE */
-	status = ocfs_lookup_file_allocation(osb, oin, vbo, &lbo, max_blocks, &new_size);
+	status = ocfs_lookup_file_allocation(osb, oin, vbo, &lbo, max_blocks, &new_size, inode);
 
 	/* Do whatever we need to the buffer_head */
 	if (set_new) {
@@ -1318,7 +1320,7 @@
 	LOG_ENTRY ();
 
 	/* blockdev_direct_IO checks alignment for us, using */
-	ret = blockdev_direct_IO (rw, iocb, inode, inode->i_sb->s_bdev, iov, offset, nr_segs, ocfs_direct_IO_get_blocks);
+	ret = blockdev_direct_IO (rw, iocb, inode, inode->i_sb->s_bdev, iov, offset, nr_segs, ocfs_direct_IO_get_blocks, NULL);
 
 	LOG_EXIT_LONG (ret);
 	return ret;
@@ -1354,6 +1356,7 @@
 #endif
 
 
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,0)
 /*
  * ocfs_rw_direct()
  *
@@ -1616,8 +1619,7 @@
 #endif
 	return err;
 }				/* ocfs_rw_direct */
-
-
+#endif /* 2.4.x kernel */
 
 #ifdef AIO_ENABLED
 int ocfs_kvec_read(struct file *file, kvec_cb_t cb, size_t size, loff_t pos) 
