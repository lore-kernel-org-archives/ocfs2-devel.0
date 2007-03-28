From: Joel Becker <joel.becker@oracle.com>
Date: Wed Mar 28 18:51:01 2007
Subject: [Ocfs2-devel] [PATCH 2/3] ocfs2: Properly lock extent map size
	changes.
References: <20070329005041.518030000@oracle.com>
Message-ID: <20070329005717.663893000@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The extent map code failed to properly lock changes to ->em_clusters, the
extent map's idea of its own size.

This leads to a subtle race.  One process is updating the size to match an
inode that changed, while another process is already past that in
the lookup code checking the size against its arguments.  For a moment, the
size is wrong (due to how the size is checked and calculated).

Properly locking the update and the query makes this safe.

The check for size change is abstracted into a common function.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/extent_map.c |   90 +++++++++++++++++++++++++++----------------------
 1 files changed, 50 insertions(+), 40 deletions(-)

diff --git a/fs/ocfs2/extent_map.c b/fs/ocfs2/extent_map.c
index 80ac69f..9ff4351 100644
--- a/fs/ocfs2/extent_map.c
+++ b/fs/ocfs2/extent_map.c
@@ -84,6 +84,8 @@ static int ocfs2_extent_map_try_insert(s
 				       struct ocfs2_extent_rec *rec,
 				       int tree_depth,
 				       struct ocfs2_em_insert_context *ctxt);
+static void ocfs2_extent_map_check_size_change(struct inode *inode,
+					       u32 expected_clusters);
 
 /* returns 1 only if the rec contains all the given clusters -- that is that
  * rec's cpos is <= the cluster cpos and that the rec endpoint (cpos +
@@ -558,8 +560,10 @@ static int ocfs2_extent_map_insert(struc
 	int ret;
 	struct ocfs2_em_insert_context ctxt = {0, };
 
+	spin_lock(&OCFS2_I(inode)->ip_lock);
 	if ((le32_to_cpu(rec->e_cpos) + le32_to_cpu(rec->e_clusters)) >
 	    OCFS2_I(inode)->ip_map.em_clusters) {
+		spin_unlock(&OCFS2_I(inode)->ip_lock);
 		ret = -EBADR;
 		mlog_errno(ret);
 		return ret;
@@ -569,6 +573,7 @@ static int ocfs2_extent_map_insert(struc
 	if (!rec->e_clusters) {
 		if ((le32_to_cpu(rec->e_cpos) + le32_to_cpu(rec->e_clusters)) !=
 		    OCFS2_I(inode)->ip_map.em_clusters) {
+			spin_unlock(&OCFS2_I(inode)->ip_lock);
 			ret = -EBADR;
 			mlog_errno(ret);
 			ocfs2_error(inode->i_sb,
@@ -578,9 +583,12 @@ static int ocfs2_extent_map_insert(struc
 			return ret;
 		}
 
+		spin_unlock(&OCFS2_I(inode)->ip_lock);
+
 		/* Ignore the truncated tail */
 		return 0;
 	}
