From: Tao Ma <tao.ma@oracle.com>
Date: Fri, 12 Jun 2009 14:18:35 +0800
Subject: [Ocfs2-devel] [PATCH 1/2] ocfs2: return EROFS instead of BUG in
	ocfs2_insert_at_leaf.
In-Reply-To: <4A326E26.4080002@oracle.com>
References: <4A326E26.4080002@oracle.com>
Message-ID: <1244787516-13475-1-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

As Mark's suggestion, change BUG to EROFS in ocfs2_insert_at_leaf.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/alloc.c |   67 +++++++++++++++++++++++++++++++++---------------------
 1 files changed, 41 insertions(+), 26 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 19e3a96..4ac408b 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -3648,12 +3648,12 @@ static void ocfs2_subtract_from_rec(struct super_block *sb,
  * list. If this leaf is part of an allocation tree, it is assumed
  * that the tree above has been prepared.
  */
-static void ocfs2_insert_at_leaf(struct ocfs2_extent_rec *insert_rec,
-				 struct ocfs2_extent_list *el,
-				 struct ocfs2_insert_type *insert,
-				 struct inode *inode)
+static int ocfs2_insert_at_leaf(struct ocfs2_extent_rec *insert_rec,
+				struct ocfs2_extent_list *el,
+				struct ocfs2_insert_type *insert,
+				struct inode *inode)
 {
-	int i = insert->ins_contig_index;
+	int ret = 0, i = insert->ins_contig_index;
 	unsigned int range;
 	struct ocfs2_extent_rec *rec;
 
@@ -3679,7 +3679,7 @@ static void ocfs2_insert_at_leaf(struct ocfs2_extent_rec *insert_rec,
 		}
 		le16_add_cpu(&rec->e_leaf_clusters,
 			     le16_to_cpu(insert_rec->e_leaf_clusters));
-		return;
+		goto out;
 	}
 
 	/*
@@ -3690,7 +3690,7 @@ static void ocfs2_insert_at_leaf(struct ocfs2_extent_rec *insert_rec,
 	     ocfs2_is_empty_extent(&el->l_recs[0]))) {
 		el->l_recs[0] = *insert_rec;
 		el->l_next_free_rec = cpu_to_le16(1);
-		return;
+		goto out;
 	}
 
 	/*
@@ -3703,23 +3703,28 @@ static void ocfs2_insert_at_leaf(struct ocfs2_extent_rec *insert_rec,
 			+ le16_to_cpu(rec->e_leaf_clusters);
 		BUG_ON(le32_to_cpu(insert_rec->e_cpos) < range);
 
-		mlog_bug_on_msg(le16_to_cpu(el->l_next_free_rec) >=
-				le16_to_cpu(el->l_count),
-				"inode %lu, depth %u, count %u, next free %u, "
-				"rec.cpos %u, rec.clusters %u, "
-				"insert.cpos %u, insert.clusters %u\n",
-				inode->i_ino,
-				le16_to_cpu(el->l_tree_depth),
-				le16_to_cpu(el->l_count),
-				le16_to_cpu(el->l_next_free_rec),
-				le32_to_cpu(el->l_recs[i].e_cpos),
-				le16_to_cpu(el->l_recs[i].e_leaf_clusters),
-				le32_to_cpu(insert_rec->e_cpos),
-				le16_to_cpu(insert_rec->e_leaf_clusters));
+		if (le16_to_cpu(el->l_next_free_rec) >=
+		    le16_to_cpu(el->l_count)) {
+			mlog(ML_ERROR, "l_next_free_rec > l_count, "
+			     "inode %lu, depth %u, count %u, next free %u, "
+			     "rec.cpos %u, rec.clusters %u, "
+			     "insert.cpos %u, insert.clusters %u\n",
+			     inode->i_ino,
+			     le16_to_cpu(el->l_tree_depth),
+			     le16_to_cpu(el->l_count),
+			     le16_to_cpu(el->l_next_free_rec),
+			     le32_to_cpu(el->l_recs[i].e_cpos),
+			     le16_to_cpu(el->l_recs[i].e_leaf_clusters),
+			     le32_to_cpu(insert_rec->e_cpos),
+			     le16_to_cpu(insert_rec->e_leaf_clusters));
+			ret = -EROFS;
+			goto out;
+		}
+
 		i++;
 		el->l_recs[i] = *insert_rec;
 		le16_add_cpu(&el->l_next_free_rec, 1);
-		return;
+		goto out;
 	}
 
 rotate:
@@ -3734,6 +3739,8 @@ rotate:
 	 * extent record, or by virtue of an l_next_rec < l_count.
 	 */
 	ocfs2_rotate_leaf(el, insert_rec);
+out:
+	return ret;
 }
 
 static void ocfs2_adjust_rightmost_records(struct inode *inode,
@@ -4006,10 +4013,14 @@ static int ocfs2_insert_path(struct inode *inode,
 						  path_leaf_bh(left_path));
 			if (ret)
 				mlog_errno(ret);
-	} else
-		ocfs2_insert_at_leaf(insert_rec, path_leaf_el(right_path),
-				     insert, inode);
-
+	} else {
+		ret = ocfs2_insert_at_leaf(insert_rec, path_leaf_el(right_path),
+					   insert, inode);
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
+	}
 	ret = ocfs2_journal_dirty(handle, leaf_bh);
 	if (ret)
 		mlog_errno(ret);
@@ -4054,7 +4065,11 @@ static int ocfs2_do_insert_extent(struct inode *inode,
 	}
 
 	if (le16_to_cpu(el->l_tree_depth) == 0) {
-		ocfs2_insert_at_leaf(insert_rec, el, type, inode);
+		ret = ocfs2_insert_at_leaf(insert_rec, el, type, inode);
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
 		goto out_update_clusters;
 	}
 
-- 
1.6.2.rc2.16.gf474c
