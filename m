From: Rusty Lynch <rusty@linux.co.intel.com>
Date: Thu Mar  4 14:35:56 2004
Subject: [Ocfs2-devel] [PATCH]remove mark_info_dirty() hack on 2.6
Message-ID: <200403042035.i24KZjAj000857@penguin.co.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In ocfs.h we have a hack for avoiding warnings by defining 
mark_info_dirty().  This is no longer needed in 2.6, and there
is a patch in the -mm tree that is about to make it into the 
mainline tree that changes the mark_info_dirty() prototype.

The following patch changes ocfs.h to only include the warning
work around if compiling against a 2.4 kernel.

    --rusty

Index: src/inc/ocfs.h
===================================================================
--- src/inc/ocfs.h	(revision 754)
+++ src/inc/ocfs.h	(working copy)
@@ -27,10 +27,6 @@
 #ifndef OCFS_H
 #define OCFS_H
 
-/* XXX Hack to avoid warning */
-struct mem_dqinfo;
-extern inline void mark_info_dirty(struct mem_dqinfo *info);
-
 /*
 ** System header files
 */
@@ -49,6 +45,10 @@
 #endif
 extern inline int generic_fls(int x);
 extern inline int get_bitmask_order(unsigned int count);
+
+/* XXX Hack to avoid warning */
+struct mem_dqinfo;
+extern inline void mark_info_dirty(struct mem_dqinfo *info);
 #endif /* 2.4 kernel */
 
 #include  <linux/module.h>
