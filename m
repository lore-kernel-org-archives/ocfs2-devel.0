From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Wed Sep 19 13:12:21 2007
Subject: [Ocfs2-devel] [PATCH 07/15] ocfs2: Implement ocfs2_empty_dir() as a
	caller of ocfs2_dir_foreach()
Message-ID: <200709192012.l8JKCGWI012183@agmgw2.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

We can preserve the behavior of ocfs2_empty_dir(), while getting rid of the
open coded directory walk by just providing a smart filldir callback. This
also automatically gets to use the dir readahead code, though in this case
any advantage is minor at best.

Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
---
 fs/ocfs2/dir.c |   96 ++++++++++++++++++++++++++-----------------------------
 fs/ocfs2/dir.h |    2 +-
 2 files changed, 46 insertions(+), 52 deletions(-)

diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index a75c340..4bb5440 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -660,67 +660,61 @@ bail:
 	return ret;
 }
 
+struct ocfs2_empty_dir_priv {
+	unsigned seen_dot;
+	unsigned seen_dot_dot;
+	unsigned seen_other;
+};
+static int ocfs2_empty_dir_filldir(void *priv, const char *name, int name_len,
+				   loff_t pos, u64 ino, unsigned type)
+{
+	struct ocfs2_empty_dir_priv *p = priv;
+
+	/*
+	 * Check the positions of "." and ".." records to be sure
+	 * they're in the correct place.
+	 */
+	if (name_len == 1 && !strncmp(".", name, 1) && pos == 0) {
+		p->seen_dot = 1;
+		return 0;
+	}
+
+	if (name_len == 2 && !strncmp("..", name, 2) &&
+	    pos == OCFS2_DIR_REC_LEN(1)) {
+		p->seen_dot_dot = 1;
+		return 0;
+	}
+
+	p->seen_other = 1;
+	return 1;
+}
 /*
  * routine to check that the specified directory is empty (for rmdir)
+ *
+ * Returns 1 if dir is empty, zero otherwise.
  */
 int ocfs2_empty_dir(struct inode *inode)
 {
-	unsigned long offset;
-	struct buffer_head * bh;
-	struct ocfs2_dir_entry * de, * de1;
-	struct super_block * sb;
-	int err;
+	int ret;
+	loff_t start = 0;
+	struct ocfs2_empty_dir_priv priv;
 
-	sb = inode->i_sb;
-	if ((i_size_read(inode) <
-	     (OCFS2_DIR_REC_LEN(1) + OCFS2_DIR_REC_LEN(2))) ||
-	    !(bh = ocfs2_bread(inode, 0, &err, 0))) {
-	    	mlog(ML_ERROR, "bad directory (dir #%llu) - no data block\n",
-		     (unsigned long long)OCFS2_I(inode)->ip_blkno);
-		return 1;
-	}
+	memset(&priv, 0, sizeof(priv));
 
-	de = (struct ocfs2_dir_entry *) bh->b_data;
-	de1 = (struct ocfs2_dir_entry *)
-			((char *)de + le16_to_cpu(de->rec_len));
-	if ((le64_to_cpu(de->inode) != OCFS2_I(inode)->ip_blkno) ||
-			!le64_to_cpu(de1->inode) ||
-			strcmp(".", de->name) ||
-			strcmp("..", de1->name)) {
-	    	mlog(ML_ERROR, "bad directory (dir #%llu) - no `.' or `..'\n",
+	ret = ocfs2_dir_foreach(inode, &start, &priv, ocfs2_empty_dir_filldir);
+	if (ret)
+		mlog_errno(ret);
+
+	if (!priv.seen_dot || !priv.seen_dot_dot) {
+		mlog(ML_ERROR, "bad directory (dir #%llu) - no `.' or `..'\n",
 		     (unsigned long long)OCFS2_I(inode)->ip_blkno);
-		brelse(bh);
+		/*
+		 * XXX: Is it really safe to allow an unlink to continue?
+		 */
 		return 1;
 	}
-	offset = le16_to_cpu(de->rec_len) + le16_to_cpu(de1->rec_len);
-	de = (struct ocfs2_dir_entry *)((char *)de1 + le16_to_cpu(de1->rec_len));
-	while (offset < i_size_read(inode) ) {
-		if (!bh || (void *)de >= (void *)(bh->b_data + sb->s_blocksize)) {
-			brelse(bh);
-			bh = ocfs2_bread(inode,
-					 offset >> sb->s_blocksize_bits, &err, 0);
-			if (!bh) {
-				mlog(ML_ERROR, "dir %llu has a hole at %lu\n",
-				     (unsigned long long)OCFS2_I(inode)->ip_blkno, offset);
-				offset += sb->s_blocksize;
-				continue;
-			}
-			de = (struct ocfs2_dir_entry *) bh->b_data;
-		}
-		if (!ocfs2_check_dir_entry(inode, de, bh, offset)) {
-			brelse(bh);
-			return 1;
-		}
-		if (le64_to_cpu(de->inode)) {
-			brelse(bh);
-			return 0;
-		}
-		offset += le16_to_cpu(de->rec_len);
-		de = (struct ocfs2_dir_entry *)
-			((char *)de + le16_to_cpu(de->rec_len));
-	}
-	brelse(bh);
-	return 1;
+
+	return !priv.seen_other;
 }
 
 int ocfs2_fill_new_dir(struct ocfs2_super *osb,
diff --git a/fs/ocfs2/dir.h b/fs/ocfs2/dir.h
index 075d0e9..3e65f91 100644
--- a/fs/ocfs2/dir.h
+++ b/fs/ocfs2/dir.h
@@ -54,7 +54,7 @@ static inline int ocfs2_add_entry(handle_t *handle,
 int ocfs2_check_dir_for_entry(struct inode *dir,
 			      const char *name,
 			      int namelen);
-int ocfs2_empty_dir(struct inode *inode);  /* FIXME: to namei.c */
+int ocfs2_empty_dir(struct inode *inode);
 int ocfs2_find_files_on_disk(const char *name,
 			     int namelen,
 			     u64 *blkno,
-- 
1.5.0.6
