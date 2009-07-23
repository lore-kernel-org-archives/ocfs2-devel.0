From: Roel Kluin <roel.kluin@gmail.com>
Date: Thu, 23 Jul 2009 16:23:23 -0000
Subject: [Ocfs2-devel] [PATCH] ocfs2: Keep index within status_map[]
Message-ID: <4A688F02.7040100@gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Do not exceed array status_map[]

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/fs/ocfs2/stack_o2cb.c b/fs/ocfs2/stack_o2cb.c
index 3f66137..e49c410 100644
--- a/fs/ocfs2/stack_o2cb.c
+++ b/fs/ocfs2/stack_o2cb.c
@@ -17,6 +17,7 @@
  * General Public License for more details.
  */
 
+#include <linux/kernel.h>
 #include <linux/crc32.h>
 #include <linux/module.h>
 
@@ -153,7 +154,7 @@ static int status_map[] = {
 
 static int dlm_status_to_errno(enum dlm_status status)
 {
-	BUG_ON(status > (sizeof(status_map) / sizeof(status_map[0])));
+	BUG_ON(status < 0 || status >= ARRAY_SIZE(status_map));
 
 	return status_map[status];
 }
