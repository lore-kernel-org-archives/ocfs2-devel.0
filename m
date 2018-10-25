From: piaojun <piaojun@huawei.com>
Date: Thu, 25 Oct 2018 18:36:33 +0800
Subject: [Ocfs2-devel] [PATCH 5/5] ocfs2/cluster: modify socket container
 macro to adapt IPv6
Message-ID: <5BD19CB1.3070202@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

SC_NODEF_FMT, SC_NODEF_ARGS, SC_PRE_NODEF_ARGS only support IPv4. Add
SC_IPV6_NODEF_FMT, SC_IPV6_NODEF_ARGS, SC_IPV6_PRE_NODEF_ARGS to adapt
IPV6 node's log.

Signed-off-by: Jun Piao <piaojun@huawei.com>
---
 fs/ocfs2/cluster/tcp.c | 127 ++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 93 insertions(+), 34 deletions(-)

diff --git a/fs/ocfs2/cluster/tcp.c b/fs/ocfs2/cluster/tcp.c
index 31157a8..fcdfde7 100644
--- a/fs/ocfs2/cluster/tcp.c
+++ b/fs/ocfs2/cluster/tcp.c
@@ -79,6 +79,11 @@
 			  &sc->sc_node->nd_ipv4_address,		\
 			  ntohs(sc->sc_node->nd_ipv4_port)

