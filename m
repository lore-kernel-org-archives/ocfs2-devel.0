From: Christoph Hellwig <hch@lst.de>
Date: Wed Jun  2 13:10:23 2004
Subject: [Ocfs2-devel] [PATCH] don't error out on unknown architecture
Message-ID: <20040602094038.GA23500@lst.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


Index: configure.in
===================================================================
--- configure.in	(revision 969)
+++ configure.in	(working copy)
@@ -60,9 +60,6 @@
   i386|i486|i586|i686|i786|k6|k7)
     OCFS_PROCESSOR="i686"
     ;;
-  *)
-    AC_MSG_ERROR([not configured for "$host_cpu"])
-    ;;
 esac
 
 AC_SUBST(OCFS_PROCESSOR)
