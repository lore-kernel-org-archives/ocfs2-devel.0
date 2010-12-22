From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Wed, 22 Dec 2010 12:39:39 -0800
Subject: [Ocfs2-devel] [PATCH 3/6] ocfs2/cluster: Use ktime instead of
	timeval in struct o2net_sock_container
In-Reply-To: <1293050382-3636-1-git-send-email-sunil.mushran@oracle.com>
References: <1293050382-3636-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1293050382-3636-4-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Replace time trackers in struct o2net_sock_container from struct timeval to
union ktime.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/cluster/netdebug.c     |   28 +++++------
 fs/ocfs2/cluster/tcp.c          |   93 ++++++++++++++++++++++----------------
 fs/ocfs2/cluster/tcp_internal.h |   19 ++++----
 3 files changed, 77 insertions(+), 63 deletions(-)

diff --git a/fs/ocfs2/cluster/netdebug.c b/fs/ocfs2/cluster/netdebug.c
index 2b986aa..536a93d 100644
--- a/fs/ocfs2/cluster/netdebug.c
+++ b/fs/ocfs2/cluster/netdebug.c
@@ -280,8 +280,6 @@ static void *sc_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 	return sc; /* unused, just needs to be null when done */
 }
 
-#define TV_SEC_USEC(TV) TV.tv_sec, (long)TV.tv_usec
-
 static int sc_seq_show(struct seq_file *seq, void *v)
 {
 	struct o2net_sock_container *sc, *dummy_sc = seq->private;
@@ -313,13 +311,13 @@ static int sc_seq_show(struct seq_file *seq, void *v)
 			   "  remote node:     %s\n"
 			   "  page off:        %zu\n"
 			   "  handshake ok:    %u\n"
-			   "  timer:           %lu.%ld\n"
-			   "  data ready:      %lu.%ld\n"
-			   "  advance start:   %lu.%ld\n"
-			   "  advance stop:    %lu.%ld\n"
-			   "  func start:      %lu.%ld\n"
-			   "  func stop:       %lu.%ld\n"
-			   "  func key:        %u\n"
+			   "  timer:           %lld usecs\n"
+			   "  data ready:      %lld usecs\n"
+			   "  advance start:   %lld usecs\n"
+			   "  advance stop:    %lld usecs\n"
+			   "  func start:      %lld usecs\n"
+			   "  func stop:       %lld usecs\n"
+			   "  func key:        0x%08x\n"
 			   "  func type:       %u\n",
 			   sc,
 			   atomic_read(&sc->sc_kref.refcount),
@@ -328,12 +326,12 @@ static int sc_seq_show(struct seq_file *seq, void *v)
 			   sc->sc_node->nd_name,
 			   sc->sc_page_off,
 			   sc->sc_handshake_ok,
-			   TV_SEC_USEC(sc->sc_tv_timer),
-			   TV_SEC_USEC(sc->sc_tv_data_ready),
-			   TV_SEC_USEC(sc->sc_tv_advance_start),
-			   TV_SEC_USEC(sc->sc_tv_advance_stop),
-			   TV_SEC_USEC(sc->sc_tv_func_start),
-			   TV_SEC_USEC(sc->sc_tv_func_stop),
+			   (long long)ktime_to_us(sc->sc_tv_timer),
+			   (long long)ktime_to_us(sc->sc_tv_data_ready),
+			   (long long)ktime_to_us(sc->sc_tv_advance_start),
+			   (long long)ktime_to_us(sc->sc_tv_advance_stop),
+			   (long long)ktime_to_us(sc->sc_tv_func_start),
+			   (long long)ktime_to_us(sc->sc_tv_func_stop),
 			   sc->sc_msg_key,
 			   sc->sc_msg_type);
 	}
diff --git a/fs/ocfs2/cluster/tcp.c b/fs/ocfs2/cluster/tcp.c
index 5996158..87b6306 100644
--- a/fs/ocfs2/cluster/tcp.c
+++ b/fs/ocfs2/cluster/tcp.c
@@ -153,61 +153,75 @@ static void o2net_init_nst(struct o2net_send_tracking *nst, u32 msgtype,
 	nst->st_node = node;
 }
 
-static void o2net_set_nst_sock_time(struct o2net_send_tracking *nst)
+static inline void o2net_set_nst_sock_time(struct o2net_send_tracking *nst)
 {
 	nst->st_sock_time = ktime_get();
 }
 
-static void o2net_set_nst_send_time(struct o2net_send_tracking *nst)
+static inline void o2net_set_nst_send_time(struct o2net_send_tracking *nst)
 {
 	nst->st_send_time = ktime_get();
 }
 
-static void o2net_set_nst_status_time(struct o2net_send_tracking *nst)
+static inline void o2net_set_nst_status_time(struct o2net_send_tracking *nst)
 {
 	nst->st_status_time = ktime_get();
 }
 
-static void o2net_set_nst_sock_container(struct o2net_send_tracking *nst,
-					 struct o2net_sock_container *sc)
+static inline void o2net_set_nst_sock_container(struct o2net_send_tracking *nst,
+						struct o2net_sock_container *sc)
 {
 	nst->st_sc = sc;
 }
 