+#define SC_IPV6_NODEF_FMT "node %s (num %u) at %pI6:%u"
+#define SC_IPV6_NODEF_ARGS(sc) sc->sc_node->nd_name, sc->sc_node->nd_num,	\
+			  sc->sc_node->nd_ipv6_address,		\
+			  ntohs(sc->sc_node->nd_ipv6_port)
+
 /*
  * In the following two log macros, the whitespace after the ',' just
  * before ##args is intentional. Otherwise, gcc 2.95 will eat the
@@ -542,19 +547,30 @@ static void o2net_set_nn_state(struct o2net_node *nn,
 	}

 	if (was_valid && !valid) {
-		if (old_sc)
-			printk(KERN_NOTICE "o2net: No longer connected to "
-				SC_NODEF_FMT "\n", SC_NODEF_ARGS(old_sc));
+		if (old_sc) {
+			if (old_sc->sc_node->nd_ipnet_type == IPV4_TYPE)
+				printk(KERN_NOTICE "o2net: No longer connected to "
+					SC_NODEF_FMT "\n", SC_NODEF_ARGS(old_sc));
+			else
+				printk(KERN_NOTICE "o2net: No longer connected to "
+					SC_IPV6_NODEF_FMT "\n", SC_IPV6_NODEF_ARGS(old_sc));
+		}
 		o2net_complete_nodes_nsw(nn);
 	}

 	if (!was_valid && valid) {
 		o2quo_conn_up(o2net_num_from_nn(nn));
 		cancel_delayed_work(&nn->nn_connect_expired);
-		printk(KERN_NOTICE "o2net: %s " SC_NODEF_FMT "\n",
-		       o2nm_this_node() > sc->sc_node->nd_num ?
-		       "Connected to" : "Accepted connection from",
-		       SC_NODEF_ARGS(sc));
+		if (sc->sc_node->nd_ipnet_type == IPV4_TYPE)
+			printk(KERN_NOTICE "o2net: %s " SC_NODEF_FMT "\n",
+			       o2nm_this_node() > sc->sc_node->nd_num ?
+			       "Connected to" : "Accepted connection from",
+			       SC_NODEF_ARGS(sc));
+		else
+			printk(KERN_NOTICE "o2net: %s " SC_IPV6_NODEF_FMT "\n",
+			       o2nm_this_node() > sc->sc_node->nd_num ?
+			       "Connected to" : "Accepted connection from",
+			       SC_IPV6_NODEF_ARGS(sc));
 	}

 	/* trigger the connecting worker func as long as we're not valid,
@@ -642,9 +658,14 @@ static void o2net_state_change(struct sock *sk)
 		o2net_sc_queue_work(sc, &sc->sc_connect_work);
 		break;
 	default:
-		printk(KERN_INFO "o2net: Connection to " SC_NODEF_FMT
-			" shutdown, state %d\n",
-			SC_NODEF_ARGS(sc), sk->sk_state);
+		if (sc->sc_node->nd_ipnet_type == IPV4_TYPE)
+			printk(KERN_INFO "o2net: Connection to " SC_NODEF_FMT
+				" shutdown, state %d\n",
+				SC_NODEF_ARGS(sc), sk->sk_state);
+		else
+			printk(KERN_INFO "o2net: Connection to " SC_IPV6_NODEF_FMT
+				" shutdown, state %d\n",
+				SC_IPV6_NODEF_ARGS(sc), sk->sk_state);
 		o2net_sc_queue_work(sc, &sc->sc_shutdown_work);
 		break;
 	}
@@ -961,13 +982,21 @@ static void o2net_sendpage(struct o2net_sock_container *sc,
 		if (ret == size)
 			break;
 		if (ret == (ssize_t)-EAGAIN) {
-			mlog(0, "sendpage of size %zu to " SC_NODEF_FMT
-			     " returned EAGAIN\n", size, SC_NODEF_ARGS(sc));
+			if (sc->sc_node->nd_ipnet_type == IPV4_TYPE)
+				mlog(0, "sendpage of size %zu to " SC_NODEF_FMT
+				     " returned EAGAIN\n", size, SC_NODEF_ARGS(sc));
+			else
+				mlog(0, "sendpage of size %zu to " SC_IPV6_NODEF_FMT
+				     " returned EAGAIN\n", size, SC_IPV6_NODEF_ARGS(sc));
 			cond_resched();
 			continue;
 		}
-		mlog(ML_ERROR, "sendpage of size %zu to " SC_NODEF_FMT
-		     " failed with %zd\n", size, SC_NODEF_ARGS(sc), ret);
+		if (sc->sc_node->nd_ipnet_type == IPV4_TYPE)
+			mlog(ML_ERROR, "sendpage of size %zu to " SC_NODEF_FMT
+			     " failed with %zd\n", size, SC_NODEF_ARGS(sc), ret);
+		else
+			mlog(ML_ERROR, "sendpage of size %zu to " SC_IPV6_NODEF_FMT
+			     " failed with %zd\n", size, SC_IPV6_NODEF_ARGS(sc), ret);
 		o2net_ensure_shutdown(nn, sc, 0);
 		break;
 	}
@@ -1275,11 +1304,18 @@ static int o2net_check_handshake(struct o2net_sock_container *sc)
 	struct o2net_node *nn = o2net_nn_from_num(sc->sc_node->nd_num);

 	if (hand->protocol_version != cpu_to_be64(O2NET_PROTOCOL_VERSION)) {
-		printk(KERN_NOTICE "o2net: " SC_NODEF_FMT " Advertised net "
-		       "protocol version %llu but %llu is required. "
-		       "Disconnecting.\n", SC_NODEF_ARGS(sc),
-		       (unsigned long long)be64_to_cpu(hand->protocol_version),
-		       O2NET_PROTOCOL_VERSION);
+		if (sc->sc_node->nd_ipnet_type == IPV4_TYPE)
+			printk(KERN_NOTICE "o2net: " SC_NODEF_FMT " Advertised net "
+			       "protocol version %llu but %llu is required. "
+			       "Disconnecting.\n", SC_NODEF_ARGS(sc),
+			       (unsigned long long)be64_to_cpu(hand->protocol_version),
+			       O2NET_PROTOCOL_VERSION);
+		else
+			printk(KERN_NOTICE "o2net: " SC_IPV6_NODEF_FMT " Advertised net "
+			       "protocol version %llu but %llu is required. "
+			       "Disconnecting.\n", SC_IPV6_NODEF_ARGS(sc),
+			       (unsigned long long)be64_to_cpu(hand->protocol_version),
+			       O2NET_PROTOCOL_VERSION);

 		/* don't bother reconnecting if its the wrong version. */
 		o2net_ensure_shutdown(nn, sc, -ENOTCONN);
