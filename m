From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 24 Feb 2009 17:41:10 -0800
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2: set gap to seperate entry and
	value when	xattr in bucket
In-Reply-To: <1235099510-14128-1-git-send-email-tiger.yang@oracle.com>
References: <1235099510-14128-1-git-send-email-tiger.yang@oracle.com>
Message-ID: <20090225014109.GA5209@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Feb 20, 2009 at 11:11:50AM +0800, Tiger Yang wrote:
> This patch set a gap (4 bytes) between xattr entry and
> name/value when xattr in bucket. This gap use to seperate
> entry and name/value when a bucket is full. It had already
> been set when xattr in inode/block.
> 
> Signed-off-by: Tiger Yang <tiger.yang@oracle.com>

Acked-by: Joel Becker <joel.becker@oracle.com>

Has this passed tristan's tests?

Joel

> ---
>  fs/ocfs2/xattr.c |   18 ++++++++++--------
>  1 files changed, 10 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
> index 915039f..dedede1 100644
> --- a/fs/ocfs2/xattr.c
> +++ b/fs/ocfs2/xattr.c
> @@ -82,13 +82,14 @@ struct ocfs2_xattr_set_ctxt {
>  
>  #define OCFS2_XATTR_ROOT_SIZE	(sizeof(struct ocfs2_xattr_def_value_root))
>  #define OCFS2_XATTR_INLINE_SIZE	80
> +#define OCFS2_XATTR_HEADER_GAP	4
>  #define OCFS2_XATTR_FREE_IN_IBODY	(OCFS2_MIN_XATTR_INLINE_SIZE \
>  					 - sizeof(struct ocfs2_xattr_header) \
> -					 - sizeof(__u32))
> +					 - OCFS2_XATTR_HEADER_GAP)
>  #define OCFS2_XATTR_FREE_IN_BLOCK(ptr)	((ptr)->i_sb->s_blocksize \
>  					 - sizeof(struct ocfs2_xattr_block) \
>  					 - sizeof(struct ocfs2_xattr_header) \
> -					 - sizeof(__u32))
> +					 - OCFS2_XATTR_HEADER_GAP)
>  
>  static struct ocfs2_xattr_def_value_root def_xv = {
>  	.xv.xr_list.l_count = cpu_to_le16(1),
> @@ -1507,7 +1508,7 @@ static int ocfs2_xattr_set_entry(struct inode *inode,
>  		last += 1;
>  	}
>  
> -	free = min_offs - ((void *)last - xs->base) - sizeof(__u32);
> +	free = min_offs - ((void *)last - xs->base) - OCFS2_XATTR_HEADER_GAP;
>  	if (free < 0)
>  		return -EIO;
>  
> @@ -2190,7 +2191,7 @@ static int ocfs2_xattr_can_be_in_inode(struct inode *inode,
>  		last += 1;
>  	}
>  
> -	free = min_offs - ((void *)last - xs->base) - sizeof(__u32);
> +	free = min_offs - ((void *)last - xs->base) - OCFS2_XATTR_HEADER_GAP;
>  	if (free < 0)
>  		return 0;
>  
> @@ -5060,8 +5061,8 @@ try_again:
>  	xh_free_start = le16_to_cpu(xh->xh_free_start);
>  	header_size = sizeof(struct ocfs2_xattr_header) +
>  			count * sizeof(struct ocfs2_xattr_entry);
> -	max_free = OCFS2_XATTR_BUCKET_SIZE -
> -		le16_to_cpu(xh->xh_name_value_len) - header_size;
> +	max_free = OCFS2_XATTR_BUCKET_SIZE - header_size -
> +		le16_to_cpu(xh->xh_name_value_len) - OCFS2_XATTR_HEADER_GAP;
>  
>  	mlog_bug_on_msg(header_size > blocksize, "bucket %llu has header size "
>  			"of %u which exceed block size\n",
> @@ -5094,7 +5095,7 @@ try_again:
>  			need = 0;
>  	}
>  
> -	free = xh_free_start - header_size;
> +	free = xh_free_start - header_size - OCFS2_XATTR_HEADER_GAP;
>  	/*
>  	 * We need to make sure the new name/value pair
>  	 * can exist in the same block.
> @@ -5127,7 +5128,8 @@ try_again:
>  			}
>  
>  			xh_free_start = le16_to_cpu(xh->xh_free_start);
> -			free = xh_free_start - header_size;
> +			free = xh_free_start - header_size
> +				- OCFS2_XATTR_HEADER_GAP;
>  			if (xh_free_start % blocksize < need)
>  				free -= xh_free_start % blocksize;
>  
> -- 
> 1.5.4.1
> 

-- 

"The doctrine of human equality reposes on this: that there is no
 man really clever who has not found that he is stupid."
	- Gilbert K. Chesterson

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
