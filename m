From: Mark Fasheh <mfasheh@suse.com>
Date: Tue, 14 Dec 2010 09:44:50 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: lock the page in
	__ocfs2_page_mkwrite() -v2
In-Reply-To: <201011181554.oAIFs5a5031128@rcsinet15.oracle.com>
References: <201011181554.oAIFs5a5031128@rcsinet15.oracle.com>
Message-ID: <20101214174450.GB9240@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Wengang,

On Thu, Nov 18, 2010 at 11:52:14PM +0800, Wengang Wang wrote:
> Lock the page in __ocfs2_page_mkwrite(). Or we may get -EINVAL error
> from ocfs2_grab_pages_for_write() if the page(page cache) gets truncated
> while someone is flushing the pagecache. In the original code, we are
> checking mapping earlier in __ocfs2_page_mkwrite() but we don't lock it.
> so the mapping can change during flushing pagecache.

Thanks for doing this work. Review is below.


> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
> index f1e962c..6b7e1f2 100644
> --- a/fs/ocfs2/aops.c
> +++ b/fs/ocfs2/aops.c
> @@ -1130,14 +1130,18 @@ static int ocfs2_grab_pages_for_write(struct address_space *mapping,
>  
>  		if (index == target_index && mmap_page) {
>  			/*
> -			 * ocfs2_pagemkwrite() is a little different
> +			 * ocfs2_page_mkwrite() is a little different
>  			 * and wants us to directly use the page
>  			 * passed in.
> +			 * So far, only __ocfs2_page_mkwrite() passes in a
> +			 * non-NULL page. And we locked the page there, so we
> +			 * just assert the page is locked. If another path will
> +			 * be passing in a non-NULL page in future, the locking
> +			 * should be well considered.
>  			 */
> -			lock_page(mmap_page);
> +			BUG_ON(!PageLocked(mmap_page));
>  
>  			if (mmap_page->mapping != mapping) {
> -				unlock_page(mmap_page);
>  				/*
>  				 * Sanity check - the locking in
>  				 * ocfs2_pagemkwrite() should ensure
> diff --git a/fs/ocfs2/mmap.c b/fs/ocfs2/mmap.c
> index 7e32db9..bb29335 100644
> --- a/fs/ocfs2/mmap.c
> +++ b/fs/ocfs2/mmap.c
> @@ -79,9 +79,10 @@ static int __ocfs2_page_mkwrite(struct file *file, struct buffer_head *di_bh,
>  	 * from do_generic_file_read.
>  	 */
>  	last_index = (size - 1) >> PAGE_CACHE_SHIFT;
> +	lock_page(page);

This breaks the page lock ordering in ocfs2_grab_pages_for_write() -- note
that the call to find_or_create_page() in that function returns pages in a
locked state. So roughly, we want to be taking them in index order.
	--Mark

--
Mark Fasheh
