Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 865742D9EE7
	for <ocfs2-devel@lists.linux.dev>; Thu,  2 Apr 2026 07:10:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775113802; cv=none; b=JLEHDo3z37Id2/w/j6q20+M7kdVvUo15dAxIGs/EUYlP9lCHMWS8hkOE4oqCfPKJHw30EXYz1rkKHzl5KTG7MygRnOT3S/AYimLXzdBSKdjumh7lsdlUHLKVPP4+6azkIMp5ziZoYziT+aHB1P+kmRWDhUyQPMQbzs3Ur1CuXYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775113802; c=relaxed/simple;
	bh=wY4PlE5rpFaLW7c34c8/0BW9+YJDYmshCE0f1xxtyLg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=E+ELeTWziz8/sqfWPKCEih2Tm0oEMNZlGTOucUXdvSTqggiJA4gK5mfZUEFYl1MHH5fNhSfJjgqwNH+T/Mckg71MikvMbos1fafPCdtca2iLxdBVFEnhzxv4attWKoM3rJ6XEN4PCEW8WLCYcPR1giSkFYX0K/uBFFQZHVPVFaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=Dk/5YJlA; arc=none smtp.client-ip=115.124.30.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="Dk/5YJlA"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1775113798; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=7/bcHzoxBhHSWB56znuBy8dFkvJZA06eTq3e6wAQSj4=;
	b=Dk/5YJlADxvHfpsSMWF0ZQksS9q7cdt0jPxF3SaDqFS3Io4dKvmMjmlT+0+N9r/0rEl1g2LY2r/HCeobMQ9b2rlmBLRHogyYMLUeycKfDu3HsqyDXbbCT2NwPIGEn2Hjjpc3KgL/MsFIS+NbKzqM150YErlrASAxyqyuTXj52uk=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0X0GOB51_1775113796;
Received: from 30.221.145.69(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X0GOB51_1775113796 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 02 Apr 2026 15:09:57 +0800
Message-ID: <e6a5b222-bdd8-4423-9561-05bd5b1aaa3e@linux.alibaba.com>
Date: Thu, 2 Apr 2026 15:09:56 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] ocfs2: fix use-after-free in ocfs2_fault() when
 VM_FAULT_RETRY
To: Andrew Morton <akpm@linux-foundation.org>
Cc: tejas bharambe <tejas.bharambe@outlook.com>,
 "mark@fasheh.com" <mark@fasheh.com>, "jlbec@evilplan.org"
 <jlbec@evilplan.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "syzbot+a49010a0e8fcdeea075f@syzkaller.appspotmail.com"
 <syzbot+a49010a0e8fcdeea075f@syzkaller.appspotmail.com>,
 "ocfs2-devel@lists.linux.dev" <ocfs2-devel@lists.linux.dev>
References: <JH0PR06MB6632E1E416539AAF508ECAB28951A@JH0PR06MB6632.apcprd06.prod.outlook.com>
 <183fdc2a-b6f9-4ffb-8d12-a5ead1b0d207@linux.alibaba.com>
 <20260401211700.0749e640e5f7c67a062c2deb@linux-foundation.org>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260401211700.0749e640e5f7c67a062c2deb@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 4/2/26 12:17 PM, Andrew Morton wrote:
> On Thu, 2 Apr 2026 11:47:12 +0800 Joseph Qi <joseph.qi@linux.alibaba.com> wrote:
> 
>>
>>
>> On 4/2/26 11:08 AM, tejas bharambe wrote:
>>> filemap_fault() may drop the mmap_lock before returning VM_FAULT_RETRY,
>>> as documented in mm/filemap.c:
>>>
>>>   "If our return value has VM_FAULT_RETRY set, it's because the mmap_lock
>>>   may be dropped before doing I/O or by lock_folio_maybe_drop_mmap()."
>>>
>>> When this happens, a concurrent munmap() can call remove_vma() and free
>>> the vm_area_struct via RCU. The saved 'vma' pointer in ocfs2_fault() then
>>> becomes a dangling pointer, and the subsequent trace_ocfs2_fault() call
>>> dereferences it -- a use-after-free.
>>>
>>> Fix this by saving the inode reference before calling filemap_fault(),
>>> and removing vma from the trace event. The inode remains valid across
>>> the lock drop since the file is still open, so the trace can fire in
>>> all cases without dereferencing the potentially freed vma.
>>>
>>> Reported-by: syzbot+a49010a0e8fcdeea075f@syzkaller.appspotmail.com
>>> Closes: https://syzkaller.appspot.com/bug?extid=a49010a0e8fcdeea075f
>>> Suggested-by: Joseph Qi <joseph.qi@linux.alibaba.com>
>>> Signed-off-by: Tejas Bharambe <tejas.bharambe@outlook.com>
>>
>> Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> 
> Cool.
> 
> I think a cc:stable is needed?
> 
> The code looks like it dates back to 2011, so Fixes: isn't needed.
> 
> 
> A process thing: as far as I know, the -stable maintainers will
> automatically gather any patch which has a Fixes:.  But they've been
> asked not to do that for MM patches, so there's a risk they'll see an
> ocfs2 patch is from my tree and not backport it.  I like to add
> a cc:stable just to be sure.
> 
> Also, because this one doesn't have a Fixes: it might not be grabbed by
> the -stable trees.  An explicit cc:stable again removes doubt.
> 
> But that's just my late night waffling which can be ignored.  For every
> single patch I always consider cc:stable so other people don't have to ;)

Yes, cc stable is preferred here.

Thanks,
Joseph

