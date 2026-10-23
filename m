Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.97
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792724896;
	b=eHYjYeTeejDZYuiUciqntaXJohJa0Rr4ulmBjjyPoWWrz4ans0d5cxiQOYh2pQIaOZO6
	 Awe3wHY4sJrV65KGq/0RWJ38HstCi6sFyQb+5MNW63OiUJksrSIeaqYTBIDMVLnNAecl7
	 gBAkEIEt54nvoBNDzp8sS1MoM6Gl8VsrC9ZjVUHM4dQQKV3CxU2uXEAMNbpKP9Tg6/Y+o
	 8ka8vC0WkuS6su1vnnB9BbdQ/5k8sS7CNgBp4iRsXzjPtCxZuv7EzMYi35jD11AdysLnI
	 KWaJsGZ4WF52wTDNT9SYdNL/eIhZ4iRm2wvoJYudNc7M1E+GaQkx7aDxjZlMVlAUm+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792724896;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=k5/3ir0P1aWVS/9JkvUlKwKFLtVvmSX8TXwpmoFMN7Y=;
	b=yKJdlx6Z9eXr0bwXndG13l9Z1RRULkQjHj1aka2ln2wEJwn/0L7r7PffRJM4VIIsh0ii
	 jMBp15oM7NLMwOVsszPlH8Q4DzDZhMc/KHcdhmm6jGOHbRmtNdMJnN5ZcI2x1qdYYrKa3
	 AwGZ3rDhGD4N7yPzWNzMKOGrKErhJ55OsdMajOV1Xmji7zlA5iRUMxBbGsrVNet34SpRk
	 pkC8GWN08U3ox11gjsFfymD1YLS0GXUmY78hHvJuKGqV5XOx0Lchc+jiJ5eqkGFlwTxUS
	 nV9CxHtRtvdyM89dGSSWl/SIBuYeg6QZXW9yt6srVU5F7hfjob5PpAOsJHuFVmz9elQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=qqlxZb+x;
	arc=none smtp.remote-ip=115.124.30.97
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 964A2606A31E
	for <ocfs2-devel@lists.linux.dev>; Fri, 23 Oct 2026 03:08:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 964A2606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=qqlxZb+x
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1792724890; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=k5/3ir0P1aWVS/9JkvUlKwKFLtVvmSX8TXwpmoFMN7Y=;
	b=qqlxZb+xPsJKJw9MxHpyF4I4ScsGoq4lz8wm6VDhNff98bxpSwME8tnxfFtm3Fzqjk4D3EMzNzRVqJgLalByCpWP2JZwrlp7ES3gO2X/1J9guO31w9luIXqY5Gbi/Si38RZcbs0u8fkIjLnKAmultGGsYQ616cnrzXaWo3JyFuo=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R911e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0XDKnkiC_1792724888;
