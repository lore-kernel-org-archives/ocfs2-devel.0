From: Christoph Hellwig <hch@infradead.org>
Date: Mon, 24 Feb 2020 13:53:24 -0800
Subject: [Ocfs2-devel] [Cluster-devel] [PATCH v7 12/24] mm: Add
 page_cache_readahead_unbounded
In-Reply-To: <20200219210103.32400-13-willy@infradead.org>
References: <20200219210103.32400-1-willy@infradead.org>
	<20200219210103.32400-13-willy@infradead.org>
Message-ID: <20200224215324.GA16051@infradead.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, linux-mm@kvack.org, ocfs2-devel@oss.oracle.com, linux-ext4@vger.kernel.org, linux-erofs@lists.ozlabs.org, linux-btrfs@vger.kernel.org

On Wed, Feb 19, 2020 at 01:00:51PM -0800, Matthew Wilcox wrote:
> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> 
> ext4 and f2fs have duplicated the guts of the readahead code so
> they can read past i_size.  Instead, separate out the guts of the
> readahead code so they can call it directly.

I don't like this, but then I like the horrible open coded versions
even less..  Can you add a do not use for new code comment to the
function as well?

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
