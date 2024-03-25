Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50C081C68AA
	for <ocfs2-devel@lists.linux.dev>; Mon, 25 Mar 2024 11:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711366515; cv=none; b=kktTdiFR0mi140pr0hTeetImebVI+Wm4Q9Mw4bfN1+zk8nB3+hPCp5Q75V4qjwqJyQXljQe4TALAmSZ+P9vGLPJoA2KxrOpyWWZerhHDqzo8lXDt2H8OZ/U0ituGw57PhwDLOmwJomikW8slEeu/e57Rcfh9FnHc99wRwQRC+v4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711366515; c=relaxed/simple;
	bh=AHJFaELi/8jf3TiVviWD2EVX+42sProEr7WcKP7+LEk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fngrjo74xn8nHyIxhtKvSvptDoq/VR847zQDenvdWRcQ85/5LH//ar6nn8pFbLB8WqdFPi9ImVrIbAfmMMqWpIilr7LtW34v6H+8HCWiYSEUQwfrfTCrzT/YUyz49Enl5oiFEs0l6kqEsWcJobdTuE1XfNQBLgpDHFOHCW/BWKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=RmPe8qIB; arc=none smtp.client-ip=115.124.30.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="RmPe8qIB"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1711366506; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=wAOlkK1KnpSJvycJ/T/mLOHwOA56cpz7AuZiElZoO2w=;
	b=RmPe8qIBG7PteFJFiTa8B7ZdeN1RCmB0VZkbBPGZRJ6chF8Q6z3GG3LaqUMseGOub/REUcjGBgTXA9sVApCzs9CSe3JNbmd1jI6fDvLS4fGP32yCavhzfZ6/+mmBL4FzZmEaFv9J64AYfFtqGZrVs/iO2g9TnSDR/Z76VrDCP48=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045192;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---0W3FdV2i_1711366504;
Received: from 30.221.128.255(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0W3FdV2i_1711366504)
          by smtp.aliyun-inc.com;
          Mon, 25 Mar 2024 19:35:05 +0800
Message-ID: <e02325da-ae50-412e-8c16-9d6e4056b247@linux.alibaba.com>
Date: Mon, 25 Mar 2024 19:35:04 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [akpm-mm:mm-nonmm-unstable 38/38] fs/ocfs2/resize.c:127:46:
 sparse: sparse: incorrect type in argument 2 (different base types)
Content-Language: en-US
To: Heming Zhao <heming.zhao@suse.com>
Cc: ocfs2-devel@lists.linux.dev
References: <202403231258.mU2k0fih-lkp@intel.com>
 <d6091c0d-c0ac-423e-a518-d8371f4b006a@suse.com>
 <3ea2c39e-25b8-4fad-aba2-25c514c5ecfb@linux.alibaba.com>
 <64114b20-c2b5-408e-bf6e-ef7d2e66e573@suse.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <64114b20-c2b5-408e-bf6e-ef7d2e66e573@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 3/25/24 1:28 PM, Heming Zhao wrote:
