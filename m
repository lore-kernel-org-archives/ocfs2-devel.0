Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A2C2225403
	for <ocfs2-devel@lists.linux.dev>; Wed, 19 Nov 2025 05:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763530306; cv=none; b=p9LYDtWiIuWL7eMtzHeuy8/YGMVih68KV9mU5uQWDrC0sJV62ADtvP85JYaEGQSSARGW39XG88QuI1Lj/k01/AN8vmwNGz3NRy+Y6PDyttPY6T7ta2JTXESwVUOgEQhkurj8Xzgw8bgu5LIUPKaywZW+KdT96nBBajLw+7zvk5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763530306; c=relaxed/simple;
	bh=ka2OgEnDU7Wte8PtPwaUUNa9lFMwe739sfHJLS1xLzI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iVO/Lfu4VZokxWXaG7JbLyvvxNEMiP9aHbga5u3OK/BRN5yD5grLrsHo6z6P/DU7viXmho3Pu1Vhr4z5m9zODebth+j/TL80dAEenHgzuLCDtg8q4bbmfWfTprHbXvehgZpL3MgbExAaVdtpRNKeZwv4BRo3sVv8QlCnekgnn2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=GAjKJCWX; arc=none smtp.client-ip=115.124.30.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="GAjKJCWX"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1763530300; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=Qe3dQ2UHFHxESIiSWjW0J+5CK973VIZO0Gc9FbyFayY=;
	b=GAjKJCWXR4mLuT/SjJL5uCmi2a4cvWLo4iH8XxhXGT87tgMtrzlrlCSSJbM9eLNk1gPkYdVYdImnSW9gyFR+wY3fLRfXMSyFt+NzSs4LYLWg9NwmrnICRWS+E/0ze9HVTzg1b1Hug8cRVuXxJMZhLdv8PATJGSIfuWcul/eK+bo=
Received: from 30.48.68.216(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WsnGx.4_1763530298 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 19 Nov 2025 13:31:39 +0800
Message-ID: <25c76729-69b8-4ed1-affd-bad92b1069d9@linux.alibaba.com>
Date: Wed, 19 Nov 2025 13:31:38 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] ocfs2: Replace deprecated strcpy in
 ocfs2_create_xattr_block
To: Thorsten Blum <thorsten.blum@linux.dev>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, akpm <akpm@linux-foundation.org>
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20251118185345.132411-2-thorsten.blum@linux.dev>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20251118185345.132411-2-thorsten.blum@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2025/11/19 02:53, Thorsten Blum wrote:
> strcpy() has been deprecated [1] because it performs no bounds checking
> on the destination buffer, which can lead to buffer overflows. Replace
> it with the safer strscpy(), and copy directly into '->xb_signature'
> instead of using the start of the struct as the destination buffer.
> 
> Link: https://www.kernel.org/doc/html/latest/process/deprecated.html#strcpy [1]
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>

Looks good.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
>  fs/ocfs2/xattr.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
> index d70a20d29e3e..73c028f452ac 100644
> --- a/fs/ocfs2/xattr.c
> +++ b/fs/ocfs2/xattr.c
> @@ -2908,7 +2908,7 @@ static int ocfs2_create_xattr_block(struct inode *inode,
>  	/* Initialize ocfs2_xattr_block */
>  	xblk = (struct ocfs2_xattr_block *)new_bh->b_data;
>  	memset(xblk, 0, inode->i_sb->s_blocksize);
> -	strcpy((void *)xblk, OCFS2_XATTR_BLOCK_SIGNATURE);
> +	strscpy(xblk->xb_signature, OCFS2_XATTR_BLOCK_SIGNATURE);
>  	xblk->xb_suballoc_slot = cpu_to_le16(ctxt->meta_ac->ac_alloc_slot);
>  	xblk->xb_suballoc_loc = cpu_to_le64(suballoc_loc);
>  	xblk->xb_suballoc_bit = cpu_to_le16(suballoc_bit_start);

