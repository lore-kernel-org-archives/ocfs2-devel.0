Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44A2D4594A;
	Thu, 11 Dec 2025 02:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765419456; cv=none; b=YTfc4Bm0mSKePjhfC4RrINH1uv5PqkKhxcUoClAeqhnMoamgPSW8B6hlR6eAoKrcsHdodz7Z48PeIA3I+MiIm1ae/d/3kwTnR4BnhhuNz+EPgWSD1rn4nueUxyvEZWB7FKi6G9tBgGfAWqxKdfhhNL3JM9h2vluaVjSw/HUCljc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765419456; c=relaxed/simple;
	bh=a+tfNJgQPF+uN9UshD59v9mkXXYfgebFMUr3mlaw3f8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dpFfLN+ljuiOMUHAe2GD1zWJF/0XgndZkSvNPGAqZLkS+UOBGMM7FVzoE9Wa0Soo4G3dhXzgPL/2MliBgucS+5EHpmpBHggn27OLn+ARtf3evPF1oqOCITIaqVsTO1PtTcfPl5VsmRisTNlMU/DcIct4WW34JmNd5Wb868qXClA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=waorHZ45; arc=none smtp.client-ip=115.124.30.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="waorHZ45"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1765419443; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=Upr/ZI57OkYJyDopLBCsUvYpG+siWtd4+W1Pv/Saam4=;
	b=waorHZ453O9KguzRjVvF8mIpxJR+plpMzomJ27/R64Ftf1hhmXVpkm8x+3gBu/2b+3U8tgoWh2d8TkqdLMV4RwYlOSuUZ3p+uQIR4VqOivXuqs0c7H47PXB7Cm0GT0h6fy89qE99luXlfFxNZXlA3EUENUuldu+FAVGigfCH19Y=
Received: from 30.221.145.54(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WuYVcyM_1765419442 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 11 Dec 2025 10:17:22 +0800
Message-ID: <9bad11da-0655-4fb4-b424-8c124b127290@linux.alibaba.com>
Date: Thu, 11 Dec 2025 10:17:21 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ocfs2: fix kernel BUG in ocfs2_write_block
To: Prithvi Tambewagh <activprithvi@gmail.com>, mark@fasheh.com,
 jlbec@evilplan.org, Heming Zhao <heming.zhao@suse.com>
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-kernel-mentees@lists.linux.dev, skhan@linuxfoundation.org,
 david.hunter.linux@gmail.com, khalid@kernel.org,
 syzbot+c818e5c4559444f88aa0@syzkaller.appspotmail.com, stable@vger.kernel.org
References: <20251210193257.25500-1-activprithvi@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20251210193257.25500-1-activprithvi@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2025/12/11 03:32, Prithvi Tambewagh wrote:
> When the filesystem is being mounted, the kernel panics while the data
> regarding slot map allocation to the local node, is being written to the
> disk. This occurs because the value of slot map buffer head block
> number, which should have been greater than or equal to
> `OCFS2_SUPER_BLOCK_BLKNO` (evaluating to 2) is less than it, indicative
> of disk metadata corruption. This triggers
> BUG_ON(bh->b_blocknr < OCFS2_SUPER_BLOCK_BLKNO) in ocfs2_write_block(),
> causing the kernel to panic.
> 
> This is fixed by introducing an if condition block in
> ocfs2_update_disk_slot(), right before calling ocfs2_write_block(), which
> checks if `bh->b_blocknr` is lesser than `OCFS2_SUPER_BLOCK_BLKNO`; if
> yes, then ocfs2_error is called, which prints the error log, for
> debugging purposes, and the return value of ocfs2_error() is returned
> back to caller of ocfs2_update_disk_slot() i.e. ocfs2_find_slot(). If
> the return value is zero. then error code EIO is returned.
> 
> Reported-by: syzbot+c818e5c4559444f88aa0@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=c818e5c4559444f88aa0
> Tested-by: syzbot+c818e5c4559444f88aa0@syzkaller.appspotmail.com
> Cc: stable@vger.kernel.org
> Signed-off-by: Prithvi Tambewagh <activprithvi@gmail.com>
> ---
> v1->v2:
>  - Remove usage of le16_to_cpu() from ocfs2_error()
>  - Cast bh->b_blocknr to unsigned long long
>  - Remove type casting for OCFS2_SUPER_BLOCK_BLKNO
>  - Fix Sparse warnings reported in v1 by kernel test robot
>  - Update title from 'ocfs2: Fix kernel BUG in ocfs2_write_block' to
>    'ocfs2: fix kernel BUG in ocfs2_write_block'
> 
> v1 link: https://lore.kernel.org/all/20251206154819.175479-1-activprithvi@gmail.com/T/
> 
>  fs/ocfs2/slot_map.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/fs/ocfs2/slot_map.c b/fs/ocfs2/slot_map.c
> index e544c704b583..e916a2e8f92d 100644
> --- a/fs/ocfs2/slot_map.c
> +++ b/fs/ocfs2/slot_map.c
> @@ -193,6 +193,16 @@ static int ocfs2_update_disk_slot(struct ocfs2_super *osb,
>  	else
>  		ocfs2_update_disk_slot_old(si, slot_num, &bh);
>  	spin_unlock(&osb->osb_lock);
> +	if (bh->b_blocknr < OCFS2_SUPER_BLOCK_BLKNO) {
> +		status = ocfs2_error(osb->sb,
> +				     "Invalid Slot Map Buffer Head "
> +				     "Block Number : %llu, Should be >= %d",
> +				     (unsigned long long)bh->b_blocknr,
> +				     OCFS2_SUPER_BLOCK_BLKNO);
> +		if (!status)
> +			return -EIO;
> +		return status;
> +	}
>  
>  	status = ocfs2_write_block(osb, bh, INODE_CACHE(si->si_inode));
>  	if (status < 0)
> 

Ummm... The 'bh' is from ocfs2_slot_info, which is load from crafted
image during mount.
So IIUC, the root cause is we read slot info without validating, see
ocfs2_refresh_slot_info().
So I'd prefer to implement a validate func and pass it into
ocfs2_read_blocks() to do this job.

Thanks,
Joseph
