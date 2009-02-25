From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 24 Feb 2009 18:17:17 -0800
Subject: [Ocfs2-devel] [PATCH 1/1] OCFS2: add error check
	for	ocfs2_read_locked_inode() call
In-Reply-To: <200902201453.n1KEr91o011340@acsinet13.oracle.com>
References: <200902201453.n1KEr91o011340@acsinet13.oracle.com>
Message-ID: <20090225021717.GD5209@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Feb 20, 2009 at 10:52:01PM +0800, wengang wang wrote:
> add error check for ocfs2_read_locked_inode() call.

	This isn't needed, because every error in
ocfs2_read_locked_inode() will set the inode bad with make_bad_inode().
ocfs2_iget() checks tat five lines later with is_bad_inode().

Joel

> 
> Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
> --
> Index: inode.c
> ===================================================================
> --- inode.c	(revision 149)
> +++ inode.c	(working copy)
> @@ -118,6 +118,7 @@ struct inode *ocfs2_iget(struct ocfs2_su
>  	struct inode *inode = NULL;
>  	struct super_block *sb = osb->sb;
>  	struct ocfs2_find_inode_args args;
> +	int status;
>  
>  	mlog_entry("(blkno = %llu)\n", (unsigned long long)blkno);
>  
> @@ -142,7 +143,12 @@ struct inode *ocfs2_iget(struct ocfs2_su
>  	 * afterwards. */
>  	if (inode && inode->i_state & I_NEW) {
>  		mlog(0, "Inode was not in inode cache, reading it.\n");
> -		ocfs2_read_locked_inode(inode, &args);
> +		status = ocfs2_read_locked_inode(inode, &args);
> +		if (status) {
> +			iput(inode);
> +			inode = ERR_PTR(status);
> +			goto bail;
> +		}
>  		unlock_new_inode(inode);
>  	}
>  	if (inode == NULL) {
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel

-- 

"In the room the women come and go
 Talking of Michaelangelo."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
