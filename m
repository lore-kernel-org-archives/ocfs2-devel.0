Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97876233149
	for <ocfs2-devel@lists.linux.dev>; Mon, 22 Jun 2026 07:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782112242; cv=none; b=iPwgVEpKvxJva6ztrNOT4j+woyMzTZ8v/zyUbJ5A0Uwvw+rr0lXtYoHj5EvyHQxDxRo70rWjV65kTtxEjCvTEjsiux7bVyxI3IHPe55scpd+hReynV6SO8w0kGm/UknCniAu3OPEXNM5XjSTHOmI+BQZbfqaL6kT9od2i9RezsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782112242; c=relaxed/simple;
	bh=M5E7Z9Mh35fMMOpjGGt4H1BVSJE09R42wS9bUJgKm/Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Y+qbJX3HTF8yBE8jC3J2gs6toINjS4RCdxlrIrcFKZR0F/sNMwjslrdGxyBVM+GnWM7xo8kGAhwxIvSNEKTDO/LX9vWKI1Z7vMZzMXileIU9fEPhcfH0CQave42XR0jhG2h5lWWty5u1W43O3L1/z3AQkhHI8oWajkmRZaaOUOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=rcp83DbN; arc=none smtp.client-ip=115.124.30.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="rcp83DbN"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1782112236; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=FHDHIdD4zKgYDfXpIo+RMS6ICLTMfaCqx9vQLfLtt/I=;
	b=rcp83DbNpVuP/OEoWkPh/1kOxV2RQvdlzQKJ81Wn4aPw8sHGgSDTN52hxv/4sgat/OvoddJNA8P5ZeQ3SuSlKecIoEe0getSWYqd4UMeZmGvdSScZTHMd8kGUo2JiiDX1E3mt75N//st30WrMi+ptDAqGDdtTo1c9977N3YJOhw=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0X5JPSde_1782112234;
Received: from 30.221.145.9(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X5JPSde_1782112234 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 22 Jun 2026 15:10:35 +0800
Message-ID: <b9dbf1e7-f19c-426f-943f-50456ee12aa8@linux.alibaba.com>
Date: Mon, 22 Jun 2026 15:10:34 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/2] ocfs2: validate xattr metadata bounds
To: Zhang Cen <rollkingzzc@gmail.com>
Cc: ocfs2-devel@lists.linux.dev, zerocling0077@gmail.com,
 2045gemini@gmail.com, Cen Zhang <zzzccc427@gmail.com>,
 Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>
References: <20260616091132.3990054-1-rollkingzzc@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260616091132.3990054-1-rollkingzzc@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,
I couldn't apply your patches cleanly upon the lastest master.
Could you please do a update?

Thanks,
Joseph

On 6/16/26 5:11 PM, Zhang Cen wrote:
> From: Cen Zhang <zzzccc427@gmail.com>
> 
> Hi,
> 
> This v3 moves the corrupted xattr metadata checks into the metadata
> validation paths Joseph pointed at.
> 
> Patch 1 validates inline xattr metadata from
> ocfs2_validate_inode_block() and keeps the get/list consumers using the
> same helper before they derive pointers from i_xattr_inline_size.
> 
> Patch 2 validates non-indexed external xattr blocks from
> ocfs2_validate_xattr_block(). Indexed xattr buckets do not pass through
> that validator, so their header and per-entry bounds are checked after
> bucket ECC verification in ocfs2_read_xattr_bucket().
> 
> Both issues were reproduced with crafted OCFS2 images under KASAN.
> 
> Changes since v2:
> - Move inline xattr validation into ocfs2_validate_inode_block().
> - Move non-indexed external xattr validation into
>   ocfs2_validate_xattr_block().
> - Validate indexed xattr bucket entries at bucket read time, after ECC
>   verification.
> - Keep get/list path checks as helper reuse instead of a separate
>   consumer-only policy.
> 
> Cen Zhang (2):
>   ocfs2: validate inline xattrs during inode block validation
>   ocfs2: validate external xattr entries when reading metadata
> 
>  fs/ocfs2/inode.c |   4 ++
>  fs/ocfs2/xattr.c | 211 +++++++++++++++++++++++++++++++++++++++--------
>  fs/ocfs2/xattr.h |   2 +
>  3 files changed, 183 insertions(+), 34 deletions(-)
> 

