From: Louis Rilling <louis.rilling@kerlabs.com>
Date: Thu, 26 Jun 2008 20:05:49 +0200
Subject: [Ocfs2-devel] [BUGFIX][PATCH 2/2] configfs: Lock new directory
	inodes before removing on cleanup after failure
In-Reply-To: <1214503549-15678-1-git-send-email-louis.rilling@kerlabs.com>
References: <1214503549-15678-1-git-send-email-louis.rilling@kerlabs.com>
Message-ID: <1214503549-15678-3-git-send-email-louis.rilling@kerlabs.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joel Becker <Joel.Becker@oracle.com>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com, Louis Rilling <louis.rilling@kerlabs.com>

Once a new configfs directory is created by configfs_attach_item() or
configfs_attach_group(), a failure in the remaining initialization steps leads
to removing a directory which inode the VFS may have already accessed.

This commit adds the necessary inode locking to safely remove configfs
directories while cleaning up after a failure. As an advantage, the locking
rules of populate_groups() and detach_groups() become the same: the caller must
have the group's inode mutex locked.

Signed-off-by: Louis Rilling <louis.rilling@kerlabs.com>
---
 fs/configfs/dir.c |   50 +++++++++++++++++++++++++++++---------------------
 1 files changed, 29 insertions(+), 21 deletions(-)

diff --git a/fs/configfs/dir.c b/fs/configfs/dir.c
index bfd2620..c11bc1b 100644
--- a/fs/configfs/dir.c
+++ b/fs/configfs/dir.c
@@ -303,6 +303,8 @@ static void remove_dir(struct dentry * d)
  * The only thing special about this is that we remove any files in
  * the directory before we remove the directory, and we've inlined
  * what used to be configfs_rmdir() below, instead of calling separately.
+ *
+ * Caller holds the mutex of the item's inode
  */
 
 static void configfs_remove_dir(struct config_item * item)
@@ -594,36 +596,20 @@ static int create_default_group(struct config_group *parent_group,
 static int populate_groups(struct config_group *group)
 {
 	struct config_group *new_group;
-	struct dentry *dentry = group->cg_item.ci_dentry;
 	int ret = 0;
 	int i;
 
-	if (group->default_groups) {
-		/*
-		 * FYI, we're faking mkdir here
-		 * I'm not sure we need this semaphore, as we're called
-		 * from our parent's mkdir.  That holds our parent's
-		 * i_mutex, so afaik lookup cannot continue through our
-		 * parent to find us, let alone mess with our tree.
-		 * That said, taking our i_mutex is closer to mkdir
-		 * emulation, and shouldn't hurt.
-		 */
-		mutex_lock_nested(&dentry->d_inode->i_mutex, I_MUTEX_CHILD);
-
+	if (group->default_groups)
 		for (i = 0; group->default_groups[i]; i++) {
 			new_group = group->default_groups[i];
 
 			ret = create_default_group(group, new_group);
-			if (ret)
+			if (ret) {
+				detach_groups(group);
 				break;
+			}
 		}
 
-		mutex_unlock(&dentry->d_inode->i_mutex);
-	}
-
-	if (ret)
-		detach_groups(group);
-
 	return ret;
 }
 
@@ -738,7 +724,14 @@ static int configfs_attach_item(struct config_item *parent_item,
 	if (!ret) {
 		ret = populate_attrs(item);
 		if (ret) {
+			/*
+			 * We are going to remove an inode and its dentry but
+			 * the VFS may already have hit and used them.
+			 */
+			mutex_lock(&dentry->d_inode->i_mutex);
 			configfs_remove_dir(item);
+			dentry->d_inode->i_flags |= S_DEAD;
+			mutex_unlock(&dentry->d_inode->i_mutex);
 			d_delete(dentry);
 		}
 	}
@@ -746,6 +739,7 @@ static int configfs_attach_item(struct config_item *parent_item,
 	return ret;
 }
 
+/* Caller holds the mutex of the item's inode */
 static void configfs_detach_item(struct config_item *item)
 {
 	detach_attrs(item);
@@ -764,16 +758,30 @@ static int configfs_attach_group(struct config_item *parent_item,
 		sd = dentry->d_fsdata;
 		sd->s_type |= CONFIGFS_USET_DIR;
 
+		/*
+		 * FYI, we're faking mkdir in populate_groups()
+		 * We must lock the group's inode to avoid races with the VFS
+		 * which can already hit the inode and try to add/remove entries
+		 * under it.
+		 *
+		 * We must also lock the inode to remove it safely in case of
+		 * error.
+		 */
+		mutex_lock_nested(&dentry->d_inode->i_mutex, I_MUTEX_CHILD);
 		ret = populate_groups(to_config_group(item));
 		if (ret) {
 			configfs_detach_item(item);
-			d_delete(dentry);
+			dentry->d_inode->i_flags |= S_DEAD;
 		}
+		mutex_unlock(&dentry->d_inode->i_mutex);
+		if (ret)
+			d_delete(dentry);
 	}
 
 	return ret;
 }
 
+/* Caller holds the mutex of the group's inode */
 static void configfs_detach_group(struct config_item *item)
 {
 	detach_groups(to_config_group(item));
-- 
1.5.5.3
