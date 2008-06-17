From: Louis Rilling <louis.rilling@kerlabs.com>
Date: Tue, 17 Jun 2008 19:37:21 +0200
Subject: [Ocfs2-devel] [BUGFIX][PATCH 1/3] configfs: Fix symlink() to a
	removing item
In-Reply-To: <1213724243-29183-1-git-send-email-louis.rilling@kerlabs.com>
References: <1213724243-29183-1-git-send-email-louis.rilling@kerlabs.com>
Message-ID: <1213724243-29183-2-git-send-email-louis.rilling@kerlabs.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joel.Becker@oracle.com
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com, Louis Rilling <louis.rilling@kerlabs.com>

The rule for configfs symlinks is that symlinks always point to valid
config_items, and prevent the target from being removed. However,
configfs_symlink() only checks that it can grab a reference on the target item,
without ensuring that it remains alive until the symlink is correctly attached.

This patch makes configfs_symlink() fail whenever the target is being removed,
using the CONFIGFS_USET_DROPPING flag set by configfs_detach_prep() and
protected by configfs_dirent_lock.

This patch introduces a similar (weird?) behavior as with mkdir failures making
rmdir fail: if symlink() races with rmdir() of the parent directory (or its
youngest user-created ancestor if parent is a default group) or rmdir() of the
target directory, and then fails in configfs_create(), this can make the racing
rmdir() fail despite the concerned directory having no user-created entry (resp.
no symlink pointing to it or one of its default groups) in the end.
This behavior is fixed in later patches.

Signed-off-by: Louis Rilling <louis.rilling@kerlabs.com>
---
 fs/configfs/dir.c     |   14 +++++++-------
 fs/configfs/symlink.c |    6 ++++++
 2 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/fs/configfs/dir.c b/fs/configfs/dir.c
index 614e382..f2a12d0 100644
--- a/fs/configfs/dir.c
+++ b/fs/configfs/dir.c
@@ -370,6 +370,9 @@ static int configfs_detach_prep(struct dentry *dentry, struct mutex **wait_mutex
 	struct configfs_dirent *sd;
 	int ret;
 
+	/* Mark that we're trying to drop the group */
+	parent_sd->s_type |= CONFIGFS_USET_DROPPING;
+
 	ret = -EBUSY;
 	if (!list_empty(&parent_sd->s_links))
 		goto out;
@@ -385,8 +388,6 @@ static int configfs_detach_prep(struct dentry *dentry, struct mutex **wait_mutex
 					*wait_mutex = &sd->s_dentry->d_inode->i_mutex;
 				return -EAGAIN;
 			}
-			/* Mark that we're trying to drop the group */
-			sd->s_type |= CONFIGFS_USET_DROPPING;
 
 			/*
 			 * Yup, recursive.  If there's a problem, blame
@@ -414,12 +415,11 @@ static void configfs_detach_rollback(struct dentry *dentry)
 	struct configfs_dirent *parent_sd = dentry->d_fsdata;
 	struct configfs_dirent *sd;
 
-	list_for_each_entry(sd, &parent_sd->s_children, s_sibling) {
-		if (sd->s_type & CONFIGFS_USET_DEFAULT) {
+	parent_sd->s_type &= ~CONFIGFS_USET_DROPPING;
+
+	list_for_each_entry(sd, &parent_sd->s_children, s_sibling)
+		if (sd->s_type & CONFIGFS_USET_DEFAULT)
 			configfs_detach_rollback(sd->s_dentry);
-			sd->s_type &= ~CONFIGFS_USET_DROPPING;
-		}
-	}
 }
 
 static void detach_attrs(struct config_item * item)
diff --git a/fs/configfs/symlink.c b/fs/configfs/symlink.c
index faeb441..58722a9 100644
--- a/fs/configfs/symlink.c
+++ b/fs/configfs/symlink.c
@@ -78,6 +78,12 @@ static int create_link(struct config_item *parent_item,
 	if (sl) {
 		sl->sl_target = config_item_get(item);
 		spin_lock(&configfs_dirent_lock);
+		if (target_sd->s_type & CONFIGFS_USET_DROPPING) {
+			spin_unlock(&configfs_dirent_lock);
+			config_item_put(item);
+			kfree(sl);
+			return -EPERM;
+		}
 		list_add(&sl->sl_list, &target_sd->s_links);
 		spin_unlock(&configfs_dirent_lock);
 		ret = configfs_create_link(sl, parent_item->ci_dentry,
-- 
1.5.5.3
