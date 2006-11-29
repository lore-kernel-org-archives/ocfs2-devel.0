From: abeekhof@suse.de <abeekhof@suse.de>
Date: Wed Nov 29 01:04:42 2006
Subject: [Ocfs2-devel] [patch 1/1] ocfs2-timeout-protocol.patch
References: <20061129085130.004252000@suse.de>
Message-ID: <20061129090355.473139000@suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


From: Andrew Beekhof <abeekhof@suse.de>
Subject: [patch 1/1] OCFS2 Configurable timeouts - Protocol changes

Modify the OCFS2 handshake to ensure essential timeouts are configured
  identically on all nodes.
Only allow changes when there are no connected peers
Improves the logic in o2net_advance_rx() which broke now that
  sizeof(struct o2net_handshake) is greater than sizeof(struct o2net_msg)
Included is the field for userspace-heartbeat timeout to avoid the need for
  further protocol changes.
Uses a global spinlock to ensure the decisions to update configfs entries
  are made on the correct value.  The region covered by the spinlock when
  incrimenting the counter is much larger as this is the more critical case.

Signed-off-by: Andrew Beekhof <abeekhof@suse.de>
---
 fs/ocfs2/cluster/nodemanager.c  |   19 +++++++
 fs/ocfs2/cluster/tcp.c          |   96 +++++++++++++++++++++++++++++++++++-----
 fs/ocfs2/cluster/tcp.h          |    1
 fs/ocfs2/cluster/nodemanager.c  |   55 ++++++++++++++------
 fs/ocfs2/cluster/tcp.c          |  105 +++++++++++++++++++++++++++++++++++-----
 fs/ocfs2/cluster/tcp.h          |    2 
 fs/ocfs2/cluster/tcp_internal.h |    6 +-
 4 files changed, 139 insertions(+), 29 deletions(-)




Index: fs/ocfs2/cluster/nodemanager.c
===================================================================
--- fs/ocfs2/cluster/nodemanager.c.orig	2006-11-20 16:25:58.000000000 +0100
+++ fs/ocfs2/cluster/nodemanager.c	2006-11-27 09:57:56.000000000 +0100
@@ -558,15 +558,14 @@ static ssize_t o2nm_cluster_attr_write(c
 	return count;
 }
 
-static ssize_t o2nm_cluster_attr_idle_timeout_ms_read(struct o2nm_cluster *cluster,
-                                                 char *page)
+static ssize_t o2nm_cluster_attr_idle_timeout_ms_read(
+	struct o2nm_cluster *cluster, char *page)
 {
 	return sprintf(page, "%u\n", cluster->cl_idle_timeout_ms);
 }
 
-static ssize_t o2nm_cluster_attr_idle_timeout_ms_write(struct o2nm_cluster *cluster,
-                                                  const char *page,
-						  size_t count)
+static ssize_t o2nm_cluster_attr_idle_timeout_ms_write(
+	struct o2nm_cluster *cluster, const char *page, size_t count)
 {
 	ssize_t ret;
 	unsigned int val;
@@ -574,10 +573,22 @@ static ssize_t o2nm_cluster_attr_idle_ti
 	ret =  o2nm_cluster_attr_write(page, count, &val);
 
 	if (ret > 0) {
+		if (cluster->cl_idle_timeout_ms != val) {
+			spin_lock(&connected_lock);
+			if(o2net_num_connected_peers()) {
+				mlog(ML_NOTICE,
+				     "o2net: cannot change idle timeout after "
+				     "the first peer has agreed to it."
+				     "  %d connected peers\n",
+				     o2net_num_connected_peers());
+				ret = -EINVAL;
+			}
+			spin_unlock(&connected_lock);
+		}
 		if (val <= cluster->cl_keepalive_delay_ms) {
 			mlog(ML_NOTICE, "o2net: idle timeout must be larger "
 			     "than keepalive delay\n");
-			return -EINVAL;
+			ret = -EINVAL;
 		}
 		cluster->cl_idle_timeout_ms = val;
 	}
@@ -585,15 +596,14 @@ static ssize_t o2nm_cluster_attr_idle_ti
 	return ret;
 }
 
-static ssize_t o2nm_cluster_attr_keepalive_delay_ms_read(struct o2nm_cluster *cluster,
-                                                 char *page)
+static ssize_t o2nm_cluster_attr_keepalive_delay_ms_read(
+	struct o2nm_cluster *cluster, char *page)
 {
 	return sprintf(page, "%u\n", cluster->cl_keepalive_delay_ms);
 }
 
