From: Joseph Qi <joseph.qi@linux.alibaba.com>
Date: Wed, 20 Nov 2019 09:00:18 +0800
Subject: [Ocfs2-devel] [PATCH] Revert "fs: ocfs2: fix possible
 null-pointer dereferences in ocfs2_xa_prepare_entry()"
In-Reply-To: <1573624916-83825-1-git-send-email-joseph.qi@linux.alibaba.com>
References: <1573624916-83825-1-git-send-email-joseph.qi@linux.alibaba.com>
Message-ID: <ee8ea52f-e460-1ac6-4e06-342ffe5427f6@linux.alibaba.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Ping...

On 19/11/13 14:01, Joseph Qi wrote:
> This reverts commit 56e94ea132bb5c2c1d0b60a6aeb34dcb7d71a53d.
> 
> commit 56e94ea132bb "fs: ocfs2: fix possible null-pointer dereferences
> in ocfs2_xa_prepare_entry()" introduces a regression that fail to create
> directory with mount option user_xattr and acl.
> Actually the reported NULL pointer dereference case can be correctly
> handled by loc->xl_ops->xlo_add_entry(), so revert it.
> 
> Reported-by: Thomas Voegtle <tv@lio96.de>
> Cc: Jia-Ju Bai <baijiaju1990@gmail.com>
> Cc: stable at vger.kernel.org
> Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
>  fs/ocfs2/xattr.c | 56 +++++++++++++++++++++++++++++++++-----------------------
>  1 file changed, 33 insertions(+), 23 deletions(-)
> 
> diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
> index d850797..90c830e3 100644
> --- a/fs/ocfs2/xattr.c
> +++ b/fs/ocfs2/xattr.c
> @@ -1490,6 +1490,18 @@ static int ocfs2_xa_check_space(struct ocfs2_xa_loc *loc,
>  	return loc->xl_ops->xlo_check_space(loc, xi);
>  }
>  
> +static void ocfs2_xa_add_entry(struct ocfs2_xa_loc *loc, u32 name_hash)
> +{
> +	loc->xl_ops->xlo_add_entry(loc, name_hash);
> +	loc->xl_entry->xe_name_hash = cpu_to_le32(name_hash);
> +	/*
> +	 * We can't leave the new entry's xe_name_offset at zero or
> +	 * add_namevalue() will go nuts.  We set it to the size of our
> +	 * storage so that it can never be less than any other entry.
> +	 */
> +	loc->xl_entry->xe_name_offset = cpu_to_le16(loc->xl_size);
> +}
> +
>  static void ocfs2_xa_add_namevalue(struct ocfs2_xa_loc *loc,
>  				   struct ocfs2_xattr_info *xi)
>  {
> @@ -2121,31 +2133,29 @@ static int ocfs2_xa_prepare_entry(struct ocfs2_xa_loc *loc,
>  	if (rc)
>  		goto out;
>  
> -	if (!loc->xl_entry) {
> -		rc = -EINVAL;
> -		goto out;
> -	}
> -
> -	if (ocfs2_xa_can_reuse_entry(loc, xi)) {
> -		orig_value_size = loc->xl_entry->xe_value_size;
> -		rc = ocfs2_xa_reuse_entry(loc, xi, ctxt);
> -		if (rc)
> -			goto out;
> -		goto alloc_value;
> -	}
> +	if (loc->xl_entry) {
> +		if (ocfs2_xa_can_reuse_entry(loc, xi)) {
> +			orig_value_size = loc->xl_entry->xe_value_size;
> +			rc = ocfs2_xa_reuse_entry(loc, xi, ctxt);
> +			if (rc)
> +				goto out;
> +			goto alloc_value;
> +		}
>  
> -	if (!ocfs2_xattr_is_local(loc->xl_entry)) {
> -		orig_clusters = ocfs2_xa_value_clusters(loc);
> -		rc = ocfs2_xa_value_truncate(loc, 0, ctxt);
> -		if (rc) {
> -			mlog_errno(rc);
> -			ocfs2_xa_cleanup_value_truncate(loc,
> -							"overwriting",
> -							orig_clusters);
> -			goto out;
> +		if (!ocfs2_xattr_is_local(loc->xl_entry)) {
> +			orig_clusters = ocfs2_xa_value_clusters(loc);
> +			rc = ocfs2_xa_value_truncate(loc, 0, ctxt);
> +			if (rc) {
> +				mlog_errno(rc);
> +				ocfs2_xa_cleanup_value_truncate(loc,
> +								"overwriting",
> +								orig_clusters);
> +				goto out;
> +			}
>  		}
> -	}
> -	ocfs2_xa_wipe_namevalue(loc);
> +		ocfs2_xa_wipe_namevalue(loc);
> +	} else
> +		ocfs2_xa_add_entry(loc, name_hash);
>  
>  	/*
>  	 * If we get here, we have a blank entry.  Fill it.  We grow our
> 
