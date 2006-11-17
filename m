From: abeekhof@suse.de <abeekhof@suse.de>
Date: Fri Nov 17 23:36:42 2006
Subject: [Ocfs2-devel] [patch 3/3] OCFS2 Configurable timeouts - Protocol
	changes
References: <20061118073600.206222000@suse.de>
Message-ID: <20061118073634.419648000@suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The addition of two dummy fields is a temporary measure to 
   satisfy the logic in o2net_check_handshake() and will be
   rectified in a future version of this patch

Signed-off-by: Andrew Beekhof <abeekhof@suse.de>
---
 fs/ocfs2/cluster/tcp.c          |   44 ++++++++++++++++++++++++++++++++++++++++
 fs/ocfs2/cluster/tcp.h          |    2 +
 fs/ocfs2/cluster/tcp_internal.h |    6 ++++-
 3 files changed, 51 insertions(+), 1 deletion(-)


Index: fs/ocfs2/cluster/tcp.c
===================================================================
--- fs/ocfs2/cluster/tcp.c.orig	2006-11-17 16:26:15.000000000 +0100
+++ fs/ocfs2/cluster/tcp.c	2006-11-17 16:26:27.000000000 +0100
@@ -1121,6 +1121,33 @@ static int o2net_check_handshake(struct 
 		return -1;
 	}
 
+	/*
+	 * Ensure timeouts are consistent with other nodes, otherwise
+	 * we can end up with one node thinking that the other must be down,
+	 * but isn't. This can ultimately cause corruption.
+	 */
+	if (be32_to_cpu(hand->o2net_idle_timeout_ms) !=
+				o2net_idle_timeout(sc->sc_node)) {
+		mlog(ML_NOTICE, SC_NODEF_FMT " uses network idle timeout of "
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
+		mlog(ML_NOTICE, SC_NODEF_FMT " uses keepalive delay of "
+		     "%u ms, but we use %u ms locally.  disconnecting\n",
+		     SC_NODEF_ARGS(sc),
+		     be32_to_cpu(hand->o2net_keepalive_delay_ms),
+		     o2net_keepalive_delay(sc->sc_node));
+		o2net_ensure_shutdown(nn, sc, -ENOTCONN);
+		return -1;
+	}
+
 	sc->sc_handshake_ok = 1;
 
 	spin_lock(&nn->nn_lock);
@@ -1269,6 +1296,21 @@ static int o2net_set_nodelay(struct sock
 	return ret;
 }
 
+static void o2net_initialize_handshake(void)
+{
+	static int initialized = 0;
+	if(initialized)
+		return;
+
+	initialized = 1;
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
@@ -1281,6 +1323,7 @@ static void o2net_sc_connect_completed(v
               (unsigned long long)O2NET_PROTOCOL_VERSION,
 	      (unsigned long long)be64_to_cpu(o2net_hand->connector_id));
 
+	o2net_initialize_handshake();
 	o2net_sendpage(sc, o2net_hand, sizeof(*o2net_hand));
 	sc_put(sc);
 }
@@ -1668,6 +1711,7 @@ static int o2net_accept_one(struct socke
 	o2net_register_callbacks(sc->sc_sock->sk, sc);
 	o2net_sc_queue_work(sc, &sc->sc_rx_work);
 
+	o2net_initialize_handshake();
 	o2net_sendpage(sc, o2net_hand, sizeof(*o2net_hand));
 
 out:
Index: fs/ocfs2/cluster/tcp.h
===================================================================
--- fs/ocfs2/cluster/tcp.h.orig	2006-11-17 16:26:15.000000000 +0100
+++ fs/ocfs2/cluster/tcp.h	2006-11-17 16:26:27.000000000 +0100
@@ -47,6 +47,8 @@ struct o2net_msg
 	__be32 status;
 	__be32 key;
 	__be32 msg_num;
+	__be64 dummy;
+	__be32 dummy2;
 	__u8  buf[0];
 };
 
Index: fs/ocfs2/cluster/tcp_internal.h
===================================================================
--- fs/ocfs2/cluster/tcp_internal.h.orig	2006-11-17 16:26:15.000000000 +0100
+++ fs/ocfs2/cluster/tcp_internal.h	2006-11-17 16:26:54.000000000 +0100
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
