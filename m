From: Eric Biggers <ebiggers@kernel.org>
Date: Fri, 20 Mar 2020 11:51:34 -0700
Subject: [Ocfs2-devel] [PATCH v9 22/25] f2fs: Convert from readpages to
	readahead
In-Reply-To: <20200320142231.2402-23-willy@infradead.org>
References: <20200320142231.2402-1-willy@infradead.org>
	<20200320142231.2402-23-willy@infradead.org>
Message-ID: <20200320185134.GI851@sol.localdomain>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Mar 20, 2020 at 07:22:28AM -0700, Matthew Wilcox wrote:
> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> 
> Use the new readahead operation in f2fs
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Reviewed-by: William Kucharski <william.kucharski@oracle.com>
> ---
>  fs/f2fs/data.c              | 47 +++++++++++++++----------------------
>  include/trace/events/f2fs.h |  6 ++---
>  2 files changed, 22 insertions(+), 31 deletions(-)
> 

Reviewed-by: Eric Biggers <ebiggers@google.com>

> @@ -2210,7 +2204,7 @@ static int f2fs_mpage_readpages(struct address_space *mapping,
>  				ret = f2fs_read_multi_pages(&cc, &bio,
>  							max_nr_pages,
>  							&last_block_in_bio,
> -							is_readahead);
> +							rac);

IMO it would be clearer to write 'rac != NULL' here (and below) since the
argument is actually a bool, but this works too.

- Eric