-static void o2net_set_nst_msg_id(struct o2net_send_tracking *nst, u32 msg_id)
+static inline void o2net_set_nst_msg_id(struct o2net_send_tracking *nst,
+					u32 msg_id)
 {
 	nst->st_id = msg_id;
 }
 
-#else  /* CONFIG_DEBUG_FS */
-
-static inline void o2net_init_nst(struct o2net_send_tracking *nst, u32 msgtype,
-				  u32 msgkey, struct task_struct *task, u8 node)
+static inline void o2net_set_sock_timer(struct o2net_sock_container *sc)
 {
+	sc->sc_tv_timer = ktime_get();
 }
 
-static inline void o2net_set_nst_sock_time(struct o2net_send_tracking *nst)
+static inline void o2net_set_data_ready_time(struct o2net_sock_container *sc)
 {
+	sc->sc_tv_data_ready = ktime_get();
 }
 
-static inline void o2net_set_nst_send_time(struct o2net_send_tracking *nst)
+static inline void o2net_set_advance_start_time(struct o2net_sock_container *sc)
 {
+	sc->sc_tv_advance_start = ktime_get();
 }
 
-static inline void o2net_set_nst_status_time(struct o2net_send_tracking *nst)
+static inline void o2net_set_advance_stop_time(struct o2net_sock_container *sc)
 {
+	sc->sc_tv_advance_stop = ktime_get();
 }
 
-static inline void o2net_set_nst_sock_container(struct o2net_send_tracking *nst,
-						struct o2net_sock_container *sc)
+static inline void o2net_set_func_start_time(struct o2net_sock_container *sc)
 {
+	sc->sc_tv_func_start = ktime_get();
 }
 
-static inline void o2net_set_nst_msg_id(struct o2net_send_tracking *nst,
-					u32 msg_id)
+static inline void o2net_set_func_stop_time(struct o2net_sock_container *sc)
 {
+	sc->sc_tv_func_stop = ktime_get();
 }
-
+#else  /* CONFIG_DEBUG_FS */
+# define o2net_init_nst(a, b, c, d, e)
+# define o2net_set_nst_sock_time(a)
+# define o2net_set_nst_send_time(a)
+# define o2net_set_nst_status_time(a)
+# define o2net_set_nst_sock_container(a, b)
+# define o2net_set_nst_msg_id(a, b)
+# define o2net_set_sock_timer(a)
+# define o2net_set_data_ready_time(a)
+# define o2net_set_advance_start_time(a)
+# define o2net_set_advance_stop_time(a)
+# define o2net_set_func_start_time(a)
+# define o2net_set_func_stop_time(a)
 #endif /* CONFIG_DEBUG_FS */
 
 static inline int o2net_reconnect_delay(void)
