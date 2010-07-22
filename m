From: Wengang Wang <wen.gang.wang@Oracle.COM>
Date: Thu, 22 Jul 2010 23:22:07 +0800
Subject: [Ocfs2-devel] [TRIVIAL] [PATCH] Remove unnecessary goto
 statements
In-Reply-To: <AANLkTilVfUTA63SEMhnaagn-mmmEWwfKgogpYcJwdqxA@mail.gmail.com>
References: <AANLkTilVfUTA63SEMhnaagn-mmmEWwfKgogpYcJwdqxA@mail.gmail.com>
Message-ID: <20100722152207.GB3973@laptop.jp.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 10-07-22 09:50, Goldwyn Rodrigues wrote:
> Remove unnecessary goto statements.
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.de>
> 
> ---
> diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
> index c30b644..c91527f 100644
> --- a/fs/ocfs2/suballoc.c
> +++ b/fs/ocfs2/suballoc.c
> @@ -824,10 +824,8 @@ int ocfs2_reserve_cluster_bitmap_bits(struct
> ocfs2_super *osb,
>  					     ALLOC_NEW_GROUP);
>  	if (status < 0 && status != -ENOSPC) {
>  		mlog_errno(status);
> -		goto bail;
>  	}

The duplicated check for "status != -ENOSPC" can be removed too :)
mlog_errno() is doing that check.

> 
> -bail:
>  	return status;
>  }
> 
> @@ -1050,7 +1048,6 @@ static inline int
> ocfs2_block_group_set_bits(handle_t *handle,
>  				     group_bh);
>  	if (status < 0) {
>  		mlog_errno(status);
> -		goto bail;
>  	}

Why this?
the following lines are modifying the buffer head.

1361         le16_add_cpu(&bg->bg_free_bits_count, -num_bits);
1362         while(num_bits--)
1363                 ocfs2_set_bit(bit_off++, bitmap);
1364 
1365         ocfs2_journal_dirty(handle, group_bh);
1366 
1367 bail:

For the next read of this group descriptor, we can't be sure it will be dirty
read. So that it may get wrong contents and then the following write will write
the wrong contents to disk.

regards,
wengang.
> 
>  bail:
