Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com [209.85.208.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8475F12D203
	for <ocfs2-devel@lists.linux.dev>; Mon, 25 Mar 2024 05:28:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711344525; cv=none; b=adO2b0vTaBWV6tx5UOAHR9jl8TKGxawwqJ6qBMU9a6pKtCishGduaARClvy3m6GkidEH1PvIjVAI0GlEHKpCmcg45TcsvxRavLAKgiYKVd6g9xyhfAlKDBn5eWe/2w+04ZRwXzUXnP2YHhhht88bjxk97qI3aGgygmY5qbna0Jc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711344525; c=relaxed/simple;
	bh=NQCeD4Inp6Tm+/guheiIzOlme1aBWpswPFNSzeCIGR8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XzFTuISnuTn8hPbxQNQOhURU3SBNVhXBoJEVmRoh2i3jl6JU6mufGpbjrO5J8tLpt/VGoATBm20n5o6bayQAbJgDixhTfj0+AUx0Qu9iFr5aRa3M2HTXG3F4m5ZWGhdxJBOI8wVWaagrslXV1pylI7SmwQVgo0DKynjGPewhoPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ENamiP2u; arc=none smtp.client-ip=209.85.208.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ENamiP2u"
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-2d4a901e284so78808851fa.1
        for <ocfs2-devel@lists.linux.dev>; Sun, 24 Mar 2024 22:28:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1711344520; x=1711949320; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yxzyipAsE4p3hlExXdox5yZCSQXyFmU+SLFRmu8cZLo=;
        b=ENamiP2unOvmpB+uOpqxGmiidhR6nfVjey/qp0Abw0XGx6Hb2qGChOyYPSIlseNffJ
         WkdDdiYKZVpbUBa3Ec4T6rF38aqYTrfLB6LcLJKaAODQuvWdQ6fYBylx5BWxtcDjO2sG
         SgBkxCO9F77qMbWuC1liwIw6nseaUxQIiKvMmP6TUQOr4zXAqCCiITe7q7wpn0O6DpuR
         qW+VsRyhVSA+B7htnop3c+wP8P2hg4iO7oPuCNkTvZySfKSqbWG+c09jzy0sSwx/fjN5
         /2xwuv9ST801j/6Uyvk28A9GhGpzFy4aQJb6/pk7Cp84cAtUrZoQWalp4jEYfWFGZG6K
         67qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711344520; x=1711949320;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yxzyipAsE4p3hlExXdox5yZCSQXyFmU+SLFRmu8cZLo=;
        b=mp+39Oe+ELJd8wQzgs7PSL8KaBhprAyvqkMYP61mcMIk0uEaExWe20oLHuEmBgem5G
         o2JyHZS7XyvATdTNVpbtdyIa10MJTlj3DCCVSmWqBW2fCDD1eCSkzGy6BkYj6CSOBpTE
         BWk/Y49y4U9Rk4b83Nf27Jfno2P9I5edfisegDex2t5uQKr+gGX3R/ld1aDozUG44AXU
         CxpAC4vIdsyoU4pVWVFy/tOOxxf/Bv1tS6SCj8DYMiiUoMpT/FauShkH0sDTm6/ctozj
         UvJxCqSCM7skYsF3ZpbzX1XXwbUOJtQy4x/nv+wDP6/eMl7P7l5H/oWvuBbD2R8ib4TW
         izUQ==
X-Gm-Message-State: AOJu0YycYEqS0eMvPUVzGZGWAF9nTK0iVppdr6Djxx2ljyy7gIvaP7Gi
	6WjfpFnqUEOG9OY5pcSXr7XG8HMjAeK2EFagMhesS3DlkG/Mox6zOO//vp4loXfs4GE6JA0TZbT
	0
X-Google-Smtp-Source: AGHT+IEFs/i1XIkZXBjLwBgHp2jZOKS78wm7XMzH8mSYzAisHRHnrULvCRKn/YcQahPxs0bpv+Nxcg==
X-Received: by 2002:a2e:9683:0:b0:2d5:acde:9065 with SMTP id q3-20020a2e9683000000b002d5acde9065mr4680424lji.34.1711344520478;
        Sun, 24 Mar 2024 22:28:40 -0700 (PDT)
Received: from [10.202.32.28] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id s19-20020a170902989300b001dd67c8e108sm3901159plp.199.2024.03.24.22.28.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 24 Mar 2024 22:28:40 -0700 (PDT)
Message-ID: <64114b20-c2b5-408e-bf6e-ef7d2e66e573@suse.com>
Date: Mon, 25 Mar 2024 13:28:37 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [akpm-mm:mm-nonmm-unstable 38/38] fs/ocfs2/resize.c:127:46:
 sparse: sparse: incorrect type in argument 2 (different base types)
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev
References: <202403231258.mU2k0fih-lkp@intel.com>
 <d6091c0d-c0ac-423e-a518-d8371f4b006a@suse.com>
 <3ea2c39e-25b8-4fad-aba2-25c514c5ecfb@linux.alibaba.com>
Content-Language: en-US
From: Heming Zhao <heming.zhao@suse.com>
In-Reply-To: <3ea2c39e-25b8-4fad-aba2-25c514c5ecfb@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Joseph,

On 3/25/24 09:55, Joseph Qi wrote:
> 
> 
> On 3/23/24 6:51 PM, Heming Zhao wrote:
>> Hello Joseph,
>>
>> Please see my comment, only one warning need to be fixed, others are harmless.
>> Do I re-send v4 patch or send a new patch?
>>
> 
> To make sparse tool happy, we'd better fix all type conversion warnings
> and then send v4 version.
> 
> Joseph
> 
>> On 3/23/24 12:17, kernel test robot wrote:
>>> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-nonmm-unstable
>>> head:   e393dbc9246c3ae0160a07c8666838056eafbc44
>>> commit: e393dbc9246c3ae0160a07c8666838056eafbc44 [38/38] ocfs2: improve write IO performance when fragmentation is high
>>> config: i386-randconfig-061-20240322 (https://download.01.org/0day-ci/archive/20240323/202403231258.mU2k0fih-lkp@intel.com/config)
>>> compiler: clang version 17.0.6 (https://github.com/llvm/llvm-project 6009708b4367171ccdbf4b5905cb6a803753fe18)
>>> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240323/202403231258.mU2k0fih-lkp@intel.com/reproduce)
>>>
>>> If you fix the issue in a separate patch/commit (i.e. not just a new version of
>>> the same patch/commit), kindly add following tags
>>> | Reported-by: kernel test robot <lkp@intel.com>
>>> | Closes: https://lore.kernel.org/oe-kbuild-all/202403231258.mU2k0fih-lkp@intel.com/
>>>
>>> sparse warnings: (new ones prefixed by >>)
>>>>> fs/ocfs2/resize.c:127:46: sparse: sparse: incorrect type in argument 2 (different base types) @@     expected unsigned short [usertype] total_bits @@     got restricted __le16 [usertype] bg_bits @@
>>>      fs/ocfs2/resize.c:127:46: sparse:     expected unsigned short [usertype] total_bits
>>>      fs/ocfs2/resize.c:127:46: sparse:     got restricted __le16 [usertype] bg_bits
>>
>> This warning need to be modified, there should do endian converting.
>>
>>>>> fs/ocfs2/resize.c:128:33: sparse: sparse: incorrect type in assignment (different base types) @@     expected unsigned short [usertype] old_bg_contig_free_bits @@     got restricted __le16 [usertype] bg_contig_free_bits @@
>>>      fs/ocfs2/resize.c:128:33: sparse:     expected unsigned short [usertype] old_bg_contig_free_bits
>>>      fs/ocfs2/resize.c:128:33: sparse:     got restricted __le16 [usertype] bg_contig_free_bits
>>
>> This warning is harmless, the old_bg_contig_free_bits does backup job.
>> later code logic just uses this value to do restore value job. So we
>> don't need to do endian converting job.

Are you sure to fix this warning, converting here waste cpu time
and meaningless.

>>
>>>>> fs/ocfs2/resize.c:169:44: sparse: sparse: incorrect type in assignment (different base types) @@     expected restricted __le16 [usertype] bg_contig_free_bits @@     got unsigned short [usertype] old_bg_contig_free_bits @@
>>>      fs/ocfs2/resize.c:169:44: sparse:     expected restricted __le16 [usertype] bg_contig_free_bits
>>>      fs/ocfs2/resize.c:169:44: sparse:     got unsigned short [usertype] old_bg_contig_free_bits
>>
>> see my above comment. just use backup value. no need to convert endian.
>>
>>>      fs/ocfs2/resize.c: note: in included file (through include/linux/mmzone.h, include/linux/gfp.h, include/linux/xarray.h, ...):
>>>      include/linux/page-flags.h:242:46: sparse: sparse: self-comparison always evaluates to false
>>>      include/linux/page-flags.h:242:46: sparse: sparse: self-comparison always evaluates to false
>>
>> This warning belongs to mm part.
>>> -- 
>>>>> fs/ocfs2/suballoc.c:2566:41: sparse: sparse: incorrect type in assignment (different base types) @@     expected unsigned short [usertype] old_bg_contig_free_bits @@     got restricted __le16 [usertype] bg_contig_free_bits @@
>>>      fs/ocfs2/suballoc.c:2566:41: sparse:     expected unsigned short [usertype] old_bg_contig_free_bits
>>>      fs/ocfs2/suballoc.c:2566:41: sparse:     got restricted __le16 [usertype] bg_contig_free_bits
>>
>> Like above, there code do backup job, no need to convert endian.
>>>      fs/ocfs2/suballoc.c: note: in included file (through include/linux/mmzone.h, include/linux/gfp.h, include/linux/xarray.h, ...):
>>>      include/linux/page-flags.h:242:46: sparse: sparse: self-comparison always evaluates to false
>>>      include/linux/page-flags.h:242:46: sparse: sparse: self-comparison always evaluates to false
>> There belongs to mm.
>>
>>>      fs/ocfs2/suballoc.c:2493:17: sparse: sparse: context imbalance in 'ocfs2_block_group_clear_bits' - different lock contexts for basic block
>>
>> from [1], this warning is harmless.
>>
>> [1]: https://lwn.net/Articles/109066/
>>

I tried some methods to fix 'context imbalance' warning but failed.
Do you have idea to resolve it?

-Heming
