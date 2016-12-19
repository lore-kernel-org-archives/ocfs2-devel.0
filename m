From: Gang He <ghe@suse.com>
Date: Mon, 19 Dec 2016 17:21:26 +0800
Subject: [Ocfs2-devel] [PATCH 1/2] ocfs2: add kobject for online file check
In-Reply-To: <1482139287-19040-1-git-send-email-ghe@suse.com>
References: <1482139287-19040-1-git-send-email-ghe@suse.com>
Message-ID: <1482139287-19040-2-git-send-email-ghe@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: mfasheh@versity.com, jlbec@evilplan.org
Cc: Gang He <ghe@suse.com>, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com, akpm@linux-foundation.org

Use embedded kobject mechanism for online file check feature,
this will avoid to use a global list to save/search per-device online file
check related data. The changed code is based on Goldwyn Rodrigues's
patches and ext4 fs code.
Second, some small adjustment/fixes are also included.
1) move some data structure definitions to the header file;
2) tune mlog message level from ERROR to NOTICE;
3) add file check duplicative ino number check;
4) the other miscellaneous.

Signed-off-by: Gang He <ghe@suse.com>
---
 fs/ocfs2/filecheck.c | 360 ++++++++++++++++++++-------------------------------
 fs/ocfs2/filecheck.h |  29 ++++-
 2 files changed, 165 insertions(+), 224 deletions(-)

diff --git a/fs/ocfs2/filecheck.c b/fs/ocfs2/filecheck.c
index 2cabbcf..5a6ae70 100644
--- a/fs/ocfs2/filecheck.c
+++ b/fs/ocfs2/filecheck.c
@@ -53,36 +53,6 @@
 	"UNSUPPORTED"
 };
 
