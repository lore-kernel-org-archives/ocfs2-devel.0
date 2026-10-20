Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.110
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792467102;
	b=1hcE9v7sKN1vl/Cyd6iueYsd3gWcg8l55IZF/eaaD/RhUa1NuFEVWNyvIzQVvPbO0iJi
	 +squ5vbza7lteOQT6kK/uQW7ViP/U+ghoIIfOMO9lWbhufq5zEvcZRyVYYavS2UF1339n
	 xQayZLVagPRsmhyKC1sYXgHaCrBFAyLvvozbQ4xWRYemnNnU292dZj6Nu2Vio5+jg5hR/
	 0P3KVcPS/UQ+K5aQIUcCG9MUCV6vovZgQvzihmmbsoKG+aIFqiGng5hM5Z4OMuXy0MWxr
	 ohlkdQeUqLCw2GBs5ZlZ7H3xfVsydN+SsXEcIGgSTpNq1LCkVv+/YVsg/oTNt7HoZgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792467102;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=1pMnW+z+gnolEDK9i8P/Eq0D/nBibiu3P4XvjwqIpzs=;
	b=uiMdp4MyzDJMay0g4Y50mzdTFjfN569GAIFXgQpVuoNNZeD8obAB9+z/ypqegFXl7mZ6
	 /PatG3z+dYCGiuRNWNESC7OQnexS5jfbfN579cFsCf9Ts0Bhcoi0jwkmGREhhcYo1HxMc
	 YLfewAJsmgtAOzUpgCAxE0+1uoEFQgVpHIV4m47d2Mix6Y8zcAHsjurDzIWQwlN+OSORn
	 HBwQTmergvoNbB7+gb8vjoaa89HH+fv4nE9/jLzKaXe/eI46Ka1E7ozx0o188MUWS+6cx
	 nRAXce2v1EhX0E/MJcNVdtk58kE8P7ZsxhibGC4OBFnXJ6I3hyscFrKmh0V1ySIOA6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=eXfivCoj;
	arc=none smtp.remote-ip=115.124.30.110
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B63D9606A320
	for <ocfs2-devel@lists.linux.dev>; Tue, 20 Oct 2026 03:31:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B63D9606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=eXfivCoj
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1792467098; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=1pMnW+z+gnolEDK9i8P/Eq0D/nBibiu3P4XvjwqIpzs=;
	b=eXfivCoj6alcsMss2B9RKh4IRf/h/P1mnXAf/qMjbhrSJxP5FRdIkMXP2Lno4sHOxk+1yePVlVQrynfJNENQBVm6uXa7DmKvjkXGXBVjDwS9trJxdDTlOIPhE8KYZ3e3BiFpiCoL1kPf6iMP6klDw2fo/N8qH5N8RZoj3AEIHwY=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0XDBTS2G_1792467096;
