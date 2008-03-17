From: Jeff Mahoney <jeffm@suse.com>
Date: Mon Mar 17 11:06:59 2008
Subject: [Ocfs2-devel] [PATCH] o2nm: Get rid of arguments to the timeout
	routines
Message-ID: <47DEB30E.8060605@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1


 We keep seeing bug reports related to NULL pointer derefs in
 o2net_set_nn_state(). When I originally wrote up the configurable timeout
 patch, I had tried to plan for multiple clusters. This was silly.

 The timeout routines all use o2nm_single_cluster so there's no point
 in passing an argument at all. This patch removes the arguments and kills
 those bugs dead.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
- ---
 fs/ocfs2/cluster/tcp.c |   45 +++++++++++++++++++--------------------------
 1 file changed, 19 insertions(+), 26 deletions(-)

- --- a/fs/ocfs2/cluster/tcp.c
+++ b/fs/ocfs2/cluster/tcp.c
@@ -149,23 +149,17 @@ static void o2net_idle_timer(unsigned lo
 static void o2net_sc_postpone_idle(struct o2net_sock_container *sc);
 static void o2net_sc_reset_idle_timer(struct o2net_sock_container *sc);
 
- -/*
- - * FIXME: These should use to_o2nm_cluster_from_node(), but we end up
- - * losing our parent link to the cluster during shutdown. This can be
- - * solved by adding a pre-removal callback to configfs, or passing
- - * around the cluster with the node. -jeffm
- - */
- -static inline int o2net_reconnect_delay(struct o2nm_node *node)
+static inline int o2net_reconnect_delay(void)
 {
 	return o2nm_single_cluster->cl_reconnect_delay_ms;
 }
 
- -static inline int o2net_keepalive_delay(struct o2nm_node *node)
+static inline int o2net_keepalive_delay(void)
 {
 	return o2nm_single_cluster->cl_keepalive_delay_ms;
 }
 
- -static inline int o2net_idle_timeout(struct o2nm_node *node)
+static inline int o2net_idle_timeout(void)
 {
 	return o2nm_single_cluster->cl_idle_timeout_ms;
 }
@@ -451,9 +445,9 @@ static void o2net_set_nn_state(struct o2
 		/* delay if we're withing a RECONNECT_DELAY of the
 		 * last attempt */
 		delay = (nn->nn_last_connect_attempt +
- -			 msecs_to_jiffies(o2net_reconnect_delay(NULL)))
+			 msecs_to_jiffies(o2net_reconnect_delay()))
 			- jiffies;
- -		if (delay > msecs_to_jiffies(o2net_reconnect_delay(NULL)))
+		if (delay > msecs_to_jiffies(o2net_reconnect_delay()))
 			delay = 0;
 		mlog(ML_CONN, "queueing conn attempt in %lu jiffies\n", delay);
 		queue_delayed_work(o2net_wq, &nn->nn_connect_work, delay);
@@ -467,7 +461,7 @@ static void o2net_set_nn_state(struct o2
 		 * the connect_expired work will do anything.  The rest will see
 		 * that it's already queued and do nothing.
 		 */
- -		delay += msecs_to_jiffies(o2net_idle_timeout(sc->sc_node));
+		delay += msecs_to_jiffies(o2net_idle_timeout());
 		queue_delayed_work(o2net_wq, &nn->nn_connect_expired, delay);
 	}
 
@@ -1167,12 +1161,12 @@ static int o2net_check_handshake(struct 
 	 * but isn't. This can ultimately cause corruption.
 	 */
 	if (be32_to_cpu(hand->o2net_idle_timeout_ms) !=
- -				o2net_idle_timeout(sc->sc_node)) {
+				o2net_idle_timeout()) {
 		mlog(ML_NOTICE, SC_NODEF_FMT " uses a network idle timeout of "
 		     "%u ms, but we use %u ms locally.  disconnecting\n",
 		     SC_NODEF_ARGS(sc),
 		     be32_to_cpu(hand->o2net_idle_timeout_ms),
- -		     o2net_idle_timeout(sc->sc_node));
+		     o2net_idle_timeout());
 		o2net_ensure_shutdown(nn, sc, -ENOTCONN);
 		return -1;
 	}
@@ -1183,7 +1177,7 @@ static int o2net_check_handshake(struct 
 		     "%u ms, but we use %u ms locally.  disconnecting\n",
 		     SC_NODEF_ARGS(sc),
 		     be32_to_cpu(hand->o2net_keepalive_delay_ms),
- -		     o2net_keepalive_delay(sc->sc_node));
+		     o2net_keepalive_delay());
 		o2net_ensure_shutdown(nn, sc, -ENOTCONN);
 		return -1;
 	}
