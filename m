From: Jeff Liu <jeff.liu@oracle.com>
Date: Mon, 17 Jun 2013 22:40:32 +0800
Subject: [Ocfs2-devel] [PATCH] Add bits_wanted while calculating credits
 in ocfs2_calc_extend_credits
In-Reply-To: <20130617140824.GA8554@shrek.cartoons>
References: <20130617140824.GA8554@shrek.cartoons>
Message-ID: <51BF1FE0.9040500@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 06/17/2013 10:08 PM, Goldwyn Rodrigues wrote:

> While adding extends to a file, the credits are calculated incorrectly
> and if the requested clusters is more than one (or more because we used 
> a conservative limit) then we run out of journal credits and we hit
> an assert in journalling code.
> 
> The function parameter bits_wanted variable was not used at all.
> 
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>

Looks good to me, thank you!
Reviewed-by: Jie Liu <jeff.liu@oracle.com>

> 
> --- 
> diff --git a/fs/ocfs2/journal.h b/fs/ocfs2/journal.h
> index a3385b6..7d927cd 100644
> --- a/fs/ocfs2/journal.h
> +++ b/fs/ocfs2/journal.h
> @@ -538,7 +538,7 @@ static inline int ocfs2_calc_extend_credits(struct super_block *sb,
>  	extent_blocks = 1 + 1 + le16_to_cpu(root_el->l_tree_depth);
>  
>  	return bitmap_blocks + sysfile_bitmap_blocks + extent_blocks +
> -	       ocfs2_quota_trans_credits(sb);
> +	       ocfs2_quota_trans_credits(sb) + bits_wanted;
>  }
>  
>  static inline int ocfs2_calc_symlink_credits(struct super_block *sb)
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
