From: Matthew Wilcox <willy@infradead.org>
Date: Fri, 14 Feb 2020 11:50:46 -0800
Subject: [Ocfs2-devel] [PATCH v5 01/13] mm: Fix the return type of
 __do_page_cache_readahead
In-Reply-To: <20200211010348.6872-2-willy@infradead.org>
References: <20200211010348.6872-1-willy@infradead.org>
	<20200211010348.6872-2-willy@infradead.org>
Message-ID: <20200214195046.GC7778@bombadil.infradead.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Feb 10, 2020 at 05:03:36PM -0800, Matthew Wilcox wrote:
> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> 
> ra_submit() which is a wrapper around __do_page_cache_readahead() already
> returns an unsigned long, and the 'nr_to_read' parameter is an unsigned
> long, so fix __do_page_cache_readahead() to return an unsigned long,
> even though I'm pretty sure we're not going to readahead more than 2^32
> pages ever.

I was going through this and realised it's completely pointless -- the
returned value from ra_submit() and __do_page_cache_readahead() is
eventually ignored through all paths.  So I'm replacing this patch with
one that makes everything return void.
