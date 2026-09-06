Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F25A443A90
	for <ocfs2-devel@lists.linux.dev>; Sun,  6 Sep 2026 14:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788704306; cv=none; b=TZqBf6vxGAf570OUdkAr53CN3iopDehLerb3Jo84oF2CH3T9uY1B9cWT6RqXOAAEzlsrDymHeJVH3EIOgERFyVokfH2h794Yj5YJhFnEguCtlQrsHd2zwRRADdBW2fWpMKR/Mcl18EM00xLnv5PaGoi3fYLbVPSU/qlsc9bIh6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788704306; c=relaxed/simple;
	bh=01RdXc6mGCbAbspIzJgjuqFcoBDlZMQc/YvqhseKRhI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UTyEWzV7/RWm+D7SJutYSTxxR0CK6deQzRC3LnFsFccidfT2tjX8SE6dFrlN7awnNVUY8awn++xY06FncRZMzgoNr95sULhKO4mieCXKhTyuBHuwsmjHYXeyr0YS8TuM48f/5Nyef9nNyHkiHPpTs1uMoZu6TF90Wj2P75G4ZDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=AkEhyEOW; arc=none smtp.client-ip=115.124.30.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="AkEhyEOW"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788704298; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=iEEv6zzBMMxNepIrZFHboYT46jsJmE0+05RgUWn+eGE=;
	b=AkEhyEOWkap8x79RVUtX7/XfhKYu3ObJ3VVo6UGMUYQkwk+RoF/Th8YPOu54erssa4341DQdoPAXjWxEZEXgqBRHE/uRlJmL7hsK+EoSMsOOT62xGptQ+nn98nLzUNUi6qYjfxxVhjouSGs3SQCT4WeQv3gGaj1t5rqrjT0dWiM=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0XANB5ld_1788704296;
Received: from 30.134.112.244(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XANB5ld_1788704296 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sun, 06 Sep 2026 22:18:17 +0800
Message-ID: <43d54bf7-a4b5-4556-bffe-d47eaf536bf5@linux.alibaba.com>
Date: Sun, 6 Sep 2026 22:18:16 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: fix ABBA deadlock in suballocator reclaim
To: ThangNN99 <ngocthang2710.1999@gmail.com>
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 Heming Zhao <heming.zhao@suse.com>, Andrew Morton
 <akpm@linux-foundation.org>, Su Yue <glass.su@suse.com>,
 ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 syzbot+73d1166b94ed9875af54@syzkaller.appspotmail.com, stable@vger.kernel.org
References: <20260906133112.73343-1-ngocthang2710.1999@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260906133112.73343-1-ngocthang2710.1999@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Seems you don't rebase the latest linux-next.
Actually this is already fixed in:
107451a4d732 ocfs2: defer suballocator block group reclaim to workqueue

Thanks,
Joseph

On 9/6/26 9:31 PM, ThangNN99 wrote:
> _ocfs2_reclaim_suballoc_to_main() runs inside an already-started
> transaction (j_trans_barrier held) and locks the global bitmap inode
> to return clusters to it. Every other allocation path takes that
> inode lock *before* starting a transaction, so this reverses the
> order and can deadlock:
> 
>   CPU0                          CPU1
>   rlock(j_trans_barrier)
>                                 lock(sb_internal)
>                                 lock(j_trans_barrier)
>   lock(GLOBAL_BITMAP inode)
> 
> Since reclaim is best-effort (its caller already ignores the return
> value), fix it by acquiring the global bitmap inode with trylock,
> before mutating anything, and bailing out to skip reclaim on a busy
> lock instead of blocking in the wrong order.
> 
> Reproduced with the syzbot C repro under QEMU: the unpatched kernel
> hits the lockdep splat on the very first mount+mkdir+rmdir cycle
> (~10s in); the patched kernel ran the same cycle 169 times with zero
> splats, and instrumentation confirmed reclaim keeps running (trylock
> succeeds) rather than being silently skipped.
> 
> Reported-by: syzbot+73d1166b94ed9875af54@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=73d1166b94ed9875af54
> Fixes: 4a54331616b3 ("ocfs2: give ocfs2 the ability to reclaim suballocator free bg")
> Cc: stable@vger.kernel.org
> Signed-off-by: ThangNN99 <ngocthang2710.1999@gmail.com>
> ---
>  fs/ocfs2/suballoc.c | 37 +++++++++++++++++++++++--------------
>  1 file changed, 23 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
> index 20c3aec6b987..085af9ba38ab 100644
> --- a/fs/ocfs2/suballoc.c
> +++ b/fs/ocfs2/suballoc.c
> @@ -2716,18 +2716,39 @@ static int _ocfs2_reclaim_suballoc_to_main(handle_t *handle,
>  	idx = le16_to_cpu(group->bg_chain);
>  	rec = &(cl->cl_recs[idx]);
>  
> +	/*
> +	 * We already hold j_trans_barrier, while everywhere else locks the
> +	 * allocator inode before starting a transaction. Trylock here, before
> +	 * mutating anything, so a busy lock skips this best-effort reclaim
> +	 * instead of inverting that order into an ABBA deadlock.
> +	 */
> +	main_bm_inode = ocfs2_get_system_file_inode(osb,
> +						    GLOBAL_BITMAP_SYSTEM_INODE,
> +						    OCFS2_INVALID_SLOT);
> +	if (!main_bm_inode)
> +		goto bail; /* ignore the error in reclaim path */
> +
> +	if (!inode_trylock(main_bm_inode)) {
> +		iput(main_bm_inode);
> +		goto bail; /* ignore the error in reclaim path */
> +	}
> +
> +	status = ocfs2_try_inode_lock(main_bm_inode, &main_bm_bh, 1);
> +	if (status < 0)
> +		goto free_bm_inode; /* ignore the error in reclaim path */
> +
>  	status = ocfs2_extend_trans(handle,
>  				ocfs2_calc_group_alloc_credits(osb->sb,
>  						 le16_to_cpu(cl->cl_cpg)));
>  	if (status) {
>  		mlog_errno(status);
> -		goto bail;
> +		goto free_bm_bh;
>  	}
>  	status = ocfs2_journal_access_di(handle, INODE_CACHE(alloc_inode),
>  					 alloc_bh, OCFS2_JOURNAL_ACCESS_WRITE);
>  	if (status < 0) {
>  		mlog_errno(status);
> -		goto bail;
> +		goto free_bm_bh;
>  	}
>  
>  	/*
> @@ -2795,18 +2816,6 @@ static int _ocfs2_reclaim_suballoc_to_main(handle_t *handle,
>  	memset(group, 0, sizeof(struct ocfs2_group_desc));
>  
>  	/* prepare job for reclaim clusters */
> -	main_bm_inode = ocfs2_get_system_file_inode(osb,
> -						    GLOBAL_BITMAP_SYSTEM_INODE,
> -						    OCFS2_INVALID_SLOT);
> -	if (!main_bm_inode)
> -		goto bail; /* ignore the error in reclaim path */
> -
> -	inode_lock(main_bm_inode);
> -
> -	status = ocfs2_inode_lock(main_bm_inode, &main_bm_bh, 1);
> -	if (status < 0)
> -		goto free_bm_inode; /* ignore the error in reclaim path */
> -
>  	ocfs2_block_to_cluster_group(main_bm_inode, start_blk, &bg_blkno,
>  				     &start_bit);
>  	fe = (struct ocfs2_dinode *) main_bm_bh->b_data;

