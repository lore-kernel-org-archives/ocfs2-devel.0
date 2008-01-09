From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Wed Jan  9 18:00:02 2008
Subject: [Ocfs2-devel] [PATCH 12/30] ocfs2: Handle missing dtors in
	kmem_cache_create()
In-Reply-To: <1199930370-17076-1-git-send-email-sunil.mushran@oracle.com>
References: <1199930370-17076-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1199930370-17076-11-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Commit 20c2df83d25c6a95affe6157a4c9cac4cf5ffaac removed the dtor arg
from kmem_cache_create(). This patch allows one to build ocfs2 with
kernels having/not having this change.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
---
 Config.make.in             |    1 +
 Makefile                   |    3 ++-
 configure.in               |    6 ++++++
 fs/ocfs2/Makefile          |    4 ++++
 fs/ocfs2/dlm/Makefile      |    4 ++++
 fs/ocfs2/dlm/dlmfs.c       |    2 +-
 fs/ocfs2/dlm/dlmmaster.c   |    2 +-
 fs/ocfs2/super.c           |    2 +-
 fs/ocfs2/uptodate.c        |    2 +-
 kapi-compat/include/slab.h |   10 ++++++++++
 10 files changed, 31 insertions(+), 5 deletions(-)
 create mode 100644 kapi-compat/include/slab.h

diff --git a/Config.make.in b/Config.make.in
index 0fdbad0..c5631b6 100644
--- a/Config.make.in
+++ b/Config.make.in
@@ -62,6 +62,7 @@ NO_DELAYED_WORK_STRUCT = @NO_DELAYED_WORK_STRUCT@
 NO_SYNC_MAPPING_RANGE  = @NO_SYNC_MAPPING_RANGE@
 NO_FAULT_IN_VMOPS = @NO_FAULT_IN_VMOPS@
 NO_F_PATH_IN_STRUCT_FILE = @NO_F_PATH_IN_STRUCT_FILE@
+KMEM_CACHE_CREATE_DTOR = @KMEM_CACHE_CREATE_DTOR@
 
 OCFS_DEBUG = @OCFS_DEBUG@
 
diff --git a/Makefile b/Makefile
index d201b85..23af453 100644
--- a/Makefile
+++ b/Makefile
@@ -16,7 +16,8 @@ KAPI_COMPAT_FILES = \
 	kapi-compat/include/fpath.h \
 	kapi-compat/include/umh_wait.h \
 	kapi-compat/include/inc_nlink.h \
-	kapi-compat/include/drop_nlink.h
+	kapi-compat/include/drop_nlink.h \
+	kapi-compat/include/slab.h
 
 PATCH_FILES =
 
