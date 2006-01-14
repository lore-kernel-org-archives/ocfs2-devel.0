From: Adrian Bunk <bunk@stusta.de>
Date: Sat, 14 Jan 2006 20:55:10 +0100
Subject: [Ocfs2-devel] [-mm patch] fs/ocfs2/dlm/dlmrecovery.c must #include
	<linux/delay.h>
Message-ID: <20060114195510.GQ29663@stusta.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: mark.fasheh@oracle.com, kurt.hackel@oracle.com
Cc: ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org

fs/ocfs2/dlm/dlmrecovery.c does now use msleep(), and does therefore 
need to #include <linux/delay.h> for getting the prototype of this 
function.


Signed-off-by: Adrian Bunk <bunk@stusta.de>

--- linux-2.6.15-mm4-full/fs/ocfs2/dlm/dlmrecovery.c.old	2006-01-14 16:44:15.000000000 +0100
+++ linux-2.6.15-mm4-full/fs/ocfs2/dlm/dlmrecovery.c	2006-01-14 16:45:06.000000000 +0100
@@ -39,6 +39,7 @@
 #include <linux/inet.h>
 #include <linux/timer.h>
 #include <linux/kthread.h>
+#include <linux/delay.h>
 
 
 #include "cluster/heartbeat.h"
