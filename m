From: Joel Becker <joel.becker@oracle.com>
Date: Fri, 13 Feb 2009 14:16:10 -0800
Subject: [Ocfs2-devel] [PATCH 23/40] ocfs2: ocfs2_grow_branch() no longer
	needs struct inode.
In-Reply-To: <1234563387-17101-1-git-send-email-joel.becker@oracle.com>
References: <1234563387-17101-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1234563387-17101-24-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

It's not really using it other than to pass it to the subfunctions
ocfs2_shift_tree_depth(), ocfs2_find_branch_target(), and
ocfs2_add_branch().  They're not using it either, so they drop the
argument.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/alloc.c |   40 ++++++++++++++++------------------------
 1 files changed, 16 insertions(+), 24 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index c3b7850..cfa390c 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -945,7 +945,7 @@ static inline u32 ocfs2_sum_rightmost_rec(struct ocfs2_extent_list  *el)
 
 /*
  * Add an entire tree branch to our inode. eb_bh is the extent block
- * to start at, if we don't want to start the branch at the dinode
+ * to start at, if we don't want to start the branch at the root
  * structure.
  *
  * last_eb_bh is required as we have to update it's next_leaf pointer
@@ -954,9 +954,7 @@ static inline u32 ocfs2_sum_rightmost_rec(struct ocfs2_extent_list  *el)
  * the new branch will be 'empty' in the sense that every block will
  * contain a single record with cluster count == 0.
  */
