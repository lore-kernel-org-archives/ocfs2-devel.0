From: Srinivas Eeda <srinivas.eeda@oracle.com>
Date: Thu, 28 Jan 2010 20:51:09 -0800
Subject: [Ocfs2-devel] [PATCH 1/3] o2net: rollback reconnect on network
	timeout.
In-Reply-To: <1264740671-908-1-git-send-email-srinivas.eeda@oracle.com>
References: <1264740671-908-1-git-send-email-srinivas.eeda@oracle.com>
Message-ID: <1264740671-908-2-git-send-email-srinivas.eeda@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This patch rollbacks earlier fix that tries to re-establish network connection
when network timeout happens. Reconnect was re-cycling sockets which results
in lost messages resulting in hangs.

Signed-off-by: Srinivas Eeda <srinivas.eeda@oracle.com>
---
 fs/ocfs2/cluster/tcp.c          |   50 +++++++++++----------------------------
 fs/ocfs2/cluster/tcp_internal.h |    2 -
 2 files changed, 14 insertions(+), 38 deletions(-)

diff --git a/fs/ocfs2/cluster/tcp.c b/fs/ocfs2/cluster/tcp.c
index 334f231..d81acff 100644
--- a/fs/ocfs2/cluster/tcp.c
+++ b/fs/ocfs2/cluster/tcp.c
@@ -463,6 +463,8 @@ static void o2net_set_nn_state(struct o2net_node *nn,
 	mlog_bug_on_msg(err && valid, "err %d valid %u\n", err, valid);
 	mlog_bug_on_msg(valid && !sc, "valid %u sc %p\n", valid, sc);
 
+	/* we won't reconnect after our valid conn goes away for
+	 * this hb iteration.. here so it shows up in the logs */
 	if (was_valid && !valid && err == 0)
 		err = -ENOTCONN;
 
@@ -491,6 +493,11 @@ static void o2net_set_nn_state(struct o2net_node *nn,
 	}
 
 	if (!was_valid && valid) {
+		/* this is a bit of a hack.  we only try reconnecting
+		 * when heartbeating starts until we get a connection.
+		 * if that connection then dies we don't try reconnecting.
+		 * the only way to start connecting again is to down
+		 * heartbeat and bring it back up. */
 		o2quo_conn_up(o2net_num_from_nn(nn));
 		cancel_delayed_work(&nn->nn_connect_expired);
 		printk(KERN_INFO "o2net: %s " SC_NODEF_FMT "\n",
@@ -514,18 +521,6 @@ static void o2net_set_nn_state(struct o2net_node *nn,
 			delay = 0;
 		mlog(ML_CONN, "queueing conn attempt in %lu jiffies\n", delay);
 		queue_delayed_work(o2net_wq, &nn->nn_connect_work, delay);
-
-		/*
-		 * Delay the expired work after idle timeout.
-		 *
-		 * We might have lots of failed connection attempts that run
-		 * through here but we only cancel the connect_expired work when
-		 * a connection attempt succeeds.  So only the first enqueue of
-		 * the connect_expired work will do anything.  The rest will see
-		 * that it's already queued and do nothing.
-		 */
-		delay += msecs_to_jiffies(o2net_idle_timeout());
-		queue_delayed_work(o2net_wq, &nn->nn_connect_expired, delay);
 	}
 
 	/* keep track of the nn's sc ref for the caller */
@@ -1273,7 +1268,6 @@ static int o2net_check_handshake(struct o2net_sock_container *sc)
 	 * shut down already */
 	if (nn->nn_sc == sc) {
 		o2net_sc_reset_idle_timer(sc);
-		atomic_set(&nn->nn_timeout, 0);
 		o2net_set_nn_state(nn, sc, 1, 0);
 	}
 	spin_unlock(&nn->nn_lock);
@@ -1471,7 +1465,6 @@ static void o2net_sc_send_keep_req(struct work_struct *work)
 static void o2net_idle_timer(unsigned long data)
 {
 	struct o2net_sock_container *sc = (struct o2net_sock_container *)data;
-	struct o2net_node *nn = o2net_nn_from_num(sc->sc_node->nd_num);
 	struct timeval now;
 
 	do_gettimeofday(&now);
@@ -1494,12 +1487,6 @@ static void o2net_idle_timer(unsigned long data)
 	     sc->sc_tv_func_start.tv_sec, (long) sc->sc_tv_func_start.tv_usec,
 	     sc->sc_tv_func_stop.tv_sec, (long) sc->sc_tv_func_stop.tv_usec);
 
-	/*
-	 * Initialize the nn_timeout so that the next connection attempt
-	 * will continue in o2net_start_connect.
-	 */
-	atomic_set(&nn->nn_timeout, 1);
-
 	o2net_sc_queue_work(sc, &sc->sc_shutdown_work);
 }
 
@@ -1534,7 +1521,6 @@ static void o2net_start_connect(struct work_struct *work)
 	struct socket *sock = NULL;
 	struct sockaddr_in myaddr = {0, }, remoteaddr = {0, };
 	int ret = 0, stop;
-	unsigned int timeout;
 
 	/* if we're greater we initiate tx, otherwise we accept */
 	if (o2nm_this_node() <= o2net_num_from_nn(nn))
@@ -1554,17 +1540,8 @@ static void o2net_start_connect(struct work_struct *work)
 	}
 
 	spin_lock(&nn->nn_lock);
-	/*
-	 * see if we already have one pending or have given up.
-	 * For nn_timeout, it is set when we close the connection
-	 * because of the idle time out. So it means that we have
-	 * at least connected to that node successfully once,
-	 * now try to connect to it again.
-	 */
-	timeout = atomic_read(&nn->nn_timeout);
-	stop = (nn->nn_sc ||
-		(nn->nn_persistent_error &&
-		(nn->nn_persistent_error != -ENOTCONN || timeout == 0)));
+	/* see if we already have one pending or have given up */
+	stop = (nn->nn_sc || nn->nn_persistent_error);
 	spin_unlock(&nn->nn_lock);
 	if (stop)
 		goto out;
@@ -1676,7 +1653,6 @@ void o2net_disconnect_node(struct o2nm_node *node)
 
 	/* don't reconnect until it's heartbeating again */
 	spin_lock(&nn->nn_lock);
-	atomic_set(&nn->nn_timeout, 0);
 	o2net_set_nn_state(nn, NULL, 0, -ENOTCONN);
 	spin_unlock(&nn->nn_lock);
 
@@ -1711,12 +1687,16 @@ static void o2net_hb_node_up_cb(struct o2nm_node *node, int node_num,
 		(msecs_to_jiffies(o2net_reconnect_delay()) + 1);
 
 	if (node_num != o2nm_this_node()) {
+		/* heartbeat doesn't work unless a local node number is
+		 * configured and doing so brings up the o2net_wq, so we can
+		 * use it.. */
+		queue_delayed_work(o2net_wq, &nn->nn_connect_expired,
+				   msecs_to_jiffies(o2net_idle_timeout()));
 		/* believe it or not, accept and node hearbeating testing
 		 * can succeed for this node before we got here.. so
 		 * only use set_nn_state to clear the persistent error
 		 * if that hasn't already happened */
 		spin_lock(&nn->nn_lock);
-		atomic_set(&nn->nn_timeout, 0);
 		if (nn->nn_persistent_error)
 			o2net_set_nn_state(nn, NULL, 0, 0);
 		spin_unlock(&nn->nn_lock);
@@ -1839,7 +1819,6 @@ static int o2net_accept_one(struct socket *sock)
 	new_sock = NULL;
 
 	spin_lock(&nn->nn_lock);
-	atomic_set(&nn->nn_timeout, 0);
 	o2net_set_nn_state(nn, sc, 0, 0);
 	spin_unlock(&nn->nn_lock);
 
@@ -2037,7 +2016,6 @@ int o2net_init(void)
 	for (i = 0; i < ARRAY_SIZE(o2net_nodes); i++) {
 		struct o2net_node *nn = o2net_nn_from_num(i);
 
-		atomic_set(&nn->nn_timeout, 0);
 		spin_lock_init(&nn->nn_lock);
 		INIT_DELAYED_WORK(&nn->nn_connect_work, o2net_start_connect);
 		INIT_DELAYED_WORK(&nn->nn_connect_expired,
diff --git a/fs/ocfs2/cluster/tcp_internal.h b/fs/ocfs2/cluster/tcp_internal.h
index 8d58cfe..df36e1b 100644
--- a/fs/ocfs2/cluster/tcp_internal.h
+++ b/fs/ocfs2/cluster/tcp_internal.h
@@ -95,8 +95,6 @@ struct o2net_node {
 	unsigned			nn_sc_valid:1;
 	/* if this is set tx just returns it */
 	int				nn_persistent_error;
-	/* It is only set to 1 after the idle time out. */
-	atomic_t			nn_timeout;
 
 	/* threads waiting for an sc to arrive wait on the wq for generation
 	 * to increase.  it is increased when a connecting socket succeeds
-- 
1.5.6.5
