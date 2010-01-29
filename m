From: Srinivas Eeda <srinivas.eeda@oracle.com>
Date: Thu, 28 Jan 2010 20:51:10 -0800
Subject: [Ocfs2-devel] [PATCH 2/3] o2net: delay enotconn for sends receives
	till quorum decision
In-Reply-To: <1264740671-908-1-git-send-email-srinivas.eeda@oracle.com>
References: <1264740671-908-1-git-send-email-srinivas.eeda@oracle.com>
Message-ID: <1264740671-908-3-git-send-email-srinivas.eeda@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

When a ocfs2 network heartbeat times out between two nodes, o2net layer breaks
the socket connection, and returns -ENOTCONN to processes that are trying
send/receive messages to/from other node. It also queues a quorum decision to
be made after the disk timeout to resolve split brain.

The fix queues the quorum decision after network heartbeat timeout but avoids
socket disconnects. The fix delays socket disconnects till O2HB_NODE_DOWN_CB
event which is triggered on the surviving node after the node evictions happen.
Surviving node signals -ENOTCONN to processes waiting to send/receives messages
to/from evicted node. If network connection comes back before the eviction,
quorum decision is cancelled and messaging resumes.

Signed-off-by: Srinivas Eeda <srinivas.eeda@oracle.com>
---
 fs/ocfs2/cluster/tcp.c          |   69 +++++++++++++++++++++++++++++++--------
 fs/ocfs2/cluster/tcp_internal.h |    3 ++
 2 files changed, 58 insertions(+), 14 deletions(-)

diff --git a/fs/ocfs2/cluster/tcp.c b/fs/ocfs2/cluster/tcp.c
index d81acff..0bbd47b 100644
--- a/fs/ocfs2/cluster/tcp.c
+++ b/fs/ocfs2/cluster/tcp.c
@@ -141,6 +141,7 @@ static void o2net_sc_send_keep_req(struct work_struct *work);
 static void o2net_idle_timer(unsigned long data);
 static void o2net_sc_postpone_idle(struct o2net_sock_container *sc);
 static void o2net_sc_reset_idle_timer(struct o2net_sock_container *sc);
