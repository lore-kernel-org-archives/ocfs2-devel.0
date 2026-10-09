Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D3373C4B81
	for <ocfs2-devel@lists.linux.dev>; Fri,  9 Oct 2026 09:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791537339; cv=none; b=qMADLb3xiwfIVNe/sHOXAqqu+TTJQDtdEhbJW22X1pppIS3cHY393WrI5QG4+Kubg6Xg673fUWlnqAYVYmfTNeKZ7Em7uYuY3Rs9TbNch2IpH/5u93MCkVDopbkz3SsvXXfAloRbYsi63IK0QuUM8xWr4yB9pejrb0z1QsvB0Uo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791537339; c=relaxed/simple;
	bh=6jy06vBwY/SUVGgvnO6yssV3juVib5+IYyAAHVzm2pA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Y6G72kPYoPJmwedfzknaMNpbOjJu3GMH7EIOkbMw64l6jwnZMQMBEOGpzmL5s1UMQTdQUFNDTLxTIWEG1LENzIjCog1FZQUHT+y+sh0RclgSa81K3Zf1TW6VOrtGflytUa1Ho+QKoLAeXnrvGBGHlj/CrHZpxGccBEedsHeOX1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=ny7Jj7A7; arc=none smtp.client-ip=115.124.30.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="ny7Jj7A7"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1791537332; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=GpVp6KFbLfTY1qHfx9ShcR45B4/eI143ESKm+3UNOkU=;
	b=ny7Jj7A7DgtNc6LzzhfDTWnLQpcJymDHpUAJuunTc+90V31ZVM6Deb2tpVbTwo8Lu3AUAF92n5FLvdDVcMIH7HCPNAUSNxPZCDWweAubIHPRVZprbaUzDTCmGulSnKrMoR0L+z1K/G9liBZJWiXOf+vsq88pWkk+N4d60LKJxUk=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0XCT-3T7_1791537331;
