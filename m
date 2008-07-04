From: Louis Rilling <louis.rilling@kerlabs.com>
Date: Fri,  4 Jul 2008 16:56:05 +0200
Subject: [Ocfs2-devel] [BUGFIX][PATCH v2 1/2] configfs: Prevent userspace
	from creating new entries under attaching directories
In-Reply-To: <1215183366-17479-1-git-send-email-louis.rilling@kerlabs.com>
References: <1215183366-17479-1-git-send-email-louis.rilling@kerlabs.com>
Message-ID: <1215183366-17479-2-git-send-email-louis.rilling@kerlabs.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: joel.becker@hawkmoon.kerlabs.com
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com, Louis Rilling <louis.rilling@kerlabs.com>

process 1: 					process 2:
configfs_mkdir("A")
  attach_group("A")
    attach_item("A")
      d_instantiate("A")
    populate_groups("A")
      mutex_lock("A")
      attach_group("A/B")
        attach_item("A")
          d_instantiate("A/B")
						mkdir("A/B/C")
						  do_path_lookup("A/B/C", LOOKUP_PARENT)
						    ok
						  lookup_create("A/B/C")
						    mutex_lock("A/B")
						    ok
						  configfs_mkdir("A/B/C")
						    ok
      attach_group("A/C")
        attach_item("A/C")
          d_instantiate("A/C")
        populate_groups("A/C")
          mutex_lock("A/C")
          attach_group("A/C/D")
            attach_item("A/C/D")
              failure
          mutex_unlock("A/C")
          detach_groups("A/C")
            nothing to do
						mkdir("A/C/E")
						  do_path_lookup("A/C/E", LOOKUP_PARENT)
						    ok
						  lookup_create("A/C/E")
						    mutex_lock("A/C")
						    ok
						  configfs_mkdir("A/C/E")
						    ok
        detach_item("A/C")
        d_delete("A/C")
      mutex_unlock("A")
      detach_groups("A")
        mutex_lock("A/B")
        detach_group("A/B")
	  detach_groups("A/B")
	    nothing since no _default_ group
          detach_item("A/B")
        mutex_unlock("A/B")
        d_delete("A/B")
    detach_item("A")
    d_delete("A")

Two bugs:

1/ "A/B/C" and "A/C/E" are created, but never removed while their parent are
removed in the end. The same could happen with symlink() instead of mkdir().

2/ "A" and "A/C" inodes are not locked while detach_item() is called on them,
   which may probably confuse VFS.

This commit fixes 1/, tagging new directories with CONFIGFS_USET_CREATING before
building the inode and instantiating the dentry, and validating the whole
group+default groups hierarchy in a second pass by clearing
CONFIGFS_USET_CREATING.
	mkdir(), symlink(), lookup(), and dir_open() simply return -ENOENT if
called in (or linking to) a directory tagged with CONFIGFS_USET_CREATING. This
does not prevent userspace from calling stat() successfuly on such directories,
but this prevents userspace from adding (children to | symlinking from/to |
read/write attributes of | listing the contents of) not validated items. In
other words, userspace will not interact with the subsystem on a new item until
the new item creation completes correctly.
	It was first proposed to re-use CONFIGFS_USET_IN_MKDIR instead of a new
flag CONFIGFS_USET_CREATING, but this generated conflicts when checking the
target of a new symlink: a valid target directory in the middle of attaching
a new user-created child item could be wrongly detected as being attached.

2/ is fixed by next commit.

Changelog:
  - Rename configfs_validate_dir() in configfs_dir_set_ready()
  - Introduce configfs_dirent_is_ready() helper to unbloat a bit
    CONFIGFS_USET_CREATING checks

Signed-off-by: Louis Rilling <louis.rilling@kerlabs.com>
---
 fs/configfs/configfs_internal.h |    2 +
 fs/configfs/dir.c               |   93 ++++++++++++++++++++++++++++++++++++---
 fs/configfs/symlink.c           |   15 ++++++
 3 files changed, 104 insertions(+), 6 deletions(-)

