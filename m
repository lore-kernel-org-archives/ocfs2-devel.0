From: Joel Becker <joel.becker@oracle.com>
Date: Fri, 13 Feb 2009 14:16:21 -0800
Subject: [Ocfs2-devel] [PATCH 34/40] ocfs2: Make extent map insertion an
	extent_tree_operation.
In-Reply-To: <1234563387-17101-1-git-send-email-joel.becker@oracle.com>
References: <1234563387-17101-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1234563387-17101-35-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

ocfs2_insert_extent() wants to insert a record into the extent map if
it's an inode data extent.  But since many btrees can call that
function, let's make it an op on ocfs2_extent_tree.  Other tree types
can leave it empty.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/alloc.c |   29 +++++++++++++++++++++++++++--
 1 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index be329a9..619ebaf 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -83,6 +83,13 @@ struct ocfs2_extent_tree_operations {
 				   u32 new_clusters);
 
 	/*
+	 * If this extent tree is supported by an extent map, insert
+	 * a record into the map.
+	 */
+	void (*eo_extent_map_insert)(struct ocfs2_extent_tree *et,
+				     struct ocfs2_extent_rec *rec);
+
+	/*
 	 * If this extent tree is supported by an extent map, truncate the
 	 * map to clusters,
 	 */
@@ -127,6 +134,8 @@ static void ocfs2_dinode_set_last_eb_blk(struct ocfs2_extent_tree *et,
 					 u64 blkno);
 static void ocfs2_dinode_update_clusters(struct ocfs2_extent_tree *et,
 					 u32 clusters);
+static void ocfs2_dinode_extent_map_insert(struct ocfs2_extent_tree *et,
+					   struct ocfs2_extent_rec *rec);
 static void ocfs2_dinode_extent_map_truncate(struct ocfs2_extent_tree *et,
 					     u32 clusters);
 static int ocfs2_dinode_insert_check(struct ocfs2_extent_tree *et,
@@ -137,6 +146,7 @@ static struct ocfs2_extent_tree_operations ocfs2_dinode_et_ops = {
 	.eo_set_last_eb_blk	= ocfs2_dinode_set_last_eb_blk,
 	.eo_get_last_eb_blk	= ocfs2_dinode_get_last_eb_blk,
 	.eo_update_clusters	= ocfs2_dinode_update_clusters,
+	.eo_extent_map_insert	= ocfs2_dinode_extent_map_insert,
 	.eo_extent_map_truncate	= ocfs2_dinode_extent_map_truncate,
 	.eo_insert_check	= ocfs2_dinode_insert_check,
 	.eo_sanity_check	= ocfs2_dinode_sanity_check,
@@ -172,6 +182,14 @@ static void ocfs2_dinode_update_clusters(struct ocfs2_extent_tree *et,
 	spin_unlock(&oi->ip_lock);
 }
 
+static void ocfs2_dinode_extent_map_insert(struct ocfs2_extent_tree *et,
+					   struct ocfs2_extent_rec *rec)
+{
+	struct inode *inode = &cache_info_to_inode(et->et_ci)->vfs_inode;
+
+	ocfs2_extent_map_insert_rec(inode, rec);
+}
+
 static void ocfs2_dinode_extent_map_truncate(struct ocfs2_extent_tree *et,
 					     u32 clusters)
 {
@@ -363,6 +381,13 @@ static inline void ocfs2_et_update_clusters(struct ocfs2_extent_tree *et,
 	et->et_ops->eo_update_clusters(et, clusters);
 }
 
+static inline void ocfs2_et_extent_map_insert(struct ocfs2_extent_tree *et,
+					      struct ocfs2_extent_rec *rec)
+{
+	if (et->et_ops->eo_extent_map_insert)
+		et->et_ops->eo_extent_map_insert(et, rec);
+}
+
 static inline void ocfs2_et_extent_map_truncate(struct ocfs2_extent_tree *et,
 						u32 clusters)
 {
@@ -4555,8 +4580,8 @@ int ocfs2_insert_extent(struct ocfs2_super *osb,
 	status = ocfs2_do_insert_extent(handle, et, &rec, &insert);
 	if (status < 0)
 		mlog_errno(status);
-	else if (et->et_ops == &ocfs2_dinode_et_ops)
-		ocfs2_extent_map_insert_rec(inode, &rec);
+	else
+		ocfs2_et_extent_map_insert(et, &rec);
 
 bail:
 	brelse(last_eb_bh);
-- 
1.5.6.5
