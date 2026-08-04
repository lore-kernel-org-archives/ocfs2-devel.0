Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AEE140DB2D
	for <ocfs2-devel@lists.linux.dev>; Tue,  4 Aug 2026 07:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785827803; cv=none; b=tOIQEABKjobdKCALijLNtxsnqqosmyY1SejaG4pNG1SwJJSCTTivJUUSlOAdotKRKlKB4wtufEleRboojEVCoYe/DMrTVk4YniR/4Erl739KOEBsF84OSuYEUEZVVmH7E5W5n+jZCLvGlO5IrHMgWRjN1I9r1Nnw9Z9/Ihf7214=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785827803; c=relaxed/simple;
	bh=u9DfxsZVDCeG+Am6tliAxuaAIFJ46jCi7xF4x10Mqdk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QuxmVHLzbS4x1zI/C441B90dRhcWZoz8uZ98t8coftRyWUla0UrqWQ1gOb5W36d1wIL0gqbr8hf8hj17HmJARekOBLVP4ULKbXyjeT2cXetp1ONbMBlL6rcygK+5opLpphPgV588mwqbBDjwd60Vl9igJw4+3t6LIc76qVs+Ikg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=fZBOcqBq; arc=none smtp.client-ip=115.124.30.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="fZBOcqBq"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1785827794; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=tpr9lIZ3I8GQrLoTCTG4T3GIK1FkzUdLAVVpXafvDSo=;
	b=fZBOcqBqz3iZbDHRdq9BYfSYHABj3GMI8UE5kjXFDoEVIMRgDsHXUHf3rBefn/lr5g2djBcveeWGNzdmsliSzIzkDr7HObIqPGAlp3aeqP6B/2ExobvRJA33aGHbtwoTPpeRh/t5IdQWEavds9BCypwyD54qel/YbvXOje3eJJo=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R821e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0X8N9pYE_1785827793;
Received: from 30.221.129.86(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X8N9pYE_1785827793 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 04 Aug 2026 15:16:33 +0800
Message-ID: <07357b0e-a8cb-415e-a7a5-f0b584ce0efd@linux.alibaba.com>
Date: Tue, 4 Aug 2026 15:16:32 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] ocfs2: validate orphan slot during inode read
To: ZhengYuan Huang <gality369@gmail.com>, akpm@linux-foundation.org
Cc: mark@fasheh.com, jlbec@evilplan.org, ocfs2-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org, baijiaju1990@gmail.com, r33s3n6@gmail.com,
 zzzccc427@gmail.com, tom442288@tuta.io
References: <20260803030007.3993199-1-gality369@gmail.com>
 <20260803030007.3993199-2-gality369@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260803030007.3993199-2-gality369@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 8/3/26 11:00 AM, ZhengYuan Huang wrote:
> [BUG]
> A corrupted dinode with OCFS2_ORPHANED_FL can carry an
> i_orphaned_slot outside the mounted filesystem slot range.
> ocfs2_wipe_inode() uses it to index osb_orphan_wipes before looking
> up the orphan directory, causing an out-of-bounds memory access.
> 
> BUG: KASAN: slab-use-after-free in ocfs2_get_system_file_inode+0x780/0x820 fs/ocfs2/sysfile.c:102
> Read of size 8 at addr ffff88800b767c00 by task kworker/u8:3/85
> Call Trace:
>  ...
>  ocfs2_get_system_file_inode+0x780/0x820 fs/ocfs2/sysfile.c:102
>  ocfs2_wipe_inode+0x292/0xf70 fs/ocfs2/inode.c:840
>  ocfs2_delete_inode fs/ocfs2/inode.c:1155 [inline]
>  ocfs2_evict_inode+0x6c9/0x1170 fs/ocfs2/inode.c:1295
>  evict+0x38e/0x8f0 fs/inode.c:810
>  iput_final fs/inode.c:1914 [inline]
>  iput fs/inode.c:1966 [inline]
>  iput+0x55b/0x8b0 fs/inode.c:1926
>  ocfs2_recover_orphans+0x610/0xe40 fs/ocfs2/journal.c:2374
>  ocfs2_complete_recovery+0x5af/0xd00 fs/ocfs2/journal.c:1373
>  ...
> 
> [CAUSE]
> ocfs2_validate_inode_block() validates i_suballoc_slot but leaves
> the active ordinary orphan slot unchecked. Downstream consumers
> assume that the value is smaller than osb->max_slots.
> 
> [FIX]
> Reject an active i_orphaned_slot outside the slot range during
> dinode validation, before the inode reaches orphan wipe processing.
> 
> Fixes: b4df6ed8db0c ("[PATCH] ocfs2: fix orphan recovery deadlock")
> Signed-off-by: ZhengYuan Huang <gality369@gmail.com>

Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
>  fs/ocfs2/inode.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
> index 41db7dd39ed9..358ab3535366 100644
> --- a/fs/ocfs2/inode.c
> +++ b/fs/ocfs2/inode.c
> @@ -1528,6 +1528,14 @@ int ocfs2_validate_inode_block(struct super_block *sb,
>  		goto bail;
>  	}
>  
> +	if ((le32_to_cpu(di->i_flags) & OCFS2_ORPHANED_FL) &&
> +	    le16_to_cpu(di->i_orphaned_slot) >= OCFS2_SB(sb)->max_slots) {
> +		rc = ocfs2_error(sb, "Invalid dinode %llu: orphaned slot %u\n",
> +				 (unsigned long long)bh->b_blocknr,
> +				 le16_to_cpu(di->i_orphaned_slot));
> +		goto bail;
> +	}
> +
>  	/*
>  	 * Reject dinodes whose i_mode does not name one of the seven
>  	 * canonical POSIX file types.  ocfs2_populate_inode() copies

