From: Joel Becker <joel.becker@oracle.com>
Date: Fri, 13 Feb 2009 14:16:13 -0800
Subject: [Ocfs2-devel] [PATCH 26/40] ocfs2: Make truncating the extent map
	an extent_tree_operation.
In-Reply-To: <1234563387-17101-1-git-send-email-joel.becker@oracle.com>
References: <1234563387-17101-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1234563387-17101-27-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

ocfs2_remove_extent() wants to truncate the extent map if it's
truncating an inode data extent.  But since many btrees can call that
function, let's make it an op on ocfs2_extent_tree.  Other tree types
can leave it empty.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/alloc.c |   37 +++++++++++++++++++++++++++++++------
 1 files changed, 31 insertions(+), 6 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index a722536..24e6c5b 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -83,6 +83,13 @@ struct ocfs2_extent_tree_operations {
 				   u32 new_clusters);
 
 	/*
+	 * If this extent tree is supported by an extent map, truncate the
+	 * map to clusters,
+	 */
+	void (*eo_extent_map_truncate)(struct ocfs2_extent_tree *et,
+				       u32 clusters);
+
+	/*
 	 * If ->eo_insert_check() exists, it is called before rec is
 	 * inserted into the extent tree.  It is optional.
 	 */
@@ -120,6 +127,8 @@ static void ocfs2_dinode_set_last_eb_blk(struct ocfs2_extent_tree *et,
 					 u64 blkno);
 static void ocfs2_dinode_update_clusters(struct ocfs2_extent_tree *et,
 					 u32 clusters);
+static void ocfs2_dinode_extent_map_truncate(struct ocfs2_extent_tree *et,
+					     u32 clusters);
 static int ocfs2_dinode_insert_check(struct ocfs2_extent_tree *et,
 				     struct ocfs2_extent_rec *rec);
 static int ocfs2_dinode_sanity_check(struct ocfs2_extent_tree *et);
@@ -128,6 +137,7 @@ static struct ocfs2_extent_tree_operations ocfs2_dinode_et_ops = {
 	.eo_set_last_eb_blk	= ocfs2_dinode_set_last_eb_blk,
 	.eo_get_last_eb_blk	= ocfs2_dinode_get_last_eb_blk,
 	.eo_update_clusters	= ocfs2_dinode_update_clusters,
+	.eo_extent_map_truncate	= ocfs2_dinode_extent_map_truncate,
 	.eo_insert_check	= ocfs2_dinode_insert_check,
 	.eo_sanity_check	= ocfs2_dinode_sanity_check,
 	.eo_fill_root_el	= ocfs2_dinode_fill_root_el,
@@ -162,6 +172,14 @@ static void ocfs2_dinode_update_clusters(struct ocfs2_extent_tree *et,
 	spin_unlock(&oi->ip_lock);
 }
 
+static void ocfs2_dinode_extent_map_truncate(struct ocfs2_extent_tree *et,
+					     u32 clusters)
+{
+	struct inode *inode = &cache_info_to_inode(et->et_ci)->vfs_inode;
+
+	ocfs2_extent_map_trunc(inode, clusters);
+}
+
 static int ocfs2_dinode_insert_check(struct ocfs2_extent_tree *et,
 				     struct ocfs2_extent_rec *rec)
 {
@@ -345,6 +363,13 @@ static inline void ocfs2_et_update_clusters(struct ocfs2_extent_tree *et,
 	et->et_ops->eo_update_clusters(et, clusters);
 }
 
+static inline void ocfs2_et_extent_map_truncate(struct ocfs2_extent_tree *et,
+						u32 clusters)
+{
+	if (et->et_ops->eo_extent_map_truncate)
+		et->et_ops->eo_extent_map_truncate(et, clusters);
+}
+
 static inline int ocfs2_et_root_journal_access(handle_t *handle,
 					       struct ocfs2_extent_tree *et,
 					       int type)
@@ -4919,12 +4944,8 @@ int ocfs2_mark_extent_written(struct inode *inode,
 	/*
 	 * XXX: This should be fixed up so that we just re-insert the
 	 * next extent records.
-	 *
-	 * XXX: This is a hack on the extent tree, maybe it should be
-	 * an op?
 	 */
-	if (et->et_ops == &ocfs2_dinode_et_ops)
-		ocfs2_extent_map_trunc(inode, 0);
+	ocfs2_et_extent_map_truncate(et, 0);
 
 	left_path = ocfs2_new_path_from_et(et);
 	if (!left_path) {
@@ -5206,7 +5227,11 @@ int ocfs2_remove_extent(struct inode *inode,
 	struct ocfs2_extent_list *el;
 	struct ocfs2_path *path = NULL;
 
-	ocfs2_extent_map_trunc(inode, 0);
+	/*
+	 * XXX: Why are we truncating to 0 instead of wherever this
+	 * affects us?
+	 */
+	ocfs2_et_extent_map_truncate(et, 0);
 
 	path = ocfs2_new_path_from_et(et);
 	if (!path) {
-- 
1.5.6.5
