From: Dave Chinner <david@fromorbit.com>
Date: Wed, 19 Feb 2020 14:40:48 +1100
Subject: [Ocfs2-devel] [PATCH v6 18/19] iomap: Convert from readpages to
	readahead
In-Reply-To: <20200217184613.19668-32-willy@infradead.org>
References: <20200217184613.19668-1-willy@infradead.org>
	<20200217184613.19668-32-willy@infradead.org>
Message-ID: <20200219034048.GF10776@dread.disaster.area>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com, linux-xfs@vger.kernel.org

On Mon, Feb 17, 2020 at 10:46:12AM -0800, Matthew Wilcox wrote:
> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> 
> Use the new readahead operation in iomap.  Convert XFS and ZoneFS to
> use it.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  fs/iomap/buffered-io.c | 91 +++++++++++++++---------------------------
>  fs/iomap/trace.h       |  2 +-
>  fs/xfs/xfs_aops.c      | 13 +++---
>  fs/zonefs/super.c      |  7 ++--
>  include/linux/iomap.h  |  3 +-
>  5 files changed, 42 insertions(+), 74 deletions(-)

All pretty straight forward...

> @@ -416,6 +384,7 @@ iomap_readpages_actor(struct inode *inode, loff_t pos, loff_t length,
>  			break;
>  		done += ret;
>  		if (offset_in_page(pos + done) == 0) {
> +			readahead_next(ctx->rac);
>  			if (!ctx->cur_page_in_bio)
>  				unlock_page(ctx->cur_page);
>  			put_page(ctx->cur_page);

Though now I look at the addition here, this might be better
restructured to mention how we handle partial page submission such as:

		done += ret;

		/*
		 * Keep working on a partially complete page, otherwise ready
		 * the ctx for the next page to be acted on.
		 */
		if (offset_in_page(pos + done))
			continue;

		if (!ctx->cur_page_in_bio)
			unlock_page(ctx->cur_page);
		put_page(ctx->cur_page);
		ctx->cur_page = NULL;
		readahead_next(ctx->rac);
	}

Cheers,

Dave.
-- 
Dave Chinner
david at fromorbit.com
