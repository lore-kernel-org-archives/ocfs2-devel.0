From: Tiger Yang <tiger.yang@oracle.com>
Date: Thu, 16 Oct 2008 15:48:51 +0800
Subject: [Ocfs2-devel] [PATCH 1/3] ocfs2/xattr: some fix in xattr
In-Reply-To: <48F6F0A3.5060909@oracle.com>
References: <48F6F0A3.5060909@oracle.com>
Message-ID: <1224143331-30924-1-git-send-email-tiger.yang@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This patch fix some function declaration problem in xattr.

Signed-off-by: Tiger Yang <tiger.yang@oracle.com>
---
 fs/ocfs2/xattr.c |   39 +++++++++++++++++++++++++--------------
 fs/ocfs2/xattr.h |   26 ++++----------------------
 2 files changed, 29 insertions(+), 36 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index de3b057..1a326a7 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -147,6 +147,24 @@ static int ocfs2_xattr_set_entry_index_block(struct inode *inode,
 static int ocfs2_delete_xattr_index_block(struct inode *inode,
 					  struct buffer_head *xb_bh);
 
+static inline u16 ocfs2_xattr_buckets_per_cluster(struct ocfs2_super *osb)
+{
+	return (1 << osb->s_clustersize_bits) / OCFS2_XATTR_BUCKET_SIZE;
+}
+
+static inline u16 ocfs2_blocks_per_xattr_bucket(struct super_block *sb)
+{
+	return OCFS2_XATTR_BUCKET_SIZE / (1 << sb->s_blocksize_bits);
+}
+
+static inline u16 ocfs2_xattr_max_xe_in_bucket(struct super_block *sb)
+{
+	u16 len = sb->s_blocksize -
+		 offsetof(struct ocfs2_xattr_header, xh_entries);
+
+	return len / sizeof(struct ocfs2_xattr_entry);
+}
+
 static inline const char *ocfs2_xattr_prefix(int name_index)
 {
 	struct xattr_handler *handler = NULL;
@@ -800,11 +818,11 @@ cleanup:
  * Copy an extended attribute into the buffer provided.
  * Buffer is NULL to compute the size of buffer required.
  */
-int ocfs2_xattr_get(struct inode *inode,
-		    int name_index,
-		    const char *name,
-		    void *buffer,
-		    size_t buffer_size)
+static int ocfs2_xattr_get(struct inode *inode,
+			   int name_index,
+			   const char *name,
+			   void *buffer,
+			   size_t buffer_size)
 {
 	int ret;
 	struct ocfs2_dinode *di = NULL;
@@ -4823,14 +4841,11 @@ out:
 /*
  * 'trusted' attributes support
  */
-
-#define XATTR_TRUSTED_PREFIX "trusted."
-
 static size_t ocfs2_xattr_trusted_list(struct inode *inode, char *list,
 				       size_t list_size, const char *name,
 				       size_t name_len)
 {
-	const size_t prefix_len = sizeof(XATTR_TRUSTED_PREFIX) - 1;
+	const size_t prefix_len = XATTR_TRUSTED_PREFIX_LEN;
 	const size_t total_len = prefix_len + name_len + 1;
 
 	if (list && total_len <= list_size) {
@@ -4867,18 +4882,14 @@ struct xattr_handler ocfs2_xattr_trusted_handler = {
 	.set	= ocfs2_xattr_trusted_set,
 };
 
-
 /*
  * 'user' attributes support
  */
-
-#define XATTR_USER_PREFIX "user."
-
 static size_t ocfs2_xattr_user_list(struct inode *inode, char *list,
 				    size_t list_size, const char *name,
 				    size_t name_len)
 {
-	const size_t prefix_len = sizeof(XATTR_USER_PREFIX) - 1;
+	const size_t prefix_len = XATTR_USER_PREFIX_LEN;
 	const size_t total_len = prefix_len + name_len + 1;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 
diff --git a/fs/ocfs2/xattr.h b/fs/ocfs2/xattr.h
index c25c7c6..c1f0974 100644
--- a/fs/ocfs2/xattr.h
+++ b/fs/ocfs2/xattr.h
@@ -40,29 +40,11 @@ enum ocfs2_xattr_type {
 
 extern struct xattr_handler ocfs2_xattr_user_handler;
 extern struct xattr_handler ocfs2_xattr_trusted_handler;
-
-extern ssize_t ocfs2_listxattr(struct dentry *, char *, size_t);
-extern int ocfs2_xattr_get(struct inode *, int, const char *, void *, size_t);
-extern int ocfs2_xattr_set(struct inode *, int, const char *, const void *,
-			   size_t, int);
-extern int ocfs2_xattr_remove(struct inode *inode, struct buffer_head *di_bh);
 extern struct xattr_handler *ocfs2_xattr_handlers[];
 
-static inline u16 ocfs2_xattr_buckets_per_cluster(struct ocfs2_super *osb)
-{
-	return (1 << osb->s_clustersize_bits) / OCFS2_XATTR_BUCKET_SIZE;
-}
-
-static inline u16 ocfs2_blocks_per_xattr_bucket(struct super_block *sb)
-{
-	return OCFS2_XATTR_BUCKET_SIZE / (1 << sb->s_blocksize_bits);
-}
-
-static inline u16 ocfs2_xattr_max_xe_in_bucket(struct super_block *sb)
-{
-	u16 len = sb->s_blocksize -
-		 offsetof(struct ocfs2_xattr_header, xh_entries);
+ssize_t ocfs2_listxattr(struct dentry *, char *, size_t);
+int ocfs2_xattr_set(struct inode *, int, const char *, const void *,
+		    size_t, int);
+int ocfs2_xattr_remove(struct inode *, struct buffer_head *);
 
-	return len / sizeof(struct ocfs2_xattr_entry);
-}
 #endif /* OCFS2_XATTR_H */
-- 
1.5.4.1
