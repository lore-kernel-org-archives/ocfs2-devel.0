From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Tue, 20 Apr 2010 13:31:32 -0700
Subject: [Ocfs2-devel] [PATCH 2/2] Ocfs2: Add new OCFS2_IOC_INFO ioctl
 for ocfs2 v7.
In-Reply-To: <1271746743-17653-2-git-send-email-tristan.ye@oracle.com>
References: <1271746743-17653-1-git-send-email-tristan.ye@oracle.com>
	<1271746743-17653-2-git-send-email-tristan.ye@oracle.com>
Message-ID: <4BCE0F24.1020809@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>


Tristan Ye wrote:
> The reason why we need this ioctl is to offer the none-privileged
> end-user a possibility to get filesys info gathering.
>
> We use OCFS2_IOC_INFO to manipulate the new ioctl, userspace passes a
> structure to kernel containing an array of request pointers and request
> count, such as,
>
> * From userspace:
>
> struct ocfs2_info_blocksize oib = {
>         .ib_req = {
>                 .ir_magic = OCFS2_INFO_MAGIC,
>                 .ir_code = OCFS2_INFO_BLOCKSIZE,
>                 ...
>         }
>         ...
> }
>
> struct ocfs2_info_clustersize oic = {
>         ...
> }
>
> uint64_t reqs[2] = {(unsigned long)&oib,
>                     (unsigned long)&oic};
>
> struct ocfs2_info info = {
>         .oi_requests = reqs,
>         .oi_count = 2,
> }
>
> ret = ioctl(fd, OCFS2_IOC_INFO, &info);
>
> * In kernel:
>
> Get the request pointers from *info*, then handle each request one bye one.
>
> Idea here is to make the spearated request small enough to guarantee
> a better backward&forward compatibility since a small piece of request
> would be less likely to be broken if filesys on raw disk get changed.
>
> Currently, following 8 ioctls get implemented per the requirement from
> userspace tool o2info, and I believe it will grow over time:-)
>
>         OCFS2_INFO_CLUSTERSIZE
>         OCFS2_INFO_BLOCKSIZE
>         OCFS2_INFO_MAXSLOTS
>         OCFS2_INFO_LABEL
>         OCFS2_INFO_UUID
>         OCFS2_INFO_FS_FEATURES
>
> This ioctl is only specific to OCFS2.
>
> Signed-off-by: Tristan Ye <tristan.ye@oracle.com>
> ---
>  fs/ocfs2/ioctl.c       |  275 ++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/ocfs2/ocfs2_ioctl.h |   80 ++++++++++++++
>  2 files changed, 355 insertions(+), 0 deletions(-)
>
> diff --git a/fs/ocfs2/ioctl.c b/fs/ocfs2/ioctl.c
> index 7d9d9c1..5e10340 100644
> --- a/fs/ocfs2/ioctl.c
> +++ b/fs/ocfs2/ioctl.c
> @@ -23,8 +23,18 @@
>  #include "ioctl.h"
>  #include "resize.h"
>  #include "refcounttree.h"
> +#include "sysfile.h"
> +#include "buffer_head_io.h"
> +#include "suballoc.h"
> +
>  
>  #include <linux/ext2_fs.h>
> +#include <linux/compat.h>
> +
> +#define o2info_from_user(a, b)	\
> +		copy_from_user(&(a), (b), sizeof(a))
> +#define o2info_to_user(a, b)	\
> +		copy_to_user((typeof(a) __user *)b, &(a), sizeof(a))
>  
>  static int ocfs2_get_inode_attr(struct inode *inode, unsigned *flags)
>  {
> @@ -109,6 +119,257 @@ bail:
>  	return status;
>  }
>  
> +int ocfs2_info_handle_blocksize(struct inode *inode,
> +				struct ocfs2_info_request __user *req)
> +{
> +	int status = -EFAULT;
> +	struct ocfs2_info_blocksize oib;
> +
> +	if (o2info_from_user(oib, req))
> +		goto bail;
> +
> +	oib.ib_blocksize = inode->i_sb->s_blocksize;
> +	oib.ib_req.ir_flags |= OCFS2_INFO_FL_FILLED;
> +
> +	if (o2info_to_user(oib, req))
> +		goto bail;
> +
> +	status = 0;
> +bail:
> +	return status;
> +}
> +
> +int ocfs2_info_handle_clustersize(struct inode *inode,
> +				  struct ocfs2_info_request __user *req)
> +{
> +	int status = -EFAULT;
> +	struct ocfs2_info_clustersize oic;
> +	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
> +
> +	if (o2info_from_user(oic, req))
> +		goto bail;
> +
> +	oic.ic_clustersize = osb->s_clustersize;
> +	oic.ic_req.ir_flags |= OCFS2_INFO_FL_FILLED;
> +
> +	if (o2info_to_user(oic, req))
> +		goto bail;
> +
> +	status = 0;
> +bail:
> +	return status;
> +}
> +
> +int ocfs2_info_handle_maxslots(struct inode *inode,
> +			       struct ocfs2_info_request __user *req)
> +{
> +	int status = -EFAULT;
> +	struct ocfs2_info_maxslots oim;
> +	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
> +
> +	if (o2info_from_user(oim, req))
> +		goto bail;
> +
> +	oim.im_max_slots = osb->max_slots;
> +	oim.im_req.ir_flags |= OCFS2_INFO_FL_FILLED;
> +
> +	if (o2info_to_user(oim, req))
> +		goto bail;
> +
> +	status = 0;
> +bail:
> +	return status;
> +}
> +
> +int ocfs2_info_handle_label(struct inode *inode,
> +			    struct ocfs2_info_request __user *req)
> +{
> +	int status = -EFAULT;
> +	struct ocfs2_info_label oil;
> +	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
> +
> +	if (o2info_from_user(oil, req))
> +		goto bail;
> +
> +	memcpy(oil.il_label, osb->vol_label, OCFS2_MAX_VOL_LABEL_LEN);
> +	oil.il_req.ir_flags |= OCFS2_INFO_FL_FILLED;
> +
> +	if (o2info_to_user(oil, req))
> +		goto bail;
> +
> +	status = 0;
> +bail:
> +	return status;
> +}
> +
> +int ocfs2_info_handle_uuid(struct inode *inode,
> +			   struct ocfs2_info_request __user *req)
> +{
> +	int status = -EFAULT;
> +	struct ocfs2_info_uuid oiu;
> +	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
> +
> +	if (o2info_from_user(oiu, req))
> +		goto bail;
> +
> +	memcpy(oiu.iu_uuid_str, osb->uuid_str, OCFS2_VOL_UUIDSTR_LEN);
> +	oiu.iu_req.ir_flags |= OCFS2_INFO_FL_FILLED;
> +
> +	if (o2info_to_user(oiu, req))
> +		goto bail;
> +
> +	status = 0;
> +bail:
> +	return status;
> +}
> +
> +int ocfs2_info_handle_fs_features(struct inode *inode,
> +				  struct ocfs2_info_request __user *req)
> +{
> +	int status = -EFAULT;
> +	struct ocfs2_info_fs_features oif;
> +	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
> +
> +	if (o2info_from_user(oif, req))
> +		goto bail;
> +
> +	oif.if_compat_features = osb->s_feature_compat;
> +	oif.if_incompat_features = osb->s_feature_incompat;
> +	oif.if_ro_compat_features = osb->s_feature_ro_compat;
> +	oif.if_req.ir_flags |= OCFS2_INFO_FL_FILLED;
> +
> +	if (o2info_to_user(oif, req))
> +		goto bail;
> +
> +	status = 0;
> +bail:
> +	return status;
> +}
> +
> +int ocfs2_info_handle_unknown(struct inode *inode,
> +			      struct ocfs2_info_request __user *req)
> +{
> +	int status = -EFAULT;
> +	struct ocfs2_info_request oir;
> +
> +	if (o2info_from_user(oir, req))
> +		goto bail;
> +
> +	oir.ir_flags &= ~OCFS2_INFO_FL_FILLED;
> +
> +	if (o2info_to_user(oir, req))
> +		goto bail;
> +
> +	status = 0;
> +bail:
> +	return status;
> +}
> +
> +/*
> + * Validate and distinguish OCFS2_IOC_INFO requests.
> + *
> + * - validate the magic number.
> + * - distinguish different requests.
> + * - validate size of different requests.
> + */
> +int ocfs2_info_handle_request(struct inode *inode,
> +			      struct ocfs2_info_request __user *req)
> +{
> +	int status = -EFAULT;
> +	struct ocfs2_info_request oir;
> +
> +	if (o2info_from_user(oir, req))
> +		goto bail;
> +
> +	status = -EINVAL;
> +	if (oir.ir_magic != OCFS2_INFO_MAGIC)
> +		goto bail;
> +
> +	switch (oir.ir_code) {
> +	case OCFS2_INFO_BLOCKSIZE:
> +		if (oir.ir_size == sizeof(struct ocfs2_info_blocksize))
> +			status = ocfs2_info_handle_blocksize(inode, req);
> +		break;
> +	case OCFS2_INFO_CLUSTERSIZE:
> +		if (oir.ir_size == sizeof(struct ocfs2_info_clustersize))
> +			status = ocfs2_info_handle_clustersize(inode, req);
> +		break;
> +	case OCFS2_INFO_MAXSLOTS:
> +		if (oir.ir_size == sizeof(struct ocfs2_info_maxslots))
> +			status = ocfs2_info_handle_maxslots(inode, req);
> +		break;
> +	case OCFS2_INFO_LABEL:
> +		if (oir.ir_size == sizeof(struct ocfs2_info_label))
> +			status = ocfs2_info_handle_label(inode, req);
> +		break;
> +	case OCFS2_INFO_UUID:
> +		if (oir.ir_size == sizeof(struct ocfs2_info_uuid))
> +			status = ocfs2_info_handle_uuid(inode, req);
> +		break;
> +	case OCFS2_INFO_FS_FEATURES:
> +		if (oir.ir_size == sizeof(struct ocfs2_info_fs_features))
> +			status = ocfs2_info_handle_fs_features(inode, req);
> +		break;
> +	default:
> +		status = ocfs2_info_handle_unknown(inode, req);
> +		break;
> +	}
> +
> +bail:
> +	return status;
> +}
> +
> +/*
> + * OCFS2_IOC_INFO handles an array of requests passed from userspace.
> + *
> + * ocfs2_info_handle() recevies a large info aggregation, grab and
> + * validate the request count from header, then break it into small
> + * pieces, later specific handlers can handle them one by one.
> + *
> + * Idea here is to make each separate request small enough to ensure
> + * a better backward&forward compatibility, since a small piece of
> + * request will be less likely to be broken if disk layout get changed.
> + */
> +int ocfs2_info_handle(struct inode *inode, struct ocfs2_info *info,
> +		      int compat_flag)
> +{
> +	int i, status = 0;
> +	u64 req_addr;
> +	struct ocfs2_info_request __user *reqp;
> +
> +	if ((info->oi_count > OCFS2_INFO_MAX_REQUEST) ||
> +	    (!info->oi_requests)) {
> +		status = -EINVAL;
> +		goto bail;
> +	}
> +
> +	for (i = 0; i < info->oi_count; i++) {
> +		status = -EFAULT;
> +		if (compat_flag) {
> +			if (get_user(req_addr,
> +			     (u64 __user *)compat_ptr(info->oi_requests) + i))
> +				goto bail;
> +		} else {
> +			if (get_user(req_addr,
> +				     (u64 __user *)(info->oi_requests) + i))
> +				goto bail;
> +		}
> +
> +		reqp = (struct ocfs2_info_request *)req_addr;
> +		if (!reqp) {
> +			status = -EINVAL;
> +			goto bail;
> +		}
> +
> +		status = ocfs2_info_handle_request(inode, reqp);
> +		if (status)
> +			goto bail;
> +	}
> +
> +bail:
> +	return status;
> +}
> +
>  long ocfs2_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
>  {
>  	struct inode *inode = filp->f_path.dentry->d_inode;
> @@ -120,6 +381,7 @@ long ocfs2_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
>  	struct reflink_arguments args;
>  	const char *old_path, *new_path;
>  	bool preserve;
> +	struct ocfs2_info info;
>  
>  	switch (cmd) {
>  	case OCFS2_IOC_GETFLAGS:
> @@ -174,6 +436,12 @@ long ocfs2_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
>  		preserve = (args.preserve != 0);
>  
>  		return ocfs2_reflink_ioctl(inode, old_path, new_path, preserve);
> +	case OCFS2_IOC_INFO:
> +		if (copy_from_user(&info, (struct ocfs2_info __user *)arg,
> +				   sizeof(struct ocfs2_info)))
> +			return -EFAULT;
> +
> +		return ocfs2_info_handle(inode, &info, 0);
>  	default:
>  		return -ENOTTY;
>  	}
> @@ -185,6 +453,7 @@ long ocfs2_compat_ioctl(struct file *file, unsigned cmd, unsigned long arg)
>  	bool preserve;
>  	struct reflink_arguments args;
>  	struct inode *inode = file->f_path.dentry->d_inode;
> +	struct ocfs2_info info;
>  
>  	switch (cmd) {
>  	case OCFS2_IOC32_GETFLAGS:
> @@ -209,6 +478,12 @@ long ocfs2_compat_ioctl(struct file *file, unsigned cmd, unsigned long arg)
>  
>  		return ocfs2_reflink_ioctl(inode, compat_ptr(args.old_path),
>  					   compat_ptr(args.new_path), preserve);
> +	case OCFS2_IOC_INFO:
> +		if (copy_from_user(&info, (struct ocfs2_info __user *)arg,
> +				   sizeof(struct ocfs2_info)))
> +			return -EFAULT;
> +
> +		return ocfs2_info_handle(inode, &info, 1);
>  	default:
>  		return -ENOIOCTLCMD;
>  	}
> diff --git a/fs/ocfs2/ocfs2_ioctl.h b/fs/ocfs2/ocfs2_ioctl.h
> index 2d3420a..12a5502 100644
> --- a/fs/ocfs2/ocfs2_ioctl.h
> +++ b/fs/ocfs2/ocfs2_ioctl.h
> @@ -76,4 +76,84 @@ struct reflink_arguments {
>  };
>  #define OCFS2_IOC_REFLINK	_IOW('o', 4, struct reflink_arguments)
>  
> +/* Following definitions dedicated for ocfs2_info_request ioctls. */
> +#define OCFS2_INFO_MAX_REQUEST		(50)
> +
> +/* Magic number of all requests */
> +#define OCFS2_INFO_MAGIC		(0x4F32494E)
> +
> +/*
> + * Always try to separate info request into small pieces to
> + * guarantee the backward&forward compatibility.
> + */
> +struct ocfs2_info {
> +	__u64 oi_requests;	/* Array of __u64 pointers to requests */
> +	__u32 oi_count;	/* Number of requests in info_requests */
> +};
> +
> +struct ocfs2_info_request {
> +/*00*/	__u32 ir_magic;	/* Magic number */
> +	__u32 ir_code;	/* Info request code */
> +	__u32 ir_size;	/* Size of request */
> +	__u32 ir_flags;	/* Request flags */
> +/*10*/	/* Request specific fields */
> +};
> +
> +struct ocfs2_info_clustersize {
> +	struct ocfs2_info_request ic_req;
> +	__u32 ic_clustersize;
> +};
> +
> +struct ocfs2_info_blocksize {
> +	struct ocfs2_info_request ib_req;
> +	__u32 ib_blocksize;
> +};
> +
> +struct ocfs2_info_maxslots {
> +	struct ocfs2_info_request im_req;
> +	__u16 im_max_slots;
> +};
> +
> +struct ocfs2_info_label {
> +	struct ocfs2_info_request il_req;
> +	__u8	il_label[OCFS2_MAX_VOL_LABEL_LEN];
> +};
> +
> +struct ocfs2_info_uuid {
> +	struct ocfs2_info_request iu_req;
> +	__u8	iu_uuid_str[OCFS2_VOL_UUIDSTR_LEN];
> +};
> +
> +struct ocfs2_info_fs_features {
> +	struct ocfs2_info_request if_req;
> +	__u32 if_compat_features;
> +	__u32 if_incompat_features;
> +	__u32 if_ro_compat_features;
> +};
> +
> +/* Codes for ocfs2_info_request */
> +enum ocfs2_info_type {
> +	OCFS2_INFO_CLUSTERSIZE = 1,
> +	OCFS2_INFO_BLOCKSIZE,
> +	OCFS2_INFO_MAXSLOTS,
> +	OCFS2_INFO_LABEL,
> +	OCFS2_INFO_UUID,
> +	OCFS2_INFO_FS_FEATURES,
> +	OCFS2_INFO_NUM_TYPES
> +};
> +
> +/* Flags for struct ocfs2_info_request */
> +/* Filled by the caller */
> +#define OCFS2_INFO_FL_NON_COHERENT	(0x00000001)	/* Cluster coherency not
> +							   required. This is a hint.
> +							   It is up to ocfs2 whether
> +							   the request can be fulfilled
> +							   without locking. */
> +/* Filled by ocfs2 */
> +#define OCFS2_INFO_FL_FILLED		(0x80000000)	/* Filesystem understood
> +							   this request and
> +							   filled in the answer */
> +
> +#define OCFS2_IOC_INFO		_IOR('o', 5, struct ocfs2_info)
> +
>  #endif /* OCFS2_IOCTL_H */
>   
