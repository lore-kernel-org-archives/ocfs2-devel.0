From: John L. Villalovos <john.l.villalovos@intel.com>
Date: Wed Mar  3 15:48:46 2004
Subject: [Ocfs2-devel] 2.6.x make support (fixed diff)
Message-ID: <404652B9.1080807@intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Second time:  Using correct diff file this time

Updated to get the make system to be able to build for 2.6.x kernels.

More work still needs to be done but it will compile.

I had to create a Config-minimal.make.in file because when I included Config.make during the portion of the build when the kernel is calling back into our Makefile it broke :(  We seem to be setting some variables which are being used by the kernel build system.

So instead I created this minimal one.

This is just a first start at this.  There is more work to be done in this area but it does make it so that people should be able to build a kernel for 2.6.x.

John

Index: configure.in
===================================================================
--- configure.in	(revision 751)
+++ configure.in	(working copy)
@@ -321,7 +321,11 @@
  GCCINC=$gccdir
  AC_SUBST(GCCINC)

+OCFS_BUILD_DIR=`pwd`
+AC_SUBST(OCFS_BUILD_DIR)
+
  AC_OUTPUT([Config.make
+Config-minimal.make
  vendor/redhat/ocfs2-2.4.9-e.spec
  vendor/redhat/ocfs2-2.4.18-e.spec
  vendor/redhat/ocfs2-2.4.21-EL.spec
Index: Config.make.in
===================================================================
--- Config.make.in	(revision 751)
+++ Config.make.in	(working copy)
@@ -61,4 +61,5 @@
  OCFS_TRACE = @OCFS_TRACE@
  OCFS_PROCESSOR = @OCFS_PROCESSOR@

+OCFS_BUILD_DIR = @OCFS_BUILD_DIR@
  USE_JOURNAL_CREATE_REPLACEMENT = @USE_JOURNAL_CREATE_REPLACEMENT@
Index: src/Makefile
===================================================================
--- src/Makefile	(revision 751)
+++ src/Makefile	(working copy)
@@ -1,3 +1,8 @@
+# See if we are being included by the 2.6 kernel build system.
+ifeq ($(KERNELRELEASE),)
+# $(warning ENTRY: Normal Build)
+# Normal build that is being called locally
+
  TOPDIR = ..

  include $(TOPDIR)/Preamble.make
@@ -2,2 +7,8 @@

+# Preliminary 2.6.x kernel support.  See if we are building for the 2.6.x
+# kernel
+ifndef KERNEL_26
+# $(warning ENTRY: Normal 2.4.x Build)
+# Building for a 2.4.x kernel
+
  WARNINGS = -Wall -Wstrict-prototypes -Wno-format
@@ -196,4 +207,94 @@
  dist-subdircreate:
  	$(TOPDIR)/mkinstalldirs $(DIST_DIR)/inc

+
+# $(warning EXIT: Normal 2.4.x Build)
+else # ifndef KERNEL_26
+# $(warning ENTRY: Normal 2.6.x Build)
+# The 2.6.x kernel makefile
+
+# Global parameter so we know where our stuff is
+OCFS_SRC_DIR	:= $(OCFS_BUILD_DIR)/src
+
+# This Makefile has two ways through it.  They are:
+#   1.	We are being included by the local Makefile to do a 2.6 kernel build.
+#	In this method we will call the kernel make system to build our module.
+#	This will cause the kernel make system to call back into our makefile
+#	(2nd way).
+
+KDIR	:= $(KERNELDIR)
+
+all:
+	$(MAKE) -C $(KDIR) V=1 SUBDIRS=$(OCFS_SRC_DIR) modules
+
+# $(warning EXIT: Normal 2.6.x Build)
+endif # OCFS_KERNEL_2_6
+
  include $(TOPDIR)/Postamble.make
+# $(warning EXIT: Normal Build)
+else # ifeq ($(KERNELRELEASE),)
+# $(warning ENTRY: Being called by 2.6.x kernel build system)
+# We are being included by the 2.6 kernel build system.  So we will include the
+# 2.6.x Makefile and skip everything else.
+# The 2.6.x kernel makefile
+
+# Global parameter so we know where our stuff is
+OCFS_SRC_DIR	:= $(SUBDIRS)
+
+include $(SUBDIRS)/../Config-minimal.make
+
+.PHONY: testy
+
+
+testy::
+	echo $(SUBDIRS)
+	echo "Hi John!"
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
+# 2nd method.  The kernel make system is including us.  We need to setup the
+# various parameters for the kernel make system and then it will take care of
+# building us.
+
+EXTRA_CFLAGS += -D__ILP32__ -I$(OCFS_SRC_DIR)/inc -Wno-format
+
+# FIXME: Need to figure out how to use the stuff from Postamble.make.  In
+# particular the MD5 and Version strings
+EXTRA_CFLAGS +=	-DOCFS_BUILD_DATE=\"y\" -DOCFS_BUILD_MD5=\"z\" \
+		-DOCFS_BUILD_VERSION=\"x\"
+
+# FIXME: Probably should not be doing this
+EXTRA_CFLAGS +=	-Werror
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
+# $(warning EXIT: Being called by 2.6.x kernel build system)
+endif # ifneq ($(KERNELRELEASE),)
--- /dev/null	2004-02-23 13:02:56.000000000 -0800
+++ Config-minimal.make.in	2004-03-03 10:57:16.845218296 -0800
@@ -0,0 +1,7 @@
+OCFS_DEBUG = @OCFS_DEBUG@
+OCFS_LARGEIO = @OCFS_LARGEIO@
+OCFS_AIO = @OCFS_AIO@
+OCFS_MEMDEBUG = @OCFS_MEMDEBUG@
+OCFS_TRACE = @OCFS_TRACE@
+OCFS_PROCESSOR = @OCFS_PROCESSOR@
+HAVE_NPTL = @HAVE_NPTL@

-------------- next part --------------
Index: configure.in
===================================================================
--- configure.in	(revision 751)
+++ configure.in	(working copy)
@@ -321,7 +321,11 @@
 GCCINC=$gccdir
 AC_SUBST(GCCINC)
 
+OCFS_BUILD_DIR=`pwd`
+AC_SUBST(OCFS_BUILD_DIR)
+
 AC_OUTPUT([Config.make
+Config-minimal.make
 vendor/redhat/ocfs2-2.4.9-e.spec
 vendor/redhat/ocfs2-2.4.18-e.spec
 vendor/redhat/ocfs2-2.4.21-EL.spec
Index: Config.make.in
===================================================================
--- Config.make.in	(revision 751)
+++ Config.make.in	(working copy)
@@ -61,4 +61,5 @@
 OCFS_TRACE = @OCFS_TRACE@
 OCFS_PROCESSOR = @OCFS_PROCESSOR@
 
+OCFS_BUILD_DIR = @OCFS_BUILD_DIR@
 USE_JOURNAL_CREATE_REPLACEMENT = @USE_JOURNAL_CREATE_REPLACEMENT@
Index: src/Makefile
===================================================================
--- src/Makefile	(revision 751)
+++ src/Makefile	(working copy)
@@ -1,3 +1,8 @@
+# See if we are being included by the 2.6 kernel build system.
+ifeq ($(KERNELRELEASE),)
+# $(warning ENTRY: Normal Build)
+# Normal build that is being called locally
+
 TOPDIR = ..
 
 include $(TOPDIR)/Preamble.make
@@ -2,2 +7,8 @@
 
+# Preliminary 2.6.x kernel support.  See if we are building for the 2.6.x
+# kernel
+ifndef KERNEL_26
+# $(warning ENTRY: Normal 2.4.x Build)
+# Building for a 2.4.x kernel
+
 WARNINGS = -Wall -Wstrict-prototypes -Wno-format
@@ -196,4 +207,94 @@
 dist-subdircreate:
 	$(TOPDIR)/mkinstalldirs $(DIST_DIR)/inc
 
+
+# $(warning EXIT: Normal 2.4.x Build)
+else # ifndef KERNEL_26
+# $(warning ENTRY: Normal 2.6.x Build)
+# The 2.6.x kernel makefile
+
+# Global parameter so we know where our stuff is
+OCFS_SRC_DIR	:= $(OCFS_BUILD_DIR)/src
+
+# This Makefile has two ways through it.  They are:
+#   1.	We are being included by the local Makefile to do a 2.6 kernel build.
+#	In this method we will call the kernel make system to build our module.
+#	This will cause the kernel make system to call back into our makefile
+#	(2nd way).
+
+KDIR	:= $(KERNELDIR)
+
+all:
+	$(MAKE) -C $(KDIR) V=1 SUBDIRS=$(OCFS_SRC_DIR) modules
+
+# $(warning EXIT: Normal 2.6.x Build)
+endif # OCFS_KERNEL_2_6
+
 include $(TOPDIR)/Postamble.make
+# $(warning EXIT: Normal Build)
+else # ifeq ($(KERNELRELEASE),)
+# $(warning ENTRY: Being called by 2.6.x kernel build system)
+# We are being included by the 2.6 kernel build system.  So we will include the
+# 2.6.x Makefile and skip everything else.
+# The 2.6.x kernel makefile
+
+# Global parameter so we know where our stuff is
+OCFS_SRC_DIR	:= $(SUBDIRS)
+
+include $(SUBDIRS)/../Config-minimal.make
+
+.PHONY: testy
+
+
+testy::
+	echo $(SUBDIRS)
+	echo "Hi John!"
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
+# 2nd method.  The kernel make system is including us.  We need to setup the
+# various parameters for the kernel make system and then it will take care of
+# building us.
+
+EXTRA_CFLAGS += -D__ILP32__ -I$(OCFS_SRC_DIR)/inc -Wno-format
+
+# FIXME: Need to figure out how to use the stuff from Postamble.make.  In
+# particular the MD5 and Version strings
+EXTRA_CFLAGS +=	-DOCFS_BUILD_DATE=\"y\" -DOCFS_BUILD_MD5=\"z\" \
+		-DOCFS_BUILD_VERSION=\"x\"
+
+# FIXME: Probably should not be doing this
+EXTRA_CFLAGS +=	-Werror
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
+# $(warning EXIT: Being called by 2.6.x kernel build system)
+endif # ifneq ($(KERNELRELEASE),)
--- /dev/null	2004-02-23 13:02:56.000000000 -0800
+++ Config-minimal.make.in	2004-03-03 10:57:16.845218296 -0800
@@ -0,0 +1,7 @@
+OCFS_DEBUG = @OCFS_DEBUG@
+OCFS_LARGEIO = @OCFS_LARGEIO@
+OCFS_AIO = @OCFS_AIO@
+OCFS_MEMDEBUG = @OCFS_MEMDEBUG@
+OCFS_TRACE = @OCFS_TRACE@
+OCFS_PROCESSOR = @OCFS_PROCESSOR@
+HAVE_NPTL = @HAVE_NPTL@
