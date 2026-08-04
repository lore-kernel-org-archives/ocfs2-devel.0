Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D26C41E6D8
	for <ocfs2-devel@lists.linux.dev>; Tue,  4 Aug 2026 07:17:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785827877; cv=none; b=Xv5gbmXk+YjkNjQ2kf+z5jGmgl/c6t4MQdjCbaAiaHIejREcYLPe1X7+pZDfuaE5gn94lQ1BQS7fIdX6It25NpA4kY2rQMUjquPLWjjrvJstaZ3GbLb8i87UTgT5fgfbvi0asGnFtI9b35FzisPE64ocMaKFTqCb/sklgfLHFko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785827877; c=relaxed/simple;
	bh=tiSItp0Ethhha0TT/1xkHraVeWJ9g/lIv3qfnIFbvXY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lf+VhQqSy41VBjKm01i4cwWlXdXn7RRM/MYtgTRzbLedv5+prifRgL/k0cu07/2ZtlXNqYtZa6N2VjXkP/Y6yPpR0rS251jV621Jbp2eMtmyZX7wIjxtcRKoA7VJ4b+fYR39562GVo5aLmyNZSulHsGvffknP5jHBLbJQKZ7tDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=aoZ+9w+e; arc=none smtp.client-ip=115.124.30.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="aoZ+9w+e"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1785827866; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=meWAj2V9mSNxQpX5KfDmdX+qlTKYN5FbwWOe362Bhsg=;
	b=aoZ+9w+eQDaW4A8amFY20kg72rxgfipyjfnUKeb5qBsgkh2ertb4cYnl9TOrsO5Upnlg9nROxeydVHSqL6rjQAlr2fyQeZLIlu/IH8j+ClLxj9hyshtVmLiGZb/FsYxrgLySB7kT3rskPjYm7Z2o7C5rYFO0ZutRX14q8vReKPU=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R631e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0X8NC4ja_1785827865;
Received: from 30.221.129.86(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X8NC4ja_1785827865 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 04 Aug 2026 15:17:45 +0800
Message-ID: <d4f79ade-2091-48de-a27c-28df563c9dda@linux.alibaba.com>
Date: Tue, 4 Aug 2026 15:17:45 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] ocfs2: validate DIO orphan slot during inode read
To: ZhengYuan Huang <gality369@gmail.com>, akpm@linux-foundation.org
Cc: mark@fasheh.com, jlbec@evilplan.org, ocfs2-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org, baijiaju1990@gmail.com, r33s3n6@gmail.com,
 zzzccc427@gmail.com, tom442288@tuta.io
References: <20260803030007.3993199-1-gality369@gmail.com>
 <20260803030007.3993199-3-gality369@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260803030007.3993199-3-gality369@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 8/3/26 11:00 AM, ZhengYuan Huang wrote:
> [BUG]
> A corrupted append-DIO dinode (high byte at offset 0xa1 
> corrupted from 0 to 1) can carry an i_dio_orphaned_slot
> outside the mounted filesystem slot range and trigger a 
> use-after-free error:
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
> ocfs2_del_inode_from_orphan() uses i_dio_orphaned_slot to index the
> slot-local system inode cache. The dinode validator does not check
> this active slot, so an out-of-range value produces an invalid cache
> entry pointer that is dereferenced as an inode pointer.
> 
> [FIX]
> Reject an active i_dio_orphaned_slot outside the slot range during
> dinode validation, before DIO orphan recovery can consume it.
> 
> Fixes: 06ee5c75b575 ("ocfs2: add functions to add and remove inode in orphan dir")
> Signed-off-by: ZhengYuan Huang <gality369@gmail.com>

Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
>  fs/ocfs2/inode.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
> index 358ab3535366..180107a11046 100644
> --- a/fs/ocfs2/inode.c
> +++ b/fs/ocfs2/inode.c
> @@ -1536,6 +1536,14 @@ int ocfs2_validate_inode_block(struct super_block *sb,
>  		goto bail;
>  	}
>  
> +	if ((le32_to_cpu(di->i_flags) & OCFS2_DIO_ORPHANED_FL) &&
> +	    le16_to_cpu(di->i_dio_orphaned_slot) >= OCFS2_SB(sb)->max_slots) {
> +		rc = ocfs2_error(sb, "Invalid dinode %llu: DIO orphaned slot %u\n",
> +				 (unsigned long long)bh->b_blocknr,
> +				 le16_to_cpu(di->i_dio_orphaned_slot));
> +		goto bail;
> +	}
> +
>  	/*
>  	 * Reject dinodes whose i_mode does not name one of the seven
>  	 * canonical POSIX file types.  ocfs2_populate_inode() copies

