From: Mark Fasheh <mfasheh@suse.com>
Date: Wed,  2 Apr 2008 13:14:59 -0700
Subject: [Ocfs2-devel] [PATCH 49/62] ocfs2: Reconnect after idle time out.
In-Reply-To: <12071674193441-git-send-email-mfasheh@suse.com>
References: <12071673121124-git-send-email-mfasheh@suse.com>
	<1207167318479-git-send-email-mfasheh@suse.com>
	<12071673203909-git-send-email-mfasheh@suse.com>
	<12071673232465-git-send-email-mfasheh@suse.com>
	<12071673263948-git-send-email-mfasheh@suse.com>
	<12071673282579-git-send-email-mfasheh@suse.com>
	<1207167330482-git-send-email-mfasheh@suse.com>
	<12071673321172-git-send-email-mfasheh@suse.com>
	<12071673341888-git-send-email-mfasheh@suse.com>
	<12071673362069-git-send-email-mfasheh@suse.com>
	<12071673391031-git-send-email-mfasheh@suse.com>
	<12071673413492-git-send-email-mfasheh@suse.com>
	<1207167343926-git-send-email-mfasheh@suse.com>
	<12071673461268-git-send-email-mfasheh@suse.com>
	<12071673481928-git-send-email-mfasheh@suse.com>
	<12071673492775-git-send-email-mfasheh@suse.com>
	<12071673511262-git-send-email-mfasheh@suse.com>
	<12071673543752-git-send-email-mfasheh@suse.com>
	<1207167355295-git-send-email-mfasheh@suse.com>
	<12071673571757-git-send-email-mfasheh@suse.com>
	<12071673591158-git-send-email-mfasheh@suse.com>
	<12071673613757-git-send-email-mfasheh@suse.com>
	<1207167363119-git-send-email-mfasheh@suse.com>
	<12071673661674-git-send-email-mfasheh@suse.com>
	<12071673681650-git-send-email-mfasheh@suse.com>
	<12071673701937-git-send-email-mfasheh@suse.com>
	<12071673722691-git-send-email-mfasheh@suse.com>
	<12071673731276-git-send-email-mfasheh@suse.com>
	<12071673753788-git-send-email-mfasheh@suse.com>
	<12071673772233-git-send-email-mfasheh@suse.com>
	<1207167379283-git-send-email-mfasheh@suse.com>
	<12071673821008-git-send-email-mfasheh@suse.com>
	<12071673843208-git-send-email-mfasheh@suse.com>
	<12071673872568-git-send-email-mfasheh@suse.com>
	<12071673882492-git-send-email-mfasheh@suse.com>
	<1207167390414-git-send-email-mfasheh@suse.com>
	<1207167392537-git-send-email-mfasheh@suse.com>
	<12071673941659-git-send-email-mfasheh@suse.com>
	<12071673964014-git-send-email-mfasheh@suse.com>
	<1207167398684-git-send-email-mfasheh@suse.com>
	<12071674013954-git-send-email-mfasheh@suse.com>
	<12071674033903-git-send-email-mfasheh@suse.com>
	<12071674061934-git-send-email-mfasheh@suse.com>
	<12071674083120-git-send-email-mfasheh@suse.com>
	<12071674103432-git-send-email-mfasheh@suse.com>
	<1207167413855-git-send-email-mfasheh@suse.com>
	<12071674151752-git-send-email-mfasheh@suse.com>
	<12071674171596-git-send-email-mfasheh@suse.com>
	<12071674193441-git-send-email-mfasheh@suse.com>
Message-ID: <12071674213882-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>, Tao Ma <tao.ma@oracle.com>

From: Tao Ma <tao.ma@oracle.com>

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
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/cluster/tcp.c          |   51 +++++++++++++++++++++++++++-----------
 fs/ocfs2/cluster/tcp_internal.h |    2 +
 2 files changed, 38 insertions(+), 15 deletions(-)

