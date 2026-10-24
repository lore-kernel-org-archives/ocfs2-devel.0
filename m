Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.118
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792855681;
	b=cuooPFUHjrxCtAmjKQLxqrJ4U9njOFthhzDZAlV6ZGtE5JtvX1ftSV6DX2w9CKrqMBjf
	 nDhWOTF2nm3+VumLgIlLHL8cyqZedKtuYh5pW4Nc/9iPzKaYkMLmAXnw2I8GHoNlauOHc
	 oGHRTL0m+/497RQTvTXqTaS4+olVINTgCgLy0Ix5/OauOnlhlGMdjxufWVtyPJcwxccHE
	 MCmMyZZP5Nk6zf0bQLtcHuBHp6Hd0mvJJbkILwulsc/g2eVuSymA5nSGRVnEGFESKUOZ4
	 e9eNF5/9EJU2r6Gl9iyl9qkRfYwioNypKsQPIIW2Dv7QmYGBe7IL8UUUWONV/SevKag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792855681;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=uKJ4KOECymSbQFCzAxwhODQQk3xEPDqheddn974Jz9Y=;
	b=Qh9oDVi19s+54G7nNxMgEg6zGXNPh43yvES+B9rTE+xVdVILG5cHBtmd54cyFFZEy6rv
	 l4jnRtcCFR6jSw+8w4ZRaIW8CIUj4ZHr755xA3kzLfDy/wDIv3Dfp0s0P6I3WsSNBIsta
	 jZqTy26HbuE61B5CSGwW3yJHGhu4F7blEfaRHfdBVdaDSE1iWnfiDlk1artMp/1LboUxK
	 DD2gaSJp3povUFS3LfoAu+RmswEsL0DUZYXbQDCvP1uTnTK33/eT8zm/KNaCtnjMYOg/T
	 B2L2bFJfviJ0ELNwL9M63fzp6azsCgDbuUyZx1LR5LXfj63Hog1hd/0+dAxMjx5XYtA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=njDF0ZwQ;
	arc=none smtp.remote-ip=115.124.30.118
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80B25606A324
	for <ocfs2-devel@lists.linux.dev>; Sat, 24 Oct 2026 15:28:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 80B25606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=njDF0ZwQ
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1792855677; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=uKJ4KOECymSbQFCzAxwhODQQk3xEPDqheddn974Jz9Y=;
	b=njDF0ZwQRYn6yhwb3q20cv3MT2bWDrg1DZQ4sCB7NCu+T/LyDUxXC9F75gHhzUYUmCW+ZhONCZUBWmQsO+Z+X9hWMN2YJJxaBbvF0i74mm3tkOf/suAEx36l2F0n8r2hAxYmNal7r3pTKtDACxam6pHnEn93APWf1M65h3+UmQI=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R371e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0XDOTpQI_1792855675;
