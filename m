From: Tiger Yang <tiger.yang@oracle.com>
Date: Mon, 27 Oct 2008 16:44:05 +0800
Subject: [Ocfs2-devel] [PATCH 4/4] ocfs2: add init_security in mknod
In-Reply-To: <49057D8B.5040700@oracle.com>
References: <49057D8B.5040700@oracle.com>
Message-ID: <1225097045-29708-1-git-send-email-tiger.yang@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

we must set security xattr when creating a new inode.
first, calculate and reserve the meta data and clusters
needed by security xattr, then set it before add_entry.

Signed-off-by: Tiger Yang <tiger.yang@oracle.com>
---
 fs/ocfs2/namei.c |   67 ++++++++++++++++++++++++++++++++++++++++++++++++-----
 1 files changed, 60 insertions(+), 7 deletions(-)

diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index dd4ee52..30d6441 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -186,6 +186,28 @@ bail:
 	return ret;
 }
 
+static void ocfs2_calc_xattr_init(struct inode *dir,
+				  int security_len,
+				  int *want_clusters,
+				  struct ocfs2_alloc_context **xattr_ac)
+{
+	struct ocfs2_super *osb = OCFS2_SB(dir->i_sb);
+
+	/*
+	 * reserve one metadata block for xattrs if we couldn't get
+	 * xattr inline (blocksize = 512).
+	 */
+	if (dir->i_sb->s_blocksize == OCFS2_MIN_BLOCKSIZE)
+		ocfs2_reserve_new_metadata_blocks(osb, 1, xattr_ac);
+
+	/* reserve clusters for xattr value which will be set in B tree*/
+	if (security_len > OCFS2_XATTR_INLINE_SIZE)
+		*want_clusters += ocfs2_clusters_for_bytes(dir->i_sb,
+							   security_len);
+
+	return;
+}
+
 static inline struct inode *ocfs2_make_init_inode(struct inode *dir, int mode)
 {
 	struct inode *inode;
@@ -215,7 +237,12 @@ static int ocfs2_mknod(struct inode *dir,
 	struct buffer_head *de_bh = NULL;
 	struct inode *inode = NULL;
 	struct ocfs2_alloc_context *inode_ac = NULL;
+	struct ocfs2_alloc_context *xattr_ac = NULL;
 	struct ocfs2_alloc_context *data_ac = NULL;
+	int want_clusters = 0;
+	size_t security_len = 0;
+	void *security_value = NULL;
+	char *security_name = NULL;
 
 	mlog_entry("(0x%p, 0x%p, %d, %lu, '%.*s')\n", dir, dentry, mode,
 		   (unsigned long)dev, dentry->d_name.len,
@@ -272,14 +299,26 @@ static int ocfs2_mknod(struct inode *dir,
 		goto leave;
 	}
 
+	/* get security xattr */
+	status = ocfs2_init_security_get(inode, dir, &security_name,
+					 &security_value, &security_len);
+	if (status < 0) {
+		mlog_errno(status);
+		goto leave;
+	}
+
+	/* calculate meta data/clusters for setting security xattr */
+	ocfs2_calc_xattr_init(dir, security_len, &want_clusters, &xattr_ac);
+
 	/* Reserve a cluster if creating an extent based directory. */
-	if (S_ISDIR(mode) && !ocfs2_supports_inline_data(osb)) {
-		status = ocfs2_reserve_clusters(osb, 1, &data_ac);
-		if (status < 0) {
-			if (status != -ENOSPC)
-				mlog_errno(status);
-			goto leave;
-		}
+	if (S_ISDIR(mode) && !ocfs2_supports_inline_data(osb))
+		want_clusters += 1;
+
+	status = ocfs2_reserve_clusters(osb, want_clusters, &data_ac);
+	if (status < 0) {
+		if (status != -ENOSPC)
+			mlog_errno(status);
+		goto leave;
 	}
 
 	handle = ocfs2_start_trans(osb, OCFS2_MKNOD_CREDITS);
@@ -322,6 +361,15 @@ static int ocfs2_mknod(struct inode *dir,
 		inc_nlink(dir);
 	}
 
+	status = ocfs2_init_security_set(handle, inode, new_fe_bh,
+					 security_name, security_value,
+					 security_len,
+					 xattr_ac, data_ac);
+	if (status < 0) {
+		mlog_errno(status);
+		goto leave;
+	}
+
 	status = ocfs2_add_entry(handle, dentry, inode,
 				 OCFS2_I(inode)->ip_blkno, parent_fe_bh,
 				 de_bh);
@@ -353,6 +401,8 @@ leave:
 	brelse(new_fe_bh);
 	brelse(de_bh);
 	brelse(parent_fe_bh);
+	kfree(security_value);
+	kfree(security_name);
 
 	if ((status < 0) && inode)
 		iput(inode);
@@ -360,6 +410,9 @@ leave:
 	if (inode_ac)
 		ocfs2_free_alloc_context(inode_ac);
 
+	if (xattr_ac)
+		ocfs2_free_alloc_context(xattr_ac);
+
 	if (data_ac)
 		ocfs2_free_alloc_context(data_ac);
 
-- 
1.5.4.1
