From: Tao Ma <tao.ma@oracle.com>
Date: Fri,  3 Apr 2009 07:45:49 +0800
Subject: [Ocfs2-devel] [PATCH 10/42] ocfs2: Abstract extent split process.
In-Reply-To: <49D5CAC2.4010201@oracle.com>
References: <49D5CAC2.4010201@oracle.com>
Message-ID: <1238715981-21488-10-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

ocfs2_mark_extent_written actually does the following things:
1. check the parameters.
2. initialize the left_path and split_rec.
3. call __ocfs2_mark_extent_written. it will do:
   1) check the flags of unwritten
   2) do the real split work.
The whole process is packed tightly somehow. So this patch
will abstract 2 different functions so that future b-tree
operation can work with it.

1. __ocfs2_split_extent will accept path and split_rec and do
  the real split work.
2. ocfs2_change_extent_flag will accept a new flag and initialize
   path and split_rec.

So now ocfs2_mark_extent_written will do:
1. check the parameters.
2. call ocfs2_change_extent_flag.
   1) initalize the left_path and split_rec.
   2) check whether the new flags conflict with the old one.
   3) call __ocfs2_split_extent to do the split.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/alloc.c |  142 ++++++++++++++++++++++++++++++++----------------------
 1 files changed, 85 insertions(+), 57 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index d79a62e..912f29c 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -4904,10 +4904,9 @@ out:
 }
 
 /*
- * Mark part or all of the extent record at split_index in the leaf
- * pointed to by path as written. This removes the unwritten
- * extent flag.
- *
+ * Split part or all of the extent record at split_index in the leaf
+ * pointed to by path. Merge with the contiguous extent record if needed.
+
  * Care is taken to handle contiguousness so as to not grow the tree.
  *
  * meta_ac is not strictly necessary - we only truly need it if growth
@@ -4923,13 +4922,13 @@ out:
  * have been brought into cache (and pinned via the journal), so the
  * extra overhead is not expressed in terms of disk reads.
  */
