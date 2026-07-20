Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81A0738AC7D
	for <ocfs2-devel@lists.linux.dev>; Mon, 20 Jul 2026 03:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784517302; cv=none; b=lqrV5aIpswOyU5zY5O5kSpNrKFYW1Ho2B8Hze/1TqmO37GCc/JQQ6h4JiTQexJjNkznQjUPREqoU0v/XAcrpF1KfMmb4fIJ4cBNPS0vYdqp3v6Aa8i5BV7RfxUmmWSSombKvmFhWgVEv0PySWc0N+cALEaC7w14lkeB8z6dfafM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784517302; c=relaxed/simple;
	bh=zG0RYla8DZ4MEMx36ZwFoGxPIBv3/gzg2rFozWWGA90=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:Cc:
	 In-Reply-To:Content-Type; b=dt2qmPPpxuOJBQVta1Yq/+/RGBZui6gZ7046F8kakFSb79Uxqwzdy5rVCvRYiNZWLEVl1jiMNs6GIOAdP7+gpbhYuug8CtTg/+7xx+eig1uLgFCaOJiTu1O327MylpWK4ICktynJRJAIpnfg4HgFUuRBreG+SuH6leZLXKmLxwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=oV5eIWgl; arc=none smtp.client-ip=115.124.30.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="oV5eIWgl"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1784517291; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=ybzns7PqX7cQ5N0j8H3ReS6/3rN3YNtUpmwzwB3l4mY=;
	b=oV5eIWglqV+UN8RJt0kGUU8tq1xN1JEAPq3QZ+YFbc1DljdzoxndA+pNPDDjg3tMYIxnfDEUQw3h/wxm4uysEtnJuXDlPhqfgq9/5buZ0qFGqrD9bl5ffZv+Hyh9pHb0PuaxxrXfYU7urt4+lQj9AKDksDo1qMITN7G+MLtIWNk=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0X7NJr.p_1784516973;