-static DEFINE_SPINLOCK(ocfs2_filecheck_sysfs_lock);
-static LIST_HEAD(ocfs2_filecheck_sysfs_list);
-
-struct ocfs2_filecheck {
-	struct list_head fc_head;	/* File check entry list head */
-	spinlock_t fc_lock;
-	unsigned int fc_max;	/* Maximum number of entry in list */
-	unsigned int fc_size;	/* Current entry count in list */
-	unsigned int fc_done;	/* Finished entry count in list */
-};
-
-struct ocfs2_filecheck_sysfs_entry {	/* sysfs entry per mounting */
-	struct list_head fs_list;
-	atomic_t fs_count;
-	struct super_block *fs_sb;
-	struct kset *fs_devicekset;
-	struct kset *fs_fcheckkset;
-	struct ocfs2_filecheck *fs_fcheck;
-};
-
-#define OCFS2_FILECHECK_MAXSIZE		100
-#define OCFS2_FILECHECK_MINSIZE		10
-
-/* File check operation type */
-enum {
-	OCFS2_FILECHECK_TYPE_CHK = 0,	/* Check a file(inode) */
-	OCFS2_FILECHECK_TYPE_FIX,	/* Fix a file(inode) */
-	OCFS2_FILECHECK_TYPE_SET = 100	/* Set entry list maximum size */
-};
-
 struct ocfs2_filecheck_entry {
 	struct list_head fe_list;
 	unsigned long fe_ino;
@@ -110,40 +80,84 @@ struct ocfs2_filecheck_args {
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
 
-static int ocfs2_filecheck_sysfs_wait(atomic_t *p)
+static void ocfs2_filecheck_release(struct kobject *kobj)
 {
-	schedule();
-	return 0;
+	struct ocfs2_filecheck_sysfs_entry *entry = container_of(kobj,
+				struct ocfs2_filecheck_sysfs_entry, fs_kobj);
+
+	complete(&entry->fs_kobj_unregister);
 }
 
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
+
 static void
 ocfs2_filecheck_sysfs_free(struct ocfs2_filecheck_sysfs_entry *entry)
 {
 	struct ocfs2_filecheck_entry *p;
 
-	if (!atomic_dec_and_test(&entry->fs_count))
-		wait_on_atomic_t(&entry->fs_count, ocfs2_filecheck_sysfs_wait,
-				 TASK_UNINTERRUPTIBLE);
-
 	spin_lock(&entry->fs_fcheck->fc_lock);
 	while (!list_empty(&entry->fs_fcheck->fc_head)) {
 		p = list_first_entry(&entry->fs_fcheck->fc_head,
@@ -154,151 +168,48 @@ static int ocfs2_filecheck_sysfs_wait(atomic_t *p)
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
+	entry->fs_fcheck = NULL;
 }
 
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
+int ocfs2_filecheck_create_sysfs(struct ocfs2_super *osb)
 {
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
-}
-
-int ocfs2_filecheck_create_sysfs(struct super_block *sb)
-{
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
@@ -315,7 +226,7 @@ int ocfs2_filecheck_remove_sysfs(struct super_block *sb)
 
 	spin_lock(&ent->fs_fcheck->fc_lock);
 	if (len < (ent->fs_fcheck->fc_size - ent->fs_fcheck->fc_done)) {
-		mlog(ML_ERROR,
+		mlog(ML_NOTICE,
 		"Cannot set online file check maximum entry number "
 		"to %u due to too many pending entries(%u)\n",
 		len, ent->fs_fcheck->fc_size - ent->fs_fcheck->fc_done);
@@ -392,7 +303,7 @@ int ocfs2_filecheck_remove_sysfs(struct super_block *sb)
 	return 0;
 }
 
-static ssize_t ocfs2_filecheck_show(struct kobject *kobj,
+static ssize_t ocfs2_filecheck_attr_show(struct kobject *kobj,
 				    struct kobj_attribute *attr,
 				    char *buf)
 {
@@ -400,19 +311,12 @@ static ssize_t ocfs2_filecheck_show(struct kobject *kobj,
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
@@ -446,11 +350,27 @@ static ssize_t ocfs2_filecheck_show(struct kobject *kobj,
 	spin_unlock(&ent->fs_fcheck->fc_lock);
 
 exit:
-	ocfs2_filecheck_sysfs_put(ent);
 	return total;
 }
 
-static int
+
+static inline int
+ocfs2_filecheck_is_dup_entry(struct ocfs2_filecheck_sysfs_entry *ent,
+				unsigned long ino)
+{
+	struct ocfs2_filecheck_entry *p;
+
+	list_for_each_entry(p, &ent->fs_fcheck->fc_head, fe_list) {
+		if (!p->fe_done) {
+			if (p->fe_ino == ino)
+				return 1;
+		}
+	}
+
+	return 0;
+}
+
+static inline int
 ocfs2_filecheck_erase_entry(struct ocfs2_filecheck_sysfs_entry *ent)
 {
 	struct ocfs2_filecheck_entry *p;
@@ -489,21 +409,21 @@ static ssize_t ocfs2_filecheck_show(struct kobject *kobj,
 ocfs2_filecheck_done_entry(struct ocfs2_filecheck_sysfs_entry *ent,
 			   struct ocfs2_filecheck_entry *entry)
 {
-	entry->fe_done = 1;
 	spin_lock(&ent->fs_fcheck->fc_lock);
+	entry->fe_done = 1;
 	ent->fs_fcheck->fc_done++;
 	spin_unlock(&ent->fs_fcheck->fc_lock);
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
@@ -521,11 +441,14 @@ static ssize_t ocfs2_filecheck_show(struct kobject *kobj,
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
@@ -533,30 +456,21 @@ static ssize_t ocfs2_filecheck_show(struct kobject *kobj,
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
-		return count;
+		return 0; /* nothing to do */
 
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
@@ -570,13 +484,16 @@ static ssize_t ocfs2_filecheck_store(struct kobject *kobj,
 	}
 
 	spin_lock(&ent->fs_fcheck->fc_lock);
-	if ((ent->fs_fcheck->fc_size >= ent->fs_fcheck->fc_max) &&
-	    (ent->fs_fcheck->fc_done == 0)) {
-		mlog(ML_ERROR,
+	if (ocfs2_filecheck_is_dup_entry(ent, args.fa_ino)) {
+		ret = -EEXIST;
+		kfree(entry);
+	} else if ((ent->fs_fcheck->fc_size >= ent->fs_fcheck->fc_max) &&
+		(ent->fs_fcheck->fc_done == 0)) {
+		mlog(ML_NOTICE,
 		"Cannot do more file check "
 		"since file check queue(%u) is full now\n",
 		ent->fs_fcheck->fc_max);
-		ret = -EBUSY;
+		ret = -EAGAIN;
 		kfree(entry);
 	} else {
 		if ((ent->fs_fcheck->fc_size >= ent->fs_fcheck->fc_max) &&
@@ -601,6 +518,5 @@ static ssize_t ocfs2_filecheck_store(struct kobject *kobj,
 		ocfs2_filecheck_handle_entry(ent, entry);
 
 exit:
-	ocfs2_filecheck_sysfs_put(ent);
 	return (!ret ? count : ret);
 }
diff --git a/fs/ocfs2/filecheck.h b/fs/ocfs2/filecheck.h
index e5cd002..6a22ee7 100644
--- a/fs/ocfs2/filecheck.h
+++ b/fs/ocfs2/filecheck.h
@@ -43,7 +43,32 @@ enum {
 #define OCFS2_FILECHECK_ERR_START	OCFS2_FILECHECK_ERR_FAILED
 #define OCFS2_FILECHECK_ERR_END		OCFS2_FILECHECK_ERR_UNSUPPORTED
 
-int ocfs2_filecheck_create_sysfs(struct super_block *sb);
-int ocfs2_filecheck_remove_sysfs(struct super_block *sb);
+struct ocfs2_filecheck {
+	struct list_head fc_head;	/* File check entry list head */
+	spinlock_t fc_lock;
+	unsigned int fc_max;	/* Maximum number of entry in list */
+	unsigned int fc_size;	/* Current entry count in list */
+	unsigned int fc_done;	/* Finished entry count in list */
+};
+
+#define OCFS2_FILECHECK_MAXSIZE		100
+#define OCFS2_FILECHECK_MINSIZE		10
+
+/* File check operation type */
+enum {
+	OCFS2_FILECHECK_TYPE_CHK = 0,	/* Check a file(inode) */
+	OCFS2_FILECHECK_TYPE_FIX,	/* Fix a file(inode) */
+	OCFS2_FILECHECK_TYPE_SET = 100	/* Set entry list maximum size */
+};
+
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
-- 
1.8.5.6
