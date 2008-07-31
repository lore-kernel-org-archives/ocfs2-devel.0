From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 31 Jul 2008 14:11:32 -0700
Subject: [Ocfs2-devel] [PATCH 2/3] ocfs2: throttle back local alloc	when
	low on disk space
In-Reply-To: <1217536922-28328-3-git-send-email-mfasheh@suse.com>
References: <1217536922-28328-1-git-send-email-mfasheh@suse.com>
	<1217536922-28328-3-git-send-email-mfasheh@suse.com>
Message-ID: <20080731211132.GD14766@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Jul 31, 2008 at 01:42:01PM -0700, Mark Fasheh wrote:
> @@ -476,16 +515,18 @@ int ocfs2_reserve_local_alloc_bits(struct ocfs2_super *osb,
>  
>  	mutex_lock(&local_alloc_inode->i_mutex);
>  
> -	if (osb->local_alloc_state != OCFS2_LA_ENABLED) {
> -		status = -ENOSPC;
> -		goto bail;
> -	}
> -
> -	if (bits_wanted > osb->local_alloc_bits) {
> -		mlog(0, "Asking for more than my max window size!\n");
> +	/*
> +	 * We must double check state and allocator bits because
> +	 * another process may have changed them while holding i_mutex.
> +	 */
> +	spin_lock(&osb->osb_lock);
> +	if (!ocfs2_la_state_enabled(osb) ||
> +	    (bits_wanted > osb->local_alloc_bits)) {
> +		spin_unlock(&osb->osb_lock);
>  		status = -ENOSPC;
>  		goto bail;
>  	}
> +	spin_unlock(&osb->osb_lock);
>  
>  	alloc = (struct ocfs2_dinode *) osb->local_alloc_bh->b_data;
>  
> @@ -513,6 +554,21 @@ int ocfs2_reserve_local_alloc_bits(struct ocfs2_super *osb,
>  				mlog_errno(status);
>  			goto bail;
>  		}
> +
> +		/*
> +		 * Under certain conditions, the window slide code
> +		 * might have reduced the number of bits available or
> +		 * disabled the the local alloc entirely. Re-check
> +		 * here and return -ENOSPC if necessary.
> +		 */
> +		status = -ENOSPC;
> +		if (!ocfs2_la_state_enabled(osb))
> +			goto bail;
> +

	Up above you take osb_lock, here you don't.  Now, if I read your
later comment correctly, you don't need osb_lock in either place,
because the read is safe under the mutex.

Joel

-- 

"Get right to the heart of matters.
 It's the heart that matters more."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
