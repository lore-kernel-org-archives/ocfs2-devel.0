From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Wed Sep 19 13:12:22 2007
Subject: [Ocfs2-devel] [PATCH 09/15] ocfs2: Rename cleanups
Message-ID: <200709192012.l8JKCG62012197@agmgw2.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

ocfs2_rename() does direct manipulation of the dirent it's gotten back from
a directory search. Wrap this manipulation inside of a function so that we
can transparently change directory update behavior in the future. As an
added bonus, this gets rid of an ugly macro.

Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
---
 fs/ocfs2/dir.c   |   22 ++++++++++++++++++++++
 fs/ocfs2/dir.h   |    3 +++
 fs/ocfs2/namei.c |   53 ++++++++++++++++++++++-------------------------------
 3 files changed, 47 insertions(+), 31 deletions(-)

diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index 4791683..31db7e3 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -271,6 +271,28 @@ cleanup_and_exit:
 	return ret;
 }
 
+int ocfs2_update_entry(struct inode *dir, handle_t *handle,
+		       struct buffer_head *de_bh, struct ocfs2_dir_entry *de,
+		       struct inode *new_entry_inode)
+{
+	int ret;
+
+	ret = ocfs2_journal_access(handle, dir, de_bh,
+				   OCFS2_JOURNAL_ACCESS_WRITE);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	de->inode = cpu_to_le64(OCFS2_I(new_entry_inode)->ip_blkno);
+	ocfs2_set_de_type(de, new_entry_inode->i_mode);
+
+	ocfs2_journal_dirty(handle, de_bh);
+
+out:
+	return ret;
+}
+
 /*
  * ocfs2_delete_entry deletes a directory entry by merging it with the
  * previous entry
diff --git a/fs/ocfs2/dir.h b/fs/ocfs2/dir.h
index d03eaaa..ce48b90 100644
--- a/fs/ocfs2/dir.h
+++ b/fs/ocfs2/dir.h
@@ -50,6 +50,9 @@ static inline int ocfs2_add_entry(handle_t *handle,
 				 dentry->d_name.name, dentry->d_name.len,
 				 inode, blkno, parent_fe_bh, insert_bh);
 }
+int ocfs2_update_entry(struct inode *dir, handle_t *handle,
+		       struct buffer_head *de_bh, struct ocfs2_dir_entry *de,
+		       struct inode *new_entry_inode);
 
 int ocfs2_check_dir_for_entry(struct inode *dir,
 			      const char *name,
diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 98aeebc..d2f0335 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -933,11 +933,6 @@ static void ocfs2_double_unlock(struct inode *inode1, struct inode *inode2)
 		ocfs2_meta_unlock(inode2, 1);
 }
 
-#define PARENT_INO(buffer) \
-	((struct ocfs2_dir_entry *) \
-	 ((char *)buffer + \
-	  le16_to_cpu(((struct ocfs2_dir_entry *)buffer)->rec_len)))->inode
-
 static int ocfs2_rename(struct inode *old_dir,
 			struct dentry *old_dentry,
 			struct inode *new_dir,
@@ -959,8 +954,8 @@ static int ocfs2_rename(struct inode *old_dir,
 	handle_t *handle = NULL;
 	struct buffer_head *old_dir_bh = NULL;
 	struct buffer_head *new_dir_bh = NULL;
-	struct ocfs2_dir_entry *old_de = NULL, *new_de = NULL; // dirent for old_dentry
-							       // and new_dentry
+	struct ocfs2_dir_entry *old_inode_dot_dot_de = NULL, *old_de = NULL,
+		*new_de = NULL;
 	struct buffer_head *new_de_bh = NULL, *old_de_bh = NULL; // bhs for above
 	struct buffer_head *old_inode_de_bh = NULL; // if old_dentry is a dir,
 						    // this is the 1st dirent bh
@@ -1044,19 +1039,26 @@ static int ocfs2_rename(struct inode *old_dir,
 	}
 
 	if (S_ISDIR(old_inode->i_mode)) {
-		status = -EIO;
-		old_inode_de_bh = ocfs2_bread(old_inode, 0, &status, 0);
-		if (!old_inode_de_bh)
+		u64 old_inode_parent;
+
+		status = ocfs2_find_files_on_disk("..", 2, &old_inode_parent,
+						  old_inode, &old_inode_de_bh,
+						  &old_inode_dot_dot_de);
+		if (status) {
+			status = -EIO;
 			goto bail;
+		}
 
-		status = -EIO;
-		if (le64_to_cpu(PARENT_INO(old_inode_de_bh->b_data)) !=
-		    OCFS2_I(old_dir)->ip_blkno)
+		if (old_inode_parent != OCFS2_I(old_dir)->ip_blkno) {
+			status = -EIO;
 			goto bail;
-		status = -EMLINK;
-		if (!new_inode && new_dir!=old_dir &&
-		    new_dir->i_nlink >= OCFS2_LINK_MAX)
+		}
+
+		if (!new_inode && new_dir != old_dir &&
+		    new_dir->i_nlink >= OCFS2_LINK_MAX) {
+			status = -EMLINK;
 			goto bail;
+		}
 	}
 
 	status = -ENOENT;
@@ -1206,20 +1208,13 @@ static int ocfs2_rename(struct inode *old_dir,
 		}
 
 		/* change the dirent to point to the correct inode */
-		status = ocfs2_journal_access(handle, new_dir, new_de_bh,
-					      OCFS2_JOURNAL_ACCESS_WRITE);
+		status = ocfs2_update_entry(new_dir, handle, new_de_bh,
+					    new_de, old_inode);
 		if (status < 0) {
 			mlog_errno(status);
 			goto bail;
 		}
-		new_de->inode = cpu_to_le64(OCFS2_I(old_inode)->ip_blkno);
-		new_de->file_type = old_de->file_type;
 		new_dir->i_version++;
-		status = ocfs2_journal_dirty(handle, new_de_bh);
-		if (status < 0) {
-			mlog_errno(status);
-			goto bail;
-		}
 
 		if (S_ISDIR(new_inode->i_mode))
 			newfe->i_links_count = 0;
@@ -1268,12 +1263,8 @@ static int ocfs2_rename(struct inode *old_dir,
 	}
 	old_dir->i_ctime = old_dir->i_mtime = CURRENT_TIME;
 	if (old_inode_de_bh) {
-		status = ocfs2_journal_access(handle, old_inode,
-					     old_inode_de_bh,
-					     OCFS2_JOURNAL_ACCESS_WRITE);
-		PARENT_INO(old_inode_de_bh->b_data) =
-			cpu_to_le64(OCFS2_I(new_dir)->ip_blkno);
-		status = ocfs2_journal_dirty(handle, old_inode_de_bh);
+		status = ocfs2_update_entry(old_inode, handle, old_inode_de_bh,
+					    old_inode_dot_dot_de, new_dir);
 		old_dir->i_nlink--;
 		if (new_inode) {
 			new_inode->i_nlink--;
-- 
1.5.0.6
