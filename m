From: Dan Carpenter <error27@gmail.com>
Date: Sun, 29 May 2011 22:57:16 +0300
Subject: [Ocfs2-devel] [patch] ocfs2: null deref on allocation error
Message-ID: <20110529195716.GD3099@shale.localdomain>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The original code had a null derefence in the error handling.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/fs/ocfs2/ioctl.c b/fs/ocfs2/ioctl.c
index bc91072..d9a6ce7 100644
--- a/fs/ocfs2/ioctl.c
+++ b/fs/ocfs2/ioctl.c
@@ -381,7 +381,7 @@ int ocfs2_info_handle_freeinode(struct inode *inode,
 	if (!oifi) {
 		status = -ENOMEM;
 		mlog_errno(status);
-		goto bail;
+		goto out_err;
 	}
 
 	if (o2info_from_user(*oifi, req))
@@ -431,7 +431,7 @@ bail:
 		o2info_set_request_error(&oifi->ifi_req, req);
 
 	kfree(oifi);
-
+out_err:
 	return status;
 }
 
@@ -666,7 +666,7 @@ int ocfs2_info_handle_freefrag(struct inode *inode,
 	if (!oiff) {
 		status = -ENOMEM;
 		mlog_errno(status);
-		goto bail;
+		goto out_err;
 	}
 
 	if (o2info_from_user(*oiff, req))
@@ -716,7 +716,7 @@ bail:
 		o2info_set_request_error(&oiff->iff_req, req);
 
 	kfree(oiff);
-
+out_err:
 	return status;
 }
 
