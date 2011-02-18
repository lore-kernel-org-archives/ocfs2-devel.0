From: Tristan Ye <tristan.ye@oracle.com>
Date: Fri, 18 Feb 2011 12:26:48 +0800
Subject: [Ocfs2-devel] [PATCH 1/3] Ocfs2: Using inline funcs to set/clear
	*FILLED* flags in info handler.
In-Reply-To: <1298003210-568-1-git-send-email-tristan.ye@oracle.com>
References: <1298003210-568-1-git-send-email-tristan.ye@oracle.com>
Message-ID: <1298003210-568-2-git-send-email-tristan.ye@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

It's a best-effort attempt to simplize duplicated codes here, also it
removes some macros for the sake of typechecking gains.

Signed-off-by: Tristan Ye <tristan.ye@oracle.com>
---
 fs/ocfs2/ioctl.c |   51 ++++++++++++++++++++++++++++++++-------------------
 1 files changed, 32 insertions(+), 19 deletions(-)

diff --git a/fs/ocfs2/ioctl.c b/fs/ocfs2/ioctl.c
index 7a48681..fa09ded 100644
--- a/fs/ocfs2/ioctl.c
+++ b/fs/ocfs2/ioctl.c
@@ -36,15 +36,22 @@
  * be -EFAULT.  The error will be returned from the ioctl(2) call.  It's
  * just a best-effort to tell userspace that this request caused the error.
  */
