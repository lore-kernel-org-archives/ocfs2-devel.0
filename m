From: Changwei Ge <ge.changwei@h3c.com>
Date: Tue, 21 Nov 2017 00:58:00 +0000
Subject: [Ocfs2-devel] [PATCH] Bug#841144: kernel BUG at
 /build/linux-Wgpe2M/linux-4.8.11/fs/ocfs2/alloc.c:1514!
References: <1511204090.3644.6.camel@nixnuts.net>
Message-ID: <63ADC13FD55D6546B7DECE290D39E373CED7CB51@H3CMLB14-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi John,
It's better to paste your patch directly into message body. It's easy 
for reviewing.

So I copied your patch below:

> The dw_zero_count tracking was assuming that w_unwritten_list would
> always contain one element. The actual count is now tracked whenever
> the list is extended.
> ---
>  fs/ocfs2/aops.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
> index 88a31e9340a0..eb0a81368dbb 100644
> --- a/fs/ocfs2/aops.c
> +++ b/fs/ocfs2/aops.c
> @@ -784,6 +784,8 @@ struct ocfs2_write_ctxt {
>  	struct ocfs2_cached_dealloc_ctxt w_dealloc;
>  
>  	struct list_head		w_unwritten_list;
> +
> +	unsigned int			w_unwritten_count;
>  };
>  
>  void ocfs2_unlock_and_free_pages(struct page **pages, int num_pages)
> @@ -873,6 +875,7 @@ static int ocfs2_alloc_write_ctxt(struct ocfs2_write_ctxt **wcp,
>  
>  	ocfs2_init_dealloc_ctxt(&wc->w_dealloc);
>  	INIT_LIST_HEAD(&wc->w_unwritten_list);
> +	wc->w_unwritten_count = 0;

I think you don't have to evaluate ::w_unwritten_count to zero since 
kzalloc already did that.

>  
>  	*wcp = wc;
>  
> @@ -1373,6 +1376,7 @@ static int ocfs2_unwritten_check(struct inode *inode,
>  	desc->c_clear_unwritten = 0;
>  	list_add_tail(&new->ue_ip_node, &oi->ip_unwritten_list);
>  	list_add_tail(&new->ue_node, &wc->w_unwritten_list);
> +	wc->w_unwritten_count++;

You increase ::w_unwritten_coun once a new _ue_ is attached to 
::w_unwritten_list. So if no _ue_ ever is attached, ::w_unwritten_list 
is still empty. I think your change has the same effect with origin.

Moreover I don't see the relation between the reported crash issue and 
your patch change. Can you elaborate further?

Thanks,
Changwei

>  	new = NULL;
>  unlock:
>  	spin_unlock(&oi->ip_lock);
> @@ -2246,7 +2250,7 @@ static int ocfs2_dio_get_block(struct inode *inode, sector_t iblock,
>  		ue->ue_phys = desc->c_phys;
>  
>  		list_splice_tail_init(&wc->w_unwritten_list, &dwc->dw_zero_list);
> -		dwc->dw_zero_count++;
> +		dwc->dw_zero_count += wc->w_unwritten_count;
>  	}
>  
>  	ret = ocfs2_write_end_nolock(inode->i_mapping, pos, len, len, wc);
> -- 
> 2.11.0



On 2017/11/21 2:56, John Lightsey wrote:
> In January Ben Hutchings reported Debian bug 841144 to the ocfs2-devel
> list:
> 
> https://oss.oracle.com/pipermail/ocfs2-devel/2017-January/012701.html
> 
> cPanel encountered this bug after upgrading our cluster to the 4.9
> Debian stable kernel. In our environment, the bug would trigger every
> few hours.
> 
> The core problem seems to be that the size of dw_zero_list is not
> tracked correctly. This causes the ocfs2_lock_allocators() call in
> ocfs2_dio_end_io_write() to underestimate the number of extents needed.
> As a result, meta_ac is null when it's needed in ocfs2_grow_tree().
> 
> The attached patch is a forward-ported version of the fix we applied to
> Debian's 4.9 kernel to correct the issue.
> 
