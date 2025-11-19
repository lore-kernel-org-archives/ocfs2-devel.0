Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 853F22BEC52
	for <ocfs2-devel@lists.linux.dev>; Wed, 19 Nov 2025 05:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763530400; cv=none; b=RDIbR6u14aaS0UUTtGADGP9WmL8AHlffqrTuxdZ/j2xNHaUjccLt5B2cRkcR4QkFhOTC/AH/lliDtnIgGwl9/8z23sGd5Cb8bM/tXQuC+E3OaYAIDuiXjPTL0+3I8OVJ7P0sFH1sS3nFLgXgeZWaktB0rvkfb90oW6hXV9d1yZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763530400; c=relaxed/simple;
	bh=HwcMCOLPLUVzvHw1ftLxtyVeBzsKAPEpsJrFZ7H0vnY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Y4v5k91UpSvymSudxnT7NjwHFjj1iA5ClB4ocIPNHWEN/F2eUnvBFYbJNSTai+b7rjrLRImsci4NZNl5iYZZJmMBlRfNwCI/L9GV+EoxrO0bMFgvuTfK/iFIUJACCG2YEtJHZszd6WklON3xCHWE+hmJgByTpJNbNwJz2DWIX7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=JhRmzFXl; arc=none smtp.client-ip=115.124.30.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="JhRmzFXl"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1763530396; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=OPpeYGV9kHe9pmS+7GQP54XxjrAj/p+tK3/BK11f974=;
	b=JhRmzFXlI11Ds1jQ1jGASLemHerivLVobD9tLXP7Bi62U1VgBOfVaOqiOzWrpPVDm9q7gzHnOZlTJiOn+Sryk+ljNKXkdXEb85WLux+tKD8t4r4W6BGgXiNKtrckbIRieT3aaRF898B5iTXaBl8eldfWkQg1uFEfuSkKHutvKKY=
Received: from 30.48.68.216(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WsnC7lt_1763530395 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 19 Nov 2025 13:33:15 +0800
Message-ID: <ee0a75f2-6090-4dd9-8a95-575fdd859dc3@linux.alibaba.com>
Date: Wed, 19 Nov 2025 13:33:14 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] ocfs2: Replace deprecated strcpy with strscpy
To: Thorsten Blum <thorsten.blum@linux.dev>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, akpm <akpm@linux-foundation.org>
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20251118185345.132411-2-thorsten.blum@linux.dev>
 <20251118185345.132411-3-thorsten.blum@linux.dev>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20251118185345.132411-3-thorsten.blum@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2025/11/19 02:53, Thorsten Blum wrote:
> strcpy() has been deprecated [1] because it performs no bounds checking
> on the destination buffer, which can lead to buffer overflows. Replace
> it with the safer strscpy(), and copy directly into '->rf_signature'
> instead of using the start of the struct as the destination buffer.
> 
> Link: https://www.kernel.org/doc/html/latest/process/deprecated.html#strcpy [1]
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>

Looks fine.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
>  fs/ocfs2/refcounttree.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
> index 267b50e8e42e..c92e0ea85bca 100644
> --- a/fs/ocfs2/refcounttree.c
> +++ b/fs/ocfs2/refcounttree.c
> @@ -34,6 +34,7 @@
>  #include <linux/pagevec.h>
>  #include <linux/swap.h>
>  #include <linux/security.h>
> +#include <linux/string.h>
>  #include <linux/fsnotify.h>
>  #include <linux/quotaops.h>
>  #include <linux/namei.h>
> @@ -621,7 +622,7 @@ static int ocfs2_create_refcount_tree(struct inode *inode,
>  	/* Initialize ocfs2_refcount_block. */
>  	rb = (struct ocfs2_refcount_block *)new_bh->b_data;
>  	memset(rb, 0, inode->i_sb->s_blocksize);
> -	strcpy((void *)rb, OCFS2_REFCOUNT_BLOCK_SIGNATURE);
> +	strscpy(rb->rf_signature, OCFS2_REFCOUNT_BLOCK_SIGNATURE);
>  	rb->rf_suballoc_slot = cpu_to_le16(meta_ac->ac_alloc_slot);
>  	rb->rf_suballoc_loc = cpu_to_le64(suballoc_loc);
>  	rb->rf_suballoc_bit = cpu_to_le16(suballoc_bit_start);
> @@ -1562,7 +1563,7 @@ static int ocfs2_new_leaf_refcount_block(handle_t *handle,
>  	/* Initialize ocfs2_refcount_block. */
>  	new_rb = (struct ocfs2_refcount_block *)new_bh->b_data;
>  	memset(new_rb, 0, sb->s_blocksize);
> -	strcpy((void *)new_rb, OCFS2_REFCOUNT_BLOCK_SIGNATURE);
> +	strscpy(new_rb->rf_signature, OCFS2_REFCOUNT_BLOCK_SIGNATURE);
>  	new_rb->rf_suballoc_slot = cpu_to_le16(meta_ac->ac_alloc_slot);
>  	new_rb->rf_suballoc_loc = cpu_to_le64(suballoc_loc);
>  	new_rb->rf_suballoc_bit = cpu_to_le16(suballoc_bit_start);

