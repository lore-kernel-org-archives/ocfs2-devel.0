From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu Jan  3 11:21:56 2008
Subject: [Ocfs2-devel] [PATCH 18/30] ocfs2: Handle the removal of struct
	subsystem
In-Reply-To: <1199388006-32658-1-git-send-email-sunil.mushran@oracle.com>
References: <1199388006-32658-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1199388006-32658-17-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Commit 823bccfc4002296ba88c3ad0f049e1abd8108d30 in mainline removes struct
subsystem from kobject.h. This patch allows one to build ocfs2 with kernels
having/not having this change.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 Config.make.in                |    1 +
 Makefile                      |    3 ++-
 configure.in                  |    6 ++++++
 fs/ocfs2/Makefile             |    4 ++++
 fs/ocfs2/cluster/Makefile     |    4 ++++
 fs/ocfs2/cluster/masklog.c    |    2 +-
 fs/ocfs2/cluster/sys.c        |    8 ++++----
 fs/ocfs2/dlm/Makefile         |    4 ++++
 kapi-compat/include/kobject.h |   12 ++++++++++++
 9 files changed, 38 insertions(+), 6 deletions(-)
 create mode 100644 kapi-compat/include/kobject.h

diff --git a/Config.make.in b/Config.make.in
index b12623a..34c4825 100644
--- a/Config.make.in
+++ b/Config.make.in
@@ -65,6 +65,7 @@ NO_F_PATH_IN_STRUCT_FILE = @NO_F_PATH_IN_STRUCT_FILE@
 KMEM_CACHE_CREATE_DTOR = @KMEM_CACHE_CREATE_DTOR@
 REGISTER_SYSCTL_TWO_ARGS = @REGISTER_SYSCTL_TWO_ARGS@
 NO_SU_MUTEX_IN_STRUCT_CONFIGFS_SUBSYSTEM = @NO_SU_MUTEX_IN_STRUCT_CONFIGFS_SUBSYSTEM@
+STRUCT_SUBSYSTEM_DEFINED = @STRUCT_SUBSYSTEM_DEFINED@
 
 OCFS_DEBUG = @OCFS_DEBUG@
 
diff --git a/Makefile b/Makefile
index 1ecedd2..b035e29 100644
--- a/Makefile
+++ b/Makefile
@@ -22,7 +22,8 @@ KAPI_COMPAT_FILES = \
 	kapi-compat/include/sysctl.h \
 	kapi-compat/include/configfs.h \
 	kapi-compat/include/register_sysctl.h \
-	kapi-compat/include/su_mutex.h
+	kapi-compat/include/su_mutex.h \
+	kapi-compat/include/kobject.h
 
 PATCH_FILES =
 
diff --git a/configure.in b/configure.in
index 034f104..4164a42 100644
--- a/configure.in
+++ b/configure.in
@@ -237,6 +237,12 @@ OCFS2_CHECK_KERNEL([su_mutex in struct configfs_subsystem in configfs.h], config
 AC_SUBST(NO_SU_MUTEX_IN_STRUCT_CONFIGFS_SUBSYSTEM)
 KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS su_mutex.h"
 
+STRUCT_SUBSYSTEM_DEFINED=
+OCFS2_CHECK_KERNEL([struct subsystem in kobject.h], kobject.h,
+  STRUCT_SUBSYSTEM_DEFINED=yes, , [^struct subsystem {])
+AC_SUBST(STRUCT_SUBSYSTEM_DEFINED)
+KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS kobject.h"
+
 # using -include has two advantages:
 #  the source doesn't need to know to include compat headers
 #  the compat header file names don't go through the search path
diff --git a/fs/ocfs2/Makefile b/fs/ocfs2/Makefile
index 1924d5c..2511fba 100644
--- a/fs/ocfs2/Makefile
+++ b/fs/ocfs2/Makefile
@@ -45,6 +45,10 @@ ifdef KMEM_CACHE_CREATE_DTOR
 EXTRA_CFLAGS += -DKMEM_CACHE_CREATE_DTOR
 endif
 
+ifdef STRUCT_SUBSYSTEM_DEFINED
+EXTRA_CFLAGS += -DSTRUCT_SUBSYSTEM_DEFINED
+endif
+
 #
 # Since SUBDIRS means something to kbuild, define them safely.  Do not
 # include trailing slashes.
diff --git a/fs/ocfs2/cluster/Makefile b/fs/ocfs2/cluster/Makefile
index 671104a..512bfa1 100644
--- a/fs/ocfs2/cluster/Makefile
+++ b/fs/ocfs2/cluster/Makefile
@@ -25,6 +25,10 @@ ifdef NO_SU_MUTEX_IN_STRUCT_CONFIGFS_SUBSYSTEM
 EXTRA_CFLAGS += -DNO_SU_MUTEX_IN_STRUCT_CONFIGFS_SUBSYSTEM
 endif
 
+ifdef STRUCT_SUBSYSTEM_DEFINED
+EXTRA_CFLAGS += -DSTRUCT_SUBSYSTEM_DEFINED
+endif
+
 SOURCES =			\
 	heartbeat.c		\
 	masklog.c		\
diff --git a/fs/ocfs2/cluster/masklog.c b/fs/ocfs2/cluster/masklog.c
index e9e042b..ced6c35 100644
--- a/fs/ocfs2/cluster/masklog.c
+++ b/fs/ocfs2/cluster/masklog.c
@@ -156,7 +156,7 @@ int mlog_sys_init(struct kset *o2cb_subsys)
 	}
 	mlog_attr_ptrs[i] = NULL;
 
-	kobj_set_kset_s(&mlog_kset, *o2cb_subsys);
+	kobj_set_kset_s(&mlog_kset, kapi_subsystem(o2cb_subsys));
 	return kset_register(&mlog_kset);
 }
 
