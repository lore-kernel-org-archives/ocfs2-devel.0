From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 29 Jun 2010 16:23:42 -0700
Subject: [Ocfs2-devel] [PATCH 3/4] ocfs2: Add readhead during CoW.
In-Reply-To: <1277800541-6844-3-git-send-email-tao.ma@oracle.com>
References: <4C29AE6C.1050205@oracle.com>
	<1277800541-6844-3-git-send-email-tao.ma@oracle.com>
Message-ID: <20100629232342.GI4150@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Jun 29, 2010 at 04:35:40PM +0800, Tao Ma wrote:
> @@ -2953,6 +2957,14 @@ static int ocfs2_duplicate_clusters_by_page(handle_t *handle,
>  		if (PAGE_CACHE_SIZE <= OCFS2_SB(sb)->s_clustersize)
>  			BUG_ON(PageDirty(page));
>  
> +		if (PageReadahead(page) && context->file) {
> +			page_cache_async_readahead(mapping,
> +						   &context->file->f_ra,
> +						   context->file,
> +						   page, page_index,
> +						   readahead_pages);
> +		}

	This is merely re-sending the same pages that were already sent,
right?  In the previous patch, you asked the readahead code to try all
pages in the hunk.  Now you've discovered a page that isn't yet up to
date, and you send it (and the 1M next to it) back to readahead.
	This is, I assume, because the readahead code doesn't actually
read your entire request from page_cache_sync_readahead().  It just
reads some, and this is you hinting that you need the next bit.  Am I
right?

Joel

-- 

Life's Little Instruction Book #464

	"Don't miss the magic of the moment by focusing on what's
	 to come."

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
