From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Wed, 22 Dec 2010 12:39:41 -0800
Subject: [Ocfs2-devel] [PATCH 5/6] ocfs2/cluster: Track process message
	timing stats for each socket
In-Reply-To: <1293050382-3636-1-git-send-email-sunil.mushran@oracle.com>
References: <1293050382-3636-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1293050382-3636-6-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Tracks total time taken to process messages received on a socket.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/cluster/tcp.c          |   15 +++++++++++++++
 fs/ocfs2/cluster/tcp_internal.h |    2 ++
 2 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/cluster/tcp.c b/fs/ocfs2/cluster/tcp.c
index 267f727..804a6bd 100644
--- a/fs/ocfs2/cluster/tcp.c
+++ b/fs/ocfs2/cluster/tcp.c
@@ -209,6 +209,11 @@ static inline void o2net_set_func_stop_time(struct o2net_sock_container *sc)
 {
 	sc->sc_tv_func_stop = ktime_get();
 }
+
+static ktime_t o2net_get_func_run_time(struct o2net_sock_container *sc)
+{
+	return ktime_sub(sc->sc_tv_func_stop, sc->sc_tv_func_start);
+}
 #else  /* CONFIG_DEBUG_FS */
 # define o2net_init_nst(a, b, c, d, e)
 # define o2net_set_nst_sock_time(a)
@@ -222,6 +227,7 @@ static inline void o2net_set_func_stop_time(struct o2net_sock_container *sc)
 # define o2net_set_advance_stop_time(a)
 # define o2net_set_func_start_time(a)
 # define o2net_set_func_stop_time(a)
+# define o2net_get_func_run_time(a)		(ktime_t)0
 #endif /* CONFIG_DEBUG_FS */
 
 #ifdef CONFIG_OCFS2_FS_STATS
@@ -240,6 +246,13 @@ static void o2net_update_send_stats(struct o2net_send_tracking *nst,
 	sc->sc_send_count++;
 }
 
+static void o2net_update_recv_stats(struct o2net_sock_container *sc)
+{
+	sc->sc_tv_process_total = ktime_add(sc->sc_tv_process_total,
+					    o2net_get_func_run_time(sc));
+	sc->sc_recv_count++;
+}
+
 #else
 
 # define o2net_update_send_stats(a, b)
@@ -1229,6 +1242,8 @@ static int o2net_process_message(struct o2net_sock_container *sc,
 					nmh->nh_func_data, &ret_data);
 	o2net_set_func_stop_time(sc);
 
+	o2net_update_recv_stats(sc);
+
 out_respond:
 	/* this destroys the hdr, so don't use it after this */
 	mutex_lock(&sc->sc_send_lock);
diff --git a/fs/ocfs2/cluster/tcp_internal.h b/fs/ocfs2/cluster/tcp_internal.h
index 640c6fc..4cbcb65 100644
--- a/fs/ocfs2/cluster/tcp_internal.h
+++ b/fs/ocfs2/cluster/tcp_internal.h
@@ -184,6 +184,8 @@ struct o2net_sock_container {
 	ktime_t			sc_tv_send_total;
 	ktime_t			sc_tv_status_total;
 	u32			sc_send_count;
+	u32			sc_recv_count;
+	ktime_t			sc_tv_process_total;
 #endif
 	struct mutex		sc_send_lock;
 };
-- 
1.7.1
