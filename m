From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Mon,  9 Nov 2009 16:08:55 -0800
Subject: [Ocfs2-devel] [PATCH 2/4] ocfs2: Copy Makefiles from ocfs2-1.4
In-Reply-To: <1257811737-10835-1-git-send-email-sunil.mushran@oracle.com>
References: <1257811737-10835-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1257811737-10835-3-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/Makefile         |  212 ++++++++++++++++++++++++++++++++++-----------
 fs/ocfs2/cluster/Makefile |   89 ++++++++++++++++++-
 fs/ocfs2/dlm/Makefile     |  105 +++++++++++++++++++++-
 3 files changed, 347 insertions(+), 59 deletions(-)

diff --git a/fs/ocfs2/Makefile b/fs/ocfs2/Makefile
index 31f25ce..7438431 100644
--- a/fs/ocfs2/Makefile
+++ b/fs/ocfs2/Makefile
@@ -1,54 +1,164 @@
-EXTRA_CFLAGS += -Ifs/ocfs2
-
-EXTRA_CFLAGS += -DCATCH_BH_JBD_RACES
-
-obj-$(CONFIG_OCFS2_FS) += 	\
-	ocfs2.o			\
-	ocfs2_stackglue.o
-
-obj-$(CONFIG_OCFS2_FS_O2CB) += ocfs2_stack_o2cb.o
-obj-$(CONFIG_OCFS2_FS_USERSPACE_CLUSTER) += ocfs2_stack_user.o
-
-ocfs2-objs := \
-	alloc.o 		\
-	aops.o 			\
-	blockcheck.o		\
-	buffer_head_io.o	\
-	dcache.o 		\
-	dir.o 			\
-	dlmglue.o 		\
-	export.o 		\
-	extent_map.o 		\
-	file.o 			\
-	heartbeat.o 		\
-	inode.o 		\
-	ioctl.o 		\
-	journal.o 		\
-	localalloc.o 		\
-	locks.o			\
-	mmap.o 			\
-	namei.o 		\
-	refcounttree.o		\
-	resize.o		\
-	slot_map.o 		\
-	suballoc.o 		\
-	super.o 		\
-	symlink.o 		\
-	sysfile.o 		\
-	uptodate.o		\
-	ver.o			\
-	quota_local.o		\
-	quota_global.o		\
-	xattr.o
-
-ifeq ($(CONFIG_OCFS2_FS_POSIX_ACL),y)
-ocfs2-objs += acl.o
+
+ifeq ($(KERNELRELEASE),)
+TOPDIR = ../..
+
+include $(TOPDIR)/Preamble.make
+else
+# We are included by kbuild.
+
+OUR_TOPDIR	:= $(M)/..
+
+include $(OUR_TOPDIR)/Config.make
+
+endif
+
+COMPAT_SOURCES =
+COMPAT_HEADERS =
+SOURCES =
+HEADERS =
+
+EXTRA_CFLAGS += -I$(OUR_TOPDIR)/fs/ocfs2
+
+ifdef OCFS_DEBUG
+EXTRA_CFLAGS += -g
+EXTRA_CFLAGS += -DDEBUG
+endif
+
+EXTRA_CFLAGS += -DCATCH_BH_JBD_RACES -DOCFS2_ORACORE_WORKAROUNDS
+
+EXTRA_CFLAGS += -DOCFS2_CDSL
+
+EXTRA_CFLAGS += -DCONFIG_OCFS2_DEBUG_MASKLOG
+
+EXTRA_CFLAGS += -DCONFIG_OCFS2_FS_STATS
+
+#
+# Since SUBDIRS means something to kbuild, define them safely.  Do not
+# include trailing slashes.
+#
+SAFE_SUBDIRS = cluster dlm
+
+SOURCES +=			\
+	acl.c			\
+	alloc.c 		\
+	aops.c 			\
+	blockcheck.c		\
+	buffer_head_io.c	\
+	dcache.c 		\
+	dir.c 			\
+	dlmglue.c 		\
+	export.c		\
+	extent_map.c 		\
+	file.c 			\
+	heartbeat.c 		\
+	inode.c 		\
+	ioctl.c			\
+	journal.c 		\
+	localalloc.c 		\
+	locks.c			\
+	mmap.c 			\
+	namei.c 		\
+	quota_global.c		\
+	quota_local.c		\
+	resize.c		\
+	slot_map.c 		\
+	stackglue.c		\
+	stack_o2cb.c		\
+	stack_user.c		\
+	suballoc.c 		\
+	super.c 		\
+	symlink.c 		\
+	sysfile.c 		\
+	uptodate.c		\
+	ver.c			\
+	xattr.c
+
+HEADERS += 			\
+	acl.h			\
+	alloc.h			\
+	aops.h			\
+	blockcheck.h		\
+	buffer_head_io.h	\
+	dcache.h		\
+	dir.h			\
+	dlmglue.h		\
+	export.h		\
+	extent_map.h		\
+	file.h			\
+	heartbeat.h		\
+	inode.h			\
+	ioctl.h			\
+	journal.h		\
+	localalloc.h		\
+	locks.h			\
+	mmap.h			\
+	namei.h			\
+	ocfs1_fs_compat.h	\
+	ocfs2_fs.h		\
+	ocfs2.h			\
+	ocfs2_lockid.h		\
+	ocfs2_lockingver.h	\
+	quota.h			\
+	resize.h		\
+	slot_map.h		\
+	stackglue.h		\
+	suballoc.h		\
+	super.h			\
+	symlink.h		\
+	sysfile.h		\
+	uptodate.h		\
+	ver.h			\
+	xattr.h
+
+OBJECTS = $(subst .c,.o,$(SOURCES))
+VERSION_FILES = $(SOURCES) $(HEADERS) $(COMPAT_SOURCES) $(COMPAT_HEADERS)
+VERSION_SRC = ver.c
+VERSION_PREFIX = OCFS2
+
+INSTALL_MOD_DIR := fs/ocfs2
+
+obj-m := ocfs2.o
+
+ocfs2-objs := $(OBJECTS)
+
+ifneq ($(KERNELRELEASE),)
+#
+# Argh, Versioning.make has ordering requirements, so we put this here
+#
+STAMP_DIR	:= $(OUR_TOPDIR)/fs/ocfs2
+include $(OUR_TOPDIR)/Versioning.make
+CFLAGS_$(VERSION_OBJ) += $(VERDEFS)
+
+obj-m += $(addsuffix /,$(SAFE_SUBDIRS))
 endif
 
