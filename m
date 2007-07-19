From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Thu Jul 19 09:55:26 2007
Subject: [Ocfs2-devel] [git patch] ocfs2 ->fallocate support
Message-ID: <20070719165520.GG32734@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

Here's a small patch to plug ocfs2 into the new ->fallocate callback which
was just merged.
	--Mark

Please pull from 'upstream-linus' branch of
git://git.kernel.org/pub/scm/linux/kernel/git/mfasheh/ocfs2.git upstream-linus

to receive the following updates:

 fs/ocfs2/file.c |   77 ++++++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 59 insertions(+), 18 deletions(-)

Mark Fasheh:
      ocfs2: ->fallocate() support

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 004c2ab..5727cd1 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -34,6 +34,7 @@ #include <linux/sched.h>
 #include <linux/splice.h>
 #include <linux/mount.h>
 #include <linux/writeback.h>
+#include <linux/falloc.h>
 
 #define MLOG_MASK_PREFIX ML_INODE
 #include <cluster/masklog.h>
@@ -1504,30 +1505,19 @@ out:
 /*
  * Parts of this function taken from xfs_change_file_space()
  */
-int ocfs2_change_file_space(struct file *file, unsigned int cmd,
-			    struct ocfs2_space_resv *sr)
+static int __ocfs2_change_file_space(struct file *file, struct inode *inode,
+				     loff_t f_pos, unsigned int cmd,
+				     struct ocfs2_space_resv *sr,
+				     int change_size)
 {
 	int ret;
 	s64 llen;
-	struct inode *inode = file->f_path.dentry->d_inode;
+	loff_t size;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	struct buffer_head *di_bh = NULL;
 	handle_t *handle;
 	unsigned long long max_off = ocfs2_max_file_offset(inode->i_sb->s_blocksize_bits);
 
-	if ((cmd == OCFS2_IOC_RESVSP || cmd == OCFS2_IOC_RESVSP64) &&
-	    !ocfs2_writes_unwritten_extents(osb))
-		return -ENOTTY;
-	else if ((cmd == OCFS2_IOC_UNRESVSP || cmd == OCFS2_IOC_UNRESVSP64) &&
-		 !ocfs2_sparse_alloc(osb))
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
 
@@ -1557,7 +1547,7 @@ int ocfs2_change_file_space(struct file 
 	case 0: /*SEEK_SET*/
 		break;
 	case 1: /*SEEK_CUR*/
-		sr->l_start += file->f_pos;
+		sr->l_start += f_pos;
 		break;
 	case 2: /*SEEK_END*/
 		sr->l_start += i_size_read(inode);
@@ -1577,6 +1567,7 @@ int ocfs2_change_file_space(struct file 
 		ret = -EINVAL;
 		goto out_meta_unlock;
 	}
+	size = sr->l_start + sr->l_len;
 
 	if (cmd == OCFS2_IOC_RESVSP || cmd == OCFS2_IOC_RESVSP64) {
 		if (sr->l_len <= 0) {
@@ -1585,7 +1576,7 @@ int ocfs2_change_file_space(struct file 
 		}
 	}
 
-	if (should_remove_suid(file->f_path.dentry)) {
+	if (file && should_remove_suid(file->f_path.dentry)) {
 		ret = __ocfs2_write_remove_suid(inode, di_bh);
 		if (ret) {
 			mlog_errno(ret);
@@ -1628,6 +1619,9 @@ int ocfs2_change_file_space(struct file 
 		goto out_meta_unlock;
 	}
 
+	if (change_size && i_size_read(inode) < size)
+		i_size_write(inode, size);
+
 	inode->i_ctime = inode->i_mtime = CURRENT_TIME;
 	ret = ocfs2_mark_inode_dirty(handle, inode, di_bh);
 	if (ret < 0)
@@ -1646,6 +1640,52 @@ out:
 	return ret;
 }
 
+int ocfs2_change_file_space(struct file *file, unsigned int cmd,
+			    struct ocfs2_space_resv *sr)
+{
+	struct inode *inode = file->f_path.dentry->d_inode;
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);;
+
+	if ((cmd == OCFS2_IOC_RESVSP || cmd == OCFS2_IOC_RESVSP64) &&
+	    !ocfs2_writes_unwritten_extents(osb))
+		return -ENOTTY;
+	else if ((cmd == OCFS2_IOC_UNRESVSP || cmd == OCFS2_IOC_UNRESVSP64) &&
+		 !ocfs2_sparse_alloc(osb))
+		return -ENOTTY;
+
+	if (!S_ISREG(inode->i_mode))
+		return -EINVAL;
+
+	if (!(file->f_mode & FMODE_WRITE))
+		return -EBADF;
+
+	return __ocfs2_change_file_space(file, inode, file->f_pos, cmd, sr, 0);
+}
+
+static long ocfs2_fallocate(struct inode *inode, int mode, loff_t offset,
+			    loff_t len)
+{
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	struct ocfs2_space_resv sr;
+	int change_size = 1;
+
+	if (!ocfs2_writes_unwritten_extents(osb))
+		return -EOPNOTSUPP;
+
+	if (S_ISDIR(inode->i_mode))
+		return -ENODEV;
+
+	if (mode & FALLOC_FL_KEEP_SIZE)
+		change_size = 0;
+
+	sr.l_whence = 0;
+	sr.l_start = (s64)offset;
+	sr.l_len = (s64)len;
+
+	return __ocfs2_change_file_space(NULL, inode, offset,
+					 OCFS2_IOC_RESVSP64, &sr, change_size);
+}
+
 static int ocfs2_prepare_inode_for_write(struct dentry *dentry,
 					 loff_t *ppos,
 					 size_t count,
@@ -2312,6 +2352,7 @@ const struct inode_operations ocfs2_file
 	.setattr	= ocfs2_setattr,
 	.getattr	= ocfs2_getattr,
 	.permission	= ocfs2_permission,
+	.fallocate	= ocfs2_fallocate,
 };
 
 const struct inode_operations ocfs2_special_file_iops = {
