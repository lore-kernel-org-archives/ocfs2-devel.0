From: Tiger Yang <tiger.yang@oracle.com>
Date: Thu, 23 Oct 2008 16:33:33 +0800
Subject: [Ocfs2-devel] [PATCH 2/4] ocfs2: fix function declaration and
	definition in xattr
In-Reply-To: <49003524.3090405@oracle.com>
References: <49003524.3090405@oracle.com>
Message-ID: <1224750813-10901-1-git-send-email-tiger.yang@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Because we merge split xattr files into one file, some functions
no need declare or define in the head file.

Signed-off-by: Tiger Yang <tiger.yang@oracle.com>
---
 fs/ocfs2/xattr.c |   28 +++++++++++++++++++++++-----
 fs/ocfs2/xattr.h |   26 ++++----------------------
 2 files changed, 27 insertions(+), 27 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index baa4825..667525b 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -142,6 +142,24 @@ static int ocfs2_xattr_set_entry_index_block(struct inode *inode,
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
@@ -793,11 +811,11 @@ cleanup:
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
diff --git a/fs/ocfs2/xattr.h b/fs/ocfs2/xattr.h
index e4e45c8..1d8314c 100644
--- a/fs/ocfs2/xattr.h
+++ b/fs/ocfs2/xattr.h
@@ -32,29 +32,11 @@ enum ocfs2_xattr_type {
 
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
