From: Joe Perches <joe@perches.com>
Date: Thu, 23 Apr 2015 00:25:08 -0700
Subject: [Ocfs2-devel] [PATCH V2 -next] ocfs2: Reduce object size of mlog
	uses
In-Reply-To: <20150422154604.3cb62467b66b1e313a30132c@linux-foundation.org>
References: <1429255070.2850.84.camel@perches.com>
	<20150422154604.3cb62467b66b1e313a30132c@linux-foundation.org>
Message-ID: <1429773908.32612.32.camel@perches.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>, ocfs2-devel@oss.oracle.com, LKML <linux-kernel@vger.kernel.org>

Using a function for __mlog_printk instead of a macro
reduces the object size of built-in.o by about 190KB, or
~18% overall (x86-64 defconfig with all ocfs2 options)

$ size fs/ocfs2/built-in.o*
   text    data     bss     dec     hex filename
 870954	 118471	 134408	1123833	 1125f9	fs/ocfs2/built-in.o,new
1064081  118071  134408 1316560  1416d0 fs/ocfs2/built-in.o.old

Miscellanea:

o Move the used-once __mlog_cpu_guess statement expression macro
  to the masklog.c file above the use in __mlog_printk function
o Simplify the mlog macro moving the and/or logic and level code
  into __mlog_printk

Signed-off-by: Joe Perches <joe@perches.com>
---

V2: Moving and/or logic to the __mlog_printk function reduces
    the object size an additional ~65K

 fs/ocfs2/cluster/masklog.c | 46 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/ocfs2/cluster/masklog.h | 42 ++++++++++++------------------------------
 2 files changed, 58 insertions(+), 30 deletions(-)

diff --git a/fs/ocfs2/cluster/masklog.c b/fs/ocfs2/cluster/masklog.c
index af7598b..fc5e522 100644
--- a/fs/ocfs2/cluster/masklog.c
+++ b/fs/ocfs2/cluster/masklog.c
@@ -64,6 +64,52 @@ static ssize_t mlog_mask_store(u64 mask, const char *buf, size_t count)
 	return count;
 }
 
+/*
+ * smp_processor_id() "helpfully" screams when called outside preemptible
+ * regions in current kernels.  sles doesn't have the variants that don't
+ * scream.  just do this instead of trying to guess which we're building
+ * against.. *sigh*.
+ */
+#define __mlog_cpu_guess						\
+({									\
+	unsigned long _cpu = get_cpu();					\
+	put_cpu();							\
+	_cpu;								\
+})
+
+void __mlog_printk(const u64 *mask, const char *func, int line,
+		   const char *fmt, ...)
+{
+	struct va_format vaf;
+	va_list args;
+	const char *level;
+	const char *prefix = "";
+
+	if (!__mlog_test_u64(*mask, mlog_and_bits) ||
+	    __mlog_test_u64(*mask, mlog_not_bits))
+		return;
+
+	if (*mask & ML_ERROR) {
+		level = KERN_ERR;
+		prefix = "ERROR: ";
+	} else if (*mask & ML_NOTICE) {
+		level = KERN_NOTICE;
+	} else {
+		level = KERN_INFO;
+	}
+
+	va_start(args, fmt);
+
+	vaf.fmt = fmt;
+	vaf.va = &args;
+
+	printk("%s(%s,%u,%lu):%s:%d %s%pV",
+	       level, current->comm, task_pid_nr(current), __mlog_cpu_guess,
+	       func, line, prefix, &vaf);
+
+	va_end(args);
+}
+
 struct mlog_attribute {
 	struct attribute attr;
 	u64 mask;
diff --git a/fs/ocfs2/cluster/masklog.h b/fs/ocfs2/cluster/masklog.h
index 7fdc25a..308ea0e 100644
--- a/fs/ocfs2/cluster/masklog.h
+++ b/fs/ocfs2/cluster/masklog.h
@@ -162,38 +162,20 @@ extern struct mlog_bits mlog_and_bits, mlog_not_bits;
 
 #endif
 
-/*
- * smp_processor_id() "helpfully" screams when called outside preemptible
- * regions in current kernels.  sles doesn't have the variants that don't
- * scream.  just do this instead of trying to guess which we're building
- * against.. *sigh*.
- */
-#define __mlog_cpu_guess ({		\
-	unsigned long _cpu = get_cpu();	\
-	put_cpu();			\
-	_cpu;				\
-})
+__printf(4, 5)
+void __mlog_printk(const u64 *m, const char *func, int line,
+		   const char *fmt, ...);
 
-/* In the following two macros, the whitespace after the ',' just
- * before ##args is intentional. Otherwise, gcc 2.95 will eat the
- * previous token if args expands to nothing.
+/*
+ * Testing before the __mlog_printk call lets the compiler eliminate the
+ * call completely when (m & ML_ALLOWED_BITS) is 0.
  */
-#define __mlog_printk(level, fmt, args...)				\
-	printk(level "(%s,%u,%lu):%s:%d " fmt, current->comm,		\
-	       task_pid_nr(current), __mlog_cpu_guess,			\
-	       __PRETTY_FUNCTION__, __LINE__ , ##args)
-
-#define mlog(mask, fmt, args...) do {					\
-	u64 __m = MLOG_MASK_PREFIX | (mask);				\
-	if ((__m & ML_ALLOWED_BITS) &&					\
-	    __mlog_test_u64(__m, mlog_and_bits) &&			\
-	    !__mlog_test_u64(__m, mlog_not_bits)) {			\
-		if (__m & ML_ERROR)					\
-			__mlog_printk(KERN_ERR, "ERROR: "fmt , ##args);	\
-		else if (__m & ML_NOTICE)				\
-			__mlog_printk(KERN_NOTICE, fmt , ##args);	\
-		else __mlog_printk(KERN_INFO, fmt , ##args);		\
-	}								\
+#define mlog(mask, fmt, ...)						\
+do {									\
+	u64 _m = MLOG_MASK_PREFIX | (mask);				\
+	if (_m & ML_ALLOWED_BITS)					\
+		__mlog_printk(&_m, __func__, __LINE__, fmt,		\
+			      ##__VA_ARGS__);				\
 } while (0)
 
 #define mlog_errno(st) ({						\