-static int __ocfs2_mark_extent_written(handle_t *handle,
-				       struct ocfs2_extent_tree *et,
-				       struct ocfs2_path *path,
-				       int split_index,
-				       struct ocfs2_extent_rec *split_rec,
-				       struct ocfs2_alloc_context *meta_ac,
-				       struct ocfs2_cached_dealloc_ctxt *dealloc)
+static int __ocfs2_split_extent(handle_t *handle,
+				struct ocfs2_extent_tree *et,
+				struct ocfs2_path *path,
+				int split_index,
+				struct ocfs2_extent_rec *split_rec,
+				struct ocfs2_alloc_context *meta_ac,
+				struct ocfs2_cached_dealloc_ctxt *dealloc)
 {
 	int ret = 0;
 	struct ocfs2_extent_list *el = path_leaf_el(path);
@@ -4939,12 +4938,6 @@ static int __ocfs2_mark_extent_written(handle_t *handle,
 	struct ocfs2_extent_list *rightmost_el;
 	struct ocfs2_alloc_context local_meta_ac;
 
-	if (!(rec->e_flags & OCFS2_EXT_UNWRITTEN)) {
-		ret = -EIO;
-		mlog_errno(ret);
-		goto out;
-	}
-
 	if (le32_to_cpu(rec->e_cpos) > le32_to_cpu(split_rec->e_cpos) ||
 	    ((le32_to_cpu(rec->e_cpos) + le16_to_cpu(rec->e_leaf_clusters)) <
 	     (le32_to_cpu(split_rec->e_cpos) + le16_to_cpu(split_rec->e_leaf_clusters)))) {
@@ -5024,43 +5017,20 @@ out:
 	return ret;
 }
 
-/*
- * Mark the already-existing extent at cpos as written for len clusters.
- *
- * If the existing extent is larger than the request, initiate a
- * split. An attempt will be made at merging with adjacent extents.
- *
- * The caller is responsible for passing down meta_ac if we'll need it.
- */
-int ocfs2_mark_extent_written(struct inode *inode,
-			      struct ocfs2_extent_tree *et,
-			      handle_t *handle, u32 cpos, u32 len, u32 phys,
-			      struct ocfs2_alloc_context *meta_ac,
-			      struct ocfs2_cached_dealloc_ctxt *dealloc)
+static int ocfs2_change_extent_flag(handle_t *handle,
+				    struct ocfs2_extent_tree *et,
+				    u32 cpos, u32 len, u32 phys,
+				    struct ocfs2_alloc_context *meta_ac,
+				    struct ocfs2_cached_dealloc_ctxt *dealloc,
+				    int new_flags, int clear_flags)
 {
 	int ret, index;
-	u64 start_blkno = ocfs2_clusters_to_blocks(inode->i_sb, phys);
+	struct super_block *sb = ocfs2_metadata_cache_get_super(et->et_ci);
+	u64 start_blkno = ocfs2_clusters_to_blocks(sb, phys);
 	struct ocfs2_extent_rec split_rec;
 	struct ocfs2_path *left_path = NULL;
 	struct ocfs2_extent_list *el;
-
-	mlog(0, "Inode %lu cpos %u, len %u, phys %u (%llu)\n",
-	     inode->i_ino, cpos, len, phys, (unsigned long long)start_blkno);
-
-	if (!ocfs2_writes_unwritten_extents(OCFS2_SB(inode->i_sb))) {
-		ocfs2_error(inode->i_sb, "Inode %llu has unwritten extents "
-			    "that are being written to, but the feature bit "
-			    "is not set in the super block.",
-			    (unsigned long long)OCFS2_I(inode)->ip_blkno);
-		ret = -EROFS;
-		goto out;
-	}
-
-	/*
-	 * XXX: This should be fixed up so that we just re-insert the
-	 * next extent records.
-	 */
-	ocfs2_et_extent_map_truncate(et, 0);
+	struct ocfs2_extent_rec *rec;
 
 	left_path = ocfs2_new_path_from_et(et);
 	if (!left_path) {
@@ -5078,30 +5048,88 @@ int ocfs2_mark_extent_written(struct inode *inode,
 
 	index = ocfs2_search_extent_list(el, cpos);
 	if (index == -1 || index >= le16_to_cpu(el->l_next_free_rec)) {
-		ocfs2_error(inode->i_sb,
-			    "Inode %llu has an extent at cpos %u which can no "
+		ocfs2_error(sb,
+			    "Owner %llu has an extent at cpos %u which can no "
 			    "longer be found.\n",
-			    (unsigned long long)OCFS2_I(inode)->ip_blkno, cpos);
+			     (unsigned long long)
+			     ocfs2_metadata_cache_owner(et->et_ci), cpos);
 		ret = -EROFS;
 		goto out;
 	}
 
+	rec = &el->l_recs[index];
+	if ((new_flags && (rec->e_flags & new_flags)) ||
+	    (clear_flags && !(rec->e_flags & clear_flags))) {
+		ret = -EIO;
+		mlog_errno(ret);
+		goto out;
+	}
+
 	memset(&split_rec, 0, sizeof(struct ocfs2_extent_rec));
 	split_rec.e_cpos = cpu_to_le32(cpos);
 	split_rec.e_leaf_clusters = cpu_to_le16(len);
 	split_rec.e_blkno = cpu_to_le64(start_blkno);
-	split_rec.e_flags = path_leaf_el(left_path)->l_recs[index].e_flags;
-	split_rec.e_flags &= ~OCFS2_EXT_UNWRITTEN;
+	split_rec.e_flags = rec->e_flags;
+	if (new_flags)
+		split_rec.e_flags |= new_flags;
+	else
+		split_rec.e_flags &= ~clear_flags;
 
-	ret = __ocfs2_mark_extent_written(handle, et, left_path,
-					  index, &split_rec, meta_ac,
-					  dealloc);
+	ret = __ocfs2_split_extent(handle, et, left_path,
+				  index, &split_rec, meta_ac,
+				  dealloc);
 	if (ret)
 		mlog_errno(ret);
 
 out:
 	ocfs2_free_path(left_path);
 	return ret;
+
+}
+
+/*
+ * Mark the already-existing extent at cpos as written for len clusters.
+ * This removes the unwritten extent flag.
+ *
+ * If the existing extent is larger than the request, initiate a
+ * split. An attempt will be made at merging with adjacent extents.
+ *
+ * The caller is responsible for passing down meta_ac if we'll need it.
+ */
+int ocfs2_mark_extent_written(struct inode *inode,
+			      struct ocfs2_extent_tree *et,
+			      handle_t *handle, u32 cpos, u32 len, u32 phys,
+			      struct ocfs2_alloc_context *meta_ac,
+			      struct ocfs2_cached_dealloc_ctxt *dealloc)
+{
+	int ret;
+
+	mlog(0, "Inode %lu cpos %u, len %u, phys clusters %u\n",
+	     inode->i_ino, cpos, len, phys);
+
+	if (!ocfs2_writes_unwritten_extents(OCFS2_SB(inode->i_sb))) {
+		ocfs2_error(inode->i_sb, "Inode %llu has unwritten extents "
+			    "that are being written to, but the feature bit "
+			    "is not set in the super block.",
+			    (unsigned long long)OCFS2_I(inode)->ip_blkno);
+		ret = -EROFS;
+		goto out;
+	}
+
+	/*
+	 * XXX: This should be fixed up so that we just re-insert the
+	 * next extent records.
+	 */
+	ocfs2_et_extent_map_truncate(et, 0);
+
+	ret = ocfs2_change_extent_flag(handle, et, cpos,
+				       len, phys, meta_ac, dealloc,
+				       0, OCFS2_EXT_UNWRITTEN);
+	if (ret)
+		mlog_errno(ret);
+
+out:
+	return ret;
 }
 
 static int ocfs2_split_tree(handle_t *handle, struct ocfs2_extent_tree *et,
-- 
1.6.2.rc2.16.gf474c
