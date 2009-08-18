From: Tao Ma <tao.ma@oracle.com>
Date: Tue, 18 Aug 2009 14:19:08 +0800
Subject: [Ocfs2-devel] [PATCH 07/41] ocfs2: Add refcount tree lock mechanism.
In-Reply-To: <4A8A47DF.8020707@oracle.com>
References: <4A8A47DF.8020707@oracle.com>
Message-ID: <1250576382-27080-7-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Create a tree lock named ocfs2_refcount_tree. It protects
all the read/write operation to the refcount tree. Also
it has its only caching_info so that we can protect our
own buffer_head among multiple nodes.

User must call ocfs2_lock_refcount_tree before his operation
on the tree and unlock it after that.

This tree is only indicated by the root refcount block number.
So create a rb-tree for it and store the root in ocfs2_super.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/ocfs2.h        |    4 +
 fs/ocfs2/refcounttree.c |  359 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/ocfs2/refcounttree.h |    7 +
 fs/ocfs2/super.c        |    5 +
 4 files changed, 375 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index 6688d19..bb53573 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -408,6 +408,10 @@ struct ocfs2_super
 
 	/* the group we used to allocate inodes. */
 	u64				osb_inode_alloc_group;
+
+	/* rb tree root for refcount lock. */
+	struct rb_root	osb_rf_lock_tree;
+	struct ocfs2_refcount_tree *osb_ref_tree_lru;
 };
 
 #define OCFS2_SB(sb)	    ((struct ocfs2_super *)(sb)->s_fs_info)
diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index eb0f4a0..b6d356b 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -27,6 +27,7 @@
 #include "buffer_head_io.h"
 #include "blockcheck.h"
 #include "refcounttree.h"
+#include "dlmglue.h"
 
 static inline struct ocfs2_refcount_tree *
 cache_info_to_refcount(struct ocfs2_caching_info *ci)
@@ -156,3 +157,361 @@ static const struct ocfs2_caching_operations ocfs2_refcount_caching_ops = {
 	.co_io_lock		= ocfs2_refcount_cache_io_lock,
 	.co_io_unlock		= ocfs2_refcount_cache_io_unlock,
 };
