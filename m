From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu, 31 Mar 2011 14:13:41 -0700
Subject: [Ocfs2-devel] [PATCH 3/3] Ocfs2: Cleanup for OCFS2_IOC_RESVSP &
	OCFS2_IOC_UNRESVSP.
In-Reply-To: <1301556866-8460-3-git-send-email-tristan.ye@oracle.com>
References: <1301556866-8460-1-git-send-email-tristan.ye@oracle.com>
	<1301556866-8460-3-git-send-email-tristan.ye@oracle.com>
Message-ID: <4D94EE85.1010808@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 03/31/2011 12:34 AM, Tristan Ye wrote:
> Given that VFS has alreay supported an entry to handle the unwritten_extents
> and punching-hole(is to be supported) by filp->f_op->fallocate(), our path of
> OCFS2_IOC_RESVSP becomes a bit redundant somehow, especially given the fact
> that ocfs2_fallocate() is working well.
>
> Signed-off-by: Tristan Ye<tristan.ye@oracle.com>
> ---
>   fs/ocfs2/file.c        |   63 ++++++++++++++++++++---------------------------
>   fs/ocfs2/file.h        |    3 --
>   fs/ocfs2/ioctl.c       |   13 ----------
>   fs/ocfs2/ocfs2_ioctl.h |   29 +++-------------------
>   4 files changed, 31 insertions(+), 77 deletions(-)
>
> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
> index cce8c2b..d016322 100644
> --- a/fs/ocfs2/file.c
> +++ b/fs/ocfs2/file.c
> @@ -37,6 +37,7 @@
>   #include<linux/falloc.h>
>   #include<linux/quotaops.h>
>   #include<linux/blkdev.h>
> +#include<linux/falloc.h>
>
>   #include<cluster/masklog.h>
>
> @@ -1804,7 +1805,7 @@ out:
>    */
>   static int __ocfs2_change_file_space(struct file *file, struct inode *inode,
>   				     loff_t f_pos, unsigned int cmd,
> -				     struct ocfs2_space_resv *sr,
> +				     struct space_resv *sr,
>   				     int change_size)
>   {
>   	int ret;
> @@ -1866,7 +1867,7 @@ static int __ocfs2_change_file_space(struct file *file, struct inode *inode,
>   	}
>   	size = sr->l_start + sr->l_len;
>
> -	if (cmd == OCFS2_IOC_RESVSP || cmd == OCFS2_IOC_RESVSP64) {
> +	if (cmd == FS_IOC_RESVSP || cmd == FS_IOC_RESVSP64) {
>   		if (sr->l_len<= 0) {
>   			ret = -EINVAL;
>   			goto out_inode_unlock;
> @@ -1883,8 +1884,8 @@ static int __ocfs2_change_file_space(struct file *file, struct inode *inode,
>
>   	down_write(&OCFS2_I(inode)->ip_alloc_sem);
>   	switch (cmd) {
> -	case OCFS2_IOC_RESVSP:
> -	case OCFS2_IOC_RESVSP64:
> +	case FS_IOC_RESVSP:
> +	case FS_IOC_RESVSP64:
>   		/*
>   		 * This takes unsigned offsets, but the signed ones we
>   		 * pass have been checked against overflow above.
> @@ -1892,8 +1893,8 @@ static int __ocfs2_change_file_space(struct file *file, struct inode *inode,
>   		ret = ocfs2_allocate_unwritten_extents(inode, sr->l_start,
>   						       sr->l_len);
>   		break;
> -	case OCFS2_IOC_UNRESVSP:
> -	case OCFS2_IOC_UNRESVSP64:
> +	case FS_IOC_UNRESVSP:
> +	case FS_IOC_UNRESVSP64:
>   		ret = ocfs2_remove_inode_range(inode, di_bh, sr->l_start,
>   					       sr->l_len);
>   		break;
> @@ -1937,47 +1938,37 @@ out:
>   	return ret;
>   }
>
> -int ocfs2_change_file_space(struct file *file, unsigned int cmd,
> -			    struct ocfs2_space_resv *sr)
> -{
> -	struct inode *inode = file->f_path.dentry->d_inode;
> -	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
> -
> -	if ((cmd == OCFS2_IOC_RESVSP || cmd == OCFS2_IOC_RESVSP64)&&
> -	    !ocfs2_writes_unwritten_extents(osb))
> -		return -ENOTTY;
> -	else if ((cmd == OCFS2_IOC_UNRESVSP || cmd == OCFS2_IOC_UNRESVSP64)&&
> -		 !ocfs2_sparse_alloc(osb))
> -		return -ENOTTY;
> -
> -	if (!S_ISREG(inode->i_mode))
> -		return -EINVAL;
> -
> -	if (!(file->f_mode&  FMODE_WRITE))
> -		return -EBADF;
> -
> -	return __ocfs2_change_file_space(file, inode, file->f_pos, cmd, sr, 0);
> -}
> -
>   static long ocfs2_fallocate(struct file *file, int mode, loff_t offset,
>   			    loff_t len)
>   {
>   	struct inode *inode = file->f_path.dentry->d_inode;
>   	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
> -	struct ocfs2_space_resv sr;
> +	struct space_resv sr;
>   	int change_size = 1;
> -	int cmd = OCFS2_IOC_RESVSP64;
> +	int cmd = FS_IOC_RESVSP64;
>
>   	if (mode&  ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE))
>   		return -EOPNOTSUPP;
> -	if (!ocfs2_writes_unwritten_extents(osb))
> -		return -EOPNOTSUPP;
>
> -	if (mode&  FALLOC_FL_KEEP_SIZE)
> -		change_size = 0;
> +	/*
> +	 * unwritten extents
> +	 */
> +	if ((mode&  FALLOC_FL_KEEP_SIZE)&&  !(mode&  FALLOC_FL_PUNCH_HOLE)) {
> +		if (ocfs2_writes_unwritten_extents(osb))
> +			change_size = 0;
> +		else
> +			return -EOPNOTSUPP;
> +	}

I think you have made the code harder to read that it was previously.


>
> -	if (mode&  FALLOC_FL_PUNCH_HOLE)
> -		cmd = OCFS2_IOC_UNRESVSP64;
> +	/*
> +	 * punching hole
> +	 */
> +	if ((mode&  FALLOC_FL_KEEP_SIZE)&&  (mode&  FALLOC_FL_PUNCH_HOLE)) {
> +		if (ocfs2_sparse_alloc(osb))
> +			cmd = FS_IOC_UNRESVSP64;
> +		else
> +			return -EOPNOTSUPP;
> +	}
>
>   	sr.l_whence = 0;
>   	sr.l_start = (s64)offset;
> diff --git a/fs/ocfs2/file.h b/fs/ocfs2/file.h
> index f5afbbe..2c9b7a8 100644
> --- a/fs/ocfs2/file.h
> +++ b/fs/ocfs2/file.h
> @@ -68,9 +68,6 @@ int ocfs2_should_update_atime(struct inode *inode,
>   int ocfs2_update_inode_atime(struct inode *inode,
>   			     struct buffer_head *bh);
>
> -int ocfs2_change_file_space(struct file *file, unsigned int cmd,
> -			    struct ocfs2_space_resv *sr);
> -
>   int ocfs2_check_range_for_refcount(struct inode *inode, loff_t pos,
>   				   size_t count);
>   #endif /* OCFS2_FILE_H */
> diff --git a/fs/ocfs2/ioctl.c b/fs/ocfs2/ioctl.c
> index 8f13c59..d703210 100644
> --- a/fs/ocfs2/ioctl.c
> +++ b/fs/ocfs2/ioctl.c
> @@ -476,7 +476,6 @@ long ocfs2_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
>   	unsigned int flags;
>   	int new_clusters;
>   	int status;
> -	struct ocfs2_space_resv sr;
>   	struct ocfs2_new_group_input input;
>   	struct reflink_arguments args;
>   	const char *old_path, *new_path;
> @@ -502,14 +501,6 @@ long ocfs2_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
>   			OCFS2_FL_MODIFIABLE);
>   		mnt_drop_write(filp->f_path.mnt);
>   		return status;
> -	case OCFS2_IOC_RESVSP:
> -	case OCFS2_IOC_RESVSP64:
> -	case OCFS2_IOC_UNRESVSP:
> -	case OCFS2_IOC_UNRESVSP64:
> -		if (copy_from_user(&sr, (int __user *) arg, sizeof(sr)))
> -			return -EFAULT;
> -
> -		return ocfs2_change_file_space(filp, cmd,&sr);
>   	case OCFS2_IOC_GROUP_EXTEND:
>   		if (!capable(CAP_SYS_RESOURCE))
>   			return -EPERM;
> @@ -562,10 +553,6 @@ long ocfs2_compat_ioctl(struct file *file, unsigned cmd, unsigned long arg)
>   	case OCFS2_IOC32_SETFLAGS:
>   		cmd = OCFS2_IOC_SETFLAGS;
>   		break;
> -	case OCFS2_IOC_RESVSP:
> -	case OCFS2_IOC_RESVSP64:
> -	case OCFS2_IOC_UNRESVSP:
> -	case OCFS2_IOC_UNRESVSP64:
>   	case OCFS2_IOC_GROUP_EXTEND:
>   	case OCFS2_IOC_GROUP_ADD:
>   	case OCFS2_IOC_GROUP_ADD64:
> diff --git a/fs/ocfs2/ocfs2_ioctl.h b/fs/ocfs2/ocfs2_ioctl.h
> index b46f39b..4f9bf28 100644
> --- a/fs/ocfs2/ocfs2_ioctl.h
> +++ b/fs/ocfs2/ocfs2_ioctl.h
> @@ -28,31 +28,10 @@
>   #define OCFS2_IOC32_GETFLAGS	FS_IOC32_GETFLAGS
>   #define OCFS2_IOC32_SETFLAGS	FS_IOC32_SETFLAGS
>
> -/*
> - * Space reservation / allocation / free ioctls and argument structure
> - * are designed to be compatible with XFS.
> - *
> - * ALLOCSP* and FREESP* are not and will never be supported, but are
> - * included here for completeness.
> - */
> -struct ocfs2_space_resv {
> -	__s16		l_type;
> -	__s16		l_whence;
> -	__s64		l_start;
> -	__s64		l_len;		/* len == 0 means until end of file */
> -	__s32		l_sysid;
> -	__u32		l_pid;
> -	__s32		l_pad[4];	/* reserve area			    */
> -};
> -
> -#define OCFS2_IOC_ALLOCSP		_IOW ('X', 10, struct ocfs2_space_resv)
> -#define OCFS2_IOC_FREESP		_IOW ('X', 11, struct ocfs2_space_resv)
> -#define OCFS2_IOC_RESVSP		_IOW ('X', 40, struct ocfs2_space_resv)
> -#define OCFS2_IOC_UNRESVSP	_IOW ('X', 41, struct ocfs2_space_resv)
> -#define OCFS2_IOC_ALLOCSP64	_IOW ('X', 36, struct ocfs2_space_resv)
> -#define OCFS2_IOC_FREESP64	_IOW ('X', 37, struct ocfs2_space_resv)
> -#define OCFS2_IOC_RESVSP64	_IOW ('X', 42, struct ocfs2_space_resv)
> -#define OCFS2_IOC_UNRESVSP64	_IOW ('X', 43, struct ocfs2_space_resv)
> +#define OCFS2_IOC_ALLOCSP		_IOW ('X', 10, struct space_resv)
> +#define OCFS2_IOC_FREESP		_IOW ('X', 11, struct space_resv)
> +#define OCFS2_IOC_ALLOCSP64	_IOW ('X', 36, struct space_resv)
> +#define OCFS2_IOC_FREESP64	_IOW ('X', 37, struct space_resv)
>
>   /* Used to pass group descriptor data when online resize is done */
>   struct ocfs2_new_group_input {
