From: Joe Perches <joe@perches.com>
Date: Fri, 17 Apr 2015 00:17:50 -0700
Subject: [Ocfs2-devel] [PATCH next] ocfs2: Reduce object size of mlog uses
Message-ID: <1429255070.2850.84.camel@perches.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: ocfs2-devel@oss.oracle.com, LKML <linux-kernel@vger.kernel.org>

Using a function for __mlog_printk instead of a macro
reduces the object size of built-in.o more than 120KB, or
~10% overall (x86-64 defconfig with all ocfs2 options)

$ size fs/ocfs2/built-in.o*
   text	   data	    bss	    dec	    hex	filename
 936255	 118071	 134408	1188734	 12237e	fs/ocfs2/built-in.o.new
1064081	 118071	 134408	1316560	 1416d0	fs/ocfs2/built-in.o.old

Miscellanea:

o Neaten macros around the __mlog_printk uses.
o Use __func__ for __PRETTY_FUNCTION__
o Use ##__VA_ARGS__ for args...

Signed-off-by: Joe Perches <joe@perches.com>
---
Compiled/untested

 fs/ocfs2/cluster/masklog.c | 17 +++++++++++++++++
 fs/ocfs2/cluster/masklog.h | 28 +++++++++++++++++-----------
 2 files changed, 34 insertions(+), 11 deletions(-)

diff --git a/fs/ocfs2/cluster/masklog.c b/fs/ocfs2/cluster/masklog.c
index af7598b..5b7a351 100644
--- a/fs/ocfs2/cluster/masklog.c
+++ b/fs/ocfs2/cluster/masklog.c
@@ -64,6 +64,23 @@ static ssize_t mlog_mask_store(u64 mask, const char *buf, size_t count)
 	return count;
 }
 
+void __mlog_printk(const char *level, const char *func, int line,
+		   const char *fmt, ...)
+{
+	struct va_format vaf;
+	va_list args;
+
+	va_start(args, fmt);
+
+	vaf.fmt = fmt;
+	vaf.va = &args;
+
+	printk("%s(%s,%u,%lu):%s:%d %pV",
+	       level, current->comm, task_pid_nr(current), __mlog_cpu_guess,
+	       func, line, &vaf);
+
+	va_end(args);
+}
 struct mlog_attribute {
 	struct attribute attr;
 	u64 mask;
diff --git a/fs/ocfs2/cluster/masklog.h b/fs/ocfs2/cluster/masklog.h
index 7fdc25a..6036e6a 100644
--- a/fs/ocfs2/cluster/masklog.h
+++ b/fs/ocfs2/cluster/masklog.h
@@ -168,7 +168,8 @@ extern struct mlog_bits mlog_and_bits, mlog_not_bits;
  * scream.  just do this instead of trying to guess which we're building
  * against.. *sigh*.
  */
-#define __mlog_cpu_guess ({		\
+#define __mlog_cpu_guess		\
+({					\
 	unsigned long _cpu = get_cpu();	\
 	put_cpu();			\
 	_cpu;				\
@@ -178,21 +179,25 @@ extern struct mlog_bits mlog_and_bits, mlog_not_bits;
  * before ##args is intentional. Otherwise, gcc 2.95 will eat the
  * previous token if args expands to nothing.
  */
-#define __mlog_printk(level, fmt, args...)				\
-	printk(level "(%s,%u,%lu):%s:%d " fmt, current->comm,		\
-	       task_pid_nr(current), __mlog_cpu_guess,			\
-	       __PRETTY_FUNCTION__, __LINE__ , ##args)
+__printf(4, 5)
+void __mlog_printk(const char *level, const char *func, int line,
+		   const char *fmt, ...);
 
-#define mlog(mask, fmt, args...) do {					\
+#define mlog(mask, fmt, ...)						\
+do {									\
 	u64 __m = MLOG_MASK_PREFIX | (mask);				\
 	if ((__m & ML_ALLOWED_BITS) &&					\
 	    __mlog_test_u64(__m, mlog_and_bits) &&			\
 	    !__mlog_test_u64(__m, mlog_not_bits)) {			\
 		if (__m & ML_ERROR)					\
-			__mlog_printk(KERN_ERR, "ERROR: "fmt , ##args);	\
+			__mlog_printk(KERN_ERR, __func__, __LINE__,	\
+				      "ERROR: " fmt, ##__VA_ARGS__);	\
 		else if (__m & ML_NOTICE)				\
-			__mlog_printk(KERN_NOTICE, fmt , ##args);	\
-		else __mlog_printk(KERN_INFO, fmt , ##args);		\
+			__mlog_printk(KERN_NOTICE, __func__, __LINE__,	\
+				      fmt, ##__VA_ARGS__);		\
+		else							\
+			__mlog_printk(KERN_INFO, __func__, __LINE__,	\
+				      fmt, ##__VA_ARGS__);		\
 	}								\
 } while (0)
 
@@ -205,10 +210,11 @@ extern struct mlog_bits mlog_and_bits, mlog_not_bits;
 	_st;								\
 })
 
-#define mlog_bug_on_msg(cond, fmt, args...) do {			\
+#define mlog_bug_on_msg(cond, fmt, ...)					\
+do {									\
 	if (cond) {							\
 		mlog(ML_ERROR, "bug expression: " #cond "\n");		\
-		mlog(ML_ERROR, fmt, ##args);				\
+		mlog(ML_ERROR, fmt, ##__VA_ARGS__);			\
 		BUG();							\
 	}								\
 } while (0)
