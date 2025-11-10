Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 567A7221F26
	for <ocfs2-devel@lists.linux.dev>; Mon, 10 Nov 2025 06:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762755974; cv=none; b=pknQCX5wYdj6e3ls8/l5uIqJjNgaKxsSXzYBitQm6ZEN2qyp0eI/1GXYulKIKY8Wg6l0NeSBywAKMSzjlFg9M3bIoALFf+dRAhCsG0JbEeYwnRKKnDc0Q1J1Bo3nUHlQee2FV+wDh7c+Sd6ynos0EB3DKdPdL32f0TgL6oiJOdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762755974; c=relaxed/simple;
	bh=n3RVDn+pogopNgCkCxbLSjC2hxHzVPknKfMM5BdmUJE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fO84J578QTsB5x/jBSQzdIFRgN2mTmDC+NkCKsfMiNfqB0RFV5AjXYElsqAzcRJV0vvmheXSwVoGyzLlTLxwSBZ8hUGyGk0jlGBG9FFtJdkoDRrVL0ew14cglhR1JE30t1CC6S6OtxpmswcRyYSLVNsvpWUarZtPPsdPQrErsi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=Ua9vhHMe; arc=none smtp.client-ip=115.124.30.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="Ua9vhHMe"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1762755967; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=klz8jmf2eqV4vVCrDRdMJGY1+jLuPNXA4hAFNNM8gZ4=;
	b=Ua9vhHMeUZudmoNruytcI9qEeriII9CMMP6wEq4Yi7XvUxFgRVou9XGYNBiLLGfgkVgzOn8ieMRU3yzQTKnQWPWAOBxOiNSw5x5XWOA+mzhtXUvN7LmkFhtD4yjqQtVvtBf063fjg/To07hmRmYktGcKAaO8sL/8T5BOSkHhfb8=
Received: from 30.221.128.93(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0Ws-h2-M_1762755648 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 10 Nov 2025 14:20:48 +0800
Message-ID: <1f24e061-b863-404f-8341-d9c2191c2604@linux.alibaba.com>
Date: Mon, 10 Nov 2025 14:20:47 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: arm build error
To: Andrew Morton <akpm@linux-foundation.org>
Cc: ocfs2-devel@lists.linux.dev
References: <20251108212340.4c815638a2c231ef45873446@linux-foundation.org>
 <4c791da9-3bea-4cab-a41b-a3e1919e8e1e@linux.alibaba.com>
 <20251109090522.79e51167f4e5eacd5b5e4a28@linux-foundation.org>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20251109090522.79e51167f4e5eacd5b5e4a28@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2025/11/10 01:05, Andrew Morton wrote:
> On Sun, 9 Nov 2025 16:38:10 +0800 Joseph Qi <joseph.qi@linux.alibaba.com> wrote:
> 
>> Hi,
>>
>> In which mm tree branch?
> 
> mm-nonmm-unstable, which is where I queue ocfs2 changes.
> 
> That gets fed into linux-next.
> 

I can't directly clone mm.git so I've applied the queued ocfs2 patches
upon master, and then make allmodconfig && make -j96 in ARM server, but
don't see this build error.
BTW, I build with gcc 12.3.

Joseph

>> On 2025/11/9 13:23, Andrew Morton wrote:
>>>
>>> Is anyone else seeing this?  Current mm.git, arm allmodconfig;
>>>
>>>
>>> In file included from ./include/linux/string.h:382,
>>>                  from ./include/linux/bitmap.h:13,
>>>                  from ./include/linux/cpumask.h:12,
>>>                  from ./include/linux/smp.h:13,
>>>                  from ./include/linux/lockdep.h:14,
>>>                  from ./include/linux/spinlock.h:63,
>>>                  from ./include/linux/wait.h:9,
>>>                  from ./include/linux/wait_bit.h:8,
>>>                  from ./include/linux/fs.h:7,
>>>                  from fs/ocfs2/xattr.c:13:
>>> In function 'fortify_memset_chk',
>>>     inlined from 'ocfs2_reflink_xattr_header' at fs/ocfs2/xattr.c:6365:5:
>>> ./include/linux/fortify-string.h:480:25: error: call to '__write_overflow_field' declared with attribute warning: detected write beyond size of field (1st parameter); maybe use struct_group()? [-Werror=attribute-warning]
>>>   480 |                         __write_overflow_field(p_size_field, size);
>>>       |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>>> cc1: all warnings being treated as errors
>>>
>>> Callsite is
>>>
>>> 				memset(last, 0,
>>> 				       sizeof(struct ocfs2_xattr_entry));
>>>