-ocfs2_stackglue-objs := stackglue.o
-ocfs2_stack_o2cb-objs := stack_o2cb.o
-ocfs2_stack_user-objs := stack_user.o
+ifeq ($(KERNELRELEASE),)
+#
+# Called from a regular "make". Just forward to kbuild.
+#
+
+DIST_FILES = $(SOURCES) $(HEADERS) $(COMPAT_SOURCES) $(COMPAT_HEADERS)
+
+ALL_RULES = stamp-md5 build-modules
+
+CLEAN_RULES = clean-modules
 
-# cluster/ is always needed when OCFS2_FS for masklog support
-obj-$(CONFIG_OCFS2_FS) += cluster/
-obj-$(CONFIG_OCFS2_FS_O2CB) += dlm/
+INSTALL_RULES = install-modules
+
+# Traverse subdirs via Makebo for "make dist"
+ifeq ($(MAKECMDGOALS),dist-all)
+SUBDIRS = $(SAFE_SUBDIRS)
+endif
+
+build-modules:
+	$(MAKE) -C $(TOPDIR)/fs build-modules
+
+install-modules:
+	$(MAKE) -C $(TOPDIR)/fs install-modules
+
+clean-modules:
+	$(MAKE) -C $(TOPDIR)/fs clean-modules
+
+include $(TOPDIR)/Postamble.make
+
+endif
diff --git a/fs/ocfs2/cluster/Makefile b/fs/ocfs2/cluster/Makefile
index bc8c5e7..fc5d3a0 100644
--- a/fs/ocfs2/cluster/Makefile
+++ b/fs/ocfs2/cluster/Makefile
@@ -1,4 +1,87 @@
-obj-$(CONFIG_OCFS2_FS) += ocfs2_nodemanager.o
 
