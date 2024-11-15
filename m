Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 645EA2629D
	for <ocfs2-devel@lists.linux.dev>; Fri, 15 Nov 2024 01:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.111
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731632733; cv=none; b=l+W/5F7aLQ+8Gid3YRogcusJLMT49Tmg8lh++JNH8TPsmO9PWZhWAzp53WwrSiE3jZRJ2eh4fGv+80fmM+hwIV0shdm9j/MNgpC1wYewpPp/fduUO+HmEQKl/VrKFNEcZbjNRfPH5nrLi1BjFWOXFmaPAGDWLyYWZKYybAGmOWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731632733; c=relaxed/simple;
	bh=0Mnaiv5giTJkitdFkwpfO+YuGFwyyLXQhkeoEFqz4ro=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=lzp/eE7icBodymsMrp7trMwDyTBzQuYgqt3l52WZoKQJrnbgcE3BacFBVme6ahTGrGipfOdktrjSr4OAhStQ7bnpMjGtbn2GXKcTB/joNVBkgnTldXwlMAQocY240mn8sAUj/WFixRFWqEv+yu0AWAUGMxv05ZgJImPvqArNd/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=iuwaPKyP; arc=none smtp.client-ip=115.124.30.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="iuwaPKyP"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1731632727; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=XJIkwQcYcCQ60i+iSidawmFPjuxY32QLzg7OO5XGm3o=;
	b=iuwaPKyPOjg1bzER21+80/VUtSH6GMGQQONb+MkDXa3W25QpUxvKRnVslkK8cQe7I1fsSWay+iyOHDd4i/ss2F2j4gpzx7HnrE1XER1/bUwfF66ogVP2rAonCDo2XKkpoaW20rJtzGlSavq3s6L1DM415ELjrEPj06sL9a9fOn4=
Received: from 30.171.192.161(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WJQc5P6_1731632726 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 15 Nov 2024 09:05:27 +0800
Message-ID: <35b0534a-0ccd-4b92-b493-33434a81845e@linux.alibaba.com>
Date: Fri, 15 Nov 2024 09:05:26 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: replace deprecated simple_strtol with kstrtol
To: Daniel Yang <danielyangkang@gmail.com>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>,
 "open list:ORACLE CLUSTER FILESYSTEM 2 (OCFS2)"
 <ocfs2-devel@lists.linux.dev>, open list <linux-kernel@vger.kernel.org>
References: <20241113080913.182499-1-danielyangkang@gmail.com>
Content-Language: en-US
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20241113080913.182499-1-danielyangkang@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 11/13/24 4:09 PM, Daniel Yang wrote:
> The function simple_strtol ignores overflows and has an awkward
> interface for error checking. Replace with the recommended kstrtol
> function leads to clearer error checking and safer conversions.
> 
> Signed-off-by: Daniel Yang <danielyangkang@gmail.com>
> ---
>  fs/ocfs2/cluster/heartbeat.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
> index 4b9f45d70..dff18efbc 100644
> --- a/fs/ocfs2/cluster/heartbeat.c
> +++ b/fs/ocfs2/cluster/heartbeat.c
> @@ -3,6 +3,7 @@
>   * Copyright (C) 2004, 2005 Oracle.  All rights reserved.
>   */
>  
> +#include "linux/kstrtox.h"
>  #include <linux/kernel.h>
>  #include <linux/sched.h>
>  #include <linux/jiffies.h>
> @@ -1777,8 +1778,9 @@ static ssize_t o2hb_region_dev_store(struct config_item *item,
>  	if (o2nm_this_node() == O2NM_MAX_NODES)
>  		goto out;
>  
> -	fd = simple_strtol(p, &p, 0);
> -	if (!p || (*p && (*p != '\n')))
> +	int p_to_long_ret = kstrtol(p, 0, &fd);
> +

Please define at the beginning.
Seems we can just re-use 'ret'.
BTW, the blank line can be eleminated.

Thanks,
Joseph

> +	if (p_to_long_ret < 0)
>  		goto out;
>  
>  	if (fd < 0 || fd >= INT_MAX)

