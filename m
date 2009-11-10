From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Mon,  9 Nov 2009 16:08:56 -0800
Subject: [Ocfs2-devel] [PATCH 3/4] ocfs2: Fix ocfs2 makefile
In-Reply-To: <1257811737-10835-1-git-send-email-sunil.mushran@oracle.com>
References: <1257811737-10835-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1257811737-10835-4-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Teach the makefile to handle stackglue and friends.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/Makefile |  115 ++++++++++++++++-------------------------------------
 1 files changed, 34 insertions(+), 81 deletions(-)

diff --git a/fs/ocfs2/Makefile b/fs/ocfs2/Makefile
index 7438431..8222d03 100644
--- a/fs/ocfs2/Makefile
+++ b/fs/ocfs2/Makefile
@@ -14,8 +14,12 @@ endif
 
 COMPAT_SOURCES =
 COMPAT_HEADERS =
-SOURCES =
-HEADERS =
+FS_SOURCES =
+FS_HEADERS =
+GLUE_SOURCES =
+GLUE_HEADERS =
+O2CB_SOURCES =
+USER_SOURCES =
 
 EXTRA_CFLAGS += -I$(OUR_TOPDIR)/fs/ocfs2
 
@@ -26,8 +30,6 @@ endif
 
 EXTRA_CFLAGS += -DCATCH_BH_JBD_RACES -DOCFS2_ORACORE_WORKAROUNDS
 
-EXTRA_CFLAGS += -DOCFS2_CDSL
-
 EXTRA_CFLAGS += -DCONFIG_OCFS2_DEBUG_MASKLOG
 
 EXTRA_CFLAGS += -DCONFIG_OCFS2_FS_STATS
@@ -38,88 +40,37 @@ EXTRA_CFLAGS += -DCONFIG_OCFS2_FS_STATS
 #
 SAFE_SUBDIRS = cluster dlm
 
-SOURCES +=			\
-	acl.c			\
-	alloc.c 		\
-	aops.c 			\
-	blockcheck.c		\
-	buffer_head_io.c	\
-	dcache.c 		\
-	dir.c 			\
-	dlmglue.c 		\
-	export.c		\
-	extent_map.c 		\
-	file.c 			\
-	heartbeat.c 		\
-	inode.c 		\
-	ioctl.c			\
-	journal.c 		\
-	localalloc.c 		\
-	locks.c			\
-	mmap.c 			\
-	namei.c 		\
-	quota_global.c		\
-	quota_local.c		\
-	resize.c		\
-	slot_map.c 		\
-	stackglue.c		\
-	stack_o2cb.c		\
-	stack_user.c		\
-	suballoc.c 		\
-	super.c 		\
-	symlink.c 		\
-	sysfile.c 		\
-	uptodate.c		\
-	ver.c			\
-	xattr.c
-
-HEADERS += 			\
-	acl.h			\
-	alloc.h			\
-	aops.h			\
-	blockcheck.h		\
-	buffer_head_io.h	\
-	dcache.h		\
-	dir.h			\
-	dlmglue.h		\
-	export.h		\
-	extent_map.h		\
-	file.h			\
-	heartbeat.h		\
-	inode.h			\
-	ioctl.h			\
-	journal.h		\
-	localalloc.h		\
-	locks.h			\
-	mmap.h			\
-	namei.h			\
-	ocfs1_fs_compat.h	\
-	ocfs2_fs.h		\
-	ocfs2.h			\
-	ocfs2_lockid.h		\
-	ocfs2_lockingver.h	\
-	quota.h			\
-	resize.h		\
-	slot_map.h		\
-	stackglue.h		\
-	suballoc.h		\
-	super.h			\
-	symlink.h		\
-	sysfile.h		\
-	uptodate.h		\
-	ver.h			\
-	xattr.h
-
-OBJECTS = $(subst .c,.o,$(SOURCES))
-VERSION_FILES = $(SOURCES) $(HEADERS) $(COMPAT_SOURCES) $(COMPAT_HEADERS)
+GLUE_SOURCES = stackglue.c
+GLUE_HEADERS = stackglue.h
+O2CB_SOURCES = stack_o2cb.c
+USER_SOURCES = stack_user.c
+
+FS_SOURCES += acl.c alloc.c aops.c blockcheck.c buffer_head_io.c dcache.c	\
+	dir.c dlmglue.c export.c extent_map.c file.c heartbeat.c inode.c	\
+	ioctl.c journal.c localalloc.c locks.c mmap.c namei.c quota_global.c	\
+	quota_local.c refcounttree.c resize.c slot_map.c suballoc.c super.c	\
+	symlink.c sysfile.c uptodate.c ver.c xattr.c
+
+FS_HEADERS += acl.h alloc.h aops.h blockcheck.h buffer_head_io.h dcache.h	\
+	dir.h dlmglue.h export.h extent_map.h file.h heartbeat.h inode.h	\
+	ioctl.h journal.h localalloc.h locks.h mmap.h namei.h ocfs1_fs_compat.h	\
+	ocfs2_fs.h ocfs2.h ocfs2_lockid.h ocfs2_lockingver.h quota.h		\
+	refcounttree.h resize.h slot_map.h suballoc.h super.h symlink.h		\
+	sysfile.h uptodate.h ver.h xattr.h
+
+FS_OBJECTS = $(subst .c,.o,$(FS_SOURCES))
+VERSION_FILES = $(FS_SOURCES) $(FS_HEADERS) $(COMPAT_SOURCES) $(COMPAT_HEADERS)
 VERSION_SRC = ver.c
 VERSION_PREFIX = OCFS2
 
 INSTALL_MOD_DIR := fs/ocfs2
 
-obj-m := ocfs2.o
+obj-m := ocfs2.o ocfs2_stackglue.o ocfs2_stack_o2cb.o ocfs2_stack_user.o
 
-ocfs2-objs := $(OBJECTS)
+ocfs2-objs := $(FS_OBJECTS)
+ocfs2_stackglue-objs := stackglue.o
+ocfs2_stack_o2cb-objs := stack_o2cb.o
+ocfs2_stack_user-objs := stack_user.o
 
 ifneq ($(KERNELRELEASE),)
 #
@@ -137,7 +88,9 @@ ifeq ($(KERNELRELEASE),)
 # Called from a regular "make". Just forward to kbuild.
 #
 
-DIST_FILES = $(SOURCES) $(HEADERS) $(COMPAT_SOURCES) $(COMPAT_HEADERS)
+DIST_FILES = $(FS_SOURCES) $(FS_HEADERS) $(COMPAT_SOURCES) $(COMPAT_HEADERS) \
+		$(GLUE_SOURCES) $(GLUE_HEADERS) $(O2CB_SOURCES) $(O2CB_HEADERS) \
+		$(USER_SOURCES) $(USER_HEADERS)
 
 ALL_RULES = stamp-md5 build-modules
 
-- 
1.5.6.5
