From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Mon,  9 Nov 2009 18:00:04 -0800
Subject: [Ocfs2-devel] [PATCH 01/10] ocfs2: Handle workqueue changes
In-Reply-To: <1257818413-32014-1-git-send-email-sunil.mushran@oracle.com>
References: <1257818413-32014-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1257818413-32014-2-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mainline commit 52bad64d95bd89e08c49ec5a071fa6dcbe5a1a9c introduced
struct delayed_work to separate delayable and non-delayable work.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 Config.make.in                  |    2 +
 Makefile                        |    3 +-
 configure.in                    |    6 +++
 fs/ocfs2/Makefile               |    4 ++
 fs/ocfs2/alloc.c                |   11 +++---
 fs/ocfs2/cluster/Makefile       |    4 ++
 fs/ocfs2/cluster/heartbeat.c    |   10 +++---
 fs/ocfs2/cluster/quorum.c       |    4 +-
 fs/ocfs2/cluster/tcp.c          |   65 ++++++++++++++++++++------------------
 fs/ocfs2/dcache.c               |    6 ++--
 fs/ocfs2/dcache.h               |    2 +-
 fs/ocfs2/dlm/Makefile           |    4 ++
 fs/ocfs2/dlm/dlmcommon.h        |    2 +-
 fs/ocfs2/dlm/dlmdomain.c        |    2 +-
 fs/ocfs2/dlm/dlmrecovery.c      |    4 +-
 fs/ocfs2/dlm/userdlm.c          |    9 +++--
 fs/ocfs2/journal.c              |   12 +++---
 fs/ocfs2/journal.h              |    2 +-
 fs/ocfs2/localalloc.c           |    6 ++--
 fs/ocfs2/localalloc.h           |    2 +-
 fs/ocfs2/quota_global.c         |   12 +++---
 fs/ocfs2/super.c                |    6 ++--
 kapi-compat/include/workqueue.h |   17 ++++++++++
 23 files changed, 118 insertions(+), 77 deletions(-)
 create mode 100644 kapi-compat/include/workqueue.h

diff --git a/Config.make.in b/Config.make.in
index 4e008fb..cf292b6 100644
--- a/Config.make.in
+++ b/Config.make.in
@@ -57,6 +57,8 @@ MAKEBO_VERSION = @VERSION@
 
 EXTRA_CFLAGS += @KAPI_COMPAT_CFLAGS@
 
+NO_DELAYED_WORK_STRUCT = @NO_DELAYED_WORK_STRUCT@
+
 
 OCFS_DEBUG = @OCFS_DEBUG@
 
diff --git a/Makefile b/Makefile
index e335ac9..262bc49 100644
--- a/Makefile
+++ b/Makefile
@@ -8,7 +8,8 @@ SUBDIRS = fs vendor
 
 LINUX_INCLUDE_FILES =
 
-KAPI_COMPAT_FILES = 
+KAPI_COMPAT_FILES = \
+	kapi-compat/include/workqueue.h
 
 PATCH_FILES =
 
diff --git a/configure.in b/configure.in
index ad06385..acbe098 100644
--- a/configure.in
+++ b/configure.in
@@ -158,6 +158,12 @@ esac
 
 # Begin kapi_compat checks
 
+NO_DELAYED_WORK_STRUCT=
+OCFS2_CHECK_KERNEL([struct delayed_work in workqueue.h], workqueue.h,
+  , NO_DELAYED_WORK_STRUCT=yes, [^struct delayed_work])
+AC_SUBST(NO_DELAYED_WORK_STRUCT)
+KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS workqueue.h"
+
 
 # End kapi_compat checks
 
diff --git a/fs/ocfs2/Makefile b/fs/ocfs2/Makefile
index 8222d03..4415ce6 100644
--- a/fs/ocfs2/Makefile
+++ b/fs/ocfs2/Makefile
@@ -34,6 +34,10 @@ EXTRA_CFLAGS += -DCONFIG_OCFS2_DEBUG_MASKLOG
 
 EXTRA_CFLAGS += -DCONFIG_OCFS2_FS_STATS
 
