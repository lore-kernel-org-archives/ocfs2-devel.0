From: Rusty Lynch <rusty@linux.co.intel.com>
Date: Fri Mar 26 14:47:07 2004
Subject: [Ocfs2-devel] [PATCH]remove ocfs_fill_super and port
	ocfs_read_super
In-Reply-To: <20040326143454.GG18020@ca-server1.us.oracle.com>
References: <200403260259.i2Q2xnp9006458@penguin.co.intel.com>
	<20040326143454.GG18020@ca-server1.us.oracle.com>
Message-ID: <20040326204638.GA7147@penguin.co.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Mar 26, 2004 at 06:34:54AM -0800, Joel Becker wrote:
> On Thu, Mar 25, 2004 at 06:59:49PM -0800, Rusty Lynch wrote:
> > The 2.6 version of ocfs_read_super (known as ocfs_fill_super) had
> > a bug where it wasn't unmounting on error.  There really isn't a lot
> > different between the 2.4 and 2.5 functions, so here is a patch that
> > adds 2.6 support to the existing ocfs_read_super, and nukes the old
> > ocfs_fill_super.
> 
> 	Ugh ugh ugh.  I see what you are trying to do here, but you are
> peppering one function with multiple #ifdefs.  Better to make the guts
> be an #ifdef ocfs_generic_fill_super(), with:
> 
> #if KERNEL_VERSION < LINUX_VERSION_CODE(2,6,0)
> static int ocfs_read_super(...)
> {
>     /* 2.6 specific */
>     ocfs_generic_fill_super();
>     /* 2.6 specific */
> }
> #else
> static struct super_block *ocfs_read_super(...)
> {
>     /* 2.4 specific */
>     ocfs_generic_fill_super();
>     /* 2.4 specific */
> }
> #endif


How about something like...

static int ocfs_set_blocksize(struct super_block *sb)
{
	int status = 0;

#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
	if (!sb_set_blocksize(sb, 512))
		status = -EIO;
#else
	/* TODO: fix this */
	sb->s_blocksize = 512;
	sb->s_blocksize_bits = 9;
#if LINUX_VERSION_CODE >= LinuxVersionCode(2,4,18)
	status = set_blocksize (sb->s_dev, 512);
#else
	set_blocksize (sb->s_dev, 512);
#endif /* < 2.4.18 */
#endif /* < 2.6.0 */

	return status;
}

/*
 * __ocfs_read_super()
 *
 */
static int __ocfs_read_super(struct super_block *sb, void *data, int silent)
{
	struct dentry *root;
	int status;
	struct inode *inode = NULL;
	__u32 uid = current->fsuid;
	__u32 gid = current->fsgid;
	bool reclaim_id;
	ocfs_super *osb = NULL;

	LOG_ENTRY_ARGS ("%p, %p, %i", sb, data, silent);

#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,0)	
	MOD_INC_USE_COUNT;
#endif
	if (ocfs_parse_options (data, &uid, &gid, &reclaim_id) != 0) {
		status = -EINVAL;
		LOG_ERROR_STR ("ocfs_read_super: bad mount option");
		goto read_super_error;
	}

	status = ocfs_set_blocksize(sb);
	if (status < 0) {
		LOG_ERROR_STR("unable to set blocksize");
		goto read_super_error;
	}

	sb->s_magic = OCFS_MAGIC;
	sb->s_op = &ocfs_sops;
	sb->s_flags |= MS_NOATIME;

	/* this is needed to support O_LARGE_FILE */
	sb->s_maxbytes = OCFS_LINUX_MAX_FILE_SIZE;

	status = ocfs_mount_volume (sb, reclaim_id, NULL);
	if (status < 0)
		goto read_super_error;

        osb = (ocfs_super *) OCFS_GENERIC_SB_P(sb);
	if (!osb) {
		status = -EINVAL;
		goto read_super_error;
	}

#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
	inode = ocfs_iget(sb, NULL);
#else	
	inode = iget4 (sb, OCFS_ROOT_INODE_NUMBER, 0, NULL);
#endif
	if (!inode) {
		status = -EIO;
		LOG_ERROR_STATUS (status);
		goto read_super_error;
	}

	root = d_alloc_root (inode);
	if (!root) {
		status = -ENOMEM;
		LOG_ERROR_STATUS (status);
		iput (inode);
		/* should we be setting inode to null?? */
		goto read_super_error;
	}

	sb->s_root = root;

	printk ("ocfs2: Mounting device (%u,%u) on %s (node %d)\n",
		MAJOR(sb->s_dev), MINOR(sb->s_dev),
		osb->node_cfg_info[osb->node_num]->node_name, osb->node_num);

	LOG_EXIT_STATUS(status);
	return status;		

read_super_error:
	if (osb)
		ocfs_dismount_volume (sb);

#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,0)
	MOD_DEC_USE_COUNT;
#endif

	if (inode != NULL) {
		iput (inode);
		inode = NULL;
	}

	LOG_EXIT_STATUS(status);
	return status;
}

