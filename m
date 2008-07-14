From: Mark Fasheh <mfasheh@suse.com>
Date: Mon, 14 Jul 2008 15:01:46 -0700
Subject: [Ocfs2-devel] [PATCH 13/17] configfs: Fix deadlock with racing
	rmdir() and rename()
In-Reply-To: <1216072910-27226-1-git-send-email-mfasheh@suse.com>
References: <1216072910-27226-1-git-send-email-mfasheh@suse.com>
Message-ID: <1216072910-27226-14-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: Mark Fasheh <mfasheh@suse.com>, ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>, Louis Rilling <Louis.Rilling@kerlabs.com>

From: Louis Rilling <Louis.Rilling@kerlabs.com>

This patch fixes the deadlock between racing sys_rename() and configfs_rmdir().

The idea is to avoid locking i_mutexes of default groups in
configfs_detach_prep(), and rely instead on the new configfs_dirent_lock to
protect against configfs_dirent's linkage mutations. To ensure that an mkdir()
racing with rmdir() will not create new items in a to-be-removed default group,
we make configfs_new_dirent() check for the CONFIGFS_USET_DROPPING flag right
before linking the new dirent, and return error if the flag is set. This makes
racing mkdir()/symlink()/dir_open() fail in places where errors could already
happen, resp. in (attach_item()|attach_group())/create_link()/new_dirent().

configfs_depend() remains safe since it locks all the path from configfs root,
and is thus mutually exclusive with rmdir().

An advantage of this is that now detach_groups() unconditionnaly takes the
default groups i_mutex, which makes it more consistent with populate_groups().

Signed-off-by: Louis Rilling <Louis.Rilling@kerlabs.com>
Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/configfs/dir.c |   45 +++++++++++++++++++++++++--------------------
 1 files changed, 25 insertions(+), 20 deletions(-)

diff --git a/fs/configfs/dir.c b/fs/configfs/dir.c
index 918a332..d5b5985 100644
--- a/fs/configfs/dir.c
+++ b/fs/configfs/dir.c
@@ -43,6 +43,10 @@ DECLARE_RWSEM(configfs_rename_sem);
  * and configfs_dirent_lock locked, in that order.
  * This allows one to safely traverse configfs_dirent trees and symlinks without
  * having to lock inodes.
+ *
+ * Protects setting of CONFIGFS_USET_DROPPING: checking the flag
+ * unlocked is not reliable unless in detach_groups() called from
+ * rmdir()/unregister() and from configfs_attach_group()
  */
 DEFINE_SPINLOCK(configfs_dirent_lock);
 
