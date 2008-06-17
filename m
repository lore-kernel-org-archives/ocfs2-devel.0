From: Joel Becker <joel.becker@oracle.com>
Date: Tue, 17 Jun 2008 15:41:00 -0700
Subject: [Ocfs2-devel] [RFC] configfs: Pin configfs subsystems separately
	from new config_items.
Message-ID: <1213742460-26331-1-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-fsdevel@vger.kernel.org
Cc: cluster-devel@redhat.com, Louis.Rilling@kerlabs.com, ocfs2-devel@oss.oracle.com

configfs_mkdir() creates a new item by calling its parent's
->make_item/group() functions.  Once that object is created,
configfs_mkdir() calls try_module_get() on the new item's module.  If it
succeeds, the module owning the new item cannot be unloaded, and
configfs is safe to reference the item.

If the item and the subsystem it belongs to are part of the same module,
the subsystem is also pinned.  This is the common case.

However, if the subsystem is made up of multiple modules, this may not
pin the subsystem.  Thus, it would be possible to unload the toplevel
subsystem module while there is still a child item.  Thus, we now
try_module_get() the subsystem's module.  This only really affects
children of the toplevel subsystem group.  Deeper children already have
their parents pinned.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/configfs/dir.c |   42 +++++++++++++++++++++++++++++++++---------
 1 files changed, 33 insertions(+), 9 deletions(-)

diff --git a/fs/configfs/dir.c b/fs/configfs/dir.c
index a48dc7d..52eed83 100644
--- a/fs/configfs/dir.c
+++ b/fs/configfs/dir.c
@@ -1008,7 +1008,7 @@ static int configfs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 	struct configfs_subsystem *subsys;
 	struct configfs_dirent *sd;
 	struct config_item_type *type;
-	struct module *owner = NULL;
+	struct module *subsys_owner = NULL, *new_item_owner = NULL;
 	char *name;
 
 	if (dentry->d_parent == configfs_sb->s_root) {
@@ -1035,10 +1035,25 @@ static int configfs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 		goto out_put;
 	}
 
+	/*
+	 * The subsystem may belong to a different module than the item
+	 * being created.  We don't want to safely pin the new item but
+	 * fail to pin the subsystem it sits under.
+	 */
+	if (!subsys->su_group.cg_item.ci_type) {
+		ret = -EINVAL;
+		goto out_put;
+	}
+	subsys_owner = subsys->su_group.cg_item.ci_type->ct_owner;
+	if (!try_module_get(subsys_owner)) {
+		ret = -EINVAL;
+		goto out_put;
+	}
+
 	name = kmalloc(dentry->d_name.len + 1, GFP_KERNEL);
 	if (!name) {
 		ret = -ENOMEM;
-		goto out_put;
+		goto out_subsys_put;
 	}
 
 	snprintf(name, dentry->d_name.len + 1, "%s", dentry->d_name.name);
@@ -1066,7 +1081,7 @@ static int configfs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 		 * There are no extra references to clean up.
 		 */
 		ret = -ENOMEM;
-		goto out_put;
+		goto out_subsys_put;
 	}
 
 	/*
@@ -1080,8 +1095,8 @@ static int configfs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 		goto out_unlink;
 	}
 
-	owner = type->ct_owner;
-	if (!try_module_get(owner)) {
+	new_item_owner = type->ct_owner;
+	if (!try_module_get(new_item_owner)) {
 		ret = -EINVAL;
 		goto out_unlink;
 	}
@@ -1113,9 +1128,13 @@ out_unlink:
 		mutex_unlock(&subsys->su_mutex);
 
 		if (module_got)
-			module_put(owner);
+			module_put(new_item_owner);
 	}
 
+out_subsys_put:
+	if (ret)
+		module_put(subsys_owner);
+
 out_put:
 	/*
 	 * link_obj()/link_group() took a reference from child->parent,
@@ -1134,7 +1153,7 @@ static int configfs_rmdir(struct inode *dir, struct dentry *dentry)
 	struct config_item *item;
 	struct configfs_subsystem *subsys;
 	struct configfs_dirent *sd;
-	struct module *owner = NULL;
+	struct module *subsys_owner = NULL, *dead_item_owner = NULL;
 	int ret;
 
 	if (dentry->d_parent == configfs_sb->s_root)
@@ -1161,6 +1180,10 @@ static int configfs_rmdir(struct inode *dir, struct dentry *dentry)
 		return -EINVAL;
 	}
 
+	/* configfs_mkdir() shouldn't have allowed this */
+	BUG_ON(!subsys->su_group.cg_item.ci_type);
+	subsys_owner = subsys->su_group.cg_item.ci_type->ct_owner;
+
 	ret = configfs_detach_prep(dentry);
 	if (ret) {
 		configfs_detach_rollback(dentry);
@@ -1175,7 +1198,7 @@ static int configfs_rmdir(struct inode *dir, struct dentry *dentry)
 	config_item_put(parent_item);
 
 	if (item->ci_type)
-		owner = item->ci_type->ct_owner;
+		dead_item_owner = item->ci_type->ct_owner;
 
 	if (sd->s_type & CONFIGFS_USET_DIR) {
 		configfs_detach_group(item);
@@ -1197,7 +1220,8 @@ static int configfs_rmdir(struct inode *dir, struct dentry *dentry)
 	/* Drop our reference from above */
 	config_item_put(item);
 
-	module_put(owner);
+	module_put(dead_item_owner);
+	module_put(subsys_owner);
 
 	return 0;
 }
-- 
1.5.5.4