-static int ocfs2_add_branch(struct ocfs2_super *osb,
-			    handle_t *handle,
-			    struct inode *inode,
+static int ocfs2_add_branch(handle_t *handle,
 			    struct ocfs2_extent_tree *et,
 			    struct buffer_head *eb_bh,
 			    struct buffer_head **last_eb_bh,
@@ -1020,7 +1018,7 @@ static int ocfs2_add_branch(struct ocfs2_super *osb,
 		BUG_ON(!OCFS2_IS_VALID_EXTENT_BLOCK(eb));
 		eb_el = &eb->h_list;
 
-		status = ocfs2_journal_access_eb(handle, INODE_CACHE(inode), bh,
+		status = ocfs2_journal_access_eb(handle, et->et_ci, bh,
 						 OCFS2_JOURNAL_ACCESS_CREATE);
 		if (status < 0) {
 			mlog_errno(status);
@@ -1060,7 +1058,7 @@ static int ocfs2_add_branch(struct ocfs2_super *osb,
 	 * journal_dirty erroring as it won't unless we've aborted the
 	 * handle (in which case we would never be here) so reserving
 	 * the write with journal_access is all we need to do. */
-	status = ocfs2_journal_access_eb(handle, INODE_CACHE(inode), *last_eb_bh,
+	status = ocfs2_journal_access_eb(handle, et->et_ci, *last_eb_bh,
 					 OCFS2_JOURNAL_ACCESS_WRITE);
 	if (status < 0) {
 		mlog_errno(status);
@@ -1073,7 +1071,7 @@ static int ocfs2_add_branch(struct ocfs2_super *osb,
 		goto bail;
 	}
 	if (eb_bh) {
-		status = ocfs2_journal_access_eb(handle, INODE_CACHE(inode), eb_bh,
+		status = ocfs2_journal_access_eb(handle, et->et_ci, eb_bh,
 						 OCFS2_JOURNAL_ACCESS_WRITE);
 		if (status < 0) {
 			mlog_errno(status);
@@ -1133,9 +1131,7 @@ bail:
  * returns back the new extent block so you can add a branch to it
  * after this call.
  */
-static int ocfs2_shift_tree_depth(struct ocfs2_super *osb,
-				  handle_t *handle,
-				  struct inode *inode,
+static int ocfs2_shift_tree_depth(handle_t *handle,
 				  struct ocfs2_extent_tree *et,
 				  struct ocfs2_alloc_context *meta_ac,
 				  struct buffer_head **ret_new_eb_bh)
@@ -1163,7 +1159,7 @@ static int ocfs2_shift_tree_depth(struct ocfs2_super *osb,
 	eb_el = &eb->h_list;
 	root_el = et->et_root_el;
 
-	status = ocfs2_journal_access_eb(handle, INODE_CACHE(inode), new_eb_bh,
+	status = ocfs2_journal_access_eb(handle, et->et_ci, new_eb_bh,
 					 OCFS2_JOURNAL_ACCESS_CREATE);
 	if (status < 0) {
 		mlog_errno(status);
@@ -1238,8 +1234,7 @@ bail:
  *
  * return status < 0 indicates an error.
  */
-static int ocfs2_find_branch_target(struct ocfs2_super *osb,
-				    struct ocfs2_extent_tree *et,
+static int ocfs2_find_branch_target(struct ocfs2_extent_tree *et,
 				    struct buffer_head **target_bh)
 {
 	int status = 0, i;
@@ -1320,20 +1315,18 @@ bail:
  *
  * *last_eb_bh will be updated by ocfs2_add_branch().
  */
-static int ocfs2_grow_tree(struct inode *inode, handle_t *handle,
-			   struct ocfs2_extent_tree *et, int *final_depth,
-			   struct buffer_head **last_eb_bh,
+static int ocfs2_grow_tree(handle_t *handle, struct ocfs2_extent_tree *et,
+			   int *final_depth, struct buffer_head **last_eb_bh,
 			   struct ocfs2_alloc_context *meta_ac)
 {
 	int ret, shift;
 	struct ocfs2_extent_list *el = et->et_root_el;
 	int depth = le16_to_cpu(el->l_tree_depth);
-	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	struct buffer_head *bh = NULL;
 
 	BUG_ON(meta_ac == NULL);
 
-	shift = ocfs2_find_branch_target(osb, et, &bh);
+	shift = ocfs2_find_branch_target(et, &bh);
 	if (shift < 0) {
 		ret = shift;
 		mlog_errno(ret);
@@ -1350,8 +1343,7 @@ static int ocfs2_grow_tree(struct inode *inode, handle_t *handle,
 		/* ocfs2_shift_tree_depth will return us a buffer with
 		 * the new extent block (so we can pass that to
 		 * ocfs2_add_branch). */
-		ret = ocfs2_shift_tree_depth(osb, handle, inode, et,
-					     meta_ac, &bh);
+		ret = ocfs2_shift_tree_depth(handle, et, meta_ac, &bh);
 		if (ret < 0) {
 			mlog_errno(ret);
 			goto out;
@@ -1377,7 +1369,7 @@ static int ocfs2_grow_tree(struct inode *inode, handle_t *handle,
 	/* call ocfs2_add_branch to add the final part of the tree with
 	 * the new data. */
 	mlog(0, "add branch. bh = %p\n", bh);
-	ret = ocfs2_add_branch(osb, handle, inode, et, bh, last_eb_bh,
+	ret = ocfs2_add_branch(handle, et, bh, last_eb_bh,
 			       meta_ac);
 	if (ret < 0) {
 		mlog_errno(ret);
@@ -4526,7 +4518,7 @@ int ocfs2_insert_extent(struct ocfs2_super *osb,
 	     free_records, insert.ins_tree_depth);
 
 	if (insert.ins_contig == CONTIG_NONE && free_records == 0) {
-		status = ocfs2_grow_tree(inode, handle, et,
+		status = ocfs2_grow_tree(handle, et,
 					 &insert.ins_tree_depth, &last_eb_bh,
 					 meta_ac);
 		if (status) {
@@ -4713,7 +4705,7 @@ leftright:
 
 	if (le16_to_cpu(rightmost_el->l_next_free_rec) ==
 	    le16_to_cpu(rightmost_el->l_count)) {
-		ret = ocfs2_grow_tree(inode, handle, et,
+		ret = ocfs2_grow_tree(handle, et,
 				      &depth, last_eb_bh, meta_ac);
 		if (ret) {
 			mlog_errno(ret);
@@ -5020,7 +5012,7 @@ static int ocfs2_split_tree(struct inode *inode, struct ocfs2_extent_tree *et,
 
 	if (le16_to_cpu(rightmost_el->l_next_free_rec) ==
 	    le16_to_cpu(rightmost_el->l_count)) {
-		ret = ocfs2_grow_tree(inode, handle, et, &depth, &last_eb_bh,
+		ret = ocfs2_grow_tree(handle, et, &depth, &last_eb_bh,
 				      meta_ac);
 		if (ret) {
 			mlog_errno(ret);
-- 
1.5.6.5
