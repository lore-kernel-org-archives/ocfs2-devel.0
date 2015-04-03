From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Fri, 3 Apr 2015 11:33:30 +0300
Subject: [Ocfs2-devel] [patch] ocfs2: double evaluation concerns in
	mlog_errno()
Message-ID: <20150403083330.GA27007@mwanda>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

It won't happen in real life, but for consistency etc then we should
only evaluate the "st" parameter once.

Also, since not all callers use the new return, it causes at static
checker warning:
fs/ocfs2/export.c:138 ocfs2_get_dentry() warn: unchecked 'PTR_ERR'

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/fs/ocfs2/cluster/masklog.h b/fs/ocfs2/cluster/masklog.h
index f96a51d..7fdc25a 100644
--- a/fs/ocfs2/cluster/masklog.h
+++ b/fs/ocfs2/cluster/masklog.h
@@ -202,7 +202,7 @@ extern struct mlog_bits mlog_and_bits, mlog_not_bits;
 	    _st != AOP_TRUNCATED_PAGE && _st != -ENOSPC &&		\
 	    _st != -EDQUOT)						\
 		mlog(ML_ERROR, "status = %lld\n", (long long)_st);	\
-	st;								\
+	_st;								\
 })
 
 #define mlog_bug_on_msg(cond, fmt, args...) do {			\
