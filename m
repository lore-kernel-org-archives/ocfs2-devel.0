Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B9F12264BB
	for <ocfs2-devel@lists.linux.dev>; Tue,  7 Apr 2026 01:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.112
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775526286; cv=none; b=U9e05FWJfJq8XOEv5fwwrw0dYsc1K3DsIojfYmIOkXEZ6Km2KjJ+dqbMHtosT9SBsF3og9aJ8ujEITadZ2CWdqQT412nurJ1Q+8S0aoM5yKBEnpBgboX/h3ICrvUI3D8ZzEEUxyxT076jhU1Vb//a7EQzymQqGpoLOzQ0Jj6wg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775526286; c=relaxed/simple;
	bh=7ixh2BK4SaH3XLpN6z6EYte+umaVCbLbdt9Ktz3fuHE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uDNYhYVLXxdw02JqkPGVKHdQzkPhqciZzu/qGYdE6EceU9n8uy+7P5AFcN9wuiRTRhWcrfNFTqpculF1RTd97+4cQ3ADIqDK49RVboyJayRnsL4EdSmqZXjgk+F8XdgdsycMKLR6/gpBIrnLHDppFUH/spkKiBc0JQqcrx/qPmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=bWvgztQw; arc=none smtp.client-ip=115.124.30.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="bWvgztQw"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1775526280; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=SwZZDo9gvwBJOFxueZcE2LRfgM690V0sXvqgqgqIAk0=;
	b=bWvgztQwCs05yxPlUdJPl41P92Z4+oJrtwTNThZTjI3UPBMCxh23WUGNR1a5doNM/7S5YL+e+IxX9PZbZGlSiViAp0eb/Z4E+gXCfO0aOR3gD3C74djQH86Ze5ITcgK/o8OjBEMSL9l/h2RVWBZp5Mtkrq6QYG+lcQZgBmL6hrs=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0X0a7j5l_1775526279;
Received: from 30.221.145.153(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X0a7j5l_1775526279 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 07 Apr 2026 09:44:39 +0800
Message-ID: <0c733707-d339-42f4-a11b-b597487918dc@linux.alibaba.com>
Date: Tue, 7 Apr 2026 09:44:38 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/4] ocfs2: consolidate extent list validation into block
 read callbacks
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Heming Zhao <heming.zhao@suse.com>, ZhengYuan Huang
 <gality369@gmail.com>, ocfs2-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org
References: <20260403090803.3860971-1-joseph.qi@linux.alibaba.com>
 <20260403122714.d01b268f8ac8148aaf55dc3c@linux-foundation.org>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260403122714.d01b268f8ac8148aaf55dc3c@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 4/4/26 3:27 AM, Andrew Morton wrote:
> On Fri,  3 Apr 2026 17:07:59 +0800 Joseph Qi <joseph.qi@linux.alibaba.com> wrote:
> 
>> ocfs2 validates extent list fields (l_count, l_next_free_rec) at various
>> points during extent tree traversal. This is fragile because each caller
>> must remember to check for corrupted on-disk data before using it.
>>
>> This series moves those checks into the block read validation callbacks
>> (ocfs2_validate_dx_root and ocfs2_validate_extent_block), so corrupted
>> fields are caught early at block read time. Redundant post-read checks
>> are then removed.
> 
> AI review asked a few questions - mainly suggesting additional changes.
> https://sashiko.dev/#/patchset/20260403090803.3860971-1-joseph.qi@linux.alibaba.com

Yes, not regressions, actually some improvements.

Thanks,
Joseph


