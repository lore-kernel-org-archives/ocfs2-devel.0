Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B631EADD
	for <ocfs2-devel@lists.linux.dev>; Sun, 25 Feb 2024 12:20:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708863634; cv=none; b=Y8yCWPs0jlH5qfenGaz8YGKyqvpiSsDQFGY8aWdq4oEpEz1XYYs2912ZSjKweXdNo2Q0mpGO82j6rLxLaK4/uXKXwk1gM/8AN4ydEuXR95xV9xzdmhUTAmBTj4NlWeBW4e6lxidlRxdZnMGftoKquNBIzUdATqykXjFuZerdsms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708863634; c=relaxed/simple;
	bh=Kjsv2XsAlGtN7DuVxONeUs7AVYi7gGV67LWznxIsNa8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NwDQLj1xCUNndCTS/VwVmb8rXDCmbPaiHbdxhIMd9KuZ8jfkQF4rZVfOibNr4bHqVQY0UnO25FL8JcOs/746A7V9YObZJUmtLpnmR69vdBTbTEPiWUonMpLBKRsMxd1vrvhl8KVD+VQ49GgmS26Qr7S8yz43taRavi75FySy0xI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=BonZ9ik0; arc=none smtp.client-ip=115.124.30.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="BonZ9ik0"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1708863623; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=z8NCW97MDZslc0cbz27LqjT3AFfM9lssW1OxcL4phSY=;
	b=BonZ9ik0U7v/abzkSsX+xYRsOr/eRROHzpOlX/leOi1bF+vs8bTaWyRc82gjI17IbHXOXklNEmJEvI2BC3llzy3WcrAFfq2Xbeunz2eso3OeRGWdxWcW5ZcU5FIOHWQd/MJccIsQtPtkZZujdKfs4vGntOGnXnltZs0XEzHEySA=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046051;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=15;SR=0;TI=SMTPD_---0W18htbR_1708863592;
Received: from 30.121.39.217(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0W18htbR_1708863592)
          by smtp.aliyun-inc.com;
          Sun, 25 Feb 2024 20:20:22 +0800
Message-ID: <aee616f4-40fc-4d24-9010-d0589d59f664@linux.alibaba.com>
Date: Sun, 25 Feb 2024 20:20:21 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: remove SLAB_MEM_SPREAD flag usage
Content-Language: en-US
To: chengming.zhou@linux.dev, mark@fasheh.com, jlbec@evilplan.org,
 brauner@kernel.org, jlayton@kernel.org, keescook@chromium.org
Cc: jack@suse.cz, zhouchengming@bytedance.com, azeemshaikh38@gmail.com,
 ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, vbabka@suse.cz, roman.gushchin@linux.dev,
 Xiongwei.Song@windriver.com
References: <20240224135008.829878-1-chengming.zhou@linux.dev>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20240224135008.829878-1-chengming.zhou@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2/24/24 9:50 PM, chengming.zhou@linux.dev wrote:
> From: Chengming Zhou <zhouchengming@bytedance.com>
> 
> The SLAB_MEM_SPREAD flag is already a no-op as of 6.8-rc1, remove
> its usage so we can delete it from slab. No functional change.
> 
If I understand correctly, you are referring the following patch:
https://lore.kernel.org/all/20240223-slab-cleanup-flags-v2-1-02f1753e8303@suse.cz/

But it seems that the above patch is not included in mainline yet.
Or am I missing something?

Joseph

