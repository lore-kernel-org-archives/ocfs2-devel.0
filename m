Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.100
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792587729;
	b=4s9TfU33Mg241+2a5Nju3xqWy5c+l98MtA/HPPbYfG29GfU/NaUI+y+syYdQB2GETL3I
	 iMczqSWqqLhoYzYxfgh01ivE05TlNvYuPlFx/njRYfP+Qyo+uA3jsUczgMTVsU2Kyiig5
	 JXxPtdsCQYTt6o8O7MpWkVOKwWEnVZdHrzP5bymLWvij84RZjTFYetO3bdz+LW8SD/VHp
	 lhRMCkY2cDe4bEMvJDxz1YcKzKqv8F0zPc0B8pCVtxFvXDx9U/dSo4VkdJ3tu0cEAR0Js
	 yb2JUIFcWLLcT1NfN7V6b9sdKKrPlrnHrXfkZIYM05BSDOUAZj9dzJQ+mFpg1UydqKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792587729;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=+U/VqdMn77e5DlPnAgR6p4ZN2g76wKdh1w/4Vd5DySo=;
	b=cQU3oWrVEfSteaRT1hJ3cAP6R+djyYxU3IRtK5ADbJHqviaxFrm1PIaCi4AbaSp/tzSc
	 Yw+yzdJiHGbEJwYfgcIqQ/tBXEIeTR0T7zx7PMrOVjqcLdPtd/MMx+2cv3A9rfPQKGM0A
	 D0LG0bhuB/8MgqlC0FSdvtyn9e1mmzT7c22SUNvMqxB7d2wzAQnQbdONLnsS0P2OLWa+8
	 QHW2clV/2g7ZOj76vI27zmCcOsREeJzhySwDgkVHHRidrjd+0JLd4N8kvS/706DxworjM
	 ut612DJ8n7UDT/kEk6VfbkkkP6UUS1fuIEhCZhDBwytEHHY0n+kbMtzuELkGWs67aDA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=meea8JwO;
	arc=none smtp.remote-ip=115.124.30.100
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 895EB606A31A
	for <ocfs2-devel@lists.linux.dev>; Wed, 21 Oct 2026 13:02:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 895EB606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=meea8JwO
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1792587718; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=+U/VqdMn77e5DlPnAgR6p4ZN2g76wKdh1w/4Vd5DySo=;
	b=meea8JwOrd0u3W9/7w46mH2qXpjZ29Ea1cHDpki9UN/n5s9askOLCWLPUH/2zxC+IC2nDPn5KhgKloO9SQ9yRz36zAjzpGw6EK75zQcvRMczeVcZFMEAtpNu8gjRSegqVJDCpxL1nz+AqGwftzVBYVAgU4U14ZBmA1kPuttvnVY=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R481e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0XDGRm8v_1792587716;
Received: from 30.221.149.139(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XDGRm8v_1792587716 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 21 Oct 2026 21:01:57 +0800
Message-ID: <71dabc63-7e67-4c25-87eb-17fcdf2ddd3a@linux.alibaba.com>
Date: Wed, 21 Oct 2026 21:01:56 +0800
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
Subject: Re: [PATCH] ocfs2/dlm: drain join handlers before releasing module
 text
To: Cen Zhang <zzzccc427@gmail.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, heming.zhao@suse.com,
 ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org, baijiaju1990@gmail.com, jjzuming@gmail.com
References: <pm-ocfs2-objects-candidate-0076-v5-dd198d8a9358ad81f70e@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <pm-ocfs2-objects-candidate-0076-v5-dd198d8a9358ad81f70e@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/20/26 9:04 PM, Cen Zhang wrote:
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
> returns and the loader releases the callback code. The same helper also
> covers partial registration and dlm_init() error unwind before module
> memory is released.
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
>     Code: cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc <cc> cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc
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
> ---
>  fs/ocfs2/dlm/dlmdomain.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/dlm/dlmdomain.c b/fs/ocfs2/dlm/dlmdomain.c
> index 97bb9400e24b..0f4d29cbce81 100644
> --- a/fs/ocfs2/dlm/dlmdomain.c
> +++ b/fs/ocfs2/dlm/dlmdomain.c
> @@ -2215,7 +2215,7 @@ static LIST_HEAD(dlm_join_handlers);
>  
>  static void dlm_unregister_net_handlers(void)
>  {
> -	o2net_unregister_handler_list(&dlm_join_handlers);
> +	o2net_unregister_and_flush_handler_list(&dlm_join_handlers);
>  }
>  
>  static int dlm_register_net_handlers(void)

dlm_unregister_net_handlers() is also reached from the dlm_init() error
label on failures that happen before any handler was ever registered.
So in case of an empty dlm_join_handlers, o2net_unregister_handler_list()
walks nothing, but o2net_flush_wq() still takes o2net_wq_mutex and drains
the entire o2net workqueue.

Thanks,
Joseph

