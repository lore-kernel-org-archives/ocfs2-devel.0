Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B91B363CF
	for <ocfs2-devel@lists.linux.dev>; Sat,  8 Jun 2024 01:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.113
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717809803; cv=none; b=Wx1HlOUK3ER5J7icXXFbgiX9d+IBnrE4nbMD9u5Dnwaci2h2iGMwPabJ3Uu9EZ/pqTNrlE0zHkwxZ3e4IqwtO6GWZhK+zb5DDC9BMKNS6u3UK/fKVgJLEMdVaNvnNHwapaMRx7EG9CceDkgv/2kBzGcUSc4GIIMc1iTCFhE9/CE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717809803; c=relaxed/simple;
	bh=usmFjaj7bgudJsgMiS5ptxznzZ6dZf47CM2AvCQH8eQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hT/O1tMrmLFJ3KEJHjgrnImRSd0gT0ycXFoHfLOz3YlrKjnszUnWMzWO96khCjvsGJsQD42CnG9C03O9y+WX4UNpJ6tf8boezy33QdrT3ExSg8qd+OiahekuZoaRpilXiB1Rt53MSux/Hi36lH+vEJjPFy7cL2mjDr3UERX/8CQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=o/HjkUlE; arc=none smtp.client-ip=115.124.30.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="o/HjkUlE"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1717809797; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=R6nt7yUK35vsFklJDNutkBwOnv/Drw8k6tMBrEt6hsc=;
	b=o/HjkUlE971gtRLH9bqc1Le+pi3dTT6wCHEFn/HXT5Q4Hs1JVS9n676iQ/DRTrLTQMQb9EXlVo6BbhMiH3yqdCuzKdK8URGgKjzI+U4no/X1H0cVpm+OQSHS7bHv29umdjpkcJfpQ/NoyQwy/04x1bMtv8li88aQyIUIspGrqC4=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045075189;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0W80E1-B_1717809794;
Received: from 30.120.131.238(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0W80E1-B_1717809794)
          by smtp.aliyun-inc.com;
          Sat, 08 Jun 2024 09:23:15 +0800
Message-ID: <b05975f7-aa8a-420a-b639-8650480cc834@linux.alibaba.com>
Date: Sat, 8 Jun 2024 09:23:14 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: convert to pr_fmt
To: Longlong Xia <xialonglong@kylinos.cn>, mark@fasheh.com
Cc: jlbec@evilplan.org, ocfs2-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org
References: <20240606022823.1296737-1-xialonglong@kylinos.cn>
Content-Language: en-US
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20240606022823.1296737-1-xialonglong@kylinos.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Basically I have no objection to do this convert.
But if we do this in cluster/tcp.c, while leave others unchanged, then
it looks inconsistent for the whole ocfs2 code.

Thanks,
Joseph

