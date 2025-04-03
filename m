Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B6261CD3F
	for <ocfs2-devel@lists.linux.dev>; Thu,  3 Apr 2025 00:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743641799; cv=none; b=GYPSZ6SbYytHC/IEZ66h1TaFTJfayhwCReDMcdoUxxYkKXVMlz2m+eNVQ5aqUCvBvTCdxy4EWDIQyLLSfGqveue4XeCDs/04R6scLcdjR+jfXYkJqnCE/cqq0C9m2Lm4BJS56a8IwBXzzz4sBlyXjNhHT3Z9MFbO1GB2rcRl5CA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743641799; c=relaxed/simple;
	bh=+OXf5M1w46IgUF2uca+d1zmhqoN6pSAXm2BCK9dapO4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ONUMBxp1PErAq1OX6hXE9IAazWnbKswYa2HmWNCbow4EnrkkLehCkhE4KFmWHDDyTkUT2Ww6iDVNxxR1ledZowKlwvh6wgFM9+GhI+hr/h4k+XrE5WmiJBCqMTxE1lHvyCloYMhBQqrAnvWebTCYxqsn27g0peeSHPWHsIoPJLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=DC0ksdl3; arc=none smtp.client-ip=115.124.30.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="DC0ksdl3"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1743641785; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=J8uanV/xeiKDcIDPpPB+muPC63DFete06zJYgy7ARkg=;
	b=DC0ksdl3Q4Q0Jo9PvZb617Gu5YgSi44Ts+0v1PFmfOm9mXfi9mpyHejkIdaaE21w2CpCSD2sB2Tz+qHq865c1Oq7c0oxI1UYBXLT9eFRrF8el8eeUb3SxIur6/Shq1IpwZxjdbBxpP4LbXHTG8c+J0w4rJjJRllpjktuTp++S2E=
Received: from 30.39.168.206(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WUW-yJ._1743641783 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 03 Apr 2025 08:56:23 +0800
Message-ID: <72e5496c-df00-4b1f-bad0-b211ffaa61cf@linux.alibaba.com>
Date: Thu, 3 Apr 2025 08:56:22 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] ocfs2: Fix possible memory leak in
 ocfs2_finish_quota_recovery
To: Murad Masimov <m.masimov@mt-integration.ru>, Mark Fasheh
 <mark@fasheh.com>, akpm <akpm@linux-foundation.org>
Cc: Joel Becker <jlbec@evilplan.org>, Jan Kara <jack@suse.cz>,
 ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 lvc-project@linuxtesting.org
References: <20250402065628.706359-1-m.masimov@mt-integration.ru>
 <20250402065628.706359-2-m.masimov@mt-integration.ru>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20250402065628.706359-2-m.masimov@mt-integration.ru>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2025/4/2 14:56, Murad Masimov wrote:
> If ocfs2_finish_quota_recovery() exits due to an error before passing all
> rc_list elements to ocfs2_recover_local_quota_file() then it can lead to
> a memory leak as rc_list may still contain elements that have to be freed.
> 
> Release all memory allocated by ocfs2_add_recovery_chunk() using
> ocfs2_free_quota_recovery() instead of kfree().
> 
> Found by Linux Verification Center (linuxtesting.org) with Syzkaller.
> 
> Fixes: 2205363dce74 ("ocfs2: Implement quota recovery")
> Signed-off-by: Murad Masimov <m.masimov@mt-integration.ru>

Looks good.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
>  fs/ocfs2/quota_local.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/quota_local.c b/fs/ocfs2/quota_local.c
> index 2956d888c131..e60383d6ecc1 100644
> --- a/fs/ocfs2/quota_local.c
> +++ b/fs/ocfs2/quota_local.c
> @@ -678,7 +678,7 @@ int ocfs2_finish_quota_recovery(struct ocfs2_super *osb,
>  	}
>  out:
>  	up_read(&sb->s_umount);
> -	kfree(rec);
> +	ocfs2_free_quota_recovery(rec);
>  	return status;
>  }
> 
> --
> 2.39.2