-ocfs2_nodemanager-objs := heartbeat.o masklog.o sys.o nodemanager.o \
-	quorum.o tcp.o netdebug.o ver.o
+ifeq ($(KERNELRELEASE),)
+TOPDIR = ../../..
+
+include $(TOPDIR)/Preamble.make
+else
+# We are included by kbuild.
+
+OUR_TOPDIR	:= $(M)/..
+
+include $(OUR_TOPDIR)/Config.make
+endif
+
+COMPAT_SOURCES =
+COMPAT_HEADERS =
+SOURCES =
+HEADERS =
+
+EXTRA_CFLAGS += -DCONFIG_OCFS2_DEBUG_MASKLOG
+
+SOURCES +=			\
+	heartbeat.c		\
+	masklog.c		\
+	netdebug.c		\
+	nodemanager.c		\
+	quorum.c		\
+	sys.c			\
+	tcp.c			\
+	ver.c
+
+HEADERS += 			\
+	heartbeat.h		\
+	masklog.h		\
+	nodemanager.h		\
+	ocfs2_heartbeat.h	\
+	ocfs2_nodemanager.h	\
+	quorum.h		\
+	sys.h			\
+	tcp.h			\
+	tcp_internal.h		\
+	ver.h
+
+OBJECTS = $(subst .c,.o,$(SOURCES))
+VERSION_FILES = $(SOURCES) $(HEADERS) $(COMPAT_SOURCES) $(COMPAT_HEADERS)
+VERSION_SRC = ver.c
+VERSION_PREFIX = CLUSTER
+
+INSTALL_MOD_DIR := fs/ocfs2
+
+obj-m := ocfs2_nodemanager.o
+
+ocfs2_nodemanager-objs := $(OBJECTS)
+
+ifneq ($(KERNELRELEASE),)
+#
+# Argh, Versioning.make has ordering requirements, so we put this here
+#
+STAMP_DIR	:= $(OUR_TOPDIR)/fs/ocfs2/cluster
+include $(OUR_TOPDIR)/Versioning.make
+CFLAGS_$(VERSION_OBJ) += $(VERDEFS)
+endif
+
+ifeq ($(KERNELRELEASE),)
+#
+# Called from a regular "make". Just forward to kbuild.
+#
+
+DIST_FILES = $(SOURCES) $(HEADERS) $(COMPAT_SOURCES) $(COMPAT_HEADERS)
+
+ALL_RULES = stamp-md5 build-modules
+
+CLEAN_RULES = clean-modules
+
+INSTALL_RULES = install-modules
+
+build-modules:
+	$(MAKE) -C $(TOPDIR)/fs build-modules
+
+install-modules:
+	$(MAKE) -C $(TOPDIR)/fs install-modules
+
+clean-modules:
+	$(MAKE) -C $(TOPDIR)/fs clean-modules
+
+include $(TOPDIR)/Postamble.make
+
+endif
diff --git a/fs/ocfs2/dlm/Makefile b/fs/ocfs2/dlm/Makefile
index 1903613..26cbf6c 100644
--- a/fs/ocfs2/dlm/Makefile
+++ b/fs/ocfs2/dlm/Makefile
@@ -1,8 +1,103 @@
-EXTRA_CFLAGS += -Ifs/ocfs2
 
-obj-$(CONFIG_OCFS2_FS_O2CB) += ocfs2_dlm.o ocfs2_dlmfs.o
+ifeq ($(KERNELRELEASE),)
+TOPDIR = ../../..
 
