From: Tiger Yang <tiger.yang@oracle.com>
Date: Thu,  5 Jun 2008 15:24:54 +0800
Subject: [Ocfs2-devel] [PATCH 7/8] ocfs2: Add extended attributes support. v1
In-Reply-To: <484792D1.3080802@oracle.com>
References: <484792D1.3080802@oracle.com>
Message-ID: <1212650694-9603-1-git-send-email-tiger.yang@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This patch implement storing extended attributes both in inode or metadata block.
For EAs in inode, we reserve the last 256 bytes in inode block(blocksize >= 1024).
When EAs value size large than 80 bytes, we will store the value via b-tree
outside inode or block.

Signed-off-by: Tiger Yang <tiger.yang@oracle.com>
---
 fs/ocfs2/Makefile        |    2 +
 fs/ocfs2/file.c          |    5 +
 fs/ocfs2/inode.c         |    8 +
 fs/ocfs2/namei.c         |    5 +
 fs/ocfs2/ocfs2.h         |    1 +
 fs/ocfs2/ocfs2_fs.h      |   43 ++-
 fs/ocfs2/super.c         |   12 +
 fs/ocfs2/xattr.c         | 1342 +++++++++++++++++++++++++++++++++++++++++++++-
 fs/ocfs2/xattr.h         |   27 +
 fs/ocfs2/xattr_trusted.c |   79 +++
 fs/ocfs2/xattr_user.c    |   91 ++++
 11 files changed, 1600 insertions(+), 15 deletions(-)
 create mode 100644 fs/ocfs2/xattr_trusted.c
 create mode 100644 fs/ocfs2/xattr_user.c

diff --git a/fs/ocfs2/Makefile b/fs/ocfs2/Makefile
index af63980..21323da 100644
--- a/fs/ocfs2/Makefile
+++ b/fs/ocfs2/Makefile
@@ -36,6 +36,8 @@ ocfs2-objs := \
 	uptodate.o		\
 	ver.o			\
 	xattr.o			\
+	xattr_user.o		\
+	xattr_trusted.o
 
 ocfs2_stackglue-objs := stackglue.o
 ocfs2_stack_o2cb-objs := stack_o2cb.o
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index e138fec..b2b96b3 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -55,6 +55,7 @@
 #include "mmap.h"
 #include "suballoc.h"
 #include "super.h"
+#include "xattr.h"
 
 #include "buffer_head_io.h"
 
@@ -2070,6 +2071,10 @@ const struct inode_operations ocfs2_file_iops = {
 	.setattr	= ocfs2_setattr,
 	.getattr	= ocfs2_getattr,
 	.permission	= ocfs2_permission,
+	.setxattr	= generic_setxattr,
+	.getxattr	= generic_getxattr,
+	.listxattr	= ocfs2_listxattr,
+	.removexattr	= generic_removexattr,
 	.fallocate	= ocfs2_fallocate,
 };
 
diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 7e9e4c7..da4b013 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -49,6 +49,7 @@
 #include "symlink.h"
 #include "sysfile.h"
 #include "uptodate.h"
+#include "xattr.h"
 
 #include "buffer_head_io.h"
 
@@ -730,6 +731,13 @@ static int ocfs2_wipe_inode(struct inode *inode,
 		goto bail_unlock_dir;
 	}
 
+	/*Free extended attribute resources associated with this inode.*/
+	status = ocfs2_xattr_remove(inode, di_bh);
+	if (status < 0) {
+		mlog_errno(status);
+		goto bail_unlock_dir;
+	}
+
 	status = ocfs2_remove_inode(inode, di_bh, orphan_dir_inode,
 				    orphan_dir_bh);
 	if (status < 0)
diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index d5d808f..b938b00 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -60,6 +60,7 @@
 #include "symlink.h"
 #include "sysfile.h"
 #include "uptodate.h"
+#include "xattr.h"
 
 #include "buffer_head_io.h"
 
@@ -1918,4 +1919,8 @@ const struct inode_operations ocfs2_dir_iops = {
 	.setattr	= ocfs2_setattr,
 	.getattr	= ocfs2_getattr,
 	.permission	= ocfs2_permission,
+	.setxattr	= generic_setxattr,
+	.getxattr	= generic_getxattr,
+	.listxattr	= ocfs2_listxattr,
+	.removexattr	= generic_removexattr,
 };
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index 3169237..f567215 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -172,6 +172,7 @@ enum ocfs2_mount_options
 	OCFS2_MOUNT_ERRORS_PANIC = 1 << 3, /* Panic on errors */
 	OCFS2_MOUNT_DATA_WRITEBACK = 1 << 4, /* No data ordering */
 	OCFS2_MOUNT_LOCALFLOCKS = 1 << 5, /* No cluster aware user file locks */
+	OCFS2_MOUNT_NOUSERXATTR = 1 << 6, /* No user xattr */
 };
 
 #define OCFS2_OSB_SOFT_RO	0x0001
diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
index 52c4266..d0fbf38 100644
--- a/fs/ocfs2/ocfs2_fs.h
+++ b/fs/ocfs2/ocfs2_fs.h
@@ -291,6 +291,9 @@ struct ocfs2_new_group_input {
 /* Journal limits (in bytes) */
 #define OCFS2_MIN_JOURNAL_SIZE		(4 * 1024 * 1024)
 
+/* Inline extended attribute size (in bytes) */
+#define OCFS2_MAX_XATTR_INLINE_SIZE	256
+
 /*
  * Default local alloc size (in megabytes)
  *
@@ -640,11 +643,12 @@ struct ocfs2_dinode {
 	__le32 i_atime_nsec;
 	__le32 i_ctime_nsec;
 	__le32 i_mtime_nsec;
-	__le32 i_attr;
+/*70*/	__le32 i_attr;
 	__le16 i_orphaned_slot;		/* Only valid when OCFS2_ORPHANED_FL
 					   was set in i_flags */
 	__le16 i_dyn_features;
-/*70*/	__le64 i_reserved2[8];
+	__le64 i_xattr_loc;
+/*80*/	__le64 i_reserved2[7];
 /*B8*/	union {
 		__le64 i_pad1;		/* Generic way to refer to this
 					   64bit union */
@@ -721,16 +725,26 @@ static inline int ocfs2_fast_symlink_chars(struct super_block *sb)
 
 static inline int ocfs2_max_inline_data(struct super_block *sb)
 {
-	return sb->s_blocksize -
-		offsetof(struct ocfs2_dinode, id2.i_data.id_data);
+	if (sb->s_blocksize != OCFS2_MIN_BLOCKSIZE)
+		return sb->s_blocksize -
+			offsetof(struct ocfs2_dinode, id2.i_data.id_data) -
+			OCFS2_MAX_XATTR_INLINE_SIZE;
+	else
+		return sb->s_blocksize -
+			offsetof(struct ocfs2_dinode, id2.i_data.id_data);
 }
 
 static inline int ocfs2_extent_recs_per_inode(struct super_block *sb)
 {
 	int size;
 
-	size = sb->s_blocksize -
-		offsetof(struct ocfs2_dinode, id2.i_list.l_recs);
+	if (sb->s_blocksize != OCFS2_MIN_BLOCKSIZE)
+		size = sb->s_blocksize -
+			offsetof(struct ocfs2_dinode, id2.i_list.l_recs) -
+			OCFS2_MAX_XATTR_INLINE_SIZE;
+	else
+		size = sb->s_blocksize -
+			offsetof(struct ocfs2_dinode, id2.i_list.l_recs);
 
 	return size / sizeof(struct ocfs2_extent_rec);
 }
@@ -806,15 +820,26 @@ static inline int ocfs2_fast_symlink_chars(int blocksize)
 
 static inline int ocfs2_max_inline_data(int blocksize)
 {
-	return blocksize - offsetof(struct ocfs2_dinode, id2.i_data.id_data);
+	if (blocksize != OCFS2_MIN_BLOCKSIZE)
+		return blocksize -
+			offsetof(struct ocfs2_dinode, id2.i_data.id_data) -
+			OCFS2_MAX_XATTR_INLINE_SIZE;
+	else
+		return blocksize -
+			offsetof(struct ocfs2_dinode, id2.i_data.id_data);
 }
 
 static inline int ocfs2_extent_recs_per_inode(int blocksize)
 {
 	int size;
 
-	size = blocksize -
-		offsetof(struct ocfs2_dinode, id2.i_list.l_recs);
+	if (blocksize != OCFS2_MIN_BLOCKSIZE)
+		size = blocksize -
+			offsetof(struct ocfs2_dinode, id2.i_list.l_recs) -
+			OCFS2_MAX_XATTR_INLINE_SIZE;
+	else
+		size = blocksize -
+			offsetof(struct ocfs2_dinode, id2.i_list.l_recs);
 
 	return size / sizeof(struct ocfs2_extent_rec);
 }
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index df63ba2..2628dbf 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -64,6 +64,7 @@
 #include "sysfile.h"
 #include "uptodate.h"
 #include "ver.h"
+#include "xattr.h"
 
 #include "buffer_head_io.h"
 
@@ -154,6 +155,8 @@ enum {
 	Opt_localalloc,
 	Opt_localflocks,
 	Opt_stack,
+	Opt_user_xattr,
+	Opt_nouser_xattr,
 	Opt_err,
 };
 
@@ -173,6 +176,8 @@ static match_table_t tokens = {
 	{Opt_localalloc, "localalloc=%d"},
 	{Opt_localflocks, "localflocks"},
 	{Opt_stack, "cluster_stack=%s"},
+	{Opt_user_xattr, "user_xattr"},
+	{Opt_nouser_xattr, "nouser_xattr"},
 	{Opt_err, NULL}
 };
 
@@ -847,6 +852,12 @@ static int ocfs2_parse_options(struct super_block *sb,
 		case Opt_data_writeback:
 			mopt->mount_opt |= OCFS2_MOUNT_DATA_WRITEBACK;
 			break;
+		case Opt_user_xattr:
+			mopt->mount_opt &= ~OCFS2_MOUNT_NOUSERXATTR;
+			break;
+		case Opt_nouser_xattr:
+			mopt->mount_opt |= OCFS2_MOUNT_NOUSERXATTR;
+			break;
 		case Opt_atime_quantum:
 			if (match_int(&args[0], &option)) {
 				status = 0;
@@ -1375,6 +1386,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
 	sb->s_fs_info = osb;
 	sb->s_op = &ocfs2_sops;
 	sb->s_export_op = &ocfs2_export_ops;
+	sb->s_xattr = ocfs2_xattr_handlers;
 	sb->s_time_gran = 1;
 	sb->s_flags |= MS_NOATIME;
 	/* this is needed to support O_LARGEFILE */
diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index c223ab0..ed07448 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -21,6 +21,19 @@
  * Boston, MA 021110-1307, USA.
  */
 
+#include <linux/capability.h>
+#include <linux/fs.h>
+#include <linux/types.h>
+#include <linux/slab.h>
+#include <linux/highmem.h>
+#include <linux/pagemap.h>
+#include <linux/uio.h>
+#include <linux/sched.h>
+#include <linux/splice.h>
+#include <linux/mount.h>
+#include <linux/writeback.h>
+#include <linux/falloc.h>
+
 #define MLOG_MASK_PREFIX ML_INODE
 #include <cluster/masklog.h>
 
@@ -28,6 +41,7 @@
 #include "alloc.h"
 #include "dlmglue.h"
 #include "file.h"
+#include "sysfile.h"
 #include "inode.h"
 #include "journal.h"
 #include "ocfs2_fs.h"
@@ -36,6 +50,129 @@
 #include "buffer_head_io.h"
 #include "xattr.h"
 
+
+#define OCFS2_XATTR_PAD_BITS	2
+#define OCFS2_XATTR_PAD		4
+#define OCFS2_XATTR_ROUND	(OCFS2_XATTR_PAD-1)
+#define OCFS2_XATTR_SIZE(size)	(((size) + OCFS2_XATTR_ROUND) & \
+				~OCFS2_XATTR_ROUND)
+#define OCFS2_XATTR_ROOT_SIZE	(sizeof(struct ocfs2_xattr_def_value_root))
+#define OCFS2_XATTR_INLINE_SIZE	80
+#define OCFS2_NAME_HASH_SHIFT	5
+#define OCFS2_VALUE_HASH_SHIFT	16
+
+static struct ocfs2_xattr_def_value_root def_xv = {
+	.xv.xr_list.l_count = cpu_to_le16(1),
+};
+
+struct xattr_handler *ocfs2_xattr_handlers[] = {
+	&ocfs2_xattr_user_handler,
+#ifdef CONFIG_OCFS2_FS_POSIX_ACL
+	&ocfs2_xattr_acl_access_handler,
+	&ocfs2_xattr_acl_default_handler,
+#endif
+	&ocfs2_xattr_trusted_handler,
+#ifdef CONFIG_OCFS2_FS_LUSTRE
+	&ocfs2_xattr_lustre_handler,
+#endif
+#ifdef CONFIG_OCFS2_FS_SECURITY
+	&ocfs2_xattr_security_handler,
+#endif
+	NULL
+};
+
+static struct xattr_handler *ocfs2_xattr_handler_map[] = {
+	[OCFS2_XATTR_INDEX_USER]	= &ocfs2_xattr_user_handler,
+#ifdef CONFIG_OCFS2_FS_POSIX_ACL
+	[OCFS2_XATTR_INDEX_POSIX_ACL_ACCESS]
+					= &ocfs2_xattr_acl_access_handler,
+	[OCFS2_XATTR_INDEX_POSIX_ACL_DEFAULT]
+					= &ocfs2_xattr_acl_default_handler,
+#endif
+	[OCFS2_XATTR_INDEX_TRUSTED]	= &ocfs2_xattr_trusted_handler,
+#ifdef CONFIG_OCFS2_FS_LUSTRE
+	[OCFS2_XATTR_INDEX_LUSTRE]	= &ocfs2_xattr_lustre_handler,
+#endif
+#ifdef CONFIG_OCFS2_FS_SECURITY
+	[OCFS2_XATTR_INDEX_SECURITY]	= &ocfs2_xattr_security_handler,
+#endif
+};
+
+struct ocfs2_xattr_info {
+	int name_index;
+	const char *name;
+	const void *value;
+	size_t value_len;
+};
+
+struct ocfs2_xattr_search {
+	struct buffer_head *inode_bh;
+	struct buffer_head *xattr_bh;
+	struct ocfs2_xattr_header *header;
+	void *base;
+	void *end;
+	struct ocfs2_xattr_entry *here;
+	int not_found;
+};
+
+static inline u32 ocfs2_blocks_per_cluster(struct super_block *sb)
+{
+	return 1 << (OCFS2_SB(sb)->s_clustersize_bits - sb->s_blocksize_bits);
+}
+
+static inline struct xattr_handler *ocfs2_xattr_handler(int name_index)
+{
+	struct xattr_handler *handler = NULL;
+
+	if (name_index > 0 && name_index < OCFS2_XATTR_MAX)
+		handler = ocfs2_xattr_handler_map[name_index];
+
+	return handler;
+}
+
+static inline __u32 ocfs2_xattr_name_hash(char *prefix,
+					  int prefix_len,
+					  char *name,
+					  int name_len)
+{
+	__u32 hash = 0;
+	int i;
+
+	for (i = 0; i < prefix_len; i++) {
+		hash = (hash << OCFS2_NAME_HASH_SHIFT) ^
+		       (hash >> (8*sizeof(hash) - OCFS2_NAME_HASH_SHIFT)) ^
+		       *prefix++;
+	}
+
+	for (i = 0; i < name_len; i++) {
+		hash = (hash << OCFS2_NAME_HASH_SHIFT) ^
+		       (hash >> (8*sizeof(hash) - OCFS2_NAME_HASH_SHIFT)) ^
+		       *name++;
+	}
+	return hash;
+}
+
+/*
+ * ocfs2_xattr_hash_entry()
+ *
+ * Compute the hash of an extended attribute.
+ */
+static void ocfs2_xattr_hash_entry(struct ocfs2_xattr_header *header,
+				   struct ocfs2_xattr_entry *entry)
+{
+	__u32 hash = 0;
+	struct xattr_handler *handler = ocfs2_xattr_handler(entry->xe_type);
+	char *prefix = handler->prefix;
+	char *name = (char *)header + le16_to_cpu(entry->xe_name_offset);
+	int prefix_len = strlen(handler->prefix);
+
+	hash = ocfs2_xattr_name_hash(prefix, prefix_len, name,
+				     entry->xe_name_len);
+	entry->xe_name_hash = cpu_to_le32(hash);
+
+	return;
+}
+
 static int ocfs2_xattr_extend_allocation(struct inode *inode,
 					 u32 clusters_to_add,
 					 struct buffer_head *xattr_bh,
@@ -50,7 +187,7 @@ static int ocfs2_xattr_extend_allocation(struct inode *inode,
 	enum ocfs2_alloc_restarted why;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	struct ocfs2_extent_list *root_el = &xv->xr_list;
-	u32 logical_start = le16_to_cpu(xv->xr_clusters);
+	u32 logical_start = le32_to_cpu(xv->xr_clusters);
 
 	mlog(0, "(clusters_to_add for xattr= %u)\n", clusters_to_add);
 
@@ -155,7 +292,9 @@ leave:
 static int __ocfs2_remove_xattr_range(struct inode *inode,
 				      struct buffer_head *root_bh,
 				      struct ocfs2_xattr_value_root *xv,
-				      u32 cpos, u32 phys_cpos, u32 len,
+				      u32 cpos,
+				      u32 phys_cpos,
+				      u32 len,
 				      struct ocfs2_cached_dealloc_ctxt *dealloc)
 {
 	int ret;
@@ -184,9 +323,8 @@ static int __ocfs2_remove_xattr_range(struct inode *inode,
 	}
 
 	handle = ocfs2_start_trans(osb, OCFS2_REMOVE_EXTENT_CREDITS);
-	if (handle == NULL) {
-		ret = -ENOMEM;
-		mlog_errno(ret);
+	if (IS_ERR(handle)) {
+		ret = PTR_ERR(handle);
 		goto out;
 	}
 
@@ -194,7 +332,7 @@ static int __ocfs2_remove_xattr_range(struct inode *inode,
 				   OCFS2_JOURNAL_ACCESS_WRITE);
 	if (ret) {
 		mlog_errno(ret);
-		goto out;
+		goto out_commit;
 	}
 
 	ret = ocfs2_remove_extent(inode, root_bh, cpos, len, handle, meta_ac,
@@ -299,3 +437,1195 @@ static int ocfs2_xattr_value_truncate(struct inode *inode,
 
 	return ret;
 }
+
+static int ocfs2_xattr_list_entries(struct inode *inode,
+				    struct ocfs2_xattr_header *header,
+				    char *buffer, size_t buffer_size)
+{
+	size_t rest = buffer_size;
+	struct ocfs2_xattr_entry *entry;
+	struct xattr_handler *handler = NULL;
+	int i;
+
+	entry = header->xh_entries;
+	for (i = 0 ; i < le16_to_cpu(header->xh_count); i++) {
+		handler = ocfs2_xattr_handler(entry->xe_type);
+
+		if (handler) {
+			size_t size = handler->list(inode, buffer, rest,
+					((char *)header +
+					le16_to_cpu(entry->xe_name_offset)),
+					entry->xe_name_len);
+			if (buffer) {
+				if (size > rest)
+					return -ERANGE;
+				buffer += size;
+			}
+			rest -= size;
+		}
+		entry += 1;
+	}
+
+	return buffer_size - rest;
+}
+
+static int ocfs2_xattr_ibody_list(struct inode *inode,
+				  struct ocfs2_dinode *di,
+				  char *buffer,
+				  size_t buffer_size)
+{
+	struct ocfs2_xattr_header *header = NULL;
+	int ret = 0;
+
+	if (!(le16_to_cpu(di->i_dyn_features) & OCFS2_INLINE_XATTR_FL))
+		return ret;
+	header = (struct ocfs2_xattr_header *)
+		 ((void *)di + inode->i_sb->s_blocksize -
+		 OCFS2_MAX_XATTR_INLINE_SIZE);
+	ret = ocfs2_xattr_list_entries(inode, header, buffer, buffer_size);
+
+	return ret;
+}
+
+static int ocfs2_xattr_block_list(struct inode *inode,
+				  struct ocfs2_dinode *di,
+				  char *buffer,
+				  size_t buffer_size)
+{
+	struct buffer_head *blk_bh = NULL;
+	struct ocfs2_xattr_header *header = NULL;
+	int ret = 0;
+
+	if (!di->i_xattr_loc)
+		return ret;
+	else {
+		ret = ocfs2_read_block(OCFS2_SB(inode->i_sb),
+				       le64_to_cpu(di->i_xattr_loc),
+				       &blk_bh, OCFS2_BH_CACHED, inode);
+		if (ret)
+			return ret;
+	}
+
+	header = &((struct ocfs2_xattr_block *)blk_bh->b_data)->
+		 xb_attrs.xb_header;
+	ret = ocfs2_xattr_list_entries(inode, header, buffer, buffer_size);
+
+	if (blk_bh)
+		brelse(blk_bh);
+	return ret;
+}
+
+ssize_t ocfs2_listxattr(struct dentry *dentry,
+			char *buffer,
+			size_t size)
+{
+	int ret, i_ret, b_ret;
+	struct buffer_head *di_bh = NULL;
+	struct ocfs2_dinode *di = NULL;
+
+	ret = ocfs2_inode_lock(dentry->d_inode, &di_bh, 0);
+	if (ret < 0) {
+		mlog_errno(ret);
+		return ret;
+	}
+
+	di = (struct ocfs2_dinode *)di_bh->b_data;
+	if (!(le16_to_cpu(di->i_dyn_features) & OCFS2_HAS_XATTR_FL))
+		return 0;
+
+	i_ret = ocfs2_xattr_ibody_list(dentry->d_inode, di, buffer, size);
+	if (i_ret < 0)
+		b_ret = 0;
+	else {
+		if (buffer) {
+			buffer += i_ret;
+			size -= i_ret;
+		}
+		b_ret = ocfs2_xattr_block_list(dentry->d_inode, di,
+					       buffer, size);
+		if (b_ret < 0)
+			i_ret = 0;
+	}
+	ocfs2_inode_unlock(dentry->d_inode, 0);
+
+	if (di_bh)
+		brelse(di_bh);
+
+	return (i_ret + b_ret);
+}
+
+static int ocfs2_xattr_find_entry(int name_index,
+				  const char *name,
+				  struct ocfs2_xattr_search *xs)
+{
+	struct ocfs2_xattr_entry *entry;
+	size_t name_len;
+	int i, cmp = 1;
+
+	if (name == NULL)
+		return -EINVAL;
+	name_len = strlen(name);
+	entry = xs->here;
+	for (i = 0; i < le16_to_cpu(xs->header->xh_count); i++) {
+		cmp = name_index - entry->xe_type;
+		if (!cmp)
+			cmp = name_len - entry->xe_name_len;
+		if (!cmp)
+			cmp = memcmp(name, (xs->base +
+				     le16_to_cpu(entry->xe_name_offset)),
+				     name_len);
+		if (cmp == 0)
+			break;
+		entry += 1;
+	}
+	xs->here = entry;
+
+	return cmp ? -ENODATA : 0;
+}
+
+static int ocfs2_xattr_get_value_outside(struct inode *inode,
+					 struct ocfs2_xattr_search *xs,
+					 void *buffer,
+					 size_t len)
+{
+	u32 cpos, p_cluster, num_clusters, bpc, clusters;
+	u64 blkno;
+	int i, ret = 0;
+	size_t cplen, blocksize;
+	struct buffer_head *bh = NULL;
+	struct ocfs2_xattr_value_root *xv;
+	struct ocfs2_extent_list *el;
+
+	xv = (struct ocfs2_xattr_value_root *)
+		(xs->base + le16_to_cpu(xs->here->xe_name_offset) +
+		OCFS2_XATTR_SIZE(xs->here->xe_name_len));
+	el = &xv->xr_list;
+	clusters = le32_to_cpu(xv->xr_clusters);
+	bpc = ocfs2_blocks_per_cluster(inode->i_sb);
+	blocksize = inode->i_sb->s_blocksize;
+
+	cpos = 0;
+	while (cpos < clusters) {
+		ret = ocfs2_xattr_get_clusters(inode, cpos, &p_cluster,
+					       &num_clusters, el);
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
+
+		blkno = ocfs2_clusters_to_blocks(inode->i_sb, p_cluster);
+		/* copy ocfs2_xattr_value */
+		for (i = 0; i < num_clusters * bpc; i++, blkno++) {
+			ret = ocfs2_read_block(OCFS2_SB(inode->i_sb), blkno,
+					       &bh, OCFS2_BH_CACHED, inode);
+			if (ret) {
+				mlog_errno(ret);
+				goto out;
+			}
+
+			cplen = len >= blocksize ? blocksize : len;
+			memcpy(buffer, bh->b_data, cplen);
+			len -= cplen;
+			buffer += cplen;
+
+			brelse(bh);
+			bh = NULL;
+			if (len == 0)
+				break;
+		}
+		cpos += num_clusters;
+	}
+out:
+	return ret;
+}
+
+static int ocfs2_xattr_ibody_get(struct inode *inode,
+				 int name_index,
+				 const char *name,
+				 void *buffer,
+				 size_t buffer_size,
+				 struct ocfs2_xattr_search *xs)
+{
+	struct ocfs2_dinode *di = (struct ocfs2_dinode *)xs->inode_bh->b_data;
+	size_t size;
+	int ret = 0;
+
+	if (!(le16_to_cpu(di->i_dyn_features) & OCFS2_INLINE_XATTR_FL))
+		return -ENODATA;
+
+	xs->end = (void *)di + inode->i_sb->s_blocksize;
+	xs->header = (struct ocfs2_xattr_header *)
+			(xs->end - OCFS2_MAX_XATTR_INLINE_SIZE);
+	xs->base = (void *)xs->header;
+	xs->here = xs->header->xh_entries;
+
+	ret = ocfs2_xattr_find_entry(name_index, name, xs);
+	if (ret)
+		return ret;
+	size = le64_to_cpu(xs->here->xe_value_size);
+	if (buffer) {
+		if (size > buffer_size)
+			return -ERANGE;
+		if (xs->here->xe_local) {
+			memcpy(buffer, (void *)xs->base +
+			       le16_to_cpu(xs->here->xe_name_offset) +
+			       OCFS2_XATTR_SIZE(xs->here->xe_name_len), size);
+		} else {
+			ret = ocfs2_xattr_get_value_outside(inode, xs,
+							    buffer, size);
+			if (ret)
+				return ret;
+		}
+	}
+	return size;
+}
+
+static int ocfs2_xattr_block_get(struct inode *inode,
+				 int name_index,
+				 const char *name,
+				 void *buffer,
+				 size_t buffer_size,
+				 struct ocfs2_xattr_search *xs)
+{
+	struct ocfs2_dinode *di = (struct ocfs2_dinode *)xs->inode_bh->b_data;
+	struct buffer_head *blk_bh = NULL;
+	size_t size;
+	int ret = -ENODATA;
+
+	if (!di->i_xattr_loc)
+		return ret;
+	else {
+		struct ocfs2_xattr_block *xb;
+
+		ret = ocfs2_read_block(OCFS2_SB(inode->i_sb),
+				       le64_to_cpu(di->i_xattr_loc),
+				       &blk_bh, OCFS2_BH_CACHED, inode);
+		if (ret)
+			goto cleanup;
+		xs->xattr_bh = blk_bh;
+		xb = (struct ocfs2_xattr_block *)blk_bh->b_data;
+		xs->header = &xb->xb_attrs.xb_header;
+		xs->base = (void *)xs->header;
+		xs->end = (void *)(blk_bh->b_data) + blk_bh->b_size;
+		xs->here = xs->header->xh_entries;
+	}
+
+	ret = ocfs2_xattr_find_entry(name_index, name, xs);
+	if (ret)
+		goto cleanup;
+	size = le64_to_cpu(xs->here->xe_value_size);
+	if (buffer) {
+		ret = -ERANGE;
+		if (size > buffer_size)
+			goto cleanup;
+		if (xs->here->xe_local) {
+			memcpy(buffer, (void *)xs->base +
+			       le16_to_cpu(xs->here->xe_name_offset) +
+			       OCFS2_XATTR_SIZE(xs->here->xe_name_len), size);
+		} else {
+			ret = ocfs2_xattr_get_value_outside(inode, xs,
+							    buffer, size);
+			if (ret)
+				goto cleanup;
+		}
+	}
+	ret = size;
+cleanup:
+	if (blk_bh)
+		brelse(blk_bh);
+	return ret;
+}
+
+int ocfs2_xattr_get(struct inode *inode,
+		    int name_index,
+		    const char *name,
+		    void *buffer,
+		    size_t buffer_size)
+{
+	int ret;
+	struct ocfs2_dinode *di = NULL;
+	struct buffer_head *di_bh = NULL;
+	struct ocfs2_xattr_search xis = {
+		.not_found = -ENODATA,
+	};
+	struct ocfs2_xattr_search xbs = {
+		.not_found = -ENODATA,
+	};
+
+	ret = ocfs2_inode_lock(inode, &di_bh, 0);
+	if (ret < 0) {
+		mlog_errno(ret);
+		return ret;
+	}
+	xis.inode_bh = xbs.inode_bh = di_bh;
+	di = (struct ocfs2_dinode *)di_bh->b_data;
+	if (!(le16_to_cpu(di->i_dyn_features) & OCFS2_HAS_XATTR_FL)) {
+		ret = -ENODATA;
+		goto cleanup;
+	}
+
+	ret = ocfs2_xattr_ibody_get(inode, name_index, name, buffer,
+				    buffer_size, &xis);
+	if (ret == -ENODATA)
+		ret = ocfs2_xattr_block_get(inode, name_index, name, buffer,
+					    buffer_size, &xbs);
+cleanup:
+	ocfs2_inode_unlock(inode, 0);
+
+	if (di_bh)
+		brelse(di_bh);
+	return ret;
+}
+
+static int __ocfs2_xattr_set_value_outside(struct inode *inode,
+					   struct ocfs2_xattr_value_root *xv,
+					   const void *value,
+					   int value_len)
+{
+	int ret = 0, i, cp_len, credits;
+	u16 blocksize = inode->i_sb->s_blocksize;
+	u32 p_cluster, num_clusters;
+	u32 cpos = 0, bpc = ocfs2_clusters_to_blocks(inode->i_sb, 1);
+	u32 clusters = ocfs2_clusters_for_bytes(inode->i_sb, value_len);
+	u64 blkno;
+	struct buffer_head *bh = NULL;
+	handle_t *handle;
+
+	BUG_ON(clusters > le32_to_cpu(xv->xr_clusters));
+
+	credits = clusters * bpc;
+	handle = ocfs2_start_trans(OCFS2_SB(inode->i_sb), credits);
+	if (IS_ERR(handle)) {
+		ret = PTR_ERR(handle);
+		goto out;
+	}
+
+	while (cpos < clusters) {
+		ret = ocfs2_xattr_get_clusters(inode, cpos, &p_cluster,
+					       &num_clusters, &xv->xr_list);
+		if (ret) {
+			mlog_errno(ret);
+			goto out_commit;
+		}
+
+		blkno = ocfs2_clusters_to_blocks(inode->i_sb, p_cluster);
+
+		for (i = 0; i < num_clusters * bpc; i++, blkno++) {
+			ret = ocfs2_read_block(OCFS2_SB(inode->i_sb), blkno,
+					       &bh, OCFS2_BH_CACHED, inode);
+			if (ret) {
+				mlog_errno(ret);
+				goto out_commit;
+			}
+
+			ret = ocfs2_journal_access(handle,
+						   inode,
+						   bh,
+						   OCFS2_JOURNAL_ACCESS_WRITE);
+			if (ret < 0) {
+				mlog_errno(ret);
+				goto out_commit;
+			}
+
+			cp_len = value_len > blocksize ? blocksize : value_len;
+			memcpy(bh->b_data, value, cp_len);
+			value_len -= cp_len;
+			value += cp_len;
+			if (cp_len < blocksize)
+				memset(bh->b_data + cp_len, 0,
+				       blocksize - cp_len);
+
+			ocfs2_journal_dirty(handle, bh);
+			brelse(bh);
+			bh = NULL;
+
+			/*
+			 * XXX: do we need to empty all the following
+			 * blocks in this cluster?
+			 */
+			if (!value_len)
+				break;
+		}
+
+		cpos += num_clusters;
+	}
+out_commit:
+	ocfs2_commit_trans(OCFS2_SB(inode->i_sb), handle);
+out:
+	if (bh)
+		brelse(bh);
+	return ret;
+}
+
+static inline int ocfs2_xattr_update_entry(struct inode *inode,
+					   struct ocfs2_xattr_info *xi,
+					   struct ocfs2_xattr_search *xs,
+					   size_t offs)
+{
+	handle_t *handle = NULL;
+	int ret = 0;
+
+	handle = ocfs2_start_trans((OCFS2_SB(inode->i_sb)),
+				   OCFS2_INODE_UPDATE_CREDITS);
+	if (IS_ERR(handle)) {
+		ret = PTR_ERR(handle);
+		goto out;
+	}
+	ret = ocfs2_journal_access(handle, inode, xs->xattr_bh,
+				   OCFS2_JOURNAL_ACCESS_WRITE);
+	if (ret) {
+		mlog_errno(ret);
+		goto out_commit;
+	}
+
+	xs->here->xe_name_offset = cpu_to_le16(offs);
+	xs->here->xe_value_size = cpu_to_le64(xi->value_len);
+	if (le64_to_cpu(xs->here->xe_value_size) <= OCFS2_XATTR_INLINE_SIZE)
+		xs->here->xe_local = 1;
+	else
+		xs->here->xe_local = 0;
+	ocfs2_xattr_hash_entry(xs->header, xs->here);
+
+	ret = ocfs2_journal_dirty(handle, xs->xattr_bh);
+	if (ret < 0)
+		mlog_errno(ret);
+out_commit:
+	ocfs2_commit_trans(OCFS2_SB(inode->i_sb), handle);
+out:
+	return ret;
+}
+
+static int ocfs2_xattr_set_value_outside(struct inode *inode,
+					 struct ocfs2_xattr_info *xi,
+					 struct ocfs2_xattr_search *xs,
+					 size_t offs)
+{
+	size_t name_len = strlen(xi->name);
+	void *val = xs->base + offs;
+	struct ocfs2_xattr_value_root *xv = NULL;
+	size_t size = OCFS2_XATTR_SIZE(name_len) + OCFS2_XATTR_ROOT_SIZE;
+	int ret = 0;
+
+	/* Clear bytes. */
+	memset(val, 0, size);
+	memcpy(val, xi->name, name_len);
+	xv = (struct ocfs2_xattr_value_root *)
+		(val + OCFS2_XATTR_SIZE(name_len));
+	xv->xr_clusters = 0;
+	xv->xr_last_eb_blk = 0;
+	xv->xr_list.l_tree_depth = 0;
+	xv->xr_list.l_count = cpu_to_le16(1);
+	xv->xr_list.l_next_free_rec = 0;
+
+	ret = ocfs2_xattr_value_truncate(inode, xs->xattr_bh, xv,
+					 xi->value_len);
+	if (ret < 0) {
+		mlog_errno(ret);
+		return ret;
+	}
+	ret = __ocfs2_xattr_set_value_outside(inode, xv, xi->value,
+					      xi->value_len);
+	if (ret < 0) {
+		mlog_errno(ret);
+		return ret;
+	}
+	ret = ocfs2_xattr_update_entry(inode, xi, xs, offs);
+
+	return ret;
+}
+
+
+
+static void ocfs2_xattr_set_entry_local(struct inode *inode,
+					struct ocfs2_xattr_info *xi,
+					struct ocfs2_xattr_search *xs,
+					struct ocfs2_xattr_entry *last,
+					size_t min_offs)
+{
+	size_t name_len = strlen(xi->name);
+	int i;
+
+	if (xi->value && xs->not_found) {
+		/* Insert the new xattr entry. */
+		le16_add_cpu(&xs->header->xh_count, 1);
+		last->xe_type = xi->name_index;
+		if (xi->value_len <= OCFS2_XATTR_INLINE_SIZE)
+			last->xe_local = 1;
+		else
+			last->xe_local = 0;
+		last->xe_name_len = name_len;
+	} else {
+		void *first_val;
+		void *val;
+		size_t offs, size;
+
+		first_val = xs->base + min_offs;
+		offs = le16_to_cpu(xs->here->xe_name_offset);
+		val = xs->base + offs;
+
+		if (le64_to_cpu(xs->here->xe_value_size) >
+		    OCFS2_XATTR_INLINE_SIZE)
+			size = OCFS2_XATTR_SIZE(name_len) +
+				OCFS2_XATTR_ROOT_SIZE;
+		else
+			size = OCFS2_XATTR_SIZE(name_len) +
+			OCFS2_XATTR_SIZE(le64_to_cpu(xs->here->xe_value_size));
+
+		if (xi->value && size == OCFS2_XATTR_SIZE(name_len) +
+				OCFS2_XATTR_SIZE(xi->value_len)) {
+			/* The old and the new value have the
+			   same size. Just replace the value. */
+			xs->here->xe_local = 1;
+			xs->here->xe_value_size = cpu_to_le64(xi->value_len);
+			/* Clear value bytes. */
+			memset(val + OCFS2_XATTR_SIZE(name_len),
+			       0,
+			       OCFS2_XATTR_SIZE(xi->value_len));
+			memcpy(val + OCFS2_XATTR_SIZE(name_len),
+			       xi->value,
+			       xi->value_len);
+			return;
+		}
+		/* Remove the old name+value. */
+		memmove(first_val + size, first_val, val - first_val);
+		memset(first_val, 0, size);
+		xs->here->xe_name_hash = 0;
+		xs->here->xe_name_offset = 0;
+		xs->here->xe_local = 0;
+		xs->here->xe_value_size = 0;
+
+		min_offs += size;
+
+		/* Adjust all value offsets. */
+		last = xs->header->xh_entries;
+		for (i = 0 ; i < le16_to_cpu(xs->header->xh_count); i++) {
+			size_t o = le16_to_cpu(last->xe_name_offset);
+			if (last->xe_value_size && o < offs)
+				last->xe_name_offset = cpu_to_le16(o + size);
+			last += 1;
+		}
+
+		if (!xi->value) {
+			/* Remove the old entry. */
+			last -= 1;
+			memmove(xs->here, xs->here + 1,
+				(void *)last - (void *)xs->here);
+			memset(last, 0, sizeof(struct ocfs2_xattr_entry));
+			le16_add_cpu(&xs->header->xh_count, -1);
+		}
+	}
+	if (xi->value) {
+		/* Insert the new name+value. */
+		size_t size = OCFS2_XATTR_SIZE(name_len) +
+				OCFS2_XATTR_SIZE(xi->value_len);
+		void *val = xs->base + min_offs - size;
+		xs->here->xe_name_offset = cpu_to_le16(min_offs - size);
+		/* Clear bytes. */
+		memset(val, 0, size);
+		memcpy(val, xi->name, name_len);
+		memcpy(val + OCFS2_XATTR_SIZE(name_len),
+		       xi->value,
+		       xi->value_len);
+		xs->here->xe_value_size = cpu_to_le64(xi->value_len);
+		xs->here->xe_local = 1;
+		ocfs2_xattr_hash_entry(xs->header, xs->here);
+	}
+	return;
+}
+
+
+static int ocfs2_xattr_set_entry(struct inode *inode,
+				 struct ocfs2_xattr_info *xi,
+				 struct ocfs2_xattr_search *xs)
+{
+	struct ocfs2_xattr_entry *last;
+	size_t free, min_offs = xs->end - xs->base, name_len = strlen(xi->name);
+	size_t size_l = 0;
+	handle_t *handle = NULL;
+	int i, ret;
+	struct ocfs2_xattr_info xi_l = {
+		.name_index = xi->name_index,
+		.name = xi->name,
+		.value = xi->value,
+		.value_len = xi->value_len,
+	};
+
+	/* Compute min_offs and last. */
+	last = xs->header->xh_entries;
+
+	for (i = 0 ; i < le16_to_cpu(xs->header->xh_count); i++) {
+		size_t offs = le16_to_cpu(last->xe_name_offset);
+		if (offs < min_offs)
+			min_offs = offs;
+		last += 1;
+	}
+
+	free = min_offs - ((void *)last - xs->base) - sizeof(__u32);
+
+	if (!xs->not_found) {
+		size_t size = 0;
+		if (xs->here->xe_local)
+			size = OCFS2_XATTR_SIZE(name_len) +
+			OCFS2_XATTR_SIZE(le64_to_cpu(xs->here->xe_value_size));
+		else
+			size = OCFS2_XATTR_SIZE(name_len) +
+				OCFS2_XATTR_ROOT_SIZE;
+		free += (size + sizeof(struct ocfs2_xattr_entry));
+	}
+	if (xi->value && xi->value_len > OCFS2_XATTR_INLINE_SIZE) {
+		if (free < sizeof(struct ocfs2_xattr_entry) +
+			   OCFS2_XATTR_SIZE(name_len) +
+			   OCFS2_XATTR_ROOT_SIZE) {
+			ret = -ENOSPC;
+			goto out;
+		}
+		size_l = OCFS2_XATTR_SIZE(name_len) + OCFS2_XATTR_ROOT_SIZE;
+		xi_l.value = (void *)&def_xv;
+		xi_l.value_len = OCFS2_XATTR_ROOT_SIZE;
+	} else if (xi->value) {
+		if (free < sizeof(struct ocfs2_xattr_entry) +
+			   OCFS2_XATTR_SIZE(name_len) +
+			   OCFS2_XATTR_SIZE(xi->value_len)) {
+			ret = -ENOSPC;
+			goto out;
+		}
+	}
+
+	if (!xs->not_found) {
+		size_t size = OCFS2_XATTR_SIZE(name_len) +
+			OCFS2_XATTR_SIZE(le64_to_cpu(xs->here->xe_value_size));
+		size_t offs = le16_to_cpu(xs->here->xe_name_offset);
+		void *val = xs->base + offs;
+
+		if (xs->here->xe_local && size == size_l) {
+			ret = ocfs2_xattr_set_value_outside(inode, xi, xs,
+							    offs);
+			goto out;
+		} else if (!xs->here->xe_local) {
+			struct ocfs2_xattr_value_root *xv = NULL;
+			xv = (struct ocfs2_xattr_value_root *)(val +
+				OCFS2_XATTR_SIZE(name_len));
+
+			if (xi->value_len > OCFS2_XATTR_INLINE_SIZE) {
+				ret = ocfs2_xattr_value_truncate(inode,
+								 xs->xattr_bh,
+								 xv,
+								 xi->value_len);
+				if (ret < 0)
+					goto out;
+
+				ret = __ocfs2_xattr_set_value_outside(inode,
+								xv,
+								xi->value,
+								xi->value_len);
+				if (ret < 0)
+					goto out;
+
+				ret = ocfs2_xattr_update_entry(inode,
+							       xi,
+							       xs,
+							       offs);
+				goto out;
+			} else
+				ret = ocfs2_xattr_value_truncate(inode,
+								 xs->xattr_bh,
+								 xv,
+								 0);
+		}
+	}
+
+	handle = ocfs2_start_trans((OCFS2_SB(inode->i_sb)),
+				   OCFS2_INODE_UPDATE_CREDITS);
+	if (IS_ERR(handle)) {
+		ret = PTR_ERR(handle);
+		goto out;
+	}
+
+	ret = ocfs2_journal_access(handle, inode, xs->xattr_bh,
+				   OCFS2_JOURNAL_ACCESS_WRITE);
+	if (ret) {
+		mlog_errno(ret);
+		goto out_commit;
+	}
+
+	ocfs2_xattr_set_entry_local(inode, &xi_l, xs, last, min_offs);
+
+	ret = ocfs2_journal_dirty(handle, xs->xattr_bh);
+	if (ret < 0)
+		mlog_errno(ret);
+
+out_commit:
+	ocfs2_commit_trans(OCFS2_SB(inode->i_sb), handle);
+
+	if (xi->value_len > OCFS2_XATTR_INLINE_SIZE) {
+		size_t offs = le16_to_cpu(xs->here->xe_name_offset);
+		ret = ocfs2_xattr_set_value_outside(inode, xi, xs, offs);
+	}
+
+out:
+	mlog_exit(ret);
+	return ret;
+
+}
+
+static int ocfs2_xattr_free_block(handle_t *handle,
+				  struct ocfs2_super *osb,
+				  struct ocfs2_xattr_block *xb)
+{
+	struct inode *xb_alloc_inode;
+	struct buffer_head *xb_alloc_bh = NULL;
+	u64 blk = le64_to_cpu(xb->xb_blkno);
+	u16 bit = le16_to_cpu(xb->xb_suballoc_bit);
+	u64 bg_blkno = ocfs2_which_suballoc_group(blk, bit);
+	int ret = 0;
+
+	xb_alloc_inode = ocfs2_get_system_file_inode(osb,
+				EXTENT_ALLOC_SYSTEM_INODE,
+				le16_to_cpu(xb->xb_suballoc_slot));
+	if (!xb_alloc_inode) {
+		ret = -ENOMEM;
+		mlog_errno(ret);
+		goto out;
+	}
+	mutex_lock(&xb_alloc_inode->i_mutex);
+
+	ret = ocfs2_inode_lock(xb_alloc_inode, &xb_alloc_bh, 1);
+	if (ret < 0) {
+		mlog_errno(ret);
+		goto out_mutex;
+	}
+	ret = ocfs2_extend_trans(handle, OCFS2_SUBALLOC_FREE);
+	if (ret < 0) {
+		mlog_errno(ret);
+		goto out_unlock;
+	}
+	ret = ocfs2_free_suballoc_bits(handle, xb_alloc_inode, xb_alloc_bh,
+				       bit, bg_blkno, 1);
+	if (ret < 0)
+		mlog_errno(ret);
+out_unlock:
+	ocfs2_inode_unlock(xb_alloc_inode, 1);
+	if (xb_alloc_bh)
+		brelse(xb_alloc_bh);
+out_mutex:
+	mutex_unlock(&xb_alloc_inode->i_mutex);
+	iput(xb_alloc_inode);
+out:
+	return ret;
+}
+
+static int ocfs2_remove_value_outside(struct inode*inode,
+				      struct buffer_head *bh,
+				      struct ocfs2_xattr_header *header)
+{
+	struct ocfs2_xattr_entry *entry;
+	struct ocfs2_xattr_value_root *xv;
+	void *val;
+	int ret = 0, i;
+
+	entry = header->xh_entries;
+	for (i = 0; i < le16_to_cpu(header->xh_count); i++) {
+		if (!entry->xe_local) {
+			val = (void *)header +
+				le16_to_cpu(entry->xe_name_offset);
+			xv = (struct ocfs2_xattr_value_root *)(val +
+				OCFS2_XATTR_SIZE(entry->xe_name_len));
+			ret = ocfs2_xattr_value_truncate(inode, bh, xv, 0);
+		}
+	}
+	return ret;
+}
+
+static int ocfs2_xattr_ibody_remove(struct inode *inode,
+				    struct buffer_head *di_bh)
+{
+
+	struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
+	struct ocfs2_xattr_header *header;
+	int ret;
+
+	header = (struct ocfs2_xattr_header *)
+		 ((void *)di + inode->i_sb->s_blocksize -
+		 OCFS2_MAX_XATTR_INLINE_SIZE);
+	ret = ocfs2_remove_value_outside(inode, di_bh, header);
+	return ret;
+}
+
+static int ocfs2_xattr_block_remove(struct inode *inode,
+				    struct buffer_head *blk_bh)
+{
+	struct ocfs2_xattr_block *xb;
+	struct ocfs2_xattr_header *header;
+	int ret = 0;
+
+	xb = (struct ocfs2_xattr_block *)blk_bh->b_data;
+	header = &(xb->xb_attrs.xb_header);
+
+	ret = ocfs2_remove_value_outside(inode, blk_bh, header);
+
+	return ret;
+}
+
+/*
+ * ocfs2_xattr_remove()
+ *
+ * Free extended attribute resources associated with this inode.
+ */
+int ocfs2_xattr_remove(struct inode *inode, struct buffer_head *di_bh)
+{
+	struct ocfs2_xattr_block *xb;
+	struct buffer_head *blk_bh = NULL;
+	struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	handle_t *handle;
+	int ret;
+
+	if (!(le16_to_cpu(di->i_dyn_features) & OCFS2_HAS_XATTR_FL))
+		return 0;
+
+	if (le16_to_cpu(di->i_dyn_features) & OCFS2_INLINE_XATTR_FL) {
+		ret = ocfs2_xattr_ibody_remove(inode, di_bh);
+		if (ret < 0)
+			mlog_errno(ret);
+	}
+	if (di->i_xattr_loc) {
+		ret = ocfs2_read_block(OCFS2_SB(inode->i_sb),
+				       le64_to_cpu(di->i_xattr_loc),
+				       &blk_bh, OCFS2_BH_CACHED, inode);
+		if (ret)
+			return ret;
+		ret = ocfs2_xattr_block_remove(inode, blk_bh);
+		if (ret < 0)
+			mlog_errno(ret);
+	}
+
+	handle = ocfs2_start_trans((OCFS2_SB(inode->i_sb)),
+				   OCFS2_INODE_UPDATE_CREDITS);
+	if (IS_ERR(handle)) {
+		ret = PTR_ERR(handle);
+		goto out;
+	}
+	ret = ocfs2_journal_access(handle, inode, di_bh,
+				   OCFS2_JOURNAL_ACCESS_WRITE);
+	if (ret) {
+		mlog_errno(ret);
+		goto out_commit;
+	}
+
+	if (di->i_xattr_loc) {
+		xb = (struct ocfs2_xattr_block *)blk_bh->b_data;
+		ocfs2_xattr_free_block(handle, osb, xb);
+		di->i_xattr_loc = cpu_to_le64(0);
+	}
+
+	di->i_dyn_features = cpu_to_le16(le16_to_cpu(di->i_dyn_features) &
+					 !OCFS2_INLINE_XATTR_FL &
+					 !OCFS2_HAS_XATTR_FL);
+
+	ret = ocfs2_journal_dirty(handle, di_bh);
+	if (ret < 0)
+		mlog_errno(ret);
+out_commit:
+	ocfs2_commit_trans(OCFS2_SB(inode->i_sb), handle);
+out:
+	if (blk_bh)
+		brelse(blk_bh);
+	return ret;
+}
+
+static int ocfs2_xattr_update_flag(struct inode *inode,
+				   struct buffer_head *di_bh,
+				   int flag)
+{
+	struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
+	handle_t *handle = NULL;
+	int ret = 0;
+
+	handle = ocfs2_start_trans((OCFS2_SB(inode->i_sb)),
+				   OCFS2_INODE_UPDATE_CREDITS);
+	if (IS_ERR(handle)) {
+		ret = PTR_ERR(handle);
+		goto out;
+	}
+	ret = ocfs2_journal_access(handle, inode, di_bh,
+				   OCFS2_JOURNAL_ACCESS_WRITE);
+	if (ret) {
+		mlog_errno(ret);
+		goto out_commit;
+	}
+
+	di->i_dyn_features = cpu_to_le16(le16_to_cpu(di->i_dyn_features) |
+					 flag);
+	ret = ocfs2_journal_dirty(handle, di_bh);
+	if (ret < 0)
+		mlog_errno(ret);
+out_commit:
+	ocfs2_commit_trans(OCFS2_SB(inode->i_sb), handle);
+out:
+	return ret;
+}
+
+static int ocfs2_xattr_ibody_find(struct inode *inode,
+				  int name_index,
+				  const char *name,
+				  struct ocfs2_xattr_search *xs)
+{
+	struct ocfs2_dinode *di = (struct ocfs2_dinode *)xs->inode_bh->b_data;
+	int ret;
+
+	if (inode->i_sb->s_blocksize == OCFS2_MIN_BLOCKSIZE)
+		return 0;
+
+	xs->xattr_bh = xs->inode_bh;
+	xs->end = (void *)di + inode->i_sb->s_blocksize;
+	xs->header = (struct ocfs2_xattr_header *)
+			(xs->end - OCFS2_MAX_XATTR_INLINE_SIZE);
+	xs->base = (void *)xs->header;
+	xs->here = xs->header->xh_entries;
+
+	/* Find the named attribute. */
+	if (le16_to_cpu(di->i_dyn_features) & OCFS2_INLINE_XATTR_FL) {
+		ret = ocfs2_xattr_find_entry(name_index, name, xs);
+		if (ret && ret != -ENODATA)
+			return ret;
+		xs->not_found = ret;
+	}
+	return 0;
+}
+
+static int ocfs2_xattr_ibody_set(struct inode *inode,
+				 struct ocfs2_xattr_info *xi,
+				 struct ocfs2_xattr_search *xs)
+{
+	struct ocfs2_dinode *di = (struct ocfs2_dinode *)xs->inode_bh->b_data;
+	int ret;
+
+	if (inode->i_sb->s_blocksize == OCFS2_MIN_BLOCKSIZE)
+		return -ENOSPC;
+	ret = ocfs2_xattr_set_entry(inode, xi, xs);
+	if (!ret && !(le16_to_cpu(di->i_dyn_features) & OCFS2_INLINE_XATTR_FL))
+		ret = ocfs2_xattr_update_flag(inode,
+					      xs->inode_bh,
+					      (OCFS2_INLINE_XATTR_FL |
+					      OCFS2_HAS_XATTR_FL));
+
+	return ret;
+}
+
+static int ocfs2_xattr_block_find(struct inode *inode,
+				  int name_index,
+				  const char *name,
+				  struct ocfs2_xattr_search *xs)
+{
+	struct ocfs2_dinode *di = (struct ocfs2_dinode *)xs->inode_bh->b_data;
+	struct buffer_head *blk_bh = NULL;
+	int ret = 0;
+
+	if (di->i_xattr_loc) {
+		ret = ocfs2_read_block(OCFS2_SB(inode->i_sb),
+				       le64_to_cpu(di->i_xattr_loc),
+				       &blk_bh, OCFS2_BH_CACHED, inode);
+		if (ret)
+			return ret;
+		xs->xattr_bh = blk_bh;
+		xs->header = &((struct ocfs2_xattr_block *)blk_bh->b_data)->
+				xb_attrs.xb_header;
+		xs->base = (void *)xs->header;
+		xs->end = (void *)(blk_bh->b_data) + blk_bh->b_size;
+		xs->here = xs->header->xh_entries;
+
+		ret = ocfs2_xattr_find_entry(name_index, name, xs);
+		if (ret && ret != -ENODATA)
+			goto cleanup;
+		xs->not_found = ret;
+		return 0;
+	}
+cleanup:
+	if (blk_bh)
+		brelse(blk_bh);
+	return ret;
+}
+
+static int ocfs2_xattr_block_set(struct inode *inode,
+				 struct ocfs2_xattr_info *xi,
+				 struct ocfs2_xattr_search *xs)
+{
+	struct buffer_head *new_bh = NULL;
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	struct ocfs2_dinode *di =  (struct ocfs2_dinode *)xs->inode_bh->b_data;
+	struct ocfs2_extent_list *el = &di->id2.i_list;
+	struct ocfs2_alloc_context *meta_ac = NULL;
+	handle_t *handle = NULL;
+	struct ocfs2_xattr_block *xblk = NULL;
+	int credits;
+	u16 suballoc_bit_start;
+	u32 num_got;
+	u64 first_blkno;
+	int ret;
+
+	if (!xs->xattr_bh) {
+		ret = ocfs2_reserve_new_metadata(osb, el, &meta_ac);
+		if (ret < 0)
+			goto out;
+
+		credits = ocfs2_calc_extend_credits(osb->sb, el, 1);
+		handle = ocfs2_start_trans(osb, credits);
+		if (IS_ERR(handle)) {
+			ret = PTR_ERR(handle);
+			goto out;
+		}
+		ret = ocfs2_journal_access(handle, inode, xs->inode_bh,
+					   OCFS2_JOURNAL_ACCESS_CREATE);
+		if (ret < 0) {
+			mlog_errno(ret);
+			goto out_commit;
+		}
+
+		ret = ocfs2_claim_metadata(osb, handle, meta_ac, 1,
+					   &suballoc_bit_start, &num_got,
+					   &first_blkno);
+		if (ret < 0) {
+			mlog_errno(ret);
+			goto out_commit;
+		}
+
+		new_bh = sb_getblk(inode->i_sb, first_blkno);
+		ocfs2_set_new_buffer_uptodate(inode, new_bh);
+
+		ret = ocfs2_journal_access(handle, inode, new_bh,
+					   OCFS2_JOURNAL_ACCESS_CREATE);
+		if (ret < 0) {
+			mlog_errno(ret);
+			goto out_commit;
+		}
+
+		/* set ocfs2_xattr_block */
+		xs->xattr_bh = new_bh;
+		xblk = (struct ocfs2_xattr_block *)new_bh->b_data;
+		memset(xblk, 0, inode->i_sb->s_blocksize);
+		strcpy((void *)xblk, OCFS2_XATTR_BLOCK_SIGNATURE_1);
+		xblk->xb_suballoc_slot = cpu_to_le16(osb->slot_num);
+		xblk->xb_suballoc_bit = cpu_to_le16(suballoc_bit_start);
+		xblk->xb_fs_generation = cpu_to_le32(osb->fs_generation);
+		xblk->xb_blkno = cpu_to_le64(first_blkno);
+
+		xs->header = &xblk->xb_attrs.xb_header;
+		xs->base = (void *)xs->header;
+		xs->end = (void *)xblk + inode->i_sb->s_blocksize;
+		xs->here = xs->header->xh_entries;
+
+
+		ret = ocfs2_journal_dirty(handle, new_bh);
+		if (ret < 0)
+			goto out_commit;
+		di->i_xattr_loc = cpu_to_le64(first_blkno);
+		ret = ocfs2_journal_dirty(handle, xs->inode_bh);
+out_commit:
+		ocfs2_commit_trans(osb, handle);
+out:
+		if (meta_ac)
+			ocfs2_free_alloc_context(meta_ac);
+		if (ret < 0)
+			return ret;
+	}
+	ret = ocfs2_xattr_set_entry(inode, xi, xs);
+	if (!ret && !(le16_to_cpu(di->i_dyn_features) & OCFS2_HAS_XATTR_FL))
+		ocfs2_xattr_update_flag(inode,
+					xs->inode_bh,
+					OCFS2_HAS_XATTR_FL);
+
+	return ret;
+}
+
+int ocfs2_xattr_set(struct inode *inode,
+		    int name_index,
+		    const char *name,
+		    const void *value,
+		    size_t value_len,
+		    int flags)
+{
+	struct buffer_head *di_bh = NULL;
+	struct ocfs2_dinode *di;
+	int ret;
+
+	struct ocfs2_xattr_info xi = {
+		.name_index = name_index,
+		.name = name,
+		.value = value,
+		.value_len = value_len,
+	};
+
+	struct ocfs2_xattr_search xis = {
+		.not_found = -ENODATA,
+	};
+
+	struct ocfs2_xattr_search xbs = {
+		.not_found = -ENODATA,
+	};
+
+	ret = ocfs2_inode_lock(inode, &di_bh, 1);
+	if (ret < 0) {
+		mlog_errno(ret);
+		return ret;
+	}
+	xis.inode_bh = xbs.inode_bh = di_bh;
+	di = (struct ocfs2_dinode *)di_bh->b_data;
+	ret = ocfs2_xattr_ibody_find(inode, name_index, name, &xis);
+	if (ret)
+		goto cleanup;
+	if (xis.not_found) {
+		ret = ocfs2_xattr_block_find(inode, name_index, name, &xbs);
+		if (ret)
+			goto cleanup;
+	}
+
+	if (xis.not_found && xbs.not_found) {
+		ret = -ENODATA;
+		if (flags & XATTR_REPLACE)
+			goto cleanup;
+		ret = 0;
+		if (!value)
+		goto cleanup;
+	} else {
+		ret = -EEXIST;
+		if (flags & XATTR_CREATE)
+			goto cleanup;
+	}
+
+	if (!value) {
+		if (!xis.not_found)
+			ret = ocfs2_xattr_ibody_set(inode, &xi, &xis);
+		else if (!xbs.not_found)
+			ret = ocfs2_xattr_block_set(inode, &xi, &xbs);
+	} else {
+		ret = ocfs2_xattr_ibody_set(inode, &xi, &xis);
+		if (!ret && !xbs.not_found) {
+			xi.value = NULL;
+			xi.value_len = 0;
+			ret = ocfs2_xattr_block_set(inode, &xi, &xbs);
+		} else if (ret == -ENOSPC) {
+			if (di->i_xattr_loc && !xbs.xattr_bh) {
+				ret = ocfs2_xattr_block_find(inode, name_index,
+							     name, &xbs);
+				if (ret)
+					goto cleanup;
+			}
+			ret = ocfs2_xattr_block_set(inode, &xi, &xbs);
+			if (ret)
+				goto cleanup;
+			if (!xis.not_found) {
+				xi.value = NULL;
+				xi.value_len = 0;
+				ret = ocfs2_xattr_ibody_set(inode, &xi, &xis);
+			}
+		}
+	}
+cleanup:
+	ocfs2_inode_unlock(inode, 1);
+	if (di_bh)
+		brelse(di_bh);
+	if (xbs.xattr_bh)
+		brelse(xbs.xattr_bh);
+	return ret;
+}
+
diff --git a/fs/ocfs2/xattr.h b/fs/ocfs2/xattr.h
index debde62..0732a00 100644
--- a/fs/ocfs2/xattr.h
+++ b/fs/ocfs2/xattr.h
@@ -77,6 +77,11 @@ struct ocfs2_xattr_tree_root {
 /*10*/	struct ocfs2_extent_list	xt_list;
 };
 
+struct ocfs2_xattr_def_value_root {
+	struct ocfs2_xattr_value_root	xv;
+	struct ocfs2_extent_rec		er;
+};
+
 #define OCFS2_XATTR_INDEXED 0x1
 
 struct ocfs2_xattr_block {
@@ -95,4 +100,26 @@ struct ocfs2_xattr_block {
 	} xb_attrs;
 };
 
+extern struct xattr_handler ocfs2_xattr_user_handler;
+extern struct xattr_handler ocfs2_xattr_trusted_handler;
+#ifdef CONFIG_OCFS2_FS_POSIX_ACL
+extern struct xattr_handler ocfs2_xattr_acl_access_handler;
+extern struct xattr_handler ocfs2_xattr_acl_default_handler;
+#endif
+#ifdef CONFIG_OCFS2_FS_LUSTRE
+extern struct xattr_handler ocfs2_xattr_lustre_handler;
+#endif
+#ifdef CONFIG_OCFS2_FS_SECURITY
+extern struct xattr_handler ocfs2_xattr_security_handler;
+#endif
+
+extern ssize_t ocfs2_listxattr(struct dentry *, char *, size_t);
+
+extern int ocfs2_xattr_get(struct inode *, int, const char *, void *, size_t);
+extern int ocfs2_xattr_set(struct inode *, int, const char *, const void *,
+			   size_t, int);
+extern int ocfs2_xattr_remove(struct inode *inode, struct buffer_head *di_bh);
+
+extern struct xattr_handler *ocfs2_xattr_handlers[];
+
 #endif /* OCFS2_XATTR_H */
diff --git a/fs/ocfs2/xattr_trusted.c b/fs/ocfs2/xattr_trusted.c
new file mode 100644
index 0000000..79f70d3
--- /dev/null
+++ b/fs/ocfs2/xattr_trusted.c
@@ -0,0 +1,79 @@
+/* -*- mode: c; c-basic-offset: 8; -*-
+ * vim: noexpandtab sw=8 ts=8 sts=0:
+ *
+ * xattr_trusted.c
+ *
+ * Copyright (C) 2008 Oracle.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License as published by the Free Software Foundation; either
+ * version 2 of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public
+ * License along with this program; if not, write to the
+ * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
+ * Boston, MA 021110-1307, USA.
+ */
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/string.h>
+
+#define MLOG_MASK_PREFIX ML_INODE
+#include <cluster/masklog.h>
+
+#include "ocfs2.h"
+#include "alloc.h"
+#include "dlmglue.h"
+#include "file.h"
+#include "ocfs2_fs.h"
+#include "xattr.h"
+
+#define XATTR_TRUSTED_PREFIX "trusted."
+
+static size_t ocfs2_xattr_trusted_list(struct inode *inode, char *list,
+				       size_t list_size, const char *name,
+				       size_t name_len)
+{
+	const size_t prefix_len = sizeof(XATTR_TRUSTED_PREFIX) - 1;
+	const size_t total_len = prefix_len + name_len + 1;
+
+	if (list && total_len <= list_size) {
+		memcpy(list, XATTR_TRUSTED_PREFIX, prefix_len);
+		memcpy(list + prefix_len, name, name_len);
+		list[prefix_len + name_len] = '\0';
+	}
+	return total_len;
+}
+
+static int ocfs2_xattr_trusted_get(struct inode *inode, const char *name,
+				   void *buffer, size_t size)
+{
+	if (strcmp(name, "") == 0)
+		return -EINVAL;
+	return ocfs2_xattr_get(inode, OCFS2_XATTR_INDEX_TRUSTED, name,
+			       buffer, size);
+}
+
+static int ocfs2_xattr_trusted_set(struct inode *inode, const char *name,
+				   const void *value, size_t size, int flags)
+{
+	if (strcmp(name, "") == 0)
+		return -EINVAL;
+
+	return ocfs2_xattr_set(inode, OCFS2_XATTR_INDEX_TRUSTED, name, value,
+			       size, flags);
+}
+
+struct xattr_handler ocfs2_xattr_trusted_handler = {
+	.prefix	= XATTR_TRUSTED_PREFIX,
+	.list	= ocfs2_xattr_trusted_list,
+	.get	= ocfs2_xattr_trusted_get,
+	.set	= ocfs2_xattr_trusted_set,
+};
diff --git a/fs/ocfs2/xattr_user.c b/fs/ocfs2/xattr_user.c
new file mode 100644
index 0000000..ef37003
--- /dev/null
+++ b/fs/ocfs2/xattr_user.c
@@ -0,0 +1,91 @@
+/* -*- mode: c; c-basic-offset: 8; -*-
+ * vim: noexpandtab sw=8 ts=8 sts=0:
+ *
+ * xattr_user.c
+ *
+ * Copyright (C) 2008 Oracle.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License as published by the Free Software Foundation; either
+ * version 2 of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public
+ * License along with this program; if not, write to the
+ * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
+ * Boston, MA 021110-1307, USA.
+ */
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/string.h>
+
+#define MLOG_MASK_PREFIX ML_INODE
+#include <cluster/masklog.h>
+
+#include "ocfs2.h"
+#include "alloc.h"
+#include "dlmglue.h"
+#include "file.h"
+#include "ocfs2_fs.h"
+#include "xattr.h"
+
+#define XATTR_USER_PREFIX "user."
+
+static size_t ocfs2_xattr_user_list(struct inode *inode, char *list,
+				    size_t list_size, const char *name,
+				    size_t name_len)
+{
+	const size_t prefix_len = sizeof(XATTR_USER_PREFIX) - 1;
+	const size_t total_len = prefix_len + name_len + 1;
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+
+	if (osb->s_mount_opt & OCFS2_MOUNT_NOUSERXATTR)
+		return 0;
+
+	if (list && total_len <= list_size) {
+		memcpy(list, XATTR_USER_PREFIX, prefix_len);
+		memcpy(list + prefix_len, name, name_len);
+		list[prefix_len + name_len] = '\0';
+	}
+	return total_len;
+}
+
+static int ocfs2_xattr_user_get(struct inode *inode, const char *name,
+				void *buffer, size_t size)
+{
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+
+	if (strcmp(name, "") == 0)
+		return -EINVAL;
+	if (osb->s_mount_opt & OCFS2_MOUNT_NOUSERXATTR)
+		return -EOPNOTSUPP;
+	return ocfs2_xattr_get(inode, OCFS2_XATTR_INDEX_USER, name,
+			       buffer, size);
+}
+
+static int ocfs2_xattr_user_set(struct inode *inode, const char *name,
+				const void *value, size_t size, int flags)
+{
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+
+	if (strcmp(name, "") == 0)
+		return -EINVAL;
+	if (osb->s_mount_opt & OCFS2_MOUNT_NOUSERXATTR)
+		return -EOPNOTSUPP;
+
+	return ocfs2_xattr_set(inode, OCFS2_XATTR_INDEX_USER, name, value,
+			       size, flags);
+}
+
+struct xattr_handler ocfs2_xattr_user_handler = {
+	.prefix	= XATTR_USER_PREFIX,
+	.list	= ocfs2_xattr_user_list,
+	.get	= ocfs2_xattr_user_get,
+	.set	= ocfs2_xattr_user_set,
+};
-- 
1.5.4.4
