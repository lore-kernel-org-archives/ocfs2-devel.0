Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.118
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792485136;
	b=30W4lcIWbSj6mRiyeIyifFwI4Ec81sf9nEHvxPkD4ga6KW7aP+/KTx5kc+RVBW6yFMIb
	 GuD6sEd9uECAFtYcSpvno1GZcxKjLQcC5vFzwRiXYRNM6v2xQJmPNTEUaj/oFOnd8ltv1
	 yOmAu1nPBTo5nMtIrhh1O5UNvZdZoptsDTilGxbAaQeebSTw1DHNvKJyXhbuO7Dbl32d7
	 nA6yjRWLP8XUmWOrnXf51Elj4LDC76RaeZQwluxCDK+cS11J0gcgK/EDvpmKA87zU/mff
	 bAisky+wGw8lGP3Jj8ytCm6vLPY+hpYynXWBhdodZaakVmYooz+5xuNKlhgkRg39kjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792485136;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=WYwqUV0a09kbpatRxoseIFVv0mewCx3MSBetA+PMlF4=;
	b=MdYNAPzXSZpJ5gmFPppN+Rp5HysUzQ/+qUM5hsH69iKL6j8LPrDFt5EvaK6lEv1y1uUp
	 ossBsI9USILwy7kUcrGPqm+0103LGDjNRZyDBI1kDfX9yVZ5ZOedwBzXCeyMGTHmhXTfK
	 P/DPKpQ8/ppqoLpXnJOYe358yJ+mepOKYTvV1jTMZWn19hCXSvbfKVF7cDcAtt3RcaY13
	 4zoY5vEfpo6+7CHKplY7xpfbHVcbgYk326n/wjgkYyO3P/5fHVAr8kJ6z4QIXQRUim01a
	 hjJXKMmWh7Y/AeGKYrH66aZgVErm96UKn3Gewp+QmoKgtNY3qmTXapXRbcFR7dd+6qg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=TXdb5k1g;
	arc=none smtp.remote-ip=115.124.30.118
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C659F606A31B
	for <ocfs2-devel@lists.linux.dev>; Tue, 20 Oct 2026 08:32:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C659F606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=TXdb5k1g
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1792485132; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=WYwqUV0a09kbpatRxoseIFVv0mewCx3MSBetA+PMlF4=;
	b=TXdb5k1gEb105YVtipP1+Yer3QcgbQgdv05emH8KM5SAvBIEd1douqj0sQ/QqFu6+x0JtfQavdTWImN4UGrqBOD/1HB2LkNnKqqcA/BRr6d5GmJZfEysz+cY82kw/SM3DJGlHCHDgvl3nqrS0VpJJy3hEhzgSq1XijurKuE7NI4=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R881e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0XDCLk5f_1792485131;