@@ -1293,22 +1329,36 @@ static int o2net_check_handshake(struct o2net_sock_container *sc)
 	 */
 	if (be32_to_cpu(hand->o2net_idle_timeout_ms) !=
 				o2net_idle_timeout()) {
-		printk(KERN_NOTICE "o2net: " SC_NODEF_FMT " uses a network "
-		       "idle timeout of %u ms, but we use %u ms locally. "
-		       "Disconnecting.\n", SC_NODEF_ARGS(sc),
-		       be32_to_cpu(hand->o2net_idle_timeout_ms),
-		       o2net_idle_timeout());
+		if (sc->sc_node->nd_ipnet_type == IPV4_TYPE)
+			printk(KERN_NOTICE "o2net: " SC_NODEF_FMT " uses a network "
+			       "idle timeout of %u ms, but we use %u ms locally. "
+			       "Disconnecting.\n", SC_NODEF_ARGS(sc),
+			       be32_to_cpu(hand->o2net_idle_timeout_ms),
+			       o2net_idle_timeout());
+		else
+			printk(KERN_NOTICE "o2net: " SC_IPV6_NODEF_FMT " uses a network "
+			       "idle timeout of %u ms, but we use %u ms locally. "
+			       "Disconnecting.\n", SC_IPV6_NODEF_ARGS(sc),
+			       be32_to_cpu(hand->o2net_idle_timeout_ms),
+			       o2net_idle_timeout());
 		o2net_ensure_shutdown(nn, sc, -ENOTCONN);
 		return -1;
 	}

 	if (be32_to_cpu(hand->o2net_keepalive_delay_ms) !=
 			o2net_keepalive_delay()) {
-		printk(KERN_NOTICE "o2net: " SC_NODEF_FMT " uses a keepalive "
-		       "delay of %u ms, but we use %u ms locally. "
-		       "Disconnecting.\n", SC_NODEF_ARGS(sc),
-		       be32_to_cpu(hand->o2net_keepalive_delay_ms),
-		       o2net_keepalive_delay());
+		if (sc->sc_node->nd_ipnet_type == IPV4_TYPE)
+			printk(KERN_NOTICE "o2net: " SC_NODEF_FMT " uses a keepalive "
+			       "delay of %u ms, but we use %u ms locally. "
+			       "Disconnecting.\n", SC_NODEF_ARGS(sc),
+			       be32_to_cpu(hand->o2net_keepalive_delay_ms),
+			       o2net_keepalive_delay());
+		else
+			printk(KERN_NOTICE "o2net: " SC_IPV6_NODEF_FMT " uses a keepalive "
+			       "delay of %u ms, but we use %u ms locally. "
+			       "Disconnecting.\n", SC_IPV6_NODEF_ARGS(sc),
+			       be32_to_cpu(hand->o2net_keepalive_delay_ms),
+			       o2net_keepalive_delay());
 		o2net_ensure_shutdown(nn, sc, -ENOTCONN);
 		return -1;
 	}
@@ -1528,9 +1578,14 @@ static void o2net_idle_timer(struct timer_list *t)
 	unsigned long msecs = o2net_idle_timeout();
 #endif

-	printk(KERN_NOTICE "o2net: Connection to " SC_NODEF_FMT " has been "
-	       "idle for %lu.%lu secs.\n",
-	       SC_NODEF_ARGS(sc), msecs / 1000, msecs % 1000);
+	if (sc->sc_node->nd_ipnet_type == IPV4_TYPE)
+		printk(KERN_NOTICE "o2net: Connection to " SC_NODEF_FMT " has been "
+		       "idle for %lu.%lu secs.\n",
+		       SC_NODEF_ARGS(sc), msecs / 1000, msecs % 1000);
+	else
+		printk(KERN_NOTICE "o2net: Connection to " SC_IPV6_NODEF_FMT " has been "
+		       "idle for %lu.%lu secs.\n",
+		       SC_IPV6_NODEF_ARGS(sc), msecs / 1000, msecs % 1000);

 	/* idle timerout happen, don't shutdown the connection, but
 	 * make fence decision. Maybe the connection can recover before
@@ -1710,8 +1765,12 @@ static void o2net_start_connect(struct work_struct *work)

 out:
 	if (ret && sc) {
-		printk(KERN_NOTICE "o2net: Connect attempt to " SC_NODEF_FMT
-		       " failed with errno %d\n", SC_NODEF_ARGS(sc), ret);
+		if (sc->sc_node->nd_ipnet_type == IPV4_TYPE)
+			printk(KERN_NOTICE "o2net: Connect attempt to " SC_NODEF_FMT
+			       " failed with errno %d\n", SC_NODEF_ARGS(sc), ret);
+		else
+			printk(KERN_NOTICE "o2net: Connect attempt to " SC_IPV6_NODEF_FMT
+			       " failed with errno %d\n", SC_IPV6_NODEF_ARGS(sc), ret);
 		/* 0 err so that another will be queued and attempted
 		 * from set_nn_state */
 		o2net_ensure_shutdown(nn, sc, 0);
-- 
