From: Joel Becker <joel.becker@oracle.com>
Date: Fri, 13 Feb 2009 14:16:11 -0800
Subject: [Ocfs2-devel] [PATCH 24/40] ocfs2: ocfs2_append_rec_to_path() loses
	struct inode.
In-Reply-To: <1234563387-17101-1-git-send-email-joel.becker@oracle.com>
References: <1234563387-17101-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1234563387-17101-25-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

It can be swapped with an ocfs2_extent_tree.  The function
ocfs2_adjust_rightmost_records() goes along for the ride.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/alloc.c |   29 +++++++++++++++--------------
 1 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index cfa390c..e2c4825 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -3710,8 +3710,8 @@ rotate:
 	ocfs2_rotate_leaf(el, insert_rec);
 }
 
-static void ocfs2_adjust_rightmost_records(struct inode *inode,
-					   handle_t *handle,
+static void ocfs2_adjust_rightmost_records(handle_t *handle,
+					   struct ocfs2_extent_tree *et,
 					   struct ocfs2_path *path,
 					   struct ocfs2_extent_rec *insert_rec)
 {
@@ -3729,9 +3729,9 @@ static void ocfs2_adjust_rightmost_records(struct inode *inode,
 
 		next_free = le16_to_cpu(el->l_next_free_rec);
 		if (next_free == 0) {
-			ocfs2_error(inode->i_sb,
-				    "Dinode %llu has a bad extent list",
-				    (unsigned long long)OCFS2_I(inode)->ip_blkno);
+			ocfs2_error(ocfs2_metadata_cache_get_super(et->et_ci),
+				    "Owner %llu has a bad extent list",
+				    (unsigned long long)ocfs2_metadata_cache_owner(et->et_ci));
 			ret = -EIO;
 			return;
 		}
@@ -3751,7 +3751,8 @@ static void ocfs2_adjust_rightmost_records(struct inode *inode,
 	}
 }
 
-static int ocfs2_append_rec_to_path(struct inode *inode, handle_t *handle,
+static int ocfs2_append_rec_to_path(handle_t *handle,
+				    struct ocfs2_extent_tree *et,
 				    struct ocfs2_extent_rec *insert_rec,
 				    struct ocfs2_path *right_path,
 				    struct ocfs2_path **ret_left_path)
@@ -3779,8 +3780,8 @@ static int ocfs2_append_rec_to_path(struct inode *inode, handle_t *handle,
 	    (next_free == 1 && ocfs2_is_empty_extent(&el->l_recs[0]))) {
 		u32 left_cpos;
 
-		ret = ocfs2_find_cpos_for_left_leaf(inode->i_sb, right_path,
-						    &left_cpos);
+		ret = ocfs2_find_cpos_for_left_leaf(ocfs2_metadata_cache_get_super(et->et_ci),
+						    right_path, &left_cpos);
 		if (ret) {
 			mlog_errno(ret);
 			goto out;
@@ -3802,7 +3803,7 @@ static int ocfs2_append_rec_to_path(struct inode *inode, handle_t *handle,
 				goto out;
 			}
 
-			ret = ocfs2_find_path(INODE_CACHE(inode), left_path,
+			ret = ocfs2_find_path(et->et_ci, left_path,
 					      left_cpos);
 			if (ret) {
 				mlog_errno(ret);
@@ -3816,13 +3817,13 @@ static int ocfs2_append_rec_to_path(struct inode *inode, handle_t *handle,
 		}
 	}
 
-	ret = ocfs2_journal_access_path(INODE_CACHE(inode), handle, right_path);
+	ret = ocfs2_journal_access_path(et->et_ci, handle, right_path);
 	if (ret) {
 		mlog_errno(ret);
 		goto out;
 	}
 
-	ocfs2_adjust_rightmost_records(inode, handle, right_path, insert_rec);
+	ocfs2_adjust_rightmost_records(handle, et, right_path, insert_rec);
 
 	*ret_left_path = left_path;
 	ret = 0;
@@ -4092,7 +4093,7 @@ static int ocfs2_do_insert_extent(struct inode *inode,
 		}
 	} else if (type->ins_appending == APPEND_TAIL
 		   && type->ins_contig != CONTIG_LEFT) {
-		ret = ocfs2_append_rec_to_path(inode, handle, insert_rec,
+		ret = ocfs2_append_rec_to_path(handle, et, insert_rec,
 					       right_path, &left_path);
 		if (ret) {
 			mlog_errno(ret);
@@ -5150,7 +5151,7 @@ static int ocfs2_truncate_rec(struct inode *inode, handle_t *handle,
 			 * be deleted by the rotate code.
 			 */
 			rec = &el->l_recs[next_free - 1];
-			ocfs2_adjust_rightmost_records(inode, handle, path,
+			ocfs2_adjust_rightmost_records(handle, et, path,
 						       rec);
 		}
 	} else if (le32_to_cpu(rec->e_cpos) == cpos) {
@@ -5162,7 +5163,7 @@ static int ocfs2_truncate_rec(struct inode *inode, handle_t *handle,
 		/* Remove rightmost portion of the record */
 		le16_add_cpu(&rec->e_leaf_clusters, -len);
 		if (is_rightmost_tree_rec)
-			ocfs2_adjust_rightmost_records(inode, handle, path, rec);
+			ocfs2_adjust_rightmost_records(handle, et, path, rec);
 	} else {
 		/* Caller should have trapped this. */
 		mlog(ML_ERROR, "Inode %llu: Invalid record truncate: (%u, %u) "
-- 
1.5.6.5
