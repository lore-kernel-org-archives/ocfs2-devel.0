From: Tiger Yang <tiger.yang@oracle.com>
Date: Thu, 30 Oct 2008 19:41:14 +0800
Subject: [Ocfs2-devel] [PATCH 09/15] ocfs2: add ocfs2_init_security in mkno
In-Reply-To: <49099B13.9030802@oracle.com>
References: <49099B13.9030802@oracle.com>
Message-ID: <1225366874-6376-1-git-send-email-tiger.yang@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

security xattr must be set when creating a new inode.
we do this in three steps. first, get security xattr's
name and value by security_operation, then calculate
and reserve the meta data and clusters needed by this
security xattr before starting transaction, finally set
it before add_entry.

Signed-off-by: Tiger Yang <tiger.yang@oracle.com>
---
 fs/ocfs2/namei.c |   56 +++++++++++++++++++++++++++++++++++----
 fs/ocfs2/xattr.c |   76 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ocfs2/xattr.h |   10 +++++++
 3 files changed, 136 insertions(+), 6 deletions(-)

diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index dd4ee52..6ec42ef 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -215,7 +215,13 @@ static int ocfs2_mknod(struct inode *dir,
 	struct buffer_head *de_bh = NULL;
 	struct inode *inode = NULL;
 	struct ocfs2_alloc_context *inode_ac = NULL;
+	struct ocfs2_alloc_context *xattr_ac = NULL;
 	struct ocfs2_alloc_context *data_ac = NULL;
+	int want_clusters = 0;
+	int has_security = 1;
+	size_t security_len = 0;
+	void *security_value = NULL;
+	char *security_name = NULL;
 
 	mlog_entry("(0x%p, 0x%p, %d, %lu, '%.*s')\n", dir, dentry, mode,
 		   (unsigned long)dev, dentry->d_name.len,
@@ -272,16 +278,38 @@ static int ocfs2_mknod(struct inode *dir,
 		goto leave;
 	}
 
-	/* Reserve a cluster if creating an extent based directory. */
-	if (S_ISDIR(mode) && !ocfs2_supports_inline_data(osb)) {
-		status = ocfs2_reserve_clusters(osb, 1, &data_ac);
-		if (status < 0) {
-			if (status != -ENOSPC)
-				mlog_errno(status);
+	/* get security xattr */
+	status = ocfs2_init_security_get(inode, dir, &security_name,
+					 &security_value, &security_len);
+	if (status) {
+		if (status == -EOPNOTSUPP)
+			has_security = 0;
+		else {
+			mlog_errno(status);
 			goto leave;
 		}
 	}
 
+	/* calculate meta data/clusters for setting security xattr */
+	status = ocfs2_calc_xattr_init(dir, strlen(security_name),
+					security_len, has_security,
+					&want_clusters, &xattr_ac);
+	if (status < 0) {
+		mlog_errno(status);
+		goto leave;
+	}
+
+	/* Reserve a cluster if creating an extent based directory. */
+	if (S_ISDIR(mode) && !ocfs2_supports_inline_data(osb))
+		want_clusters += 1;
+
+	status = ocfs2_reserve_clusters(osb, want_clusters, &data_ac);
+	if (status < 0) {
+		if (status != -ENOSPC)
+			mlog_errno(status);
+		goto leave;
+	}
+
 	handle = ocfs2_start_trans(osb, OCFS2_MKNOD_CREDITS);
 	if (IS_ERR(handle)) {
 		status = PTR_ERR(handle);
@@ -322,6 +350,17 @@ static int ocfs2_mknod(struct inode *dir,
 		inc_nlink(dir);
 	}
 
+	if (has_security) {
+		status = ocfs2_init_security_set(handle, inode, new_fe_bh,
+						 security_name, security_value,
+						 security_len,
+						 xattr_ac, data_ac);
+		if (status < 0) {
+			mlog_errno(status);
+			goto leave;
+		}
+	}
+
 	status = ocfs2_add_entry(handle, dentry, inode,
 				 OCFS2_I(inode)->ip_blkno, parent_fe_bh,
 				 de_bh);
@@ -353,6 +392,8 @@ leave:
 	brelse(new_fe_bh);
 	brelse(de_bh);
 	brelse(parent_fe_bh);
+	kfree(security_value);
+	kfree(security_name);
 
 	if ((status < 0) && inode)
 		iput(inode);
@@ -360,6 +401,9 @@ leave:
 	if (inode_ac)
 		ocfs2_free_alloc_context(inode_ac);
 
+	if (xattr_ac)
+		ocfs2_free_alloc_context(xattr_ac);
+
 	if (data_ac)
 		ocfs2_free_alloc_context(data_ac);
 
diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 93026dc..3922b43 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -81,6 +81,9 @@ struct ocfs2_xattr_set_ctxt {
 
 #define OCFS2_XATTR_ROOT_SIZE	(sizeof(struct ocfs2_xattr_def_value_root))
 #define OCFS2_XATTR_INLINE_SIZE	80
+#define OCFS2_XATTR_FREE_IN_IBODY	(OCFS2_MIN_XATTR_INLINE_SIZE \
+					 - sizeof(struct ocfs2_xattr_header) \
+					 - sizeof(__u32))
 
 static struct ocfs2_xattr_def_value_root def_xv = {
 	.xv.xr_list.l_count = cpu_to_le16(1),
@@ -341,6 +344,55 @@ static void ocfs2_xattr_hash_entry(struct inode *inode,
 	return;
 }
 
+static int ocfs2_xattr_entry_real_size(int name_len, size_t value_len)
+{
+	int size = 0;
+
+	if (value_len <= OCFS2_XATTR_INLINE_SIZE)
+		size = OCFS2_XATTR_SIZE(name_len) + OCFS2_XATTR_SIZE(value_len);
+	else
+		size = OCFS2_XATTR_SIZE(name_len) + OCFS2_XATTR_ROOT_SIZE;
+	size += sizeof(struct ocfs2_xattr_entry);
+
+	return size;
+}
+
+int ocfs2_calc_xattr_init(struct inode *dir,
+			  int s_name_len,
+			  size_t s_value_len,
+			  int has_security,
+			  int *want_clusters,
+			  struct ocfs2_alloc_context **xattr_ac)
+{
+	int ret = 0;
+	struct ocfs2_super *osb = OCFS2_SB(dir->i_sb);
+	int s_size = 0;
+
+	if (has_security)
+		s_size = ocfs2_xattr_entry_real_size(s_name_len, s_value_len);
+	else
+		return ret;
+	/*
+	 * The max space of security xattr taken inline is
+	 * 256(name) + 80(value) + 16(entry) = 352 bytes,
+	 * So reserve one metadata block for it is ok.
+	 */
+	if (dir->i_sb->s_blocksize == OCFS2_MIN_BLOCKSIZE ||
+	    s_size > OCFS2_XATTR_FREE_IN_IBODY) {
+		ret = ocfs2_reserve_new_metadata_blocks(osb, 1, xattr_ac);
+		if (ret) {
+			mlog_errno(ret);
+			return ret;
+		}
+	}
+
+	/* reserve clusters for xattr value which will be set in B tree*/
+	if (s_value_len > OCFS2_XATTR_INLINE_SIZE)
+		*want_clusters += ocfs2_clusters_for_bytes(dir->i_sb,
+							   s_value_len);
+	return ret;
+}
+
 static int ocfs2_xattr_extend_allocation(struct inode *inode,
 					 u32 clusters_to_add,
 					 struct buffer_head *xattr_bh,
@@ -5037,6 +5089,30 @@ static int ocfs2_xattr_security_set(struct inode *inode, const char *name,
 			       size, flags);
 }
 
+int ocfs2_init_security_get(struct inode *inode,
+			    struct inode *dir,
+			    char **name,
+			    void **value,
+			    size_t *len)
+{
+	return security_inode_init_security(inode, dir, name, value, len);
+}
+
+int ocfs2_init_security_set(handle_t *handle,
+			    struct inode *inode,
+			    struct buffer_head *di_bh,
+			    char *name,
+			    void *value,
+			    size_t len,
+			    struct ocfs2_alloc_context *xattr_ac,
+			    struct ocfs2_alloc_context *data_ac)
+{
+	return ocfs2_xattr_set_handle(handle, inode, di_bh,
+				     OCFS2_XATTR_INDEX_SECURITY,
+				     name, value, len, 0,
+				     xattr_ac, data_ac);
+}
+
 struct xattr_handler ocfs2_xattr_security_handler = {
 	.prefix	= XATTR_SECURITY_PREFIX,
 	.list	= ocfs2_xattr_security_list,
diff --git a/fs/ocfs2/xattr.h b/fs/ocfs2/xattr.h
index 55c5256..c615ed9 100644
--- a/fs/ocfs2/xattr.h
+++ b/fs/ocfs2/xattr.h
@@ -43,5 +43,15 @@ int ocfs2_xattr_set_handle(handle_t *, struct inode *, struct buffer_head *,
 			   struct ocfs2_alloc_context *,
 			   struct ocfs2_alloc_context *);
 int ocfs2_xattr_remove(struct inode *, struct buffer_head *);
+int ocfs2_init_security_get(struct inode *, struct inode *,
+			    char **, void **, size_t *);
+int ocfs2_init_security_set(handle_t *, struct inode *,
+			    struct buffer_head *,
+			    char *, void *, size_t,
+			    struct ocfs2_alloc_context *,
+			    struct ocfs2_alloc_context *);
+int ocfs2_calc_xattr_init(struct inode *, int, size_t,
+			  int, int *,
+			  struct ocfs2_alloc_context **);
 
 #endif /* OCFS2_XATTR_H */
-- 
1.5.4.1
