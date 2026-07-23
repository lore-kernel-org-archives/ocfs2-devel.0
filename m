Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 375832DC350
	for <ocfs2-devel@lists.linux.dev>; Thu, 23 Jul 2026 03:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.118
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784778029; cv=none; b=GjA87GzbZetOLQ49cBH/Rn9kc0sH1a9LJ8pyZE9J0O8pKv2J6DO/tzVC8u/xn3dUwA1BPtD39Nl/9Fa9mCSvcFMP+DTRSl2UrHIXyLWYCON55DPVNpZE/rRT7rfaK/ElcBSYz3O3WjHF/0PHHvHw3/auK9+0O98mReY3noIRfD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784778029; c=relaxed/simple;
	bh=o8aBj5/7LtA86Lx+nBVt2IuN+t4nFsa9vQMvJDGPBII=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lR1BCp/5WXsbZ1rWrGCS9+omK4ftvvNEmjshWLGd1MBOmc59dc3bwxJF7dEbNcaisu73o9wwtJld5/75AL3fthz54eEJjptHhUSH9pUkjVIVz8lhS8KO8jVFyCddJdk/lrjfXo9FpA2QRPsvtDa70RLOGulIei4Uifp/h2J+wH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=LWEvVrdM; arc=none smtp.client-ip=115.124.30.118
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="LWEvVrdM"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1784778024; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=2ZTHDOQMuBGPgIkn8iSQLMfyDZR08lBDZNNdLXEZagk=;
	b=LWEvVrdMUGm5lhHKFGTTu17ZbwaJ7ZTz6S8I2A5F5uFQQNx5S9y039iKvG8ic8h48oTVAFle8VwFKTKx1tXnSmjW5YcjEVJnPGhWwYuwQFvQ0AgVY6DaAkBCvqmE+LzNAStfQubMdl6LQjHuPypBD4H9LPnznqNIsnsdopZPy7U=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0X7evV3i_1784778023;
Received: from 30.166.0.230(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X7evV3i_1784778023 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 23 Jul 2026 11:40:23 +0800
Message-ID: <4be16c98-32c1-4d87-beeb-368a45dafa40@linux.alibaba.com>
Date: Thu, 23 Jul 2026 11:40:21 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: validate truncate log dinode before caching
To: ZhengYuan Huang <gality369@gmail.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, ocfs2-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org, baijiaju1990@gmail.com, r33s3n6@gmail.com,
 zzzccc427@gmail.com, tom442288@tuta.io
References: <20260722091157.3141414-1-gality369@gmail.com>
 <de598854-410c-4fae-95a5-8db0ee6d47e5@linux.alibaba.com>
 <CAOmEq9V-g+AxUw9XZr2Kk5_MYffAndsrbTPfXOyKDiH-eGSKGg@mail.gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <CAOmEq9V-g+AxUw9XZr2Kk5_MYffAndsrbTPfXOyKDiH-eGSKGg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 7/23/26 11:05 AM, ZhengYuan Huang wrote:
> On Wed, Jul 22, 2026 at 8:56 PM Joseph Qi <joseph.qi@linux.alibaba.com> wrote:
>>
>>
>>
>> On 7/22/26 5:11 PM, ZhengYuan Huang wrote:
>>> [BUG]
>>> A corrupted truncate log dinode can pass through mount initialization and
>>> reach the delayed flush worker, where it triggers:
>>>
>>> kernel BUG at fs/ocfs2/alloc.c:6019!
>>> Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
>>> RIP: 0010:__ocfs2_flush_truncate_log+0xa87/0xf10 fs/ocfs2/alloc.c:6019
>>> Call Trace:
>>>  ocfs2_flush_truncate_log fs/ocfs2/alloc.c:6084 [inline]
>>>  ocfs2_truncate_log_worker+0xa9/0x180 fs/ocfs2/alloc.c:6097
>>>  process_one_work+0x8e0/0x1980 kernel/workqueue.c:3263
>>>  ...
>>>
>>
>> I've encountered this BUG occasionality. But I don't see why it happens.
>> Do you have more clues on how to reproduce it?
>>
>> Thanks,
>> Joseph
> 
> Thanks for looking into this.
> 
> This bug was originally found by our fuzzing tool. We tried to
> reproduce it using the automatically saved disk image and syscall
> program, but so far we have been unable to reproduce the BUG in
> __ocfs2_flush_truncate_log directly. Instead, the same artifacts have
> triggered two other issues:
> 
> KASAN: use-after-free Read in ocfs2_dx_dir_search
> kernel BUG in ocfs2_grow_tree
> 
> For the use-after-free in ocfs2_dx_dir_search, I previously submitted
> a patch that addresses what I believe is its root cause:
> 
> https://lore.kernel.org/all/20260416082105.1295887-1-gality369@gmail.com/
> 
> However, I have not received any feedback on the patch yet, and at
> this point we are not sure whether that issue is related to the
> truncate-log corruption reported here.
> 

It seems I've missed the thread.

And I've found a similar one in:
https://lore.kernel.org/ocfs2-devel/20260713205625.92391-1-doruk@0sec.ai/

Could you please check if it fixes the same issue?

Thanks,
Joseph

> We are continuing to investigate and will share any new findings. In
> the meantime, the original artifacts generated by our fuzzer are
> available here:
> 
> https://drive.google.com/file/d/1zCJoUb2uwVqTrGIM4JFLbwkcHRz04TJo/view?usp=sharing
> 
> The archive contains the disk image, the PoC program, and a kernel
> log. To run the reproducer, mount the supplied disk image and execute
> the PoC. Please note that, in our current tests, these artifacts can
> trigger the two issues mentioned above, but they do not reproduce the
> BUG in __ocfs2_flush_truncate_log. The archive also includes the
> kernel log captured when the original BUG occurred, which may help
> with further investigation.
> 
> Thanks,
> ZhengYuan Huang

