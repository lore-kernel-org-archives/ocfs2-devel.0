From: Gang He <ghe@suse.com>
Date: Mon, 30 May 2016 03:25:08 -0600
Subject: [Ocfs2-devel] [PATCH 3/5] Generate uevents for errors
In-Reply-To: <1464232219-12553-4-git-send-email-rgoldwyn@suse.de>
References: <1464232219-12553-1-git-send-email-rgoldwyn@suse.de>
	<1464232219-12553-4-git-send-email-rgoldwyn@suse.de>
Message-ID: <574C7774020000F900039259@prv-mh.provo.novell.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Looks good for me.

Thanks
Gang


>>> 
> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
> 
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> ---
>  fs/ocfs2/inode.c | 13 +++++++++++++
>  fs/ocfs2/sysfs.c | 17 +++++++++++++++++
>  fs/ocfs2/sysfs.h |  2 ++
>  3 files changed, 32 insertions(+)
> 
> diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
> index 12f4a9e..a6cfe5d 100644
> --- a/fs/ocfs2/inode.c
> +++ b/fs/ocfs2/inode.c
> @@ -54,6 +54,7 @@
>  #include "refcounttree.h"
>  #include "ocfs2_trace.h"
>  #include "filecheck.h"
> +#include "sysfs.h"
>  
>  #include "buffer_head_io.h"
>  
> @@ -1412,6 +1413,9 @@ int ocfs2_validate_inode_block(struct super_block *sb,
>  		rc = ocfs2_error(sb, "Invalid dinode #%llu: signature = %.*s\n",
>  				 (unsigned long long)bh->b_blocknr, 7,
>  				 di->i_signature);
> +		ocfs2_report_error(OCFS2_SB(sb), (unsigned long long)bh->b_blocknr,
> +				(unsigned long long)bh->b_blocknr,
> +				rc);
>  		goto bail;
>  	}
>  
> @@ -1419,6 +1423,9 @@ int ocfs2_validate_inode_block(struct super_block *sb,
>  		rc = ocfs2_error(sb, "Invalid dinode #%llu: i_blkno is %llu\n",
>  				 (unsigned long long)bh->b_blocknr,
>  				 (unsigned long long)le64_to_cpu(di->i_blkno));
> +		ocfs2_report_error(OCFS2_SB(sb), (unsigned long long)bh->b_blocknr,
> +				(unsigned long long)bh->b_blocknr,
> +				rc);
>  		goto bail;
>  	}
>  
> @@ -1426,6 +1433,9 @@ int ocfs2_validate_inode_block(struct super_block *sb,
>  		rc = ocfs2_error(sb,
>  				 "Invalid dinode #%llu: OCFS2_VALID_FL not set\n",
>  				 (unsigned long long)bh->b_blocknr);
> +		ocfs2_report_error(OCFS2_SB(sb), (unsigned long long)bh->b_blocknr,
> +				(unsigned long long)bh->b_blocknr,
> +				rc);
>  		goto bail;
>  	}
>  
> @@ -1435,6 +1445,9 @@ int ocfs2_validate_inode_block(struct super_block *sb,
>  				 "Invalid dinode #%llu: fs_generation is %u\n",
>  				 (unsigned long long)bh->b_blocknr,
>  				 le32_to_cpu(di->i_fs_generation));
> +		ocfs2_report_error(OCFS2_SB(sb), (unsigned long long)bh->b_blocknr,
> +				(unsigned long long)bh->b_blocknr,
> +				rc);
>  		goto bail;
>  	}
>  
> diff --git a/fs/ocfs2/sysfs.c b/fs/ocfs2/sysfs.c
> index 81e3dd4..acc4834 100644
> --- a/fs/ocfs2/sysfs.c
> +++ b/fs/ocfs2/sysfs.c
> @@ -126,6 +126,23 @@ static ssize_t file_check_max_entries_store(struct 
> ocfs2_super *osb,
>  	return count;
>  }
>  
> +void ocfs2_report_error(struct ocfs2_super *osb, unsigned long long ino,
> +			unsigned long long blkno, int errno)
> +{
> +	char event_name[] = "EVENT=FS_ERROR";
> +	char device[16];
> +	char inode_number[16];
> +	char error_number[16];
> +	char block_number[16];
> +	char *envp[] = {event_name, inode_number, error_number, block_number,
> +		NULL};
> +	snprintf(device, 16, "DEVICE=%s", osb->sb->s_id);
> +	snprintf(error_number, 16, "ERROR=%d", errno);
> +	snprintf(inode_number, 16, "INODE=%llu", ino);
> +	snprintf(block_number, 16, "BLOCK=%llu", blkno);
> +	kobject_uevent_env(&osb->kobj, KOBJ_CHANGE, envp);
> +}
> +
>  static void sb_release(struct kobject *kobj)
>  {
>  	struct ocfs2_super *osb = container_of(kobj, struct ocfs2_super, kobj);
> diff --git a/fs/ocfs2/sysfs.h b/fs/ocfs2/sysfs.h
> index d929ac1..0383ee3 100644
> --- a/fs/ocfs2/sysfs.h
> +++ b/fs/ocfs2/sysfs.h
> @@ -3,6 +3,8 @@
>  #ifndef _SYS_H
>  #define _SYS_H
>  
> +void ocfs2_report_error(struct ocfs2_super *osb, unsigned long long ino,
> +		unsigned long long blkno, int error);
>  int ocfs2_sysfs_sb_init(struct super_block *sb);
>  void ocfs2_sysfs_sb_exit(struct super_block *sb);
>  
> -- 
> 2.6.6
> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com 
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
