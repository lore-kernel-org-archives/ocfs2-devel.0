From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Mon Mar  1 16:06:54 2004
Subject: [Ocfs2-devel] [PATCH]2.6 fixes in journal.c
In-Reply-To: <20040301165447.GA16000@penguin.co.intel.com>
References: <200402270216.i1R2GnW8007425@penguin.co.intel.com>
	<20040301165447.GA16000@penguin.co.intel.com>
Message-ID: <20040301220643.GT1421@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Mar 01, 2004 at 08:54:47AM -0800, Rusty Lynch wrote:
> Here is the same patch cut against the new svn tree.
> 
> 
> Index: src/journal.c
> ===================================================================
> --- src/journal.c	(revision 738)
> +++ src/journal.c	(working copy)
> @@ -656,7 +656,7 @@
>  		break;
>  
>  	case OCFS_JOURNAL_ACCESS_WRITE:
> -		status = journal_get_write_access(handle->k_handle, bh);
> +		status = journal_get_write_access(handle->k_handle, bh, NULL);
>  		break;
Can we put an #if LINUX_VERSION_CODE around that one please? Passing NULL in
2.6 for the credits argument is fine.

>  
>  	default:
> @@ -899,7 +899,7 @@
>  	OCFS_BH_PUT_DATA(bh);
>  	fe = NULL;
>  #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
> -	inode = ocfs_iget (sb, &args);
> +	inode = ocfs_iget (osb->sb, &args);
>  #else
>  	inode = ocfs_get_inode_from_offset(osb, args.offset, bh);
>  #endif
> @@ -935,9 +935,13 @@
>  
>  	LOG_TRACE_STR("Returned from journal_init_inode");
>  	LOG_TRACE_ARGS("k_journal->j_maxlen = %u\n", k_journal->j_maxlen);
> +#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
> +	k_journal->j_commit_interval = OCFS_DEFAULT_COMMIT_INTERVAL;
> +#else
>  	lock_journal(k_journal);
>  	k_journal->j_commit_interval = OCFS_DEFAULT_COMMIT_INTERVAL;
>  	unlock_journal(k_journal);
> +#endif
Ok, you can actually just remove that lock_journal/unlock_journal pair. At
that point in the JBD init cycle, we don't have to worry about protecting
that variable.

The rest of the patch looks good, so if you could just fix those two things,
I'll commit.
	--Mark

--
Mark Fasheh
Software Developer, Oracle Corp
mark.fasheh@oracle.com
