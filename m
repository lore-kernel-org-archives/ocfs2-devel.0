From: TaoMa <tao.ma@oracle.com>
Date: Thu, 21 Aug 2008 15:46:36 +0800
Subject: [Ocfs2-devel] [PATCH 10/10] ocfs2: Make ocfs2_extent_tree the
 first-class representation of a tree.
In-Reply-To: <1219286905-28104-11-git-send-email-joel.becker@oracle.com>
References: <1219286905-28104-1-git-send-email-joel.becker@oracle.com>
	<1219286905-28104-11-git-send-email-joel.becker@oracle.com>
Message-ID: <48AD1D5C.8000803@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Joel Becker wrote:
> We now have three different kinds of extent trees in ocfs2: inode data
> (dinode), extended attributes (xattr_tree), and extended attribute
> values (xattr_value).  There is a nice abstraction for them,
> ocfs2_extent_tree, but it is hidden in alloc.c.  All the calling
> functions have to pick amongst a varied API and pass in type bits and
> often extraneous pointers.
>
> A better way is to make ocfs2_extent_tree a first-class object.
> Everyone converts their object to an ocfs2_extent_tree() via the
> ocfs2_get_*_extent_tree() calls, then uses the ocfs2_extent_tree for all
> tree calls to alloc.c.
>
> This simplifies a lot of callers, making for readability.  It also
> provides an easy way to add additional extent tree types, as they only
> need to be defined in alloc.c with a ocfs2_get_<new>_extent_tree()
> function.
>
> Signed-off-by: Joel Becker <joel.becker@oracle.com>
> ---
>  fs/ocfs2/alloc.c    |  300 +++++++++++++++-----------------------------------
>  fs/ocfs2/alloc.h    |  111 +++++++++++---------
>  fs/ocfs2/aops.c     |   16 ++-
>  fs/ocfs2/dir.c      |   20 ++--
>  fs/ocfs2/file.c     |   34 ++++---
>  fs/ocfs2/suballoc.c |   12 +--
>  fs/ocfs2/suballoc.h |    6 +-
>  fs/ocfs2/xattr.c    |   71 +++++++------
>  8 files changed, 238 insertions(+), 332 deletions(-)
>
>   
>  
> @@ -1236,10 +1241,11 @@ static int __ocfs2_remove_inode_range(struct inode *inode,
>  	handle_t *handle;
>  	struct ocfs2_alloc_context *meta_ac = NULL;
>  	struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
> +	struct ocfs2_extent_tree et;
> +
> +	ocfs2_get_dinode_extent_tree(&et, inode, di_bh);
>  
> -	ret = ocfs2_lock_allocators(inode, di_bh, &di->id2.i_list,
> -				    0, 1, NULL, &meta_ac,
> -				    OCFS2_DINODE_EXTENT, NULL);
> +	ret = ocfs2_lock_allocators(inode, &et, 0, 1, NULL, &meta_ac);
>  	if (ret) {
>  		mlog_errno(ret);
>  		return ret;
>   
here you need to ocfs2_put_dinoe_extent_tree and I see no put in the end 
of the function.
> @@ -1269,8 +1275,8 @@ static int __ocfs2_remove_inode_range(struct inode *inode,
>  		goto out;
>  	}
>  
> -	ret = ocfs2_remove_extent(inode, di_bh, cpos, len, handle, meta_ac,
> -				  dealloc, OCFS2_DINODE_EXTENT, NULL);
> +	ret = ocfs2_remove_extent(inode, &et, cpos, len, handle, meta_ac,
> +				  dealloc);
>  	if (ret) {
>  		mlog_errno(ret);
>  		goto out_commit;
>   
btw, I like your abstraction.

Regards,
Tao
