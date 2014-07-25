From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Fri, 25 Jul 2014 13:32:47 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: reflink: fix slow unlink for
	refcounted file
Message-ID: <1406266367-12188-1-git-send-email-junxiao.bi@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

When running ocfs2 test suite multiple nodes reflink stress test, for
a 4 nodes cluster, every unlink() for refcounted file needs about 700s.

The slow unlink is caused by the contention of refcount tree lock since all
nodes are unlink files using the same refcount tree. When the unlinking file
have many extents(over 1600 in our test), most of the extents has refcounted
flag set. In ocfs2_commit_truncate(), it will execute the following call trace
for every extents. This means it needs get and released refcount tree lock
about 1600 times. And when several nodes are do this at the same time, the
performance will be very low.
.
ocfs2_remove_btree_range()
----ocfs2_lock_refcount_tree()
------ocfs2_refcount_lock()
--------__ocfs2_cluster_lock()

ocfs2_refcount_lock() is costly, move it to ocfs2_commit_truncate() to do
lock/unlock once can improve a lot performance.

Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
---
 fs/ocfs2/alloc.c |   22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 9d8fcf2..a764363 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -5667,13 +5667,6 @@ int ocfs2_remove_btree_range(struct inode *inode,
 		BUG_ON(!(OCFS2_I(inode)->ip_dyn_features &
 			 OCFS2_HAS_REFCOUNT_FL));
 
-		ret = ocfs2_lock_refcount_tree(osb, refcount_loc, 1,
-					       &ref_tree, NULL);
-		if (ret) {
-			mlog_errno(ret);
-			goto bail;
-		}
-
 		ret = ocfs2_prepare_refcount_change_for_del(inode,
 							    refcount_loc,
 							    phys_blkno,
@@ -5755,9 +5748,6 @@ bail:
 	if (meta_ac)
 		ocfs2_free_alloc_context(meta_ac);
 
-	if (ref_tree)
-		ocfs2_unlock_refcount_tree(osb, ref_tree, 1);
-
 	return ret;
 }
 
@@ -7012,6 +7002,7 @@ int ocfs2_commit_truncate(struct ocfs2_super *osb,
 	u64 refcount_loc = le64_to_cpu(di->i_refcount_loc);
 	struct ocfs2_extent_tree et;
 	struct ocfs2_cached_dealloc_ctxt dealloc;
+	struct ocfs2_refcount_tree *ref_tree = NULL;
 
 	ocfs2_init_dinode_extent_tree(&et, INODE_CACHE(inode), di_bh);
 	ocfs2_init_dealloc_ctxt(&dealloc);
@@ -7121,6 +7112,15 @@ start:
 
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
 					  refcount_loc);
@@ -7138,6 +7138,8 @@ start:
 	goto start;
 
 bail:
+	if (ref_tree)
+		ocfs2_unlock_refcount_tree(osb, ref_tree, 1);
 
 	ocfs2_schedule_truncate_log_flush(osb, 1);
 
-- 
1.7.9.5
