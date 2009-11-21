From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Fri, 20 Nov 2009 17:12:54 -0800
Subject: [Ocfs2-devel] [PATCH 07/10] ocfs2: Handle missing kobj_attribute
In-Reply-To: <1258765977-4334-1-git-send-email-sunil.mushran@oracle.com>
References: <1258765977-4334-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1258765977-4334-8-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mainline commit 23b5212cc7422f475b82124334b64277b5b43013 added kobj_attribute.
This patch adds compat code to allow the fs to build on older EL5 kernels.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 Config.make.in                       |    1 +
 Makefile                             |    3 +-
 configure.in                         |    6 ++
 fs/ocfs2/Makefile                    |    8 +++-
 fs/ocfs2/cluster/Makefile            |    6 ++-
 fs/ocfs2/cluster/kapi-default.h      |   10 ++++
 fs/ocfs2/cluster/sys.c               |   16 +++---
 fs/ocfs2/compat_kobject.c            |   90 ++++++++++++++++++++++++++++++++++
 fs/ocfs2/kapi-default.h              |   10 ++++
 fs/ocfs2/stackglue.c                 |   10 ++--
 kapi-compat/include/compat_kobject.h |   29 +++++++++++
 11 files changed, 173 insertions(+), 16 deletions(-)
 create mode 100644 fs/ocfs2/compat_kobject.c
 create mode 100644 kapi-compat/include/compat_kobject.h

diff --git a/Config.make.in b/Config.make.in
index 0107e2e..dd2e406 100644
--- a/Config.make.in
+++ b/Config.make.in
@@ -81,6 +81,7 @@ HAS_FOPS_SENDFILE = @HAS_FOPS_SENDFILE@
 SKIP_SPLICE = @SKIP_SPLICE@
 SKIP_BUFFER_TRIGGERS = @SKIP_BUFFER_TRIGGERS@
 NO_NAME_IN_BACKING_DEV_INFO=@NO_NAME_IN_BACKING_DEV_INFO@
+NO_KOBJ_ATTRIBUTE = @NO_KOBJ_ATTRIBUTE@
 
 
 OCFS_DEBUG = @OCFS_DEBUG@
diff --git a/Makefile b/Makefile
index fd34d67..7c48788 100644
--- a/Makefile
+++ b/Makefile
@@ -38,7 +38,8 @@ KAPI_COMPAT_FILES = \
 	kapi-compat/include/filemap_fdatawait_range.h	\
 	kapi-compat/include/mnt_want_write.h		\
 	kapi-compat/include/hardsect.h			\
-	kapi-compat/include/triggers.h
+	kapi-compat/include/triggers.h			\
+	kapi-compat/include/compat_kobject.h
 
 PATCH_FILES =
 
diff --git a/configure.in b/configure.in
index 0a3a356..22245ec 100644
--- a/configure.in
+++ b/configure.in
@@ -440,6 +440,12 @@ OCFS2_CHECK_KERNEL([name in backing-dev.h], backing-dev.h,
  , NO_NAME_IN_BACKING_DEV_INFO=yes, [char.*\*name;$])
 AC_SUBST(NO_NAME_IN_BACKING_DEV_INFO)
 
