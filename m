From: Goldwyn Rodrigues <rgoldwyn@gmail.com>
Date: Wed, 15 Jun 2011 10:58:25 -0500
Subject: [Ocfs2-devel] [PATCH 2/2] Disable index if indexed directory find
	fails
Message-ID: <BANLkTikTBRxEhUb8OkwegPp1nSecxRixhA@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Disable directory indexing during a dirent search operation. In order to
disable, the inode's buffer_head has to be passed through.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.de>
---
 fs/ocfs2/dir.c          |   30 ++++++++++++++++++++----------
 fs/ocfs2/dir.h          |   10 +++++-----
 fs/ocfs2/export.c       |    2 +-
 fs/ocfs2/ioctl.c        |    3 ++-
 fs/ocfs2/move_extents.c |    2 +-
 fs/ocfs2/namei.c        |   33 +++++++++++++++++----------------
 fs/ocfs2/sysfile.c      |    2 +-
 7 files changed, 47 insertions(+), 35 deletions(-)

diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index 3a6f6e4..b6cf5d2 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -1113,13 +1113,22 @@ static void ocfs2_dx_disable(struct inode
*dir, struct buffer_head *di_bh)
  * in the indexed directory case, multiple buffers are involved.
  */
 int ocfs2_find_entry(const char *name, int namelen,
-		     struct inode *dir, struct ocfs2_dir_lookup_result *lookup)
+		     struct inode *dir, struct buffer_head *di_bh,
+		     struct ocfs2_dir_lookup_result *lookup)
 {
 	struct buffer_head *bh;
 	struct ocfs2_dir_entry *res_dir = NULL;
+	int ret = 0;
+
+	if (ocfs2_dir_indexed(dir)) {
+		ret = ocfs2_find_entry_dx(name, namelen, dir, lookup);
+		if (ret == -EINVAL) {
+			ocfs2_dx_disable(dir, di_bh);
+			ret = 0;
+		} else
+			return ret;
+	}

-	if (ocfs2_dir_indexed(dir))
-		return ocfs2_find_entry_dx(name, namelen, dir, lookup);

 	/*
 	 * The unindexed dir code only uses part of the lookup
@@ -2083,7 +2092,7 @@ bail_nolock:
 int ocfs2_find_files_on_disk(const char *name,
 			     int namelen,
 			     u64 *blkno,
-			     struct inode *inode,
+			     struct inode *inode, struct buffer_head *di_bh,
 			     struct ocfs2_dir_lookup_result *lookup)
 {
 	int status = -ENOENT;
@@ -2091,7 +2100,7 @@ int ocfs2_find_files_on_disk(const char *name,
 	trace_ocfs2_find_files_on_disk(namelen, name, blkno,
 				(unsigned long long)OCFS2_I(inode)->ip_blkno);

-	status = ocfs2_find_entry(name, namelen, inode, lookup);
+	status = ocfs2_find_entry(name, namelen, inode, di_bh, lookup);
 	if (status)
 		goto leave;

@@ -2107,13 +2116,14 @@ leave:
  * Convenience function for callers which just want the block number
  * mapped to a name and don't require the full dirent info, etc.
  */
-int ocfs2_lookup_ino_from_name(struct inode *dir, const char *name,
-			       int namelen, u64 *blkno)
+int ocfs2_lookup_ino_from_name(struct inode *dir, struct buffer_head *di_bh,
+		const char *name, int namelen, u64 *blkno)
 {
 	int ret;
 	struct ocfs2_dir_lookup_result lookup = { NULL, };

-	ret = ocfs2_find_files_on_disk(name, namelen, blkno, dir, &lookup);
+	ret = ocfs2_find_files_on_disk(name, namelen, blkno, dir, di_bh,
+			&lookup);
 	ocfs2_free_dir_lookup_result(&lookup);

 	return ret;
@@ -2126,7 +2136,7 @@ int ocfs2_lookup_ino_from_name(struct inode
*dir, const char *name,
  *
  * Callers should have i_mutex + a cluster lock on dir
  */
-int ocfs2_check_dir_for_entry(struct inode *dir,
+int ocfs2_check_dir_for_entry(struct inode *dir, struct buffer_head *bh,
 			      const char *name,
 			      int namelen)
 {
@@ -2137,7 +2147,7 @@ int ocfs2_check_dir_for_entry(struct inode *dir,
 		(unsigned long long)OCFS2_I(dir)->ip_blkno, namelen, name);

 	ret = -EEXIST;
-	if (ocfs2_find_entry(name, namelen, dir, &lookup) == 0)
+	if (ocfs2_find_entry(name, namelen, dir, bh, &lookup) == 0)
 		goto bail;

 	ret = 0;
diff --git a/fs/ocfs2/dir.h b/fs/ocfs2/dir.h
index e683f3d..2c271d9 100644
--- a/fs/ocfs2/dir.h
+++ b/fs/ocfs2/dir.h
@@ -55,7 +55,7 @@ struct ocfs2_dir_lookup_result {
 void ocfs2_free_dir_lookup_result(struct ocfs2_dir_lookup_result *res);

 int ocfs2_find_entry(const char *name, int namelen,
-		     struct inode *dir,
+		     struct inode *dir, struct buffer_head *di_bh,
 		     struct ocfs2_dir_lookup_result *lookup);
 int ocfs2_delete_entry(handle_t *handle,
 		       struct inode *dir,
@@ -80,7 +80,7 @@ int ocfs2_update_entry(struct inode *dir, handle_t *handle,
 		       struct ocfs2_dir_lookup_result *res,
 		       struct inode *new_entry_inode);

-int ocfs2_check_dir_for_entry(struct inode *dir,
+int ocfs2_check_dir_for_entry(struct inode *dir, struct buffer_head *di_bh,
 			      const char *name,
 			      int namelen);
 int ocfs2_empty_dir(struct inode *inode);
@@ -88,10 +88,10 @@ int ocfs2_empty_dir(struct inode *inode);
 int ocfs2_find_files_on_disk(const char *name,
 			     int namelen,
 			     u64 *blkno,
-			     struct inode *inode,
+			     struct inode *inode, struct buffer_head *di_bh,
 			     struct ocfs2_dir_lookup_result *res);
-int ocfs2_lookup_ino_from_name(struct inode *dir, const char *name,
-			       int namelen, u64 *blkno);
+int ocfs2_lookup_ino_from_name(struct inode *dir, struct buffer_head *di_bh,
+		const char *name, int namelen, u64 *blkno);
 int ocfs2_readdir(struct file *filp, void *dirent, filldir_t filldir);
 int ocfs2_dir_foreach(struct inode *inode, loff_t *f_pos, void *priv,
 		      filldir_t filldir);
diff --git a/fs/ocfs2/export.c b/fs/ocfs2/export.c
index 745db42..a130bcc 100644
--- a/fs/ocfs2/export.c
+++ b/fs/ocfs2/export.c
@@ -160,7 +160,7 @@ static struct dentry *ocfs2_get_parent(struct dentry *child)
 		goto bail;
 	}

-	status = ocfs2_lookup_ino_from_name(dir, "..", 2, &blkno);
+	status = ocfs2_lookup_ino_from_name(dir, NULL, "..", 2, &blkno);
 	if (status < 0) {
 		parent = ERR_PTR(-ENOENT);
 		goto bail_unlock;
diff --git a/fs/ocfs2/ioctl.c b/fs/ocfs2/ioctl.c
index bc91072..a6078d1 100644
--- a/fs/ocfs2/ioctl.c
+++ b/fs/ocfs2/ioctl.c
@@ -403,6 +403,7 @@ int ocfs2_info_handle_freeinode(struct inode *inode,
 							sizeof(namebuf),
 							type, i);
 			status = ocfs2_lookup_ino_from_name(osb->sys_root_inode,
+							    NULL,
 							    namebuf,
 							    strlen(namebuf),
 							    &blkno);
@@ -691,7 +692,7 @@ int ocfs2_info_handle_freefrag(struct inode *inode,
 	} else {
 		ocfs2_sprintf_system_inode_name(namebuf, sizeof(namebuf), type,
 						OCFS2_INVALID_SLOT);
-		status = ocfs2_lookup_ino_from_name(osb->sys_root_inode,
+		status = ocfs2_lookup_ino_from_name(osb->sys_root_inode, NULL,
 						    namebuf,
 						    strlen(namebuf),
 						    &blkno);
diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
index cd94270..37bb243 100644
--- a/fs/ocfs2/move_extents.c
+++ b/fs/ocfs2/move_extents.c
@@ -380,7 +380,7 @@ static int ocfs2_find_victim_alloc_group(struct
inode *inode,
 	struct ocfs2_group_desc *bg;

 	ocfs2_sprintf_system_inode_name(namebuf, sizeof(namebuf), type, slot);
-	ret = ocfs2_lookup_ino_from_name(osb->sys_root_inode, namebuf,
+	ret = ocfs2_lookup_ino_from_name(osb->sys_root_inode, NULL, namebuf,
 					 strlen(namebuf), &blkno);
 	if (ret) {
 		ret = -ENOENT;
diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index e5d738c..396ca7c 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -123,7 +123,7 @@ static struct dentry *ocfs2_lookup(struct inode
*dir, struct dentry *dentry,
 		goto bail;
 	}

-	status = ocfs2_lookup_ino_from_name(dir, dentry->d_name.name,
+	status = ocfs2_lookup_ino_from_name(dir, NULL, dentry->d_name.name,
 					    dentry->d_name.len, &blkno);
 	if (status < 0)
 		goto bail_add;
@@ -261,8 +261,8 @@ static int ocfs2_mknod(struct inode *dir,
 		goto leave;
 	}

-	status = ocfs2_check_dir_for_entry(dir, dentry->d_name.name,
-					   dentry->d_name.len);
+	status = ocfs2_check_dir_for_entry(dir, parent_fe_bh,
+			dentry->d_name.name, dentry->d_name.len);
 	if (status)
 		goto leave;

@@ -668,8 +668,8 @@ static int ocfs2_link(struct dentry *old_dentry,
 		goto out;
 	}

-	err = ocfs2_check_dir_for_entry(dir, dentry->d_name.name,
-					dentry->d_name.len);
+	err = ocfs2_check_dir_for_entry(dir, parent_fe_bh,
+			dentry->d_name.name, dentry->d_name.len);
 	if (err)
 		goto out;

@@ -827,7 +827,7 @@ static int ocfs2_unlink(struct inode *dir,

 	status = ocfs2_find_files_on_disk(dentry->d_name.name,
 					  dentry->d_name.len, &blkno, dir,
-					  &lookup);
+					  parent_node_bh, &lookup);
 	if (status < 0) {
 		if (status != -ENOENT)
 			mlog_errno(status);
@@ -1148,7 +1148,7 @@ static int ocfs2_rename(struct inode *old_dir,

 		update_dot_dot = 1;
 		status = ocfs2_find_files_on_disk("..", 2, &old_inode_parent,
-						  old_inode,
+						  old_inode, old_inode_bh,
 						  &old_inode_dot_dot_res);
 		if (status) {
 			status = -EIO;
@@ -1167,7 +1167,8 @@ static int ocfs2_rename(struct inode *old_dir,
 		}
 	}

-	status = ocfs2_lookup_ino_from_name(old_dir, old_dentry->d_name.name,
+	status = ocfs2_lookup_ino_from_name(old_dir, NULL,
+					    old_dentry->d_name.name,
 					    old_dentry->d_name.len,
 					    &old_de_ino);
 	if (status) {
@@ -1190,7 +1191,7 @@ static int ocfs2_rename(struct inode *old_dir,
 	 * to delete it */
 	status = ocfs2_find_files_on_disk(new_dentry->d_name.name,
 					  new_dentry->d_name.len,
-					  &newfe_blkno, new_dir,
+					  &newfe_blkno, new_dir, new_dir_bh,
 					  &target_lookup_res);
 	/* The only error we allow here is -ENOENT because the new
 	 * file not existing is perfectly valid. */
@@ -1272,7 +1273,7 @@ static int ocfs2_rename(struct inode *old_dir,
 	} else {
 		BUG_ON(new_dentry->d_parent->d_inode != new_dir);

-		status = ocfs2_check_dir_for_entry(new_dir,
+		status = ocfs2_check_dir_for_entry(new_dir, new_dir_bh,
 						   new_dentry->d_name.name,
 						   new_dentry->d_name.len);
 		if (status)
@@ -1367,7 +1368,7 @@ static int ocfs2_rename(struct inode *old_dir,
 	 * we're dealing with.
 	 */
 	status = ocfs2_find_entry(old_dentry->d_name.name,
-				  old_dentry->d_name.len, old_dir,
+				  old_dentry->d_name.len, old_dir, old_dir_bh,
 				  &old_entry_lookup);
 	if (status)
 		goto bail;
@@ -1634,8 +1635,8 @@ static int ocfs2_symlink(struct inode *dir,
 		goto bail;
 	}

-	status = ocfs2_check_dir_for_entry(dir, dentry->d_name.name,
-					   dentry->d_name.len);
+	status = ocfs2_check_dir_for_entry(dir, parent_fe_bh,
+			dentry->d_name.name, dentry->d_name.len);
 	if (status)
 		goto bail;

@@ -2090,7 +2091,7 @@ int ocfs2_orphan_del(struct ocfs2_super *osb,

 	/* find it's spot in the orphan directory */
 	status = ocfs2_find_entry(name, OCFS2_ORPHAN_NAMELEN, orphan_dir_inode,
-				  &lookup);
+			orphan_dir_bh, &lookup);
 	if (status) {
 		mlog_errno(status);
 		goto leave;
@@ -2373,8 +2374,8 @@ int ocfs2_mv_orphaned_inode_to_new(struct inode *dir,
 		goto leave;
 	}

-	status = ocfs2_check_dir_for_entry(dir, dentry->d_name.name,
-					   dentry->d_name.len);
+	status = ocfs2_check_dir_for_entry(dir, parent_di_bh,
+			dentry->d_name.name, dentry->d_name.len);
 	if (status)
 		goto leave;

diff --git a/fs/ocfs2/sysfile.c b/fs/ocfs2/sysfile.c
index 3d635f4..37cf15f 100644
--- a/fs/ocfs2/sysfile.c
+++ b/fs/ocfs2/sysfile.c
@@ -146,7 +146,7 @@ static struct inode *
_ocfs2_get_system_file_inode(struct ocfs2_super *osb,
 					sizeof(namebuf),
 					type, slot);

-	status = ocfs2_lookup_ino_from_name(osb->sys_root_inode, namebuf,
+	status = ocfs2_lookup_ino_from_name(osb->sys_root_inode, NULL, namebuf,
 					    strlen(namebuf), &blkno);
 	if (status < 0) {
 		goto bail;
-- 
1.7.5.3


-- 
Goldwyn
