From: Tiger Yang <tiger.yang@oracle.com>
Date: Fri,  9 Nov 2012 12:43:48 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix BUG_ON issue in
	ocfs2_set_new_buffer_uptodate
Message-ID: <1352436228-18544-1-git-send-email-tiger.yang@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

If buffer already in cache, call ocfs2_init_xattr_bucket will cause BUG_ON
in ocfs2_set_new_buffer_uptodate. The check of ocfs2_buffer_uptodate
in ocfs2_init_xattr_bucket wouldn't help this. So replace it with
ocfs2_read_xattr_bucket to initialize the bucket to avoid this issue.

Signed-off-by: Tiger Yang <tiger.yang@oracle.com>
---
 fs/ocfs2/xattr.c |   12 ++----------
 1 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index dce35dd..0085261 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -4640,11 +4640,7 @@ static int ocfs2_divide_xattr_bucket(struct inode *inode,
 		goto out;
 	}
 
-	/*
-	 * Even if !new_bucket_head, we're overwriting t_bucket.  Thus,
-	 * there's no need to read it.
-	 */
-	ret = ocfs2_init_xattr_bucket(t_bucket, new_blk);
+	ret = ocfs2_read_xattr_bucket(t_bucket, new_blk);
 	if (ret) {
 		mlog_errno(ret);
 		goto out;
@@ -4806,11 +4802,7 @@ static int ocfs2_cp_xattr_bucket(struct inode *inode,
 	if (ret)
 		goto out;
 
-	/*
-	 * Even if !t_is_new, we're overwriting t_bucket.  Thus,
-	 * there's no need to read it.
-	 */
-	ret = ocfs2_init_xattr_bucket(t_bucket, t_blkno);
+	ret = ocfs2_read_xattr_bucket(t_bucket, t_blkno);
 	if (ret)
 		goto out;
 
-- 
1.7.4.4
