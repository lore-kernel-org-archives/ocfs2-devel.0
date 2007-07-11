From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Wed Jul 11 09:22:37 2007
Subject: [Ocfs2-devel] [git patches] ocfs2 and configfs updates
Message-ID: <20070711162233.GN15463@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com, David Teigland <teigland@redhat.com>, Joel Becker <joel.becker@oracle.com>

This represents the majority of our 2.6.23-rc1 patches.

I'll start with ocfs2, which gets the following new features:

* Full support for shared writeable mmap. This was implemented using the
  ->page_mkwrite callback to allow ocfs2 a chance to take cluster locks on
  the inode data and allocate file space for writes. This also has the
  effect that ocfs2 should never run out of space during ->writepage.

* Some internal improvements to how deallocation of meta-data is handled. 
  This simplified deallocation locking so that we could turn on allocation
  of meta data from per-node pools.

* Unwritten extents support. ocfs2 can now pre-allocate inode space without
  zeroing data by leaving a special "unwritten" flag in the extent record. 
  Reads from regions marked as unwritten return zeros and writes to the
  regions are guaranteed to never require data allocation. The sparse file
  support in Ocfs2 (from 2.6.22) included read support for unwritten
  extents, so the file system option is an RO compat bit. It won't ever be
  turned on by ocfs2-tools without first having the sparse files incompat
  bit set.

* Support for removing arbitrary file regions. Conceptually this is the
  opposite of unwritten extents support. The ocfs2 btree code is now smart
  enough to remove any extent or partial extent, regardless of where it is
  in the tree. Previously it was only possible to remove extents from the
  rightmost edge during a truncate.

The reservation and extent truncate support is exposed to user space via a
set of ioctls compatible with those currently used by XFS. This allows us to
take advantage of the existing install base of software which uses that
feature. Some weeks ago, I also posted an -mm patch to get ocfs2 under the
->fallocate() callback. Once the sys_fallocate() patches are merged, I
intend to send a version of the ocfs2 patch upstream.


On the Configfs side, these patches include a series of cleanups and some
API adjustments.

* Drivers now have the ability to specify a dependancy on config items. This
  allows clients to pin certain objects when removal would have bad
  consequences. ocfs2 uses this functionality to codify a mountpoints
  dependancy on a live heartbeat.

* A new notification callback, ops->disconnect_notify() is added which is
  called just before item linkage is broken during removal. This allows
  configfs users to do work on the item while it is still in the hierarchy.

Three of the configfs patches which modify the api touch code in fs/dlm (in
fairly trivial ways) so David has been CC'd. Those patches are also attached
to the end of this mail. I had to fix some conflicts with an fs/dlm/config.c
change when getting two of those ready for merge so the commit messages have
been marked as such.


Please pull from 'upstream-linus' branch of
git://git.kernel.org/pub/scm/linux/kernel/git/mfasheh/ocfs2.git upstream-linus

to receive the following updates:

 Documentation/filesystems/configfs/configfs.txt       |   57 
 Documentation/filesystems/configfs/configfs_example.c |    2 
 fs/configfs/configfs_internal.h                       |    7 
 fs/configfs/dir.c                                     |  289 +
 fs/configfs/file.c                                    |   28 
 fs/configfs/item.c                                    |   29 
 fs/dlm/config.c                                       |   20 
 fs/ocfs2/alloc.c                                      | 2676 ++++++++++++++++--
 fs/ocfs2/alloc.h                                      |   43 
 fs/ocfs2/aops.c                                       | 1015 ++++--
 fs/ocfs2/aops.h                                       |   61 
 fs/ocfs2/cluster/heartbeat.c                          |   96 
 fs/ocfs2/cluster/heartbeat.h                          |    6 
 fs/ocfs2/cluster/nodemanager.c                        |   42 
 fs/ocfs2/cluster/nodemanager.h                        |    5 
 fs/ocfs2/cluster/tcp.c                                |   21 
 fs/ocfs2/dir.c                                        |    2 
 fs/ocfs2/dlm/dlmdomain.c                              |    8 
 fs/ocfs2/dlm/dlmmaster.c                              |   40 
 fs/ocfs2/dlm/dlmrecovery.c                            |   79 
 fs/ocfs2/dlmglue.c                                    |    6 
 fs/ocfs2/endian.h                                     |    5 
 fs/ocfs2/extent_map.c                                 |   41 
 fs/ocfs2/file.c                                       |  702 ++++
 fs/ocfs2/file.h                                       |   10 
 fs/ocfs2/heartbeat.c                                  |   10 
 fs/ocfs2/ioctl.c                                      |   15 
 fs/ocfs2/journal.c                                    |    6 
 fs/ocfs2/journal.h                                    |    2 
 fs/ocfs2/mmap.c                                       |  167 -
 fs/ocfs2/namei.c                                      |    2 
 fs/ocfs2/ocfs2.h                                      |   14 
 fs/ocfs2/ocfs2_fs.h                                   |   33 
 fs/ocfs2/slot_map.c                                   |   12 
 fs/ocfs2/suballoc.c                                   |   46 
 fs/ocfs2/suballoc.h                                   |   17 
 fs/ocfs2/super.c                                      |   27 
 fs/ocfs2/super.h                                      |    2 
 include/linux/configfs.h                              |   34 
 39 files changed, 4623 insertions(+), 1054 deletions(-)

