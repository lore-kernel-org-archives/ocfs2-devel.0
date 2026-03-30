Received: from out199-8.us.a.mail.aliyun.com (out199-8.us.a.mail.aliyun.com [47.90.199.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF6AE362156
	for <ocfs2-devel@lists.linux.dev>; Mon, 30 Mar 2026 02:14:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=47.90.199.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774836892; cv=none; b=cAV7bQd03jt13XM+XccdHuumFQs/+VILtnnBXI3NfSdRxjsSK8qeyHlPZm0VkKwI/bzCK5UeIl57/Crj1o8NRkaCI8wHnS7tMZw5O7gcb6ZEAJGZuAjTbFaeADCyjzajNev9VfyBu+wlj59TUgFdy/+G2sipP8rDDaVqjG9j2NA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774836892; c=relaxed/simple;
	bh=Y2Z+FnQEs4ee/0ozZUzKStMbo9zTsqlJoymWmkEeA0s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HD11eCijPq947moxTu2s0bLmu1J7TYWO/mEfakpcVz2+VgVWLYVefNysp3xQRZfEy5LX4yLE6e1A8EuXVl450+KRHDILLgCVxBnM5OVzEYmwGbFCVA0HC0o+T0LpIOnQBQoHadn7ID4zCzVX9EmBFhb2RHehm4EZvg1cW+2gz8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=KLJMa2j2; arc=none smtp.client-ip=47.90.199.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="KLJMa2j2"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1774836873; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=vznDA0CKb+u+prh0P5UvL1DKV3xUTRGqaTSd7PX6oo4=;
	b=KLJMa2j2DFLW9c7oSWvUkZoyo7c2PKhJsXbTKKq17pFL144VutMm4bjpg0UfxHlF1L0Qcei/WskiA2IP1iS6dMSc91IwQ3Rmz8SWrke7x78eHugeABOeVZ54xcsIzQhUsKBW3vx7EmyZhQKphF38ZXDMbQr3cd96/dYu68jvY20=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0X.tpIRA_1774836871;
Received: from 30.221.146.6(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X.tpIRA_1774836871 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 30 Mar 2026 10:14:32 +0800
Message-ID: <7a05cf3f-6feb-4606-9d9d-c7b31ecfa10d@linux.alibaba.com>
Date: Mon, 30 Mar 2026 10:14:31 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2/heartbeat: fix slot mapping rollback leaks on error
 paths
To: Yufan Chen <yufan.chen@linux.dev>
Cc: Yufan Chen <ericterminal@gmail.com>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>,
 "ocfs2-devel@lists.linux.dev" <ocfs2-devel@lists.linux.dev>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Heming Zhao <heming.zhao@suse.com>
References: <20260328092339.75306-1-yufan.chen@linux.dev>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260328092339.75306-1-yufan.chen@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 3/28/26 5:23 PM, Yufan Chen wrote:
> From: Yufan Chen <ericterminal@gmail.com>
> 
> o2hb_map_slot_data() allocated hr_tmp_block, hr_slots, hr_slot_data, and pages in stages but returned directly on allocation failures without unwinding previously allocated resources. Under repeated allocation failures this could leak memory and increase pressure toward OOM.
> 
> o2hb_region_dev_store() also failed to roll back slot mapping resources when setup aborted, leaving stale allocations around retry attempts.
> 
> Introduce o2hb_unmap_slot_data() as a single reverse-order cleanup helper, switch o2hb_map_slot_data() to a centralized goto-based error exit, and call the same rollback path from o2hb_region_dev_store() after stopping a possibly started heartbeat thread. This ensures failed setup fully releases resources and remains safely retryable.
> 

The commit log is too long for a single line.
Please use scripts/checkpatch.pl to check it.

> Signed-off-by: Yufan Chen <ericterminal@gmail.com>
> ---
>  fs/ocfs2/cluster/heartbeat.c | 64 +++++++++++++++++++++++++-----------
>  1 file changed, 45 insertions(+), 19 deletions(-)
> 
> diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
> index fe1949578..2f82040f4 100644
> --- a/fs/ocfs2/cluster/heartbeat.c
> +++ b/fs/ocfs2/cluster/heartbeat.c
> @@ -1488,18 +1488,10 @@ static struct o2hb_region *to_o2hb_region(struct config_item *item)
>  	return item ? container_of(item, struct o2hb_region, hr_item) : NULL;
>  }
>  
> -/* drop_item only drops its ref after killing the thread, nothing should
> - * be using the region anymore.  this has to clean up any state that
> - * attributes might have built up. */
> -static void o2hb_region_release(struct config_item *item)
> +static void o2hb_unmap_slot_data(struct o2hb_region *reg)
>  {
>  	int i;
>  	struct page *page;
> -	struct o2hb_region *reg = to_o2hb_region(item);
> -
> -	mlog(ML_HEARTBEAT, "hb region release (%pg)\n", reg_bdev(reg));
> -
> -	kfree(reg->hr_tmp_block);
>  
>  	if (reg->hr_slot_data) {
>  		for (i = 0; i < reg->hr_num_pages; i++) {
> @@ -1508,13 +1500,32 @@ static void o2hb_region_release(struct config_item *item)
>  				__free_page(page);
>  		}
>  		kfree(reg->hr_slot_data);
> +		reg->hr_slot_data = NULL;
>  	}
>  
> +	kfree(reg->hr_slots);
> +	reg->hr_slots = NULL;
> +
> +	kfree(reg->hr_tmp_block);
> +	reg->hr_tmp_block = NULL;
> +	reg->hr_num_pages = 0;

Instead of set reg->hr_num_pages to 0, I'd like to set
reg->hr_slot_data[i] to NULL once freed.

> +}
> +
> +/* drop_item only drops its ref after killing the thread, nothing should
> + * be using the region anymore.  this has to clean up any state that
> + * attributes might have built up.
> + */
> +static void o2hb_region_release(struct config_item *item)
> +{
> +	struct o2hb_region *reg = to_o2hb_region(item);
> +
> +	mlog(ML_HEARTBEAT, "hb region release (%pg)\n", reg_bdev(reg));
> +
> +	o2hb_unmap_slot_data(reg);
> +
>  	if (reg->hr_bdev_file)
>  		fput(reg->hr_bdev_file);
>  
> -	kfree(reg->hr_slots);
> -
>  	debugfs_remove_recursive(reg->hr_debug_dir);
>  	kfree(reg->hr_db_livenodes);
>  	kfree(reg->hr_db_regnum);
> @@ -1667,6 +1678,7 @@ static void o2hb_init_region_params(struct o2hb_region *reg)
>  static int o2hb_map_slot_data(struct o2hb_region *reg)
>  {
>  	int i, j;
> +	int ret = -ENOMEM;
>  	unsigned int last_slot;
>  	unsigned int spp = reg->hr_slots_per_page;
>  	struct page *page;
> @@ -1674,14 +1686,14 @@ static int o2hb_map_slot_data(struct o2hb_region *reg)
>  	struct o2hb_disk_slot *slot;
>  
>  	reg->hr_tmp_block = kmalloc(reg->hr_block_bytes, GFP_KERNEL);
> -	if (reg->hr_tmp_block == NULL)
> -		return -ENOMEM;
> +	if (!reg->hr_tmp_block)
> +		goto out;
>  
>  	reg->hr_slots = kzalloc_objs(struct o2hb_disk_slot, reg->hr_blocks);
> -	if (reg->hr_slots == NULL)
> -		return -ENOMEM;
> +	if (!reg->hr_slots)
> +		goto out;
>  
> -	for(i = 0; i < reg->hr_blocks; i++) {
> +	for (i = 0; i < reg->hr_blocks; i++) {
>  		slot = &reg->hr_slots[i];
>  		slot->ds_node_num = i;
>  		INIT_LIST_HEAD(&slot->ds_live_item);
> @@ -1695,12 +1707,12 @@ static int o2hb_map_slot_data(struct o2hb_region *reg)
>  
>  	reg->hr_slot_data = kzalloc_objs(struct page *, reg->hr_num_pages);
>  	if (!reg->hr_slot_data)
> -		return -ENOMEM;
> +		goto out;
>  
> -	for(i = 0; i < reg->hr_num_pages; i++) {
> +	for (i = 0; i < reg->hr_num_pages; i++) {
>  		page = alloc_page(GFP_KERNEL);
>  		if (!page)
> -			return -ENOMEM;
> +			goto out;
>  
>  		reg->hr_slot_data[i] = page;
>  
> @@ -1720,6 +1732,10 @@ static int o2hb_map_slot_data(struct o2hb_region *reg)
>  	}
>  
>  	return 0;
> +
> +out:
> +	o2hb_unmap_slot_data(reg);
> +	return ret;
>  }
>  
>  /* Read in all the slots available and populate the tracking
> @@ -1903,6 +1919,16 @@ static ssize_t o2hb_region_dev_store(struct config_item *item,
>  
>  out3:

Let's clean the 'out3' to 'out' as well.

Thanks,
Joseph

>  	if (ret < 0) {
> +		spin_lock(&o2hb_live_lock);
> +		hb_task = reg->hr_task;
> +		reg->hr_task = NULL;
> +		spin_unlock(&o2hb_live_lock);
> +
> +		if (hb_task)
> +			kthread_stop(hb_task);
> +
> +		o2hb_unmap_slot_data(reg);
> +
>  		fput(reg->hr_bdev_file);
>  		reg->hr_bdev_file = NULL;
>  	}

