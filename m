From: Tao Ma <tao.ma@oracle.com>
Date: Wed, 07 Jul 2010 23:19:27 +0800
Subject: [Ocfs2-devel] [PATCH 1/3] ocfs2: When zero extending,
	do it by page.
In-Reply-To: <1278501367-7710-2-git-send-email-joel.becker@oracle.com>
References: <20100703213219.GB21262@mail.oracle.com>
	<1278501367-7710-2-git-send-email-joel.becker@oracle.com>
Message-ID: <4C349AFF.9040301@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joel Becker <joel.becker@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>, Linus Torvalds <torvalds@linux-foundation.org>, Linux Kernel <linux-kernel@vger.kernel.org>, ocfs2-devel@oss.oracle.com, Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>, Mark Fasheh <mfasheh@suse.com>

Hi Joel,
Joel Becker wrote:
> ocfs2_zero_extend() does its zeroing block by block, but it calls a
> function named ocfs2_write_zero_page().  Let's have
> ocfs2_write_zero_page() handle the page level.  From
> ocfs2_zero_extend()'s perspective, it is now page-at-a-time.
>
> Signed-off-by: Joel Becker <joel.becker@oracle.com>
> ---
>  fs/ocfs2/aops.c |   30 --------------
>  fs/ocfs2/file.c |  119 +++++++++++++++++++++++++++++++++++++++----------------
>  2 files changed, 85 insertions(+), 64 deletions(-)
>
> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
> index 3623ca2..9a5c931 100644
> --- a/fs/ocfs2/aops.c
> +++ b/fs/ocfs2/aops.c
> @@ -459,36 +459,6 @@ int walk_page_buffers(	handle_t *handle,
>  	return ret;
>  }
>  
> -handle_t *ocfs2_start_walk_page_trans(struct inode *inode,
> -							 struct page *page,
> -							 unsigned from,
> -							 unsigned to)
> -{
> -	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
> -	handle_t *handle;
> -	int ret = 0;
> -
> -	handle = ocfs2_start_trans(osb, OCFS2_INODE_UPDATE_CREDITS);
> -	if (IS_ERR(handle)) {
> -		ret = -ENOMEM;
> -		mlog_errno(ret);
> -		goto out;
> -	}
> -
> -	if (ocfs2_should_order_data(inode)) {
> -		ret = ocfs2_jbd2_file_inode(handle, inode);
> -		if (ret < 0)
> -			mlog_errno(ret);
> -	}
> -out:
> -	if (ret) {
> -		if (!IS_ERR(handle))
> -			ocfs2_commit_trans(osb, handle);
> -		handle = ERR_PTR(ret);
> -	}
> -	return handle;
> -}
> -
>  static sector_t ocfs2_bmap(struct address_space *mapping, sector_t block)
>  {
>  	sector_t status;
> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
> index 6a13ea6..a6e0eb6 100644
> --- a/fs/ocfs2/file.c
> +++ b/fs/ocfs2/file.c
> @@ -724,28 +724,55 @@ leave:
>  	return status;
>  }
>  
> +/*
> + * While a write will already be ordering the data, a truncate will not.
> + * Thus, we need to explicitly order the zeroed pages.
> + */
> +static handle_t *ocfs2_zero_start_ordered_transaction(struct inode *inode)
> +{
> +	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
> +	handle_t *handle = NULL;
> +	int ret = 0;
> +
> +	if (ocfs2_should_order_data(inode))
>   
This should be if (!ocfs2_should_order_data(inode)) I guess? ;)
> +		goto out;
> +
> +	handle = ocfs2_start_trans(osb, OCFS2_INODE_UPDATE_CREDITS);
> +	if (IS_ERR(handle)) {
> +		ret = -ENOMEM;
> +		mlog_errno(ret);
> +		goto out;
> +	}
> +
>   
Regards,
Tao
