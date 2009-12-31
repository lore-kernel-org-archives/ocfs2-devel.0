From: Tristan Ye <tristan.ye@oracle.com>
Date: Thu, 31 Dec 2009 16:18:43 +0800
Subject: [Ocfs2-devel] [PATCH 1/2] Ocfs2: Add stuffs associated with
	ocfs2_info_request ioctls to ioctl.h
Message-ID: <1262247524-26824-1-git-send-email-tristan.ye@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Currently we were adding ioctl cmds/structures for ocfs2 into ocfs2_fs.h
which was used for define ocfs2 on-disk layout. That sounds a little bit
confusing, and it can be quickly polluted espcially when growing the
ocfs2_info_request ioctls afterwards. The appropriate place to kept in-memory
ioctl structures is ioctl.h I guess.

I'm only adding ocfs2_info related ioctls into ioctl.h, while existed ioctls still
stay unchanged there, in case it may hurt some others who add their ioctls in ocfs2_fs.h
originally. If possible, separate other patches can be dedicated for the transfer later.

Signed-off-by: Tristan Ye <tristan.ye@oracle.com>
---
 fs/ocfs2/ioctl.h |  118 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 118 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/ioctl.h b/fs/ocfs2/ioctl.h
index cf9a5ee..a1b7b54 100644
--- a/fs/ocfs2/ioctl.h
+++ b/fs/ocfs2/ioctl.h
@@ -10,6 +10,124 @@
 #ifndef OCFS2_IOCTL_H
 #define OCFS2_IOCTL_H
 
+/*
+ * ioctl commands
+ */
+
+/* Following definition dedicated for ocfs2_info_request ioctls. */
+#define OCFS2_INFO_VOL_UUID_LEN		(16)
+#define OCFS2_INFO_MAX_VOL_LABEL_LEN	(64)
+#define OCFS2_INFO_VOL_UUIDSTR_LEN	(OCFS2_INFO_VOL_UUID_LEN * 2 + 1)
+#define OCFS2_INFO_MAX_SLOTS		(255)
+#define OCFS2_INFO_MAX_HIST		(32)
+
+#define OCFS2_INFO_MAX_REQUEST		(50)
+
+/* Magic number of all requests */
+#define OCFS2_INFO_MAGIC		(0x4F32494E)
+
+/*
+ * Always try to separate info request into small pieces to
+ * guarantee the backward&forward compatibility.
+ */
+
+struct ocfs2_info {
+	__u64 info_requests;	/* Array of __u64 pointers to requests */
+	__u32 info_count;	/* Number of requests in info_requests */
+};
+
+struct ocfs2_info_request {
+/*00*/	__u32 ir_magic;	/* Magic number */
+	__u32 ir_code;	/* Info request code */
+	__u32 ir_size;	/* Size of request */
+	__u32 ir_flags;	/* Request flags */
+/*10*/	/* Request specific fields */
+};
+
+struct ocfs2_info_clustersize {
+	struct ocfs2_info_request ir_request;
+	__u32 ir_clustersize;
+};
+
+struct ocfs2_info_blocksize {
+	struct ocfs2_info_request ir_request;
+	__u32 ir_blocksize;
+};
+
+struct ocfs2_info_slotnum {
+	struct ocfs2_info_request ir_request;
+	__u16 ir_slotnum;
+};
+
+struct ocfs2_info_label {
+	struct ocfs2_info_request ir_request;
+	__u8	ir_label[OCFS2_INFO_MAX_VOL_LABEL_LEN];
+};
+
+struct ocfs2_info_uuid {
+	struct ocfs2_info_request ir_request;
+	__u8	ir_uuid_str[OCFS2_INFO_VOL_UUIDSTR_LEN];
+};
+
+struct ocfs2_info_fs_features {
+	struct ocfs2_info_request ir_request;
+	__u32 ir_compat_features;
+	__u32 ir_incompat_features;
+	__u32 ir_ro_compat_features;
+};
+
+struct ocfs2_info_freefrag {
+	struct ocfs2_info_request ir_request;
+	__u32 ir_chunksize; /* chunksize in clusters(in) */
+	struct ocfs2_info_freefrag_stats { /* (out) */
+		__u32 ir_clusters;
+		__u32 ir_free_clusters;
+		__u32 ir_free_chunks;
+		__u32 ir_free_chunks_real;
+		__u32 ir_min; /* Minimum free chunksize in clusters */
+		__u32 ir_max;
+		__u32 ir_avg;
+		struct ocfs2_info_free_chunk_list {
+			__u32 ir_fc_chunks[OCFS2_INFO_MAX_HIST];
+			__u32 ir_fc_clusters[OCFS2_INFO_MAX_HIST];
+		} ir_fc_hist;
+	} ir_ffg;
+};
+
+struct ocfs2_info_freeinode {
+	struct ocfs2_info_request ir_request;
+	__u32 ir_slotnum; /* out */
+	struct ocfs2_info_local_fi {
+		__u64 ir_total;
+		__u64 ir_free;
+	} ir_fi_stat[OCFS2_MAX_SLOTS];
+};
+
+/* Codes for ocfs2_info_request */
+
+#define OCFS2_INFO_CLUSTERSIZE	(0x00000001)
+#define OCFS2_INFO_BLOCKSIZE	(0x00000002)
+#define OCFS2_INFO_SLOTNUM	(0x00000004)
+#define OCFS2_INFO_LABEL	(0x00000008)
+#define OCFS2_INFO_UUID	(0x00000010)
+#define OCFS2_INFO_FS_FEATURES	(0x00000020)
+#define OCFS2_INFO_FREEFRAG	(0x00000040)
+#define OCFS2_INFO_FREEINODE	(0x00000080)
+
+/* Flags for struct ocfs2_info_request */
+/* Filled by the caller */
+#define OCFS2_INFO_FL_NON_COHERENT	(0x00000001)	/* Cluster coherency not
+							   required. This is a hint.
+							   It is up to ocfs2 whether
+							   the request can be fulfilled
+							   without locking. */
+/* Filled by ocfs2 */
+#define OCFS2_INFO_FL_FILLED		(0x80000000)	/* Filesystem understood
+							   this request and
+							   filled in the answer */
+
+#define OCFS2_IOC_INFO		_IOR('o', 5, struct ocfs2_info)
+
 long ocfs2_ioctl(struct file *filp, unsigned int cmd, unsigned long arg);
 long ocfs2_compat_ioctl(struct file *file, unsigned cmd, unsigned long arg);
 
-- 
1.5.5
