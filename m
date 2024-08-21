Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CCD81B5EB7
	for <ocfs2-devel@lists.linux.dev>; Wed, 21 Aug 2024 07:58:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724227124; cv=none; b=U3Yw4VfC5dOYdTonLRbqVlF2dP6j6ndg7NGOuJ8jqlIGF4kTLxbFetVUI6+f30OYUo3/0DTxk7yMwk35IW5qlIc7mQI9fPzKLIp76rqMjFnaQuKDf3z8vx3gq8cxcUPCc1YEeegAybHPjotb+1uJd4y/1w2ls5w+eIjF6KytbEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724227124; c=relaxed/simple;
	bh=8osB/wcFehwq1pA0msz9b7FFVSe5bxbfn1XCWsoKrs8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nwG2t+MPnxW8+1IOAbShSp+jfUfZ0ad0v6McIfNZSezDHIwkinn6cTsLjHcJnFg6xH1MzWjt3MjYHOnBojYwAYUbY4FHfLqk+EvI9Vgce2J47OIk2gIHBVdX5QMnbtvc7KJ1QjkaE/cNw+NA437e7PbHfpW6XjgZFvk0xR4d1H4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=gNcbPSH5; arc=none smtp.client-ip=115.124.30.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="gNcbPSH5"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1724227118; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=LEqqDi/krVo1lceJDkIrISzHv6al/xT2SjSgavb2vck=;
	b=gNcbPSH5Z9Jxsj/R7tB/z5LtzewOb/3uwA3GBahVdz5s+IiAOYGOuOq3S4Gf0u1l1Gxr3zaHQu9rEWXVBLbXkwfQYI4cmC0ecty1XDP2ieYVIUZ7IKYVcK/vi8tTo7NldfnWD9CjylIBZ9s3qFE0oQKycRKu+nA0sa5QarYmavI=
Received: from 30.221.129.221(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WDLAvpM_1724227116)
          by smtp.aliyun-inc.com;
          Wed, 21 Aug 2024 15:58:37 +0800
Message-ID: <1a063827-5cf3-42df-a690-f3c644c10996@linux.alibaba.com>
Date: Wed, 21 Aug 2024 15:58:36 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V4 2/2] ocfs2: Fix possible null-ptr-deref in
 ocfs2_set_buffer_uptodate
To: "heming.zhao@suse.com" <heming.zhao@suse.com>,
 Lizhi Xu <lizhi.xu@windriver.com>
Cc: jlbec@evilplan.org, linux-kernel@vger.kernel.org, mark@fasheh.com,
 ocfs2-devel@lists.linux.dev,
 syzbot+ab134185af9ef88dfed5@syzkaller.appspotmail.com,
 syzkaller-bugs@googlegroups.com
References: <0dd1d1b4-5e83-449e-af48-3811abd2e6a4@suse.com>
 <20240821065517.3844044-1-lizhi.xu@windriver.com>
 <9e4daf9b-a8f6-4d95-8e4b-125ef7b03911@suse.com>
Content-Language: en-US
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <9e4daf9b-a8f6-4d95-8e4b-125ef7b03911@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 8/21/24 3:37 PM, heming.zhao@suse.com wrote:
> Hi,
> 
> On 8/21/24 14:55, Lizhi Xu wrote:
>> On Wed, 21 Aug 2024 14:23:08 +0800, Heming Zhao wrote:
>>> Where is my "Reviewed-by" tag, and where is [patch 1/2]?
>> Sorry about your "Reviewed-by" tag, I remove it, if you don't mind, you can
>> add it by yourself.
> 
> Good answer!
> 
> This patch issue was found by me, and I also pointed out how to fix it, then take the time
> to review your code. But in the end, you removed my "Reviewed-by" tag.
> 

Seems a misunderstanding, take it easy:) 
Lizhi may think since this is a new version, it needs a new round review.

>>
>> In my previous email, I explicitly stated that only this patch should
>> be sent separately, as the first patch has already been reviewed by two
>> reviewers. If the second patch is updated with the first patch, I
>> personally think it is unnecessary.
>>
>> [patch 1/2]: https://lore.kernel.org/all/20240820094512.2228159-1-lizhi.xu@windriver.com/
>>
>> Lizhi
> 
> It looks like you don't have basis knowledge of how to send patches.
> 
> I will never reply to or review any of your mails/patches.
