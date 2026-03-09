Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 032042264A9
	for <ocfs2-devel@lists.linux.dev>; Mon,  9 Mar 2026 01:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773018614; cv=none; b=jl3l7u5gRXKtBvOa2q5CnRsyGHlMtxPWjE9L5ApmOnzxD6NPrAHNCHZR5IMmlxV8PSP/C74n6Bj7ZuAGYiEksfFSuPcM8OgwZopESTLpGe0sJPC5mtrWKYkWgVPZQeI2jKCw2EbjaUgIN6aM7F4vbNowMGgzdYC7K03IGD23gv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773018614; c=relaxed/simple;
	bh=K/iIE95fpNlUGcb0cxSVFMk6L5akr42yuCq+7DENjQ8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pK2Aq7Ff3WFzMiUSlgfN9xjLLcuSl9AFaa5wyI+vns7fx543uO6j+/MusUcslJPPuz4ihZtUu9I5G9gHjO/WE7ZSxHR2VZxpo/091Leq2v7PHLnl6tnAlATUVbmwb8kFk5rbuttDsLC8tt0D999UnLSLbPjfFqQ9h9V2MsSfKc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=IuSjSVHw; arc=none smtp.client-ip=115.124.30.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="IuSjSVHw"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1773018604; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=KzQuyG0MeSrqLktH4U8rGQDLdHUxmaAcRefS3jN8FPA=;
	b=IuSjSVHwFysbzh2fnjy3Snm/EbRoKKnzOxx+hoCRdZWTiSQXesFjobh2Gx+xCQ0Zq98TD3FEoexZZcdqA8acVDbPvt4D/IARWVtJ+irwGCcJ5oju84jUPKz8pZSOqYQ2kG7EiXP0iHo4T5lfTiP9v90LhpI1Qsr6PnukaasBQ88=
Received: from 30.221.129.90(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X-Swn.7_1773018602 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 09 Mar 2026 09:10:03 +0800
Message-ID: <e622f6e5-baa4-4f7b-b35b-c5ad03db903b@linux.alibaba.com>
Date: Mon, 9 Mar 2026 09:10:02 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: remove redundant error code assignment
To: Alexey Velichayshiy <a.velichayshiy@ispras.ru>,
 akpm <akpm@linux-foundation.org>
Cc: Joel Becker <jlbec@evilplan.org>, ocfs2-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org,
 Mark Fasheh <mark@fasheh.com>
References: <20260307234809.88421-1-a.velichayshiy@ispras.ru>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260307234809.88421-1-a.velichayshiy@ispras.ru>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 3/8/26 7:47 AM, Alexey Velichayshiy wrote:
> Removed the error assignment for variable 'ret' during correct code
> execution. In subsequent execution, variable 'ret' is overwritten.
> 
> Found by Linux Verification Center (linuxtesting.org) with SVACE.
> 
> Signed-off-by: Alexey Velichayshiy <a.velichayshiy@ispras.ru>

Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
>  fs/ocfs2/dlm/dlmmaster.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
> index eb62724bbe9b..93eff38fdadd 100644
> --- a/fs/ocfs2/dlm/dlmmaster.c
> +++ b/fs/ocfs2/dlm/dlmmaster.c
> @@ -930,7 +930,6 @@ struct dlm_lock_resource * dlm_get_lock_resource(struct dlm_ctxt *dlm,
>  	if (blocked)
>  		goto wait;
>  
> -	ret = -EINVAL;
>  	dlm_node_iter_init(mle->vote_map, &iter);
>  	while ((nodenum = dlm_node_iter_next(&iter)) >= 0) {
>  		ret = dlm_do_master_request(res, mle, nodenum);