Received: from 30.166.0.112(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X7NJr.p_1784516973 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 20 Jul 2026 11:09:33 +0800
Message-ID: <910f147b-baaa-441f-b532-8858f8d43d85@linux.alibaba.com>
Date: Mon, 20 Jul 2026 11:09:32 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ocfs2: free unused clusters on defrag move errors
To: Guangshuo Li <lgs201920130244@gmail.com>
References: <20260714113517.1381604-1-lgs201920130244@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 Tristan Ye <tristan.ye@oracle.com>, ocfs2-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org
In-Reply-To: <20260714113517.1381604-1-lgs201920130244@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 7/14/26 7:35 PM, Guangshuo Li wrote:
> ocfs2_defrag_extent() claims new clusters before calling
> __ocfs2_move_extent(). If the move fails before the extent tree update
> is attempted, the claimed clusters are not referenced by the inode and
> must be released.
> 
> The current error path only logs the error and continues to
> ocfs2_cow_sync_writeback(), which can overwrite the original error with
> zero. The claimed clusters are also left allocated.
> 
> Not every __ocfs2_move_extent() error can free the new clusters,
> however. Once ocfs2_split_extent() has been called, the extent tree may
> already reference them even if a later operation fails. Freeing them in
> that case would leave the extent tree pointing to clusters marked free.
> 
> Track whether the extent split has been started. On errors before that
> point, report that the new clusters remain unused so the defrag caller
> can release them. Once the split has started, leave the clusters
> allocated. Return all move errors through the transaction cleanup path
> without allowing writeback to overwrite them.
> 
> Fixes: 202ee5facb2c ("Ocfs2/move_extents: defrag a range of extent.")
> Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
> ---
> v2:
>   - Do not free the new clusters after the extent-tree update has
>     started, as pointed out by Joseph Qi.
>   - Track whether the new clusters remain unused on error.
>   - Preserve __ocfs2_move_extent() errors instead of allowing the
>     subsequent writeback call to overwrite them.
> 
>  fs/ocfs2/move_extents.c | 23 +++++++++++++++++++----
>  1 file changed, 19 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
> index ad1678ee7cc4..138c65d21668 100644
> --- a/fs/ocfs2/move_extents.c
> +++ b/fs/ocfs2/move_extents.c
> @@ -49,9 +49,10 @@ struct ocfs2_move_extents_context {
>  static int __ocfs2_move_extent(handle_t *handle,
>  			       struct ocfs2_move_extents_context *context,
>  			       u32 cpos, u32 len, u32 p_cpos, u32 new_p_cpos,
> -			       int ext_flags)
> +			       int ext_flags, bool *new_clusters_unused)
>  {
>  	int ret = 0, index;
> +	bool split_started = false;
>  	struct inode *inode = context->inode;
>  	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
>  	struct ocfs2_extent_rec *rec, replace_rec;
> @@ -59,6 +60,10 @@ static int __ocfs2_move_extent(handle_t *handle,
>  	struct ocfs2_extent_list *el;
>  	u64 ino = ocfs2_metadata_cache_owner(context->et.et_ci);
>  	u64 old_blkno = ocfs2_clusters_to_blocks(inode->i_sb, p_cpos);
> +	bool split_started = false;

Duplicate declaration?

> +
> +	if (new_clusters_unused)
> +		*new_clusters_unused = false;
>  
>  	ret = ocfs2_duplicate_clusters_by_page(handle, inode, cpos,
>  					       p_cpos, new_p_cpos, len);
> @@ -111,6 +116,7 @@ static int __ocfs2_move_extent(handle_t *handle,
>  	 */
>  	replace_rec.e_flags = ext_flags & ~OCFS2_EXT_REFCOUNTED;
>  
> +	split_started = true;
>  	ret = ocfs2_split_extent(handle, &context->et, path, index,
>  				 &replace_rec, context->meta_ac,
>  				 &context->dealloc);
> @@ -138,6 +144,9 @@ static int __ocfs2_move_extent(handle_t *handle,
>  
>  	ocfs2_update_inode_fsync_trans(handle, inode, 0);
>  out:
> +	if (ret && !split_started && new_clusters_unused)
> +		*new_clusters_unused = true;
> +
>  	ocfs2_free_path(path);
>  	return ret;
>  }
> @@ -209,6 +218,7 @@ static int ocfs2_defrag_extent(struct ocfs2_move_extents_context *context,
>  	struct ocfs2_refcount_tree *ref_tree = NULL;
>  	u32 new_phys_cpos, new_len;
>  	u64 phys_blkno = ocfs2_clusters_to_blocks(inode->i_sb, phys_cpos);
> +	bool new_clusters_unused;
>  	int need_free = 0;
>  
>  	if ((ext_flags & OCFS2_EXT_REFCOUNTED) && *len) {
> @@ -309,9 +319,14 @@ static int ocfs2_defrag_extent(struct ocfs2_move_extents_context *context,
>  	     phys_cpos, new_phys_cpos);
>  
>  	ret = __ocfs2_move_extent(handle, context, cpos, new_len, phys_cpos,
> -				  new_phys_cpos, ext_flags);
> -	if (ret)
> +				  new_phys_cpos, ext_flags,
> +				  &new_clusters_unused);

Seems we can reuse 'context->new_phys_cpos' to check if need free without
changing __ocfs2_move_extent() prototype.

Thanks,
Joseph

> +	if (ret) {
>  		mlog_errno(ret);
> +		if (new_clusters_unused)
> +			need_free = 1;
> +		goto out_commit;
> +	}
>  
>  	if (partial && (new_len != *len))
>  		*len = new_len;
> @@ -684,7 +699,7 @@ static int ocfs2_move_extent(struct ocfs2_move_extents_context *context,
>  	}
>  
>  	ret = __ocfs2_move_extent(handle, context, cpos, len, phys_cpos,
> -				  *new_phys_cpos, ext_flags);
> +				  *new_phys_cpos, ext_flags, NULL);
>  	if (ret) {
>  		mlog_errno(ret);
>  		goto out_commit;

