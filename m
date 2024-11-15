Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C2601370
	for <ocfs2-devel@lists.linux.dev>; Fri, 15 Nov 2024 01:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731632512; cv=none; b=XKr2bendga3GSmhHk5hU0Vp6lZ7KbY2ut8klwnbIzSR2disBXqIGY3LAKVNMG/LUnSSSp8PLmfV8VFDtdfNPaUHk+2cjbZfLdD3njMATF0cgAHwCH3A3FJn43PRPJd5NwctVkX5IGKk8MFNnqul00up4we56Jn2RYye9+1hNhKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731632512; c=relaxed/simple;
	bh=vS3GPbhggG+7It6YKD6yGG4nXacbgsc8RJrqlVYsfaM=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=eZJwp7yVkCkUBNJG6/386Dvk7fJGGruTz6NuU3qwGKDbI7vARpiDECNHVxuWuorD/EEZXAPWuw3pyeG4VdyC/dEAUX7Qb6YEGfwtSiyf59gCu41xGi3WKM5/pRDX8oGNhUBG5SUhD04AEpGglZzOOmeswmSanR3mdSGlPBO1iw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=IVF2K3aL; arc=none smtp.client-ip=115.124.30.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="IVF2K3aL"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1731632507; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=RZ5+13Xg46zBFHHnJHSrCXHb1cyKMu8F7TupXZ+HxCg=;
	b=IVF2K3aL1tYI59cRYcKLYibeKrrqe0iVRnjZURnJ/Xvy95o36CIeuqW6SK8H0PsV/g+xwU3SnSP1lt82rds/9u1nZdGaCMLmUNXMrkrTvKdv+RWBHntj/KdDKd1HUHrcADarJLNkjxop7J+nE402+vaWGgkyOGue1yUShYn9sEk=
Received: from 30.171.192.161(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WJQV3zx_1731632505 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 15 Nov 2024 09:01:46 +0800
Message-ID: <50564a28-9c75-497f-a50c-22e08b1f794f@linux.alibaba.com>
Date: Fri, 15 Nov 2024 09:01:45 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: heartbeat: replace simple_strtoul with kstrtoul
To: Daniel Yang <danielyangkang@gmail.com>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>,
 "open list:ORACLE CLUSTER FILESYSTEM 2 (OCFS2)"
 <ocfs2-devel@lists.linux.dev>, open list <linux-kernel@vger.kernel.org>
References: <20241113084108.186506-1-danielyangkang@gmail.com>
Content-Language: en-US
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20241113084108.186506-1-danielyangkang@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 11/13/24 4:41 PM, Daniel Yang wrote:
> The function simple_strtoul is deprecated due to ignoring overflows and
> also requires clunkier error checking. Replacing with kstrtoul() leads
> to safer code and cleaner error checking.
> 
> Signed-off-by: Daniel Yang <danielyangkang@gmail.com>
> ---
>  fs/ocfs2/cluster/heartbeat.c | 15 +++++++++------
>  1 file changed, 9 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
> index dff18efbc..4fc1b23f1 100644
> --- a/fs/ocfs2/cluster/heartbeat.c
> +++ b/fs/ocfs2/cluster/heartbeat.c
> @@ -1537,8 +1537,9 @@ static int o2hb_read_block_input(struct o2hb_region *reg,
>  	unsigned long bytes;
>  	char *p = (char *)page;

Please define 'ret' here to make code style consistent.
>  
> -	bytes = simple_strtoul(p, &p, 0);
> -	if (!p || (*p && (*p != '\n')))
> +	int ret = kstrtoul(p, 0, &bytes);
> +

The above blane line can be eleminated.

> +	if (ret)
>  		return -EINVAL;
>  
>  	/* Heartbeat and fs min / max block sizes are the same. */
> @@ -1627,8 +1628,9 @@ static ssize_t o2hb_region_blocks_store(struct config_item *item,
>  	if (reg->hr_bdev_file)
>  		return -EINVAL;
>  
> -	tmp = simple_strtoul(p, &p, 0);
> -	if (!p || (*p && (*p != '\n')))
> +	int ret = kstrtoul(p, 0, &tmp);
> +

Ditto.

> +	if (ret)
>  		return -EINVAL;
>  
>  	if (tmp > O2NM_MAX_NODES || tmp == 0)
> @@ -2142,8 +2144,9 @@ static ssize_t o2hb_heartbeat_group_dead_threshold_store(struct config_item *ite
>  	unsigned long tmp;
>  	char *p = (char *)page;
>  
> -	tmp = simple_strtoul(p, &p, 10);
> -	if (!p || (*p && (*p != '\n')))
> +	int ret = kstrtoul(p, 10, &tmp);
> +

Ditto.

Thanks,
Joseph
> +	if (ret)
>                  return -EINVAL;
>  
>  	/* this will validate ranges for us. */

