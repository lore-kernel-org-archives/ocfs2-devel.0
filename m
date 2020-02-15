From: Matthew Wilcox <willy@infradead.org>
Date: Fri, 14 Feb 2020 17:15:52 -0800
Subject: [Ocfs2-devel] [PATCH v5 03/13] mm: Put readahead pages in cache
	earlier
In-Reply-To: <b0cdd7b4-e103-a884-d8f7-2378905f7b3b@nvidia.com>
References: <20200211010348.6872-1-willy@infradead.org>
	<20200211010348.6872-4-willy@infradead.org>
	<b0cdd7b4-e103-a884-d8f7-2378905f7b3b@nvidia.com>
Message-ID: <20200215011552.GE7778@bombadil.infradead.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Feb 13, 2020 at 07:36:38PM -0800, John Hubbard wrote:
> I see two distinct things happening in this patch, and I think they want to each be
> in their own patch:
> 
> 1) A significant refactoring of the page loop, and
> 
> 2) Changing the place where the page is added to the page cache. (Only this one is 
>    mentioned in the commit description.)
> 
> We'll be more likely to spot any errors if these are teased apart.

Thanks.  I ended up splitting this patch into three, each hopefully
easier to understand.
