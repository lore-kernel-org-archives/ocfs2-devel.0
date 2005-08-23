From: Andreas Gruenbacher <agruen@suse.de>
Date: Tue Aug 23 19:09:29 2005
Subject: [Ocfs2-devel] Minor fs/Kconfig cleanup
Message-ID: <200508231800.00580.agruen@suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hello,

the current ocfs2 code nicely adds "select JBD" for EXT3_FS, but doesn't 
remove the following line, which is obsolete after that. Here's a patch:

Index: linux-2.6.12/fs/Kconfig
===================================================================
--- linux-2.6.12.orig/fs/Kconfig
+++ linux-2.6.12/fs/Kconfig
@@ -140,7 +140,6 @@ config EXT3_FS_SECURITY
 
 config JBD
 	tristate
-	default EXT3_FS
 	help
 	  This is a generic journaling layer for block devices.  It is
 	  currently used by the ext3 and OCFS2 file systems, but it could

Cheers,
-- 
Andreas Gruenbacher <agruen@suse.de>
SUSE Labs, SUSE LINUX PRODUCTS GMBH
