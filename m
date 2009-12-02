From: Tristan Ye <tristan.ye@oracle.com>
Date: Wed,  2 Dec 2009 20:42:07 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] Ocfs2: Add new OCFS2_IOC_INFO ioctl for
	ocfs2 V2.
Message-ID: <1259757727-26835-1-git-send-email-tristan.ye@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The reason why we need this ioctl is to offer the none-privileged
end-user a possibility to get filesys info gathering.

We use OCFS2_IOC_INFO to manipulate the new ioctl, userspace passes a
structure to kernel containing an array of request pointers and request
count, such as,

* From userspace:

struct ocfs2_info_blocksize brq = {
	.ir_request = {
		.ir_magic = OCFS2_INFO_MAGIC,
		.ir_code = OCFS2_INFO_BLOCKSIZE,
		...
	}
	...
}

struct ocfs2_info_clustersize crq = {
	...
}

uint64_t reqs[2] = {(unsigned long)&brq,
		    (unsigned long)&crq};

struct ocfs2_info info = {
	.ir_requests = reqs,
	.ir_count = 2,
}

ret = ioctl(fd, OCFS2_IOC_INFO, &info);

* In kernel:

Get the request pointers from *info*, then handle each request one bye one.

Idea here is to make the spearated request small enough to guarantee
a better backward&forward compatibility since a small piece of request
would be less likely to be broken if filesys on raw disk get changed.

Signed-off-by: Tristan Ye <tristan.ye@oracle.com>
---
 fs/ocfs2/ioctl.c    |  289 +++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ocfs2/ocfs2_fs.h |   84 ++++++++++++++-
 2 files changed, 370 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/ioctl.c b/fs/ocfs2/ioctl.c
index 31fbb06..23d4a58 100644
--- a/fs/ocfs2/ioctl.c
+++ b/fs/ocfs2/ioctl.c
@@ -108,6 +108,269 @@ bail:
 	return status;
 }
 
