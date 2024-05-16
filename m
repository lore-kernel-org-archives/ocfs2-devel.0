Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 234E010E3
	for <ocfs2-devel@lists.linux.dev>; Thu, 16 May 2024 01:25:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.113
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715822735; cv=none; b=nKuooL5F+wmXEmb7TLK75/xnthptSpiT3VuN7p3ZYCVZvfJRYG1m8MaTRFIag5gBMbxAWrraEcvGh6ft75ctTmQA2GRWU/2Kg7FsqubsPR6MuQ9UIolXgX9q1LR+aQacx0NaKhT6hDALOBFd9i795T2PXnGxFPzvwFjCnAojS9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715822735; c=relaxed/simple;
	bh=hzGJgKulpQX2J2VYQHpmUzBVbITwBgGfAjtKWVSlGtc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ae5P4G4jzRbVAXXl9KW6aVOz8iI7syXlSuyj1ogGAE3JQ7L4kiPs6fM4yKFwcb1BHz7l/rpIrp6EET+bmrY+p+ft/qPpo2/ZT8vnTqUse5L8NeWVn8oW24d9iHz2/OyT1m9sWMNqLtt/rI/Td1k6LHJZHofqWxITDkG+c20TV5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=F2oPCACP; arc=none smtp.client-ip=115.124.30.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="F2oPCACP"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1715822729; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=r1isWmBJiUBnwSRE2U9rv0XS6h/F0ZDmTQNKcWxVn5Q=;
	b=F2oPCACPYhtw+uLLugQdtK3KmK9Vd6VNmzP/rMwGVIpwffNS/I26b9raAY1AXfQzBljkvOD9Gp1SDm5XV9cNktfnIA8UfMu129Rt9KTCoo9BA6XTVndu4xDMNA7onoLr7mnXPAN7dgcVCOItCqIgzowxXtuBxoEdrWc3L92aGvg=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R411e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037067112;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0W6ZBgVk_1715822726;
Received: from 30.221.128.154(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0W6ZBgVk_1715822726)
          by smtp.aliyun-inc.com;
          Thu, 16 May 2024 09:25:28 +0800
Message-ID: <cb1d3df4-db34-447d-b265-e4fad5a1fe7f@linux.alibaba.com>
Date: Thu, 16 May 2024 09:25:26 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] ocfs2: add bounds checking to
 ocfs2_xattr_find_entry()
To: Ferry Meng <mengferry@linux.alibaba.com>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, ocfs2-devel@lists.linux.dev
Cc: linux-kernel@vger.kernel.org
References: <20240515132934.69511-1-mengferry@linux.alibaba.com>
 <20240515132934.69511-2-mengferry@linux.alibaba.com>
Content-Language: en-US
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20240515132934.69511-2-mengferry@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 5/15/24 9:29 PM, Ferry Meng wrote:
> Just add redundant (perhaps paranoia) checks to make sure it doesn't
> stray beyond valid meory region of ocfs2 xattr entry array during a
> single match.
> 
> Maybe this patch can prevent some crash caused by crafted poison images.
> 

I'd rather restructure the commit message as below:

Add a paranoia check to make sure it doesn't stray beyond valid memory
region containing ocfs2 xattr entries when scanning for a match.
It will prevent out-of-bound access in case of crafted images.

> Signed-off-by: Ferry Meng <mengferry@linux.alibaba.com>
> ---
>  fs/ocfs2/xattr.c | 14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
> index 3b81213ed7b8..37be4a286faf 100644
> --- a/fs/ocfs2/xattr.c
> +++ b/fs/ocfs2/xattr.c
> @@ -1062,8 +1062,8 @@ ssize_t ocfs2_listxattr(struct dentry *dentry,
>  	return i_ret + b_ret;
>  }
>  
> -static int ocfs2_xattr_find_entry(int name_index,
> -				  const char *name,
> +static int ocfs2_xattr_find_entry(struct inode *inode, void *end,

'end' can be obtained from ocfs2_xattr_search directly.

Thanks,
Joseph

> +				  int name_index, const char *name,
>  				  struct ocfs2_xattr_search *xs)
>  {
>  	struct ocfs2_xattr_entry *entry;
> @@ -1076,6 +1076,10 @@ static int ocfs2_xattr_find_entry(int name_index,
>  	name_len = strlen(name);
>  	entry = xs->here;
>  	for (i = 0; i < le16_to_cpu(xs->header->xh_count); i++) {
> +		if ((void *)entry >= end) {
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
> +	ret = ocfs2_xattr_find_entry(inode, xs->end, name_index, name, xs);
>  	if (ret)
>  		return ret;
>  	size = le64_to_cpu(xs->here->xe_value_size);
> @@ -2698,7 +2702,7 @@ static int ocfs2_xattr_ibody_find(struct inode *inode,
>  
>  	/* Find the named attribute. */
>  	if (oi->ip_dyn_features & OCFS2_INLINE_XATTR_FL) {
> -		ret = ocfs2_xattr_find_entry(name_index, name, xs);
> +		ret = ocfs2_xattr_find_entry(inode, xs->end, name_index, name, xs);
>  		if (ret && ret != -ENODATA)
>  			return ret;
>  		xs->not_found = ret;
> @@ -2833,7 +2837,7 @@ static int ocfs2_xattr_block_find(struct inode *inode,
>  		xs->end = (void *)(blk_bh->b_data) + blk_bh->b_size;
>  		xs->here = xs->header->xh_entries;
>  
> -		ret = ocfs2_xattr_find_entry(name_index, name, xs);
> +		ret = ocfs2_xattr_find_entry(inode, xs->end, name_index, name, xs);
>  	} else
>  		ret = ocfs2_xattr_index_block_find(inode, blk_bh,
>  						   name_index,
