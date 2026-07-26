Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 721C1374A1D
	for <ocfs2-devel@lists.linux.dev>; Sun, 26 Jul 2026 06:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785049147; cv=none; b=PwqRhaRZ61Brh0J5q+o37S03EkDdNZeFSAZUzCmTDIardYXG4dm4/+n1cFkA7vUsGFbvKPQ8lxr7aWcD9o62VT7TJ3aY7zA8GPMMmVgKtA99MsU4uNUDJ8cKNhO0FD0jHJR81z9jV9Een2t6d+3B/HqYTxTre6JlhhuXkIoIrWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785049147; c=relaxed/simple;
	bh=75Dar6DOzOYSFgevmZOYLpjfvJ8oYqARcyMvBCqnFgM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fu9d2L4ZX8WQA4bec77YVoTueyxoL9OA/TGOSe7PY01/hgG1JtyHNzrCeOMUP9xbby+3nbNkOpzIJIvTzMsjpL/xauRHyH/A2SoGhX01NOHFSYwwhaH3uQpGdLY/7ICxNLso+hsTkc938MQk+93ksoHVIndlwUDwlw8/JEkP1sc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=yrLVmeyQ; arc=none smtp.client-ip=115.124.30.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="yrLVmeyQ"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1785049133; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=gO84aq2gd3sW8yk/H/Ra3yqu7PdlVXIbLEeSMywaZnU=;
	b=yrLVmeyQ8pFwVJ8wMjC+NbqCIvQuObvdSpkXvbGgOclGvGaYQ6mzNTvRyK6qm64r+bZEHJwuab+939o7XgTn+UmHDzYniA6TTrrwo4pZBYHLZQoc+LK7rRMQplxkB0+djvWmua5wZlItM0Z/CCPdR6tiXXZrn881NS3TQ2eYrSw=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0X7n14L7_1785049131;
Received: from 30.41.82.155(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X7n14L7_1785049131 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sun, 26 Jul 2026 14:58:52 +0800
Message-ID: <96dd1081-bed7-42e6-a84b-483ee36a9e62@linux.alibaba.com>
Date: Sun, 26 Jul 2026 14:58:50 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] ocfs2: harden heartbeat teardown races
To: Andrew Morton <akpm@linux-foundation.org>, Cen Zhang <zzzccc427@gmail.com>
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 baijiaju1990@gmail.com
References: <20260624095310.763763-1-zzzccc427@gmail.com>
 <20260725210217.8880c2417a832cad67b0d9d2@linux-foundation.org>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260725210217.8880c2417a832cad67b0d9d2@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 7/26/26 12:02 PM, Andrew Morton wrote:
> On Wed, 24 Jun 2026 17:53:08 +0800 Cen Zhang <zzzccc427@gmail.com> wrote:
> 
>> This series fixes two OCFS2 heartbeat/o2net teardown races found by
>> KASAN.
> 
> Thanks.
> 
> Having two Fixes: on [2/2] is quite confusing.  Fixes: tells -stable
> maintainers "add this patch to this kernel version".  So what are they
> to make of this conflicting advice?
> 
> But both Fixes: targets are from 2016 so it doesn't matter.  I'm assuming
> we don't need cc:stable on these, but that might be wrong?
> 

I'd prefer not cc stable since it introduce a reconstruction.

> 
> I'd really like to see Sashiko review on this series, but
> https://sashiko.dev/#/patchset/20260624095310.763763-1-zzzccc427@gmail.com
> says "failed to apply".  
> 

Not sure how it conflicts. The 2 patches can be applied cleanly in my
devel tree, on top of my o2hb_region_pin fixes.

Cen, could you please verify it on the latest linux-next?

Thanks,
Joseph

> I don't know what its problem is.  It tries linux-next and
> ocfs2-cluster-keep-heartbeat-local-node-stable.patch has been in
> linux-next for over a week and both patches apply cleanly to linux-next
> for me.
> 
> It's a shame, because these are two quite large and complex patches to
> old and very tricky code which hasn't proven to be problem-free in
> recent times!
> 
> Sigh.  I'll poke Roman, see if there's something that can be done
> longer-term to improve the situation.  Meanwhile, Joseph, are you
> really sure?

