Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 030BF1C3F0C
	for <ocfs2-devel@lists.linux.dev>; Thu,  9 Oct 2025 11:07:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760008075; cv=none; b=YtNHcqsCx2YQNHjTNHCdfRX/HUAT3/VQJou17foPbHdH0pY5jN8MGwPjuA5yG8dTCHnM74UM9lgRflfYGiAKCs/KNx9wJiRSl4ki4XPQnqkaGs0qnsVrK7NADpsMD0IDTNYfRrbIfsjBytdrPP0O1QSMH2FqpSzx73F0G+9D7ak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760008075; c=relaxed/simple;
	bh=R91l0ZPsy9y0oObQT7nb10JTbtWY0fiA+xNi3HGgf/E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SnGMtque3dWUGd2Ivi0yK8CPlMZHvZPOqInDjx1G6s6Do40KdAHzFMJBWkXA5HFQrSKa4ynNOBPE0nCbASUngPN1fkxCcDPMllM8ocPobRb3BOpfeBBha4k6JgVrAwIbSm+GYBQpPkS7jeE0u2bgbBkWGUns0ryGMGNd4gaN7kE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=sA2zQQ6h; arc=none smtp.client-ip=115.124.30.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="sA2zQQ6h"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1760008070; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=5bLhNyUkQCZLpsmi+G3NO4RNpEgKRNei4Ot6UfSzTRE=;
	b=sA2zQQ6hlM4J3gVZ3KlIys42qqvJfBTrxLo6itqSuYDhYN7qgVtM8poG49aK8HcotLx1sK4D07RMznTdPIsq+ZcxBgHNX7ROYGoXiGZYYBFz0UWPlxOYFbcoXd1hQ3qMNeYWkCrmS141DQzmbm2UhwHznV7fm79W1KzrsmcQPoI=
Received: from 30.221.128.150(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0Wpm7mbI_1760008069 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 09 Oct 2025 19:07:49 +0800
Message-ID: <32dfd05f-0210-4a4f-8584-550bdedb06ec@linux.alibaba.com>
Date: Thu, 9 Oct 2025 19:07:48 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] ocfs2: add extra flags check in
 ocfs2_ioctl_move_extents()
To: Dmitry Antipov <dmantipov@yandex.ru>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, akpm <akpm@linux-foundation.org>
Cc: ocfs2-devel@lists.linux.dev, lvc-project@linuxtesting.org
References: <6be1e189-b974-4666-add0-5b0fe7330fb3@linux.alibaba.com>
 <20251009102349.181126-1-dmantipov@yandex.ru>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20251009102349.181126-1-dmantipov@yandex.ru>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2025/10/9 18:23, Dmitry Antipov wrote:
> In 'ocfs2_ioctl_move_extents()', add extra check whether only actually
> supported flags are passed via 'ioctl(..., OCFS2_IOC_MOVE_EXT, ...)',
> and reject anything beyond OCFS2_MOVE_EXT_FL_AUTO_DEFRAG and
> OCFS2_MOVE_EXT_FL_PART_DEFRAG with -EINVAL. In particular,
> OCFS2_MOVE_EXT_FL_COMPLETE may be set by the kernel only and
> should never be passed from userspace.
> 
> Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>

Looks fine.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
>  fs/ocfs2/move_extents.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
> index 86f2631e6360..e038c009cdef 100644
> --- a/fs/ocfs2/move_extents.c
> +++ b/fs/ocfs2/move_extents.c
> @@ -1031,6 +1031,12 @@ int ocfs2_ioctl_move_extents(struct file *filp, void __user *argp)
>  	if (range.me_threshold > i_size_read(inode))
>  		range.me_threshold = i_size_read(inode);
>  
> +	if (range.me_flags & ~(OCFS2_MOVE_EXT_FL_AUTO_DEFRAG |
> +			       OCFS2_MOVE_EXT_FL_PART_DEFRAG)) {
> +		status = -EINVAL;
> +		goto out_free;
> +	}
> +
>  	if (range.me_flags & OCFS2_MOVE_EXT_FL_AUTO_DEFRAG) {
>  		context->auto_defrag = 1;
>  

