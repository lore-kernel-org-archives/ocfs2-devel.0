From: Xue jiufei <xuejiufei@huawei.com>
Date: Sat, 22 Dec 2012 15:23:16 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix hang process in
	o2net_send_message_vec
In-Reply-To: <50D55EA6.8080903@huawei.com>
References: <50D55EA6.8080903@huawei.com>
Message-ID: <50D55FE4.7080404@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

  We found a race between o2net_send_message_vec() and
o2net_set_nn_states(). A node(say nodeA) sends messages to another node
(say nodeB) while it happened to detect nodeB down. NodeA calls the two
functions i.e., o2net_send_message_vec() and o2net_set_nn_state() almost
at the same time. 
 
    o2net_send_message_vec                        o2net_set_nn_state

wait_event(nn->nn_sc_wq, 
	o2net_tx_can_proceed(nn, &sc, &ret));
Not detect nodeB down yet,going on; 
						clear nodeB->nn_sc_valid and
						set nodeB->nn_persistent_error;
						call o2net_complete_nodes_nsw()
						to delete all nsw of nodeB;
											  
o2net_prep_nsw() alloc a new nsw and insert
into nodeB->nn_status_idr;

o2net_send_tcp_msg()

                                                o2net_shutdown_sc();

wait_event(nsw.ns_wq,
		o2net_nsw_completed(nn, &nsw))

  NodeA waiting for nsw to be deleted. But nodeB is already down, it will
never send the response. So nodeA hangs in o2net_send_message_vec(). 
  This patch introduce a mutex lock to fix this race.

Signed-off-by: xuejiufei <xuejiufei@huawei.com>
---
 fs/ocfs2/cluster/tcp.c          |   26 ++++++++++++++++++++++++++
 fs/ocfs2/cluster/tcp_internal.h |    2 ++
 2 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/cluster/tcp.c b/fs/ocfs2/cluster/tcp.c
index 1bfe880..2bcfa64 100644
--- a/fs/ocfs2/cluster/tcp.c
+++ b/fs/ocfs2/cluster/tcp.c
@@ -306,6 +306,14 @@ static int o2net_prep_nsw(struct o2net_node *nn, struct o2net_status_wait *nsw)
 {
 	int ret = 0;
 
+	spin_lock(&nn->nn_lock);
+	ret = nn->nn_sc_valid ? 0 : -ENOTCONN;
+	spin_unlock(&nn->nn_lock);
+	if (ret) {
+		mlog(ML_CONN, "o2net: connection invalid while preparing nsw\n");
+		goto out;
+	}
+
 	do {
 		if (!idr_pre_get(&nn->nn_status_idr, GFP_ATOMIC)) {
 			ret = -EAGAIN;
@@ -325,6 +333,7 @@ static int o2net_prep_nsw(struct o2net_node *nn, struct o2net_status_wait *nsw)
 		nsw->ns_status = 0;
 	}
 
+out:
 	return ret;
 }
 
@@ -712,10 +721,12 @@ static void o2net_ensure_shutdown(struct o2net_node *nn,
 			           struct o2net_sock_container *sc,
 				   int err)
 {
+	mutex_lock(&nn->nn_mutex);
 	spin_lock(&nn->nn_lock);
 	if (nn->nn_sc == sc)
 		o2net_set_nn_state(nn, NULL, 0, err);
 	spin_unlock(&nn->nn_lock);
+	mutex_unlock(&nn->nn_mutex);
 }
 
 /*
@@ -1125,7 +1136,9 @@ int o2net_send_message_vec(u32 msg_type, u32 key, struct kvec *caller_vec,
 	vec[0].iov_base = msg;
 	memcpy(&vec[1], caller_vec, caller_veclen * sizeof(struct kvec));
 
+	mutex_lock(&nn->nn_mutex);
 	ret = o2net_prep_nsw(nn, &nsw);
+	mutex_unlock(&nn->nn_mutex);
 	if (ret)
 		goto out;
 
@@ -1355,6 +1368,7 @@ static int o2net_check_handshake(struct o2net_sock_container *sc)
 
 	sc->sc_handshake_ok = 1;
 
+	mutex_lock(&nn->nn_mutex);
 	spin_lock(&nn->nn_lock);
 	/* set valid and queue the idle timers only if it hasn't been
 	 * shut down already */
@@ -1364,6 +1378,7 @@ static int o2net_check_handshake(struct o2net_sock_container *sc)
 		o2net_set_nn_state(nn, sc, 1, 0);
 	}
 	spin_unlock(&nn->nn_lock);
