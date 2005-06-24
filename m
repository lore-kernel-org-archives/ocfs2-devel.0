From: Adrian Bunk <bunk@stusta.de>
Date: Fri Jun 24 03:03:19 2005
Subject: [Ocfs2-devel] [-mm patch] CONFIGFS_FS shouldn't be user-visible
Message-ID: <20050624080315.GC26545@stusta.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joel Becker <joel.becker@oracle.com>
Cc: ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org

I haven't found any reason why CONFIGFS_FS is user-visible.
Other parts of the kernel using configfs should simply select it.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

--- linux-2.6.12-mm1-full/fs/Kconfig.old	2005-06-21 23:19:19.000000000 +0200
+++ linux-2.6.12-mm1-full/fs/Kconfig	2005-06-21 23:22:30.000000000 +0200
@@ -981,16 +981,7 @@
 	  ramfs.
 
 config CONFIGFS_FS
-	tristate "Userspace-driven configuration filesystem (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
-	help
-	  configfs is a ram-based filesystem that provides the converse
-	  of sysfs's functionality. Where sysfs is a filesystem-based
-	  view of kernel objects, configfs is a filesystem-based manager
-	  of kernel objects, or config_items.
-
-	  Both sysfs and configfs can and should exist together on the
-	  same system. One is not a replacement for the other.
+	tristate
 
 config RELAYFS_FS
 	tristate "Relayfs file system support"
