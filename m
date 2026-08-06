Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 933664477F3
	for <ocfs2-devel@lists.linux.dev>; Thu,  6 Aug 2026 10:23:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.113
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786011832; cv=none; b=HlPgD3zbYGLF4T8kqUhxtOo6lO+JSPSSwBczEHoRFv5ufcHswU/T6cUKZYoa8iWn6gonN7qgWdujhXaRZcm+hASGgs7FqZRdUDxzwhMETfRhHx7gy01BkQxHxWPUxGbJXoWkRyF92e5J5pV6+7DNiSo5A6sfFaCerFzXHsb0gMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786011832; c=relaxed/simple;
	bh=C5I84RxSp8Qlh8ciQKGh+oj6KPnpAtnfSJGidFpFAWg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XDiD+M+SaqHYItgqL5nXTpmzLRmUizwhlOtl2ej1bh2pTEQXssCZN0k0jll0wiAgqJ+nNtNSMrfVgQQp2QgF+AdcI7LX9GMOAxXprmnnW80HISStpc8mU2i1imBLnXjomPTsTCvU9B9cHWFTJu0wug/vCa3JT7s2xlnRxBZ0j70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=O9U0qmxO; arc=none smtp.client-ip=115.124.30.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="O9U0qmxO"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1786011822; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=KxCQEIJTEpu2HLskEO3anQPPaiXW2MuwM7tILXssSfM=;
	b=O9U0qmxOLi2agZnPDHmAPZrpE2BQjvCmR+fCV49PVaF4b9qOniHJjX/sZbFZ/Y3l3BWZWNu6FdwfQ4XHFS5iRN89GKdTA3rBd1yUdh7a1x4Hn7hZiZO5xewB6Co4ZPTGSDJP/ujuNEgOTr5vzwf0zuZ+vm+qvMWO9dGRT/ljPEU=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=16;SR=0;TI=SMTPD_---0X8TmP1U_1786011820;
Received: from 30.221.129.97(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X8TmP1U_1786011820 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 06 Aug 2026 18:23:41 +0800
Message-ID: <5849a28b-ffaa-420f-b173-d8a085d9c61f@linux.alibaba.com>
Date: Thu, 6 Aug 2026 18:23:40 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] ocfs2: fix readdir position truncation on 32-bit
 kernels
To: Andrew Morton <akpm@linux-foundation.org>,
 Zhan Xusheng <zhanxusheng1024@gmail.com>
Cc: Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>,
 Jan Kara <jack@suse.cz>, Baokun Li <libaokun@linux.alibaba.com>,
 Ojaswin Mujoo <ojaswin@linux.ibm.com>, Ritesh Harjani
 <ritesh.list@gmail.com>, Zhang Yi <yi.zhang@huawei.com>,
 Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 linux-ext4@vger.kernel.org, ocfs2-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org, zhanxusheng@xiaomi.com, stable@vger.kernel.org
References: <20260806022044.167962-1-zhanxusheng@xiaomi.com>
 <20260806022044.167962-3-zhanxusheng@xiaomi.com>
 <20260805214202.a644393ef2f28ffb30090ff4@linux-foundation.org>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260805214202.a644393ef2f28ffb30090ff4@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 8/6/26 12:42 PM, Andrew Morton wrote:
> On Thu,  6 Aug 2026 10:20:44 +0800 Zhan Xusheng <zhanxusheng1024@gmail.com> wrote:
> 
>> In ocfs2_dir_foreach_blk_el(), the directory cookie position is
>> rebuilt with
>>
>> 	ctx->pos = (ctx->pos & ~(sb->s_blocksize - 1)) | offset;
>>
>> `ctx->pos` is loff_t (signed 64-bit), while `sb->s_blocksize` is
>> unsigned long.  On 32-bit kernels unsigned long is 32-bit, so the mask
>>
>> 	~(sb->s_blocksize - 1)
>>
>> is computed as a 32-bit unsigned value (e.g. 0xfffff000 for a 4 KiB
>> block size).  In the AND expression with the 64-bit `ctx->pos`, that
>> unsigned operand is zero-extended to 64 bits per the usual arithmetic
>> conversions, yielding 0x00000000fffff000.  The high 32 bits of
>> `ctx->pos` are silently cleared, even though directory size is
>> allowed to exceed 4 GiB.
>>
>> When readdir() crosses the 4 GiB boundary on a 32-bit kernel the
>> position is reset back into the first 4 GiB block, making the
>> re-validation path re-enumerate already-returned dirents indefinitely.
>>
>> This is ocfs2_dir_foreach_blk_el(), the extent-list readdir path taken
>> for all non-inline directories, so a directory large enough to cross
>> 4 GiB reaches it.
>>
>> This is the same class of bug that commit 3dce5bb82c97 ("exfat: Fix
>> bitwise operation having different size") fixed in exfat, and the
>> fix mirrors the equivalent ext4 fix in this series.  Cast the operand
>> to loff_t so the mask is 64-bit before the AND:
>>
>> 	ctx->pos = (ctx->pos & ~((loff_t)sb->s_blocksize - 1)) | offset;
>>
>> 64-bit kernels are unaffected.
> 
> AI review had no comment on your change, but it might have found a
> bunch of unrelated ocfs2 issues:
> 
> 	https://sashiko.dev/#/patchset/20260806022044.167962-1-zhanxusheng@xiaomi.com

It looks fine.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

For the issues founded by sashiko, I'd rather track them in a separate
thread.
So Xusheng, could you please send a new fix for that? It seems enough
to do the same check like ocfs2_check_dir_entry(). e.g.

i + OCFS2_DIR_REC_LEN(1) <= sb->s_blocksize

Thanks,
Joseph