-ocfs2_dlm-objs := dlmdomain.o dlmdebug.o dlmthread.o dlmrecovery.o \
-	dlmmaster.o dlmast.o dlmconvert.o dlmlock.o dlmunlock.o dlmver.o
+include $(TOPDIR)/Preamble.make
 
-ocfs2_dlmfs-objs := userdlm.o dlmfs.o dlmfsver.o
+else
+# We are included by kbuild.
+
+OUR_TOPDIR	:= $(M)/..
+
+include $(OUR_TOPDIR)/Config.make
+endif
+
+COMPAT_SOURCES =
+COMPAT_HEADERS =
+DLM_SOURCES =
+DLMFS_SOURCES =
+HEADERS =
+
+EXTRA_CFLAGS += -I$(OUR_TOPDIR)/fs/ocfs2
+
+EXTRA_CFLAGS += -DCONFIG_OCFS2_DEBUG_MASKLOG
+
+DLM_SOURCES +=			\
+	dlmast.c		\
+	dlmconvert.c		\
+	dlmdebug.c		\
+	dlmdomain.c		\
+	dlmlock.c		\
+	dlmmaster.c		\
+	dlmrecovery.c		\
+	dlmthread.c		\
+	dlmunlock.c		\
+	dlmver.c
+
+DLMFS_SOURCES += \
+	userdlm.c		\
+	dlmfs.c			\
+	dlmfsver.c
+
+HEADERS += 			\
+	dlmapi.h		\
+	dlmcommon.h		\
+	dlmconvert.h		\
+	dlmdebug.h		\
+	dlmdomain.h		\
+	dlmfsver.h		\
+	dlmver.h		\
+	userdlm.h
+
+DLM_OBJECTS = $(subst .c,.o,$(DLM_SOURCES))
+DLMFS_OBJECTS = $(subst .c,.o,$(DLMFS_SOURCES))
+
+VERSION_FILES = $(DLM_SOURCES) $(DLMFS_SOURCES) $(HEADERS) $(COMPAT_SOURCES) $(COMPAT_HEADERS)
+VERSION_SRC = dlmver.c dlmfsver.c
+VERSION_PREFIX = DLM
+
+INSTALL_MOD_DIR := fs/ocfs2
+
+obj-m := ocfs2_dlm.o ocfs2_dlmfs.o
+
+ocfs2_dlm-objs := $(DLM_OBJECTS)
+
+ocfs2_dlmfs-objs := $(DLMFS_OBJECTS)
+
+ifneq ($(KERNELRELEASE),)
+#
+# Argh, Versioning.make has ordering requirements, so we put this here
+#
+STAMP_DIR       := $(OUR_TOPDIR)/fs/ocfs2/dlm
+include $(OUR_TOPDIR)/Versioning.make
+endif
+
+# This has to be outside a conditional, because of a bug in make
+# It's harmless in the regular make case, as VERSION_OBJ will be empty
+$(foreach objfile,$(VERSION_OBJ),$(eval CFLAGS_$(objfile) += $(VERDEFS)))
+
+ifeq ($(KERNELRELEASE),)
+#
+# Called from a regular "make". Just forward to kbuild.
+#
+
+DIST_FILES = $(DLM_SOURCES) $(DLMFS_SOURCES) $(HEADERS) $(COMPAT_SOURCES) $(COMPAT_HEADERS)
+
+ALL_RULES = stamp-md5 build-modules
+
+CLEAN_RULES = clean-modules
+
+INSTALL_RULES = install-modules
+
+build-modules:
+	$(MAKE) -C $(TOPDIR)/fs build-modules
+
+install-modules:
+	$(MAKE) -C $(TOPDIR)/fs install-modules
+
+clean-modules:
+	$(MAKE) -C $(TOPDIR)/fs clean-modules
+
+include $(TOPDIR)/Postamble.make
+
+endif
-- 
1.5.6.5
