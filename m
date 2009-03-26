From: Tao Ma <tao.ma@oracle.com>
Date: Fri, 27 Mar 2009 07:02:31 +0800
Subject: [Ocfs2-devel] [PATCH 25/42] ocfs2: Add refcount tree lock mechanism.
In-Reply-To: <49CC86FC.2070906@oracle.com>
References: <49CC86FC.2070906@oracle.com>
Message-ID: <1238108568-23740-25-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Refcount tree lock is only related to a block number. So
create a rb-tree for it. And the tree root is stored in
ocfs2_super.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/ocfs2.h        |    3 +
 fs/ocfs2/refcounttree.c |  185 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/ocfs2/refcounttree.h |    7 ++
 fs/ocfs2/super.c        |    5 ++
 4 files changed, 200 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index 74db43f..366c91c 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -372,6 +372,9 @@ struct ocfs2_super
 	struct ocfs2_node_map		osb_recovering_orphan_dirs;
 	unsigned int			*osb_orphan_wipes;
 	wait_queue_head_t		osb_wipe_event;
+
+	/* rb tree root for refcount lock. */
+	struct rb_root	osb_rf_lock_tree;
 };
 
 #define OCFS2_SB(sb)	    ((struct ocfs2_super *)(sb)->s_fs_info)
diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index e86bb27..d6a6352 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -2050,3 +2050,188 @@ out:
 
 	return error;
 }
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
+					    struct ocfs2_refcount_tree *new)
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
+static void ocfs2_free_refcount_tree(struct ocfs2_super *osb,
+				     struct ocfs2_refcount_tree *tree)
+{
+	ocfs2_simple_drop_lockres(osb, &tree->rf_lockres);
+	ocfs2_lock_res_free(&tree->rf_lockres);
+	kfree(tree);
+}
+
+static void ocfs2_delete_refcount_tree(struct ocfs2_super *osb,
+				       struct ocfs2_refcount_tree *tree)
+{
+	spin_lock(&osb->osb_lock);
+	rb_erase(&tree->rf_node, &osb->osb_rf_lock_tree);
+	spin_unlock(&osb->osb_lock);
+
+	ocfs2_free_refcount_tree(osb, tree);
+}
+
+static int ocfs2_get_refcount_tree(struct ocfs2_super *osb, u64 rf_blkno,
+				   struct ocfs2_refcount_tree **ret_tree)
+{
+	int ret = 0;
+	struct ocfs2_refcount_tree *tree, *new = NULL;
+
+	spin_lock(&osb->osb_lock);
+	tree = ocfs2_find_refcount_tree(osb, rf_blkno);
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
+	init_rwsem(&new->rf_sem);
+	ocfs2_refcount_lock_res_init(&new->rf_lockres, osb, rf_blkno);
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
+	if (new)
+		ocfs2_free_refcount_tree(osb, new);
+
+	*ret_tree = tree;
+
+	spin_unlock(&osb->osb_lock);
+
+	return ret;
+}
+
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
+		goto out;
+	}
+
+	ret = ocfs2_refcount_lock(&tree->rf_lockres, rw);
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
+	if (ref_bh) {
+		ret = ocfs2_read_refcount_block(&tree->rf_ci,
+						ref_blkno, ref_bh);
+		if (ret) {
+			mlog_errno(ret);
+			ocfs2_unlock_refcount_tree(osb, tree, rw);
+			goto out;
+		}
+	}
+
+	*ret_tree = tree;
+out:
+	return ret;
+}
+
+void ocfs2_unlock_refcount_tree(struct ocfs2_super *osb,
+				struct ocfs2_refcount_tree *tree, int rw)
+{
+	ocfs2_refcount_unlock(&tree->rf_lockres, rw);
+
+	if (rw)
+		up_write(&tree->rf_sem);
+	else
+		up_read(&tree->rf_sem);
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
+		ocfs2_free_refcount_tree(osb, tree);
+	}
+}
diff --git a/fs/ocfs2/refcounttree.h b/fs/ocfs2/refcounttree.h
index 0364989..cb776c2 100644
--- a/fs/ocfs2/refcounttree.h
+++ b/fs/ocfs2/refcounttree.h
@@ -51,4 +51,11 @@ int ocfs2_refcount_cow(struct inode *inode, struct buffer_head *di_bh,
 int ocfs2_reflink(struct inode *inode,
 		  const char __user *oldname,
 		  const char __user *newname);
+void ocfs2_purge_refcount_tree(struct ocfs2_super *osb);
+int ocfs2_lock_refcount_tree(struct ocfs2_super *osb, u64 ref_blkno, int rw,
+			     struct ocfs2_refcount_tree **tree,
+			     struct buffer_head **ref_bh);
+void ocfs2_unlock_refcount_tree(struct ocfs2_super *osb,
+				struct ocfs2_refcount_tree *tree,
+				int rw);
 #endif /* OCFS2_REFCOUNTTREE_H */
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 6497559..7dc7128 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -68,6 +68,7 @@
 #include "ver.h"
 #include "xattr.h"
 #include "quota.h"
+#include "refcounttree.h"
 
 #include "buffer_head_io.h"
 
@@ -1625,6 +1626,8 @@ static void ocfs2_dismount_volume(struct super_block *sb, int mnt_err)
 
 	ocfs2_sync_blockdev(sb);
 
+	ocfs2_purge_refcount_tree(osb);
+
 	/* No cluster connection means we've failed during mount, so skip
 	 * all the steps which depended on that to complete. */
 	if (osb->cconn) {
@@ -1817,6 +1820,8 @@ static int ocfs2_initialize_super(struct super_block *sb,
 		goto bail;
 	}
 
+	osb->osb_rf_lock_tree = RB_ROOT;
+
 	osb->s_feature_compat =
 		le32_to_cpu(OCFS2_RAW_SB(di)->s_feature_compat);
 	osb->s_feature_ro_compat =
-- 
1.6.2.rc2.16.gf474c
