From: Rusty Lynch <rusty@linux.co.intel.com>
Date: Mon Mar 29 18:39:30 2004
Subject: [Ocfs2-devel] [PATCH] Turn off verbose 2.6 build
Message-ID: <200403300036.i2U0aPGH004761@penguin.co.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Now that the 2.6 build works just fine, here is a patch to remove
the "V=1" argument that forces extra verbose output when there
are no warnings or errors.

  --rusty

Index: src/Makefile
===================================================================
--- src/Makefile	(revision 821)
+++ src/Makefile	(working copy)
@@ -238,7 +238,7 @@
 KDIR	:= $(KERNELDIR)
 
 all:
-	$(MAKE) -C $(KDIR) V=1 SUBDIRS=$(CURDIR) modules
+	$(MAKE) -C $(KDIR) SUBDIRS=$(CURDIR) modules
 
 endif # OCFS_KERNEL_2_6
 
