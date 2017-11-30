From: akpm at linux-foundation.org <akpm@linux-foundation.org>
Date: Thu, 30 Nov 2017 14:24:22 -0800
Subject: [Ocfs2-devel] [patch 05/11] ocfs2: add kobject for online file check
Message-ID: <5a208516.CHnPEcDj1TvxwCu4%akpm@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Gang He <ghe@suse.com>
Subject: ocfs2: add kobject for online file check

Use embedded kobject mechanism for online file check feature, this will
avoid to use a global list to save/search per-device online file check
related data, meanwhile, reduce the code lines and make the code logic
clear.  The changed code is based on Goldwyn Rodrigues's patches and ext4
fs code.

Link: https://urldefense.proofpoint.com/v2/url?u=http-3A__lkml.kernel.org_r_1495611866-2D27360-2D4-2Dgit-2Dsend-2Demail-2Dghe-40suse.com&d=DwICAg&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=C7gAd4uDxlAvTdc0vmU6X8CMk6L2iDY8-HD0qT6Fo7Y&m=AVHkCv72yZmji6Wsolhn226lBxAYCiyOC-0ntPnG5u8&s=VMgdcyFFGaNF_l1RdCOtCOBX1fS5hJvOBmBzALQXz4c&e=
Signed-off-by: Gang He <ghe@suse.com>
Cc: Mark Fasheh <mfasheh@versity.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/filecheck.c |  301 +++++++++++++++--------------------------
 fs/ocfs2/filecheck.h |   20 +-
 fs/ocfs2/ocfs2.h     |    8 +
 fs/ocfs2/super.c     |   27 +++
 4 files changed, 155 insertions(+), 201 deletions(-)

diff -puN fs/ocfs2/filecheck.c~ocfs2-add-kobject-for-online-file-check fs/ocfs2/filecheck.c
--- a/fs/ocfs2/filecheck.c~ocfs2-add-kobject-for-online-file-check
+++ a/fs/ocfs2/filecheck.c
@@ -53,9 +53,6 @@ static const char * const ocfs2_filechec
 	"UNSUPPORTED"
 };
 
-static DEFINE_SPINLOCK(ocfs2_filecheck_sysfs_lock);
-static LIST_HEAD(ocfs2_filecheck_sysfs_list);
-
 struct ocfs2_filecheck_entry {
 	struct list_head fe_list;
 	unsigned long fe_ino;
@@ -83,34 +80,84 @@ ocfs2_filecheck_error(int errno)
 	return ocfs2_filecheck_errs[errno - OCFS2_FILECHECK_ERR_START + 1];
 }
 
