Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF4B72BEC5E
	for <ocfs2-devel@lists.linux.dev>; Mon, 11 May 2026 06:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778481226; cv=none; b=DGLPAGg5hjjB8eGjOQqV6k7jaK4kEpZDTJtKnkBgk63q83OV/T0KSegXfbY084wvH4HXMEgrzOF3UhmqcU8pwho5zFeE/xllQlk5bfEJiK3qv5ZWm1MSrFrLxNVwdtPrqHxOqhsB7qNehRJZ1HtAHPnknchmilojTnaL8LrpU3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778481226; c=relaxed/simple;
	bh=DVIz6iPe+PYd8uUvYXRX0u8Wf3K4/P8j/o9/XMN156w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YyC3T93yr1OCca1dNArIrd1nslF/CSN6t/aj/l2ixPObbIv1hfzfHF/6989YpQLplxTqE371SWD0ju8eM3Takg1273DV7B70hKGkBUhCQbs7JT/3qbz9HNP6FCzWSFccmLOXKowwR8GfWHRn2CCCHanVE6jysNaIz/cKXpDIC1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=LDTegoH5; arc=none smtp.client-ip=115.124.30.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="LDTegoH5"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1778481216; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=SbUWWwN7uQ69QLrVhUi0dvjI2Oi3amyZ3mUVMhb0h3I=;
	b=LDTegoH5mYPDqOWtG6woGt1qfSMR90B+2Fbal1ryW6ds4tjADX4CJ89zks2VR8MghfIpms41aHV+fCOZDtuCtKzZzk4s7N8uYrI24rHMnduoUdwm5MY11ueh0eopnqqWetCXWUGOwebFPEmicJWcH6OjW96FO8R2rEVvAH41/M4=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0X2ewNib_1778481215;
Received: from 30.221.128.206(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X2ewNib_1778481215 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 11 May 2026 14:33:35 +0800
Message-ID: <cadec5cd-2e34-4f47-8bff-88f51531a45d@linux.alibaba.com>
Date: Mon, 11 May 2026 14:33:34 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/5] ocfs2: validate inline xattr header before inline
 refcount attach
To: ZhengYuan Huang <gality369@gmail.com>, akpm <akpm@linux-foundation.org>
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 baijiaju1990@gmail.com, r33s3n6@gmail.com, zzzccc427@gmail.com,
 Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>
References: <20260508085914.61647-1-gality369@gmail.com>
 <20260508085914.61647-5-gality369@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260508085914.61647-5-gality369@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 5/8/26 4:59 PM, ZhengYuan Huang wrote:
> [BUG]
> A corrupt inline xattr header can make ocfs2_xattr_inline_attach_refcount()
> feed an unchecked header into the refcount-attachment walk for inline
> xattr values.
> 
> [CAUSE]
> The inline refcount-attach path still derived the header directly from
> di->i_xattr_inline_size and then passed it to code that iterates xh_count
> and xattr entries.
> 
> [FIX]
> Use the shared ibody header helper before attaching refcounts to inline
> xattr values so corrupt header geometry is rejected with -EFSCORRUPTED
> instead of being traversed.
> 
> Signed-off-by: ZhengYuan Huang <gality369@gmail.com>

Looks fine.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
>  fs/ocfs2/xattr.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
> index bbb25a01b097..4877406a83ce 100644
> --- a/fs/ocfs2/xattr.c
> +++ b/fs/ocfs2/xattr.c
> @@ -6016,14 +6016,17 @@ static int ocfs2_xattr_inline_attach_refcount(struct inode *inode,
>  				struct ocfs2_cached_dealloc_ctxt *dealloc)
>  {
>  	struct ocfs2_dinode *di = (struct ocfs2_dinode *)fe_bh->b_data;
> -	struct ocfs2_xattr_header *header = (struct ocfs2_xattr_header *)
> -				(fe_bh->b_data + inode->i_sb->s_blocksize -
> -				le16_to_cpu(di->i_xattr_inline_size));
> +	struct ocfs2_xattr_header *header;
> +	int ret;
>  	struct ocfs2_xattr_value_buf vb = {
>  		.vb_bh = fe_bh,
>  		.vb_access = ocfs2_journal_access_di,
>  	};
>  
> +	ret = ocfs2_xattr_ibody_lookup_header(inode, di, &header);
> +	if (ret)
> +		return ret;
> +
>  	return ocfs2_xattr_attach_refcount_normal(inode, &vb, header,
>  						  ref_ci, ref_root_bh, dealloc);
>  }

