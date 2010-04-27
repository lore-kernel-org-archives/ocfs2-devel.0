From: Tristan Ye <tristan.ye@oracle.com>
Date: Tue, 27 Apr 2010 18:30:03 +0800
Subject: [Ocfs2-devel] [PATCH 2/2] Ocfs2: Add support of
	OCFS2_INFO_JOURNAL_SIZE to o2info.
Message-ID: <1272364203-4162-1-git-send-email-tristan.ye@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Signed-off-by: Tristan Ye <tristan.ye@oracle.com>
---
 fs/ocfs2/ioctl.c       |   31 +++++++++++++++++++++++++++++++
 fs/ocfs2/ocfs2_ioctl.h |    6 ++++++
 2 files changed, 37 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/ioctl.c b/fs/ocfs2/ioctl.c
index e55e52d..1672e6b 100644
--- a/fs/ocfs2/ioctl.c
+++ b/fs/ocfs2/ioctl.c
@@ -276,6 +276,33 @@ bail:
 	return status;
 }
 
+int ocfs2_info_handle_journal_size(struct inode *inode,
+				   struct ocfs2_info_request __user *req)
+{
+	int status = -EFAULT;
+	struct ocfs2_info_journal_size oij;
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+
+	if (o2info_from_user(oij, req))
+		goto bail;
+
+	oij.ij_journal_size = osb->journal->j_inode->i_size;
+
+	oij.ij_req.ir_flags |= OCFS2_INFO_FL_FILLED;
+
+	if (o2info_to_user(oij, req))
+		goto bail;
+
+	status = 0;
+bail:
+	if (status) {
+		oij.ij_req.ir_flags |= OCFS2_INFO_FL_ERROR;
+		oij.ij_req.ir_error = status;
+	}
+
+	return status;
+}
+
 int ocfs2_info_handle_unknown(struct inode *inode,
 			      struct ocfs2_info_request __user *req)
 {
@@ -345,6 +372,10 @@ int ocfs2_info_handle_request(struct inode *inode,
 		if (oir.ir_size == sizeof(struct ocfs2_info_fs_features))
 			status = ocfs2_info_handle_fs_features(inode, req);
 		break;
+	case OCFS2_INFO_JOURNAL_SIZE:
+		if (oir.ir_size == sizeof(struct ocfs2_info_journal_size))
+			status = ocfs2_info_handle_journal_size(inode, req);
+		break;
 	default:
 		status = ocfs2_info_handle_unknown(inode, req);
 		break;
diff --git a/fs/ocfs2/ocfs2_ioctl.h b/fs/ocfs2/ocfs2_ioctl.h
index 4b922f3..06e00b8 100644
--- a/fs/ocfs2/ocfs2_ioctl.h
+++ b/fs/ocfs2/ocfs2_ioctl.h
@@ -133,6 +133,11 @@ struct ocfs2_info_fs_features {
 	__u32 if_ro_compat_features;
 };
 
+struct ocfs2_info_journal_size {
+	struct ocfs2_info_request ij_req;
+	__u64 ij_journal_size;
+};
+
 /* Codes for ocfs2_info_request */
 enum ocfs2_info_type {
 	OCFS2_INFO_CLUSTERSIZE = 1,
@@ -141,6 +146,7 @@ enum ocfs2_info_type {
 	OCFS2_INFO_LABEL,
 	OCFS2_INFO_UUID,
 	OCFS2_INFO_FS_FEATURES,
+	OCFS2_INFO_JOURNAL_SIZE,
 	OCFS2_INFO_NUM_TYPES
 };
 
-- 
1.5.5
