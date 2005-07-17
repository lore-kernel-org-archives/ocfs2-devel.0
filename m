From: Adrian Bunk <bunk@stusta.de>
Date: Sun Jul 17 14:42:09 2005
Subject: [Ocfs2-devel] [-mm patch] OCFS2_FS must depend on NET
Message-ID: <20050717194207.GB3753@stusta.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com
Cc: linux-kernel@vger.kernel.org

If you select some variable, you have to ensure that the dependencies of 
the select'ed variable are fulfilled.

OCFS2_FS=y, NET=n, INET=y is not a legal combination (resulting in link 
errors).

Signed-off-by: Adrian Bunk <bunk@stusta.de>

--- linux-2.6.13-rc3-mm1-full/fs/Kconfig.old	2005-07-17 21:35:15.000000000 +0200
+++ linux-2.6.13-rc3-mm1-full/fs/Kconfig	2005-07-17 21:35:54.000000000 +0200
@@ -327,11 +327,11 @@
 
 source "fs/xfs/Kconfig"
 
 config OCFS2_FS
 	tristate "OCFS2 file system support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && (X86 || IA64 || X86_64 || BROKEN)
+	depends on NET && EXPERIMENTAL && (X86 || IA64 || X86_64 || BROKEN)
 	select CONFIGFS_FS
 	select JBD
 	select CRC32
 	select INET
 	help
