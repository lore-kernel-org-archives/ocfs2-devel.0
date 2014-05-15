From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Thu, 15 May 2014 12:26:21 +0800
Subject: [Ocfs2-devel] [PATCH 1/3] ocfs2: o2net: don't shutdown connection
	when idle timeout
In-Reply-To: <1400127983-9774-1-git-send-email-junxiao.bi@oracle.com>
References: <1400127983-9774-1-git-send-email-junxiao.bi@oracle.com>
Message-ID: <1400127983-9774-2-git-send-email-junxiao.bi@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Some messages in the tcp queue maybe lost if we shutdown the connection
and reconnect when idle timeout. If packets lost and reconnect success,
then the ocfs2 cluster maybe hung.

To fix this, we can leave the connection there and do the fence decision
when idle timeout, if network recover before fence dicision is made, the
connection survive without lost any messages.

Reviewed-by: Srinivas Eeda <srinivas.eeda@oracle.com>
Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
---
 fs/ocfs2/cluster/tcp.c |   25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/fs/ocfs2/cluster/tcp.c b/fs/ocfs2/cluster/tcp.c
index c6b90e6..76ef3d8 100644
--- a/fs/ocfs2/cluster/tcp.c
+++ b/fs/ocfs2/cluster/tcp.c
@@ -1536,16 +1536,20 @@ static void o2net_idle_timer(unsigned long data)
 #endif
 
 	printk(KERN_NOTICE "o2net: Connection to " SC_NODEF_FMT " has been "
-	       "idle for %lu.%lu secs, shutting it down.\n", SC_NODEF_ARGS(sc),
-	       msecs / 1000, msecs % 1000);
+	       "idle for %lu.%lu secs.\n",
+	       SC_NODEF_ARGS(sc), msecs / 1000, msecs % 1000);
 
-	/*
-	 * Initialize the nn_timeout so that the next connection attempt
-	 * will continue in o2net_start_connect.
+	/* idle timerout happen, don't shutdown the connection, but
+	 * make fence decision. Maybe the connection can recover before
+	 * the decision is made.
 	 */
 	atomic_set(&nn->nn_timeout, 1);
+	o2quo_conn_err(o2net_num_from_nn(nn));
+	queue_delayed_work(o2net_wq, &nn->nn_still_up,
+			msecs_to_jiffies(O2NET_QUORUM_DELAY_MS));
+
+	o2net_sc_reset_idle_timer(sc);
 
-	o2net_sc_queue_work(sc, &sc->sc_shutdown_work);
 }
 
 static void o2net_sc_reset_idle_timer(struct o2net_sock_container *sc)
@@ -1560,6 +1564,15 @@ static void o2net_sc_reset_idle_timer(struct o2net_sock_container *sc)
 
 static void o2net_sc_postpone_idle(struct o2net_sock_container *sc)
 {
+	struct o2net_node *nn = o2net_nn_from_num(sc->sc_node->nd_num);
+
+	/* clear fence decision since the connection recover from timeout*/
+	if (atomic_read(&nn->nn_timeout)) {
+		o2quo_conn_up(o2net_num_from_nn(nn));
+		cancel_delayed_work(&nn->nn_still_up);
+		atomic_set(&nn->nn_timeout, 0);
+	}
+
 	/* Only push out an existing timer */
 	if (timer_pending(&sc->sc_idle_timeout))
 		o2net_sc_reset_idle_timer(sc);
-- 
1.7.9.5
