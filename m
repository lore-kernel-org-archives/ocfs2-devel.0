From: John L. Villalovos <john.l.villalovos@intel.com>
Date: Fri Jul  2 13:00:14 2004
Subject: [Ocfs2-devel] Patch to fix the dist rule in ocfs-tools
Message-ID: <40E5A2A8.6030700@intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Index: ocfs2/libocfs2/Makefile
===================================================================
--- ocfs2/libocfs2/Makefile	(revision 127)
+++ ocfs2/libocfs2/Makefile	(working copy)
@@ -65,6 +65,7 @@

  HFILES =				\
  	include/jfs_user.h		\
+	include/jfs_compat.h		\
  	include/kernel-jbd.h		\
  	include/kernel-list.h		\
  	include/ocfs2_fs.h		\
Index: ocfs2/debugfs.ocfs2/Makefile
===================================================================
--- ocfs2/debugfs.ocfs2/Makefile	(revision 127)
+++ ocfs2/debugfs.ocfs2/Makefile	(working copy)
@@ -21,4 +21,9 @@
  debugfs.ocfs2: $(OBJS)
  	$(LINK) $(GLIB_LIBS) -lreadline -lncurses

+DIST_RULES = dist-subdircreate
+
+dist-subdircreate:
+	$(TOPDIR)/mkinstalldirs $(DIST_DIR)/include
+
  include $(TOPDIR)/Postamble.make
