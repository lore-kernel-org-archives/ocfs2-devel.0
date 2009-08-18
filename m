From: Tao Ma <tao.ma@oracle.com>
Date: Tue, 18 Aug 2009 14:19:38 +0800
Subject: [Ocfs2-devel] [PATCH 37/41] ocfs2: Create reflinked file in orphan
	dir.
In-Reply-To: <4A8A47DF.8020707@oracle.com>
References: <4A8A47DF.8020707@oracle.com>
Message-ID: <1250576382-27080-37-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

reflink is a very complicated process, so it can't be integrated
into one transaction. So if the system panic in the operation, we
may leave a unfinished inode in the destication directory.

So we will try to create an inode in orphan_dir first, reflink it
to the src file and then move it to the destication file in the end.
In that way we won't be afraid of any corruption during the reflink.

This patch adds 2 functions for orphan_dir operation:
1. Create a new inode in orphand dir.
2. Move an inode to a target dir.

Note:
fsck.ocfs2 should work for us to remove the unfinished file in the
orphan_dir.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/namei.c |  268 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ocfs2/namei.h |    6 +
 2 files changed, 274 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 818df58..f010b22 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -2041,6 +2041,274 @@ leave:
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
+	struct ocfs2_dinode *di = NULL;
+	handle_t *handle = NULL;
+	char orphan_name[OCFS2_ORPHAN_NAMELEN + 1];
+	struct buffer_head *parent_di_bh = NULL;
+	struct buffer_head *new_di_bh = NULL;
+	struct ocfs2_alloc_context *inode_ac = NULL;
+	struct ocfs2_dir_lookup_result orphan_insert = { NULL, };
+
+	status = ocfs2_inode_lock(dir, &parent_di_bh, 1);
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
+				    0, &new_di_bh, parent_di_bh, handle,
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
+	di = (struct ocfs2_dinode *)new_di_bh->b_data;
+	status = ocfs2_orphan_add(osb, handle, inode, di, orphan_name,
+				  &orphan_insert, orphan_dir);
+	if (status < 0) {
+		mlog_errno(status);
+		goto leave;
+	}
+
+	/* get open lock so that only nodes can't remove it from orphan dir. */
+	status = ocfs2_open_lock(inode);
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
+	brelse(new_di_bh);
+
+	if (!status)
+		*new_inode = inode;
+
+	ocfs2_free_dir_lookup_result(&orphan_insert);
+
+	ocfs2_inode_unlock(dir, 1);
+	brelse(parent_di_bh);
+	return status;
+}
+
+int ocfs2_mv_orphaned_inode_to_new(struct inode *dir,
+				   struct inode *inode,
+				   struct dentry *dentry)
+{
+	int status = 0;
+	struct buffer_head *parent_di_bh = NULL;
+	handle_t *handle = NULL;
+	struct ocfs2_super *osb = OCFS2_SB(dir->i_sb);
+	struct ocfs2_dinode *dir_di, *di;
+	struct inode *orphan_dir_inode = NULL;
+	struct buffer_head *orphan_dir_bh = NULL;
+	struct buffer_head *di_bh = NULL;
+	struct ocfs2_dir_lookup_result lookup = { NULL, };
+
+	mlog_entry("(0x%p, 0x%p, %.*s')\n", dir, dentry,
+		   dentry->d_name.len, dentry->d_name.name);
+
+	status = ocfs2_inode_lock(dir, &parent_di_bh, 1);
+	if (status < 0) {
+		if (status != -ENOENT)
+			mlog_errno(status);
+		return status;
+	}
+
+	dir_di = (struct ocfs2_dinode *) parent_di_bh->b_data;
+	if (!dir_di->i_links_count) {
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
+	status = ocfs2_prepare_dir_for_insert(osb, dir, parent_di_bh,
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
+	status = ocfs2_read_inode_block(inode, &di_bh);
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
+	status = ocfs2_journal_access_di(handle, INODE_CACHE(inode),
+					 di_bh, OCFS2_JOURNAL_ACCESS_WRITE);
+	if (status < 0) {
+		mlog_errno(status);
+		goto out_commit;
+	}
+
+	status = ocfs2_orphan_del(osb, handle, orphan_dir_inode, inode,
+				  orphan_dir_bh);
+	if (status < 0) {
+		mlog_errno(status);
+		goto out_commit;
+	}
+
+	di = (struct ocfs2_dinode *)di_bh->b_data;
+	le32_add_cpu(&di->i_flags, -OCFS2_ORPHANED_FL);
+	di->i_orphaned_slot = 0;
+	ocfs2_journal_dirty(handle, di_bh);
+
+	status = ocfs2_add_entry(handle, dentry, inode,
+				 OCFS2_I(inode)->ip_blkno, parent_di_bh,
+				 &lookup);
+	if (status < 0) {
+		mlog_errno(status);
+		goto out_commit;
+	}
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
+	brelse(di_bh);
+	brelse(parent_di_bh);
+	brelse(orphan_dir_bh);
+
+	ocfs2_free_dir_lookup_result(&lookup);
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
index 688aef6..e5d059d 100644
--- a/fs/ocfs2/namei.h
+++ b/fs/ocfs2/namei.h
@@ -35,5 +35,11 @@ int ocfs2_orphan_del(struct ocfs2_super *osb,
 		     struct inode *orphan_dir_inode,
 		     struct inode *inode,
 		     struct buffer_head *orphan_dir_bh);
+int ocfs2_create_inode_in_orphan(struct inode *dir,
+				 int mode,
+				 struct inode **new_inode);
+int ocfs2_mv_orphaned_inode_to_new(struct inode *dir,
+				   struct inode *new_inode,
+				   struct dentry *new_dentry);
 
 #endif /* OCFS2_NAMEI_H */
-- 
1.6.2.rc2.16.gf474c
