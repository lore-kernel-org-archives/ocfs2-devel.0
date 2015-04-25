From: Xue jiufei <xuejiufei@huawei.com>
Date: Sat, 25 Apr 2015 17:18:27 +0800
Subject: [Ocfs2-devel] [PATCH V3] ocfs2: return error while
 ocfs2_figure_merge_contig_type failing
Message-ID: <553B5BE3.8080307@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Now function ocfs2_figure_merge_contig_type() still return CONTIG_NONE
when some error occurs which will cause unpredictable error.
So return error while ocfs2_figure_merge_contig_type failing.

Signed-off-by: joyce.xue <xuejiufei@huawei.com>
---
 fs/ocfs2/alloc.c | 34 ++++++++++++++++++++++++----------
 1 file changed, 24 insertions(+), 10 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 2d7f76e..ea4c822 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -4311,13 +4311,13 @@ out:
 	return ret;
 }
 
-static enum ocfs2_contig_type
-ocfs2_figure_merge_contig_type(struct ocfs2_extent_tree *et,
+static int ocfs2_figure_merge_contig_type(struct ocfs2_extent_tree *et,
 			       struct ocfs2_path *path,
 			       struct ocfs2_extent_list *el, int index,
-			       struct ocfs2_extent_rec *split_rec)
+			       struct ocfs2_extent_rec *split_rec,
+			       struct ocfs2_merge_ctxt *ctxt)
 {
-	int status;
+	int status = 0;
 	enum ocfs2_contig_type ret = CONTIG_NONE;
 	u32 left_cpos, right_cpos;
 	struct ocfs2_extent_rec *rec = NULL;
@@ -4336,8 +4336,11 @@ ocfs2_figure_merge_contig_type(struct ocfs2_extent_tree *et,
 
 		if (left_cpos != 0) {
 			left_path = ocfs2_new_path_from_path(path);
-			if (!left_path)
+			if (!left_path) {
+				status = -ENOMEM;
+				mlog_errno(status);
 				goto exit;
+			}
 
 			status = ocfs2_find_path(et->et_ci, left_path,
 						 left_cpos);
@@ -4392,8 +4395,11 @@ ocfs2_figure_merge_contig_type(struct ocfs2_extent_tree *et,
 			goto free_left_path;
 
 		right_path = ocfs2_new_path_from_path(path);
-		if (!right_path)
+		if (!right_path) {
+			status = -ENOMEM;
+			mlog_errno(status);
 			goto free_left_path;
+		}
 
 		status = ocfs2_find_path(et->et_ci, right_path, right_cpos);
 		if (status)
@@ -4433,7 +4439,10 @@ free_right_path:
 free_left_path:
 	ocfs2_free_path(left_path);
 exit:
-	return ret;
+	if (status == 0)
+		ctxt->c_contig_type = ret;
+
+	return status;
 }
 
 static void ocfs2_figure_contig_type(struct ocfs2_extent_tree *et,
@@ -5039,9 +5048,14 @@ int ocfs2_split_extent(handle_t *handle,
 		goto out;
 	}
 
-	ctxt.c_contig_type = ocfs2_figure_merge_contig_type(et, path, el,
-							    split_index,
-							    split_rec);
+	ret = ocfs2_figure_merge_contig_type(et, path, el,
+					     split_index,
+					     split_rec,
+					     &ctxt);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
 
 	/*
 	 * The core merge / split code wants to know how much room is
-- 
1.8.4.3
