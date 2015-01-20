From: Joseph Qi <joseph.qi@huawei.com>
Date: Tue, 20 Jan 2015 16:03:43 +0800
Subject: [Ocfs2-devel] [PATCH 2/9 v6] ocfs2: add functions to add and remove
 inode in orphan dir
Message-ID: <54BE0BDF.4080604@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Add functions to add inode to orphan dir and remove inode in orphan dir.
Here we do not call ocfs2_prepare_orphan_dir and ocfs2_orphan_add
directly.  Because append O_DIRECT will add inode to orphan two and may
result in more than one orphan entry for the same inode.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Cc: Weiwei Wang <wangww631@huawei.com>
---
 fs/ocfs2/inode.c    |   2 +-
 fs/ocfs2/journal.h  |   5 ++
 fs/ocfs2/namei.c    | 248 ++++++++++++++++++++++++++++++++++++++++++++++------
 fs/ocfs2/namei.h    |   8 +-
 fs/ocfs2/ocfs2_fs.h |   6 +-
 5 files changed, 239 insertions(+), 30 deletions(-)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index c8b25de..3025c0d 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -648,7 +648,7 @@ static int ocfs2_remove_inode(struct inode *inode,

 	if (!(OCFS2_I(inode)->ip_flags & OCFS2_INODE_SKIP_ORPHAN_DIR)) {
 		status = ocfs2_orphan_del(osb, handle, orphan_dir_inode, inode,
-					  orphan_dir_bh);
+					  orphan_dir_bh, false);
 		if (status < 0) {
 			mlog_errno(status);
 			goto bail_commit;
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
index 914c121..b069d6d 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -79,7 +79,8 @@ static int ocfs2_prepare_orphan_dir(struct ocfs2_super *osb,
 				    struct inode **ret_orphan_dir,
 				    u64 blkno,
 				    char *name,
-				    struct ocfs2_dir_lookup_result *lookup);
+				    struct ocfs2_dir_lookup_result *lookup,
+				    bool dio);

 static int ocfs2_orphan_add(struct ocfs2_super *osb,
 			    handle_t *handle,
@@ -87,7 +88,8 @@ static int ocfs2_orphan_add(struct ocfs2_super *osb,
 			    struct buffer_head *fe_bh,
 			    char *name,
 			    struct ocfs2_dir_lookup_result *lookup,
-			    struct inode *orphan_dir_inode);
+			    struct inode *orphan_dir_inode,
+			    bool dio);

 static int ocfs2_create_symlink_data(struct ocfs2_super *osb,
 				     handle_t *handle,
@@ -104,6 +106,8 @@ static int ocfs2_double_lock(struct ocfs2_super *osb,
 static void ocfs2_double_unlock(struct inode *inode1, struct inode *inode2);
 /* An orphan dir name is an 8 byte value, printed as a hex string */
 #define OCFS2_ORPHAN_NAMELEN ((int)(2 * sizeof(u64)))
+#define OCFS2_DIO_ORPHAN_PREFIX "dio-"
+#define OCFS2_DIO_ORPHAN_PREFIX_LEN 4

 static struct dentry *ocfs2_lookup(struct inode *dir, struct dentry *dentry,
 				   unsigned int flags)
@@ -952,7 +956,8 @@ static int ocfs2_unlink(struct inode *dir,
 	if (ocfs2_inode_is_unlinkable(inode)) {
 		status = ocfs2_prepare_orphan_dir(osb, &orphan_dir,
 						  OCFS2_I(inode)->ip_blkno,
-						  orphan_name, &orphan_insert);
+						  orphan_name, &orphan_insert,
+						  false);
 		if (status < 0) {
 			mlog_errno(status);
 			goto leave;
@@ -1004,7 +1009,7 @@ static int ocfs2_unlink(struct inode *dir,

 	if (is_unlinkable) {
 		status = ocfs2_orphan_add(osb, handle, inode, fe_bh,
-				orphan_name, &orphan_insert, orphan_dir);
+				orphan_name, &orphan_insert, orphan_dir, false);
 		if (status < 0)
 			mlog_errno(status);
 	}
@@ -1440,7 +1445,8 @@ static int ocfs2_rename(struct inode *old_dir,
 		if (S_ISDIR(new_inode->i_mode) || (new_inode->i_nlink == 1)) {
 			status = ocfs2_prepare_orphan_dir(osb, &orphan_dir,
 						OCFS2_I(new_inode)->ip_blkno,
-						orphan_name, &orphan_insert);
+						orphan_name, &orphan_insert,
+						false);
 			if (status < 0) {
 				mlog_errno(status);
 				goto bail;
@@ -1507,7 +1513,7 @@ static int ocfs2_rename(struct inode *old_dir,
 		if (should_add_orphan) {
 			status = ocfs2_orphan_add(osb, handle, new_inode,
 					newfe_bh, orphan_name,
-					&orphan_insert, orphan_dir);
+					&orphan_insert, orphan_dir, false);
 			if (status < 0) {
 				mlog_errno(status);
 				goto bail;
@@ -2088,12 +2094,28 @@ static int __ocfs2_prepare_orphan_dir(struct inode *orphan_dir_inode,
 				      struct buffer_head *orphan_dir_bh,
 				      u64 blkno,
 				      char *name,
-				      struct ocfs2_dir_lookup_result *lookup)
+				      struct ocfs2_dir_lookup_result *lookup,
+				      bool dio)
 {
 	int ret;
 	struct ocfs2_super *osb = OCFS2_SB(orphan_dir_inode->i_sb);
+	int namelen = dio ?
+			(OCFS2_DIO_ORPHAN_PREFIX_LEN + OCFS2_ORPHAN_NAMELEN) :
+			OCFS2_ORPHAN_NAMELEN;
+
+	if (dio) {
+		ret = snprintf(name, OCFS2_DIO_ORPHAN_PREFIX_LEN + 1, "%s",
+				OCFS2_DIO_ORPHAN_PREFIX);
+		if (ret != OCFS2_DIO_ORPHAN_PREFIX_LEN) {
+			ret = -EINVAL;
+			mlog_errno(ret);
+			return ret;
+		}

-	ret = ocfs2_blkno_stringify(blkno, name);
+		ret = ocfs2_blkno_stringify(blkno,
+				name + OCFS2_DIO_ORPHAN_PREFIX_LEN);
+	} else
+		ret = ocfs2_blkno_stringify(blkno, name);
 	if (ret < 0) {
 		mlog_errno(ret);
 		return ret;
@@ -2101,7 +2123,7 @@ static int __ocfs2_prepare_orphan_dir(struct inode *orphan_dir_inode,

 	ret = ocfs2_prepare_dir_for_insert(osb, orphan_dir_inode,
 					   orphan_dir_bh, name,
-					   OCFS2_ORPHAN_NAMELEN, lookup);
+					   namelen, lookup);
 	if (ret < 0) {
 		mlog_errno(ret);
 		return ret;
@@ -2128,7 +2150,8 @@ static int ocfs2_prepare_orphan_dir(struct ocfs2_super *osb,
 				    struct inode **ret_orphan_dir,
 				    u64 blkno,
 				    char *name,
-				    struct ocfs2_dir_lookup_result *lookup)
+				    struct ocfs2_dir_lookup_result *lookup,
+				    bool dio)
 {
 	struct inode *orphan_dir_inode = NULL;
 	struct buffer_head *orphan_dir_bh = NULL;
@@ -2142,7 +2165,7 @@ static int ocfs2_prepare_orphan_dir(struct ocfs2_super *osb,
 	}

 	ret = __ocfs2_prepare_orphan_dir(orphan_dir_inode, orphan_dir_bh,
-					 blkno, name, lookup);
+					 blkno, name, lookup, dio);
 	if (ret < 0) {
 		mlog_errno(ret);
 		goto out;
@@ -2170,12 +2193,16 @@ static int ocfs2_orphan_add(struct ocfs2_super *osb,
 			    struct buffer_head *fe_bh,
 			    char *name,
 			    struct ocfs2_dir_lookup_result *lookup,
-			    struct inode *orphan_dir_inode)
+			    struct inode *orphan_dir_inode,
+			    bool dio)
 {
 	struct buffer_head *orphan_dir_bh = NULL;
 	int status = 0;
 	struct ocfs2_dinode *orphan_fe;
 	struct ocfs2_dinode *fe = (struct ocfs2_dinode *) fe_bh->b_data;
+	int namelen = dio ?
+			(OCFS2_DIO_ORPHAN_PREFIX_LEN + OCFS2_ORPHAN_NAMELEN) :
+			OCFS2_ORPHAN_NAMELEN;

 	trace_ocfs2_orphan_add_begin(
 				(unsigned long long)OCFS2_I(inode)->ip_blkno);
@@ -2219,7 +2246,7 @@ static int ocfs2_orphan_add(struct ocfs2_super *osb,
 	ocfs2_journal_dirty(handle, orphan_dir_bh);

 	status = __ocfs2_add_entry(handle, orphan_dir_inode, name,
-				   OCFS2_ORPHAN_NAMELEN, inode,
+				   namelen, inode,
 				   OCFS2_I(inode)->ip_blkno,
 				   orphan_dir_bh, lookup);
 	if (status < 0) {
@@ -2227,13 +2254,21 @@ static int ocfs2_orphan_add(struct ocfs2_super *osb,
 		goto rollback;
 	}

-	fe->i_flags |= cpu_to_le32(OCFS2_ORPHANED_FL);
-	OCFS2_I(inode)->ip_flags &= ~OCFS2_INODE_SKIP_ORPHAN_DIR;
+	if (dio) {
+		/* Update flag OCFS2_DIO_ORPHANED_FL and record the orphan
+		 * slot.
+		 */
+		fe->i_flags |= cpu_to_le32(OCFS2_DIO_ORPHANED_FL);
+		fe->i_dio_orphaned_slot = cpu_to_le16(osb->slot_num);
+	} else {
+		fe->i_flags |= cpu_to_le32(OCFS2_ORPHANED_FL);
+		OCFS2_I(inode)->ip_flags &= ~OCFS2_INODE_SKIP_ORPHAN_DIR;

-	/* Record which orphan dir our inode now resides
-	 * in. delete_inode will use this to determine which orphan
-	 * dir to lock. */
-	fe->i_orphaned_slot = cpu_to_le16(osb->slot_num);
+		/* Record which orphan dir our inode now resides
+		 * in. delete_inode will use this to determine which orphan
+		 * dir to lock. */
+		fe->i_orphaned_slot = cpu_to_le16(osb->slot_num);
+	}

 	ocfs2_journal_dirty(handle, fe_bh);

@@ -2258,14 +2293,29 @@ int ocfs2_orphan_del(struct ocfs2_super *osb,
 		     handle_t *handle,
 		     struct inode *orphan_dir_inode,
 		     struct inode *inode,
-		     struct buffer_head *orphan_dir_bh)
+		     struct buffer_head *orphan_dir_bh,
+		     bool dio)
 {
-	char name[OCFS2_ORPHAN_NAMELEN + 1];
+	int namelen = dio ? OCFS2_DIO_ORPHAN_PREFIX_LEN + OCFS2_ORPHAN_NAMELEN :
+			OCFS2_ORPHAN_NAMELEN;
+	char name[namelen + 1];
 	struct ocfs2_dinode *orphan_fe;
 	int status = 0;
 	struct ocfs2_dir_lookup_result lookup = { NULL, };

-	status = ocfs2_blkno_stringify(OCFS2_I(inode)->ip_blkno, name);
+	if (dio) {
+		status = snprintf(name, OCFS2_DIO_ORPHAN_PREFIX_LEN + 1, "%s",
+				OCFS2_DIO_ORPHAN_PREFIX);
+		if (status != OCFS2_DIO_ORPHAN_PREFIX_LEN) {
+			status = -EINVAL;
+			mlog_errno(status);
+			return status;
+		}
+
+		status = ocfs2_blkno_stringify(OCFS2_I(inode)->ip_blkno,
+				name + OCFS2_DIO_ORPHAN_PREFIX_LEN);
+	} else
+		status = ocfs2_blkno_stringify(OCFS2_I(inode)->ip_blkno, name);
 	if (status < 0) {
 		mlog_errno(status);
 		goto leave;
@@ -2273,10 +2323,10 @@ int ocfs2_orphan_del(struct ocfs2_super *osb,

 	trace_ocfs2_orphan_del(
 	     (unsigned long long)OCFS2_I(orphan_dir_inode)->ip_blkno,
-	     name, OCFS2_ORPHAN_NAMELEN);
+	     name, namelen);

 	/* find it's spot in the orphan directory */
-	status = ocfs2_find_entry(name, OCFS2_ORPHAN_NAMELEN, orphan_dir_inode,
+	status = ocfs2_find_entry(name, namelen, orphan_dir_inode,
 				  &lookup);
 	if (status) {
 		mlog_errno(status);
@@ -2376,7 +2426,8 @@ static int ocfs2_prep_new_orphaned_file(struct inode *dir,
 	}

 	ret = __ocfs2_prepare_orphan_dir(orphan_dir, orphan_dir_bh,
-					 di_blkno, orphan_name, orphan_insert);
+					 di_blkno, orphan_name, orphan_insert,
+					 false);
 	if (ret < 0) {
 		mlog_errno(ret);
 		goto out;
@@ -2482,7 +2533,7 @@ int ocfs2_create_inode_in_orphan(struct inode *dir,

 	di = (struct ocfs2_dinode *)new_di_bh->b_data;
 	status = ocfs2_orphan_add(osb, handle, inode, new_di_bh, orphan_name,
-				  &orphan_insert, orphan_dir);
+				  &orphan_insert, orphan_dir, false);
 	if (status < 0) {
 		mlog_errno(status);
 		goto leave;
@@ -2527,6 +2578,149 @@ leave:
 	return status;
 }

+int ocfs2_add_inode_to_orphan(struct ocfs2_super *osb,
+	struct inode *inode)
+{
+	char orphan_name[OCFS2_DIO_ORPHAN_PREFIX_LEN + OCFS2_ORPHAN_NAMELEN + 1];
+	struct inode *orphan_dir_inode = NULL;
+	struct ocfs2_dir_lookup_result orphan_insert = { NULL, };
+	struct buffer_head *di_bh = NULL;
+	int status = 0;
+	handle_t *handle = NULL;
+
+	status = ocfs2_inode_lock(inode, &di_bh, 1);
+	if (status < 0) {
+		mlog_errno(status);
+		goto bail;
+	}
+
+	status = ocfs2_prepare_orphan_dir(osb, &orphan_dir_inode,
+			OCFS2_I(inode)->ip_blkno,
+			orphan_name,
+			&orphan_insert,
+			true);
+	if (status < 0) {
+		mlog_errno(status);
+		goto bail_unlock_inode;
+	}
+
+	handle = ocfs2_start_trans(osb,
+			OCFS2_INODE_ADD_TO_ORPHAN_CREDITS);
+	if (IS_ERR(handle)) {
+		status = PTR_ERR(handle);
+		goto bail_unlock_orphan;
+	}
+
+	status = ocfs2_orphan_add(osb, handle, inode, di_bh, orphan_name,
+			&orphan_insert, orphan_dir_inode, true);
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
+		status = -ENOENT;
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
+	BUG_ON(!(di->i_flags & cpu_to_le32(OCFS2_DIO_ORPHANED_FL)));
+
+	status = ocfs2_orphan_del(osb, handle, orphan_dir_inode,
+				inode, orphan_dir_bh, true);
+	if (status < 0) {
+		mlog_errno(status);
+		goto bail_commit;
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
@@ -2615,7 +2809,7 @@ int ocfs2_mv_orphaned_inode_to_new(struct inode *dir,
 	}

 	status = ocfs2_orphan_del(osb, handle, orphan_dir_inode, inode,
-				  orphan_dir_bh);
+				  orphan_dir_bh, false);
 	if (status < 0) {
 		mlog_errno(status);
 		goto out_commit;
diff --git a/fs/ocfs2/namei.h b/fs/ocfs2/namei.h
index e5d059d..5ddecce 100644
--- a/fs/ocfs2/namei.h
+++ b/fs/ocfs2/namei.h
@@ -34,10 +34,16 @@ int ocfs2_orphan_del(struct ocfs2_super *osb,
 		     handle_t *handle,
 		     struct inode *orphan_dir_inode,
 		     struct inode *inode,
-		     struct buffer_head *orphan_dir_bh);
+		     struct buffer_head *orphan_dir_bh,
+		     bool dio);
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
index 938387a..cf4fa43 100644
--- a/fs/ocfs2/ocfs2_fs.h
+++ b/fs/ocfs2/ocfs2_fs.h
@@ -229,6 +229,8 @@
 #define OCFS2_CHAIN_FL		(0x00000400)	/* Chain allocator */
 #define OCFS2_DEALLOC_FL	(0x00000800)	/* Truncate log */
 #define OCFS2_QUOTA_FL		(0x00001000)	/* Quota file */
+#define OCFS2_DIO_ORPHANED_FL	(0X00002000)	/* On the orphan list especially
+						 * for dio */

 /*
  * Flags on ocfs2_dinode.i_dyn_features
@@ -729,7 +731,9 @@ struct ocfs2_dinode {
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
-- 
1.8.4.3
