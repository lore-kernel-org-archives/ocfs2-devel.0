From: Christoph Hellwig <hch@infradead.org>
Date: Tue, 24 Mar 2020 01:40:49 -0700
Subject: [Ocfs2-devel] [PATCH v10 12/25] mm: Move end_index check out of
	readahead loop
In-Reply-To: <20200323202259.13363-13-willy@infradead.org>
References: <20200323202259.13363-1-willy@infradead.org>
	<20200323202259.13363-13-willy@infradead.org>
Message-ID: <20200324084049.GB32036@infradead.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Mar 23, 2020 at 01:22:46PM -0700, Matthew Wilcox wrote:
> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> 
> By reducing nr_to_read, we can eliminate this check from inside the loop.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Reviewed-by: John Hubbard <jhubbard@nvidia.com>
> Reviewed-by: William Kucharski <william.kucharski@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
