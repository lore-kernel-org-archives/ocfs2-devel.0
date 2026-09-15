Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FFFD4A013A
	for <ocfs2-devel@lists.linux.dev>; Tue, 15 Sep 2026 11:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789471608; cv=none; b=QCu0VWKvfKI3HS8vXI+NEGaDT+OSrC1HiwK0Ty4300s82KdKsUgyuM0VjoexcsGzr1KmniENpNReLd6c7+xDCgF8hzKMSEmSc4qggB76MVAXz9/Ms4kAJJyt0LyY08mHklv0dqREEeV6axtPQ/Vt/9C0zciMH6jZbD5AoI7n8Lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789471608; c=relaxed/simple;
	bh=gaA/kxB50cSDMqZM90BCKSuChZ+HkO+qPHzFinQVvOA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=f4NXZHO4mlBZ5xHSRLH4Rk1T4EjdShYoKlDx/29Mx/VWrPtitXPITbLfvuC3cLHvl7e+x2TlCWHojweTpo835sXehkbevnaWlaUlhs+kp3qhbcj7438lInxs/ye8pyTKxX6UfcxX0aH+3U9AY+FMUxzbNcS5lueuDarwl/t4JyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=lF/NmP9+; arc=none smtp.client-ip=115.124.30.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="lF/NmP9+"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1789471601; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=fCLN93VGucN/fcF3uBa1rWpSUOO9o0juY8XVqVKiJts=;
	b=lF/NmP9+IIq9zeDco65OgKtN+z9lbmOD79UBUeu/IXO4SUC1w+hLhtmNCVKKB6NpzlRGEhzdAwOYx3Ra6puaL3MzLMcPdny+EInpi4CykpT2inrkRMLGqCo17FY61JphRC4ZxaguHE4yLe2T43Jj0jCirUxooVdvmT4Vh/cfwxo=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0XB1PCzC_1789471600;
Received: from 30.166.1.13(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XB1PCzC_1789471600 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 15 Sep 2026 19:26:40 +0800
Message-ID: <fc9f0268-255e-4a68-ac3c-5bd69c242a73@linux.alibaba.com>
Date: Tue, 15 Sep 2026 19:26:40 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: update xattr count before moving bucket entries
To: Su Yue <glass.su@suse.com>, Heming Zhao <heming.zhao@suse.com>
Cc: ocfs2-devel@lists.linux.dev
References: <20260915041633.93575-1-glass.su@suse.com> <aqj05U-1FXW3293I@p15>
 <C0FCFF37-0F21-44B7-8992-6E8C21E8B51B@suse.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <C0FCFF37-0F21-44B7-8992-6E8C21E8B51B@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 9/15/26 4:28 PM, Su Yue wrote:
> 
> 
>> On Sep 15, 2026, at 15:42, Heming Zhao <heming.zhao@suse.com> wrote:
>>
>> On Tue, Sep 15, 2026 at 12:16:33PM +0800, Su Yue wrote:
>>> The xh_entries array is annotated with __counted_by_le(xh_count), so
>>> FORTIFY uses xh_count to determine its bounds. When inserting an entry
>>> into a bucket, ocfs2_xa_bucket_add_entry() shifts existing entries before
>>> incrementing xh_count. The destination therefore extends one entry past
>>> the bounds described by the old count.
>>>
>>> With CONFIG_CC_HAS_COUNTED_BY and CONFIG_FORTIFY_SOURCE enabled,
>>> ocfs2-test: single_run-WIP.sh -t reflink triggers the following failure while
>>> adding an extended attribute:
>>>
>>> [  150.156484] memmove: detected buffer overflow: 352 byte write of buffer size 336
>>> [  150.156487] WARNING: lib/string_helpers.c:1036 at __fortify_report+0x3d/0x50, CPU#15: reflink_test/2336
>>> [  150.160496] RIP: 0010:__fortify_report+0x40/0x50
>>> [  150.164031] Call Trace:
>>> [  150.164141]  <TASK>
>>> [  150.164232]  __fortify_panic+0x9/0xb
>>> [  150.164383]  ocfs2_xa_bucket_add_entry.cold+0x17/0x28 [ocfs2]
>>> [  150.164661]  ocfs2_xa_set+0x8fb/0xf40 [ocfs2]
>>>
>>> Increment xh_count before memmove() so the destination bounds include
>>> the new entry. Keep the local count unchanged to calculate the insertion
>>> position and move length from the original number of entries. The caller
>>> has already checked that there is enough space for the new entry.
>>>
>>> Fixes: 2f26f58df041b ("ocfs2: annotate flexible array members with __counted_by_le()")
>>
>> The code looks good to me. Just one note:
>> commit 2f26f58df041b introduced stricter bounds checking rather than fixing a bug.
>> This reference should go into the commit log instead of a Fixes tag.
> 
> IIUC, fixes tag can be used whatever the referenced commit is a bug fix,  code refactor or strict checker.
> I think it’s proper here. 
> Let’s wait for Joseph’s opinion.
> 
It seems the patch is semantically neutral. Same bytes written, same
control flow, same return values. Only the annotation-derived bound
during the access changes.

So I'd prefer Heming's suggestion, describe it in commit log instead of
a standalone Fixes tag.

BTW, please use 12-chars commit id instead.

Thanks,
Joseph
