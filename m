Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.101
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793273120;
	b=eW3xesQa5U4SBHrhMjRUdnbEmRMWQ55ivYAAQ2BSuFx33AW/LRD7NVhX/3A5JpCO5PXQ
	 GJA7UFtUspURwSSDqXhkpuMNhOj9onYUTLhLv9tQqPFqxbH+otpZ0MMwegblHb1efFcxd
	 lYKBTx9YmdqKZ3saNaHUp7zsSnYtpT1aeZQYQGseqqszwEvsY+PgCFq2CZE9PwF2jcGKZ
	 0H101CVaomGe/DSRpo2x9wpo6uTES9Z9UTwGDMBbEUsSQWDjlDLEvUVN9s0Q2aQdURLU+
	 F/25VeCq+pegcOyn7uuQ4x1Dpc5GcXvzkFgFP0jogpRHtodlb0Ti0y4aBUEDi1HsoJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793273120;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=nAU4owEjk36lEPSSaeh5evdiPLASncBlT4PAdLhvFAs=;
	b=389uv2w4gxVvPngSt3YbvvzXD2vnZ2Cm82dMnsJvF/WMsPbvCPb2bSzJlzGkKstzmKiT
	 KN3EBAbk3gZWpo/P1wk84q08XUR0tc/3uk5PLFQi6GrR1sHkjJjBzlTcVuh7WpikHSbTj
	 Fr/9EUe0mi19cQd+m/VKTsLxGWquNG11704DWIKOWO1B6tPExn/IRArzyvcEgOVBxPJ7j
	 JgiOaG/60KxOPfPXwgeBe4TQIeky814gPG1zpxT06fAEPOMi1eSlTC4BRHxELxfDf57lc
	 Gs2pXbBl+lV5jVjsrxDhCXx/a/V2Oo+bm0XPCSoCUllgLHyDhq1aPMVdfIKXbdcv/SQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=QvGpD1z2;
	arc=none smtp.remote-ip=115.124.30.101
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28F7D606A31C
	for <ocfs2-devel@lists.linux.dev>; Thu, 29 Oct 2026 11:25:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 28F7D606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=QvGpD1z2
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793273114; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=nAU4owEjk36lEPSSaeh5evdiPLASncBlT4PAdLhvFAs=;
	b=QvGpD1z2gTd4/bP8jyO3RGWlCKE0dsIEjecwX8TBPFAiA2KDZ1RXDjIBTHvABHMCCE7mrGbRimq4eKc3aVxXW4BHmcyeZJEjzr92YuUYbY+z6cJkEKYr43Z5UBXn/nOGL4vIrheQfyxlvSiwuU1033pDoorcHEHTDzKOi7Iv1f8=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0XDjKhwY_1793273112;
