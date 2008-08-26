From: Tao Ma <tao.ma@oracle.com>
Date: Wed, 27 Aug 2008 06:38:33 +0800
Subject: [Ocfs2-devel] [PATCH 1/2] ocfs2: Add wrapper for the check of
	extent tree type.
In-Reply-To: <48B4F128.2060303@oracle.com>
References: <48B4F128.2060303@oracle.com>
Message-ID: <1219790314-9355-1-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In some places we may need to check the ocfs2_extent_tree's type,
so add the checker for them.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/alloc.c |   19 +++++++++++++++++--
 fs/ocfs2/alloc.h |    3 +++
 2 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 5f44ef8..80dbf2f 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -344,6 +344,21 @@ void ocfs2_init_xattr_value_extent_tree(struct ocfs2_extent_tree *et,
 				 &ocfs2_xattr_value_et_ops);
 }
 
+int ocfs2_is_dinode_extent_tree(struct ocfs2_extent_tree *et)
+{
+	return et->et_ops == &ocfs2_dinode_et_ops;
+}
+
+int ocfs2_is_xattr_value_extent_tree(struct ocfs2_extent_tree *et)
+{
+	return et->et_ops == &ocfs2_xattr_value_et_ops;
+}
+
+int ocfs2_is_xattr_tree_extent_tree(struct ocfs2_extent_tree *et)
+{
+	return et->et_ops == &ocfs2_xattr_tree_et_ops;
+}
+
 static inline void ocfs2_et_set_last_eb_blk(struct ocfs2_extent_tree *et,
 					    u64 new_last_eb_blk)
 {
@@ -4476,7 +4491,7 @@ int ocfs2_insert_extent(struct ocfs2_super *osb,
 	status = ocfs2_do_insert_extent(inode, handle, et, &rec, &insert);
 	if (status < 0)
 		mlog_errno(status);
-	else if (et->et_ops == &ocfs2_dinode_et_ops)
+	else if (ocfs2_is_dinode_extent_tree(et))
 		ocfs2_extent_map_insert_rec(inode, &rec);
 
 bail:
@@ -4874,7 +4889,7 @@ int ocfs2_mark_extent_written(struct inode *inode,
 	 * XXX: This is a hack on the extent tree, maybe it should be
 	 * an op?
 	 */
-	if (et->et_ops == &ocfs2_dinode_et_ops)
+	if (ocfs2_is_dinode_extent_tree(et))
 		ocfs2_extent_map_trunc(inode, 0);
 
 	left_path = ocfs2_new_path(et->et_root_bh, et->et_root_el);
diff --git a/fs/ocfs2/alloc.h b/fs/ocfs2/alloc.h
index a0ae6bd..8b98f40 100644
--- a/fs/ocfs2/alloc.h
+++ b/fs/ocfs2/alloc.h
@@ -72,6 +72,9 @@ void ocfs2_init_xattr_value_extent_tree(struct ocfs2_extent_tree *et,
 					struct inode *inode,
 					struct buffer_head *bh,
 					struct ocfs2_xattr_value_root *xv);
+int ocfs2_is_dinode_extent_tree(struct ocfs2_extent_tree *et);
+int ocfs2_is_xattr_value_extent_tree(struct ocfs2_extent_tree *et);
+int ocfs2_is_xattr_tree_extent_tree(struct ocfs2_extent_tree *et);
 
 struct ocfs2_alloc_context;
 int ocfs2_insert_extent(struct ocfs2_super *osb,
-- 
1.5.4.GIT
