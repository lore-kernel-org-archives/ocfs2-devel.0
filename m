Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB1BE3932D1
	for <ocfs2-devel@lists.linux.dev>; Wed, 23 Sep 2026 02:45:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790131521; cv=none; b=d7wzoe13QoaNDfu2cHupdvgtLf9XCPx1ffhLc5x8F8ngGTjkabTBPKAmQJn07ykqBcRM0KW18+GIphPzfstKR7Wf0IQqmF6qv3pUPUxUHFoJVBxAAfe3ETZdfYM2ockXt8TmnyEB4qc4vpZ1vSqeDjKxu+7TPD7Y+dqK7pclhOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790131521; c=relaxed/simple;
	bh=PSSM7K/fn4Nkrq6d5fc8Mmdz+iCnvg4dwHtMWkc4vc0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IJhoPBzYuPKSQRbfW+gG+8jtEhdE2w7A8GJ4Eh4jHHsZWpoYv2Cyo5dOm7t1HEiVGsuBNeq6nb1vpMUXDMnXxrqb/KxdKtM8XufbmnSi6PMHiQp6i+IfW8qTICIcru5Y6V0HcwFllXIv6hlXhMGVT0CM9u8w5bE4bP0kVGcHQTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=cND1MLCq; arc=none smtp.client-ip=115.124.30.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="cND1MLCq"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1790131513; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=trCBeAovAYhgYEdqVsI6xe1L4c6rfxTxY8bJzoa7qJk=;
	b=cND1MLCqXJ7hf8A8h4JHRYdICyMHWrj1zHLCqlV7myRe0VzQsztnGodMedb+EKWBUar+6tBdxx4sRLwA7ymPlopa24CAJcHIGnNwVu9sdoK77sjKZRd/HjHDwRPvN/W5MX2eoN+e3wyheZNBtvSc9qjYEvYaXqukrhZTFL4u4RI=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0XBVVb7s_1790131512;
Received: from 30.170.56.46(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XBVVb7s_1790131512 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 23 Sep 2026 10:45:13 +0800
Message-ID: <e06390dc-fdfb-4bad-85ba-6baf361fac18@linux.alibaba.com>
Date: Wed, 23 Sep 2026 10:45:10 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2/cluster: hold a reference on the heartbeat thread
To: Karl Mehltretter <kmehltretter@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 Cen Zhang <zzzccc427@gmail.com>, ocfs2-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org, Sashiko <sashiko-bot@kernel.org>
References: <20260923010149.14391-1-kmehltretter@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260923010149.14391-1-kmehltretter@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 9/23/26 9:01 AM, Karl Mehltretter wrote:
> Since commit 688bc88e2046 ("ocfs2/cluster: keep heartbeat local node
> stable"), o2hb_thread() leaves its loop and returns when the local node
> changes, for example after "echo 0 > node/<name>/local". The thread
> was started with kthread_run() and nothing holds a reference to its
> task_struct, so the task is freed once it exits, while reg->hr_task
> still points to it.
> 
> Reading the region's pid attribute then reads the freed task, and
> removing the region calls kthread_stop() on it:
> 
>   BUG: KASAN: slab-use-after-free in o2hb_region_pid_show+0xb3/0xc0
>   refcount_t: addition on 0; use-after-free.
>   Oops: Oops: 0000 [#1] SMP KASAN NOPTI
>   RIP: 0010:kthread_stop+0xb1/0x390
> 
> The thread could already return by itself before, when heartbeat start
> was aborted or on an unclean stop, but the local node change makes it
> reachable from userspace at any time.
> 
> Create the thread parked, take a reference on it and only then wake it,

Just a wording nit. kthread_create() doesn't leave the thread parked in
the kthread_park() sense. __kthread_parkme() only runs after the first
wake_up_process(), so "parked" here may be a little confused.

> so the reference cannot race with the thread exiting. Drop it with
> kthread_stop_put().
> 
> Fixes: 688bc88e2046 ("ocfs2/cluster: keep heartbeat local node stable")
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Closes: https://sashiko.dev/#/patchset/20260616074931.3774929-1-zzzccc427%40gmail.com
> Assisted-by: LLM
> Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>

The change looks fine to me.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
> Reproduced under QEMU x86_64 with KASAN, using one node over configfs
> and a loop device as the heartbeat region:
> 
>   echo 0 > cluster/c1/node/n0/local     # heartbeat thread returns
>   cat cluster/c1/heartbeat/<uuid>/pid   # reads the freed task_struct
>   rmdir cluster/c1/heartbeat/<uuid>     # kthread_stop() on it
> 
> With the patch, that sequence, a normal region removal and a start
> interrupted by a signal ran clean on two CPUs, five rounds each, and
> every heartbeat task_struct was freed.
> 
>  fs/ocfs2/cluster/heartbeat.c | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
> index 1c3def99bb076..a4c8ea695f5cf 100644
> --- a/fs/ocfs2/cluster/heartbeat.c
> +++ b/fs/ocfs2/cluster/heartbeat.c
> @@ -1966,18 +1966,22 @@ static ssize_t o2hb_region_dev_store(struct config_item *item,
>  	atomic_set(&reg->hr_unsteady_iterations, (live_threshold * 3));
>  	o2hb_set_region_stopping(reg, false);
>  
> -	hb_task = kthread_run(o2hb_thread, reg, "o2hb-%s",
> -			      reg->hr_item.ci_name);
> +	hb_task = kthread_create(o2hb_thread, reg, "o2hb-%s",
> +				 reg->hr_item.ci_name);
>  	if (IS_ERR(hb_task)) {
>  		ret = PTR_ERR(hb_task);
>  		mlog_errno(ret);
>  		goto out;
>  	}
> +	/* The thread may exit on its own, so pin it before it can run. */
> +	get_task_struct(hb_task);
>  
>  	spin_lock(&o2hb_live_lock);
>  	reg->hr_task = hb_task;
>  	spin_unlock(&o2hb_live_lock);
>  
> +	wake_up_process(hb_task);
> +
>  	ret = wait_event_interruptible(o2hb_steady_queue,
>  				atomic_read(&reg->hr_steady_iterations) == 0 ||
>  				reg->hr_node_deleted);
> @@ -2022,7 +2026,7 @@ static ssize_t o2hb_region_dev_store(struct config_item *item,
>  		spin_unlock(&o2hb_live_lock);
>  
>  		if (hb_task)
> -			kthread_stop(hb_task);
> +			kthread_stop_put(hb_task);
>  
>  		o2hb_unmap_slot_data(reg);
>  
> @@ -2208,7 +2212,7 @@ static void o2hb_heartbeat_group_drop_item(struct config_group *group,
>  	spin_unlock(&o2hb_live_lock);
>  
>  	if (hb_task)
> -		kthread_stop(hb_task);
> +		kthread_stop_put(hb_task);
>  
>  	if (o2hb_global_heartbeat_active()) {
>  		spin_lock(&o2hb_live_lock);

