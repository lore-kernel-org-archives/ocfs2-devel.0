From: Mark Fasheh <mfasheh@suse.com>
Date: Mon, 14 Jul 2008 15:01:47 -0700
Subject: [Ocfs2-devel] [PATCH 14/17] configfs: Fix failing mkdir() making
	racing rmdir() fail
In-Reply-To: <1216072910-27226-1-git-send-email-mfasheh@suse.com>
References: <1216072910-27226-1-git-send-email-mfasheh@suse.com>
Message-ID: <1216072910-27226-15-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: Mark Fasheh <mfasheh@suse.com>, ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>, Louis Rilling <Louis.Rilling@kerlabs.com>

From: Louis Rilling <Louis.Rilling@kerlabs.com>

When fixing the rename() vs rmdir() deadlock, we stopped locking default groups'
inodes in configfs_detach_prep(), letting racing mkdir() in default groups
proceed concurrently. This enables races like below happen, which leads to a
failing mkdir() making rmdir() fail, despite the group to remove having no
user-created directory under it in the end.

	process A: 			process B:
	/* PWD=A/B */
	mkdir("C")
	  make_item("C")
	  attach_group("C")
					rmdir("A")
					  detach_prep("A")
					    detach_prep("B")
					      error because of "C"
					  return -ENOTEMPTY
	    attach_group("C/D")
	      error (eg -ENOMEM)
	  return -ENOMEM

This patch prevents such scenarii by making rmdir() wait as long as
detach_prep() fails because a racing mkdir() is in the middle of attach_group().
To achieve this, mkdir() sets a flag CONFIGFS_USET_IN_MKDIR in parent's
configfs_dirent before calling attach_group(), and clears the flag once
attach_group() is done. detach_prep() fails with -EAGAIN whenever the flag is
hit and returns the guilty inode's mutex so that rmdir() can wait on it.

Signed-off-by: Louis Rilling <Louis.Rilling@kerlabs.com>
Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/configfs/configfs_internal.h |    1 +
 fs/configfs/dir.c               |   53 +++++++++++++++++++++++++++++++-------
 2 files changed, 44 insertions(+), 10 deletions(-)

diff --git a/fs/configfs/configfs_internal.h b/fs/configfs/configfs_internal.h
index 5a33b58..da015c1 100644
--- a/fs/configfs/configfs_internal.h
+++ b/fs/configfs/configfs_internal.h
@@ -48,6 +48,7 @@ struct configfs_dirent {
 #define CONFIGFS_USET_DIR	0x0040
 #define CONFIGFS_USET_DEFAULT	0x0080
 #define CONFIGFS_USET_DROPPING	0x0100
+#define CONFIGFS_USET_IN_MKDIR	0x0200
 #define CONFIGFS_NOT_PINNED	(CONFIGFS_ITEM_ATTR)
 
 extern spinlock_t configfs_dirent_lock;
diff --git a/fs/configfs/dir.c b/fs/configfs/dir.c
index d5b5985..614e382 100644
--- a/fs/configfs/dir.c
+++ b/fs/configfs/dir.c
@@ -364,7 +364,7 @@ static struct dentry * configfs_lookup(struct inode *dir,
  * If there is an error, the caller will reset the flags via
  * configfs_detach_rollback().
  */
-static int configfs_detach_prep(struct dentry *dentry)
+static int configfs_detach_prep(struct dentry *dentry, struct mutex **wait_mutex)
 {
 	struct configfs_dirent *parent_sd = dentry->d_fsdata;
 	struct configfs_dirent *sd;
@@ -379,6 +379,12 @@ static int configfs_detach_prep(struct dentry *dentry)
 		if (sd->s_type & CONFIGFS_NOT_PINNED)
 			continue;
 		if (sd->s_type & CONFIGFS_USET_DEFAULT) {
+			/* Abort if racing with mkdir() */
+			if (sd->s_type & CONFIGFS_USET_IN_MKDIR) {
+				if (wait_mutex)
+					*wait_mutex = &sd->s_dentry->d_inode->i_mutex;
+				return -EAGAIN;
+			}
 			/* Mark that we're trying to drop the group */
 			sd->s_type |= CONFIGFS_USET_DROPPING;
 
@@ -386,7 +392,7 @@ static int configfs_detach_prep(struct dentry *dentry)
 			 * Yup, recursive.  If there's a problem, blame
 			 * deep nesting of default_groups
 			 */
-			ret = configfs_detach_prep(sd->s_dentry);
+			ret = configfs_detach_prep(sd->s_dentry, wait_mutex);
 			if (!ret)
 				continue;
 		} else
@@ -1113,11 +1119,26 @@ static int configfs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 	 */
 	module_got = 1;
 
+	/*
+	 * Make racing rmdir() fail if it did not tag parent with
+	 * CONFIGFS_USET_DROPPING
+	 * Note: if CONFIGFS_USET_DROPPING is already set, attach_group() will
+	 * fail and let rmdir() terminate correctly
+	 */
+	spin_lock(&configfs_dirent_lock);
+	/* This will make configfs_detach_prep() fail */
+	sd->s_type |= CONFIGFS_USET_IN_MKDIR;
+	spin_unlock(&configfs_dirent_lock);
+
 	if (group)
 		ret = configfs_attach_group(parent_item, item, dentry);
 	else
 		ret = configfs_attach_item(parent_item, item, dentry);
 
+	spin_lock(&configfs_dirent_lock);
+	sd->s_type &= ~CONFIGFS_USET_IN_MKDIR;
+	spin_unlock(&configfs_dirent_lock);
+
 out_unlink:
 	if (ret) {
 		/* Tear down everything we built up */
@@ -1182,13 +1203,25 @@ static int configfs_rmdir(struct inode *dir, struct dentry *dentry)
 	}
 
 	spin_lock(&configfs_dirent_lock);
-	ret = configfs_detach_prep(dentry);
-	if (ret) {
-		configfs_detach_rollback(dentry);
-		spin_unlock(&configfs_dirent_lock);
-		config_item_put(parent_item);
-		return ret;
-	}
+	do {
+		struct mutex *wait_mutex;
+
+		ret = configfs_detach_prep(dentry, &wait_mutex);
+		if (ret) {
+			configfs_detach_rollback(dentry);
+			spin_unlock(&configfs_dirent_lock);
+			if (ret != -EAGAIN) {
+				config_item_put(parent_item);
+				return ret;
+			}
+
+			/* Wait until the racing operation terminates */
+			mutex_lock(wait_mutex);
+			mutex_unlock(wait_mutex);
+
+			spin_lock(&configfs_dirent_lock);
+		}
+	} while (ret == -EAGAIN);
 	spin_unlock(&configfs_dirent_lock);
 
 	/* Get a working ref for the duration of this function */
@@ -1480,7 +1513,7 @@ void configfs_unregister_subsystem(struct configfs_subsystem *subsys)
 			  I_MUTEX_PARENT);
 	mutex_lock_nested(&dentry->d_inode->i_mutex, I_MUTEX_CHILD);
 	spin_lock(&configfs_dirent_lock);
-	if (configfs_detach_prep(dentry)) {
+	if (configfs_detach_prep(dentry, NULL)) {
 		printk(KERN_ERR "configfs: Tried to unregister non-empty subsystem!\n");
 	}
 	spin_unlock(&configfs_dirent_lock);
-- 
1.5.4.1
