Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.99
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792580167;
	b=hoYMIHTcXGxfu/dRUbVUdV0HKCWKZCYLWXontRKmgM/B+Jd3JSUshURGeMbDrbp/V+M8
	 h1j3Tw/xLGjkCqSwFGx+oifqUzYrdvPi21wvs7u3q2lDQUTDW2Bj8B03Z8Q0n9uxi6bNq
	 7hn1M4qjngj/Y5tuSOM9KsvddsoQpDGivawOiujThL9HW0bLy5q06b0fk9raUrrG5PjX6
	 5JgO6nxTpXKymTyNk9SDFIi7v05FHodlI7ApbBShboO8nPVwPQWOQMoKh54pftvNyWNKT
	 Pxgt/hUvJbPoQHLNwpTvCZ2d3y1FDcEwmxEHmvQrWfuK0RcN9UP5drjM3Oqe4RQoA8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792580167;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=1awJR/cIwunF3OYLn6iH249UFQKC6nkambq2EgaI6ro=;
	b=WMtPr8Oqg9xQBBFmGv2dSOehuB0L1MsOg9CeIFaTGMleT7bu4ENgF8Lh32W2vliOktlo
	 PRCT4wFyjgeZ/DiTd4gGkVkJsjVwrV5kzROiwDJ1a7x4wb6e+E/GDKlFH6CKvNee1nnWZ
	 iRp//MMMW/UvIcn7gDtH3Rhypfjf5dtHqBRQv/1AJHWQJud+sH0WM5mqTmdj0lj1xrSpC
	 p7nfC1QCpYih46tL4cNpmbCKYfVQQVTCeZTzKTDVYQHYVEpw6aaLqR6NJsI7M+mRvxKoR
	 YUhC/ASDgLvU01O9IK0lgFCJQ9KhIhEIkr2MQKnmMGXsNaJvY2t8zl0feTKMjCCBSXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=wTJYdyrb;
	arc=none smtp.remote-ip=115.124.30.99
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 380C0606A327
	for <ocfs2-devel@lists.linux.dev>; Wed, 21 Oct 2026 10:56:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 380C0606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=wTJYdyrb
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1792580163; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=1awJR/cIwunF3OYLn6iH249UFQKC6nkambq2EgaI6ro=;
	b=wTJYdyrbKZItmkDakTkijPvVTsBvzwcLWxLd+HMcS3IBSaslGs/8ODsaJ9N/BfgcIdOpB7XJIh3QViZ5F7wUTu6MXmIniUoKkp1SX5mxCEDpWa8bmXbqZXE2jdmJOKjV3C4jjsHrK3wWoVnXwg9SzZKjweIK0B/DmxbY/PSeizg=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0XDG8Q0F_1792580162;
