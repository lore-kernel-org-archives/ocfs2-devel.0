From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu, 31 Mar 2011 14:14:43 -0700
Subject: [Ocfs2-devel] [PATCH 1/3] VFS/ioctl: Add punching-hole support
	to ioctl().
In-Reply-To: <1301556810-8438-1-git-send-email-tristan.ye@oracle.com>
References: <1301556810-8438-1-git-send-email-tristan.ye@oracle.com>
Message-ID: <4D94EEC3.2030206@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tristan Ye <tristan.ye@oracle.com>
Cc: linux-kernel@vger.kernel.org, josef@redhat.com, ocfs2-devel@oss.oracle.com, chris.mason@oracle.com, linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org

Frankly I see no point extending the ioctl interface when we have
a syscall interface.

On 03/31/2011 12:33 AM, Tristan Ye wrote:
> We're currently support two paths from VFS to preallocate unwritten
> extents(from FS_IOC_RESVSP, or fallocate()), likewise, behavior of
> punching-hole should be treated as the same, this patch tries to teach
> file_ioctl() to handle FS_IOC_UNRESVSP, underlying filesystem like ocfs2
> is wise enough to do the rest of work;-)
>
> Signed-off-by: Tristan Ye<tristan.ye@oracle.com>
> ---
>   fs/ioctl.c             |   10 +++++++---
>   include/linux/falloc.h |    2 ++
>   2 files changed, 9 insertions(+), 3 deletions(-)
>
> diff --git a/fs/ioctl.c b/fs/ioctl.c
> index 1d9b9fc..234e26f 100644
> --- a/fs/ioctl.c
> +++ b/fs/ioctl.c
> @@ -422,7 +422,7 @@ EXPORT_SYMBOL(generic_block_fiemap);
>    * Only the l_start, l_len and l_whence fields of the 'struct space_resv'
>    * are used here, rest are ignored.
>    */
> -int ioctl_preallocate(struct file *filp, void __user *argp)
> +int ioctl_preallocate(struct file *filp, void __user *argp, int mode)
>   {
>   	struct inode *inode = filp->f_path.dentry->d_inode;
>   	struct space_resv sr;
> @@ -443,7 +443,7 @@ int ioctl_preallocate(struct file *filp, void __user *argp)
>   		return -EINVAL;
>   	}
>
> -	return do_fallocate(filp, FALLOC_FL_KEEP_SIZE, sr.l_start, sr.l_len);
> +	return do_fallocate(filp, mode, sr.l_start, sr.l_len);
>   }
>
>   static int file_ioctl(struct file *filp, unsigned int cmd,
> @@ -459,7 +459,11 @@ static int file_ioctl(struct file *filp, unsigned int cmd,
>   		return put_user(i_size_read(inode) - filp->f_pos, p);
>   	case FS_IOC_RESVSP:
>   	case FS_IOC_RESVSP64:
> -		return ioctl_preallocate(filp, p);
> +		return ioctl_preallocate(filp, p, FALLOC_FL_KEEP_SIZE);
> +	case FS_IOC_UNRESVSP:
> +	case FS_IOC_UNRESVSP64:
> +		return ioctl_preallocate(filp, p, FALLOC_FL_KEEP_SIZE |
> +						  FALLOC_FL_PUNCH_HOLE);
>   	}
>
>   	return vfs_ioctl(filp, cmd, arg);
> diff --git a/include/linux/falloc.h b/include/linux/falloc.h
> index 73e0b62..fd1e871 100644
> --- a/include/linux/falloc.h
> +++ b/include/linux/falloc.h
> @@ -21,7 +21,9 @@ struct space_resv {
>   };
>
>   #define FS_IOC_RESVSP		_IOW('X', 40, struct space_resv)
> +#define FS_IOC_UNRESVSP		_IOW('X', 41, struct space_resv)
>   #define FS_IOC_RESVSP64		_IOW('X', 42, struct space_resv)
> +#define FS_IOC_UNRESVSP64	_IOW('X', 43, struct space_resv)
>
>   #endif /* __KERNEL__ */
>
