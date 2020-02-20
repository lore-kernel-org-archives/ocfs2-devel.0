From: Zi Yan <ziy@nvidia.com>
Date: Thu, 20 Feb 2020 09:36:19 -0500
Subject: [Ocfs2-devel] [PATCH v7 04/24] mm: Move readahead nr_pages
 check into read_pages
In-Reply-To: <20200219210103.32400-5-willy@infradead.org>
References: <20200219210103.32400-1-willy@infradead.org>
	<20200219210103.32400-5-willy@infradead.org>
Message-ID: <DD2E8059-DA56-468F-9185-6C0082266067@nvidia.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com, linux-xfs@vger.kernel.org

On 19 Feb 2020, at 16:00, Matthew Wilcox wrote:

> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
>
> Simplify the callers by moving the check for nr_pages and the BUG_ON
> into read_pages().
>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  mm/readahead.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
>
> diff --git a/mm/readahead.c b/mm/readahead.c
> index 61b15b6b9e72..9fcd4e32b62d 100644
> --- a/mm/readahead.c
> +++ b/mm/readahead.c
> @@ -119,6 +119,9 @@ static void read_pages(struct address_space *mapping, struct file *filp,
>  	struct blk_plug plug;
>  	unsigned page_idx;
>
> +	if (!nr_pages)
> +		return;
> +
>  	blk_start_plug(&plug);
>
>  	if (mapping->a_ops->readpages) {
> @@ -138,6 +141,8 @@ static void read_pages(struct address_space *mapping, struct file *filp,
>
>  out:
>  	blk_finish_plug(&plug);
> +
> +	BUG_ON(!list_empty(pages));
>  }
>
>  /*
> @@ -180,8 +185,7 @@ void __do_page_cache_readahead(struct address_space *mapping,
>  			 * contiguous pages before continuing with the next
>  			 * batch.
>  			 */
> -			if (nr_pages)
> -				read_pages(mapping, filp, &page_pool, nr_pages,
> +			read_pages(mapping, filp, &page_pool, nr_pages,
>  						gfp_mask);
>  			nr_pages = 0;
>  			continue;
> @@ -202,9 +206,7 @@ void __do_page_cache_readahead(struct address_space *mapping,
>  	 * uptodate then the caller will launch readpage again, and
>  	 * will then handle the error.
>  	 */
> -	if (nr_pages)
> -		read_pages(mapping, filp, &page_pool, nr_pages, gfp_mask);
> -	BUG_ON(!list_empty(&page_pool));
> +	read_pages(mapping, filp, &page_pool, nr_pages, gfp_mask);
>  }
>
>  /*
> -- 
> 2.25.0

Looks good to me. Thanks.

Reviewed-by: Zi Yan <ziy@nvidia.com>


--
Best Regards,
Yan Zi
-------------- next part --------------
A non-text attachment was scrubbed...
Name: signature.asc
Type: application/pgp-signature
Size: 854 bytes
Desc: OpenPGP digital signature
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20200220/419c5d42/attachment-0001.bin 
