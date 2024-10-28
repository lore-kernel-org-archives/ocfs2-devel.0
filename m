Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3225516F8F5
	for <ocfs2-devel@lists.linux.dev>; Mon, 28 Oct 2024 02:52:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730083938; cv=none; b=aNS+/vOBu8mltM4iMeDObaiSWpYKV134N7z8wjSDZ937BU7qYJgxLr9zHvm6s5OCF7fliiobBnFMQwRU1WdD+ThwtbfnFeO+tzTF2n4SqNCJAX4hyj9K0candIoJ+ewITKzlt5bZR91fbF0DTclUtqSjkSoHY8EUoifv0ULiE4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730083938; c=relaxed/simple;
	bh=HAVLsqK9UzwLDQUVoiCRHNdhEfmVKcdLiNiMKd+cyk8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HbIKtblVnMJQyuTiNXJ3RHdRlvan8fnM4tAdDp0uPkbJChxNQgCDG1GyUmBwR/QvJv3GdKim9dqYAOPUgeHUL2Jm6OXnvWj5lMAexYL5thWvzu4RsCXIxwwMWKRyTJ8u/7dfP2u7vTKJVvH+LhzyX6KSHTCbLEGTtBa8YbyrMWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=yiJekmoR; arc=none smtp.client-ip=115.124.30.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="yiJekmoR"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1730083932; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=b5yQ4YFvkLKgKnnUbCI5wEBIs+r+JY9U+CGgILijEGQ=;
	b=yiJekmoR1ejtIgL9S/jKRrUScXBex0DM5casJsmbiaiExcsC9D5SX1kt6IUuloho5XM4jquF/Du6xuE4ywGAglvSg21C/HtqGNqvf55T5s1HYf9n23Zv3fgLRfVMtlcLUBgBXJcCGpJ7hOrAfdHlaUUA1vA1oiA50VRmqygfPb8=
Received: from 30.221.129.41(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WHzAHht_1730083931 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 28 Oct 2024 10:52:11 +0800
Message-ID: <42fec340-eedc-41b2-9f27-2e41c92d2bba@linux.alibaba.com>
Date: Mon, 28 Oct 2024 10:52:11 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: cluster: fix a typo
To: Andrew Kreimer <algonell@gmail.com>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, akpm <akpm@linux-foundation.org>
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 kernel-janitors@vger.kernel.org
References: <20241027133540.22090-1-algonell@gmail.com>
Content-Language: en-US
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20241027133540.22090-1-algonell@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/27/24 9:35 PM, Andrew Kreimer wrote:
> Fix a typo: panicing -> panicking.
> 
> Via codespell.
> 
> Signed-off-by: Andrew Kreimer <algonell@gmail.com>

Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
>  fs/ocfs2/cluster/quorum.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/cluster/quorum.c b/fs/ocfs2/cluster/quorum.c
> index 15d0ed9c13e5..8bf17231d7b7 100644
> --- a/fs/ocfs2/cluster/quorum.c
> +++ b/fs/ocfs2/cluster/quorum.c
> @@ -60,7 +60,7 @@ static void o2quo_fence_self(void)
>  	switch (o2nm_single_cluster->cl_fence_method) {
>  	case O2NM_FENCE_PANIC:
>  		panic("*** ocfs2 is very sorry to be fencing this system by "
> -		      "panicing ***\n");
> +		      "panicking ***\n");
>  		break;
>  	default:
>  		WARN_ON(o2nm_single_cluster->cl_fence_method >=

