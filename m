From: John L. Villalovos <john.l.villalovos@intel.com>
Date: Fri Feb 27 16:52:40 2004
Subject: [Ocfs2-devel] Makefile and configure changes for 2.6 support
Message-ID: <403FCA30.6090807@intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This is a cumulative patch to provide support to the build system for building OCFS2 for 2.6.

This does NOT have the patches that are needed to the source code files to make them build under 2.6.

It only consists of changes to:
Config.make.in
configure.in
src/Makefile

and the addition of:
src/Makefile-2.6.in

Thanks,
John



Index: Config.make.in
===================================================================
--- Config.make.in	(revision 36)
+++ Config.make.in	(working copy)
@@ -58,5 +58,6 @@
  OCFS_MEMDEBUG = @OCFS_MEMDEBUG@
  OCFS_TRACE = @OCFS_TRACE@
  OCFS_PROCESSOR = @OCFS_PROCESSOR@
+OCFS_KERNEL_2_6 = @OCFS_KERNEL_2_6@

  USE_JOURNAL_CREATE_REPLACEMENT = @USE_JOURNAL_CREATE_REPLACEMENT@
Index: configure.in
===================================================================
--- configure.in	(revision 36)
+++ configure.in	(working copy)
@@ -83,6 +83,13 @@
    AC_MSG_ERROR(GCC is required)
  fi

+AC_ARG_ENABLE(kernel-2_6, AS_HELP_STRING([--enable-kernel-2_6], [(BROKEN!) Enable building on Linux kernel version 2.6.x (default=no)]),enable_kernel26=yes,enable_kernel26=no)
+OCFS_KERNEL_2_6=
+if test "x$enable_kernel26" = "xyes"; then
+  OCFS_KERNEL_2_6=yes
+fi
+AC_SUBST(OCFS_KERNEL_2_6)
+
  AC_ARG_ENABLE(debug, [  --enable-debug=[yes/no]         Turn on debugging [default=yes]],,enable_debug=yes)
  OCFS_DEBUG=
  if test "x$enable_debug" = "xyes"; then
@@ -178,6 +185,13 @@
  case "$kversion" in
    2.4.*)
      ;;
+  2.6.*)
+    if test "x$enable_kernel26" = "xyes"; then
+      AC_MSG_NOTICE([Support for kernel version 2.6 is BROKEN at this time!])
+    else
+      AC_MSG_ERROR([Support for kernel version 2.6 is BROKEN (System Hangs) at this time!  You must use --enable-kernel-2_6 to get past this point.])
+    fi
+    ;;
    *)
      AC_MSG_ERROR([This module only supports kernel version 2.4.x])
      ;;
@@ -304,6 +318,9 @@
  GCCINC=$gccdir
  AC_SUBST(GCCINC)

+OCFS_BUILD_DIR=`pwd`
+AC_SUBST(OCFS_BUILD_DIR)
+
  AC_OUTPUT([Config.make
  vendor/redhat/ocfs2-2.4.9-e.spec
  vendor/redhat/ocfs2-2.4.18-e.spec
@@ -314,4 +331,5 @@
  vendor/unitedlinux/ocfs2-2.4.21-107.spec
  vendor/unitedlinux/ocfs2-2.4.21-111.spec
  vendor/unitedlinux/ocfs2-2.4.21-138.spec
+src/Makefile-2.6
  ])
Index: src/Makefile
===================================================================
--- src/Makefile	(revision 36)
+++ src/Makefile	(working copy)
@@ -1,3 +1,8 @@
+# 2.6 Kernel stuff
+ifneq "$(KERNELRELEASE)" ""
+include $(obj)/Makefile-2.6
+else
+
  TOPDIR = ..

  include $(TOPDIR)/Preamble.make
@@ -2,2 +7,5 @@

+# Preliminary 2.6.x kernel support
+ifndef OCFS_KERNEL_2_6
+
  WARNINGS = -Wall -Wstrict-prototypes -Wno-format
@@ -199,4 +207,9 @@
  dist-subdircreate:
  	$(TOPDIR)/mkinstalldirs $(DIST_DIR)/inc

+else # OCFS_KERNEL_2_6
+# Preliminary 2.6.x kernel support
+include Makefile-2.6
+endif # OCFS_KERNEL_2_6
  include $(TOPDIR)/Postamble.make
+endif # ifneq ($(KERNELRELEASE),)
Index: src/Makefile-2.6.in
===================================================================
--- /dev/null	2004-02-23 13:02:56.000000000 -0800
+++ src/Makefile-2.6.in	2004-02-27 14:42:05.631311124 -0800
@@ -0,0 +1,24 @@
+ifneq ($(KERNELRELEASE),)
+
+OCFS_SRC_DIR	:= @OCFS_BUILD_DIR@/src
+EXTRA_CFLAGS += -D__ILP32__ -I$(OCFS_SRC_DIR)/inc -DDEBUG -DHAVE_NPTL \
+		-DTRACE -DALLOW_NO_HANDLE_SYNCING -DOCFS_PARANOID_ABORTS \
+		-Wno-format -DOCFS_BUILD_VERSION=\"x\" -DLINUX_2_5 \
+		-DOCFS_BUILD_DATE=\"y\" -DOCFS_BUILD_MD5=\"z\" -Werror
+
+obj-m += ocfs2.o
+
+ocfs2-objs := alloc.o divdi3.o hash.o ioctl.o oin.o super.o ver.o \
+              bitmap.o dlm.o heartbeat.o journal.o osb.o symlink.o volcfg.o \
+              dcache.o extmap.o inode.o namei.o proc.o sysfile.o vote.o \
+              dir.o file.o io.o nm.o sem.o util.o
+
+else
+
+KDIR	:= $(KERNELDIR)
+OCFS_SRC_DIR	:= @OCFS_BUILD_DIR@/src
+
+all:
+	$(MAKE) -C $(KDIR) V=1 SUBDIRS=$(OCFS_SRC_DIR) modules
+
+endif
-------------- next part --------------
Index: Config.make.in
===================================================================
--- Config.make.in	(revision 36)
+++ Config.make.in	(working copy)
@@ -58,5 +58,6 @@
 OCFS_MEMDEBUG = @OCFS_MEMDEBUG@
 OCFS_TRACE = @OCFS_TRACE@
 OCFS_PROCESSOR = @OCFS_PROCESSOR@
