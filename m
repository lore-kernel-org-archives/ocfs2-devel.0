Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBD903DBD57
	for <ocfs2-devel@lists.linux.dev>; Tue, 16 Jun 2026 06:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.113
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781591603; cv=none; b=DQlIUsWnnjIwNZM0UP/MdHBMa6zYi8M3dhu5+9wkcIkP7OKilYNMGmdyf62Tz+XRzyP5sL43wNWR6+WSVmR50xdqd184CKmsYCTHqz/ySNLrMK+57cNCs7rb0KI+wvKuGg/oMpCfUqCTEv33jlngWPDN6nSNx/qBYYMDyfhRiso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781591603; c=relaxed/simple;
	bh=DWi1GwMxDhvZ7gRN9y8bugxzyW6uSI1IzSpGkKKrdGo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tx4WibyHxYj+5IX1UlASpy16q+wbmVt9u/CHGFUVAZfkU1ZOXoJgKP72MENRl6Qw1n5WsbuGopsVCrR+3IUun5pjPHSarSP46JfroQj0dHoZ1jj9Hl2KPrNvZ0NWdYtOhpx0JMcvqLv9zzaLaCbyi9QW+PqzRqhGUECLFFqoaxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=F9UIsHU1; arc=none smtp.client-ip=115.124.30.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="F9UIsHU1"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1781591597; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=a4LQxhSgp0MzujG44kca/3pgDRv7KkogTSxRWSfXu0o=;
	b=F9UIsHU1P/e9CHpZypsm3pge1+XBv99vHBcUcFsEsctTPc7tZpIfl3H0Opb7zzLIsz1LLosjqdqYfAA4mhhHF2NPDorCZPdQhXs5O48r0nTD2VPCrdHWz/USXmsAuXVjAM2wDxjdUz22cnFnak3jO0kjUiX6ohMGzbkBhrZsqbM=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0X5-WfG0_1781591595;
