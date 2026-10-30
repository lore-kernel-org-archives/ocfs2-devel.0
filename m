Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.110
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793330832;
	b=eg9PmSLR/1WuI02yBt2MAA69gqLJNHQHGTPGoMLI2N0yk1Cfzl1fB1GFMHSCknobDQ5O
	 j4LN6SDMg2AK5uC3ts6H4qHvnRvfsFLUjm5mhgMMdzocEBTQCmMQwDtDd7xVfm+BRrOR5
	 vlJXldZnThuzhxnqZm8Z0tRXYodr9FP2IAyeoJ5Sg2leHz60KvgzxdsFYmUOiIDVBbtDz
	 EU0JxpeaeInKo2Ry95j06FmLSdscVlMlKhuFMDMINW3jdgM5iok4Peu5vae/rIYKdRW8h
	 +Xo2OouVX9N4e3/pVx9SF7qCCCYBW5uFyXVjwawLQ0E941zjJTO1xVek/4JUt/6dxkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793330832;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=1rPszPa95omO2WaIpFWNNT2Z1Vf6DPM6xcYumF3O7YY=;
	b=t4sixebzlYRO7KoGP1v2M7OxtrwWHLot+NfV5Z2YUUHANLXGUl6pNNIDOnBxnD92RmV4
	 HVp3RWfTmVfyV1/lrkoxCk131gfQcWfJnEJTw/rc/IapvQpIY25WQOXczUfQzDy8Z/CeX
	 AZ6hLDq+t/H1NB4NosEjuM9dhafpCe09ZYMOvqMgZXGt8CBBfPb9ZV3X8wFYYJqLeWK1J
	 /EGOYfU+Qx95Qd7GoioknBH9N58cbXpGl85qpDadQgDQ58GdmtiOYIj3dhAZA9u1Txt2y
	 kK8wCrgsA2C3+txTO5OZpYXzskvGjofdB7Rq+oyXXmxy7mRw7Rrzos+QKI321mqpxAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b="ZoErqQp/";
	arc=none smtp.remote-ip=115.124.30.110
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C38B606A31C
	for <ocfs2-devel@lists.linux.dev>; Fri, 30 Oct 2026 03:27:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7C38B606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=ZoErqQp/
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793330828; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=1rPszPa95omO2WaIpFWNNT2Z1Vf6DPM6xcYumF3O7YY=;
	b=ZoErqQp/9EAano3BCbP5r3KeRQipLetUE9A0oIPNmiJHfLBdaypTrzKeqL/jHy2c4hd6tVEcuqJW0InuEgXQZfNuMCOu3JjqMbKTHOUZlmfj407v3mvDYjIPXHbkUEiiQeJvddpLx3bNvjBZeKMH4xRY6Gei7UHob6CbUKMnsTo=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R531e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0XDkvBnT_1793330826;
