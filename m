Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D51ED3B71BB
	for <ocfs2-devel@lists.linux.dev>; Wed, 26 Aug 2026 08:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.112
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787731269; cv=none; b=SD1ZMh4Dk+bAnX5sY+8JkCqRfJ9a8l7/FR1Nb9m5JkrRDB0q/cTwMjjkRanhHc1RL2naU4sPGA3mq3b+d+YyrfABiZKmNf8jW35RYBMzCWpepY33NLHW/p893l5Pd4ISoxuSPqNyXqNihaRX68yj7lBrgduFV8OwTgFeUEhi9Co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787731269; c=relaxed/simple;
	bh=4/ws5hSA9Aq+3QsNSzH5yORw2TbWjn5fO7WOw8CFeLA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DE+U8uaZ69BsX9k2oTmVpfRi7JgJnmZxY7v9LV7OKim3MF4IgG3xMqHIugTq2APns0eDrMcLlBiRYT+2u9s5dSvTDZ5DhjJ7jbNNuxcvSj/k0wZM44tXRjgZxwG3j72qdSUSY7PEWLAQzfM+k7WBtn08QSWlFadU7bGCU0F+RRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=bi5GQ3AR; arc=none smtp.client-ip=115.124.30.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="bi5GQ3AR"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1787731255; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=3Cnd6XqtaLU9l7UProwWIT/wHD0mS81qIJUyjOYdKeU=;
	b=bi5GQ3AR7fQjuG8tGlX85zfE7RInQGSsO0g+2OT361+iIKUUUuJqESZ1vI2E/XcifwI+xbaisbvK5dNINqx33coFQlyZ4ITjBoziAa+c4V634ybs45TYDEOXQjeG/NZHBrJlqLo/ZUPiP2DkGsD9YlkPTHu8tiz5CBW5B6MYptI=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0X9gODlf_1787731254;
