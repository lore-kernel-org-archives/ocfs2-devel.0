From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Mon Jun 21 19:48:12 2004
Subject: [Ocfs2-devel] [PATCH] fixup journal-related ifdef mess
In-Reply-To: <20040620144000.GB16073@lst.de>
References: <20040620144000.GB16073@lst.de>
Message-ID: <20040622004806.GF1771@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Thanks for all the patches so far.

(This patch has been committed, but before I could take a look at it)

What's wrong with how this was done before?

I agree with the goal of reducing code clutter, and making it easier to be
a  2.6 file system, so why can't we do ext3 style thin wrappers around those
functions (look at ext3_jbd.h to see what I'm going for) instead of doing
things like 

> +#define journal_start(journal, nblocks)      \
> +     ocfs_journal_start(journal, nblocks)
> +#define journal_stop(handle) \
> +     ocfs_journal_stop(handle)

which winds up defining a macro with the same name as a function (blech! ;)

Of course, ext3 had some other reasons for doing it that way too, but it
seemed to me to be a bit more obvious...

If there's some documented place where this clashes with the linux kernel
coding style, then I'll gladly defer, but otherwise I'm thinking it used to
be more clear (of course, I have an obvious bias :)
	--Mark

On Sun, Jun 20, 2004 at 04:40:00PM +0200, Christoph Hellwig wrote:
> always use the 2.6 variants and fix up for 2.4 under the hood
> 
> 
> Index: src/journal.c
> ===================================================================
> --- src/journal.c	(revision 1156)
> +++ src/journal.c	(working copy)
> @@ -105,9 +105,17 @@
>  
>  	return status;
>  }
> -#else
> -#define ocfs_journal_start	journal_start
> -#define ocfs_journal_stop	journal_stop
> +
> +#define journal_start(journal, nblocks)	\
> +	ocfs_journal_start(journal, nblocks)
> +#define journal_stop(handle) \
> +	ocfs_journal_stop(handle)
> +
> +/* these two gained another argument during 2.6 */
> +#define journal_get_write_access(handle, bh, credits) \
> +	journal_get_write_access(handle, bh)
> +#define journal_get_undo_access(handle, bh, credits) \
> +	journal_get_undo_access(handle, bh)
>  #endif
>  
>  
> @@ -165,7 +173,7 @@
>  	down_read(&osb->journal->trans_barrier);
>  
>  	/* actually start the transaction now */
> -	retval->k_handle = ocfs_journal_start(journal, max_buffs);
> +	retval->k_handle = journal_start(journal, max_buffs);
>  	if (IS_ERR(retval->k_handle)) {
>  		up_read(&osb->journal->trans_barrier);
>  
> @@ -411,7 +419,7 @@
>  
>  	/* actually stop the transaction. if we've set h_sync,
>  	 * it'll have been commited when we return */
> -	retval = ocfs_journal_stop(kern_handle);
> +	retval = journal_stop(kern_handle);
>  	if (retval < 0) {
>  		LOG_ERROR_STATUS(retval);
>  		LOG_ERROR_STR("Could not commit transaction");
> @@ -583,7 +591,7 @@
>  	/* want to force our handle to disk in abort case. */
>  	handle->k_handle->h_sync = 1;
>  
> -	retval = ocfs_journal_stop(handle->k_handle);
> +	retval = journal_stop(handle->k_handle);
>  	if (retval < 0) {
>  		LOG_ERROR_STR("Could not commit aborted transaction!");
>  		LOG_ERROR_STATUS(retval);
> @@ -705,19 +713,11 @@
>  	switch (type) {
>  	case OCFS_JOURNAL_ACCESS_CREATE:
>  	case OCFS_JOURNAL_ACCESS_WRITE:
> -#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
>  		status = journal_get_write_access(handle->k_handle, bh, NULL);
> -#else
> -		status = journal_get_write_access(handle->k_handle, bh);
> -#endif
>  		break;
>  
>  	case OCFS_JOURNAL_ACCESS_UNDO:
> -#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
>  		status = journal_get_undo_access(handle->k_handle, bh, NULL);
> -#else
> -		status = journal_get_undo_access(handle->k_handle, bh);
> -#endif
>  		break;
>  
>  	default:
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel@oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
--
Mark Fasheh
Software Developer, Oracle Corp
mark.fasheh@oracle.com