+
+static struct ocfs2_refcount_tree *
+ocfs2_find_refcount_tree(struct ocfs2_super *osb, u64 blkno)
+{
+	struct rb_node *n = osb->osb_rf_lock_tree.rb_node;
+	struct ocfs2_refcount_tree *tree = NULL;
+
+	while (n) {
+		tree = rb_entry(n, struct ocfs2_refcount_tree, rf_node);
+
+		if (blkno < tree->rf_blkno)
+			n = n->rb_left;
+		else if (blkno > tree->rf_blkno)
+			n = n->rb_right;
+		else
+			return tree;
+	}
+
+	return NULL;
+}
+
+/* osb_lock is already locked. */
+static void ocfs2_insert_refcount_tree(struct ocfs2_super *osb,
+				       struct ocfs2_refcount_tree *new)
+{
+	u64 rf_blkno = new->rf_blkno;
+	struct rb_node *parent = NULL;
+	struct rb_node **p = &osb->osb_rf_lock_tree.rb_node;
+	struct ocfs2_refcount_tree *tmp;
+
+	while (*p) {
+		parent = *p;
+
+		tmp = rb_entry(parent, struct ocfs2_refcount_tree,
+			       rf_node);
+
+		if (rf_blkno < tmp->rf_blkno)
+			p = &(*p)->rb_left;
+		else if (rf_blkno > tmp->rf_blkno)
+			p = &(*p)->rb_right;
+		else {
+			/* This should never happen! */
+			mlog(ML_ERROR, "Duplicate refcount block %llu found!\n",
+			     (unsigned long long)rf_blkno);
+			BUG();
+		}
+	}
+
+	rb_link_node(&new->rf_node, parent, p);
+	rb_insert_color(&new->rf_node, &osb->osb_rf_lock_tree);
+}
+
+static void ocfs2_free_refcount_tree(struct ocfs2_refcount_tree *tree)
+{
+	ocfs2_metadata_cache_exit(&tree->rf_ci);
+	ocfs2_simple_drop_lockres(OCFS2_SB(tree->rf_sb), &tree->rf_lockres);
+	ocfs2_lock_res_free(&tree->rf_lockres);
+	kfree(tree);
+}
+
+static inline void
+ocfs2_erase_refcount_tree_from_list_no_lock(struct ocfs2_super *osb,
+					struct ocfs2_refcount_tree *tree)
+{
+	rb_erase(&tree->rf_node, &osb->osb_rf_lock_tree);
+	if (osb->osb_ref_tree_lru && osb->osb_ref_tree_lru == tree)
+		osb->osb_ref_tree_lru = NULL;
+}
+
+static void ocfs2_erase_refcount_tree_from_list(struct ocfs2_super *osb,
+					struct ocfs2_refcount_tree *tree)
+{
+	spin_lock(&osb->osb_lock);
+	ocfs2_erase_refcount_tree_from_list_no_lock(osb, tree);
+	spin_unlock(&osb->osb_lock);
+}
+
+void ocfs2_kref_remove_refcount_tree(struct kref *kref)
+{
+	struct ocfs2_refcount_tree *tree =
+		container_of(kref, struct ocfs2_refcount_tree, rf_getcnt);
+
+	ocfs2_free_refcount_tree(tree);
+}
+
+static inline void
+ocfs2_refcount_tree_get(struct ocfs2_refcount_tree *tree)
+{
+	kref_get(&tree->rf_getcnt);
+}
+
+static inline void
+ocfs2_refcount_tree_put(struct ocfs2_refcount_tree *tree)
+{
+	kref_put(&tree->rf_getcnt, ocfs2_kref_remove_refcount_tree);
+}
+
+static inline void ocfs2_init_refcount_tree_ci(struct ocfs2_refcount_tree *new,
+					       struct super_block *sb)
+{
+	ocfs2_metadata_cache_init(&new->rf_ci, &ocfs2_refcount_caching_ops);
+	mutex_init(&new->rf_io_mutex);
+	new->rf_sb = sb;
+	spin_lock_init(&new->rf_lock);
+}
+
+static inline void ocfs2_init_refcount_tree_lock(struct ocfs2_super *osb,
+					struct ocfs2_refcount_tree *new,
+					u64 rf_blkno, u32 generation)
+{
+	init_rwsem(&new->rf_sem);
+	ocfs2_refcount_lock_res_init(&new->rf_lockres, osb,
+				     rf_blkno, generation);
+}
+
+static int ocfs2_get_refcount_tree(struct ocfs2_super *osb, u64 rf_blkno,
+				   struct ocfs2_refcount_tree **ret_tree)
+{
+	int ret = 0;
+	struct ocfs2_refcount_tree *tree, *new = NULL;
+	struct buffer_head *ref_root_bh = NULL;
+	struct ocfs2_refcount_block *ref_rb;
+
+	spin_lock(&osb->osb_lock);
+	if (osb->osb_ref_tree_lru &&
+	    osb->osb_ref_tree_lru->rf_blkno == rf_blkno)
+		tree = osb->osb_ref_tree_lru;
+	else
+		tree = ocfs2_find_refcount_tree(osb, rf_blkno);
+	if (tree)
+		goto out;
+
+	spin_unlock(&osb->osb_lock);
+
+	new = kzalloc(sizeof(struct ocfs2_refcount_tree), GFP_NOFS);
+	if (!new) {
+		ret = -ENOMEM;
+		return ret;
+	}
+
+	new->rf_blkno = rf_blkno;
+	kref_init(&new->rf_getcnt);
+	ocfs2_init_refcount_tree_ci(new, osb->sb);
+
+	/*
+	 * We need the generation to create the refcount tree lock and since
+	 * it isn't changed during the tree modification, we are safe here to
+	 * read without protection.
+	 * We also have to purge the cache after we create the lock since the
+	 * refcount block may have the stale data. It can only be trusted when
+	 * we hold the refcount lock.
+	 */
+	ret = ocfs2_read_refcount_block(&new->rf_ci, rf_blkno, &ref_root_bh);
+	if (ret) {
+		mlog_errno(ret);
+		ocfs2_metadata_cache_exit(&new->rf_ci);
+		kfree(new);
+		return ret;
+	}
+
+	ref_rb = (struct ocfs2_refcount_block *)ref_root_bh->b_data;
+	new->rf_generation = le32_to_cpu(ref_rb->rf_generation);
+	ocfs2_init_refcount_tree_lock(osb, new, rf_blkno,
+				      new->rf_generation);
+	ocfs2_metadata_cache_purge(&new->rf_ci);
+
+	spin_lock(&osb->osb_lock);
+	tree = ocfs2_find_refcount_tree(osb, rf_blkno);
+	if (tree)
+		goto out;
+
+	ocfs2_insert_refcount_tree(osb, new);
+
+	tree = new;
+	new = NULL;
+
+out:
+	*ret_tree = tree;
+
+	osb->osb_ref_tree_lru = tree;
+
+	spin_unlock(&osb->osb_lock);
+
+	if (new)
+		ocfs2_free_refcount_tree(new);
+
+	brelse(ref_root_bh);
+	return ret;
+}
+
+static int ocfs2_get_refcount_block(struct inode *inode, u64 *ref_blkno)
+{
+	int ret;
+	struct buffer_head *di_bh = NULL;
+	struct ocfs2_dinode *di;
+
+	ret = ocfs2_read_inode_block(inode, &di_bh);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	BUG_ON(!(OCFS2_I(inode)->ip_dyn_features & OCFS2_HAS_REFCOUNT_FL));
+
+	di = (struct ocfs2_dinode *)di_bh->b_data;
+	*ref_blkno = le64_to_cpu(di->i_refcount_loc);
+	brelse(di_bh);
+out:
+	return ret;
+}
+
+static int __ocfs2_lock_refcount_tree(struct ocfs2_super *osb,
+				      struct ocfs2_refcount_tree *tree, int rw)
+{
+	int ret;
+
+	ret = ocfs2_refcount_lock(tree, rw);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	if (rw)
+		down_write(&tree->rf_sem);
+	else
+		down_read(&tree->rf_sem);
+
+out:
+	return ret;
+}
+
+/*
+ * Lock the refcount tree pointed by ref_blkno and return the tree.
+ * In most case, we lock the tree and read the refcount block.
+ * So read it here if the caller really need it.
+ *
+ * If the tree has been re-created by other node, it will free the
+ * old one and re-create it.
+ */
+int ocfs2_lock_refcount_tree(struct ocfs2_super *osb,
+			     u64 ref_blkno, int rw,
+			     struct ocfs2_refcount_tree **ret_tree,
+			     struct buffer_head **ref_bh)
+{
+	int ret, delete_tree = 0;
+	struct ocfs2_refcount_tree *tree = NULL;
+	struct buffer_head *ref_root_bh = NULL;
+	struct ocfs2_refcount_block *rb;
+
+again:
+	ret = ocfs2_get_refcount_tree(osb, ref_blkno, &tree);
+	if (ret) {
+		mlog_errno(ret);
+		return ret;
+	}
+
+	ocfs2_refcount_tree_get(tree);
+
+	ret = __ocfs2_lock_refcount_tree(osb, tree, rw);
+	if (ret) {
+		mlog_errno(ret);
+		ocfs2_refcount_tree_put(tree);
+		goto out;
+	}
+
+	ret = ocfs2_read_refcount_block(&tree->rf_ci, tree->rf_blkno,
+					&ref_root_bh);
+	if (ret) {
+		mlog_errno(ret);
+		ocfs2_unlock_refcount_tree(osb, tree, rw);
+		ocfs2_refcount_tree_put(tree);
+		goto out;
+	}
+
+	rb = (struct ocfs2_refcount_block *)ref_root_bh->b_data;
+	/*
+	 * If the refcount block has been freed and re-created, we may need
+	 * to recreate the refcount tree also.
+	 *
+	 * Here we just remove the tree from the rb-tree, and the last
+	 * kref holder will unlock and delete this refcount_tree.
+	 * Then we goto "again" and ocfs2_get_refcount_tree will create
+	 * the new refcount tree for us.
+	 */
+	if (tree->rf_generation != le32_to_cpu(rb->rf_generation)) {
+		if (!tree->rf_removed) {
+			ocfs2_erase_refcount_tree_from_list(osb, tree);
+			tree->rf_removed = 1;
+			delete_tree = 1;
+		}
+
+		ocfs2_unlock_refcount_tree(osb, tree, rw);
+		/*
+		 * We get an extra reference when we create the refcount
+		 * tree, so another put will destroy it.
+		 */
+		if (delete_tree)
+			ocfs2_refcount_tree_put(tree);
+		brelse(ref_root_bh);
+		ref_root_bh = NULL;
+		goto again;
+	}
+
+	*ret_tree = tree;
+	if (ref_bh) {
+		*ref_bh = ref_root_bh;
+		ref_root_bh = NULL;
+	}
+out:
+	brelse(ref_root_bh);
+	return ret;
+}
+
+int ocfs2_lock_refcount_tree_by_inode(struct inode *inode, int rw,
+				      struct ocfs2_refcount_tree **ret_tree,
+				      struct buffer_head **ref_bh)
+{
+	int ret;
+	u64 ref_blkno;
+
+	ret = ocfs2_get_refcount_block(inode, &ref_blkno);
+	if (ret) {
+		mlog_errno(ret);
+		return ret;
+	}
+
+	return ocfs2_lock_refcount_tree(OCFS2_SB(inode->i_sb), ref_blkno,
+					rw, ret_tree, ref_bh);
+}
+
+void ocfs2_unlock_refcount_tree(struct ocfs2_super *osb,
+				struct ocfs2_refcount_tree *tree, int rw)
+{
+	if (rw)
+		up_write(&tree->rf_sem);
+	else
+		up_read(&tree->rf_sem);
+
+	ocfs2_refcount_unlock(tree, rw);
+	ocfs2_refcount_tree_put(tree);
+}
+
+void ocfs2_purge_refcount_tree(struct ocfs2_super *osb)
+{
+	struct rb_node *node;
+	struct ocfs2_refcount_tree *tree;
+	struct rb_root *root = &osb->osb_rf_lock_tree;
+
+	while ((node = rb_last(root)) != NULL) {
+		tree = rb_entry(node, struct ocfs2_refcount_tree, rf_node);
+
+		mlog(0, "Purge tree %llu\n",
+		     (unsigned long long) tree->rf_blkno);
+
+		rb_erase(&tree->rf_node, root);
+		ocfs2_free_refcount_tree(tree);
+	}
+}
diff --git a/fs/ocfs2/refcounttree.h b/fs/ocfs2/refcounttree.h
index 9a3695c..3c38bbd 100644
--- a/fs/ocfs2/refcounttree.h
+++ b/fs/ocfs2/refcounttree.h
@@ -33,4 +33,11 @@ struct ocfs2_refcount_tree {
 	struct super_block *rf_sb;
 };
 