+ifdef NO_DELAYED_WORK_STRUCT
+EXTRA_CFLAGS += -DNO_DELAYED_WORK_STRUCT
+endif
+
 #
 # Since SUBDIRS means something to kbuild, define them safely.  Do not
 # include trailing slashes.
diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 38a42f5..a1cfe4b 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -6024,12 +6024,11 @@ int ocfs2_flush_truncate_log(struct ocfs2_super *osb)
 	return status;
 }
 
-static void ocfs2_truncate_log_worker(struct work_struct *work)
+static void ocfs2_truncate_log_worker(kapi_work_struct_t *work)
 {
 	int status;
-	struct ocfs2_super *osb =
-		container_of(work, struct ocfs2_super,
-			     osb_truncate_log_wq.work);
+	struct ocfs2_super *osb = work_to_object(work, struct ocfs2_super,
+						 osb_truncate_log_wq.work);
 
 	mlog_entry_void();
 
@@ -6262,8 +6261,8 @@ int ocfs2_truncate_log_init(struct ocfs2_super *osb)
 	/* ocfs2_truncate_log_shutdown keys on the existence of
 	 * osb->osb_tl_inode so we don't set any of the osb variables
 	 * until we're sure all is well. */
-	INIT_DELAYED_WORK(&osb->osb_truncate_log_wq,
-			  ocfs2_truncate_log_worker);
+	KAPI_INIT_DELAYED_WORK(&osb->osb_truncate_log_wq,
+			       ocfs2_truncate_log_worker, osb);
 	osb->osb_tl_bh    = tl_bh;
 	osb->osb_tl_inode = tl_inode;
 
diff --git a/fs/ocfs2/cluster/Makefile b/fs/ocfs2/cluster/Makefile
index fc5d3a0..c1f4f31 100644
--- a/fs/ocfs2/cluster/Makefile
+++ b/fs/ocfs2/cluster/Makefile
@@ -18,6 +18,10 @@ HEADERS =
 
 EXTRA_CFLAGS += -DCONFIG_OCFS2_DEBUG_MASKLOG
 
+ifdef NO_DELAYED_WORK_STRUCT
+EXTRA_CFLAGS += -DNO_DELAYED_WORK_STRUCT
+endif
+
 SOURCES +=			\
 	heartbeat.c		\
 	masklog.c		\
diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index c452d11..68e9af5 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -162,11 +162,10 @@ struct o2hb_bio_wait_ctxt {
 	int               wc_error;
 };
 
-static void o2hb_write_timeout(struct work_struct *work)
+static void o2hb_write_timeout(kapi_work_struct_t *work)
 {
-	struct o2hb_region *reg =
-		container_of(work, struct o2hb_region,
-			     hr_write_timeout_work.work);
+	struct o2hb_region *reg = work_to_object(work, struct o2hb_region,
+						 hr_write_timeout_work.work);
 
 	mlog(ML_ERROR, "Heartbeat write timeout to device %s after %u "
 	     "milliseconds\n", reg->hr_dev_name,
@@ -1400,7 +1399,8 @@ static ssize_t o2hb_region_dev_write(struct o2hb_region *reg,
 		goto out;
 	}
 
-	INIT_DELAYED_WORK(&reg->hr_write_timeout_work, o2hb_write_timeout);
+	KAPI_INIT_DELAYED_WORK(&reg->hr_write_timeout_work, o2hb_write_timeout,
+			       reg);
 
 	/*
 	 * A node is considered live after it has beat LIVE_THRESHOLD
diff --git a/fs/ocfs2/cluster/quorum.c b/fs/ocfs2/cluster/quorum.c
index bbacf7d..242622f 100644
--- a/fs/ocfs2/cluster/quorum.c
+++ b/fs/ocfs2/cluster/quorum.c
@@ -91,7 +91,7 @@ void o2quo_disk_timeout(void)
 	o2quo_fence_self();
 }
 
-static void o2quo_make_decision(struct work_struct *work)
+static void o2quo_make_decision(kapi_work_struct_t *work)
 {
 	int quorum;
 	int lowest_hb, lowest_reachable = 0, fence = 0;
@@ -309,7 +309,7 @@ void o2quo_init(void)
 	struct o2quo_state *qs = &o2quo_state;
 
 	spin_lock_init(&qs->qs_lock);
-	INIT_WORK(&qs->qs_work, o2quo_make_decision);
+	KAPI_INIT_WORK(&qs->qs_work, o2quo_make_decision, qs);
 }
 
 void o2quo_exit(void)
diff --git a/fs/ocfs2/cluster/tcp.c b/fs/ocfs2/cluster/tcp.c
index 334f231..4b8279e 100644
--- a/fs/ocfs2/cluster/tcp.c
+++ b/fs/ocfs2/cluster/tcp.c
@@ -133,11 +133,11 @@ static int o2net_sys_err_translations[O2NET_ERR_MAX] =
 		 [O2NET_ERR_DIED]	= -EHOSTDOWN,};
 
 /* can't quite avoid *all* internal declarations :/ */
-static void o2net_sc_connect_completed(struct work_struct *work);
-static void o2net_rx_until_empty(struct work_struct *work);
-static void o2net_shutdown_sc(struct work_struct *work);
+static void o2net_sc_connect_completed(kapi_work_struct_t *work);
+static void o2net_rx_until_empty(kapi_work_struct_t *work);
+static void o2net_shutdown_sc(kapi_work_struct_t *work);
 static void o2net_listen_data_ready(struct sock *sk, int bytes);
-static void o2net_sc_send_keep_req(struct work_struct *work);
+static void o2net_sc_send_keep_req(kapi_work_struct_t *work);
 static void o2net_idle_timer(unsigned long data);
 static void o2net_sc_postpone_idle(struct o2net_sock_container *sc);
 static void o2net_sc_reset_idle_timer(struct o2net_sock_container *sc);
@@ -386,10 +386,11 @@ static struct o2net_sock_container *sc_alloc(struct o2nm_node *node)
 	o2nm_node_get(node);
 	sc->sc_node = node;
 
-	INIT_WORK(&sc->sc_connect_work, o2net_sc_connect_completed);
-	INIT_WORK(&sc->sc_rx_work, o2net_rx_until_empty);
-	INIT_WORK(&sc->sc_shutdown_work, o2net_shutdown_sc);
-	INIT_DELAYED_WORK(&sc->sc_keepalive_work, o2net_sc_send_keep_req);
+	KAPI_INIT_WORK(&sc->sc_connect_work, o2net_sc_connect_completed, sc);
+	KAPI_INIT_WORK(&sc->sc_rx_work, o2net_rx_until_empty, sc);
+	KAPI_INIT_WORK(&sc->sc_shutdown_work, o2net_shutdown_sc, sc);
+	KAPI_INIT_DELAYED_WORK(&sc->sc_keepalive_work, o2net_sc_send_keep_req,
+			       sc);
 
 	init_timer(&sc->sc_idle_timeout);
 	sc->sc_idle_timeout.function = o2net_idle_timer;
@@ -662,11 +663,11 @@ static void o2net_ensure_shutdown(struct o2net_node *nn,
  * ourselves as state_change couldn't get the nn_lock and call set_nn_state
  * itself.
  */
-static void o2net_shutdown_sc(struct work_struct *work)
+static void o2net_shutdown_sc(kapi_work_struct_t *work)
 {
 	struct o2net_sock_container *sc =
-		container_of(work, struct o2net_sock_container,
-			     sc_shutdown_work);
+		work_to_object(work, struct o2net_sock_container,
+			       sc_shutdown_work);
 	struct o2net_node *nn = o2net_nn_from_num(sc->sc_node->nd_num);
 
 	sclog(sc, "shutting down\n");
@@ -1379,10 +1380,10 @@ out:
 /* this work func is triggerd by data ready.  it reads until it can read no
  * more.  it interprets 0, eof, as fatal.  if data_ready hits while we're doing
  * our work the work struct will be marked and we'll be called again. */
-static void o2net_rx_until_empty(struct work_struct *work)
+static void o2net_rx_until_empty(kapi_work_struct_t *work)
 {
 	struct o2net_sock_container *sc =
-		container_of(work, struct o2net_sock_container, sc_rx_work);
+		work_to_object(work, struct o2net_sock_container, sc_rx_work);
 	int ret;
 
 	do {
@@ -1439,11 +1440,11 @@ static void o2net_initialize_handshake(void)
 
 /* called when a connect completes and after a sock is accepted.  the
  * rx path will see the response and mark the sc valid */
-static void o2net_sc_connect_completed(struct work_struct *work)
+static void o2net_sc_connect_completed(kapi_work_struct_t *work)
 {
 	struct o2net_sock_container *sc =
-		container_of(work, struct o2net_sock_container,
-			     sc_connect_work);
+		work_to_object(work, struct o2net_sock_container,
+			       sc_connect_work);
 
 	mlog(ML_MSG, "sc sending handshake with ver %llu id %llx\n",
               (unsigned long long)O2NET_PROTOCOL_VERSION,
@@ -1455,11 +1456,11 @@ static void o2net_sc_connect_completed(struct work_struct *work)
 }
 
 /* this is called as a work_struct func. */
-static void o2net_sc_send_keep_req(struct work_struct *work)
+static void o2net_sc_send_keep_req(kapi_work_struct_t *work)
 {
 	struct o2net_sock_container *sc =
-		container_of(work, struct o2net_sock_container,
-			     sc_keepalive_work.work);
+		work_to_object(work, struct o2net_sock_container,
+			       sc_keepalive_work.work);
 
 	o2net_sendpage(sc, o2net_keep_req, sizeof(*o2net_keep_req));
 	sc_put(sc);
@@ -1525,10 +1526,10 @@ static void o2net_sc_postpone_idle(struct o2net_sock_container *sc)
  * having a connect attempt fail, etc. This centralizes the logic which decides
  * if a connect attempt should be made or if we should give up and all future
  * transmit attempts should fail */
-static void o2net_start_connect(struct work_struct *work)
+static void o2net_start_connect(kapi_work_struct_t *work)
 {
 	struct o2net_node *nn =
-		container_of(work, struct o2net_node, nn_connect_work.work);
+		work_to_object(work, struct o2net_node, nn_connect_work.work);
 	struct o2net_sock_container *sc = NULL;
 	struct o2nm_node *node = NULL, *mynode = NULL;
 	struct socket *sock = NULL;
@@ -1642,10 +1643,11 @@ out:
 	return;
 }
 
-static void o2net_connect_expired(struct work_struct *work)
+static void o2net_connect_expired(kapi_work_struct_t *work)
 {
 	struct o2net_node *nn =
-		container_of(work, struct o2net_node, nn_connect_expired.work);
+		work_to_object(work, struct o2net_node,
+			       nn_connect_expired.work);
 
 	spin_lock(&nn->nn_lock);
 	if (!nn->nn_sc_valid) {
@@ -1660,10 +1662,10 @@ static void o2net_connect_expired(struct work_struct *work)
 	spin_unlock(&nn->nn_lock);
 }
 
-static void o2net_still_up(struct work_struct *work)
+static void o2net_still_up(kapi_work_struct_t *work)
 {
 	struct o2net_node *nn =
-		container_of(work, struct o2net_node, nn_still_up.work);
+		work_to_object(work, struct o2net_node, nn_still_up.work);
 
 	o2quo_hb_still_up(o2net_num_from_nn(nn));
 }
@@ -1859,7 +1861,7 @@ out:
 	return ret;
 }
 
-static void o2net_accept_many(struct work_struct *work)
+static void o2net_accept_many(kapi_work_struct_t *work)
 {
 	struct socket *sock = o2net_listen_sock;
 	while (o2net_accept_one(sock) == 0)
@@ -1915,7 +1917,7 @@ static int o2net_open_listening_sock(__be32 addr, __be16 port)
 	write_unlock_bh(&sock->sk->sk_callback_lock);
 
 	o2net_listen_sock = sock;
-	INIT_WORK(&o2net_listen_work, o2net_accept_many);
+	KAPI_INIT_WORK(&o2net_listen_work, o2net_accept_many, sock);
 
 	sock->sk->sk_reuse = 1;
 	ret = sock->ops->bind(sock, (struct sockaddr *)&sin, sizeof(sin));
@@ -2039,10 +2041,11 @@ int o2net_init(void)
 
 		atomic_set(&nn->nn_timeout, 0);
 		spin_lock_init(&nn->nn_lock);
-		INIT_DELAYED_WORK(&nn->nn_connect_work, o2net_start_connect);
-		INIT_DELAYED_WORK(&nn->nn_connect_expired,
-				  o2net_connect_expired);
-		INIT_DELAYED_WORK(&nn->nn_still_up, o2net_still_up);
+		KAPI_INIT_DELAYED_WORK(&nn->nn_connect_work,
+				       o2net_start_connect, nn);
+		KAPI_INIT_DELAYED_WORK(&nn->nn_connect_expired,
+				       o2net_connect_expired, nn);
+		KAPI_INIT_DELAYED_WORK(&nn->nn_still_up, o2net_still_up, nn);
 		/* until we see hb from a node we'll return einval */
 		nn->nn_persistent_error = -ENOTCONN;
 		init_waitqueue_head(&nn->nn_sc_wq);
diff --git a/fs/ocfs2/dcache.c b/fs/ocfs2/dcache.c
index b4957c7..8ad82bc 100644
--- a/fs/ocfs2/dcache.c
+++ b/fs/ocfs2/dcache.c
@@ -344,10 +344,10 @@ static void __ocfs2_drop_dl_inodes(struct ocfs2_super *osb, int drop_count)
 	spin_unlock(&dentry_list_lock);
 }
 
-void ocfs2_drop_dl_inodes(struct work_struct *work)
+void ocfs2_drop_dl_inodes(kapi_work_struct_t *work)
 {
-	struct ocfs2_super *osb = container_of(work, struct ocfs2_super,
-					       dentry_lock_work);
+	struct ocfs2_super *osb = work_to_object(work, struct ocfs2_super,
+						 dentry_lock_work);
 
 	__ocfs2_drop_dl_inodes(osb, DL_INODE_DROP_COUNT);
 	/*
diff --git a/fs/ocfs2/dcache.h b/fs/ocfs2/dcache.h
index f5dd178..d13a087 100644
--- a/fs/ocfs2/dcache.h
+++ b/fs/ocfs2/dcache.h
@@ -54,7 +54,7 @@ extern spinlock_t dentry_list_lock;
 void ocfs2_dentry_lock_put(struct ocfs2_super *osb,
 			   struct ocfs2_dentry_lock *dl);
 
-void ocfs2_drop_dl_inodes(struct work_struct *work);
+void ocfs2_drop_dl_inodes(kapi_work_struct_t *work);
 void ocfs2_drop_all_dl_inodes(struct ocfs2_super *osb);
 
 struct dentry *ocfs2_find_local_alias(struct inode *inode, u64 parent_blkno,
diff --git a/fs/ocfs2/dlm/Makefile b/fs/ocfs2/dlm/Makefile
index 26cbf6c..44b6cc6 100644
--- a/fs/ocfs2/dlm/Makefile
+++ b/fs/ocfs2/dlm/Makefile
@@ -22,6 +22,10 @@ EXTRA_CFLAGS += -I$(OUR_TOPDIR)/fs/ocfs2
 
 EXTRA_CFLAGS += -DCONFIG_OCFS2_DEBUG_MASKLOG
 
+ifdef NO_DELAYED_WORK_STRUCT
+EXTRA_CFLAGS += -DNO_DELAYED_WORK_STRUCT
+endif
+
 DLM_SOURCES +=			\
 	dlmast.c		\
 	dlmconvert.c		\
diff --git a/fs/ocfs2/dlm/dlmcommon.h b/fs/ocfs2/dlm/dlmcommon.h
index 0102be3..a13292a 100644
--- a/fs/ocfs2/dlm/dlmcommon.h
+++ b/fs/ocfs2/dlm/dlmcommon.h
@@ -203,7 +203,7 @@ static inline struct hlist_head *dlm_master_hash(struct dlm_ctxt *dlm,
  * called functions that cannot be directly called from the
  * net message handlers for some reason, usually because
  * they need to send net messages of their own. */
-void dlm_dispatch_work(struct work_struct *work);
+void dlm_dispatch_work(kapi_work_struct_t *work);
 
 struct dlm_lock_resource;
 struct dlm_work_item;
diff --git a/fs/ocfs2/dlm/dlmdomain.c b/fs/ocfs2/dlm/dlmdomain.c
index 0334000..05a0350 100644
--- a/fs/ocfs2/dlm/dlmdomain.c
+++ b/fs/ocfs2/dlm/dlmdomain.c
@@ -1613,7 +1613,7 @@ static struct dlm_ctxt *dlm_alloc_ctxt(const char *domain,
 
 	spin_lock_init(&dlm->work_lock);
 	INIT_LIST_HEAD(&dlm->work_list);
-	INIT_WORK(&dlm->dispatched_work, dlm_dispatch_work);
+	KAPI_INIT_WORK(&dlm->dispatched_work, dlm_dispatch_work, dlm);
 
 	kref_init(&dlm->dlm_refs);
 	dlm->dlm_state = DLM_CTXT_NEW;
diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
index d9fa3d2..2e16a38 100644
--- a/fs/ocfs2/dlm/dlmrecovery.c
+++ b/fs/ocfs2/dlm/dlmrecovery.c
@@ -152,10 +152,10 @@ static inline void dlm_reset_recovery(struct dlm_ctxt *dlm)
 }
 
 /* Worker function used during recovery. */
-void dlm_dispatch_work(struct work_struct *work)
+void dlm_dispatch_work(kapi_work_struct_t *work)
 {
 	struct dlm_ctxt *dlm =
-		container_of(work, struct dlm_ctxt, dispatched_work);
+		work_to_object(work, struct dlm_ctxt, dispatched_work);
 	LIST_HEAD(tmp_list);
 	struct dlm_work_item *item, *next;
 	dlm_workfunc_t *workfunc;
diff --git a/fs/ocfs2/dlm/userdlm.c b/fs/ocfs2/dlm/userdlm.c
index 4cb1d3d..01a57c8 100644
--- a/fs/ocfs2/dlm/userdlm.c
+++ b/fs/ocfs2/dlm/userdlm.c
@@ -171,14 +171,15 @@ static inline void user_dlm_grab_inode_ref(struct user_lock_res *lockres)
 		BUG();
 }
 
-static void user_dlm_unblock_lock(struct work_struct *work);
+static void user_dlm_unblock_lock(kapi_work_struct_t *work);
 
 static void __user_dlm_queue_lockres(struct user_lock_res *lockres)
 {
 	if (!(lockres->l_flags & USER_LOCK_QUEUED)) {
 		user_dlm_grab_inode_ref(lockres);
 
-		INIT_WORK(&lockres->l_work, user_dlm_unblock_lock);
+		KAPI_INIT_WORK(&lockres->l_work, user_dlm_unblock_lock,
+			       lockres);
 
 		queue_work(user_dlm_worker, &lockres->l_work);
 		lockres->l_flags |= USER_LOCK_QUEUED;
@@ -278,11 +279,11 @@ static inline void user_dlm_drop_inode_ref(struct user_lock_res *lockres)
 	iput(inode);
 }
 
-static void user_dlm_unblock_lock(struct work_struct *work)
+static void user_dlm_unblock_lock(kapi_work_struct_t *work)
 {
 	int new_level, status;
 	struct user_lock_res *lockres =
-		container_of(work, struct user_lock_res, l_work);
+		work_to_object(work, struct user_lock_res, l_work);
 	struct dlm_ctxt *dlm = dlm_ctxt_from_user_lockres(lockres);
 
 	mlog(0, "processing lockres %.*s\n", lockres->l_namelen,
diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index 54c16b6..67cc5a7 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -1189,11 +1189,11 @@ struct ocfs2_la_recovery_item {
  * NOTE: This function can and will sleep on recovery of other nodes
  * during cluster locking, just like any other ocfs2 process.
  */
-void ocfs2_complete_recovery(struct work_struct *work)
+void ocfs2_complete_recovery(kapi_work_struct_t *work)
 {
 	int ret;
 	struct ocfs2_journal *journal =
-		container_of(work, struct ocfs2_journal, j_recovery_work);
+		work_to_object(work, struct ocfs2_journal, j_recovery_work);
 	struct ocfs2_super *osb = journal->j_osb;
 	struct ocfs2_dinode *la_dinode, *tl_dinode;
 	struct ocfs2_la_recovery_item *item, *n;
@@ -1926,13 +1926,13 @@ out:
 }
 
 /* Worker task that gets fired every ORPHAN_SCAN_SCHEDULE_TIMEOUT millsec */
-void ocfs2_orphan_scan_work(struct work_struct *work)
+void ocfs2_orphan_scan_work(kapi_work_struct_t *work)
 {
 	struct ocfs2_orphan_scan *os;
 	struct ocfs2_super *osb;
 
-	os = container_of(work, struct ocfs2_orphan_scan,
-			  os_orphan_scan_work.work);
+	os = work_to_object(work, struct ocfs2_orphan_scan,
+			    os_orphan_scan_work.work);
 	osb = os->os_osb;
 
 	mutex_lock(&os->os_lock);
@@ -1965,7 +1965,7 @@ void ocfs2_orphan_scan_init(struct ocfs2_super *osb)
 	os->os_count = 0;
 	os->os_seqno = 0;
 	mutex_init(&os->os_lock);
-	INIT_DELAYED_WORK(&os->os_orphan_scan_work, ocfs2_orphan_scan_work);
+	KAPI_INIT_DELAYED_WORK(&os->os_orphan_scan_work, ocfs2_orphan_scan_work, os);
 }
 
 void ocfs2_orphan_scan_start(struct ocfs2_super *osb)
diff --git a/fs/ocfs2/journal.h b/fs/ocfs2/journal.h
index 3f74e09..321c857 100644
--- a/fs/ocfs2/journal.h
+++ b/fs/ocfs2/journal.h
@@ -159,7 +159,7 @@ void ocfs2_orphan_scan_start(struct ocfs2_super *osb);
 void ocfs2_orphan_scan_stop(struct ocfs2_super *osb);
 void ocfs2_orphan_scan_exit(struct ocfs2_super *osb);
 
-void ocfs2_complete_recovery(struct work_struct *work);
+void ocfs2_complete_recovery(kapi_work_struct_t *work);
 void ocfs2_wait_for_recovery(struct ocfs2_super *osb);
 
 int ocfs2_recovery_init(struct ocfs2_super *osb);
diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
index ac10f83..83b22ca 100644
--- a/fs/ocfs2/localalloc.c
+++ b/fs/ocfs2/localalloc.c
@@ -93,11 +93,11 @@ void ocfs2_local_alloc_seen_free_bits(struct ocfs2_super *osb,
 	spin_unlock(&osb->osb_lock);
 }
 
-void ocfs2_la_enable_worker(struct work_struct *work)
+void ocfs2_la_enable_worker(kapi_work_struct_t *work)
 {
 	struct ocfs2_super *osb =
-		container_of(work, struct ocfs2_super,
-			     la_enable_wq.work);
+		work_to_object(work, struct ocfs2_super,
+			       la_enable_wq.work);
 	spin_lock(&osb->osb_lock);
 	osb->local_alloc_state = OCFS2_LA_ENABLED;
 	spin_unlock(&osb->osb_lock);
diff --git a/fs/ocfs2/localalloc.h b/fs/ocfs2/localalloc.h
index ac5ea9f..3234d2a 100644
--- a/fs/ocfs2/localalloc.h
+++ b/fs/ocfs2/localalloc.h
@@ -54,6 +54,6 @@ int ocfs2_claim_local_alloc_bits(struct ocfs2_super *osb,
 
 void ocfs2_local_alloc_seen_free_bits(struct ocfs2_super *osb,
 				      unsigned int num_clusters);
-void ocfs2_la_enable_worker(struct work_struct *work);
+void ocfs2_la_enable_worker(kapi_work_struct_t *work);
 
 #endif /* OCFS2_LOCALALLOC_H */
diff --git a/fs/ocfs2/quota_global.c b/fs/ocfs2/quota_global.c
index b437dc0..0f319fb 100644
--- a/fs/ocfs2/quota_global.c
+++ b/fs/ocfs2/quota_global.c
@@ -28,7 +28,7 @@
 
 static struct workqueue_struct *ocfs2_quota_wq = NULL;
 
-static void qsync_work_fn(struct work_struct *work);
+static void qsync_work_fn(kapi_work_struct_t *work);
 
 static void ocfs2_global_disk2memdqb(struct dquot *dquot, void *dp)
 {
@@ -360,7 +360,7 @@ int ocfs2_global_read_info(struct super_block *sb, int type)
 	oinfo->dqi_gi.dqi_usable_bs = sb->s_blocksize -
 						OCFS2_QBLK_RESERVED_SPACE;
 	oinfo->dqi_gi.dqi_qtree_depth = qtree_depth(&oinfo->dqi_gi);
-	INIT_DELAYED_WORK(&oinfo->dqi_sync_work, qsync_work_fn);
+	KAPI_INIT_DELAYED_WORK(&oinfo->dqi_sync_work, qsync_work_fn, oinfo);
 	queue_delayed_work(ocfs2_quota_wq, &oinfo->dqi_sync_work,
 			   msecs_to_jiffies(oinfo->dqi_syncms));
 
@@ -653,11 +653,11 @@ out:
 	return status;
 }
 
-static void qsync_work_fn(struct work_struct *work)
+static void qsync_work_fn(kapi_work_struct_t *work)
 {
-	struct ocfs2_mem_dqinfo *oinfo = container_of(work,
-						      struct ocfs2_mem_dqinfo,
-						      dqi_sync_work.work);
+	struct ocfs2_mem_dqinfo *oinfo =
+		work_to_object(work, struct ocfs2_mem_dqinfo,
+			       dqi_sync_work.work);
 	struct super_block *sb = oinfo->dqi_gqinode->i_sb;
 
 	dquot_scan_active(sb, ocfs2_sync_dquot_helper, oinfo->dqi_type);
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index c0e48ae..5f19ff5 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -2027,7 +2027,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
 
 	osb->local_alloc_state = OCFS2_LA_UNUSED;
 	osb->local_alloc_bh = NULL;
-	INIT_DELAYED_WORK(&osb->la_enable_wq, ocfs2_la_enable_worker);
+	KAPI_INIT_DELAYED_WORK(&osb->la_enable_wq, ocfs2_la_enable_worker, osb);
 
 	init_waitqueue_head(&osb->osb_mount_event);
 
@@ -2134,10 +2134,10 @@ static int ocfs2_initialize_super(struct super_block *sb,
 	spin_lock_init(&journal->j_lock);
 	journal->j_trans_id = (unsigned long) 1;
 	INIT_LIST_HEAD(&journal->j_la_cleanups);
-	INIT_WORK(&journal->j_recovery_work, ocfs2_complete_recovery);
+	KAPI_INIT_WORK(&journal->j_recovery_work, ocfs2_complete_recovery, journal);
 	journal->j_state = OCFS2_JOURNAL_FREE;
 
-	INIT_WORK(&osb->dentry_lock_work, ocfs2_drop_dl_inodes);
+	KAPI_INIT_WORK(&osb->dentry_lock_work, ocfs2_drop_dl_inodes, osb);
 	osb->dentry_lock_list = NULL;
 
 	/* get some pseudo constants for clustersize bits */
diff --git a/kapi-compat/include/workqueue.h b/kapi-compat/include/workqueue.h
new file mode 100644
index 0000000..24dfe2d
--- /dev/null
+++ b/kapi-compat/include/workqueue.h
@@ -0,0 +1,17 @@
+#ifndef KAPI_WORKQUEUE_H
+#define KAPI_WORKQUEUE_H
+
+#ifdef NO_DELAYED_WORK_STRUCT
+# define delayed_work				work_struct
+typedef void kapi_work_struct_t;
+# define work_to_object(a, b, c)		(a)
+# define KAPI_INIT_WORK(a, b, c)		INIT_WORK(a, b, c)
+# define KAPI_INIT_DELAYED_WORK(a, b, c)	INIT_WORK(a, b, c)
+#else
+typedef struct work_struct kapi_work_struct_t;
+# define work_to_object(a, b, c)		container_of(a, b, c)
+# define KAPI_INIT_WORK(a, b, c)		INIT_WORK(a, b)
+# define KAPI_INIT_DELAYED_WORK(a, b, c)	INIT_DELAYED_WORK(a, b)
+#endif
+
+#endif
-- 
1.5.6.5
