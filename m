From: Tao Ma <tao.ma@oracle.com>
Date: Mon Feb  4 06:58:37 2008
Subject: [Ocfs2-devel] [PATCH] o2net: Reconnect after idle time out.
Message-ID: <20080204145822.GA30215@tma-pc1.cn.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Currently, o2net connects to a node on hb_up and disconnects on
hb_down and net timeout.

It disconnects on net timeout is ok, but it should attempt to
reconnect back. This is because sometimes nodes get overloaded
enough that the network connection breaks but the disk hb does not.
And if we get into that situation, we either fence (unnecessarily)
or wait for its disk hb to die (and sometimes hang in the process).

So in this updated scheme, when the network disconnects, we keep
attempting to reconnect till we succeed or we get a disk hb down
event.

If the other node is really dead, then we will eventually get a
node down event. If not, we should be able to connect again and
continue.

Signed-off-by: Tao Ma <tao.ma@oracle.com>

---

 fs/ocfs2/cluster/tcp.c          |   41 +++++++++++++++++++++++++--------------
 fs/ocfs2/cluster/tcp_internal.h |    2 ++
 2 files changed, 28 insertions(+), 15 deletions(-)

8a10f583244554c18234a031113a8ad6c796f51d
diff --git a/fs/ocfs2/cluster/tcp.c b/fs/ocfs2/cluster/tcp.c
index ee50c96..ad81a5e 100644
--- a/fs/ocfs2/cluster/tcp.c
+++ b/fs/ocfs2/cluster/tcp.c
@@ -399,8 +399,6 @@ static void o2net_set_nn_state(struct o2
 	mlog_bug_on_msg(err && valid, "err %d valid %u\n", err, valid);
 	mlog_bug_on_msg(valid && !sc, "valid %u sc %p\n", valid, sc);
 
-	/* we won't reconnect after our valid conn goes away for
-	 * this hb iteration.. here so it shows up in the logs */
 	if (was_valid && !valid && err == 0)
 		err = -ENOTCONN;
 
@@ -430,11 +428,6 @@ static void o2net_set_nn_state(struct o2
 
 	if (!was_valid && valid) {
 		o2quo_conn_up(o2net_num_from_nn(nn));
-		/* this is a bit of a hack.  we only try reconnecting
-		 * when heartbeating starts until we get a connection.
-		 * if that connection then dies we don't try reconnecting.
-		 * the only way to start connecting again is to down
-		 * heartbeat and bring it back up. */
 		cancel_delayed_work(&nn->nn_connect_expired);
 		printk(KERN_INFO "o2net: %s " SC_NODEF_FMT "\n",
 		       o2nm_this_node() > sc->sc_node->nd_num ?
@@ -457,6 +450,8 @@ static void o2net_set_nn_state(struct o2
 			delay = 0;
 		mlog(ML_CONN, "queueing conn attempt in %lu jiffies\n", delay);
 		queue_delayed_work(o2net_wq, &nn->nn_connect_work, delay);
+		queue_delayed_work(o2net_wq, &nn->nn_connect_expired,
+			delay + msecs_to_jiffies(o2net_idle_timeout(sc->sc_node)));
 	}
 
 	/* keep track of the nn's sc ref for the caller */
@@ -1193,6 +1188,7 @@ static int o2net_check_handshake(struct 
 	 * shut down already */
 	if (nn->nn_sc == sc) {
 		o2net_sc_reset_idle_timer(sc);
+		nn->nn_timeout = 0;
 		o2net_set_nn_state(nn, sc, 1, 0);
 	}
 	spin_unlock(&nn->nn_lock);
@@ -1391,6 +1387,7 @@ static void o2net_sc_send_keep_req(struc
 static void o2net_idle_timer(unsigned long data)
 {
 	struct o2net_sock_container *sc = (struct o2net_sock_container *)data;
+	struct o2net_node *nn = o2net_nn_from_num(sc->sc_node->nd_num);
 	struct timeval now;
 
 	do_gettimeofday(&now);
@@ -1413,6 +1410,14 @@ static void o2net_idle_timer(unsigned lo
 	     sc->sc_tv_func_start.tv_sec, (long) sc->sc_tv_func_start.tv_usec,
 	     sc->sc_tv_func_stop.tv_sec, (long) sc->sc_tv_func_stop.tv_usec);
 
+	/*
+	 * Initialize the nn_timeout so that the next connection attempt
+	 * will continue in o2net_start_connect.
+	 */
+	spin_lock(&nn->nn_lock);
+	nn->nn_timeout = 1;
+	spin_unlock(&nn->nn_lock);
+
 	o2net_sc_queue_work(sc, &sc->sc_shutdown_work);
 }
 
@@ -1466,8 +1471,17 @@ static void o2net_start_connect(struct w
 	}
 
 	spin_lock(&nn->nn_lock);
-	/* see if we already have one pending or have given up */
-	stop = (nn->nn_sc || nn->nn_persistent_error);
+	/*
+	 * see if we already have one pending or have given up.
+	 * For nn_timeout, it is set when we close the connection
+	 * because of the idle time out. So it means that we have
+	 * at least connected to that node successfully once,
+	 * now try to connect to it again.
+	 */
+	stop = (nn->nn_sc ||
+		(nn->nn_persistent_error &&
+		(nn->nn_persistent_error != -ENOTCONN ||
+		 nn->nn_timeout == 0)));
 	spin_unlock(&nn->nn_lock);
 	if (stop)
 		goto out;
@@ -1580,6 +1594,7 @@ void o2net_disconnect_node(struct o2nm_n
 
 	/* don't reconnect until it's heartbeating again */
 	spin_lock(&nn->nn_lock);
+	nn->nn_timeout = 0;
 	o2net_set_nn_state(nn, NULL, 0, -ENOTCONN);
 	spin_unlock(&nn->nn_lock);
 
@@ -1614,17 +1629,12 @@ static void o2net_hb_node_up_cb(struct o
 		(msecs_to_jiffies(o2net_reconnect_delay(node)) + 1);
 
 	if (node_num != o2nm_this_node()) {
-		/* heartbeat doesn't work unless a local node number is
-		 * configured and doing so brings up the o2net_wq, so we can
-		 * use it.. */
-		queue_delayed_work(o2net_wq, &nn->nn_connect_expired,
-		                   msecs_to_jiffies(o2net_idle_timeout(node)));
-
 		/* believe it or not, accept and node hearbeating testing
 		 * can succeed for this node before we got here.. so
 		 * only use set_nn_state to clear the persistent error
 		 * if that hasn't already happened */
 		spin_lock(&nn->nn_lock);
+		nn->nn_timeout = 0;
 		if (nn->nn_persistent_error)
 			o2net_set_nn_state(nn, NULL, 0, 0);
 		spin_unlock(&nn->nn_lock);
@@ -1748,6 +1758,7 @@ static int o2net_accept_one(struct socke
 	new_sock = NULL;
 
 	spin_lock(&nn->nn_lock);
+	nn->nn_timeout = 0;
 	o2net_set_nn_state(nn, sc, 0, 0);
 	spin_unlock(&nn->nn_lock);
 
diff --git a/fs/ocfs2/cluster/tcp_internal.h b/fs/ocfs2/cluster/tcp_internal.h
index 9606111..e85da65 100644
--- a/fs/ocfs2/cluster/tcp_internal.h
+++ b/fs/ocfs2/cluster/tcp_internal.h
@@ -78,6 +78,8 @@ struct o2net_node {
 	struct o2net_sock_container	*nn_sc;
 	/* _valid is only set after the handshake passes and tx can happen */
 	unsigned			nn_sc_valid:1;
+	/* It is only set after the idle time out. */
+	unsigned			nn_timeout:1;
 	/* if this is set tx just returns it */
 	int				nn_persistent_error;
 
-- 
1.3.3
