From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu, 12 Nov 2009 17:47:24 -0800
Subject: [Ocfs2-devel] [PATCH 03/18] ocfs2: Handle missing dtor in
	kmem_cache_create()
In-Reply-To: <1258076859-13538-1-git-send-email-sunil.mushran@oracle.com>
References: <1258076859-13538-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1258076859-13538-4-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mainline commit 20c2df83d25c6a95affe6157a4c9cac4cf5ffaac removed the
dtor arg from kmem_cache_create(). Patch adds a kapi macro that adds
a dtor arg when building against EL5 kernels.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 Config.make.in              |    1 +
 Makefile                    |    3 ++-
 configure.in                |    6 ++++++
 fs/ocfs2/Makefile           |    4 ++++
 fs/ocfs2/dlm/Makefile       |    4 ++++
 fs/ocfs2/dlm/dlmfs.c        |    7 ++++++-
 fs/ocfs2/dlm/dlmlock.c      |    2 +-
 fs/ocfs2/dlm/dlmmaster.c    |    6 +++---
 fs/ocfs2/dlm/kapi-default.h |    4 ++++
 fs/ocfs2/kapi-default.h     |    4 ++++
 fs/ocfs2/super.c            |   11 ++++++++---
 fs/ocfs2/uptodate.c         |    2 +-
 kapi-compat/include/slab.h  |    8 ++++++++
 13 files changed, 52 insertions(+), 10 deletions(-)
 create mode 100644 kapi-compat/include/slab.h

diff --git a/Config.make.in b/Config.make.in
index a19d096..fb705b5 100644
--- a/Config.make.in
+++ b/Config.make.in
@@ -72,6 +72,7 @@ VMOP_IS_NOT_CONST = @VMOP_IS_NOT_CONST@
 SEQOP_IS_NOT_CONST = @SEQOP_IS_NOT_CONST@
 NO_VECTORIZED_AIO = @NO_VECTORIZED_AIO@
 OLD_PERMISSION = @OLD_PERMISSION@
+KMEM_CACHE_CREATE_DTOR = @KMEM_CACHE_CREATE_DTOR@
 
 
 OCFS_DEBUG = @OCFS_DEBUG@
diff --git a/Makefile b/Makefile
index adaf9fb..912fb70 100644
--- a/Makefile
+++ b/Makefile
@@ -23,7 +23,8 @@ KAPI_COMPAT_FILES = \
 	kapi-compat/include/fsuid.h			\
 	kapi-compat/include/umh_wait.h			\
 	kapi-compat/include/register_sysctl.h		\
-	kapi-compat/include/sysctl.h
+	kapi-compat/include/sysctl.h			\
+	kapi-compat/include/slab.h
 
 PATCH_FILES =
 
diff --git a/configure.in b/configure.in
index b662f88..98cdc5d 100644
--- a/configure.in
+++ b/configure.in
@@ -328,6 +328,12 @@ OCFS2_CHECK_KERNEL([enum FS_OCFS2 in sysctl.h], sysctl.h,
   , sysctl_compat_header=sysctl.h, [FS_OCFS2=])
 KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS $sysctl_compat_header"
 
+KMEM_CACHE_CREATE_DTOR=
+OCFS2_CHECK_KERNEL([	older prototype of kmem_cache_create() in slab.h], slab.h,
+  KMEM_CACHE_CREATE_DTOR=slab.h, , [^.*void (\*)(void \*, kmem_cache_t \*, unsigned long),])
+AC_SUBST(KMEM_CACHE_CREATE_DTOR)
+KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS $KMEM_CACHE_CREATE_DTOR"
+
 # End kapi_compat checks
 
 # using -include has two advantages:
diff --git a/fs/ocfs2/Makefile b/fs/ocfs2/Makefile
index 32d864d..c769fd8 100644
--- a/fs/ocfs2/Makefile
+++ b/fs/ocfs2/Makefile
@@ -92,6 +92,10 @@ ifdef OLD_PERMISSION
 EXTRA_CFLAGS += -DOLD_PERMISSION
 endif
 
+ifdef KMEM_CACHE_CREATE_DTOR
+EXTRA_CFLAGS += -DKMEM_CACHE_CREATE_DTOR
+endif
+
 #
 # Since SUBDIRS means something to kbuild, define them safely.  Do not
 # include trailing slashes.
