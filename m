From: Ling, Xiaofeng <xiaofeng.ling@intel.com>
Date: Thu Apr  1 21:56:58 2004
Subject: [Ocfs2-devel] [Patch] install module on 2.6
Message-ID: <3ACA40606221794F80A5670F0AF15F8403D2C732@PDSMSX403.ccr.corp.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

It seems on 2.6 kernel, "make install" does not work.
A simple patch to fix it


Index: src/Makefile
===================================================================
--- src/Makefile	(revision 833)
+++ src/Makefile	(working copy)
@@ -239,7 +239,13 @@
 
 all:
 	$(MAKE) -C $(KDIR) SUBDIRS=$(CURDIR) modules
+install:install-ocfs
 
+install-ocfs: ocfs2.ko
+	$(TOPDIR)/mkinstalldirs $(DESTDIR)$(MODULEDIR)/ocfs
+	$(INSTALL_DATA) ocfs2.ko $(DESTDIR)$(MODULEDIR)/ocfs/ocfs2.ko
+	depmod -a
+
 endif # OCFS_KERNEL_2_6
 
 include $(TOPDIR)/Postamble.make


-------------------
Xiaofeng
xfling@users.sourceforge.net
