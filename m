From: John L. Villalovos <john.l.villalovos@intel.com>
Date: Wed Mar  3 18:40:06 2004
Subject: [Ocfs2-devel] 2.6 build support
Message-ID: <40467ADE.8010507@intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Okay.  I'm still plugging away here.

I have worked on having the Makefile setup things which are common to both 2.4.x and 2.6.x and then go and do the 2.4.x/2.6.x specific things.

I have compiled this on both 2.4.x and 2.6.x and I did not see any problems.

John


Index: configure.in
===================================================================
--- configure.in	(revision 751)
+++ configure.in	(working copy)
@@ -281,6 +281,10 @@
    ;;
  esac

+if test "x$enable_kernel26" = "xyes"; then
+  USE_JOURNAL_CREATE_REPLACEMENT=no
+fi
+
  AC_MSG_RESULT($USE_JOURNAL_CREATE_REPLACEMENT)
  AC_SUBST(USE_JOURNAL_CREATE_REPLACEMENT)

@@ -321,7 +325,11 @@
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
@@ -1,50 +1,61 @@
+# See if we are being included by the 2.6 kernel build system.
+ifeq ($(KERNELRELEASE),)
+# Normal build that is being called locally
  TOPDIR = ..

  include $(TOPDIR)/Preamble.make
+else # ifeq ($(KERNELRELEASE),)
+# We are being included by the 2.6.x kernel build system

-WARNINGS = -Wall -Wstrict-prototypes -Wno-format
+# Global parameter so we know where our stuff is
+OCFS_SRC_DIR	:= $(SUBDIRS)

-ifneq ($(OCFS_PROCESSOR),x86_64)
-WARNINGS += -Wmissing-prototypes -Wmissing-declarations
+include $(OCFS_SRC_DIR)/../Config-minimal.make
  endif

+#-*******************************************************
+# Now do stuff which is global for 2.4.x and 2.6.x builds
+
+# WARNINGS = -Wall -Wstrict-prototypes -Wno-format
+WARNINGS = -Werror -Wstrict-prototypes -Wno-format
+
  ifdef OCFS_DEBUG
  OPTS += -g
  endif

  BASE_DEFINES = -DMODULE -DLINUX -D__KERNEL__
-DEFINES = $(BASE_DEFINES)
+GLOBAL_DEFINES =

  ifdef OCFS_DEBUG
-DEFINES += -DDEBUG
+GLOBAL_DEFINES += -DDEBUG
  endif

  ifdef OCFS_MEMDEBUG
-DEFINES += -DOCFS_LINUX_MEM_DEBUG -DDEBUG_SLAB_ALLOCS
+GLOBAL_DEFINES += -DOCFS_LINUX_MEM_DEBUG -DDEBUG_SLAB_ALLOCS
  endif

  ifdef OCFS_AIO
-DEFINES += -DAIO_ENABLED
+GLOBAL_DEFINES += -DAIO_ENABLED
  endif

  ifdef OCFS_TRACE
-DEFINES += -DTRACE
+GLOBAL_DEFINES += -DTRACE
  endif

  ifdef HAVE_NPTL
-DEFINES += -DHAVE_NPTL
+GLOBAL_DEFINES += -DHAVE_NPTL
  endif

  ifeq ($(USE_JOURNAL_CREATE_REPLACEMENT),yes)
-DEFINES += -DUSE_JOURNAL_CREATE_REPLACEMENT
+GLOBAL_DEFINES += -DUSE_JOURNAL_CREATE_REPLACEMENT
  endif

  ifneq ($(QUIET),1)
-DEFINES += -DDEBUG_LOCK_BUFFER
-DEFINES += -DVERBOSE_BH_JBD_TRACE
-DEFINES += -DVERBOSE_LOCKING_TRACE
-DEFINES += -DVERBOSE_BH_SEQNUM_TRACE
-DEFINES += -DVERBOSE_PROCESS_VOTE
+GLOBAL_DEFINES += -DDEBUG_LOCK_BUFFER
+GLOBAL_DEFINES += -DVERBOSE_BH_JBD_TRACE
+GLOBAL_DEFINES += -DVERBOSE_LOCKING_TRACE
+GLOBAL_DEFINES += -DVERBOSE_BH_SEQNUM_TRACE
+GLOBAL_DEFINES += -DVERBOSE_PROCESS_VOTE

  #off by default -- these generate ALOT of output
  #DEFINES += -DVERBOSE_BH_SEM
