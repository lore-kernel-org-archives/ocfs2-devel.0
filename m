Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.98
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792738962;
	b=u0CcGxzzBCgxSQk12kz45Sc4J8PQOhY3bm4YO3/yeaILwL3X9xMVoIKC8ZxWhZ3LgPEn
	 14JSvWVoGbl9X/JLCOsnFW4KypNq14a6tFwITO6/bwtgAJ5GdM4cm/qLjKVC6WwWUhN+b
	 KRlRLJfgA6g2LCVmlWR81y/gfJBgvivSGqctfFfkVX+tiqOCu2fQ3N+BXMHfYzT2Aetta
	 AAmmJFoZ8k/lkGHIoPFV+VoMs8VbO2h4dt8QGilQbpTxVfr4WvIJDe+ZMruedVk82NwiI
	 2Z+hx3nBSLszrCPucrpj3aFpfLxpbynZLTMbu0gBTabCxeMiLQGsUfmY9xaaEyufY9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792738962;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=Kc3NtUK8eQip9/0mvl4xkoyZxqWwahrf29NWu5Kg0ZE=;
	b=Clpr9bdKQkFXHzL7COlUHDLfT45N3tz9sX4Wm6hC0JJsb88Qi2RrnVi8Nujr5X4TCYV0
	 /Qo6JjAOkpSlWiOrMDUD9/EeRTqiYtAVfC1nasa2kJwlmXT3LIWyr7NOw/SXYoNYS5bUV
	 EytpawGbQBT/Tbq/7CqBBjemZZdGHBE0OPsWEiNDdke/2TodrhOoz1BLw8TwIOZ5G8inp
	 iz0WazqrMjsYg3GTk3vJXH2NGOl+p9ShxZ+r7/4JHKY8DXyhewJD/4OG54ps4XiQjH9GD
	 Qq5YpWqvoRFzK7FxMU1C81j8EvNdlAUvt6QiXy+UP7C0dKcehXpW/xbRqfeexTbSM7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=uCVJmzOu;
	arc=none smtp.remote-ip=115.124.30.98
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8DE2606A336
	for <ocfs2-devel@lists.linux.dev>; Fri, 23 Oct 2026 07:02:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E8DE2606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=uCVJmzOu
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1792738956; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=Kc3NtUK8eQip9/0mvl4xkoyZxqWwahrf29NWu5Kg0ZE=;
	b=uCVJmzOu/LRk2ISKh3HlRz31rUgpWnEpOT9ljwkAYoROQdPQ8CaOZvBK4fiBeJRns92BQff5ShgH8UKTVSOSyhuuIsFRvxuTMZLCgQSgV6rhDPaMZFp7wA7hG8FpzzYZ801i4xvtKkc458SBB3lMQ4HXcLS4v/MSzCOFDl2a3aE=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0XDLJ3Lw_1792738954;
Received: from 30.221.129.69(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XDLJ3Lw_1792738954 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 23 Oct 2026 15:02:35 +0800
Message-ID: <cb8eef8c-40da-439c-9f62-0428a75bc977@linux.alibaba.com>
Date: Fri, 23 Oct 2026 15:02:34 +0800
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Post: <mailto:ocfs2-devel@lists.linux.dev>
List-Help: <mailto:ocfs2-devel+help@lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:ocfs2-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2/cluster: remove zero-address nodes from IP tree on
 teardown
To: Cen Zhang <zzzccc427@gmail.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: mark@fasheh.com, jlbec@evilplan.org, heming.zhao@suse.com,
 ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org, baijiaju1990@gmail.com, jjzuming@gmail.com
References: <pm-ocfs2-node-ip-rbtree-zero-address-uaf-v5-e7f64be16b7c3b0988d1@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <pm-ocfs2-node-ip-rbtree-zero-address-uaf-v5-e7f64be16b7c3b0988d1@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/20/26 9:12 PM, Cen Zhang wrote:
> o2nm_node_ipv4_address_store() accepts 0.0.0.0. It sets
> O2NM_NODE_ATTR_ADDRESS and links nd_ip_node into cl_node_ip_tree under
> cl_nodes_lock, but o2nm_node_group_drop_item() uses nd_ipv4_address as a
> membership test. A zero address therefore leaves the rbtree node linked
> when config_item_put() releases and frees struct o2nm_node. A later
> address store or IP lookup can then walk the stale node and dereference
> freed memory.
> 
> During teardown, drop_item takes cl_nodes_lock, skips rb_erase()
> for the zero key, and then calls config_item_put(). A later
> o2nm_node_ipv4_address_store() duplicate check or o2nm_get_node_by_ip()
> lookup takes the same lock and walks the stale cl_node_ip_tree entry. Use
> O2NM_NODE_ATTR_ADDRESS for teardown so every published nd_ip_node is
> erased before configfs can release the node, without rejecting 0.0.0.0
> or changing lookup semantics.
> 
> Fixes: 0c83ed8eeb28 ("[PATCH] OCFS2: The Second Oracle Cluster Filesystem")
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Cen Zhang <zzzccc427@gmail.com>

Looks fine.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
>  fs/ocfs2/cluster/nodemanager.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ocfs2/cluster/nodemanager.c b/fs/ocfs2/cluster/nodemanager.c
> index e08850a5d736..be184c5ad54d 100644
> --- a/fs/ocfs2/cluster/nodemanager.c
> +++ b/fs/ocfs2/cluster/nodemanager.c
> @@ -626,8 +626,11 @@ static void o2nm_node_group_drop_item(struct config_group *group,
>  
>  	write_lock(&cluster->cl_nodes_lock);
>  
> -	/* XXX sloppy */
> -	if (node->nd_ipv4_address)
> +	/*
> +	 * 0.0.0.0 is a valid configured address, so nd_ipv4_address does
> +	 * not tell us whether nd_ip_node was published in the IP tree.
> +	 */
> +	if (test_bit(O2NM_NODE_ATTR_ADDRESS, &node->nd_set_attributes))
>  		rb_erase(&node->nd_ip_node, &cluster->cl_node_ip_tree);
>  
>  	/* nd_num might be 0 if the node number hasn't been set.. */