-static ssize_t o2nm_cluster_attr_keepalive_delay_ms_write(struct o2nm_cluster *cluster,
-                                                  const char *page,
-						  size_t count)
+static ssize_t o2nm_cluster_attr_keepalive_delay_ms_write(
+	struct o2nm_cluster *cluster, const char *page, size_t count)
 {
 	ssize_t ret;
 	unsigned int val;
@@ -601,10 +611,22 @@ static ssize_t o2nm_cluster_attr_keepali
 	ret =  o2nm_cluster_attr_write(page, count, &val);
 
 	if (ret > 0) {
+		if (cluster->cl_keepalive_delay_ms != val) {
+			spin_lock(&connected_lock);
+			if(o2net_num_connected_peers()) {
+				mlog(ML_NOTICE,
+				     "o2net: cannot change keepalive delay after"
+				     " the first peer has agreed to it."
+				     "  %d connected peers\n",
+				     o2net_num_connected_peers());
+				ret = -EINVAL;
+			}
+			spin_unlock(&connected_lock);
+		}
 		if (val >= cluster->cl_idle_timeout_ms) {
 			mlog(ML_NOTICE, "o2net: keepalive delay must be "
 			     "smaller than idle timeout\n");
-			return -EINVAL;
+			ret = -EINVAL;
 		}
 		cluster->cl_keepalive_delay_ms = val;
 	}
@@ -612,15 +634,14 @@ static ssize_t o2nm_cluster_attr_keepali
 	return ret;
 }
 
-static ssize_t o2nm_cluster_attr_reconnect_delay_ms_read(struct o2nm_cluster *cluster,
-                                                 char *page)
+static ssize_t o2nm_cluster_attr_reconnect_delay_ms_read(
+	struct o2nm_cluster *cluster, char *page)
 {
 	return sprintf(page, "%u\n", cluster->cl_reconnect_delay_ms);
 }
 