Christoph Hellwig:
      ocfs2: use list_for_each_entry where benefical

Eric Sandeen:
      ocfs2: zero_user_page conversion

Joel Becker:
      configfs: consistent attribute size
      configfs: Convert subsystem semaphore to mutex
      configfs: accessing item hierarchy during rmdir(2)
      configfs: config item dependancies.
      ocfs2: Depend on configfs heartbeat items.
      ocfs2: live heartbeat depends on the local node configuration
      ocfs2: Wake up a starting region if it gets killed in the background.

Johannes Berg:
      configsfs buffer: use mutex

Mark Fasheh:
      ocfs2: take ip_alloc_sem during entire truncate
      ocfs2: rework ocfs2_buffered_write_cluster()
      ocfs2: factor out write aops into nolock variants
      ocfs2: shared writeable mmap
      ocfs2: harden buffer check during mapping of page blocks
      ocfs2: simplify deallocation locking
      ocfs2: plug truncate into cached dealloc routines
      ocfs2: use all extent block suballocators
      ocfs2: abstract btree growing calls
      ocfs2: btree changes for unwritten extents
      ocfs2: small cleanup of ocfs2_write_begin_nolock()
      ocfs2: support writing of unwritten extents
      ocfs2: Support creation of unwritten extents
      ocfs2: btree support for removal of arbirtrary extents
      ocfs2: update truncate handling of partial clusters
      ocfs2: support for removing file regions
      ocfs2: Support xfs style space reservation ioctls

Satyam Sharma:
      configfs: misc cleanups
      configfs+dlm: Separate out __CONFIGFS_ATTR into configfs.h
      configfs+dlm: Rename config_group_find_obj and state semantics clearly

Shani Moideen:
      [KJ PATCH] Replacing memset(<addr>,0,PAGE_SIZE) with clear_page() in fs/ocfs2/dlm/dlmrecovery.c

Sunil Mushran:
      ocfs2: Add "preferred slot" mount option


--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh@oracle.com



From: Satyam Sharma <ssatyam@cse.iitk.ac.in>

[PATCH] configfs+dlm: Separate out __CONFIGFS_ATTR into configfs.h

fs/dlm/config.c contains a useful generic macro called __CONFIGFS_ATTR
that is similar to sysfs' __ATTR macro that makes defining attributes
easy for any user of configfs. Separate it out into configfs.h so that
other users (forthcoming in dynamic netconsole patchset) can use it too.

Signed-off-by: Satyam Sharma <ssatyam@cse.iitk.ac.in>
Cc: David Teigland <teigland@redhat.com>
Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
---
 fs/dlm/config.c          |    8 --------
 include/linux/configfs.h |   16 ++++++++++++++++
 2 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/fs/dlm/config.c b/fs/dlm/config.c
index 5069b2c..e47eb42 100644
--- a/fs/dlm/config.c
+++ b/fs/dlm/config.c
@@ -133,14 +133,6 @@ static ssize_t cluster_set(struct cluster *cl, unsigned int *cl_field,
 	return len;
 }
 
