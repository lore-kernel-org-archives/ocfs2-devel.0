From: Joel Becker <joel.becker@oracle.com>
Date: Fri, 13 Feb 2009 14:16:25 -0800
Subject: [Ocfs2-devel] [PATCH 38/40] ocfs2: ocfs2_split_and_insert() no
	longer needs struct inode.
In-Reply-To: <1234563387-17101-1-git-send-email-joel.becker@oracle.com>
References: <1234563387-17101-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1234563387-17101-39-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

It already has an extent_tree.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/alloc.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index e724fa8..37b1410 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -4717,10 +4717,9 @@ static void ocfs2_make_right_split_rec(struct super_block *sb,
 	split_rec->e_flags = rec->e_flags;
 }
 
-static int ocfs2_split_and_insert(struct inode *inode,
-				  handle_t *handle,
-				  struct ocfs2_path *path,
+static int ocfs2_split_and_insert(handle_t *handle,
 				  struct ocfs2_extent_tree *et,
+				  struct ocfs2_path *path,
 				  struct buffer_head **last_eb_bh,
 				  int split_index,
 				  struct ocfs2_extent_rec *orig_split_rec,
@@ -4782,8 +4781,8 @@ leftright:
 		 */
 		insert.ins_split = SPLIT_RIGHT;
 
-		ocfs2_make_right_split_rec(inode->i_sb, &tmprec, insert_range,
-					   &rec);
+		ocfs2_make_right_split_rec(ocfs2_metadata_cache_get_super(et->et_ci),
+					   &tmprec, insert_range, &rec);
 
 		split_rec = tmprec;
 
@@ -4913,7 +4912,7 @@ static int __ocfs2_mark_extent_written(struct inode *inode,
 		if (ctxt.c_split_covers_rec)
 			el->l_recs[split_index] = *split_rec;
 		else
-			ret = ocfs2_split_and_insert(inode, handle, path, et,
+			ret = ocfs2_split_and_insert(handle, et, path,
 						     &last_eb_bh, split_index,
 						     split_rec, meta_ac);
 		if (ret)
-- 
1.5.6.5
