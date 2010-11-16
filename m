From: Jan Kara <jack@suse.cz>
Date: Tue, 16 Nov 2010 11:50:42 -0000
Subject: [Ocfs2-devel] [PATCH 3/6] Ocfs2: handle hole punching via
	fallocate properly
In-Reply-To: <1289840723-3056-4-git-send-email-josef@redhat.com>
References: <1289840723-3056-1-git-send-email-josef@redhat.com>
	<1289840723-3056-4-git-send-email-josef@redhat.com>
Message-ID: <20101116115038.GC4757@quack.suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Josef Bacik <josef@redhat.com>
Cc: david@fromorbit.com, linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, cmm@us.ibm.com, cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com

On Mon 15-11-10 12:05:20, Josef Bacik wrote:
> This patch just makes ocfs2 use its UNRESERVP ioctl when we get the hole punch
> flag in fallocate.  I didn't test it, but it seems simple enough.  Thanks,
> 
> Signed-off-by: Josef Bacik <josef@redhat.com>
  You might want to directly CC Joel Becker <Joel.Becker@oracle.com> who
maintains OCFS2. Otherwise the patch looks OK so you can add
  Acked-by: Jan Kara <jack@suse.cz>
for what it's worth ;).

								Honza
> ---
>  fs/ocfs2/file.c |   10 ++++++++--
>  1 files changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
> index 77b4c04..181ae52 100644
> --- a/fs/ocfs2/file.c
> +++ b/fs/ocfs2/file.c
> @@ -1992,6 +1992,7 @@ static long ocfs2_fallocate(struct inode *inode, int mode, loff_t offset,
>  	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
>  	struct ocfs2_space_resv sr;
>  	int change_size = 1;
> +	int cmd = OCFS2_IOC_RESVSP64;
>  
>  	if (!ocfs2_writes_unwritten_extents(osb))
>  		return -EOPNOTSUPP;
> @@ -2002,12 +2003,17 @@ static long ocfs2_fallocate(struct inode *inode, int mode, loff_t offset,
>  	if (mode & FALLOC_FL_KEEP_SIZE)
>  		change_size = 0;
>  
> +	if (mode & FALLOC_FL_PUNCH_HOLE) {
> +		cmd = OCFS2_IOC_UNRESVSP64;
> +		change_size = 0;
> +	}
> +
>  	sr.l_whence = 0;
>  	sr.l_start = (s64)offset;
>  	sr.l_len = (s64)len;
>  
> -	return __ocfs2_change_file_space(NULL, inode, offset,
> -					 OCFS2_IOC_RESVSP64, &sr, change_size);
> +	return __ocfs2_change_file_space(NULL, inode, offset, cmd, &sr,
> +					 change_size);
>  }
>  
>  int ocfs2_check_range_for_refcount(struct inode *inode, loff_t pos,
> -- 
> 1.6.6.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo at vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
