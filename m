From: Tao Ma <tao.ma@oracle.com>
Date: Wed, 14 Jul 2010 15:53:20 +0800
Subject: [Ocfs2-devel] [PATCH 2/5] ocfs2: pass struct file* to
	ocfs2_prepare_inode_for_write.
In-Reply-To: <4C3D6CBA.10401@oracle.com>
References: <4C3D6CBA.10401@oracle.com>
Message-ID: <1279094003-10209-2-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

struct file * has file_ra_state to store the readahead state
and data. So pass this to ocfs2_prepare_inode_for_write. so
that it can be used in ocfs2_refcount_cow.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/file.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 6a13ea6..d61137e 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -1864,6 +1864,7 @@ out:
 }
 
 static int ocfs2_prepare_inode_for_refcount(struct inode *inode,
+					    struct file *file,
 					    loff_t pos, size_t count,
 					    int *meta_level)
 {
@@ -1889,7 +1890,7 @@ out:
 	return ret;
 }
 
-static int ocfs2_prepare_inode_for_write(struct dentry *dentry,
+static int ocfs2_prepare_inode_for_write(struct file *file,
 					 loff_t *ppos,
 					 size_t count,
 					 int appending,
@@ -1897,6 +1898,7 @@ static int ocfs2_prepare_inode_for_write(struct dentry *dentry,
 					 int *has_refcount)
 {
 	int ret = 0, meta_level = 0;
+	struct dentry *dentry = file->f_path.dentry;
 	struct inode *inode = dentry->d_inode;
 	loff_t saved_pos, end;
 
@@ -1952,6 +1954,7 @@ static int ocfs2_prepare_inode_for_write(struct dentry *dentry,
 			meta_level = -1;
 
 			ret = ocfs2_prepare_inode_for_refcount(inode,
+							       file,
 							       saved_pos,
 							       count,
 							       &meta_level);
@@ -2066,7 +2069,7 @@ relock:
 	}
 
 	can_do_direct = direct_io;
-	ret = ocfs2_prepare_inode_for_write(file->f_path.dentry, ppos,
+	ret = ocfs2_prepare_inode_for_write(file, ppos,
 					    iocb->ki_left, appending,
 					    &can_do_direct, &has_refcount);
 	if (ret < 0) {
@@ -2196,7 +2199,7 @@ static int ocfs2_splice_to_file(struct pipe_inode_info *pipe,
 {
 	int ret;
 
-	ret = ocfs2_prepare_inode_for_write(out->f_path.dentry,	&sd->pos,
+	ret = ocfs2_prepare_inode_for_write(out, &sd->pos,
 					    sd->total_len, 0, NULL, NULL);
 	if (ret < 0) {
 		mlog_errno(ret);
-- 
1.7.1.GIT
