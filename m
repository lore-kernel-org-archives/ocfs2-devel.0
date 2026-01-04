Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D3411F461D
	for <ocfs2-devel@lists.linux.dev>; Sun,  4 Jan 2026 01:53:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767491594; cv=none; b=Rmad9+8iDAUGrqhcrq9o26StclMyPkhuW3E0aVPp9/Covp5ZBUK+JMBdbjCrwo+duFY0/vf4TmYluqsGXkSRIHGkVM0ifivPkSr98E7dVm5dTGc5xJ18pz3lYSeybze9H7nFh2qjhRzlcvEWSvv2+4myGDCNhl3lByyhpjyBDTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767491594; c=relaxed/simple;
	bh=nrAoqeuG6lMr9ZX7KggOnGQrYdGJIY4O5s3Ve7Cih7w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Iw0taVoSW2DXojcLGWVE46gh3xV3pbh54W5lDMRXSpZp3e+qj47z0spU6TWXOfZPaS04QZyGfjE9z2IXMlrZIzseJt8KAZT2EHxhn2i41TTImqCBIjYIEPRoGG7q0z1srTtTZnZdsAHJJsKH7ZMjYbJ+OAieAahE7sOuUEA3K6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=k1FX+dz2; arc=none smtp.client-ip=115.124.30.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="k1FX+dz2"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1767491582; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=Rn6OCOsWTiHUcURo0i9v6hM4wHWmGCDEVwNcK7Xzyes=;
	b=k1FX+dz2kv0paEjMLJiocNlmXF0udLINOQA5GjRcbpHvLMU+plNd16ya5cIDqZPeyBsog45ctofLFRNBWCXKeQZEpVGtJ1IIgvL4PXhmb7yC7imFJ0loZU4MqK+6SNKJNJdY4hQ+HSkWGMFoweifwAOquy2ipPRP+XoaIXYdnxw=
Received: from 30.221.145.42(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WwA3laG_1767491580 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sun, 04 Jan 2026 09:53:01 +0800
Message-ID: <5b8d075f-6f86-4b89-aa2a-51b52146c938@linux.alibaba.com>
Date: Sun, 4 Jan 2026 09:53:00 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: adjust function name reference
To: Julia Lawall <Julia.Lawall@inria.fr>, Mark Fasheh <mark@fasheh.com>,
 akpm <akpm@linux-foundation.org>
Cc: yunbolyu@smu.edu.sg, kexinsun@smail.nju.edu.cn, ratnadiraw@smu.edu.sg,
 xutong.ma@inria.fr, Joel Becker <jlbec@evilplan.org>,
 ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20251230142513.95467-1-Julia.Lawall@inria.fr>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20251230142513.95467-1-Julia.Lawall@inria.fr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2025/12/30 22:25, Julia Lawall wrote:
> There is no function dlm_mast_regions().  However,
> dlm_match_regions() is passed the buffer "local",
> which it uses internally, so it seems like
> dlm_match_regions() was intended.
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@inria.fr>

Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> 
> ---
>  fs/ocfs2/dlm/dlmdomain.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/dlm/dlmdomain.c b/fs/ocfs2/dlm/dlmdomain.c
> index 2347a50f079b..cf3ca2f597c2 100644
> --- a/fs/ocfs2/dlm/dlmdomain.c
> +++ b/fs/ocfs2/dlm/dlmdomain.c
> @@ -1105,7 +1105,7 @@ static int dlm_query_region_handler(struct o2net_msg *msg, u32 len,
>  	mlog(0, "Node %u queries hb regions on domain %s\n", qr->qr_node,
>  	     qr->qr_domain);
>  
> -	/* buffer used in dlm_mast_regions() */
> +	/* buffer used in dlm_match_regions() */
>  	local = kmalloc(sizeof(qr->qr_regions), GFP_KERNEL);
>  	if (!local)
>  		return -ENOMEM;
> 

