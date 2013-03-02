From: Joel Becker <jlbec@evilplan.org>
Date: Sat, 2 Mar 2013 02:47:46 -0800
Subject: [Ocfs2-devel] [RFC PATCH 3/3] ocfs2: only return the shared
 extents if FIEMAP_FLAG_COW is set
In-Reply-To: <51244A21.5090601@oracle.com>
References: <51244A21.5090601@oracle.com>
Message-ID: <20130302104742.GD22177@localhost>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jeff Liu <jeff.liu@oracle.com>
Cc: ocfs2-devel@oss.oracle.com, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, Andreas Dilger <adilger@dilger.ca>, Dave Chinner <david@fromorbit.com>, Mark Fasheh <mfasheh@suse.com>, Jan Kara <jack@suse.cz>, Chris Mason <chris.mason@fusionio.com>, Christoph Hellwig <hch@infradead.org>

Discussing this on another thread, but officially I'll NAK this here.

Joel

On Wed, Feb 20, 2013 at 11:59:29AM +0800, Jeff Liu wrote:
> Teach OCFS2 to be aware of FIEMAP_FLAG_COW - fill the extent map array with
> those extents that have OCFS2_EXT_REFCOUNTED in rec.re_flags.
> 
> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> Cc: Andreas Dilger <adilger@dilger.ca>
> Cc: Dave Chinner <david@fromorbit.com>
> Cc: Mark Fasheh <mfasheh@suse.com>
> Cc: Joel Becker <jlbec@evilplan.org>
> Cc: Jan Kara <jack@suse.de>
> Cc: Chris Mason <chris.mason@fusionio.com>
> Cc: Christoph Hellwig <hch@infradead.org>
> 
> ---
>  fs/ocfs2/extent_map.c |   11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/extent_map.c b/fs/ocfs2/extent_map.c
> index f487aa3..1eaae3f 100644
> --- a/fs/ocfs2/extent_map.c
> +++ b/fs/ocfs2/extent_map.c
> @@ -745,7 +745,7 @@ static int ocfs2_fiemap_inline(struct inode *inode, struct buffer_head *di_bh,
>  	return 0;
>  }
>  
> -#define OCFS2_FIEMAP_FLAGS	(FIEMAP_FLAG_SYNC)
> +#define OCFS2_FIEMAP_FLAGS	(FIEMAP_FLAG_SYNC | FIEMAP_FLAG_COW)
>  
>  int ocfs2_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
>  		 u64 map_start, u64 map_len)
> @@ -810,11 +810,20 @@ int ocfs2_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
>  		phys_bytes = le64_to_cpu(rec.e_blkno) << osb->sb->s_blocksize_bits;
>  		virt_bytes = (u64)le32_to_cpu(rec.e_cpos) << osb->s_clustersize_bits;
>  
> +		/*
> +		 * If the FIEMAP_FLAG_COW is set, fill the fiemap_extent array
> +		 * with the extents in copy-on-write state only.
> +		 */
> +		if ((fieinfo->fi_flags & FIEMAP_FLAG_COW) &&
> +		    !(fe_flags & FIEMAP_EXTENT_SHARED))
> +			goto next_map;
> +
>  		ret = fiemap_fill_next_extent(fieinfo, virt_bytes, phys_bytes,
>  					      len_bytes, fe_flags);
>  		if (ret)
>  			break;
>  
> +next_map:
>  		cpos = le32_to_cpu(rec.e_cpos)+ le16_to_cpu(rec.e_leaf_clusters);
>  	}
>  
> -- 
> 1.7.9.5

-- 

Life's Little Instruction Book #306

	"Take a nap on Sunday afternoons."

			http://www.jlbec.org/
			jlbec at evilplan.org
