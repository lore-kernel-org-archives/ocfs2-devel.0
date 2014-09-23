From: WeiWei Wang <wangww631@huawei.com>
Date: Tue, 23 Sep 2014 17:09:41 +0800
Subject: [Ocfs2-devel] [PATCH 2/7 v2] ocfs2: add two functions of add and
 remove inode in orphan dir
Message-ID: <542138D5.3050904@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This commit adds two functions to add inode to orphan dir and remove inode from orphan dir.
Here the original functions ocfs2_orphan_add and ocfs2_orphan_del are called respectively.

Signed-off-by: Weiwei Wang <wangww631@huawei.com>
---
 fs/ocfs2/namei.c | 143 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ocfs2/namei.h |   6 +++
 2 files changed, 149 insertions(+)

diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 2666dce..a780a63 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -2486,6 +2486,149 @@ leave:
 	return status;
 }

+/* An orphan dir name is an 8 byte value, printed as a hex string */
+#define OCFS2_ORPHAN_NAMELEN ((int)(2 * sizeof(u64)))
+int ocfs2_add_inode_to_orphan(struct ocfs2_super *osb,
+			      handle_t *handle, struct inode *inode)
+{
+	char orphan_name[OCFS2_ORPHAN_NAMELEN + 1];
+	struct inode *orphan_dir_inode = NULL;
+	struct ocfs2_dir_lookup_result orphan_insert = { NULL, };
+	struct buffer_head *di_bh = NULL;
+	int status = 0;
+	bool inode_locked = false;
+
+	status = ocfs2_inode_lock(inode, &di_bh, 1);
+	if (status < 0) {
+		mlog_errno(status);
+		goto out;
+	}
+	inode_locked = true;
+
+	status = ocfs2_prepare_orphan_dir(osb, &orphan_dir_inode,
+					  OCFS2_I(inode)->ip_blkno,
+					  orphan_name,
+					  &orphan_insert);
+	if (status < 0) {
+		mlog_errno(status);
+		goto out;
+	}
+
+	status = ocfs2_journal_access_di(handle, INODE_CACHE(inode), di_bh,
+				OCFS2_JOURNAL_ACCESS_WRITE);
+	if (status < 0) {
+		mlog_errno(status);
+		goto out;
+	}
+
+	status = ocfs2_orphan_add(osb, handle, inode, di_bh, orphan_name,
+				  &orphan_insert, orphan_dir_inode);
+	if (status) {
+		mlog_errno(status);
+		goto out;
+	}
+
+out:
+	brelse(di_bh);
+
+	if (inode_locked)
+		ocfs2_inode_unlock(inode, 1);
+
+	if (orphan_dir_inode) {
+		ocfs2_inode_unlock(orphan_dir_inode, 1);
+		mutex_unlock(&orphan_dir_inode->i_mutex);
+		iput(orphan_dir_inode);
+	}
+	ocfs2_free_dir_lookup_result(&orphan_insert);
+
+	return status;
+}
+
+int ocfs2_del_inode_from_orphan(struct ocfs2_super *osb,
+				handle_t *handle, struct inode *inode)
+{
+	struct inode *orphan_dir_inode = NULL;
+	struct buffer_head *orphan_dir_bh = NULL;
+	struct buffer_head *di_bh = NULL;
+	struct ocfs2_dinode *di = NULL;
+	bool orphan_dir_locked = false;
+	int status = 0;
+
+	orphan_dir_inode = ocfs2_get_system_file_inode(osb,
+						ORPHAN_DIR_SYSTEM_INODE,
+						osb->slot_num);
+	if (!orphan_dir_inode) {
+		status = -EEXIST;
+		mlog_errno(status);
+		goto out;
+	}
+
+	mutex_lock(&orphan_dir_inode->i_mutex);
+	status = ocfs2_inode_lock(orphan_dir_inode, &orphan_dir_bh, 1);
+	if (status < 0) {
+		mlog_errno(status);
+		goto out;
+	}
+	orphan_dir_locked = true;
+
+	status = ocfs2_journal_access_di(handle,
+					 INODE_CACHE(orphan_dir_inode),
+					 orphan_dir_bh,
+					 OCFS2_JOURNAL_ACCESS_WRITE);
+	if (status < 0) {
+		mlog_errno(status);
+		goto out;
+	}
+
+	status = ocfs2_orphan_del(osb, handle, orphan_dir_inode,
+				  inode, orphan_dir_bh);
+	if (status < 0) {
+		mlog_errno(status);
+		goto out;
+	}
+
+	status = ocfs2_inode_lock(inode, &di_bh, 1);
+	if (status < 0) {
+		mlog_errno(status);
+		goto out;
+	}
+	di =  (struct ocfs2_dinode *) di_bh->b_data;
+
+	/*
+	 * We're going to journal the change of i_flags and i_orphaned_slot.
+	 * It's safe anyway, though some callers may duplicate the journaling.
+	 * Journaling within the func just make the logic look more
+	 * straightforward.
+	 */
+	status = ocfs2_journal_access_di(handle,
+					 INODE_CACHE(inode),
+					 di_bh,
+					 OCFS2_JOURNAL_ACCESS_WRITE);
+	if (status < 0) {
+		mlog_errno(status);
+		goto out;
+	}
+
+	di->i_flags &= ~cpu_to_le32(OCFS2_ORPHANED_FL);
+	OCFS2_I(inode)->ip_flags |= OCFS2_INODE_SKIP_ORPHAN_DIR;
+
+	di->i_orphaned_slot = 0;
+	ocfs2_journal_dirty(handle, di_bh);
+
+	ocfs2_inode_unlock(inode, 1);
+
+out:
+	brelse(orphan_dir_bh);
+
+	if (orphan_dir_inode) {
+		if (orphan_dir_locked)
+			ocfs2_inode_unlock(orphan_dir_inode, 1);
+		mutex_unlock(&orphan_dir_inode->i_mutex);
+		iput(orphan_dir_inode);
+	}
+	return status;
+}
+
 int ocfs2_mv_orphaned_inode_to_new(struct inode *dir,
 				   struct inode *inode,
 				   struct dentry *dentry)
diff --git a/fs/ocfs2/namei.h b/fs/ocfs2/namei.h
index e5e43d7..c985e35 100644
--- a/fs/ocfs2/namei.h
+++ b/fs/ocfs2/namei.h
@@ -51,6 +51,12 @@ int ocfs2_orphan_del(struct ocfs2_super *osb,
 int ocfs2_create_inode_in_orphan(struct inode *dir,
 				 int mode,
 				 struct inode **new_inode);
+int ocfs2_add_inode_to_orphan(struct ocfs2_super *osb,
+				handle_t *handle,
+				struct inode *inode);
+int ocfs2_del_inode_from_orphan(struct ocfs2_super *osb,
+				handle_t *handle,
+				struct inode *inode);
 int ocfs2_mv_orphaned_inode_to_new(struct inode *dir,
 				   struct inode *new_inode,
 				   struct dentry *new_dentry);
-- 1.8.4.3