+	mutex_unlock(&nn->nn_mutex);
 
 	/* shift everything up as though it wasn't there */
 	sc->sc_page_off -= sizeof(struct o2net_handshake);
@@ -1683,10 +1698,12 @@ static void o2net_start_connect(struct work_struct *work)
 
 	o2net_register_callbacks(sc->sc_sock->sk, sc);
 
+	mutex_lock(&nn->nn_mutex);
 	spin_lock(&nn->nn_lock);
 	/* handshake completion will set nn->nn_sc_valid */
 	o2net_set_nn_state(nn, sc, 0, 0);
 	spin_unlock(&nn->nn_lock);
+	mutex_unlock(&nn->nn_mutex);
 
 	remoteaddr.sin_family = AF_INET;
 	remoteaddr.sin_addr.s_addr = node->nd_ipv4_address;
@@ -1723,6 +1740,7 @@ static void o2net_connect_expired(struct work_struct *work)
 	struct o2net_node *nn =
 		container_of(work, struct o2net_node, nn_connect_expired.work);
 
+	mutex_lock(&nn->nn_mutex);
 	spin_lock(&nn->nn_lock);
 	if (!nn->nn_sc_valid) {
 		printk(KERN_NOTICE "o2net: No connection established with "
@@ -1734,6 +1752,7 @@ static void o2net_connect_expired(struct work_struct *work)
 		o2net_set_nn_state(nn, NULL, 0, -ENOTCONN);
 	}
 	spin_unlock(&nn->nn_lock);
+	mutex_unlock(&nn->nn_mutex);
 }
 
 static void o2net_still_up(struct work_struct *work)
@@ -1751,10 +1770,12 @@ void o2net_disconnect_node(struct o2nm_node *node)
 	struct o2net_node *nn = o2net_nn_from_num(node->nd_num);
 
 	/* don't reconnect until it's heartbeating again */
+	mutex_lock(&nn->nn_mutex);
 	spin_lock(&nn->nn_lock);
 	atomic_set(&nn->nn_timeout, 0);
 	o2net_set_nn_state(nn, NULL, 0, -ENOTCONN);
 	spin_unlock(&nn->nn_lock);
+	mutex_unlock(&nn->nn_mutex);
 
 	if (o2net_wq) {
 		cancel_delayed_work(&nn->nn_connect_expired);
@@ -1796,11 +1817,13 @@ static void o2net_hb_node_up_cb(struct o2nm_node *node, int node_num,
 		 * can succeed for this node before we got here.. so
 		 * only use set_nn_state to clear the persistent error
 		 * if that hasn't already happened */
+		mutex_lock(&nn->nn_mutex);
 		spin_lock(&nn->nn_lock);
 		atomic_set(&nn->nn_timeout, 0);
 		if (nn->nn_persistent_error)
 			o2net_set_nn_state(nn, NULL, 0, 0);
 		spin_unlock(&nn->nn_lock);
+		mutex_unlock(&nn->nn_mutex);
 	}
 }
 
@@ -1924,10 +1947,12 @@ static int o2net_accept_one(struct socket *sock)
 	sc->sc_sock = new_sock;
 	new_sock = NULL;
 
+	mutex_lock(&nn->nn_mutex);
 	spin_lock(&nn->nn_lock);
 	atomic_set(&nn->nn_timeout, 0);
 	o2net_set_nn_state(nn, sc, 0, 0);
 	spin_unlock(&nn->nn_lock);
+	mutex_unlock(&nn->nn_mutex);
 
 	o2net_register_callbacks(sc->sc_sock->sk, sc);
 	o2net_sc_queue_work(sc, &sc->sc_rx_work);
@@ -2135,6 +2160,7 @@ int o2net_init(void)
 		init_waitqueue_head(&nn->nn_sc_wq);
 		idr_init(&nn->nn_status_idr);
 		INIT_LIST_HEAD(&nn->nn_status_list);
+		mutex_init(&nn->nn_mutex);
 	}
 
 	return 0;
diff --git a/fs/ocfs2/cluster/tcp_internal.h b/fs/ocfs2/cluster/tcp_internal.h
index 4cbcb65..11640d4 100644
--- a/fs/ocfs2/cluster/tcp_internal.h
+++ b/fs/ocfs2/cluster/tcp_internal.h
@@ -125,6 +125,8 @@ struct o2net_node {
 	 * that it is still heartbeating and that we should do some
 	 * quorum work */
 	struct delayed_work		nn_still_up;
+
+	struct mutex nn_mutex;
 };
 
 struct o2net_sock_container {
-- 
1.7.8.6
