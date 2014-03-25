From: Srinivas Eeda <srinivas.eeda@oracle.com>
Date: Tue, 25 Mar 2014 11:45:05 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: do not put bh when buffer_uptodate
 failed
In-Reply-To: <53312AD6.4080607@huawei.com>
References: <53312AD6.4080607@huawei.com>
Message-ID: <5331CEB1.8030706@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

These changes looks good to me. However ocfs2_read_blocks and 
ocfs2_read_blocks_sync needs the same fix ? :)

On 03/25/2014 12:05 AM, alex chen wrote:
> Do not put bh when buffer_uptodate failed in ocfs2_write_block and
> ocfs2_write_super_or_backup, because it will put bh in b_end_io.
> Otherwise it will hit a warning "VFS: brelse: Trying to free free
> buffer".
>
> Signed-off-by: Alex Chen <alex.chen@huawei.com>
> Reviewed-by: Joseph Qi <joseph.qi@huawei.com>
> ---
>   fs/ocfs2/buffer_head_io.c | 2 --
>   1 file changed, 2 deletions(-)
>
> diff --git a/fs/ocfs2/buffer_head_io.c b/fs/ocfs2/buffer_head_io.c
> index 5b704c6..1edcb14 100644
> --- a/fs/ocfs2/buffer_head_io.c
> +++ b/fs/ocfs2/buffer_head_io.c
> @@ -90,7 +90,6 @@ int ocfs2_write_block(struct ocfs2_super *osb, struct buffer_head *bh,
>   		 * information for this bh as it's not marked locally
>   		 * uptodate. */
>   		ret = -EIO;
> -		put_bh(bh);
>   		mlog_errno(ret);
>   	}
>
> @@ -420,7 +419,6 @@ int ocfs2_write_super_or_backup(struct ocfs2_super *osb,
>
>   	if (!buffer_uptodate(bh)) {
>   		ret = -EIO;
> -		put_bh(bh);
>   		mlog_errno(ret);
>   	}
>
