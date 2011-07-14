From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu, 14 Jul 2011 15:50:13 -0700
Subject: [Ocfs2-devel] [PATCH 02/16] ocfs2/cluster: Clean up messages in
	o2net
In-Reply-To: <1310683827-19157-1-git-send-email-sunil.mushran@oracle.com>
References: <1310683827-19157-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1310683827-19157-3-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

o2net messages needed a facelift.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/cluster/tcp.c |  119 +++++++++++++++++++++--------------------------
 1 files changed, 53 insertions(+), 66 deletions(-)

diff --git a/fs/ocfs2/cluster/tcp.c b/fs/ocfs2/cluster/tcp.c
index db5ee4b..6e97895 100644
--- a/fs/ocfs2/cluster/tcp.c
+++ b/fs/ocfs2/cluster/tcp.c
@@ -545,7 +545,7 @@ static void o2net_set_nn_state(struct o2net_node *nn,
 	}
 
 	if (was_valid && !valid) {
-		printk(KERN_NOTICE "o2net: no longer connected to "
+		printk(KERN_NOTICE "o2net: No longer connected to "
 		       SC_NODEF_FMT "\n", SC_NODEF_ARGS(old_sc));
 		o2net_complete_nodes_nsw(nn);
 	}
@@ -555,7 +555,7 @@ static void o2net_set_nn_state(struct o2net_node *nn,
 		cancel_delayed_work(&nn->nn_connect_expired);
 		printk(KERN_NOTICE "o2net: %s " SC_NODEF_FMT "\n",
 		       o2nm_this_node() > sc->sc_node->nd_num ?
-		       		"connected to" : "accepted connection from",
+		       "Connected to" : "Accepted connection from",
 		       SC_NODEF_ARGS(sc));
 	}
 
@@ -643,7 +643,7 @@ static void o2net_state_change(struct sock *sk)
 			o2net_sc_queue_work(sc, &sc->sc_connect_work);
 			break;
 		default:
-			printk(KERN_INFO "o2net: connection to " SC_NODEF_FMT
+			printk(KERN_INFO "o2net: Connection to " SC_NODEF_FMT
 			      " shutdown, state %d\n",
 			      SC_NODEF_ARGS(sc), sk->sk_state);
 			o2net_sc_queue_work(sc, &sc->sc_shutdown_work);
@@ -1284,11 +1284,11 @@ static int o2net_check_handshake(struct o2net_sock_container *sc)
 	struct o2net_node *nn = o2net_nn_from_num(sc->sc_node->nd_num);
 
 	if (hand->protocol_version != cpu_to_be64(O2NET_PROTOCOL_VERSION)) {
-		mlog(ML_NOTICE, SC_NODEF_FMT " advertised net protocol "
-		     "version %llu but %llu is required, disconnecting\n",
-		     SC_NODEF_ARGS(sc),
-		     (unsigned long long)be64_to_cpu(hand->protocol_version),
-		     O2NET_PROTOCOL_VERSION);
+		printk(KERN_NOTICE "o2net: " SC_NODEF_FMT " Advertised net "
+		       "protocol version %llu but %llu is required. "
+		       "Disconnecting.\n", SC_NODEF_ARGS(sc),
+		       (unsigned long long)be64_to_cpu(hand->protocol_version),
+		       O2NET_PROTOCOL_VERSION);
 
 		/* don't bother reconnecting if its the wrong version. */
 		o2net_ensure_shutdown(nn, sc, -ENOTCONN);
@@ -1302,33 +1302,33 @@ static int o2net_check_handshake(struct o2net_sock_container *sc)
 	 */
 	if (be32_to_cpu(hand->o2net_idle_timeout_ms) !=
 				o2net_idle_timeout()) {
-		mlog(ML_NOTICE, SC_NODEF_FMT " uses a network idle timeout of "
-		     "%u ms, but we use %u ms locally.  disconnecting\n",
-		     SC_NODEF_ARGS(sc),
-		     be32_to_cpu(hand->o2net_idle_timeout_ms),
-		     o2net_idle_timeout());
+		printk(KERN_NOTICE "o2net: " SC_NODEF_FMT " uses a network "
+		       "idle timeout of %u ms, but we use %u ms locally. "
+		       "Disconnecting.\n", SC_NODEF_ARGS(sc),
+		       be32_to_cpu(hand->o2net_idle_timeout_ms),
+		       o2net_idle_timeout());
 		o2net_ensure_shutdown(nn, sc, -ENOTCONN);
 		return -1;
 	}
 
 	if (be32_to_cpu(hand->o2net_keepalive_delay_ms) !=
 			o2net_keepalive_delay()) {
-		mlog(ML_NOTICE, SC_NODEF_FMT " uses a keepalive delay of "
-		     "%u ms, but we use %u ms locally.  disconnecting\n",
-		     SC_NODEF_ARGS(sc),
-		     be32_to_cpu(hand->o2net_keepalive_delay_ms),
-		     o2net_keepalive_delay());
+		printk(KERN_NOTICE "o2net: " SC_NODEF_FMT " uses a keepalive "
+		       "delay of %u ms, but we use %u ms locally. "
+		       "Disconnecting.\n", SC_NODEF_ARGS(sc),
+		       be32_to_cpu(hand->o2net_keepalive_delay_ms),
+		       o2net_keepalive_delay());
 		o2net_ensure_shutdown(nn, sc, -ENOTCONN);
 		return -1;
 	}
 
 	if (be32_to_cpu(hand->o2hb_heartbeat_timeout_ms) !=
 			O2HB_MAX_WRITE_TIMEOUT_MS) {
-		mlog(ML_NOTICE, SC_NODEF_FMT " uses a heartbeat timeout of "
-		     "%u ms, but we use %u ms locally.  disconnecting\n",
-		     SC_NODEF_ARGS(sc),
-		     be32_to_cpu(hand->o2hb_heartbeat_timeout_ms),
-		     O2HB_MAX_WRITE_TIMEOUT_MS);
+		printk(KERN_NOTICE "o2net: " SC_NODEF_FMT " uses a heartbeat "
+		       "timeout of %u ms, but we use %u ms locally. "
+		       "Disconnecting.\n", SC_NODEF_ARGS(sc),
+		       be32_to_cpu(hand->o2hb_heartbeat_timeout_ms),
+		       O2HB_MAX_WRITE_TIMEOUT_MS);
 		o2net_ensure_shutdown(nn, sc, -ENOTCONN);
 		return -1;
 	}
@@ -1539,28 +1539,16 @@ static void o2net_idle_timer(unsigned long data)
 {
 	struct o2net_sock_container *sc = (struct o2net_sock_container *)data;
 	struct o2net_node *nn = o2net_nn_from_num(sc->sc_node->nd_num);
-
 #ifdef CONFIG_DEBUG_FS
-	ktime_t now = ktime_get();
+	unsigned long msecs = ktime_to_ms(ktime_get()) -
+		ktime_to_ms(sc->sc_tv_timer);
+#else
+	unsigned long msecs = o2net_idle_timeout();
 #endif
 
-	printk(KERN_NOTICE "o2net: connection to " SC_NODEF_FMT " has been idle for %u.%u "
-	     "seconds, shutting it down.\n", SC_NODEF_ARGS(sc),
-		     o2net_idle_timeout() / 1000,
-		     o2net_idle_timeout() % 1000);
-
-#ifdef CONFIG_DEBUG_FS
-	mlog(ML_NOTICE, "Here are some times that might help debug the "
-	     "situation: (Timer: %lld, Now %lld, DataReady %lld, Advance %lld-%lld, "
-	     "Key 0x%08x, Func %u, FuncTime %lld-%lld)\n",
-	     (long long)ktime_to_us(sc->sc_tv_timer), (long long)ktime_to_us(now),
-	     (long long)ktime_to_us(sc->sc_tv_data_ready),
-	     (long long)ktime_to_us(sc->sc_tv_advance_start),
-	     (long long)ktime_to_us(sc->sc_tv_advance_stop),
-	     sc->sc_msg_key, sc->sc_msg_type,
-	     (long long)ktime_to_us(sc->sc_tv_func_start),
-	     (long long)ktime_to_us(sc->sc_tv_func_stop));
-#endif
+	printk(KERN_NOTICE "o2net: Connection to " SC_NODEF_FMT " has been "
+	       "idle for %lu.%lu secs, shutting it down.\n", SC_NODEF_ARGS(sc),
+	       msecs / 1000, msecs % 1000);
 
 	/*
 	 * Initialize the nn_timeout so that the next connection attempt
@@ -1693,8 +1681,8 @@ static void o2net_start_connect(struct work_struct *work)
 
 out:
 	if (ret) {
-		mlog(ML_NOTICE, "connect attempt to " SC_NODEF_FMT " failed "
-		     "with errno %d\n", SC_NODEF_ARGS(sc), ret);
+		printk(KERN_NOTICE "o2net: Connect attempt to " SC_NODEF_FMT
+		       " failed with errno %d\n", SC_NODEF_ARGS(sc), ret);
 		/* 0 err so that another will be queued and attempted
 		 * from set_nn_state */
 		if (sc)
@@ -1717,8 +1705,8 @@ static void o2net_connect_expired(struct work_struct *work)
 
 	spin_lock(&nn->nn_lock);
 	if (!nn->nn_sc_valid) {
-		mlog(ML_ERROR, "no connection established with node %u after "
-		     "%u.%u seconds, giving up and returning errors.\n",
+		printk(KERN_NOTICE "o2net: No connection established with "
+		       "node %u after %u.%u seconds, giving up.\n",
 		     o2net_num_from_nn(nn),
 		     o2net_idle_timeout() / 1000,
 		     o2net_idle_timeout() % 1000);
@@ -1861,21 +1849,21 @@ static int o2net_accept_one(struct socket *sock)
 
 	node = o2nm_get_node_by_ip(sin.sin_addr.s_addr);
 	if (node == NULL) {
-		mlog(ML_NOTICE, "attempt to connect from unknown node at %pI4:%d\n",
-		     &sin.sin_addr.s_addr, ntohs(sin.sin_port));
+		printk(KERN_NOTICE "o2net: Attempt to connect from unknown "
+		       "node at %pI4:%d\n", &sin.sin_addr.s_addr,
+		       ntohs(sin.sin_port));
 		ret = -EINVAL;
 		goto out;
 	}
 
 	if (o2nm_this_node() >= node->nd_num) {
 		local_node = o2nm_get_node_by_num(o2nm_this_node());
-		mlog(ML_NOTICE, "unexpected connect attempt seen at node '%s' ("
-		     "%u, %pI4:%d) from node '%s' (%u, %pI4:%d)\n",
-		     local_node->nd_name, local_node->nd_num,
-		     &(local_node->nd_ipv4_address),
-		     ntohs(local_node->nd_ipv4_port),
-		     node->nd_name, node->nd_num, &sin.sin_addr.s_addr,
-		     ntohs(sin.sin_port));
+		printk(KERN_NOTICE "o2net: Unexpected connect attempt seen "
+		       "at node '%s' (%u, %pI4:%d) from node '%s' (%u, "
+		       "%pI4:%d)\n", local_node->nd_name, local_node->nd_num,
+		       &(local_node->nd_ipv4_address),
+		       ntohs(local_node->nd_ipv4_port), node->nd_name,
+		       node->nd_num, &sin.sin_addr.s_addr, ntohs(sin.sin_port));
 		ret = -EINVAL;
 		goto out;
 	}
@@ -1900,10 +1888,10 @@ static int o2net_accept_one(struct socket *sock)
 		ret = 0;
 	spin_unlock(&nn->nn_lock);
 	if (ret) {
-		mlog(ML_NOTICE, "attempt to connect from node '%s' at "
-		     "%pI4:%d but it already has an open connection\n",
-		     node->nd_name, &sin.sin_addr.s_addr,
-		     ntohs(sin.sin_port));
+		printk(KERN_NOTICE "o2net: Attempt to connect from node '%s' "
+		       "at %pI4:%d but it already has an open connection\n",
+		       node->nd_name, &sin.sin_addr.s_addr,
+		       ntohs(sin.sin_port));
 		goto out;
 	}
 
@@ -1983,7 +1971,7 @@ static int o2net_open_listening_sock(__be32 addr, __be16 port)
 
 	ret = sock_create(PF_INET, SOCK_STREAM, IPPROTO_TCP, &sock);
 	if (ret < 0) {
-		mlog(ML_ERROR, "unable to create socket, ret=%d\n", ret);
+		printk(KERN_ERR "o2net: Error %d while creating socket\n", ret);
 		goto out;
 	}
 
@@ -2000,16 +1988,15 @@ static int o2net_open_listening_sock(__be32 addr, __be16 port)
 	sock->sk->sk_reuse = 1;
 	ret = sock->ops->bind(sock, (struct sockaddr *)&sin, sizeof(sin));
 	if (ret < 0) {
-		mlog(ML_ERROR, "unable to bind socket at %pI4:%u, "
-		     "ret=%d\n", &addr, ntohs(port), ret);
+		printk(KERN_ERR "o2net: Error %d while binding socket@"
+		       "%pI4:%u\n", ret, &addr, ntohs(port)); 
 		goto out;
 	}
 
 	ret = sock->ops->listen(sock, 64);
-	if (ret < 0) {
-		mlog(ML_ERROR, "unable to listen on %pI4:%u, ret=%d\n",
-		     &addr, ntohs(port), ret);
-	}
+	if (ret < 0)
+		printk(KERN_ERR "o2net: Error %d while listening on %pI4:%u\n",
+		       ret, &addr, ntohs(port));
 
 out:
 	if (ret) {
-- 
1.7.4.1
