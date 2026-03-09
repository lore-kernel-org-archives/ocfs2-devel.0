Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDA1020E030
	for <ocfs2-devel@lists.linux.dev>; Mon,  9 Mar 2026 01:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773019617; cv=none; b=tsmbES8JxFNCCFb6nAgFZdhn27ZJAbQkqePWIJvadtPdnzoyZ1NIzgmyHyguuGqdRtUeXYt/sOLiY/lEslx5PNlFq2h3aHkYXexCv9wIEAQrxCuMwH4T93PJF2ctSlXuVYt0s9UQa+L2UkShw3GGw1hHamSU00viETCxpfhR84k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773019617; c=relaxed/simple;
	bh=SqxOem8BOmCwJuP836tnU+boZen0ttxD0rkyKGUyCjk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PVRewG0XJ8lRJdSoMMkUQhDHEDPKeFE08JhHwbyveyhKE2sXZD5jCWAA9EJrJ4ewm0kfNq9WYtIMu/Wcgzl8sq5E+H78++D5bHauBTP2ePQTZ9nbgKgvgQHW83/iV0yTAg7UJVLfQ6CVkzGpcFrv0+AGEIY0rDUp6dbOaH9jrZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=WAsANKat; arc=none smtp.client-ip=115.124.30.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="WAsANKat"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1773019606; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=NOKId5WJiN7XNuQrTuohRqdblcfNtk8BfBVY0tUGN8E=;
	b=WAsANKatdBtzel3dvn6PbCC+/jAdoMI6+8ypRzNlEL5AM8bUj0snpqJlwnqqtN3XJJYHpAT0JzGdc+mTWtn30EeNNKXDShN1JPC2nKbyVin0oBnDQMWxkO1BatxJMbmSHpkRXFUsu5udkIImEyTztTgy71RePCh9S+Mrs2TKdEI=
Received: from 30.221.129.90(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X-T4B7d_1773019604 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 09 Mar 2026 09:26:46 +0800
Message-ID: <0ea3f3f9-8d3c-4ef4-b54b-c5594531f573@linux.alibaba.com>
Date: Mon, 9 Mar 2026 09:26:44 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] ocfs2/dlm: fix two bugs in dlm_match_regions()
To: Wengang Wang <wen.gang.wang@oracle.com>,
 Junrui Luo <moonafterrain@outlook.com>
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 Sunil Mushran <sunil.mushran@oracle.com>,
 "ocfs2-devel@lists.linux.dev" <ocfs2-devel@lists.linux.dev>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Yuhao Jiang <danisjiang@gmail.com>
References: <SYBPR01MB7881A334D02ACEE5E0645801AF7BA@SYBPR01MB7881.ausprd01.prod.outlook.com>
 <00EF98C8-5E0C-4778-9506-E6C2F54FB93B@oracle.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <00EF98C8-5E0C-4778-9506-E6C2F54FB93B@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 3/8/26 12:06 AM, Wengang Wang wrote:
> The two patches looks good to me.
> 
> Reviewed-by: Wengang Wang <wen.gang.wang@oracle.com <mailto:wen.gang.wang@oracle.com>>
> 
> Just unrelated to these patches, looking at function o2hb_get_all_regions,
> 
> 2519 int o2hb_get_all_regions(char *region_uuids, u8 max_regions)
> 2520 {
> 2521         struct o2hb_region *reg;
> 2522         int numregs = 0;
> 2523         char *p;
> 2524
> 2525         spin_lock(&o2hb_live_lock);
> 2526
> 2527         p = region_uuids;
> 2528         list_for_each_entry(reg, &o2hb_all_regions, hr_all_item) {
> 2529                 if (reg->hr_item_dropped)
> 2530                         continue;
> 2531
> 2532                 mlog(0, "Region: %s\n", config_item_name(&reg->hr_item));
> 2533                 if (numregs < max_regions) {
> 2534                         memcpy(p, config_item_name(&reg->hr_item),
> 2535                                O2HB_MAX_REGION_NAME_LEN);
> 2536                         p += O2HB_MAX_REGION_NAME_LEN;
> 2537                 }
> 2538                 numregs++;
> 2539         }
> 2540
> 2541         spin_unlock(&o2hb_live_lock);
> 2542
> 2543         return numregs;
> 2544 }
> 
> It seems that ‘numregs’ can mismatch with ‘region_uuids' (line 2538 VS line 2534) due to the limitation of ‘max_regions’
> though calling o2hb_get_all_regions() with max_regions being O2NM_MAX_REGIONS looks good.
> 

Yes, it looks wried here.
So why not fix it by moving 'numregs++' into if clause?

Thanks,
Joseph

