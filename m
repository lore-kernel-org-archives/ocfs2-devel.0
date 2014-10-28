From: Joseph Qi <joseph.qi@huawei.com>
Date: Tue, 28 Oct 2014 21:13:47 +0800
Subject: [Ocfs2-devel] [PATCH 2/7 v5] ocfs2: add functions to add and remove
 inode in orphan dir
Message-ID: <544F968B.2030900@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Weiwei Wang <wangww631@huawei.com>

Add functions to add inode to orphan dir and remove inode in orphan dir.
Here we do not call ocfs2_prepare_orphan_dir and ocfs2_orphan_add
directly. Because append O_DIRECT will add inode to orphan two and
may result in more than one orphan entry for the same inode.

Signed-off-by: Weiwei Wang <wangww631@huawei.com>
Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
---
 fs/ocfs2/journal.h     |   5 +
 fs/ocfs2/namei.c       | 315 +++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ocfs2/namei.h       |   5 +
 fs/ocfs2/ocfs2_fs.h    |   5 +-
 fs/ocfs2/ocfs2_trace.h |   3 +
 5 files changed, 332 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/journal.h b/fs/ocfs2/journal.h
index 7f8cde9..f4cd3c3 100644
--- a/fs/ocfs2/journal.h
+++ b/fs/ocfs2/journal.h
@@ -472,6 +472,11 @@ static inline int ocfs2_unlink_credits(struct super_block *sb)
  * orphan dir index leaf */
 #define OCFS2_DELETE_INODE_CREDITS (3 * OCFS2_INODE_UPDATE_CREDITS + 4)

+/* dinode + orphan dir dinode + extent tree leaf block + orphan dir entry +
+ * orphan dir index root + orphan dir index leaf */
+#define OCFS2_INODE_ADD_TO_ORPHAN_CREDITS  (2 * OCFS2_INODE_UPDATE_CREDITS + 4)
+#define OCFS2_INODE_DEL_FROM_ORPHAN_CREDITS  OCFS2_INODE_ADD_TO_ORPHAN_CREDITS
+
 /* dinode update, old dir dinode update, new dir dinode update, old
  * dir dir entry, new dir dir entry, dir entry update for renaming
  * directory + target unlink + 3 x dir index leaves */
diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 8add6f1..3b74f58 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -81,6 +81,12 @@ static int ocfs2_prepare_orphan_dir(struct ocfs2_super *osb,
 				    char *name,
 				    struct ocfs2_dir_lookup_result *lookup);

