Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F22CA17E9
	for <ocfs2-devel@lists.linux.dev>; Fri, 15 Mar 2024 01:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710465006; cv=none; b=eQNZRYNCfaFsr/RjEqtKIMrSahNpqwT+W04Dhg5RGyXndCszPaYUMimRmeGDV7TJ/3RAtokg6LQbjod5buCbEMKYnKUvDEgJJDCr7t+jnhrXX1z7OlzflAl4Py4FuooMo5ARCqHxxDnDIL8LH+v6pNGCS0i08boYZb6nXhwmhuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710465006; c=relaxed/simple;
	bh=nLVjScqtnzhT2dG1iPdJoRntz6a87rk6eZkoN5MEbvA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kcVDd0nl67wT7peENngTit/bsEcCS2415wJ5POgZyH6cgGOX448krKmVW2GH7ul9uokzK+olRU6RxnKJnvr6leBEC1fB4StyieFHbBH3GI8xMjYL9CZw6hrc69TuJFxYWj7QaCMfZbut9TSMXm8jJawZZAY8LP3BFJNi4I8EX0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=PcEftE8K; arc=none smtp.client-ip=115.124.30.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="PcEftE8K"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1710465000; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=p4v82nBmjq4McfbftttyvtOx62FlmXncoW4tBvgfzJk=;
	b=PcEftE8Kaf76NHxeBrpxnL/3kYR6gA+R1skcl4Ifa3M7mxrItR7H0FltgGHvy6xmb3S9CNcbKQVzpI97ge7YoQTXCKsiwRUHZ+WF1PJ/0/nm+lxISsQX4LAmfwgBoanxeaiD/9Wm7cH2tDJsv2Mu2HQDN6bKYJCP2Uurm3iZgEI=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R701e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046056;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---0W2U8I5S_1710464999;
Received: from 30.221.128.128(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0W2U8I5S_1710464999)
          by smtp.aliyun-inc.com;
          Fri, 15 Mar 2024 09:09:59 +0800
Message-ID: <1e0cd8fb-ca1e-4937-bdfe-333284569425@linux.alibaba.com>
Date: Fri, 15 Mar 2024 09:09:57 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: fix journal protection issues
To: Heming Zhao <heming.zhao@suse.com>
Cc: ocfs2-devel@lists.linux.dev
References: <20240314073353.11489-1-heming.zhao@suse.com>
Content-Language: en-US
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20240314073353.11489-1-heming.zhao@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,

On 3/14/24 3:33 PM, Heming Zhao wrote:
> This patch resolves 3 journal-related issues:
> 1. ocfs2_rollback_alloc_dinode_counts() forgets to provide journal
>    protection for modifying dinode.
> 2. ocfs2_block_group_alloc() & ocfs2_group_add() forget to provide
>    journal protection for writing fe->i_size.
> 3. adjusted journal_dirty scope for ocfs2_update_last_group_and_inode().
>    This adjustment ensures that only content requiring protection is
>    included in the journal.
> 

Any real issue you've found for above cases?

Take ocfs2_rollback_alloc_dinode_counts() for example, it will always be
pair used with ocfs2_alloc_dinode_update_counts(), more precisely, in
the error case of ocfs2_block_group_set_bits(). And the 'di_bh' is
already dirtied before. Since they are in the same transaction, I don't
see any problem here.

Thanks,
Joseph


> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
> ---
>  fs/ocfs2/move_extents.c |  2 +-
>  fs/ocfs2/resize.c       |  7 +++----
>  fs/ocfs2/suballoc.c     | 25 +++++++++++++++++--------
>  fs/ocfs2/suballoc.h     |  3 ++-
>  4 files changed, 23 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
> index 1f9ed117e78b..a631f9cf0c05 100644
> --- a/fs/ocfs2/move_extents.c
> +++ b/fs/ocfs2/move_extents.c
> @@ -687,7 +687,7 @@ static int ocfs2_move_extent(struct ocfs2_move_extents_context *context,
>  	ret = ocfs2_block_group_set_bits(handle, gb_inode, gd, gd_bh,
>  					 goal_bit, len);
>  	if (ret) {
> -		ocfs2_rollback_alloc_dinode_counts(gb_inode, gb_bh, len,
> +		ocfs2_rollback_alloc_dinode_counts(handle, gb_inode, gb_bh, len,
>  					       le16_to_cpu(gd->bg_chain));
>  		mlog_errno(ret);
>  	}
> diff --git a/fs/ocfs2/resize.c b/fs/ocfs2/resize.c
> index d65d43c61857..2c7e3548ae82 100644
> --- a/fs/ocfs2/resize.c
> +++ b/fs/ocfs2/resize.c
> @@ -143,15 +143,14 @@ static int ocfs2_update_last_group_and_inode(handle_t *handle,
>  		le32_add_cpu(&cr->c_free, -1 * backups);
>  		le32_add_cpu(&fe->id1.bitmap1.i_used, backups);
>  	}
> +	le64_add_cpu(&fe->i_size, (u64)new_clusters << osb->s_clustersize_bits);
> +	ocfs2_journal_dirty(handle, bm_bh);
>  
>  	spin_lock(&OCFS2_I(bm_inode)->ip_lock);
>  	OCFS2_I(bm_inode)->ip_clusters = le32_to_cpu(fe->i_clusters);
> -	le64_add_cpu(&fe->i_size, (u64)new_clusters << osb->s_clustersize_bits);
>  	spin_unlock(&OCFS2_I(bm_inode)->ip_lock);
>  	i_size_write(bm_inode, le64_to_cpu(fe->i_size));
>  
> -	ocfs2_journal_dirty(handle, bm_bh);
> -
>  out_rollback:
>  	if (ret < 0) {
>  		ocfs2_calc_new_backup_super(bm_inode,
> @@ -551,12 +550,12 @@ int ocfs2_group_add(struct inode *inode, struct ocfs2_new_group_input *input)
>  	le32_add_cpu(&fe->id1.bitmap1.i_used,
>  		     (input->clusters - input->frees) * cl_bpc);
>  	le32_add_cpu(&fe->i_clusters, input->clusters);
> +	le64_add_cpu(&fe->i_size, (u64)input->clusters << osb->s_clustersize_bits);
>  
>  	ocfs2_journal_dirty(handle, main_bm_bh);
>  
>  	spin_lock(&OCFS2_I(main_bm_inode)->ip_lock);
>  	OCFS2_I(main_bm_inode)->ip_clusters = le32_to_cpu(fe->i_clusters);
> -	le64_add_cpu(&fe->i_size, (u64)input->clusters << osb->s_clustersize_bits);
>  	spin_unlock(&OCFS2_I(main_bm_inode)->ip_lock);
>  	i_size_write(main_bm_inode, le64_to_cpu(fe->i_size));
>  
> diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
> index 166c8918c825..e1168db659df 100644
> --- a/fs/ocfs2/suballoc.c
> +++ b/fs/ocfs2/suballoc.c
> @@ -727,17 +727,16 @@ static int ocfs2_block_group_alloc(struct ocfs2_super *osb,
>  					le16_to_cpu(bg->bg_free_bits_count));
>  	le32_add_cpu(&fe->id1.bitmap1.i_total, le16_to_cpu(bg->bg_bits));
>  	le32_add_cpu(&fe->i_clusters, le16_to_cpu(cl->cl_cpg));
> -
> +	fe->i_size = cpu_to_le64(ocfs2_clusters_to_bytes(alloc_inode->i_sb,
> +					     le32_to_cpu(fe->i_clusters)));
>  	ocfs2_journal_dirty(handle, bh);
> +	ocfs2_update_inode_fsync_trans(handle, alloc_inode, 0);
>  
>  	spin_lock(&OCFS2_I(alloc_inode)->ip_lock);
>  	OCFS2_I(alloc_inode)->ip_clusters = le32_to_cpu(fe->i_clusters);
> -	fe->i_size = cpu_to_le64(ocfs2_clusters_to_bytes(alloc_inode->i_sb,
> -					     le32_to_cpu(fe->i_clusters)));
>  	spin_unlock(&OCFS2_I(alloc_inode)->ip_lock);
>  	i_size_write(alloc_inode, le64_to_cpu(fe->i_size));
>  	alloc_inode->i_blocks = ocfs2_inode_sector_count(alloc_inode);
> -	ocfs2_update_inode_fsync_trans(handle, alloc_inode, 0);
>  
>  	status = 0;
>  
> @@ -1601,19 +1600,28 @@ int ocfs2_alloc_dinode_update_counts(struct inode *inode,
>  	return ret;
>  }
>  
> -void ocfs2_rollback_alloc_dinode_counts(struct inode *inode,
> +void ocfs2_rollback_alloc_dinode_counts(handle_t *handle,
> +				       struct inode *inode,
>  				       struct buffer_head *di_bh,
>  				       u32 num_bits,
>  				       u16 chain)
>  {
> +	int ret;
>  	u32 tmp_used;
>  	struct ocfs2_dinode *di = (struct ocfs2_dinode *) di_bh->b_data;
>  	struct ocfs2_chain_list *cl;
>  
> +	ret = ocfs2_journal_access_di(handle, INODE_CACHE(inode), di_bh,
> +				      OCFS2_JOURNAL_ACCESS_WRITE);
> +	if (ret < 0) {
> +		mlog_errno(ret);
> +		return;
> +	}
>  	cl = (struct ocfs2_chain_list *)&di->id2.i_chain;
>  	tmp_used = le32_to_cpu(di->id1.bitmap1.i_used);
>  	di->id1.bitmap1.i_used = cpu_to_le32(tmp_used - num_bits);
>  	le32_add_cpu(&cl->cl_recs[chain].c_free, num_bits);
> +	ocfs2_journal_dirty(handle, di_bh);
>  }
>  
>  static int ocfs2_bg_discontig_fix_by_rec(struct ocfs2_suballoc_result *res,
> @@ -1717,7 +1725,8 @@ static int ocfs2_search_one_group(struct ocfs2_alloc_context *ac,
>  	ret = ocfs2_block_group_set_bits(handle, alloc_inode, gd, group_bh,
>  					 res->sr_bit_offset, res->sr_bits);
>  	if (ret < 0) {
> -		ocfs2_rollback_alloc_dinode_counts(alloc_inode, ac->ac_bh,
> +		ocfs2_rollback_alloc_dinode_counts(handle,
> +					       alloc_inode, ac->ac_bh,
>  					       res->sr_bits,
>  					       le16_to_cpu(gd->bg_chain));
>  		mlog_errno(ret);
> @@ -1851,7 +1860,7 @@ static int ocfs2_search_chain(struct ocfs2_alloc_context *ac,
>  					    res->sr_bit_offset,
>  					    res->sr_bits);
>  	if (status < 0) {
> -		ocfs2_rollback_alloc_dinode_counts(alloc_inode,
> +		ocfs2_rollback_alloc_dinode_counts(handle, alloc_inode,
>  					ac->ac_bh, res->sr_bits, chain);
>  		mlog_errno(status);
>  		goto bail;
> @@ -2165,7 +2174,7 @@ int ocfs2_claim_new_inode_at_loc(handle_t *handle,
>  					 res->sr_bit_offset,
>  					 res->sr_bits);
>  	if (ret < 0) {
> -		ocfs2_rollback_alloc_dinode_counts(ac->ac_inode,
> +		ocfs2_rollback_alloc_dinode_counts(handle, ac->ac_inode,
>  					       ac->ac_bh, res->sr_bits, chain);
>  		mlog_errno(ret);
>  		goto out;
> diff --git a/fs/ocfs2/suballoc.h b/fs/ocfs2/suballoc.h
> index 9c74eace3adc..0c56ddce0752 100644
> --- a/fs/ocfs2/suballoc.h
> +++ b/fs/ocfs2/suballoc.h
> @@ -75,7 +75,8 @@ int ocfs2_alloc_dinode_update_counts(struct inode *inode,
>  			 struct buffer_head *di_bh,
>  			 u32 num_bits,
>  			 u16 chain);
> -void ocfs2_rollback_alloc_dinode_counts(struct inode *inode,
> +void ocfs2_rollback_alloc_dinode_counts(handle_t *handle,
> +			 struct inode *inode,
>  			 struct buffer_head *di_bh,
>  			 u32 num_bits,
>  			 u16 chain);
