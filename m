From: Joel Becker <joel.becker@oracle.com>
Date: Fri, 13 Feb 2009 14:16:14 -0800
Subject: [Ocfs2-devel] [PATCH 27/40] ocfs2: ocfs2_insert_at_leaf() doesn't
	need struct inode.
In-Reply-To: <1234563387-17101-1-git-send-email-joel.becker@oracle.com>
References: <1234563387-17101-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1234563387-17101-28-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Give it an ocfs2_extent_tree and it is happy.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/alloc.c |   19 ++++++++++---------
 1 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 24e6c5b..8783b63 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -3647,10 +3647,10 @@ static void ocfs2_subtract_from_rec(struct super_block *sb,
  * list. If this leaf is part of an allocation tree, it is assumed
  * that the tree above has been prepared.
  */
-static void ocfs2_insert_at_leaf(struct ocfs2_extent_rec *insert_rec,
+static void ocfs2_insert_at_leaf(struct ocfs2_extent_tree *et,
+				 struct ocfs2_extent_rec *insert_rec,
 				 struct ocfs2_extent_list *el,
-				 struct ocfs2_insert_type *insert,
-				 struct inode *inode)
+				 struct ocfs2_insert_type *insert)
 {
 	int i = insert->ins_contig_index;
 	unsigned int range;
@@ -3662,7 +3662,8 @@ static void ocfs2_insert_at_leaf(struct ocfs2_extent_rec *insert_rec,
 		i = ocfs2_search_extent_list(el, le32_to_cpu(insert_rec->e_cpos));
 		BUG_ON(i == -1);
 		rec = &el->l_recs[i];
-		ocfs2_subtract_from_rec(inode->i_sb, insert->ins_split, rec,
+		ocfs2_subtract_from_rec(ocfs2_metadata_cache_get_super(et->et_ci),
+					insert->ins_split, rec,
 					insert_rec);
 		goto rotate;
 	}
@@ -3704,10 +3705,10 @@ static void ocfs2_insert_at_leaf(struct ocfs2_extent_rec *insert_rec,
 
 		mlog_bug_on_msg(le16_to_cpu(el->l_next_free_rec) >=
 				le16_to_cpu(el->l_count),
-				"inode %lu, depth %u, count %u, next free %u, "
+				"owner %llu, depth %u, count %u, next free %u, "
 				"rec.cpos %u, rec.clusters %u, "
 				"insert.cpos %u, insert.clusters %u\n",
-				inode->i_ino,
+				ocfs2_metadata_cache_owner(et->et_ci),
 				le16_to_cpu(el->l_tree_depth),
 				le16_to_cpu(el->l_count),
 				le16_to_cpu(el->l_next_free_rec),
@@ -4009,8 +4010,8 @@ static int ocfs2_insert_path(struct inode *inode,
 			if (ret)
 				mlog_errno(ret);
 	} else
-		ocfs2_insert_at_leaf(insert_rec, path_leaf_el(right_path),
-				     insert, inode);
+		ocfs2_insert_at_leaf(et, insert_rec, path_leaf_el(right_path),
+				     insert);
 
 	ret = ocfs2_journal_dirty(handle, leaf_bh);
 	if (ret)
@@ -4056,7 +4057,7 @@ static int ocfs2_do_insert_extent(struct inode *inode,
 	}
 
 	if (le16_to_cpu(el->l_tree_depth) == 0) {
-		ocfs2_insert_at_leaf(insert_rec, el, type, inode);
+		ocfs2_insert_at_leaf(et, insert_rec, el, type);
 		goto out_update_clusters;
 	}
 
-- 
1.5.6.5
