Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BED1489FD0
	for <ocfs2-devel@lists.linux.dev>; Fri,  9 Oct 2026 08:04:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791533052; cv=none; b=Ro/Wc9kEQr00ALG5VZuEAclw/TN2FdqhxDqVsRGwoOQnNeJIlPbDwUuZ9na1pSKUiWl5F6q2z1X3dK26QjKwjnwgsvOnjuvgTwpswP2vvyyT1TRPfP7z4XY4aXDixR/Jq/g1LxD1IZFlcEA6mD2H7K+4+HJubJnNuz8/0pCdBS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791533052; c=relaxed/simple;
	bh=+0kXAjOjg/9WUc5d0eFE41rzMQPlmPari+A2rE+8uyg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=c4ex0zgNFdTTU0vd3MUizJm13rWq5APrNmkMw4cn/0JetV/Fz/02i9gWxSc6j2ChjLuDOpsM3Rogicgz9fADcSoXATExEqbXvBf81wBxfsT7feZ9ItG2IN/zd652XnCjFHQ+IjfAiciLf17calJr+JHeDDW3pFeztO38rv/V2n0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=LVu7Bfqk; arc=none smtp.client-ip=115.124.30.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="LVu7Bfqk"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1791533039; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=/ZWpKMi0mJSFdhpu7QKy0xfJr15BOhxJqinnt5xIn9U=;
	b=LVu7Bfqk7futSUA+BZ14xwNEyD5vKMrqJuGUtk0BWoKZ3nRxZcRt/xWVJk533eKGBo+JzDQ+c48VsC5L3qDa6Jv8HJ0ppBN0ffBAgHb85YR9s+jcf0WoK4dsWmDP7LbYh2uqOZG18h2/yFma0NMCb4bXH+chZh90CqJbHVONamU=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0XCSlded_1791533037;
Received: from 30.221.148.47(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XCSlded_1791533037 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 09 Oct 2026 16:03:58 +0800
Message-ID: <368a2c31-d365-4e38-8e61-69319cd0bdd7@linux.alibaba.com>
Date: Fri, 9 Oct 2026 16:03:57 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: Initialize status waiters before publishing them
To: Cen Zhang <zzzccc427@gmail.com>, akpm@linux-foundation.org
Cc: mark@fasheh.com, jlbec@evilplan.org, kees@kernel.org, kuba@kernel.org,
 kurt.hackel@oracle.com, ocfs2-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org, baijiaju1990@gmail.com, jjzuming@gmail.com
References: <pm-ocfs2-objects-candidate-0066-v1-437a0422801b292a2879@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <pm-ocfs2-objects-candidate-0066-v1-437a0422801b292a2879@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/9/26 9:43 AM, Cen Zhang wrote:
> o2net_prep_nsw() publishes its stack waiter in nn_status_idr and
> nn_status_list under nn_lock, then initializes the wait queue and
> completion status after releasing the lock. A concurrent disconnect
> can find that waiter through o2net_complete_nodes_nsw() and call
> wake_up() before the wait queue has a valid lock and list head. The
> sender can also overwrite a completion status with its initial value.
> 
> Initialize the wait queue and status before publishing the waiter.
> nn_lock then orders publication against completion, and no reader can
> observe a partially initialized object. Leave the IDR allocation and
> its failure handling unchanged.
> 
> A controlled case-modified test kernel used a synthetic connection to
> enter the real send path and overlap publication with disconnect. The
> candidate completion and wake-up code were unchanged. Its Oops includes:
> 
>   KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
>   RIP: 0010:__wake_up_common+0xa0/0x1f0
>   Call Trace:
>    <TASK>
>    __wake_up+0x36/0x60
>    o2net_complete_nsw_locked+0x222/0x370
>    o2net_set_nn_state+0x917/0xea0
>    o2net_disconnect_node+0xd0/0x190
>    o2net_validate_control_write+0x454/0x500
>    full_proxy_write+0x11f/0x180
>    vfs_write+0x25a/0x1010
>    ksys_write+0x111/0x200
>    do_syscall_64+0x114/0x620
>    entry_SYSCALL_64_after_hwframe+0x77/0x7f
>    </TASK>
>   Modules linked in:
> 
> Fixes: 98211489d414 ("[PATCH] OCFS2: The Second Oracle Cluster Filesystem")
> Assisted-by: LLM
> Signed-off-by: Cen Zhang <zzzccc427@gmail.com>

Looks fine.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
>  fs/ocfs2/cluster/tcp.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ocfs2/cluster/tcp.c b/fs/ocfs2/cluster/tcp.c
> index 474fe1414cee8609d7976b983332c6e120f06fb5..8b3830b601ba6e5fe964bec970581b8e4ddbb5dd 100644
> --- a/fs/ocfs2/cluster/tcp.c
> +++ b/fs/ocfs2/cluster/tcp.c
> @@ -301,6 +301,11 @@ static int o2net_prep_nsw(struct o2net_node *nn, struct o2net_status_wait *nsw)
>  {
>  	int ret;
>  
> +	/* Initialize all completion-visible state before publishing the waiter. */
> +	init_waitqueue_head(&nsw->ns_wq);
> +	nsw->ns_sys_status = O2NET_ERR_NONE;
> +	nsw->ns_status = 0;
> +
>  	spin_lock(&nn->nn_lock);
>  	ret = idr_alloc(&nn->nn_status_idr, nsw, 0, 0, GFP_ATOMIC);
>  	if (ret >= 0) {
> @@ -311,9 +316,6 @@ static int o2net_prep_nsw(struct o2net_node *nn, struct o2net_status_wait *nsw)
>  	if (ret < 0)
>  		return ret;
>  
> -	init_waitqueue_head(&nsw->ns_wq);
> -	nsw->ns_sys_status = O2NET_ERR_NONE;
> -	nsw->ns_status = 0;
>  	return 0;
>  }
>  

