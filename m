From: tristan.ye <tristan.ye@oracle.com>
Date: Thu, 12 Mar 2009 10:28:50 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Use xs->bucket to set xattr
	value	outside.
In-Reply-To: <1236642573-4073-1-git-send-email-tao.ma@oracle.com>
References: <1236642573-4073-1-git-send-email-tao.ma@oracle.com>
Message-ID: <1236824930.6816.142.camel@tristan-laptop.cn.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, 2009-03-10 at 07:49 +0800, Tao Ma wrote:
> Tristan,
> 	could you please run your xattr test against it?

Awesome! All single&multi-nodes xattr tests passed!


For detail testing info, refer to:
http://oss.oracle.com/osswiki/OCFS2/XattrTest


Regards,
Tristan

> 
> xs->base used to be allocated a 4K size and all the contents in the
> bucket are copied to the it. So in ocfs2_xattr_bucket_set_value_outside,
> we are safe to use xs->base + offset. Now we use ocfs2_xattr_bucket to
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
> ---
>  fs/ocfs2/xattr.c |   27 +++++++++++++++++++++------
>  1 files changed, 21 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
> index f1b9af1..503a1d7 100644
> --- a/fs/ocfs2/xattr.c
> +++ b/fs/ocfs2/xattr.c
> @@ -4795,19 +4795,34 @@ static int ocfs2_xattr_bucket_set_value_outside(struct inode *inode,
>  						char *val,
>  						int value_len)
>  {
> -	int offset;
> +	int ret, offset, block_off;
>  	struct ocfs2_xattr_value_root *xv;
>  	struct ocfs2_xattr_entry *xe = xs->here;
> +	struct ocfs2_xattr_bucket *bucket = xs->bucket;
> +	struct ocfs2_xattr_header *xh = bucket_xh(bucket);
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
