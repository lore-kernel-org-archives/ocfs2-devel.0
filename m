From: Tristan Ye <tristan.ye@oracle.com>
Date: Tue, 24 May 2011 18:07:02 +0800
Subject: [Ocfs2-devel] [PATCH 1/3] Ocfs2: Using inline funcs to set/clear
	*FILLED* flags in info handler.
In-Reply-To: <1306231624-26967-1-git-send-email-tristan.ye@oracle.com>
References: <1306231624-26967-1-git-send-email-tristan.ye@oracle.com>
Message-ID: <1306231624-26967-2-git-send-email-tristan.ye@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

It just removes some macros for the sake of typechecking gains.

Signed-off-by: Tristan Ye <tristan.ye@oracle.com>
---
 fs/ocfs2/ioctl.c |   47 +++++++++++++++++++----------------------------
 1 files changed, 19 insertions(+), 28 deletions(-)

diff --git a/fs/ocfs2/ioctl.c b/fs/ocfs2/ioctl.c
index 8f13c59..373c1d1 100644
--- a/fs/ocfs2/ioctl.c
+++ b/fs/ocfs2/ioctl.c
@@ -35,32 +35,23 @@
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
-
-static inline void __o2info_set_request_filled(struct ocfs2_info_request *req)
+static inline void o2info_set_request_filled(struct ocfs2_info_request *req)
 {
 	req->ir_flags |= OCFS2_INFO_FL_FILLED;
 }
 
-#define o2info_set_request_filled(a) \
-		__o2info_set_request_filled((struct ocfs2_info_request *)&(a))
-
-static inline void __o2info_clear_request_filled(struct ocfs2_info_request *req)
+static inline void o2info_clear_request_filled(struct ocfs2_info_request *req)
 {
 	req->ir_flags &= ~OCFS2_INFO_FL_FILLED;
 }
 
-#define o2info_clear_request_filled(a) \
-		__o2info_clear_request_filled((struct ocfs2_info_request *)&(a))
-
 static int ocfs2_get_inode_attr(struct inode *inode, unsigned *flags)
 {
 	int status;
@@ -153,7 +144,7 @@ int ocfs2_info_handle_blocksize(struct inode *inode,
 
 	oib.ib_blocksize = inode->i_sb->s_blocksize;
 
-	o2info_set_request_filled(oib);
+	o2info_set_request_filled(&oib.ib_req);
 
 	if (o2info_to_user(oib, req))
 		goto bail;
@@ -161,7 +152,7 @@ int ocfs2_info_handle_blocksize(struct inode *inode,
 	status = 0;
 bail:
 	if (status)
-		o2info_set_request_error(oib, req);
+		o2info_set_request_error(&oib.ib_req, req);
 
 	return status;
 }
@@ -178,7 +169,7 @@ int ocfs2_info_handle_clustersize(struct inode *inode,
 
 	oic.ic_clustersize = osb->s_clustersize;
 
-	o2info_set_request_filled(oic);
+	o2info_set_request_filled(&oic.ic_req);
 
 	if (o2info_to_user(oic, req))
 		goto bail;
@@ -186,7 +177,7 @@ int ocfs2_info_handle_clustersize(struct inode *inode,
 	status = 0;
 bail:
 	if (status)
-		o2info_set_request_error(oic, req);
+		o2info_set_request_error(&oic.ic_req, req);
 
 	return status;
 }
@@ -203,7 +194,7 @@ int ocfs2_info_handle_maxslots(struct inode *inode,
 
 	oim.im_max_slots = osb->max_slots;
 
-	o2info_set_request_filled(oim);
+	o2info_set_request_filled(&oim.im_req);
 
 	if (o2info_to_user(oim, req))
 		goto bail;
@@ -211,7 +202,7 @@ int ocfs2_info_handle_maxslots(struct inode *inode,
 	status = 0;
 bail:
 	if (status)
-		o2info_set_request_error(oim, req);
+		o2info_set_request_error(&oim.im_req, req);
 
 	return status;
 }
@@ -228,7 +219,7 @@ int ocfs2_info_handle_label(struct inode *inode,
 
 	memcpy(oil.il_label, osb->vol_label, OCFS2_MAX_VOL_LABEL_LEN);
 
-	o2info_set_request_filled(oil);
+	o2info_set_request_filled(&oil.il_req);
 
 	if (o2info_to_user(oil, req))
 		goto bail;
@@ -236,7 +227,7 @@ int ocfs2_info_handle_label(struct inode *inode,
 	status = 0;
 bail:
 	if (status)
-		o2info_set_request_error(oil, req);
+		o2info_set_request_error(&oil.il_req, req);
 
 	return status;
 }
@@ -253,7 +244,7 @@ int ocfs2_info_handle_uuid(struct inode *inode,
 
 	memcpy(oiu.iu_uuid_str, osb->uuid_str, OCFS2_TEXT_UUID_LEN + 1);
 
-	o2info_set_request_filled(oiu);
+	o2info_set_request_filled(&oiu.iu_req);
 
 	if (o2info_to_user(oiu, req))
 		goto bail;
@@ -261,7 +252,7 @@ int ocfs2_info_handle_uuid(struct inode *inode,
 	status = 0;
 bail:
 	if (status)
-		o2info_set_request_error(oiu, req);
+		o2info_set_request_error(&oiu.iu_req, req);
 
 	return status;
 }
@@ -280,7 +271,7 @@ int ocfs2_info_handle_fs_features(struct inode *inode,
 	oif.if_incompat_features = osb->s_feature_incompat;
 	oif.if_ro_compat_features = osb->s_feature_ro_compat;
 
-	o2info_set_request_filled(oif);
+	o2info_set_request_filled(&oif.if_req);
 
 	if (o2info_to_user(oif, req))
 		goto bail;
@@ -288,7 +279,7 @@ int ocfs2_info_handle_fs_features(struct inode *inode,
 	status = 0;
 bail:
 	if (status)
-		o2info_set_request_error(oif, req);
+		o2info_set_request_error(&oif.if_req, req);
 
 	return status;
 }
@@ -305,7 +296,7 @@ int ocfs2_info_handle_journal_size(struct inode *inode,
 
 	oij.ij_journal_size = osb->journal->j_inode->i_size;
 
-	o2info_set_request_filled(oij);
+	o2info_set_request_filled(&oij.ij_req);
 
 	if (o2info_to_user(oij, req))
 		goto bail;
@@ -313,7 +304,7 @@ int ocfs2_info_handle_journal_size(struct inode *inode,
 	status = 0;
 bail:
 	if (status)
-		o2info_set_request_error(oij, req);
+		o2info_set_request_error(&oij.ij_req, req);
 
 	return status;
 }
@@ -327,7 +318,7 @@ int ocfs2_info_handle_unknown(struct inode *inode,
 	if (o2info_from_user(oir, req))
 		goto bail;
 
-	o2info_clear_request_filled(oir);
+	o2info_clear_request_filled(&oir);
 
 	if (o2info_to_user(oir, req))
 		goto bail;
@@ -335,7 +326,7 @@ int ocfs2_info_handle_unknown(struct inode *inode,
 	status = 0;
 bail:
 	if (status)
-		o2info_set_request_error(oir, req);
+		o2info_set_request_error(&oir, req);
 
 	return status;
 }
-- 
1.5.5