-static ssize_t ocfs2_filecheck_show(struct kobject *kobj,
-				    struct kobj_attribute *attr,
-				    char *buf);
-static ssize_t ocfs2_filecheck_store(struct kobject *kobj,
-				     struct kobj_attribute *attr,
-				     const char *buf, size_t count);
-static struct kobj_attribute ocfs2_attr_filecheck_chk =
+static ssize_t ocfs2_filecheck_attr_show(struct kobject *kobj,
+					struct kobj_attribute *attr,
+					char *buf);
+static ssize_t ocfs2_filecheck_attr_store(struct kobject *kobj,
+					struct kobj_attribute *attr,
+					const char *buf, size_t count);
+static struct kobj_attribute ocfs2_filecheck_attr_chk =
 					__ATTR(check, S_IRUSR | S_IWUSR,
-					ocfs2_filecheck_show,
-					ocfs2_filecheck_store);
-static struct kobj_attribute ocfs2_attr_filecheck_fix =
+					ocfs2_filecheck_attr_show,
+					ocfs2_filecheck_attr_store);
+static struct kobj_attribute ocfs2_filecheck_attr_fix =
 					__ATTR(fix, S_IRUSR | S_IWUSR,
-					ocfs2_filecheck_show,
-					ocfs2_filecheck_store);
-static struct kobj_attribute ocfs2_attr_filecheck_set =
+					ocfs2_filecheck_attr_show,
+					ocfs2_filecheck_attr_store);
+static struct kobj_attribute ocfs2_filecheck_attr_set =
 					__ATTR(set, S_IRUSR | S_IWUSR,
-					ocfs2_filecheck_show,
-					ocfs2_filecheck_store);
+					ocfs2_filecheck_attr_show,
+					ocfs2_filecheck_attr_store);
+static struct attribute *ocfs2_filecheck_attrs[] = {
+	&ocfs2_filecheck_attr_chk.attr,
+	&ocfs2_filecheck_attr_fix.attr,
+	&ocfs2_filecheck_attr_set.attr,
+	NULL
+};
+
+static void ocfs2_filecheck_release(struct kobject *kobj)
+{
+	struct ocfs2_filecheck_sysfs_entry *entry = container_of(kobj,
+				struct ocfs2_filecheck_sysfs_entry, fs_kobj);
+
+	complete(&entry->fs_kobj_unregister);
+}
+
+static ssize_t
+ocfs2_filecheck_show(struct kobject *kobj, struct attribute *attr, char *buf)
+{
+	ssize_t ret = -EIO;
+	struct kobj_attribute *kattr = container_of(attr,
+					struct kobj_attribute, attr);
+
+	kobject_get(kobj);
+	if (kattr->show)
+		ret = kattr->show(kobj, kattr, buf);
+	kobject_put(kobj);
+	return ret;
+}
+
+static ssize_t
+ocfs2_filecheck_store(struct kobject *kobj, struct attribute *attr,
+			const char *buf, size_t count)
+{
+	ssize_t ret = -EIO;
+	struct kobj_attribute *kattr = container_of(attr,
+					struct kobj_attribute, attr);
+
+	kobject_get(kobj);
+	if (kattr->store)
+		ret = kattr->store(kobj, kattr, buf, count);
+	kobject_put(kobj);
+	return ret;
+}
+
+static const struct sysfs_ops ocfs2_filecheck_ops = {
+	.show = ocfs2_filecheck_show,
+	.store = ocfs2_filecheck_store,
+};
+
+static struct kobj_type ocfs2_ktype_filecheck = {
+	.default_attrs = ocfs2_filecheck_attrs,
+	.sysfs_ops = &ocfs2_filecheck_ops,
+	.release = ocfs2_filecheck_release,
+};
 
 static void
 ocfs2_filecheck_sysfs_free(struct ocfs2_filecheck_sysfs_entry *entry)
 {
 	struct ocfs2_filecheck_entry *p;
 
-	if (!atomic_dec_and_test(&entry->fs_count))
-		wait_on_atomic_t(&entry->fs_count, atomic_t_wait,
-				 TASK_UNINTERRUPTIBLE);
-
 	spin_lock(&entry->fs_fcheck->fc_lock);
 	while (!list_empty(&entry->fs_fcheck->fc_head)) {
 		p = list_first_entry(&entry->fs_fcheck->fc_head,
@@ -121,151 +168,48 @@ ocfs2_filecheck_sysfs_free(struct ocfs2_
 	}
 	spin_unlock(&entry->fs_fcheck->fc_lock);
 
-	kset_unregister(entry->fs_fcheckkset);
-	kset_unregister(entry->fs_devicekset);
 	kfree(entry->fs_fcheck);
-	kfree(entry);
-}
-
-static void
-ocfs2_filecheck_sysfs_add(struct ocfs2_filecheck_sysfs_entry *entry)
-{
-	spin_lock(&ocfs2_filecheck_sysfs_lock);
-	list_add_tail(&entry->fs_list, &ocfs2_filecheck_sysfs_list);
-	spin_unlock(&ocfs2_filecheck_sysfs_lock);
-}
-
-static int ocfs2_filecheck_sysfs_del(const char *devname)
-{
-	struct ocfs2_filecheck_sysfs_entry *p;
-
-	spin_lock(&ocfs2_filecheck_sysfs_lock);
-	list_for_each_entry(p, &ocfs2_filecheck_sysfs_list, fs_list) {
-		if (!strcmp(p->fs_sb->s_id, devname)) {
-			list_del(&p->fs_list);
-			spin_unlock(&ocfs2_filecheck_sysfs_lock);
-			ocfs2_filecheck_sysfs_free(p);
-			return 0;
-		}
-	}
-	spin_unlock(&ocfs2_filecheck_sysfs_lock);
-	return 1;
-}
-
-static void
-ocfs2_filecheck_sysfs_put(struct ocfs2_filecheck_sysfs_entry *entry)
-{
-	if (atomic_dec_and_test(&entry->fs_count))
-		wake_up_atomic_t(&entry->fs_count);
-}
-
-static struct ocfs2_filecheck_sysfs_entry *
-ocfs2_filecheck_sysfs_get(const char *devname)
-{
-	struct ocfs2_filecheck_sysfs_entry *p = NULL;
-
-	spin_lock(&ocfs2_filecheck_sysfs_lock);
-	list_for_each_entry(p, &ocfs2_filecheck_sysfs_list, fs_list) {
-		if (!strcmp(p->fs_sb->s_id, devname)) {
-			atomic_inc(&p->fs_count);
-			spin_unlock(&ocfs2_filecheck_sysfs_lock);
-			return p;
-		}
-	}
-	spin_unlock(&ocfs2_filecheck_sysfs_lock);
-	return NULL;
+	entry->fs_fcheck = NULL;
 }
 
-int ocfs2_filecheck_create_sysfs(struct super_block *sb)
+int ocfs2_filecheck_create_sysfs(struct ocfs2_super *osb)
 {
-	int ret = 0;
-	struct kset *device_kset = NULL;
-	struct kset *fcheck_kset = NULL;
-	struct ocfs2_filecheck *fcheck = NULL;
-	struct ocfs2_filecheck_sysfs_entry *entry = NULL;
-	struct attribute **attrs = NULL;
-	struct attribute_group attrgp;
-
-	if (!ocfs2_kset)
-		return -ENOMEM;
-
-	attrs = kmalloc(sizeof(struct attribute *) * 4, GFP_NOFS);
-	if (!attrs) {
-		ret = -ENOMEM;
-		goto error;
-	} else {
-		attrs[0] = &ocfs2_attr_filecheck_chk.attr;
-		attrs[1] = &ocfs2_attr_filecheck_fix.attr;
-		attrs[2] = &ocfs2_attr_filecheck_set.attr;
-		attrs[3] = NULL;
-		memset(&attrgp, 0, sizeof(attrgp));
-		attrgp.attrs = attrs;
-	}
+	int ret;
+	struct ocfs2_filecheck *fcheck;
+	struct ocfs2_filecheck_sysfs_entry *entry = &osb->osb_fc_ent;
 
 	fcheck = kmalloc(sizeof(struct ocfs2_filecheck), GFP_NOFS);
-	if (!fcheck) {
-		ret = -ENOMEM;
-		goto error;
-	} else {
-		INIT_LIST_HEAD(&fcheck->fc_head);
-		spin_lock_init(&fcheck->fc_lock);
-		fcheck->fc_max = OCFS2_FILECHECK_MINSIZE;
-		fcheck->fc_size = 0;
-		fcheck->fc_done = 0;
-	}
-
-	if (strlen(sb->s_id) <= 0) {
-		mlog(ML_ERROR,
-		"Cannot get device basename when create filecheck sysfs\n");
-		ret = -ENODEV;
-		goto error;
-	}
-
-	device_kset = kset_create_and_add(sb->s_id, NULL, &ocfs2_kset->kobj);
-	if (!device_kset) {
-		ret = -ENOMEM;
-		goto error;
-	}
-
-	fcheck_kset = kset_create_and_add("filecheck", NULL,
-					  &device_kset->kobj);
-	if (!fcheck_kset) {
-		ret = -ENOMEM;
-		goto error;
-	}
-
-	ret = sysfs_create_group(&fcheck_kset->kobj, &attrgp);
-	if (ret)
-		goto error;
+	if (!fcheck)
+		return -ENOMEM;
 
-	entry = kmalloc(sizeof(struct ocfs2_filecheck_sysfs_entry), GFP_NOFS);
-	if (!entry) {
-		ret = -ENOMEM;
-		goto error;
-	} else {
-		atomic_set(&entry->fs_count, 1);
-		entry->fs_sb = sb;
-		entry->fs_devicekset = device_kset;
-		entry->fs_fcheckkset = fcheck_kset;
-		entry->fs_fcheck = fcheck;
-		ocfs2_filecheck_sysfs_add(entry);
+	INIT_LIST_HEAD(&fcheck->fc_head);
+	spin_lock_init(&fcheck->fc_lock);
+	fcheck->fc_max = OCFS2_FILECHECK_MINSIZE;
+	fcheck->fc_size = 0;
+	fcheck->fc_done = 0;
+
+	entry->fs_kobj.kset = osb->osb_dev_kset;
+	init_completion(&entry->fs_kobj_unregister);
+	ret = kobject_init_and_add(&entry->fs_kobj, &ocfs2_ktype_filecheck,
+					NULL, "filecheck");
+	if (ret) {
+		kfree(fcheck);
+		return ret;
 	}
 
-	kfree(attrs);
+	entry->fs_fcheck = fcheck;
 	return 0;
-
-error:
-	kfree(attrs);
-	kfree(entry);
-	kfree(fcheck);
-	kset_unregister(fcheck_kset);
-	kset_unregister(device_kset);
-	return ret;
 }
 
-int ocfs2_filecheck_remove_sysfs(struct super_block *sb)
+void ocfs2_filecheck_remove_sysfs(struct ocfs2_super *osb)
 {
-	return ocfs2_filecheck_sysfs_del(sb->s_id);
+	if (!osb->osb_fc_ent.fs_fcheck)
+		return;
+
+	kobject_del(&osb->osb_fc_ent.fs_kobj);
+	kobject_put(&osb->osb_fc_ent.fs_kobj);
+	wait_for_completion(&osb->osb_fc_ent.fs_kobj_unregister);
+	ocfs2_filecheck_sysfs_free(&osb->osb_fc_ent);
 }
 
 static int
@@ -359,7 +303,7 @@ ocfs2_filecheck_args_parse(const char *n
 	return 0;
 }
 
-static ssize_t ocfs2_filecheck_show(struct kobject *kobj,
+static ssize_t ocfs2_filecheck_attr_show(struct kobject *kobj,
 				    struct kobj_attribute *attr,
 				    char *buf)
 {
@@ -367,19 +311,12 @@ static ssize_t ocfs2_filecheck_show(stru
 	ssize_t ret = 0, total = 0, remain = PAGE_SIZE;
 	unsigned int type;
 	struct ocfs2_filecheck_entry *p;
-	struct ocfs2_filecheck_sysfs_entry *ent;
+	struct ocfs2_filecheck_sysfs_entry *ent = container_of(kobj,
+				struct ocfs2_filecheck_sysfs_entry, fs_kobj);
 
 	if (ocfs2_filecheck_type_parse(attr->attr.name, &type))
 		return -EINVAL;
 
-	ent = ocfs2_filecheck_sysfs_get(kobj->parent->name);
-	if (!ent) {
-		mlog(ML_ERROR,
-		"Cannot get the corresponding entry via device basename %s\n",
-		kobj->name);
-		return -ENODEV;
-	}
-
 	if (type == OCFS2_FILECHECK_TYPE_SET) {
 		spin_lock(&ent->fs_fcheck->fc_lock);
 		total = snprintf(buf, remain, "%u\n", ent->fs_fcheck->fc_max);
@@ -413,11 +350,10 @@ static ssize_t ocfs2_filecheck_show(stru
 	spin_unlock(&ent->fs_fcheck->fc_lock);
 
 exit:
-	ocfs2_filecheck_sysfs_put(ent);
 	return total;
 }
 
-static int
+static inline int
 ocfs2_filecheck_erase_entry(struct ocfs2_filecheck_sysfs_entry *ent)
 {
 	struct ocfs2_filecheck_entry *p;
@@ -463,14 +399,14 @@ ocfs2_filecheck_done_entry(struct ocfs2_
 }
 
 static unsigned int
-ocfs2_filecheck_handle(struct super_block *sb,
+ocfs2_filecheck_handle(struct ocfs2_super *osb,
 		       unsigned long ino, unsigned int flags)
 {
 	unsigned int ret = OCFS2_FILECHECK_ERR_SUCCESS;
 	struct inode *inode = NULL;
 	int rc;
 
-	inode = ocfs2_iget(OCFS2_SB(sb), ino, flags, 0);
+	inode = ocfs2_iget(osb, ino, flags, 0);
 	if (IS_ERR(inode)) {
 		rc = (int)(-(long)inode);
 		if (rc >= OCFS2_FILECHECK_ERR_START &&
@@ -488,11 +424,14 @@ static void
 ocfs2_filecheck_handle_entry(struct ocfs2_filecheck_sysfs_entry *ent,
 			     struct ocfs2_filecheck_entry *entry)
 {
+	struct ocfs2_super *osb = container_of(ent, struct ocfs2_super,
+						osb_fc_ent);
+
 	if (entry->fe_type == OCFS2_FILECHECK_TYPE_CHK)
-		entry->fe_status = ocfs2_filecheck_handle(ent->fs_sb,
+		entry->fe_status = ocfs2_filecheck_handle(osb,
 				entry->fe_ino, OCFS2_FI_FLAG_FILECHECK_CHK);
 	else if (entry->fe_type == OCFS2_FILECHECK_TYPE_FIX)
-		entry->fe_status = ocfs2_filecheck_handle(ent->fs_sb,
+		entry->fe_status = ocfs2_filecheck_handle(osb,
 				entry->fe_ino, OCFS2_FI_FLAG_FILECHECK_FIX);
 	else
 		entry->fe_status = OCFS2_FILECHECK_ERR_UNSUPPORTED;
@@ -500,30 +439,21 @@ ocfs2_filecheck_handle_entry(struct ocfs
 	ocfs2_filecheck_done_entry(ent, entry);
 }
 
-static ssize_t ocfs2_filecheck_store(struct kobject *kobj,
+static ssize_t ocfs2_filecheck_attr_store(struct kobject *kobj,
 				     struct kobj_attribute *attr,
 				     const char *buf, size_t count)
 {
+	ssize_t ret = 0;
 	struct ocfs2_filecheck_args args;
 	struct ocfs2_filecheck_entry *entry;
-	struct ocfs2_filecheck_sysfs_entry *ent;
-	ssize_t ret = 0;
+	struct ocfs2_filecheck_sysfs_entry *ent = container_of(kobj,
+				struct ocfs2_filecheck_sysfs_entry, fs_kobj);
 
 	if (count == 0)
 		return count;
 
-	if (ocfs2_filecheck_args_parse(attr->attr.name, buf, count, &args)) {
-		mlog(ML_ERROR, "Invalid arguments for online file check\n");
+	if (ocfs2_filecheck_args_parse(attr->attr.name, buf, count, &args))
 		return -EINVAL;
-	}
-
-	ent = ocfs2_filecheck_sysfs_get(kobj->parent->name);
-	if (!ent) {
-		mlog(ML_ERROR,
-		"Cannot get the corresponding entry via device basename %s\n",
-		kobj->parent->name);
-		return -ENODEV;
-	}
 
 	if (args.fa_type == OCFS2_FILECHECK_TYPE_SET) {
 		ret = ocfs2_filecheck_adjust_max(ent, args.fa_len);
@@ -538,7 +468,7 @@ static ssize_t ocfs2_filecheck_store(str
 
 	spin_lock(&ent->fs_fcheck->fc_lock);
 	if ((ent->fs_fcheck->fc_size >= ent->fs_fcheck->fc_max) &&
-	    (ent->fs_fcheck->fc_done == 0)) {
+		(ent->fs_fcheck->fc_done == 0)) {
 		mlog(ML_NOTICE,
 		"Cannot do more file check "
 		"since file check queue(%u) is full now\n",
@@ -568,6 +498,5 @@ static ssize_t ocfs2_filecheck_store(str
 		ocfs2_filecheck_handle_entry(ent, entry);
 
 exit:
-	ocfs2_filecheck_sysfs_put(ent);
 	return (!ret ? count : ret);
 }
diff -puN fs/ocfs2/filecheck.h~ocfs2-add-kobject-for-online-file-check fs/ocfs2/filecheck.h
--- a/fs/ocfs2/filecheck.h~ocfs2-add-kobject-for-online-file-check
+++ a/fs/ocfs2/filecheck.h
@@ -51,15 +51,6 @@ struct ocfs2_filecheck {
 	unsigned int fc_done;	/* Finished entry count in list */
 };
 
-struct ocfs2_filecheck_sysfs_entry {	/* sysfs entry per mounting */
-	struct list_head fs_list;
-	atomic_t fs_count;
-	struct super_block *fs_sb;
-	struct kset *fs_devicekset;
-	struct kset *fs_fcheckkset;
-	struct ocfs2_filecheck *fs_fcheck;
-};
-
 #define OCFS2_FILECHECK_MAXSIZE		100
 #define OCFS2_FILECHECK_MINSIZE		10
 
@@ -70,7 +61,14 @@ enum {
 	OCFS2_FILECHECK_TYPE_SET = 100	/* Set entry list maximum size */
 };
 
-int ocfs2_filecheck_create_sysfs(struct super_block *sb);
-int ocfs2_filecheck_remove_sysfs(struct super_block *sb);
+struct ocfs2_filecheck_sysfs_entry {	/* sysfs entry per partition */
+	struct kobject fs_kobj;
+	struct completion fs_kobj_unregister;
+	struct ocfs2_filecheck *fs_fcheck;
+};
+
+
+int ocfs2_filecheck_create_sysfs(struct ocfs2_super *osb);
+void ocfs2_filecheck_remove_sysfs(struct ocfs2_super *osb);
 
 #endif  /* FILECHECK_H */
diff -puN fs/ocfs2/ocfs2.h~ocfs2-add-kobject-for-online-file-check fs/ocfs2/ocfs2.h
--- a/fs/ocfs2/ocfs2.h~ocfs2-add-kobject-for-online-file-check
+++ a/fs/ocfs2/ocfs2.h
@@ -50,6 +50,8 @@
 
 #include "reservations.h"
 
+#include "filecheck.h"
+
 /* Caching of metadata buffers */
 
 /* Most user visible OCFS2 inodes will have very few pieces of
@@ -471,6 +473,12 @@ struct ocfs2_super
 	 * workqueue and schedule on our own.
 	 */
 	struct workqueue_struct *ocfs2_wq;
+
+	/* sysfs directory per partition */
+	struct kset *osb_dev_kset;
+
+	/* file check related stuff */
+	struct ocfs2_filecheck_sysfs_entry osb_fc_ent;
 };
 
 #define OCFS2_SB(sb)	    ((struct ocfs2_super *)(sb)->s_fs_info)
diff -puN fs/ocfs2/super.c~ocfs2-add-kobject-for-online-file-check fs/ocfs2/super.c
--- a/fs/ocfs2/super.c~ocfs2-add-kobject-for-online-file-check
+++ a/fs/ocfs2/super.c
@@ -1162,6 +1162,23 @@ static int ocfs2_fill_super(struct super
 
 	ocfs2_complete_mount_recovery(osb);
 
+	osb->osb_dev_kset = kset_create_and_add(sb->s_id, NULL,
+						&ocfs2_kset->kobj);
+	if (!osb->osb_dev_kset) {
+		status = -ENOMEM;
+		mlog(ML_ERROR, "Unable to create device kset %s.\n", sb->s_id);
+		goto read_super_error;
+	}
+
+	/* Create filecheck sysfs related directories/files at
+	 * /sys/fs/ocfs2/<devname>/filecheck */
+	if (ocfs2_filecheck_create_sysfs(osb)) {
+		status = -ENOMEM;
+		mlog(ML_ERROR, "Unable to create filecheck sysfs directory at "
+			"/sys/fs/ocfs2/%s/filecheck.\n", sb->s_id);
+		goto read_super_error;
+	}
+
 	if (ocfs2_mount_local(osb))
 		snprintf(nodestr, sizeof(nodestr), "local");
 	else
@@ -1200,9 +1217,6 @@ static int ocfs2_fill_super(struct super
 	/* Start this when the mount is almost sure of being successful */
 	ocfs2_orphan_scan_start(osb);
 
-	/* Create filecheck sysfile /sys/fs/ocfs2/<devname>/filecheck */
-	ocfs2_filecheck_create_sysfs(sb);
-
 	return status;
 
 read_super_error:
@@ -1654,7 +1668,6 @@ static void ocfs2_put_super(struct super
 
 	ocfs2_sync_blockdev(sb);
 	ocfs2_dismount_volume(sb, 0);
-	ocfs2_filecheck_remove_sysfs(sb);
 }
 
 static int ocfs2_statfs(struct dentry *dentry, struct kstatfs *buf)
@@ -1900,6 +1913,12 @@ static void ocfs2_dismount_volume(struct
 	osb = OCFS2_SB(sb);
 	BUG_ON(!osb);
 
+	/* Remove file check sysfs related directores/files,
+	 * and wait for the pending file check operations */
+	ocfs2_filecheck_remove_sysfs(osb);
+
+	kset_unregister(osb->osb_dev_kset);
+
 	debugfs_remove(osb->osb_ctxt);
 
 	/* Orphan scan should be stopped as early as possible */
_
