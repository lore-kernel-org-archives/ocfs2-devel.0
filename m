From: Eric Biggers <ebiggers@kernel.org>
Date: Tue, 18 Feb 2020 19:10:44 -0800
Subject: [Ocfs2-devel] [PATCH v6 08/19] mm: Add readahead address space
	operation
In-Reply-To: <20200217184613.19668-14-willy@infradead.org>
References: <20200217184613.19668-1-willy@infradead.org>
	<20200217184613.19668-14-willy@infradead.org>
Message-ID: <20200219031044.GA1075@sol.localdomain>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, linux-mm@kvack.org, ocfs2-devel@oss.oracle.com, linux-ext4@vger.kernel.org, linux-erofs@lists.ozlabs.org, linux-btrfs@vger.kernel.org

On Mon, Feb 17, 2020 at 10:45:54AM -0800, Matthew Wilcox wrote:
> diff --git a/Documentation/filesystems/vfs.rst b/Documentation/filesystems/vfs.rst
> index 7d4d09dd5e6d..81ab30fbe45c 100644
> --- a/Documentation/filesystems/vfs.rst
> +++ b/Documentation/filesystems/vfs.rst
> @@ -706,6 +706,7 @@ cache in your filesystem.  The following members are defined:
>  		int (*readpage)(struct file *, struct page *);
>  		int (*writepages)(struct address_space *, struct writeback_control *);
>  		int (*set_page_dirty)(struct page *page);
> +		void (*readahead)(struct readahead_control *);
>  		int (*readpages)(struct file *filp, struct address_space *mapping,
>  				 struct list_head *pages, unsigned nr_pages);
>  		int (*write_begin)(struct file *, struct address_space *mapping,
> @@ -781,12 +782,24 @@ cache in your filesystem.  The following members are defined:
>  	If defined, it should set the PageDirty flag, and the
>  	PAGECACHE_TAG_DIRTY tag in the radix tree.
>  
> +``readahead``
> +	Called by the VM to read pages associated with the address_space
> +	object.  The pages are consecutive in the page cache and are
> +	locked.  The implementation should decrement the page refcount
> +	after starting I/O on each page.  Usually the page will be
> +	unlocked by the I/O completion handler.  If the function does
> +	not attempt I/O on some pages, the caller will decrement the page
> +	refcount and unlock the pages for you.	Set PageUptodate if the
> +	I/O completes successfully.  Setting PageError on any page will
> +	be ignored; simply unlock the page if an I/O error occurs.
> +

This is unclear about how "not attempting I/O" works and how that affects who is
responsible for putting and unlocking the pages.  How does the caller know which
pages were not attempted?  Can any arbitrary subset of pages be not attempted,
or just the last N pages?

In the code, the caller actually uses readahead_for_each() to iterate through
and put+unlock the pages.  That implies that ->readahead() must also use
readahead_for_each() as well, in order for the iterator to be advanced
correctly... Right?  And the ownership of each page is transferred to the callee
when the callee advances the iterator past that page.

I don't see how ext4_readahead() and f2fs_readahead() can work at all, given
that they don't advance the iterator.

- Eric
