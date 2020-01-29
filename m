From: Dave Chinner <david@fromorbit.com>
Date: Wed, 29 Jan 2020 11:24:56 +1100
Subject: [Ocfs2-devel] [PATCH 04/12] mm: Add readahead address space
	operation
In-Reply-To: <20200125013553.24899-5-willy@infradead.org>
References: <20200125013553.24899-1-willy@infradead.org>
	<20200125013553.24899-5-willy@infradead.org>
Message-ID: <20200129002456.GH18610@dread.disaster.area>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org, cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com

On Fri, Jan 24, 2020 at 05:35:45PM -0800, Matthew Wilcox wrote:
> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> 
> This replaces ->readpages with a saner interface:
>  - Return the number of pages not read instead of an ignored error code.
>  - Pages are already in the page cache when ->readahead is called.
>  - Implementation looks up the pages in the page cache instead of
>    having them passed in a linked list.
....
> diff --git a/mm/readahead.c b/mm/readahead.c
> index 5a6676640f20..6d65dae6dad0 100644
> --- a/mm/readahead.c
> +++ b/mm/readahead.c
> @@ -121,7 +121,18 @@ static void read_pages(struct address_space *mapping, struct file *filp,
>  
>  	blk_start_plug(&plug);
>  
> -	if (mapping->a_ops->readpages) {
> +	if (mapping->a_ops->readahead) {
> +		unsigned left = mapping->a_ops->readahead(filp, mapping,
> +				start, nr_pages);
> +
> +		while (left) {
> +			struct page *page = readahead_page(mapping,
> +					start + nr_pages - left - 1);

Off by one? start = 2, nr_pages = 2, left = 1, this looks up the
page at index 2, which is the one we issued IO on, not the one we
"left behind" which is at index 3.

Cheers,

Dave.
-- 
Dave Chinner
david at fromorbit.com
