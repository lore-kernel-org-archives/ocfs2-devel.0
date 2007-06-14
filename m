From: Joel Becker <joel.becker@oracle.com>
Date: Thu Jun 14 21:53:51 2007
Subject: [Ocfs2-devel] [PATCH 1/2] configfs: config item dependancies.
In-Reply-To: <20070615044046.GA17382@tasint.org>
References: <20070615044046.GA17382@tasint.org>
Message-ID: <E1Hz3of-0004n3-Ml@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com

Sometimes other drivers depend on particular configfs items.  For example,
ocfs2 mounts depend on a heartbeat region item.  If that region item is
removed with rmdir(2), the ocfs2 mount must BUG or go readonly.  Not happy.

This provides two additional API calls: configfs_depend_item() and
configfs_undepend_item().  A client driver can call configfs_depend_item()
on an existing item to tell configfs that it is depended on.  configfs will
then return -EBUSY from rmdir(2) for that item.  When the item is no longer
depended on, the client driver calls configfs_undepend_item() on it.

These API cannot be called underneath any configfs callbacks, as they will
conflict.  They can block and allocate.  A client driver probably shouldn't
calling them of its own gumption.  Rather it should be providing an API that
external subsystems call.

How does this work?  Imagine the ocfs2 mount process.  When it mounts, it
asks for a heart region item.  This is done via a call into the heartbeat
code.  Inside the heartbeat code, the region item is looked up.  Here,
the heartbeat code calls configfs_depend_item().  If it succeeds, then
heartbeat knows the region is safe to give to ocfs2.  If it fails, it was
being torn down anyway, and heartbeat can gracefully pass up an error.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/configfs/configfs_internal.h |    7 +
 fs/configfs/dir.c               |  203 +++++++++++++++++++++++++++++++++++++++
 include/linux/configfs.h        |    5 +
 3 files changed, 212 insertions(+), 3 deletions(-)

