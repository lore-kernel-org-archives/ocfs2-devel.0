From: John L. Villalovos <john.l.villalovos@intel.com>
Date: Wed Mar  3 15:42:02 2004
Subject: [Ocfs2-devel] 2.6.x make support
Message-ID: <40465120.50108@intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Updated to get the make system to be able to build for 2.6.x kernels.

More work still needs to be done but it will compile.

I had to create a Config-minimal.make.in file because when I included Config.make during the portion of the build when the kernel is calling back into our Makefile it broke :(  We seem to be setting some variables which are being used by the kernel build system.

So instead I created this minimal one.

This is just a first start at this.  There is more work to be done in this area but it does make it so that people should be able to build a kernel for 2.6.x.

John


Index: configure.in
===================================================================
--- configure.in	(revision 747)
+++ configure.in	(working copy)
@@ -83,6 +83,13 @@
    AC_MSG_ERROR(GCC is required)
  fi

+AC_ARG_ENABLE(kernel-2_6, AC_HELP_STRING([--enable-kernel-2_6], [(BROKEN!) Enable building on Linux kernel version 2.6.x (default=no)]),enable_kernel26=yes,enable_kernel26=no)
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
+      AC_MSG_NOTICE([Support for kernel version 2.6 is BROKEN at this time!  Your system WILL hang.])
+    else
+      AC_MSG_ERROR([Support for kernel version 2.6 is BROKEN (Your system WILL hang!) at this time.  You must use --enable-kernel-2_6 to get past this point.])
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
Index: Config.make.in
===================================================================
--- Config.make.in	(revision 747)
+++ Config.make.in	(working copy)
@@ -58,5 +58,6 @@
  OCFS_MEMDEBUG = @OCFS_MEMDEBUG@
  OCFS_TRACE = @OCFS_TRACE@
  OCFS_PROCESSOR = @OCFS_PROCESSOR@
+OCFS_KERNEL_2_6 = @OCFS_KERNEL_2_6@

  USE_JOURNAL_CREATE_REPLACEMENT = @USE_JOURNAL_CREATE_REPLACEMENT@
Index: src/Makefile
===================================================================
--- src/Makefile	(revision 747)
+++ src/Makefile	(working copy)
@@ -1,3 +1,11 @@
+# See if we are being included by the 2.6 kernel build system.
+ifneq ($(KERNELRELEASE),)
+# We are being included by the 2.6 kernel build system.  So we will include the
+# 2.6.x Makefile and skip everything else.
+include $(obj)/Makefile-2.6
+else
+# Normal build that is being called locally
+
  TOPDIR = ..

  include $(TOPDIR)/Preamble.make
@@ -2,2 +10,7 @@

+# Preliminary 2.6.x kernel support.  See if we are building for the 2.6.x
+# kernel
+ifndef OCFS_KERNEL_2_6
+# Building for a 2.4.x kernel
+
  WARNINGS = -Wall -Wstrict-prototypes -Wno-format
@@ -196,4 +209,11 @@
  dist-subdircreate:
  	$(TOPDIR)/mkinstalldirs $(DIST_DIR)/inc

+
+else # OCFS_KERNEL_2_6
+# Building for a 2.6.x kernel
+include Makefile-2.6
+endif # OCFS_KERNEL_2_6
+
  include $(TOPDIR)/Postamble.make
+endif # ifneq ($(KERNELRELEASE),)
--- /dev/null	2004-02-23 13:02:56.000000000 -0800
+++ src/Makefile-2.6.in	2004-03-02 14:17:21.207201128 -0800
@@ -0,0 +1,74 @@
+# The 2.6.x kernel makefile
+
+# Global parameter so we know where our stuff is
+OCFS_SRC_DIR	:= @OCFS_BUILD_DIR@/src
+
+# This Makefile has two ways through it.  They are:
+#   1.	We are being included by the local Makefile to do a 2.6 kernel build.
+#	In this method we will call the kernel make system to build our module.
+#	This will cause the kernel make system to call back into our makefile
+#	(2nd way).
+#
+#   2.	We are being included by the kernel make system.  So in this method we
+#	just setup the variables that the make system wants and then the kernel
+#	make system will take care of the build.
+
+ifeq ($(KERNELRELEASE),)
+# 1st method.  Local Makefile is including us.  We will now call the kernel
+# make system to do the build.
+
+KDIR	:= $(KERNELDIR)
+
+all:
+	$(MAKE) -C $(KDIR) V=1 SUBDIRS=$(OCFS_SRC_DIR) modules
+
+else
+# 2nd method.  The kernel make system is including us.  We need to setup the
+# various parameters for the kernel make system and then it will take care of
+# building us.
+
+EXTRA_CFLAGS += -D__ILP32__ -I$(OCFS_SRC_DIR)/inc \
+		-DALLOW_NO_HANDLE_SYNCING -DOCFS_PARANOID_ABORTS \
+		-Wno-format
+
+# FIXME: Need to figure out how to use the stuff from Postamble.make.  In
+# particular the MD5 and Version strings
+EXTRA_CFLAGS +=	-DOCFS_BUILD_DATE=\"y\" -DOCFS_BUILD_MD5=\"z\" \
+		-DOCFS_BUILD_VERSION=\"x\"
+
+# FIXME: Probably should not be doing this
+EXTRA_CFLAGS +=	-Werror
+
+# Defines
+HAVE_NPTL = @HAVE_NPTL@
+OCFS_DEBUG = @OCFS_DEBUG@
+OCFS_LARGEIO = @OCFS_LARGEIO@
+OCFS_AIO = @OCFS_AIO@
+OCFS_MEMDEBUG = @OCFS_MEMDEBUG@
+OCFS_TRACE = @OCFS_TRACE@
+OCFS_PROCESSOR = @OCFS_PROCESSOR@
+OCFS_KERNEL_2_6 = @OCFS_KERNEL_2_6@
+
+# Setup all the extra parameters that might be needed by the build.
+# FIXME: Not sure if we have all the parameters here.
+ifdef OCFS_DEBUG
+EXTRA_CFLAGS += -DDEBUG
+endif
+
+ifdef OCFS_TRACE
+EXTRA_CFLAGS += -DTRACE
+endif
+
+ifdef HAVE_NPTL
+EXTRA_CFLAGS += -DHAVE_NPTL
+endif
+
+# Kernel Module file to produce
+obj-m += ocfs2.o
+
+# list of object files that are used to create our module
+ocfs2-objs := alloc.o divdi3.o hash.o ioctl.o oin.o super.o ver.o \
+              bitmap.o dlm.o heartbeat.o journal.o osb.o symlink.o volcfg.o \
+              dcache.o extmap.o inode.o namei.o proc.o sysfile.o vote.o \
+              dir.o file.o io.o nm.o sem.o util.o
+endif

-------------- next part --------------
Index: configure.in
===================================================================
--- configure.in	(revision 747)
+++ configure.in	(working copy)
@@ -83,6 +83,13 @@
   AC_MSG_ERROR(GCC is required)
 fi
 
+AC_ARG_ENABLE(kernel-2_6, AC_HELP_STRING([--enable-kernel-2_6], [(BROKEN!) Enable building on Linux kernel version 2.6.x (default=no)]),enable_kernel26=yes,enable_kernel26=no)
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
+      AC_MSG_NOTICE([Support for kernel version 2.6 is BROKEN at this time!  Your system WILL hang.])
+    else
+      AC_MSG_ERROR([Support for kernel version 2.6 is BROKEN (Your system WILL hang!) at this time.  You must use --enable-kernel-2_6 to get past this point.])
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
Index: Config.make.in
===================================================================
--- Config.make.in	(revision 747)
+++ Config.make.in	(working copy)
@@ -58,5 +58,6 @@
 OCFS_MEMDEBUG = @OCFS_MEMDEBUG@
 OCFS_TRACE = @OCFS_TRACE@
 OCFS_PROCESSOR = @OCFS_PROCESSOR@
+OCFS_KERNEL_2_6 = @OCFS_KERNEL_2_6@
 
 USE_JOURNAL_CREATE_REPLACEMENT = @USE_JOURNAL_CREATE_REPLACEMENT@
Index: src/Makefile
===================================================================
--- src/Makefile	(revision 747)
+++ src/Makefile	(working copy)
@@ -1,3 +1,11 @@
+# See if we are being included by the 2.6 kernel build system.
+ifneq ($(KERNELRELEASE),)
+# We are being included by the 2.6 kernel build system.  So we will include the
+# 2.6.x Makefile and skip everything else.
+include $(obj)/Makefile-2.6
+else
+# Normal build that is being called locally
+
 TOPDIR = ..
 
 include $(TOPDIR)/Preamble.make
@@ -2,2 +10,7 @@
 
+# Preliminary 2.6.x kernel support.  See if we are building for the 2.6.x
+# kernel
+ifndef OCFS_KERNEL_2_6
+# Building for a 2.4.x kernel
+
 WARNINGS = -Wall -Wstrict-prototypes -Wno-format
@@ -196,4 +209,11 @@
 dist-subdircreate:
 	$(TOPDIR)/mkinstalldirs $(DIST_DIR)/inc
 
+
+else # OCFS_KERNEL_2_6
+# Building for a 2.6.x kernel
+include Makefile-2.6
+endif # OCFS_KERNEL_2_6
+
 include $(TOPDIR)/Postamble.make
+endif # ifneq ($(KERNELRELEASE),)
--- /dev/null	2004-02-23 13:02:56.000000000 -0800
+++ src/Makefile-2.6.in	2004-03-02 14:17:21.207201128 -0800
@@ -0,0 +1,74 @@
+# The 2.6.x kernel makefile
+
+# Global parameter so we know where our stuff is
+OCFS_SRC_DIR	:= @OCFS_BUILD_DIR@/src
+
+# This Makefile has two ways through it.  They are:
+#   1.	We are being included by the local Makefile to do a 2.6 kernel build.
+#	In this method we will call the kernel make system to build our module.
+#	This will cause the kernel make system to call back into our makefile
+#	(2nd way).
+#
+#   2.	We are being included by the kernel make system.  So in this method we
+#	just setup the variables that the make system wants and then the kernel
+#	make system will take care of the build.
+
+ifeq ($(KERNELRELEASE),)
+# 1st method.  Local Makefile is including us.  We will now call the kernel
+# make system to do the build.
+
+KDIR	:= $(KERNELDIR)
+
+all:
+	$(MAKE) -C $(KDIR) V=1 SUBDIRS=$(OCFS_SRC_DIR) modules
+
+else
+# 2nd method.  The kernel make system is including us.  We need to setup the
+# various parameters for the kernel make system and then it will take care of
+# building us.
+
+EXTRA_CFLAGS += -D__ILP32__ -I$(OCFS_SRC_DIR)/inc \
+		-DALLOW_NO_HANDLE_SYNCING -DOCFS_PARANOID_ABORTS \
+		-Wno-format
+
+# FIXME: Need to figure out how to use the stuff from Postamble.make.  In
+# particular the MD5 and Version strings
+EXTRA_CFLAGS +=	-DOCFS_BUILD_DATE=\"y\" -DOCFS_BUILD_MD5=\"z\" \
+		-DOCFS_BUILD_VERSION=\"x\"
+
+# FIXME: Probably should not be doing this
+EXTRA_CFLAGS +=	-Werror
+
+# Defines
+HAVE_NPTL = @HAVE_NPTL@
+OCFS_DEBUG = @OCFS_DEBUG@
+OCFS_LARGEIO = @OCFS_LARGEIO@
+OCFS_AIO = @OCFS_AIO@
+OCFS_MEMDEBUG = @OCFS_MEMDEBUG@
+OCFS_TRACE = @OCFS_TRACE@
+OCFS_PROCESSOR = @OCFS_PROCESSOR@
+OCFS_KERNEL_2_6 = @OCFS_KERNEL_2_6@
+
+# Setup all the extra parameters that might be needed by the build.
+# FIXME: Not sure if we have all the parameters here.
+ifdef OCFS_DEBUG
+EXTRA_CFLAGS += -DDEBUG
+endif
+
+ifdef OCFS_TRACE
+EXTRA_CFLAGS += -DTRACE
+endif
+
+ifdef HAVE_NPTL
+EXTRA_CFLAGS += -DHAVE_NPTL
+endif
+
+# Kernel Module file to produce
+obj-m += ocfs2.o
+
+# list of object files that are used to create our module
+ocfs2-objs := alloc.o divdi3.o hash.o ioctl.o oin.o super.o ver.o \
+              bitmap.o dlm.o heartbeat.o journal.o osb.o symlink.o volcfg.o \
+              dcache.o extmap.o inode.o namei.o proc.o sysfile.o vote.o \
+              dir.o file.o io.o nm.o sem.o util.o
+endif