Received: from 30.221.129.214(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XDkvBnT_1793330826 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 30 Oct 2026 11:27:07 +0800
Message-ID: <f80554e4-fde7-4811-9c2e-ae9407793bf7@linux.alibaba.com>
Date: Fri, 30 Oct 2026 11:27:06 +0800
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
Subject: Re: [PATCH v4] ocfs2/dlm: serialize migration MLE cleanup on failure
To: Cen Zhang <zzzccc427@gmail.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: mark@fasheh.com, jlbec@evilplan.org, heming.zhao@suse.com,
 ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org, baijiaju1990@gmail.com, jjzuming@gmail.com
References: <pm-ocfs2-objects-candidate-0038-v9-659f247ea980d5f3fbeb@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <pm-ocfs2-objects-candidate-0038-v9-659f247ea980d5f3fbeb@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/27/26 6:14 PM, Cen Zhang wrote:
> A migration MLE has a base reference for the mastering answer and an
> in-use reference held by dlm_migrate_lockres(). The finishing assertion
> consumes the base reference, but migration failure drops it again
> without checking whether the assertion already consumed it.
> 
> The target queues its migration worker before it acknowledges the
> ALL_DONE packet, so its finishing assertion can be handled while the
> sender still waits for the status. If the connection fails before the
> status arrives, dlm_send_one_lockres() returns an error for a migration
> that the target has already completed:
> 
>   Old-master sender                  Finishing assertion
>   -----------------                  -------------------
>   publish MLE; take in-use reference
>   send ALL_DONE; wait for status
>                                      take lookup reference
>                                      unlink MLE
>                                      put lookup and base references
>   send returns a connection error
>   put base reference again; free MLE
>   put in-use reference; access freed MLE
> 
> dlm_assert_master_handler() holds dlm->spinlock from the MLE lookup to
> the final puts, and it takes dlm->master_lock around the unlink and the
> puts. Decide under the same locks: if the MLE is already unhashed, the
> assertion consumed the base reference, so drop only the sender's in-use
> reference. Otherwise unlink it before consuming the base reference so a
> later assertion no longer finds it.
> 
> An assertion that got there first has also made the target the owner
> and cleared DLM_LOCK_RES_MIGRATING. Treating the attempt as failed at
> that point would leave the lockres owned by the target while this node
> still holds the other nodes' locks and refmap bits, so it could neither
> be purged nor migrated again. Finish our side as a completed migration
> does instead: drop those locks under res->spinlock if the target still
> owns the lockres, and recalculate its usage.
> 
> Use the same cleanup for the pre-send failure, the send failure and the
> target-death failure paths. The sender's in-use reference keeps the MLE
> alive until its final put outside the nested locks. Successful
> migration retains its existing in-use-only put.
> 
> A target that has died cannot assert after the sender has seen its
> death. The o2net node-down callback runs before the DLM one; it
> disconnects the node and flushes the workqueue that runs the message
> handlers, so an assertion already received has been handled by the time
> the DLM removes the node from the domain map. A node that leaves the
> domain cleanly sends its exit message only after its assertions have
> been answered.
> 
> Two windows of the hand-over itself are left as they are: the handler
> switches the owner and the sender drops the other nodes' locks moments
> later, and an assertion from a live target that arrives after the
> sender has given up still meets the owner check in the handler. Waiting
> for the target before giving up would only stretch the first window
> into the time in which recovery of the target can observe it.
> 
> KASAN report, only the relevant frames are kept:
> 
> BUG: KASAN: slab-use-after-free in dlm_put_mle_inuse+0xce/0xe0
> Read of size 8 at addr ffff8881190e3c20 by task umount/593
> 
> Call Trace:
>  <TASK>
>  dlm_put_mle_inuse+0xce/0xe0
>  dlm_migrate_lockres+0x16af/0x20d0
>  dlm_empty_lockres+0x60a/0xbd0
>  dlm_unregister_domain+0x53b/0x11d0
>  o2cb_cluster_disconnect+0xa5/0x110
>  ocfs2_cluster_disconnect+0x73/0xc0
>  ocfs2_dlm_shutdown+0x311/0x440
>  ocfs2_dismount_volume+0x696/0x940
>  generic_shutdown_super+0x15f/0x490
>  kill_block_super+0x40/0xa0
>  deactivate_locked_super+0xae/0x120
>  deactivate_super+0xa2/0xc0
>  cleanup_mnt+0x217/0x450
>  task_work_run+0x144/0x230
>  </TASK>
> 
> Allocated by task 593:
>  kmem_cache_alloc_noprof+0x20b/0x5c0
>  dlm_migrate_lockres+0x20e/0x20d0
>  dlm_empty_lockres+0x60a/0xbd0
>  dlm_unregister_domain+0x53b/0x11d0
>  o2cb_cluster_disconnect+0xa5/0x110
>  ocfs2_cluster_disconnect+0x73/0xc0
>  ocfs2_dlm_shutdown+0x311/0x440
>  ocfs2_dismount_volume+0x696/0x940
> 
> Freed by task 593:
>  kmem_cache_free+0x242/0x580
>  __dlm_put_mle+0x4b2/0x660
>  dlm_migrate_lockres+0x1690/0x20d0
>  dlm_empty_lockres+0x60a/0xbd0
>  dlm_unregister_domain+0x53b/0x11d0
>  o2cb_cluster_disconnect+0xa5/0x110
>  ocfs2_cluster_disconnect+0x73/0xc0
>  ocfs2_dlm_shutdown+0x311/0x440
> 
> The buggy address belongs to the object at ffff8881190e3c00
>  which belongs to the cache o2dlm_mle of size 480
> The buggy address is located 32 bytes inside of
>  freed 480-byte region [ffff8881190e3c00, ffff8881190e3de0)
> 
> Fixes: 6714d8e86bf4 ("[PATCH] OCFS2: The Second Oracle Cluster Filesystem")
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Cen Zhang <zzzccc427@gmail.com>

Looks fine.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
