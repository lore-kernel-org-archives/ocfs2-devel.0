From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Mon, 12 May 2008 18:31:37 -0700
Subject: [Ocfs2-devel] [PATCH 3/3] ocfs2/net: Silence build warnings
In-Reply-To: <1210642297-23180-1-git-send-email-sunil.mushran@oracle.com>
References: <1210642297-23180-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1210642297-23180-3-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This patch silences the build warnings concerning o2net_init_nst()
and friends when building without CONFIG_DEBUG_FS enabled.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/cluster/tcp.c          |   28 +++++++++-------------------
 fs/ocfs2/cluster/tcp_internal.h |   32 ++++++++++++++++++++++++++++++++
 2 files changed, 41 insertions(+), 19 deletions(-)

diff --git a/fs/ocfs2/cluster/tcp.c b/fs/ocfs2/cluster/tcp.c
index 1e44ad1..a27d615 100644
--- a/fs/ocfs2/cluster/tcp.c
+++ b/fs/ocfs2/cluster/tcp.c
@@ -142,53 +142,43 @@ static void o2net_idle_timer(unsigned long data);
 static void o2net_sc_postpone_idle(struct o2net_sock_container *sc);
 static void o2net_sc_reset_idle_timer(struct o2net_sock_container *sc);
 
-static void o2net_init_nst(struct o2net_send_tracking *nst, u32 msgtype,
-			   u32 msgkey, struct task_struct *task, u8 node)
-{
 #ifdef CONFIG_DEBUG_FS
+void o2net_init_nst(struct o2net_send_tracking *nst, u32 msgtype,
+		    u32 msgkey, struct task_struct *task, u8 node)
+{
 	INIT_LIST_HEAD(&nst->st_net_debug_item);
 	nst->st_task = task;
 	nst->st_msg_type = msgtype;
 	nst->st_msg_key = msgkey;
 	nst->st_node = node;
-#endif
 }
 
-static void o2net_set_nst_sock_time(struct o2net_send_tracking *nst)
+void o2net_set_nst_sock_time(struct o2net_send_tracking *nst)
 {
-#ifdef CONFIG_DEBUG_FS
 	do_gettimeofday(&nst->st_sock_time);
-#endif
 }
 
-static void o2net_set_nst_send_time(struct o2net_send_tracking *nst)
+void o2net_set_nst_send_time(struct o2net_send_tracking *nst)
 {
-#ifdef CONFIG_DEBUG_FS
 	do_gettimeofday(&nst->st_send_time);
-#endif
 }
 
-static void o2net_set_nst_status_time(struct o2net_send_tracking *nst)
+void o2net_set_nst_status_time(struct o2net_send_tracking *nst)
 {
-#ifdef CONFIG_DEBUG_FS
 	do_gettimeofday(&nst->st_status_time);
-#endif
 }
 
-static void o2net_set_nst_sock_container(struct o2net_send_tracking *nst,
+void o2net_set_nst_sock_container(struct o2net_send_tracking *nst,
 					 struct o2net_sock_container *sc)
 {
-#ifdef CONFIG_DEBUG_FS
 	nst->st_sc = sc;
-#endif
 }
 
-static void o2net_set_nst_msg_id(struct o2net_send_tracking *nst, u32 msg_id)
+void o2net_set_nst_msg_id(struct o2net_send_tracking *nst, u32 msg_id)
 {
-#ifdef CONFIG_DEBUG_FS
 	nst->st_id = msg_id;
-#endif
 }
+#endif /* CONFIG_DEBUG_FS */
 
 static inline int o2net_reconnect_delay(void)
 {
diff --git a/fs/ocfs2/cluster/tcp_internal.h b/fs/ocfs2/cluster/tcp_internal.h
index 8d58cfe..18307ff 100644
--- a/fs/ocfs2/cluster/tcp_internal.h
+++ b/fs/ocfs2/cluster/tcp_internal.h
@@ -224,10 +224,42 @@ struct o2net_send_tracking {
 	struct timeval			st_send_time;
 	struct timeval			st_status_time;
 };
+
+void o2net_init_nst(struct o2net_send_tracking *nst, u32 msgtype,
+		    u32 msgkey, struct task_struct *task, u8 node);
+void o2net_set_nst_sock_time(struct o2net_send_tracking *nst);
+void o2net_set_nst_send_time(struct o2net_send_tracking *nst);
+void o2net_set_nst_status_time(struct o2net_send_tracking *nst);
+void o2net_set_nst_sock_container(struct o2net_send_tracking *nst,
+				  struct o2net_sock_container *sc);
+void o2net_set_nst_msg_id(struct o2net_send_tracking *nst, u32 msg_id);
+
 #else
 struct o2net_send_tracking {
 	u32	dummy;
 };
+
+static inline void o2net_init_nst(struct o2net_send_tracking *nst, u32 msgtype,
+				  u32 msgkey, struct task_struct *task, u8 node)
+{
+}
+static inline void o2net_set_nst_sock_time(struct o2net_send_tracking *nst)
+{
+}
+static inline void o2net_set_nst_send_time(struct o2net_send_tracking *nst)
+{
+}
+static inline void o2net_set_nst_status_time(struct o2net_send_tracking *nst)
+{
+}
+static inline void o2net_set_nst_sock_container(struct o2net_send_tracking *nst,
+						struct o2net_sock_container *sc)
+{
+}
+static inline void o2net_set_nst_msg_id(struct o2net_send_tracking *nst,
+					u32 msg_id)
+{
+}
 #endif	/* CONFIG_DEBUG_FS */
 
 #endif /* O2CLUSTER_TCP_INTERNAL_H */
-- 
1.5.3.6
