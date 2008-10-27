From: Tiger Yang <tiger.yang@oracle.com>
Date: Mon, 27 Oct 2008 16:42:38 +0800
Subject: [Ocfs2-devel] [PATCH 1/4] ocfs2: move new_inode out of the
	transaction
In-Reply-To: <49057D8B.5040700@oracle.com>
References: <49057D8B.5040700@oracle.com>
Message-ID: <1225096958-29646-1-git-send-email-tiger.yang@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

we need know the security xattr size before start transaction,
so mov new_inode out of mknod_unlock and populate i_mode to
get the exact security xattr size.

Signed-off-by: Tiger Yang <tiger.yang@oracle.com>
---
 fs/ocfs2/namei.c |   53 +++++++++++++++++++++++++++++++++--------------------
 1 files changed, 33 insertions(+), 20 deletions(-)

diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index f4967e6..dd4ee52 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -71,7 +71,7 @@ static int ocfs2_mknod_locked(struct ocfs2_super *osb,
 			      struct buffer_head **new_fe_bh,
 			      struct buffer_head *parent_fe_bh,
 			      handle_t *handle,
-			      struct inode **ret_inode,
+			      struct inode *inode,
 			      struct ocfs2_alloc_context *inode_ac);
 
 static int ocfs2_prepare_orphan_dir(struct ocfs2_super *osb,
@@ -186,6 +186,21 @@ bail:
 	return ret;
 }
 
+static inline struct inode *ocfs2_make_init_inode(struct inode *dir, int mode)
+{
+	struct inode *inode;
+
+	/*
+	 * move new_inode out of the transanction and populate i_mode
+	 * to get exact security xattr size.
+	 */
+	inode = new_inode(dir->i_sb);
+	if (!IS_ERR(inode))
+		inode->i_mode = mode;
+
+	return inode;
+}
+
 static int ocfs2_mknod(struct inode *dir,
 		       struct dentry *dentry,
 		       int mode,
@@ -250,6 +265,13 @@ static int ocfs2_mknod(struct inode *dir,
 		goto leave;
 	}
 
+	inode = ocfs2_make_init_inode(dir, mode);
+	if (IS_ERR(inode)) {
+		status = PTR_ERR(inode);
+		mlog(ML_ERROR, "new_inode failed!\n");
+		goto leave;
+	}
+
 	/* Reserve a cluster if creating an extent based directory. */
 	if (S_ISDIR(mode) && !ocfs2_supports_inline_data(osb)) {
 		status = ocfs2_reserve_clusters(osb, 1, &data_ac);
@@ -271,7 +293,7 @@ static int ocfs2_mknod(struct inode *dir,
 	/* do the real work now. */
 	status = ocfs2_mknod_locked(osb, dir, dentry, mode, dev,
 				    &new_fe_bh, parent_fe_bh, handle,
-				    &inode, inode_ac);
+				    inode, inode_ac);
 	if (status < 0) {
 		mlog_errno(status);
 		goto leave;
@@ -353,7 +375,7 @@ static int ocfs2_mknod_locked(struct ocfs2_super *osb,
 			      struct buffer_head **new_fe_bh,
 			      struct buffer_head *parent_fe_bh,
 			      handle_t *handle,
-			      struct inode **ret_inode,
+			      struct inode *inode,
 			      struct ocfs2_alloc_context *inode_ac)
 {
 	int status = 0;
@@ -361,14 +383,12 @@ static int ocfs2_mknod_locked(struct ocfs2_super *osb,
 	struct ocfs2_extent_list *fel;
 	u64 fe_blkno = 0;
 	u16 suballoc_bit;
-	struct inode *inode = NULL;
 
 	mlog_entry("(0x%p, 0x%p, %d, %lu, '%.*s')\n", dir, dentry, mode,
 		   (unsigned long)dev, dentry->d_name.len,
 		   dentry->d_name.name);
 
 	*new_fe_bh = NULL;
-	*ret_inode = NULL;
 
 	status = ocfs2_claim_new_inode(osb, handle, inode_ac, &suballoc_bit,
 				       &fe_blkno);
@@ -377,13 +397,6 @@ static int ocfs2_mknod_locked(struct ocfs2_super *osb,
 		goto leave;
 	}
 
-	inode = new_inode(dir->i_sb);
-	if (!inode) {
-		status = -ENOMEM;
-		mlog(ML_ERROR, "new_inode failed!\n");
-		goto leave;
-	}
-
 	/* populate as many fields early on as possible - many of
 	 * these are used by the support functions here and in
 	 * callers. */
@@ -393,7 +406,6 @@ static int ocfs2_mknod_locked(struct ocfs2_super *osb,
 		inode->i_nlink = 2;
 	else
 		inode->i_nlink = 1;
-	inode->i_mode = mode;
 	spin_lock(&osb->osb_lock);
 	inode->i_generation = osb->s_next_generation++;
 	spin_unlock(&osb->osb_lock);
@@ -483,18 +495,12 @@ static int ocfs2_mknod_locked(struct ocfs2_super *osb,
 
 	status = 0; /* error in ocfs2_create_new_inode_locks is not
 		     * critical */
-
-	*ret_inode = inode;
 leave:
 	if (status < 0) {
 		if (*new_fe_bh) {
 			brelse(*new_fe_bh);
 			*new_fe_bh = NULL;
 		}
-		if (inode) {
-			clear_nlink(inode);
-			iput(inode);
-		}
 	}
 
 	mlog_exit(status);
@@ -1552,6 +1558,13 @@ static int ocfs2_symlink(struct inode *dir,
 		}
 	}
 
+	inode = ocfs2_make_init_inode(dir, (S_IFLNK | S_IRWXUGO));
+	if (IS_ERR(inode)) {
+		status = PTR_ERR(inode);
+		mlog(ML_ERROR, "new_inode failed!\n");
+		goto bail;
+	}
+
 	handle = ocfs2_start_trans(osb, credits);
 	if (IS_ERR(handle)) {
 		status = PTR_ERR(handle);
@@ -1563,7 +1576,7 @@ static int ocfs2_symlink(struct inode *dir,
 	status = ocfs2_mknod_locked(osb, dir, dentry,
 				    S_IFLNK | S_IRWXUGO, 0,
 				    &new_fe_bh, parent_fe_bh, handle,
-				    &inode, inode_ac);
+				    inode, inode_ac);
 	if (status < 0) {
 		mlog_errno(status);
 		goto bail;
-- 
1.5.4.1
