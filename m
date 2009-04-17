From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Fri, 17 Apr 2009 14:48:43 -0700
Subject: [Ocfs2-devel] [PATCH 1/1] OCFS2: Log -EIO errors just when hit
 them.
In-Reply-To: <200904170744.n3H7iJac013765@acsinet15.oracle.com>
References: <200904170744.n3H7iJac013765@acsinet15.oracle.com>
Message-ID: <49E8F93B.40300@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

I imagine this is for the unlogged EIOs that have been reported.

 From my scan, at least in mainline, all these EIOs are being logged
by the caller. So this patch is not adding any value. Can you double
check that please?

Now it could be that the reported EIOs are on 1.2/1.4 and that those
trees are missing the mlogs. In that case, the patch should be specific
to the tree.

BTW, the (u64) should be (unsigned long long). This ensures that
it compiles warning free on all arches.

Sunil


wengang wang wrote:
> This patch logs(ERROR) -EIO errors just when they are hitted.
>
> Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
> --
> diff -up ./linux-2.6.29.y.build/fs/ocfs2/buffer_head_io.c.orig ./linux-2.6.29.y.build/fs/ocfs2/buffer_head_io.c
> --- ./linux-2.6.29.y.build/fs/ocfs2/buffer_head_io.c.orig	2009-04-17 13:55:52.000000000 +0800
> +++ ./linux-2.6.29.y.build/fs/ocfs2/buffer_head_io.c	2009-04-17 14:19:54.000000000 +0800
> @@ -91,6 +91,8 @@ int ocfs2_write_block(struct ocfs2_super
>  		 * information for this bh as it's not marked locally
>  		 * uptodate. */
>  		ret = -EIO;
> +		mlog(ML_ERROR, "writing block %llu failed with %d\n",
> +		     (u64)bh->b_blocknr, ret);
>  		put_bh(bh);
>  	}
>  
> @@ -168,6 +170,8 @@ int ocfs2_read_blocks_sync(struct ocfs2_
>  			 * so we can safely record this and loop back
>  			 * to cleanup the other buffers. */
>  			status = -EIO;
> +			mlog(ML_ERROR, "reading block %llu failed with %d\n",
> +			     (u64)bh->b_blocknr, status);
>  			put_bh(bh);
>  			bhs[i - 1] = NULL;
>  		}
> @@ -340,6 +344,9 @@ int ocfs2_read_blocks(struct inode *inod
>  				 * for this bh as it's not marked locally
>  				 * uptodate. */
>  				status = -EIO;
> +				mlog(ML_ERROR, "reading block %llu failed with"
> +				     " %d\n",
> +				     (u64)bh->b_blocknr, status);
>  				put_bh(bh);
>  				bhs[i] = NULL;
>  				continue;
> @@ -431,6 +438,8 @@ int ocfs2_write_super_or_backup(struct o
>  
>  	if (!buffer_uptodate(bh)) {
>  		ret = -EIO;
> +		mlog(ML_ERROR, "writing block %llu failed with %d\n",
> +		     (u64)bh->b_blocknr, ret);
>  		put_bh(bh);
>  	}
>   
