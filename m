Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37F092857CC
	for <ocfs2-devel@lists.linux.dev>; Fri, 31 Jul 2026 00:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785458707; cv=none; b=TkIL9U59WaM/JnciHC8GEWSHQqzoaYundtkw+ibMdPYc7Gs26E1Pcvu5talPPaRHDEOXpo7vpOJy8FDx0mFwVxRBM+kB9RAoD8oZeMG+fxnApGrIGJp/cYnM9XzT1peFPH119egGIKjtbzxeYzuL2EMxqJQCFVe2hYf8O0TmCC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785458707; c=relaxed/simple;
	bh=3YGkrcb9ty1xvsPRti4EGPeMaMMgmstjBHfzPwM0xdI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jiIMW8HuQeK39mHFEoaPerI/NsdA+mqB0126Bnu75G0P7ZGxt/1iyzfn8riNBAlcsmMfDoxpJXo/F3pXAL9U6nMkPVTi4yCCfGYvPSq8O6VyjTaGVHaEEA5eMrmGiLgaxf8Re8msK+MtrYMDMl9gz1sotNRPOOQJqA8gKLqp6fA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=JcBtBwBD; arc=none smtp.client-ip=115.124.30.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="JcBtBwBD"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1785458700; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=v6zC9Pu67+hG+fApLQE3VZHygRmJISPKeFpPL5zynL0=;
	b=JcBtBwBD5jnc/2o1CfbK7BpJxyIHa1pnKgzfav1365MYqia5joBoiH4OwqX0Axvkf9WR8knWoOK54vgCkAsMpUONFOcZrKC+D4q8uDN3aYobL659KPKLGSpvNzd6rf/A8SBr3mr+x0U0G0CAZ2EEtKppG7djbYAL4XpnJioFx0Y=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0X86Hp7q_1785458698;
Received: from 30.221.129.39(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X86Hp7q_1785458698 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 31 Jul 2026 08:44:59 +0800
Message-ID: <a62a1071-4134-4bd6-b4fe-5b4f278037a9@linux.alibaba.com>
Date: Fri, 31 Jul 2026 08:44:58 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: Remove redundant NULL check for rec variable
To: Roman Demidov <roman.demidov@red-soft.ru>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 lvc-project@linuxtesting.org
References: <20260730131507.26636-1-roman.demidov@red-soft.ru>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260730131507.26636-1-roman.demidov@red-soft.ru>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 7/30/26 9:15 PM, Roman Demidov wrote:
> The rec variable will contain the address of the structure array element,
> i.e., the address of the ocfs2_chain_rec structure.
> This address cannot be NULL.
> 
> Found by Linux Verification Center (linuxtesting.org) with SVACE.
> 
> Signed-off-by: Roman Demidov <roman.demidov@red-soft.ru>

Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
>  fs/ocfs2/move_extents.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
> index ad1678ee7cc4..b546c7371e28 100644
> --- a/fs/ocfs2/move_extents.c
> +++ b/fs/ocfs2/move_extents.c
> @@ -415,9 +415,6 @@ static int ocfs2_find_victim_alloc_group(struct inode *inode,
>  	for (i = 0; i < le16_to_cpu(cl->cl_next_free_rec); i++) {
>  
>  		rec = &(cl->cl_recs[i]);
> -		if (!rec)
> -			continue;
> -
>  		bg = NULL;
>  
>  		do {

