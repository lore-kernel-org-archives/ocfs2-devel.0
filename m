From: Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 12 Mar 2014 14:37:39 -0700
Subject: [Ocfs2-devel] [PATCH] allow for more than one data extent when
 creating xattr
In-Reply-To: <1394485700-12641-1-git-send-email-tariq.x.saeed@oracle.com>
References: <1394485700-12641-1-git-send-email-tariq.x.saeed@oracle.com>
Message-ID: <20140312143739.0905183f6a7931699dd94ac7@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, 10 Mar 2014 14:08:20 -0700 Tariq Saeed <tariq.x.saeed@oracle.com> wrote:

> Orabug: 18108070
> 
> ocfs2_xattr_extend_allocation() hits panic when creating xattr during
> data extent alloc phase. The problem occurs if due to local alloc
> fragmentation, clusters are spread over multiple extents.  In this case
> ocfs2_add_clusters_in_btree() finds no space to store more than one extent
> record and therefore fails returning RESTART_META.  The situation is
> anticipated for xattr update case but not xattr create case. This fix
> simply ports that code to create case.
> 
> Signed-off-by: Tariq Saeed <tariq.x.saeed@oracle.com>
> ---
>  fs/ocfs2/xattr.c |    9 ++++++++-
>  1 files changed, 8 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
> index 5b8d944..bfa1c37 100644
> --- a/fs/ocfs2/xattr.c
> +++ b/fs/ocfs2/xattr.c
> @@ -3207,8 +3207,15 @@ meta_guess:
>  			clusters_add += 1;
>  		}
>  	} else {
> -		meta_add += 1;
>  		credits += OCFS2_XATTR_BLOCK_CREATE_CREDITS;
> +		if (xi->xi_value_len > OCFS2_XATTR_INLINE_SIZE) {
> +			struct ocfs2_extent_list *el = &def_xv.xv.xr_list;
> +			meta_add += ocfs2_extend_meta_needed(el);
> +			credits += ocfs2_calc_extend_credits(inode->i_sb,
> +							     el, 1);
> +		} else {
> +			meta_add += 1;
> +		}

fs/ocfs2/xattr.c: In function 'ocfs2_calc_xattr_set_need':
fs/ocfs2/xattr.c:3208: error: too many arguments to function 'ocfs2_calc_extend_credits'

I could just remove the arg, but something has obviously gone wrong
with testing here so I'll drop the patch.
