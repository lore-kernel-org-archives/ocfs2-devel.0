From: Louis Rilling <louis.rilling@kerlabs.com>
Date: Mon, 23 Jun 2008 14:16:18 +0200
Subject: [Ocfs2-devel] [PATCH 2/2] configfs: Fix failing symlink() making
	rmdir() fail
In-Reply-To: <1214223378-14203-1-git-send-email-louis.rilling@kerlabs.com>
References: <1214223378-14203-1-git-send-email-louis.rilling@kerlabs.com>
Message-ID: <1214223378-14203-3-git-send-email-louis.rilling@kerlabs.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joel.Becker@oracle.com
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com, Louis Rilling <louis.rilling@kerlabs.com>

On a similar pattern as mkdir() vs rmdir(), a failing symlink() may make rmdir()
fail for the symlink's parent and the symlink's target as well.

failing symlink() making target's rmdir() fail:

	process 1:				process 2:
	symlink("A/S" -> "B")
	  allow_link()
	  create_link()
	    attach to "B" links list
						rmdir("B")
						  detach_prep("B")
						    error because of new link
	    configfs_create_link("A", "S")
	      error (eg -ENOMEM)

failing symlink() making parent's rmdir() fail:

	process 1:				process 2:
	symlink("A/D/S" -> "B")
	  allow_link()
	  create_link()
	    attach to "B" links list
	    configfs_create_link("A/D", "S")
	      make_dirent("A/D", "S")
						rmdir("A")
						  detach_prep("A")
						    detach_prep("A/D")
						      error because of "S"
	      create("S")
	        error (eg -ENOMEM)

We cannot use the same solution as for mkdir() vs rmdir(), since rmdir() on the
target cannot wait on the i_mutex of the new symlink's parent without risking a
deadlock (with other symlink() or sys_rename()). Instead we define a global
mutex protecting all configfs symlinks attachment, so that rmdir() can avoid the
races above.

Signed-off-by: Louis Rilling <louis.rilling@kerlabs.com>
---
 fs/configfs/configfs_internal.h |    1 +
 fs/configfs/dir.c               |   10 ++++++++++
 fs/configfs/symlink.c           |    8 +++++++-
 3 files changed, 18 insertions(+), 1 deletions(-)

diff --git a/fs/configfs/configfs_internal.h b/fs/configfs/configfs_internal.h
index da015c1..5f61b26 100644
--- a/fs/configfs/configfs_internal.h
+++ b/fs/configfs/configfs_internal.h
@@ -51,6 +51,7 @@ struct configfs_dirent {
 #define CONFIGFS_USET_IN_MKDIR	0x0200
 #define CONFIGFS_NOT_PINNED	(CONFIGFS_ITEM_ATTR)
 
+extern struct mutex configfs_symlink_mutex;
 extern spinlock_t configfs_dirent_lock;
 
 extern struct vfsmount * configfs_mount;
diff --git a/fs/configfs/dir.c b/fs/configfs/dir.c
index f2a12d0..2c873fd 100644
--- a/fs/configfs/dir.c
+++ b/fs/configfs/dir.c
@@ -1202,6 +1202,11 @@ static int configfs_rmdir(struct inode *dir, struct dentry *dentry)
 		return -EINVAL;
 	}
 
+	/*
+	 * Ensure that no racing symlink() will make detach_prep() fail while
+	 * the new link is temporarily attached
+	 */
+	mutex_lock(&configfs_symlink_mutex);
 	spin_lock(&configfs_dirent_lock);
 	do {
 		struct mutex *wait_mutex;
@@ -1210,6 +1215,7 @@ static int configfs_rmdir(struct inode *dir, struct dentry *dentry)
 		if (ret) {
 			configfs_detach_rollback(dentry);
 			spin_unlock(&configfs_dirent_lock);
+			mutex_unlock(&configfs_symlink_mutex);
 			if (ret != -EAGAIN) {
 				config_item_put(parent_item);
 				return ret;
@@ -1219,10 +1225,12 @@ static int configfs_rmdir(struct inode *dir, struct dentry *dentry)
 			mutex_lock(wait_mutex);
 			mutex_unlock(wait_mutex);
 
+			mutex_lock(&configfs_symlink_mutex);
 			spin_lock(&configfs_dirent_lock);
 		}
 	} while (ret == -EAGAIN);
 	spin_unlock(&configfs_dirent_lock);
+	mutex_unlock(&configfs_symlink_mutex);
 
 	/* Get a working ref for the duration of this function */
 	item = configfs_get_config_item(dentry);
@@ -1512,11 +1520,13 @@ void configfs_unregister_subsystem(struct configfs_subsystem *subsys)
 	mutex_lock_nested(&configfs_sb->s_root->d_inode->i_mutex,
 			  I_MUTEX_PARENT);
 	mutex_lock_nested(&dentry->d_inode->i_mutex, I_MUTEX_CHILD);
+	mutex_lock(&configfs_symlink_mutex);
 	spin_lock(&configfs_dirent_lock);
 	if (configfs_detach_prep(dentry, NULL)) {
 		printk(KERN_ERR "configfs: Tried to unregister non-empty subsystem!\n");
 	}
 	spin_unlock(&configfs_dirent_lock);
+	mutex_unlock(&configfs_symlink_mutex);
 	configfs_detach_group(&group->cg_item);
 	dentry->d_inode->i_flags |= S_DEAD;
 	mutex_unlock(&dentry->d_inode->i_mutex);
diff --git a/fs/configfs/symlink.c b/fs/configfs/symlink.c
index b66908d..21bd751 100644
--- a/fs/configfs/symlink.c
+++ b/fs/configfs/symlink.c
@@ -31,6 +31,9 @@
 #include <linux/configfs.h>
 #include "configfs_internal.h"
 
+/* Protects attachments of new symlinks */
+DEFINE_MUTEX(configfs_symlink_mutex);
+
 static int item_depth(struct config_item * item)
 {
 	struct config_item * p = item;
@@ -146,8 +149,11 @@ int configfs_symlink(struct inode *dir, struct dentry *dentry, const char *symna
 		goto out_put;
 
 	ret = type->ct_item_ops->allow_link(parent_item, target_item);
-	if (!ret)
+	if (!ret) {
+		mutex_lock(&configfs_symlink_mutex);
 		ret = create_link(parent_item, target_item, dentry);
+		mutex_unlock(&configfs_symlink_mutex);
+	}
 
 	config_item_put(target_item);
 	path_put(&nd.path);
-- 
1.5.5.3