Received: from 30.251.227.55(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XDOTpQI_1792855675 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 24 Oct 2026 23:27:56 +0800
Message-ID: <5b2e0676-da77-49b6-8015-8613d4fcd6cd@linux.alibaba.com>
Date: Sat, 24 Oct 2026 23:27:54 +0800
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
Subject: Re: [PATCH v3] ocfs2/heartbeat: serialize concurrent writes to a
 region's dev attribute
To: Eklavya Singh <eklavyasingh2106@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 Heming Zhao <heming.zhao@suse.com>,
 Deepanshu Kartikey <kartikey406@gmail.com>, Cen Zhang <zzzccc427@gmail.com>,
 ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 syzbot+5d4e96acd0febccb5e87@syzkaller.appspotmail.com, stable@vger.kernel.org
References: <20261019072936.2279-1-eklavyasingh2106@gmail.com>
 <20261020212339.46591-1-eklavyasingh2106@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20261020212339.46591-1-eklavyasingh2106@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/21/26 5:23 AM, Eklavya Singh wrote:
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
> takes the mutex in a small wrapper rather than with guard(). The mutex
> is dropped while dev_store() waits for the heartbeat to become steady,
> which takes seconds, so a read of dev doesn't stall behind a start.
> hr_bdev_file is already set at that point, so other writers still get
> -EINVAL, and the cleanup after the wait retakes the mutex.
> 
> With the patch the same test ran for 10 minutes with lockdep on and
> nothing was reported. So did a second one, with a working loop device,
> that interrupts starts during the wait while other threads read and
> write the attributes.
> 
> Fixes: a7f6a5fb4bde ("[PATCH] OCFS2: The Second Oracle Cluster Filesystem")
> Reported-by: syzbot+5d4e96acd0febccb5e87@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=5d4e96acd0febccb5e87
> Cc: stable@vger.kernel.org
> Signed-off-by: Eklavya Singh <eklavyasingh2106@gmail.com>

Looks fine.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
> Changes in v3:
> - rebase onto linux-next
> - drop hr_dev_mutex while waiting for the heartbeat to become steady,
>   so a read of dev that races a start no longer blocks (Joseph)
> - name the four attributes in the hr_dev_mutex comment and assert the
>   mutex is held in __o2hb_region_dev_store() (Joseph)
> 
> Changes in v2:
> - take the mutex in a wrapper around dev_store() instead of with
>   guard(), since dev_store() uses goto for its cleanup
> 
> Deepanshu Kartikey [1] and Cen Zhang [2] have posted patches for the
> same race, and they conflict with this one. This version also takes
> the mutex in dev_show(), which otherwise can read hr_bdev_file while a
> failed start is dropping it.
> 
> [1] https://lore.kernel.org/all/20261020085100.8819-1-kartikey406@gmail.com/
> [2] https://lore.kernel.org/all/pm-ocfs2-objects-candidate-0077-v7-34980443ec254b2a1ffc@gmail.com/
> 
> v2: https://lore.kernel.org/all/20261019072936.2279-1-eklavyasingh2106@gmail.com/
> v1: https://lore.kernel.org/all/20261018163121.128911-1-eklavyasingh2106@gmail.com/
> 
>  fs/ocfs2/cluster/heartbeat.c | 40 ++++++++++++++++++++++++++++++------
>  1 file changed, 34 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
> index b45adc3..7a18e71 100644
> --- a/fs/ocfs2/cluster/heartbeat.c
> +++ b/fs/ocfs2/cluster/heartbeat.c
> @@ -269,6 +269,8 @@ struct o2hb_region {
>  	struct list_head	hr_handler_list;
>  	/* Serializes timeout arming against failed-start and teardown. */
>  	struct mutex		hr_arming_mutex;
> +	/* Serializes the dev, block_bytes, start_block and blocks attributes. */
> +	struct mutex		hr_dev_mutex;
>  	bool			hr_stopping;
>  
>  	/* last hb status, 0 for success, other value for error. */
> @@ -1681,6 +1683,7 @@ static ssize_t o2hb_region_block_bytes_store(struct config_item *item,
>  	unsigned long block_bytes;
>  	unsigned int block_bits;
>  
> +	guard(mutex)(&reg->hr_dev_mutex);
>  	if (reg->hr_bdev_file)
>  		return -EINVAL;
>  
> @@ -1710,6 +1713,7 @@ static ssize_t o2hb_region_start_block_store(struct config_item *item,
>  	char *p = (char *)page;
>  	ssize_t ret;
>  
> +	guard(mutex)(&reg->hr_dev_mutex);
>  	if (reg->hr_bdev_file)
>  		return -EINVAL;
>  
> @@ -1736,6 +1740,7 @@ static ssize_t o2hb_region_blocks_store(struct config_item *item,
>  	char *p = (char *)page;
>  	int ret;
>  
> +	guard(mutex)(&reg->hr_dev_mutex);
>  	if (reg->hr_bdev_file)
>  		return -EINVAL;
>  
> @@ -1753,10 +1758,12 @@ static ssize_t o2hb_region_blocks_store(struct config_item *item,
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
> @@ -1872,11 +1879,9 @@ out:
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
>  	struct task_struct *hb_task;
>  	long fd;
>  	int sectsize;
> @@ -1884,6 +1889,8 @@ static ssize_t o2hb_region_dev_store(struct config_item *item,
>  	ssize_t ret = -EINVAL;
>  	int live_threshold;
>  
> +	lockdep_assert_held(&reg->hr_dev_mutex);
> +
>  	if (reg->hr_bdev_file)
>  		return -EINVAL;
>  
> @@ -1987,9 +1994,15 @@ static ssize_t o2hb_region_dev_store(struct config_item *item,
>  
>  	wake_up_process(hb_task);
>  
> +	/*
> +	 * Don't hold hr_dev_mutex across the wait, which can take seconds.
> +	 * hr_bdev_file is already set, so other writers still get -EINVAL.
> +	 */
> +	mutex_unlock(&reg->hr_dev_mutex);
>  	ret = wait_event_interruptible(o2hb_steady_queue,
>  				atomic_read(&reg->hr_steady_iterations) == 0 ||
>  				reg->hr_node_deleted);
> +	mutex_lock(&reg->hr_dev_mutex);
>  	if (ret) {
>  		atomic_set(&reg->hr_steady_iterations, 0);
>  		reg->hr_aborted_start = 1;
> @@ -2041,6 +2054,20 @@ out:
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
>  static ssize_t o2hb_region_pid_show(struct config_item *item, char *page)
>  {
>  	struct o2hb_region *reg = to_o2hb_region(item);
> @@ -2143,6 +2170,7 @@ static struct config_item *o2hb_heartbeat_group_make_item(struct config_group *g
>  
>  	INIT_LIST_HEAD(&reg->hr_all_item);
>  	mutex_init(&reg->hr_arming_mutex);
> +	mutex_init(&reg->hr_dev_mutex);
>  	reg->hr_stopping = true;
>  	INIT_DELAYED_WORK(&reg->hr_write_timeout_work, o2hb_write_timeout);
>  	INIT_DELAYED_WORK(&reg->hr_nego_timeout_work, o2hb_nego_timeout);