diff --git a/fs/ocfs2/dlm/Makefile b/fs/ocfs2/dlm/Makefile
index 0c4d1f4..907e390 100644
--- a/fs/ocfs2/dlm/Makefile
+++ b/fs/ocfs2/dlm/Makefile
@@ -42,6 +42,10 @@ ifdef SEQOP_IS_NOT_CONST
 EXTRA_CFLAGS += -DSEQOP_IS_NOT_CONST
 endif
 
+ifdef KMEM_CACHE_CREATE_DTOR
+EXTRA_CFLAGS += -DKMEM_CACHE_CREATE_DTOR
+endif
+
 DLM_SOURCES +=			\
 	dlmast.c		\
 	dlmconvert.c		\
diff --git a/fs/ocfs2/dlm/dlmfs.c b/fs/ocfs2/dlm/dlmfs.c
index d05653d..6d97173 100644
--- a/fs/ocfs2/dlm/dlmfs.c
+++ b/fs/ocfs2/dlm/dlmfs.c
@@ -277,7 +277,12 @@ static ssize_t dlmfs_file_write(struct file *filp,
 	return writelen;
 }
 
+#ifdef KMEM_CACHE_CREATE_DTOR
+static void dlmfs_init_once(void *foo, struct kmem_cache *cachep,
+			    unsigned long flags)
+#else
 static void dlmfs_init_once(void *foo)
