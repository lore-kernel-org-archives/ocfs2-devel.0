From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Fri, 12 Feb 2010 14:09:06 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Add current->comm in trace output
Message-ID: <1266012546-13865-1-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Add current->comm to the standard mlog() output to help with debugging.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/cluster/masklog.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/cluster/masklog.h b/fs/ocfs2/cluster/masklog.h
index b792005..1ef480d 100644
--- a/fs/ocfs2/cluster/masklog.h
+++ b/fs/ocfs2/cluster/masklog.h
@@ -194,9 +194,9 @@ extern struct mlog_bits mlog_and_bits, mlog_not_bits;
  * previous token if args expands to nothing.
  */
 #define __mlog_printk(level, fmt, args...)				\
-	printk(level "(%u,%lu):%s:%d " fmt, task_pid_nr(current),	\
-	       __mlog_cpu_guess, __PRETTY_FUNCTION__, __LINE__ ,	\
-	       ##args)
+	printk(level "(%s,%u,%lu):%s:%d " fmt, current->comm,		\
+	       task_pid_nr(current), __mlog_cpu_guess,			\
+	       __PRETTY_FUNCTION__, __LINE__ , ##args)
 
 #define mlog(mask, fmt, args...) do {					\
 	u64 __m = MLOG_MASK_PREFIX | (mask);				\
-- 
1.6.3.3