@@ -61,43 +72,35 @@
  endif

  ifeq ($(KVER),suse)
-DEFINES += -DSUSE
+GLOBAL_DEFINES += -DSUSE
  endif
  ifeq ($(KVER),hugemem)
-  DEFINES += -D__BOOT_KERNEL_HUGEMEM=1
-  DEFINES += -D__BOOT_KERNEL_ENTERPRISE=0
-  DEFINES += -D__BOOT_KERNEL_SMP=0
-  DEFINES += -D__BOOT_KERNEL_UP=0
+  GLOBAL_DEFINES += -D__BOOT_KERNEL_HUGEMEM=1
+  GLOBAL_DEFINES += -D__BOOT_KERNEL_ENTERPRISE=0
+  GLOBAL_DEFINES += -D__BOOT_KERNEL_SMP=0
+  GLOBAL_DEFINES += -D__BOOT_KERNEL_UP=0
  endif
  ifeq ($(KVER),smp)
-  DEFINES += -D__BOOT_KERNEL_HUGEMEM=0
-  DEFINES += -D__BOOT_KERNEL_ENTERPRISE=0
-  DEFINES += -D__BOOT_KERNEL_SMP=1
-  DEFINES += -D__BOOT_KERNEL_UP=0
+  GLOBAL_DEFINES += -D__BOOT_KERNEL_HUGEMEM=0
+  GLOBAL_DEFINES += -D__BOOT_KERNEL_ENTERPRISE=0
+  GLOBAL_DEFINES += -D__BOOT_KERNEL_SMP=1
+  GLOBAL_DEFINES += -D__BOOT_KERNEL_UP=0
  endif
  ifeq ($(KVER),ent)
-  DEFINES += -D__BOOT_KERNEL_HUGEMEM=0
-  DEFINES += -D__BOOT_KERNEL_ENTERPRISE=1
-  DEFINES += -D__BOOT_KERNEL_SMP=0
-  DEFINES += -D__BOOT_KERNEL_UP=0
+  GLOBAL_DEFINES += -D__BOOT_KERNEL_HUGEMEM=0
+  GLOBAL_DEFINES += -D__BOOT_KERNEL_ENTERPRISE=1
+  GLOBAL_DEFINES += -D__BOOT_KERNEL_SMP=0
+  GLOBAL_DEFINES += -D__BOOT_KERNEL_UP=0
  endif
  ifeq ($(KVER),up)
-  DEFINES += -D__BOOT_KERNEL_HUGEMEM=0
-  DEFINES += -D__BOOT_KERNEL_ENTERPRISE=0
-  DEFINES += -D__BOOT_KERNEL_SMP=0
-  DEFINES += -D__BOOT_KERNEL_UP=1
+  GLOBAL_DEFINES += -D__BOOT_KERNEL_HUGEMEM=0
+  GLOBAL_DEFINES += -D__BOOT_KERNEL_ENTERPRISE=0
+  GLOBAL_DEFINES += -D__BOOT_KERNEL_SMP=0
+  GLOBAL_DEFINES += -D__BOOT_KERNEL_UP=1
  endif

-INCLUDES = -Iinc -I$(KERNELINC) -I$(GCCINC)
-
-CFLAGS=$(OPTS) -pipe -nostdinc -fno-strict-aliasing -fno-common \
-	-fomit-frame-pointer $(MODVERSIONS) $(WARNINGS)
-LDADD=-nostdlib
-
-OPTIMIZE = -O2
-
  ifeq ($(OCFS_PROCESSOR),ppc64)
-  DEFINES += -D__LP64__
+  GLOBAL_DEFINES += -D__LP64__
    CFLAGS += -m64 -fsigned-char -fno-builtin -msoft-float -mminimal-toc
    LDADD += -m elf64ppc
  endif
@@ -107,12 +110,50 @@
  ifeq ($(OCFS_PROCESSOR),ia64)
  endif
  ifeq ($(OCFS_PROCESSOR),i686)
-  DEFINES += -D__ILP32__
+  GLOBAL_DEFINES += -D__ILP32__
  endif
  ifeq ($(OCFS_PROCESSOR),i586)
-  DEFINES += -D__ILP32__
+  GLOBAL_DEFINES += -D__ILP32__
  endif