-#define __CONFIGFS_ATTR(_name,_mode,_read,_write) {                           \
-	.attr   = { .ca_name = __stringify(_name),                            \
-		    .ca_mode = _mode,                                         \
-		    .ca_owner = THIS_MODULE },                                \
-	.show   = _read,                                                      \
-	.store  = _write,                                                     \
-}
-
 #define CLUSTER_ATTR(name, check_zero)                                        \
 static ssize_t name##_write(struct cluster *cl, const char *buf, size_t len)  \
 {                                                                             \
diff --git a/include/linux/configfs.h b/include/linux/configfs.h
index 3d4a96e..def7c83 100644
--- a/include/linux/configfs.h
+++ b/include/linux/configfs.h
@@ -130,6 +130,22 @@ struct configfs_attribute {
 	mode_t			ca_mode;
 };
 
+/*
+ * Users often need to create attribute structures for their configurable
+ * attributes, containing a configfs_attribute member and function pointers
+ * for the show() and store() operations on that attribute. They can use
+ * this macro (similar to sysfs' __ATTR) to make defining attributes easier.
+ */
+#define __CONFIGFS_ATTR(_name, _mode, _show, _store)			\
+{									\
+	.attr	= {							\
+			.ca_name = __stringify(_name),			\
+			.ca_mode = _mode,				\
+			.ca_owner = THIS_MODULE,			\
+	},								\
+	.show	= _show,						\
+	.store	= _store,						\
+}
 
 /*
  * If allow_link() exists, the item can symlink(2) out to other
-- 
1.5.2.1




From: Satyam Sharma <ssatyam@cse.iitk.ac.in>

[PATCH] configfs+dlm: Rename config_group_find_obj and state semantics clearly

Configfs being based upon sysfs code, config_group_find_obj() is probably
so named because of the similar kset_find_obj() in sysfs. However,
"kobject"s in sysfs become "config_item"s in configfs, so let's call it
config_group_find_item() instead, for sake of uniformity, and make
corresponding change in the users of this function.

BTW a crucial difference between kset_find_obj and config_group_find_item
is in locking expectations. kset_find_obj does its locking by itself, but
config_group_find_item expects the *caller* to do the locking. The reason
for this: kset's have their own locks, config_group's don't but instead
rely on the subsystem mutex. And, subsystem needn't necessarily be around
when config_group_find_item() is called.

So let's state these locking semantics explicitly, and rectify the comment,
otherwise bugs could continue to occur in future, as they did in the past
(refer commit d82b8191e238 in gfs2-2.6-fixes.git).

[ I also took the opportunity to fix some bad whitespace and
double-empty lines. --Joel ]

[ Conflict in fs/dlm/config.c with commit
  3168b0780d06ace875696f8a648d04d6089654e5 manually resolved. --Mark ]

Signed-off-by: Satyam Sharma <ssatyam@cse.iitk.ac.in>
Cc: David Teigland <teigland@redhat.com>
Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
---
 fs/configfs/item.c       |   18 ++++++++----------
 fs/dlm/config.c          |    2 +-
 include/linux/configfs.h |    7 ++-----
 3 files changed, 11 insertions(+), 16 deletions(-)

diff --git a/fs/configfs/item.c b/fs/configfs/item.c
index b762bbe..76dc4c3 100644
--- a/fs/configfs/item.c
+++ b/fs/configfs/item.c
@@ -183,27 +183,25 @@ void config_group_init(struct config_group *group)
 	INIT_LIST_HEAD(&group->cg_children);
 }
 
-
 /**
- *	config_group_find_obj - search for item in group.
+ *	config_group_find_item - search for item in group.
  *	@group:	group we're looking in.
  *	@name:	item's name.
  *
- *	Lock group via @group->cg_subsys, and iterate over @group->cg_list,
- *	looking for a matching config_item. If matching item is found
- *	take a reference and return the item.
+ *	Iterate over @group->cg_list, looking for a matching config_item.
+ *	If matching item is found take a reference and return the item.
+ *	Caller must have locked group via @group->cg_subsys->su_mtx.
  */
-struct config_item *config_group_find_obj(struct config_group *group,
-					  const char * name)
+struct config_item *config_group_find_item(struct config_group *group,
+					   const char *name)
 {
 	struct list_head * entry;
 	struct config_item * ret = NULL;
 
-        /* XXX LOCKING! */
 	list_for_each(entry,&group->cg_children) {
 		struct config_item * item = to_item(entry);
 		if (config_item_name(item) &&
-                    !strcmp(config_item_name(item), name)) {
+		    !strcmp(config_item_name(item), name)) {
 			ret = config_item_get(item);
 			break;
 		}
@@ -215,4 +213,4 @@ EXPORT_SYMBOL(config_item_init);
 EXPORT_SYMBOL(config_group_init);
 EXPORT_SYMBOL(config_item_get);
 EXPORT_SYMBOL(config_item_put);
-EXPORT_SYMBOL(config_group_find_obj);
+EXPORT_SYMBOL(config_group_find_item);
diff --git a/fs/dlm/config.c b/fs/dlm/config.c
index e47eb42..4348cb4 100644
--- a/fs/dlm/config.c
+++ b/fs/dlm/config.c
@@ -752,7 +752,7 @@ static struct space *get_space(char *name)
 		return NULL;
 
 	down(&space_list->cg_subsys->su_sem);
-	i = config_group_find_obj(space_list, name);
+	i = config_group_find_item(space_list, name);
 	up(&space_list->cg_subsys->su_sem);
 
 	return to_space(i);
diff --git a/include/linux/configfs.h b/include/linux/configfs.h
index def7c83..bbb1b6c 100644
--- a/include/linux/configfs.h
+++ b/include/linux/configfs.h
@@ -86,12 +86,10 @@ struct config_item_type {
 	struct configfs_attribute		**ct_attrs;
 };
 
-
 /**
  *	group - a group of config_items of a specific type, belonging
  *	to a specific subsystem.
  */
-
 struct config_group {
 	struct config_item		cg_item;
 	struct list_head		cg_children;
@@ -99,13 +97,11 @@ struct config_group {
 	struct config_group		**default_groups;
 };
 
-
 extern void config_group_init(struct config_group *group);
 extern void config_group_init_type_name(struct config_group *group,
 					const char *name,
 					struct config_item_type *type);
 
-
 static inline struct config_group *to_config_group(struct config_item *item)
 {
 	return item ? container_of(item,struct config_group,cg_item) : NULL;
@@ -121,7 +117,8 @@ static inline void config_group_put(struct config_group *group)
 	config_item_put(&group->cg_item);
 }
 
-extern struct config_item *config_group_find_obj(struct config_group *, const char *);
+extern struct config_item *config_group_find_item(struct config_group *,
+						  const char *);
 
 
 struct configfs_attribute {
-- 
1.5.2.1




From e6bd07aee739566803425acdbf5cdb29919164e1 Mon Sep 17 00:00:00 2001
From: Joel Becker <joel.becker@oracle.com>
Date: Fri, 6 Jul 2007 23:33:17 -0700
Subject: configfs: Convert subsystem semaphore to mutex

Convert the su_sem member of struct configfs_subsystem to a struct
mutex, as that's what it is. Also convert all the users and update
Documentation/configfs.txt and Documentation/configfs_example.c
accordingly.

[ Conflict in fs/dlm/config.c with commit
  3168b0780d06ace875696f8a648d04d6089654e5 manually resolved. --Mark ]

Inspired-by: Satyam Sharma <ssatyam@cse.iitk.ac.in>
Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
---
 Documentation/filesystems/configfs/configfs.txt    |   18 +++++++++---------
 .../filesystems/configfs/configfs_example.c        |    2 +-
 fs/configfs/dir.c                                  |   16 ++++++++--------
 fs/dlm/config.c                                    |   10 +++++-----
 fs/ocfs2/cluster/nodemanager.c                     |    2 +-
 include/linux/configfs.h                           |    4 ++--
 6 files changed, 26 insertions(+), 26 deletions(-)

diff --git a/Documentation/filesystems/configfs/configfs.txt b/Documentation/filesystems/configfs/configfs.txt
index b34cdb5..21f038e 100644
--- a/Documentation/filesystems/configfs/configfs.txt
+++ b/Documentation/filesystems/configfs/configfs.txt
@@ -280,18 +280,18 @@ tells configfs to make the subsystem appear in the file tree.
 
 	struct configfs_subsystem {
 		struct config_group	su_group;
-		struct semaphore	su_sem;
+		struct mutex		su_mutex;
 	};
 
 	int configfs_register_subsystem(struct configfs_subsystem *subsys);
 	void configfs_unregister_subsystem(struct configfs_subsystem *subsys);
 
-	A subsystem consists of a toplevel config_group and a semaphore.
+	A subsystem consists of a toplevel config_group and a mutex.
 The group is where child config_items are created.  For a subsystem,
 this group is usually defined statically.  Before calling
 configfs_register_subsystem(), the subsystem must have initialized the
 group via the usual group _init() functions, and it must also have
-initialized the semaphore.
+initialized the mutex.
 	When the register call returns, the subsystem is live, and it
 will be visible via configfs.  At that point, mkdir(2) can be called and
 the subsystem must be ready for it.
@@ -303,7 +303,7 @@ subsystem/group and the simple_child item in configfs_example.c  It
 shows a trivial object displaying and storing an attribute, and a simple
 group creating and destroying these children.
 
-[Hierarchy Navigation and the Subsystem Semaphore]
+[Hierarchy Navigation and the Subsystem Mutex]
 
 There is an extra bonus that configfs provides.  The config_groups and
 config_items are arranged in a hierarchy due to the fact that they
@@ -314,19 +314,19 @@ and config_item->ci_parent structure members.
 
 A subsystem can navigate the cg_children list and the ci_parent pointer
 to see the tree created by the subsystem.  This can race with configfs'
-management of the hierarchy, so configfs uses the subsystem semaphore to
+management of the hierarchy, so configfs uses the subsystem mutex to
 protect modifications.  Whenever a subsystem wants to navigate the
 hierarchy, it must do so under the protection of the subsystem
-semaphore.
+mutex.
 
-A subsystem will be prevented from acquiring the semaphore while a newly
+A subsystem will be prevented from acquiring the mutex while a newly
 allocated item has not been linked into this hierarchy.   Similarly, it
-will not be able to acquire the semaphore while a dropping item has not
+will not be able to acquire the mutex while a dropping item has not
 yet been unlinked.  This means that an item's ci_parent pointer will
 never be NULL while the item is in configfs, and that an item will only
 be in its parent's cg_children list for the same duration.  This allows
 a subsystem to trust ci_parent and cg_children while they hold the
-semaphore.
+mutex.
 
 [Item Aggregation Via symlink(2)]
 
diff --git a/Documentation/filesystems/configfs/configfs_example.c b/Documentation/filesystems/configfs/configfs_example.c
index 2d6a14a..e56d492 100644
--- a/Documentation/filesystems/configfs/configfs_example.c
+++ b/Documentation/filesystems/configfs/configfs_example.c
@@ -453,7 +453,7 @@ static int __init configfs_example_init(void)
 		subsys = example_subsys[i];
 
 		config_group_init(&subsys->su_group);
-		init_MUTEX(&subsys->su_sem);
+		mutex_init(&subsys->su_mutex);
 		ret = configfs_register_subsystem(subsys);
 		if (ret) {
 			printk(KERN_ERR "Error %d while registering subsystem %s\n",
diff --git a/fs/configfs/dir.c b/fs/configfs/dir.c
index 5e6e37e..d3b1dbb 100644
--- a/fs/configfs/dir.c
+++ b/fs/configfs/dir.c
@@ -562,7 +562,7 @@ static int populate_groups(struct config_group *group)
 
 /*
  * All of link_obj/unlink_obj/link_group/unlink_group require that
- * subsys->su_sem is held.
+ * subsys->su_mutex is held.
  */
 
 static void unlink_obj(struct config_item *item)
@@ -783,7 +783,7 @@ static int configfs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 
 	snprintf(name, dentry->d_name.len + 1, "%s", dentry->d_name.name);
 
-	down(&subsys->su_sem);
+	mutex_lock(&subsys->su_mutex);
 	group = NULL;
 	item = NULL;
 	if (type->ct_group_ops->make_group) {
@@ -797,7 +797,7 @@ static int configfs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 		if (item)
 			link_obj(parent_item, item);
 	}
-	up(&subsys->su_sem);
+	mutex_unlock(&subsys->su_mutex);
 
 	kfree(name);
 	if (!item) {
@@ -841,13 +841,13 @@ static int configfs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 out_unlink:
 	if (ret) {
 		/* Tear down everything we built up */
-		down(&subsys->su_sem);
+		mutex_lock(&subsys->su_mutex);
 		if (group)
 			unlink_group(group);
 		else
 			unlink_obj(item);
 		client_drop_item(parent_item, item);
-		up(&subsys->su_sem);
+		mutex_unlock(&subsys->su_mutex);
 
 		if (module_got)
 			module_put(owner);
@@ -910,17 +910,17 @@ static int configfs_rmdir(struct inode *dir, struct dentry *dentry)
 	if (sd->s_type & CONFIGFS_USET_DIR) {
 		configfs_detach_group(item);
 
-		down(&subsys->su_sem);
+		mutex_lock(&subsys->su_mutex);
 		unlink_group(to_config_group(item));
 	} else {
 		configfs_detach_item(item);
 
-		down(&subsys->su_sem);
+		mutex_lock(&subsys->su_mutex);
 		unlink_obj(item);
 	}
 
 	client_drop_item(parent_item, item);
-	up(&subsys->su_sem);
+	mutex_unlock(&subsys->su_mutex);
 
 	/* Drop our reference from above */
 	config_item_put(item);
diff --git a/fs/dlm/config.c b/fs/dlm/config.c
index 4348cb4..2f8e3c8 100644
--- a/fs/dlm/config.c
+++ b/fs/dlm/config.c
@@ -607,7 +607,7 @@ static struct clusters clusters_root = {
 int dlm_config_init(void)
 {
 	config_group_init(&clusters_root.subsys.su_group);
-	init_MUTEX(&clusters_root.subsys.su_sem);
+	mutex_init(&clusters_root.subsys.su_mutex);
 	return configfs_register_subsystem(&clusters_root.subsys);
 }
 
@@ -751,9 +751,9 @@ static struct space *get_space(char *name)
 	if (!space_list)
 		return NULL;
 
-	down(&space_list->cg_subsys->su_sem);
+	mutex_lock(&space_list->cg_subsys->su_mutex);
 	i = config_group_find_item(space_list, name);
-	up(&space_list->cg_subsys->su_sem);
+	mutex_unlock(&space_list->cg_subsys->su_mutex);
 
 	return to_space(i);
 }
@@ -772,7 +772,7 @@ static struct comm *get_comm(int nodeid, struct sockaddr_storage *addr)
 	if (!comm_list)
 		return NULL;
 
-	down(&clusters_root.subsys.su_sem);
+	mutex_lock(&clusters_root.subsys.su_mutex);
 
 	list_for_each_entry(i, &comm_list->cg_children, ci_entry) {
 		cm = to_comm(i);
@@ -792,7 +792,7 @@ static struct comm *get_comm(int nodeid, struct sockaddr_storage *addr)
 			break;
 		}
 	}
-	up(&clusters_root.subsys.su_sem);
+	mutex_unlock(&clusters_root.subsys.su_mutex);
 
 	if (!found)
 		cm = NULL;
diff --git a/fs/ocfs2/cluster/nodemanager.c b/fs/ocfs2/cluster/nodemanager.c
index 9f5ad0f..48b77d1 100644
--- a/fs/ocfs2/cluster/nodemanager.c
+++ b/fs/ocfs2/cluster/nodemanager.c
@@ -934,7 +934,7 @@ static int __init init_o2nm(void)
 		goto out_sysctl;
 
 	config_group_init(&o2nm_cluster_group.cs_subsys.su_group);
-	init_MUTEX(&o2nm_cluster_group.cs_subsys.su_sem);
+	mutex_init(&o2nm_cluster_group.cs_subsys.su_mutex);
 	ret = configfs_register_subsystem(&o2nm_cluster_group.cs_subsys);
 	if (ret) {
 		printk(KERN_ERR "nodemanager: Registration returned %d\n", ret);
diff --git a/include/linux/configfs.h b/include/linux/configfs.h
index bbb1b6c..5ce0fc4 100644
--- a/include/linux/configfs.h
+++ b/include/linux/configfs.h
@@ -40,9 +40,9 @@
 #include <linux/types.h>
 #include <linux/list.h>
 #include <linux/kref.h>
+#include <linux/mutex.h>
 
 #include <asm/atomic.h>
-#include <asm/semaphore.h>
 
 #define CONFIGFS_ITEM_NAME_LEN	20
 
@@ -174,7 +174,7 @@ struct configfs_group_operations {
 
 struct configfs_subsystem {
 	struct config_group	su_group;
-	struct semaphore	su_sem;
+	struct mutex		su_mutex;
 };
 
 static inline struct configfs_subsystem *to_configfs_subsystem(struct config_group *group)
-- 
1.5.2.1
