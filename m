From: Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 1 Apr 2015 20:45:41 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: check if the ocfs2 lock resource
 be initialized before calling ocfs2_dlm_lock
In-Reply-To: <551CB41E.4030005@huawei.com>
References: <5518C165.10106@huawei.com>
	<20150331151348.2887ede16683257826833e04@linux-foundation.org>
	<551B3F41.6020501@huawei.com>
	<20150331191909.d5445d66.akpm@linux-foundation.org>
	<551CB41E.4030005@huawei.com>
Message-ID: <20150401204541.585fc044.akpm@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, 2 Apr 2015 11:14:38 +0800 alex chen <alex.chen@huawei.com> wrote:

> >>>
> >> I don't think this is fit for all.
> >> In many places it should do cleanup rather than just return the error
> >> code.
> > 
> > There are about 50 sites which can use this.
> > 
> 
> Can we define a new macro 'mlog_errno_return' as described below ?
> In addition, ocfs2 does
> 	if (v)
> 		mlog_errno(v);
> 	return v;
> in some places. In order to deal with this situation we can judge if
> 'st' is not equal to zero before printing log.

Macros which hide control flow are evil, although in this case the
"return" in the name gives people info about what's happening.

But why bother?  This:

--- a/fs/ocfs2/cluster/masklog.h~ocfs2-make-mlog_errno-return-the-errno
+++ a/fs/ocfs2/cluster/masklog.h
@@ -196,13 +196,14 @@ extern struct mlog_bits mlog_and_bits, m
 	}								\
 } while (0)
 
-#define mlog_errno(st) do {						\
+#define mlog_errno(st) ({						\
 	int _st = (st);							\
 	if (_st != -ERESTARTSYS && _st != -EINTR &&			\
 	    _st != AOP_TRUNCATED_PAGE && _st != -ENOSPC &&		\
 	    _st != -EDQUOT)						\
 		mlog(ML_ERROR, "status = %lld\n", (long long)_st);	\
-} while (0)
+	st;								\
+})
 
 #define mlog_bug_on_msg(cond, fmt, args...) do {			\
 	if (cond) {							\


is clean, idiomatic and works great.  And with no other change it
shrinks the fs object code by 6k.



Gad, mlog_errno() is a *huge* source of bloat.  Look:

--- a/fs/ocfs2/cluster/masklog.h~a
+++ a/fs/ocfs2/cluster/masklog.h
@@ -183,27 +183,9 @@ extern struct mlog_bits mlog_and_bits, m
 	       task_pid_nr(current), __mlog_cpu_guess,			\
 	       __PRETTY_FUNCTION__, __LINE__ , ##args)
 
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
-} while (0)
+#define mlog(mask, fmt, args...) do { } while (0)
 
-#define mlog_errno(st) ({						\
-	int _st = (st);							\
-	if (_st != -ERESTARTSYS && _st != -EINTR &&			\
-	    _st != AOP_TRUNCATED_PAGE && _st != -ENOSPC &&		\
-	    _st != -EDQUOT)						\
-		mlog(ML_ERROR, "status = %lld\n", (long long)_st);	\
-	st;								\
-})
+#define mlog_errno(st) do { } while (0)
 
 #define mlog_bug_on_msg(cond, fmt, args...) do {			\
 	if (cond) {							\


z:/usr/src/25> size fs/ocfs2/ocfs2.ko
   text    data     bss     dec     hex filename
1140849   82767  832192 2055808  1f5e80 fs/ocfs2/ocfs2.ko-before
 675402   82767  226104  984273   f04d1 fs/ocfs2/ocfs2.ko


It almost doubles the size of the object code!

Someone, please put this thing on a diet.  It doesn't all need to be
inlined.  We could just do

extern void __mlog_errno(int st);
#define mlog_errno(st) __mlog_errno(st, __LINE__)

and save hundreds of kilobytes of text.  It'll be faster too, due to the
reduced instruction cache footprint.
