From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu, 22 Jul 2010 09:45:36 -0700
Subject: [Ocfs2-devel] [TRIVIAL] [PATCH] Remove unnecessary goto
	statements
In-Reply-To: <AANLkTilVfUTA63SEMhnaagn-mmmEWwfKgogpYcJwdqxA@mail.gmail.com>
References: <AANLkTilVfUTA63SEMhnaagn-mmmEWwfKgogpYcJwdqxA@mail.gmail.com>
Message-ID: <4C4875B0.2020404@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

NAK. Sorry. I don't think the patch is worth it. It's not like
the compiler cannot detect this already.

On 07/22/2010 07:50 AM, Goldwyn Rodrigues wrote:
> Remove unnecessary goto statements.
> Signed-off-by: Goldwyn Rodrigues<rgoldwyn@suse.de>
>
> ---
> diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
> index c30b644..c91527f 100644
> --- a/fs/ocfs2/suballoc.c
> +++ b/fs/ocfs2/suballoc.c
> @@ -824,10 +824,8 @@ int ocfs2_reserve_cluster_bitmap_bits(struct
> ocfs2_super *osb,
>   					     ALLOC_NEW_GROUP);
>   	if (status<  0&&  status != -ENOSPC) {
>   		mlog_errno(status);
> -		goto bail;
>   	}
>
> -bail:
>   	return status;
>   }
>
> @@ -1050,7 +1048,6 @@ static inline int
> ocfs2_block_group_set_bits(handle_t *handle,
>   				     group_bh);
>   	if (status<  0) {
>   		mlog_errno(status);
> -		goto bail;
>   	}
>
>   bail:
>
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
>    
