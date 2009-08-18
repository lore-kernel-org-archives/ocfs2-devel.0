From: Tao Ma <tao.ma@oracle.com>
Date: Tue, 18 Aug 2009 14:19:23 +0800
Subject: [Ocfs2-devel] [PATCH 22/41] ocfs2: handle file attributes issue for
	reflink.
In-Reply-To: <4A8A47DF.8020707@oracle.com>
References: <4A8A47DF.8020707@oracle.com>
Message-ID: <1250576382-27080-22-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

A reflink creates a snapshot of a file, that means the attributes
must be identical except for three exceptions - nlink, ino, and ctime.

As for time changes, Here is a brief description:

1. Source file:
   1) atime: Ignore. Let the lazy atime code handle that.
   2) mtime: don't touch.
   3) ctime: If we change the tree (adding REFCOUNTED to at least one
             extent), update it.
2. Destination file:
   1) atime: ignore.
   2) mtime: we want it to appear identical to the source.
   3) ctime: update.

The idea here is that an ls -l will show the same time for the
src and target - it shows mtime.  Backup software like rsync and tar
will treat the new file correctly too.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/refcounttree.c |  122 ++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 120 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index ec07518..efcccb4 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -3207,10 +3207,44 @@ out:
 	return ret;
 }
 
+static int ocfs2_change_ctime(struct inode *inode,
+			      struct buffer_head *di_bh)
+{
+	int ret;
+	handle_t *handle;
+	struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
+
+	handle = ocfs2_start_trans(OCFS2_SB(inode->i_sb),
+				   OCFS2_INODE_UPDATE_CREDITS);
+	if (IS_ERR(handle)) {
+		ret = PTR_ERR(handle);
+		mlog_errno(ret);
+		goto out;
+	}
+
+	ret = ocfs2_journal_access_di(handle, INODE_CACHE(inode), di_bh,
+				      OCFS2_JOURNAL_ACCESS_WRITE);
+	if (ret) {
+		mlog_errno(ret);
+		goto out_commit;
+	}
+
+	inode->i_ctime = CURRENT_TIME;
+	di->i_ctime = cpu_to_le64(inode->i_ctime.tv_sec);
+	di->i_ctime_nsec = cpu_to_le32(inode->i_ctime.tv_nsec);
+
+	ocfs2_journal_dirty(handle, di_bh);
+
+out_commit:
+	ocfs2_commit_trans(OCFS2_SB(inode->i_sb), handle);
+out:
+	return ret;
+}
+
 static int ocfs2_attach_refcount_tree(struct inode *inode,
 				      struct buffer_head *di_bh)
 {
-	int ret;
+	int ret, data_changed = 0;
 	struct buffer_head *ref_root_bh = NULL;
 	struct ocfs2_inode_info *oi = OCFS2_I(inode);
 	struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
@@ -3259,12 +3293,21 @@ static int ocfs2_attach_refcount_tree(struct inode *inode,
 						      &dealloc);
 			if (ret) {
 				mlog_errno(ret);
-				break;
+				goto unlock;
 			}
+
+			data_changed = 1;
 		}
 		cpos += num_clusters;
 	}
 
+	if (data_changed) {
+		ret = ocfs2_change_ctime(inode, di_bh);
+		if (ret)
+			mlog_errno(ret);
+	}
+
+unlock:
 	ocfs2_unlock_refcount_tree(osb, ref_tree, 1);
 	brelse(ref_root_bh);
 
@@ -3379,6 +3422,74 @@ out:
 	return ret;
 }
 
+/*
+ * change the new file's attributes to the src.
+ *
+ * reflink creates a snapshot of a file, that means the attributes
+ * must be identical except for three exceptions - nlink, ino, and ctime.
+ */
+static int ocfs2_complete_reflink(struct inode *s_inode,
+				  struct buffer_head *s_bh,
+				  struct inode *t_inode,
+				  struct buffer_head *t_bh)
+{
+	int ret;
+	handle_t *handle;
+	struct ocfs2_dinode *s_di = (struct ocfs2_dinode *)s_bh->b_data;
+	struct ocfs2_dinode *di = (struct ocfs2_dinode *)t_bh->b_data;
+	loff_t size = i_size_read(s_inode);
+
+	handle = ocfs2_start_trans(OCFS2_SB(t_inode->i_sb),
+				   OCFS2_INODE_UPDATE_CREDITS);
+	if (IS_ERR(handle)) {
+		ret = PTR_ERR(handle);
+		mlog_errno(ret);
+		return ret;
+	}
+
+	ret = ocfs2_journal_access_di(handle, INODE_CACHE(t_inode), t_bh,
+				      OCFS2_JOURNAL_ACCESS_WRITE);
+	if (ret) {
+		mlog_errno(ret);
+		goto out_commit;
+	}
+
+	spin_lock(&OCFS2_I(t_inode)->ip_lock);
+	OCFS2_I(t_inode)->ip_clusters = OCFS2_I(s_inode)->ip_clusters;
+	OCFS2_I(t_inode)->ip_attr = OCFS2_I(s_inode)->ip_attr;
+	OCFS2_I(t_inode)->ip_dyn_features = OCFS2_I(s_inode)->ip_dyn_features;
+	spin_unlock(&OCFS2_I(t_inode)->ip_lock);
+	i_size_write(t_inode, size);
+
+	di->i_xattr_inline_size = s_di->i_xattr_inline_size;
+	di->i_clusters = s_di->i_clusters;
+	di->i_size = s_di->i_size;
+	di->i_dyn_features = s_di->i_dyn_features;
+	di->i_attr = s_di->i_attr;
+	di->i_uid = s_di->i_uid;
+	di->i_gid = s_di->i_gid;
+	di->i_mode = s_di->i_mode;
+
+	/*
+	 * update time.
+	 * we want mtime to appear identical to the source and update ctime.
+	 */
+	t_inode->i_ctime = CURRENT_TIME;
+
+	di->i_ctime = cpu_to_le64(t_inode->i_ctime.tv_sec);
+	di->i_ctime_nsec = cpu_to_le32(t_inode->i_ctime.tv_nsec);
+
+	t_inode->i_mtime = s_inode->i_mtime;
+	di->i_mtime = s_di->i_mtime;
+	di->i_mtime_nsec = s_di->i_mtime_nsec;
+
+	ocfs2_journal_dirty(handle, t_bh);
+
+out_commit:
+	ocfs2_commit_trans(OCFS2_SB(t_inode->i_sb), handle);
+	return ret;
+}
+
 static int ocfs2_create_reflink_node(struct inode *s_inode,
 				     struct buffer_head *s_bh,
 				     struct inode *t_inode,
@@ -3412,9 +3523,16 @@ static int ocfs2_create_reflink_node(struct inode *s_inode,
 	ret = ocfs2_duplicate_extent_list(s_inode, t_inode, t_bh,
 					  &ref_tree->rf_ci, ref_root_bh,
 					  &dealloc);
+	if (ret) {
+		mlog_errno(ret);
+		goto out_unlock_refcount;
+	}
+
+	ret = ocfs2_complete_reflink(s_inode, s_bh, t_inode, t_bh);
 	if (ret)
 		mlog_errno(ret);
 
+out_unlock_refcount:
 	ocfs2_unlock_refcount_tree(osb, ref_tree, 1);
 	brelse(ref_root_bh);
 out:
-- 
1.6.2.rc2.16.gf474c
