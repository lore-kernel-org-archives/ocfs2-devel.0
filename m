From: Mark Fasheh <mfasheh@suse.com>
Date: Mon, 24 Jan 2011 15:18:35 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix ocfs2_page_mkwrite path
In-Reply-To: <201101131103.p0D7C5Cx002897@acsinet15.oracle.com>
References: <201101131103.p0D7C5Cx002897@acsinet15.oracle.com>
Message-ID: <20110124231835.GJ9240@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Wengang, thanks again for this patch. It looks pretty good, I had only
one comment which is below.

On Thu, Jan 13, 2011 at 07:01:36PM +0800, Wengang Wang wrote:

> @@ -1139,20 +1166,19 @@ static int ocfs2_grab_pages_for_write(struct address_space *mapping,
>  			 */
>  			lock_page(mmap_page);
>  
> +			/*
> +			 * pagecache gets truncated. Let VM retry it.
> +			 */
>  			if (mmap_page->mapping != mapping) {
> +				WARN_ON(mmap_page->mapping);
>  				unlock_page(mmap_page);
> -				/*
> -				 * Sanity check - the locking in
> -				 * ocfs2_pagemkwrite() should ensure
> -				 * that this code doesn't trigger.
> -				 */
> -				ret = -EINVAL;
> -				mlog_errno(ret);
> +				ret = 0;

We're returning zero here (success) when we haven't really met success. I
see that in the next hunk, you test for this particular condition by looking
at wc->w_target_page. There's no bug but this approach makes understanding
the return code of ocfs2_grab_pages_for_write() harder.

Instead, can you have ocfs2_grab_pages_for_write return a specific error
code here which then would get automatically triggered by the error handling
code in ocfs2_write_begin_nolock()?
	--Mark

>  				goto out;
>  			}
>  
>  			page_cache_get(mmap_page);
>  			wc->w_pages[i] = mmap_page;
> +			wc->w_target_locked = true;
>  		} else {
>  			wc->w_pages[i] = find_or_create_page(mapping, index,
>  							     GFP_NOFS);
> @@ -1167,6 +1193,8 @@ static int ocfs2_grab_pages_for_write(struct address_space *mapping,
>  			wc->w_target_page = wc->w_pages[i];
>  	}
>  out:
> +	if (ret)
> +		wc->w_target_locked = false;
>  	return ret;
>  }
>  
> @@ -1786,6 +1814,9 @@ int ocfs2_write_begin_nolock(struct file *filp,
>  		mlog_errno(ret);
>  		goto out_quota;
>  	}
> +	/* Did the pagecache lose the page?  Retry. */
> +	if (!wc->w_target_page)
> +		goto out_quota;
>  
>  	ret = ocfs2_write_cluster_by_desc(mapping, data_ac, meta_ac, wc, pos,
>  					  len);

--
Mark Fasheh
