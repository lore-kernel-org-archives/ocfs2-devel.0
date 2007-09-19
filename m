From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Wed Sep 19 13:12:23 2007
Subject: [Ocfs2-devel] [PATCH 06/15] ocfs2: Remove open coded readdir()
Message-ID: <200709192012.l8JKCGEE029300@rgmgw2.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

ocfs2_queue_orphans() has an open coded readdir loop which can easily just
use a directory accessor function.

Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
---
 fs/ocfs2/dir.c     |   28 +++++++++++--
 fs/ocfs2/dir.h     |    7 +--
 fs/ocfs2/journal.c |  118 +++++++++++++++++++--------------------------------
 3 files changed, 70 insertions(+), 83 deletions(-)

diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index dbfa6f6..a75c340 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -81,10 +81,10 @@ static int ocfs2_do_extend_dir(struct super_block *sb,
 			       struct ocfs2_alloc_context *meta_ac,
 			       struct buffer_head **new_bh);
 
-int ocfs2_check_dir_entry(struct inode * dir,
-			  struct ocfs2_dir_entry * de,
-			  struct buffer_head * bh,
-			  unsigned long offset)
+static int ocfs2_check_dir_entry(struct inode * dir,
+				 struct ocfs2_dir_entry * de,
+				 struct buffer_head * bh,
+				 unsigned long offset)
 {
 	const char *error_msg = NULL;
 	const int rlen = le16_to_cpu(de->rec_len);
@@ -532,6 +532,26 @@ out:
 }
 
 /*
+ * This is intended to be called from inside other kernel functions,
+ * so we fake some arguments.
+ */
+int ocfs2_dir_foreach(struct inode *inode, loff_t *f_pos, void *priv,
+		      filldir_t filldir)
+{
+	int ret = 0;
+	unsigned long version = inode->i_version;
+
+	while (*f_pos < i_size_read(inode)) {
+		ret = ocfs2_dir_foreach_blk(inode, &version, f_pos, priv,
+					    filldir);
+		if (ret)
+			break;
+	}
+
+	return 0;
+}
+
+/*
  * ocfs2_readdir()
  *
  */
diff --git a/fs/ocfs2/dir.h b/fs/ocfs2/dir.h
index 7bf9c0a..075d0e9 100644
--- a/fs/ocfs2/dir.h
+++ b/fs/ocfs2/dir.h
@@ -62,6 +62,8 @@ int ocfs2_find_files_on_disk(const char *name,
 			     struct buffer_head **dirent_bh,
 			     struct ocfs2_dir_entry **dirent);
 int ocfs2_readdir(struct file *filp, void *dirent, filldir_t filldir);
+int ocfs2_dir_foreach(struct inode *inode, loff_t *f_pos, void *priv,
+		      filldir_t filldir);
 int ocfs2_prepare_dir_for_insert(struct ocfs2_super *osb,
 				 struct inode *dir,
 				 struct buffer_head *parent_fe_bh,
@@ -76,9 +78,4 @@ int ocfs2_fill_new_dir(struct ocfs2_super *osb,
 		       struct buffer_head *fe_bh,
 		       struct ocfs2_alloc_context *data_ac);
 
-int ocfs2_check_dir_entry(struct inode *dir,
-			  struct ocfs2_dir_entry *de,
-			  struct buffer_head *bh,
-			  unsigned long offset);
-
 #endif /* OCFS2_DIR_H */
diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index 8bbfc80..f9d01e2 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -1213,17 +1213,49 @@ bail:
 	return status;
 }
 
