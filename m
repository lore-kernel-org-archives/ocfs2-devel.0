Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98A1B276049
	for <ocfs2-devel@lists.linux.dev>; Wed, 27 May 2026 07:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779868492; cv=none; b=peV+31WjZTNGhYq4TKYPib3HT4xH/Wn67JCUxb4hm6yOc9IXhnnyCVNQEInMjgcN2ca0ulrPVAHWvSzpQFJ1QYI7ky1LzWnF1Gqu/zB6RDX4Fhn1+3H4+OubogGgWlOggPaLc5UkEEloujb0zdZGwPitUl0t5jvaObyj3NRECxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779868492; c=relaxed/simple;
	bh=r2CdmUt9vJ3JA0P9UYyJVR8Tg4yVwtbWnTHJijeji78=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Y4UvIiYMS5XxZJdgyvfbhW8cxlzounMz+A98wjy9Qww0hM+FnjKcGPxLXol+eHnLyiYBtVvJYFYRm66HRmlq5UmAWy5kicJjm4DCFmW5C/wBo8scKt6jD94EBT0vVu4ddjpgxE87OVmoFm2HUiHXLlpZ6TYq+tTllmBHYI2Gb5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=hgk/n1iM; arc=none smtp.client-ip=115.124.30.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="hgk/n1iM"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1779868482; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=iTiY0JNHNI2uJ32QpCQH8YLgznwGyDMe0eHrOf1pmO0=;
	b=hgk/n1iMlGiDwXC/phs57roCrmD17cvte7vzTrM82lrlFxGxh+9326gQLLp3erjjdSyS0120cFPBuMcILz5wfTi/K9nz/og/PQ9NG62ZAPt2ZpGXrJYwSUOBy1/nF14GIfjX8dg7P8zQucwp7T/A2W0h2GyplhwxoLz1Y548t2U=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0X3ioSmd_1779868481;
Received: from 30.221.145.39(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X3ioSmd_1779868481 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 27 May 2026 15:54:41 +0800
Message-ID: <3164f091-7777-4144-a18a-023478ff9f8a@linux.alibaba.com>
Date: Wed, 27 May 2026 15:54:41 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 18/34] ocfs2: Convert ocfs2_write_block to bh_submit()
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>
Cc: Christian Brauner <brauner@kernel.org>,
 Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
 ocfs2-devel@lists.linux.dev
References: <20260525171931.4144395-1-willy@infradead.org>
 <20260525171931.4144395-19-willy@infradead.org>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260525171931.4144395-19-willy@infradead.org>
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
> index 701d27d908d4..3e42ca700db0 100644
> --- a/fs/ocfs2/buffer_head_io.c
> +++ b/fs/ocfs2/buffer_head_io.c
> @@ -62,9 +62,8 @@ int ocfs2_write_block(struct ocfs2_super *osb, struct buffer_head *bh,
>  	/* remove from dirty list before I/O. */
>  	clear_buffer_dirty(bh);
>  
> -	get_bh(bh); /* for end_buffer_write_sync() */
> -	bh->b_end_io = end_buffer_write_sync;
> -	submit_bh(REQ_OP_WRITE, bh);
> +	get_bh(bh); /* for bh_end_write() */
> +	bh_submit(bh, REQ_OP_WRITE, bh_end_write);
>  
>  	wait_on_buffer(bh);
>  