+DEFINES += $(BASE_DEFINES) $(GLOBAL_DEFINES)
+
+ifeq ($(OCFS_PROCESSOR),x86_64)
+SUPPORT =
+endif
+ifeq ($(OCFS_PROCESSOR),ia64)
+SUPPORT =
+endif
+ifeq ($(OCFS_PROCESSOR),i686)
+SUPPORT = divdi3.c
+endif
+ifeq ($(OCFS_PROCESSOR),i586)
+SUPPORT = divdi3.c
+endif
+
+# End of stuff which is global for 2.4.x and 2.6.x kernels
+#-********************************************************
+
+# See if we are being included by the 2.6 kernel build system.
+ifeq ($(KERNELRELEASE),)
+# Normal build that is being called locally
+# Preliminary 2.6.x kernel support.  See if we are building for the 2.6.x
+# kernel
+ifndef KERNEL_26
+# Building for a 2.4.x kernel
+
+ifneq ($(OCFS_PROCESSOR),x86_64)
+WARNINGS += -Wmissing-prototypes -Wmissing-declarations
+endif
+
+INCLUDES = -Iinc -I$(KERNELINC) -I$(GCCINC)
+
+CFLAGS=$(OPTS) -pipe -nostdinc -fno-strict-aliasing -fno-common \
+	-fomit-frame-pointer $(MODVERSIONS) $(WARNINGS)
+LDADD=-nostdlib
+
+OPTIMIZE = -O2
+
  CFLAGS += $(OPTIMIZE)

  MODULES = ocfs2.o
@@ -147,19 +188,6 @@
  	vote.c


-ifeq ($(OCFS_PROCESSOR),x86_64)
-SUPPORT =
-endif
-ifeq ($(OCFS_PROCESSOR),ia64)
-SUPPORT =
-endif
-ifeq ($(OCFS_PROCESSOR),i686)
-SUPPORT = divdi3.c
-endif
-ifeq ($(OCFS_PROCESSOR),i586)
-SUPPORT = divdi3.c
-endif
-
  CFILES = $(OSOURCES) $(SUPPORT)

  HFILES = \
@@ -196,4 +224,59 @@
  dist-subdircreate:
  	$(TOPDIR)/mkinstalldirs $(DIST_DIR)/inc

+
+else # ifndef KERNEL_26
+# The 2.6.x kernel makefile
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
+	$(MAKE) -C $(KDIR) V=1 SUBDIRS=$(OCFS_BUILD_DIR)/src modules
+
+endif # OCFS_KERNEL_2_6
+
  include $(TOPDIR)/Postamble.make
+else # ifeq ($(KERNELRELEASE),)
+# We are being included by the 2.6 kernel build system.  So we will include the
+# 2.6.x Makefile and skip everything else.
+# The 2.6.x kernel makefile
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
+# EXTRA_CFLAGS += -D__ILP32__ -I$(OCFS_SRC_DIR)/inc -Wno-format
+EXTRA_CFLAGS += -I$(OCFS_SRC_DIR)/inc
+
+EXTRA_CFLAGS += $(GLOBAL_DEFINES) $(WARNINGS)
+
+# FIXME: Need to figure out how to use the stuff from Postamble.make.  In
+# particular the MD5 and Version strings
+EXTRA_CFLAGS +=	-DOCFS_BUILD_DATE=\"y\" -DOCFS_BUILD_MD5=\"z\" \
+		-DOCFS_BUILD_VERSION=\"x\"
+
+# Kernel Module file to produce
+obj-m += ocfs2.o
+
+# list of object files that are used to create our module
+ocfs2-objs := alloc.o divdi3.o hash.o ioctl.o oin.o super.o ver.o \
+              bitmap.o dlm.o heartbeat.o journal.o osb.o symlink.o volcfg.o \
+              dcache.o extmap.o inode.o namei.o proc.o sysfile.o vote.o \
+              dir.o file.o io.o nm.o sem.o util.o
+endif # ifneq ($(KERNELRELEASE),)
Index: Config-minimal.make.in
===================================================================
--- /dev/null	2004-02-23 13:02:56.000000000 -0800
+++ Config-minimal.make.in	2004-03-03 16:23:30.173607433 -0800
@@ -0,0 +1,8 @@
+OCFS_DEBUG = @OCFS_DEBUG@
+OCFS_LARGEIO = @OCFS_LARGEIO@
+OCFS_AIO = @OCFS_AIO@
+OCFS_MEMDEBUG = @OCFS_MEMDEBUG@
+OCFS_TRACE = @OCFS_TRACE@
+OCFS_PROCESSOR = @OCFS_PROCESSOR@
+HAVE_NPTL = @HAVE_NPTL@
+USE_JOURNAL_CREATE_REPLACEMENT = @USE_JOURNAL_CREATE_REPLACEMENT@