Received: from 30.221.145.25(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XDBTS2G_1792467096 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 20 Oct 2026 11:31:37 +0800
Message-ID: <12688893-dc59-4234-9faf-14c257396c93@linux.alibaba.com>
Date: Tue, 20 Oct 2026 11:31:36 +0800
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
Subject: Re: [PATCH] ocfs2/cluster: Initialize heartbeat regions before
 publishing them
To: Cen Zhang <zzzccc427@gmail.com>, akpm@linux-foundation.org
Cc: mark@fasheh.com, jlbec@evilplan.org, heming.zhao@suse.com,
 ericterminal@gmail.com, christophe.jaillet@wanadoo.fr, kees@kernel.org,
 kmehltretter@gmail.com, ocfs2-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org,
 baijiaju1990@gmail.com, jjzuming@gmail.com
References: <pm-ocfs2-objects-candidate-0079-v5-f931a29339cadc0a2a70@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <pm-ocfs2-objects-candidate-0079-v5-f931a29339cadc0a2a70@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/16/26 12:58 AM, Cen Zhang wrote:
> A region on o2hb_all_regions must have an initialized config item and
> name. o2hb_heartbeat_group_make_item() currently links the zeroed region
> under o2hb_live_lock, drops the lock, and only then initializes hr_item.
> The lock therefore protects the list without protecting initialization
> from readers of the published item.
> 
> With global heartbeat enabled, a DLM_QUERY_REGION from the current
> joining node can pass the existing-domain and protocol checks while a
> configfs mkdir creates another region. The DLM locks are not taken by
> the constructor, and the network worker does not take the configfs
> subsystem mutex. The following ordering is possible:
> 
>   Configfs mkdir                     O2net receive worker
>   --------------                     --------------------
>   Allocate reg
>   Lock o2hb_live_lock
>   Link into o2hb_all_regions
>   Unlock o2hb_live_lock
>                                      dlm_query_region_handler()
>                                        dlm_match_regions()
>                                          o2hb_get_all_regions()
>                                            Lock o2hb_live_lock
>                                            Copy 32 bytes from NULL name
>                                            Unlock o2hb_live_lock
>   config_item_init_type_name()
> 
> The query thus dereferences NULL. Initialize hr_item before linking the
> region so the existing list lock also orders name initialization before
> any reader. Reject a failed name allocation, since the initialization
> helper does not propagate that error.
> 
> Use config_item_put() on initialized constructor failures to release the
> name and respect references retained by o2hb_region_pin(). Initialize
> the list heads, mutex and delayed works needed by o2hb_region_release()
> before any such put, and leave the list node self-linked after rollback.
> Keep the existing handler drain before removing a failed published item.
> 
> KASAN report as below:
> 
>     ==================================================================
>     BUG: KASAN: null-ptr-deref in o2hb_get_all_regions+0xbb/0x1f0
>     Read of size 32 at addr 0000000000000000 by task kworker/u16:1/14
> 
>     CPU: 2 UID: 0 PID: 14 Comm: kworker/u16:1 Not tainted 7.3.0-rc4-next-20260921-pmb-ocfs2-functional-v1+ #1 PREEMPT(lazy)
>     Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
>     Workqueue: o2net o2net_rx_until_empty
>     Call Trace:
>      <TASK>
>      dump_stack_lvl+0x93/0xd0
>      kasan_report+0xe0/0x110
>      ? o2hb_get_all_regions+0xbb/0x1f0
>      kasan_check_range+0x105/0x1b0
>      __asan_memcpy+0x23/0x60
>      o2hb_get_all_regions+0xbb/0x1f0
>      dlm_query_region_handler+0x4c2/0xc20
>      ? __pfx_dlm_query_region_handler+0x10/0x10
>      ? srso_alias_return_thunk+0x5/0xfbef5
>      ? srso_alias_return_thunk+0x5/0xfbef5
>      ? trace_hardirqs_on+0x18/0x160
>      ? srso_alias_return_thunk+0x5/0xfbef5
>      ? kvm_clock_get_cycles+0x31/0x60
>      ? srso_alias_return_thunk+0x5/0xfbef5
>      ? __pfx_dlm_query_region_handler+0x10/0x10
>      o2net_rx_until_empty+0x1a50/0x3200
>      ? reacquire_held_locks+0xdd/0x200
>      ? __pfx_o2net_rx_until_empty+0x10/0x10
>      ? lock_acquire+0x190/0x300
>      ? process_one_work+0x935/0x1b40
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
>     ==================================================================
> 
> Fixes: 536f0741f324 ("ocfs2/cluster: Track number of global heartbeat regions")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Cen Zhang <zzzccc427@gmail.com>

Looks fine.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> Assisted-by: LLM
> 
> ---
> diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
> index 8e6ead433228..9a4703bdc4e8 100644
> --- a/fs/ocfs2/cluster/heartbeat.c
> +++ b/fs/ocfs2/cluster/heartbeat.c
> @@ -2140,6 +2140,18 @@ static struct config_item *o2hb_heartbeat_group_make_item(struct config_group *g
>  	}
>  	reg->hr_node_num = O2NM_MAX_NODES;
>  
> +	INIT_LIST_HEAD(&reg->hr_all_item);
> +	mutex_init(&reg->hr_arming_mutex);
> +	reg->hr_stopping = true;
> +	INIT_DELAYED_WORK(&reg->hr_write_timeout_work, o2hb_write_timeout);
> +	INIT_DELAYED_WORK(&reg->hr_nego_timeout_work, o2hb_nego_timeout);
> +	INIT_LIST_HEAD(&reg->hr_handler_list);
> +	config_item_init_type_name(&reg->hr_item, name, &o2hb_region_type);
> +	if (!config_item_name(&reg->hr_item)) {
> +		ret = -ENOMEM;
> +		goto put_item;
> +	}
> +
>  	spin_lock(&o2hb_live_lock);
>  	reg->hr_region_num = 0;
>  	if (o2hb_global_heartbeat_active()) {
> @@ -2148,26 +2160,19 @@ static struct config_item *o2hb_heartbeat_group_make_item(struct config_group *g
>  		if (reg->hr_region_num >= O2NM_MAX_REGIONS) {
>  			spin_unlock(&o2hb_live_lock);
>  			ret = -EFBIG;
> -			goto free;
> +			goto put_item;
>  		}
>  		set_bit(reg->hr_region_num, o2hb_region_bitmap);
>  	}
>  	list_add_tail(&reg->hr_all_item, &o2hb_all_regions);
>  	spin_unlock(&o2hb_live_lock);
>  
> -	config_item_init_type_name(&reg->hr_item, name, &o2hb_region_type);
> -
>  	/* this is the same way to generate msg key as dlm, for local heartbeat,
>  	 * name is also the same, so make initial crc value different to avoid
>  	 * message key conflict.
>  	 */
>  	reg->hr_key = crc32_le(reg->hr_region_num + O2NM_MAX_REGIONS,
>  		name, strlen(name));
> -	mutex_init(&reg->hr_arming_mutex);
> -	reg->hr_stopping = true;
> -	INIT_DELAYED_WORK(&reg->hr_write_timeout_work, o2hb_write_timeout);
> -	INIT_DELAYED_WORK(&reg->hr_nego_timeout_work, o2hb_nego_timeout);
> -	INIT_LIST_HEAD(&reg->hr_handler_list);
>  	ret = o2net_register_handler(O2HB_NEGO_TIMEOUT_MSG, reg->hr_key,
>  			sizeof(struct o2hb_nego_msg),
>  			o2hb_nego_timeout_handler,
> @@ -2190,10 +2195,13 @@ unregister_handler:
>  	o2net_unregister_and_flush_handler_list(&reg->hr_handler_list);
>  remove_item:
>  	spin_lock(&o2hb_live_lock);
> -	list_del(&reg->hr_all_item);
> +	list_del_init(&reg->hr_all_item);
>  	if (o2hb_global_heartbeat_active())
>  		clear_bit(reg->hr_region_num, o2hb_region_bitmap);
>  	spin_unlock(&o2hb_live_lock);
> +put_item:
> +	config_item_put(&reg->hr_item);
> +	return ERR_PTR(ret);
>  free:
>  	kfree(reg);
>  	return ERR_PTR(ret);

