From: alex chen <alex.chen@huawei.com>
Date: Thu, 2 Apr 2015 11:14:38 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: check if the ocfs2 lock resource
 be initialized before calling ocfs2_dlm_lock
In-Reply-To: <20150331191909.d5445d66.akpm@linux-foundation.org>
References: <5518C165.10106@huawei.com>	<20150331151348.2887ede16683257826833e04@linux-foundation.org>	<551B3F41.6020501@huawei.com>
	<20150331191909.d5445d66.akpm@linux-foundation.org>
Message-ID: <551CB41E.4030005@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Andrew,

On 2015/4/1 10:19, Andrew Morton wrote:
> On Wed, 1 Apr 2015 08:43:45 +0800 Joseph Qi <joseph.qi@huawei.com> wrote:
> 
>>> From: Andrew Morton <akpm@linux-foundation.org>
>>> Subject: ocfs2: make mlog_errno return the errno
>>>
>>> ocfs2 does
>>>
>>> 	mlog_errno(v);
>>> 	return v;
>>>
>>> in many places.  Change mlog_errno() so we can do
>>>
>>> 	return mlog_errno(v);
>>>
>> I don't think this is fit for all.
>> In many places it should do cleanup rather than just return the error
>> code.
> 
> There are about 50 sites which can use this.
> 

Can we define a new macro 'mlog_errno_return' as described below ?
In addition, ocfs2 does
	if (v)
		mlog_errno(v);
	return v;
in some places. In order to deal with this situation we can judge if
'st' is not equal to zero before printing log.

Thanks
Alex

---
 fs/ocfs2/cluster/masklog.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/ocfs2/cluster/masklog.h b/fs/ocfs2/cluster/masklog.h
index 2260fb9..269fef9 100644
--- a/fs/ocfs2/cluster/masklog.h
+++ b/fs/ocfs2/cluster/masklog.h
@@ -204,6 +204,15 @@ extern struct mlog_bits mlog_and_bits, mlog_not_bits;
 		mlog(ML_ERROR, "status = %lld\n", (long long)_st);	\
 } while (0)

+#define mlog_errno_return(st) ({					\
+	int _st = (st);							\
+	if (_st != 0 && _st != -ERESTARTSYS && _st != -EINTR &&		\
+	    _st != AOP_TRUNCATED_PAGE && _st != -ENOSPC &&		\
+	    _st != -EDQUOT)						\
+		mlog(ML_ERROR, "status = %lld\n", (long long)_st);	\
+	st;								\
+})
+
 #define mlog_bug_on_msg(cond, fmt, args...) do {			\
 	if (cond) {							\
 		mlog(ML_ERROR, "bug expression: " #cond "\n");		\
-- 
1.8.4.3
