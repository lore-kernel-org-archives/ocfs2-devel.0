From: Rusty Lynch <rusty@linux.co.intel.com>
Date: Wed Mar 17 12:25:38 2004
Subject: [Ocfs2-devel] [Build PATCH]Add --enable-lockres-debug
Message-ID: <200403171825.i2HIPRIn022075@penguin.co.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The following patch just enables existing lock resource debug code
that already exist in ocfs.h.  

    --rusty

Index: configure.in
===================================================================
--- configure.in	(revision 781)
+++ configure.in	(working copy)
@@ -104,6 +104,13 @@
 fi
 AC_SUBST(OCFS_MEMDEBUG)
 
+AC_ARG_ENABLE(lockres-debug, [  --enable-lockres-debug=[yes/no]     Turn on lock resource debugging [default=no]],,enable_lockres_debug=no)
+OCFS_DBG_LOCKRES=
+if test "x$enable_lockres_debug" = "xyes"; then
+  OCFS_DBG_LOCKRES=yes
+fi
+AC_SUBST(OCFS_DBG_LOCKRES)
+
 AC_ARG_ENABLE(trace, [  --enable-trace=[yes/no]         Turn on tracing [default=yes]],,enable_trace=yes)
 OCFS_TRACE=
 if test "x$enable_trace" = "xyes"; then
Index: Config.make.in
===================================================================
--- Config.make.in	(revision 781)
+++ Config.make.in	(working copy)
@@ -60,6 +60,7 @@
 OCFS_LARGEIO = @OCFS_LARGEIO@
 OCFS_AIO = @OCFS_AIO@
 OCFS_MEMDEBUG = @OCFS_MEMDEBUG@
+OCFS_DBG_LOCKRES = @OCFS_DBG_LOCKRES@
 OCFS_TRACE = @OCFS_TRACE@
 OCFS_PROCESSOR = @OCFS_PROCESSOR@
 
Index: src/Makefile
===================================================================
--- src/Makefile	(revision 781)
+++ src/Makefile	(working copy)
@@ -33,6 +33,10 @@
 GLOBAL_DEFINES += -DOCFS_LINUX_MEM_DEBUG -DDEBUG_SLAB_ALLOCS
 endif
 
+ifdef OCFS_DBG_LOCKRES
+GLOBAL_DEFINES += -DOCFS_DBG_LOCKRES
+endif
+
 ifdef OCFS_AIO
 GLOBAL_DEFINES += -DAIO_ENABLED
 endif