diff --git a/fs/configfs/configfs_internal.h b/fs/configfs/configfs_internal.h
index 7b48c03..3b0185f 100644
--- a/fs/configfs/configfs_internal.h
+++ b/fs/configfs/configfs_internal.h
@@ -29,10 +29,11 @@ #include <linux/list.h>
 
 struct configfs_dirent {
 	atomic_t		s_count;
+	int			s_dependent_count;
 	struct list_head	s_sibling;
 	struct list_head	s_children;
 	struct list_head	s_links;
-	void 			* s_element;
+	void			* s_element;
 	int			s_type;
 	umode_t			s_mode;
 	struct dentry		* s_dentry;
@@ -41,8 +42,8 @@ struct configfs_dirent {
 
 #define CONFIGFS_ROOT		0x0001
 #define CONFIGFS_DIR		0x0002
-#define CONFIGFS_ITEM_ATTR 	0x0004
-#define CONFIGFS_ITEM_LINK 	0x0020
+#define CONFIGFS_ITEM_ATTR	0x0004
+#define CONFIGFS_ITEM_LINK	0x0020
 #define CONFIGFS_USET_DIR	0x0040
 #define CONFIGFS_USET_DEFAULT	0x0080
 #define CONFIGFS_USET_DROPPING	0x0100
diff --git a/fs/configfs/dir.c b/fs/configfs/dir.c
index 5e6e37e..94b139c 100644
--- a/fs/configfs/dir.c
+++ b/fs/configfs/dir.c
@@ -355,6 +355,10 @@ static int configfs_detach_prep(struct d
 			/* Mark that we've taken i_mutex */
 			sd->s_type |= CONFIGFS_USET_DROPPING;
 
+			/*
+			 * Yup, recursive.  If there's a problem, blame
+			 * deep nesting of default_groups
+			 */
 			ret = configfs_detach_prep(sd->s_dentry);
 			if (!ret)
 				continue;
@@ -738,6 +742,198 @@ static void client_drop_item(struct conf
 		config_item_put(item);
 }
 
+/*
+ * configfs_depend_item() and configfs_undepend_item()
+ *
+ * WARNING: Do not call these from a configfs callback!
+ *
+ * This describes these functions and their helpers.
+ *
+ * Allow another kernel system to depend on a config_item.  If this
+ * happens, the item cannot go away until the dependant can live without
+ * it.  The idea is to give client modules as simple an interface as
+ * possible.  When a system asks them to depend on an item, they just
+ * call configfs_depend_item().  If the item is live and the client
+ * driver is in good shape, we'll happily do the work for them.
+ *
+ * Why is the locking complex?  Because configfs uses the VFS to handle
+ * all locking, but this function is called outside the normal
+ * VFS->configfs path.  So it must take VFS locks to prevent the
+ * VFS->configfs stuff (configfs_mkdir(), configfs_rmdir(), etc).  This is
+ * why you can't call these functions underneath configfs callbacks.
+ *
+ * Note, btw, that this can be called at *any* time, even when a configfs
+ * subsystem isn't registered, or when configfs is loading or unloading.
+ * Just like configfs_register_subsystem().  So we take the same
+ * precautions.  We pin the filesystem.  We lock each i_mutex _in_order_
+ * on our way down the tree.  If we can find the target item in the
+ * configfs tree, it must be part of the subsystem tree as well, so we
+ * do not need the subsystem semaphore.  Holding the i_mutex chain locks
+ * out mkdir() and rmdir(), who might be racing us.
+ */
+
+/*
+ * configfs_depend_prep()
+ *
+ * Only subdirectories count here.  Files (CONFIGFS_NOT_PINNED) are
+ * attributes.  This is similar but not the same to configfs_detach_prep().
+ * Note that configfs_detach_prep() expects the parent to be locked when it
+ * is called, but we lock the parent *inside* configfs_depend_prep().  We
+ * do that so we can unlock it if we find nothing.
+ *
+ * Here we do a depth-first search of the dentry hierarchy looking for
+ * our object.  We take i_mutex on each step of the way down.  IT IS
+ * ESSENTIAL THAT i_mutex LOCKING IS ORDERED.  If we come back up a branch,
+ * we'll drop the i_mutex.
+ *
+ * If the target is not found, -ENOENT is bubbled up and we have released
+ * all locks.  If the target was found, the locks will be cleared by
+ * configfs_depend_rollback().
+ *
+ * This adds a requirement that all config_items be unique!
+ *
+ * XXX: Ugly recursive!  If we keep this, it needs to be iterative!
+ */
+static int configfs_depend_prep(struct dentry *origin,
+				struct config_item *target)
+{
+	struct configfs_dirent *child_sd, *sd = origin->d_fsdata;
+	int ret = 0;
+
+	/* Lock this guy on the way down */
+	mutex_lock(&sd->s_dentry->d_inode->i_mutex);
+	if (sd->s_element == target)  /* Boo-yah */
+		goto out;
+
+	list_for_each_entry(child_sd, &sd->s_children, s_sibling) {
+		if (sd->s_type & CONFIGFS_DIR) {
+			ret = configfs_depend_prep(child_sd->s_dentry,
+						   target);
+			if (!ret)
+				goto out;  /* Child path boo-yah */
+		}
+	}
+
+	/* We looped all our children and didn't find target */
+	mutex_unlock(&sd->s_dentry->d_inode->i_mutex);
+	ret = -ENOENT;
+
+out:
+	return ret;
+}
+
+/*
+ * This is ONLY called if configfs_depend_prep() did its job.  So we can
+ * trust the entire path from item back up to origin.
+ *
+ * We walk backwards from item, unlocking each i_mutex.  We finish by
+ * unlocking origin.
+ */
+static void configfs_depend_rollback(struct dentry *origin,
+				     struct config_item *item)
+{
+	struct dentry *dentry = item->ci_dentry;
+
+	while (dentry != origin) {
+		mutex_unlock(&dentry->d_inode->i_mutex);
+		dentry = dentry->d_parent;
+	}
+
+	mutex_unlock(&origin->d_inode->i_mutex);
+}
+
+int configfs_depend_item(struct configfs_subsystem *subsys,
+			 struct config_item *target)
+{
+	int ret;
+	struct configfs_dirent *p, *root_sd, *subsys_sd = NULL;
+	struct config_item *s_item = &subsys->su_group.cg_item;
+
+	/*
+	 * Pin the configfs filesystem.  This means we can safely access
+	 * the root of the configfs filesystem.
+	 */
+	ret = configfs_pin_fs();
+	if (ret)
+		return ret;
+
+	/*
+	 * Next, lock the root directory.  We're going to check that the
+	 * subsystem is really registered, and so we need to lock out
+	 * configfs_[un]register_subsystem().
+	 */
+	mutex_lock(&configfs_sb->s_root->d_inode->i_mutex);
+
+	root_sd = configfs_sb->s_root->d_fsdata;
+
+	list_for_each_entry(p, &root_sd->s_children, s_sibling) {
+		if (p->s_type & CONFIGFS_DIR) {
+			if (p->s_element == s_item) {
+				subsys_sd = p;
+				break;
+			}
+		}
+	}
+
+	if (!subsys_sd) {
+		ret = -ENOENT;
+		goto out_unlock_fs;
+	}
+
+	/* Ok, now we can trust subsys/s_item */
+
+	/* Scan the tree, locking i_mutex recursively, return 0 if found */
+	ret = configfs_depend_prep(subsys_sd->s_dentry, target);
+	if (ret)
+		goto out_unlock_fs;
+
+	/* We hold all i_mutexes from the subsystem down to the target */
+	p = target->ci_dentry->d_fsdata;
+	p->s_dependent_count += 1;
+
+	configfs_depend_rollback(subsys_sd->s_dentry, target);
+
+out_unlock_fs:
+	mutex_unlock(&configfs_sb->s_root->d_inode->i_mutex);
+
+	/*
+	 * If we succeeded, the fs is pinned via other methods.  If not,
+	 * we're done with it anyway.  So release_fs() is always right.
+	 */
+	configfs_release_fs();
+
+	return ret;
+}
+EXPORT_SYMBOL(configfs_depend_item);
+
+/*
+ * Release the dependent linkage.  This is much simpler than
+ * configfs_depend_item() because we know that that the client driver is
+ * pinned, thus the subsystem is pinned, and therefore configfs is pinned.
+ */
+void configfs_undepend_item(struct configfs_subsystem *subsys,
+			    struct config_item *target)
+{
+	struct configfs_dirent *sd;
+
+	/*
+	 * Since we can trust everything is pinned, we just need i_mutex
+	 * on the item.
+	 */
+	mutex_lock(&target->ci_dentry->d_inode->i_mutex);
+
+	sd = target->ci_dentry->d_fsdata;
+	BUG_ON(sd->s_dependent_count < 1);
+
+	sd->s_dependent_count -= 1;
+
+	/*
+	 * After this unlock, we cannot trust the item to stay alive!
+	 * DO NOT REFERENCE item after this unlock.
+	 */
+	mutex_unlock(&target->ci_dentry->d_inode->i_mutex);
+}
+EXPORT_SYMBOL(configfs_undepend_item);
 
 static int configfs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 {
@@ -881,6 +1077,13 @@ static int configfs_rmdir(struct inode *
 	if (sd->s_type & CONFIGFS_USET_DEFAULT)
 		return -EPERM;
 
+	/*
+	 * Here's where we check for dependents.  We're protected by
+	 * i_mutex.
+	 */
+	if (sd->s_dependent_count)
+		return -EBUSY;
+
 	/* Get a working ref until we have the child */
 	parent_item = configfs_get_config_item(dentry->d_parent);
 	subsys = to_config_group(parent_item)->cg_subsys;
diff --git a/include/linux/configfs.h b/include/linux/configfs.h
index fef6f3d..9815531 100644
--- a/include/linux/configfs.h
+++ b/include/linux/configfs.h
@@ -175,6 +175,11 @@ static inline struct configfs_subsystem 
 int configfs_register_subsystem(struct configfs_subsystem *subsys);
 void configfs_unregister_subsystem(struct configfs_subsystem *subsys);
 
+/* These functions can sleep and can alloc with GFP_KERNEL */
+/* WARNING: These cannot be called underneath configfs callbacks!! */
+int configfs_depend_item(struct configfs_subsystem *subsys, struct config_item *target);
+void configfs_undepend_item(struct configfs_subsystem *subsys, struct config_item *target);
+
 #endif  /* __KERNEL__ */
 
 #endif /* _CONFIGFS_H_ */
-- 
1.4.2.3
