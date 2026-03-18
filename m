Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8661735DA52
	for <ocfs2-devel@lists.linux.dev>; Wed, 18 Mar 2026 05:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773813325; cv=none; b=rtmkML0bAOH9F6rGBCLcvQQpXceFgGw1L2ZIpedJeC6/jW3A62KzwjiEm1Zq5OzbMH5R0x2XgCdV1g6P7VVNHg1Xr4Uv4L6uQbAYlWl1KSN6iJSJKFmFIwkx/0avG7lmAGDYy5onDnV6MAEaBZ/HrsskWwADwVA6P3rs7aLGlUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773813325; c=relaxed/simple;
	bh=IuMF8pwjaUIADb5Hc+KEgalcsVjHm3FkhCO2R6DLNQc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gwxFkiDLZEUqGolqz+sxND2Wr1LBRXzWPrD05wJg1RqKqXXrLJ5URDT0WYRq4/3Y6aI4HYUELBGGwHH9pgcr9K5CQ3EaVGCaEusoRGloySDMmT5w/l9GdOveXJ827FzJtwX8lYZljmQ+1CjCt0kltkjRlwHCpKj4garQEsqBONM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=WznUMWtL; arc=none smtp.client-ip=115.124.30.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="WznUMWtL"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1773813317; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=Oz6FSNpJ9r2YXlOYiH9pQs1PlxKIRZcodnzRi118zlk=;
	b=WznUMWtLejxUE9Vgw5A5Pm/s4SvOH0r0k+vgD1MIntplCdypFJhkp1YadfmtzH08ui+fqmqR9n/YksNOmczf6oiFGHapOldUX3vObCNdUz70vvWKCx9jaYGYWUzoQ1y3BeZ2lygrHAVpHoMgSUCwQ5KKdCOAl394szTzW9hJWBE=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R681e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0X.DGewr_1773813315;
Received: from 30.221.129.103(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X.DGewr_1773813315 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 18 Mar 2026 13:55:16 +0800
Message-ID: <075f5ad1-6512-49cc-8959-daf733cc3d06@linux.alibaba.com>
Date: Wed, 18 Mar 2026 13:55:15 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] ocfs2/dlm: fix off-by-one in dlm_match_regions()
 region comparison
To: Junrui Luo <moonafterrain@outlook.com>, akpm <akpm@linux-foundation.org>
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 Yuhao Jiang <danisjiang@gmail.com>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, Sunil Mushran <sunil.mushran@oracle.com>
References: <SYBPR01MB7881A334D02ACEE5E0645801AF7BA@SYBPR01MB7881.ausprd01.prod.outlook.com>
 <SYBPR01MB78813DA26B50EC5E01F00566AF7BA@SYBPR01MB7881.ausprd01.prod.outlook.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <SYBPR01MB78813DA26B50EC5E01F00566AF7BA@SYBPR01MB7881.ausprd01.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 3/7/26 3:21 PM, Junrui Luo wrote:
> The local-vs-remote region comparison loop uses '<=' instead of '<',
> causing it to read one entry past the valid range of qr_regions. The
> other loops in the same function correctly use '<'.
> 
> Fix the loop condition to use '<' for consistency and correctness.
> 
> Fixes: ea2034416b54 ("ocfs2/dlm: Add message DLM_QUERY_REGION")
> Reported-by: Yuhao Jiang <danisjiang@gmail.com>
> Signed-off-by: Junrui Luo <moonafterrain@outlook.com>

Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
>  fs/ocfs2/dlm/dlmdomain.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/dlm/dlmdomain.c b/fs/ocfs2/dlm/dlmdomain.c
> index 0a28cb5ded2a..dc9da9133c8e 100644
> --- a/fs/ocfs2/dlm/dlmdomain.c
> +++ b/fs/ocfs2/dlm/dlmdomain.c
> @@ -1002,7 +1002,7 @@ static int dlm_match_regions(struct dlm_ctxt *dlm,
>  	for (i = 0; i < localnr; ++i) {
>  		foundit = 0;
>  		r = remote;
> -		for (j = 0; j <= qr->qr_numregions; ++j) {
> +		for (j = 0; j < qr->qr_numregions; ++j) {
>  			if (!memcmp(l, r, O2HB_MAX_REGION_NAME_LEN)) {
>  				foundit = 1;
>  				break;
> 

