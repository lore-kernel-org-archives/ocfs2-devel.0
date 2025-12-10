Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C14E7260F
	for <ocfs2-devel@lists.linux.dev>; Wed, 10 Dec 2025 01:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765331717; cv=none; b=eOyxyEx0Wb0V44IGAX0MGMNb3x9d20jvbxiPXn3kU2mI0o5ACnkhMq3uJZw4BRhrye7TDkSr57W65MLFt5NjnXdPw+8p6Xxl9Mh23GydlkuJBptryLdmaDLH8pidTReBsd4Nsn+xALQiOv/SDdv25uj48x8zNOdIIon604Hc5a4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765331717; c=relaxed/simple;
	bh=zADPUiySYeb31KI98vj+YGUwMaoXsX73VNHvEZ+56BY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bIz3RsRpd0crmyuHG9IhPN2nG5gOK/Mc8/EU794x/fy7xgzrW0faaMfWX0mvnLGXnT8ApiLcnzWUMoK1X4EZ3ygTKf2rbR5/s2FVPMahW3+GJ3WsRGxnSAvql7RtcvLlrC7uD/BBr5G02UY8XdVfMNfiwfEkraJj2AIYYdolRqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=X9XVqz2f; arc=none smtp.client-ip=115.124.30.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="X9XVqz2f"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1765331704; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=ITs/5L2ORyxeRn0yiVHP1f3lZb6YagXm0ecPAj3NPJQ=;
	b=X9XVqz2fP8qUksPH+IXvq/UAV2jB8TMD+oIbVwPsO4fc8Uf6Dm4LUiVEEO4JGdTTC6l2dTJGhAmf+rlKo0fE71tOPCEVcIEIE0tm7YhKXYU7AYuK4uEGkKKvHKxvaOizCw7c0RRbwQCoSzyOX05LWrbaZSeqBpx9wdYpNQ1KpNI=
Received: from 30.221.145.92(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WuUc16w_1765331703 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 10 Dec 2025 09:55:03 +0800
Message-ID: <86fe3ab7-943d-415f-822d-ffa2e7c18640@linux.alibaba.com>
Date: Wed, 10 Dec 2025 09:55:03 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RESEND v4 2/2] ocfs2: detect released suballocator BG for
 fh_to_[dentry|parent]
To: Heming Zhao <heming.zhao@suse.com>, mark@fasheh.com, jlbec@evilplan.org
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 glass.su@suse.com
References: <20251202063938.9046-1-heming.zhao@suse.com>
 <20251202063938.9046-3-heming.zhao@suse.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20251202063938.9046-3-heming.zhao@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2025/12/2 14:39, Heming Zhao wrote:
