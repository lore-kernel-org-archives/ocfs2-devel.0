From: Joel Becker <Joel.Becker@oracle.com>
Date: Sun, 10 Oct 2010 03:59:49 -0700
Subject: [Ocfs2-devel] [PATCH 2/2] Ocfs2: Handle O_DIRECT writes with
 coherency option.
In-Reply-To: <1286623602-7559-2-git-send-email-tristan.ye@oracle.com>
References: <1286623602-7559-1-git-send-email-tristan.ye@oracle.com>
	<1286623602-7559-2-git-send-email-tristan.ye@oracle.com>
Message-ID: <20101010105948.GT13876@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Sat, Oct 09, 2010 at 07:26:42PM +0800, Tristan Ye wrote:
> -	/* concurrent O_DIRECT writes are allowed */
> -	rw_level = !direct_io;
> +	/* 
> +	 * concurrent O_DIRECT writes are allowed with
> +	 * mount_option "coherency=buffered".
> +	 */
> +	if (direct_io) {
> +		rw_level = !(osb->s_mount_opt & OCFS2_MOUNT_COHERENCY_BUFFERED);
> +	} else
> +		rw_level = !direct_io;
> +

	I think I'd like:

	if (direct_io && (osb->s_mount_opt & OCFS2_MOUNT_COHERENCY_BUFFERED))
		rw_level = 0;
	else
		rw_level = 1;

It actually matches your comment much better.  But since we're going to
be using it again later, perhaps you should set 'int full_coherency =
(osb->s_mount_opt & OCFS2_MOUNT_COHERENCY_BUFFERED)' up at the top of
the function and then do:

	rw_level = (!direct_io || full_coherency)

>  	ret = ocfs2_rw_lock(inode, rw_level);
>  	if (ret < 0) {
>  		mlog_errno(ret);
>  		goto out_sems;
>  	}
>  
> +	/*
> +	 * O_DIRECT writes with "coherency=full" need to take EX cluster
> +	 * inode_lock to guarantee coherency.
> +	 */
> +	if ((direct_io) &&
> +	    !(osb->s_mount_opt & OCFS2_MOUNT_COHERENCY_BUFFERED)) {

	Then this check can be:

	if (direct_io && full_coherency) {
		/*
		 * We need to take and drop the inode lock to force
		 * other nodes to drop their caches.  Buffered I/O
		 * already does this in write_begin().
		 */

> +		ret = ocfs2_inode_lock(inode, NULL, 1);
> +		if (ret < 0) {
> +			mlog_errno(ret);
> +			goto out_sems;
> +		}
> +		
> +		/*
> +		 * Safe to drop the inode_lock immediately since we're just
> +		 * telling other nodes to flush their cache.
> +		 */

	And you don't need this comment.

> +		ocfs2_inode_unlock(inode, 1);
> +	}

-- 

"The lawgiver, of all beings, most owes the law allegiance.  He of all
 men should behave as though the law compelled him.  But it is the
 universal weakness of mankind that what we are given to administer we
 presently imagine we own."
        - H.G. Wells

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
