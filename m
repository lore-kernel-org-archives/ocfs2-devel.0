From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Wed, 23 Dec 2009 10:48:04 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2/trivial: Use le16_to_cpu for a disk
 value in xattr.c
In-Reply-To: <1261549875-14192-1-git-send-email-tao.ma@oracle.com>
References: <1261549875-14192-1-git-send-email-tao.ma@oracle.com>
Message-ID: <4B3265E4.9060000@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Ack.

Tao Ma wrote:
> In ocfs2_value_metas_in_xattr_header, we should Use
> le16_to_cpu for ocfs2_extent_list.l_next_free_rec.
>
> Signed-off-by: Tao Ma <tao.ma@oracle.com>
> ---
>  fs/ocfs2/xattr.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
> index fe34190..8c0bfa2 100644
> --- a/fs/ocfs2/xattr.c
> +++ b/fs/ocfs2/xattr.c
> @@ -6066,7 +6066,7 @@ static int ocfs2_value_metas_in_xattr_header(struct super_block *sb,
>  		 * to the extent block, so just calculate a maximum record num.
>  		 */
>  		if (!xv->xr_list.l_tree_depth)
> -			*num_recs += xv->xr_list.l_next_free_rec;
> +			*num_recs += le16_to_cpu(xv->xr_list.l_next_free_rec);
>  		else
>  			*num_recs += ocfs2_clusters_for_bytes(sb,
>  							      XATTR_SIZE_MAX);
>   
