From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Tue, 1 Dec 2015 15:08:51 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2: return non-zero st_blocks for
 inline data
In-Reply-To: <1448399221-6109-2-git-send-email-john.haxby@oracle.com>
References: <1448399221-6109-1-git-send-email-john.haxby@oracle.com>
	<1448399221-6109-2-git-send-email-john.haxby@oracle.com>
Message-ID: <565D4783.2090501@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 11/25/2015 05:07 AM, John Haxby wrote:
> Some versions of tar assume that files with st_blocks == 0 do not
> contain any data and will skip reading them entirely. See also
> commit 9206c561554c ("ext4: return non-zero st_blocks for inline data").
> 
> Signed-off-by: John Haxby <john.haxby@oracle.com>
> ---
>  fs/ocfs2/file.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
> index 0e5b451..d631279 100644
> --- a/fs/ocfs2/file.c
> +++ b/fs/ocfs2/file.c
> @@ -1302,6 +1302,14 @@ int ocfs2_getattr(struct vfsmount *mnt,
>  	}
>  
>  	generic_fillattr(inode, stat);
> +	/*
> +	 * If there is inline data in the inode, the inode will normally not
> +	 * have data blocks allocated (it may have an external xattr block).
> +	 * Report at least one sector for such files, so tools like tar, rsync,
> +	 * others don't incorrectly think the file is completely sparse.
> +	 */
> +	if (unlikely(OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL))
> +		stat->blocks += (stat->size + 511)>>9;
From filesystem side, looks reasonable that data block is 0 for
inlined-data file. This is like a hack to filesystem to fix tools issue.
Indeed tar-1.26-27 have been fixed to not think file with st_blocks == 0
empty. But I am not sure why ext4 merge that fix.

Thanks,
Junxiao.

>  
>  	/* We set the blksize from the cluster size for performance */
>  	stat->blksize = osb->s_clustersize;
> 