Received: from 30.221.148.47(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XCT-3T7_1791537331 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 09 Oct 2026 17:15:31 +0800
Message-ID: <df6242cb-9bf4-4387-8558-bc5c6a6e042e@linux.alibaba.com>
Date: Fri, 9 Oct 2026 17:15:29 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ocfs2/heartbeat: Unlink live slots when their node is
 missing
To: Cen Zhang <zzzccc427@gmail.com>, akpm@linux-foundation.org
Cc: mark@fasheh.com, jlbec@evilplan.org, ericterminal@gmail.com,
 kees@kernel.org, ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 baijiaju1990@gmail.com, jjzuming@gmail.com
References: <pm-ocfs2-objects-candidate-0058-v2-9446113c2b16c817c538@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <pm-ocfs2-objects-candidate-0058-v2-9446113c2b16c817c538@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/9/26 1:21 PM, Cen Zhang wrote:
> o2hb_shutdown_slot() returns immediately when its node is no longer
> in the configfs registry. A slot can still be linked in o2hb_live_slots
> when that lookup fails. Region teardown or startup-error cleanup then
> frees the slot array without removing its embedded list member.
> 
> With the same peer live in another region, the next list update can
> follow a predecessor into the freed array. Reusing the node number can
> also make a later insertion encounter that stale member.
> 
> Always remove the slot under o2hb_live_lock, even when node lookup
> fails. Preserve aggregate membership accounting and the last-region
> DOWN callback: the existing callback interface explicitly permits a
> NULL node for DOWN events. Only drop the node reference when lookup
> returned one. This closes both normal release and startup-abort paths
> without changing the publication or callback locking protocol.
> 
> Also require a configured node before admitting a new live slot in
> o2hb_check_slot(). The early live-bitmap check is not held through
> admission: the last live slot in another region can be removed in
> between. Without a node, admission can then queue an UP event with
> a NULL argument and hit the event helper's BUG_ON. Existing live
> slots can still leave and generate NULL-node DOWN events.
> 
> A controlled probe-instrumented test reproduced this while stopping
> one of two regions after removing the peer from configfs. Its KASAN
> report includes:
> 
>   BUG: KASAN: slab-use-after-free in __list_del_entry_valid_or_report+0x1e0/0x210
>   Read of size 8 at addr ffff888106a4ac60 by task o2hb-pmbd0058_b/497
>   Call Trace:
>    <TASK>
>    dump_stack_lvl+0x93/0xd0
>    print_report+0xce/0x630
>    kasan_report+0xe0/0x110
>    __list_del_entry_valid_or_report+0x1e0/0x210
>    o2hb_do_disk_heartbeat+0x1591/0x2c50
>    o2hb_thread+0x1ed/0xe70
>    kthread+0x351/0x460
>    ret_from_fork+0x659/0x940
>    ret_from_fork_asm+0x1a/0x30
>    </TASK>
>   Allocated by task 491:
>    kasan_save_stack+0x33/0x60
>    kasan_save_track+0x14/0x30
>    __kasan_kmalloc+0xaa/0xb0
>    __kmalloc_noprof+0x2de/0x780
>    o2hb_region_dev_store+0x7c2/0x1b60
>    configfs_write_iter+0x2f9/0x4f0
>    vfs_write+0x639/0x1010
>    ksys_write+0x111/0x200
>    do_syscall_64+0x114/0x620
>    entry_SYSCALL_64_after_hwframe+0x77/0x7f
>   Freed by task 491:
>    kasan_save_stack+0x33/0x60
>    kasan_save_track+0x14/0x30
>    kasan_save_free_info+0x3b/0x60
>    __kasan_slab_free+0x5f/0x80
>    kfree+0x308/0x580
>    o2hb_unmap_slot_data+0x1db/0x330
>    o2hb_region_release+0x14b/0x4f0
>    config_item_cleanup+0x14b/0x230
>    config_item_put+0x79/0x90
>    configfs_rmdir+0x58a/0x910
>    vfs_rmdir+0x2e8/0x820
>    filename_rmdir+0x3b1/0x520
>    __x64_sys_rmdir+0x4b/0x70
>    do_syscall_64+0x114/0x620
>    entry_SYSCALL_64_after_hwframe+0x77/0x7f
> 
> Fixes: a7f6a5fb4bde ("[PATCH] OCFS2: The Second Oracle Cluster Filesystem")
> Assisted-by: LLM
> Signed-off-by: Cen Zhang <zzzccc427@gmail.com>

Looks fine.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
> Changes in v2:
> - Require a configured node before admitting a live slot in
>   o2hb_check_slot().
> 
> Link to v1: https://lore.kernel.org/r/pm-ocfs2-objects-candidate-0058-v1-177573785904d0ea43c7@gmail.com
> 
>  fs/ocfs2/cluster/heartbeat.c | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
> index 1c3def99bb0765deb828ad6415fde31ed9316002..3f3f6fc6b1316e7c996681fc50fde84d183d117d 100644
> --- a/fs/ocfs2/cluster/heartbeat.c
> +++ b/fs/ocfs2/cluster/heartbeat.c
> @@ -880,8 +880,11 @@ static void o2hb_shutdown_slot(struct o2hb_disk_slot *slot)
>  	int queued = 0;
>  
>  	node = o2nm_get_node_by_num(slot->ds_node_num);
> -	if (!node)
> -		return;
> +	/*
> +	 * The node may have been removed from the node table while this
> +	 * region's slot is still linked.  The list member must still be
> +	 * removed before the region releases its slot array.
> +	 */
>  
>  	spin_lock(&o2hb_live_lock);
>  	if (!list_empty(&slot->ds_live_item)) {
> @@ -903,7 +906,8 @@ static void o2hb_shutdown_slot(struct o2hb_disk_slot *slot)
>  	if (queued)
>  		o2hb_run_event_list(&event);
>  
> -	o2nm_node_put(node);
> +	if (node)
> +		o2nm_node_put(node);
>  }
>  
>  static void o2hb_set_quorum_device(struct o2hb_region *reg)
> @@ -1038,7 +1042,7 @@ static int o2hb_check_slot(struct o2hb_region *reg,
>  fire_callbacks:
>  	/* dead nodes only come to life after some number of
>  	 * changes at any time during their dead time */
> -	if (list_empty(&slot->ds_live_item) &&
> +	if (node && list_empty(&slot->ds_live_item) &&
>  	    slot->ds_changed_samples >= O2HB_LIVE_THRESHOLD) {
>  		mlog(ML_HEARTBEAT, "Node %d (id 0x%llx) joined my region\n",
>  		     slot->ds_node_num, (long long)slot->ds_last_generation);