@@ -91,6 +95,11 @@ static struct configfs_dirent *configfs_new_dirent(struct configfs_dirent * pare
 	INIT_LIST_HEAD(&sd->s_children);
 	sd->s_element = element;
 	spin_lock(&configfs_dirent_lock);
+	if (parent_sd->s_type & CONFIGFS_USET_DROPPING) {
+		spin_unlock(&configfs_dirent_lock);
+		kmem_cache_free(configfs_dir_cachep, sd);
+		return ERR_PTR(-ENOENT);
+	}
 	list_add(&sd->s_sibling, &parent_sd->s_children);
 	spin_unlock(&configfs_dirent_lock);
 
@@ -349,11 +358,11 @@ static struct dentry * configfs_lookup(struct inode *dir,
 
 /*
  * Only subdirectories count here.  Files (CONFIGFS_NOT_PINNED) are
- * attributes and are removed by rmdir().  We recurse, taking i_mutex
- * on all children that are candidates for default detach.  If the
- * result is clean, then configfs_detach_group() will handle dropping
- * i_mutex.  If there is an error, the caller will clean up the i_mutex
- * holders via configfs_detach_rollback().
+ * attributes and are removed by rmdir().  We recurse, setting
+ * CONFIGFS_USET_DROPPING on all children that are candidates for
+ * default detach.
+ * If there is an error, the caller will reset the flags via
+ * configfs_detach_rollback().
  */
 static int configfs_detach_prep(struct dentry *dentry)
 {
@@ -370,8 +379,7 @@ static int configfs_detach_prep(struct dentry *dentry)
 		if (sd->s_type & CONFIGFS_NOT_PINNED)
 			continue;
 		if (sd->s_type & CONFIGFS_USET_DEFAULT) {
-			mutex_lock(&sd->s_dentry->d_inode->i_mutex);
-			/* Mark that we've taken i_mutex */
+			/* Mark that we're trying to drop the group */
 			sd->s_type |= CONFIGFS_USET_DROPPING;
 
 			/*
@@ -392,7 +400,7 @@ out:
 }
 
 /*
- * Walk the tree, dropping i_mutex wherever CONFIGFS_USET_DROPPING is
+ * Walk the tree, resetting CONFIGFS_USET_DROPPING wherever it was
  * set.
  */
 static void configfs_detach_rollback(struct dentry *dentry)
@@ -403,11 +411,7 @@ static void configfs_detach_rollback(struct dentry *dentry)
 	list_for_each_entry(sd, &parent_sd->s_children, s_sibling) {
 		if (sd->s_type & CONFIGFS_USET_DEFAULT) {
 			configfs_detach_rollback(sd->s_dentry);
-
-			if (sd->s_type & CONFIGFS_USET_DROPPING) {
-				sd->s_type &= ~CONFIGFS_USET_DROPPING;
-				mutex_unlock(&sd->s_dentry->d_inode->i_mutex);
-			}
+			sd->s_type &= ~CONFIGFS_USET_DROPPING;
 		}
 	}
 }
@@ -486,16 +490,12 @@ static void detach_groups(struct config_group *group)
 
 		child = sd->s_dentry;
 
+		mutex_lock(&child->d_inode->i_mutex);
+
 		configfs_detach_group(sd->s_element);
 		child->d_inode->i_flags |= S_DEAD;
 
-		/*
-		 * From rmdir/unregister, a configfs_detach_prep() pass
-		 * has taken our i_mutex for us.  Drop it.
-		 * From mkdir/register cleanup, there is no sem held.
-		 */
-		if (sd->s_type & CONFIGFS_USET_DROPPING)
-			mutex_unlock(&child->d_inode->i_mutex);
+		mutex_unlock(&child->d_inode->i_mutex);
 
 		d_delete(child);
 		dput(child);
@@ -1181,12 +1181,15 @@ static int configfs_rmdir(struct inode *dir, struct dentry *dentry)
 		return -EINVAL;
 	}
 
+	spin_lock(&configfs_dirent_lock);
 	ret = configfs_detach_prep(dentry);
 	if (ret) {
 		configfs_detach_rollback(dentry);
+		spin_unlock(&configfs_dirent_lock);
 		config_item_put(parent_item);
 		return ret;
 	}
+	spin_unlock(&configfs_dirent_lock);
 
 	/* Get a working ref for the duration of this function */
 	item = configfs_get_config_item(dentry);
@@ -1476,9 +1479,11 @@ void configfs_unregister_subsystem(struct configfs_subsystem *subsys)
 	mutex_lock_nested(&configfs_sb->s_root->d_inode->i_mutex,
 			  I_MUTEX_PARENT);
 	mutex_lock_nested(&dentry->d_inode->i_mutex, I_MUTEX_CHILD);
+	spin_lock(&configfs_dirent_lock);
 	if (configfs_detach_prep(dentry)) {
 		printk(KERN_ERR "configfs: Tried to unregister non-empty subsystem!\n");
 	}
+	spin_unlock(&configfs_dirent_lock);
 	configfs_detach_group(&group->cg_item);
 	dentry->d_inode->i_flags |= S_DEAD;
 	mutex_unlock(&dentry->d_inode->i_mutex);
-- 
1.5.4.1
