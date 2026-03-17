Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E33F3C3BEE
	for <ocfs2-devel@lists.linux.dev>; Tue, 17 Mar 2026 12:22:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.118
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773750137; cv=none; b=IPzARHiN9CxC+Tr57DjxjKb7UL6omwhUPKlTjrkAohv1zX80OyQtmb9vIGlv1+0r1RRab9oysP2Dc0AsdRQP6aKVCm1Qot4pq0x+wtEBEFGMV8h2cmrKXpXT07pTpWsT+rqcptzyBZ0yjp0aBdXtbmEXySZiyiQj0Vf0MykYBEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773750137; c=relaxed/simple;
	bh=CwqmOtDedE3vPSKwcIgRZGYpswGb8oUFdLF3Cn/PjsQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BOasTVDQlvjlW6rYz8BEW7WBtyvPO0jma11aioxhmtdtuObeyzWrXwYd6wLv4XMOIeQRVbERH42KsVkHnlZmYoo+iNLXF43rMdTe31zWwQLrZbxOsyVfR0Pzkj51+U7f2Ii2X0h39dsw3u4mfVZAWF5DCevX23NpFifDgLJNpjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=Bc/y0/Qr; arc=none smtp.client-ip=115.124.30.118
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="Bc/y0/Qr"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1773750130; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=IcBDrMF6egPDeR1Nx999ZhF+DZ+aH1WWZBUJtvevnHg=;
	b=Bc/y0/QrM3BZwBjdBwmz6brc+pNeL8M0v+SKD9O/std5F6ED5McpM9iGPlKSHKaxah0f/43tBOSvenGD0DWvgDdK4Zxd5IzN66qq6xj4AQBlIfO2yZJCNGTxexYHeozRbsmMWwdj7UrH3c2lzelhJlkg4LWu1TkmEbzILvPWrQM=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0X.B.vPK_1773750128;
Received: from 30.221.129.140(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X.B.vPK_1773750128 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 17 Mar 2026 20:22:09 +0800
Message-ID: <a7f7510b-652c-414b-a530-3aeda945c74a@linux.alibaba.com>
Date: Tue, 17 Mar 2026 20:22:08 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2/dlm: validate message payload length in query
 handlers
To: Junrui Luo <moonafterrain@outlook.com>
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org, Yuhao Jiang <danisjiang@gmail.com>,
 Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 Sunil Mushran <sunil.mushran@oracle.com>
References: <SYBPR01MB7881890B57945C79BC03F31EAF44A@SYBPR01MB7881.ausprd01.prod.outlook.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <SYBPR01MB7881890B57945C79BC03F31EAF44A@SYBPR01MB7881.ausprd01.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 3/12/26 6:03 PM, Junrui Luo wrote:
> dlm_query_region_handler() and dlm_query_nodeinfo_handler() cast
> msg->buf to their respective structure pointers without validating
> that the received message length is sufficient. The o2net transport
> layer only enforces a maximum payload length, not a minimum, so a
> truncated message passes the network check and reaches the handler.
> 
> This causes out-of-bounds reads from the receive page buffer when
> accessing structure fields beyond the actual payload, leading to
> operations on stale or uninitialized data.
> 

OCFS2 is always deployed in trusted network.
So if not considering defensive programming, how does it happen in real
environment?

Thanks,
Joseph

> Fix by validating that len covers the full expected structure size
> before accessing any payload fields.
> 
> Cc: stable@vger.kernel.org
> Fixes: ea2034416b54 ("ocfs2/dlm: Add message DLM_QUERY_REGION")
> Fixes: 18cfdf1b1a8e ("ocfs2/dlm: Add message DLM_QUERY_NODEINFO")
> Reported-by: Yuhao Jiang <danisjiang@gmail.com>
> Signed-off-by: Junrui Luo <moonafterrain@outlook.com>
> ---
>  fs/ocfs2/dlm/dlmdomain.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/fs/ocfs2/dlm/dlmdomain.c b/fs/ocfs2/dlm/dlmdomain.c
> index 70ca79e4bdc3..07aef9ae8cbe 100644
> --- a/fs/ocfs2/dlm/dlmdomain.c
> +++ b/fs/ocfs2/dlm/dlmdomain.c
> @@ -1100,6 +1100,9 @@ static int dlm_query_region_handler(struct o2net_msg *msg, u32 len,
>  	char *local = NULL;
>  	int status = 0;
>  
> +	if (len < sizeof(struct o2net_msg) + sizeof(struct dlm_query_region))
> +		return -EINVAL;
> +
>  	qr = (struct dlm_query_region *) msg->buf;
>  
>  	mlog(0, "Node %u queries hb regions on domain %s\n", qr->qr_node,
> @@ -1276,6 +1279,9 @@ static int dlm_query_nodeinfo_handler(struct o2net_msg *msg, u32 len,
>  	struct dlm_ctxt *dlm = NULL;
>  	int status = -EINVAL;
>  
> +	if (len < sizeof(struct o2net_msg) + sizeof(struct dlm_query_nodeinfo))
> +		return -EINVAL;
> +
>  	qn = (struct dlm_query_nodeinfo *) msg->buf;
>  
>  	mlog(0, "Node %u queries nodes on domain %s\n", qn->qn_nodenum,
> 
> ---
> base-commit: 1f318b96cc84d7c2ab792fcc0bfd42a7ca890681
> change-id: 20260312-fixes-c80f56fb6069
> 
> Best regards,

