From: Adrian Bunk <bunk@kernel.org>
Date: Thu, 5 Jun 2008 21:25:40 +0300
Subject: [Ocfs2-devel] [2.6 patch] ocfs2/cluster/tcp.c: make some functions
	static
Message-ID: <20080605182539.GF1469@cs181133002.pp.htv.fi>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sunil Mushran <sunil.mushran@oracle.com>, Mark Fasheh <mfasheh@suse.com>, joel.becker@oracle.com
Cc: ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org

Commit 0f475b2abed6cbccee1da20a0bef2895eb2a0edd
(ocfs2/net: Silence build warnings) made sense
as far as it fixed compile warnings, but it was
not required that it made the functions global.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 fs/ocfs2/cluster/tcp.c          |   44 ++++++++++++++++++++++++++------
 fs/ocfs2/cluster/tcp_internal.h |   32 -----------------------
 2 files changed, 37 insertions(+), 39 deletions(-)

dd88fbb63c1952663eed2f1d93b85a95938cf37c diff --git a/fs/ocfs2/cluster/tcp.c b/fs/ocfs2/cluster/tcp.c
index a27d615..2bcf706 100644
--- a/fs/ocfs2/cluster/tcp.c
+++ b/fs/ocfs2/cluster/tcp.c
@@ -143,8 +143,8 @@ static void o2net_sc_postpone_idle(struct o2net_sock_container *sc);
 static void o2net_sc_reset_idle_timer(struct o2net_sock_container *sc);
 
 #ifdef CONFIG_DEBUG_FS
-void o2net_init_nst(struct o2net_send_tracking *nst, u32 msgtype,
-		    u32 msgkey, struct task_struct *task, u8 node)
+static void o2net_init_nst(struct o2net_send_tracking *nst, u32 msgtype,
+			   u32 msgkey, struct task_struct *task, u8 node)
 {
 	INIT_LIST_HEAD(&nst->st_net_debug_item);
 	nst->st_task = task;
@@ -153,31 +153,61 @@ void o2net_init_nst(struct o2net_send_tracking *nst, u32 msgtype,
 	nst->st_node = node;
 }
 
-void o2net_set_nst_sock_time(struct o2net_send_tracking *nst)
+static void o2net_set_nst_sock_time(struct o2net_send_tracking *nst)
 {
 	do_gettimeofday(&nst->st_sock_time);
 }
 
-void o2net_set_nst_send_time(struct o2net_send_tracking *nst)
+static void o2net_set_nst_send_time(struct o2net_send_tracking *nst)
 {
 	do_gettimeofday(&nst->st_send_time);
 }
 
-void o2net_set_nst_status_time(struct o2net_send_tracking *nst)
+static void o2net_set_nst_status_time(struct o2net_send_tracking *nst)
 {
 	do_gettimeofday(&nst->st_status_time);
 }
 
-void o2net_set_nst_sock_container(struct o2net_send_tracking *nst,
+static void o2net_set_nst_sock_container(struct o2net_send_tracking *nst,
 					 struct o2net_sock_container *sc)
 {
 	nst->st_sc = sc;
 }
 
-void o2net_set_nst_msg_id(struct o2net_send_tracking *nst, u32 msg_id)
+static void o2net_set_nst_msg_id(struct o2net_send_tracking *nst, u32 msg_id)
 {
 	nst->st_id = msg_id;
 }
+
+#else  /* CONFIG_DEBUG_FS */
+
+static inline void o2net_init_nst(struct o2net_send_tracking *nst, u32 msgtype,
+				  u32 msgkey, struct task_struct *task, u8 node)
+{
+}
+
+static inline void o2net_set_nst_sock_time(struct o2net_send_tracking *nst)
+{
+}
+
+static inline void o2net_set_nst_send_time(struct o2net_send_tracking *nst)
+{
+}
+
+static inline void o2net_set_nst_status_time(struct o2net_send_tracking *nst)
+{
+}
+
+static inline void o2net_set_nst_sock_container(struct o2net_send_tracking *nst,
+						struct o2net_sock_container *sc)
+{
+}
+
+static inline void o2net_set_nst_msg_id(struct o2net_send_tracking *nst,
+					u32 msg_id)
+{
+}
+
 #endif /* CONFIG_DEBUG_FS */
 
 static inline int o2net_reconnect_delay(void)
diff --git a/fs/ocfs2/cluster/tcp_internal.h b/fs/ocfs2/cluster/tcp_internal.h
index 18307ff..8d58cfe 100644
--- a/fs/ocfs2/cluster/tcp_internal.h
+++ b/fs/ocfs2/cluster/tcp_internal.h
@@ -224,42 +224,10 @@ struct o2net_send_tracking {
 	struct timeval			st_send_time;
 	struct timeval			st_status_time;
 };
-
-void o2net_init_nst(struct o2net_send_tracking *nst, u32 msgtype,
-		    u32 msgkey, struct task_struct *task, u8 node);
-void o2net_set_nst_sock_time(struct o2net_send_tracking *nst);
-void o2net_set_nst_send_time(struct o2net_send_tracking *nst);
-void o2net_set_nst_status_time(struct o2net_send_tracking *nst);
-void o2net_set_nst_sock_container(struct o2net_send_tracking *nst,
-				  struct o2net_sock_container *sc);
-void o2net_set_nst_msg_id(struct o2net_send_tracking *nst, u32 msg_id);
-
 #else
 struct o2net_send_tracking {
 	u32	dummy;
 };
-
-static inline void o2net_init_nst(struct o2net_send_tracking *nst, u32 msgtype,
-				  u32 msgkey, struct task_struct *task, u8 node)
-{
-}
-static inline void o2net_set_nst_sock_time(struct o2net_send_tracking *nst)
-{
-}
-static inline void o2net_set_nst_send_time(struct o2net_send_tracking *nst)
-{
-}
-static inline void o2net_set_nst_status_time(struct o2net_send_tracking *nst)
-{
-}
-static inline void o2net_set_nst_sock_container(struct o2net_send_tracking *nst,
-						struct o2net_sock_container *sc)
-{
-}
-static inline void o2net_set_nst_msg_id(struct o2net_send_tracking *nst,
-					u32 msg_id)
-{
-}
 #endif	/* CONFIG_DEBUG_FS */
 
 #endif /* O2CLUSTER_TCP_INTERNAL_H */