diff --git a/fs/configfs/configfs_internal.h b/fs/configfs/configfs_internal.h
index 5f61b26..762d287 100644
--- a/fs/configfs/configfs_internal.h
+++ b/fs/configfs/configfs_internal.h
@@ -49,6 +49,7 @@ struct configfs_dirent {
 #define CONFIGFS_USET_DEFAULT	0x0080
 #define CONFIGFS_USET_DROPPING	0x0100
 #define CONFIGFS_USET_IN_MKDIR	0x0200
+#define CONFIGFS_USET_CREATING	0x0400
 #define CONFIGFS_NOT_PINNED	(CONFIGFS_ITEM_ATTR)
 
 extern struct mutex configfs_symlink_mutex;
@@ -67,6 +68,7 @@ extern void configfs_inode_exit(void);
 extern int configfs_create_file(struct config_item *, const struct configfs_attribute *);
 extern int configfs_make_dirent(struct configfs_dirent *,
 				struct dentry *, void *, umode_t, int);
+extern int configfs_dirent_is_ready(struct configfs_dirent *);
 
 extern int configfs_add_file(struct dentry *, const struct configfs_attribute *, int);
 extern void configfs_hash_and_remove(struct dentry * dir, const char * name);
diff --git a/fs/configfs/dir.c b/fs/configfs/dir.c
index 2c873fd..8dd99a2 100644
--- a/fs/configfs/dir.c
+++ b/fs/configfs/dir.c
@@ -185,7 +185,7 @@ static int create_dir(struct config_item * k, struct dentry * p,
 	error = configfs_dirent_exists(p->d_fsdata, d->d_name.name);
 	if (!error)
 		error = configfs_make_dirent(p->d_fsdata, d, k, mode,
-					     CONFIGFS_DIR);
+					     CONFIGFS_DIR | CONFIGFS_USET_CREATING);
 	if (!error) {
 		error = configfs_create(d, mode, init_dir);
 		if (!error) {
@@ -209,6 +209,9 @@ static int create_dir(struct config_item * k, struct dentry * p,
  *	configfs_create_dir - create a directory for an config_item.
  *	@item:		config_itemwe're creating directory for.
  *	@dentry:	config_item's dentry.
+ *
+ *	Note: user-created entries won't be allowed under this new directory
+ *	until it is validated by configfs_dir_set_ready()
  */
 
 static int configfs_create_dir(struct config_item * item, struct dentry *dentry)
@@ -231,6 +234,44 @@ static int configfs_create_dir(struct config_item * item, struct dentry *dentry)
 	return error;
 }
 
+/*
+ * Allow userspace to create new entries under a new directory created with
+ * configfs_create_dir(), and under all of its chidlren directories recursively.
+ * @sd		configfs_dirent of the new directory to validate
+ *
+ * Caller must hold configfs_dirent_lock.
+ */
+static void configfs_dir_set_ready(struct configfs_dirent *sd)
+{
+	struct configfs_dirent *child_sd;
+
+	sd->s_type &= ~CONFIGFS_USET_CREATING;
+	list_for_each_entry(child_sd, &sd->s_children, s_sibling)
+		if (child_sd->s_type & CONFIGFS_USET_CREATING)
+			configfs_dir_set_ready(child_sd);
+}
+
+/*
+ * Check that a directory does not belong to a directory hierarchy being
+ * attached and not validated yet.
+ * @sd		configfs_dirent of the directory to check
+ *
+ * @return	non-zero iff the directory was validated
+ *
+ * Note: takes configfs_dirent_lock, so the result may change from false to true
+ * in two consecutive calls, but never from true to false.
+ */
+int configfs_dirent_is_ready(struct configfs_dirent *sd)
+{
+	int ret;
+
+	spin_lock(&configfs_dirent_lock);
+	ret = !(sd->s_type & CONFIGFS_USET_CREATING);
+	spin_unlock(&configfs_dirent_lock);
+
+	return ret;
+}
+
 int configfs_create_link(struct configfs_symlink *sl,
 			 struct dentry *parent,
 			 struct dentry *dentry)
@@ -330,7 +371,19 @@ static struct dentry * configfs_lookup(struct inode *dir,
 	struct configfs_dirent * parent_sd = dentry->d_parent->d_fsdata;
 	struct configfs_dirent * sd;
 	int found = 0;
-	int err = 0;
+	int err;
+
+	/*
+	 * Fake invisibility if dir belongs to a group/default groups hierarchy
+	 * being attached
+	 *
+	 * This forbids userspace to read/write attributes of items which may
+	 * not complete their initialization, since the dentries of the
+	 * attributes won't be instantiated.
+	 */
+	err = -ENOENT;
+	if (!configfs_dirent_is_ready(parent_sd))
+		goto out;
 
 	list_for_each_entry(sd, &parent_sd->s_children, s_sibling) {
 		if (sd->s_type & CONFIGFS_NOT_PINNED) {
@@ -353,6 +406,7 @@ static struct dentry * configfs_lookup(struct inode *dir,
 		return simple_lookup(dir, dentry, nd);
 	}
 
+out:
 	return ERR_PTR(err);
 }
 
@@ -1027,7 +1081,7 @@ EXPORT_SYMBOL(configfs_undepend_item);
 
 static int configfs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 {
-	int ret, module_got = 0;
+	int ret = 0, module_got = 0;
 	struct config_group *group;
 	struct config_item *item;
 	struct config_item *parent_item;
@@ -1043,6 +1097,16 @@ static int configfs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 	}
 
 	sd = dentry->d_parent->d_fsdata;
+
+	/*
+	 * Fake invisibility if dir belongs to a group/default groups hierarchy
+	 * being attached
+	 */
+	if (!configfs_dirent_is_ready(sd)) {
+		ret = -ENOENT;
+		goto out;
+	}
+
 	if (!(sd->s_type & CONFIGFS_USET_DIR)) {
 		ret = -EPERM;
 		goto out;
@@ -1137,6 +1201,8 @@ static int configfs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 
 	spin_lock(&configfs_dirent_lock);
 	sd->s_type &= ~CONFIGFS_USET_IN_MKDIR;
+	if (!ret)
+		configfs_dir_set_ready(dentry->d_fsdata);
 	spin_unlock(&configfs_dirent_lock);
 
 out_unlink:
@@ -1317,13 +1383,24 @@ static int configfs_dir_open(struct inode *inode, struct file *file)
 {
 	struct dentry * dentry = file->f_path.dentry;
 	struct configfs_dirent * parent_sd = dentry->d_fsdata;
+	int err;
 
 	mutex_lock(&dentry->d_inode->i_mutex);
-	file->private_data = configfs_new_dirent(parent_sd, NULL);
+	/*
+	 * Fake invisibility if dir belongs to a group/default groups hierarchy
+	 * being attached
+	 */
+	err = -ENOENT;
+	if (configfs_dirent_is_ready(parent_sd)) {
+		file->private_data = configfs_new_dirent(parent_sd, NULL);
+		if (IS_ERR(file->private_data))
+			err = PTR_ERR(file->private_data);
+		else
+			err = 0;
+	}
 	mutex_unlock(&dentry->d_inode->i_mutex);
 
-	return IS_ERR(file->private_data) ? PTR_ERR(file->private_data) : 0;
-
+	return err;
 }
 
 static int configfs_dir_close(struct inode *inode, struct file *file)
@@ -1494,6 +1571,10 @@ int configfs_register_subsystem(struct configfs_subsystem *subsys)
 		if (err) {
 			d_delete(dentry);
 			dput(dentry);
+		} else {
+			spin_lock(&configfs_dirent_lock);
+			configfs_dir_set_ready(dentry->d_fsdata);
+			spin_unlock(&configfs_dirent_lock);
 		}
 	}
 
diff --git a/fs/configfs/symlink.c b/fs/configfs/symlink.c
index 21bd751..e29a77e 100644
--- a/fs/configfs/symlink.c
+++ b/fs/configfs/symlink.c
@@ -76,6 +76,9 @@ static int create_link(struct config_item *parent_item,
 	struct configfs_symlink *sl;
 	int ret;
 
+	ret = -ENOENT;
+	if (!configfs_dirent_is_ready(target_sd))
+		goto out;
 	ret = -ENOMEM;
 	sl = kmalloc(sizeof(struct configfs_symlink), GFP_KERNEL);
 	if (sl) {
@@ -100,6 +103,7 @@ static int create_link(struct config_item *parent_item,
 		}
 	}
 
+out:
 	return ret;
 }
 
@@ -129,6 +133,7 @@ int configfs_symlink(struct inode *dir, struct dentry *dentry, const char *symna
 {
 	int ret;
 	struct nameidata nd;
+	struct configfs_dirent *sd;
 	struct config_item *parent_item;
 	struct config_item *target_item;
 	struct config_item_type *type;
@@ -137,9 +142,19 @@ int configfs_symlink(struct inode *dir, struct dentry *dentry, const char *symna
 	if (dentry->d_parent == configfs_sb->s_root)
 		goto out;
 
+	sd = dentry->d_parent->d_fsdata;
+	/*
+	 * Fake invisibility if dir belongs to a group/default groups hierarchy
+	 * being attached
+	 */
+	ret = -ENOENT;
+	if (!configfs_dirent_is_ready(sd))
+		goto out;
+
 	parent_item = configfs_get_config_item(dentry->d_parent);
 	type = parent_item->ci_type;
 
+	ret = -EPERM;
 	if (!type || !type->ct_item_ops ||
 	    !type->ct_item_ops->allow_link)
 		goto out_put;
-- 
1.5.5.3