-static inline void __o2info_set_request_error(struct ocfs2_info_request *kreq,
+static inline void o2info_set_request_error(struct ocfs2_info_request *kreq,
 					struct ocfs2_info_request __user *req)
 {
 	kreq->ir_flags |= OCFS2_INFO_FL_ERROR;
 	(void)put_user(kreq->ir_flags, (__u32 __user *)&(req->ir_flags));
 }
 
-#define o2info_set_request_error(a, b) \
-		__o2info_set_request_error((struct ocfs2_info_request *)&(a), b)
+static inline void o2info_set_request_filled(struct ocfs2_info_request *req)
+{
+	req->ir_flags |= OCFS2_INFO_FL_FILLED;
+}
+
+static inline void o2info_clear_request_filled(struct ocfs2_info_request *req)
+{
+	req->ir_flags &= ~OCFS2_INFO_FL_FILLED;
+}
 
 static int ocfs2_get_inode_attr(struct inode *inode, unsigned *flags)
 {
@@ -139,7 +146,8 @@ int ocfs2_info_handle_blocksize(struct inode *inode,
 		goto bail;
 
 	oib.ib_blocksize = inode->i_sb->s_blocksize;
-	oib.ib_req.ir_flags |= OCFS2_INFO_FL_FILLED;
+
+	o2info_set_request_filled(&oib.ib_req);
 
 	if (o2info_to_user(oib, req))
 		goto bail;
@@ -147,7 +155,7 @@ int ocfs2_info_handle_blocksize(struct inode *inode,
 	status = 0;
 bail:
 	if (status)
-		o2info_set_request_error(oib, req);
+		o2info_set_request_error(&oib.ib_req, req);
 
 	return status;
 }
@@ -163,7 +171,8 @@ int ocfs2_info_handle_clustersize(struct inode *inode,
 		goto bail;
 
 	oic.ic_clustersize = osb->s_clustersize;
-	oic.ic_req.ir_flags |= OCFS2_INFO_FL_FILLED;
+
+	o2info_set_request_filled(&oic.ic_req);
 
 	if (o2info_to_user(oic, req))
 		goto bail;
@@ -171,7 +180,7 @@ int ocfs2_info_handle_clustersize(struct inode *inode,
 	status = 0;
 bail:
 	if (status)
-		o2info_set_request_error(oic, req);
+		o2info_set_request_error(&oic.ic_req, req);
 
 	return status;
 }
@@ -187,7 +196,8 @@ int ocfs2_info_handle_maxslots(struct inode *inode,
 		goto bail;
 
 	oim.im_max_slots = osb->max_slots;
-	oim.im_req.ir_flags |= OCFS2_INFO_FL_FILLED;
+
+	o2info_set_request_filled(&oim.im_req);
 
 	if (o2info_to_user(oim, req))
 		goto bail;
@@ -195,7 +205,7 @@ int ocfs2_info_handle_maxslots(struct inode *inode,
 	status = 0;
 bail:
 	if (status)
-		o2info_set_request_error(oim, req);
+		o2info_set_request_error(&oim.im_req, req);
 
 	return status;
 }
@@ -211,7 +221,8 @@ int ocfs2_info_handle_label(struct inode *inode,
 		goto bail;
 
 	memcpy(oil.il_label, osb->vol_label, OCFS2_MAX_VOL_LABEL_LEN);
-	oil.il_req.ir_flags |= OCFS2_INFO_FL_FILLED;
+
+	o2info_set_request_filled(&oil.il_req);
 
 	if (o2info_to_user(oil, req))
 		goto bail;
@@ -219,7 +230,7 @@ int ocfs2_info_handle_label(struct inode *inode,
 	status = 0;
 bail:
 	if (status)
-		o2info_set_request_error(oil, req);
+		o2info_set_request_error(&oil.il_req, req);
 
 	return status;
 }
@@ -235,7 +246,8 @@ int ocfs2_info_handle_uuid(struct inode *inode,
 		goto bail;
 
 	memcpy(oiu.iu_uuid_str, osb->uuid_str, OCFS2_TEXT_UUID_LEN + 1);
-	oiu.iu_req.ir_flags |= OCFS2_INFO_FL_FILLED;
+
+	o2info_set_request_filled(&oiu.iu_req);
 
 	if (o2info_to_user(oiu, req))
 		goto bail;
@@ -243,7 +255,7 @@ int ocfs2_info_handle_uuid(struct inode *inode,
 	status = 0;
 bail:
 	if (status)
-		o2info_set_request_error(oiu, req);
+		o2info_set_request_error(&oiu.iu_req, req);
 
 	return status;
 }
@@ -261,7 +273,8 @@ int ocfs2_info_handle_fs_features(struct inode *inode,
 	oif.if_compat_features = osb->s_feature_compat;
 	oif.if_incompat_features = osb->s_feature_incompat;
 	oif.if_ro_compat_features = osb->s_feature_ro_compat;
-	oif.if_req.ir_flags |= OCFS2_INFO_FL_FILLED;
+
+	o2info_set_request_filled(&oif.if_req);
 
 	if (o2info_to_user(oif, req))
 		goto bail;
@@ -269,7 +282,7 @@ int ocfs2_info_handle_fs_features(struct inode *inode,
 	status = 0;
 bail:
 	if (status)
-		o2info_set_request_error(oif, req);
+		o2info_set_request_error(&oif.if_req, req);
 
 	return status;
 }
@@ -286,7 +299,7 @@ int ocfs2_info_handle_journal_size(struct inode *inode,
 
 	oij.ij_journal_size = osb->journal->j_inode->i_size;
 
-	oij.ij_req.ir_flags |= OCFS2_INFO_FL_FILLED;
+	o2info_set_request_filled(&oij.ij_req);
 
 	if (o2info_to_user(oij, req))
 		goto bail;
@@ -294,7 +307,7 @@ int ocfs2_info_handle_journal_size(struct inode *inode,
 	status = 0;
 bail:
 	if (status)
-		o2info_set_request_error(oij, req);
+		o2info_set_request_error(&oij.ij_req, req);
 
 	return status;
 }
@@ -308,7 +321,7 @@ int ocfs2_info_handle_unknown(struct inode *inode,
 	if (o2info_from_user(oir, req))
 		goto bail;
 
-	oir.ir_flags &= ~OCFS2_INFO_FL_FILLED;
+	o2info_clear_request_filled(&oir);
 
 	if (o2info_to_user(oir, req))
 		goto bail;
@@ -316,7 +329,7 @@ int ocfs2_info_handle_unknown(struct inode *inode,
 	status = 0;
 bail:
 	if (status)
-		o2info_set_request_error(oir, req);
+		o2info_set_request_error(&oir, req);
 
 	return status;
 }
-- 
1.5.5