Received: from 30.221.149.139(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XDG8Q0F_1792580162 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 21 Oct 2026 18:56:02 +0800
Message-ID: <1baa76fc-4fc8-4943-816c-cc04e4dfec21@linux.alibaba.com>
Date: Wed, 21 Oct 2026 18:56:01 +0800
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
Subject: Re: [PATCH v2] ocfs2: drain quorum work before removing the cluster
To: Cen Zhang <zzzccc427@gmail.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: mark@fasheh.com, jlbec@evilplan.org, heming.zhao@suse.com,
 ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org, baijiaju1990@gmail.com, jjzuming@gmail.com
References: <pm-ocfs2-objects-candidate-0064-v5-e3870bf6571b80b07b52@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <pm-ocfs2-objects-candidate-0064-v5-e3870bf6571b80b07b52@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/20/26 11:45 AM, Cen Zhang wrote:
> The configured cluster must remain available until an in-flight quorum
> decision has finished using its fencing method. o2quo_make_decision()
> drops qs_lock before calling o2quo_fence_self(), which marks heartbeat
> regions for unclean stop and then reads
> o2nm_single_cluster->cl_fence_method. Cluster removal clears the
> singleton without waiting for this independent system-workqueue item.
> 
> When a failed-quorum decision overlaps removal of the heartbeat regions,
> nodes and cluster through configfs, the worker can be preempted after
> marking the regions and resume after the singleton has been cleared:
> 
>   Quorum worker                     Configfs removal
>   select fence; drop qs_lock
>   o2hb_stop_all_regions()
>                                     remove regions; join heartbeat threads
>                                     remove nodes; stop o2net
>                                     clear singleton; release cluster
>   read cl_fence_method
> 
> The resumed read dereferences NULL instead of applying the configured
> fencing method. The heartbeat thread's dependency protects the local
> node only until the thread exits, and draining o2net does not wait for
> qs_work.
> 
> Add o2quo_flush_work() to drain pending or running quorum decisions
> before clearing the singleton in o2nm_cluster_group_drop_item(). By
> this point the heartbeat regions and nodes have been removed, so their
> work publishers are stopped. The worker can finish while the cluster
> and its configured fencing method remain available. It does not acquire
> the configfs mutex held by the removal path.
> 
> Keep o2quo_exit() as the counterpart of o2quo_init() for module teardown
> and initialization failure, and have it call the same drain helper.
> Cluster removal uses only the explicitly named drain operation.
> 
> KASAN report as below:
> 
>     Oops: general protection fault, probably for non-canonical address 0xdffffc000000011b: 0000 [#1] SMP KASAN NOPTI
>     KASAN: null-ptr-deref in range [0x00000000000008d8-0x00000000000008df]
>     CPU: 0 UID: 0 PID: 72 Comm: kworker/0:2 Not tainted 7.3.0-rc4-next-20260921-pmb-ocfs2-functional-v1+ #1 PREEMPT(lazy)
>     Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
>     Workqueue: events o2quo_make_decision
>     RIP: 0010:o2quo_fence_self+0x65/0x200
> 
> Register dump omitted.
> 
>     Call Trace:
>      <TASK>
>      o2quo_make_decision+0x345/0x3a0
>      ? __pfx_o2quo_make_decision+0x10/0x10
>      ? process_one_work+0x834/0x1b40
>      ? srso_alias_return_thunk+0x5/0xfbef5
>      ? lock_release+0xc8/0x290
>      ? srso_alias_return_thunk+0x5/0xfbef5
>      process_one_work+0x9a8/0x1b40
>      ? __pfx_process_one_work+0x10/0x10
>      ? lock_acquire+0x190/0x300
>      ? lock_is_held_type+0x8f/0x100
>      ? srso_alias_return_thunk+0x5/0xfbef5
>      worker_thread+0x65c/0xe40
>      ? srso_alias_return_thunk+0x5/0xfbef5
>      ? __kthread_parkme+0x177/0x220
>      ? srso_alias_return_thunk+0x5/0xfbef5
>      ? __pfx_worker_thread+0x10/0x10
>      kthread+0x351/0x460
>      ? srso_alias_return_thunk+0x5/0xfbef5
>      ? __pfx_kthread+0x10/0x10
>      ret_from_fork+0x659/0x940
>      ? __pfx_ret_from_fork+0x10/0x10
>      ? srso_alias_return_thunk+0x5/0xfbef5
>      ? __switch_to+0x74f/0xf70
>      ? __pfx_kthread+0x10/0x10
>      ret_from_fork_asm+0x1a/0x30
>      </TASK>
>     Modules linked in:
>     ---[ end trace 0000000000000000 ]---
> 
> Fixes: f6656d26d17b ("ocfs2/cluster: Make fence method configurable - v2")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Cen Zhang <zzzccc427@gmail.com>

Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> Assisted-by: LLM
> ---
> Changes in v2:
> - Add a dedicated o2quo_flush_work() helper and use it before clearing the
>   cluster singleton, as requested by Joseph Qi.
> - Preserve o2quo_exit() as the counterpart of o2quo_init() and make it call
>   the shared drain helper.
> 
> Link to v1: https://lore.kernel.org/r/pm-ocfs2-objects-candidate-0064-v4-51daf51db746eedf7533@gmail.com
> 
>  fs/ocfs2/cluster/nodemanager.c | 3 +++
>  fs/ocfs2/cluster/quorum.c      | 7 ++++++-
>  fs/ocfs2/cluster/quorum.h      | 1 +
>  3 files changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/cluster/nodemanager.c b/fs/ocfs2/cluster/nodemanager.c
> index e08850a5d736..ced4fe6d3b59 100644
> --- a/fs/ocfs2/cluster/nodemanager.c
> +++ b/fs/ocfs2/cluster/nodemanager.c
> @@ -12,6 +12,7 @@
>  #include "tcp.h"
>  #include "nodemanager.h"
>  #include "heartbeat.h"
> +#include "quorum.h"
>  #include "masklog.h"
>  #include "sys.h"
>  
> @@ -740,6 +741,8 @@ static void o2nm_cluster_group_drop_item(struct config_group *group, struct conf
>  	struct o2nm_cluster *cluster = to_o2nm_cluster(item);
>  
>  	BUG_ON(o2nm_single_cluster != cluster);
> +	/* Drain quorum work before it loses access to the cluster. */
> +	o2quo_flush_work();
>  	o2nm_single_cluster = NULL;
>  
>  	configfs_remove_default_groups(&cluster->cl_group);
> diff --git a/fs/ocfs2/cluster/quorum.c b/fs/ocfs2/cluster/quorum.c
> index bfb8b456876c..ab5b3d4fd0e8 100644
> --- a/fs/ocfs2/cluster/quorum.c
> +++ b/fs/ocfs2/cluster/quorum.c
> @@ -318,9 +318,14 @@ void o2quo_init(void)
>  	INIT_WORK(&qs->qs_work, o2quo_make_decision);
>  }
>  
> -void o2quo_exit(void)
> +void o2quo_flush_work(void)
>  {
>  	struct o2quo_state *qs = &o2quo_state;
>  
>  	flush_work(&qs->qs_work);
>  }
> +
> +void o2quo_exit(void)
> +{
> +	o2quo_flush_work();
> +}
> diff --git a/fs/ocfs2/cluster/quorum.h b/fs/ocfs2/cluster/quorum.h
> index d64bf4482a4a..1ce5fc2a8ca9 100644
> --- a/fs/ocfs2/cluster/quorum.h
> +++ b/fs/ocfs2/cluster/quorum.h
> @@ -8,6 +8,7 @@
>  
>  void o2quo_init(void);
>  void o2quo_exit(void);
> +void o2quo_flush_work(void);
>  
>  void o2quo_hb_up(u8 node);
>  void o2quo_hb_down(u8 node);

