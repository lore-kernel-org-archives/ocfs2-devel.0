From: Joel Becker <jlbec@evilplan.org>
Date: Wed, 26 Mar 2014 19:22:08 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: do not put bh when buffer_uptodate
 failed
In-Reply-To: <53312AD6.4080607@huawei.com>
References: <53312AD6.4080607@huawei.com>
Message-ID: <20140327022207.GA5215@localhost>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Mar 25, 2014 at 03:05:58PM +0800, alex chen wrote:
> Do not put bh when buffer_uptodate failed in ocfs2_write_block and
> ocfs2_write_super_or_backup, because it will put bh in b_end_io.
> Otherwise it will hit a warning "VFS: brelse: Trying to free free
> buffer".
> 
> Signed-off-by: Alex Chen <alex.chen@huawei.com>
> Reviewed-by: Joseph Qi <joseph.qi@huawei.com>

Good catch.  Can you tell me what testing or workload found this issue?
Just for future reference.

Acked-by: Joel Becker <jlbec@evilplan.org>

> ---
>  fs/ocfs2/buffer_head_io.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/fs/ocfs2/buffer_head_io.c b/fs/ocfs2/buffer_head_io.c
> index 5b704c6..1edcb14 100644
> --- a/fs/ocfs2/buffer_head_io.c
> +++ b/fs/ocfs2/buffer_head_io.c
> @@ -90,7 +90,6 @@ int ocfs2_write_block(struct ocfs2_super *osb, struct buffer_head *bh,
>  		 * information for this bh as it's not marked locally
>  		 * uptodate. */
>  		ret = -EIO;
> -		put_bh(bh);
>  		mlog_errno(ret);
>  	}
> 
> @@ -420,7 +419,6 @@ int ocfs2_write_super_or_backup(struct ocfs2_super *osb,
> 
>  	if (!buffer_uptodate(bh)) {
>  		ret = -EIO;
> -		put_bh(bh);
>  		mlog_errno(ret);
>  	}
> 
> -- 
> 1.8.4.3
> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel

-- 

Life's Little Instruction Book #497

	"Go down swinging."

			http://www.jlbec.org/
			jlbec at evilplan.org
