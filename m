From: Christoph Hellwig <hch@infradead.org>
Date: Wed, 12 Feb 2020 10:13:30 -0800
Subject: [Ocfs2-devel] [PATCH v5 02/13] mm: Ignore return value of
	->readpages
In-Reply-To: <20200211010348.6872-3-willy@infradead.org>
References: <20200211010348.6872-1-willy@infradead.org>
	<20200211010348.6872-3-willy@infradead.org>
Message-ID: <20200212181330.GB9756@infradead.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Feb 10, 2020 at 05:03:37PM -0800, Matthew Wilcox wrote:
> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> 
> We used to assign the return value to a variable, which we then ignored.
> Remove the pretence of caring.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