+static int ocfs2_dio_prepare_orphan_dir(struct ocfs2_super *osb,
+		struct inode **ret_orphan_dir,
+		u64 blkno,
+		char *name,
+		struct ocfs2_dir_lookup_result *lookup);
+
 static int ocfs2_orphan_add(struct ocfs2_super *osb,
 			    handle_t *handle,
 			    struct inode *inode,
@@ -89,6 +95,15 @@ static int ocfs2_orphan_add(struct ocfs2_super *osb,
 			    struct ocfs2_dir_lookup_result *lookup,
 			    struct inode *orphan_dir_inode);

+static int ocfs2_dio_orphan_add(struct ocfs2_super *osb,
+		handle_t *handle,
+		struct inode *inode,
+		struct buffer_head *fe_bh,
+		char *name,
+		struct ocfs2_dir_lookup_result *lookup,
+		struct inode *orphan_dir_inode,
+		bool orphaned);
+
 static int ocfs2_create_symlink_data(struct ocfs2_super *osb,
 				     handle_t *handle,
 				     struct inode *inode,
@@ -2137,6 +2152,51 @@ out:
 	return ret;
 }

+/**
+ * Copy from ocfs2_prepare_orphan_dir(). The difference:
+ * It will still lock orphan dir if entry exists.
+ * Caller must take care of -EEXIST and responsible for unlock.
+*/
+static int ocfs2_dio_prepare_orphan_dir(struct ocfs2_super *osb,
+				    struct inode **ret_orphan_dir,
+				    u64 blkno,
+				    char *name,
+				    struct ocfs2_dir_lookup_result *lookup)
+{
+	struct inode *orphan_dir_inode = NULL;
+	struct buffer_head *orphan_dir_bh = NULL;
+	int ret = 0;
+
+	ret = ocfs2_lookup_lock_orphan_dir(osb, &orphan_dir_inode,
+					   &orphan_dir_bh);
+	if (ret < 0) {
+		mlog_errno(ret);
+		return ret;
+	}
+
+	ret = __ocfs2_prepare_orphan_dir(orphan_dir_inode, orphan_dir_bh,
+					 blkno, name, lookup);
+	if (ret < 0 && ret != -EEXIST) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	*ret_orphan_dir = orphan_dir_inode;
+
+out:
+	brelse(orphan_dir_bh);
+
+	if (ret && ret != -EEXIST) {
+		ocfs2_inode_unlock(orphan_dir_inode, 1);
+		mutex_unlock(&orphan_dir_inode->i_mutex);
+		iput(orphan_dir_inode);
+	}
+
+	if (ret && ret != -EEXIST)
+		mlog_errno(ret);
+	return ret;
+}
+
 static int ocfs2_orphan_add(struct ocfs2_super *osb,
 			    handle_t *handle,
 			    struct inode *inode,
@@ -2226,6 +2286,100 @@ leave:
 	return status;
 }

+/**
+ * Copy from ocfs2_orphan_add, the difference:
+ * 1. Do not add entry if already added.
+ * 2. Update di flags OCFS2_DIO_ORPHANED_FL and record the
+ * orphan slot.
+*/
+static int ocfs2_dio_orphan_add(struct ocfs2_super *osb,
+			    handle_t *handle,
+			    struct inode *inode,
+			    struct buffer_head *fe_bh,
+			    char *name,
+			    struct ocfs2_dir_lookup_result *lookup,
+			    struct inode *orphan_dir_inode,
+			    bool orphaned)
+{
+	struct buffer_head *orphan_dir_bh = NULL;
+	int status = 0;
+	struct ocfs2_dinode *orphan_fe;
+	struct ocfs2_dinode *fe = (struct ocfs2_dinode *) fe_bh->b_data;
+
+	trace_ocfs2_dio_orphan_add_begin(
+				(unsigned long long)OCFS2_I(inode)->ip_blkno);
+
+	status = ocfs2_read_inode_block(orphan_dir_inode, &orphan_dir_bh);
+	if (status < 0) {
+		mlog_errno(status);
+		goto leave;
+	}
+
+	status = ocfs2_journal_access_di(handle,
+					 INODE_CACHE(orphan_dir_inode),
+					 orphan_dir_bh,
+					 OCFS2_JOURNAL_ACCESS_WRITE);
+	if (status < 0) {
+		mlog_errno(status);
+		goto leave;
+	}
+
+	/*
+	 * We're going to journal the change of i_flags and i_dio_orphaned_slot.
+	 * It's safe anyway, though some callers may duplicate the journaling.
+	 * Journaling within the func just make the logic look more
+	 * straightforward.
+	 */
+	status = ocfs2_journal_access_di(handle,
+					 INODE_CACHE(inode),
+					 fe_bh,
+					 OCFS2_JOURNAL_ACCESS_WRITE);
+	if (status < 0) {
+		mlog_errno(status);
+		goto leave;
+	}
+
+	/* we're a cluster, and nlink can change on disk from
+	 * underneath us... */
+	orphan_fe = (struct ocfs2_dinode *) orphan_dir_bh->b_data;
+	if (S_ISDIR(inode->i_mode))
+		ocfs2_add_links_count(orphan_fe, 1);
+	set_nlink(orphan_dir_inode, ocfs2_read_links_count(orphan_fe));
+	ocfs2_journal_dirty(handle, orphan_dir_bh);
+
+	/* It may already be orphaned by ocfs2_unlink/ocfs2_rename */
+	if (!orphaned) {
+		status = __ocfs2_add_entry(handle, orphan_dir_inode, name,
+				   OCFS2_ORPHAN_NAMELEN, inode,
+				   OCFS2_I(inode)->ip_blkno,
+				   orphan_dir_bh, lookup);
+		if (status < 0) {
+			mlog_errno(status);
+			goto rollback;
+		}
+	}
+
+	/* Update flag OCFS2_DIO_ORPHANED_FL and record the orphan slot */
+	fe->i_flags |= cpu_to_le32(OCFS2_DIO_ORPHANED_FL);
+	fe->i_dio_orphaned_slot = cpu_to_le16(osb->slot_num);
+
+	ocfs2_journal_dirty(handle, fe_bh);
+
+	trace_ocfs2_dio_orphan_add_end((unsigned long long)OCFS2_I(inode)->ip_blkno,
+				   osb->slot_num);
+
+rollback:
+	if (status < 0) {
+		if (S_ISDIR(inode->i_mode))
+			ocfs2_add_links_count(orphan_fe, -1);
+		set_nlink(orphan_dir_inode, ocfs2_read_links_count(orphan_fe));
+	}
+
+leave:
+	brelse(orphan_dir_bh);
+
+	return status;
+}
 /* unlike orphan_add, we expect the orphan dir to already be locked here. */
 int ocfs2_orphan_del(struct ocfs2_super *osb,
 		     handle_t *handle,
@@ -2500,6 +2654,167 @@ leave:
 	return status;
 }

+int ocfs2_add_inode_to_orphan(struct ocfs2_super *osb,
+	struct inode *inode)
+{
+	char orphan_name[OCFS2_ORPHAN_NAMELEN + 1];
+	struct inode *orphan_dir_inode = NULL;
+	struct ocfs2_dir_lookup_result orphan_insert = { NULL, };
+	struct buffer_head *di_bh = NULL;
+	int status = 0;
+	handle_t *handle = NULL;
+	struct ocfs2_dinode *di = NULL;
+	bool orphaned = false;
+
+	status = ocfs2_inode_lock(inode, &di_bh, 1);
+	if (status < 0) {
+		mlog_errno(status);
+		goto bail;
+	}
+
+	status = ocfs2_dio_prepare_orphan_dir(osb, &orphan_dir_inode,
+			OCFS2_I(inode)->ip_blkno,
+			orphan_name,
+			&orphan_insert);
+	if (status < 0 && status != -EEXIST) {
+		mlog_errno(status);
+		goto bail_unlock_inode;
+	} else if (status == -EEXIST) {
+		mlog(ML_NOTICE, "inode %llu already added to "
+				"orphan dir %llu.\n",
+				OCFS2_I(inode)->ip_blkno,
+				OCFS2_I(orphan_dir_inode)->ip_blkno);
+		di = (struct ocfs2_dinode *) di_bh->b_data;
+		if (!(di->i_flags & le32_to_cpu(OCFS2_ORPHANED_FL))) {
+			mlog_errno(status);
+			goto bail_unlock_orphan;
+		}
+		orphaned = true;
+	}
+
+	handle = ocfs2_start_trans(osb,
+			OCFS2_INODE_ADD_TO_ORPHAN_CREDITS);
+	if (IS_ERR(handle)) {
+		status = PTR_ERR(handle);
+		goto bail_unlock_orphan;
+	}
+
+	status = ocfs2_dio_orphan_add(osb, handle, inode, di_bh, orphan_name,
+			&orphan_insert, orphan_dir_inode, orphaned);
+	if (status)
+		mlog_errno(status);
+
+	ocfs2_commit_trans(osb, handle);
+
+bail_unlock_orphan:
+	ocfs2_inode_unlock(orphan_dir_inode, 1);
+	mutex_unlock(&orphan_dir_inode->i_mutex);
+	iput(orphan_dir_inode);
+
+	ocfs2_free_dir_lookup_result(&orphan_insert);
+
+bail_unlock_inode:
+	ocfs2_inode_unlock(inode, 1);
+	brelse(di_bh);
+
+bail:
+	return status;
+}
+
+int ocfs2_del_inode_from_orphan(struct ocfs2_super *osb,
+		struct inode *inode, int update_isize,
+		loff_t end)
+{
+	struct inode *orphan_dir_inode = NULL;
+	struct buffer_head *orphan_dir_bh = NULL;
+	struct buffer_head *di_bh = NULL;
+	struct ocfs2_dinode *di = NULL;
+	handle_t *handle = NULL;
+	int status = 0;
+
+	status = ocfs2_inode_lock(inode, &di_bh, 1);
+	if (status < 0) {
+		mlog_errno(status);
+		goto bail;
+	}
+	di = (struct ocfs2_dinode *) di_bh->b_data;
+
+	orphan_dir_inode = ocfs2_get_system_file_inode(osb,
+			ORPHAN_DIR_SYSTEM_INODE,
+			le16_to_cpu(di->i_dio_orphaned_slot));
+	if (!orphan_dir_inode) {
+		status = -EEXIST;
+		mlog_errno(status);
+		goto bail_unlock_inode;
+	}
+
+	mutex_lock(&orphan_dir_inode->i_mutex);
+	status = ocfs2_inode_lock(orphan_dir_inode, &orphan_dir_bh, 1);
+	if (status < 0) {
+		mutex_unlock(&orphan_dir_inode->i_mutex);
+		iput(orphan_dir_inode);
+		mlog_errno(status);
+		goto bail_unlock_inode;
+	}
+
+	handle = ocfs2_start_trans(osb,
+			OCFS2_INODE_DEL_FROM_ORPHAN_CREDITS);
+	if (IS_ERR(handle)) {
+		status = PTR_ERR(handle);
+		goto bail_unlock_orphan;
+	}
+
+	BUG_ON(!di->i_flags & cpu_to_le32(OCFS2_DIO_ORPHANED_FL));
+
+	/* Only delete entry if OCFS2_ORPHANED_FL not set, or
+	 * there are two entries added */
+	if (!(di->i_flags & cpu_to_le32(OCFS2_ORPHANED_FL)) ||
+			(di->i_flags & cpu_to_le32(OCFS2_ORPHANED_FL) &&
+			(di->i_orphaned_slot != di->i_dio_orphaned_slot))) {
+		status = ocfs2_orphan_del(osb, handle, orphan_dir_inode,
+				inode, orphan_dir_bh);
+		if (status < 0) {
+			mlog_errno(status);
+			goto bail_commit;
+		}
+	}
+
+	status = ocfs2_journal_access_di(handle,
+			INODE_CACHE(inode),
+			di_bh,
+			OCFS2_JOURNAL_ACCESS_WRITE);
+	if (status < 0) {
+		mlog_errno(status);
+		goto bail_commit;
+	}
+
+	di->i_flags &= ~cpu_to_le32(OCFS2_DIO_ORPHANED_FL);
+	di->i_dio_orphaned_slot = 0;
+
+	if (update_isize) {
+		status = ocfs2_set_inode_size(handle, inode, di_bh, end);
+		if (status)
+			mlog_errno(status);
+	} else
+		ocfs2_journal_dirty(handle, di_bh);
+
+bail_commit:
+	ocfs2_commit_trans(osb, handle);
+
+bail_unlock_orphan:
+	ocfs2_inode_unlock(orphan_dir_inode, 1);
+	mutex_unlock(&orphan_dir_inode->i_mutex);
+	brelse(orphan_dir_bh);
+	iput(orphan_dir_inode);
+
+bail_unlock_inode:
+	ocfs2_inode_unlock(inode, 1);
+	brelse(di_bh);
+
+bail:
+	return status;
+}
+
 int ocfs2_mv_orphaned_inode_to_new(struct inode *dir,
 				   struct inode *inode,
 				   struct dentry *dentry)
diff --git a/fs/ocfs2/namei.h b/fs/ocfs2/namei.h
index e5d059d..5625540 100644
--- a/fs/ocfs2/namei.h
+++ b/fs/ocfs2/namei.h
@@ -38,6 +38,11 @@ int ocfs2_orphan_del(struct ocfs2_super *osb,
 int ocfs2_create_inode_in_orphan(struct inode *dir,
 				 int mode,
 				 struct inode **new_inode);
+int ocfs2_add_inode_to_orphan(struct ocfs2_super *osb,
+		struct inode *inode);
+int ocfs2_del_inode_from_orphan(struct ocfs2_super *osb,
+		struct inode *inode, int update_isize,
+		loff_t end);
 int ocfs2_mv_orphaned_inode_to_new(struct inode *dir,
 				   struct inode *new_inode,
 				   struct dentry *new_dentry);
diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
index 938387a..e933ea2 100644
--- a/fs/ocfs2/ocfs2_fs.h
+++ b/fs/ocfs2/ocfs2_fs.h
@@ -229,6 +229,7 @@
 #define OCFS2_CHAIN_FL		(0x00000400)	/* Chain allocator */
 #define OCFS2_DEALLOC_FL	(0x00000800)	/* Truncate log */
 #define OCFS2_QUOTA_FL		(0x00001000)	/* Quota file */
+#define OCFS2_DIO_ORPHANED_FL	(0X00002000)	/* On the orphan list especially for dio */

 /*
  * Flags on ocfs2_dinode.i_dyn_features
@@ -729,7 +730,9 @@ struct ocfs2_dinode {
 					   inode belongs to.  Only valid
 					   if allocated from a
 					   discontiguous block group */
-/*A0*/	__le64 i_reserved2[3];
+/*A0*/	__le16 i_dio_orphaned_slot;	/* only used for append dio write */
+	__le16 i_reserved1[3];
+	__le64 i_reserved2[2];
 /*B8*/	union {
 		__le64 i_pad1;		/* Generic way to refer to this
 					   64bit union */
diff --git a/fs/ocfs2/ocfs2_trace.h b/fs/ocfs2/ocfs2_trace.h
index 6cb019b..2d471cc 100644
--- a/fs/ocfs2/ocfs2_trace.h
+++ b/fs/ocfs2/ocfs2_trace.h
@@ -2373,6 +2373,9 @@ DEFINE_OCFS2_ULL_EVENT(ocfs2_orphan_add_begin);

 DEFINE_OCFS2_ULL_UINT_EVENT(ocfs2_orphan_add_end);

+DEFINE_OCFS2_ULL_EVENT(ocfs2_dio_orphan_add_begin);
+DEFINE_OCFS2_ULL_UINT_EVENT(ocfs2_dio_orphan_add_end);
+
 TRACE_EVENT(ocfs2_orphan_del,
 	TP_PROTO(unsigned long long dir, const char *name, int namelen),
 	TP_ARGS(dir, name, namelen),
-- 
1.8.4.3
