Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98A67363C75
	for <ocfs2-devel@lists.linux.dev>; Tue, 31 Mar 2026 05:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774936035; cv=none; b=h19Sz7cT9qidBUT/yIk99k6anZVC41yMTk4RkjIo8fTz6Yp5Iwm2Rr8ooqJTT+nJCRbZ1qxwQp2K9QnjnMcLKSU/JxaQ7UlPrDT3aS7ePxRqQutYm72i6VgwQlf3FPnCKJOp2s/nTFaxfeFW8bjVtVretrdyEn7x6nDeyrkG2oU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774936035; c=relaxed/simple;
	bh=xWFLJtrqN1MDwRQX1U0IfEKHVs5r0ICDljKCRP1DJWo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cgEiK81maqT5V2eVFC15+Zq738fInT1cg6Ms7VY0mozjOJgJURiQt2m4LOHBATOOwT9nYvsD9poveYNdOFwKDGYDSFf9Xzvve1AtlKl8pX77D+e6Bjdk5YoUjsKXDN6mko4d2X6lGPQmLXKlkyVqxA1zFGbOPXaIn7p8TfUI4NA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=x1u+hfRc; arc=none smtp.client-ip=115.124.30.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="x1u+hfRc"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1774936024; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=R/ePRq8caphgmiKBTPCo95D9shrwBGExxDo+9e1OnYg=;
	b=x1u+hfRcqVwcLHSn1aXq2vbRUo5wWU01kuknCxwOd2m7/eCX8tmEfi4XPjmZBWntF/kV3P+fXuc62Dj06AGr7qb4cUMI7ppMDvDU6ikOcBcSfvXev6FxaUdTg6a3xlyHXLZfpmJhmXAclW4th1Gyqg9I4b3dXV1iI1204o55Wcc=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0X03GF86_1774936023;
Received: from 30.221.145.64(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X03GF86_1774936023 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 31 Mar 2026 13:47:03 +0800
Message-ID: <cc9f091b-bf6c-4681-9050-777543f92fcf@linux.alibaba.com>
Date: Tue, 31 Mar 2026 13:47:02 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ocfs2/heartbeat: fix slot mapping rollback leaks on
 error paths
To: Yufan Chen <yufan.chen@linux.dev>, akpm <akpm@linux-foundation.org>
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 linux-kernel@vger.kernel.org,
 "ocfs2-devel@lists.linux.dev" <ocfs2-devel@lists.linux.dev>,
 Heming Zhao <heming.zhao@suse.com>
References: <20260330153428.19586-1-yufan.chen@linux.dev>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260330153428.19586-1-yufan.chen@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 3/30/26 11:34 PM, Yufan Chen wrote:
> From: Yufan Chen <ericterminal@gmail.com>
> 
> o2hb_map_slot_data() allocates hr_tmp_block, hr_slots,
> hr_slot_data, and pages in stages. If a later allocation fails, the
> current code returns without unwinding the earlier allocations.
> 
> o2hb_region_dev_store() also leaves slot mapping resources behind when
> setup aborts, and it keeps hr_aborted_start/hr_node_deleted set across
> retries. That leaves stale state behind after a failed start.
> 
> Factor the slot cleanup into o2hb_unmap_slot_data(), use it from both
> o2hb_map_slot_data() and o2hb_region_release(), and call it from the
> dev_store() rollback after stopping a started heartbeat thread. While
> freeing pages, clear each hr_slot_data entry as it is released, and
> reset the start state before each new setup attempt.
> 
> This closes the slot mapping leak on allocation/setup failure paths
> and keeps failed setup attempts retryable.
> 
> Signed-off-by: Yufan Chen <ericterminal@gmail.com>

Looks fine.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
>  fs/ocfs2/cluster/heartbeat.c | 83 ++++++++++++++++++++++++------------
>  1 file changed, 56 insertions(+), 27 deletions(-)
> 
> diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
> index fe1949578..d12784aaa 100644
> --- a/fs/ocfs2/cluster/heartbeat.c
> +++ b/fs/ocfs2/cluster/heartbeat.c
> @@ -1488,33 +1488,45 @@ static struct o2hb_region *to_o2hb_region(struct config_item *item)
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
>  			page = reg->hr_slot_data[i];
> -			if (page)
> +			if (page) {
>  				__free_page(page);
> +				reg->hr_slot_data[i] = NULL;
> +			}
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
> @@ -1667,6 +1679,7 @@ static void o2hb_init_region_params(struct o2hb_region *reg)
>  static int o2hb_map_slot_data(struct o2hb_region *reg)
>  {
>  	int i, j;
> +	int ret = -ENOMEM;
>  	unsigned int last_slot;
>  	unsigned int spp = reg->hr_slots_per_page;
>  	struct page *page;
> @@ -1674,14 +1687,14 @@ static int o2hb_map_slot_data(struct o2hb_region *reg)
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
> @@ -1695,12 +1708,12 @@ static int o2hb_map_slot_data(struct o2hb_region *reg)
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
> @@ -1720,6 +1733,10 @@ static int o2hb_map_slot_data(struct o2hb_region *reg)
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
> @@ -1809,9 +1826,11 @@ static ssize_t o2hb_region_dev_store(struct config_item *item,
>  		     "blocksize %u incorrect for device, expected %d",
>  		     reg->hr_block_bytes, sectsize);
>  		ret = -EINVAL;
> -		goto out3;
> +		goto out;
>  	}
>  
> +	reg->hr_aborted_start = 0;
> +	reg->hr_node_deleted = 0;
>  	o2hb_init_region_params(reg);
>  
>  	/* Generation of zero is invalid */
> @@ -1823,13 +1842,13 @@ static ssize_t o2hb_region_dev_store(struct config_item *item,
>  	ret = o2hb_map_slot_data(reg);
>  	if (ret) {
>  		mlog_errno(ret);
> -		goto out3;
> +		goto out;
>  	}
>  
>  	ret = o2hb_populate_slot_data(reg);
>  	if (ret) {
>  		mlog_errno(ret);
> -		goto out3;
> +		goto out;
>  	}
>  
>  	INIT_DELAYED_WORK(&reg->hr_write_timeout_work, o2hb_write_timeout);
> @@ -1860,7 +1879,7 @@ static ssize_t o2hb_region_dev_store(struct config_item *item,
>  	if (IS_ERR(hb_task)) {
>  		ret = PTR_ERR(hb_task);
>  		mlog_errno(ret);
> -		goto out3;
> +		goto out;
>  	}
>  
>  	spin_lock(&o2hb_live_lock);
> @@ -1877,12 +1896,12 @@ static ssize_t o2hb_region_dev_store(struct config_item *item,
>  
>  	if (reg->hr_aborted_start) {
>  		ret = -EIO;
> -		goto out3;
> +		goto out;
>  	}
>  
>  	if (reg->hr_node_deleted) {
>  		ret = -EINVAL;
> -		goto out3;
> +		goto out;
>  	}
>  
>  	/* Ok, we were woken.  Make sure it wasn't by drop_item() */
> @@ -1901,8 +1920,18 @@ static ssize_t o2hb_region_dev_store(struct config_item *item,
>  		printk(KERN_NOTICE "o2hb: Heartbeat started on region %s (%pg)\n",
>  		       config_item_name(&reg->hr_item), reg_bdev(reg));
>  
> -out3:
> +out:
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

