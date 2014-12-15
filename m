From: akpm at linux-foundation.org <akpm@linux-foundation.org>
Date: Mon, 15 Dec 2014 14:51:06 -0800
Subject: [Ocfs2-devel] [patch 06/15] ocfs2: reflink: fix slow unlink for
	refcounted file
Message-ID: <548f65da.rrmQq58cyUfZy3uq%akpm@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Junxiao Bi <junxiao.bi@oracle.com>
Subject: ocfs2: reflink: fix slow unlink for refcounted file

When running ocfs2 test suite multiple nodes reflink stress test, for a 4
nodes cluster, every unlink() for refcounted file needs about 700s.

The slow unlink is caused by the contention of refcount tree lock since
all nodes are unlink files using the same refcount tree.  When the
unlinking file have many extents(over 1600 in our test), most of the
extents has refcounted flag set.  In ocfs2_commit_truncate(), it will
execute the following call trace for every extents.  This means it needs
get and released refcount tree lock about 1600 times.  And when several
nodes are do this at the same time, the performance will be very low.

ocfs2_remove_btree_range()
----ocfs2_lock_refcount_tree()
------ocfs2_refcount_lock()
--------__ocfs2_cluster_lock()

ocfs2_refcount_lock() is costly, move it to ocfs2_commit_truncate() to do
lock/unlock once can improve a lot performance.

Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Wengang <wen.gang.wang@oracle.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/alloc.c |   28 +++++++++++++++++++++-------
 fs/ocfs2/alloc.h |    2 +-
 fs/ocfs2/dir.c   |    2 +-
 fs/ocfs2/file.c  |    2 +-
 4 files changed, 24 insertions(+), 10 deletions(-)

diff -puN fs/ocfs2/alloc.c~ocfs2-reflink-fix-slow-unlink-for-refcounted-file fs/ocfs2/alloc.c
--- a/fs/ocfs2/alloc.c~ocfs2-reflink-fix-slow-unlink-for-refcounted-file
+++ a/fs/ocfs2/alloc.c
@@ -5662,7 +5662,7 @@ int ocfs2_remove_btree_range(struct inod
 			     struct ocfs2_extent_tree *et,
 			     u32 cpos, u32 phys_cpos, u32 len, int flags,
 			     struct ocfs2_cached_dealloc_ctxt *dealloc,
-			     u64 refcount_loc)
+			     u64 refcount_loc, bool refcount_tree_locked)
 {
 	int ret, credits = 0, extra_blocks = 0;
 	u64 phys_blkno = ocfs2_clusters_to_blocks(inode->i_sb, phys_cpos);
@@ -5676,11 +5676,13 @@ int ocfs2_remove_btree_range(struct inod
 		BUG_ON(!(OCFS2_I(inode)->ip_dyn_features &
 			 OCFS2_HAS_REFCOUNT_FL));
 
-		ret = ocfs2_lock_refcount_tree(osb, refcount_loc, 1,
-					       &ref_tree, NULL);
-		if (ret) {
-			mlog_errno(ret);
-			goto bail;
+		if (!refcount_tree_locked) {
+			ret = ocfs2_lock_refcount_tree(osb, refcount_loc, 1,
+						       &ref_tree, NULL);
+			if (ret) {
+				mlog_errno(ret);
+				goto bail;
+			}
 		}
 
 		ret = ocfs2_prepare_refcount_change_for_del(inode,
@@ -7021,6 +7023,7 @@ int ocfs2_commit_truncate(struct ocfs2_s
 	u64 refcount_loc = le64_to_cpu(di->i_refcount_loc);
 	struct ocfs2_extent_tree et;
 	struct ocfs2_cached_dealloc_ctxt dealloc;
+	struct ocfs2_refcount_tree *ref_tree = NULL;
 
 	ocfs2_init_dinode_extent_tree(&et, INODE_CACHE(inode), di_bh);
 	ocfs2_init_dealloc_ctxt(&dealloc);
@@ -7130,9 +7133,18 @@ start:
 
 	phys_cpos = ocfs2_blocks_to_clusters(inode->i_sb, blkno);
 
+	if ((flags & OCFS2_EXT_REFCOUNTED) && trunc_len && !ref_tree) {
+		status = ocfs2_lock_refcount_tree(osb, refcount_loc, 1,
+				&ref_tree, NULL);
+		if (status) {
+			mlog_errno(status);
+			goto bail;
+		}
+	}
+
 	status = ocfs2_remove_btree_range(inode, &et, trunc_cpos,
 					  phys_cpos, trunc_len, flags, &dealloc,
-					  refcount_loc);
+					  refcount_loc, true);
 	if (status < 0) {
 		mlog_errno(status);
 		goto bail;
@@ -7147,6 +7159,8 @@ start:
 	goto start;
 
 bail:
+	if (ref_tree)
+		ocfs2_unlock_refcount_tree(osb, ref_tree, 1);
 
 	ocfs2_schedule_truncate_log_flush(osb, 1);
 
diff -puN fs/ocfs2/alloc.h~ocfs2-reflink-fix-slow-unlink-for-refcounted-file fs/ocfs2/alloc.h
--- a/fs/ocfs2/alloc.h~ocfs2-reflink-fix-slow-unlink-for-refcounted-file
+++ a/fs/ocfs2/alloc.h
@@ -142,7 +142,7 @@ int ocfs2_remove_btree_range(struct inod
 			     struct ocfs2_extent_tree *et,
 			     u32 cpos, u32 phys_cpos, u32 len, int flags,
 			     struct ocfs2_cached_dealloc_ctxt *dealloc,
-			     u64 refcount_loc);
+			     u64 refcount_loc, bool refcount_tree_locked);
 
 int ocfs2_num_free_extents(struct ocfs2_super *osb,
 			   struct ocfs2_extent_tree *et);
diff -puN fs/ocfs2/dir.c~ocfs2-reflink-fix-slow-unlink-for-refcounted-file fs/ocfs2/dir.c
--- a/fs/ocfs2/dir.c~ocfs2-reflink-fix-slow-unlink-for-refcounted-file
+++ a/fs/ocfs2/dir.c
@@ -4479,7 +4479,7 @@ int ocfs2_dx_dir_truncate(struct inode *
 		p_cpos = ocfs2_blocks_to_clusters(dir->i_sb, blkno);
 
 		ret = ocfs2_remove_btree_range(dir, &et, cpos, p_cpos, clen, 0,
-					       &dealloc, 0);
+					       &dealloc, 0, false);
 		if (ret) {
 			mlog_errno(ret);
 			goto out;
diff -puN fs/ocfs2/file.c~ocfs2-reflink-fix-slow-unlink-for-refcounted-file fs/ocfs2/file.c
--- a/fs/ocfs2/file.c~ocfs2-reflink-fix-slow-unlink-for-refcounted-file
+++ a/fs/ocfs2/file.c
@@ -1803,7 +1803,7 @@ static int ocfs2_remove_inode_range(stru
 
 		ret = ocfs2_remove_btree_range(inode, &et, trunc_cpos,
 					       phys_cpos, trunc_len, flags,
-					       &dealloc, refcount_loc);
+					       &dealloc, refcount_loc, false);
 		if (ret < 0) {
 			mlog_errno(ret);
 			goto out;
_