Received: from 30.221.129.69(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XDKnkiC_1792724888 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 23 Oct 2026 11:08:09 +0800
Message-ID: <16c6e640-d99f-4f10-9f16-f016d30023cb@linux.alibaba.com>
Date: Fri, 23 Oct 2026 11:08:08 +0800
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
Subject: Re: [PATCH v2] ocfs2/dlm: drain join handlers before releasing module
 text
To: Cen Zhang <zzzccc427@gmail.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: mark@fasheh.com, jlbec@evilplan.org, heming.zhao@suse.com,
 ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org, baijiaju1990@gmail.com, jjzuming@gmail.com
References: <pm-ocfs2-objects-candidate-0076-v6-12de5f4628f57fba3be3@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <pm-ocfs2-objects-candidate-0076-v6-12de5f4628f57fba3be3@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/22/26 5:09 PM, Cen Zhang wrote:
> The code for a registered DLM handler must remain resident until its
> last invocation finishes. dlm_unregister_net_handlers() only removes
> dlm_join_handlers from the o2net registry. o2net_handler_get() takes a
> kref on the wrapper, but that reference does not pin ocfs2_dlm text.
> o2net_process_message() calls nh_func after dropping o2net_handler_lock.
> 
> With CONFIG_OCFS2_FS_O2CB=m, ocfs2_dlm can be loaded independently of
> ocfs2_stack_o2cb while nodemanager continues handling messages from a
> configured, heartbeating peer. If no dependent module or module reference
> prevents normal unload, the following ordering is possible:
> 
>   Receive worker                       Module unload
>   --------------                       -------------
>   o2net_handler_get()
>     take wrapper kref
>     drop handler lock
>   <preempted>
>                                        dlm_exit()
>                                          unregister handlers
>                                        release DLM module text
>   call saved nh_func
>     in released module text
> 
> Use o2net_unregister_and_flush_handler_list() in the shared DLM
> unregister helper. It first prevents new lookups, then waits for the
> ordered o2net workqueue to drain, including a concurrent destruction of
> that queue. The acquired invocation therefore finishes before dlm_exit()
> returns and the loader releases the callback code. The same helper
> covers partial registration and dlm_init() error unwind before module
> memory is released.
> 
> Skip the drain when the private join-handler list is empty. Early
> dlm_init() failures can reach this helper before any handler has been
> published. Partial-registration failure also reaches it a second time
> after the first call has already unregistered and drained the list.
> Neither case needs to take o2net_wq_mutex or drain unrelated work.
> The list is changed only by serialized module init/exit paths; a
> nonempty list still uses the full unregister-and-flush helper.
> 
> Oops report as below:
> 
>     Oops: int3: 0000 [#1] SMP KASAN NOPTI
>     CPU: 2 UID: 0 PID: 54 Comm: kworker/u16:3 Not tainted 7.3.0-rc4-next-20260921-pmb-ocfs2-functional-v1+ #1 PREEMPT(lazy)
> 
> Hardware identification omitted.
> 
>     Workqueue: o2net o2net_rx_until_empty [ocfs2_nodemanager]
>     RIP: 0010:0xffffffffc0423871
>     [Instruction byte dump omitted.]
> 
> Register dump omitted.
> 
>     Call Trace:
>      <TASK>
>      ? o2net_rx_until_empty+0x19b1/0x3300 [ocfs2_nodemanager]
>      ? __pfx_o2net_rx_until_empty+0x10/0x10 [ocfs2_nodemanager]
>      ? lock_acquire+0x190/0x300
>      ? process_one_work+0x935/0x1b40
>      ? process_one_work+0x834/0x1b40
>      ? srso_alias_return_thunk+0x5/0xfbef5
>      ? lock_release+0xc8/0x290
>      ? srso_alias_return_thunk+0x5/0xfbef5
>      ? process_one_work+0x9a8/0x1b40
>      ? __pfx_process_one_work+0x10/0x10
>      ? lock_acquire+0x190/0x300
>      ? lock_is_held_type+0x8f/0x100
>      ? srso_alias_return_thunk+0x5/0xfbef5
>      ? worker_thread+0x65c/0xe40
>      ? srso_alias_return_thunk+0x5/0xfbef5
>      ? __kthread_parkme+0x177/0x220
>      ? srso_alias_return_thunk+0x5/0xfbef5
>      ? __pfx_worker_thread+0x10/0x10
>      ? kthread+0x351/0x460
>      ? srso_alias_return_thunk+0x5/0xfbef5
>      ? __pfx_kthread+0x10/0x10
>      ? ret_from_fork+0x659/0x940
>      ? __pfx_ret_from_fork+0x10/0x10
>      ? srso_alias_return_thunk+0x5/0xfbef5
>      ? __switch_to+0x74f/0xf70
>      ? __pfx_kthread+0x10/0x10
>      ? ret_from_fork_asm+0x1a/0x30
>      </TASK>
>     Modules linked in: ocfs2_nodemanager [last unloaded: ocfs2_dlm]
>     ---[ end trace 0000000000000000 ]---
> 
> Fixes: 6714d8e86bf4 ("[PATCH] OCFS2: The Second Oracle Cluster Filesystem")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
> Assisted-by: LLM

Looks fine.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
> Changes in v2:
> - Skip unregister-and-flush when the private join-handler list is empty,
>   covering early dlm_init failures and the second cleanup after
>   partial-registration unwind.
> - Retain the full unregister-and-flush helper for every nonempty list; do
>   not change the generic o2net helper.
> 
> Link to v1: https://lore.kernel.org/r/pm-ocfs2-objects-candidate-0076-v5-dd198d8a9358ad81f70e@gmail.com
> 
>  fs/ocfs2/dlm/dlmdomain.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/dlm/dlmdomain.c b/fs/ocfs2/dlm/dlmdomain.c
> index 97bb9400e24b..a7dc3da6dfc7 100644
> --- a/fs/ocfs2/dlm/dlmdomain.c
> +++ b/fs/ocfs2/dlm/dlmdomain.c
> @@ -2215,7 +2215,8 @@ static LIST_HEAD(dlm_join_handlers);
>  
>  static void dlm_unregister_net_handlers(void)
>  {
> -	o2net_unregister_handler_list(&dlm_join_handlers);
> +	if (!list_empty(&dlm_join_handlers))
> +		o2net_unregister_and_flush_handler_list(&dlm_join_handlers);
>  }
>  
>  static int dlm_register_net_handlers(void)

