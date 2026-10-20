Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.110
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792458270;
	b=LXADauEZhuShVdaUIaOK7PH+XGGWKlcF7WIONjpBDu2fOjDEi7wCvH0czOkHASotBj1z
	 xUDFtWthHHha1hv0dcK+xP2NVB1wR6jtAF6jviDmX+06g2BhCB20tTGGdJXsoD2/sMVx1
	 OpDC3x+l7GMWPTklUbh4yB5HtPh4iVRpeHzWqkoX+WO1wfCqmLFn62YS+gUm3xM69Qcn9
	 lZr/rDEudaLRNbZpyDnoiEgWGupNKznA0+vLCneJiA4S8ELVMRj+DzIuCd6yMKu+U31Cz
	 EN/T7MKMSKfAfQ+bn+BfcCnV+g2jYycE3YZznUZTkfbeVbWlnLIHPl8hoR6UL2dmtQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792458270;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=l/hNaEYX7pwjnbOy9kQT5DzXVQgH4HbRFHOPYgj+TYc=;
	b=rOhbGtfDe6q4rZFKG9/pcRU6J7rcPCadtfbSwm1qZvEjXfjw1IpXmovFRSkI2aaNAObH
	 468wLph1oM+J3El2wx6BN6vbJHRbQQzOGbtyLpnFYXoYbWncyNLHLeOVnLyS47SPkpcFy
	 MHh+5qDD+2llFjBz5xEihGwjyMfHWNQzXGUedfmsZmVY/E4IgVGrHLpYXuv9ZwccAuG+F
	 mBUL0s5X1AjCvZiNo/HBMFj9y+hJf+FYP+X2+US22VLeBItPfASgYhivfW9LoglklK2b4
	 /uZHvEHBevIatfKXRr/7zyHD5m8tc67Qx65P3//OBmoe1z47nmVgrzWxCAxEm1WGcIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=s1jvQjTY;
	arc=none smtp.remote-ip=115.124.30.110
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DD1F606A319
	for <ocfs2-devel@lists.linux.dev>; Tue, 20 Oct 2026 01:04:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0DD1F606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=s1jvQjTY
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1792458261; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=l/hNaEYX7pwjnbOy9kQT5DzXVQgH4HbRFHOPYgj+TYc=;
	b=s1jvQjTYnZhmePGm0bkEKOZ5/y1N7l4MVPuI80gB8d9ywoio2DJirxlHSoOrL2I6Jzp9dpIPgJsLgZHyTIbrZIhknc48rLQy526y5fK/c5zTDXm7A6CiX8CBi2QTMi+wd64tgTXkivR9Gj0SB1LesNr8brNj/U6Znmk0LTCD6f4=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0XDAoyyL_1792458259;
Received: from 30.221.145.25(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XDAoyyL_1792458259 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 20 Oct 2026 09:04:20 +0800
Message-ID: <1beb38aa-e068-456c-a4d8-6590f2bd1266@linux.alibaba.com>
Date: Tue, 20 Oct 2026 09:04:19 +0800
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
Subject: Re: [PATCH] ocfs2: drain quorum work before removing the cluster
To: Cen Zhang <zzzccc427@gmail.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, heming.zhao@suse.com,
 akpm@linux-foundation.org, christophe.jaillet@wanadoo.fr, blum@kernel.org,
 kees@kernel.org, sunil.mushran@oracle.com, ocfs2-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org,
 baijiaju1990@gmail.com, jjzuming@gmail.com
References: <pm-ocfs2-objects-candidate-0064-v4-51daf51db746eedf7533@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <pm-ocfs2-objects-candidate-0064-v4-51daf51db746eedf7533@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/16/26 12:57 AM, Cen Zhang wrote:
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
> Call the existing o2quo_exit() flush before clearing the singleton in
> o2nm_cluster_group_drop_item(). By this point the heartbeat regions and
> nodes have been removed, so their work publishers are stopped. The
> flush lets any pending or running decision finish while the cluster is
> still available. It introduces no new state or locking; the worker does
> not acquire the configfs mutex held by the removal path.
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
> Assisted-by: LLM
> 
> ---
> diff --git a/fs/ocfs2/cluster/nodemanager.c b/fs/ocfs2/cluster/nodemanager.c
> index e08850a5d736..13d7f579047f 100644
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
> +	o2quo_exit();
>  	o2nm_single_cluster = NULL;
>  
>  	configfs_remove_default_groups(&cluster->cl_group);
------------------------------------------------------------------------
o2quo_exit() is the counterpart of o2quo_init(), and it is called from
o2net_exit() when the module goes away.

I'd like a separate drain helper, say o2quo_flush_work(), to describe
this better than reusing the exit function.

Thanks,
Joseph
