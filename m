From: Mark Fasheh <mfasheh@suse.com>
Date: Wed, 12 Nov 2008 18:24:06 -0800
Subject: [Ocfs2-devel] [PATCH 2/4] ocfs2: Introduce dir lookup helper struct
In-Reply-To: <1226543048-911-1-git-send-email-mfasheh@suse.com>
References: <1226543048-911-1-git-send-email-mfasheh@suse.com>
Message-ID: <1226543048-911-3-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Many directory manipulation calls pass around a tuple of dirent, and it's
containing buffer_head. Dir indexing has a bit more state, but instead of
adding yet more arguments to functions, we introduce 'struct
ocfs2_dir_lookup_result'. In this patch, it simply holds the same tuple, but
future patches will add more state.

Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/dir.c   |  103 ++++++++++++++++++++-----------------
 fs/ocfs2/dir.h   |   30 ++++++-----
 fs/ocfs2/namei.c |  150 ++++++++++++++++++++++++++++--------------------------
 3 files changed, 150 insertions(+), 133 deletions(-)

diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index 026e6eb..fa7870a 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -125,6 +125,11 @@ fail:
 	return NULL;
 }
 
+void ocfs2_free_dir_lookup_result(struct ocfs2_dir_lookup_result *res)
+{
+	brelse(res->dl_leaf_bh);
+}
+
 /*
  * bh passed here can be an inode block or a dir data block, depending
  * on the inode inline data flag.
@@ -352,42 +357,52 @@ cleanup_and_exit:
 /*
  * Try to find an entry of the provided name within 'dir'.
  *
- * If nothing was found, NULL is returned. Otherwise, a buffer_head
- * and pointer to the dir entry are passed back.
+ * If nothing was found, -ENOENT is returned. Otherwise, zero is
+ * returned and the struct 'res' will contain information useful to
+ * other directory manipulation functions.
  *
  * Caller can NOT assume anything about the contents of the
- * buffer_head - it is passed back only so that it can be passed into
+ * buffer_heads - they are passed back only so that it can be passed into
  * any one of the manipulation functions (add entry, delete entry,
  * etc). As an example, bh in the extent directory case is a data
  * block, in the inline-data case it actually points to an inode.
  */
