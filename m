From: Rusty Lynch <rusty@linux.co.intel.com>
Date: Wed Mar 10 22:49:45 2004
Subject: [Ocfs2-devel] [PATCH]2.6 mechanism for holding private inode data
Message-ID: <200403110449.i2B4ncDw032388@penguin.co.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The following patch is safe for the 2.4 kernel, but still incomplete 
for the 2.6 kernel.  I am sending this just incase there is any feedback
on what I am doing (and to give Sonic and Xiaofeng a chance to figure this
out while I'm asleep.)

So... struct inode changed in 2.6 such that the union on the end of the
struct now only contains "void *generic_ip", and therefore only adds
on sizeof(void *) to the end of the structure.  Our 2.6 code is still
attempting to read/write private data at the end of the inode struct,
and therefore writing past the end of the object.

The suggested new way of storing private data is to define a new
struct that contains your private data and has an inode imbedded inside.
Then the private data can be reached from an inode by doing a simple
container_of on the inode.  This is possible by hooking into inode
allocation/deallocation via the alloc_inode/destroy_inode function 
pointers in the super operations.

(See linux/Documentation/filesystems/port)

The following patch does this and also takes the liberty to convert the 
macros for getting/setting private data into inline functions (mainly
because stared at OCFS_GENERIC_IP and friends for way to long before
I realized what they were actually doing, and why that was freezing my
2.6 build.)

All this sounds good except... now d_alloc_root() oops's when it attempts
to initialize which attempts to d_initialize() which eventually dereferences
a new pointer while initializing a list_head.  I'm sure I missed a step
some place, but I'm spent for the night.

    --rusty

Index: src/super.c
===================================================================
--- src/super.c	(revision 769)
+++ src/super.c	(working copy)
@@ -135,6 +135,8 @@
 static void ocfs_free_mem_lists (void);
 
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
+static struct inode *ocfs_alloc_inode(struct super_block *sb);
+static void ocfs_destroy_inode(struct inode *inode);
 static int ocfs_statfs (struct super_block *sb, struct kstatfs *buf);
 #else
 static int ocfs_statfs (struct super_block *sb, struct statfs *buf);
@@ -146,7 +148,10 @@
 	.clear_inode = ocfs_clear_inode,
 	//put_inode =           force_delete,
 	//delete_inode =        ocfs_delete_inode, 
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,0)
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
+	.alloc_inode = ocfs_alloc_inode,
+	.destroy_inode = ocfs_destroy_inode,
+#else
 	.read_inode = ocfs_read_inode,
 	.read_inode2 = ocfs_read_inode2,
 #endif
@@ -154,9 +159,24 @@
 
 };
 
-
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
 
