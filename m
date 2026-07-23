Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3034812C534
	for <ocfs2-devel@lists.linux.dev>; Thu, 23 Jul 2026 01:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.111
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784769194; cv=none; b=B1PbRPp/k+bSTRVNfbl7Dr5ejNIly4+4rWqepI4zlaNP2ozWqPNcYGuoau8I1SIruVtM8odSWQWoUwVJ2IJ4E5nQi6JqfQRdgkeezxmh2jsCLOb5pxISZMq/HHUyVAHAmsO/G62X5iYqwmYzcWxPNvCUw3kzyH9zetUC0zHzQes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784769194; c=relaxed/simple;
	bh=K0CAErlsJNv6otKpGzv/1AOAiHjCyE21zFA2mK/v2P8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WxsXBODOtTwVgw+cI+o1/ckficggsWPdFeoA7Au61ucJWOJZo7XAU+ETu9L4AqkbJU3ldgBPnXEz1bcrsh3KfBFLdNF5mmnBx6w18nOYKBor77Y5Fqp7T+6V+rica+T5bz2oU7kga6w6LH1Ck3B9HDuLBjQc3EytvpbeQB3oHfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=BPTGfb8T; arc=none smtp.client-ip=115.124.30.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="BPTGfb8T"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1784769183; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=Jl/4PYAsOwZbQYkAWf1ikBdzEXw30ondxKmXIwFf1OY=;
	b=BPTGfb8T19ChZOisk3Iud1X8b7/mSGIe2g17bpoYjVJGTveSGGllbrDWoCrm+nQTAmR7qfofG5h5QbFbJak5i/coJEZvWPyqZrOv39cG5RwyzkYieBqV7du1ZhDOmfmpJYp3DhFQHYj40z927I/1iJTytoPj3AdDup3NrA4JtBY=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0X7eOnh8_1784769181;
Received: from 30.166.0.230(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X7eOnh8_1784769181 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 23 Jul 2026 09:13:02 +0800
Message-ID: <6f7a1532-c709-44ba-96d2-d32c85de7d58@linux.alibaba.com>
Date: Thu, 23 Jul 2026 09:13:00 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/3] ocfs2: cluster: o2hb_region_pin() fixes
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 Heming Zhao <heming.zhao@suse.com>, ocfs2-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org
References: <20260722124933.430554-1-joseph.qi@linux.alibaba.com>
 <20260722164348.994179ec6c81bdb85c416c56@linux-foundation.org>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260722164348.994179ec6c81bdb85c416c56@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 7/23/26 7:43 AM, Andrew Morton wrote:
> On Wed, 22 Jul 2026 20:49:30 +0800 Joseph Qi <joseph.qi@linux.alibaba.com> wrote:
> 
>> This series fixes three related issues in o2hb_region_pin(), all are
>> from the original implementation in commit:
>> 58a3158a5d17 ("ocfs2/cluster: Pin/unpin o2hb regions"):
> 
> Thanks.  I assume we want cc:stable on all three?
> 
> (If there's no known way in which userspace can hit any of these issues
> then cc:stable can be omitted, but I expect the stablebots will
> backport the patches anyway, based on their Fixes:)
> 

These bugs pre-existing for a long time. And it seems can't be easily
reproduced.

Cc stable is fine. But I'm afraid some stable trees may not be applied
cleanly.

Thanks,
Joseph
