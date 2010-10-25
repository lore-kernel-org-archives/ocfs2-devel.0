From: Tristan Ye <tristan.ye@oracle.com>
Date: Mon, 25 Oct 2010 19:09:45 +0800
Subject: [Ocfs2-devel] [PATCH 1/6] O2info: Add all structures and commands
	OCFS2_IOC_INFO needed into ocfs2_ioctl.h
In-Reply-To: <1288004990-20076-1-git-send-email-tristan.ye@oracle.com>
References: <1288004990-20076-1-git-send-email-tristan.ye@oracle.com>
Message-ID: <1288004990-20076-2-git-send-email-tristan.ye@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Signed-off-by: Tristan Ye <tristan.ye@oracle.com>
---
 include/ocfs2-kernel/ocfs2_ioctl.h |   95 ++++++++++++++++++++++++++++++++++++
 1 files changed, 95 insertions(+), 0 deletions(-)

diff --git a/include/ocfs2-kernel/ocfs2_ioctl.h b/include/ocfs2-kernel/ocfs2_ioctl.h
index 2d3420a..9bc5354 100644
--- a/include/ocfs2-kernel/ocfs2_ioctl.h
+++ b/include/ocfs2-kernel/ocfs2_ioctl.h
@@ -76,4 +76,99 @@ struct reflink_arguments {
 };
 #define OCFS2_IOC_REFLINK	_IOW('o', 4, struct reflink_arguments)
 
+/* Following definitions dedicated for ocfs2_info_request ioctls. */
+#define OCFS2_INFO_MAX_REQUEST		(50)
+#define OCFS2_TEXT_UUID_LEN		(OCFS2_VOL_UUID_LEN * 2)
+
+/* Magic number of all requests */
+#define OCFS2_INFO_MAGIC		(0x4F32494E)
+
+/*
+ * Always try to separate info request into small pieces to
+ * guarantee the backward&forward compatibility.
+ */
+struct ocfs2_info {
+	__u64 oi_requests;	/* Array of __u64 pointers to requests */
+	__u32 oi_count;		/* Number of requests in info_requests */
+	__u32 oi_pad;
+};
+
+struct ocfs2_info_request {
+/*00*/	__u32 ir_magic;	/* Magic number */
+	__u32 ir_code;	/* Info request code */
+	__u32 ir_size;	/* Size of request */
+	__u32 ir_flags;	/* Request flags */
+/*10*/			/* Request specific fields */
+};
+
+struct ocfs2_info_clustersize {
+	struct ocfs2_info_request ic_req;
+	__u32 ic_clustersize;
+	__u32 ic_pad;
+};
+
+struct ocfs2_info_blocksize {
+	struct ocfs2_info_request ib_req;
+	__u32 ib_blocksize;
+	__u32 ib_pad;
+};
+
+struct ocfs2_info_maxslots {
+	struct ocfs2_info_request im_req;
+	__u32 im_max_slots;
+	__u32 im_pad;
+};
+
+struct ocfs2_info_label {
+	struct ocfs2_info_request il_req;
+	__u8	il_label[OCFS2_MAX_VOL_LABEL_LEN];
+} __attribute__ ((packed));
+
+struct ocfs2_info_uuid {
+	struct ocfs2_info_request iu_req;
+	__u8	iu_uuid_str[OCFS2_TEXT_UUID_LEN + 1];
+} __attribute__ ((packed));
+
+struct ocfs2_info_fs_features {
+	struct ocfs2_info_request if_req;
+	__u32 if_compat_features;
+	__u32 if_incompat_features;
+	__u32 if_ro_compat_features;
+	__u32 if_pad;
+};
+
+struct ocfs2_info_journal_size {
+	struct ocfs2_info_request ij_req;
+	__u64 ij_journal_size;
+};
+
+/* Codes for ocfs2_info_request */
+enum ocfs2_info_type {
+	OCFS2_INFO_CLUSTERSIZE = 1,
+	OCFS2_INFO_BLOCKSIZE,
+	OCFS2_INFO_MAXSLOTS,
+	OCFS2_INFO_LABEL,
+	OCFS2_INFO_UUID,
+	OCFS2_INFO_FS_FEATURES,
+	OCFS2_INFO_JOURNAL_SIZE,
+	OCFS2_INFO_NUM_TYPES
+};
+
+/* Flags for struct ocfs2_info_request */
+/* Filled by the caller */
+#define OCFS2_INFO_FL_NON_COHERENT	(0x00000001)	/* Cluster coherency not
+							   required. This is a hint.
+							   It is up to ocfs2 whether
+							   the request can be fulfilled
+							   without locking. */
+/* Filled by ocfs2 */
+#define OCFS2_INFO_FL_FILLED		(0x40000000)	/* Filesystem understood
+							   this request and
+							   filled in the answer */
+
+#define OCFS2_INFO_FL_ERROR		(0x80000000)	/* Error happened during
+							   request handling. */
+
+#define OCFS2_IOC_INFO		_IOR('o', 5, struct ocfs2_info)
+
 #endif /* OCFS2_IOCTL_H */
-- 
1.5.5
