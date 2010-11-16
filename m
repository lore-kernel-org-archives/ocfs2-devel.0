From: Tristan Ye <tristan.ye@oracle.com>
Date: Tue, 16 Nov 2010 18:13:40 +0800
Subject: [Ocfs2-devel] [PATCH 1/3] Ocfs2: Using macro to set/clear *FILLED*
	flags in info handler.
In-Reply-To: <1289902422-3315-1-git-send-email-tristan.ye@oracle.com>
References: <1289902422-3315-1-git-send-email-tristan.ye@oracle.com>
Message-ID: <1289902422-3315-2-git-send-email-tristan.ye@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

It's a best-effort attempt to simplize duplicated codes here.

Signed-off-by: Tristan Ye <tristan.ye@oracle.com>
---
 fs/ocfs2/ioctl.c |   38 ++++++++++++++++++++++++++++++--------
 1 files changed, 30 insertions(+), 8 deletions(-)

diff --git a/fs/ocfs2/ioctl.c b/fs/ocfs2/ioctl.c
index 7a48681..731cf46 100644
--- a/fs/ocfs2/ioctl.c
+++ b/fs/ocfs2/ioctl.c
@@ -46,6 +46,22 @@ static inline void __o2info_set_request_error(struct ocfs2_info_request *kreq,
 #define o2info_set_request_error(a, b) \
 		__o2info_set_request_error((struct ocfs2_info_request *)&(a), b)
 
+static inline void __o2info_set_request_filled(struct ocfs2_info_request *req)
+{
+	req->ir_flags |= OCFS2_INFO_FL_FILLED;
+}
+
+#define o2info_set_request_filled(a) \
+		__o2info_set_request_filled((struct ocfs2_info_request *)&(a))
+
+static inline void __o2info_clear_request_filled(struct ocfs2_info_request *req)
+{
+	req->ir_flags &= ~OCFS2_INFO_FL_FILLED;
+}
+
+#define o2info_clear_request_filled(a) \
+		__o2info_clear_request_filled((struct ocfs2_info_request *)&(a))
+
 static int ocfs2_get_inode_attr(struct inode *inode, unsigned *flags)
 {
 	int status;
@@ -139,7 +155,8 @@ int ocfs2_info_handle_blocksize(struct inode *inode,
 		goto bail;
 
 	oib.ib_blocksize = inode->i_sb->s_blocksize;
-	oib.ib_req.ir_flags |= OCFS2_INFO_FL_FILLED;
+
+	o2info_set_request_filled(oib);
 
 	if (o2info_to_user(oib, req))
 		goto bail;
@@ -163,7 +180,8 @@ int ocfs2_info_handle_clustersize(struct inode *inode,
 		goto bail;
 
 	oic.ic_clustersize = osb->s_clustersize;
-	oic.ic_req.ir_flags |= OCFS2_INFO_FL_FILLED;
+
+	o2info_set_request_filled(oic);
 
 	if (o2info_to_user(oic, req))
 		goto bail;
@@ -187,7 +205,8 @@ int ocfs2_info_handle_maxslots(struct inode *inode,
 		goto bail;
 
 	oim.im_max_slots = osb->max_slots;
-	oim.im_req.ir_flags |= OCFS2_INFO_FL_FILLED;
+
+	o2info_set_request_filled(oim);
 
 	if (o2info_to_user(oim, req))
 		goto bail;
@@ -211,7 +230,8 @@ int ocfs2_info_handle_label(struct inode *inode,
 		goto bail;
 
 	memcpy(oil.il_label, osb->vol_label, OCFS2_MAX_VOL_LABEL_LEN);
-	oil.il_req.ir_flags |= OCFS2_INFO_FL_FILLED;
+
+	o2info_set_request_filled(oil);
 
 	if (o2info_to_user(oil, req))
 		goto bail;
@@ -235,7 +255,8 @@ int ocfs2_info_handle_uuid(struct inode *inode,
 		goto bail;
 
 	memcpy(oiu.iu_uuid_str, osb->uuid_str, OCFS2_TEXT_UUID_LEN + 1);
-	oiu.iu_req.ir_flags |= OCFS2_INFO_FL_FILLED;
+
+	o2info_set_request_filled(oiu);
 
 	if (o2info_to_user(oiu, req))
 		goto bail;
@@ -261,7 +282,8 @@ int ocfs2_info_handle_fs_features(struct inode *inode,
 	oif.if_compat_features = osb->s_feature_compat;
 	oif.if_incompat_features = osb->s_feature_incompat;
 	oif.if_ro_compat_features = osb->s_feature_ro_compat;
-	oif.if_req.ir_flags |= OCFS2_INFO_FL_FILLED;
+
+	o2info_set_request_filled(oif);
 
 	if (o2info_to_user(oif, req))
 		goto bail;
@@ -286,7 +308,7 @@ int ocfs2_info_handle_journal_size(struct inode *inode,
 
 	oij.ij_journal_size = osb->journal->j_inode->i_size;
 
-	oij.ij_req.ir_flags |= OCFS2_INFO_FL_FILLED;
+	o2info_set_request_filled(oij);
 
 	if (o2info_to_user(oij, req))
 		goto bail;
@@ -308,7 +330,7 @@ int ocfs2_info_handle_unknown(struct inode *inode,
 	if (o2info_from_user(oir, req))
 		goto bail;
 
-	oir.ir_flags &= ~OCFS2_INFO_FL_FILLED;
+	o2info_clear_request_filled(oir);
 
 	if (o2info_to_user(oir, req))
 		goto bail;
-- 
1.5.5