+static void o2net_queue_quorum(struct o2net_node *nn);
 
 #ifdef CONFIG_DEBUG_FS
 static void o2net_init_nst(struct o2net_send_tracking *nst, u32 msgtype,
@@ -447,7 +448,6 @@ static void o2net_set_nn_state(struct o2net_node *nn,
 			       unsigned valid, int err)
 {
 	int was_valid = nn->nn_sc_valid;
-	int was_err = nn->nn_persistent_error;
 	struct o2net_sock_container *old_sc = nn->nn_sc;
 
 	assert_spin_locked(&nn->nn_lock);
@@ -480,12 +480,6 @@ static void o2net_set_nn_state(struct o2net_node *nn,
 	if (nn->nn_persistent_error || nn->nn_sc_valid)
 		wake_up(&nn->nn_sc_wq);
 
-	if (!was_err && nn->nn_persistent_error) {
-		o2quo_conn_err(o2net_num_from_nn(nn));
-		queue_delayed_work(o2net_wq, &nn->nn_still_up,
-				   msecs_to_jiffies(O2NET_QUORUM_DELAY_MS));
-	}
-
 	if (was_valid && !valid) {
 		printk(KERN_INFO "o2net: no longer connected to "
 		       SC_NODEF_FMT "\n", SC_NODEF_ARGS(old_sc));
@@ -498,7 +492,6 @@ static void o2net_set_nn_state(struct o2net_node *nn,
 		 * if that connection then dies we don't try reconnecting.
 		 * the only way to start connecting again is to down
 		 * heartbeat and bring it back up. */
-		o2quo_conn_up(o2net_num_from_nn(nn));
 		cancel_delayed_work(&nn->nn_connect_expired);
 		printk(KERN_INFO "o2net: %s " SC_NODEF_FMT "\n",
 		       o2nm_this_node() > sc->sc_node->nd_num ?
@@ -557,6 +550,7 @@ static void o2net_state_change(struct sock *sk)
 {
 	void (*state_change)(struct sock *sk);
 	struct o2net_sock_container *sc;
+	struct o2net_node *nn;
 
 	read_lock(&sk->sk_callback_lock);
 	sc = sk->sk_user_data;
@@ -578,7 +572,11 @@ static void o2net_state_change(struct sock *sk)
 			o2net_sc_queue_work(sc, &sc->sc_connect_work);
 			break;
 		default:
-			o2net_sc_queue_work(sc, &sc->sc_shutdown_work);
+			if (sc->sc_handshake_ok) {
+				nn = o2net_nn_from_num(sc->sc_node->nd_num);
+				queue_work(o2net_wq, &nn->nn_connection_err);
+			} else
+				o2net_sc_queue_work(sc, &sc->sc_shutdown_work);
 			break;
 	}
 out:
@@ -682,6 +680,26 @@ static void o2net_shutdown_sc(struct work_struct *work)
 	sc_put(sc);
 }
 
+static void o2net_queue_quorum(struct o2net_node *nn)
+{
+	if (!atomic_read(&nn->nn_quorum_queued)) {
+		o2quo_conn_err(o2net_num_from_nn(nn));
+		queue_delayed_work(o2net_wq, &nn->nn_still_up,
+				   msecs_to_jiffies(O2NET_QUORUM_DELAY_MS));
+		atomic_set(&nn->nn_quorum_queued, 1);
+	}
+}
+
+static void o2net_connection_err(struct work_struct *work)
+{
+	struct o2net_node *nn =
+		container_of(work, struct o2net_node, nn_connection_err);
+
+	spin_lock(&nn->nn_lock);
+	o2net_queue_quorum(nn);
+	spin_unlock(&nn->nn_lock);
+}
+
 /* ------------------------------------------------------------ */
 
 static int o2net_handler_cmp(struct o2net_msg_handler *nmh, u32 msg_type,
@@ -1465,6 +1483,7 @@ static void o2net_sc_send_keep_req(struct work_struct *work)
 static void o2net_idle_timer(unsigned long data)
 {
 	struct o2net_sock_container *sc = (struct o2net_sock_container *)data;
+	struct o2net_node *nn = o2net_nn_from_num(sc->sc_node->nd_num);
 	struct timeval now;
 
 	do_gettimeofday(&now);
@@ -1487,7 +1506,7 @@ static void o2net_idle_timer(unsigned long data)
 	     sc->sc_tv_func_start.tv_sec, (long) sc->sc_tv_func_start.tv_usec,
 	     sc->sc_tv_func_stop.tv_sec, (long) sc->sc_tv_func_stop.tv_usec);
 
-	o2net_sc_queue_work(sc, &sc->sc_shutdown_work);
+	queue_work(o2net_wq, &nn->nn_connection_err);
 }
 
 static void o2net_sc_reset_idle_timer(struct o2net_sock_container *sc)
@@ -1502,9 +1521,24 @@ static void o2net_sc_reset_idle_timer(struct o2net_sock_container *sc)
 
 static void o2net_sc_postpone_idle(struct o2net_sock_container *sc)
 {
-	/* Only push out an existing timer */
-	if (timer_pending(&sc->sc_idle_timeout))
-		o2net_sc_reset_idle_timer(sc);
+	struct o2net_node *nn = o2net_nn_from_num(sc->sc_node->nd_num);
+
+	/* avoid spin_lock if not needed */
+	if (atomic_read(&nn->nn_quorum_queued)) {
+		spin_lock(&nn->nn_lock);
+		if (atomic_read(&nn->nn_quorum_queued)) {
+			o2quo_conn_up(sc->sc_node->nd_num);
+			cancel_delayed_work(&nn->nn_still_up);
+			atomic_set(&nn->nn_quorum_queued, 0);
+			printk(KERN_INFO "o2net: reconnected to "
+			       SC_NODEF_FMT "\n", SC_NODEF_ARGS(sc));
+		}
+		spin_unlock(&nn->nn_lock);
+	}
+
+	if (!timer_pending(&sc->sc_idle_timeout))
+		return;
+	o2net_sc_reset_idle_timer(sc);
 }
 
 /* this work func is kicked whenever a path sets the nn state which doesn't
@@ -1540,7 +1574,7 @@ static void o2net_start_connect(struct work_struct *work)
 	}
 
 	spin_lock(&nn->nn_lock);
-	/* see if we already have one pending or have given up */
+	/* don't queue on broken or pending connection. */
 	stop = (nn->nn_sc || nn->nn_persistent_error);
 	spin_unlock(&nn->nn_lock);
 	if (stop)
@@ -1653,6 +1687,9 @@ void o2net_disconnect_node(struct o2nm_node *node)
 
 	/* don't reconnect until it's heartbeating again */
 	spin_lock(&nn->nn_lock);
+	if (nn->nn_sc)
+		o2net_sc_queue_work(nn->nn_sc, &nn->nn_sc->sc_shutdown_work);
+
 	o2net_set_nn_state(nn, NULL, 0, -ENOTCONN);
 	spin_unlock(&nn->nn_lock);
 
@@ -1661,7 +1698,9 @@ void o2net_disconnect_node(struct o2nm_node *node)
 		cancel_delayed_work(&nn->nn_connect_work);
 		cancel_delayed_work(&nn->nn_still_up);
 		flush_workqueue(o2net_wq);
+		atomic_set(&nn->nn_quorum_queued, 0);
 	}
+	o2quo_conn_err(o2net_num_from_nn(nn));
 }
 
 static void o2net_hb_node_down_cb(struct o2nm_node *node, int node_num,
@@ -2021,8 +2060,10 @@ int o2net_init(void)
 		INIT_DELAYED_WORK(&nn->nn_connect_expired,
 				  o2net_connect_expired);
 		INIT_DELAYED_WORK(&nn->nn_still_up, o2net_still_up);
+		INIT_WORK(&nn->nn_connection_err, o2net_connection_err);
 		/* until we see hb from a node we'll return einval */
 		nn->nn_persistent_error = -ENOTCONN;
+		atomic_set(&nn->nn_quorum_queued, 0);
 		init_waitqueue_head(&nn->nn_sc_wq);
 		idr_init(&nn->nn_status_idr);
 		INIT_LIST_HEAD(&nn->nn_status_list);
diff --git a/fs/ocfs2/cluster/tcp_internal.h b/fs/ocfs2/cluster/tcp_internal.h
index df36e1b..f013c35 100644
--- a/fs/ocfs2/cluster/tcp_internal.h
+++ b/fs/ocfs2/cluster/tcp_internal.h
@@ -95,6 +95,8 @@ struct o2net_node {
 	unsigned			nn_sc_valid:1;
 	/* if this is set tx just returns it */
 	int				nn_persistent_error;
+	/* It is toggled between quorum fired and cancelled */
+	atomic_t			nn_quorum_queued;
 
 	/* threads waiting for an sc to arrive wait on the wq for generation
 	 * to increase.  it is increased when a connecting socket succeeds
@@ -123,6 +125,7 @@ struct o2net_node {
 	 * that it is still heartbeating and that we should do some
 	 * quorum work */
 	struct delayed_work		nn_still_up;
+	struct work_struct		nn_connection_err;
 };
 
 struct o2net_sock_container {
-- 
1.5.6.5