> Hi Joseph,
> 
> On 3/25/24 09:55, Joseph Qi wrote:
>>
>>
>> On 3/23/24 6:51 PM, Heming Zhao wrote:
>>> Hello Joseph,
>>>
>>> Please see my comment, only one warning need to be fixed, others are harmless.
>>> Do I re-send v4 patch or send a new patch?
>>>
>>
>> To make sparse tool happy, we'd better fix all type conversion warnings
>> and then send v4 version.
>>
>> Joseph
>>
>>> On 3/23/24 12:17, kernel test robot wrote:
>>>> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-nonmm-unstable
>>>> head:   e393dbc9246c3ae0160a07c8666838056eafbc44
>>>> commit: e393dbc9246c3ae0160a07c8666838056eafbc44 [38/38] ocfs2: improve write IO performance when fragmentation is high
>>>> config: i386-randconfig-061-20240322 (https://download.01.org/0day-ci/archive/20240323/202403231258.mU2k0fih-lkp@intel.com/config)
>>>> compiler: clang version 17.0.6 (https://github.com/llvm/llvm-project 6009708b4367171ccdbf4b5905cb6a803753fe18)
>>>> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240323/202403231258.mU2k0fih-lkp@intel.com/reproduce)
>>>>
>>>> If you fix the issue in a separate patch/commit (i.e. not just a new version of
>>>> the same patch/commit), kindly add following tags
>>>> | Reported-by: kernel test robot <lkp@intel.com>
>>>> | Closes: https://lore.kernel.org/oe-kbuild-all/202403231258.mU2k0fih-lkp@intel.com/
>>>>
>>>> sparse warnings: (new ones prefixed by >>)
>>>>>> fs/ocfs2/resize.c:127:46: sparse: sparse: incorrect type in argument 2 (different base types) @@     expected unsigned short [usertype] total_bits @@     got restricted __le16 [usertype] bg_bits @@
>>>>      fs/ocfs2/resize.c:127:46: sparse:     expected unsigned short [usertype] total_bits
>>>>      fs/ocfs2/resize.c:127:46: sparse:     got restricted __le16 [usertype] bg_bits
>>>
>>> This warning need to be modified, there should do endian converting.
>>>
>>>>>> fs/ocfs2/resize.c:128:33: sparse: sparse: incorrect type in assignment (different base types) @@     expected unsigned short [usertype] old_bg_contig_free_bits @@     got restricted __le16 [usertype] bg_contig_free_bits @@
>>>>      fs/ocfs2/resize.c:128:33: sparse:     expected unsigned short [usertype] old_bg_contig_free_bits
>>>>      fs/ocfs2/resize.c:128:33: sparse:     got restricted __le16 [usertype] bg_contig_free_bits
>>>
>>> This warning is harmless, the old_bg_contig_free_bits does backup job.
>>> later code logic just uses this value to do restore value job. So we
>>> don't need to do endian converting job.
> 
> Are you sure to fix this warning, converting here waste cpu time
> and meaningless.
> 

Since it is just used as a saved value, why not define it as __le16?

>>>
>>>>>> fs/ocfs2/resize.c:169:44: sparse: sparse: incorrect type in assignment (different base types) @@     expected restricted __le16 [usertype] bg_contig_free_bits @@     got unsigned short [usertype] old_bg_contig_free_bits @@
>>>>      fs/ocfs2/resize.c:169:44: sparse:     expected restricted __le16 [usertype] bg_contig_free_bits
>>>>      fs/ocfs2/resize.c:169:44: sparse:     got unsigned short [usertype] old_bg_contig_free_bits
>>>
>>> see my above comment. just use backup value. no need to convert endian.
>>>
>>>>      fs/ocfs2/resize.c: note: in included file (through include/linux/mmzone.h, include/linux/gfp.h, include/linux/xarray.h, ...):
>>>>      include/linux/page-flags.h:242:46: sparse: sparse: self-comparison always evaluates to false
>>>>      include/linux/page-flags.h:242:46: sparse: sparse: self-comparison always evaluates to false
>>>
>>> This warning belongs to mm part.
>>>> -- 
>>>>>> fs/ocfs2/suballoc.c:2566:41: sparse: sparse: incorrect type in assignment (different base types) @@     expected unsigned short [usertype] old_bg_contig_free_bits @@     got restricted __le16 [usertype] bg_contig_free_bits @@
>>>>      fs/ocfs2/suballoc.c:2566:41: sparse:     expected unsigned short [usertype] old_bg_contig_free_bits
>>>>      fs/ocfs2/suballoc.c:2566:41: sparse:     got restricted __le16 [usertype] bg_contig_free_bits
>>>
>>> Like above, there code do backup job, no need to convert endian.
>>>>      fs/ocfs2/suballoc.c: note: in included file (through include/linux/mmzone.h, include/linux/gfp.h, include/linux/xarray.h, ...):
>>>>      include/linux/page-flags.h:242:46: sparse: sparse: self-comparison always evaluates to false
>>>>      include/linux/page-flags.h:242:46: sparse: sparse: self-comparison always evaluates to false
>>> There belongs to mm.
>>>
>>>>      fs/ocfs2/suballoc.c:2493:17: sparse: sparse: context imbalance in 'ocfs2_block_group_clear_bits' - different lock contexts for basic block
>>>
>>> from [1], this warning is harmless.
>>>
>>> [1]: https://lwn.net/Articles/109066/
>>>
> 
> I tried some methods to fix 'context imbalance' warning but failed.
> Do you have idea to resolve it?
> 

Seems sparse is not suitable for checking the following code style:
if (condition)
	spin_lock(&lock);
...
if (condition)
	spin_unlock(&lock);

I don't have a better idea to eliminate this warning. Seems we have to
leave it alone.

Thanks,
Joseph
