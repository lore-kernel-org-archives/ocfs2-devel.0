Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13DFC33F6
	for <ocfs2-devel@lists.linux.dev>; Fri, 17 May 2024 10:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715943165; cv=none; b=n1GobTaZfQ9dO56947Q4m5UjzPl6oVFmNk9dnh6vr3wk5du/IeKT1fE8GVfJOC1H70oM5/eDJd/496lOtWT9Fbad+FNxkvyHvNLIgEsLNXAOC4MbgLx44COcuzGX+ZFCcCF807yTVmP3NMceCnf0R4B7S0m/P88iYWOKFFiA744=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715943165; c=relaxed/simple;
	bh=JDqGBD0D5kpmPykpBr4kW+JyQRNpCrU3OX4bPh5dBfA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IR1bns+Snx3uZ17yIHxrwvYNrHcELr3Ls2BhySUK6a7ALmixv/4oLkHSFbaLoL9myogZl7QsqzK5QFFpsPRM5k3jR4RXbNNi8CWLGe9G7/km9FxNiIcWH6wCJR6Yo78RRuatho1EcnGvdkp6KzJBJFxX2YTeFnHg5Q+V38q30UI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=wLhrP9ND; arc=none smtp.client-ip=115.124.30.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="wLhrP9ND"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1715943158; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=XHU484ru7u5dgmBpXpNyU6IxS0QHgLQgPSB3Je2RxDQ=;
	b=wLhrP9ND8dr8jU33OneiiRxYyPHBXACz6y+35TtLckK/BoP82D65aMHXtysklcGkznhsctSx5s5S15Y+oTBmSzfyLSG1XsoNBY94IGHm+xB9Ewo0LMcDkzGj+amQF4MOkaD8/Dg0ULuktXr8wsUMENmHK4FYq9dW9KNCI74NYDA=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037067112;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0W6eXBwH_1715943155;
Received: from 30.221.128.140(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0W6eXBwH_1715943155)
          by smtp.aliyun-inc.com;
          Fri, 17 May 2024 18:52:36 +0800
Message-ID: <1b906ebc-a850-4974-8ceb-e33d88768bf1@linux.alibaba.com>
Date: Fri, 17 May 2024 18:52:34 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] ocfs2: add bounds checking to
 ocfs2_xattr_find_entry()
To: Ferry Meng <mengferry@linux.alibaba.com>, lei lu <llfamsec@gmail.com>,
 akpm <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, ocfs2-devel@lists.linux.dev
References: <20240517094147.87133-1-mengferry@linux.alibaba.com>
 <20240517094147.87133-2-mengferry@linux.alibaba.com>
Content-Language: en-US
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20240517094147.87133-2-mengferry@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 5/17/24 5:41 PM, Ferry Meng wrote:
> Add a paranoia check to make sure it doesn't stray beyond valid memory
> region containing ocfs2 xattr entries when scanning for a match.
> It will prevent out-of-bound access in case of crafted images.
> 
> Signed-off-by: Ferry Meng <mengferry@linux.alibaba.com>

Reported-by: lei lu <llfamsec@gmail.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
>  fs/ocfs2/xattr.c | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
> index 3b81213ed7b8..8aea94c90739 100644
> --- a/fs/ocfs2/xattr.c
> +++ b/fs/ocfs2/xattr.c
> @@ -1062,7 +1062,7 @@ ssize_t ocfs2_listxattr(struct dentry *dentry,
>  	return i_ret + b_ret;
>  }
>  
> -static int ocfs2_xattr_find_entry(int name_index,
> +static int ocfs2_xattr_find_entry(struct inode *inode, int name_index,
>  				  const char *name,
>  				  struct ocfs2_xattr_search *xs)
>  {
> @@ -1076,6 +1076,10 @@ static int ocfs2_xattr_find_entry(int name_index,
>  	name_len = strlen(name);
>  	entry = xs->here;
>  	for (i = 0; i < le16_to_cpu(xs->header->xh_count); i++) {
> +		if ((void *)entry >= xs->end) {
> +			ocfs2_error(inode->i_sb, "corrupted xattr entries");
> +			return -EFSCORRUPTED;
> +		}
>  		cmp = name_index - ocfs2_xattr_get_type(entry);
>  		if (!cmp)
>  			cmp = name_len - entry->xe_name_len;
> @@ -1166,7 +1170,7 @@ static int ocfs2_xattr_ibody_get(struct inode *inode,
>  	xs->base = (void *)xs->header;
>  	xs->here = xs->header->xh_entries;
>  
> -	ret = ocfs2_xattr_find_entry(name_index, name, xs);
> +	ret = ocfs2_xattr_find_entry(inode, name_index, name, xs);
>  	if (ret)
>  		return ret;
>  	size = le64_to_cpu(xs->here->xe_value_size);
> @@ -2698,7 +2702,7 @@ static int ocfs2_xattr_ibody_find(struct inode *inode,
>  
>  	/* Find the named attribute. */
>  	if (oi->ip_dyn_features & OCFS2_INLINE_XATTR_FL) {
> -		ret = ocfs2_xattr_find_entry(name_index, name, xs);
> +		ret = ocfs2_xattr_find_entry(inode, name_index, name, xs);
>  		if (ret && ret != -ENODATA)
>  			return ret;
>  		xs->not_found = ret;
> @@ -2833,7 +2837,7 @@ static int ocfs2_xattr_block_find(struct inode *inode,
>  		xs->end = (void *)(blk_bh->b_data) + blk_bh->b_size;
>  		xs->here = xs->header->xh_entries;
>  
> -		ret = ocfs2_xattr_find_entry(name_index, name, xs);
> +		ret = ocfs2_xattr_find_entry(inode, name_index, name, xs);
>  	} else
>  		ret = ocfs2_xattr_index_block_find(inode, blk_bh,
>  						   name_index,
