From: abeekhof@suse.de <abeekhof@suse.de>
Date: Mon Dec  4 05:12:47 2006
Subject: [Ocfs2-devel] [patch 3/3] ocfs2-timeout-protocol.patch
References: <20061204130452.199246000@suse.de>
Message-ID: <20061204131237.894581000@suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


From: Andrew Beekhof <abeekhof@suse.de>
Subject: [patch 3/3] OCFS2 Configurable timeouts - Protocol changes

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
 fs/ocfs2/cluster/nodemanager.c  |   30 ++++++++++--
 fs/ocfs2/cluster/tcp.c          |   94 ++++++++++++++++++++++++++++++++++++----
 fs/ocfs2/cluster/tcp.h          |    1 
 fs/ocfs2/cluster/tcp_internal.h |    6 ++
 4 files changed, 115 insertions(+), 16 deletions(-)









Index: fs/ocfs2/cluster/nodemanager.c
===================================================================
--- fs/ocfs2/cluster/nodemanager.c.orig	2006-12-04 12:07:32.000000000 +0100
+++ fs/ocfs2/cluster/nodemanager.c	2006-12-04 12:07:32.000000000 +0100
@@ -573,12 +573,21 @@ static ssize_t o2nm_cluster_attr_idle_ti
 	ret =  o2nm_cluster_attr_write(page, count, &val);
 
 	if (ret > 0) {
-		if (val <= cluster->cl_keepalive_delay_ms) {
+		if (cluster->cl_idle_timeout_ms != val
+			&& o2net_num_connected_peers()) {
+			mlog(ML_NOTICE,
+			     "o2net: cannot change idle timeout after "
+			     "the first peer has agreed to it."
+			     "  %d connected peers\n",
+			     o2net_num_connected_peers());
+			ret = -EINVAL;
+		} else if (val <= cluster->cl_keepalive_delay_ms) {
 			mlog(ML_NOTICE, "o2net: idle timeout must be larger "
 			     "than keepalive delay\n");
-			return -EINVAL;
+			ret = -EINVAL;
+		} else {
+			cluster->cl_idle_timeout_ms = val;
 		}
-		cluster->cl_idle_timeout_ms = val;
 	}
 
 	return ret;
@@ -599,12 +608,21 @@ static ssize_t o2nm_cluster_attr_keepali
 	ret =  o2nm_cluster_attr_write(page, count, &val);
 
 	if (ret > 0) {
-		if (val >= cluster->cl_idle_timeout_ms) {
+		if (cluster->cl_keepalive_delay_ms != val
+		    && o2net_num_connected_peers()) {
+			mlog(ML_NOTICE,
+			     "o2net: cannot change keepalive delay after"
+			     " the first peer has agreed to it."
+			     "  %d connected peers\n",
+			     o2net_num_connected_peers());
+			ret = -EINVAL;
+		} else if (val >= cluster->cl_idle_timeout_ms) {
 			mlog(ML_NOTICE, "o2net: keepalive delay must be "
 			     "smaller than idle timeout\n");
-			return -EINVAL;
+			ret = -EINVAL;
+		} else {
+			cluster->cl_keepalive_delay_ms = val;
 		}
-		cluster->cl_keepalive_delay_ms = val;
 	}
 
 	return ret;
Index: fs/ocfs2/cluster/tcp.c
===================================================================
--- fs/ocfs2/cluster/tcp.c.orig	2006-12-04 12:07:32.000000000 +0100
+++ fs/ocfs2/cluster/tcp.c	2006-12-04 13:59:41.000000000 +0100
@@ -380,6 +380,13 @@ static void o2net_sc_cancel_delayed_work
 		sc_put(sc);
 }
 
+atomic_t o2net_connected_peers = ATOMIC_INIT(0);
+
+int o2net_num_connected_peers(void)
+{
+	return atomic_read(&o2net_connected_peers);
+}
+
 static void o2net_set_nn_state(struct o2net_node *nn,
 			       struct o2net_sock_container *sc,
 			       unsigned valid, int err)
@@ -390,6 +397,13 @@ static void o2net_set_nn_state(struct o2
 
 	assert_spin_locked(&nn->nn_lock);
 
+	if (old_sc != sc) {
+		if (old_sc)
+			atomic_dec(&o2net_connected_peers);
+		else
+			atomic_inc(&o2net_connected_peers);
+	}
+
 	/* the node num comparison and single connect/accept path should stop
 	 * an non-null sc from being overwritten with another */
 	BUG_ON(sc && nn->nn_sc && nn->nn_sc != sc);
@@ -1121,6 +1135,44 @@ static int o2net_check_handshake(struct 
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
+		     be32_to_cpu(hand->o2hb_heartbeat_timeout_ms),
+		     O2HB_MAX_WRITE_TIMEOUT_MS);
+		o2net_ensure_shutdown(nn, sc, -ENOTCONN);
+		return -1;
+	}
+
 	sc->sc_handshake_ok = 1;
 
 	spin_lock(&nn->nn_lock);
@@ -1153,6 +1205,23 @@ static int o2net_advance_rx(struct o2net
 	sclog(sc, "receiving\n");
 	do_gettimeofday(&sc->sc_tv_advance_start);
 
+	if (unlikely(sc->sc_handshake_ok == 0)) {
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
+			if (unlikely(sc->sc_handshake_ok == 0))
+				ret = -EPROTO;
+		}
+		goto out;
+	}
+
 	/* do we need more header? */
 	if (sc->sc_page_off < sizeof(struct o2net_msg)) {
 		data = page_address(sc->sc_page) + sc->sc_page_off;
@@ -1160,15 +1229,6 @@ static int o2net_advance_rx(struct o2net
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
@@ -1269,6 +1329,18 @@ static int o2net_set_nodelay(struct sock
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
@@ -1281,6 +1353,7 @@ static void o2net_sc_connect_completed(v
               (unsigned long long)O2NET_PROTOCOL_VERSION,
 	      (unsigned long long)be64_to_cpu(o2net_hand->connector_id));
 
+	o2net_initialize_handshake();
 	o2net_sendpage(sc, o2net_hand, sizeof(*o2net_hand));
 	sc_put(sc);
 }
@@ -1505,6 +1578,8 @@ static void o2net_hb_node_down_cb(struct
 
 	if (node_num != o2nm_this_node())
 		o2net_disconnect_node(node);
+
+	BUG_ON(atomic_read(&o2net_connected_peers) < 0);
 }
 
 static void o2net_hb_node_up_cb(struct o2nm_node *node, int node_num,
@@ -1668,6 +1743,7 @@ static int o2net_accept_one(struct socke
 	o2net_register_callbacks(sc->sc_sock->sk, sc);
 	o2net_sc_queue_work(sc, &sc->sc_rx_work);
 
+	o2net_initialize_handshake();
 	o2net_sendpage(sc, o2net_hand, sizeof(*o2net_hand));
 
 out:
Index: fs/ocfs2/cluster/tcp.h
===================================================================
--- fs/ocfs2/cluster/tcp.h.orig	2006-12-04 12:07:32.000000000 +0100
+++ fs/ocfs2/cluster/tcp.h	2006-12-04 12:07:32.000000000 +0100
@@ -108,6 +108,7 @@ void o2net_unregister_hb_callbacks(void)
 int o2net_start_listening(struct o2nm_node *node);
 void o2net_stop_listening(struct o2nm_node *node);
 void o2net_disconnect_node(struct o2nm_node *node);
+int o2net_num_connected_peers(void);
 
 int o2net_init(void);
 void o2net_exit(void);
Index: fs/ocfs2/cluster/tcp_internal.h
===================================================================
--- fs/ocfs2/cluster/tcp_internal.h.orig	2006-12-04 12:07:32.000000000 +0100
+++ fs/ocfs2/cluster/tcp_internal.h	2006-12-04 12:07:32.000000000 +0100
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