@@ -1361,12 +1355,11 @@ static void o2net_initialize_handshake(v
 {
 	o2net_hand->o2hb_heartbeat_timeout_ms = cpu_to_be32(
 		O2HB_MAX_WRITE_TIMEOUT_MS);
- -	o2net_hand->o2net_idle_timeout_ms = cpu_to_be32(
- -		o2net_idle_timeout(NULL));
+	o2net_hand->o2net_idle_timeout_ms = cpu_to_be32(o2net_idle_timeout());
 	o2net_hand->o2net_keepalive_delay_ms = cpu_to_be32(
- -		o2net_keepalive_delay(NULL));
+		o2net_keepalive_delay());
 	o2net_hand->o2net_reconnect_delay_ms = cpu_to_be32(
- -		o2net_reconnect_delay(NULL));
+		o2net_reconnect_delay());
 }
 
 /* ------------------------------------------------------------ */
@@ -1412,8 +1405,8 @@ static void o2net_idle_timer(unsigned lo
 
 	printk(KERN_INFO "o2net: connection to " SC_NODEF_FMT " has been idle for %u.%u "
 	     "seconds, shutting it down.\n", SC_NODEF_ARGS(sc),
- -		     o2net_idle_timeout(sc->sc_node) / 1000,
- -		     o2net_idle_timeout(sc->sc_node) % 1000);
+		     o2net_idle_timeout() / 1000,
+		     o2net_idle_timeout() % 1000);
 	mlog(ML_NOTICE, "here are some times that might help debug the "
 	     "situation: (tmr %ld.%ld now %ld.%ld dr %ld.%ld adv "
 	     "%ld.%ld:%ld.%ld func (%08x:%u) %ld.%ld:%ld.%ld)\n",
@@ -1441,10 +1434,10 @@ static void o2net_sc_reset_idle_timer(st
 {
 	o2net_sc_cancel_delayed_work(sc, &sc->sc_keepalive_work);
 	o2net_sc_queue_delayed_work(sc, &sc->sc_keepalive_work,
- -		      msecs_to_jiffies(o2net_keepalive_delay(sc->sc_node)));
+		      msecs_to_jiffies(o2net_keepalive_delay()));
 	do_gettimeofday(&sc->sc_tv_timer);
 	mod_timer(&sc->sc_idle_timeout,
- -	       jiffies + msecs_to_jiffies(o2net_idle_timeout(sc->sc_node)));
+	       jiffies + msecs_to_jiffies(o2net_idle_timeout()));
 }
 
 static void o2net_sc_postpone_idle(struct o2net_sock_container *sc)
@@ -1586,8 +1579,8 @@ static void o2net_connect_expired(kapi_w
 		mlog(ML_ERROR, "no connection established with node %u after "
 		     "%u.%u seconds, giving up and returning errors.\n",
 		     o2net_num_from_nn(nn),
- -		     o2net_idle_timeout(NULL) / 1000,
- -		     o2net_idle_timeout(NULL) % 1000);
+		     o2net_idle_timeout() / 1000,
+		     o2net_idle_timeout() % 1000);
 
 		o2net_set_nn_state(nn, NULL, 0, -ENOTCONN);
 	}
@@ -1642,7 +1635,7 @@ static void o2net_hb_node_up_cb(struct o
 
 	/* ensure an immediate connect attempt */
 	nn->nn_last_connect_attempt = jiffies -
- -		(msecs_to_jiffies(o2net_reconnect_delay(node)) + 1);
+		(msecs_to_jiffies(o2net_reconnect_delay()) + 1);
 
 	if (node_num != o2nm_this_node()) {
 		/* believe it or not, accept and node hearbeating testing

- -- 
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iD8DBQFH3rMOLPWxlyuTD7IRAocRAJ4i3+qUYoiN9wom7g/7Rpui2meKdQCcCqF+
8yLr8EpNrHtT7TnQRbJDbTg=
=EJce
-----END PGP SIGNATURE-----