> After ocfs2 gained the ability to reclaim suballocator free block
> group (BGs), a suballocator block group may be released. This change
> causes the xfstest case generic/426 to fail.
> 
> generic/426 expects return value -ENOENT or -ESTALE, but the current
> code triggers -EROFS.
> 
> Call stack before ocfs2 gained the ability to reclaim bg:
> 
> ocfs2_fh_to_dentry //or ocfs2_fh_to_parent
>  ocfs2_get_dentry
>   + ocfs2_test_inode_bit
>   |  ocfs2_test_suballoc_bit
>   |   + ocfs2_read_group_descriptor //Since ocfs2 never releases the bg,
>   |   |                             //the bg block was always found.
>   |   + *res = ocfs2_test_bit //unlink was called, and the bit is zero
>   |
>   + if (!set) //because the above *res is 0
>      status = -ESTALE //the generic/426 expected return value
> 
> Current call stack that triggers -EROFS:
> 
> ocfs2_get_dentry
>  ocfs2_test_inode_bit
>   ocfs2_test_suballoc_bit
>    ocfs2_read_group_descriptor
>     + if reading a released bg, validation fails and triggers -EROFS
> 
> How to fix:
> Since the read BG is already released, we must avoid triggering -EROFS.
> With this commit, we use ocfs2_read_hint_group_descriptor() to detect
> the released BG block. This approach quietly handles this type of error
> and returns -EINVAL, which triggers the caller's existing conversion
> path to -ESTALE.
> 
> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
> Reviewed-by: Su Yue <glass.su@suse.com>
> ---
>  fs/ocfs2/suballoc.c | 28 ++++++++++++++++++----------
>  1 file changed, 18 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
> index de2f09217142..a126d83ddb1c 100644
> --- a/fs/ocfs2/suballoc.c
> +++ b/fs/ocfs2/suballoc.c
> @@ -3152,7 +3152,7 @@ static int ocfs2_test_suballoc_bit(struct ocfs2_super *osb,
>  	struct ocfs2_group_desc *group;
>  	struct buffer_head *group_bh = NULL;
>  	u64 bg_blkno;
> -	int status;
> +	int status, quiet = 0, released;
>  
>  	trace_ocfs2_test_suballoc_bit((unsigned long long)blkno,
>  				      (unsigned int)bit);
> @@ -3168,11 +3168,15 @@ static int ocfs2_test_suballoc_bit(struct ocfs2_super *osb,
>  
>  	bg_blkno = group_blkno ? group_blkno :
>  		   ocfs2_which_suballoc_group(blkno, bit);
> -	status = ocfs2_read_group_descriptor(suballoc, alloc_di, bg_blkno,
> -					     &group_bh);
> -	if (status < 0) {
> +	status = ocfs2_read_hint_group_descriptor(suballoc, alloc_di, bg_blkno,
> +					     &group_bh, &released);
> +	if (released) {
> +		quiet = 1;
> +		status = -EINVAL;
> +		goto bail;
> +	} else if (status < 0) {
>  		mlog(ML_ERROR, "read group %llu failed %d\n",
> -		     (unsigned long long)bg_blkno, status);
> +				(unsigned long long)bg_blkno, status);
>  		goto bail;
>  	}
>  
> @@ -3182,7 +3186,7 @@ static int ocfs2_test_suballoc_bit(struct ocfs2_super *osb,
>  bail:
>  	brelse(group_bh);
>  
> -	if (status)
> +	if (status && (!quiet))
>  		mlog_errno(status);
>  	return status;
>  }
> @@ -3202,7 +3206,7 @@ static int ocfs2_test_suballoc_bit(struct ocfs2_super *osb,
>   */
>  int ocfs2_test_inode_bit(struct ocfs2_super *osb, u64 blkno, int *res)
>  {
> -	int status;
> +	int status, quiet = 0;
>  	u64 group_blkno = 0;
>  	u16 suballoc_bit = 0, suballoc_slot = 0;
>  	struct inode *inode_alloc_inode;
> @@ -3244,8 +3248,12 @@ int ocfs2_test_inode_bit(struct ocfs2_super *osb, u64 blkno, int *res)
>  
>  	status = ocfs2_test_suballoc_bit(osb, inode_alloc_inode, alloc_bh,
>  					 group_blkno, blkno, suballoc_bit, res);
> -	if (status < 0)
> -		mlog(ML_ERROR, "test suballoc bit failed %d\n", status);
> +	if (status < 0) {
> +		if (status == -EINVAL)

This seems not right, since there is other case which will also return -EINVAL.
So how about return -ESTALE in this case?

Thanks,
Joseph

> +			quiet = 1;
> +		else
> +			mlog(ML_ERROR, "test suballoc bit failed %d\n", status);
> +	}
>  
>  	ocfs2_inode_unlock(inode_alloc_inode, 0);
>  	inode_unlock(inode_alloc_inode);
> @@ -3253,7 +3261,7 @@ int ocfs2_test_inode_bit(struct ocfs2_super *osb, u64 blkno, int *res)
>  	iput(inode_alloc_inode);
>  	brelse(alloc_bh);
>  bail:
> -	if (status)
> +	if (status && !quiet)
>  		mlog_errno(status);
>  	return status;
>  }

