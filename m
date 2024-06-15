Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6423E1396
	for <ocfs2-devel@lists.linux.dev>; Sat, 15 Jun 2024 01:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718416574; cv=none; b=XidJmpwG8lsriiXUfh+3y96FnR8G3BVFHtvRela9kBYqrZDgY8HOOgfGiRmMS+T4VXmfMxGusdpAOvUDrhVuSfPIJzku5QgGHnm5+4X0wImraMBEsa4vnT3MrrT8id7xhjBDG+pVjaRJpsYuiZyKSHcb4cdMKrBYI08y7528yA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718416574; c=relaxed/simple;
	bh=btpwMCaZYqjBJXKKWesPMKsIjdi9z1A3+bz3ZX4jOd4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=b/pLRkVfsVcZP3pY3mhjxhv0Gco/Iim2k4YLAioNMp3fPHnpCaku0WrETRcsjzwFuNKbGSg/0B6+Z6OXZ/973L+h/XYH+9GygGUFkyKFADs4rFrI9RKpAAs6KsH07s/vMRDEFNkM84egxwgQm4/Tc7jg7UDDCkwZ3OaZ3WAlmP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=NUY2UFBQ; arc=none smtp.client-ip=115.124.30.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="NUY2UFBQ"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1718416568; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=GsU6LAfBKeviD8SMjhUibsN//hTcilE9RsctzEK2pmc=;
	b=NUY2UFBQO5ih8HZFhyuqi9/115MlEo7ujgLhxMHv6JRivX4QGZjrEbKQQQplJpO2fGnuBIM0qHbxpl+mZ0PhnCTXYTDmNLlwpDCyv4CjnHENyWxstHpb6iC6oIkDe8RtyUpmS7ka5sseX4O6IsfhH60n0s8NtzQiCTTqu+h1bEQ=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037067112;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0W8SIhWO_1718416566;
Received: from 30.32.103.198(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0W8SIhWO_1718416566)
          by smtp.aliyun-inc.com;
          Sat, 15 Jun 2024 09:56:07 +0800
Message-ID: <4689296d-99c3-4e73-a13d-ea4ac7ec243b@linux.alibaba.com>
Date: Sat, 15 Jun 2024 09:56:06 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: Fix DIO failure due to insufficient transaction
 credits
To: Jan Kara <jack@suse.cz>, akpm <akpm@linux-foundation.org>
Cc: ocfs2-devel@lists.linux.dev, Joel Becker <jlbec@evilplan.org>,
 Mark Fasheh <mark@fasheh.com>, Heming Zhao <heming.zhao@suse.com>
References: <20240614145243.8837-1-jack@suse.cz>
Content-Language: en-US
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20240614145243.8837-1-jack@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 6/14/24 10:52 PM, Jan Kara wrote:
> The code in ocfs2_dio_end_io_write() estimates number of necessary
> transaction credits using ocfs2_calc_extend_credits(). This however does
> not take into account that the IO could be arbitrarily large and can
> contain arbitrary number of extents. Extent tree manipulations do often
> extend the current transaction but not in all of the cases. For example
> if we have only single block extents in the tree,
> ocfs2_mark_extent_written() will end up calling
> ocfs2_replace_extent_rec() all the time and we will never extend the
> current transaction and eventually exhaust all the transaction credits
> if the IO contains many single block extents. Make sure the transaction
> always has enough credits for one extent insert before each call of
> ocfs2_mark_extent_written().
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Looks good.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
>  fs/ocfs2/aops.c        |  5 +++++
>  fs/ocfs2/journal.c     | 17 +++++++++++++++++
>  fs/ocfs2/journal.h     |  2 ++
>  fs/ocfs2/ocfs2_trace.h |  2 ++
>  4 files changed, 26 insertions(+)
> 
> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
> index ba790219d528..f4d7c0675651 100644
> --- a/fs/ocfs2/aops.c
> +++ b/fs/ocfs2/aops.c
> @@ -2371,6 +2371,11 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
>  	}
>  
>  	list_for_each_entry(ue, &dwc->dw_zero_list, ue_node) {
> +		ret = ocfs2_assure_trans_credits(handle, credits);
> +		if (ret < 0) {
> +			mlog_errno(ret);
> +			break;
> +		}
>  		ret = ocfs2_mark_extent_written(inode, &et, handle,
>  						ue->ue_cpos, 1,
>  						ue->ue_phys,
> diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
> index 604fea3a26ff..4866d7d3ac57 100644
> --- a/fs/ocfs2/journal.c
> +++ b/fs/ocfs2/journal.c
> @@ -445,6 +445,23 @@ int ocfs2_extend_trans(handle_t *handle, int nblocks)
>  	return status;
>  }
>  
> +/*
> + * Make sure handle has at least 'nblocks' credits available. If it does not
> + * have that many credits available, we will try to extend the handle to have
> + * enough credits. If that fails, we will restart transaction to have enough
> + * credits. Similar notes regarding data consistency and locking implications
> + * as for ocfs2_extend_trans() apply here.
> + */
> +int ocfs2_assure_trans_credits(handle_t *handle, int nblocks)
> +{
> +	int old_nblks = jbd2_handle_buffer_credits(handle);
> +
> +	trace_ocfs2_assure_trans_credits(old_nblks);
> +	if (old_nblks >= nblocks)
> +		return 0;
> +	return ocfs2_extend_trans(handle, nblocks - old_nblks);
> +}
> +
>  /*
>   * If we have fewer than thresh credits, extend by OCFS2_MAX_TRANS_DATA.
>   * If that fails, restart the transaction & regain write access for the
> diff --git a/fs/ocfs2/journal.h b/fs/ocfs2/journal.h
> index 41c9fe7e62f9..e3c3a35dc5e0 100644
> --- a/fs/ocfs2/journal.h
> +++ b/fs/ocfs2/journal.h
> @@ -243,6 +243,8 @@ handle_t		    *ocfs2_start_trans(struct ocfs2_super *osb,
>  int			     ocfs2_commit_trans(struct ocfs2_super *osb,
>  						handle_t *handle);
>  int			     ocfs2_extend_trans(handle_t *handle, int nblocks);
> +int			     ocfs2_assure_trans_credits(handle_t *handle,
> +						int nblocks);
>  int			     ocfs2_allocate_extend_trans(handle_t *handle,
>  						int thresh);
>  
> diff --git a/fs/ocfs2/ocfs2_trace.h b/fs/ocfs2/ocfs2_trace.h
> index ac4fd1d5b128..6c3f4d7df7d6 100644
> --- a/fs/ocfs2/ocfs2_trace.h
> +++ b/fs/ocfs2/ocfs2_trace.h
> @@ -2579,6 +2579,8 @@ DEFINE_OCFS2_ULL_UINT_EVENT(ocfs2_commit_cache_end);
>  
>  DEFINE_OCFS2_INT_INT_EVENT(ocfs2_extend_trans);
>  
> +DEFINE_OCFS2_INT_EVENT(ocfs2_assure_trans_credits);
> +
>  DEFINE_OCFS2_INT_EVENT(ocfs2_extend_trans_restart);
>  
>  DEFINE_OCFS2_INT_INT_EVENT(ocfs2_allocate_extend_trans);
