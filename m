From: Mark Fasheh <mfasheh@suse.de>
Date: Mon, 31 Aug 2015 13:56:26 -0700
Subject: [Ocfs2-devel] [patch 23/28] ocfs2: check/fix inode block for
	online file check
In-Reply-To: <55de39c6.NQqMm5hA00TLdLDU%akpm@linux-foundation.org>
References: <55de39c6.NQqMm5hA00TLdLDU%akpm@linux-foundation.org>
Message-ID: <20150831205626.GB1145@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Aug 26, 2015 at 03:12:22PM -0700, Andrew Morton wrote:
> From: Gang He <ghe@suse.com>
> Subject: ocfs2: check/fix inode block for online file check
> 
> Implement online check or fix inode block during reading a inode block to
> memory.
> 
> Signed-off-by: Gang He <ghe@suse.com>
> Reviewed-by: Goldwyn Rodrigues <rgoldwyn@suse.de>
> Cc: Mark Fasheh <mfasheh@suse.com>
> Cc: Joel Becker <jlbec@evilplan.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  fs/ocfs2/inode.c       |  196 +++++++++++++++++++++++++++++++++++++--
>  fs/ocfs2/ocfs2_trace.h |    2 
>  2 files changed, 192 insertions(+), 6 deletions(-)
> 
> diff -puN fs/ocfs2/inode.c~ocfs2-check-fix-inode-block-for-online-file-check fs/ocfs2/inode.c
> --- a/fs/ocfs2/inode.c~ocfs2-check-fix-inode-block-for-online-file-check
> +++ a/fs/ocfs2/inode.c
> @@ -53,6 +53,7 @@
>  #include "xattr.h"
>  #include "refcounttree.h"
>  #include "ocfs2_trace.h"
> +#include "filecheck.h"
>  
>  #include "buffer_head_io.h"
>  
> @@ -74,6 +75,13 @@ static int ocfs2_truncate_for_delete(str
>  				    struct inode *inode,
>  				    struct buffer_head *fe_bh);
>  
> +static int ocfs2_filecheck_read_inode_block_full(struct inode *inode,
> +			struct buffer_head **bh, int flags, int type);
> +static int ocfs2_filecheck_validate_inode_block(struct super_block *sb,
> +			struct buffer_head *bh);
> +static int ocfs2_filecheck_repair_inode_block(struct super_block *sb,
> +			struct buffer_head *bh);
> +
>  void ocfs2_set_inode_flags(struct inode *inode)
>  {
>  	unsigned int flags = OCFS2_I(inode)->ip_attr;
> @@ -127,6 +135,7 @@ struct inode *ocfs2_ilookup(struct super
>  struct inode *ocfs2_iget(struct ocfs2_super *osb, u64 blkno, unsigned flags,
>  			 int sysfile_type)
>  {
> +	int rc = 0;
>  	struct inode *inode = NULL;
>  	struct super_block *sb = osb->sb;
>  	struct ocfs2_find_inode_args args;
> @@ -161,12 +170,17 @@ struct inode *ocfs2_iget(struct ocfs2_su
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
> +			(flags & OCFS2_FI_FLAG_FILECHECK_FIX))
> +			/* Return OCFS2_FILECHECK_ERR_XXX related errno */
> +			inode = ERR_PTR(rc);
> +		else
> +			inode = ERR_PTR(-ESTALE);
>  		goto bail;
>  	}
>  
> @@ -494,16 +508,32 @@ static int ocfs2_read_locked_inode(struc
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

NAK, at first glance this is very hacky - I don't like that we've hidden these checks
and fixups down in iget(). If there's a reason it has to be this way that
should be explained, but otherwise I would expect the check/repair code to
be less intertwined with ocfs2_iget(). Otherwise I fear we're setting ourselves up
for finding some ugly bugs down the road.

Btw, how does the code handle the case where the inode is already in our
cache? In that case you'd never get to read_locked_inode()...

Thanks,
	--Mark

--
Mark Fasheh
