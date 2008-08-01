From: Louis Rilling <louis.rilling@kerlabs.com>
Date: Fri,  1 Aug 2008 14:03:02 +0200
Subject: [Ocfs2-devel] [PATCH] configfs: Consolidate locking around
	configfs_detach_prep() in configfs_rmdir()
Message-ID: <1217592182-26845-1-git-send-email-louis.rilling@kerlabs.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joel Becker <Joel.Becker@oracle.com>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com, Louis Rilling <louis.rilling@kerlabs.com>

It appears that configfs_rmdir() can protect configfs_detach_prep() retries with
less calls to {spin,mutex}_{lock,unlock}, and a cleaner code.

This patch does not change any behavior, except that it removes two useless
lock/unlock pairs having nothing inside to protect and providing a useless
barrier.

Signed-off-by: Louis Rilling <louis.rilling@kerlabs.com>
---
 fs/configfs/dir.c |   17 +++++++----------
 1 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/fs/configfs/dir.c b/fs/configfs/dir.c
index 7a8db78..8e93341 100644
--- a/fs/configfs/dir.c
+++ b/fs/configfs/dir.c
@@ -1311,16 +1311,18 @@ static int configfs_rmdir(struct inode *dir, struct dentry *dentry)
 	 * Ensure that no racing symlink() will make detach_prep() fail while
 	 * the new link is temporarily attached
 	 */
-	mutex_lock(&configfs_symlink_mutex);
-	spin_lock(&configfs_dirent_lock);
 	do {
 		struct mutex *wait_mutex;
 
+		mutex_lock(&configfs_symlink_mutex);
+		spin_lock(&configfs_dirent_lock);
 		ret = configfs_detach_prep(dentry, &wait_mutex);
-		if (ret) {
+		if (ret)
 			configfs_detach_rollback(dentry);
-			spin_unlock(&configfs_dirent_lock);
-			mutex_unlock(&configfs_symlink_mutex);
+		spin_unlock(&configfs_dirent_lock);
+		mutex_unlock(&configfs_symlink_mutex);
+
+		if (ret) {
 			if (ret != -EAGAIN) {
 				config_item_put(parent_item);
 				return ret;
@@ -1329,13 +1331,8 @@ static int configfs_rmdir(struct inode *dir, struct dentry *dentry)
 			/* Wait until the racing operation terminates */
 			mutex_lock(wait_mutex);
 			mutex_unlock(wait_mutex);
-
-			mutex_lock(&configfs_symlink_mutex);
-			spin_lock(&configfs_dirent_lock);
 		}
 	} while (ret == -EAGAIN);
-	spin_unlock(&configfs_dirent_lock);
-	mutex_unlock(&configfs_symlink_mutex);
 
 	/* Get a working ref for the duration of this function */
 	item = configfs_get_config_item(dentry);
-- 
1.5.5.3