+OCFS_KERNEL_2_6 = @OCFS_KERNEL_2_6@
 
 USE_JOURNAL_CREATE_REPLACEMENT = @USE_JOURNAL_CREATE_REPLACEMENT@
Index: configure.in
===================================================================
--- configure.in	(revision 36)
+++ configure.in	(working copy)
@@ -83,6 +83,13 @@
   AC_MSG_ERROR(GCC is required)
 fi
 
+AC_ARG_ENABLE(kernel-2_6, AS_HELP_STRING([--enable-kernel-2_6], [(BROKEN!) Enable building on Linux kernel version 2.6.x (default=no)]),enable_kernel26=yes,enable_kernel26=no)
+OCFS_KERNEL_2_6=
+if test "x$enable_kernel26" = "xyes"; then
+  OCFS_KERNEL_2_6=yes
+fi
+AC_SUBST(OCFS_KERNEL_2_6)
+
 AC_ARG_ENABLE(debug, [  --enable-debug=[yes/no]         Turn on debugging [default=yes]],,enable_debug=yes)
 OCFS_DEBUG=
 if test "x$enable_debug" = "xyes"; then
@@ -178,6 +185,13 @@
 case "$kversion" in
   2.4.*)
     ;;
+  2.6.*)
+    if test "x$enable_kernel26" = "xyes"; then
+      AC_MSG_NOTICE([Support for kernel version 2.6 is BROKEN at this time!])
+    else
+      AC_MSG_ERROR([Support for kernel version 2.6 is BROKEN (System Hangs) at this time!  You must use --enable-kernel-2_6 to get past this point.])
+    fi
+    ;;
   *)
     AC_MSG_ERROR([This module only supports kernel version 2.4.x])
     ;;
@@ -304,6 +318,9 @@
 GCCINC=$gccdir
 AC_SUBST(GCCINC)
 
+OCFS_BUILD_DIR=`pwd`
+AC_SUBST(OCFS_BUILD_DIR)
+
 AC_OUTPUT([Config.make
 vendor/redhat/ocfs2-2.4.9-e.spec
 vendor/redhat/ocfs2-2.4.18-e.spec
@@ -314,4 +331,5 @@
 vendor/unitedlinux/ocfs2-2.4.21-107.spec
 vendor/unitedlinux/ocfs2-2.4.21-111.spec
 vendor/unitedlinux/ocfs2-2.4.21-138.spec
+src/Makefile-2.6
 ])
Index: src/Makefile
===================================================================
--- src/Makefile	(revision 36)
+++ src/Makefile	(working copy)
@@ -1,3 +1,8 @@
+# 2.6 Kernel stuff
+ifneq "$(KERNELRELEASE)" ""
+include $(obj)/Makefile-2.6
+else
+
 TOPDIR = ..
 
 include $(TOPDIR)/Preamble.make
@@ -2,2 +7,5 @@
 
+# Preliminary 2.6.x kernel support
+ifndef OCFS_KERNEL_2_6
+
 WARNINGS = -Wall -Wstrict-prototypes -Wno-format
@@ -199,4 +207,9 @@
 dist-subdircreate:
 	$(TOPDIR)/mkinstalldirs $(DIST_DIR)/inc
 
+else # OCFS_KERNEL_2_6
+# Preliminary 2.6.x kernel support
+include Makefile-2.6
+endif # OCFS_KERNEL_2_6
 include $(TOPDIR)/Postamble.make
+endif # ifneq ($(KERNELRELEASE),)
Index: src/Makefile-2.6.in
===================================================================
--- /dev/null	2004-02-23 13:02:56.000000000 -0800
+++ src/Makefile-2.6.in	2004-02-27 14:42:05.631311124 -0800
@@ -0,0 +1,24 @@
+ifneq ($(KERNELRELEASE),)
+
+OCFS_SRC_DIR	:= @OCFS_BUILD_DIR@/src
+EXTRA_CFLAGS += -D__ILP32__ -I$(OCFS_SRC_DIR)/inc -DDEBUG -DHAVE_NPTL \
+		-DTRACE -DALLOW_NO_HANDLE_SYNCING -DOCFS_PARANOID_ABORTS \
+		-Wno-format -DOCFS_BUILD_VERSION=\"x\" -DLINUX_2_5 \
+		-DOCFS_BUILD_DATE=\"y\" -DOCFS_BUILD_MD5=\"z\" -Werror
+
+obj-m += ocfs2.o
+
+ocfs2-objs := alloc.o divdi3.o hash.o ioctl.o oin.o super.o ver.o \
+              bitmap.o dlm.o heartbeat.o journal.o osb.o symlink.o volcfg.o \
+              dcache.o extmap.o inode.o namei.o proc.o sysfile.o vote.o \
+              dir.o file.o io.o nm.o sem.o util.o
+
+else
+
+KDIR	:= $(KERNELDIR)
+OCFS_SRC_DIR	:= @OCFS_BUILD_DIR@/src
+
+all:
+	$(MAKE) -C $(KDIR) V=1 SUBDIRS=$(OCFS_SRC_DIR) modules
+
+endif
