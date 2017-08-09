From: piaojun <piaojun@huawei.com>
Date: Wed, 9 Aug 2017 08:58:09 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: clean up some dead code
Message-ID: <598A5E21.2080807@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

clean up some unused functions and parameters.

Signed-off-by: Jun Piao <piaojun@huawei.com>
Reviewed-by: Alex Chen <alex.chen@huawei.com>
---
 fs/ocfs2/alloc.c             | 22 ++++++++--------------
 fs/ocfs2/alloc.h             |  3 +--
 fs/ocfs2/cluster/heartbeat.c | 42 ++++--------------------------------------
 fs/ocfs2/dir.c               |  2 +-
 fs/ocfs2/file.c              |  7 -------
 fs/ocfs2/journal.c           |  1 -
 fs/ocfs2/move_extents.c      |  2 +-
 fs/ocfs2/ocfs2.h             |  4 +---
 fs/ocfs2/refcounttree.c      |  2 +-
 fs/ocfs2/suballoc.c          |  2 +-
 fs/ocfs2/super.c             |  1 -
 fs/ocfs2/xattr.c             |  2 +-
 12 files changed, 19 insertions(+), 71 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index fb15a96..a177eae 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -955,8 +955,7 @@ int ocfs2_read_extent_block(struct ocfs2_caching_info *ci, u64 eb_blkno,
 /*
  * How many free extents have we got before we need more meta data?
  */
-int ocfs2_num_free_extents(struct ocfs2_super *osb,
-			   struct ocfs2_extent_tree *et)
+int ocfs2_num_free_extents(struct ocfs2_extent_tree *et)
 {
 	int retval;
 	struct ocfs2_extent_list *el = NULL;
@@ -1933,14 +1932,12 @@ int ocfs2_find_leaf(struct ocfs2_caching_info *ci,
  * the new changes.
  *
  * left_rec: the record on the left.
- * left_child_el: is the child list pointed to by left_rec
  * right_rec: the record to the right of left_rec
  * right_child_el: is the child list pointed to by right_rec
  *
  * By definition, this only works on interior nodes.
  */
 static void ocfs2_adjust_adjacent_records(struct ocfs2_extent_rec *left_rec,
-				  struct ocfs2_extent_list *left_child_el,
 				  struct ocfs2_extent_rec *right_rec,
 				  struct ocfs2_extent_list *right_child_el)
 {
@@ -2003,7 +2000,7 @@ static void ocfs2_adjust_root_records(struct ocfs2_extent_list *root_el,
 	 */
 	BUG_ON(i >= (le16_to_cpu(root_el->l_next_free_rec) - 1));

-	ocfs2_adjust_adjacent_records(&root_el->l_recs[i], left_el,
+	ocfs2_adjust_adjacent_records(&root_el->l_recs[i],
 				      &root_el->l_recs[i + 1], right_el);
 }

@@ -2060,8 +2057,7 @@ static void ocfs2_complete_edge_insert(handle_t *handle,
 		el = right_path->p_node[i].el;
 		right_rec = &el->l_recs[0];

-		ocfs2_adjust_adjacent_records(left_rec, left_el, right_rec,
-					      right_el);
+		ocfs2_adjust_adjacent_records(left_rec, right_rec, right_el);

 		ocfs2_journal_dirty(handle, left_path->p_node[i].bh);
 		ocfs2_journal_dirty(handle, right_path->p_node[i].bh);
@@ -2509,7 +2505,7 @@ static int ocfs2_rotate_tree_right(handle_t *handle,

 static int ocfs2_update_edge_lengths(handle_t *handle,
 				     struct ocfs2_extent_tree *et,
-				     int subtree_index, struct ocfs2_path *path)
+				     struct ocfs2_path *path)
 {
 	int i, idx, ret;
 	struct ocfs2_extent_rec *rec;
@@ -2755,8 +2751,7 @@ static int ocfs2_rotate_subtree_left(handle_t *handle,
 	if (del_right_subtree) {
 		ocfs2_unlink_subtree(handle, et, left_path, right_path,
 				     subtree_index, dealloc);
-		ret = ocfs2_update_edge_lengths(handle, et, subtree_index,
-						left_path);
+		ret = ocfs2_update_edge_lengths(handle, et, left_path);
 		if (ret) {
 			mlog_errno(ret);
 			goto out;
@@ -3060,8 +3055,7 @@ static int ocfs2_remove_rightmost_path(handle_t *handle,

 		ocfs2_unlink_subtree(handle, et, left_path, path,
 				     subtree_index, dealloc);
-		ret = ocfs2_update_edge_lengths(handle, et, subtree_index,
-						left_path);
+		ret = ocfs2_update_edge_lengths(handle, et, left_path);
 		if (ret) {
 			mlog_errno(ret);
 			goto out;
@@ -4790,7 +4784,7 @@ int ocfs2_add_clusters_in_btree(handle_t *handle,
 	if (mark_unwritten)
 		flags = OCFS2_EXT_UNWRITTEN;

-	free_extents = ocfs2_num_free_extents(osb, et);
+	free_extents = ocfs2_num_free_extents(et);
 	if (free_extents < 0) {
 		status = free_extents;
 		mlog_errno(status);
@@ -5668,7 +5662,7 @@ static int ocfs2_reserve_blocks_for_rec_trunc(struct inode *inode,

 	*ac = NULL;

-	num_free_extents = ocfs2_num_free_extents(osb, et);
+	num_free_extents = ocfs2_num_free_extents(et);
 	if (num_free_extents < 0) {
 		ret = num_free_extents;
 		mlog_errno(ret);
diff --git a/fs/ocfs2/alloc.h b/fs/ocfs2/alloc.h
index 4a5152e..27b75cf 100644
--- a/fs/ocfs2/alloc.h
+++ b/fs/ocfs2/alloc.h
@@ -144,8 +144,7 @@ int ocfs2_remove_btree_range(struct inode *inode,
 			     struct ocfs2_cached_dealloc_ctxt *dealloc,
 			     u64 refcount_loc, bool refcount_tree_locked);

-int ocfs2_num_free_extents(struct ocfs2_super *osb,
-			   struct ocfs2_extent_tree *et);
+int ocfs2_num_free_extents(struct ocfs2_extent_tree *et);

 /*
  * how many new metadata chunks would an allocation need@maximum?
diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index 0da0332..53ae2a9 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -505,8 +505,7 @@ static inline void o2hb_bio_wait_dec(struct o2hb_bio_wait_ctxt *wc,
 	}
 }

-static void o2hb_wait_on_io(struct o2hb_region *reg,
-			    struct o2hb_bio_wait_ctxt *wc)
+static void o2hb_wait_on_io(struct o2hb_bio_wait_ctxt *wc)
 {
 	o2hb_bio_wait_dec(wc, 1);
 	wait_for_completion(&wc->wc_io_complete);
@@ -608,7 +607,7 @@ static int o2hb_read_slots(struct o2hb_region *reg,
 	status = 0;

 bail_and_wait:
-	o2hb_wait_on_io(reg, &wc);
+	o2hb_wait_on_io(&wc);
 	if (wc.wc_error && !status)
 		status = wc.wc_error;

@@ -1162,7 +1161,7 @@ static int o2hb_do_disk_heartbeat(struct o2hb_region *reg)
 	 * before we can go to steady state.  This ensures that
 	 * people we find in our steady state have seen us.
 	 */
-	o2hb_wait_on_io(reg, &write_wc);
+	o2hb_wait_on_io(&write_wc);
 	if (write_wc.wc_error) {
 		/* Do not re-arm the write timeout on I/O error - we
 		 * can't be sure that the new block ever made it to
@@ -1275,7 +1274,7 @@ static int o2hb_thread(void *data)
 		o2hb_prepare_block(reg, 0);
 		ret = o2hb_issue_node_write(reg, &write_wc);
 		if (ret == 0)
-			o2hb_wait_on_io(reg, &write_wc);
+			o2hb_wait_on_io(&write_wc);
 		else
 			mlog_errno(ret);
 	}
@@ -2576,22 +2575,6 @@ void o2hb_unregister_callback(const char *region_uuid,
 }
 EXPORT_SYMBOL_GPL(o2hb_unregister_callback);

-int o2hb_check_node_heartbeating(u8 node_num)
-{
-	unsigned long testing_map[BITS_TO_LONGS(O2NM_MAX_NODES)];
-
-	o2hb_fill_node_map(testing_map, sizeof(testing_map));
-	if (!test_bit(node_num, testing_map)) {
-		mlog(ML_HEARTBEAT,
-		     "node (%u) does not have heartbeating enabled.\n",
-		     node_num);
-		return 0;
-	}
-
-	return 1;
-}
-EXPORT_SYMBOL_GPL(o2hb_check_node_heartbeating);
-
 int o2hb_check_node_heartbeating_no_sem(u8 node_num)
 {
 	unsigned long testing_map[BITS_TO_LONGS(O2NM_MAX_NODES)];
@@ -2626,23 +2609,6 @@ int o2hb_check_node_heartbeating_from_callback(u8 node_num)
 }
 EXPORT_SYMBOL_GPL(o2hb_check_node_heartbeating_from_callback);

-/* Makes sure our local node is configured with a node number, and is
- * heartbeating. */
-int o2hb_check_local_node_heartbeating(void)
-{
-	u8 node_num;
-
-	/* if this node was set then we have networking */
-	node_num = o2nm_this_node();
-	if (node_num == O2NM_MAX_NODES) {
-		mlog(ML_HEARTBEAT, "this node has not been configured.\n");
-		return 0;
-	}
-
-	return o2hb_check_node_heartbeating(node_num);
-}
-EXPORT_SYMBOL_GPL(o2hb_check_local_node_heartbeating);
-
 /*
  * this is just a hack until we get the plumbing which flips file systems
  * read only and drops the hb ref instead of killing the node dead.
diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index 3ecb9f3..febe631 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -3249,7 +3249,7 @@ static int ocfs2_extend_dir(struct ocfs2_super *osb,
 		spin_unlock(&OCFS2_I(dir)->ip_lock);
 		ocfs2_init_dinode_extent_tree(&et, INODE_CACHE(dir),
 					      parent_fe_bh);
-		num_free_extents = ocfs2_num_free_extents(osb, &et);
+		num_free_extents = ocfs2_num_free_extents(&et);
 		if (num_free_extents < 0) {
 			status = num_free_extents;
 			mlog_errno(status);
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index bfeb647..b4512fa 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -713,13 +713,6 @@ static int __ocfs2_extend_allocation(struct inode *inode, u32 logical_start,
 	return status;
 }

-int ocfs2_extend_allocation(struct inode *inode, u32 logical_start,
-		u32 clusters_to_add, int mark_unwritten)
-{
-	return __ocfs2_extend_allocation(inode, logical_start,
-			clusters_to_add, mark_unwritten);
-}
-
 /*
  * While a write will already be ordering the data, a truncate will not.
  * Thus, we need to explicitly order the zeroed pages.
diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index d5e5fa7..3630443 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -1348,7 +1348,6 @@ void ocfs2_complete_mount_recovery(struct ocfs2_super *osb)
 	ocfs2_schedule_truncate_log_flush(osb, 0);

 	osb->local_alloc_copy = NULL;
-	osb->dirty = 0;

 	/* queue to recover orphan slots for all offline slots */
 	ocfs2_replay_map_set_state(osb, REPLAY_NEEDED);
diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
index e52a285..7eb3b0a 100644
--- a/fs/ocfs2/move_extents.c
+++ b/fs/ocfs2/move_extents.c
@@ -175,7 +175,7 @@ static int ocfs2_lock_allocators_move_extents(struct inode *inode,
 	unsigned int max_recs_needed = 2 * extents_to_split + clusters_to_move;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);

-	num_free_extents = ocfs2_num_free_extents(osb, et);
+	num_free_extents = ocfs2_num_free_extents(et);
 	if (num_free_extents < 0) {
 		ret = num_free_extents;
 		mlog_errno(ret);
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index 0c39d71..9a50f22 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -320,7 +320,6 @@ struct ocfs2_super
 	u64 system_dir_blkno;
 	u64 bitmap_blkno;
 	u32 bitmap_cpg;
-	u8 *uuid;
 	char *uuid_str;
 	u32 uuid_hash;
 	u8 *vol_label;
@@ -388,9 +387,8 @@ struct ocfs2_super
 	unsigned int	osb_resv_level;
 	unsigned int	osb_dir_resv_level;

-	/* Next three fields are for local node slot recovery during
+	/* Next two fields are for local node slot recovery during
 	 * mount. */
-	int dirty;
 	struct ocfs2_dinode *local_alloc_copy;
 	struct ocfs2_quota_recovery *quota_rec;

diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index f8933cb..ab156e3 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -2851,7 +2851,7 @@ static int ocfs2_lock_refcount_allocators(struct super_block *sb,
 					int *credits)
 {
 	int ret = 0, meta_add = 0;
-	int num_free_extents = ocfs2_num_free_extents(OCFS2_SB(sb), et);
+	int num_free_extents = ocfs2_num_free_extents(et);

 	if (num_free_extents < 0) {
 		ret = num_free_extents;
diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index 6ad3533..71f22c8 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -2700,7 +2700,7 @@ int ocfs2_lock_allocators(struct inode *inode,

 	BUG_ON(clusters_to_add != 0 && data_ac == NULL);

-	num_free_extents = ocfs2_num_free_extents(osb, et);
+	num_free_extents = ocfs2_num_free_extents(et);
 	if (num_free_extents < 0) {
 		ret = num_free_extents;
 		mlog_errno(ret);
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index ca1646f..a34963c 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -2486,7 +2486,6 @@ static int ocfs2_check_volume(struct ocfs2_super *osb)
 	if (dirty) {
 		/* Recovery will be completed after we've mounted the
 		 * rest of the volume. */
-		osb->dirty = 1;
 		osb->local_alloc_copy = local_alloc;
 		local_alloc = NULL;
 	}
diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index f70c377..5fdf269 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -6800,7 +6800,7 @@ static int ocfs2_lock_reflink_xattr_rec_allocators(
 		*credits += 1;

 	/* count in the xattr tree change. */
-	num_free_extents = ocfs2_num_free_extents(osb, xt_et);
+	num_free_extents = ocfs2_num_free_extents(xt_et);
 	if (num_free_extents < 0) {
 		ret = num_free_extents;
 		mlog_errno(ret);
-- 
1.9.5.msysgit.0
