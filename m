From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 25 Jan 2010 19:51:48 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Sync max_inline_data_with_xattr
	from tools.
In-Reply-To: <1263958271-15826-1-git-send-email-tao.ma@oracle.com>
References: <1263958271-15826-1-git-send-email-tao.ma@oracle.com>
Message-ID: <20100126035148.GD15982@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Jan 20, 2010 at 11:31:11AM +0800, Tao Ma wrote:
> In ocfs2-tools, we have added ocfs2_max_inline_data_with_xattr,
> so add it in the kernel's ocfs2_fs.h.
> 
> Signed-off-by: Tao Ma <tao.ma@oracle.com>

This patch is now part of the 'fixes' branch of ocfs2.git

Joel

> ---
>  fs/ocfs2/ocfs2_fs.h |   11 +++++++++--
>  1 files changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
> index 1a1a679..7638a38 100644
> --- a/fs/ocfs2/ocfs2_fs.h
> +++ b/fs/ocfs2/ocfs2_fs.h
> @@ -1417,9 +1417,16 @@ static inline int ocfs2_fast_symlink_chars(int blocksize)
>  	return blocksize - offsetof(struct ocfs2_dinode, id2.i_symlink);
>  }
>  
> -static inline int ocfs2_max_inline_data(int blocksize)
> +static inline int ocfs2_max_inline_data_with_xattr(int blocksize,
> +						   struct ocfs2_dinode *di)
>  {
> -	return blocksize - offsetof(struct ocfs2_dinode, id2.i_data.id_data);
> +	if (di && (di->i_dyn_features & OCFS2_INLINE_XATTR_FL))
> +		return blocksize -
> +			offsetof(struct ocfs2_dinode, id2.i_data.id_data) -
> +			di->i_xattr_inline_size;
> +	else
> +		return blocksize -
> +			offsetof(struct ocfs2_dinode, id2.i_data.id_data);
>  }
>  
>  static inline int ocfs2_extent_recs_per_inode(int blocksize)
> -- 
> 1.6.3.3
> 

-- 

"What does it say about a society's priorities when the time you
 spend in meetings on Monday is greater than the total number of
 hours you spent sleeping over the weekend?"
	- Nat Friedman

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
