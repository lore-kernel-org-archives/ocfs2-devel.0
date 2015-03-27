From: Joe Perches <joe@perches.com>
Date: Thu, 26 Mar 2015 20:07:07 -0700
Subject: [Ocfs2-devel] [PATCH 1/2] ocfs2: Logging: Remove static buffer,
	use vsprintf extension %pV
In-Reply-To: <cover.1427425496.git.joe@perches.com>
References: <cover.1427425496.git.joe@perches.com>
Message-ID: <996120dd3543ce1498aace6de19b94168d5dd4b0.1427425496.git.joe@perches.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>
Cc: ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org

Use the vsprintf %pV extension to avoid using a static buffer
and remove the now unnecessary buffer.

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/ocfs2/super.c | 34 +++++++++++++++++++---------------
 1 file changed, 19 insertions(+), 15 deletions(-)

diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 2dfaa5c..3ee15b3 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -2593,22 +2593,23 @@ static int ocfs2_handle_error(struct super_block *sb)
 
 }
 
-static char error_buf[1024];
-
-int __ocfs2_error(struct super_block *sb,
-		   const char *function,
-		   const char *fmt, ...)
+int __ocfs2_error(struct super_block *sb, const char *function,
+		  const char *fmt, ...)
 {
+	struct va_format vaf;
 	va_list args;
 
 	va_start(args, fmt);
-	vsnprintf(error_buf, sizeof(error_buf), fmt, args);
-	va_end(args);
+
+	vaf.fmt = fmt;
+	vaf.va = &args;
 
 	/* Not using mlog here because we want to show the actual
 	 * function the error came from. */
-	printk(KERN_CRIT "OCFS2: ERROR (device %s): %s: %s\n",
-	       sb->s_id, function, error_buf);
+	printk(KERN_CRIT "OCFS2: ERROR (device %s): %s: %pV\n",
+	       sb->s_id, function, &vaf);
+
+	va_end(args);
 
 	return ocfs2_handle_error(sb);
 }
@@ -2616,18 +2617,21 @@ int __ocfs2_error(struct super_block *sb,
 /* Handle critical errors. This is intentionally more drastic than
  * ocfs2_handle_error, so we only use for things like journal errors,
  * etc. */
-void __ocfs2_abort(struct super_block* sb,
-		   const char *function,
+void __ocfs2_abort(struct super_block *sb, const char *function,
 		   const char *fmt, ...)
 {
+	struct va_format vaf;
 	va_list args;
 
 	va_start(args, fmt);
-	vsnprintf(error_buf, sizeof(error_buf), fmt, args);
-	va_end(args);
 
-	printk(KERN_CRIT "OCFS2: abort (device %s): %s: %s\n",
-	       sb->s_id, function, error_buf);
+	vaf.fmt = fmt;
+	vaf.va = &args;
+
+	printk(KERN_CRIT "OCFS2: abort (device %s): %s: %pV\n",
+	       sb->s_id, function, &vaf);
+
+	va_end(args);
 
 	/* We don't have the cluster support yet to go straight to
 	 * hard readonly in here. Until then, we want to keep
-- 
2.1.2
