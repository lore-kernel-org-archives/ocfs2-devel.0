From: Tiger Yang <tiger.yang@oracle.com>
Date: Thu,  7 Aug 2008 15:12:28 +0800
Subject: [Ocfs2-devel] [PATCH 15/15] ocfs2: Add incompatible flag for
	extended attribute v3
In-Reply-To: <489A94F4.90903@oracle.com>
References: <489A94F4.90903@oracle.com>
Message-ID: <1218093148-8632-1-git-send-email-tiger.yang@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This patch add incompatible flag for extended attribute support.
This flag could protect EAs not destroyed by previous ocfs2-tools
or kernel modules.

Signed-off-by: Tiger Yang <tiger.yang@oracle.com>
---
 fs/ocfs2/ocfs2.h    |    7 +++++++
 fs/ocfs2/ocfs2_fs.h |   19 +++++++++++++------
 fs/ocfs2/super.c    |    3 ++-
 fs/ocfs2/xattr.c    |   12 ++++++++++++
 4 files changed, 34 insertions(+), 7 deletions(-)

diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index 33ddb7d..1fcd09c 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -329,6 +329,13 @@ static inline int ocfs2_supports_inline_data(struct ocfs2_super *osb)
 	return 0;
 }
 
+static inline int ocfs2_supports_xattr(struct ocfs2_super *osb)
+{
+	if (osb->s_feature_incompat & OCFS2_FEATURE_INCOMPAT_XATTR)
+		return 1;
+	return 0;
+}
+
 /* set / clear functions because cluster events can make these happen
  * in parallel so we want the transitions to be atomic. this also
  * means that any future flags osb_flags must be protected by spinlock
diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
index 0a2019b..947130b 100644
--- a/fs/ocfs2/ocfs2_fs.h
+++ b/fs/ocfs2/ocfs2_fs.h
@@ -91,7 +91,8 @@
 					 | OCFS2_FEATURE_INCOMPAT_SPARSE_ALLOC \
 					 | OCFS2_FEATURE_INCOMPAT_INLINE_DATA \
 					 | OCFS2_FEATURE_INCOMPAT_EXTENDED_SLOT_MAP \
-					 | OCFS2_FEATURE_INCOMPAT_USERSPACE_STACK)
+					 | OCFS2_FEATURE_INCOMPAT_USERSPACE_STACK \
+					 | OCFS2_FEATURE_INCOMPAT_XATTR)
 #define OCFS2_FEATURE_RO_COMPAT_SUPP	OCFS2_FEATURE_RO_COMPAT_UNWRITTEN
 
 /*
@@ -128,10 +129,6 @@
 /* Support for data packed into inode blocks */
 #define OCFS2_FEATURE_INCOMPAT_INLINE_DATA	0x0040
 
-/* Support for the extended slot map */
-#define OCFS2_FEATURE_INCOMPAT_EXTENDED_SLOT_MAP 0x100
-
-
 /*
  * Support for alternate, userspace cluster stacks.  If set, the superblock
  * field s_cluster_info contains a tag for the alternate stack in use as
@@ -143,6 +140,12 @@
  */
 #define OCFS2_FEATURE_INCOMPAT_USERSPACE_STACK	0x0080
 
+/* Support for the extended slot map */
+#define OCFS2_FEATURE_INCOMPAT_EXTENDED_SLOT_MAP 0x100
+
+/* Support for extended attributes */
+#define OCFS2_FEATURE_INCOMPAT_XATTR		0x0200
+
 /*
  * backup superblock flag is used to indicate that this volume
  * has backup superblocks.
@@ -575,7 +578,11 @@ struct ocfs2_super_block {
 /*A0*/  struct ocfs2_cluster_info s_cluster_info; /* Selected userspace
 						     stack.  Only valid
 						     with INCOMPAT flag. */
-/*B8*/  __le64 s_reserved2[17];		/* Fill out superblock */
+/*B8*/	__le16 s_xattr_inline_size;	/* extended attribute inline size
+					   for this fs*/
+	__le16 s_reserved0;
+	__le32 s_reserved1;
+/*C0*/  __le64 s_reserved2[16];		/* Fill out superblock */
 /*140*/
 
 	/*
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 1202fb8..fc4eb4a 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1434,7 +1434,8 @@ static int ocfs2_initialize_super(struct super_block *sb,
 
 	osb->slot_num = OCFS2_INVALID_SLOT;
 
-	osb->s_xattr_inline_size = OCFS2_MIN_XATTR_INLINE_SIZE;
+	osb->s_xattr_inline_size = le16_to_cpu(
+					di->id2.i_super.s_xattr_inline_size);
 
 	osb->local_alloc_state = OCFS2_LA_UNUSED;
 	osb->local_alloc_bh = NULL;
diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 4589dec..9cd39ad 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -580,6 +580,9 @@ ssize_t ocfs2_listxattr(struct dentry *dentry,
 	struct ocfs2_dinode *di = NULL;
 	struct ocfs2_inode_info *oi = OCFS2_I(dentry->d_inode);
 
+	if (!ocfs2_supports_xattr(OCFS2_SB(dentry->d_sb)))
+		return -EOPNOTSUPP;
+
 	if (!(oi->ip_dyn_features & OCFS2_HAS_XATTR_FL))
 		return ret;
 
@@ -859,6 +862,9 @@ int ocfs2_xattr_get(struct inode *inode,
 		.not_found = -ENODATA,
 	};
 
+	if (!ocfs2_supports_xattr(OCFS2_SB(inode->i_sb)))
+		return -EOPNOTSUPP;
+
 	if (!(oi->ip_dyn_features & OCFS2_HAS_XATTR_FL))
 		ret = -ENODATA;
 
@@ -1557,6 +1563,9 @@ int ocfs2_xattr_remove(struct inode *inode, struct buffer_head *di_bh)
 	handle_t *handle;
 	int ret;
 
+	if (!ocfs2_supports_xattr(OCFS2_SB(inode->i_sb)))
+		return 0;
+
 	if (!(oi->ip_dyn_features & OCFS2_HAS_XATTR_FL))
 		return 0;
 
@@ -1993,6 +2002,9 @@ int ocfs2_xattr_set(struct inode *inode,
 		.not_found = -ENODATA,
 	};
 
+	if (!ocfs2_supports_xattr(OCFS2_SB(inode->i_sb)))
+		return -EOPNOTSUPP;
+
 	ret = ocfs2_inode_lock(inode, &di_bh, 1);
 	if (ret < 0) {
 		mlog_errno(ret);
-- 
1.5.4.4
