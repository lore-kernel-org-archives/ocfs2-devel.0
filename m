From: Tao Ma <tao.ma@oracle.com>
Date: Mon,  4 May 2009 05:18:09 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Don't print error when listing too
	many xattrs.
Message-ID: <1241385489-24389-1-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Currently, when listing xattrs, kernel define XATTR_LIST_MAX as 65536
in include/linux/limits.h, so it can't handle too many xattrs.

But with ocfs2 xattr tree, we actually have no limit for the number.
And it will pollute the message with something like this when listing.
(27738,0):ocfs2_iterate_xattr_buckets:3158 ERROR: status = -34
(27738,0):ocfs2_xattr_tree_list_index_block:3264 ERROR: status = -34

So don't print "ERROR" message as this is not an ocfs2 error.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/xattr.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 1563101..ba320e2 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -3154,7 +3154,7 @@ static int ocfs2_iterate_xattr_buckets(struct inode *inode,
 		     le32_to_cpu(bucket_xh(bucket)->xh_entries[0].xe_name_hash));
 		if (func) {
 			ret = func(inode, bucket, para);
-			if (ret)
+			if (ret && ret != -ERANGE)
 				mlog_errno(ret);
 			/* Fall through to bucket_relse() */
 		}
@@ -3261,7 +3261,8 @@ static int ocfs2_xattr_tree_list_index_block(struct inode *inode,
 						  ocfs2_list_xattr_bucket,
 						  &xl);
 		if (ret) {
-			mlog_errno(ret);
+			if (ret != -ERANGE)
+				mlog_errno(ret);
 			goto out;
 		}
 
-- 
1.5.5
