Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAB5A4756CA
	for <ocfs2-devel@lists.linux.dev>; Tue, 15 Sep 2026 09:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789464432; cv=none; b=UT6rybv9gl8hSVFkoa5FXmrGQiE1Ub7YXQHPrf+qMuyTx/qDs9CyGllUkIb6yQPgYdaqP3o9KD0HO7XvVreqBe3dXVku9/q1UfxB8EXDN4PQ/Bb1SbSL8Tmo7Hb7zlDnErgatvn3cSKXh3bCzcJI6IkIhAWqBhdAbdTpO9TNwKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789464432; c=relaxed/simple;
	bh=jrav296c2HpTz0k20Kl+5LAjON8gv8iFrRCvB255baQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YG23GGWdhNDGp+mkuvFOutoG25JC/NqTVbhUEGtp1+ZRFnEhyztR2tDRn+IC01xnu1GVeIVgigU0y12tzJjBn/5/lHdpOv8tD6+H8sjLJdeGFZTEAGLjrxFu5sVCKk3gNDVIWLhuNM1Kml94cbj41aEjOWvZEfHEWNqg2DuCxAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=d8dIyBcA; arc=none smtp.client-ip=115.124.30.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="d8dIyBcA"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1789464420; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=0OZtua8DFLNJVs4PID79pkEn6QrqMiWm6otoJFtXXVc=;
	b=d8dIyBcAtd/cSg8QhK+EGJgF5E8xuHWFDNEIWvSoTHIG8/WbfwPdgvzvwCqiFuOnA88Kid/YEvcXGU57Tj6eTv6UPMaj9wxGurRgB242z9L6UyqfDhmXKOFEA/ZWAjDRkASuD3d3alkBEjAkSIzXa3pxdeSz12MbM7o49u1LYeM=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R451e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0XB1Au2f_1789464419;
Received: from 30.166.1.13(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XB1Au2f_1789464419 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 15 Sep 2026 17:27:00 +0800
Message-ID: <aeb6c68d-5c76-4e0d-b49b-d5a14345aa79@linux.alibaba.com>
Date: Tue, 15 Sep 2026 17:26:59 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: fix chunk number of the first chunk in a local
 quota file
To: Jiaming Zhang <r772577952@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: jlbec@evilplan.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org, syzkaller@googlegroups.com,
 stable@vger.kernel.org
References: <CANypQFZ05tpth0Xc33gmP6jgPnkY4VuezyHcsajV-SqCsmN_gg@mail.gmail.com>
 <20260914034940.4070970-1-r772577952@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260914034940.4070970-1-r772577952@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 9/14/26 11:49 AM, Jiaming Zhang wrote:
> The local quota file in OCFS2 is divided into chunks, and each chunk
> begins with a header block holding a bitmap of the quota entries that
> chunk has handed out.  Chunks are numbered from zero, and that number is
> used to convert the file offset of an entry back into a bit position in
> the bitmap. ocfs2_local_quota_add_chunk() appends a new chunk to the
> in-memory list and numbers it one past the chunk that was last:
> 
> 	list_add_tail(&chunk->qc_chunk, &oinfo->dqi_chunk);
> 	chunk->qc_num = list_entry(chunk->qc_chunk.prev,
> 				   struct ocfs2_quota_chunk,
> 				   qc_chunk)->qc_num + 1;
> 
> The predecessor is looked up after the new chunk is added to the list,
> so if the list was empty, the prev pointer is the list head itself.  The
> head is the dqi_chunk member of struct ocfs2_mem_dqinfo and is not a
> chunk, so reading qc_num through it lands 16 bytes past the start of the
> head, on the dqi_gqinode pointer that follows it.  The first chunk of
> the file is then numbered with the lower half of a kernel pointer
> instead of 0.
> 
> The list is empty when the local quota file header claims the file has
> no chunks.  ocfs2_local_read_info() takes dqi_chunks from that header
> without validating it, so an image with dqi_chunks == 0 takes this path
> when the first quota entry is allocated.
> 
> ocfs2_create_local_dquot() turns the bad number into a file offset with
> ol_dqblk_off(), which shifts a 32-bit block number left by the block
> size bits, so the top bits of such a large block number are lost.
> ocfs2_local_release_dquot() turns the offset back into a bit index with
> ol_dqblk_chunk_off(), using the full chunk number, so the lost bits push
> that index far outside the bitmap, and clearing it corrupts unrelated
> memory.
> 
> Compute the chunk number before putting the chunk on the list, and use 0
> when the list is empty.
> 
> Fixes: 9e33d69f553a ("ocfs2: Implementation of local and global quota file handling")
> Closes: https://lore.kernel.org/lkml/CANypQFZ05tpth0Xc33gmP6jgPnkY4VuezyHcsajV-SqCsmN_gg@mail.gmail.com/
> Cc: stable@vger.kernel.org
> Assisted-by: Claude Code:claude-opus-5
> Signed-off-by: Jiaming Zhang <r772577952@gmail.com>

Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
>  fs/ocfs2/quota_local.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ocfs2/quota_local.c b/fs/ocfs2/quota_local.c
> index f55810c59b1b..d351cda9211f 100644
> --- a/fs/ocfs2/quota_local.c
> +++ b/fs/ocfs2/quota_local.c
> @@ -1071,10 +1071,13 @@ static struct ocfs2_quota_chunk *ocfs2_local_quota_add_chunk(
>  		goto out;
>  	}
>  
> +	if (list_empty(&oinfo->dqi_chunk))
> +		chunk->qc_num = 0;
> +	else
> +		chunk->qc_num = list_entry(oinfo->dqi_chunk.prev,
> +					   struct ocfs2_quota_chunk,
> +					   qc_chunk)->qc_num + 1;
>  	list_add_tail(&chunk->qc_chunk, &oinfo->dqi_chunk);
> -	chunk->qc_num = list_entry(chunk->qc_chunk.prev,
> -				   struct ocfs2_quota_chunk,
> -				   qc_chunk)->qc_num + 1;
>  	chunk->qc_headerbh = bh;
>  	*offset = 0;
>  	return chunk;

