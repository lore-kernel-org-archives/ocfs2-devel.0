From: Tao Ma <tao.ma@oracle.com>
Date: Fri, 24 Oct 2008 08:44:25 +0800
Subject: [Ocfs2-devel] [PATCH 2/3] ocfs2/xattr: Merge xattr set
	transaction.
In-Reply-To: <20081023214036.GC12751@mail.oracle.com>
References: <48F81730.9020809@oracle.com>
	<1224218678-32196-2-git-send-email-tao.ma@oracle.com>
	<20081023214036.GC12751@mail.oracle.com>
Message-ID: <49011A69.9040003@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



Joel Becker wrote:
> On Fri, Oct 17, 2008 at 12:44:37PM +0800, Tao Ma wrote:
>> In current ocfs2/xattr, the whole xattr set is divided into
>> many steps are many transaction are used, this make the
>> xattr set process isn't like a real transaction, so this
>> patch try to merge all the transaction into one. Another
>> benefit is that acl can use it easily now.
> 
> 	I love the concept of this change.  I didn't like the old code,
> where random hunks of the operation would open their own handle and
> close it right away.
>  
>> I don't merge the transaction of deleting xattr when we
>> remove an inode. The reason is that if we have a large number
>> of xattrs and every xattrs has large values(large enough
>> for outside storage), the whole transaction will be very
>> huge and it looks like jbd can't handle it(I meet with a
>> jbd complain once). And the old inode removal is also divided
>> into many steps, so I'd like to leave as it is.
> 
> 	That's just fine.  Piecemeal is the right way to go there.  As
> long as we have a sane inode after every step, it is easily recovered
> from the orphan dir after a crash.
> 
>> Signed-off-by: Tao Ma <tao.ma@oracle.com>
>> ---
>>  fs/ocfs2/xattr.c |  889 +++++++++++++++++++++++++++++++-----------------------
>>  1 files changed, 514 insertions(+), 375 deletions(-)
> 
> 	I'm trying to think of a way you could break this patch up.
> It's huge.
Actually, most of the modification are just changing ocfs2_start_trans 
to ocfs2_extend_trans and passing 'handle_t *' to the function. So 
although the patch is a little large, but I think it is easy to review, 
does it? ;)
> 
>> @@ -128,11 +134,15 @@ static int ocfs2_xattr_tree_list_index_block(struct inode *inode,
>>  					size_t buffer_size);
>>  
>>  static int ocfs2_xattr_create_index_block(struct inode *inode,
>> -					  struct ocfs2_xattr_search *xs);
>> +					  handle_t *handle,
>> +					  struct ocfs2_xattr_search *xs,
>> +					  struct ocfs2_xattr_set_ctxt *ctxt);
>>  
>>  static int ocfs2_xattr_set_entry_index_block(struct inode *inode,
>> +					     handle_t *handle,
>>  					     struct ocfs2_xattr_info *xi,
>> -					     struct ocfs2_xattr_search *xs);
>> +					     struct ocfs2_xattr_search *xs,
>> +					     struct ocfs2_xattr_set_ctxt *ctxt);
> 
> 	You pass 'handle' and 'ctxt' to all the same functions.  Why not
> put the handle on the ctxt?
Most functions doesn't need 'ctxt' actually, only the functions which 
use cluster/metadata allocation/free use it. So I'd like to separate them.
> 
>> @@ -203,21 +211,10 @@ static int ocfs2_xattr_extend_allocation(struct inode *inode,
>>  
>>  	ocfs2_init_xattr_value_extent_tree(&et, inode, xattr_bh, xv);
>>  
>> -restart_all:
>> -
>> -	status = ocfs2_lock_allocators(inode, &et, clusters_to_add, 0,
>> -				       &data_ac, &meta_ac);
>> -	if (status) {
>> -		mlog_errno(status);
>> -		goto leave;
>> -	}
>> -
>>  	credits = ocfs2_calc_extend_credits(osb->sb, et.et_root_el,
>> -					    clusters_to_add);
>> -	handle = ocfs2_start_trans(osb, credits);
>> -	if (IS_ERR(handle)) {
>> -		status = PTR_ERR(handle);
>> -		handle = NULL;
>> +			clusters_to_add) + handle->h_buffer_credits;
>> +	status = ocfs2_extend_trans(handle, credits);
> 
> 	Um, you just made 'credits' be double the existing transaction +
> the result of ocfs2_calc_extend_credits().  Did you mean that?
> ocfs2_extend_trans() takes the additional credits, not the total.  Later
> you do an eocfs2_extend_trans() with merely the new credits, so I wonder
> if you meant this here?
Yes, I do this intentionally. Because ocfs2_extend_trans sometimes 
doesn't work like its name. ;) If the first extension fails, it will 
commit the dirty blocks and then extend it, that make the credits which 
isn't used lost. In some cases it is OK(see some of my following 
modification), while in other cases when some metadata will be updated 
after this function, it will fails because of no credits. I have once 
meet with a bug for this. And actually tree operation do the same thing 
as I do. See  ocfs2_extend_rotate_transaction.
>> +static int ocfs2_init_xattr_set_ctxt(struct inode *inode,
>> +				     struct ocfs2_dinode *di,
>> +				     struct ocfs2_xattr_info *xi,
>> +				     struct ocfs2_xattr_search *xis,
>> +				     struct ocfs2_xattr_search *xbs,
>> +				     struct ocfs2_xattr_set_ctxt *ctxt)
>> +{
>> +	int ret = 0, clusters_add = 0, meta_add = 0;
>> +	struct buffer_head *bh = NULL;
>> +	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
>> +	struct ocfs2_xattr_block *xb = NULL;
>> +	struct ocfs2_xattr_entry *xe;
>> +
>> +	memset(ctxt, 0, sizeof(struct ocfs2_xattr_set_ctxt));
>> +
>> +	ocfs2_init_dealloc_ctxt(&ctxt->dealloc);
>> +
>> +	if (di->i_xattr_loc) {
>> +		if (!xbs->xattr_bh) {
>> +			ret = ocfs2_read_block(inode,
>> +					       le64_to_cpu(di->i_xattr_loc),
>> +					       &bh);
>> +			if (ret) {
>> +				mlog_errno(ret);
>> +				goto out;
>> +			}
>> +
>> +			xb = (struct ocfs2_xattr_block *)bh->b_data;
>> +		} else
>> +			xb = (struct ocfs2_xattr_block *)xbs->xattr_bh->b_data;
>> +
>> +		if (le16_to_cpu(xb->xb_flags) & OCFS2_XATTR_INDEXED) {
>> +			struct ocfs2_extent_list *el =
>> +				 &xb->xb_attrs.xb_root.xt_list;
>> +			meta_add += ocfs2_extend_meta_needed(el);
>> +		}
>> +		/*
>> +		 * This cluster will be used either for new bucket or for
>> +		 * new xattr block.
>> +		 * If the cluster size is the same as the bucket size, one
>> +		 * more is needed since we may need to extend the bucket
>> +		 * also.
>> +		 */
>> +		clusters_add += 1;
>> +		if (OCFS2_XATTR_BUCKET_SIZE == osb->s_clustersize)
>> +			clusters_add += 1;
>> +	} else
>> +		meta_add += 1;
>> +
>> +	/* calculate xattr value update. */
>> +	if (xi->value && xi->value_len > OCFS2_XATTR_INLINE_SIZE) {
>> +		char *base;
>> +		int name_offset, name_len, block_off, i;
>> +		u32 new_clusters = ocfs2_clusters_for_bytes(inode->i_sb,
>> +							    xi->value_len);
>> +
>> +		xe = NULL;
>> +		if (!xis->not_found) {
>> +			xe = xis->here;
>> +			name_offset = le16_to_cpu(xe->xe_name_offset);
>> +			name_len = OCFS2_XATTR_SIZE(xe->xe_name_len);
>> +			base = xis->base;
>> +		} else if (!xbs->not_found) {
>> +			xe = xbs->here;
>> +			name_offset = le16_to_cpu(xe->xe_name_offset);
>> +			name_len = OCFS2_XATTR_SIZE(xe->xe_name_len);
>> +			i = xbs->here - xbs->header->xh_entries;
>> +
>> +			if (le16_to_cpu(xb->xb_flags) & OCFS2_XATTR_INDEXED) {
>> +				ret = ocfs2_xattr_bucket_get_name_value(inode,
>> +								xbs->bucket.xh,
>> +								i,
>> +								&block_off,
>> +								&name_offset);
>> +				base = xbs->bucket.bhs[block_off]->b_data;
>> +			} else
>> +				base = xbs->base;
>> +		}
>> +
>> +		/* calc value clusters and value tree metadata change. */
>> +		if (!xe ||
>> +		    (le64_to_cpu(xe->xe_value_size) <= OCFS2_XATTR_INLINE_SIZE))
>> +			clusters_add += new_clusters;
>> +		else {
>> +			u32 old_clusters = ocfs2_clusters_for_bytes(inode->i_sb,
>> +						le64_to_cpu(xe->xe_value_size));
>> +
>> +			if (old_clusters < new_clusters) {
>> +				struct ocfs2_xattr_value_root *xv =
>> +					(struct ocfs2_xattr_value_root *)
>> +					(base + name_offset + name_len);
>> +				meta_add +=
>> +					ocfs2_extend_meta_needed(&xv->xr_list);
>> +				clusters_add += new_clusters - old_clusters;
>> +
>> +			}
>> +		}
>> +	}
>> +
>> +	mlog(0, "Set xattr %s, reserve meta blocks = %d, clusters = %d\n",
>> +	     xi->name, meta_add, clusters_add);
>> +	if (meta_add) {
>> +		ret = ocfs2_reserve_new_metadata_blocks(osb, meta_add,
>> +							&ctxt->meta_ac);
>> +		if (ret)
>> +			mlog_errno(ret);
>> +	}
>> +
>> +	if (clusters_add) {
>> +		ret = ocfs2_reserve_clusters(osb, clusters_add, &ctxt->data_ac);
>> +		if (ret) {
>> +			mlog_errno(ret);
>> +			goto out;
>> +		}
>> +	}
>> +
>> +out:
>> +	return ret;
>> +}
> 
> 	Here you have almost all the information to calculate the
> credits you need for your transaction?  Any chance you can pass that to
> ocfs2_start_trans() up front and not have to extend later?
yes, you are right. I will try to merge, but it isn't a deal. ;)
> 
>> @@ -1940,8 +2098,12 @@ int ocfs2_xattr_set(struct inode *inode,
>>  {
>>  	struct buffer_head *di_bh = NULL;
>>  	struct ocfs2_dinode *di;
>> -	int ret;
>> +	int ret, credits;
>>  	u16 i, blk_per_bucket = ocfs2_blocks_per_xattr_bucket(inode->i_sb);
>> +	struct ocfs2_xattr_set_ctxt ctxt;
>> +	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
>> +	struct inode *tl_inode = osb->osb_tl_inode;
>> +	handle_t *handle = NULL;
>>  
>>  	struct ocfs2_xattr_info xi = {
>>  		.name_index = name_index,
>> @@ -1996,48 +2158,45 @@ int ocfs2_xattr_set(struct inode *inode,
>>  			goto cleanup;
>>  	}
>>  
>> -	if (!value) {
>> -		/* Remove existing extended attribute */
>> -		if (!xis.not_found)
>> -			ret = ocfs2_xattr_ibody_set(inode, &xi, &xis);
>> -		else if (!xbs.not_found)
>> -			ret = ocfs2_xattr_block_set(inode, &xi, &xbs);
>> -	} else {
>> -		/* We always try to set extended attribute into inode first*/
>> -		ret = ocfs2_xattr_ibody_set(inode, &xi, &xis);
>> -		if (!ret && !xbs.not_found) {
>> -			/*
>> -			 * If succeed and that extended attribute existing in
>> -			 * external block, then we will remove it.
>> -			 */
>> -			xi.value = NULL;
>> -			xi.value_len = 0;
>> -			ret = ocfs2_xattr_block_set(inode, &xi, &xbs);
>> -		} else if (ret == -ENOSPC) {
>> -			if (di->i_xattr_loc && !xbs.xattr_bh) {
>> -				ret = ocfs2_xattr_block_find(inode, name_index,
>> -							     name, &xbs);
>> -				if (ret)
>> -					goto cleanup;
>> -			}
>> -			/*
>> -			 * If no space in inode, we will set extended attribute
>> -			 * into external block.
>> -			 */
>> -			ret = ocfs2_xattr_block_set(inode, &xi, &xbs);
>> -			if (ret)
>> -				goto cleanup;
>> -			if (!xis.not_found) {
>> -				/*
>> -				 * If succeed and that extended attribute
>> -				 * existing in inode, we will remove it.
>> -				 */
>> -				xi.value = NULL;
>> -				xi.value_len = 0;
>> -				ret = ocfs2_xattr_ibody_set(inode, &xi, &xis);
>> -			}
>> +
>> +	mutex_lock(&tl_inode->i_mutex);
>> +
>> +	if (ocfs2_truncate_log_needs_flush(osb)) {
>> +		ret = __ocfs2_flush_truncate_log(osb);
>> +		if (ret < 0) {
>> +			mutex_unlock(&tl_inode->i_mutex);
>> +			mlog_errno(ret);
>> +			goto cleanup;
>>  		}
>>  	}
>> +	mutex_unlock(&tl_inode->i_mutex);
>> +
>> +	ret = ocfs2_init_xattr_set_ctxt(inode, di, &xi, &xis, &xbs, &ctxt);
>> +	if (ret) {
>> +		mlog_errno(ret);
>> +		goto cleanup;
>> +	}
>> +
>> +	credits = ocfs2_calc_xattr_set_credits(inode, &xi, &xis, &xbs);
> 
> 	You recalculate this inside __ocfs2_xattr_set_handle().  Why do
> you need to calculate it twice?
I calculate twice because the situation has been changed. If the xattr 
is in inode, the ocfs2_xattr_set will only search inode, so the first 
calc will get 1(for inode update). While if the __ocfs2_xattr_set_handle 
can update the xattr successfully it will try to move it to bucket, then 
we have to calc again since we are going to update a bucket.

Regards,
Tao
