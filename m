From: Gang He <ghe@suse.com>
Date: Sun, 10 Dec 2017 23:31:41 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: using the OCFS2_XATTR_ROOT_SIZE
 macro in ocfs2_reflink_xattr_header()
In-Reply-To: <5A2E1F97.5010906@huawei.com>
References: <5A2E1F97.5010906@huawei.com>
Message-ID: <5A2E96CD020000F90009D77E@prv-mh.provo.novell.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com




>>> 
> Using the OCFS2_XATTR_ROOT_SIZE macro improves the readability of the code.
> 
> Signed-off-by: Alex Chen <alex.chen@huawei.com>
> Reviewed-by: Jun Piao <piaojun@huawei.com>
Reviewed-by: Gang He <ghe@suse.com>

> ---
>  fs/ocfs2/xattr.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
> index 5fdf269..ca3b61a 100644
> --- a/fs/ocfs2/xattr.c
> +++ b/fs/ocfs2/xattr.c
> @@ -6415,7 +6415,7 @@ static int ocfs2_reflink_xattr_header(handle_t *handle,
>  		 * and then insert the extents one by one.
>  		 */
>  		if (xv->xr_list.l_tree_depth) {
> -			memcpy(new_xv, &def_xv, sizeof(def_xv));
> +			memcpy(new_xv, &def_xv, OCFS2_XATTR_ROOT_SIZE);
>  			vb->vb_xv = new_xv;
>  			vb->vb_bh = value_bh;
>  			ocfs2_init_xattr_value_extent_tree(&data_et,
> -- 1.9.5.msysgit.1
> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com 
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
