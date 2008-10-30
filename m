From: Tiger Yang <tiger.yang@oracle.com>
Date: Thu, 30 Oct 2008 19:41:29 +0800
Subject: [Ocfs2-devel] [PATCH 10/15] ocfs2: add ocfs2_xattr_get_nolock
In-Reply-To: <49099B13.9030802@oracle.com>
References: <49099B13.9030802@oracle.com>
Message-ID: <1225366889-6396-1-git-send-email-tiger.yang@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This function do the work of ocfs2_xattr_get under
an opend lock.

Signed-off-by: Tiger Yang <tiger.yang@oracle.com>
---
 fs/ocfs2/xattr.c |   40 ++++++++++++++++++++++++++++------------
 fs/ocfs2/xattr.h |    2 ++
 2 files changed, 30 insertions(+), 12 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 3922b43..d926960 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -921,12 +921,8 @@ cleanup:
 	return ret;
 }
 
-/* ocfs2_xattr_get()
- *
- * Copy an extended attribute into the buffer provided.
- * Buffer is NULL to compute the size of buffer required.
- */
-static int ocfs2_xattr_get(struct inode *inode,
+int ocfs2_xattr_get_nolock(struct inode *inode,
+			   struct buffer_head *di_bh,
 			   int name_index,
 			   const char *name,
 			   void *buffer,
@@ -934,7 +930,6 @@ static int ocfs2_xattr_get(struct inode *inode,
 {
 	int ret;
 	struct ocfs2_dinode *di = NULL;
-	struct buffer_head *di_bh = NULL;
 	struct ocfs2_inode_info *oi = OCFS2_I(inode);
 	struct ocfs2_xattr_search xis = {
 		.not_found = -ENODATA,
@@ -949,11 +944,6 @@ static int ocfs2_xattr_get(struct inode *inode,
 	if (!(oi->ip_dyn_features & OCFS2_HAS_XATTR_FL))
 		ret = -ENODATA;
 
-	ret = ocfs2_inode_lock(inode, &di_bh, 0);
-	if (ret < 0) {
-		mlog_errno(ret);
-		return ret;
-	}
 	xis.inode_bh = xbs.inode_bh = di_bh;
 	di = (struct ocfs2_dinode *)di_bh->b_data;
 
@@ -964,6 +954,32 @@ static int ocfs2_xattr_get(struct inode *inode,
 		ret = ocfs2_xattr_block_get(inode, name_index, name, buffer,
 					    buffer_size, &xbs);
 	up_read(&oi->ip_xattr_sem);
+
+	return ret;
+}
+
+/* ocfs2_xattr_get()
+ *
+ * Copy an extended attribute into the buffer provided.
+ * Buffer is NULL to compute the size of buffer required.
+ */
+static int ocfs2_xattr_get(struct inode *inode,
+			   int name_index,
+			   const char *name,
+			   void *buffer,
+			   size_t buffer_size)
+{
+	int ret;
+	struct buffer_head *di_bh = NULL;
+
+	ret = ocfs2_inode_lock(inode, &di_bh, 0);
+	if (ret < 0) {
+		mlog_errno(ret);
+		return ret;
+	}
+	ret = ocfs2_xattr_get_nolock(inode, di_bh, name_index,
+				     name, buffer, buffer_size);
+
 	ocfs2_inode_unlock(inode, 0);
 
 	brelse(di_bh);
diff --git a/fs/ocfs2/xattr.h b/fs/ocfs2/xattr.h
index c615ed9..d9f3da9 100644
--- a/fs/ocfs2/xattr.h
+++ b/fs/ocfs2/xattr.h
@@ -36,6 +36,8 @@ extern struct xattr_handler ocfs2_xattr_security_handler;
 extern struct xattr_handler *ocfs2_xattr_handlers[];
 
 ssize_t ocfs2_listxattr(struct dentry *, char *, size_t);
+int ocfs2_xattr_get_nolock(struct inode *, struct buffer_head *, int,
+			   const char *, void *, size_t);
 int ocfs2_xattr_set(struct inode *, int, const char *, const void *,
 		    size_t, int);
 int ocfs2_xattr_set_handle(handle_t *, struct inode *, struct buffer_head *,
-- 
1.5.4.1
