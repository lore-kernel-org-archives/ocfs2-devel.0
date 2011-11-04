From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Fri,  4 Nov 2011 11:59:26 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: ensure journalaccess/journaldirty
 pairs don't cross journal restarting --ocfs2_rotate_subtree_left
Message-ID: <201111040359.pA43x9wm007354@acsmt357.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

journalaccess/journaldirty pairs shouldn't cross journal restarting.
Function ocfs2_rotate_subtree_left() violates this rule. This patch tries
to fix it.

1) adding a extra journal access before modifying the tree root. (see
comment in patch it's self)

2) moving ocfs2_remove_empty_extent(left_leaf_el) priror, so that
ocfs2_journal_dirty(handle, path_leaf_bh(left_path)) can take care of it.
(before the change, seems there is a miss of not putting left_leaf_el to
journal in del_right_subtree case.

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
---
 fs/ocfs2/alloc.c |   36 +++++++++++++++---------------------
 1 files changed, 15 insertions(+), 21 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index ed553c6..ace7aa2 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -2708,20 +2708,8 @@ static int ocfs2_rotate_subtree_left(handle_t *handle,
 	}
 
 	if (eb->h_next_leaf_blk == 0ULL &&
-	    le16_to_cpu(right_leaf_el->l_next_free_rec) == 1) {
-		/*
-		 * We have to update i_last_eb_blk during the meta
-		 * data delete.
-		 */
-		ret = ocfs2_et_root_journal_access(handle, et,
-						   OCFS2_JOURNAL_ACCESS_WRITE);
-		if (ret) {
-			mlog_errno(ret);
-			goto out;
-		}
-
+	    le16_to_cpu(right_leaf_el->l_next_free_rec) == 1)
 		del_right_subtree = 1;
-	}
 
 	/*
 	 * Getting here with an empty extent in the right path implies
@@ -2762,7 +2750,10 @@ static int ocfs2_rotate_subtree_left(handle_t *handle,
 		ocfs2_rotate_leaf(left_leaf_el, &right_leaf_el->l_recs[0]);
 		memset(&right_leaf_el->l_recs[0], 0,
 		       sizeof(struct ocfs2_extent_rec));
+	} else {
+		ocfs2_remove_empty_extent(left_leaf_el);
 	}
+		
 	if (eb->h_next_leaf_blk == 0ULL) {
 		/*
 		 * Move recs over to get rid of empty extent, decrease
@@ -2786,17 +2777,20 @@ static int ocfs2_rotate_subtree_left(handle_t *handle,
 			goto out;
 		}
 
-		eb = (struct ocfs2_extent_block *)path_leaf_bh(left_path)->b_data;
-		ocfs2_et_set_last_eb_blk(et, le64_to_cpu(eb->h_blkno));
-
 		/*
-		 * Removal of the extent in the left leaf was skipped
-		 * above so we could delete the right path
-		 * 1st.
+		 * journal can just restarted in ocfs2_update_edge_lengths.
+		 * we have to re-access the tree root. We still has an credit
+		 * reserved for the tree root. 
 		 */
-		if (right_has_empty)
-			ocfs2_remove_empty_extent(left_leaf_el);
+		ret = ocfs2_et_root_journal_access(handle, et,
+						   OCFS2_JOURNAL_ACCESS_WRITE);
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
 
+		eb = (struct ocfs2_extent_block *)path_leaf_bh(left_path)->b_data;
+		ocfs2_et_set_last_eb_blk(et, le64_to_cpu(eb->h_blkno));
 		ocfs2_journal_dirty(handle, et_root_bh);
 
 		*deleted = 1;
-- 
1.7.5.2
