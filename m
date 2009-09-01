From: Tao Ma <tao.ma@oracle.com>
Date: Tue, 01 Sep 2009 16:55:04 +0800
Subject: [Ocfs2-devel] [PATCH 10/14] ocfs2: Allocation in
 ocfs2_xa_prepare_entry() values in ocfs2_xa_store_value()
In-Reply-To: <1251448563-12508-11-git-send-email-joel.becker@oracle.com>
References: <1251448563-12508-1-git-send-email-joel.becker@oracle.com>
	<1251448563-12508-11-git-send-email-joel.becker@oracle.com>
Message-ID: <4A9CE168.6050107@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



Joel Becker wrote:
> ocfs2_xa_prepare_entry() gets all the logic to add, remove, or modify
> external value trees.  Now, when it exits, the entry is ready to receive
> a value of any size.
> 
> ocfs2_xa_store_inline_value() becomes ocfs2_xa_store_value().  It can
> store any value.
> 
> ocfs2_xattr_set_entry() loses all the allocation logic and just uses
> these functions.  ocfs2_xattr_set_value_outside() disappears.
> 
> ocfs2_xattr_set_in_bucket() uses these functions and makes
> ocfs2_xattr_set_entry_in_bucket() obsolete.  That goes away, as does
> ocfs2_xattr_bucket_set_value_outside() and
> ocfs2_xattr_bucket_value_truncate().
> 
> Signed-off-by: Joel Becker <joel.becker@oracle.com>
> ---
>  fs/ocfs2/xattr.c |  611 ++++++++++++------------------------------------------
>  1 files changed, 138 insertions(+), 473 deletions(-)
> 
> diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
> index 1bc12fa..d922ad9 100644
> --- a/fs/ocfs2/xattr.c
> +++ b/fs/ocfs2/xattr.c
<snip>
> +/*
> + * Take an existing entry and make it ready for the new value.  This
> + * won't allocate space, but it may free space.  It should be ready for
> + * ocfs2_xa_prepare_entry() to finish the work.
> + */
> +static int ocfs2_xa_reuse_entry(struct ocfs2_xa_loc *loc,
> +				struct ocfs2_xattr_info *xi,
> +				struct ocfs2_xattr_set_ctxt *ctxt)
> +{
> +	int rc = 0;
> +	int name_size = OCFS2_XATTR_SIZE(xi->xi_name_len);
> +	char *nameval_buf;
> +	int xe_local = ocfs2_xattr_is_local(loc->xl_entry);
> +	int xi_local = xi->xi_value_len <= OCFS2_XATTR_INLINE_SIZE;
> +
> +	BUG_ON(OCFS2_XATTR_SIZE(loc->xl_entry->xe_name_len) !=
> +	       name_size);
> +
> +	nameval_buf = ocfs2_xa_offset_pointer(loc,
> +				le16_to_cpu(loc->xl_entry->xe_name_offset));
> +	if (xe_local) {
> +		memset(nameval_buf + name_size, 0,
> +		       namevalue_size_xe(loc->xl_entry) - name_size);
> +		if (!xi_local)
> +			ocfs2_xa_install_value_root(loc);
> +	} else {
> +		if (xi_local) {
> +			rc = ocfs2_xa_value_truncate(loc, 0, ctxt);
> +			if (rc < 0) {
> +				mlog_errno(rc);
> +				goto out;
> +			}
> +			memset(nameval_buf + name_size, 0,
> +			       namevalue_size_xe(loc->xl_entry) -
> +			       name_size);
> +		} else if (le64_to_cpu(loc->xl_entry->xe_value_size) >
> +			   xi->xi_value_len) {
> +			rc = ocfs2_xa_value_truncate(loc, xi->xi_value_len,
> +						     ctxt);
 From your comments above, we don't allocate space. I am just curious 
why we can't extend it here if value_size < xi->xi_value_len?
> +			if (rc < 0) {
> +				mlog_errno(rc);
> +				goto out;
> +			}
> +		}
> +	}
> +
> +	loc->xl_entry->xe_value_size = cpu_to_le64(xi->xi_value_len);
> +	ocfs2_xattr_set_local(loc->xl_entry, xi_local);
> +
> +out:
> +	return rc;
> +}
> +
>  /*
>   * Prepares loc->xl_entry to receive the new xattr.  This includes
>   * properly setting up the name+value pair region.  If loc->xl_entry
> @@ -2027,11 +1974,10 @@ static void ocfs2_xa_remove_entry(struct ocfs2_xa_loc *loc)
>   */
>  static int ocfs2_xa_prepare_entry(struct ocfs2_xa_loc *loc,
>  				  struct ocfs2_xattr_info *xi,
> -				  u32 name_hash)
> +				  u32 name_hash,
> +				  struct ocfs2_xattr_set_ctxt *ctxt)
>  {
>  	int rc = 0;
> -	int name_size = OCFS2_XATTR_SIZE(xi->xi_name_len);
> -	char *nameval_buf;
>  
>  	if (!xi->xi_value) {
>  		ocfs2_xa_remove_entry(loc);
> @@ -2044,13 +1990,10 @@ static int ocfs2_xa_prepare_entry(struct ocfs2_xa_loc *loc,
>  
>  	if (loc->xl_entry) {
>  		if (ocfs2_xa_can_reuse_entry(loc, xi)) {
> -			nameval_buf = ocfs2_xa_offset_pointer(loc,
> -				le16_to_cpu(loc->xl_entry->xe_name_offset));
> -			memset(nameval_buf + name_size, 0,
> -			       namevalue_size_xe(loc->xl_entry) - name_size);
> -			loc->xl_entry->xe_value_size =
> -				cpu_to_le64(xi->xi_value_len);
> -			goto out;
> +			rc = ocfs2_xa_reuse_entry(loc, xi, ctxt);
> +			if (rc)
> +				goto out;
> +			goto alloc_value;
As I said above in xa_reuse_entry, if we have already "alloc value" in 
ocfs2_xa_reuse_entry, we don't need to goto it again?
>  		}
>  
>  		ocfs2_xa_wipe_namevalue(loc);

>  static void ocfs2_init_dinode_xa_loc(struct ocfs2_xa_loc *loc,
<snip>
> @@ -2336,28 +2195,6 @@ static int ocfs2_xattr_set_entry(struct inode *inode,
>  	if (ret < 0)
>  		mlog_errno(ret);
>  
> -	if (!ret && xi->xi_value_len > OCFS2_XATTR_INLINE_SIZE) {
> -		/*
> -		 * Set value outside in B tree.
> -		 * This is the second step for value size > INLINE_SIZE.
> -		 */
> -		size_t offs = le16_to_cpu(xs->here->xe_name_offset);
> -		ret = ocfs2_xattr_set_value_outside(inode, xi, xs, ctxt,
> -						    &vb, offs);
> -		if (ret < 0) {
> -			int ret2;
> -
> -			mlog_errno(ret);
> -			/*
> -			 * If set value outside failed, we have to clean
> -			 * the junk tree root we have already set in local.
> -			 */
> -			ret2 = ocfs2_xattr_cleanup(inode, ctxt->handle,
> -						   xi, xs, &vb, offs);
you just removed this part which will remove the entry if we fail in 
cluster extension. I haven't seen some new implementation like that. Am 
I missing something here?
> -			if (ret2 < 0)
> -				mlog_errno(ret2);
> -		}
> -	}
>  out:
>  	return ret;
>  }

Regards,
Tao
