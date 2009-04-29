From: Tao Ma <tao.ma@oracle.com>
Date: Thu, 30 Apr 2009 06:58:37 +0800
Subject: [Ocfs2-devel] [PATCH 25/39] ocfs2: Add refcount tree find mechanism
	from an inode.
In-Reply-To: <49F95A79.6040806@oracle.com>
References: <49F95A79.6040806@oracle.com>
Message-ID: <1241045931-24607-25-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

xattr need refcount tree support, but some functions don't
have an easy access to the inode bh, so add a helper function
which read inode_bh first and then get the refcount tree.

And in order to speed up the refcount searching, we add a
LRU to the ocfs2_super so that we can find a recently used
refcount tree more quickly.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/ocfs2.h        |    1 +
 fs/ocfs2/refcounttree.c |   85 ++++++++++++++++++++++++++++++++++++++++-------
 fs/ocfs2/refcounttree.h |    1 -
 3 files changed, 74 insertions(+), 13 deletions(-)

diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index 3f62291..9ea1b30 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -383,6 +383,7 @@ struct ocfs2_super
 
 	/* rb tree root for refcount lock. */
 	struct rb_root	osb_rf_lock_tree;
+	struct ocfs2_refcount_tree *osb_ref_tree_lru;
 };
 
 #define OCFS2_SB(sb)	    ((struct ocfs2_super *)(sb)->s_fs_info)
diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index 4ef6bd2..a12d739 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -3140,7 +3140,11 @@ static int ocfs2_get_refcount_tree(struct ocfs2_super *osb, u64 rf_blkno,
 	struct ocfs2_refcount_tree *tree, *new = NULL;
 
 	spin_lock(&osb->osb_lock);
-	tree = ocfs2_find_refcount_tree(osb, rf_blkno);
+	if (osb->osb_ref_tree_lru &&
+	    osb->osb_ref_tree_lru->rf_blkno == rf_blkno)
+		tree = osb->osb_ref_tree_lru;
+	else
+		tree = ocfs2_find_refcount_tree(osb, rf_blkno);
 	if (tree)
 		goto out;
 
@@ -3176,29 +3180,48 @@ out:
 
 	*ret_tree = tree;
 
+	osb->osb_ref_tree_lru = tree;
 	spin_unlock(&osb->osb_lock);
 
 	return ret;
 }
 
-/*
- * Lock the refcount tree pointed by ref_blkno and return the tree.
- * In most case, we lock the tree and read the refcount block.
- * So read it here if the caller really need it.
- */
-int ocfs2_lock_refcount_tree(struct ocfs2_super *osb, u64 ref_blkno, int rw,
-			     struct ocfs2_refcount_tree **ret_tree,
-			     struct buffer_head **ref_bh)
+/* Search refcount tree by inode. */
+static int ocfs2_get_refcount_tree_by_inode(struct inode *inode,
+					struct ocfs2_refcount_tree **ret_tree)
 {
 	int ret;
-	struct ocfs2_refcount_tree *tree = NULL;
+	struct buffer_head *di_bh = NULL;
+	struct ocfs2_dinode *di;
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 
-	ret = ocfs2_get_refcount_tree(osb, ref_blkno, &tree);
+	/* We have never touch refcount tree for this inode. So let us do it. */
+	ret = ocfs2_read_inode_block(inode, &di_bh);
 	if (ret) {
 		mlog_errno(ret);
 		goto out;
 	}
 
+	BUG_ON(!(OCFS2_I(inode)->ip_dyn_features & OCFS2_HAS_REFCOUNT_FL));
+
+	di = (struct ocfs2_dinode *)di_bh->b_data;
+	ret = ocfs2_get_refcount_tree(osb, le64_to_cpu(di->i_refcount_loc),
+				      ret_tree);
+	if (ret)
+		mlog_errno(ret);
+
+	brelse(di_bh);
+out:
+	return ret;
+}
+
+static int __ocfs2_lock_refcount_tree(struct ocfs2_super *osb,
+				      struct ocfs2_refcount_tree *tree, int rw,
+				      struct ocfs2_refcount_tree **ret_tree,
+				      struct buffer_head **ref_bh)
+{
+	int ret;
+
 	ret = ocfs2_refcount_lock(&tree->rf_lockres, rw);
 	if (ret) {
 		mlog_errno(ret);
@@ -3212,7 +3235,7 @@ int ocfs2_lock_refcount_tree(struct ocfs2_super *osb, u64 ref_blkno, int rw,
 
 	if (ref_bh) {
 		ret = ocfs2_read_refcount_block(&tree->rf_ci,
-						ref_blkno, ref_bh);
+						tree->rf_blkno, ref_bh);
 		if (ret) {
 			mlog_errno(ret);
 			ocfs2_unlock_refcount_tree(osb, tree, rw);
@@ -3225,6 +3248,44 @@ out:
 	return ret;
 }
 
+/*
+ * Lock the refcount tree pointed by ref_blkno and return the tree.
+ * In most case, we lock the tree and read the refcount block.
+ * So read it here if the caller really need it.
+ */
+int ocfs2_lock_refcount_tree(struct ocfs2_super *osb, u64 ref_blkno, int rw,
+			     struct ocfs2_refcount_tree **ret_tree,
+			     struct buffer_head **ref_bh)
+{
+	int ret;
+	struct ocfs2_refcount_tree *tree = NULL;
+
+	ret = ocfs2_get_refcount_tree(osb, ref_blkno, &tree);
+	if (ret) {
+		mlog_errno(ret);
+		return ret;
+	}
+
+	return __ocfs2_lock_refcount_tree(osb, tree, rw, ret_tree, ref_bh);
+}
+
+int ocfs2_lock_refcount_tree_by_inode(struct inode *inode, int rw,
+				      struct ocfs2_refcount_tree **ret_tree,
+				      struct buffer_head **ref_bh)
+{
+	int ret;
+	struct ocfs2_refcount_tree *tree = NULL;
+
+	ret = ocfs2_get_refcount_tree_by_inode(inode, &tree);
+	if (ret) {
+		mlog_errno(ret);
+		return ret;
+	}
+
+	return __ocfs2_lock_refcount_tree(OCFS2_SB(inode->i_sb), tree,
+					  rw, ret_tree, ref_bh);
+}
+
 void ocfs2_unlock_refcount_tree(struct ocfs2_super *osb,
 				struct ocfs2_refcount_tree *tree, int rw)
 {
diff --git a/fs/ocfs2/refcounttree.h b/fs/ocfs2/refcounttree.h
index b7fb077..ed86f65 100644
--- a/fs/ocfs2/refcounttree.h
+++ b/fs/ocfs2/refcounttree.h
@@ -28,7 +28,6 @@ struct ocfs2_refcount_tree {
 	spinlock_t rf_lock;
 	struct mutex rf_io_mutex;
 	struct super_block *rf_sb;
-
 };
 
 static inline struct ocfs2_refcount_tree *
-- 
1.6.2.rc2.16.gf474c
