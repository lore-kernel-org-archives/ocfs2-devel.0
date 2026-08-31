Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C5E23AAF5A
	for <ocfs2-devel@lists.linux.dev>; Mon, 31 Aug 2026 06:32:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788157965; cv=none; b=qDU/DZAqscfxofAtwxmP1qxAM23WKZ/PnYyJDADcv4ZOgs8z6N6eB4yoJxlqXqYmej7Rz/MT096qXPUzo8vg5KSolzOJH2SO1E7deX63gGZd/AZCQ1ZrEVCrokaVpnTq+DovGJvWcizQi9hN4AfgiT5ToPILiVLUEZDMi5qJn4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788157965; c=relaxed/simple;
	bh=D9crxlgw6ub1xfbjPz8ZjCBR2G4y63a+JsPlfFGzU9s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=H1bFK4QCouTBmeuQZFhBjwrDgEJbt3txodjWeRxpaYy9qI4nsKT0uiiMK+yhQT5xJgGRWS41V1TdISwdPF4emBbQTiyABfZGtdIAH7pjMtxum9gVZ7+8E9hIO0exA5zZXsx8lfoo6TJTM5ANqUSv1sj7BFE2HuWT2p1o+dQQ/Qw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=kRtUnF7B; arc=none smtp.client-ip=115.124.30.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="kRtUnF7B"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788157960; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=t/36wknHFexnAeKdhAm/GZP0AHM1tihOrh4MgaZ6ly8=;
	b=kRtUnF7BtV+LmiiSTjShMJE0qmA40Nk/VNc56WnMuWDUohwu6hHu4NGyqWlV3SZbPlXGIrhL43lnwmTUB+XMsX8LettrGFmTGIP3LHFJ2cScYZnkjB7VAFWMoyjJC9pf3afM14Y6XRKryLYnrkC8YRr48Eij4xehTMaMmJBkots=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0X9tGWPr_1788157958;
Received: from 30.221.129.115(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X9tGWPr_1788157958 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 31 Aug 2026 14:32:39 +0800
Message-ID: <ac2bd4a2-808e-4f37-89de-930836320d36@linux.alibaba.com>
Date: Mon, 31 Aug 2026 14:32:38 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] ocfs2: validate active orphan slots during inode read
To: Andrew Morton <akpm@linux-foundation.org>,
 ZhengYuan Huang <gality369@gmail.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, ocfs2-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org, baijiaju1990@gmail.com, r33s3n6@gmail.com,
 zzzccc427@gmail.com, tom442288@tuta.io
References: <20260803030007.3993199-1-gality369@gmail.com>
 <20260804134157.38e3b8513d53c079f8b05823@linux-foundation.org>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260804134157.38e3b8513d53c079f8b05823@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 8/5/26 4:41 AM, Andrew Morton wrote:
> On Mon,  3 Aug 2026 11:00:05 +0800 ZhengYuan Huang <gality369@gmail.com> wrote:
> 
>> OCFS2 trusts active ordinary and append-DIO orphan slots read from dinodes.
>> A corrupted slot can therefore index osb_orphan_wipes or the slot-local
>> system-inode cache outside their allocations before the corruption is
>> reported.
> 
> Thanks.  AI review raised several possible issues, all pre-existing. 
> "out of bound access", "crash the kernel", "out-of-bounds heap access",
> "triggering this crash", etc.  All the usual things (seriously!).
> 
> 	https://sashiko.dev/#/patchset/20260803030007.3993199-1-gality369@gmail.com
> 
> None of which stands in the way of your fixes.
> 
> The best I can do with this onslaught is to make maintainers aware then
> move on.
> 
> I do wish that Sashiko was more organized about these drive-by bug
> reports.  Retain them in some lookable-uppable way for maintainers to
> look at when they have time.  This has been suggested to the Sashiko
> developers.  Perhaps one day...

Addressed in:
https://lore.kernel.org/ocfs2-devel/20260831062848.2743436-1-joseph.qi@linux.alibaba.com/T/#u

Thanks,
Joseph
