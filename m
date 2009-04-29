From: Tao Ma <tao.ma@oracle.com>
Date: Thu, 30 Apr 2009 06:58:31 +0800
Subject: [Ocfs2-devel] [PATCH 19/39] ocfs2: Create reflinked file in orphan
	dir.
In-Reply-To: <49F95A79.6040806@oracle.com>
References: <49F95A79.6040806@oracle.com>
Message-ID: <1241045931-24607-19-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

reflink is a very complicated process, so it can't be integrated
into one transaction. So if the system panic in the operation, we
may leave a unfinished inode in the destication directory.

This patch try to create an inode in orphan_dir first, reflink it
to the src file and then move it to the destication file in the end.
So we are not afraid of any corruption during the reflink.

In the mean time, we never use ocfs2_mknod, so make it static again.

Note:
fsck.ocfs2 should work for us to remove the unfinished file in the
orphan_dir.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/namei.c        |  260 ++++++++++++++++++++++++++++++++++++++++++++++-
 fs/ocfs2/namei.h        |    9 +-
 fs/ocfs2/refcounttree.c |   35 ++++---
 3 files changed, 283 insertions(+), 21 deletions(-)

diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 04ffbfe..3baeac3 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -216,8 +216,8 @@ static struct inode *ocfs2_get_init_inode(struct inode *dir, int mode)
 	return inode;
 }
 
-int ocfs2_mknod(struct inode *dir, struct dentry *dentry,
-		int mode, dev_t dev)
+static int ocfs2_mknod(struct inode *dir, struct dentry *dentry,
+		       int mode, dev_t dev)
 {
 	int status = 0;
 	struct buffer_head *parent_fe_bh = NULL;
@@ -2040,6 +2040,262 @@ leave:
 	return status;
 }
 