+#endif
 {
 	struct dlmfs_inode_private *ip =
 		(struct dlmfs_inode_private *) foo;
@@ -628,7 +633,7 @@ static int __init init_dlmfs_fs(void)
 	if (status)
 		return status;
 
-	dlmfs_inode_cache = kmem_cache_create("dlmfs_inode_cache",
+	dlmfs_inode_cache = kapi_kmem_cache_create("dlmfs_inode_cache",
 				sizeof(struct dlmfs_inode_private),
 				0, (SLAB_HWCACHE_ALIGN|SLAB_RECLAIM_ACCOUNT|
 					SLAB_MEM_SPREAD),
diff --git a/fs/ocfs2/dlm/dlmlock.c b/fs/ocfs2/dlm/dlmlock.c
index 437698e..98840f9 100644
--- a/fs/ocfs2/dlm/dlmlock.c
+++ b/fs/ocfs2/dlm/dlmlock.c
@@ -67,7 +67,7 @@ static void dlm_lock_detach_lockres(struct dlm_lock *lock);
 
 int dlm_init_lock_cache(void)
 {
-	dlm_lock_cache = kmem_cache_create("o2dlm_lock",
+	dlm_lock_cache = kapi_kmem_cache_create("o2dlm_lock",
 					   sizeof(struct dlm_lock),
 					   0, SLAB_HWCACHE_ALIGN, NULL);
 	if (dlm_lock_cache == NULL)
diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
index 83bcaf2..90d3157 100644
--- a/fs/ocfs2/dlm/dlmmaster.c
+++ b/fs/ocfs2/dlm/dlmmaster.c
@@ -406,7 +406,7 @@ static void dlm_mle_node_up(struct dlm_ctxt *dlm,
 
 int dlm_init_mle_cache(void)
 {
-	dlm_mle_cache = kmem_cache_create("o2dlm_mle",
+	dlm_mle_cache = kapi_kmem_cache_create("o2dlm_mle",
 					  sizeof(struct dlm_master_list_entry),
 					  0, SLAB_HWCACHE_ALIGN,
 					  NULL);
@@ -457,13 +457,13 @@ static void dlm_mle_release(struct kref *kref)
 
 int dlm_init_master_caches(void)
 {
-	dlm_lockres_cache = kmem_cache_create("o2dlm_lockres",
+	dlm_lockres_cache = kapi_kmem_cache_create("o2dlm_lockres",
 					      sizeof(struct dlm_lock_resource),
 					      0, SLAB_HWCACHE_ALIGN, NULL);
 	if (!dlm_lockres_cache)
 		goto bail;
 
-	dlm_lockname_cache = kmem_cache_create("o2dlm_lockname",
+	dlm_lockname_cache = kapi_kmem_cache_create("o2dlm_lockname",
 					       DLM_LOCKID_NAME_MAX, 0,
 					       SLAB_HWCACHE_ALIGN, NULL);
 	if (!dlm_lockname_cache)
diff --git a/fs/ocfs2/dlm/kapi-default.h b/fs/ocfs2/dlm/kapi-default.h
index 21e5e3a..bcdb486 100644
--- a/fs/ocfs2/dlm/kapi-default.h
+++ b/fs/ocfs2/dlm/kapi-default.h
@@ -29,4 +29,8 @@ typedef struct work_struct kapi_work_struct_t;
 # define KAPI_INIT_DELAYED_WORK(a, b, c)	INIT_DELAYED_WORK(a, b)
 #endif
 
+#ifndef kapi_kmem_cache_create
+# define kapi_kmem_cache_create(a, b, c, d, e)	kmem_cache_create(a, b, c, d, e)
+#endif
+
 #endif
diff --git a/fs/ocfs2/kapi-default.h b/fs/ocfs2/kapi-default.h
index 7489a19..2f60b87 100644
--- a/fs/ocfs2/kapi-default.h
+++ b/fs/ocfs2/kapi-default.h
@@ -50,4 +50,8 @@ typedef u64 f_version_t;
 # define kapi_register_sysctl_table(a)	register_sysctl_table(a)
 #endif
 
+#ifndef kapi_kmem_cache_create
+# define kapi_kmem_cache_create(a, b, c, d, e)	kmem_cache_create(a, b, c, d, e)
+#endif
+
 #endif
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index bee2c31..e36bec2 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1671,7 +1671,12 @@ bail:
 	return status;
 }
 
+#ifdef KMEM_CACHE_CREATE_DTOR
+static void ocfs2_inode_init_once(void *data, struct kmem_cache *cachep,
+				  unsigned long flags)
+#else
 static void ocfs2_inode_init_once(void *data)
+#endif
 {
 	struct ocfs2_inode_info *oi = data;
 
@@ -1701,19 +1706,19 @@ static void ocfs2_inode_init_once(void *data)
 
 static int ocfs2_initialize_mem_caches(void)
 {
-	ocfs2_inode_cachep = kmem_cache_create("ocfs2_inode_cache",
+	ocfs2_inode_cachep = kapi_kmem_cache_create("ocfs2_inode_cache",
 				       sizeof(struct ocfs2_inode_info),
 				       0,
 				       (SLAB_HWCACHE_ALIGN|SLAB_RECLAIM_ACCOUNT|
 						SLAB_MEM_SPREAD),
 				       ocfs2_inode_init_once);
-	ocfs2_dquot_cachep = kmem_cache_create("ocfs2_dquot_cache",
+	ocfs2_dquot_cachep = kapi_kmem_cache_create("ocfs2_dquot_cache",
 					sizeof(struct ocfs2_dquot),
 					0,
 					(SLAB_HWCACHE_ALIGN|SLAB_RECLAIM_ACCOUNT|
 						SLAB_MEM_SPREAD),
 					NULL);
-	ocfs2_qf_chunk_cachep = kmem_cache_create("ocfs2_qf_chunk_cache",
+	ocfs2_qf_chunk_cachep = kapi_kmem_cache_create("ocfs2_qf_chunk_cache",
 					sizeof(struct ocfs2_quota_chunk),
 					0,
 					(SLAB_RECLAIM_ACCOUNT|SLAB_MEM_SPREAD),
diff --git a/fs/ocfs2/uptodate.c b/fs/ocfs2/uptodate.c
index b6284f2..fe57890 100644
--- a/fs/ocfs2/uptodate.c
+++ b/fs/ocfs2/uptodate.c
@@ -625,7 +625,7 @@ void ocfs2_remove_xattr_clusters_from_cache(struct ocfs2_caching_info *ci,
 
 int __init init_ocfs2_uptodate_cache(void)
 {
-	ocfs2_uptodate_cachep = kmem_cache_create("ocfs2_uptodate",
+	ocfs2_uptodate_cachep = kapi_kmem_cache_create("ocfs2_uptodate",
 				  sizeof(struct ocfs2_meta_cache_item),
 				  0, SLAB_HWCACHE_ALIGN, NULL);
 	if (!ocfs2_uptodate_cachep)
diff --git a/kapi-compat/include/slab.h b/kapi-compat/include/slab.h
new file mode 100644
index 0000000..c682289
--- /dev/null
+++ b/kapi-compat/include/slab.h
@@ -0,0 +1,8 @@
+#ifndef KAPI_SLAB_H
+#define KAPI_SLAB_H
+
+#ifdef KMEM_CACHE_CREATE_DTOR
+# define kapi_kmem_cache_create(a, b, c, d, e)	kmem_cache_create(a, b, c, d, e, NULL)
+#endif
+
+#endif
-- 
1.5.6.5