diff --git a/fs/ocfs2/cluster/tcp.c b/fs/ocfs2/cluster/tcp.c
index b8057c5..4ea4b0a 100644
--- a/fs/ocfs2/cluster/tcp.c
+++ b/fs/ocfs2/cluster/tcp.c
@@ -399,8 +399,6 @@ static void o2net_set_nn_state(struct o2net_node *nn,
 	mlog_bug_on_msg(err && valid, "err %d valid %u\n", err, valid);
 	mlog_bug_on_msg(valid && !sc, "valid %u sc %p\n", valid, sc);
 
-	/* we won't reconnect after our valid conn goes away for
-	 * this hb iteration.. here so it shows up in the logs */
 	if (was_valid && !valid && err == 0)
 		err = -ENOTCONN;
 
@@ -430,11 +428,6 @@ static void o2net_set_nn_state(struct o2net_node *nn,
 
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
@@ -457,6 +450,18 @@ static void o2net_set_nn_state(struct o2net_node *nn,
 			delay = 0;
 		mlog(ML_CONN, "queueing conn attempt in %lu jiffies\n", delay);
 		queue_delayed_work(o2net_wq, &nn->nn_connect_work, delay);
+
+		/*
+		 * Delay the expired work after idle timeout.
+		 *
+		 * We might have lots of failed connection attempts that run
+		 * through here but we only cancel the connect_expired work when
+		 * a connection attempt succeeds.  So only the first enqueue of
+		 * the connect_expired work will do anything.  The rest will see
+		 * that it's already queued and do nothing.
+		 */
+		delay += msecs_to_jiffies(o2net_idle_timeout(NULL));
+		queue_delayed_work(o2net_wq, &nn->nn_connect_expired, delay);
 	}
 
 	/* keep track of the nn's sc ref for the caller */
@@ -1193,6 +1198,7 @@ static int o2net_check_handshake(struct o2net_sock_container *sc)
 	 * shut down already */
 	if (nn->nn_sc == sc) {
 		o2net_sc_reset_idle_timer(sc);
+		atomic_set(&nn->nn_timeout, 0);
 		o2net_set_nn_state(nn, sc, 1, 0);
 	}
 	spin_unlock(&nn->nn_lock);
@@ -1391,6 +1397,7 @@ static void o2net_sc_send_keep_req(struct work_struct *work)
 static void o2net_idle_timer(unsigned long data)
 {
 	struct o2net_sock_container *sc = (struct o2net_sock_container *)data;
+	struct o2net_node *nn = o2net_nn_from_num(sc->sc_node->nd_num);
 	struct timeval now;
 
 	do_gettimeofday(&now);
@@ -1413,6 +1420,12 @@ static void o2net_idle_timer(unsigned long data)
 	     sc->sc_tv_func_start.tv_sec, (long) sc->sc_tv_func_start.tv_usec,
 	     sc->sc_tv_func_stop.tv_sec, (long) sc->sc_tv_func_stop.tv_usec);
 
+	/*
+	 * Initialize the nn_timeout so that the next connection attempt
+	 * will continue in o2net_start_connect.
+	 */
+	atomic_set(&nn->nn_timeout, 1);
+
 	o2net_sc_queue_work(sc, &sc->sc_shutdown_work);
 }
 
@@ -1447,6 +1460,7 @@ static void o2net_start_connect(struct work_struct *work)
 	struct socket *sock = NULL;
 	struct sockaddr_in myaddr = {0, }, remoteaddr = {0, };
 	int ret = 0, stop;
+	unsigned int timeout;
 
 	/* if we're greater we initiate tx, otherwise we accept */
 	if (o2nm_this_node() <= o2net_num_from_nn(nn))
@@ -1466,8 +1480,17 @@ static void o2net_start_connect(struct work_struct *work)
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
+	timeout = atomic_read(&nn->nn_timeout);
+	stop = (nn->nn_sc ||
+		(nn->nn_persistent_error &&
+		(nn->nn_persistent_error != -ENOTCONN || timeout == 0)));
 	spin_unlock(&nn->nn_lock);
 	if (stop)
 		goto out;
@@ -1579,6 +1602,7 @@ void o2net_disconnect_node(struct o2nm_node *node)
 
 	/* don't reconnect until it's heartbeating again */
 	spin_lock(&nn->nn_lock);
+	atomic_set(&nn->nn_timeout, 0);
 	o2net_set_nn_state(nn, NULL, 0, -ENOTCONN);
 	spin_unlock(&nn->nn_lock);
 
@@ -1613,17 +1637,12 @@ static void o2net_hb_node_up_cb(struct o2nm_node *node, int node_num,
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
+		atomic_set(&nn->nn_timeout, 0);
 		if (nn->nn_persistent_error)
 			o2net_set_nn_state(nn, NULL, 0, 0);
 		spin_unlock(&nn->nn_lock);
@@ -1747,6 +1766,7 @@ static int o2net_accept_one(struct socket *sock)
 	new_sock = NULL;
 
 	spin_lock(&nn->nn_lock);
+	atomic_set(&nn->nn_timeout, 0);
 	o2net_set_nn_state(nn, sc, 0, 0);
 	spin_unlock(&nn->nn_lock);
 
@@ -1941,6 +1961,7 @@ int o2net_init(void)
 	for (i = 0; i < ARRAY_SIZE(o2net_nodes); i++) {
 		struct o2net_node *nn = o2net_nn_from_num(i);
 
+		atomic_set(&nn->nn_timeout, 0);
 		spin_lock_init(&nn->nn_lock);
 		INIT_DELAYED_WORK(&nn->nn_connect_work, o2net_start_connect);
 		INIT_DELAYED_WORK(&nn->nn_connect_expired,
diff --git a/fs/ocfs2/cluster/tcp_internal.h b/fs/ocfs2/cluster/tcp_internal.h
index d25b9af..b4c5586 100644
--- a/fs/ocfs2/cluster/tcp_internal.h
+++ b/fs/ocfs2/cluster/tcp_internal.h
@@ -95,6 +95,8 @@ struct o2net_node {
 	unsigned			nn_sc_valid:1;
 	/* if this is set tx just returns it */
 	int				nn_persistent_error;
+	/* It is only set to 1 after the idle time out. */
+	atomic_t			nn_timeout;
 
 	/* threads waiting for an sc to arrive wait on the wq for generation
 	 * to increase.  it is increased when a connecting socket succeeds
-- 
1.5.4.1
