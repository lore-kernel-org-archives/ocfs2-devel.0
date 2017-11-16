From: Changwei Ge <ge.changwei@h3c.com>
Date: Thu, 16 Nov 2017 00:42:09 +0000
Subject: [Ocfs2-devel] [PATCH] ocfs2: The goto is not useful in the
 function ocfs2_reserve_cluster_bitmap_bits, so remove it.
References: <71604351584F6A4EBAE558C676F37CA4F3CDE3A9@H3CMLB14-EX.srv.huawei-3com.com>
Message-ID: <63ADC13FD55D6546B7DECE290D39E373CED7B2EF@H3CMLB14-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Zhonghua,
On 2017/11/15 20:04, Guozhonghua wrote:
> The goto is not useful anymore, removed from the context.

Perhaps we can make this change-log more clear like:
The bail declare is not necessary any more, so trim it. If code path 
falls into error branch, ocfs2_reserve_cluster_bitmap_bits will return 
in next following step, too.

And this title can be changed into 'ocfs2: clean up unnecessary bail 
declare'

I suppose after that this patch will be neater.

Can you resend this patch?
Moreover, I think we should also CC this patch to OCFS2 maintainers.

Thanks,
Changwei

> 
> Signed-off-by: guozhonghua <guozhonghua@h3c.com>
> ---
>   fs/ocfs2/suballoc.c |    5 +----
>   1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
> index 71f22c8..9f0b95a 100644
> --- a/fs/ocfs2/suballoc.c
> +++ b/fs/ocfs2/suballoc.c
> @@ -1147,12 +1147,9 @@ int ocfs2_reserve_cluster_bitmap_bits(struct ocfs2_super *osb,
>   					     GLOBAL_BITMAP_SYSTEM_INODE,
>   					     OCFS2_INVALID_SLOT, NULL,
>   					     ALLOC_NEW_GROUP);
> -	if (status < 0 && status != -ENOSPC) {
> +	if (status < 0 && status != -ENOSPC)
>   		mlog_errno(status);
> -		goto bail;
> -	}
>   
> -bail:
>   	return status;
>   }
>   
> 