diff --git a/configure.in b/configure.in
index f9b0a70..2ce14ed 100644
--- a/configure.in
+++ b/configure.in
@@ -204,6 +204,12 @@ OCFS2_CHECK_KERNEL([drop_nlink() in fs.h], fs.h,
   , drop_nlink_compat_header="drop_nlink.h", [^static inline void drop_nlink(])
 KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS $drop_nlink_compat_header"
 
+KMEM_CACHE_CREATE_DTOR=
+OCFS2_CHECK_KERNEL([kmem_cache_create() with dtor arg in slab.h], slab.h,
+  KMEM_CACHE_CREATE_DTOR=yes, , [^.*void (\*)(void \*, kmem_cache_t \*, unsigned long),])
+AC_SUBST(KMEM_CACHE_CREATE_DTOR)
+KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS slab.h"
+
 # using -include has two advantages:
 #  the source doesn't need to know to include compat headers
 #  the compat header file names don't go through the search path
diff --git a/fs/ocfs2/Makefile b/fs/ocfs2/Makefile
index 8733e21..456b24b 100644
--- a/fs/ocfs2/Makefile
+++ b/fs/ocfs2/Makefile
@@ -48,6 +48,10 @@ ifdef NO_F_PATH_IN_STRUCT_FILE
 EXTRA_CFLAGS += -DNO_F_PATH_IN_STRUCT_FILE
 endif
 
+ifdef KMEM_CACHE_CREATE_DTOR
+EXTRA_CFLAGS += -DKMEM_CACHE_CREATE_DTOR
+endif
+
 #
 # Since SUBDIRS means something to kbuild, define them safely.  Do not
 # include trailing slashes.
diff --git a/fs/ocfs2/dlm/Makefile b/fs/ocfs2/dlm/Makefile
index cd8b237..31f312e 100644
--- a/fs/ocfs2/dlm/Makefile
+++ b/fs/ocfs2/dlm/Makefile
@@ -30,6 +30,10 @@ ifdef NO_F_PATH_IN_STRUCT_FILE
 EXTRA_CFLAGS += -DNO_F_PATH_IN_STRUCT_FILE
 endif
 
+ifdef KMEM_CACHE_CREATE_DTOR
+EXTRA_CFLAGS += -DKMEM_CACHE_CREATE_DTOR
+endif
+
 DLM_SOURCES +=			\
 	dlmast.c		\
 	dlmconvert.c		\
diff --git a/fs/ocfs2/dlm/dlmfs.c b/fs/ocfs2/dlm/dlmfs.c
index 0284cdb..78704a1 100644
--- a/fs/ocfs2/dlm/dlmfs.c
+++ b/fs/ocfs2/dlm/dlmfs.c
@@ -588,7 +588,7 @@ static int __init init_dlmfs_fs(void)
 
 	dlmfs_print_version();
 
-	dlmfs_inode_cache = kmem_cache_create("dlmfs_inode_cache",
+	dlmfs_inode_cache = kapi_kmem_cache_create("dlmfs_inode_cache",
 				sizeof(struct dlmfs_inode_private),
 				0, (SLAB_HWCACHE_ALIGN|SLAB_RECLAIM_ACCOUNT|
 					SLAB_MEM_SPREAD),
diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
index 62e4a7d..a668840 100644
--- a/fs/ocfs2/dlm/dlmmaster.c
+++ b/fs/ocfs2/dlm/dlmmaster.c
@@ -507,7 +507,7 @@ static void dlm_mle_node_up(struct dlm_ctxt *dlm,
 
 int dlm_init_mle_cache(void)
 {
-	dlm_mle_cache = kmem_cache_create("dlm_mle_cache",
+	dlm_mle_cache = kapi_kmem_cache_create("dlm_mle_cache",
 					  sizeof(struct dlm_master_list_entry),
 					  0, SLAB_HWCACHE_ALIGN,
 					  NULL);
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index a8f90a2..f5c424d 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1033,7 +1033,7 @@ static void ocfs2_inode_init_once(void *data,
 
 static int ocfs2_initialize_mem_caches(void)
 {
-	ocfs2_inode_cachep = kmem_cache_create("ocfs2_inode_cache",
+	ocfs2_inode_cachep = kapi_kmem_cache_create("ocfs2_inode_cache",
 				       sizeof(struct ocfs2_inode_info),
 				       0,
 				       (SLAB_HWCACHE_ALIGN|SLAB_RECLAIM_ACCOUNT|
diff --git a/fs/ocfs2/uptodate.c b/fs/ocfs2/uptodate.c
index 4da8851..6248308 100644
--- a/fs/ocfs2/uptodate.c
+++ b/fs/ocfs2/uptodate.c
@@ -546,7 +546,7 @@ void ocfs2_remove_from_cache(struct inode *inode,
 
 int __init init_ocfs2_uptodate_cache(void)
 {
-	ocfs2_uptodate_cachep = kmem_cache_create("ocfs2_uptodate",
+	ocfs2_uptodate_cachep = kapi_kmem_cache_create("ocfs2_uptodate",
 				  sizeof(struct ocfs2_meta_cache_item),
 				  0, SLAB_HWCACHE_ALIGN, NULL);
 	if (!ocfs2_uptodate_cachep)
diff --git a/kapi-compat/include/slab.h b/kapi-compat/include/slab.h
new file mode 100644
index 0000000..239763f
--- /dev/null
+++ b/kapi-compat/include/slab.h
@@ -0,0 +1,10 @@
+#ifndef KAPI_SLAB_H
+#define KAPI_SLAB_H
+
+#ifdef KMEM_CACHE_CREATE_DTOR
+#define kapi_kmem_cache_create(a, b, c, d, e)	kmem_cache_create(a, b, c, d, e, NULL)
+#else
+#define kapi_kmem_cache_create(a, b, c, d, e)	kmem_cache_create(a, b, c, d, e)
+#endif
+
+#endif
-- 
1.5.2.5