Received: from 30.166.0.157(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X9gODlf_1787731254 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 26 Aug 2026 16:00:54 +0800
Message-ID: <19d91b4a-7c43-4f03-b01d-91c6fe701ed6@linux.alibaba.com>
Date: Wed, 26 Aug 2026 16:00:54 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ocfs2: fix deadlock in inline-data truncate
 transactions
To: ZhengYuan Huang <gality369@gmail.com>
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 baijiaju1990@gmail.com, r33s3n6@gmail.com, zzzccc427@gmail.com,
 mark@fasheh.com, jlbec@evilplan.org
References: <20260806035947.2451857-1-gality369@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260806035947.2451857-1-gality369@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 8/6/26 11:59 AM, ZhengYuan Huang wrote:
> [BUG]
> Updating an inode xattr can cause an ABBA deadlock with 
> inline file truncation.
> 
>   ocfs2_truncate_file()
>     down_write(&oi->ip_alloc_sem)
>     ocfs2_truncate_inline()
>       ocfs2_start_trans()
> 
>   ocfs2_xattr_set()
>     ocfs2_start_trans()
>     ocfs2_xattr_ibody_set()
>       down_write(&oi->ip_alloc_sem)
> 
> [CAUSE]
> The xattr set path starts its merged transaction before the helpers which
> modify inode-body xattrs acquire ip_alloc_sem. This creates the reverse of
> the ip_alloc_sem -> transaction order used by the allocation and truncate
> paths. The transaction merge in 
> commit 85db90e77806 ("ocfs2/xattr: Merge xattr set transaction.")
> introduced this ordering for ordinary xattr updates.
> 
> The create-time transaction -> ip_xattr_sem dependency is a separate case.
> The fix in 
> commit c13024342c82 ("ocfs2: fix circular locking dependency in ocfs2_init_acl()")
> prepares the parent ACL before the create transaction and avoids the xattr
> semaphore for initial xattrs on an unpublished inode. That change does not
> cover ordinary ocfs2_xattr_set().
> 
> [FIX]
> Acquire ip_alloc_sem in ocfs2_xattr_set() before xattr preparation,
> allocation reservations, and transaction start.  Tell the inode-body and
> indexed-block helpers when the semaphore is already held, while preserving
> their local locking for callers that do not provide outer protection.
> 
> Keep the existing ip_alloc_sem -> transaction order in allocation and
> truncate paths; fixing the xattr side avoids changing that established
> ordering.
> 

I'd rather fix it in an alternative way by pushing the semaphore fully
up into ocfs2_xattr_set() and strip it from the helpers entirely, which
seems more cleaner.

I have a local prototype and will send out when pass regression tests.

Thanks,
Joseph

> Fixes: 85db90e77806 ("ocfs2/xattr: Merge xattr set transaction.")
> Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
> ---
> v2:
> - Fix the xattr side of the lock ordering based on Joseph's feedback.
> - Explain why the remaining fix belongs on the ordinary xattr side.
> ---
>  fs/ocfs2/xattr.c | 49 ++++++++++++++++++++++++++++++++----------------
>  1 file changed, 33 insertions(+), 16 deletions(-)
> 
> diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
> index 35bcbb0ff607..27bea1f360a1 100644
> --- a/fs/ocfs2/xattr.c
> +++ b/fs/ocfs2/xattr.c
> @@ -74,6 +74,7 @@ struct ocfs2_xattr_set_ctxt {
>  	struct ocfs2_alloc_context *data_ac;
>  	struct ocfs2_cached_dealloc_ctxt dealloc;
>  	int set_abort;
> +	int alloc_sem_protected;
>  };
>  
>  #define OCFS2_XATTR_ROOT_SIZE	(sizeof(struct ocfs2_xattr_def_value_root))
> @@ -2916,7 +2917,8 @@ static int ocfs2_xattr_has_space_inline(struct inode *inode,
>  static int ocfs2_xattr_ibody_find(struct inode *inode,
>  				  int name_index,
>  				  const char *name,
> -				  struct ocfs2_xattr_search *xs)
> +				  struct ocfs2_xattr_search *xs,
> +				  int lock_alloc_sem)
>  {
>  	struct ocfs2_inode_info *oi = OCFS2_I(inode);
>  	struct ocfs2_dinode *di = (struct ocfs2_dinode *)xs->inode_bh->b_data;
> @@ -2927,9 +2929,11 @@ static int ocfs2_xattr_ibody_find(struct inode *inode,
>  		return 0;
>  
>  	if (!(oi->ip_dyn_features & OCFS2_INLINE_XATTR_FL)) {
> -		down_read(&oi->ip_alloc_sem);
> +		if (lock_alloc_sem)
> +			down_read(&oi->ip_alloc_sem);
>  		has_space = ocfs2_xattr_has_space_inline(inode, di);
> -		up_read(&oi->ip_alloc_sem);
> +		if (lock_alloc_sem)
> +			up_read(&oi->ip_alloc_sem);
>  		if (!has_space)
>  			return 0;
>  	}
> @@ -3016,14 +3020,17 @@ static int ocfs2_xattr_ibody_set(struct inode *inode,
>  				 struct ocfs2_xattr_search *xs,
>  				 struct ocfs2_xattr_set_ctxt *ctxt)
>  {
> -	int ret;
> +	int ret, took_alloc_sem = 0;
>  	struct ocfs2_inode_info *oi = OCFS2_I(inode);
>  	struct ocfs2_xa_loc loc;
>  
>  	if (inode->i_sb->s_blocksize == OCFS2_MIN_BLOCKSIZE)
>  		return -ENOSPC;
>  
> -	down_write(&oi->ip_alloc_sem);
> +	if (!ctxt->alloc_sem_protected) {
> +		down_write(&oi->ip_alloc_sem);
> +		took_alloc_sem = 1;
> +	}
>  	if (!(oi->ip_dyn_features & OCFS2_INLINE_XATTR_FL)) {
>  		ret = ocfs2_xattr_ibody_init(inode, xs->inode_bh, ctxt);
>  		if (ret) {
> @@ -3044,7 +3051,8 @@ static int ocfs2_xattr_ibody_set(struct inode *inode,
>  	xs->here = loc.xl_entry;
>  
>  out:
> -	up_write(&oi->ip_alloc_sem);
> +	if (took_alloc_sem)
> +		up_write(&oi->ip_alloc_sem);
>  
>  	return ret;
>  }
> @@ -3729,6 +3737,7 @@ int ocfs2_xattr_set_handle(handle_t *handle,
>  		.handle = handle,
>  		.meta_ac = meta_ac,
>  		.data_ac = data_ac,
> +		.alloc_sem_protected = 1,
>  	};
>  
>  	if (!ocfs2_supports_xattr(OCFS2_SB(inode->i_sb)))
> @@ -3750,7 +3759,7 @@ int ocfs2_xattr_set_handle(handle_t *handle,
>  	xis.inode_bh = xbs.inode_bh = di_bh;
>  	di = (struct ocfs2_dinode *)di_bh->b_data;
>  
> -	ret = ocfs2_xattr_ibody_find(inode, name_index, name, &xis);
> +	ret = ocfs2_xattr_ibody_find(inode, name_index, name, &xis, 0);
>  	if (ret)
>  		goto cleanup;
>  	if (xis.not_found) {
> @@ -3834,7 +3843,7 @@ int ocfs2_xattr_set(struct inode *inode,
>  	 * Scan inode and external block to find the same name
>  	 * extended attribute and collect search information.
>  	 */
> -	ret = ocfs2_xattr_ibody_find(inode, name_index, name, &xis);
> +	ret = ocfs2_xattr_ibody_find(inode, name_index, name, &xis, 1);
>  	if (ret)
>  		goto cleanup;
>  	if (xis.not_found) {
> @@ -3856,6 +3865,8 @@ int ocfs2_xattr_set(struct inode *inode,
>  			goto cleanup;
>  	}
>  
> +	down_write(&OCFS2_I(inode)->ip_alloc_sem);
> +
>  	/* Check whether the value is refcounted and do some preparation. */
>  	if (ocfs2_is_refcount_inode(inode) &&
>  	    (!xis.not_found || !xbs.not_found)) {
> @@ -3864,7 +3875,7 @@ int ocfs2_xattr_set(struct inode *inode,
>  						   &ref_meta, &ref_credits);
>  		if (ret) {
>  			mlog_errno(ret);
> -			goto cleanup;
> +			goto out_unlock_alloc;
>  		}
>  	}
>  
> @@ -3875,7 +3886,7 @@ int ocfs2_xattr_set(struct inode *inode,
>  		if (ret < 0) {
>  			inode_unlock(tl_inode);
>  			mlog_errno(ret);
> -			goto cleanup;
> +			goto out_unlock_alloc;
>  		}
>  	}
>  	inode_unlock(tl_inode);
> @@ -3884,8 +3895,9 @@ int ocfs2_xattr_set(struct inode *inode,
>  					&xbs, &ctxt, ref_meta, &credits);
>  	if (ret) {
>  		mlog_errno(ret);
> -		goto cleanup;
> +		goto out_unlock_alloc;
>  	}
> +	ctxt.alloc_sem_protected = 1;
>  
>  	/* we need to update inode's ctime field, so add credit for it. */
>  	credits += OCFS2_INODE_UPDATE_CREDITS;
> @@ -3893,15 +3905,15 @@ int ocfs2_xattr_set(struct inode *inode,
>  	if (IS_ERR(ctxt.handle)) {
>  		ret = PTR_ERR(ctxt.handle);
>  		mlog_errno(ret);
> -		goto out_free_ac;
> +		goto out_unlock_alloc;
>  	}
>  
>  	ret = __ocfs2_xattr_set_handle(inode, di, &xi, &xis, &xbs, &ctxt);
>  	ocfs2_update_inode_fsync_trans(ctxt.handle, inode, 0);
>  
>  	ocfs2_commit_trans(osb, ctxt.handle);
> -
> -out_free_ac:
> +out_unlock_alloc:
> +	up_write(&OCFS2_I(inode)->ip_alloc_sem);
>  	if (ctxt.data_ac)
>  		ocfs2_free_alloc_context(ctxt.data_ac);
>  	if (ctxt.meta_ac)
> @@ -4520,6 +4532,7 @@ static int ocfs2_xattr_create_index_block(struct inode *inode,
>  	u64 blkno;
>  	handle_t *handle = ctxt->handle;
>  	struct ocfs2_inode_info *oi = OCFS2_I(inode);
> +	int took_alloc_sem = 0;
>  	struct buffer_head *xb_bh = xs->xattr_bh;
>  	struct ocfs2_xattr_block *xb =
>  			(struct ocfs2_xattr_block *)xb_bh->b_data;
> @@ -4537,7 +4550,10 @@ static int ocfs2_xattr_create_index_block(struct inode *inode,
>  	 * We can use this lock for now, and maybe move to a dedicated mutex
>  	 * if performance becomes a problem later.
>  	 */
> -	down_write(&oi->ip_alloc_sem);
> +	if (!ctxt->alloc_sem_protected) {
> +		down_write(&oi->ip_alloc_sem);
> +		took_alloc_sem = 1;
> +	}
>  
>  	ret = ocfs2_journal_access_xb(handle, INODE_CACHE(inode), xb_bh,
>  				      OCFS2_JOURNAL_ACCESS_WRITE);
> @@ -4600,7 +4616,8 @@ static int ocfs2_xattr_create_index_block(struct inode *inode,
>  	ocfs2_journal_dirty(handle, xb_bh);
>  
>  out:
> -	up_write(&oi->ip_alloc_sem);
> +	if (took_alloc_sem)
> +		up_write(&oi->ip_alloc_sem);
>  
>  	return ret;
>  }

