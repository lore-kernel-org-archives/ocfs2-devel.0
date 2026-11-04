Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793783944;
	b=dfFCLeSeWh1We2ieU7GBCdxitkotuj9KIeoeJk2n5pc8PAt9PeK9rfJjo63AhxikhUll
	 E8iUbhtEx8e/PJzNddBun2uharjt5nuxUoFAIiL0EpWteKQmfqaYTsAOIR5ePPqpf66RC
	 datqsz/8uaEPK5SU6l1YdsnPOqmQekgSm9J12oy/LEE6s7f5jzu8OI9rjL//0spwOLZDZ
	 PILSkhZ4bJotPqArCYeIpdHVkyN/hECqGcTT76NkxWv+gYFc6HaG2FZpsuDUVa4G4Nbfo
	 iy+WPAvLIc2SnlyTFRiy0+xwR+25TE9VenZv7+S34dYJofyI8cQM2J9st7YogeMqdQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793783944;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=BAoBjpIgACtrLsmOkRtFMCNcv/GAFByXNJ6aEQXCWcc=;
	b=sb3WBt6OSyCyQ/GW6cDv4B/8N7VRrckkIPOBCnLBP0JhKM0jMazIYkyw6eqcdUh8E1gc
	 qrl9hy4vBi6pJgD6sA0mk5i+y/n5pZFJ3wb3AePlOXksTS9Aec8THHIT5bihTGltD1+Pb
	 zd2q4UPlPl3HxUKDGzqvvUD32q9djdjzmgwwQDUJj5husBeIjAiuUyNNZuP3ln/s4i32l
	 Y5uAHa42BRryXPCQFDrzCRi5CocjNRibY8uVGeViweqx8H35oId+Gcv4o13uftXNbt34U
	 0B5b6kSRzK6ghe4dAYyFKdS1xMMEMwgRNU1pkansQEf6yEY2fExvhTDFm50EpuSmt7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=LlXke0td;
	arc=none smtp.remote-ip=115.124.30.130
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63107606A31B
	for <ocfs2-devel@lists.linux.dev>; Wed,  4 Nov 2026 09:19:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 63107606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=LlXke0td
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793783934; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=BAoBjpIgACtrLsmOkRtFMCNcv/GAFByXNJ6aEQXCWcc=;
	b=LlXke0td+x99xSJtaqAl0gAnWpBanbSxVkGnP1vbWDStvhhcIF9SHBBongeOoTykxJi0j91dqDjiRMgvh86D/g9tMZGwO7AxLE+N7J0IZfevU5sxPEMa1h62vhPU4ykebF58Sq4oplF2KZ6dPsCJ15oSSX2gZoJ68cSZC300v6A=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0XE5HIU1_1793783932;
Received: from 30.221.129.178(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XE5HIU1_1793783932 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 04 Nov 2026 17:18:53 +0800
Message-ID: <c625feef-9fb4-4a32-b40f-5d118768c587@linux.alibaba.com>
Date: Wed, 4 Nov 2026 17:18:52 +0800
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Post: <mailto:ocfs2-devel@lists.linux.dev>
List-Help: <mailto:ocfs2-devel+help@lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:ocfs2-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2/dlmfs: keep the superblock alive during lock work
To: Cen Zhang <zzzccc427@gmail.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: mark@fasheh.com, jlbec@evilplan.org, heming.zhao@suse.com,
 ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org, baijiaju1990@gmail.com, jjzuming@gmail.com
References: <pm-ocfs2-objects-candidate-0054-v6-c3887cceae3b039e591e@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <pm-ocfs2-objects-candidate-0054-v6-c3887cceae3b039e591e@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/29/26 3:00 PM, Cen Zhang wrote:
> Queued dlmfs lock work holds an inode reference, but no active reference
> to its superblock. The workqueue is drained on module exit rather than
> on each dlmfs unmount, and an inode reference does not stop superblock
> shutdown: generic_shutdown_super() reports the busy inode and goes on.
> 
>   DLM callback / worker               Unmount
>   ---------------------               -------
>   queue lock work; igrab(inode)
>   worker delayed
>                                       drop last active superblock ref
>                                       kill_anon_super()
>                                         report the busy inode
>                                         free the superblock
>   finish lock work
>   iput(inode)
>     access the inode's freed superblock
> 
> Flushing the workqueue from a dlmfs kill_sb would not be enough: a
> blocking AST can queue new work for an inode that is still alive after
> the flush and before eviction, and that work again holds only an inode
> reference.
> 
> Take an active superblock reference before acquiring the queued inode
> reference, with the atomic_inc_not_zero() on s_active that grab_super()
> and the NFS and procfs superblock walkers use. Decline to queue if the
> superblock is already shutting down; the inode is then being evicted
> and user_dlm_destroy_lock() tears the lock down. The existing l_lock
> and USER_LOCK_QUEUED flag serialize this with other queue attempts.
> Each execution drops its inode reference before releasing the active
> superblock reference, outside l_lock. If that releases the last active
> reference, the unmount completes on the worker; it only waits for DLM
> replies and never for this workqueue.
> 
> Only the relevant frames of the report are kept:
> 
> Oops: general protection fault, probably for non-canonical address 0xfbd59c0000000026: 0000 [#1] SMP KASAN NOPTI
> KASAN: maybe wild-memory-access in range [0xdead000000000130-0xdead000000000137]
> Workqueue: user_dlm user_dlm_unblock_lock
> RIP: 0010:iput+0x246/0xc10
> Call Trace:
>  <TASK>
>  user_dlm_unblock_lock+0x503/0xa50
>  process_one_work+0x9a8/0x1b40
>  worker_thread+0x65c/0xe40
>  </TASK>
> 
> Fixes: 8df08c89c668 ("[PATCH] OCFS2: The Second Oracle Cluster Filesystem")
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Cen Zhang <zzzccc427@gmail.com>

Looks fine.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
>  fs/ocfs2/dlmfs/userdlm.c | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ocfs2/dlmfs/userdlm.c b/fs/ocfs2/dlmfs/userdlm.c
> index 617c92e7b925..516e50a5728d 100644
> --- a/fs/ocfs2/dlmfs/userdlm.c
> +++ b/fs/ocfs2/dlmfs/userdlm.c
> @@ -162,7 +162,13 @@ static void user_dlm_unblock_lock(struct work_struct *work);
>  
>  static void __user_dlm_queue_lockres(struct user_lock_res *lockres)
>  {
> +	struct inode *inode = user_dlm_inode_from_user_lockres(lockres);
> +
>  	if (!(lockres->l_flags & USER_LOCK_QUEUED)) {
> +		/* Pin the superblock through the worker's iput(). */
> +		if (!atomic_inc_not_zero(&inode->i_sb->s_active))
> +			return;
> +
>  		user_dlm_grab_inode_ref(lockres);
>  
>  		INIT_WORK(&lockres->l_work, user_dlm_unblock_lock);
> @@ -275,9 +281,11 @@ static struct ocfs2_locking_protocol user_dlm_lproto = {
>  
>  static inline void user_dlm_drop_inode_ref(struct user_lock_res *lockres)
>  {
> -	struct inode *inode;
> -	inode = user_dlm_inode_from_user_lockres(lockres);
> +	struct inode *inode = user_dlm_inode_from_user_lockres(lockres);
> +	struct super_block *sb = inode->i_sb;
> +
>  	iput(inode);
> +	deactivate_super(sb);
>  }
>  
>  static void user_dlm_unblock_lock(struct work_struct *work)