-------------- next part --------------
Index: configure.in
===================================================================
--- configure.in	(revision 751)
+++ configure.in	(working copy)
@@ -281,6 +281,10 @@
   ;;
 esac
 
+if test "x$enable_kernel26" = "xyes"; then
+  USE_JOURNAL_CREATE_REPLACEMENT=no
+fi
+
 AC_MSG_RESULT($USE_JOURNAL_CREATE_REPLACEMENT)
 AC_SUBST(USE_JOURNAL_CREATE_REPLACEMENT)
 
@@ -321,7 +325,11 @@
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
@@ -1,50 +1,61 @@
+# See if we are being included by the 2.6 kernel build system.
+ifeq ($(KERNELRELEASE),)
+# Normal build that is being called locally
 TOPDIR = ..
 
 include $(TOPDIR)/Preamble.make
+else # ifeq ($(KERNELRELEASE),)
+# We are being included by the 2.6.x kernel build system
 
-WARNINGS = -Wall -Wstrict-prototypes -Wno-format
+# Global parameter so we know where our stuff is
+OCFS_SRC_DIR	:= $(SUBDIRS)
 
-ifneq ($(OCFS_PROCESSOR),x86_64)
-WARNINGS += -Wmissing-prototypes -Wmissing-declarations
+include $(OCFS_SRC_DIR)/../Config-minimal.make
 endif
 
+#-*******************************************************
+# Now do stuff which is global for 2.4.x and 2.6.x builds
+
+# WARNINGS = -Wall -Wstrict-prototypes -Wno-format
+WARNINGS = -Werror -Wstrict-prototypes -Wno-format
+
 ifdef OCFS_DEBUG
 OPTS += -g
 endif
 
 BASE_DEFINES = -DMODULE -DLINUX -D__KERNEL__ 
-DEFINES = $(BASE_DEFINES)
+GLOBAL_DEFINES =
 
 ifdef OCFS_DEBUG
-DEFINES += -DDEBUG
+GLOBAL_DEFINES += -DDEBUG
 endif
 
 ifdef OCFS_MEMDEBUG
-DEFINES += -DOCFS_LINUX_MEM_DEBUG -DDEBUG_SLAB_ALLOCS
+GLOBAL_DEFINES += -DOCFS_LINUX_MEM_DEBUG -DDEBUG_SLAB_ALLOCS
 endif
 
 ifdef OCFS_AIO
-DEFINES += -DAIO_ENABLED
+GLOBAL_DEFINES += -DAIO_ENABLED
 endif
 
 ifdef OCFS_TRACE
-DEFINES += -DTRACE
+GLOBAL_DEFINES += -DTRACE
 endif
 
 ifdef HAVE_NPTL
-DEFINES += -DHAVE_NPTL
+GLOBAL_DEFINES += -DHAVE_NPTL
 endif
 
 ifeq ($(USE_JOURNAL_CREATE_REPLACEMENT),yes)
-DEFINES += -DUSE_JOURNAL_CREATE_REPLACEMENT
+GLOBAL_DEFINES += -DUSE_JOURNAL_CREATE_REPLACEMENT
 endif
 
 ifneq ($(QUIET),1)
-DEFINES += -DDEBUG_LOCK_BUFFER
-DEFINES += -DVERBOSE_BH_JBD_TRACE
-DEFINES += -DVERBOSE_LOCKING_TRACE
-DEFINES += -DVERBOSE_BH_SEQNUM_TRACE
-DEFINES += -DVERBOSE_PROCESS_VOTE
+GLOBAL_DEFINES += -DDEBUG_LOCK_BUFFER
+GLOBAL_DEFINES += -DVERBOSE_BH_JBD_TRACE
+GLOBAL_DEFINES += -DVERBOSE_LOCKING_TRACE
+GLOBAL_DEFINES += -DVERBOSE_BH_SEQNUM_TRACE
+GLOBAL_DEFINES += -DVERBOSE_PROCESS_VOTE
 
 #off by default -- these generate ALOT of output
 #DEFINES += -DVERBOSE_BH_SEM
@@ -61,43 +72,35 @@
 endif
 
 ifeq ($(KVER),suse)
-DEFINES += -DSUSE
+GLOBAL_DEFINES += -DSUSE
 endif
 ifeq ($(KVER),hugemem)
