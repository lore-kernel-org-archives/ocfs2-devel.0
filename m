From: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 12 Dec 2017 14:47:47 -0800
Subject: [Ocfs2-devel] [PATCH v2] ocfs2: using the OCFS2_XATTR_ROOT_SIZE
 macro in ocfs2_reflink_xattr_header()
In-Reply-To: <5A2E2488.70301@huawei.com>
References: <5A2E2488.70301@huawei.com>
Message-ID: <20171212144747.f35e16dfcd2a0b90c18e0479@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, 11 Dec 2017 14:24:08 +0800 alex chen <alex.chen@huawei.com> wrote:

> Using the OCFS2_XATTR_ROOT_SIZE macro improves the readability of the code.
> 
> Signed-off-by: Alex Chen <alex.chen@huawei.com>
> Reviewed-by: Jun Piao <piaojun@huawei.com>
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

OK.

But what's wrong with

	*new_xv = def_xv;

?

That gets typechecked and the compiler may be able to perform
some optimizations...
