From: Rusty Lynch <rusty@linux.co.intel.com>
Date: Mon Mar 29 17:46:21 2004
Subject: [Ocfs2-devel] [PATCH]remove ocfs_fill_super and port
	ocfs_read_super
In-Reply-To: <20040329230609.GY10672@ca-server1.us.oracle.com>
References: <200403260259.i2Q2xnp9006458@penguin.co.intel.com>
	<20040326143454.GG18020@ca-server1.us.oracle.com>
	<20040326204638.GA7147@penguin.co.intel.com>
	<20040329212947.GW10672@ca-server1.us.oracle.com>
	<20040329213158.GA12840@penguin.co.intel.com>
	<20040329223754.GA15877@penguin.co.intel.com>
	<20040329230609.GY10672@ca-server1.us.oracle.com>
Message-ID: <20040329234603.GA19720@penguin.co.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Mar 29, 2004 at 03:06:09PM -0800, Mark Fasheh wrote:
> On Mon, Mar 29, 2004 at 02:37:54PM -0800, Rusty Lynch wrote:
> > ah... first of all, s/I should be inline/It should be inlined/
> > hey, it's not like englihs is first (and only) language or anything :->
> heh, i dont' now wat your taking abuot
> 
> > The only thing left in __ocfs_read_super that requires #if LINUX.../#endif's
> > is the ocfs_iget/iget4 stuff, which is one of those areas that I have been meaning
> > to deal with...  ocfs_iget() should be what get's called regardless of 2.4/2.6, 
> > and then deal with 2.4 verses 2.6 specifics in that function instead of sprinkled
> > over super/namei/hash.
> > 
> > You mind if I tackle this in the same patch, or do you want two patches?  (It's just
> > that ocfs_iget needs to be fixed before __ocfs_read_super can be made clean.)
> Actually, two patches please. I don't mind the extra over #ifdef, and it'll
> give us time to run with the new read_super while you deal with the inode
> stuff (which I'd like to test seperately anyway).
> 
> While we're on the topic of iget, here's a thought. Theoretically we don't
> need iget4/iget5 anymore, as our inode numbers are no longer tied to 64 bit
> disk offsets and instead are taken from iunique, which, as the name
> indicates, gives you a unique inode number. We should be able to just always
> use iget instead, which is much simpler.
> 
> Of course, eliminating the #ifdef ... iget4 #else ocfs_iget #endif stuff is
> a step in a good direction. However, if you want to give moving to iget a
> shot, I'd be more than happy to help out with at least the 2.4 side of
> things (testing, etc)
> 	--Mark
> 

hmm... yea, switching over to pure iget's sounds like a good idea.  Let me take
a look into it.

Here is my previous patch with the ocfs_set_blocksize make inline, and the addition
of OCFS_MOD_[INC|DEC]_USE_COUNT


Index: src/super.c
===================================================================
--- src/super.c	(revision 820)
+++ src/super.c	(working copy)
@@ -154,108 +154,32 @@
 
 };
 
+static inline int ocfs_set_blocksize(struct super_block *sb)
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
@@ -265,27 +189,21 @@
 	bool reclaim_id;
 	ocfs_super *osb = NULL;
 
-	LOG_ENTRY ();
+	LOG_ENTRY_ARGS ("%p, %p, %i", sb, data, silent);
 
-	MOD_INC_USE_COUNT;
+	OCFS_MOD_INC_USE_COUNT;
 
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
@@ -295,20 +213,32 @@
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
 
-	inode = iget4 (sb, OCFS_ROOT_INODE_NUMBER, 0, NULL);
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)	
+	inode = ocfs_iget(sb, NULL);
+#else
+	inode = iget4(sb, OCFS_ROOT_INODE_NUMBER, 0, NULL);
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
 
@@ -318,29 +248,59 @@
 		MAJOR(sb->s_dev), MINOR(sb->s_dev),
 		osb->node_cfg_info[osb->node_num]->node_name, osb->node_num);
 
-	LOG_EXIT_PTR (sb);
-	return sb;
+	LOG_EXIT_STATUS(status);
+	return status;		
 
 read_super_error:
 	if (osb)
 		ocfs_dismount_volume (sb);
 
-	MOD_DEC_USE_COUNT;
+	OCFS_MOD_DEC_USE_COUNT;
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
Index: src/inc/ocfs.h
===================================================================
--- src/inc/ocfs.h	(revision 820)
+++ src/inc/ocfs.h	(working copy)
@@ -1159,6 +1159,14 @@
 #define OCFS_GENERIC_SB_P(sb)	((ocfs_super *)(sb->u.generic_sbp))
 #endif
 
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
+#define OCFS_MOD_INC_USE_COUNT
+#define OCFS_MOD_DEC_USE_COUNT
+#else
+#define OCFS_MOD_INC_USE_COUNT        MOD_INC_USE_COUNT
+#define OCFS_MOD_DEC_USE_COUNT        MOD_INC_USE_COUNT
+#endif
+
 extern __u32 debug_context;
 extern __u32 debug_level;
 extern __u32 debug_exclude;