#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
static int ocfs_read_super (struct super_block *sb, void *data, int silent)
{
	return __ocfs_read_super(sb, data, silent);
}
#else
static struct super_block *ocfs_read_super (struct super_block *sb, void *data, int silent)
{
	if (__ocfs_read_super(sb, data, silent) < 0)
		return NULL;
	return sb;
}
#endif

The __ocfs_read_super() still has to keep some #if/#else/#endif's for 2.4/2.6 code, so it really 
isn't generic, so I thought __ocfs_read_super() was more accurate.  The biggest part of __ocfs_read_super
that made it hard on the eyes was the stuff about setting the block size, so I went ahead and seperated
that into a ocfs_set_blocksize() function that does the right thing for a given kernel version.
(It adds another function call, but does it really matter if a mount takes a sliver of time longer?)

Take a look@this and see if this is better.

  --rusty


Index: src/super.c
===================================================================
--- src/super.c	(revision 812)
+++ src/super.c	(working copy)
@@ -154,108 +154,32 @@
 
 };
 
+static int ocfs_set_blocksize(struct super_block *sb)
+{
+	int status = 0;
 
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
+	if (!sb_set_blocksize(sb, 512))
+		status = -EIO;
+#else
+	/* TODO: fix this */
+	sb->s_blocksize = 512;
+	sb->s_blocksize_bits = 9;
+#if LINUX_VERSION_CODE >= LinuxVersionCode(2,4,18)
+	status = set_blocksize (sb->s_dev, 512);
+#else
+	set_blocksize (sb->s_dev, 512);
+#endif /* < 2.4.18 */
+#endif /* < 2.6.0 */
 
-static int ocfs_fill_super (struct super_block *sb, void *data, int silent)
-{
-	struct dentry *root_dentry;
-	int status = -1;
-	struct inode *root_inode = NULL;
-	__u32 uid = current->fsuid;
-	__u32 gid = current->fsgid;
-	bool reclaim_id;
-        ocfs_super *osb;
-
-	LOG_ENTRY ();
-	
-	if (ocfs_parse_options (data, &uid, &gid, &reclaim_id) != 0) {
-		LOG_ERROR_STR ("bad mount option");
-		status=-EINVAL;
-		goto read_super_error;
-	}
-
-	sb->s_magic = OCFS_MAGIC;
-	sb->s_op = &ocfs_sops;
-	sb->s_flags |= MS_NOATIME;
-
-	/* this is needed to support O_LARGE_FILE */
-	sb->s_maxbytes = OCFS_LINUX_MAX_FILE_SIZE;
-
-	if (!sb_set_blocksize(sb, 512)) {
-		LOG_ERROR_STR("Could not set block size");
-		status=-EIO;
-		goto read_super_error;
-	}
-
-	status = ocfs_mount_volume (sb, reclaim_id, NULL);
-	if (status < 0) {
-		goto read_super_error;
-	}
-	osb = ((ocfs_super *)(sb->s_fs_info));
-	if (!osb) {
-		status=-EINVAL;
-		goto read_super_error;
-	}
-
-	root_inode = ocfs_iget(sb, NULL);
-	if (!root_inode) {
-		status=-EIO;
-		LOG_ERROR_STATUS (status);
-		goto read_super_error;
-	}
-
-	root_dentry = d_alloc_root (root_inode);
-	if (!root_dentry) {
-		status=-ENOMEM;
-		LOG_ERROR_STATUS (status);
-		goto read_super_error;
-	}
-
-	sb->s_root = root_dentry;
-	printk ("ocfs2: Mounting device (%u,%u) on %s (node %d)\n",
-		MAJOR(sb->s_dev), MINOR(sb->s_dev),
-		osb->node_cfg_info[osb->node_num]->node_name, osb->node_num);
-
-	status = 0;
-	LOG_EXIT_STATUS (status);
 	return status;
-
-read_super_error:
-	if (root_inode != NULL) {
-		iput (root_inode);
-		root_inode = NULL;
-	}
-
-	LOG_EXIT_STATUS (status);
-	return status;
-}				/* ocfs_fill_super */
-
-static struct super_block *ocfs_get_sb(struct file_system_type *fs_type, int flags, const char *dev_name, void *data)
-{
-	return get_sb_bdev(fs_type, flags, dev_name, data, ocfs_fill_super);
 }
 
-static struct file_system_type ocfs_fs_type = {
-        .owner          = THIS_MODULE,
-        .name           = "ocfs2",
-        .get_sb         = ocfs_get_sb, /* is this called when we mount
-					* the fs? */
-        .kill_sb        = kill_block_super, /* set to the generic one
-					     * right now, but do we
-					     * need to change that? */
-        .fs_flags       = FS_REQUIRES_DEV,
-	.next           = NULL
-};
-
-#else  /* We're a 2.4 kernel */
-
-
 /*
- * ocfs_read_super()
+ * __ocfs_read_super()
  *
  */
-static struct super_block *ocfs_read_super (struct super_block *sb, void *data, int silent)
+static int __ocfs_read_super(struct super_block *sb, void *data, int silent)
 {
 	struct dentry *root;
 	int status;
@@ -265,27 +189,22 @@
 	bool reclaim_id;
 	ocfs_super *osb = NULL;
 
-	LOG_ENTRY ();
+	LOG_ENTRY_ARGS ("%p, %p, %i", sb, data, silent);
 
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,0)	
 	MOD_INC_USE_COUNT;
-
+#endif
 	if (ocfs_parse_options (data, &uid, &gid, &reclaim_id) != 0) {
+		status = -EINVAL;
 		LOG_ERROR_STR ("ocfs_read_super: bad mount option");
 		goto read_super_error;
 	}
 
-	/* TODO: fix this */
-	sb->s_blocksize = 512;
-	sb->s_blocksize_bits = 9;
-#if LINUX_VERSION_CODE >= LinuxVersionCode(2,4,18)
-	status = set_blocksize (sb->s_dev, 512);
+	status = ocfs_set_blocksize(sb);
 	if (status < 0) {
-		LOG_ERROR_STR ("ocfs_read_super: set_blocksize failed!");
+		LOG_ERROR_STR("unable to set blocksize");
 		goto read_super_error;
 	}
-#else
-	set_blocksize (sb->s_dev, 512);
-#endif
 
 	sb->s_magic = OCFS_MAGIC;
 	sb->s_op = &ocfs_sops;
@@ -295,20 +214,32 @@
 	sb->s_maxbytes = OCFS_LINUX_MAX_FILE_SIZE;
 
 	status = ocfs_mount_volume (sb, reclaim_id, NULL);
+	if (status < 0)
+		goto read_super_error;
+
         osb = (ocfs_super *) OCFS_GENERIC_SB_P(sb);
-	if (status < 0 || !osb)
+	if (!osb) {
+		status = -EINVAL;
 		goto read_super_error;
+	}
 
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
+	inode = ocfs_iget(sb, NULL);
+#else	
 	inode = iget4 (sb, OCFS_ROOT_INODE_NUMBER, 0, NULL);
+#endif
 	if (!inode) {
+		status = -EIO;
 		LOG_ERROR_STATUS (status);
 		goto read_super_error;
 	}
 
 	root = d_alloc_root (inode);
 	if (!root) {
+		status = -ENOMEM;
 		LOG_ERROR_STATUS (status);
 		iput (inode);
+		/* should we be setting inode to null?? */
 		goto read_super_error;
 	}
 
@@ -318,29 +249,61 @@
 		MAJOR(sb->s_dev), MINOR(sb->s_dev),
 		osb->node_cfg_info[osb->node_num]->node_name, osb->node_num);
 
