From: John Hubbard <jhubbard@nvidia.com>
Date: Tue, 18 Feb 2020 13:33:19 -0800
Subject: [Ocfs2-devel] [PATCH v6 02/19] mm: Ignore return value of
	->readpages
In-Reply-To: <20200217184613.19668-3-willy@infradead.org>
References: <20200217184613.19668-1-willy@infradead.org>
	<20200217184613.19668-3-willy@infradead.org>
Message-ID: <ed5b3635-be1b-c290-0e19-b516e7af2aca@nvidia.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Matthew Wilcox <willy@infradead.org>, linux-fsdevel@vger.kernel.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>

On 2/17/20 10:45 AM, Matthew Wilcox wrote:
> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> 
> We used to assign the return value to a variable, which we then ignored.
> Remove the pretence of caring.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  mm/readahead.c | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)

Looks good,

    Reviewed-by: John Hubbard <jhubbard@nvidia.com>

thanks,
-- 
John Hubbard
NVIDIA

> 
> diff --git a/mm/readahead.c b/mm/readahead.c
> index 8ce46d69e6ae..12d13b7792da 100644
> --- a/mm/readahead.c
> +++ b/mm/readahead.c
> @@ -113,17 +113,16 @@ int read_cache_pages(struct address_space *mapping, struct list_head *pages,
>  
>  EXPORT_SYMBOL(read_cache_pages);
>  
> -static int read_pages(struct address_space *mapping, struct file *filp,
> +static void read_pages(struct address_space *mapping, struct file *filp,
>  		struct list_head *pages, unsigned int nr_pages, gfp_t gfp)
>  {
>  	struct blk_plug plug;
>  	unsigned page_idx;
> -	int ret;
>  
>  	blk_start_plug(&plug);
>  
>  	if (mapping->a_ops->readpages) {
> -		ret = mapping->a_ops->readpages(filp, mapping, pages, nr_pages);
> +		mapping->a_ops->readpages(filp, mapping, pages, nr_pages);
>  		/* Clean up the remaining pages */
>  		put_pages_list(pages);
>  		goto out;
> @@ -136,12 +135,9 @@ static int read_pages(struct address_space *mapping, struct file *filp,
>  			mapping->a_ops->readpage(filp, page);
>  		put_page(page);
>  	}
> -	ret = 0;
>  
>  out:
>  	blk_finish_plug(&plug);
> -
> -	return ret;
>  }
>  
>  /*
> 
