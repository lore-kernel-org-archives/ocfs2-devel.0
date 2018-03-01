From: Lei Chen <lchen@suse.com>
Date: Wed, 28 Feb 2018 23:59:51 -0700
Subject: [Ocfs2-devel] =?utf-8?b?562U5aSN77yaIFJlOiAgW1BBVENIXSBDb3JyZWN0?=
 =?utf-8?q?_a_comment_error?=
In-Reply-To: <63ADC13FD55D6546B7DECE290D39E373F292A95A@H3CMLB12-EX.srv.huawei-3com.com>
References: <20180228101720.20725-1-lchen@suse.com>
	<63ADC13FD55D6546B7DECE290D39E373F292A95A@H3CMLB12-EX.srv.huawei-3com.com>
Message-ID: <5A97A4E7020000B50006EC49@prv-mh.provo.novell.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Changwei,

Thanks for your review.

I think the original comment is not as clear as you said since 
the code does not reflect any relation between lockid and blockid.

Besides, the function inside indeed uses the block number for
comparision. And it's really misleading for new beginners ,emmmm, like me. 

:)

Thanks,
Larry





>>> Changwei Ge <ge.changwei@h3c.com> 2018-3-1 ?? 8:37 >>>
Hi Larry,

On 2018/2/28 18:18, Larry Chen wrote:
> The function ocfs2_double_lock tries to lock the inode with lower
> blockid first, not lockid.

As ocfs2's lock name includes block number, so I think the comment you want to 
rework is all right.
So nack.

Thanks,
Changwei

> 
> Signed-off-by: Larry Chen <lchen@suse.com>
> ---
>   fs/ocfs2/namei.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
> index c801eddc4bf3..30d454de35a8 100644
> --- a/fs/ocfs2/namei.c
> +++ b/fs/ocfs2/namei.c
> @@ -1133,7 +1133,7 @@ static int ocfs2_double_lock(struct ocfs2_super *osb,
>       if (*bh2)
>           *bh2 = NULL;
>   
> -    /* we always want to lock the one with the lower lockid first.
> +    /* we always want to lock the one with the lower blockid first.
>        * and if they are nested, we lock ancestor first */
>       if (oi1->ip_blkno != oi2->ip_blkno) {
>           inode1_is_ancestor = ocfs2_check_if_ancestor(osb, oi2->ip_blkno,
> 




-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20180228/db74a027/attachment.html 
