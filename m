From: Mark Fasheh <mfasheh@suse.de>
Date: Wed, 13 Jan 2016 17:40:57 -0800
Subject: [Ocfs2-devel] [PATCH v3 4/4] ocfs2: check/fix inode block for
 online file check
In-Reply-To: <1451027779-6849-5-git-send-email-ghe@suse.com>
References: <1451027779-6849-1-git-send-email-ghe@suse.com>
	<1451027779-6849-5-git-send-email-ghe@suse.com>
Message-ID: <20160114014057.GN819@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Gang He <ghe@suse.com>
Cc: rgoldwyn@suse.de, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

On Fri, Dec 25, 2015 at 03:16:19PM +0800, Gang He wrote:
> Implement online check or fix inode block during
> reading a inode block to memory.
> 
> Signed-off-by: Gang He <ghe@suse.com>
> ---
>  fs/ocfs2/inode.c       | 200 +++++++++++++++++++++++++++++++++++++++++++++++--
>  fs/ocfs2/ocfs2_trace.h |   2 +
>  2 files changed, 196 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
> index 8f87e05..6ac2f19 100644
> --- a/fs/ocfs2/inode.c
> +++ b/fs/ocfs2/inode.c
> @@ -53,6 +53,7 @@
>  #include "xattr.h"
>  #include "refcounttree.h"
>  #include "ocfs2_trace.h"
> +#include "filecheck.h"
>  
>  #include "buffer_head_io.h"
>  
> @@ -74,6 +75,14 @@ static int ocfs2_truncate_for_delete(struct ocfs2_super *osb,
>  				    struct inode *inode,
>  				    struct buffer_head *fe_bh);
>  
> +static int ocfs2_filecheck_read_inode_block_full(struct inode *inode,
> +						 struct buffer_head **bh,
> +						 int flags, int type);
> +static int ocfs2_filecheck_validate_inode_block(struct super_block *sb,
> +						struct buffer_head *bh);
> +static int ocfs2_filecheck_repair_inode_block(struct super_block *sb,
> +					      struct buffer_head *bh);
> +
>  void ocfs2_set_inode_flags(struct inode *inode)
>  {
>  	unsigned int flags = OCFS2_I(inode)->ip_attr;
> @@ -127,6 +136,7 @@ struct inode *ocfs2_ilookup(struct super_block *sb, u64 blkno)
>  struct inode *ocfs2_iget(struct ocfs2_super *osb, u64 blkno, unsigned flags,
>  			 int sysfile_type)
>  {
> +	int rc = 0;
>  	struct inode *inode = NULL;
>  	struct super_block *sb = osb->sb;
>  	struct ocfs2_find_inode_args args;
> @@ -161,12 +171,17 @@ struct inode *ocfs2_iget(struct ocfs2_super *osb, u64 blkno, unsigned flags,
>  	}
>  	trace_ocfs2_iget5_locked(inode->i_state);
>  	if (inode->i_state & I_NEW) {
> -		ocfs2_read_locked_inode(inode, &args);
> +		rc = ocfs2_read_locked_inode(inode, &args);
>  		unlock_new_inode(inode);
>  	}
>  	if (is_bad_inode(inode)) {
>  		iput(inode);
> -		inode = ERR_PTR(-ESTALE);
> +		if ((flags & OCFS2_FI_FLAG_FILECHECK_CHK) ||
> +		    (flags & OCFS2_FI_FLAG_FILECHECK_FIX))
> +			/* Return OCFS2_FILECHECK_ERR_XXX related errno */
> +			inode = ERR_PTR(rc);
> +		else
> +			inode = ERR_PTR(-ESTALE);
>  		goto bail;
>  	}
>  
> @@ -494,16 +509,32 @@ static int ocfs2_read_locked_inode(struct inode *inode,
>  	}
>  
>  	if (can_lock) {
> -		status = ocfs2_read_inode_block_full(inode, &bh,
> -						     OCFS2_BH_IGNORE_CACHE);
> +		if (args->fi_flags & OCFS2_FI_FLAG_FILECHECK_CHK)
> +			status = ocfs2_filecheck_read_inode_block_full(inode,
> +						&bh, OCFS2_BH_IGNORE_CACHE, 0);
> +		else if (args->fi_flags & OCFS2_FI_FLAG_FILECHECK_FIX)
> +			status = ocfs2_filecheck_read_inode_block_full(inode,
> +						&bh, OCFS2_BH_IGNORE_CACHE, 1);
> +		else
> +			status = ocfs2_read_inode_block_full(inode,
> +						&bh, OCFS2_BH_IGNORE_CACHE);
>  	} else {
>  		status = ocfs2_read_blocks_sync(osb, args->fi_blkno, 1, &bh);
>  		/*
>  		 * If buffer is in jbd, then its checksum may not have been
>  		 * computed as yet.
>  		 */
> -		if (!status && !buffer_jbd(bh))
> -			status = ocfs2_validate_inode_block(osb->sb, bh);
> +		if (!status && !buffer_jbd(bh)) {
> +			if (args->fi_flags & OCFS2_FI_FLAG_FILECHECK_CHK)
> +				status = ocfs2_filecheck_validate_inode_block(
> +								osb->sb, bh);
> +			else if (args->fi_flags & OCFS2_FI_FLAG_FILECHECK_FIX)
> +				status = ocfs2_filecheck_repair_inode_block(
> +								osb->sb, bh);
> +			else
> +				status = ocfs2_validate_inode_block(
> +								osb->sb, bh);
> +		}
>  	}
>  	if (status < 0) {
>  		mlog_errno(status);
> @@ -531,6 +562,14 @@ static int ocfs2_read_locked_inode(struct inode *inode,
>  
>  	BUG_ON(args->fi_blkno != le64_to_cpu(fe->i_blkno));
>  
> +	if (buffer_dirty(bh)) {
> +		status = ocfs2_write_block(osb, bh, INODE_CACHE(inode));
> +		if (status < 0) {
> +			mlog_errno(status);
> +			goto bail;
> +		}
> +	}

This reminds me, we should be checking for a readonly file system up top in
the 'fix' helper.

Also, I'm concerned that the buffer in question might be journaled. In that
case, writing it to disk like this could cause corruptions (if the buffer
contains not-committed changes).

The answer might be to journal the changes we make but I'm not sure if that
can deadlock with other iget() calls.
	--Mark

--
Mark Fasheh
