Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 047DE3DF00F
	for <ocfs2-devel@lists.linux.dev>; Tue, 26 May 2026 13:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.118
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779801494; cv=none; b=ArfnOx+gERFcpBZ+6dYMAq+/S6cvNTWavdENmat49q4DQuHhkOfwooKtqBV28IvAblcqHoI7t2mvrk2H90zysTrHMG27CNuffBFE+CNq7yfLrSWGmUS8iUp+5L7hngPYn5m/K5f4uBqkM4Di+8Yh0HqIuYdxGCqr0ei/NsRaJJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779801494; c=relaxed/simple;
	bh=53VY+YCLEGK5BHLmzBVTtKvSF6h8Xj1MQrw2m2Mu+DI=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:Cc:
	 In-Reply-To:Content-Type; b=aETMVTYp2hTOW6Quzgx2tMwZ3n1hucuLMZEPZzufG//DrjbQGA0Dvcah2MPj10lA1fbE/IqIquG0b9Lh/jZPfb+Y6fENmGe064fNz/iZzJTRqpry4j/IoYeYFpnYBmiLbOpvH6nt4BdjpbaVxMrkQrG0kqjGkRB486rTSrBLAPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=Fx/Uc85e; arc=none smtp.client-ip=115.124.30.118
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="Fx/Uc85e"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1779801487; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=v2vfqiZ4KlrA1H2oXkLwFH5Ezj31psb9+6DeHvOrMLA=;
	b=Fx/Uc85eYyrrUKC6/3silSZvcwHNHGPSAtVtij5sNZzAd2GB6t4Ij2HuL1pmq7QyYEQQ8Ne4XxTSbK3E4Xe9jm8V3E0Pzxdj7d4a7RiO/1QOCeRiua8Ra8UrLpQwyicePdBXvAUU0/nUv2LVXyDED3kbvskuqNP9FT8jQVJscrE=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0X3gLb7F_1779801485;
Received: from 30.221.147.124(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X3gLb7F_1779801485 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 26 May 2026 21:18:06 +0800
Message-ID: <66faed08-ed79-42ba-a605-3ec8465c89ca@linux.alibaba.com>
Date: Tue, 26 May 2026 21:18:05 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: On
 https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=775c17386a6fd
To: Dmitry Antipov <dmantipov@yandex.ru>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>
References: <979042b0a8e9a70189c9195c81dfb9fa26f789ef.camel@yandex.ru>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: "ocfs2-devel@lists.linux.dev" <ocfs2-devel@lists.linux.dev>
In-Reply-To: <979042b0a8e9a70189c9195c81dfb9fa26f789ef.camel@yandex.ru>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 5/26/26 7:09 PM, Dmitry Antipov wrote:
> Note that [1] opens the door for the things like [2] and [3] again. This happens
> when ocfs2_validate_dx_root() detects bad signature and ocfs2_error() remounts
> the filesystem readonly; since read operations are still allowed after that,
> ocfs2_dx_dir_lookup_rec() may be issued for a dx root block with invalid extent
> records (in particular, out-of-range l_count and l_next_free_rec values).
> 
> Dmitry
> 
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=775c17386a6fd
> [2] https://syzkaller.appspot.com/bug?extid=caacd220635a9cc3bac9
> [3] https://syzkaller.appspot.com/bug?extid=30b53487d00b4f7f0922

Don't understand in which case we will see a corrupted dr_list in
ocfs2_dx_dir_lookup_rec().

When ocfs2_validate_dx_root() fails, it will jump to read_failure logic
and buffer is not set to uptodate.

Could you please list a detail flow for it?

Thanks,
Joseph
