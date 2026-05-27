Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FE433C8700
	for <ocfs2-devel@lists.linux.dev>; Wed, 27 May 2026 07:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779868506; cv=none; b=RxQ4/gOjtgiHAQHJeNuNixj20NKZEPtUxw6It44SiTlDAWZASn0YKvwvGwGwPcFF0h1SQzhZDiJ5KqGhPwz1Q0uhYj3j4ns3i8trK2mCnEJzIIsGnogogEFnhNs1Pcr1MbEIXOEc6Z7I/adG8gK7gElRmPJndUZZHe9piCaPawo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779868506; c=relaxed/simple;
	bh=45Q9YGNqKlndlbrypMmr6IHOx2sHhcz8jwRRWL/CQHg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rkKnaaxby6yNU/VCDUlOrOeys2Bau8pRCWc9Ee/KvJADV3VGylcTAVa1iZ9zshKoM1fWJOkXcavGLBh4DRXCl2veCZ5/N70uOUBlh/6syjFjbsNv72Vj46yj9bYQiZksxSIQSmUm3V7Bx6RryJkjI9XhElnTPWkr5OLr6lr1Ei8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=nxg5QSHR; arc=none smtp.client-ip=115.124.30.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="nxg5QSHR"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1779868502; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=jn33czpJjH+yDDStgIUN/hEBu6vy8j0GmyHRxQMkSgc=;
	b=nxg5QSHRdi0KoESDXsVXmc8tmYsBjVSJuZOqBmVwJICtXyP5xV6+WqO3PqEXj0NVdpHXzRxnKQozaQU2WoqAHxdOGSnntlfdqem/3/CcHwUvgRPkJyfxYIwY3949YUnQRbQdkXvu4T0yFxRkY1WM4XP22xzlCgGxqSTMx+wegXE=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0X3ioSwI_1779868501;
Received: from 30.221.145.39(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X3ioSwI_1779868501 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 27 May 2026 15:55:01 +0800
Message-ID: <22dd2ff9-35d1-4a83-be75-6a89b19014d4@linux.alibaba.com>
Date: Wed, 27 May 2026 15:55:01 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 19/34] ocfs2: Convert ocfs2_read_block to bh_submit()
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>
Cc: Christian Brauner <brauner@kernel.org>,
 Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
 ocfs2-devel@lists.linux.dev
References: <20260525171931.4144395-1-willy@infradead.org>
 <20260525171931.4144395-20-willy@infradead.org>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260525171931.4144395-20-willy@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 5/26/26 1:19 AM, Matthew Wilcox (Oracle) wrote:
> Avoid an extra indirect function call by using bh_submit() instead of
> submit_bh().
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Cc: ocfs2-devel@lists.linux.dev

Looks fine.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
>  fs/ocfs2/buffer_head_io.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ocfs2/buffer_head_io.c b/fs/ocfs2/buffer_head_io.c
> index 3e42ca700db0..44a4fa3dfbc0 100644
> --- a/fs/ocfs2/buffer_head_io.c
> +++ b/fs/ocfs2/buffer_head_io.c
> @@ -144,9 +144,8 @@ int ocfs2_read_blocks_sync(struct ocfs2_super *osb, u64 block,
>  #endif
>  		}
>  
> -		get_bh(bh); /* for end_buffer_read_sync() */
> -		bh->b_end_io = end_buffer_read_sync;
> -		submit_bh(REQ_OP_READ, bh);
> +		get_bh(bh); /* for bh_end_read() */
> +		bh_submit(bh, REQ_OP_READ, bh_end_read);
>  	}
>  
>  read_failure:

