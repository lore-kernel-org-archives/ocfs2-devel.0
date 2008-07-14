From: Mark Fasheh <mfasheh@suse.com>
Date: Mon, 14 Jul 2008 15:01:43 -0700
Subject: [Ocfs2-devel] [PATCH 10/17] configfs: Introduce configfs_dirent_lock
In-Reply-To: <1216072910-27226-1-git-send-email-mfasheh@suse.com>
References: <1216072910-27226-1-git-send-email-mfasheh@suse.com>
Message-ID: <1216072910-27226-11-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: Mark Fasheh <mfasheh@suse.com>, ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>, Louis Rilling <Louis.Rilling@kerlabs.com>

From: Louis Rilling <Louis.Rilling@kerlabs.com>

This patch introduces configfs_dirent_lock spinlock to protect configfs_dirent
traversals against linkage mutations (add/del/move). This will allow
configfs_detach_prep() to avoid locking i_mutexes.

Locking rules for configfs_dirent linkage mutations are the same plus the
requirement of taking configfs_dirent_lock. For configfs_dirent walking, one can
either take appropriate i_mutex as before, or take configfs_dirent_lock.

The spinlock could actually be a mutex, but the critical sections are either
O(1) or should not be too long (default groups walking in last patch).

ChangeLog:
  - Clarify the comment on configfs_dirent_lock usage
  - Move sd->s_element init before linking the new dirent
  - In lseek(), do not release configfs_dirent_lock before the dirent is
    relinked.

Signed-off-by: Louis Rilling <Louis.Rilling@kerlabs.com>
Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/configfs/configfs_internal.h |    3 +++
 fs/configfs/dir.c               |   28 +++++++++++++++++++++++++++-
 fs/configfs/inode.c             |    2 ++
 fs/configfs/symlink.c           |    2 ++
 4 files changed, 34 insertions(+), 1 deletions(-)

diff --git a/fs/configfs/configfs_internal.h b/fs/configfs/configfs_internal.h
index cca9860..5a33b58 100644
--- a/fs/configfs/configfs_internal.h
+++ b/fs/configfs/configfs_internal.h
@@ -26,6 +26,7 @@
 
 #include <linux/slab.h>
 #include <linux/list.h>
