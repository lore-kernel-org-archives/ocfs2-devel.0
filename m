From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Mon, 15 Nov 2010 10:12:44 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: lock the page in
 __ocfs2_page_mkwrite()
In-Reply-To: <201011050455.oA52fktp020706@rcsinet15.oracle.com>
References: <201011050455.oA52fktp020706@rcsinet15.oracle.com>
Message-ID: <20101115021244.GA3369@laptop>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Any comments on this patch? --It's not DLM related.

regards,
wengang.
On 10-11-05 12:53, Wengang Wang wrote:
> Lock the page in __ocfs2_page_mkwrite(). Or we may get -EINVAL error
> from ocfs2_grab_pages_for_write() if the page(page cache) gets truncated.
> 
> regards,
> wengang.
> 
> Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
> ---
>  fs/ocfs2/aops.c |    9 +++++++--
>  fs/ocfs2/mmap.c |   10 +++++++---
>  2 files changed, 14 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
> index f1e962c..ade2f48 100644
> --- a/fs/ocfs2/aops.c
> +++ b/fs/ocfs2/aops.c
> @@ -1097,6 +1097,7 @@ static int ocfs2_grab_pages_for_write(struct address_space *mapping,
>  	unsigned long start, target_index, end_index, index;
>  	struct inode *inode = mapping->host;
>  	loff_t last_byte;
> +	int lockpg= !PageLocked(mmap_page);
>  
>  	target_index = user_pos >> PAGE_CACHE_SHIFT;
>  
> @@ -1133,11 +1134,15 @@ static int ocfs2_grab_pages_for_write(struct address_space *mapping,
>  			 * ocfs2_pagemkwrite() is a little different
>  			 * and wants us to directly use the page
>  			 * passed in.
> +			 * in ocfs2_page_mkwirte() path, the page is already
> +			 * locked, don't lock it again.
>  			 */
> -			lock_page(mmap_page);
> +			if (lockpg)
> +				lock_page(mmap_page);
>  
>  			if (mmap_page->mapping != mapping) {
> -				unlock_page(mmap_page);
> +				if (lockpg)
> +					unlock_page(mmap_page);
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
>  	if (unlikely(!size || page->index > last_index)) {
>  		ret = -EINVAL;
> -		goto out;
> +		goto out_unlock;
>  	}
>  
>  	/*
> @@ -96,7 +97,7 @@ static int __ocfs2_page_mkwrite(struct file *file, struct buffer_head *di_bh,
>  		 * So return 0 here and let VFS retry.
>  		 */
>  		ret = 0;
> -		goto out;
> +		goto out_unlock;
>  	}
>  
>  	/*
> @@ -117,7 +118,7 @@ static int __ocfs2_page_mkwrite(struct file *file, struct buffer_head *di_bh,
>  	if (ret) {
>  		if (ret != -ENOSPC)
>  			mlog_errno(ret);
> -		goto out;
> +		goto out_unlock;
>  	}
>  
>  	ret = ocfs2_write_end_nolock(mapping, pos, len, len, locked_page,
> @@ -128,6 +129,9 @@ static int __ocfs2_page_mkwrite(struct file *file, struct buffer_head *di_bh,
>  	}
>  	BUG_ON(ret != len);
>  	ret = 0;
> +	goto out;
> +out_unlock:
> +	unlock_page(page);
>  out:
>  	return ret;
>  }
> -- 
> 1.7.2.3
> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