-static ssize_t o2nm_cluster_attr_reconnect_delay_ms_write(struct o2nm_cluster *cluster,
-                                                  const char *page,
-						  size_t count)
+static ssize_t o2nm_cluster_attr_reconnect_delay_ms_write(
+	struct o2nm_cluster *cluster, const char *page, size_t count)
 {
 	return o2nm_cluster_attr_write(page, count,
 	                               &cluster->cl_reconnect_delay_ms);
Index: fs/ocfs2/cluster/tcp.c
===================================================================
--- fs/ocfs2/cluster/tcp.c.orig	2006-11-20 16:19:12.000000000 +0100
+++ fs/ocfs2/cluster/tcp.c	2006-11-27 10:41:20.000000000 +0100
@@ -1121,6 +1121,44 @@ static int o2net_check_handshake(struct 
 		return -1;
 	}
 
+	/*
+	 * Ensure timeouts are consistent with other nodes, otherwise
+	 * we can end up with one node thinking that the other must be down,
+	 * but isn't. This can ultimately cause corruption.
+	 */
+	if (be32_to_cpu(hand->o2net_idle_timeout_ms) !=
+				o2net_idle_timeout(sc->sc_node)) {
+		mlog(ML_NOTICE, SC_NODEF_FMT " uses a network idle timeout of "
+		     "%u ms, but we use %u ms locally.  disconnecting\n",
+		     SC_NODEF_ARGS(sc),
+		     be32_to_cpu(hand->o2net_idle_timeout_ms),
+		     o2net_idle_timeout(sc->sc_node));
+		o2net_ensure_shutdown(nn, sc, -ENOTCONN);
+		return -1;
+	}
+
+	if (be32_to_cpu(hand->o2net_keepalive_delay_ms) !=
+			o2net_keepalive_delay(sc->sc_node)) {
+		mlog(ML_NOTICE, SC_NODEF_FMT " uses a keepalive delay of "
+		     "%u ms, but we use %u ms locally.  disconnecting\n",
+		     SC_NODEF_ARGS(sc),
+		     be32_to_cpu(hand->o2net_keepalive_delay_ms),
+		     o2net_keepalive_delay(sc->sc_node));
+		o2net_ensure_shutdown(nn, sc, -ENOTCONN);
+		return -1;
+	}
+
+	if (be32_to_cpu(hand->o2hb_heartbeat_timeout_ms) !=
+			O2HB_MAX_WRITE_TIMEOUT_MS) {
+		mlog(ML_NOTICE, SC_NODEF_FMT " uses a heartbeat timeout of "
+		     "%u ms, but we use %u ms locally.  disconnecting\n",
+		     SC_NODEF_ARGS(sc),
+		     be32_to_cpu(hand->o2net_keepalive_delay_ms),
+		     O2HB_MAX_WRITE_TIMEOUT_MS);
+		o2net_ensure_shutdown(nn, sc, -ENOTCONN);
+		return -1;
+	}
+
 	sc->sc_handshake_ok = 1;
 
 	spin_lock(&nn->nn_lock);
@@ -1153,6 +1191,26 @@ static int o2net_advance_rx(struct o2net
 	sclog(sc, "receiving\n");
 	do_gettimeofday(&sc->sc_tv_advance_start);
 
+	if(unlikely(sc->sc_handshake_ok == 0)) {
+		if(sc->sc_page_off < sizeof(struct o2net_handshake)) {
+			data = page_address(sc->sc_page) + sc->sc_page_off;
+			datalen = sizeof(struct o2net_handshake) - sc->sc_page_off;
+			ret = o2net_recv_tcp_msg(sc->sc_sock, data, datalen);
+			if (ret > 0)
+				sc->sc_page_off += ret;
+		}
+
+		if (sc->sc_page_off == sizeof(struct o2net_handshake)) {
+			o2net_check_handshake(sc);
+			if(sc->sc_handshake_ok == 0) {
+				BUG_ON(sizeof(struct o2net_handshake)
+				       == sizeof(struct o2net_msg));
+				ret = -EPROTO;
+			}
+			goto out;
+		}
+	}
+
 	/* do we need more header? */
 	if (sc->sc_page_off < sizeof(struct o2net_msg)) {
 		data = page_address(sc->sc_page) + sc->sc_page_off;
@@ -1160,15 +1218,6 @@ static int o2net_advance_rx(struct o2net
 		ret = o2net_recv_tcp_msg(sc->sc_sock, data, datalen);
 		if (ret > 0) {
 			sc->sc_page_off += ret;
-
-			/* this working relies on the handshake being
-			 * smaller than the normal message header */
-			if (sc->sc_page_off >= sizeof(struct o2net_handshake)&&
-			    !sc->sc_handshake_ok && o2net_check_handshake(sc)) {
-				ret = -EPROTO;
-				goto out;
-			}
-
 			/* only swab incoming here.. we can
 			 * only get here once as we cross from
 			 * being under to over */
@@ -1178,8 +1227,7 @@ static int o2net_advance_rx(struct o2net
 				    O2NET_MAX_PAYLOAD_BYTES)
 					ret = -EOVERFLOW;
 			}
-		}
-		if (ret <= 0)
+		} else
 			goto out;
 	}
 
@@ -1269,6 +1317,18 @@ static int o2net_set_nodelay(struct sock
 	return ret;
 }
 
+static void o2net_initialize_handshake(void)
+{
+	o2net_hand->o2hb_heartbeat_timeout_ms = cpu_to_be32(
+		O2HB_MAX_WRITE_TIMEOUT_MS);
+	o2net_hand->o2net_idle_timeout_ms = cpu_to_be32(
+		o2net_idle_timeout(NULL));
+	o2net_hand->o2net_keepalive_delay_ms = cpu_to_be32(
+		o2net_keepalive_delay(NULL));
+	o2net_hand->o2net_reconnect_delay_ms = cpu_to_be32(
+		o2net_reconnect_delay(NULL));
+}
+
 /* ------------------------------------------------------------ */
 
 /* called when a connect completes and after a sock is accepted.  the
@@ -1281,6 +1341,7 @@ static void o2net_sc_connect_completed(v
               (unsigned long long)O2NET_PROTOCOL_VERSION,
 	      (unsigned long long)be64_to_cpu(o2net_hand->connector_id));
 
+	o2net_initialize_handshake();
 	o2net_sendpage(sc, o2net_hand, sizeof(*o2net_hand));
 	sc_put(sc);
 }
@@ -1481,11 +1542,23 @@ static void o2net_still_up(void *arg)
 
 /* ------------------------------------------------------------ */
 
+static int o2net_connected_peers = 0;
+spinlock_t connected_lock;
+
+int o2net_num_connected_peers(void)
+{
+	return o2net_connected_peers;
+}
+
 void o2net_disconnect_node(struct o2nm_node *node)
 {
 	struct o2net_node *nn = o2net_nn_from_num(node->nd_num);
 
 	/* don't reconnect until it's heartbeating again */
+	spin_lock(&connected_lock);
+	o2net_connected_peers--;
+	spin_unlock(&connected_lock);
+
 	spin_lock(&nn->nn_lock);
 	o2net_set_nn_state(nn, NULL, 0, -ENOTCONN);
 	spin_unlock(&nn->nn_lock);
@@ -1505,13 +1578,17 @@ static void o2net_hb_node_down_cb(struct
 
 	if (node_num != o2nm_this_node())
 		o2net_disconnect_node(node);
+
+	BUG_ON(o2net_connected_peers < 0);
 }
 
+
 static void o2net_hb_node_up_cb(struct o2nm_node *node, int node_num,
 				void *data)
 {
 	struct o2net_node *nn = o2net_nn_from_num(node_num);
 
+	spin_lock(&connected_lock);
 	o2quo_hb_up(node_num);
 
 	/* ensure an immediate connect attempt */
@@ -1519,6 +1596,8 @@ static void o2net_hb_node_up_cb(struct o
 		(msecs_to_jiffies(o2net_reconnect_delay(node)) + 1);
 
 	if (node_num != o2nm_this_node()) {
+		o2net_connected_peers++;
+
 		/* heartbeat doesn't work unless a local node number is
 		 * configured and doing so brings up the o2net_wq, so we can
 		 * use it.. */
@@ -1534,6 +1613,8 @@ static void o2net_hb_node_up_cb(struct o
 			o2net_set_nn_state(nn, NULL, 0, 0);
 		spin_unlock(&nn->nn_lock);
 	}
+
+	spin_unlock(&connected_lock);
 }
 
 void o2net_unregister_hb_callbacks(void)
@@ -1668,6 +1749,7 @@ static int o2net_accept_one(struct socke
 	o2net_register_callbacks(sc->sc_sock->sk, sc);
 	o2net_sc_queue_work(sc, &sc->sc_rx_work);
 
+	o2net_initialize_handshake();
 	o2net_sendpage(sc, o2net_hand, sizeof(*o2net_hand));
 
 out:
@@ -1834,6 +1916,7 @@ int o2net_init(void)
 	unsigned long i;
 
 	o2quo_init();
+	spin_lock_init(&connected_lock);
 
 	o2net_hand = kcalloc(1, sizeof(struct o2net_handshake), GFP_KERNEL);
 	o2net_keep_req = kcalloc(1, sizeof(struct o2net_msg), GFP_KERNEL);
Index: fs/ocfs2/cluster/tcp.h
===================================================================
--- fs/ocfs2/cluster/tcp.h.orig	2006-11-20 16:19:12.000000000 +0100
+++ fs/ocfs2/cluster/tcp.h	2006-11-27 09:52:12.000000000 +0100
@@ -103,11 +103,13 @@ int o2net_register_handler(u32 msg_type,
 void o2net_unregister_handler_list(struct list_head *list);
 
 struct o2nm_node;
+extern spinlock_t connected_lock;
 int o2net_register_hb_callbacks(void);
 void o2net_unregister_hb_callbacks(void);
 int o2net_start_listening(struct o2nm_node *node);
 void o2net_stop_listening(struct o2nm_node *node);
 void o2net_disconnect_node(struct o2nm_node *node);
+int o2net_num_connected_peers(void);
 
 int o2net_init(void);
 void o2net_exit(void);
Index: fs/ocfs2/cluster/tcp_internal.h
===================================================================
--- fs/ocfs2/cluster/tcp_internal.h.orig	2006-11-20 16:19:12.000000000 +0100
+++ fs/ocfs2/cluster/tcp_internal.h	2006-11-20 16:25:36.000000000 +0100
@@ -48,10 +48,14 @@
  * 	- full 64 bit i_size in the metadata lock lvbs
  * 	- introduction of "rw" lock and pushing meta/data locking down
  */
-#define O2NET_PROTOCOL_VERSION 4ULL
+#define O2NET_PROTOCOL_VERSION 5ULL
 struct o2net_handshake {
 	__be64	protocol_version;
 	__be64	connector_id;
+	__be32  o2hb_heartbeat_timeout_ms;
+	__be32  o2net_idle_timeout_ms;
+	__be32  o2net_keepalive_delay_ms;
+	__be32  o2net_reconnect_delay_ms;
 };
 
 struct o2net_node {

--
