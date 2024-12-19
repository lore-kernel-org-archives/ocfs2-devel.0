Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41C58217673
	for <ocfs2-devel@lists.linux.dev>; Thu, 19 Dec 2024 05:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.111
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734587494; cv=none; b=FzD/b7V+aBJpu3iuOE26tXClgxugDZNWaJ88NYUvinqpdQNnYjJwdKt0R5jqvuBj9eWjKt9ANlScRqKToLCTpD8B+UXvYhp0HC6NPYdFmBrFYZJnl/UpZpCume0q4SBlserOxmhoxxZyX0DieVzkkgfkysWlNZ28y2IcF4ycvgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734587494; c=relaxed/simple;
	bh=2hp7rFPnEf1qyY7KaOrWCK81/pSMuh7Uhxskfz45xlc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bJaGf4ZtOZ1q+u6PurjdZWy+FIi97AJHi9l6wOog2kSFSrc13mlQ2zq1h4T41k2WjlCZhAyRvMCddWY/PdMEQkEHz28/Mx7COtEvgLXq7ESEHWsPEla52jW2XXm8PE7xIpjtR+3w/LBmDXjtPhvK+0G9JHt7CqemR3/JanH0W+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=xJfiNUbb; arc=none smtp.client-ip=115.124.30.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="xJfiNUbb"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1734587489; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=mxuLvvy0ZXkcCtwDqgP9YnsO9yfGnvj0RLtjEaLQsg0=;
	b=xJfiNUbbnPiNSmGRV+SYQC63Zvt6Egj5t36CHYm4rRP1UE9yeLrHFK0FnX0sY+beSykc/jpnNMt3RCgeYYvN1uFyTUOEK1vg37Pnsezb7xmcflNEbJ2PeN27if21wp4iooQrK9PU99luGtr4ECX1Qau5lYHqoNpXiB77GD9Wu3A=
Received: from 30.221.145.61(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WLpDfQ5_1734587488 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 19 Dec 2024 13:51:29 +0800
Message-ID: <ad2361a5-652d-45da-b8f2-24ab74219d58@linux.alibaba.com>
Date: Thu, 19 Dec 2024 13:51:28 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ocfs2: fix slab-use-after-free due to dangling pointer
 dqi_priv
To: Dennis Lam <dennis.lamerice@gmail.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, akpm <akpm@linux-foundation.org>,
 linux-kernel@vger.kernel.org, ocfs2-devel@lists.linux.dev,
 syzbot+d173bf8a5a7faeede34c@syzkaller.appspotmail.com
References: <20241218023924.22821-2-dennis.lamerice@gmail.com>
 <f61955e5-9cfe-41af-aece-283b811817a8@linux.alibaba.com>
 <ee744944-359a-43ad-b9cf-72eac1b374e4@linux.alibaba.com>
 <CAGZfcdn2OeghHDhg5N7R34TLehaUH=tr_GvTVDydZAEwFRqdJw@mail.gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <CAGZfcdn2OeghHDhg5N7R34TLehaUH=tr_GvTVDydZAEwFRqdJw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2024/12/19 13:46, Dennis Lam wrote:
>> Moreover, better to leave a space before '{'.
>> Sorry for not pointing out this in my first reply.
>>
>> Thanks,
>> Joseph
>>
> 
> No worries, I think it's actually my fault for forgetting to use the
> checkpatch script before sending. I'll send another patch with the
> checkpatch warnings and errors fixed, and I'll try to be more mindful
> the next time I send a patch.
> 

Andrew has already done the favor.

Thanks,
Joseph


