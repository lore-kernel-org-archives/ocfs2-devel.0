From: Rusty Lynch <rusty@linux.co.intel.com>
Date: Tue Mar 30 19:41:43 2004
Subject: [Ocfs2-devel] [PATCH]Remove 2.6 configure warning
Message-ID: <200403310141.i2V1fS8h008170@penguin.co.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From my own unit testing the 2.6 build is now working with the same
level of functionality as the 2.4 build.  I don't think we need the
2.6 warning in the config script.

(I've been looking forward to saying this :->)

Here is a patch to remove the configure warning.

    --rusty

Index: configure.in
===================================================================
--- configure.in	(revision 825)
+++ configure.in	(working copy)
@@ -194,28 +194,13 @@
   AC_MSG_ERROR([Could not determine kernel version.])
 fi
 
-AC_ARG_ENABLE(kernel-26, [  --enable-kernel-26=[yes/no]   (BROKEN!) Enable building on Linux kernel version 2.6.x (default=no)],enable_kernel26=yes,enable_kernel26=no)
-KERNEL_26=
-if test "x$enable_kernel26" = "xyes"; then
-  KERNEL_26=yes
-fi
-AC_SUBST(KERNEL_26)
-
 case "$kversion" in
   2.4.*)
     ;;
   2.6.*)
-    if test "x$enable_kernel26" = "xyes"; then
-      AC_MSG_WARN([
-Support for kernel version 2.6 is BROKEN at this time! Your system WILL hang.])
-    else
-      AC_MSG_ERROR([
-Support for kernel version 2.6 is BROKEN (Your system WILL hang!) at this time.
-You can use --enable-kernel-26 if you realy know what you're doing.])
-    fi
     ;;
   *)
-    AC_MSG_ERROR([This module only supports kernel version 2.4.x])
+    AC_MSG_ERROR([This module only supports kernel versions 2.4.x and 2.6.x])
     ;;
 esac
 