-  DEFINES += -D__BOOT_KERNEL_HUGEMEM=1
-  DEFINES += -D__BOOT_KERNEL_ENTERPRISE=0
-  DEFINES += -D__BOOT_KERNEL_SMP=0
-  DEFINES += -D__BOOT_KERNEL_UP=0
+  GLOBAL_DEFINES += -D__BOOT_KERNEL_HUGEMEM=1
+  GLOBAL_DEFINES += -D__BOOT_KERNEL_ENTERPRISE=0
+  GLOBAL_DEFINES += -D__BOOT_KERNEL_SMP=0
+  GLOBAL_DEFINES += -D__BOOT_KERNEL_UP=0
 endif
 ifeq ($(KVER),smp)
-  DEFINES += -D__BOOT_KERNEL_HUGEMEM=0
-  DEFINES += -D__BOOT_KERNEL_ENTERPRISE=0 
-  DEFINES += -D__BOOT_KERNEL_SMP=1 
-  DEFINES += -D__BOOT_KERNEL_UP=0 
+  GLOBAL_DEFINES += -D__BOOT_KERNEL_HUGEMEM=0
+  GLOBAL_DEFINES += -D__BOOT_KERNEL_ENTERPRISE=0 
+  GLOBAL_DEFINES += -D__BOOT_KERNEL_SMP=1 
+  GLOBAL_DEFINES += -D__BOOT_KERNEL_UP=0 
 endif
 ifeq ($(KVER),ent)
-  DEFINES += -D__BOOT_KERNEL_HUGEMEM=0
-  DEFINES += -D__BOOT_KERNEL_ENTERPRISE=1 
-  DEFINES += -D__BOOT_KERNEL_SMP=0 
-  DEFINES += -D__BOOT_KERNEL_UP=0 
+  GLOBAL_DEFINES += -D__BOOT_KERNEL_HUGEMEM=0
+  GLOBAL_DEFINES += -D__BOOT_KERNEL_ENTERPRISE=1 
+  GLOBAL_DEFINES += -D__BOOT_KERNEL_SMP=0 
+  GLOBAL_DEFINES += -D__BOOT_KERNEL_UP=0 
 endif
 ifeq ($(KVER),up)
-  DEFINES += -D__BOOT_KERNEL_HUGEMEM=0
-  DEFINES += -D__BOOT_KERNEL_ENTERPRISE=0 
-  DEFINES += -D__BOOT_KERNEL_SMP=0 
-  DEFINES += -D__BOOT_KERNEL_UP=1 
+  GLOBAL_DEFINES += -D__BOOT_KERNEL_HUGEMEM=0
+  GLOBAL_DEFINES += -D__BOOT_KERNEL_ENTERPRISE=0 
+  GLOBAL_DEFINES += -D__BOOT_KERNEL_SMP=0 
+  GLOBAL_DEFINES += -D__BOOT_KERNEL_UP=1 
 endif
 
-INCLUDES = -Iinc -I$(KERNELINC) -I$(GCCINC)
-
-CFLAGS=$(OPTS) -pipe -nostdinc -fno-strict-aliasing -fno-common \
-	-fomit-frame-pointer $(MODVERSIONS) $(WARNINGS)
-LDADD=-nostdlib
-
-OPTIMIZE = -O2
-
 ifeq ($(OCFS_PROCESSOR),ppc64)
-  DEFINES += -D__LP64__
+  GLOBAL_DEFINES += -D__LP64__
   CFLAGS += -m64 -fsigned-char -fno-builtin -msoft-float -mminimal-toc
   LDADD += -m elf64ppc
 endif
@@ -107,12 +110,50 @@
 ifeq ($(OCFS_PROCESSOR),ia64)
 endif
 ifeq ($(OCFS_PROCESSOR),i686)
-  DEFINES += -D__ILP32__
+  GLOBAL_DEFINES += -D__ILP32__
 endif
 ifeq ($(OCFS_PROCESSOR),i586)
-  DEFINES += -D__ILP32__
+  GLOBAL_DEFINES += -D__ILP32__
 endif
 