diff --git a/fs/ocfs2/cluster/sys.c b/fs/ocfs2/cluster/sys.c
index 64f6f37..c3e4131 100644
--- a/fs/ocfs2/cluster/sys.c
+++ b/fs/ocfs2/cluster/sys.c
@@ -80,7 +80,7 @@ o2cb_show(struct kobject * kobj, struct attribute * attr, char * buffer)
 	struct o2cb_attribute *o2cb_attr = to_o2cb_attr(attr);
 	struct kset *sbs = to_kset(kobj);
 
-	BUG_ON(sbs != &o2cb_subsys);
+	BUG_ON(sbs != kapi_subsystem_kset(&o2cb_subsys));
 
 	if (o2cb_attr->show)
 		return o2cb_attr->show(buffer);
@@ -94,7 +94,7 @@ o2cb_store(struct kobject * kobj, struct attribute * attr,
 	struct o2cb_attribute *o2cb_attr = to_o2cb_attr(attr);
 	struct kset *sbs = to_kset(kobj);
 
-	BUG_ON(sbs != &o2cb_subsys);
+	BUG_ON(sbs != kapi_subsystem_kset(&o2cb_subsys));
 
 	if (o2cb_attr->store)
 		return o2cb_attr->store(buffer, count);
@@ -111,12 +111,12 @@ int o2cb_sys_init(void)
 {
 	int ret;
 
-	o2cb_subsys.kobj.ktype = &o2cb_subsys_type;
+	kapi_subsystem_kset(&o2cb_subsys)->kobj.ktype = &o2cb_subsys_type;
 	ret = subsystem_register(&o2cb_subsys);
 	if (ret)
 		return ret;
 
-	ret = mlog_sys_init(&o2cb_subsys);
+	ret = mlog_sys_init(kapi_subsystem_kset(&o2cb_subsys));
 	if (ret)
 		subsystem_unregister(&o2cb_subsys);
 	return ret;
diff --git a/fs/ocfs2/dlm/Makefile b/fs/ocfs2/dlm/Makefile
index f8a5376..76d794b 100644
--- a/fs/ocfs2/dlm/Makefile
+++ b/fs/ocfs2/dlm/Makefile
@@ -28,6 +28,10 @@ ifdef KMEM_CACHE_CREATE_DTOR
 EXTRA_CFLAGS += -DKMEM_CACHE_CREATE_DTOR
 endif
 
+ifdef STRUCT_SUBSYSTEM_DEFINED
+EXTRA_CFLAGS += -DSTRUCT_SUBSYSTEM_DEFINED
+endif
+
 DLM_SOURCES =			\
 	dlmast.c		\
 	dlmconvert.c		\
diff --git a/kapi-compat/include/kobject.h b/kapi-compat/include/kobject.h
new file mode 100644
index 0000000..c613868
--- /dev/null
+++ b/kapi-compat/include/kobject.h
@@ -0,0 +1,12 @@
+#ifndef KAPI_KOBJECT_H
+#define KAPI_KOBJECT_H
+
+#ifdef STRUCT_SUBSYSTEM_DEFINED
+# define kapi_subsystem_kset(_sub)	(&((_sub)->kset))
+# define kapi_subsystem(_sub)		*((struct subsystem *)(_sub))
+#else
+# define kapi_subsystem_kset(_sub)	(_sub)
+# define kapi_subsystem(_sub)		(_sub)
+#endif
+
+#endif
-- 
1.5.2.5