+NO_KOBJ_ATTRIBUTE=
+OCFS2_CHECK_KERNEL([struct kobj_attribute in kobject.h], kobject.h,
+  , NO_KOBJ_ATTRIBUTE=compat_kobject.h, [^struct kobj_attribute {])
+AC_SUBST(NO_KOBJ_ATTRIBUTE)
+KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS $NO_KOBJ_ATTRIBUTE"
+
 # End kapi_compat checks
 
 # using -include has two advantages:
diff --git a/fs/ocfs2/Makefile b/fs/ocfs2/Makefile
index 1e8fed6..c02cbee 100644
--- a/fs/ocfs2/Makefile
+++ b/fs/ocfs2/Makefile
@@ -122,6 +122,12 @@ ifdef SKIP_BUFFER_TRIGGERS
 CFLAGS_journal.o += -DSKIP_BUFFER_TRIGGERS
 endif
 
+COMPAT_SOURCES += compat_kobject.c
+ifdef NO_KOBJ_ATTRIBUTE
+FS_SOURCES += compat_kobject.c
+EXTRA_CFLAGS += -DNO_KOBJ_ATTRIBUTE
+endif
+
 #
 # Since SUBDIRS means something to kbuild, define them safely.  Do not
 # include trailing slashes.
@@ -156,7 +162,7 @@ INSTALL_MOD_DIR := fs/ocfs2
 obj-m := ocfs2.o ocfs2_stackglue.o ocfs2_stack_o2cb.o ocfs2_stack_user.o
 
 ocfs2-objs := $(FS_OBJECTS)
-ocfs2_stackglue-objs := stackglue.o
+ocfs2_stackglue-objs := stackglue.o compat_kobject.o
 ocfs2_stack_o2cb-objs := stack_o2cb.o
 ocfs2_stack_user-objs := stack_user.o
 
diff --git a/fs/ocfs2/cluster/Makefile b/fs/ocfs2/cluster/Makefile
index d107cca..7336217 100644
--- a/fs/ocfs2/cluster/Makefile
+++ b/fs/ocfs2/cluster/Makefile
@@ -30,6 +30,10 @@ ifdef OLD_BIO_END_IO_T
 EXTRA_CFLAGS += -DOLD_BIO_END_IO_T
 endif
 
+ifdef NO_KOBJ_ATTRIBUTE
+EXTRA_CFLAGS += -DNO_KOBJ_ATTRIBUTE
+endif
+
 SOURCES +=			\
 	heartbeat.c		\
 	masklog.c		\
@@ -52,7 +56,7 @@ HEADERS += 			\
 	tcp_internal.h		\
 	ver.h
 
-OBJECTS = $(subst .c,.o,$(SOURCES))
+OBJECTS = $(subst .c,.o,$(SOURCES)) ../compat_kobject.o
 VERSION_FILES = $(SOURCES) $(HEADERS) $(COMPAT_SOURCES) $(COMPAT_HEADERS)
 VERSION_SRC = ver.c
 VERSION_PREFIX = CLUSTER
diff --git a/fs/ocfs2/cluster/kapi-default.h b/fs/ocfs2/cluster/kapi-default.h
index 81dce2f..36976f1 100644
--- a/fs/ocfs2/cluster/kapi-default.h
+++ b/fs/ocfs2/cluster/kapi-default.h
@@ -42,4 +42,14 @@ typedef struct work_struct kapi_work_struct_t;
 # define su_mutex			su_mutex
 #endif
 
+#ifndef kapi_kset
+# define kapi_kset				kset
+# define kapi_kset_create_and_add(a, b, c)	kset_create_and_add(a, b, c)
+# define kapi_kset_unregister(a)		kset_unregister(a)
+# define kapi_to_kobj(a)			(&((a)->kobj))
+# define kapi_to_kset(a)			(a)
+# define kapi_sysfs_create_link(a, b, c)	sysfs_create_link(a, b, c)
+# define kapi_sysfs_remove_link(a, b)		sysfs_remove_link(a, b)
+#endif
+
 #endif
diff --git a/fs/ocfs2/cluster/sys.c b/fs/ocfs2/cluster/sys.c
index bc702da..46d32c6 100644
--- a/fs/ocfs2/cluster/sys.c
+++ b/fs/ocfs2/cluster/sys.c
@@ -52,20 +52,20 @@ static struct attribute_group o2cb_attr_group = {
 	.attrs = o2cb_attrs,
 };
 
-static struct kset *o2cb_kset;
+static struct kapi_kset *o2cb_kset;
 
 void o2cb_sys_shutdown(void)
 {
 	mlog_sys_shutdown();
-	sysfs_remove_link(NULL, "o2cb");
-	kset_unregister(o2cb_kset);
+	kapi_sysfs_remove_link(NULL, "o2cb");
+	kapi_kset_unregister(o2cb_kset);
 }
 
 int o2cb_sys_init(void)
 {
 	int ret;
 
-	o2cb_kset = kset_create_and_add("o2cb", NULL, fs_kobj);
+	o2cb_kset = kapi_kset_create_and_add("o2cb", NULL, fs_kobj);
 	if (!o2cb_kset)
 		return -ENOMEM;
 
@@ -73,19 +73,19 @@ int o2cb_sys_init(void)
 	 * Create this symlink for backwards compatibility with old
 	 * versions of ocfs2-tools which look for things in /sys/o2cb.
 	 */
-	ret = sysfs_create_link(NULL, &o2cb_kset->kobj, "o2cb");
+	ret = kapi_sysfs_create_link(NULL, &o2cb_kset->kobj, "o2cb");
 	if (ret)
 		goto error;
 
-	ret = sysfs_create_group(&o2cb_kset->kobj, &o2cb_attr_group);
+	ret = sysfs_create_group(kapi_to_kobj(o2cb_kset), &o2cb_attr_group);
 	if (ret)
 		goto error;
 
-	ret = mlog_sys_init(o2cb_kset);
+	ret = mlog_sys_init(kapi_to_kset(o2cb_kset));
 	if (ret)
 		goto error;
 	return 0;
 error:
-	kset_unregister(o2cb_kset);
+	kapi_kset_unregister(o2cb_kset);
 	return ret;
 }
diff --git a/fs/ocfs2/compat_kobject.c b/fs/ocfs2/compat_kobject.c
new file mode 100644
index 0000000..fef1fd9
--- /dev/null
+++ b/fs/ocfs2/compat_kobject.c
@@ -0,0 +1,90 @@
+#include <linux/slab.h>
+#include <linux/kobject.h>
+
+/* default kobject attribute operations */
+static ssize_t kobj_attr_show(struct kobject *kobj, struct attribute *attr,
+			      char *buf)
+{
+	struct kobj_attribute *kattr;
+	ssize_t ret = -EIO;
+
+	kattr = container_of(attr, struct kobj_attribute, attr);
+	if (kattr->show)
+		ret = kattr->show(kobj, kattr, buf);
+	return ret;
+}
+
+static ssize_t kobj_attr_store(struct kobject *kobj, struct attribute *attr,
+			       const char *buf, size_t count)
+{
+	struct kobj_attribute *kattr;
+	ssize_t ret = -EIO;
+
+	kattr = container_of(attr, struct kobj_attribute, attr);
+	if (kattr->store)
+		ret = kattr->store(kobj, kattr, buf, count);
+	return ret;
+}
+
+static struct sysfs_ops kobj_sysfs_ops = {
+	.show   = kobj_attr_show,
+	.store  = kobj_attr_store,
+};
+
+static void dynamic_kobj_release(struct kobject *kobj)
+{
+	pr_debug("kobject: (%p): %s\n", kobj, __FUNCTION__);
+	kfree(kobj);
+}
+
+static struct kobj_type dynamic_kobj_ktype = {
+	.release        = dynamic_kobj_release,
+	.sysfs_ops      = &kobj_sysfs_ops,
+};
+
+/**
+ * kobject_create_and_add - create a struct kobject dynamically and register it with sysfs
+ *
+ * @name: the name for the kset
+ * @parent: the parent kobject of this kobject, if any.
+ *
+ * This function creates a kobject structure dynamically and registers it
+ * with sysfs.  When you are finished with this structure, call
+ * kobject_put() and the structure will be dynamically freed when
+ * it is no longer being used.
+ *
+ * If the kobject was not able to be created, NULL will be returned.
+ */
+struct kobject *kobject_create_and_add(const char *name, struct kobject *parent)
+{
+	struct kobject *kobj;
+	int retval;
+
+	kobj = kzalloc(sizeof(*kobj), GFP_KERNEL);
+	if (!kobj)
+		return NULL;
+
+	kobject_init(kobj);
+	kobj->ktype = &dynamic_kobj_ktype;
+	kobj->parent = parent;
+
+	retval = kobject_set_name(kobj, "%s", name);
+	if (retval) {
+		printk(KERN_WARNING "%s: kobject_set_name error: %d\n",
+			__FUNCTION__, retval);
+		goto err;
+	}
+
+	retval = kobject_add(kobj);
+	if (retval) {
+		printk(KERN_WARNING "%s: kobject_add error: %d\n",
+			__FUNCTION__, retval);
+		goto err;
+	}
+
+	return kobj;
+
+err:
+	kobject_put(kobj);
+	return NULL;
+}
diff --git a/fs/ocfs2/kapi-default.h b/fs/ocfs2/kapi-default.h
index 80f04ff..68e5746 100644
--- a/fs/ocfs2/kapi-default.h
+++ b/fs/ocfs2/kapi-default.h
@@ -69,4 +69,14 @@ typedef u64 f_version_t;
 # define kapi_filemap_fdatawait_range		filemap_fdatawait_range
 #endif
 
+#ifndef kapi_kset
+# define kapi_kset				kset
+# define kapi_kset_create_and_add(a, b, c)	kset_create_and_add(a, b, c)
+# define kapi_kset_unregister(a)		kset_unregister(a)
+# define kapi_to_kobj(a)			(&((a)->kobj))
+# define kapi_to_kset(a)			(a)
+# define kapi_sysfs_create_link(a, b, c)	sysfs_create_link(a, b, c)
+# define kapi_sysfs_remove_link(a, b)		sysfs_remove_link(a, b)
+#endif
+
 #endif
diff --git a/fs/ocfs2/stackglue.c b/fs/ocfs2/stackglue.c
index b4c85be..02ba5b5 100644
--- a/fs/ocfs2/stackglue.c
+++ b/fs/ocfs2/stackglue.c
@@ -582,29 +582,29 @@ static struct attribute_group ocfs2_attr_group = {
 	.attrs = ocfs2_attrs,
 };
 
-static struct kset *ocfs2_kset;
+static struct kapi_kset *ocfs2_kset;
 
 static void ocfs2_sysfs_exit(void)
 {
-	kset_unregister(ocfs2_kset);
+	kapi_kset_unregister(ocfs2_kset);
 }
 
 static int ocfs2_sysfs_init(void)
 {
 	int ret;
 
-	ocfs2_kset = kset_create_and_add("ocfs2", NULL, fs_kobj);
+	ocfs2_kset = kapi_kset_create_and_add("ocfs2", NULL, fs_kobj);
 	if (!ocfs2_kset)
 		return -ENOMEM;
 
-	ret = sysfs_create_group(&ocfs2_kset->kobj, &ocfs2_attr_group);
+	ret = sysfs_create_group(kapi_to_kobj(ocfs2_kset), &ocfs2_attr_group);
 	if (ret)
 		goto error;
 
 	return 0;
 
 error:
-	kset_unregister(ocfs2_kset);
+	kapi_kset_unregister(ocfs2_kset);
 	return ret;
 }
 
diff --git a/kapi-compat/include/compat_kobject.h b/kapi-compat/include/compat_kobject.h
new file mode 100644
index 0000000..441b3c6
--- /dev/null
+++ b/kapi-compat/include/compat_kobject.h
@@ -0,0 +1,29 @@
+#ifndef KAPI_COMPAT_KOBJECT_H
+#define KAPI_COMPAT_KOBJECT_H
+
+#ifdef NO_KOBJ_ATTRIBUTE
+
+#include <linux/slab.h>
+#include <linux/kobject.h>
+
+#define kapi_kset				kobject
+#define kapi_kset_create_and_add(a, b, c)	kobject_create_and_add(a, b)
+#define kapi_kset_unregister(a)			kobject_unregister(a)
+#define kapi_to_kobj(a)				(a)
+#define kapi_to_kset(a)				((a)->kset)
+#define kapi_sysfs_create_link(a, b, c)		0
+#define kapi_sysfs_remove_link(a, b)
+
+struct kobj_attribute {
+	struct attribute attr;
+	ssize_t (*show)(struct kobject *kobj, struct kobj_attribute *attr,
+			char *buf);
+	ssize_t (*store)(struct kobject *kobj, struct kobj_attribute *attr,
+			 const char *buf, size_t count);
+};
+
+struct kobject *kobject_create_and_add(const char *name, struct kobject *parent);
+
+#endif
+
+#endif
-- 
1.5.6.5
