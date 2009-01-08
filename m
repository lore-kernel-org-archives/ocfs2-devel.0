From: Tao Ma <tao.ma@oracle.com>
Date: Thu,  8 Jan 2009 08:21:43 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Access the xattr bucket only before
	modifying it.
Message-ID: <1231374103-5765-1-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Mark,
	This is the fix for 2.6.29(introduced by uniting the bucket journal
access). Since I found no fixes-for-2.6.29 in your ocfs2.git, it is based
on your original upstream-linus.

In ocfs2_xattr_value_truncate, we may call b-tree codes which will
extend the journal transaction. It has a potential problem that it
may let the already-accessed-but-not-dirtied buffers gone. So we'd
better access the bucket after we call ocfs2_xattr_value_truncate.
And as for the root buffer for the xattr value, b-tree code will
acess and dirty it, so we don't need to worry about it.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/xattr.c |   17 ++++++++---------
 1 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index e1d638a..915039f 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -4729,13 +4729,6 @@ static int ocfs2_xattr_bucket_value_truncate(struct inode *inode,
 	vb.vb_xv = (struct ocfs2_xattr_value_root *)
 		(vb.vb_bh->b_data + offset % blocksize);
 
-	ret = ocfs2_xattr_bucket_journal_access(ctxt->handle, bucket,
-						OCFS2_JOURNAL_ACCESS_WRITE);
-	if (ret) {
-		mlog_errno(ret);
-		goto out;
-	}
-
 	/*
 	 * From here on out we have to dirty the bucket.  The generic
 	 * value calls only modify one of the bucket's bhs, but we need
@@ -4748,12 +4741,18 @@ static int ocfs2_xattr_bucket_value_truncate(struct inode *inode,
 	ret = ocfs2_xattr_value_truncate(inode, &vb, len, ctxt);
 	if (ret) {
 		mlog_errno(ret);
-		goto out_dirty;
+		goto out;
+	}
+
+	ret = ocfs2_xattr_bucket_journal_access(ctxt->handle, bucket,
+						OCFS2_JOURNAL_ACCESS_WRITE);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
 	}
 
 	xe->xe_value_size = cpu_to_le64(len);
 
-out_dirty:
 	ocfs2_xattr_bucket_journal_dirty(ctxt->handle, bucket);
 
 out:
-- 
1.5.5
