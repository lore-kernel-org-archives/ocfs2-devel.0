Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F2FA3B47F9
	for <ocfs2-devel@lists.linux.dev>; Wed,  1 Jul 2026 09:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782897253; cv=none; b=lDjdW8SLnwFAFePn0RWO7xz1J8rAc0O/PEGuf9y92vALgEwUaLEGj0XjllLtfX/UW6Ve5G7Abad0bHagRfrAyzgZraUl1kCEfBmIJb3Upu3nvY7ulH2rho5TDfgHMWcmkN2799xsis/GXTZ01A02T25D/LRpk/4pyQs+2gKEuho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782897253; c=relaxed/simple;
	bh=+7OACqcl37tq0zKz2PqIt+QUQyboGE1C95BTm5K5f58=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XPiJUHtHz3YrFR91NFFaP9BLwRyFK4CPsO9748GCopk1QcAp9REYeJOeh0WJWvVufiV5AKWUocutIuT05K17FjtvS6Dk37YZ0vB21weEWpaTNQn0hrOLmGfYNk7SaVuvTKCINT6GSKNs17YT/oGomLegH5hqvrFvO9zXnWYHkt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=bIayttiU; arc=none smtp.client-ip=115.124.30.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="bIayttiU"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1782897247; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=cdtrtgwsmgh8pIkG5iRhuJ+NkZEl1R+W5nk/InpFvSM=;
	b=bIayttiUTEkVgLxEXhocToo/eZX5QQlwDo8SrqwlfNvyNBsft5a+PT43IlKQyMF7p+Ss1RcaZCyA/HSuRNZoLCYc7rHphQcoQafP988nlzmxZuSas9Fdenu4iPHgd3Hvc5I9XIykhLv/1zt9IK9l0lN7j7jalSzwdoGRb+/BqHU=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R781e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0X66AjjQ_1782896926;
Received: from 30.221.145.49(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X66AjjQ_1782896926 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 01 Jul 2026 17:08:47 +0800
Message-ID: <f89a5fb9-9d49-47e9-b356-f14acb603f0b@linux.alibaba.com>
Date: Wed, 1 Jul 2026 17:08:46 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: validate quota file block count in
 ocfs2_local_read_info()
To: Dmitry Antipov <dmantipov@yandex.ru>
Cc: Sam Sun <samsun1006219@gmail.com>, ocfs2-devel@lists.linux.dev,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20260625084448.1634511-1-dmantipov@yandex.ru>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260625084448.1634511-1-dmantipov@yandex.ru>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 6/25/26 4:44 PM, Dmitry Antipov wrote:
> In 'ocfs2_local_read_info()', assume that number of blocks allocated
> for local quota file should not exceed the limit based on claimed
> number of chunks, and refuse an attempt to enable quota otherwise.
> 
> Reported-by: Sam Sun <samsun1006219@gmail.com>
> Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
> ---
>  fs/ocfs2/quota_local.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/fs/ocfs2/quota_local.c b/fs/ocfs2/quota_local.c
> index f55810c59b1b..33a9b5b449c8 100644
> --- a/fs/ocfs2/quota_local.c
> +++ b/fs/ocfs2/quota_local.c
> @@ -733,6 +733,13 @@ static int ocfs2_local_read_info(struct super_block *sb, int type)
>  	oinfo->dqi_blocks = le32_to_cpu(ldinfo->dqi_blocks);
>  	oinfo->dqi_libh = bh;
>  
> +	if (oinfo->dqi_blocks > oinfo->dqi_chunks * ol_chunk_blocks(sb)) {

This will reject valid on-disk layouts.
See ol_quota_chunk_block().

BTW, could we move the geometry bound check into a dedicated info-block
validator?

Thanks,
Joseph

> +		mlog(ML_ERROR, "unexpectedly large local quota "
> +		     "file block count %u\n", oinfo->dqi_blocks);
> +		status = -EFSCORRUPTED;
> +		goto out_err;
> +	}
> +
>  	/* We crashed when using local quota file? */
>  	if (!(oinfo->dqi_flags & OLQF_CLEAN)) {
>  		rec = OCFS2_SB(sb)->quota_rec;

