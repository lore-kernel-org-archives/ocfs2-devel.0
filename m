Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB5D3CA45
	for <ocfs2-devel@lists.linux.dev>; Wed, 18 Mar 2026 05:54:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773813289; cv=none; b=lmF2y33mlE7XHvUQrFQTGftEMkY6GFdUoRa5bsE/0hDOhdmAbUgr5dopWKvMjoTBC8m0PGI4TiINLhAQSrdxwRNOL3/2SjqxpSGkpEqGPvN/E1oWCXTVxeZz6PR8Qdu+wVE2Ys9MnFTJ7ZehfHlJzZfz8KkkL2BBqORySy5t9L4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773813289; c=relaxed/simple;
	bh=q06Hd9cGal0E1dj5Yz+aULbt/2NUG/SPjqsy0BTLhXY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XPhgrsaz7/9ul7PGqwOnZEi8+q9XSWr30iXj6/bJyApT0IHXXVbEeetYonQftB1mIN8+kbYo/7TVoGVaLcbVIE4qnr6EfxcFMrG1Qnl/eD7tpJF27uPaYXwvVTkiq8GmYH12Mv7wUOIeX4auICbUmul+DoGmnkSY+6IjWd4k6AE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=x07Me1i2; arc=none smtp.client-ip=115.124.30.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="x07Me1i2"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1773813285; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=rGU94KYt9vOMPtVgMLIhjhXuK6/VSHtJuAV8m3Fz5Og=;
	b=x07Me1i2XzNTQtlg7on0Ena2SlnlbDW7+U1jI9O4IXXh+E6S3bCgsDsME3yvfKiLXXPcXRTe0feI/hG6Z/mzGjaOcUI8+bpyi2IO3kdKL5VFkZb5IMePzjyeWL0I71sIbjmdSI83MZmYoKJsHI5B0Bl1Okr5XCCXmKaqE6fFq6w=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R891e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0X.DLWSg_1773813284;
Received: from 30.221.129.103(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X.DLWSg_1773813284 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 18 Mar 2026 13:54:44 +0800
Message-ID: <2030e53f-8826-4476-a3dc-5bf2c24e1e4d@linux.alibaba.com>
Date: Wed, 18 Mar 2026 13:54:43 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] ocfs2/dlm: validate qr_numregions in
 dlm_match_regions()
To: Junrui Luo <moonafterrain@outlook.com>, akpm <akpm@linux-foundation.org>
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 Yuhao Jiang <danisjiang@gmail.com>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, Sunil Mushran <sunil.mushran@oracle.com>
References: <SYBPR01MB7881A334D02ACEE5E0645801AF7BA@SYBPR01MB7881.ausprd01.prod.outlook.com>
 <SYBPR01MB788166F524AD04E262E174BEAF7BA@SYBPR01MB7881.ausprd01.prod.outlook.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <SYBPR01MB788166F524AD04E262E174BEAF7BA@SYBPR01MB7881.ausprd01.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 3/7/26 3:21 PM, Junrui Luo wrote:
> The qr_numregions field from a DLM_QUERY_REGION network message is used
> directly as loop bounds in dlm_match_regions() without checking against
> O2NM_MAX_REGIONS. Since qr_regions is sized for at most O2NM_MAX_REGIONS
> (32) entries, a crafted message with qr_numregions > 32 causes
> out-of-bounds reads past the qr_regions buffer.
> 
> Add a bounds check for qr_numregions before entering the loops.
> 
> Fixes: ea2034416b54 ("ocfs2/dlm: Add message DLM_QUERY_REGION")
> Reported-by: Yuhao Jiang <danisjiang@gmail.com>
> Signed-off-by: Junrui Luo <moonafterrain@outlook.com>

Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
>  fs/ocfs2/dlm/dlmdomain.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/fs/ocfs2/dlm/dlmdomain.c b/fs/ocfs2/dlm/dlmdomain.c
> index 70ca79e4bdc3..0a28cb5ded2a 100644
> --- a/fs/ocfs2/dlm/dlmdomain.c
> +++ b/fs/ocfs2/dlm/dlmdomain.c
> @@ -980,6 +980,14 @@ static int dlm_match_regions(struct dlm_ctxt *dlm,
>  		goto bail;
>  	}
>  
> +	if (qr->qr_numregions > O2NM_MAX_REGIONS) {
> +		mlog(ML_ERROR, "Domain %s: Joining node %d has invalid "
> +		     "number of heartbeat regions %u\n",
> +		     qr->qr_domain, qr->qr_node, qr->qr_numregions);
> +		status = -EINVAL;
> +		goto bail;
> +	}
> +
>  	r = remote;
>  	for (i = 0; i < qr->qr_numregions; ++i) {
>  		mlog(0, "Region %.*s\n", O2HB_MAX_REGION_NAME_LEN, r);
> 