+static struct inode *ocfs_alloc_inode(struct super_block *sb)
+{
+	struct ocfs_inode_info *i = (struct ocfs_inode_info *)kmem_cache_alloc(OcfsGlobalCtxt.inode_cache, GFP_NOFS);
+	if (!i) {
+		LOG_ERROR_STR("unable to allocate inode");
+		return NULL;
+	}
+
+	return &(i->vfs_inode);
+}
+
+static void ocfs_destroy_inode(struct inode *inode)
+{
+	kmem_cache_free(OcfsGlobalCtxt.inode_cache, OCFS_I(inode));
+}
+
 static int ocfs_fill_super (struct super_block *sb, void *data, int silent)
 {
 	struct dentry *root_dentry;
@@ -788,6 +808,11 @@
  */
 static int ocfs_initialize_mem_lists (void)
 {
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)	
+	OcfsGlobalCtxt.inode_cache = kmem_cache_create ("ocfs2_inode",
+		sizeof (struct ocfs_inode_info) + OCFS_POINTER_SIZE, 0, SLAB_NO_REAP | SLAB_HWCACHE_ALIGN,
+		NULL, NULL);
+#endif
 	OcfsGlobalCtxt.oin_cache = kmem_cache_create ("ocfs2_oin",
 		sizeof (ocfs_inode) + OCFS_POINTER_SIZE, 0, SLAB_NO_REAP | SLAB_HWCACHE_ALIGN,
 		NULL, NULL);
@@ -826,6 +851,9 @@
  */
 static void ocfs_free_mem_lists (void)
 {
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
+	kmem_cache_destroy (OcfsGlobalCtxt.inode_cache);
+#endif
 	kmem_cache_destroy (OcfsGlobalCtxt.oin_cache);
 	kmem_cache_destroy (OcfsGlobalCtxt.ofile_cache);
 	kmem_cache_destroy (OcfsGlobalCtxt.fe_cache);
Index: src/inc/ocfs.h
===================================================================
--- src/inc/ocfs.h	(revision 769)
+++ src/inc/ocfs.h	(working copy)
@@ -227,8 +227,85 @@
 #define ocfs_getpid()               getpid()
 #endif
 
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
 
+struct ocfs_inode_info {
+	/* fs-private stuff */
+	void *           generic_ip;
+	__u64            voteoff;
+	__u64            feoff;
+	atomic_t         i_clean_buffer_seq;
+	__u8             deleted; /* this can be a generic flags field later */
+	struct inode vfs_inode;
+};
 
+static inline struct ocfs_inode_info *OCFS_I(struct inode *inode)
+{
+	return list_entry(inode, struct ocfs_inode_info, vfs_inode);
+}
+
+static inline atomic_t *GET_INODE_CLEAN_SEQ(struct inode *inode)
+{
+	return &(OCFS_I(inode)->i_clean_buffer_seq);
+}
+
+static inline int inode_data_is_oin(struct inode *inode)
+{
+	return (OCFS_I(inode)->generic_ip != NULL);
+}
+
+static inline __u8 INODE_DELETED(struct inode *inode)
+{
+	return OCFS_I(inode)->deleted;
+}
+
+static inline void SET_INODE_DELETED(struct inode *inode)
+{
+	OCFS_I(inode)->deleted = 1;
+}
+
+static inline void CLEAR_INODE_DELETED(struct inode *inode)
+{
+	OCFS_I(inode)->deleted = 0;
+}
+
+static inline void SET_INODE_VOTEOFF(struct inode *inode, __u64 voteoff)
+{
+	OCFS_I(inode)->voteoff = voteoff;
+}
+
+static inline __u64 GET_INODE_VOTEOFF(struct inode *inode)
+{
+	return OCFS_I(inode)->voteoff;
+}
+
+static inline void SET_INODE_FEOFF(struct inode *inode, __u64 feoff)
+{
+	OCFS_I(inode)->feoff = feoff;
+}
+
+static inline __u64 GET_INODE_FEOFF(struct inode *inode)
+{
+	return OCFS_I(inode)->feoff;
+}
+
+static inline void CLEAR_INODE_OIN(struct inode *inode)
+{
+	OCFS_I(inode)->generic_ip = (void *)NULL;
+}
+
+static inline void SET_INODE_OIN(struct inode *inode, void *oin)
+{
+	OCFS_I(inode)->generic_ip = oin;
+}
+
+static inline void *GET_INODE_OIN(struct inode *inode)
+{
+	return OCFS_I(inode)->generic_ip;
+}
+
+#else
+
 typedef struct _ocfs_inode_private
 {
 	void *           generic_ip;
@@ -277,6 +354,8 @@
 
 #define GET_INODE_OIN(i) ((ocfs_inode *)(OCFS_GENERIC_IP(i)->generic_ip))
 
+#endif /* 2.4.x kernel */
+
 #define FIRST_FILE_ENTRY(dir)   ((char *) ((char *)dir)+OCFS_SECTOR_SIZE)
 #define FILEENT(dir,idx)        (ocfs_file_entry *) ( ((char *)dir) + \
                                 ((dir->index[idx]+1) * OCFS_SECTOR_SIZE))
@@ -2059,6 +2138,7 @@
 	ocfs_obj_id obj_id;
 	ocfs_sem res;
 	struct list_head osb_next;	/* List of all volumes */
+	kmem_cache_t *inode_cache;
 	kmem_cache_t *oin_cache;
 	kmem_cache_t *ofile_cache;
 	kmem_cache_t *fe_cache;
Index: src/namei.c
===================================================================
--- src/namei.c	(revision 769)
+++ src/namei.c	(working copy)
@@ -935,7 +935,7 @@
 
 	/* new parent dir offset */
 	if (inode_data_is_oin (new_dir))
-		newDirOff = (GET_INODE_OIN(new_dir))->dir_disk_off;
+		newDirOff = ((ocfs_inode *)GET_INODE_OIN(new_dir))->dir_disk_off;
 	else
 		newDirOff = GET_INODE_VOTEOFF (new_dir);
 