+void ocfs2_purge_refcount_tree(struct ocfs2_super *osb);
+int ocfs2_lock_refcount_tree(struct ocfs2_super *osb, u64 ref_blkno, int rw,
+			     struct ocfs2_refcount_tree **tree,
+			     struct buffer_head **ref_bh);
+void ocfs2_unlock_refcount_tree(struct ocfs2_super *osb,
+				struct ocfs2_refcount_tree *tree,
+				int rw);
 #endif /* OCFS2_REFCOUNTTREE_H */
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index e35a505..4edc298 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -69,6 +69,7 @@
 #include "ver.h"
 #include "xattr.h"
 #include "quota.h"
+#include "refcounttree.h"
 
 #include "buffer_head_io.h"
 
@@ -1858,6 +1859,8 @@ static void ocfs2_dismount_volume(struct super_block *sb, int mnt_err)
 
 	ocfs2_sync_blockdev(sb);
 
+	ocfs2_purge_refcount_tree(osb);
+
 	/* No cluster connection means we've failed during mount, so skip
 	 * all the steps which depended on that to complete. */
 	if (osb->cconn) {
@@ -2064,6 +2067,8 @@ static int ocfs2_initialize_super(struct super_block *sb,
 		goto bail;
 	}
 
+	osb->osb_rf_lock_tree = RB_ROOT;
+
 	osb->s_feature_compat =
 		le32_to_cpu(OCFS2_RAW_SB(di)->s_feature_compat);
 	osb->s_feature_ro_compat =
-- 
1.6.2.rc2.16.gf474c
