Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 703068627C
	for <ocfs2-devel@lists.linux.dev>; Wed, 24 Apr 2024 03:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713929458; cv=none; b=MI1yeJzclkdFiesDr7rRymzVyZ9frR2dwkCyTfsnNvRUySvU15uY9Dr9pBjOeZDd3kN9g73IJD3DrE6DapOjeZnT+2BMVXlkCnXusaHeeCLaNiMMt/9M8l8+WkYHUW5p1ieR6mgQp1GjWWhROcqJzpV/7+q85vKmPl2NeTppH7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713929458; c=relaxed/simple;
	bh=rKi6NN48wepECtBpXiA7bU1rkNQhpJjd3bV4sNW0FT0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=C9pUB3zUM3QSrttWaLhUYfqGPs0DUpm709bJYqJZ5TOdblv2ajtwvgWmx5b/rR0XANdoDq0Tl5Sz66SJwQhP0UpP4RDdzwgJQneuOFZ6QmUHesV0dWStme7dEcBCVSqDa7RXFusXZnqyp4pxKnaO6zxMxQIVo9PQ67s4UQmr6iM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=ti+9iZ2b; arc=none smtp.client-ip=115.124.30.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="ti+9iZ2b"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1713929454; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=RAITW8Q5G1SlFKuL2iNYgoTd3KgsFZ6WJdYB4NCuFC4=;
	b=ti+9iZ2bA6B9Huev8dpdGwNDZf+NL0ixy4jp7fJkSJnzsV3oCMN17SQSZiyqzHJwZR0FZ7JDo1raq2fAZPoVO1BxO2wrF2CnGn7wv4DfWJUJcxccnG5NrHvBV8LFZItcaUC7+AlfSiGZO4iGReGFkMgjndlXTq3wQbsk4DQKSOk=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R351e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045046011;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0W5AojMt_1713929452;
Received: from 30.221.128.184(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0W5AojMt_1713929452)
          by smtp.aliyun-inc.com;
          Wed, 24 Apr 2024 11:30:53 +0800
Message-ID: <a4d38a49-9629-4ee0-9eba-4d45abace30d@linux.alibaba.com>
Date: Wed, 24 Apr 2024 11:30:52 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH][next] ocfs2: remove redundant assignment to variable
 status
To: Colin Ian King <colin.i.king@gmail.com>, akpm <akpm@linux-foundation.org>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
 ocfs2-devel@lists.linux.dev, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, Heming Zhao <heming.zhao@suse.com>
References: <20240423223018.1573213-1-colin.i.king@gmail.com>
Content-Language: en-US
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20240423223018.1573213-1-colin.i.king@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 4/24/24 6:30 AM, Colin Ian King wrote:
> Variable status is being assigned and error code that is never read, it is
> being assigned inside of a do-while loop. The assignment is redundant and
> can be removed.
> 
> Cleans up clang scan build warning:
> fs/ocfs2/dlm/dlmdomain.c:1530:2: warning: Value stored to 'status' is never
> read [deadcode.DeadStores]
> 
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>

Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
>  fs/ocfs2/dlm/dlmdomain.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/fs/ocfs2/dlm/dlmdomain.c b/fs/ocfs2/dlm/dlmdomain.c
> index 2e0a2f338282..2018501b2249 100644
> --- a/fs/ocfs2/dlm/dlmdomain.c
> +++ b/fs/ocfs2/dlm/dlmdomain.c
> @@ -1527,7 +1527,6 @@ static void dlm_send_join_asserts(struct dlm_ctxt *dlm,
>  {
>  	int status, node, live;
>  
> -	status = 0;
>  	node = -1;
>  	while ((node = find_next_bit(node_map, O2NM_MAX_NODES,
>  				     node + 1)) < O2NM_MAX_NODES) {