On 6/6/24 10:28 AM, Longlong Xia wrote:
> Use the pr_fmt() macro to prefix all the output with "o2net: ".
> while at it, convert printk(<LEVEL>) to pr_<level>().
> 
> Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>
> ---
>  fs/ocfs2/cluster/tcp.c | 109 ++++++++++++++++++-----------------------
>  1 file changed, 49 insertions(+), 60 deletions(-)
> 
> diff --git a/fs/ocfs2/cluster/tcp.c b/fs/ocfs2/cluster/tcp.c
> index 2b8fa3e782fb..fc483c7c4fb4 100644
> --- a/fs/ocfs2/cluster/tcp.c
> +++ b/fs/ocfs2/cluster/tcp.c
> @@ -37,6 +37,8 @@
>   * and only accepts the connection if the higher numbered node is heartbeating.
>   */
>  
> +#define pr_fmt(fmt) "o2net: " fmt
> +
>  #include <linux/kernel.h>
>  #include <linux/sched/mm.h>
>  #include <linux/jiffies.h>
> @@ -528,18 +530,16 @@ static void o2net_set_nn_state(struct o2net_node *nn,
>  
>  	if (was_valid && !valid) {
>  		if (old_sc)
> -			printk(KERN_NOTICE "o2net: No longer connected to "
> -				SC_NODEF_FMT "\n", SC_NODEF_ARGS(old_sc));
> +			pr_notice("No longer connected to " SC_NODEF_FMT "\n",
> +				  SC_NODEF_ARGS(old_sc));
>  		o2net_complete_nodes_nsw(nn);
>  	}
>  
>  	if (!was_valid && valid) {
>  		o2quo_conn_up(o2net_num_from_nn(nn));
>  		cancel_delayed_work(&nn->nn_connect_expired);
> -		printk(KERN_NOTICE "o2net: %s " SC_NODEF_FMT "\n",
> -		       o2nm_this_node() > sc->sc_node->nd_num ?
> -		       "Connected to" : "Accepted connection from",
> -		       SC_NODEF_ARGS(sc));
> +		pr_notice("%s " SC_NODEF_FMT "\n", o2nm_this_node() > sc->sc_node->nd_num ?
> +			  "Connected to" : "Accepted connection from", SC_NODEF_ARGS(sc));
>  	}
>  
>  	/* trigger the connecting worker func as long as we're not valid,
> @@ -629,9 +629,8 @@ static void o2net_state_change(struct sock *sk)
>  		o2net_sc_queue_work(sc, &sc->sc_connect_work);
>  		break;
>  	default:
> -		printk(KERN_INFO "o2net: Connection to " SC_NODEF_FMT
> -			" shutdown, state %d\n",
> -			SC_NODEF_ARGS(sc), sk->sk_state);
> +		pr_notice("Connection to " SC_NODEF_FMT " shutdown, state %d\n",
> +			  SC_NODEF_ARGS(sc), sk->sk_state);
>  		o2net_sc_queue_work(sc, &sc->sc_shutdown_work);
>  		break;
>  	}
> @@ -1260,11 +1259,10 @@ static int o2net_check_handshake(struct o2net_sock_container *sc)
>  	struct o2net_node *nn = o2net_nn_from_num(sc->sc_node->nd_num);
>  
>  	if (hand->protocol_version != cpu_to_be64(O2NET_PROTOCOL_VERSION)) {
> -		printk(KERN_NOTICE "o2net: " SC_NODEF_FMT " Advertised net "
> -		       "protocol version %llu but %llu is required. "
> -		       "Disconnecting.\n", SC_NODEF_ARGS(sc),
> -		       (unsigned long long)be64_to_cpu(hand->protocol_version),
> -		       O2NET_PROTOCOL_VERSION);
> +		pr_notice(SC_NODEF_FMT " Advertised net protocol version %llu but %llu is required. Disconnecting.\n",
> +			SC_NODEF_ARGS(sc),
> +			(unsigned long long)be64_to_cpu(hand->protocol_version),
> +			O2NET_PROTOCOL_VERSION);
>  
>  		/* don't bother reconnecting if its the wrong version. */
>  		o2net_ensure_shutdown(nn, sc, -ENOTCONN);
> @@ -1278,33 +1276,30 @@ static int o2net_check_handshake(struct o2net_sock_container *sc)
>  	 */
>  	if (be32_to_cpu(hand->o2net_idle_timeout_ms) !=
>  				o2net_idle_timeout()) {
> -		printk(KERN_NOTICE "o2net: " SC_NODEF_FMT " uses a network "
> -		       "idle timeout of %u ms, but we use %u ms locally. "
> -		       "Disconnecting.\n", SC_NODEF_ARGS(sc),
> -		       be32_to_cpu(hand->o2net_idle_timeout_ms),
> -		       o2net_idle_timeout());
> +		pr_notice(SC_NODEF_FMT " uses a network idle timeout of %u ms, but we use %u ms locally. Disconnecting.\n",
> +			  SC_NODEF_ARGS(sc),
> +			  be32_to_cpu(hand->o2net_idle_timeout_ms),
> +			  o2net_idle_timeout());
>  		o2net_ensure_shutdown(nn, sc, -ENOTCONN);
>  		return -1;
>  	}
>  
>  	if (be32_to_cpu(hand->o2net_keepalive_delay_ms) !=
>  			o2net_keepalive_delay()) {
> -		printk(KERN_NOTICE "o2net: " SC_NODEF_FMT " uses a keepalive "
> -		       "delay of %u ms, but we use %u ms locally. "
> -		       "Disconnecting.\n", SC_NODEF_ARGS(sc),
> -		       be32_to_cpu(hand->o2net_keepalive_delay_ms),
> -		       o2net_keepalive_delay());
> +		pr_notice(SC_NODEF_FMT " uses a keepalive delay of %u ms, but we use %u ms locally. Disconnecting.\n",
> +			  SC_NODEF_ARGS(sc),
> +			  be32_to_cpu(hand->o2net_keepalive_delay_ms),
> +			  o2net_keepalive_delay());
>  		o2net_ensure_shutdown(nn, sc, -ENOTCONN);
>  		return -1;
>  	}
>  
>  	if (be32_to_cpu(hand->o2hb_heartbeat_timeout_ms) !=
>  			O2HB_MAX_WRITE_TIMEOUT_MS) {
> -		printk(KERN_NOTICE "o2net: " SC_NODEF_FMT " uses a heartbeat "
> -		       "timeout of %u ms, but we use %u ms locally. "
> -		       "Disconnecting.\n", SC_NODEF_ARGS(sc),
> -		       be32_to_cpu(hand->o2hb_heartbeat_timeout_ms),
> -		       O2HB_MAX_WRITE_TIMEOUT_MS);
> +		pr_notice(SC_NODEF_FMT " uses a heartbeat timeout of %u ms, but we use %u ms locally. Disconnecting.\n",
> +			  SC_NODEF_ARGS(sc),
> +			  be32_to_cpu(hand->o2hb_heartbeat_timeout_ms),
> +			  O2HB_MAX_WRITE_TIMEOUT_MS);
>  		o2net_ensure_shutdown(nn, sc, -ENOTCONN);
>  		return -1;
>  	}
> @@ -1497,9 +1492,8 @@ static void o2net_idle_timer(struct timer_list *t)
>  	unsigned long msecs = o2net_idle_timeout();
>  #endif
>  
> -	printk(KERN_NOTICE "o2net: Connection to " SC_NODEF_FMT " has been "
> -	       "idle for %lu.%lu secs.\n",
> -	       SC_NODEF_ARGS(sc), msecs / 1000, msecs % 1000);
> +	pr_notice("Connection to " SC_NODEF_FMT " has been idle for %lu.%lu secs.\n",
> +		  SC_NODEF_ARGS(sc), msecs / 1000, msecs % 1000);
>  
>  	/* idle timerout happen, don't shutdown the connection, but
>  	 * make fence decision. Maybe the connection can recover before
> @@ -1645,8 +1639,8 @@ static void o2net_start_connect(struct work_struct *work)
>  
>  out:
>  	if (ret && sc) {
> -		printk(KERN_NOTICE "o2net: Connect attempt to " SC_NODEF_FMT
> -		       " failed with errno %d\n", SC_NODEF_ARGS(sc), ret);
> +		pr_notice("Connect attempt to " SC_NODEF_FMT " failed with errno %d\n",
> +			  SC_NODEF_ARGS(sc), ret);
>  		/* 0 err so that another will be queued and attempted
>  		 * from set_nn_state */
>  		o2net_ensure_shutdown(nn, sc, 0);
> @@ -1669,12 +1663,10 @@ static void o2net_connect_expired(struct work_struct *work)
>  
>  	spin_lock(&nn->nn_lock);
>  	if (!nn->nn_sc_valid) {
> -		printk(KERN_NOTICE "o2net: No connection established with "
> -		       "node %u after %u.%u seconds, check network and"
> -		       " cluster configuration.\n",
> -		     o2net_num_from_nn(nn),
> -		     o2net_idle_timeout() / 1000,
> -		     o2net_idle_timeout() % 1000);
> +		pr_notice("No connection established with node %u after %u.%u seconds, check network and cluster configuration.\n",
> +			  o2net_num_from_nn(nn),
> +			  o2net_idle_timeout() / 1000,
> +			  o2net_idle_timeout() % 1000);
>  
>  		o2net_set_nn_state(nn, NULL, 0, 0);
>  	}
> @@ -1821,9 +1813,9 @@ static int o2net_accept_one(struct socket *sock, int *more)
>  
>  	node = o2nm_get_node_by_ip(sin.sin_addr.s_addr);
>  	if (node == NULL) {
> -		printk(KERN_NOTICE "o2net: Attempt to connect from unknown "
> -		       "node at %pI4:%d\n", &sin.sin_addr.s_addr,
> -		       ntohs(sin.sin_port));
> +		pr_notice("Attempt to connect from unknown node at %pI4:%d\n",
> +			  &sin.sin_addr.s_addr,
> +			  ntohs(sin.sin_port));
>  		ret = -EINVAL;
>  		goto out;
>  	}
> @@ -1831,15 +1823,13 @@ static int o2net_accept_one(struct socket *sock, int *more)
>  	if (o2nm_this_node() >= node->nd_num) {
>  		local_node = o2nm_get_node_by_num(o2nm_this_node());
>  		if (local_node)
> -			printk(KERN_NOTICE "o2net: Unexpected connect attempt "
> -					"seen at node '%s' (%u, %pI4:%d) from "
> -					"node '%s' (%u, %pI4:%d)\n",
> -					local_node->nd_name, local_node->nd_num,
> -					&(local_node->nd_ipv4_address),
> -					ntohs(local_node->nd_ipv4_port),
> -					node->nd_name,
> -					node->nd_num, &sin.sin_addr.s_addr,
> -					ntohs(sin.sin_port));
> +			pr_notice("Unexpected connect attempt seen at node '%s' (%u, %pI4:%d) from node '%s' (%u, %pI4:%d)\n",
> +				  local_node->nd_name, local_node->nd_num,
> +				  &(local_node->nd_ipv4_address),
> +				  ntohs(local_node->nd_ipv4_port),
> +				  node->nd_name,
> +				  node->nd_num, &sin.sin_addr.s_addr,
> +				  ntohs(sin.sin_port));
>  		ret = -EINVAL;
>  		goto out;
>  	}
> @@ -1864,10 +1854,9 @@ static int o2net_accept_one(struct socket *sock, int *more)
>  		ret = 0;
>  	spin_unlock(&nn->nn_lock);
>  	if (ret) {
> -		printk(KERN_NOTICE "o2net: Attempt to connect from node '%s' "
> -		       "at %pI4:%d but it already has an open connection\n",
> -		       node->nd_name, &sin.sin_addr.s_addr,
> -		       ntohs(sin.sin_port));
> +		pr_notice("Attempt to connect from node '%s' at %pI4:%d but it already has an open connection\n",
> +			  node->nd_name, &sin.sin_addr.s_addr,
> +			  ntohs(sin.sin_port));
>  		goto out;
>  	}
>  
> @@ -1986,7 +1975,7 @@ static int o2net_open_listening_sock(__be32 addr, __be16 port)
>  
>  	ret = sock_create(PF_INET, SOCK_STREAM, IPPROTO_TCP, &sock);
>  	if (ret < 0) {
> -		printk(KERN_ERR "o2net: Error %d while creating socket\n", ret);
> +		pr_err("Error %d while creating socket\n", ret);
>  		goto out;
>  	}
>  
> @@ -2003,14 +1992,14 @@ static int o2net_open_listening_sock(__be32 addr, __be16 port)
>  	sock->sk->sk_reuse = SK_CAN_REUSE;
>  	ret = sock->ops->bind(sock, (struct sockaddr *)&sin, sizeof(sin));
>  	if (ret < 0) {
> -		printk(KERN_ERR "o2net: Error %d while binding socket at "
> -		       "%pI4:%u\n", ret, &addr, ntohs(port)); 
> +		pr_err("Error %d while binding socket at %pI4:%u\n",
> +		       ret, &addr, ntohs(port));
>  		goto out;
>  	}
>  
>  	ret = sock->ops->listen(sock, 64);
>  	if (ret < 0)
> -		printk(KERN_ERR "o2net: Error %d while listening on %pI4:%u\n",
> +		pr_err("Error %d while listening on %pI4:%u\n",
>  		       ret, &addr, ntohs(port));
>  
>  out:
