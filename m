Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 904DB426408
	for <ocfs2-devel@lists.linux.dev>; Fri,  4 Sep 2026 07:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788505589; cv=none; b=Yb6oLiEDhkOB26I+8YZHPxzJLaMnmxJZd5deqW7ehanTDolR5VhhinHtFoj37Qdzc2cj+4rACIanSMO+rVYEyZrYMy+6QhyRvMud+YF6Rq5oCydeCrcUgq8FDtPawUgryjf+atjMg3i5RockrpOX9rmKY9slLgCKX20v87tm9iQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788505589; c=relaxed/simple;
	bh=SLYWX6fmltl+vPJ2vPcmsTLqISulSTH5VJMWwyndt7I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JGWCZLCt5iZAiOCkWLb1Seas/iNk6OC0YYIMSR/Fhf9BOFrF6P2yJLDOafR59F4KzrL3mQuhygXhIMh5u8Z1kBGpyWVe3VMLv/lJLcl0as2qUdT+MV/wodPka0O9rAGphU+ybFesC7Q+y2PIdZjHn69rtzFdMl8qBpL1AXuKxsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=IQbhCZre; arc=none smtp.client-ip=115.124.30.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="IQbhCZre"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788505582; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=T9jAiwI+MoE2Opds6yP7kvVJ4gQx9t2dVhmsJtCXsGo=;
	b=IQbhCZreEauWhbsAf141EzFoH8I+uHlha0M5iy4bcYwAHQvGWY72YscxNRQgRhmp4NNummxtGCJP19DU1gJwIgmA4CT7G9fKABCNu1hR+jhV6+xKruGxR6MitJXAd32CKrp6+fOxRTeWXCZt62VTR/PcdIUPi66A+5eco7l04sM=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0XAI4urp_1788505580;
Received: from 30.221.129.151(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XAI4urp_1788505580 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 04 Sep 2026 15:06:21 +0800
Message-ID: <4a012149-fda6-4b3e-a422-8804e1df3ec0@linux.alibaba.com>
Date: Fri, 4 Sep 2026 15:06:20 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: make ocfs2_calc_xattr_init() return void
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Heming Zhao <heming.zhao@suse.com>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, ocfs2-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org
References: <20260904023751.3703334-1-joseph.qi@linux.alibaba.com>
 <20260903213618.04d90c1cf88323b0dae59008@linux-foundation.org>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260903213618.04d90c1cf88323b0dae59008@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 9/4/26 12:36 PM, Andrew Morton wrote:
> On Fri,  4 Sep 2026 10:37:51 +0800 Joseph Qi <joseph.qi@linux.alibaba.com> wrote:
> 
>> ocfs2_calc_xattr_init() used to read the default ACL off the parent
>> inode itself, so it could return an error from ocfs2_xattr_get_nolock().
>> Commit bd7c05fb4a47 ("ocfs2: fix circular locking dependency in
>> ocfs2_init_acl()") moved that lookup before the transaction starts and
>> deleted the error path, but left the now vestigial 'int ret = 0'
>> declaration and both 'return ret' statements behind, along with an
>> unreachable error branch in ocfs2_mknod().
>>
>> Drop the leftover variable and convert the return type to void, so the
>> callee states that it always succeeds and the caller no longer carries
>> a check that can never trigger.
>>
>> No functional change.
> 
> Thanks.
> 
>> Fixes: bd7c05fb4a47 ("ocfs2: fix circular locking dependency in ocfs2_init_acl()")
>> Reported-by: kernel test robot <lkp@intel.com>
>> Closes: https://lore.kernel.org/oe-kbuild-all/202609040247.8B3lmoqX-lkp@intel.com/
> 
> Gee, that's a bit picky, isn't it?

It's indeed a trivial fix.
I've followed the report mail to add the tags and I think it may help
kernel test robot tracking.

Thanks,
Joseph

