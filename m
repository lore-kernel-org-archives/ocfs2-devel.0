Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7915C439356
	for <ocfs2-devel@lists.linux.dev>; Thu,  9 Jul 2026 03:59:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783569550; cv=none; b=pDHiNGhF85Sg2Su3vPQs4A8wgBf6MaJkYWstlsWBPRFtVhz5Ot31ULZhgm1B2fCit1H03Idid4iosatA7rLeHnpmu7czhclIreMPL4Y7T7ab60Fx8Gs7XCmkUARdVVef3BIXKD+66q7EP07AwSFDuUoSD0pqUDPUzGBYB5fYSB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783569550; c=relaxed/simple;
	bh=IbBIkaZF46cqMJlPORp7pYbXNvhdj6iKnPJ6S0DXL9I=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:Cc:From:
	 In-Reply-To:Content-Type; b=D3SOzlPoN5fYz7eoeJKVmYqB9Xnc/m51cY7zt4M0KEWUDHA/uZnuG9gwDjj/WDLQu01YXTpJk60nPtBcGbtReSJTwEKQMtvmbcFi48nfpJNnugjDrlhMtVNst0lv4ZlcsTx3kdgDBIn15Rn+vWJYwporoIq70j4OyIfDDvC9zNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=xAk0ec6M; arc=none smtp.client-ip=115.124.30.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="xAk0ec6M"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1783569545; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=buQdi0BomK5CB74T7xDmUNZVePMYb8bI5undGI57DXk=;
	b=xAk0ec6Mbm5VU6KrwwBIYHIyiAwZGI7P2LXSXtJGM3RXkolBN/xnblCzd3VVeK6KYWu7gAwXWpAJdMabufKukNhQSFiTgnRDQXzPEKrbrdofxiECES3y8xZuwDtvzvr9dWUXJfc6pEvNeCP1igcXm7PT9tFvQkNWeKYbXiZC+Es=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R921e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0X6jKSMW_1783569543;
Received: from 30.221.145.97(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X6jKSMW_1783569543 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 09 Jul 2026 11:59:04 +0800
Message-ID: <12edcc56-8f9f-4f36-b5ca-8a4ba0f3d9f3@linux.alibaba.com>
Date: Thu, 9 Jul 2026 11:59:02 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: free claimed clusters when defrag move fails
To: Guangshuo Li <lgs201920130244@gmail.com>
References: <20260708062212.715437-1-lgs201920130244@gmail.com>
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 Tristan Ye <tristan.ye@oracle.com>, ocfs2-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260708062212.715437-1-lgs201920130244@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 7/8/26 2:22 PM, Guangshuo Li wrote:
> ocfs2_defrag_extent() claims new clusters before calling
> __ocfs2_move_extent(). If __ocfs2_move_extent() fails, the newly claimed
> clusters have not been attached to the inode extent tree, but the error
> path only logs the error and continues.
> 
> The following ocfs2_cow_sync_writeback() call can then overwrite the
> original error with 0, while the claimed clusters are left allocated and
> unreferenced.
> 
> Set need_free and leave through out_commit when __ocfs2_move_extent()
> fails, so the claimed clusters are released and the original error is
> returned to the caller.
> 
> Fixes: 202ee5facb2c ("Ocfs2/move_extents: defrag a range of extent.")
> Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
> ---
>  fs/ocfs2/move_extents.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
> index ad1678ee7cc4..4f1745d58a88 100644
> --- a/fs/ocfs2/move_extents.c
> +++ b/fs/ocfs2/move_extents.c
> @@ -310,8 +310,11 @@ static int ocfs2_defrag_extent(struct ocfs2_move_extents_context *context,
>  
>  	ret = __ocfs2_move_extent(handle, context, cpos, new_len, phys_cpos,
>  				  new_phys_cpos, ext_flags);
> -	if (ret)
> +	if (ret) {
>  		mlog_errno(ret);
> +		need_free = 1;
> +		goto out_commit;
> +	}
>  
>  	if (partial && (new_len != *len))
>  		*len = new_len;

__ocfs2_move_extent() calls ocfs2_split_extent() partway through, which
repoints the tree at new_phys_cpos, then can still fail in
ocfs2_decrease_refcount() (-ENOMEM from ocfs2_read_refcount_block()) or
ocfs2_truncate_log_append() (-ENOSPC). Neither aborts the handle.

On those failures the new out_commit path frees new_phys_cpos/new_len and
commits, so the clusters are both referenced by the extent tree and marked
free.

Thanks,
Joseph