@@ -546,7 +560,7 @@ static void o2net_data_ready(struct sock *sk, int bytes)
 	if (sk->sk_user_data) {
 		struct o2net_sock_container *sc = sk->sk_user_data;
 		sclog(sc, "data_ready hit\n");
-		do_gettimeofday(&sc->sc_tv_data_ready);
+		o2net_set_data_ready_time(sc);
 		o2net_sc_queue_work(sc, &sc->sc_rx_work);
 		ready = sc->sc_data_ready;
 	} else {
@@ -1183,13 +1197,13 @@ static int o2net_process_message(struct o2net_sock_container *sc,
 	if (syserr != O2NET_ERR_NONE)
 		goto out_respond;
 
-	do_gettimeofday(&sc->sc_tv_func_start);
+	o2net_set_func_start_time(sc);
 	sc->sc_msg_key = be32_to_cpu(hdr->key);
 	sc->sc_msg_type = be16_to_cpu(hdr->msg_type);
 	handler_status = (nmh->nh_func)(hdr, sizeof(struct o2net_msg) +
 					     be16_to_cpu(hdr->data_len),
 					nmh->nh_func_data, &ret_data);
-	do_gettimeofday(&sc->sc_tv_func_stop);
+	o2net_set_func_stop_time(sc);
 
 out_respond:
 	/* this destroys the hdr, so don't use it after this */
@@ -1300,7 +1314,7 @@ static int o2net_advance_rx(struct o2net_sock_container *sc)
 	size_t datalen;
 
 	sclog(sc, "receiving\n");
-	do_gettimeofday(&sc->sc_tv_advance_start);
+	o2net_set_advance_start_time(sc);
 
 	if (unlikely(sc->sc_handshake_ok == 0)) {
 		if(sc->sc_page_off < sizeof(struct o2net_handshake)) {
@@ -1375,7 +1389,7 @@ static int o2net_advance_rx(struct o2net_sock_container *sc)
 
 out:
 	sclog(sc, "ret = %d\n", ret);
-	do_gettimeofday(&sc->sc_tv_advance_stop);
+	o2net_set_advance_stop_time(sc);
 	return ret;
 }
 
@@ -1475,27 +1489,28 @@ static void o2net_idle_timer(unsigned long data)
 {
 	struct o2net_sock_container *sc = (struct o2net_sock_container *)data;
 	struct o2net_node *nn = o2net_nn_from_num(sc->sc_node->nd_num);
-	struct timeval now;
 
-	do_gettimeofday(&now);
+#ifdef CONFIG_DEBUG_FS
+	ktime_t now = ktime_get();
+#endif
 
 	printk(KERN_NOTICE "o2net: connection to " SC_NODEF_FMT " has been idle for %u.%u "
 	     "seconds, shutting it down.\n", SC_NODEF_ARGS(sc),
 		     o2net_idle_timeout() / 1000,
 		     o2net_idle_timeout() % 1000);
-	mlog(ML_NOTICE, "here are some times that might help debug the "
-	     "situation: (tmr %ld.%ld now %ld.%ld dr %ld.%ld adv "
-	     "%ld.%ld:%ld.%ld func (%08x:%u) %ld.%ld:%ld.%ld)\n",
-	     sc->sc_tv_timer.tv_sec, (long) sc->sc_tv_timer.tv_usec,
-	     now.tv_sec, (long) now.tv_usec,
-	     sc->sc_tv_data_ready.tv_sec, (long) sc->sc_tv_data_ready.tv_usec,
-	     sc->sc_tv_advance_start.tv_sec,
-	     (long) sc->sc_tv_advance_start.tv_usec,
-	     sc->sc_tv_advance_stop.tv_sec,
-	     (long) sc->sc_tv_advance_stop.tv_usec,
-	     sc->sc_msg_key, sc->sc_msg_type,
-	     sc->sc_tv_func_start.tv_sec, (long) sc->sc_tv_func_start.tv_usec,
-	     sc->sc_tv_func_stop.tv_sec, (long) sc->sc_tv_func_stop.tv_usec);
+
+#ifdef CONFIG_DEBUG_FS
+	mlog(ML_NOTICE, "Here are some times that might help debug the "
+	     "situation: (Timer: %lld, Now %lld, DataReady %lld, Advance %lld-%lld, "
+	     "Key 0x%08x, Func %u, FuncTime %lld-%lld)\n",
+	     (long long)ktime_to_us(sc->sc_tv_timer), (long long)ktime_to_us(now),
+	     (long long)ktime_to_us(sc->sc_tv_data_ready),
+	     (long long)ktime_to_us(sc->sc_tv_advance_start),
+	     (long long)ktime_to_us(sc->sc_tv_advance_stop),
+ 	     sc->sc_msg_key, sc->sc_msg_type,
+	     (long long)ktime_to_us(sc->sc_tv_func_start),
+	     (long long)ktime_to_us(sc->sc_tv_func_stop));
+#endif
 
 	/*
 	 * Initialize the nn_timeout so that the next connection attempt
@@ -1511,7 +1526,7 @@ static void o2net_sc_reset_idle_timer(struct o2net_sock_container *sc)
 	o2net_sc_cancel_delayed_work(sc, &sc->sc_keepalive_work);
 	o2net_sc_queue_delayed_work(sc, &sc->sc_keepalive_work,
 		      msecs_to_jiffies(o2net_keepalive_delay()));
-	do_gettimeofday(&sc->sc_tv_timer);
+	o2net_set_sock_timer(sc);
 	mod_timer(&sc->sc_idle_timeout,
 	       jiffies + msecs_to_jiffies(o2net_idle_timeout()));
 }
diff --git a/fs/ocfs2/cluster/tcp_internal.h b/fs/ocfs2/cluster/tcp_internal.h
index b613aaa..f815763 100644
--- a/fs/ocfs2/cluster/tcp_internal.h
+++ b/fs/ocfs2/cluster/tcp_internal.h
@@ -166,18 +166,19 @@ struct o2net_sock_container {
 	/* original handlers for the sockets */
 	void			(*sc_state_change)(struct sock *sk);
 	void			(*sc_data_ready)(struct sock *sk, int bytes);
-#ifdef CONFIG_DEBUG_FS
-	struct list_head        sc_net_debug_item;
-#endif
-	struct timeval 		sc_tv_timer;
-	struct timeval 		sc_tv_data_ready;
-	struct timeval 		sc_tv_advance_start;
-	struct timeval 		sc_tv_advance_stop;
-	struct timeval 		sc_tv_func_start;
-	struct timeval 		sc_tv_func_stop;
+
 	u32			sc_msg_key;
 	u16			sc_msg_type;
 
+#ifdef CONFIG_DEBUG_FS
+	struct list_head        sc_net_debug_item;
+	ktime_t			sc_tv_timer;
+	ktime_t			sc_tv_data_ready;
+	ktime_t			sc_tv_advance_start;
+	ktime_t			sc_tv_advance_stop;
+	ktime_t			sc_tv_func_start;
+	ktime_t			sc_tv_func_stop;
+#endif
 	struct mutex		sc_send_lock;
 };
 
-- 
1.7.1