Received: from 30.221.145.25(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XDCLk5f_1792485131 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 20 Oct 2026 16:32:11 +0800
Message-ID: <27f03c8f-c41d-437a-aca7-e6aecbed45f8@linux.alibaba.com>
Date: Tue, 20 Oct 2026 16:32:10 +0800
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
Subject: Re: [PATCH v2] ocfs2/heartbeat: serialize concurrent writes to a
 region's dev attribute
To: Eklavya Singh <eklavyasingh2106@gmail.com>
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 Heming Zhao <heming.zhao@suse.com>, Andrew Morton
 <akpm@linux-foundation.org>, ocfs2-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org,
 syzbot+5d4e96acd0febccb5e87@syzkaller.appspotmail.com, stable@vger.kernel.org
References: <20261018163121.128911-1-eklavyasingh2106@gmail.com>
 <20261019072936.2279-1-eklavyasingh2106@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20261019072936.2279-1-eklavyasingh2106@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/19/26 3:29 PM, Eklavya Singh wrote:
> o2hb_region_dev_store() checks reg->hr_bdev_file to see if the region
> is already started, but nothing stops two writers from doing that at
> the same time. configfs only serializes writes through the same open
> file, so two processes that each open the dev attribute can both get
> past the check:
> 
>   A: hr_bdev_file is NULL, opens file A, sets hr_bdev_file = A
>   B: hr_bdev_file is NULL, opens file B, sets hr_bdev_file = B
>   A: start fails, fput(hr_bdev_file) drops B, sets it to NULL
>   B: start fails, fput(NULL)
> 
> Both calls also use the same hr_slots, hr_slot_data and hr_tmp_block,
> so the error paths can free the slot data twice.
> 
> syzbot hit the fput(NULL) with an unbound loop device, where every
> start fails with -EIO. With four threads doing the same thing on a
> KASAN kernel I get both crashes within a second:
> 
>   BUG: KASAN: double-free in o2hb_unmap_slot_data+0x14d/0x2f0
>   BUG: kernel NULL pointer dereference, address: 0000000000000158
> 
> Add a mutex to the region and hold it in dev_store(), in the
> block_bytes, start_block and blocks stores, and in dev_show(), since
> they all look at hr_bdev_file. dev_store() cleans up with goto, so it
> takes the mutex in a small wrapper rather than with guard(). It sleeps
> with the mutex held while it waits for the heartbeat thread. That is
> fine because neither the thread nor the teardown paths take it.
> 
> With the patch the same test ran for 10 minutes with lockdep on and
> nothing was reported.
> 
> Fixes: a7f6a5fb4bde ("[PATCH] OCFS2: The Second Oracle Cluster Filesystem")
> Reported-by: syzbot+5d4e96acd0febccb5e87@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=5d4e96acd0febccb5e87
> Cc: stable@vger.kernel.org
> Signed-off-by: Eklavya Singh <eklavyasingh2106@gmail.com>
> ---
> v2: take the mutex in a wrapper around dev_store() instead of with
> guard(), since dev_store() uses goto for its cleanup. No other changes.
> 
> v1: https://lore.kernel.org/all/20261018163121.128911-1-eklavyasingh2106@gmail.com/
> 
>  fs/ocfs2/cluster/heartbeat.c | 32 ++++++++++++++++++++++++++------
>  1 file changed, 26 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
> index 1c3def99bb0..003c398366e 100644
> --- a/fs/ocfs2/cluster/heartbeat.c
> +++ b/fs/ocfs2/cluster/heartbeat.c
> @@ -269,6 +269,8 @@ struct o2hb_region {
>  	struct list_head	hr_handler_list;
>  	/* Serializes timeout arming against failed-start and teardown. */
>  	struct mutex		hr_arming_mutex;
> +	/* Serializes the region's configfs attributes against dev_store(). */

Naming the covered 4 region's attributes would be clearer.

> +	struct mutex		hr_dev_mutex;
>  	bool			hr_stopping;
>  
>  	/* last hb status, 0 for success, other value for error. */
> @@ -1676,6 +1678,7 @@ static ssize_t o2hb_region_block_bytes_store(struct config_item *item,
>  	unsigned long block_bytes;
>  	unsigned int block_bits;
>  
> +	guard(mutex)(&reg->hr_dev_mutex);
>  	if (reg->hr_bdev_file)
>  		return -EINVAL;
>  
> @@ -1705,6 +1708,7 @@ static ssize_t o2hb_region_start_block_store(struct config_item *item,
>  	char *p = (char *)page;
>  	ssize_t ret;
>  
> +	guard(mutex)(&reg->hr_dev_mutex);
>  	if (reg->hr_bdev_file)
>  		return -EINVAL;
>  
> @@ -1731,6 +1735,7 @@ static ssize_t o2hb_region_blocks_store(struct config_item *item,
>  	char *p = (char *)page;
>  	int ret;
>  
> +	guard(mutex)(&reg->hr_dev_mutex);
>  	if (reg->hr_bdev_file)
>  		return -EINVAL;
>  
> @@ -1748,10 +1753,12 @@ static ssize_t o2hb_region_blocks_store(struct config_item *item,
>  
>  static ssize_t o2hb_region_dev_show(struct config_item *item, char *page)
>  {
> +	struct o2hb_region *reg = to_o2hb_region(item);
>  	unsigned int ret = 0;
>  
> -	if (to_o2hb_region(item)->hr_bdev_file)
> -		ret = sprintf(page, "%pg\n", reg_bdev(to_o2hb_region(item)));
> +	guard(mutex)(&reg->hr_dev_mutex);
> +	if (reg->hr_bdev_file)
> +		ret = sprintf(page, "%pg\n", reg_bdev(reg));
>  
>  	return ret;
>  }
> @@ -1867,11 +1874,9 @@ static int o2hb_populate_slot_data(struct o2hb_region *reg)
>   * this is acting as commit; we set up all of hr_bdev_file and hr_task or
>   * nothing
>   */
> -static ssize_t o2hb_region_dev_store(struct config_item *item,
> -				     const char *page,
> -				     size_t count)
> +static ssize_t __o2hb_region_dev_store(struct o2hb_region *reg,
> +				       const char *page, size_t count)
>  {
> -	struct o2hb_region *reg = to_o2hb_region(item);

Would it be worth recording that hr_dev_mutex must be held now?

>  	struct task_struct *hb_task;
>  	long fd;
>  	int sectsize;
> @@ -2032,6 +2037,20 @@ static ssize_t o2hb_region_dev_store(struct config_item *item,
>  	return ret;
>  }
>  
> +static ssize_t o2hb_region_dev_store(struct config_item *item,
> +				     const char *page,
> +				     size_t count)
> +{
> +	struct o2hb_region *reg = to_o2hb_region(item);
> +	ssize_t ret;
> +
> +	mutex_lock(&reg->hr_dev_mutex);
> +	ret = __o2hb_region_dev_store(reg, page, count);
> +	mutex_unlock(&reg->hr_dev_mutex);
> +
> +	return ret;
> +}
> +
The wrapper keeps hr_dev_mutex held across the whole start, including
the wait for the thread:

        ret = wait_event_interruptible(o2hb_steady_queue,
                                atomic_read(&reg->hr_steady_iterations) == 0 ||
                                reg->hr_node_deleted);

hr_timeout_ms is O2HB_REGION_TIMEOUT_MS, 2000, and hr_steady_iterations
starts at O2HB_LIVE_THRESHOLD + 1, or one more doubling again when this
is the only region and global heartbeat is active.  So a read of the dev
attribute that races a start blocks for roughly six seconds, or ten for
that first region, where it used to return at once.

Thanks,
Joseph

>  static ssize_t o2hb_region_pid_show(struct config_item *item, char *page)
>  {
>  	struct o2hb_region *reg = to_o2hb_region(item);
> @@ -2156,6 +2175,7 @@ static struct config_item *o2hb_heartbeat_group_make_item(struct config_group *g
>  	reg->hr_key = crc32_le(reg->hr_region_num + O2NM_MAX_REGIONS,
>  		name, strlen(name));
>  	mutex_init(&reg->hr_arming_mutex);
> +	mutex_init(&reg->hr_dev_mutex);
>  	reg->hr_stopping = true;
>  	INIT_DELAYED_WORK(&reg->hr_write_timeout_work, o2hb_write_timeout);
>  	INIT_DELAYED_WORK(&reg->hr_nego_timeout_work, o2hb_nego_timeout);

