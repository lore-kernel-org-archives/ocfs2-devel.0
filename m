From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Mon Jul  5 12:58:15 2004
Subject: [Ocfs2-devel] [Patch] fix  for continuous receiving
	FLAG_VOTE_UPDATE_RETRY
In-Reply-To: <3ACA40606221794F80A5670F0AF15F8404CD968E@pdsmsx403>
References: <3ACA40606221794F80A5670F0AF15F8404CD968E@pdsmsx403>
Message-ID: <20040705175809.GB14805@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Jul 05, 2004 at 05:27:15PM +0800, Ling, Xiaofeng wrote:
> It seems the inode lock system map file is not released after acquired.That causes when another node want to acquire it,
> this node found it is already holded.
Ahh, good catch! I saw that bug but hadn't had a chance to track it down.
It also looks like, down below that code we're not freeing the
inode_alloc_inode and the inode_alloc_free array.

> --------------------------------------------------------------------------------
> Index: alloc.c
> ===================================================================
> --- alloc.c	(revision 1238)
> +++ alloc.c	(working copy)
> @@ -482,6 +482,21 @@
>  	}
>  
>  	for (i = 0; i < osb->max_nodes; i++) {
> +		if (inode_alloc_free[i] != NULL) {
> +			down_write(&OCFS_I(inode_alloc_inode[i])->ip_io_sem);
> +			status = ocfs_release_lock (osb,
> +						    OCFS_LKM_EXMODE,
> +						    FLAG_FILE_CREATE,
> +						    NULL, inode_alloc_inode[i]);
> +			up_write(&OCFS_I(inode_alloc_inode[i])->ip_io_sem);
> +			if (status < 0) {
> +				LOG_ERROR_STATUS (status);
> +				goto finally;
> +			}
> +		}
> +	}
> +	
> +	for (i = 0; i < osb->max_nodes; i++) {
>  		if (ext_alloc_free[i] != NULL) {
>  			down_write(&OCFS_I(ext_alloc_inode[i])->ip_io_sem);
>  			status = ocfs_release_lock (osb,
Hmm, since we loop on the same conditions (i < osb->max_nodes), could you
resend with both 'if' blocks within the same 'for' loop? Also, if you feel
like fixing the bug noted above in the same patch, that'd be just fine with
me :)
	--Mark

--
Mark Fasheh
Software Developer, Oracle Corp
mark.fasheh@oracle.com
