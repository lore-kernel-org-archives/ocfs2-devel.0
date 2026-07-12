Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F71C3769F6
	for <ocfs2-devel@lists.linux.dev>; Sun, 12 Jul 2026 12:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783860220; cv=none; b=tBtmCyeRstTpBb60jkJ/eKM9maTJcUBrLkfF0N6wmqPqruivciIAvO0/aoV51Wo/Emb3lpTEDT27HOfTedBiLQcX2KjFdeb9m2MAnCwWNu6lYhlCkd10k8yIWQJpKnkqPBE/COy9B0YqEqIWexlIgxrybjGwGuMvZNm20LSSfOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783860220; c=relaxed/simple;
	bh=zqVMdxoNm2XT5PgbYhHqUWXvGOqnsC6zkr3zgk/Sy2Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iQlhtUgdhphGZSO87m8/4jfPL1/jkkSqHC7RGFft5c0CiwRZruRbAfs3waSB81+gvAEengAx3tnzStmH056Ilurj8ENyX/dvnuWYdYw93tv0gtSJNsMY2Lbf32GpKtQhyCnWIwRzceTAr1APEn/7LZdcXbjSE3W/+A9XDPEN1kc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=IVFj87Ku; arc=none smtp.client-ip=115.124.30.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="IVFj87Ku"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1783860208; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=N3B16MEu1BWDRpBq4JDEKledBQjIad1Ke/22GTvpEWc=;
	b=IVFj87KuO9lybEHfBNE+d3shZTfbb17flUiaBDki2+GqOJp9j/vyDlYOztyPemyP4j1/5XynhLpgrpWOzJxxOxC1b0JLtbiQkHVd2zg3mlN45EHW0CmdCdY6qa/TxRuYZPKOHQ8l3GTgTe+l8ZEX6Us+Q5QsPNgzVb/EbHwtPDo=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R551e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0X6s31tv_1783860207;
Received: from 30.134.110.188(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X6s31tv_1783860207 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sun, 12 Jul 2026 20:43:27 +0800
Message-ID: <0479b948-54e3-4dbe-a661-6c36070bb4f9@linux.alibaba.com>
Date: Sun, 12 Jul 2026 20:43:25 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] ocfs2: cluster: use GFP_NOFS for heartbeat bio
 allocation
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Heming Zhao <heming.zhao@suse.com>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, ocfs2-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org
References: <20260710071756.3586797-1-joseph.qi@linux.alibaba.com>
 <20260710172629.46dcd01fc4132e876b92d2f0@linux-foundation.org>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260710172629.46dcd01fc4132e876b92d2f0@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 7/11/26 8:26 AM, Andrew Morton wrote:
> On Fri, 10 Jul 2026 15:17:55 +0800 Joseph Qi <joseph.qi@linux.alibaba.com> wrote:
> 
>> o2hb_setup_one_bio() allocates the heartbeat bio with GFP_ATOMIC. The
>> disk heartbeat runs in the o2hb kernel thread (o2hb_do_disk_heartbeat),
>> which is process context and can sleep, so there is no atomicity
>> requirement here.
>>
>> GFP_ATOMIC lacks __GFP_DIRECT_RECLAIM, so the allocation is not served
>> from the fs_bio_set mempool reserve and can return NULL under memory
>> pressure. A failed heartbeat allocation aborts the heartbeat and can
>> lead to the local node being fenced, which is exactly what the old
>> comment worried about.
>>
>> Use GFP_NOFS instead. It keeps __GFP_DIRECT_RECLAIM so the allocation is
>> backed by the fs_bio_set mempool and cannot fail, while avoiding
>> recursion back into the filesystem during heartbeat I/O. As the
>> allocation can no longer fail, drop the dead ERR_PTR(-ENOMEM) path in
>> o2hb_setup_one_bio() and the now-redundant IS_ERR() handling in its
>> callers.
> 
> fyi, AI review asked a thing:
> 	https://sashiko.dev/#/patchset/20260710071756.3586797-1-joseph.qi@linux.alibaba.com

GFP_NOFS won't reintroduce the fencing stall. mempool_alloc strips
__GFP_DIRECT_RECLAIM on the first attempt (mempool_adjust_gfp) and
checks the reserve before any reclaim, so the common path never blocks.
Reclaim happens only if the reserve is fully drained — strictly better
than GFP_ATOMIC failing outright.

And the further improvement is what next patch exactly does.

Thanks,
Joseph
