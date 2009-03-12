From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 12 Mar 2009 03:18:56 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: Use xs->bucket to set xattr
	value	outside.v2
In-Reply-To: <1236818254-22203-1-git-send-email-tao.ma@oracle.com>
References: <20090312092926.GC2014@ca-server1.us.oracle.com>
	<1236818254-22203-1-git-send-email-tao.ma@oracle.com>
Message-ID: <20090312101856.GD2014@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Mar 12, 2009 at 08:37:34AM +0800, Tao Ma wrote:
> V1 to V2:
> Just remove the local variable bucket.
> 
> A long time ago, xs->base is allocated a 4K size and all the contents
> in the bucket are copied to the it. Now we use ocfs2_xattr_bucket to
> abstract xattr bucket and xs->base is initialized to the start of the
> bu_bhs[0]. So xs->base + offset will overflow when the value root is
> stored outside the first block.
> 
> Then why we can survive the xattr test by now? It is because we always
> read the bucket contiguously now and kernel mm allocate continguous
> memory for us. We are lucky, but we should fix it. So just get the
> right value root as other callers do.
> 
> Signed-off-by: Tao Ma <tao.ma@oracle.com>
Acked-by: Joel Becker <joel.becker@oracle.com>


> ---
>  fs/ocfs2/xattr.c |   26 ++++++++++++++++++++------
>  1 files changed, 20 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
> index f1b9af1..195120d 100644
> --- a/fs/ocfs2/xattr.c
> +++ b/fs/ocfs2/xattr.c
> @@ -4795,19 +4795,33 @@ static int ocfs2_xattr_bucket_set_value_outside(struct inode *inode,
>  						char *val,
>  						int value_len)
>  {
> -	int offset;
> +	int ret, offset, block_off;
>  	struct ocfs2_xattr_value_root *xv;
>  	struct ocfs2_xattr_entry *xe = xs->here;
> +	struct ocfs2_xattr_header *xh = bucket_xh(xs->bucket);
> +	void *base;
>  
>  	BUG_ON(!xs->base || !xe || ocfs2_xattr_is_local(xe));
>  
> -	offset = le16_to_cpu(xe->xe_name_offset) +
> -		 OCFS2_XATTR_SIZE(xe->xe_name_len);
> +	ret = ocfs2_xattr_bucket_get_name_value(inode, xh,
> +						xe - xh->xh_entries,
> +						&block_off,
> +						&offset);
> +	if (ret) {
> +		mlog_errno(ret);
> +		goto out;
> +	}
>  
> -	xv = (struct ocfs2_xattr_value_root *)(xs->base + offset);
> +	base = bucket_block(xs->bucket, block_off);
> +	xv = (struct ocfs2_xattr_value_root *)(base + offset +
> +		 OCFS2_XATTR_SIZE(xe->xe_name_len));
>  
> -	return __ocfs2_xattr_set_value_outside(inode, handle,
> -					       xv, val, value_len);
> +	ret = __ocfs2_xattr_set_value_outside(inode, handle,
> +					      xv, val, value_len);
> +	if (ret)
> +		mlog_errno(ret);
> +out:
> +	return ret;
>  }
>  
>  static int ocfs2_rm_xattr_cluster(struct inode *inode,
> -- 
> 1.6.2.rc2.16.gf474c
> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel

-- 

Life's Little Instruction Book #356

	"Be there when people need you."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
