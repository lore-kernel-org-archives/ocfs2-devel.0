From: Eric Biggers <ebiggers@kernel.org>
Date: Tue, 18 Feb 2020 19:29:34 -0800
Subject: [Ocfs2-devel] [PATCH v6 14/19] ext4: Convert from readpages to
	readahead
In-Reply-To: <20200217184613.19668-25-willy@infradead.org>
References: <20200217184613.19668-1-willy@infradead.org>
	<20200217184613.19668-25-willy@infradead.org>
Message-ID: <20200219032934.GC1075@sol.localdomain>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, linux-mm@kvack.org, ocfs2-devel@oss.oracle.com, linux-ext4@vger.kernel.org, linux-erofs@lists.ozlabs.org, linux-btrfs@vger.kernel.org

On Mon, Feb 17, 2020 at 10:46:05AM -0800, Matthew Wilcox wrote:
> diff --git a/fs/ext4/readpage.c b/fs/ext4/readpage.c
> index c1769afbf799..e14841ade612 100644
> --- a/fs/ext4/readpage.c
> +++ b/fs/ext4/readpage.c
> @@ -7,8 +7,8 @@
>   *
>   * This was originally taken from fs/mpage.c
>   *
> - * The intent is the ext4_mpage_readpages() function here is intended
> - * to replace mpage_readpages() in the general case, not just for
> + * The ext4_mpage_readahead() function here is intended to
> + * replace mpage_readahead() in the general case, not just for
>   * encrypted files.  It has some limitations (see below), where it
>   * will fall back to read_block_full_page(), but these limitations
>   * should only be hit when page_size != block_size.
> @@ -222,8 +222,7 @@ static inline loff_t ext4_readpage_limit(struct inode *inode)
>  }

This says ext4_mpage_readahead(), but it's actually still called
ext4_mpage_readpages().

- Eric