+#include <linux/spinlock.h>
 
 struct configfs_dirent {
 	atomic_t		s_count;
@@ -49,6 +50,8 @@ struct configfs_dirent {
 #define CONFIGFS_USET_DROPPING	0x0100
 #define CONFIGFS_NOT_PINNED	(CONFIGFS_ITEM_ATTR)
 
+extern spinlock_t configfs_dirent_lock;
+
 extern struct vfsmount * configfs_mount;
 extern struct kmem_cache *configfs_dir_cachep;
 
diff --git a/fs/configfs/dir.c b/fs/configfs/dir.c
index a48dc7d..2619f48 100644
--- a/fs/configfs/dir.c
+++ b/fs/configfs/dir.c
@@ -35,6 +35,14 @@
 #include "configfs_internal.h"
 
 DECLARE_RWSEM(configfs_rename_sem);
+/*
+ * Protects mutations of configfs_dirent linkage together with proper i_mutex
+ * Mutators of configfs_dirent linkage must *both* have the proper inode locked
+ * and configfs_dirent_lock locked, in that order.
+ * This allows one to safely traverse configfs_dirent trees without having to
+ * lock inodes.
+ */
+DEFINE_SPINLOCK(configfs_dirent_lock);
 
 static void configfs_d_iput(struct dentry * dentry,
 			    struct inode * inode)
@@ -79,8 +87,10 @@ static struct configfs_dirent *configfs_new_dirent(struct configfs_dirent * pare
 	atomic_set(&sd->s_count, 1);
 	INIT_LIST_HEAD(&sd->s_links);
 	INIT_LIST_HEAD(&sd->s_children);
-	list_add(&sd->s_sibling, &parent_sd->s_children);
 	sd->s_element = element;
+	spin_lock(&configfs_dirent_lock);
+	list_add(&sd->s_sibling, &parent_sd->s_children);
+	spin_unlock(&configfs_dirent_lock);
 
 	return sd;
 }
@@ -173,7 +183,9 @@ static int create_dir(struct config_item * k, struct dentry * p,
 		} else {
 			struct configfs_dirent *sd = d->d_fsdata;
 			if (sd) {
+				spin_lock(&configfs_dirent_lock);
 				list_del_init(&sd->s_sibling);
+				spin_unlock(&configfs_dirent_lock);
 				configfs_put(sd);
 			}
 		}
@@ -224,7 +236,9 @@ int configfs_create_link(struct configfs_symlink *sl,
 		else {
 			struct configfs_dirent *sd = dentry->d_fsdata;
 			if (sd) {
+				spin_lock(&configfs_dirent_lock);
 				list_del_init(&sd->s_sibling);
+				spin_unlock(&configfs_dirent_lock);
 				configfs_put(sd);
 			}
 		}
@@ -238,7 +252,9 @@ static void remove_dir(struct dentry * d)
 	struct configfs_dirent * sd;
 
 	sd = d->d_fsdata;
+	spin_lock(&configfs_dirent_lock);
 	list_del_init(&sd->s_sibling);
+	spin_unlock(&configfs_dirent_lock);
 	configfs_put(sd);
 	if (d->d_inode)
 		simple_rmdir(parent->d_inode,d);
@@ -410,7 +426,9 @@ static void detach_attrs(struct config_item * item)
 	list_for_each_entry_safe(sd, tmp, &parent_sd->s_children, s_sibling) {
 		if (!sd->s_element || !(sd->s_type & CONFIGFS_NOT_PINNED))
 			continue;
+		spin_lock(&configfs_dirent_lock);
 		list_del_init(&sd->s_sibling);
+		spin_unlock(&configfs_dirent_lock);
 		configfs_drop_dentry(sd, dentry);
 		configfs_put(sd);
 	}
@@ -1268,7 +1286,9 @@ static int configfs_dir_close(struct inode *inode, struct file *file)
 	struct configfs_dirent * cursor = file->private_data;
 
 	mutex_lock(&dentry->d_inode->i_mutex);
+	spin_lock(&configfs_dirent_lock);
 	list_del_init(&cursor->s_sibling);
+	spin_unlock(&configfs_dirent_lock);
 	mutex_unlock(&dentry->d_inode->i_mutex);
 
 	release_configfs_dirent(cursor);
@@ -1308,7 +1328,9 @@ static int configfs_readdir(struct file * filp, void * dirent, filldir_t filldir
 			/* fallthrough */
 		default:
 			if (filp->f_pos == 2) {
+				spin_lock(&configfs_dirent_lock);
 				list_move(q, &parent_sd->s_children);
+				spin_unlock(&configfs_dirent_lock);
 			}
 			for (p=q->next; p!= &parent_sd->s_children; p=p->next) {
 				struct configfs_dirent *next;
@@ -1331,7 +1353,9 @@ static int configfs_readdir(struct file * filp, void * dirent, filldir_t filldir
 						 dt_type(next)) < 0)
 					return 0;
 
+				spin_lock(&configfs_dirent_lock);
 				list_move(q, p);
+				spin_unlock(&configfs_dirent_lock);
 				p = q;
 				filp->f_pos++;
 			}
@@ -1362,6 +1386,7 @@ static loff_t configfs_dir_lseek(struct file * file, loff_t offset, int origin)
 			struct list_head *p;
 			loff_t n = file->f_pos - 2;
 
+			spin_lock(&configfs_dirent_lock);
 			list_del(&cursor->s_sibling);
 			p = sd->s_children.next;
 			while (n && p != &sd->s_children) {
@@ -1373,6 +1398,7 @@ static loff_t configfs_dir_lseek(struct file * file, loff_t offset, int origin)
 				p = p->next;
 			}
 			list_add_tail(&cursor->s_sibling, p);
+			spin_unlock(&configfs_dirent_lock);
 		}
 	}
 	mutex_unlock(&dentry->d_inode->i_mutex);
diff --git a/fs/configfs/inode.c b/fs/configfs/inode.c
index b9a1d81..4803ccc 100644
--- a/fs/configfs/inode.c
+++ b/fs/configfs/inode.c
@@ -247,7 +247,9 @@ void configfs_hash_and_remove(struct dentry * dir, const char * name)
 		if (!sd->s_element)
 			continue;
 		if (!strcmp(configfs_get_name(sd), name)) {
+			spin_lock(&configfs_dirent_lock);
 			list_del_init(&sd->s_sibling);
+			spin_unlock(&configfs_dirent_lock);
 			configfs_drop_dentry(sd, dir);
 			configfs_put(sd);
 			break;
diff --git a/fs/configfs/symlink.c b/fs/configfs/symlink.c
index 2a731ef..676c84c 100644
--- a/fs/configfs/symlink.c
+++ b/fs/configfs/symlink.c
@@ -169,7 +169,9 @@ int configfs_unlink(struct inode *dir, struct dentry *dentry)
 	parent_item = configfs_get_config_item(dentry->d_parent);
 	type = parent_item->ci_type;
 
+	spin_lock(&configfs_dirent_lock);
 	list_del_init(&sd->s_sibling);
+	spin_unlock(&configfs_dirent_lock);
 	configfs_drop_dentry(sd, dentry->d_parent);
 	dput(dentry);
 	configfs_put(sd);
-- 
1.5.4.1
