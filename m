Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1582814B977
	for <ocfs2-devel@lists.linux.dev>; Sun,  4 Jan 2026 01:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767491729; cv=none; b=S9+LEQRauYE3FdK8wda81zR0MUi2sJgjN6koZVQe0xdskPxnLY3ghG5IW34wOteGq9HZQA+8uyiBvsYRsRfUl+42IGbOV9Y0XEHMppdn8H+sz7pm73poiFuPtH1IlXsno2TDwyBWRs3QOQASRXC31TmwrM6ntTT6QLOi/uGE1q8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767491729; c=relaxed/simple;
	bh=gTtU36HlhD1N9pv+He8SJ2VrQqW01XmIlMjMC/u/534=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=X1XpKDWGKuoySutFr9wWfuT5niwbHhJqMQHSH1S1UukWFk+2V0OpL+ndZRrzkCA0TwuMqak6Pyfp6PrBtheRg73jDGceXbSDyhJtvWhRR2kjQa0hvWDTchEUq1xrFJKaTPbYWI0VV7PHNfmaAw06hFNqdzA6YK85uUfXV5843ZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=Nz6ZRrBt; arc=none smtp.client-ip=115.124.30.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="Nz6ZRrBt"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1767491719; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=xj/moysUeUoDRW2OR44j3eR8HUPrY3Z1dpNw65BbqtI=;
	b=Nz6ZRrBt3EtcxbeoygRr64n1CzJvLnBDndZwwTzizIAt7siUhz8GELXkRp6+MQ/VMqpPBZH6RcZ1XKaSwWsKuUIKIAhY4IfNA2QPW72MBk4nxcLEsX0fI82muQTBevm/CaLVX2JbFi21Acbrw65TZA6OitmUtsuz8kWHQ88HoAs=
Received: from 30.221.145.42(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0Ww9jziI_1767491400 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sun, 04 Jan 2026 09:50:01 +0800
Message-ID: <5563a638-6acd-46cf-b78a-75c4e7a8e836@linux.alibaba.com>
Date: Sun, 4 Jan 2026 09:50:00 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: add check for free bits before allocation in
 ocfs2_move_extent()
To: Deepanshu Kartikey <kartikey406@gmail.com>, mark@fasheh.com,
 jlbec@evilplan.org, Heming Zhao <heming.zhao@suse.com>
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 syzbot+7960178e777909060224@syzkaller.appspotmail.com
References: <20251231115801.293726-1-kartikey406@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20251231115801.293726-1-kartikey406@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2025/12/31 19:58, Deepanshu Kartikey wrote:
> Add a check to verify the group descriptor has enough free bits before
> attempting allocation in ocfs2_move_extent(). This prevents a kernel
> BUG_ON crash in ocfs2_block_group_set_bits() when the move_extents ioctl
> is called on a crafted or corrupted filesystem.
> 
> The existing validation in ocfs2_validate_gd_self() only checks static
> metadata consistency (bg_free_bits_count <= bg_bits) when the descriptor
> is first read from disk. However, during move_extents operations,
> multiple allocations can exhaust the free bits count below the requested
> allocation size, triggering BUG_ON(le16_to_cpu(bg->bg_free_bits_count)
> num_bits).

BUG_ON(le16_to_cpu(bg->bg_free_bits_count) < num_bits)

Seems '<' is missing.

> 
> The debug trace shows the issue clearly:
>   - Block group 32 validated with bg_free_bits_count=427
>   - Repeated allocations decreased count: 427 -> 171 -> 43 -> ... -> 1
>   - Final request for 2 bits with only 1 available triggers BUG_ON
> 
> By adding an early check in ocfs2_move_extent() before calling
> ocfs2_block_group_set_bits(), we return -ENOSPC gracefully instead of
> crashing the kernel.
> 
> Reported-by: syzbot+7960178e777909060224@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=7960178e777909060224
> Tested-by: syzbot+7960178e777909060224@syzkaller.appspotmail.com
> Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
> ---
>  fs/ocfs2/move_extents.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
> index 99637e34d9da..2548a8908a1b 100644
> --- a/fs/ocfs2/move_extents.c
> +++ b/fs/ocfs2/move_extents.c
> @@ -690,6 +690,11 @@ static int ocfs2_move_extent(struct ocfs2_move_extents_context *context,
>  		goto out_commit;
>  	}
>  
> +	if (le16_to_cpu(gd->bg_free_bits_count) < len) {
> +		ret = -ENOSPC;
> +		goto out_commit;
> +	}
> +

Why not check rightly after ocfs2_find_victim_alloc_group()?

Joseph

>  	ret = ocfs2_block_group_set_bits(handle, gb_inode, gd, gd_bh,
>  					 goal_bit, len, 0, 0);
>  	if (ret) {