+	spin_unlock(&OCFS2_I(inode)->ip_lock);
 
 	ret = -ENOMEM;
 	ctxt.new_ent = kmem_cache_alloc(ocfs2_em_ent_cachep,
@@ -662,15 +670,8 @@ int ocfs2_extent_map_append(struct inode
 	BUG_ON(!new_clusters);
 	BUG_ON(le32_to_cpu(rec->e_clusters) < new_clusters);
 
-	if (em->em_clusters < OCFS2_I(inode)->ip_clusters) {
-		/*
-		 * Size changed underneath us on disk.  Drop any
-		 * straddling records and update our idea of
-		 * i_clusters
-		 */
-		ocfs2_extent_map_drop(inode, em->em_clusters - 1);
-		em->em_clusters = OCFS2_I(inode)->ip_clusters;
-	}
+	ocfs2_extent_map_check_size_change(inode,
+					   OCFS2_I(inode)->ip_clusters);
 
 	mlog_bug_on_msg((le32_to_cpu(rec->e_cpos) +
 			 le32_to_cpu(rec->e_clusters)) !=
@@ -745,7 +746,6 @@ int ocfs2_extent_map_get_rec(struct inod
 			     int *tree_depth)
 {
 	int ret = -ENOENT;
-	struct ocfs2_extent_map *em = &OCFS2_I(inode)->ip_map;
 	struct ocfs2_extent_map_entry *ent;
 
 	*rec = NULL;
@@ -753,15 +753,7 @@ int ocfs2_extent_map_get_rec(struct inod
 	if (cpos >= OCFS2_I(inode)->ip_clusters)
 		return -EINVAL;
 
-	if (cpos >= em->em_clusters) {
-		/*
-		 * Size changed underneath us on disk.  Drop any
-		 * straddling records and update our idea of
-		 * i_clusters
-		 */
-		ocfs2_extent_map_drop(inode, em->em_clusters - 1);
-		em->em_clusters = OCFS2_I(inode)->ip_clusters ;
-	}
+	ocfs2_extent_map_check_size_change(inode, cpos);
 
 	ent = ocfs2_extent_map_lookup(&OCFS2_I(inode)->ip_map, cpos, 1,
 				      NULL, NULL);
@@ -782,7 +774,6 @@ int ocfs2_extent_map_get_clusters(struct
 {
 	int ret;
 	u32 coff, ccount;
-	struct ocfs2_extent_map *em = &OCFS2_I(inode)->ip_map;
 	struct ocfs2_extent_map_entry *ent = NULL;
 
 	*p_cpos = ccount = 0;
@@ -790,16 +781,7 @@ int ocfs2_extent_map_get_clusters(struct
 	if ((v_cpos + count) > OCFS2_I(inode)->ip_clusters)
 		return -EINVAL;
 
-	if ((v_cpos + count) > em->em_clusters) {
-		/*
-		 * Size changed underneath us on disk.  Drop any
-		 * straddling records and update our idea of
-		 * i_clusters
-		 */
-		ocfs2_extent_map_drop(inode, em->em_clusters - 1);
-		em->em_clusters = OCFS2_I(inode)->ip_clusters;
-	}
-
+	ocfs2_extent_map_check_size_change(inode, v_cpos + count);
 
 	ret = ocfs2_extent_map_lookup_read(inode, v_cpos, count, &ent);
 	if (ret)
@@ -838,7 +820,6 @@ int ocfs2_extent_map_get_blocks(struct i
 	u32 cpos, clusters;
 	int bpc = ocfs2_clusters_to_blocks(inode->i_sb, 1);
 	struct ocfs2_extent_map_entry *ent = NULL;
-	struct ocfs2_extent_map *em = &OCFS2_I(inode)->ip_map;
 	struct ocfs2_extent_rec *rec;
 
 	*p_blkno = 0;
@@ -852,15 +833,7 @@ int ocfs2_extent_map_get_blocks(struct i
 		return ret;
 	}
 
-	if ((cpos + clusters) > em->em_clusters) {
-		/*
-		 * Size changed underneath us on disk.  Drop any
-		 * straddling records and update our idea of
-		 * i_clusters
-		 */
-		ocfs2_extent_map_drop(inode, em->em_clusters - 1);
-		em->em_clusters = OCFS2_I(inode)->ip_clusters;
-	}
+	ocfs2_extent_map_check_size_change(inode, cpos + clusters);
 
 	ret = ocfs2_extent_map_lookup_read(inode, cpos, clusters, &ent);
 	if (ret) {
@@ -996,6 +969,43 @@ int ocfs2_extent_map_drop(struct inode *
 }
 
 /*
+ * This is almost a wrapper of ocfs2_extent_map_drop(), but must
+ * handle its locking carefully.
+ */
+static void ocfs2_extent_map_check_size_change(struct inode *inode,
+					       u32 expected_clusters)
+{
+	struct rb_node *free_head = NULL;
+	struct ocfs2_extent_map *em = &OCFS2_I(inode)->ip_map;
+	struct ocfs2_extent_map_entry *ent;
+
+	spin_lock(&OCFS2_I(inode)->ip_lock);
+
+	if (em->em_clusters < expected_clusters) {
+		/*
+		 * Size changed underneath us on disk.  Drop any
+		 * straddling records and update our idea of
+		 * i_clusters
+		 */
+		__ocfs2_extent_map_drop(inode, em->em_clusters -1,
+					&free_head, &ent);
+
+		if (ent) {
+			rb_erase(&ent->e_node, &em->em_extents);
+			ent->e_node.rb_right = free_head;
+			free_head = &ent->e_node;
+		}
+
+		em->em_clusters = OCFS2_I(inode)->ip_clusters;
+	}
+
+	spin_unlock(&OCFS2_I(inode)->ip_lock);
+
+	if (free_head)
+		__ocfs2_extent_map_drop_cleanup(free_head);
+}
+
+/*
  * Remove all entries past new_clusters and also clip any extent
  * straddling new_clusters, if there is one.  This does not check
  * or modify ip_clusters
-- 
1.4.2.3
