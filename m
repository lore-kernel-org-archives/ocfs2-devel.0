From: Christoph Hellwig <hch@infradead.org>
Date: Wed, 12 Feb 2020 10:18:11 -0800
Subject: [Ocfs2-devel] [PATCH v5 04/13] mm: Add readahead address space
	operation
In-Reply-To: <20200211010348.6872-5-willy@infradead.org>
References: <20200211010348.6872-1-willy@infradead.org>
	<20200211010348.6872-5-willy@infradead.org>
Message-ID: <20200212181811.GC9756@infradead.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Feb 10, 2020 at 05:03:39PM -0800, Matthew Wilcox wrote:
> +struct readahead_control {
> +	struct file *file;
> +	struct address_space *mapping;
> +/* private: use the readahead_* accessors instead */
> +	pgoff_t start;
> +	unsigned int nr_pages;
> +	unsigned int batch_count;

We often use __ prefixes for the private fields to make that a little
more clear.