Received: from 30.221.145.41(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X5-WfG0_1781591595 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 16 Jun 2026 14:33:16 +0800
Message-ID: <84ecad6e-4072-46e5-a2ab-3dbfe5c48476@linux.alibaba.com>
Date: Tue, 16 Jun 2026 14:33:15 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2/cluster: reject local node clears while heartbeat
 runs
To: Cen Zhang <zzzccc427@gmail.com>
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 baijiaju1990@gmail.com, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, Heming Zhao <heming.zhao@suse.com>
References: <20260614053345.64053-1-zzzccc427@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260614053345.64053-1-zzzccc427@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 6/14/26 1:33 PM, Cen Zhang wrote:
> o2nm_node_local_store() can clear the current local node while a
> heartbeat region is still active. That path stops listening and stores
> O2NM_INVALID_NODE_NUM, but heartbeat threads keep calling
> o2nm_this_node() from o2hb_do_disk_heartbeat() and shutdown.
> 

Seems a simple fix for this issue is also clearing cluster->cl_has_local
in the same path?

Thanks,
Joseph

> Once that happens, o2hb_check_own_slot() and o2hb_prepare_block() can
> use node 255 as a slot index, and o2nm_undepend_this_node() can BUG_ON()
> when the thread exits. The same local=0 path also leaves cl_has_local
> set, so later attempts to restore a real local node fail with -EBUSY.
> 
> Track the heartbeat start/run/stop window with a per-region active flag
> protected by o2hb_live_lock. Set it before kthread_run() can let the
> heartbeat thread re-read o2nm_this_node(), and clear it only after
> startup cleanup or region teardown has stopped any created thread. Then
> reject local=0 while any region remains active, and when the clear is
> allowed drop cl_has_local together with cl_local_node so the
> nodemanager state matches o2nm_node_group_drop_item().
> 
> The buggy scenario involves two paths, with each column showing the
> order within that path:
> 
> configfs local attribute store		heartbeat thread
> 1. Userspace writes 0 to the		1. o2hb_thread() keeps calling
>    current node's local attribute.	   o2hb_do_disk_heartbeat().
> 2. o2nm_node_local_store()		2. o2hb_check_own_slot() and
>    stops listening and stores		   o2hb_prepare_block() re-read
>    O2NM_INVALID_NODE_NUM.		   o2nm_this_node().
> 3. cl_has_local still stays set,	3. The thread uses node 255 as
>    so later o2nm_this_node()		   the local slot index or
>    reports node 255.			   shutdown node number.
> 4. A later local=1 write hits		4. Heartbeat can touch
>    -EBUSY.				   reg->hr_slots[255] or BUG_ON()
> 					   in o2nm_undepend_this_node().
> 
> Validation reproduced this kernel report:
> KASAN slab-out-of-bounds in o2hb_do_disk_heartbeat+0x372/0xb30
> RIP: 0010:memset+0xf/0x20
> Read of size 8
> Call trace:
>   dump_stack_lvl+0x66/0xa0
>   print_report+0xd0/0x630
>   o2hb_do_disk_heartbeat+0x372/0xb30 (fs/ocfs2/cluster/heartbeat.c:1079)
>   srso_alias_return_thunk+0x5/0xfbef5
>   __virt_addr_valid+0x188/0x2f0
>   kasan_report+0xe4/0x120
>   o2hb_do_disk_heartbeat+0x5/0xb30 (fs/ocfs2/cluster/heartbeat.c:1079)
>   o2hb_thread+0x14e/0x770
>   kthread_affine_node+0x139/0x180
>   lockdep_hardirqs_on_prepare+0xda/0x190
>   trace_hardirqs_on+0x18/0x130
>   kthread+0x19d/0x1e0
>   ret_from_fork+0x37a/0x4d0
>   __switch_to+0x2d5/0x6f0
>   ret_from_fork_asm+0x1a/0x30
> 
> Fixes: a7f6a5fb4bde ("[PATCH] OCFS2: The Second Oracle Cluster Filesystem")
> Assisted-by: Codex:gpt-5.5
> Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
> ---
>  fs/ocfs2/cluster/heartbeat.c   | 55 +++++++++++++++++++++++++++++++---
>  fs/ocfs2/cluster/heartbeat.h   |  1 +
>  fs/ocfs2/cluster/nodemanager.c | 13 ++++----
>  fs/ocfs2/cluster/nodemanager.h |  3 ++
>  4 files changed, 63 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
> index d12784aaaa4b..4c83f680017f 100644
> --- a/fs/ocfs2/cluster/heartbeat.c
> +++ b/fs/ocfs2/cluster/heartbeat.c
> @@ -201,8 +201,9 @@ struct o2hb_region {
>  				hr_item_dropped:1,
>  				hr_node_deleted:1;
>  
> -	/* protected by the hr_callback_sem */
> +	/* Protected by o2hb_live_lock. */
>  	struct task_struct 	*hr_task;
> +	bool			hr_heartbeat_active;
>  
>  	unsigned int		hr_blocks;
>  	unsigned long long	hr_start_block;
> @@ -1771,8 +1772,9 @@ static int o2hb_populate_slot_data(struct o2hb_region *reg)
>  }
>  
>  /*
> - * this is acting as commit; we set up all of hr_bdev_file and hr_task or
> - * nothing
> + * This acts as commit.  The active flag covers the start/run/stop window and
> + * startup publishes it before rechecking the local node, so local=0 either
> + * sees heartbeat in progress or forces this path to fail before a thread runs.
>   */
>  static ssize_t o2hb_region_dev_store(struct config_item *item,
>  				     const char *page,
> @@ -1874,6 +1876,17 @@ static ssize_t o2hb_region_dev_store(struct config_item *item,
>  	/* unsteady_iterations is triple the steady_iterations */
>  	atomic_set(&reg->hr_unsteady_iterations, (live_threshold * 3));
>  
> +	o2nm_lock_subsystem();
> +	spin_lock(&o2hb_live_lock);
> +	reg->hr_heartbeat_active = true;
> +	spin_unlock(&o2hb_live_lock);
> +	if (o2nm_this_node() == O2NM_MAX_NODES) {
> +		o2nm_unlock_subsystem();
> +		ret = -EINVAL;
> +		goto out;
> +	}
> +	o2nm_unlock_subsystem();
> +
>  	hb_task = kthread_run(o2hb_thread, reg, "o2hb-%s",
>  			      reg->hr_item.ci_name);
>  	if (IS_ERR(hb_task)) {
> @@ -1925,10 +1938,16 @@ static ssize_t o2hb_region_dev_store(struct config_item *item,
>  		spin_lock(&o2hb_live_lock);
>  		hb_task = reg->hr_task;
>  		reg->hr_task = NULL;
> +		if (!hb_task)
> +			reg->hr_heartbeat_active = false;
>  		spin_unlock(&o2hb_live_lock);
>  
> -		if (hb_task)
> +		if (hb_task) {
>  			kthread_stop(hb_task);
> +			spin_lock(&o2hb_live_lock);
> +			reg->hr_heartbeat_active = false;
> +			spin_unlock(&o2hb_live_lock);
> +		}
>  
>  		o2hb_unmap_slot_data(reg);
>  
> @@ -2109,6 +2128,11 @@ static void o2hb_heartbeat_group_drop_item(struct config_group *group,
>  	if (hb_task)
>  		kthread_stop(hb_task);
>  
> +	spin_lock(&o2hb_live_lock);
> +	if (hb_task)
> +		reg->hr_heartbeat_active = false;
> +	spin_unlock(&o2hb_live_lock);
> +
>  	if (o2hb_global_heartbeat_active()) {
>  		spin_lock(&o2hb_live_lock);
>  		clear_bit(reg->hr_region_num, o2hb_region_bitmap);
> @@ -2571,6 +2595,29 @@ int o2hb_get_all_regions(char *region_uuids, u8 max_regions)
>  }
>  EXPORT_SYMBOL_GPL(o2hb_get_all_regions);
>  
> +/*
> + * The active flag covers the entire start/run/stop window in which a region
> + * may still have a heartbeat thread that can re-read o2nm_this_node().
> + */
> +int o2hb_heartbeat_active(void)
> +{
> +	struct o2hb_region *reg;
> +	int active = 0;
> +
> +	spin_lock(&o2hb_live_lock);
> +
> +	list_for_each_entry(reg, &o2hb_all_regions, hr_all_item) {
> +		if (reg->hr_heartbeat_active) {
> +			active = 1;
> +			break;
> +		}
> +	}
> +
> +	spin_unlock(&o2hb_live_lock);
> +
> +	return active;
> +}
> +
>  int o2hb_global_heartbeat_active(void)
>  {
>  	return (o2hb_heartbeat_mode == O2HB_HEARTBEAT_GLOBAL);
> diff --git a/fs/ocfs2/cluster/heartbeat.h b/fs/ocfs2/cluster/heartbeat.h
> index 8ef8c1b9eeb7..7040dc4b529d 100644
> --- a/fs/ocfs2/cluster/heartbeat.h
> +++ b/fs/ocfs2/cluster/heartbeat.h
> @@ -66,6 +66,7 @@ int o2hb_check_node_heartbeating_no_sem(u8 node_num);
>  int o2hb_check_node_heartbeating_from_callback(u8 node_num);
>  void o2hb_stop_all_regions(void);
>  int o2hb_get_all_regions(char *region_uuids, u8 numregions);
> +int o2hb_heartbeat_active(void);
>  int o2hb_global_heartbeat_active(void);
>  
>  #endif /* O2CLUSTER_HEARTBEAT_H */
> diff --git a/fs/ocfs2/cluster/nodemanager.c b/fs/ocfs2/cluster/nodemanager.c
> index 402563154550..ffe9cb37d9e5 100644
> --- a/fs/ocfs2/cluster/nodemanager.c
> +++ b/fs/ocfs2/cluster/nodemanager.c
> @@ -25,9 +25,6 @@ static const char *o2nm_fence_method_desc[O2NM_FENCE_METHODS] = {
>  	"panic",	/* O2NM_FENCE_PANIC */
>  };
>  
> -static inline void o2nm_lock_subsystem(void);
> -static inline void o2nm_unlock_subsystem(void);
> -
>  struct o2nm_node *o2nm_get_node_by_num(u8 node_num)
>  {
>  	struct o2nm_node *node = NULL;
> @@ -366,7 +363,13 @@ static ssize_t o2nm_node_local_store(struct config_item *item, const char *page,
>  
>  	if (!tmp && cluster->cl_has_local &&
>  	    cluster->cl_local_node == node->nd_num) {
> +		if (o2hb_heartbeat_active()) {
> +			ret = -EBUSY;
> +			goto out;
> +		}
> +
>  		o2net_stop_listening(node);
> +		cluster->cl_has_local = 0;
>  		cluster->cl_local_node = O2NM_INVALID_NODE_NUM;
>  	}
>  
> @@ -762,12 +765,12 @@ static struct o2nm_cluster_group o2nm_cluster_group = {
>  	},
>  };
>  
> -static inline void o2nm_lock_subsystem(void)
> +void o2nm_lock_subsystem(void)
>  {
>  	mutex_lock(&o2nm_cluster_group.cs_subsys.su_mutex);
>  }
>  
> -static inline void o2nm_unlock_subsystem(void)
> +void o2nm_unlock_subsystem(void)
>  {
>  	mutex_unlock(&o2nm_cluster_group.cs_subsys.su_mutex);
>  }
> diff --git a/fs/ocfs2/cluster/nodemanager.h b/fs/ocfs2/cluster/nodemanager.h
> index 3490e77a952d..96c0abb1f127 100644
> --- a/fs/ocfs2/cluster/nodemanager.h
> +++ b/fs/ocfs2/cluster/nodemanager.h
> @@ -63,6 +63,9 @@ struct o2nm_node *o2nm_get_node_by_ip(__be32 addr);
>  void o2nm_node_get(struct o2nm_node *node);
>  void o2nm_node_put(struct o2nm_node *node);
>  
> +void o2nm_lock_subsystem(void);
> +void o2nm_unlock_subsystem(void);
> +
>  int o2nm_depend_item(struct config_item *item);
>  void o2nm_undepend_item(struct config_item *item);
>  int o2nm_depend_this_node(void);

