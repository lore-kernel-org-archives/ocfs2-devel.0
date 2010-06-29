From: Tao Ma <tao.ma@oracle.com>
Date: Tue, 29 Jun 2010 16:35:38 +0800
Subject: [Ocfs2-devel] [PATCH 1/4] ocfs2: Add struct file to
	ocfs2_refcount_cow.
In-Reply-To: <4C29AE6C.1050205@oracle.com>
References: <4C29AE6C.1050205@oracle.com>
Message-ID: <1277800541-6844-1-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Add a new parameter 'struct file *' to ocfs2_refcount_cow
so that we can add readahead support later.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/aops.c         |    2 +-
 fs/ocfs2/file.c         |   13 ++++++++-----
 fs/ocfs2/refcounttree.c |    4 +++-
 fs/ocfs2/refcounttree.h |    3 ++-
 4 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 4dfaa6e..5f94923 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -1691,7 +1691,7 @@ int ocfs2_write_begin_nolock(struct address_space *mapping,
 		mlog_errno(ret);
 		goto out;
 	} else if (ret == 1) {
-		ret = ocfs2_refcount_cow(inode, di_bh,
+		ret = ocfs2_refcount_cow(inode, NULL, di_bh,
 					 wc->w_cpos, wc->w_clen, UINT_MAX);
 		if (ret) {
 			mlog_errno(ret);
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index ca527ca..06780f0 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -361,7 +361,7 @@ static int ocfs2_cow_file_pos(struct inode *inode,
 	if (!(ext_flags & OCFS2_EXT_REFCOUNTED))
 		goto out;
 
-	return ocfs2_refcount_cow(inode, fe_bh, cpos, 1, cpos+1);
+	return ocfs2_refcount_cow(inode, NULL, fe_bh, cpos, 1, cpos+1);
 
 out:
 	return status;
@@ -1864,6 +1864,7 @@ out:
 }
 
 static int ocfs2_prepare_inode_for_refcount(struct inode *inode,
+					    struct file *file,
 					    loff_t pos, size_t count,
 					    int *meta_level)
 {
@@ -1881,7 +1882,7 @@ static int ocfs2_prepare_inode_for_refcount(struct inode *inode,
 
 	*meta_level = 1;
 
-	ret = ocfs2_refcount_cow(inode, di_bh, cpos, clusters, UINT_MAX);
+	ret = ocfs2_refcount_cow(inode, file, di_bh, cpos, clusters, UINT_MAX);
 	if (ret)
 		mlog_errno(ret);
 out:
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
@@ -2193,7 +2196,7 @@ static int ocfs2_splice_to_file(struct pipe_inode_info *pipe,
 {
 	int ret;
 
-	ret = ocfs2_prepare_inode_for_write(out->f_path.dentry,	&sd->pos,
+	ret = ocfs2_prepare_inode_for_write(out, &sd->pos,
 					    sd->total_len, 0, NULL, NULL);
 	if (ret < 0) {
 		mlog_errno(ret);
diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index 4793f36..7636174 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -3398,6 +3398,7 @@ static int ocfs2_replace_cow(struct ocfs2_cow_context *context)
  * unrefcounted extent.
  */
 static int ocfs2_refcount_cow_hunk(struct inode *inode,
+				   struct file *file,
 				   struct buffer_head *di_bh,
 				   u32 cpos, u32 write_len, u32 max_cpos)
 {
@@ -3475,6 +3476,7 @@ out:
  * clusters between cpos and cpos+write_len are safe to modify.
  */
 int ocfs2_refcount_cow(struct inode *inode,
+		       struct file *file,
 		       struct buffer_head *di_bh,
 		       u32 cpos, u32 write_len, u32 max_cpos)
 {
@@ -3494,7 +3496,7 @@ int ocfs2_refcount_cow(struct inode *inode,
 			num_clusters = write_len;
 
 		if (ext_flags & OCFS2_EXT_REFCOUNTED) {
-			ret = ocfs2_refcount_cow_hunk(inode, di_bh, cpos,
+			ret = ocfs2_refcount_cow_hunk(inode, file, di_bh, cpos,
 						      num_clusters, max_cpos);
 			if (ret) {
 				mlog_errno(ret);
diff --git a/fs/ocfs2/refcounttree.h b/fs/ocfs2/refcounttree.h
index 9983ba1..29cba0e 100644
--- a/fs/ocfs2/refcounttree.h
+++ b/fs/ocfs2/refcounttree.h
@@ -52,7 +52,8 @@ int ocfs2_prepare_refcount_change_for_del(struct inode *inode,
 					  u32 clusters,
 					  int *credits,
 					  int *ref_blocks);
-int ocfs2_refcount_cow(struct inode *inode, struct buffer_head *di_bh,
+int ocfs2_refcount_cow(struct inode *inode,
+		       struct file *filep, struct buffer_head *di_bh,
 		       u32 cpos, u32 write_len, u32 max_cpos);
 
 typedef int (ocfs2_post_refcount_func)(struct inode *inode,
-- 
1.7.1.GIT
