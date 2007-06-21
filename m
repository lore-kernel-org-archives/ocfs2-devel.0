From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Thu Jun 21 12:01:47 2007
Subject: [Ocfs2-devel] [-mm PATCH] ocfs2: ->fallocate() support
Message-ID: <20070621190143.GC17713@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, Amit Arora <aarora@in.ibm.com>, ocfs2-devel@oss.oracle.com

Plug ocfs2 into the ->fallocate() callback. We only support FA_ALLOCATE for
now - FA_DEALLOCATE will come later.

Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>

---

 fs/ocfs2/file.c |   67 ++++++++++++++++++++++++++++++++++++++++++++-----------
 1 files changed, 53 insertions(+), 14 deletions(-)

f1281cd91f406365d417efbb7418f7b644300d5c
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index c3e01e0..35b5a3f 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -1264,26 +1264,19 @@ out:
 /*
  * Parts of this function taken from xfs_change_file_space()
  */
-int ocfs2_change_file_space(struct file *file, unsigned int cmd,
-			    struct ocfs2_space_resv *sr)
+static int __ocfs2_change_file_space(struct file *file, struct inode *inode,
+				     loff_t f_pos, unsigned int cmd,
+				     struct ocfs2_space_resv *sr,
+				     int allow_past_eof)
 {
 	int ret;
 	s64 llen;
-	struct inode *inode = file->f_path.dentry->d_inode;
+	loff_t size;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	struct buffer_head *di_bh = NULL;
 	handle_t *handle;
 	unsigned long long max_off = ocfs2_max_file_offset(inode->i_sb->s_blocksize_bits);
 
-	if (!ocfs2_writes_unwritten_extents(osb))
-		return -ENOTTY;
-
-	if (!S_ISREG(inode->i_mode))
-		return -EINVAL;
-
-	if (!(file->f_mode & FMODE_WRITE))
-		return -EBADF;
-
 	if (ocfs2_is_hard_readonly(osb) || ocfs2_is_soft_readonly(osb))
 		return -EROFS;
 
@@ -1313,7 +1306,7 @@ int ocfs2_change_file_space(struct file 
 	case 0: /*SEEK_SET*/
 		break;
 	case 1: /*SEEK_CUR*/
-		sr->l_start += file->f_pos;
+		sr->l_start += f_pos;
 		break;
 	case 2: /*SEEK_END*/
 		sr->l_start += i_size_read(inode);
@@ -1334,6 +1327,8 @@ int ocfs2_change_file_space(struct file 
 		goto out_meta_unlock;
 	}
 
+	size = sr->l_start + sr->l_len;
+
 	if (cmd == OCFS2_IOC_RESVSP || cmd == OCFS2_IOC_RESVSP64) {
 		if (sr->l_len <= 0) {
 			ret = -EINVAL;
@@ -1341,7 +1336,7 @@ int ocfs2_change_file_space(struct file 
 		}
 	}
 
-	if (should_remove_suid(file->f_path.dentry)) {
+	if (file && should_remove_suid(file->f_path.dentry)) {
 		ret = __ocfs2_write_remove_suid(inode, di_bh);
 		if (ret) {
 			mlog_errno(ret);
@@ -1371,6 +1366,9 @@ int ocfs2_change_file_space(struct file 
 		goto out_meta_unlock;
 	}
 
+	if (!allow_past_eof && i_size_read(inode) < size)
+		i_size_write(inode, size);
+
 	inode->i_ctime = inode->i_mtime = CURRENT_TIME;
 	ret = ocfs2_mark_inode_dirty(handle, inode, di_bh);
 	if (ret < 0)
@@ -1389,6 +1387,46 @@ out:
 	return ret;
 }
 
+int ocfs2_change_file_space(struct file *file, unsigned int cmd,
+			    struct ocfs2_space_resv *sr)
+{
+	struct inode *inode = file->f_path.dentry->d_inode;
+
+	if (!ocfs2_writes_unwritten_extents(OCFS2_SB(inode->i_sb)))
+		return -ENOTTY;
+
+	if (!S_ISREG(inode->i_mode))
+		return -EINVAL;
+
+	if (!(file->f_mode & FMODE_WRITE))
+		return -EBADF;
+
+	return __ocfs2_change_file_space(file, inode, file->f_pos, cmd, sr, 1);
+}
+
+static long ocfs2_fallocate(struct inode *inode, int mode, loff_t offset,
+			    loff_t len)
+{
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	struct ocfs2_space_resv sr;
+
+	/*
+	 * Currently only allocation is supported and on regular files
+	 */
+	if (mode != FA_ALLOCATE || !ocfs2_writes_unwritten_extents(osb))
+		return -EOPNOTSUPP;
+
+	if (S_ISDIR(inode->i_mode))
+		return -ENODEV;
+
+	sr.l_whence = 0;
+	sr.l_start = (s64)offset;
+	sr.l_len = (s64)len;
+
+	return __ocfs2_change_file_space(NULL, inode, offset,
+					 OCFS2_IOC_RESVSP64, &sr, 0);
+}
+
 static int ocfs2_prepare_inode_for_write(struct dentry *dentry,
 					 loff_t *ppos,
 					 size_t count,
@@ -1817,6 +1855,7 @@ const struct inode_operations ocfs2_file
 	.setattr	= ocfs2_setattr,
 	.getattr	= ocfs2_getattr,
 	.permission	= ocfs2_permission,
+	.fallocate	= ocfs2_fallocate,
 };
 
 const struct inode_operations ocfs2_special_file_iops = {
-- 
1.3.3
