From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Wed, 22 Dec 2010 12:39:40 -0800
Subject: [Ocfs2-devel] [PATCH 4/6] ocfs2/cluster: Track send message timing
	stats for each socket
In-Reply-To: <1293050382-3636-1-git-send-email-sunil.mushran@oracle.com>
References: <1293050382-3636-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1293050382-3636-5-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Tracks total send and status times for all messages sent on a socket.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/cluster/tcp.c          |   24 ++++++++++++++++++++++++
 fs/ocfs2/cluster/tcp_internal.h |    6 ++++++
 2 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/cluster/tcp.c b/fs/ocfs2/cluster/tcp.c
index 87b6306..267f727 100644
--- a/fs/ocfs2/cluster/tcp.c
+++ b/fs/ocfs2/cluster/tcp.c
@@ -224,6 +224,28 @@ static inline void o2net_set_func_stop_time(struct o2net_sock_container *sc)
 # define o2net_set_func_stop_time(a)
 #endif /* CONFIG_DEBUG_FS */
 
+#ifdef CONFIG_OCFS2_FS_STATS
+static void o2net_update_send_stats(struct o2net_send_tracking *nst,
+				    struct o2net_sock_container *sc)
+{
+	sc->sc_tv_status_total = ktime_add(sc->sc_tv_status_total,
+					   ktime_sub(ktime_get(),
+						     nst->st_status_time));
+	sc->sc_tv_send_total = ktime_add(sc->sc_tv_send_total,
+					 ktime_sub(nst->st_status_time,
+						   nst->st_send_time));
+	sc->sc_tv_acquiry_total = ktime_add(sc->sc_tv_acquiry_total,
+					    ktime_sub(nst->st_send_time,
+						      nst->st_sock_time));
+	sc->sc_send_count++;
+}
+
+#else
+
+# define o2net_update_send_stats(a, b)
+
+#endif /* CONFIG_OCFS2_FS_STATS */
+
 static inline int o2net_reconnect_delay(void)
 {
 	return o2nm_single_cluster->cl_reconnect_delay_ms;
@@ -1084,6 +1106,8 @@ int o2net_send_message_vec(u32 msg_type, u32 key, struct kvec *caller_vec,
 	o2net_set_nst_status_time(&nst);
 	wait_event(nsw.ns_wq, o2net_nsw_completed(nn, &nsw));
 
+	o2net_update_send_stats(&nst, sc);
+
 	/* Note that we avoid overwriting the callers status return
 	 * variable if a system error was reported on the other
 	 * side. Callers beware. */
diff --git a/fs/ocfs2/cluster/tcp_internal.h b/fs/ocfs2/cluster/tcp_internal.h
index f815763..640c6fc 100644
--- a/fs/ocfs2/cluster/tcp_internal.h
+++ b/fs/ocfs2/cluster/tcp_internal.h
@@ -179,6 +179,12 @@ struct o2net_sock_container {
 	ktime_t			sc_tv_func_start;
 	ktime_t			sc_tv_func_stop;
 #endif
+#ifdef CONFIG_OCFS2_FS_STATS
+	ktime_t			sc_tv_acquiry_total;
+	ktime_t			sc_tv_send_total;
+	ktime_t			sc_tv_status_total;
+	u32			sc_send_count;
+#endif
 	struct mutex		sc_send_lock;
 };
 
-- 
1.7.1