Received: from 30.221.129.93(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XDjKhwY_1793273112 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 29 Oct 2026 19:25:13 +0800
Message-ID: <76775188-2010-48ae-b92f-ed1ae819a021@linux.alibaba.com>
Date: Thu, 29 Oct 2026 19:25:12 +0800
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
Subject: Re: [PATCH v2] ocfs2/cluster: quiesce peer slots before destroying
 the o2net workqueue
To: Cen Zhang <zzzccc427@gmail.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, heming.zhao@suse.com,
 ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org, baijiaju1990@gmail.com, jjzuming@gmail.com
References: <pm-ocfs2-objects-candidate-0090-v7-06712049fb73524bb8d3@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <pm-ocfs2-objects-candidate-0090-v7-06712049fb73524bb8d3@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 10/27/26 12:32 PM, Cen Zhang wrote:
> Listener shutdown must leave no peer work behind before it destroys the
> o2net workqueue. destroy_workqueue() drains the work that is queued, but
> delayed work whose timer has not expired is invisible to it and is
> queued onto the freed workqueue when the timer fires.
> 
> o2net_stop_listening() only disconnects peers that are still in the node
> table, and o2net_disconnect_node() cancels the delayed work without
> waiting for a running instance. Several paths rearm it afterwards.
> 
> Node removal disconnects a peer before taking it out of the table. A
> heartbeat-up callback in between sees the persistent error and queues
> the connect and expiry work again, and the listener shutdown then skips
> the peer because it is no longer in the table:
> 
>   Peer removal                       Heartbeat / listener shutdown
>   ------------                       -----------------------------
>   disconnect peer; cancel work
>                                      heartbeat-up: rearm delayed work
>   remove peer from node table
>                                      stop listener
>                                        synchronize heartbeat callbacks
>                                        skip peer absent from node table
>                                        destroy o2net workqueue
>                                      delayed-work timer expires
>                                        queue on freed workqueue
> 
> o2net_connect_expired() may be running while the disconnect cancels;
> once the disconnect drops nn_lock it queues itself and the connect work
> again, and the flush does not wait for those timers.
> 
> o2net_start_connect() decides under nn_lock whether to connect, drops
> the lock to create the socket, and attaches the socket without looking
> again. A disconnect in between is undone: the socket stays attached
> with its callbacks armed, and o2net_set_nn_state() rearms the expiry
> work after it has been cancelled.
> 
> Set o2net_shutting_down for the duration of the shutdown. While it is
> set, o2net_set_nn_state() rearms no work, the connect worker repeats its
> check under nn_lock before attaching the socket and backs off, and the
> accept path refuses a new socket. With no rearm left, cancel the
> connect-expiry, connect and still-up work of every peer slot
> synchronously after the disconnect; expiry queues connect work, so it
> is cancelled first.
> 
> Those cancellations can remove the only pending connection attempt of a
> slot whose persistent error a rearm has already cleared. Leave every
> slot the way a disconnect does, with nn_timeout reset and -ENOTCONN as
> the persistent error, so that the next heartbeat-up after a restart
> reconnects and senders fail instead of waiting for a connection that
> nothing will establish.
> 
> KASAN report, only the relevant frames are kept:
> 
> BUG: KASAN: slab-use-after-free in __queue_work+0x1189/0x1600
> Read of size 4 at addr ffff8881169069c0 by task swapper/2/0
> 
> Call Trace:
>  <IRQ>
>  __queue_work+0x1189/0x1600
>  call_timer_fn+0x176/0x540
>  </IRQ>
> 
> Allocated by task 486:
>  __kmalloc_noprof+0x2de/0x780
>  __alloc_workqueue+0x61/0x17a0
>  alloc_workqueue_noprof+0xcc/0x130
>  o2net_start_listening+0x139/0x7c0
>  o2nm_node_local_store+0x4c0/0x810
>  configfs_write_iter+0x2f9/0x4f0
>  vfs_write+0x639/0x1010
>  ksys_write+0x111/0x200
> 
> Freed by task 485:
>  kfree+0x308/0x580
>  rcu_core+0x6be/0x1ed0
> 
> Last potentially related work creation:
>  __call_rcu_common.constprop.0+0x80/0x280
>  pwq_release_workfn+0x740/0xe10
> 
> The buggy address belongs to the object at ffff888116906800
>  which belongs to the cache kmalloc-1k of size 1024
> The buggy address is located 448 bytes inside of
>  freed 1024-byte region [ffff888116906800, ffff888116906c00)
> 
> Fixes: 98211489d414 ("[PATCH] OCFS2: The Second Oracle Cluster Filesystem")
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
> ---
> Changes in v2:
> - Add o2net_shutting_down: o2net_set_nn_state() rearms nothing while it is
>   set, the connect worker rechecks under nn_lock before attaching its socket
>   and the accept path refuses a new socket, so an in-flight connect or
>   expiry can no longer rearm the timers after the synchronous cancellations
>   (Sashiko review).
> - Leave every slot with nn_timeout reset and -ENOTCONN after the
>   cancellations, so a later heartbeat-up reconnects and senders fail instead
>   of waiting on a slot whose persistent error a rearm had cleared (Sashiko
>   review).
> - Subject changed accordingly.
> 
> Link to v1: https://lore.kernel.org/r/pm-ocfs2-objects-candidate-0090-v6-127847d463212a41b773@gmail.com
> 
>  fs/ocfs2/cluster/tcp.c | 86 +++++++++++++++++++++++++++++++++---------
>  1 file changed, 69 insertions(+), 17 deletions(-)
> 
> diff --git a/fs/ocfs2/cluster/tcp.c b/fs/ocfs2/cluster/tcp.c
> index 8b3830b601ba..eb4628839eef 100644
> --- a/fs/ocfs2/cluster/tcp.c
> +++ b/fs/ocfs2/cluster/tcp.c
> @@ -114,6 +114,8 @@ static DEFINE_MUTEX(o2net_wq_mutex);
>  static DECLARE_COMPLETION(o2net_wq_destroyed);
>  /* Heartbeat callbacks stay registered across local-node off/on. */
>  static bool o2net_listening;
> +/* set while o2net_stop_listening() quiesces the peer slots */
> +static bool o2net_shutting_down;
>  static struct work_struct o2net_listen_work;
>  
>  static struct o2hb_callback_func o2net_hb_up, o2net_hb_down;
> @@ -553,11 +555,14 @@ static void o2net_set_nn_state(struct o2net_node *nn,
>  		       SC_NODEF_ARGS(sc));
>  	}
>  
> -	/* trigger the connecting worker func as long as we're not valid,
> +	/*
> +	 * trigger the connecting worker func as long as we're not valid,
>  	 * it will back off if it shouldn't connect.  This can be called
>  	 * from node config teardown and so needs to be careful about
> -	 * the work queue actually being up. */
> -	if (!valid && o2net_wq) {
> +	 * the work queue actually being up.  Once the listener shutdown
> +	 * has started cancelling, nothing may be rearmed.
> +	 */
> +	if (!valid && o2net_wq && !READ_ONCE(o2net_shutting_down)) {
>  		unsigned long delay;
>  		/* delay if we're within a RECONNECT_DELAY of the
>  		 * last attempt */
> @@ -1578,6 +1583,23 @@ static void o2net_sc_postpone_idle(struct o2net_sock_container *sc)
>   * having a connect attempt fail, etc. This centralizes the logic which decides
>   * if a connect attempt should be made or if we should give up and all future
>   * transmit attempts should fail */
> +/*
> + * Called with nn->nn_lock held.  See if we already have one pending or
> + * have given up.  For nn_timeout, it is set when we close the connection
> + * because of the idle time out.  So it means that we have at least
> + * connected to that node successfully once, now try to connect to it
> + * again.  Nothing may connect once the listener shutdown has started.
> + */
> +static bool o2net_nn_should_connect(struct o2net_node *nn)
> +{
> +	unsigned int timeout = atomic_read(&nn->nn_timeout);
> +
> +	if (READ_ONCE(o2net_shutting_down) || nn->nn_sc)
> +		return false;
> +	return !nn->nn_persistent_error ||
> +	       (nn->nn_persistent_error == -ENOTCONN && timeout != 0);
> +}
> +
>  static void o2net_start_connect(struct work_struct *work)
>  {
>  	struct o2net_node *nn =
> @@ -1587,7 +1609,6 @@ static void o2net_start_connect(struct work_struct *work)
>  	struct socket *sock = NULL;
>  	struct sockaddr_in myaddr = {0, }, remoteaddr = {0, };
>  	int ret = 0, stop;
> -	unsigned int timeout;
>  	unsigned int nofs_flag;
>  
>  	/*
> @@ -1609,17 +1630,7 @@ static void o2net_start_connect(struct work_struct *work)
>  		goto out;
>  
>  	spin_lock(&nn->nn_lock);
> -	/*
> -	 * see if we already have one pending or have given up.
> -	 * For nn_timeout, it is set when we close the connection
> -	 * because of the idle time out. So it means that we have
> -	 * at least connected to that node successfully once,
> -	 * now try to connect to it again.
> -	 */
> -	timeout = atomic_read(&nn->nn_timeout);
> -	stop = (nn->nn_sc ||
> -		(nn->nn_persistent_error &&
> -		(nn->nn_persistent_error != -ENOTCONN || timeout == 0)));
> +	stop = !o2net_nn_should_connect(nn);
>  	spin_unlock(&nn->nn_lock);
>  	if (stop)
>  		goto out;
> @@ -1658,9 +1669,16 @@ static void o2net_start_connect(struct work_struct *work)
>  	tcp_sock_set_nodelay(sc->sc_sock->sk);
>  	tcp_sock_set_user_timeout(sock->sk, O2NET_TCP_USER_TIMEOUT);
>  
> -	o2net_register_callbacks(sc->sc_sock->sk, sc);
> -
>  	spin_lock(&nn->nn_lock);
> +	/*
> +	 * nn_lock was dropped while the socket was created.  A disconnect
> +	 * or the listener shutdown in between must not gain this socket.
> +	 */
> +	if (!o2net_nn_should_connect(nn)) {
> +		spin_unlock(&nn->nn_lock);
> +		goto out;
> +	}
> +	o2net_register_callbacks(sc->sc_sock->sk, sc);
>  	/* handshake completion will set nn->nn_sc_valid */
>  	o2net_set_nn_state(nn, sc, 0, 0);
>  	spin_unlock(&nn->nn_lock);
> @@ -1954,6 +1972,12 @@ static int o2net_accept_one(struct socket *sock, int *more)
>  	new_sock = NULL;
>  
>  	spin_lock(&nn->nn_lock);
> +	/* a slot that is being quiesced takes no new socket */
> +	if (READ_ONCE(o2net_shutting_down)) {
> +		spin_unlock(&nn->nn_lock);
> +		ret = -ESHUTDOWN;
> +		goto out;
> +	}
>  	atomic_set(&nn->nn_timeout, 0);
>  	o2net_set_nn_state(nn, sc, 0, 0);
>  	spin_unlock(&nn->nn_lock);
> @@ -2179,6 +2203,30 @@ int o2net_start_listening(struct o2nm_node *node)
>  	return ret;
>  }
>  
> +/*
> + * Called with o2net_shutting_down set.  Cancel the delayed work of a peer
> + * slot synchronously: work waiting on its timer is invisible to a flush
> + * and would be queued on the destroyed workqueue.  Then leave the slot
> + * the way a disconnect does, so that the next heartbeat-up after a
> + * restart reconnects and senders fail instead of waiting.
> + */
> +static void o2net_quiesce_nn(struct o2net_node *nn)
> +{
> +	/* whoever takes nn_lock from now on sees o2net_shutting_down */
> +	spin_lock(&nn->nn_lock);
> +	spin_unlock(&nn->nn_lock);
> +
> +	/* expiry queues connect work, so cancel it first */
> +	cancel_delayed_work_sync(&nn->nn_connect_expired);
> +	cancel_delayed_work_sync(&nn->nn_connect_work);
> +	cancel_delayed_work_sync(&nn->nn_still_up);
> +
> +	spin_lock(&nn->nn_lock);
> +	atomic_set(&nn->nn_timeout, 0);
> +	o2net_set_nn_state(nn, NULL, 0, -ENOTCONN);
> +	spin_unlock(&nn->nn_lock);
> +}

o2net_set_nn_state() still has a queue_delayed_work() that the new flag
doesn't gate. So o2net_quiesce_nn() cancels nn_still_up and afterwards
calls o2net_set_nn_state(), which queues it again.

> +
>  /* again, o2nm_this_node() doesn't work here as we're involved in
>   * tearing it down */
>  void o2net_stop_listening(struct o2nm_node *node)
> @@ -2190,6 +2238,7 @@ void o2net_stop_listening(struct o2nm_node *node)
>  	BUG_ON(o2net_listen_sock == NULL);
>  
>  	WRITE_ONCE(o2net_listening, false);
> +	WRITE_ONCE(o2net_shutting_down, true);
>  	o2hb_synchronize_callbacks();
>  
>  	/* stop the listening socket from generating work */
> @@ -2200,15 +2249,18 @@ void o2net_stop_listening(struct o2nm_node *node)
>  
>  	for (i = 0; i < ARRAY_SIZE(o2net_nodes); i++) {
>  		struct o2nm_node *node = o2nm_get_node_by_num(i);
> +
>  		if (node) {
>  			o2net_disconnect_node(node);
>  			o2nm_node_put(node);
>  		}
> +		o2net_quiesce_nn(o2net_nn_from_num(i));

o2net_idle_timer() queues the same work from softirq with no nn_lock and no
flag check, sets nn_timeout back to 1, and re-arms sc_idle_timeout — which
quiesce never deletes.

Thanks,
Joseph

>  	}
>  
>  	/* finish all work and tear down the work queue */
>  	mlog(ML_KTHREAD, "waiting for o2net thread to exit....\n");
>  	o2net_destroy_wq();
> +	WRITE_ONCE(o2net_shutting_down, false);
>  
>  	sock_release(o2net_listen_sock);
>  	o2net_listen_sock = NULL;

