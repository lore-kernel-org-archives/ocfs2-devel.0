From: John Villalovos <John.L.Villalovos@intel.com>
Date: Fri Feb 27 13:51:34 2004
Subject: [Ocfs2-devel] Patch for 2.6 support in configure
Message-ID: <3779.10.10.213.44.1077910769.squirrel@linux.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This patch add support for using a 2.6.x kernel when running configure.

It requires the user to use "--enable-kernel-2_6" to enable it.  It also
creates an OCFS_KERNEL_2_6 Makefile variable that is put into
Config.make.in

I am working on using this information in the src/Makefile to add
support for 2.6

John


Index: configure.in
=================================================================== ---
configure.in	(revision 36)
+++ configure.in	(working copy)
@@ -83,6 +83,13 @@
   AC_MSG_ERROR(GCC is required)
 fi

+AC_ARG_ENABLE(kernel-2_6, AS_HELP_STRING([--enable-kernel-2_6],
[(BROKEN!) Enable building on Linux kernel version 2.6.x
(default=no)]),enable_kernel26=yes,enable_kernel26=no)
+OCFS_KERNEL_2_6=
+if test "x$enable_kernel26" = "xyes"; then
+  OCFS_KERNEL_2_6=yes
+fi
+AC_SUBST(OCFS_KERNEL_2_6)
+
 AC_ARG_ENABLE(debug, [  --enable-debug=[yes/no]         Turn on
debugging
[default=yes]],,enable_debug=yes)
 OCFS_DEBUG=
 if test "x$enable_debug" = "xyes"; then
@@ -178,6 +185,13 @@
 case "$kversion" in
   2.4.*)
     ;;
+  2.6.*)
+    if test "x$enable_kernel26" = "xyes"; then
+      AC_MSG_NOTICE([Support for kernel version 2.6 is BROKEN at this
time!])
+    else
+      AC_MSG_ERROR([Support for kernel version 2.6 is BROKEN (System
Hangs) at this time!  You must use --enable-kernel-2_6 to get past this
point.])
+    fi
+    ;;
   *)
     AC_MSG_ERROR([This module only supports kernel version 2.4.x]) ;;
Index: Config.make.in
=================================================================== ---
Config.make.in	(revision 36)
+++ Config.make.in	(working copy)
@@ -58,5 +58,6 @@
 OCFS_MEMDEBUG = @OCFS_MEMDEBUG@
 OCFS_TRACE = @OCFS_TRACE@
 OCFS_PROCESSOR = @OCFS_PROCESSOR@
+OCFS_KERNEL_2_6 = @OCFS_KERNEL_2_6@

 USE_JOURNAL_CREATE_REPLACEMENT = @USE_JOURNAL_CREATE_REPLACEMENT@


-------------- next part --------------
A non-text attachment was scrubbed...
Name: configure.in.diff
Type: application/octet-stream
Size: 1499 bytes
Desc: not available
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20040227/4e61d0f7/configure.in.obj