-struct buffer_head *ocfs2_find_entry(const char *name, int namelen,
-				     struct inode *dir,
-				     struct ocfs2_dir_entry **res_dir)
+int ocfs2_find_entry(const char *name, int namelen,
+		     struct inode *dir,
+		     struct ocfs2_dir_lookup_result *lookup)
 {
-	*res_dir = NULL;
+	struct buffer_head *bh;
+	struct ocfs2_dir_entry *res_dir = NULL;
 
 	if (OCFS2_I(dir)->ip_dyn_features & OCFS2_INLINE_DATA_FL)
-		return ocfs2_find_entry_id(name, namelen, dir, res_dir);
+		bh = ocfs2_find_entry_id(name, namelen, dir, &res_dir);
+	else
+		bh = ocfs2_find_entry_el(name, namelen, dir, &res_dir);
+
+	if (bh == NULL)
+		return -ENOENT;
 
-	return ocfs2_find_entry_el(name, namelen, dir, res_dir);
+	lookup->dl_leaf_bh = bh;
+	lookup->dl_entry = res_dir;
+	return 0;
 }
 
 /*
  * Update inode number and type of a previously found directory entry.
  */
 int ocfs2_update_entry(struct inode *dir, handle_t *handle,
-		       struct buffer_head *de_bh, struct ocfs2_dir_entry *de,
+		       struct ocfs2_dir_lookup_result *res,
 		       struct inode *new_entry_inode)
 {
 	int ret;
+	struct ocfs2_dir_entry *de = res->dl_entry;
 
 	/*
 	 * The same code works fine for both inline-data and extent
 	 * based directories, so no need to split this up.
 	 */
 
-	ret = ocfs2_journal_access(handle, dir, de_bh,
+	ret = ocfs2_journal_access(handle, dir, res->dl_leaf_bh,
 				   OCFS2_JOURNAL_ACCESS_WRITE);
 	if (ret) {
 		mlog_errno(ret);
@@ -397,7 +412,7 @@ int ocfs2_update_entry(struct inode *dir, handle_t *handle,
 	de->inode = cpu_to_le64(OCFS2_I(new_entry_inode)->ip_blkno);
 	ocfs2_set_de_type(de, new_entry_inode->i_mode);
 
-	ocfs2_journal_dirty(handle, de_bh);
+	ocfs2_journal_dirty(handle, res->dl_leaf_bh);
 
 out:
 	return ret;
@@ -490,13 +505,14 @@ static inline int ocfs2_delete_entry_el(handle_t *handle,
  */
 int ocfs2_delete_entry(handle_t *handle,
 		       struct inode *dir,
-		       struct ocfs2_dir_entry *de_del,
-		       struct buffer_head *bh)
+		       struct ocfs2_dir_lookup_result *res)
 {
 	if (OCFS2_I(dir)->ip_dyn_features & OCFS2_INLINE_DATA_FL)
-		return ocfs2_delete_entry_id(handle, dir, de_del, bh);
+		return ocfs2_delete_entry_id(handle, dir, res->dl_entry,
+					     res->dl_leaf_bh);
 
-	return ocfs2_delete_entry_el(handle, dir, de_del, bh);
+	return ocfs2_delete_entry_el(handle, dir, res->dl_entry,
+				     res->dl_leaf_bh);
 }
 
 /*
@@ -527,15 +543,15 @@ static inline int ocfs2_dirent_would_fit(struct ocfs2_dir_entry *de,
 /* we don't always have a dentry for what we want to add, so people
  * like orphan dir can call this instead.
  *
- * If you pass me insert_bh, I'll skip the search of the other dir
- * blocks and put the record in there.
+ * The lookup context must have been filled from
+ * ocfs2_prepare_dir_for_insert.
  */
 int __ocfs2_add_entry(handle_t *handle,
 		      struct inode *dir,
 		      const char *name, int namelen,
 		      struct inode *inode, u64 blkno,
 		      struct buffer_head *parent_fe_bh,
-		      struct buffer_head *insert_bh)
+		      struct ocfs2_dir_lookup_result *lookup)
 {
 	unsigned long offset;
 	unsigned short rec_len;
@@ -544,6 +560,7 @@ int __ocfs2_add_entry(handle_t *handle,
 	struct super_block *sb = dir->i_sb;
 	int retval, status;
 	unsigned int size = sb->s_blocksize;
+	struct buffer_head *insert_bh = lookup->dl_leaf_bh;
 	char *data_start = insert_bh->b_data;
 
 	mlog_entry_void();
@@ -917,31 +934,22 @@ int ocfs2_find_files_on_disk(const char *name,
 			     int namelen,
 			     u64 *blkno,
 			     struct inode *inode,
-			     struct buffer_head **dirent_bh,
-			     struct ocfs2_dir_entry **dirent)
+			     struct ocfs2_dir_lookup_result *lookup)
 {
 	int status = -ENOENT;
 
-	mlog_entry("(name=%.*s, blkno=%p, inode=%p, dirent_bh=%p, dirent=%p)\n",
-		   namelen, name, blkno, inode, dirent_bh, dirent);
+	mlog(0, "name=%.*s, blkno=%p, inode=%llu\n", namelen, name, blkno,
+	     (unsigned long long)OCFS2_I(inode)->ip_blkno);
 
-	*dirent_bh = ocfs2_find_entry(name, namelen, inode, dirent);
-	if (!*dirent_bh || !*dirent) {
-		status = -ENOENT;
+	status = ocfs2_find_entry(name, namelen, inode, lookup);
+	if (status)
 		goto leave;
-	}
 
-	*blkno = le64_to_cpu((*dirent)->inode);
+	*blkno = le64_to_cpu(lookup->dl_entry->inode);
 
 	status = 0;
 leave:
-	if (status < 0) {
-		*dirent = NULL;
-		brelse(*dirent_bh);
-		*dirent_bh = NULL;
-	}
 
-	mlog_exit(status);
 	return status;
 }
 
@@ -953,11 +961,10 @@ int ocfs2_lookup_ino_from_name(struct inode *dir, const char *name,
 			       int namelen, u64 *blkno)
 {
 	int ret;
-	struct buffer_head *bh = NULL;
-	struct ocfs2_dir_entry *dirent = NULL;
+	struct ocfs2_dir_lookup_result lookup = { NULL, };
 
-	ret = ocfs2_find_files_on_disk(name, namelen, blkno, dir, &bh, &dirent);
-	brelse(bh);
+	ret = ocfs2_find_files_on_disk(name, namelen, blkno, dir, &lookup);
+	ocfs2_free_dir_lookup_result(&lookup);
 
 	return ret;
 }
@@ -974,20 +981,18 @@ int ocfs2_check_dir_for_entry(struct inode *dir,
 			      int namelen)
 {
 	int ret;
-	struct buffer_head *dirent_bh = NULL;
-	struct ocfs2_dir_entry *dirent = NULL;
+	struct ocfs2_dir_lookup_result lookup = { NULL, };
 
 	mlog_entry("dir %llu, name '%.*s'\n",
 		   (unsigned long long)OCFS2_I(dir)->ip_blkno, namelen, name);
 
 	ret = -EEXIST;
-	dirent_bh = ocfs2_find_entry(name, namelen, dir, &dirent);
-	if (dirent_bh)
+	if (ocfs2_find_entry(name, namelen, dir, &lookup) == 0)
 		goto bail;
 
 	ret = 0;
 bail:
-	brelse(dirent_bh);
+	ocfs2_free_dir_lookup_result(&lookup);
 
 	mlog_exit(ret);
 	return ret;
@@ -1741,12 +1746,18 @@ bail:
 	return status;
 }
 
+/*
+ * Get a directory ready for insert. Any directory allocation required
+ * happens here. Success returns zero, and enough context in the dir
+ * lookup result that ocfs2_add_entry() will be able complete the task
+ * with minimal performance impact.
+ */
 int ocfs2_prepare_dir_for_insert(struct ocfs2_super *osb,
 				 struct inode *dir,
 				 struct buffer_head *parent_fe_bh,
 				 const char *name,
 				 int namelen,
-				 struct buffer_head **ret_de_bh)
+				 struct ocfs2_dir_lookup_result *lookup)
 {
 	int ret;
 	unsigned int blocks_wanted = 1;
@@ -1755,8 +1766,6 @@ int ocfs2_prepare_dir_for_insert(struct ocfs2_super *osb,
 	mlog(0, "getting ready to insert namelen %d into dir %llu\n",
 	     namelen, (unsigned long long)OCFS2_I(dir)->ip_blkno);
 
-	*ret_de_bh = NULL;
-
 	if (!namelen) {
 		ret = -EINVAL;
 		mlog_errno(ret);
@@ -1791,7 +1800,7 @@ int ocfs2_prepare_dir_for_insert(struct ocfs2_super *osb,
 		BUG_ON(!bh);
 	}
 
-	*ret_de_bh = bh;
+	lookup->dl_leaf_bh = bh;
 	bh = NULL;
 out:
 	brelse(bh);
diff --git a/fs/ocfs2/dir.h b/fs/ocfs2/dir.h
index ce48b90..768ee9f 100644
--- a/fs/ocfs2/dir.h
+++ b/fs/ocfs2/dir.h
@@ -26,44 +26,48 @@
 #ifndef OCFS2_DIR_H
 #define OCFS2_DIR_H
 
-struct buffer_head *ocfs2_find_entry(const char *name,
-				     int namelen,
-				     struct inode *dir,
-				     struct ocfs2_dir_entry **res_dir);
+struct ocfs2_dir_lookup_result {
+	struct buffer_head		*dl_leaf_bh;
+	struct ocfs2_dir_entry		*dl_entry;
+};
+void ocfs2_free_dir_lookup_result(struct ocfs2_dir_lookup_result *res);
+
+int ocfs2_find_entry(const char *name, int namelen,
+		     struct inode *dir,
+		     struct ocfs2_dir_lookup_result *lookup);
 int ocfs2_delete_entry(handle_t *handle,
 		       struct inode *dir,
-		       struct ocfs2_dir_entry *de_del,
-		       struct buffer_head *bh);
+		       struct ocfs2_dir_lookup_result *res);
 int __ocfs2_add_entry(handle_t *handle,
 		      struct inode *dir,
 		      const char *name, int namelen,
 		      struct inode *inode, u64 blkno,
 		      struct buffer_head *parent_fe_bh,
-		      struct buffer_head *insert_bh);
+		      struct ocfs2_dir_lookup_result *lookup);
 static inline int ocfs2_add_entry(handle_t *handle,
 				  struct dentry *dentry,
 				  struct inode *inode, u64 blkno,
 				  struct buffer_head *parent_fe_bh,
-				  struct buffer_head *insert_bh)
+				  struct ocfs2_dir_lookup_result *lookup)
 {
 	return __ocfs2_add_entry(handle, dentry->d_parent->d_inode,
 				 dentry->d_name.name, dentry->d_name.len,
-				 inode, blkno, parent_fe_bh, insert_bh);
+				 inode, blkno, parent_fe_bh, lookup);
 }
 int ocfs2_update_entry(struct inode *dir, handle_t *handle,
-		       struct buffer_head *de_bh, struct ocfs2_dir_entry *de,
+		       struct ocfs2_dir_lookup_result *res,
 		       struct inode *new_entry_inode);
 
 int ocfs2_check_dir_for_entry(struct inode *dir,
 			      const char *name,
 			      int namelen);
 int ocfs2_empty_dir(struct inode *inode);
+
 int ocfs2_find_files_on_disk(const char *name,
 			     int namelen,
 			     u64 *blkno,
 			     struct inode *inode,
-			     struct buffer_head **dirent_bh,
-			     struct ocfs2_dir_entry **dirent);
+			     struct ocfs2_dir_lookup_result *res);
 int ocfs2_lookup_ino_from_name(struct inode *dir, const char *name,
 			       int namelen, u64 *blkno);
 int ocfs2_readdir(struct file *filp, void *dirent, filldir_t filldir);
@@ -74,7 +78,7 @@ int ocfs2_prepare_dir_for_insert(struct ocfs2_super *osb,
 				 struct buffer_head *parent_fe_bh,
 				 const char *name,
 				 int namelen,
-				 struct buffer_head **ret_de_bh);
+				 struct ocfs2_dir_lookup_result *lookup);
 struct ocfs2_alloc_context;
 int ocfs2_fill_new_dir(struct ocfs2_super *osb,
 		       handle_t *handle,
diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index f4967e6..d136bdf 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -78,14 +78,14 @@ static int ocfs2_prepare_orphan_dir(struct ocfs2_super *osb,
 				    struct inode **ret_orphan_dir,
 				    struct inode *inode,
 				    char *name,
-				    struct buffer_head **de_bh);
+				    struct ocfs2_dir_lookup_result *lookup);
 
 static int ocfs2_orphan_add(struct ocfs2_super *osb,
 			    handle_t *handle,
 			    struct inode *inode,
 			    struct ocfs2_dinode *fe,
 			    char *name,
-			    struct buffer_head *de_bh,
+			    struct ocfs2_dir_lookup_result *lookup,
 			    struct inode *orphan_dir_inode);
 
 static int ocfs2_create_symlink_data(struct ocfs2_super *osb,
@@ -197,10 +197,10 @@ static int ocfs2_mknod(struct inode *dir,
 	struct ocfs2_super *osb;
 	struct ocfs2_dinode *dirfe;
 	struct buffer_head *new_fe_bh = NULL;
-	struct buffer_head *de_bh = NULL;
 	struct inode *inode = NULL;
 	struct ocfs2_alloc_context *inode_ac = NULL;
 	struct ocfs2_alloc_context *data_ac = NULL;
+	struct ocfs2_dir_lookup_result lookup = { NULL, };
 
 	mlog_entry("(0x%p, 0x%p, %d, %lu, '%.*s')\n", dir, dentry, mode,
 		   (unsigned long)dev, dentry->d_name.len,
@@ -236,7 +236,7 @@ static int ocfs2_mknod(struct inode *dir,
 	/* get a spot inside the dir. */
 	status = ocfs2_prepare_dir_for_insert(osb, dir, parent_fe_bh,
 					      dentry->d_name.name,
-					      dentry->d_name.len, &de_bh);
+					      dentry->d_name.len, &lookup);
 	if (status < 0) {
 		mlog_errno(status);
 		goto leave;
@@ -302,7 +302,7 @@ static int ocfs2_mknod(struct inode *dir,
 
 	status = ocfs2_add_entry(handle, dentry, inode,
 				 OCFS2_I(inode)->ip_blkno, parent_fe_bh,
-				 de_bh);
+				 &lookup);
 	if (status < 0) {
 		mlog_errno(status);
 		goto leave;
@@ -329,9 +329,10 @@ leave:
 		mlog(0, "Disk is full\n");
 
 	brelse(new_fe_bh);
-	brelse(de_bh);
 	brelse(parent_fe_bh);
 
+	ocfs2_free_dir_lookup_result(&lookup);
+
 	if ((status < 0) && inode)
 		iput(inode);
 
@@ -539,9 +540,9 @@ static int ocfs2_link(struct dentry *old_dentry,
 	int err;
 	struct buffer_head *fe_bh = NULL;
 	struct buffer_head *parent_fe_bh = NULL;
-	struct buffer_head *de_bh = NULL;
 	struct ocfs2_dinode *fe = NULL;
 	struct ocfs2_super *osb = OCFS2_SB(dir->i_sb);
+	struct ocfs2_dir_lookup_result lookup = { NULL, };
 
 	mlog_entry("(inode=%lu, old='%.*s' new='%.*s')\n", inode->i_ino,
 		   old_dentry->d_name.len, old_dentry->d_name.name,
@@ -569,7 +570,7 @@ static int ocfs2_link(struct dentry *old_dentry,
 
 	err = ocfs2_prepare_dir_for_insert(osb, dir, parent_fe_bh,
 					   dentry->d_name.name,
-					   dentry->d_name.len, &de_bh);
+					   dentry->d_name.len, &lookup);
 	if (err < 0) {
 		mlog_errno(err);
 		goto out;
@@ -619,7 +620,7 @@ static int ocfs2_link(struct dentry *old_dentry,
 
 	err = ocfs2_add_entry(handle, dentry, inode,
 			      OCFS2_I(inode)->ip_blkno,
-			      parent_fe_bh, de_bh);
+			      parent_fe_bh, &lookup);
 	if (err) {
 		le16_add_cpu(&fe->i_links_count, -1);
 		drop_nlink(inode);
@@ -645,10 +646,11 @@ out_unlock_inode:
 out:
 	ocfs2_inode_unlock(dir, 1);
 
-	brelse(de_bh);
 	brelse(fe_bh);
 	brelse(parent_fe_bh);
 
+	ocfs2_free_dir_lookup_result(&lookup);
+
 	mlog_exit(err);
 
 	return err;
@@ -697,10 +699,9 @@ static int ocfs2_unlink(struct inode *dir,
 	struct buffer_head *fe_bh = NULL;
 	struct buffer_head *parent_node_bh = NULL;
 	handle_t *handle = NULL;
-	struct ocfs2_dir_entry *dirent = NULL;
-	struct buffer_head *dirent_bh = NULL;
 	char orphan_name[OCFS2_ORPHAN_NAMELEN + 1];
-	struct buffer_head *orphan_entry_bh = NULL;
+	struct ocfs2_dir_lookup_result lookup = { NULL, };
+	struct ocfs2_dir_lookup_result orphan_insert = { NULL, };
 
 	mlog_entry("(0x%p, 0x%p, '%.*s')\n", dir, dentry,
 		   dentry->d_name.len, dentry->d_name.name);
@@ -722,8 +723,8 @@ static int ocfs2_unlink(struct inode *dir,
 	}
 
 	status = ocfs2_find_files_on_disk(dentry->d_name.name,
-					  dentry->d_name.len, &blkno,
-					  dir, &dirent_bh, &dirent);
+					  dentry->d_name.len, &blkno, dir,
+					  &lookup);
 	if (status < 0) {
 		if (status != -ENOENT)
 			mlog_errno(status);
@@ -767,8 +768,7 @@ static int ocfs2_unlink(struct inode *dir,
 
 	if (inode_is_unlinkable(inode)) {
 		status = ocfs2_prepare_orphan_dir(osb, &orphan_dir, inode,
-						  orphan_name,
-						  &orphan_entry_bh);
+						  orphan_name, &orphan_insert);
 		if (status < 0) {
 			mlog_errno(status);
 			goto leave;
@@ -794,7 +794,7 @@ static int ocfs2_unlink(struct inode *dir,
 
 	if (inode_is_unlinkable(inode)) {
 		status = ocfs2_orphan_add(osb, handle, inode, fe, orphan_name,
-					  orphan_entry_bh, orphan_dir);
+					  &orphan_insert, orphan_dir);
 		if (status < 0) {
 			mlog_errno(status);
 			goto leave;
@@ -802,7 +802,7 @@ static int ocfs2_unlink(struct inode *dir,
 	}
 
 	/* delete the name from the parent dir */
-	status = ocfs2_delete_entry(handle, dir, dirent, dirent_bh);
+	status = ocfs2_delete_entry(handle, dir, &lookup);
 	if (status < 0) {
 		mlog_errno(status);
 		goto leave;
@@ -847,9 +847,10 @@ leave:
 	}
 
 	brelse(fe_bh);
-	brelse(dirent_bh);
 	brelse(parent_node_bh);
-	brelse(orphan_entry_bh);
+
+	ocfs2_free_dir_lookup_result(&orphan_insert);
+	ocfs2_free_dir_lookup_result(&lookup);
 
 	mlog_exit(status);
 
@@ -935,8 +936,8 @@ static int ocfs2_rename(struct inode *old_dir,
 			struct inode *new_dir,
 			struct dentry *new_dentry)
 {
-	int status = 0, rename_lock = 0, parents_locked = 0;
-	int old_child_locked = 0, new_child_locked = 0;
+	int status = 0, rename_lock = 0, parents_locked = 0, target_exists = 0;
+	int old_child_locked = 0, new_child_locked = 0, update_dot_dot = 0;
 	struct inode *old_inode = old_dentry->d_inode;
 	struct inode *new_inode = new_dentry->d_inode;
 	struct inode *orphan_dir = NULL;
@@ -951,13 +952,13 @@ static int ocfs2_rename(struct inode *old_dir,
 	handle_t *handle = NULL;
 	struct buffer_head *old_dir_bh = NULL;
 	struct buffer_head *new_dir_bh = NULL;
-	struct ocfs2_dir_entry *old_inode_dot_dot_de = NULL, *old_de = NULL,
-		*new_de = NULL;
-	struct buffer_head *new_de_bh = NULL, *old_de_bh = NULL; // bhs for above
-	struct buffer_head *old_inode_de_bh = NULL; // if old_dentry is a dir,
-						    // this is the 1st dirent bh
 	nlink_t old_dir_nlink = old_dir->i_nlink;
 	struct ocfs2_dinode *old_di;
+	struct ocfs2_dir_lookup_result old_inode_dot_dot_res = { NULL, };
+	struct ocfs2_dir_lookup_result target_lookup_res = { NULL, };
+	struct ocfs2_dir_lookup_result old_entry_lookup = { NULL, };
+	struct ocfs2_dir_lookup_result orphan_insert = { NULL, };
+	struct ocfs2_dir_lookup_result target_insert = { NULL, };
 
 	/* At some point it might be nice to break this function up a
 	 * bit. */
@@ -1039,9 +1040,10 @@ static int ocfs2_rename(struct inode *old_dir,
 	if (S_ISDIR(old_inode->i_mode)) {
 		u64 old_inode_parent;
 
+		update_dot_dot = 1;
 		status = ocfs2_find_files_on_disk("..", 2, &old_inode_parent,
-						  old_inode, &old_inode_de_bh,
-						  &old_inode_dot_dot_de);
+						  old_inode,
+						  &old_inode_dot_dot_res);
 		if (status) {
 			status = -EIO;
 			goto bail;
@@ -1082,8 +1084,8 @@ static int ocfs2_rename(struct inode *old_dir,
 	 * to delete it */
 	status = ocfs2_find_files_on_disk(new_dentry->d_name.name,
 					  new_dentry->d_name.len,
-					  &newfe_blkno, new_dir, &new_de_bh,
-					  &new_de);
+					  &newfe_blkno, new_dir,
+					  &target_lookup_res);
 	/* The only error we allow here is -ENOENT because the new
 	 * file not existing is perfectly valid. */
 	if ((status < 0) && (status != -ENOENT)) {
@@ -1092,8 +1094,10 @@ static int ocfs2_rename(struct inode *old_dir,
 		mlog_errno(status);
 		goto bail;
 	}
+	if (status == 0)
+		target_exists = 1;
 
-	if (!new_de && new_inode) {
+	if (!target_exists && new_inode) {
 		/*
 		 * Target was unlinked by another node while we were
 		 * waiting to get to ocfs2_rename(). There isn't
@@ -1106,7 +1110,7 @@ static int ocfs2_rename(struct inode *old_dir,
 
 	/* In case we need to overwrite an existing file, we blow it
 	 * away first */
-	if (new_de) {
+	if (target_exists) {
 		/* VFS didn't think there existed an inode here, but
 		 * someone else in the cluster must have raced our
 		 * rename to create one. Today we error cleanly, in
@@ -1147,8 +1151,8 @@ static int ocfs2_rename(struct inode *old_dir,
 
 		newfe = (struct ocfs2_dinode *) newfe_bh->b_data;
 
-		mlog(0, "aha rename over existing... new_de=%p new_blkno=%llu "
-		     "newfebh=%p bhblocknr=%llu\n", new_de,
+		mlog(0, "aha rename over existing... new_blkno=%llu "
+		     "newfebh=%p bhblocknr=%llu\n",
 		     (unsigned long long)newfe_blkno, newfe_bh, newfe_bh ?
 		     (unsigned long long)newfe_bh->b_blocknr : 0ULL);
 
@@ -1156,7 +1160,7 @@ static int ocfs2_rename(struct inode *old_dir,
 			status = ocfs2_prepare_orphan_dir(osb, &orphan_dir,
 							  new_inode,
 							  orphan_name,
-							  &orphan_entry_bh);
+							  &orphan_insert);
 			if (status < 0) {
 				mlog_errno(status);
 				goto bail;
@@ -1174,7 +1178,7 @@ static int ocfs2_rename(struct inode *old_dir,
 		status = ocfs2_prepare_dir_for_insert(osb, new_dir, new_dir_bh,
 						      new_dentry->d_name.name,
 						      new_dentry->d_name.len,
-						      &insert_entry_bh);
+						      &target_insert);
 		if (status < 0) {
 			mlog_errno(status);
 			goto bail;
@@ -1189,7 +1193,7 @@ static int ocfs2_rename(struct inode *old_dir,
 		goto bail;
 	}
 
-	if (new_de) {
+	if (target_exists) {
 		if (S_ISDIR(new_inode->i_mode)) {
 			if (!ocfs2_empty_dir(new_inode) ||
 			    new_inode->i_nlink != 2) {
@@ -1208,7 +1212,7 @@ static int ocfs2_rename(struct inode *old_dir,
 		    (newfe->i_links_count == cpu_to_le16(1))){
 			status = ocfs2_orphan_add(osb, handle, new_inode,
 						  newfe, orphan_name,
-						  orphan_entry_bh, orphan_dir);
+						  &orphan_insert, orphan_dir);
 			if (status < 0) {
 				mlog_errno(status);
 				goto bail;
@@ -1216,8 +1220,8 @@ static int ocfs2_rename(struct inode *old_dir,
 		}
 
 		/* change the dirent to point to the correct inode */
-		status = ocfs2_update_entry(new_dir, handle, new_de_bh,
-					    new_de, old_inode);
+		status = ocfs2_update_entry(new_dir, handle, &target_lookup_res,
+					    old_inode);
 		if (status < 0) {
 			mlog_errno(status);
 			goto bail;
@@ -1238,7 +1242,7 @@ static int ocfs2_rename(struct inode *old_dir,
 		/* if the name was not found in new_dir, add it now */
 		status = ocfs2_add_entry(handle, new_dentry, old_inode,
 					 OCFS2_I(old_inode)->ip_blkno,
-					 new_dir_bh, insert_entry_bh);
+					 new_dir_bh, &target_insert);
 	}
 
 	old_inode->i_ctime = CURRENT_TIME;
@@ -1265,15 +1269,13 @@ static int ocfs2_rename(struct inode *old_dir,
 	 * because the insert might have changed the type of directory
 	 * we're dealing with.
 	 */
-	old_de_bh = ocfs2_find_entry(old_dentry->d_name.name,
-				     old_dentry->d_name.len,
-				     old_dir, &old_de);
-	if (!old_de_bh) {
-		status = -EIO;
+	status = ocfs2_find_entry(old_dentry->d_name.name,
+				  old_dentry->d_name.len, old_dir,
+				  &old_entry_lookup);
+	if (status)
 		goto bail;
-	}
 
-	status = ocfs2_delete_entry(handle, old_dir, old_de, old_de_bh);
+	status = ocfs2_delete_entry(handle, old_dir, &old_entry_lookup);
 	if (status < 0) {
 		mlog_errno(status);
 		goto bail;
@@ -1284,9 +1286,10 @@ static int ocfs2_rename(struct inode *old_dir,
 		new_inode->i_ctime = CURRENT_TIME;
 	}
 	old_dir->i_ctime = old_dir->i_mtime = CURRENT_TIME;
-	if (old_inode_de_bh) {
-		status = ocfs2_update_entry(old_inode, handle, old_inode_de_bh,
-					    old_inode_dot_dot_de, new_dir);
+
+	if (update_dot_dot) {
+		status = ocfs2_update_entry(old_inode, handle,
+					    &old_inode_dot_dot_res, new_dir);
 		old_dir->i_nlink--;
 		if (new_inode) {
 			new_inode->i_nlink--;
@@ -1360,13 +1363,17 @@ bail:
 
 	if (new_inode)
 		iput(new_inode);
+
+	ocfs2_free_dir_lookup_result(&target_lookup_res);
+	ocfs2_free_dir_lookup_result(&old_entry_lookup);
+	ocfs2_free_dir_lookup_result(&old_inode_dot_dot_res);
+	ocfs2_free_dir_lookup_result(&orphan_insert);
+	ocfs2_free_dir_lookup_result(&target_insert);
+
 	brelse(newfe_bh);
 	brelse(old_inode_bh);
 	brelse(old_dir_bh);
 	brelse(new_dir_bh);
-	brelse(new_de_bh);
-	brelse(old_de_bh);
-	brelse(old_inode_de_bh);
 	brelse(orphan_entry_bh);
 	brelse(insert_entry_bh);
 
@@ -1489,13 +1496,13 @@ static int ocfs2_symlink(struct inode *dir,
 	struct inode *inode = NULL;
 	struct super_block *sb;
 	struct buffer_head *new_fe_bh = NULL;
-	struct buffer_head *de_bh = NULL;
 	struct buffer_head *parent_fe_bh = NULL;
 	struct ocfs2_dinode *fe = NULL;
 	struct ocfs2_dinode *dirfe;
 	handle_t *handle = NULL;
 	struct ocfs2_alloc_context *inode_ac = NULL;
 	struct ocfs2_alloc_context *data_ac = NULL;
+	struct ocfs2_dir_lookup_result lookup = { NULL, };
 
 	mlog_entry("(0x%p, 0x%p, symname='%s' actual='%.*s')\n", dir,
 		   dentry, symname, dentry->d_name.len, dentry->d_name.name);
@@ -1529,7 +1536,7 @@ static int ocfs2_symlink(struct inode *dir,
 
 	status = ocfs2_prepare_dir_for_insert(osb, dir, parent_fe_bh,
 					      dentry->d_name.name,
-					      dentry->d_name.len, &de_bh);
+					      dentry->d_name.len, &lookup);
 	if (status < 0) {
 		mlog_errno(status);
 		goto bail;
@@ -1616,7 +1623,7 @@ static int ocfs2_symlink(struct inode *dir,
 
 	status = ocfs2_add_entry(handle, dentry, inode,
 				 le64_to_cpu(fe->i_blkno), parent_fe_bh,
-				 de_bh);
+				 &lookup);
 	if (status < 0) {
 		mlog_errno(status);
 		goto bail;
@@ -1639,7 +1646,7 @@ bail:
 
 	brelse(new_fe_bh);
 	brelse(parent_fe_bh);
-	brelse(de_bh);
+	ocfs2_free_dir_lookup_result(&lookup);
 	if (inode_ac)
 		ocfs2_free_alloc_context(inode_ac);
 	if (data_ac)
@@ -1687,7 +1694,7 @@ static int ocfs2_prepare_orphan_dir(struct ocfs2_super *osb,
 				    struct inode **ret_orphan_dir,
 				    struct inode *inode,
 				    char *name,
-				    struct buffer_head **de_bh)
+				    struct ocfs2_dir_lookup_result *lookup)
 {
 	struct inode *orphan_dir_inode;
 	struct buffer_head *orphan_dir_bh = NULL;
@@ -1718,7 +1725,7 @@ static int ocfs2_prepare_orphan_dir(struct ocfs2_super *osb,
 
 	status = ocfs2_prepare_dir_for_insert(osb, orphan_dir_inode,
 					      orphan_dir_bh, name,
-					      OCFS2_ORPHAN_NAMELEN, de_bh);
+					      OCFS2_ORPHAN_NAMELEN, lookup);
 	if (status < 0) {
 		ocfs2_inode_unlock(orphan_dir_inode, 1);
 
@@ -1745,7 +1752,7 @@ static int ocfs2_orphan_add(struct ocfs2_super *osb,
 			    struct inode *inode,
 			    struct ocfs2_dinode *fe,
 			    char *name,
-			    struct buffer_head *de_bh,
+			    struct ocfs2_dir_lookup_result *lookup,
 			    struct inode *orphan_dir_inode)
 {
 	struct buffer_head *orphan_dir_bh = NULL;
@@ -1785,7 +1792,7 @@ static int ocfs2_orphan_add(struct ocfs2_super *osb,
 	status = __ocfs2_add_entry(handle, orphan_dir_inode, name,
 				   OCFS2_ORPHAN_NAMELEN, inode,
 				   OCFS2_I(inode)->ip_blkno,
-				   orphan_dir_bh, de_bh);
+				   orphan_dir_bh, lookup);
 	if (status < 0) {
 		mlog_errno(status);
 		goto leave;
@@ -1818,8 +1825,7 @@ int ocfs2_orphan_del(struct ocfs2_super *osb,
 	char name[OCFS2_ORPHAN_NAMELEN + 1];
 	struct ocfs2_dinode *orphan_fe;
 	int status = 0;
-	struct buffer_head *target_de_bh = NULL;
-	struct ocfs2_dir_entry *target_de = NULL;
+	struct ocfs2_dir_lookup_result lookup = { NULL, };
 
 	mlog_entry_void();
 
@@ -1834,17 +1840,15 @@ int ocfs2_orphan_del(struct ocfs2_super *osb,
 	     OCFS2_ORPHAN_NAMELEN);
 
 	/* find it's spot in the orphan directory */
-	target_de_bh = ocfs2_find_entry(name, OCFS2_ORPHAN_NAMELEN,
-					orphan_dir_inode, &target_de);
-	if (!target_de_bh) {
-		status = -ENOENT;
+	status = ocfs2_find_entry(name, OCFS2_ORPHAN_NAMELEN, orphan_dir_inode,
+				  &lookup);
+	if (status) {
 		mlog_errno(status);
 		goto leave;
 	}
 
 	/* remove it from the orphan directory */
-	status = ocfs2_delete_entry(handle, orphan_dir_inode, target_de,
-				    target_de_bh);
+	status = ocfs2_delete_entry(handle, orphan_dir_inode, &lookup);
 	if (status < 0) {
 		mlog_errno(status);
 		goto leave;
@@ -1870,7 +1874,7 @@ int ocfs2_orphan_del(struct ocfs2_super *osb,
 	}
 
 leave:
-	brelse(target_de_bh);
+	ocfs2_free_dir_lookup_result(&lookup);
 
 	mlog_exit(status);
 	return status;
-- 
1.5.4.1