+int ocfs2_create_inode_in_orphan(struct inode *dir,
+				 int mode,
+				 struct inode **new_inode)
+{
+	int status, did_quota_inode = 0;
+	struct inode *inode = NULL;
+	struct inode *orphan_dir = NULL;
+	struct ocfs2_super *osb = OCFS2_SB(dir->i_sb);
+	struct ocfs2_dinode *fe = NULL;
+	handle_t *handle = NULL;
+	char orphan_name[OCFS2_ORPHAN_NAMELEN + 1];
+	struct buffer_head *parent_fe_bh = NULL;
+	struct buffer_head *new_fe_bh = NULL;
+	struct ocfs2_alloc_context *inode_ac = NULL;
+	struct ocfs2_dir_lookup_result orphan_insert = { NULL, };
+
+	status = ocfs2_inode_lock(dir, &parent_fe_bh, 1);
+	if (status < 0) {
+		if (status != -ENOENT)
+			mlog_errno(status);
+		return status;
+	}
+
+	/*
+	 * We give the orphan dir the root blkno to fake an orphan name,
+	 * and allocate enough space for our insertion.
+	 */
+	status = ocfs2_prepare_orphan_dir(osb, &orphan_dir,
+					  osb->root_blkno,
+					  orphan_name, &orphan_insert);
+	if (status < 0) {
+		mlog_errno(status);
+		goto leave;
+	}
+
+	/* reserve an inode spot */
+	status = ocfs2_reserve_new_inode(osb, &inode_ac);
+	if (status < 0) {
+		if (status != -ENOSPC)
+			mlog_errno(status);
+		goto leave;
+	}
+
+	inode = ocfs2_get_init_inode(dir, mode);
+	if (!inode) {
+		status = -ENOMEM;
+		mlog_errno(status);
+		goto leave;
+	}
+
+	handle = ocfs2_start_trans(osb, ocfs2_mknod_credits(osb->sb, 0, 0));
+	if (IS_ERR(handle)) {
+		status = PTR_ERR(handle);
+		handle = NULL;
+		mlog_errno(status);
+		goto leave;
+	}
+
+	/* We don't use standard VFS wrapper because we don't want vfs_dq_init
+	 * to be called. */
+	if (sb_any_quota_active(osb->sb) &&
+	    osb->sb->dq_op->alloc_inode(inode, 1) == NO_QUOTA) {
+		status = -EDQUOT;
+		goto leave;
+	}
+	did_quota_inode = 1;
+
+	/* do the real work now. */
+	status = ocfs2_mknod_locked(osb, dir, inode,
+				    0, &new_fe_bh, parent_fe_bh, handle,
+				    inode_ac);
+	if (status < 0) {
+		mlog_errno(status);
+		goto leave;
+	}
+
+	status = ocfs2_blkno_stringify(OCFS2_I(inode)->ip_blkno, orphan_name);
+	if (status < 0) {
+		mlog_errno(status);
+		goto leave;
+	}
+
+	fe = (struct ocfs2_dinode *)new_fe_bh->b_data;
+	status = ocfs2_orphan_add(osb, handle, inode, fe, orphan_name,
+				  &orphan_insert, orphan_dir);
+	if (status < 0)
+		mlog_errno(status);
+
+leave:
+	if (status < 0 && did_quota_inode)
+		vfs_dq_free_inode(inode);
+	if (handle)
+		ocfs2_commit_trans(osb, handle);
+
+	if (orphan_dir) {
+		/* This was locked for us in ocfs2_prepare_orphan_dir() */
+		ocfs2_inode_unlock(orphan_dir, 1);
+		mutex_unlock(&orphan_dir->i_mutex);
+		iput(orphan_dir);
+	}
+
+	if (status == -ENOSPC)
+		mlog(0, "Disk is full\n");
+
+	if ((status < 0) && inode) {
+		clear_nlink(inode);
+		iput(inode);
+	}
+
+	if (inode_ac)
+		ocfs2_free_alloc_context(inode_ac);
+
+	brelse(new_fe_bh);
+
+	if (!status)
+		*new_inode = inode;
+
+	ocfs2_inode_unlock(dir, 1);
+	return status;
+}
+
+int ocfs2_mv_orphaned_inode_to_new(struct inode *dir,
+				   struct inode *inode,
+				   struct dentry *dentry)
+{
+	int status = 0;
+	struct buffer_head *parent_fe_bh = NULL;
+	handle_t *handle = NULL;
+	struct ocfs2_super *osb = OCFS2_SB(dir->i_sb);
+	struct ocfs2_dinode *dirfe, *fe;
+	struct inode *orphan_dir_inode = NULL;
+	struct buffer_head *orphan_dir_bh = NULL;
+	struct buffer_head *fe_bh = NULL;
+	struct ocfs2_dir_lookup_result lookup = { NULL, };
+
+	mlog_entry("(0x%p, 0x%p, %.*s')\n", dir, dentry,
+		   dentry->d_name.len, dentry->d_name.name);
+
+	status = ocfs2_inode_lock(dir, &parent_fe_bh, 1);
+	if (status < 0) {
+		if (status != -ENOENT)
+			mlog_errno(status);
+		return status;
+	}
+
+	dirfe = (struct ocfs2_dinode *) parent_fe_bh->b_data;
+	if (!dirfe->i_links_count) {
+		/* can't make a file in a deleted directory. */
+		status = -ENOENT;
+		goto leave;
+	}
+
+	status = ocfs2_check_dir_for_entry(dir, dentry->d_name.name,
+					   dentry->d_name.len);
+	if (status)
+		goto leave;
+
+	/* get a spot inside the dir. */
+	status = ocfs2_prepare_dir_for_insert(osb, dir, parent_fe_bh,
+					      dentry->d_name.name,
+					      dentry->d_name.len, &lookup);
+	if (status < 0) {
+		mlog_errno(status);
+		goto leave;
+	}
+
+	orphan_dir_inode = ocfs2_get_system_file_inode(osb,
+						       ORPHAN_DIR_SYSTEM_INODE,
+						       osb->slot_num);
+	if (!orphan_dir_inode) {
+		status = -EEXIST;
+		mlog_errno(status);
+		goto leave;
+	}
+
+	mutex_lock(&orphan_dir_inode->i_mutex);
+
+	status = ocfs2_inode_lock(orphan_dir_inode, &orphan_dir_bh, 1);
+	if (status < 0) {
+		mlog_errno(status);
+		mutex_unlock(&orphan_dir_inode->i_mutex);
+		iput(orphan_dir_inode);
+		goto leave;
+	}
+
+	status = ocfs2_read_inode_block(inode, &fe_bh);
+	if (status < 0) {
+		mlog_errno(status);
+		goto orphan_unlock;
+	}
+
+	handle = ocfs2_start_trans(osb, ocfs2_rename_credits(osb->sb));
+	if (IS_ERR(handle)) {
+		status = PTR_ERR(handle);
+		handle = NULL;
+		mlog_errno(status);
+		goto orphan_unlock;
+	}
+
+	status = ocfs2_orphan_del(osb, handle, orphan_dir_inode, inode,
+				  orphan_dir_bh);
+	if (status < 0) {
+		mlog_errno(status);
+		goto out_commit;
+	}
+
+	status = ocfs2_journal_access_di(handle, INODE_CACHE(inode),
+					 fe_bh, OCFS2_JOURNAL_ACCESS_WRITE);
+	if (status < 0) {
+		mlog_errno(status);
+		goto out_commit;
+	}
+
+	fe = (struct ocfs2_dinode *)fe_bh->b_data;
+	le32_add_cpu(&fe->i_flags, -OCFS2_ORPHANED_FL);
+	fe->i_orphaned_slot = 0;
+	ocfs2_journal_dirty(handle, fe_bh);
+
+	status = ocfs2_add_entry(handle, dentry, inode,
+				 OCFS2_I(inode)->ip_blkno, parent_fe_bh,
+				 &lookup);
+	if (status < 0) {
+		mlog_errno(status);
+		goto out_commit;
+	}
+
+
+	status = ocfs2_dentry_attach_lock(dentry, inode,
+					  OCFS2_I(dir)->ip_blkno);
+	if (status) {
+		mlog_errno(status);
+		goto out_commit;
+	}
+
+	insert_inode_hash(inode);
+	dentry->d_op = &ocfs2_dentry_ops;
+	d_instantiate(dentry, inode);
+	status = 0;
+out_commit:
+	ocfs2_commit_trans(osb, handle);
+orphan_unlock:
+	ocfs2_inode_unlock(orphan_dir_inode, 1);
+	mutex_unlock(&orphan_dir_inode->i_mutex);
+	iput(orphan_dir_inode);
+leave:
+
+	ocfs2_inode_unlock(dir, 1);
+
+	brelse(parent_fe_bh);
+	brelse(orphan_dir_bh);
+
+	mlog_exit(status);
+
+	return status;
+}
+
 const struct inode_operations ocfs2_dir_iops = {
 	.create		= ocfs2_create,
 	.lookup		= ocfs2_lookup,
diff --git a/fs/ocfs2/namei.h b/fs/ocfs2/namei.h
index 7f9cc46..1db41a2 100644
--- a/fs/ocfs2/namei.h
+++ b/fs/ocfs2/namei.h
@@ -35,7 +35,10 @@ int ocfs2_orphan_del(struct ocfs2_super *osb,
 		     struct inode *orphan_dir_inode,
 		     struct inode *inode,
 		     struct buffer_head *orphan_dir_bh);
-int ocfs2_mknod(struct inode *dir, struct dentry *dentry,
-		int mode, dev_t dev);
-
+int ocfs2_create_inode_in_orphan(struct inode *dir,
+				 int mode,
+				 struct inode **new_inode);
+int ocfs2_mv_orphaned_inode_to_new(struct inode *dir,
+				   struct inode *new_inode,
+				   struct dentry *new_dentry);
 #endif /* OCFS2_NAMEI_H */
diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index fbdefb0..8927c33 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -2814,32 +2814,18 @@ out:
 
 static int __ocfs2_reflink(struct dentry *old_dentry,
 			   struct buffer_head *old_bh,
-			   struct inode *dir,
-			   struct dentry *dentry)
+			   struct inode *new_inode)
 {
 	int ret;
 	struct inode *inode = old_dentry->d_inode;
-	struct inode *new_inode;
 	struct buffer_head *new_bh = NULL;
 
-	mlog_entry("(inode=%lu, old='%.*s' new='%.*s')\n", inode->i_ino,
-		   old_dentry->d_name.len, old_dentry->d_name.name,
-		   dentry->d_name.len, dentry->d_name.name);
-
-	ret = ocfs2_mknod(dir, dentry, inode->i_mode, 0);
-	if (ret) {
-		mlog_errno(ret);
-		goto out;
-	}
-
 	ret = ocfs2_attach_refcount_tree(inode, old_bh);
 	if (ret) {
 		mlog_errno(ret);
 		goto out;
 	}
 
-	new_inode = dentry->d_inode;
-
 	mutex_lock(&new_inode->i_mutex);
 	ret = ocfs2_inode_lock(new_inode, &new_bh, 1);
 	if (ret) {
@@ -2878,6 +2864,7 @@ static int ocfs2_vfs_reflink(struct dentry *old_dentry,
 {
 	struct buffer_head *old_bh = NULL;
 	struct inode *inode = old_dentry->d_inode;
+	struct inode *new_orphan_inode;
 	int error;
 
 	if (!inode)
@@ -2903,6 +2890,13 @@ static int ocfs2_vfs_reflink(struct dentry *old_dentry,
 		return -EINVAL;
 	}
 
+	error = ocfs2_create_inode_in_orphan(dir, inode->i_mode,
+					     &new_orphan_inode);
+	if (error) {
+		mlog_errno(error);
+		goto out_unlock;
+	}
+
 	mutex_lock(&inode->i_mutex);
 	error = ocfs2_inode_lock(inode, &old_bh, 1);
 	if (error) {
@@ -2912,14 +2906,23 @@ static int ocfs2_vfs_reflink(struct dentry *old_dentry,
 
 	down_write(&OCFS2_I(inode)->ip_alloc_sem);
 	vfs_dq_init(dir);
-	error = __ocfs2_reflink(old_dentry, old_bh, dir, new_dentry);
+	error = __ocfs2_reflink(old_dentry, old_bh, new_orphan_inode);
 	up_write(&OCFS2_I(inode)->ip_alloc_sem);
+	if (error)
+		mlog_errno(error);
 
 	ocfs2_inode_unlock(inode, 1);
 	brelse(old_bh);
 out_unlock:
 	mutex_unlock(&inode->i_mutex);
 
+	if (!error) {
+		error = ocfs2_mv_orphaned_inode_to_new(dir, new_orphan_inode,
+						       new_dentry);
+		if (error)
+			mlog_errno(error);
+	}
+
 	return error;
 }
 
-- 
1.6.2.rc2.16.gf474c
