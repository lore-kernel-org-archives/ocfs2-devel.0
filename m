Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B50C5381
	for <ocfs2-devel@lists.linux.dev>; Mon, 26 Feb 2024 01:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708909882; cv=none; b=AN3wfUxYLX8kGFdeigO6fTqOdOOHHO8tVKRaUpmfQF213+01RGWp1C+iERrPsdjJKjFVrx9H0vBweR6k/DrwhKJGUoDaIE5E48+mrIwaMik6i0mlUFSupqsx0jPh4wSxFuPXdSEhwTTd4ecily+goDL2vQovUH5kgStStKoNDSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708909882; c=relaxed/simple;
	bh=iUNCxdIUqHGbJaptFDXrwwpJ5FvpLDYcaqS14qG5nIg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SVpoRNKDczUOeUgvns9iKxnVsEI/xw4s7hoB46l3ygQZVRbKCMt/rGMehF86FFoG6SDZVKeo2jPw9Oqcb2a6svxMkDmQZh4LQMdxOnMhu9ai+iMQ7WpQpZUsDTsLEh6FR1Sm7HJC9dKE9r/16fK5Cywlel2e+MHCDzkaYlMx6vU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=OrcClT6R; arc=none smtp.client-ip=115.124.30.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="OrcClT6R"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1708909872; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=jQ2dZcVJPaCKNom3iNa7RkigITsK151L7vDe+k/SP3A=;
	b=OrcClT6RPo0UFl2qADOnXD1pXJqbwvDR4pRXv0EXymPH8JUU73ttfp8N4D5NzYHsYo77Q3DU97kcHOferW6XvE+I5bA0XIkC8NerWPeS1MWjK0nWD0WDJXfjbgJuxQlM1Eqf2hrVGMBObkpAeyNwjTx6E85bCeB0vVYrvFcZAZw=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046060;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=16;SR=0;TI=SMTPD_---0W19okBT_1708909869;
Received: from 30.221.128.188(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0W19okBT_1708909869)
          by smtp.aliyun-inc.com;
          Mon, 26 Feb 2024 09:11:10 +0800
Message-ID: <d34ba82f-cde8-4bf9-ab97-a1c4c06c2972@linux.alibaba.com>
Date: Mon, 26 Feb 2024 09:11:09 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: remove SLAB_MEM_SPREAD flag usage
Content-Language: en-US
To: Chengming Zhou <chengming.zhou@linux.dev>, mark@fasheh.com,
 jlbec@evilplan.org, brauner@kernel.org, jlayton@kernel.org,
 keescook@chromium.org, akpm <akpm@linux-foundation.org>
Cc: jack@suse.cz, zhouchengming@bytedance.com, azeemshaikh38@gmail.com,
 ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, vbabka@suse.cz, roman.gushchin@linux.dev,
 Xiongwei.Song@windriver.com
References: <20240224135008.829878-1-chengming.zhou@linux.dev>
 <aee616f4-40fc-4d24-9010-d0589d59f664@linux.alibaba.com>
 <34678776-859a-42f2-802b-0c7bc90bdfdc@linux.dev>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <34678776-859a-42f2-802b-0c7bc90bdfdc@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2/25/24 9:02 PM, Chengming Zhou wrote:
> On 2024/2/25 20:20, Joseph Qi wrote:
>>
>>
>> On 2/24/24 9:50 PM, chengming.zhou@linux.dev wrote:
>>> From: Chengming Zhou <zhouchengming@bytedance.com>
>>>
>>> The SLAB_MEM_SPREAD flag is already a no-op as of 6.8-rc1, remove
>>> its usage so we can delete it from slab. No functional change.
>>>
>> If I understand correctly, you are referring the following patch:
>> https://lore.kernel.org/all/20240223-slab-cleanup-flags-v2-1-02f1753e8303@suse.cz/
>>
>> But it seems that the above patch is not included in mainline yet.
>> Or am I missing something?
> 
> I realize my commit message should explain more why it's a no-op, my bad.
> 
> The SLAB_MEM_SPREAD flag used to be implemented in SLAB, which was
> removed so it became a dead flag as of v6.8-rc1. That series[1]
> mark it obsolete to avoid confusion for users. So here we can just
> remove all its users, which has no functional changes.
> 
> [1] https://lore.kernel.org/all/20240223-slab-cleanup-flags-v2-1-02f1753e8303@suse.cz/
> 
Take more look at v6.8-rc1, I've found the following commit:
16a1d968358a ("mm/slab: remove mm/slab.c and slab_def.h")
It seems that after this commit, there is no user of 'SLAB_MEM_SPREAD'. So,
Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
