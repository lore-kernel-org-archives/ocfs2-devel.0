From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 20 Aug 2009 18:04:43 -0700
Subject: [Ocfs2-devel] [PATCH 19/41] ocfs2: Integrate CoW in file write.
In-Reply-To: <1250576382-27080-19-git-send-email-tao.ma@oracle.com>
References: <4A8A47DF.8020707@oracle.com>
	<1250576382-27080-19-git-send-email-tao.ma@oracle.com>
Message-ID: <20090821010443.GF10558@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Aug 18, 2009 at 02:19:20PM +0800, Tao Ma wrote:
> @@ -1674,6 +1692,7 @@ int ocfs2_write_begin_nolock(struct address_space *mapping,
>  	struct ocfs2_alloc_context *meta_ac = NULL;
>  	handle_t *handle;
>  	struct ocfs2_extent_tree et;
> +	unsigned int refcounted_cpos, cow_len;
>  
>  	ret = ocfs2_alloc_write_ctxt(&wc, osb, pos, len, di_bh);
>  	if (ret) {
> @@ -1701,12 +1720,36 @@ int ocfs2_write_begin_nolock(struct address_space *mapping,
>  	}
>  
>  	ret = ocfs2_populate_write_desc(inode, wc, &clusters_to_alloc,
> -					&extents_to_split);
> -	if (ret) {
> +					&extents_to_split, &refcounted_cpos);
> +	if (ret && ret != -ETXTBSY) {
>  		mlog_errno(ret);
>  		goto out;
>  	}
>  
> +	if (ret == -ETXTBSY) {
> +		BUG_ON(refcounted_cpos == UINT_MAX);
> +		cow_len = wc->w_clen - (refcounted_cpos - wc->w_cpos);
> +
> +		ret = ocfs2_refcount_cow(inode, di_bh,
> +					 refcounted_cpos, cow_len);
> +		if (ret) {
> +			mlog_errno(ret);
> +			goto out;
> +		}
> +
> +		/* reinitialize write_desc and populate it again. */
> +		ocfs2_clear_write_desc(wc);
> +		ret = ocfs2_populate_write_desc(inode, wc, &clusters_to_alloc,
> +						&extents_to_split,
> +						&refcounted_cpos);
> +		if (ret) {
> +			mlog_errno(ret);
> +			goto out;
> +		}
> +
> +		BUG_ON(refcounted_cpos != UINT_MAX);
> +	}

	First see my comment on the ocfs2_refcount_cal_clusters() and a
possible short CoW.
	Basically, ocfs2_refcount_cow() can do a short CoW in two
situations.  First, the one I described about
ocfs2_refcount_cal_clusters().  The second is if the write wants to
cover three extents, the middle of which is not refcounted:

  |--refcounted--|--not refcounted--]--refcounted--|

ocfs2_refcount_cal_cow_clusters() will be called on the first extent.
It will set up *cow_len to cover that first extent, but then it will hit
the second extent and break out.  ocfs2_refcount_cow() will then replace
the first extent.  We end up with:

  |--not refcounted--|--not refcounted--]--refcounted--|


	Now we call to ocfs2_prepare_write_desc() again.  It will see
the first and second extents as not refcounted, but then it will hit
the third extent and return -ETXTBSY.  refcounted_cpos will be set to
the third extent.  Then in ocfs2_write_begin_nolock(), we'll hit:

		BUG_ON(refcounted_cpos != UINT_MAX);

Am I missing something?

Joel

-- 

"Where are my angels?
 Where's my golden one?
 And where is my hope
 Now that my heroes are gone?"

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
