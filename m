Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7F7C4C97
	for <ocfs2-devel@lists.linux.dev>; Tue, 11 Nov 2025 00:50:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822206; cv=none; b=Qb6FzIyz5GV9JYRv9K9Km0QRZ1ERMoo9A8zZws9xSHys0XcWEC9rbV8gPk7+JJyOCZ3rsvLRcjD6w8heG1srfidKuQm3yOiYjvtqS/kScdelHzgyAUx0ax9Ju/bn1LkenUTAAPFBnKHln2srnPMGktXrpj2x8Ys64C7aopBdNY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822206; c=relaxed/simple;
	bh=YtKMMfUS7oZUvMroDXBJjGS7j+qM4zm51rBl8FGLuA8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=e6eotJEPmRlQOkNSjuNnkqJmMLU6st5gMmrcwcZoV9Kq6K+MFz8Y5anGvGhk2gNDT8VlLFgxluqPTEdE8Cr7ACoujdrlQzJwTbgyWQbLrNBpIXTOUs9tzdIqiSZuWiwJxreZNDqgmdwo+FoBlWgLu5gqktbLtZ/sOzDctgr0VdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=rR3YfL2m; arc=none smtp.client-ip=115.124.30.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="rR3YfL2m"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1762822200; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=s4HUgKxiJ2Bzjs5nsCl/JTQ6XXjPLhmE3FjUx5lRJrs=;
	b=rR3YfL2m7EPr/QICz+cgWsVAoGObMmCohfZyojzJaaKuB0WHqWCV/YXLZz+9eHGS6Qtl1C2lcJVeRPcSQ9eRnGeaWI9/JjWoNAvlCZA32Hwf3iYHLvBJN4T2N221k18tzzFOjKXXeJtBvVkNZjbHDAKAgSlkLhnyU9xVnvKx9Y4=
Received: from 30.221.128.130(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0Ws8hIiK_1762822199 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 11 Nov 2025 08:49:59 +0800
Message-ID: <2b904ec3-c4c7-4638-b3d4-5ea34e91ce64@linux.alibaba.com>
Date: Tue, 11 Nov 2025 08:49:59 +0800
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
 <1f24e061-b863-404f-8341-d9c2191c2604@linux.alibaba.com>
 <20251110075310.249336e414fe5f257e33383d@linux-foundation.org>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20251110075310.249336e414fe5f257e33383d@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2025/11/10 23:53, Andrew Morton wrote:
> On Mon, 10 Nov 2025 14:20:47 +0800 Joseph Qi <joseph.qi@linux.alibaba.com> wrote:
> 
>>
>>
>> On 2025/11/10 01:05, Andrew Morton wrote:
>>> On Sun, 9 Nov 2025 16:38:10 +0800 Joseph Qi <joseph.qi@linux.alibaba.com> wrote:
>>>
>>>> Hi,
>>>>
>>>> In which mm tree branch?
>>>
>>> mm-nonmm-unstable, which is where I queue ocfs2 changes.
>>>
>>> That gets fed into linux-next.
>>>
>>
>> I can't directly clone mm.git so I've applied the queued ocfs2 patches
>> upon master, and then make allmodconfig && make -j96 in ARM server, but
>> don't see this build error.
>> BTW, I build with gcc 12.3.
> 
> I'm using gcc-15.2.  I get my cross-compilers from
> https://www.kernel.org/pub/tools/crosstool/ - they're super easy to
> install and run.
> 
> 
>> Joseph
>>
>>>> On 2025/11/9 13:23, Andrew Morton wrote:
>>>>>
>>>>> Is anyone else seeing this?  Current mm.git, arm allmodconfig;
>>>>>
>>>>>
>>>>> In file included from ./include/linux/string.h:382,
>>>>>                  from ./include/linux/bitmap.h:13,
>>>>>                  from ./include/linux/cpumask.h:12,
>>>>>                  from ./include/linux/smp.h:13,
>>>>>                  from ./include/linux/lockdep.h:14,
>>>>>                  from ./include/linux/spinlock.h:63,
>>>>>                  from ./include/linux/wait.h:9,
>>>>>                  from ./include/linux/wait_bit.h:8,
>>>>>                  from ./include/linux/fs.h:7,
>>>>>                  from fs/ocfs2/xattr.c:13:
>>>>> In function 'fortify_memset_chk',
>>>>>     inlined from 'ocfs2_reflink_xattr_header' at fs/ocfs2/xattr.c:6365:5:
>>>>> ./include/linux/fortify-string.h:480:25: error: call to '__write_overflow_field' declared with attribute warning: detected write beyond size of field (1st parameter); maybe use struct_group()? [-Werror=attribute-warning]
> 
> I poked around a bit with struct_group(), no success.  It isn't a thing
> I'm familiar with and ocfs2_reflink_xattr_header() is very dense.
> 
> I'll take another look later.
> 
If this is newly build error, I guess it has some relations with:
ocfs2: annotate flexible array members with __counted_by_le()

It adds array bounds checking for ocfs2_xattr_header.xh_entries.

