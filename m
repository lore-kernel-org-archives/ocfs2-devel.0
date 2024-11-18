Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C82414F90
	for <ocfs2-devel@lists.linux.dev>; Mon, 18 Nov 2024 01:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731892293; cv=none; b=ppKGjAHdl8L0mMqcFs2a0Q+Qlo2VpFKNowqKHTCqJ+5V+qEjKUaBK/VrO2esBKJrO9cNgKZamySIkV1836T3OBcIZmrrX/IMPcO1oTX1KXB7hZbnFmV3JG/OIfY3LXbp9BX00bbv+cYyxBuhUF89saCkLzgPI420ftMPfVgL6pg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731892293; c=relaxed/simple;
	bh=LQf7kbzlpRxF5GWMAtn35rWyz1fS5TX9dSdMmsCXubc=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:Cc:From:
	 In-Reply-To:Content-Type; b=Fx840svnd4sNAEdDiL0trla+fMoakdXkYrk2eBs+RIt4IZ//UoeSsfq14jBoUuhJCBUscl482hQKsIeiyjRnvE8D0Z1l/SG16fIQlYqvYqetbAcro8gDAYI1anmyA2IhYQtHL2NyNLddrxVZaoGZx/YvFWj84O1NRehO7Ty9xe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=DIpevUcQ; arc=none smtp.client-ip=115.124.30.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="DIpevUcQ"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1731892287; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=dp8VSuA7rOBJYAzDEEwyzxRkoPG+lS1PRg2VSlsG8nI=;
	b=DIpevUcQM5dIrsJNckVhKeISoPckVmYvG7uery8Z0SAMLFZPI0yx+YQGSy7qSj41nZgM/ilpukF3YGZagJ6oltjgruM0VJWkD6xegjxJIF4E4ikbrtt+ilQT56C4aPzQ3R9gNTJeB+ShcxzxOBEfXAqexvobmoYPEm42d6tSeTc=
Received: from 30.221.128.223(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WJact4X_1731892283 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 18 Nov 2024 09:11:24 +0800
Message-ID: <46e3bfb7-ae28-412e-8996-900f6a2902fc@linux.alibaba.com>
Date: Mon, 18 Nov 2024 09:11:23 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] ocfs2: heartbeat: replace simple_strtoul with kstrtoul
To: Daniel Yang <danielyangkang@gmail.com>, akpm <akpm@linux-foundation.org>
References: <20241117215219.4012-1-danielyangkang@gmail.com>
Content-Language: en-US
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 "open list:ORACLE CLUSTER FILESYSTEM 2 (OCFS2)"
 <ocfs2-devel@lists.linux.dev>, open list <linux-kernel@vger.kernel.org>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20241117215219.4012-1-danielyangkang@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 11/18/24 5:52 AM, Daniel Yang wrote:
> The function simple_strtoul is deprecated due to ignoring overflows and
> also requires clunkier error checking. Replacing with kstrtoul() leads
> to safer code and cleaner error checking.
> 
> Signed-off-by: Daniel Yang <danielyangkang@gmail.com>

Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
> v2->v3: code style change and return ret
> v1->v2: moved ret definition and removed blank lines
> 
>  fs/ocfs2/cluster/heartbeat.c | 21 ++++++++++++---------
>  1 file changed, 12 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
> index dff18efbc..76f1e7bfd 100644
> --- a/fs/ocfs2/cluster/heartbeat.c
> +++ b/fs/ocfs2/cluster/heartbeat.c
> @@ -1536,10 +1536,11 @@ static int o2hb_read_block_input(struct o2hb_region *reg,
>  {
>  	unsigned long bytes;
>  	char *p = (char *)page;
> +	int ret;
>  
> -	bytes = simple_strtoul(p, &p, 0);
> -	if (!p || (*p && (*p != '\n')))
> -		return -EINVAL;
> +	ret = kstrtoul(p, 0, &bytes);
> +	if (ret)
> +		return ret;
>  
>  	/* Heartbeat and fs min / max block sizes are the same. */
>  	if (bytes > 4096 || bytes < 512)
> @@ -1623,13 +1624,14 @@ static ssize_t o2hb_region_blocks_store(struct config_item *item,
>  	struct o2hb_region *reg = to_o2hb_region(item);
>  	unsigned long tmp;
>  	char *p = (char *)page;
> +	int ret;
>  
>  	if (reg->hr_bdev_file)
>  		return -EINVAL;
>  
> -	tmp = simple_strtoul(p, &p, 0);
> -	if (!p || (*p && (*p != '\n')))
> -		return -EINVAL;
> +	ret = kstrtoul(p, 0, &tmp);
> +	if (ret)
> +		return ret;
>  
>  	if (tmp > O2NM_MAX_NODES || tmp == 0)
>  		return -ERANGE;
> @@ -2141,10 +2143,11 @@ static ssize_t o2hb_heartbeat_group_dead_threshold_store(struct config_item *ite
>  {
>  	unsigned long tmp;
>  	char *p = (char *)page;
> +	int ret;
>  
> -	tmp = simple_strtoul(p, &p, 10);
> -	if (!p || (*p && (*p != '\n')))
> -                return -EINVAL;
> +	ret = kstrtoul(p, 10, &tmp);
> +	if (ret)
> +		return ret;
>  
>  	/* this will validate ranges for us. */
>  	o2hb_dead_threshold_set((unsigned int) tmp);

