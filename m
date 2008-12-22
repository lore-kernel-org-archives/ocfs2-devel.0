From: Mark Fasheh <mfasheh@suse.com>
Date: Mon, 22 Dec 2008 13:48:24 -0800
Subject: [Ocfs2-devel] [PATCH 43/56] ocfs2: Narrow the transaction for
	deleting xattrs from a bucket.
In-Reply-To: <1229982517-3455-1-git-send-email-mfasheh@suse.com>
References: <1229982517-3455-1-git-send-email-mfasheh@suse.com>
Message-ID: <1229982517-3455-44-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>, Tao Ma <tao.ma@oracle.com>, Mark Fasheh <mfasheh@suse.com>

From: Tao Ma <tao.ma@oracle.com>

We move the transaction into the loop because in
ocfs2_remove_extent, we will double the credits in function
ocfs2_extend_rotate_transaction. So if we have a large loop
number, we will soon waste much the journal space.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/xattr.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 6db68a2..df53a2c 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -5094,30 +5094,30 @@ static int ocfs2_delete_xattr_in_bucket(struct inode *inode,
 
 	ocfs2_init_dealloc_ctxt(&ctxt.dealloc);
 
-	ctxt.handle = ocfs2_start_trans(osb, credits);
-	if (IS_ERR(ctxt.handle)) {
-		ret = PTR_ERR(ctxt.handle);
-		mlog_errno(ret);
-		goto out;
-	}
-
 	for (i = 0; i < le16_to_cpu(xh->xh_count); i++) {
 		xe = &xh->xh_entries[i];
 		if (ocfs2_xattr_is_local(xe))
 			continue;
 
+		ctxt.handle = ocfs2_start_trans(osb, credits);
+		if (IS_ERR(ctxt.handle)) {
+			ret = PTR_ERR(ctxt.handle);
+			mlog_errno(ret);
+			break;
+		}
+
 		ret = ocfs2_xattr_bucket_value_truncate(inode, bucket,
 							i, 0, &ctxt);
+
+		ocfs2_commit_trans(osb, ctxt.handle);
 		if (ret) {
 			mlog_errno(ret);
 			break;
 		}
 	}
 
-	ret = ocfs2_commit_trans(osb, ctxt.handle);
 	ocfs2_schedule_truncate_log_flush(osb, 1);
 	ocfs2_run_deallocs(osb, &ctxt.dealloc);
-out:
 	return ret;
 }
 
-- 
1.5.6