+int ocfs2_info_handle_blocksize(struct inode *inode,
+				struct ocfs2_info_request __user *user_req)
+{
+	int ret = 0;
+	struct ocfs2_info_blocksize req_bs;
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+
+	if (copy_from_user(&req_bs, user_req,
+			   sizeof(struct ocfs2_info_blocksize)))
+		return -EFAULT;
+
+	if (!(req_bs.ir_request.ir_flags & OCFS2_INFO_FL_NON_COHERENT)) {
+		ret = ocfs2_super_lock(osb, 0);
+		if (ret < 0) {
+			mlog_errno(ret);
+			return ret;
+		}
+	}
+
+	req_bs.ir_blocksize = inode->i_sb->s_blocksize;
+	req_bs.ir_request.ir_flags |= OCFS2_INFO_FL_FILLED;
+
+	if (copy_to_user((struct ocfs2_info_blocksize __user *)user_req,
+			 &req_bs,
+			 sizeof(struct ocfs2_info_blocksize)))
+		return -EFAULT;
+
+	if (!(req_bs.ir_request.ir_flags & OCFS2_INFO_FL_NON_COHERENT))
+		ocfs2_super_unlock(osb, 0);
+
+	return ret;
+}
+
+int ocfs2_info_handle_clustersize(struct inode *inode,
+				  struct ocfs2_info_request __user *user_req)
+{
+	int ret = 0;
+	struct ocfs2_info_clustersize req_cs;
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+
+	if (copy_from_user(&req_cs, user_req,
+			   sizeof(struct ocfs2_info_clustersize)))
+		return -EFAULT;
+
+	if (!(req_cs.ir_request.ir_flags & OCFS2_INFO_FL_NON_COHERENT)) {
+		ret = ocfs2_super_lock(osb, 0);
+		if (ret < 0) {
+			mlog_errno(ret);
+			return ret;
+		}
+	}
+
+	req_cs.ir_clustersize = osb->s_clustersize;
+	req_cs.ir_request.ir_flags |= OCFS2_INFO_FL_FILLED;
+
+	if (copy_to_user((struct ocfs2_info_clustersize __user *)user_req,
+			 &req_cs,
+			 sizeof(struct ocfs2_info_clustersize)))
+		return -EFAULT;
+
+	if (!(req_cs.ir_request.ir_flags & OCFS2_INFO_FL_NON_COHERENT))
+		ocfs2_super_unlock(osb, 0);
+
+	return ret;
+}
+
+int ocfs2_info_handle_slotnum(struct inode *inode,
+			      struct ocfs2_info_request __user *user_req)
+{
+	int ret = 0;
+	struct ocfs2_info_slotnum req_sn;
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+
+	if (copy_from_user(&req_sn, user_req,
+			   sizeof(struct ocfs2_info_slotnum)))
+		return -EFAULT;
+
+	if (!(req_sn.ir_request.ir_flags & OCFS2_INFO_FL_NON_COHERENT)) {
+		ret = ocfs2_super_lock(osb, 0);
+		if (ret < 0) {
+			mlog_errno(ret);
+			return ret;
+		}
+	}
+
+	req_sn.ir_slotnum = osb->max_slots;
+	req_sn.ir_request.ir_flags |= OCFS2_INFO_FL_FILLED;
+
+	if (copy_to_user((struct ocfs2_info_slotnum __user *)user_req,
+			 &req_sn,
+			 sizeof(struct ocfs2_info_slotnum)))
+		return -EFAULT;
+
+	if (!(req_sn.ir_request.ir_flags & OCFS2_INFO_FL_NON_COHERENT))
+		ocfs2_super_unlock(osb, 0);
+
+	return ret;
+}
+
+int ocfs2_info_handle_label(struct inode *inode,
+			    struct ocfs2_info_request __user *user_req)
+{
+	int ret = 0;
+	struct ocfs2_info_label req_lb;
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+
+	if (copy_from_user(&req_lb, user_req,
+			   sizeof(struct ocfs2_info_label)))
+		return -EFAULT;
+
+	if (!(req_lb.ir_request.ir_flags & OCFS2_INFO_FL_NON_COHERENT)) {
+		ret = ocfs2_super_lock(osb, 0);
+		if (ret < 0) {
+			mlog_errno(ret);
+			return ret;
+		}
+	}
+
+	memcpy(req_lb.ir_label, osb->vol_label, OCFS2_MAX_VOL_LABEL_LEN);
+	req_lb.ir_request.ir_flags |= OCFS2_INFO_FL_FILLED;
+
+	if (copy_to_user((struct ocfs2_info_label __user *)user_req,
+			 &req_lb,
+			 sizeof(struct ocfs2_info_label)))
+		return -EFAULT;
+
+	if (!(req_lb.ir_request.ir_flags & OCFS2_INFO_FL_NON_COHERENT))
+		ocfs2_super_unlock(osb, 0);
+
+	return ret;
+}
+
+int ocfs2_info_handle_uuid(struct inode *inode,
+			   struct ocfs2_info_request __user *user_req)
+{
+	int ret = 0;
+	struct ocfs2_info_uuid req_uuid;
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+
+	if (copy_from_user(&req_uuid, user_req,
+			   sizeof(struct ocfs2_info_uuid)))
+		return -EFAULT;
+
+	if (!(req_uuid.ir_request.ir_flags & OCFS2_INFO_FL_NON_COHERENT)) {
+		ret = ocfs2_super_lock(osb, 0);
+		if (ret < 0) {
+			mlog_errno(ret);
+			return ret;
+		}
+	}
+
+	memcpy(req_uuid.ir_uuid_str, osb->uuid_str, OCFS2_VOL_UUIDSTR_LEN);
+	req_uuid.ir_request.ir_flags |= OCFS2_INFO_FL_FILLED;
+
+	if (copy_to_user((struct ocfs2_info_uuid __user *)user_req,
+			 &req_uuid,
+			 sizeof(struct ocfs2_info_uuid)))
+		return -EFAULT;
+
+	if (!(req_uuid.ir_request.ir_flags & OCFS2_INFO_FL_NON_COHERENT))
+		ocfs2_super_unlock(osb, 0);
+
+	return ret;
+}
+
+int ocfs2_info_handle_fs_features(struct inode *inode,
+				  struct ocfs2_info_request __user *user_req)
+{
+	int ret = 0;
+	struct ocfs2_info_fs_features req_fs;
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+
+	if (copy_from_user(&req_fs, user_req,
+			   sizeof(struct ocfs2_info_fs_features)))
+		return -EFAULT;
+
+	if (!(req_fs.ir_request.ir_flags & OCFS2_INFO_FL_NON_COHERENT)) {
+		ret = ocfs2_super_lock(osb, 0);
+		if (ret < 0) {
+			mlog_errno(ret);
+			return ret;
+		}
+	}
+
+	req_fs.ir_compat_features = osb->s_feature_compat;
+	req_fs.ir_incompat_features = osb->s_feature_incompat;
+	req_fs.ir_ro_compat_features = osb->s_feature_ro_compat;
+	req_fs.ir_request.ir_flags |= OCFS2_INFO_FL_FILLED;
+
+	if (copy_to_user((struct ocfs2_info_fs_features __user *)user_req,
+			 &req_fs,
+			 sizeof(struct ocfs2_info_fs_features)))
+		return -EFAULT;
+
+	if (!(req_fs.ir_request.ir_flags & OCFS2_INFO_FL_NON_COHERENT))
+		ocfs2_super_unlock(osb, 0);
+
+	return ret;
+}
+
+int ocfs2_info_handle(struct inode *inode,
+		      struct ocfs2_info_request __user *user_req)
+{
+	int ret = 0;
+	struct ocfs2_info_request req;
+
+	if (copy_from_user(&req, user_req, sizeof(struct ocfs2_info_request)))
+		return -EFAULT;
+
+	if (req.ir_magic != OCFS2_INFO_MAGIC)
+		return -EINVAL;
+
+	switch (req.ir_code) {
+	case OCFS2_INFO_BLOCKSIZE:
+		if (req.ir_size != sizeof(struct ocfs2_info_blocksize)) {
+			ret = -EINVAL;
+			break;
+		}
+		ret = ocfs2_info_handle_blocksize(inode, user_req);
+		break;
+	case OCFS2_INFO_CLUSTERSIZE:
+		if (req.ir_size != sizeof(struct ocfs2_info_clustersize)) {
+			ret = -EINVAL;
+			break;
+		}
+		ret = ocfs2_info_handle_clustersize(inode, user_req);
+		break;
+	case OCFS2_INFO_SLOTNUM:
+		if (req.ir_size != sizeof(struct ocfs2_info_slotnum)) {
+			ret = -EINVAL;
+			break;
+		}
+		ret = ocfs2_info_handle_slotnum(inode, user_req);
+		break;
+	case OCFS2_INFO_LABEL:
+		if (req.ir_size != sizeof(struct ocfs2_info_label)) {
+			ret = -EINVAL;
+			break;
+		}
+		ret = ocfs2_info_handle_label(inode, user_req);
+		break;
+	case OCFS2_INFO_UUID:
+		if (req.ir_size != sizeof(struct ocfs2_info_uuid)) {
+			ret = -EINVAL;
+			break;
+		}
+		ret = ocfs2_info_handle_uuid(inode, user_req);
+		break;
+	case OCFS2_INFO_FS_FEATURES:
+		if (req.ir_size != sizeof(struct ocfs2_info_fs_features)) {
+			ret = -EINVAL;
+			break;
+		}
+		ret = ocfs2_info_handle_fs_features(inode, user_req);
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+
+	return ret;
+}
+
 long ocfs2_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 {
 	struct inode *inode = filp->f_path.dentry->d_inode;
@@ -117,8 +380,13 @@ long ocfs2_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 	struct ocfs2_space_resv sr;
 	struct ocfs2_new_group_input input;
 	struct reflink_arguments args;
+	struct ocfs2_info info;
+	struct ocfs2_info_request __user *reqp;
 	const char *old_path, *new_path;
 	bool preserve;
+	int i;
+
+	u64 req_addr;
 
 	switch (cmd) {
 	case OCFS2_IOC_GETFLAGS:
@@ -173,6 +441,27 @@ long ocfs2_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		preserve = (args.preserve != 0);
 
 		return ocfs2_reflink_ioctl(inode, old_path, new_path, preserve);
+	case OCFS2_IOC_INFO:
+		if (copy_from_user(&info, (struct ocfs2_info __user *)arg,
+				   sizeof(struct ocfs2_info)))
+			return -EFAULT;
+
+		if ((info.info_count > OCFS2_INFO_MAX_REQUEST) ||
+		    (!info.info_requests))
+			return -EINVAL;
+
+		for (i = 0; i < info.info_count; i++) {
+			status = -EFAULT;
+			if (get_user(req_addr,
+				     (u64 __user *)(info.info_requests) + i))
+				break;
+
+			reqp = (struct ocfs2_info_request *)req_addr;
+			status = ocfs2_info_handle(inode, reqp);
+			if (status)
+				break;
+		}
+		return status;
 	default:
 		return -ENOTTY;
 	}
diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
index e9431e4..ca7a38a 100644
--- a/fs/ocfs2/ocfs2_fs.h
+++ b/fs/ocfs2/ocfs2_fs.h
@@ -309,6 +309,87 @@ struct reflink_arguments {
 };
 #define OCFS2_IOC_REFLINK	_IOW('o', 4, struct reflink_arguments)
 
+#define OCFS2_VOL_UUID_LEN		(16)
+#define OCFS2_MAX_VOL_LABEL_LEN	(64)
+#define OCFS2_VOL_UUIDSTR_LEN		(OCFS2_VOL_UUID_LEN * 2 + 1)
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
+	__u8	ir_label[OCFS2_MAX_VOL_LABEL_LEN];
+};
+
+struct ocfs2_info_uuid {
+	struct ocfs2_info_request ir_request;
+	__u8	ir_uuid_str[OCFS2_VOL_UUIDSTR_LEN];
+};
+
+struct ocfs2_info_fs_features {
+	struct ocfs2_info_request ir_request;
+	__u32 ir_compat_features;
+	__u32 ir_incompat_features;
+	__u32 ir_ro_compat_features;
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
 
 /*
  * Journal Flags (ocfs2_dinode.id1.journal1.i_flags)
@@ -329,9 +410,6 @@ struct reflink_arguments {
 /* Slot map indicator for an empty slot */
 #define OCFS2_INVALID_SLOT		-1
 
-#define OCFS2_VOL_UUID_LEN		16
-#define OCFS2_MAX_VOL_LABEL_LEN		64
-
 /* The alternate, userspace stack fields */
 #define OCFS2_STACK_LABEL_LEN		4
 #define OCFS2_CLUSTER_NAME_LEN		16
-- 
1.5.5
