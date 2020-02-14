From: Matthew Wilcox <willy@infradead.org>
Date: Thu, 13 Feb 2020 20:21:37 -0800
Subject: [Ocfs2-devel] [PATCH v5 01/13] mm: Fix the return type of
 __do_page_cache_readahead
In-Reply-To: <e0f459af-bb5d-58b9-78be-5adf687477c0@nvidia.com>
References: <20200211010348.6872-1-willy@infradead.org>
	<20200211010348.6872-2-willy@infradead.org>
	<e0f459af-bb5d-58b9-78be-5adf687477c0@nvidia.com>
Message-ID: <20200214042137.GX7778@bombadil.infradead.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Feb 13, 2020 at 07:19:53PM -0800, John Hubbard wrote:
> On 2/10/20 5:03 PM, Matthew Wilcox wrote:
> > @@ -161,7 +161,7 @@ unsigned int __do_page_cache_readahead(struct address_space *mapping,
> >  	unsigned long end_index;	/* The last page we want to read */
> >  	LIST_HEAD(page_pool);
> >  	int page_idx;
> 
> 
> What about page_idx, too? It should also have the same data type as nr_pages, as long as
> we're trying to be consistent on this point.
> 
> Just want to ensure we're ready to handle those 2^33+ page readaheads... :)

Nah, this is just a type used internally to the function.  Getting the
API right for the callers is the important part.
