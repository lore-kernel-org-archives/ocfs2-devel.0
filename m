From: Joel Becker <joel.becker@oracle.com>
Date: Fri, 13 Feb 2009 14:16:15 -0800
Subject: [Ocfs2-devel] [PATCH 28/40] ocfs2: Give ocfs2_split_record() an
	extent_tree instead of an inode.
In-Reply-To: <1234563387-17101-1-git-send-email-joel.becker@oracle.com>
References: <1234563387-17101-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1234563387-17101-29-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Another on the way to generic btree functions.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/alloc.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 8783b63..5a50032 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -3860,7 +3860,7 @@ out:
 	return ret;
 }
 
-static void ocfs2_split_record(struct inode *inode,
+static void ocfs2_split_record(struct ocfs2_extent_tree *et,
 			       struct ocfs2_path *left_path,
 			       struct ocfs2_path *right_path,
 			       struct ocfs2_extent_rec *split_rec,
@@ -3933,7 +3933,8 @@ static void ocfs2_split_record(struct inode *inode,
 	}
 
 	rec = &el->l_recs[index];
-	ocfs2_subtract_from_rec(inode->i_sb, split, rec, split_rec);
+	ocfs2_subtract_from_rec(ocfs2_metadata_cache_get_super(et->et_ci),
+				split, rec, split_rec);
 	ocfs2_rotate_leaf(insert_el, split_rec);
 }
 
@@ -3996,7 +3997,7 @@ static int ocfs2_insert_path(struct inode *inode,
 		 * of splits, but it's easier to just let one separate
 		 * function sort it all out.
 		 */
-		ocfs2_split_record(inode, left_path, right_path,
+		ocfs2_split_record(et, left_path, right_path,
 				   insert_rec, insert->ins_split);
 
 		/*
-- 
1.5.6.5