+DEFINES += $(BASE_DEFINES) $(GLOBAL_DEFINES)
+
+ifeq ($(OCFS_PROCESSOR),x86_64)
+SUPPORT =
+endif
+ifeq ($(OCFS_PROCESSOR),ia64)
+SUPPORT =
+endif
+ifeq ($(OCFS_PROCESSOR),i686)
+SUPPORT = divdi3.c
+endif
+ifeq ($(OCFS_PROCESSOR),i586)
+SUPPORT = divdi3.c
+endif
+
+# End of stuff which is global for 2.4.x and 2.6.x kernels
+#-********************************************************
+
+# See if we are being included by the 2.6 kernel build system.
+ifeq ($(KERNELRELEASE),)
+# Normal build that is being called locally
+# Preliminary 2.6.x kernel support.  See if we are building for the 2.6.x
+# kernel
+ifndef KERNEL_26
+# Building for a 2.4.x kernel
+
+ifneq ($(OCFS_PROCESSOR),x86_64)
+WARNINGS += -Wmissing-prototypes -Wmissing-declarations
+endif
+
+INCLUDES = -Iinc -I$(KERNELINC) -I$(GCCINC)
+
+CFLAGS=$(OPTS) -pipe -nostdinc -fno-strict-aliasing -fno-common \
+	-fomit-frame-pointer $(MODVERSIONS) $(WARNINGS)
+LDADD=-nostdlib
+
+OPTIMIZE = -O2
+
 CFLAGS += $(OPTIMIZE)
 
 MODULES = ocfs2.o
@@ -147,19 +188,6 @@
 	vote.c
 
 
-ifeq ($(OCFS_PROCESSOR),x86_64)
-SUPPORT =
-endif
-ifeq ($(OCFS_PROCESSOR),ia64)
-SUPPORT =
-endif
-ifeq ($(OCFS_PROCESSOR),i686)
-SUPPORT = divdi3.c
-endif
-ifeq ($(OCFS_PROCESSOR),i586)
-SUPPORT = divdi3.c
-endif
-
 CFILES = $(OSOURCES) $(SUPPORT)
 
 HFILES = \
@@ -196,4 +224,59 @@
 dist-subdircreate:
 	$(TOPDIR)/mkinstalldirs $(DIST_DIR)/inc
 
+
+else # ifndef KERNEL_26
+# The 2.6.x kernel makefile
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
+	$(MAKE) -C $(KDIR) V=1 SUBDIRS=$(OCFS_BUILD_DIR)/src modules
+
+endif # OCFS_KERNEL_2_6
+
 include $(TOPDIR)/Postamble.make
+else # ifeq ($(KERNELRELEASE),)
+# We are being included by the 2.6 kernel build system.  So we will include the
+# 2.6.x Makefile and skip everything else.
+# The 2.6.x kernel makefile
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
+# EXTRA_CFLAGS += -D__ILP32__ -I$(OCFS_SRC_DIR)/inc -Wno-format
+EXTRA_CFLAGS += -I$(OCFS_SRC_DIR)/inc
+
+EXTRA_CFLAGS += $(GLOBAL_DEFINES) $(WARNINGS)
+
+# FIXME: Need to figure out how to use the stuff from Postamble.make.  In
+# particular the MD5 and Version strings
+EXTRA_CFLAGS +=	-DOCFS_BUILD_DATE=\"y\" -DOCFS_BUILD_MD5=\"z\" \
+		-DOCFS_BUILD_VERSION=\"x\"
+
+# Kernel Module file to produce
+obj-m += ocfs2.o
+
+# list of object files that are used to create our module
+ocfs2-objs := alloc.o divdi3.o hash.o ioctl.o oin.o super.o ver.o \
+              bitmap.o dlm.o heartbeat.o journal.o osb.o symlink.o volcfg.o \
+              dcache.o extmap.o inode.o namei.o proc.o sysfile.o vote.o \
+              dir.o file.o io.o nm.o sem.o util.o
+endif # ifneq ($(KERNELRELEASE),)
Index: Config-minimal.make.in
===================================================================
--- /dev/null	2004-02-23 13:02:56.000000000 -0800
+++ Config-minimal.make.in	2004-03-03 16:23:30.173607433 -0800
@@ -0,0 +1,8 @@
+OCFS_DEBUG = @OCFS_DEBUG@
+OCFS_LARGEIO = @OCFS_LARGEIO@
+OCFS_AIO = @OCFS_AIO@
+OCFS_MEMDEBUG = @OCFS_MEMDEBUG@
+OCFS_TRACE = @OCFS_TRACE@
+OCFS_PROCESSOR = @OCFS_PROCESSOR@
+HAVE_NPTL = @HAVE_NPTL@
+USE_JOURNAL_CREATE_REPLACEMENT = @USE_JOURNAL_CREATE_REPLACEMENT@
