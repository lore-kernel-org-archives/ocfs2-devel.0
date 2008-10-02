From: Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 1 Oct 2008 23:12:01 -0700
Subject: [Ocfs2-devel] [PATCH 11/39] ocfs2: Add extent tree operation
 for xattr value btrees
In-Reply-To: <1222293680-15451-12-git-send-email-mfasheh@suse.com>
References: <1222293680-15451-1-git-send-email-mfasheh@suse.com>
	<1222293680-15451-12-git-send-email-mfasheh@suse.com>
Message-ID: <20081001231201.ece971cf.akpm@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mark Fasheh <mfasheh@suse.com>
Cc: linux-kernel@vger.kernel.org, joel.becker@oracle.com, ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org, tao.ma@oracle.com

> On Wed, 24 Sep 2008 15:00:52 -0700 Mark Fasheh <mfasheh@suse.com> wrote:
> +	void *private;
>  };
>  
>  static void ocfs2_dinode_set_last_eb_blk(struct ocfs2_extent_tree *et,
> @@ -136,9 +137,50 @@ static struct ocfs2_extent_tree_operations ocfs2_dinode_et_ops = {
>  	.sanity_check		= ocfs2_dinode_sanity_check,
>  };
>  
> +static void ocfs2_xattr_value_set_last_eb_blk(struct ocfs2_extent_tree *et,
> +					      u64 blkno)
> +{
> +	struct ocfs2_xattr_value_root *xv =
> +		(struct ocfs2_xattr_value_root *)et->private;

unneeded and undesirable cast of void*

> +	xv->xr_last_eb_blk = cpu_to_le64(blkno);
> +}
> +
> +static u64 ocfs2_xattr_value_get_last_eb_blk(struct ocfs2_extent_tree *et)
> +{
> +	struct ocfs2_xattr_value_root *xv =
> +		(struct ocfs2_xattr_value_root *) et->private;

many etceteras.
