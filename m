Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA128204C3B
	for <ocfs2-devel@lists.linux.dev>; Wed, 22 Jul 2026 12:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784724962; cv=none; b=H0fNkcNmdyyBKR66ZyRmSX7ToCPryFGvcCRsf5NQwI/ZLT/4fO7aLElIPRrYSnuXLou66aDdywjylBMHxGSb3eXo6G7NM8w+1sdxCps+L2q6okqgOVs3fPua8NT1A2ECLMPLP46TeLHj8MggRK5JWw5fDFf5TIOq2nFVHX1DlTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784724962; c=relaxed/simple;
	bh=deRUxsv5srV7zqYTH4jPbd9DwYHRRG1uVrvSajEYp9Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BhqqEKhgjzGBrtCZfcLnf8FyFv9WfoNsKC6+UZ/R91923QxoHd7yLAi8nCMxDKLtWRWM3rFvObIIsxUzoFw+kDVKhB3YyJlezxOGuk9/oMTk0BJxsP72RN8fmJU/Sqmd6h2N5lofND8Iq5F2p0hznCVvr2smVAtsTIpfr/g0/G4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=YgSw9ZNl; arc=none smtp.client-ip=115.124.30.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="YgSw9ZNl"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1784724956; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=hVP/c6gOOXQ5oqJcJpmlBTJ20J8EqecV7BhHwopRYSc=;
	b=YgSw9ZNlOgMMN68kJK+zE1OyaVUcJpV2zkQGHTCNec2u7DP2+gNHBGLNhyyIY5fLTnieDAbuVgveNdDaRP6JoP6FT4n4YEbg4RYHz+aDfjzxNsv+H/UixyGZBHCrwXkhQIgyNtAhaCkNd9VHtviHKxXUjfKzrUb7yWG9ZHQ+jhU=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0X7dP-su_1784724954;
Received: from 30.221.129.75(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X7dP-su_1784724954 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 22 Jul 2026 20:55:55 +0800
Message-ID: <de598854-410c-4fae-95a5-8db0ee6d47e5@linux.alibaba.com>
Date: Wed, 22 Jul 2026 20:55:53 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: validate truncate log dinode before caching
To: ZhengYuan Huang <gality369@gmail.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, ocfs2-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org, baijiaju1990@gmail.com, r33s3n6@gmail.com,
 zzzccc427@gmail.com, tom442288@tuta.io
References: <20260722091157.3141414-1-gality369@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260722091157.3141414-1-gality369@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 7/22/26 5:11 PM, ZhengYuan Huang wrote:
> [BUG]
> A corrupted truncate log dinode can pass through mount initialization and
> reach the delayed flush worker, where it triggers:
> 
> kernel BUG at fs/ocfs2/alloc.c:6019!
> Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
> RIP: 0010:__ocfs2_flush_truncate_log+0xa87/0xf10 fs/ocfs2/alloc.c:6019
> Call Trace:
>  ocfs2_flush_truncate_log fs/ocfs2/alloc.c:6084 [inline]
>  ocfs2_truncate_log_worker+0xa9/0x180 fs/ocfs2/alloc.c:6097
>  process_one_work+0x8e0/0x1980 kernel/workqueue.c:3263
>  ...
> 

I've encountered this BUG occasionality. But I don't see why it happens.
Do you have more clues on how to reproduce it?

Thanks,
Joseph

> [CAUSE]
> ocfs2_get_truncate_log_info() assumes that ocfs2_read_inode_block()
> always validates the returned dinode. However, ocfs2_read_blocks() skips
> the validation callback for JBD-managed buffers. The function then reads
> truncate log fields and exposes the invalid buffer to callers, allowing
> ocfs2_truncate_log_init() to retain it in osb->osb_tl_bh.
> 
> [FIX]
> Check the dinode signature in ocfs2_get_truncate_log_info() immediately
> after the inode read. Reject an invalid dinode as filesystem corruption
> before reading truncate log fields or returning the inode and buffer to
> the caller. This keeps invalid state out of the long-lived truncate log
> cache and preserves the validated-buffer invariant in append, flush, and
> recovery paths.
> 
> Fixes: 10995aa2451a ("ocfs2: Morph the haphazard OCFS2_IS_VALID_DINODE() checks.")
> Assisted-by: Codex:gpt-5.6-sol
> Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
> ---
>  fs/ocfs2/alloc.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
> index be09e766ac1f..e36ae2e522d3 100644
> --- a/fs/ocfs2/alloc.c
> +++ b/fs/ocfs2/alloc.c
> @@ -6192,6 +6192,19 @@ static int ocfs2_get_truncate_log_info(struct ocfs2_super *osb,
>  	}
>  
>  	di = (struct ocfs2_dinode *)bh->b_data;
> +	/*
> +	 * A JBD-managed buffer may skip the read validation callback. Check
> +	 * the signature before exposing the truncate log to callers.
> +	 */
> +	if (!OCFS2_IS_VALID_DINODE(di)) {
> +		status = ocfs2_error(osb->sb,
> +				     "Invalid truncate log dinode #%llu\n",
> +				     (unsigned long long)bh->b_blocknr);
> +		iput(inode);
> +		brelse(bh);
> +		goto bail;
> +	}
> +
>  	tl = &di->id2.i_dealloc;
>  	tl_count = le16_to_cpu(tl->tl_count);
>  	tl_used = le16_to_cpu(tl->tl_used);