+struct ocfs2_orphan_filldir_priv {
+	struct inode		*head;
+	struct ocfs2_super	*osb;
+};
+
+static int ocfs2_orphan_filldir(void *priv, const char *name, int name_len,
+				loff_t pos, u64 ino, unsigned type)
+{
+	struct ocfs2_orphan_filldir_priv *p = priv;
+	struct inode *iter;
+
+	if (name_len == 1 && !strncmp(".", name, 1))
+		return 0;
+	if (name_len == 2 && !strncmp("..", name, 2))
+		return 0;
+
+	/* Skip bad inodes so that recovery can continue */
+	iter = ocfs2_iget(p->osb, ino,
+			  OCFS2_FI_FLAG_ORPHAN_RECOVERY);
+	if (IS_ERR(iter))
+		return 0;
+
+	mlog(0, "queue orphan %llu\n",
+	     (unsigned long long)OCFS2_I(iter)->ip_blkno);
+	/* No locking is required for the next_orphan queue as there
+	 * is only ever a single process doing orphan recovery. */
+	OCFS2_I(iter)->ip_next_orphan = p->head;
+	p->head = iter;
+
+	return 0;
+}
+
 static int ocfs2_queue_orphans(struct ocfs2_super *osb,
 			       int slot,
 			       struct inode **head)
 {
 	int status;
 	struct inode *orphan_dir_inode = NULL;
-	struct inode *iter;
-	unsigned long offset, blk, local;
-	struct buffer_head *bh = NULL;
-	struct ocfs2_dir_entry *de;
-	struct super_block *sb = osb->sb;
+	struct ocfs2_orphan_filldir_priv priv;
+	loff_t pos = 0;
+
+	priv.osb = osb;
+	priv.head = *head;
 
 	orphan_dir_inode = ocfs2_get_system_file_inode(osb,
 						       ORPHAN_DIR_SYSTEM_INODE,
@@ -1241,77 +1273,15 @@ static int ocfs2_queue_orphans(struct ocfs2_super *osb,
 		goto out;
 	}
 
-	offset = 0;
-	iter = NULL;
-	while(offset < i_size_read(orphan_dir_inode)) {
-		blk = offset >> sb->s_blocksize_bits;
-
-		bh = ocfs2_bread(orphan_dir_inode, blk, &status, 0);
-		if (!bh)
-			status = -EINVAL;
-		if (status < 0) {
-			if (bh)
-				brelse(bh);
-			mlog_errno(status);
-			goto out_unlock;
-		}
-
-		local = 0;
-		while(offset < i_size_read(orphan_dir_inode)
-		      && local < sb->s_blocksize) {
-			de = (struct ocfs2_dir_entry *) (bh->b_data + local);
-
-			if (!ocfs2_check_dir_entry(orphan_dir_inode,
-						  de, bh, local)) {
-				status = -EINVAL;
-				mlog_errno(status);
-				brelse(bh);
-				goto out_unlock;
-			}
-
-			local += le16_to_cpu(de->rec_len);
-			offset += le16_to_cpu(de->rec_len);
-
-			/* I guess we silently fail on no inode? */
-			if (!le64_to_cpu(de->inode))
-				continue;
-			if (de->file_type > OCFS2_FT_MAX) {
-				mlog(ML_ERROR,
-				     "block %llu contains invalid de: "
-				     "inode = %llu, rec_len = %u, "
-				     "name_len = %u, file_type = %u, "
-				     "name='%.*s'\n",
-				     (unsigned long long)bh->b_blocknr,
-				     (unsigned long long)le64_to_cpu(de->inode),
-				     le16_to_cpu(de->rec_len),
-				     de->name_len,
-				     de->file_type,
-				     de->name_len,
-				     de->name);
-				continue;
-			}
-			if (de->name_len == 1 && !strncmp(".", de->name, 1))
-				continue;
-			if (de->name_len == 2 && !strncmp("..", de->name, 2))
-				continue;
-
-			iter = ocfs2_iget(osb, le64_to_cpu(de->inode),
-					  OCFS2_FI_FLAG_ORPHAN_RECOVERY);
-			if (IS_ERR(iter))
-				continue;
-
-			mlog(0, "queue orphan %llu\n",
-			     (unsigned long long)OCFS2_I(iter)->ip_blkno);
-			/* No locking is required for the next_orphan
-			 * queue as there is only ever a single
-			 * process doing orphan recovery. */
-			OCFS2_I(iter)->ip_next_orphan = *head;
-			*head = iter;
-		}
-		brelse(bh);
+	status = ocfs2_dir_foreach(orphan_dir_inode, &pos, &priv,
+				   ocfs2_orphan_filldir);
+	if (status) {
+		mlog_errno(status);
+		goto out;
 	}
 
-out_unlock:
+	*head = priv.head;
+
 	ocfs2_meta_unlock(orphan_dir_inode, 0);
 out:
 	mutex_unlock(&orphan_dir_inode->i_mutex);
-- 
1.5.0.6
