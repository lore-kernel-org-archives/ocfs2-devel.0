Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D9633BB4A
	for <ocfs2-devel@lists.linux.dev>; Wed,  8 Apr 2026 05:47:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775627223; cv=none; b=bQwNhKZzBdYjdMr7FwtG9HQDFL1bUfS2at2KzC5Md4aXj4uFDGV48pyE1ri0J3YK7VLYrUb21UUdk/Q/Cj2Kmz4VuwhG21PyYgWJaTDftzZML45d+IFlXC3gba81Tkk71eq/dW6i4Rlnv7aTFsliMiTwSA+1YpiiJynPPEYvKWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775627223; c=relaxed/simple;
	bh=VL1LgjlwyVlXEU5Va58s7183yT4IePlmOBYPJ676uGA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lyqRnuKD1liuqpOupIT7LHqHvjbrwxkjr66LTgM+QpISWtiiG0pCYbTTDFb5W1du+g4IFoXlIY8wffg+p6P83RNUo1T4wTtH2UlkLK0bCAMMwpo6oVJW5NUpvTbn35UaoYfYxB8JQ9f320ANtrRe7aOBZGzMePHFYvB/yfuCgCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=XkVhTR7D; arc=none smtp.client-ip=115.124.30.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="XkVhTR7D"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1775627210; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=8HxFDS85wN9rvHZG9v5M3rk30ZGnshODqB3BJaGAY/w=;
	b=XkVhTR7DGGUvl79OTKr96/PvHgJ20ubDAKJsD8HF8g670Sm7Bjy3Z4Ay/XStFAQDFTtuM9koUOxJWr1kBDf6kJbelKIQdnGbBTLjLQ4hhYR0muXNvjM0oC4WWXCa1U8hvxVooHxRmwRneTP2mCVItUWVsSeOjqWxloWIM+bux+Y=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0X0dlaHW_1775627208;
Received: from 30.221.145.30(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X0dlaHW_1775627208 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 08 Apr 2026 13:46:48 +0800
Message-ID: <214f9901-a153-47d8-a099-847fb2c97aa4@linux.alibaba.com>
Date: Wed, 8 Apr 2026 13:46:47 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] ocfs2: fix use-after-free in ocfs2_fault() when
 VM_FAULT_RETRY
To: tejas bharambe <tejas.bharambe@outlook.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Tejas Bharambe <thbharam@gmail.com>,
 "ocfs2-devel@lists.linux.dev" <ocfs2-devel@lists.linux.dev>,
 "mark@fasheh.com" <mark@fasheh.com>, "jlbec@evilplan.org"
 <jlbec@evilplan.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "syzbot+a49010a0e8fcdeea075f@syzkaller.appspotmail.com"
 <syzbot+a49010a0e8fcdeea075f@syzkaller.appspotmail.com>,
 "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <20260403035333.136824-1-tejas.bharambe@outlook.com>
 <20260403122947.2afc337b5333fb1990a78a65@linux-foundation.org>
 <JH0PR06MB66320ABCFAD8F239FE5112B2895CA@JH0PR06MB6632.apcprd06.prod.outlook.com>
 <20260404175040.40a746040ddb0cb5ce347fe3@linux-foundation.org>
 <JH0PR06MB6632F1A4381AB798FED980CE895BA@JH0PR06MB6632.apcprd06.prod.outlook.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <JH0PR06MB6632F1A4381AB798FED980CE895BA@JH0PR06MB6632.apcprd06.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 4/8/26 11:50 AM, tejas bharambe wrote:
> Hi Andrew,
> 
> You're right, I missed that scenario.
> 
> The inode can be freed if the file descriptor is closed after mmap() and munmap() races with the fault handler.
> 
> I can do one of the following:
> 1. I can skip the trace firing when VM_FAULT_RETRY is set as I did in v1. It was changed to v4 after Joseph's suggestion to keep traces.
> 2. If we want to keep traces, we can use ihold()/iput() as shown below:
> 
> ihold(inode);   //pin inode
> ret = filemap_fault(vmf);
> trace_ocfs2_fault(OCFS2_I(inode)->ip_blkno, ...);  // safe, refcount held
> iput(inode);  //release inode
> 
> 
> Which approach do you prefer?
> 
It seems theoretically possible.
Since we only want to trace ip_blkno here, not inode itself, we can
simply save it at first.

Thanks,
Joseph

> Thanks,
> Tejas
> ________________________________________
> From: Andrew Morton <akpm@linux-foundation.org>
> Sent: Saturday, April 4, 2026 5:50 PM
> To: tejas bharambe <tejas.bharambe@outlook.com>
> Cc: Tejas Bharambe <thbharam@gmail.com>; ocfs2-devel@lists.linux.dev <ocfs2-devel@lists.linux.dev>; mark@fasheh.com <mark@fasheh.com>; jlbec@evilplan.org <jlbec@evilplan.org>; joseph.qi@linux.alibaba.com <joseph.qi@linux.alibaba.com>; linux-kernel@vger.kernel.org <linux-kernel@vger.kernel.org>; syzbot+a49010a0e8fcdeea075f@syzkaller.appspotmail.com <syzbot+a49010a0e8fcdeea075f@syzkaller.appspotmail.com>; stable@vger.kernel.org <stable@vger.kernel.org>
> Subject: Re: [PATCH v4] ocfs2: fix use-after-free in ocfs2_fault() when VM_FAULT_RETRY
> 
> On Sun, 5 Apr 2026 00:30:14 +0000 tejas bharambe <tejas.bharambe@outlook.com> wrote:
> 
>> Following is my response for question posted on https://sashiko.dev/#/patchset/20260403035333.136824-1-tejas.bharambe%40outlook.com
>>
>>
>> No. For ocfs2_fault() to be executing, the file must be open and
>> the process holds an active file descriptor. The inode's lifetime
>> is tied to the file's reference count, which remains held by the
>> file descriptor for the duration of the fault handler. munmap()
>> can free the VMA (decrementing vm_file's refcount) but cannot
>> free the inode as long as the file descriptor is open. The faulting
>> thread cannot call close() while it is inside the fault handler,
>> so the inode is guaranteed to outlive the trace call.
> 
> I don't think that's the scenario which Sashiko is suggesting.
> 
> Suppose userspace does
> 
>         fd = open(...);
>         p = mmap(fd, ...);
>         close(fd);
> 
> Now, that mmap is the only ref against fd.
> 
> Now, suppose that userspace does munmap() while another thread is in
> the fault handler.