-	LOG_EXIT_PTR (sb);
-	return sb;
+	LOG_EXIT_STATUS(status);
+	return status;		
 
 read_super_error:
 	if (osb)
 		ocfs_dismount_volume (sb);
 
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,0)
 	MOD_DEC_USE_COUNT;
+#endif
+
 	if (inode != NULL) {
 		iput (inode);
 		inode = NULL;
 	}
 
-	LOG_EXIT_PTR (0);
-	return NULL;
-}				/* ocfs_read_super */
+	LOG_EXIT_STATUS(status);
+	return status;
+}
 
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
+static int ocfs_read_super (struct super_block *sb, void *data, int silent)
+{
+	return __ocfs_read_super(sb, data, silent);
+}
+#else
+static struct super_block *ocfs_read_super (struct super_block *sb, void *data, int silent)
+{
+	if (__ocfs_read_super(sb, data, silent) < 0)
+		return NULL;
+	return sb;
+}
+#endif
 
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
+static struct super_block *ocfs_get_sb(struct file_system_type *fs_type, int flags, const char *dev_name, void *data)
+{
+	return get_sb_bdev(fs_type, flags, dev_name, data, ocfs_read_super);
+}
+
+static struct file_system_type ocfs_fs_type = {
+        .owner          = THIS_MODULE,
+        .name           = "ocfs2",
+        .get_sb         = ocfs_get_sb, /* is this called when we mount
+					* the fs? */
+        .kill_sb        = kill_block_super, /* set to the generic one
+					     * right now, but do we
+					     * need to change that? */
+        .fs_flags       = FS_REQUIRES_DEV,
+	.next           = NULL
+};
+#else
 static DECLARE_FSTYPE (ocfs_fs_type, "ocfs2", ocfs_read_super, FS_REQUIRES_DEV);
-#endif /* #if 2.6 kernel ... #else */
+#endif
 
-
-
 /*
  * ocfs_parse_options()
  *
Index: src/inc/io.h
===================================================================
--- src/inc/io.h	(revision 812)
+++ src/inc/io.h	(working copy)
@@ -41,7 +41,6 @@
 				  struct buffer_head **bh, 
 				  int                  flags, 
 				  struct inode        *inode);
-
 int ocfs_write_bhs (ocfs_super          *osb,
 		    struct buffer_head  *bh[], 
 		    int                  nr, 
