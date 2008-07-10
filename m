From: Mark Fasheh <mfasheh@suse.com>
Date: Thu, 10 Jul 2008 16:15:17 -0700
Subject: [Ocfs2-devel] [PATCH 09/15] Add helper function in uptodate	for
	removing xattr clusters.v2
In-Reply-To: <20080627070149.GA20359@tma-pc2.cn.oracle.com>
References: <48648B3E.6050808@oracle.com>
	<20080627070149.GA20359@tma-pc2.cn.oracle.com>
Message-ID: <20080710231517.GA26363@eris>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Jun 27, 2008 at 03:01:49PM +0800, Tao Ma wrote:
> diff --git a/fs/ocfs2/uptodate.c b/fs/ocfs2/uptodate.c
> index 4da8851..7345d1c 100644
> --- a/fs/ocfs2/uptodate.c
> +++ b/fs/ocfs2/uptodate.c
> @@ -511,14 +511,10 @@ static void ocfs2_remove_metadata_tree(struct ocfs2_caching_info *ci,
>  	ci->ci_num_cached--;
>  }
>  
> -/* Called when we remove a chunk of metadata from an inode. We don't
> - * bother reverting things to an inlined array in the case of a remove
> - * which moves us back under the limit. */
> -void ocfs2_remove_from_cache(struct inode *inode,
> -			     struct buffer_head *bh)
> +void ocfs2_remove_block_from_cache(struct inode *inode,
> +				   sector_t block)

This new function should be static.
	--Mark

--
Mark Fasheh
