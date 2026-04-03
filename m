Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB3E52FDC27
	for <ocfs2-devel@lists.linux.dev>; Fri,  3 Apr 2026 09:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775208624; cv=none; b=dEYiLMWm+lw5a0kuzj+jLyiHfDxfHui99cBnl/dMvjyrjZFrXAq2EGSJD2oJXeAP0vIZS5jEGKHwIyhio5F5eXiFBTSKUsUq61jUsKCqwYtsl1aXhPq3Mor2JdJ/5JsBUcIrGlBEddODFN7Nu1PdzPgF/uCYIU0zNAV/kK5mqtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775208624; c=relaxed/simple;
	bh=3NHMJ1S+cIyUY2bqVYA9HbCYkP2UDNnI3HRlGOAZFeI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RDkwrYJU2jEFBF8YjPsSjnpXtfKC69dNWLevEB0Vhn1HevrgwOYJX2d0lataQ22kZAO42qfdnvS6bK6KLry4HHT3IA3X2GhWLwK4hUibEczew4bRPFEewKfiNQfa7chBHmElgFhQHPrnBMUdyNSN76GJZH7KFZkDNqiuUYX2/vA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=ZjaXdDP7; arc=none smtp.client-ip=115.124.30.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="ZjaXdDP7"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1775208614; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=NjSWYt2V6fO7NxMUGDUWpdEe+vws9h1rmtZOwOyxleE=;
	b=ZjaXdDP72U55dsrn6rMyzWPU7eEgQ+9aOT7GvCSZe9xdS/N5A+3Q4LB6n5M0V3yajaKInJUvF3MlnZjGswGV3/r57gqCdlKho+oMCbXmPru56URiBEZ4sMwlzqL3nOU9UvLJhQxtiOyCkJPG/j1+h6g9TQNLSzlnTPxTyrsHPdo=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R791e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0X0JrH26_1775208612;
Received: from 30.221.145.18(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X0JrH26_1775208612 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 03 Apr 2026 17:30:13 +0800
Message-ID: <de8b2fd1-5176-472c-9fe6-e0b464133e7f@linux.alibaba.com>
Date: Fri, 3 Apr 2026 17:30:11 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] ocfs2: stop BUG_ON crashes in suballoc invalid-dinode
 paths
To: ZhengYuan Huang <gality369@gmail.com>
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 baijiaju1990@gmail.com, r33s3n6@gmail.com, zzzccc427@gmail.com,
 Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 akpm <akpm@linux-foundation.org>
References: <20260403063016.438287-1-gality369@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260403063016.438287-1-gality369@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 4/3/26 2:30 PM, ZhengYuan Huang wrote:
> commit 10995aa2451a ("ocfs2: Morph the haphazard
> OCFS2_IS_VALID_DINODE() checks.") converted several OCFS2 dinode
> corruption checks from graceful error handling to BUG_ON() under the
> assumption that every caller only sees validated inode buffers.
> 
> That assumption does not always hold for JBD-managed buffers. The common
> inode read path can still hand suballoc code an invalid dinode, which turns
> crafted filesystem corruption into a kernel panic instead of a normal OCFS2
> filesystem error.
> 

When inode first read from disk, it will call ocfs2_validate_inode_block()
to validate if it is valid.
So it seems this is a code bug once the buffer is modified? Or how it
happens?

Thanks,
Joseph

> This series restores graceful corruption handling at the three
> independently reachable BUG_ON() sites in fs/ocfs2/suballoc.c:
> 
> 1. reserve_suballoc_bits()
> 2. claim_suballoc_bits()
> 3. _ocfs2_free_suballoc_bits()
> 
> The series is split per crash site so each patch fixes one bug. A broader
> follow-up could harden structural validation for JBD-managed inode reads,
> but that change touches a much wider read-side contract and is kept out of
> scope here.
> 
> ZhengYuan Huang (3):
>   ocfs2: handle invalid dinode in reserve_suballoc_bits
>   ocfs2: handle invalid dinode in claim_suballoc_bits
>   ocfs2: handle invalid dinode in _ocfs2_free_suballoc_bits
> 
>  fs/ocfs2/suballoc.c | 33 +++++++++++++++++++++------------
>  1 file changed, 21 insertions(+), 12 deletions(-)
> 

