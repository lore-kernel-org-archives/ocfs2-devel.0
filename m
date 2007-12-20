From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu Dec 20 15:30:06 2007
Subject: [Ocfs2-devel] [PATCH 03/30] ocfs2: Handle workqueue changes
In-Reply-To: <1198193387-16606-1-git-send-email-sunil.mushran@oracle.com>
References: <1198193387-16606-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1198193387-16606-2-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Commit 52bad64d95bd89e08c49ec5a071fa6dcbe5a1a9c in mainline makes
changes to workqueue.h. This patch allows one to build ocfs2 with
kernels having/not having that change.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 Config.make.in                  |    2 +
 Makefile                        |    3 +-
 configure.in                    |    6 ++++
 fs/Makefile                     |   64 +++++++++++++++++++++++++++++++++++++++
 fs/ocfs2/Makefile               |    4 ++
 fs/ocfs2/alloc.c                |    8 ++--
 fs/ocfs2/cluster/Makefile       |    4 ++
 fs/ocfs2/cluster/heartbeat.c    |    6 ++--
 fs/ocfs2/cluster/quorum.c       |    4 +-
 fs/ocfs2/cluster/tcp.c          |   56 +++++++++++++++++-----------------
 fs/ocfs2/dlm/Makefile           |    4 ++
 fs/ocfs2/dlm/dlmcommon.h        |    2 +-
 fs/ocfs2/dlm/dlmdomain.c        |    2 +-
 fs/ocfs2/dlm/dlmrecovery.c      |    2 +-
 fs/ocfs2/dlm/userdlm.c          |    8 ++--
 fs/ocfs2/journal.c              |    4 +-
 fs/ocfs2/journal.h              |    2 +-
 fs/ocfs2/super.c                |    2 +-
 kapi-compat/include/workqueue.h |   17 ++++++++++
 19 files changed, 151 insertions(+), 49 deletions(-)
 create mode 100644 fs/Makefile
 create mode 100644 kapi-compat/include/workqueue.h

diff --git a/Config.make.in b/Config.make.in
index c9e0132..befeb79 100644
--- a/Config.make.in
+++ b/Config.make.in
@@ -57,6 +57,8 @@ MAKEBO_VERSION = @VERSION@
 
 EXTRA_CFLAGS += @KAPI_COMPAT_CFLAGS@
 
+DELAYED_WORK_DEFINED = @DELAYED_WORK_DEFINED@
+
 OCFS_DEBUG = @OCFS_DEBUG@
 
 ifneq ($(OCFS_DEBUG),)
diff --git a/Makefile b/Makefile
index 227ab23..4752593 100644
--- a/Makefile
+++ b/Makefile
@@ -8,7 +8,8 @@ SUBDIRS = fs vendor
 
 LINUX_INCLUDE_FILES =
 
-KAPI_COMPAT_FILES =
+KAPI_COMPAT_FILES = \
+	kapi-compat/include/workqueue.h
 
 PATCH_FILES =
 
diff --git a/configure.in b/configure.in
index 1af47fc..72567b5 100644
--- a/configure.in
+++ b/configure.in
@@ -156,6 +156,12 @@ case "$kversion" in
     ;;
 esac
 
+DELAYED_WORK_DEFINED=
+OCFS2_CHECK_KERNEL([struct delayed_work in workqueue.h], workqueue.h,
+  DELAYED_WORK_DEFINED=yes, , [^struct delayed_work])
+AC_SUBST(DELAYED_WORK_DEFINED)
+KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS workqueue.h"
+
 # using -include has two advantages:
 #  the source doesn't need to know to include compat headers
 #  the compat header file names don't go through the search path
diff --git a/fs/Makefile b/fs/Makefile
new file mode 100644
index 0000000..d7f3aec
--- /dev/null
+++ b/fs/Makefile
@@ -0,0 +1,64 @@
+
+ifeq ($(KERNELRELEASE),)
+TOPDIR = ..
+
+include $(TOPDIR)/Preamble.make
+else
+# We are included by kbuild.
+
+OUR_TOPDIR	:= $(M)/..
+
+include $(OUR_TOPDIR)/Config.make
+
+endif
+
+#
+# As 2.6 kbuild is unhappy seeing SUBDIRS, this is a safe one to
+# set globally.  Do not include trailing slashes.
+#
+SAFE_SUBDIRS :=
+
+SAFE_SUBDIRS += ocfs2
+
+ifneq ($(KERNELRELEASE),)
+#
+# Called under kbuild 2.6
+#
+
+obj-m	+= $(addsuffix /,$(SAFE_SUBDIRS))
+INSTALL_MOD_DIR := fs/ocfs2
+
+else
+#
+# Called from a regular "make". Just forward to kbuild.
+#
+
+ALL_RULES = build-modules
+
+CLEAN_RULES = clean-modules
+
+INSTALL_RULES = install-modules
+
+# Traverse subdirs via Makebo for "make dist"
+ifeq ($(MAKECMDGOALS),dist-all)
+SUBDIRS = $(SAFE_SUBDIRS)
+endif
+
+build-modules:
+	$(MAKE) -C ocfs2 stamp-md5
+	$(MAKE) -C ocfs2/cluster stamp-md5
+	$(MAKE) -C ocfs2/dlm stamp-md5
+	$(MAKE) -C $(KERNELDIR) M=$(CURDIR) modules
+
+install-modules:
+	$(MAKE) -C $(KERNELDIR) M=$(CURDIR) modules_install
+
+clean-modules:
+	$(MAKE) -C $(KERNELDIR) M=$(CURDIR) clean
+	-rm ocfs2/stamp-md5
+	-rm ocfs2/cluster/stamp-md5
+	-rm ocfs2/dlm/stamp-md5
+
+include $(TOPDIR)/Postamble.make
+
+endif
diff --git a/fs/ocfs2/Makefile b/fs/ocfs2/Makefile
index dce2a62..0edfed7 100644
--- a/fs/ocfs2/Makefile
+++ b/fs/ocfs2/Makefile
@@ -25,6 +25,10 @@ EXTRA_CFLAGS += -DOCFS2_CDSL
 
 EXTRA_CFLAGS += -DCONFIG_OCFS2_DEBUG_MASKLOG
 
+ifdef DELAYED_WORK_DEFINED
+EXTRA_CFLAGS += -DDELAYED_WORK_DEFINED
+endif
+
 #
 # Since SUBDIRS means something to kbuild, define them safely.  Do not
 # include trailing slashes.
diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 4ba7f0b..5a8a4f2 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -4752,11 +4752,11 @@ int ocfs2_flush_truncate_log(struct ocfs2_super *osb)
 	return status;
 }
 
-static void ocfs2_truncate_log_worker(struct work_struct *work)
+static void ocfs2_truncate_log_worker(kapi_work_struct_t *work)
 {
 	int status;
 	struct ocfs2_super *osb =
-		container_of(work, struct ocfs2_super,
+		kapi_container_of(work, struct ocfs2_super,
 			     osb_truncate_log_wq.work);
 
 	mlog_entry_void();
@@ -4989,8 +4989,8 @@ int ocfs2_truncate_log_init(struct ocfs2_super *osb)
 	/* ocfs2_truncate_log_shutdown keys on the existence of
 	 * osb->osb_tl_inode so we don't set any of the osb variables
 	 * until we're sure all is well. */
-	INIT_DELAYED_WORK(&osb->osb_truncate_log_wq,
-			  ocfs2_truncate_log_worker);
+	KAPI_INIT_DELAYED_WORK(&osb->osb_truncate_log_wq,
+			  ocfs2_truncate_log_worker, osb);
 	osb->osb_tl_bh    = tl_bh;
 	osb->osb_tl_inode = tl_inode;
 
diff --git a/fs/ocfs2/cluster/Makefile b/fs/ocfs2/cluster/Makefile
index c9c2e9b..a4251f5 100644
--- a/fs/ocfs2/cluster/Makefile
+++ b/fs/ocfs2/cluster/Makefile
@@ -13,6 +13,10 @@ endif
 
 EXTRA_CFLAGS += -DCONFIG_OCFS2_DEBUG_MASKLOG
 
+ifdef DELAYED_WORK_DEFINED
+EXTRA_CFLAGS += -DDELAYED_WORK_DEFINED
+endif
+
 SOURCES =			\
 	heartbeat.c		\
 	masklog.c		\
diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index f14b541..e610665 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -156,10 +156,10 @@ struct o2hb_bio_wait_ctxt {
 	int               wc_error;
 };
 
-static void o2hb_write_timeout(struct work_struct *work)
+static void o2hb_write_timeout(kapi_work_struct_t *work)
 {
 	struct o2hb_region *reg =
-		container_of(work, struct o2hb_region,
+		kapi_container_of(work, struct o2hb_region,
 			     hr_write_timeout_work.work);
 
 	mlog(ML_ERROR, "Heartbeat write timeout to device %s after %u "
@@ -1306,7 +1306,7 @@ static ssize_t o2hb_region_dev_write(struct o2hb_region *reg,
 		goto out;
 	}
 
-	INIT_DELAYED_WORK(&reg->hr_write_timeout_work, o2hb_write_timeout);
+	KAPI_INIT_DELAYED_WORK(&reg->hr_write_timeout_work, o2hb_write_timeout, reg);
 
 	/*
 	 * A node is considered live after it has beat LIVE_THRESHOLD
diff --git a/fs/ocfs2/cluster/quorum.c b/fs/ocfs2/cluster/quorum.c
index bbacf7d..df9b74a 100644
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
+	KAPI_INIT_WORK(&qs->qs_work, o2quo_make_decision, NULL);
 }
 
 void o2quo_exit(void)
diff --git a/fs/ocfs2/cluster/tcp.c b/fs/ocfs2/cluster/tcp.c
index 685c180..c4a0c73 100644
--- a/fs/ocfs2/cluster/tcp.c
+++ b/fs/ocfs2/cluster/tcp.c
@@ -140,11 +140,11 @@ static int o2net_sys_err_translations[O2NET_ERR_MAX] =
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
@@ -330,10 +330,10 @@ static struct o2net_sock_container *sc_alloc(struct o2nm_node *node)
 	o2nm_node_get(node);
 	sc->sc_node = node;
 
-	INIT_WORK(&sc->sc_connect_work, o2net_sc_connect_completed);
-	INIT_WORK(&sc->sc_rx_work, o2net_rx_until_empty);
-	INIT_WORK(&sc->sc_shutdown_work, o2net_shutdown_sc);
-	INIT_DELAYED_WORK(&sc->sc_keepalive_work, o2net_sc_send_keep_req);
+	KAPI_INIT_WORK(&sc->sc_connect_work, o2net_sc_connect_completed, sc);
+	KAPI_INIT_WORK(&sc->sc_rx_work, o2net_rx_until_empty, sc);
+	KAPI_INIT_WORK(&sc->sc_shutdown_work, o2net_shutdown_sc, sc);
+	KAPI_INIT_DELAYED_WORK(&sc->sc_keepalive_work, o2net_sc_send_keep_req, sc);
 
 	init_timer(&sc->sc_idle_timeout);
 	sc->sc_idle_timeout.function = o2net_idle_timer;
@@ -600,10 +600,10 @@ static void o2net_ensure_shutdown(struct o2net_node *nn,
  * ourselves as state_change couldn't get the nn_lock and call set_nn_state
  * itself.
  */
-static void o2net_shutdown_sc(struct work_struct *work)
+static void o2net_shutdown_sc(kapi_work_struct_t *work)
 {
 	struct o2net_sock_container *sc =
-		container_of(work, struct o2net_sock_container,
+		kapi_container_of(work, struct o2net_sock_container,
 			     sc_shutdown_work);
 	struct o2net_node *nn = o2net_nn_from_num(sc->sc_node->nd_num);
 
@@ -1306,10 +1306,10 @@ out:
 /* this work func is triggerd by data ready.  it reads until it can read no
  * more.  it interprets 0, eof, as fatal.  if data_ready hits while we're doing
  * our work the work struct will be marked and we'll be called again. */
-static void o2net_rx_until_empty(struct work_struct *work)
+static void o2net_rx_until_empty(kapi_work_struct_t *work)
 {
 	struct o2net_sock_container *sc =
-		container_of(work, struct o2net_sock_container, sc_rx_work);
+		kapi_container_of(work, struct o2net_sock_container, sc_rx_work);
 	int ret;
 
 	do {
@@ -1367,10 +1367,10 @@ static void o2net_initialize_handshake(void)
 
 /* called when a connect completes and after a sock is accepted.  the
  * rx path will see the response and mark the sc valid */
-static void o2net_sc_connect_completed(struct work_struct *work)
+static void o2net_sc_connect_completed(kapi_work_struct_t *work)
 {
 	struct o2net_sock_container *sc =
-		container_of(work, struct o2net_sock_container,
+		kapi_container_of(work, struct o2net_sock_container,
 			     sc_connect_work);
 
 	mlog(ML_MSG, "sc sending handshake with ver %llu id %llx\n",
@@ -1383,10 +1383,10 @@ static void o2net_sc_connect_completed(struct work_struct *work)
 }
 
 /* this is called as a work_struct func. */
-static void o2net_sc_send_keep_req(struct work_struct *work)
+static void o2net_sc_send_keep_req(kapi_work_struct_t *work)
 {
 	struct o2net_sock_container *sc =
-		container_of(work, struct o2net_sock_container,
+		kapi_container_of(work, struct o2net_sock_container,
 			     sc_keepalive_work.work);
 
 	o2net_sendpage(sc, o2net_keep_req, sizeof(*o2net_keep_req));
@@ -1446,10 +1446,10 @@ static void o2net_sc_postpone_idle(struct o2net_sock_container *sc)
  * having a connect attempt fail, etc. This centralizes the logic which decides
  * if a connect attempt should be made or if we should give up and all future
  * transmit attempts should fail */
-static void o2net_start_connect(struct work_struct *work)
+static void o2net_start_connect(kapi_work_struct_t *work)
 {
 	struct o2net_node *nn =
-		container_of(work, struct o2net_node, nn_connect_work.work);
+		kapi_container_of(work, struct o2net_node, nn_connect_work.work);
 	struct o2net_sock_container *sc = NULL;
 	struct o2nm_node *node = NULL, *mynode = NULL;
 	struct socket *sock = NULL;
@@ -1553,10 +1553,10 @@ out:
 	return;
 }
 
-static void o2net_connect_expired(struct work_struct *work)
+static void o2net_connect_expired(kapi_work_struct_t *work)
 {
 	struct o2net_node *nn =
-		container_of(work, struct o2net_node, nn_connect_expired.work);
+		kapi_container_of(work, struct o2net_node, nn_connect_expired.work);
 
 	spin_lock(&nn->nn_lock);
 	if (!nn->nn_sc_valid) {
@@ -1572,10 +1572,10 @@ static void o2net_connect_expired(struct work_struct *work)
 	spin_unlock(&nn->nn_lock);
 }
 
-static void o2net_still_up(struct work_struct *work)
+static void o2net_still_up(kapi_work_struct_t *work)
 {
 	struct o2net_node *nn =
-		container_of(work, struct o2net_node, nn_still_up.work);
+		kapi_container_of(work, struct o2net_node, nn_still_up.work);
 
 	o2quo_hb_still_up(o2net_num_from_nn(nn));
 }
@@ -1775,7 +1775,7 @@ out:
 	return ret;
 }
 
-static void o2net_accept_many(struct work_struct *work)
+static void o2net_accept_many(kapi_work_struct_t *work)
 {
 	struct socket *sock = o2net_listen_sock;
 	while (o2net_accept_one(sock) == 0)
@@ -1831,7 +1831,7 @@ static int o2net_open_listening_sock(__be32 addr, __be16 port)
 	write_unlock_bh(&sock->sk->sk_callback_lock);
 
 	o2net_listen_sock = sock;
-	INIT_WORK(&o2net_listen_work, o2net_accept_many);
+	KAPI_INIT_WORK(&o2net_listen_work, o2net_accept_many, sock);
 
 	sock->sk->sk_reuse = 1;
 	ret = sock->ops->bind(sock, (struct sockaddr *)&sin, sizeof(sin));
@@ -1951,10 +1951,10 @@ int o2net_init(void)
 		struct o2net_node *nn = o2net_nn_from_num(i);
 
 		spin_lock_init(&nn->nn_lock);
-		INIT_DELAYED_WORK(&nn->nn_connect_work, o2net_start_connect);
-		INIT_DELAYED_WORK(&nn->nn_connect_expired,
-				  o2net_connect_expired);
-		INIT_DELAYED_WORK(&nn->nn_still_up, o2net_still_up);
+		KAPI_INIT_DELAYED_WORK(&nn->nn_connect_work, o2net_start_connect, nn);
+		KAPI_INIT_DELAYED_WORK(&nn->nn_connect_expired,
+				  o2net_connect_expired, nn);
+		KAPI_INIT_DELAYED_WORK(&nn->nn_still_up, o2net_still_up, nn);
 		/* until we see hb from a node we'll return einval */
 		nn->nn_persistent_error = -ENOTCONN;
 		init_waitqueue_head(&nn->nn_sc_wq);
diff --git a/fs/ocfs2/dlm/Makefile b/fs/ocfs2/dlm/Makefile
index 7e1031e..b4fb8e3 100644
--- a/fs/ocfs2/dlm/Makefile
+++ b/fs/ocfs2/dlm/Makefile
@@ -16,6 +16,10 @@ EXTRA_CFLAGS += -I$(OUR_TOPDIR)/fs/ocfs2
 
 EXTRA_CFLAGS += -DCONFIG_OCFS2_DEBUG_MASKLOG
 
+ifdef DELAYED_WORK_DEFINED
+EXTRA_CFLAGS += -DDELAYED_WORK_DEFINED
+endif
+
 DLM_SOURCES =			\
 	dlmast.c		\
 	dlmconvert.c		\
diff --git a/fs/ocfs2/dlm/dlmcommon.h b/fs/ocfs2/dlm/dlmcommon.h
index e90b92f..cddf85a 100644
--- a/fs/ocfs2/dlm/dlmcommon.h
+++ b/fs/ocfs2/dlm/dlmcommon.h
@@ -153,7 +153,7 @@ static inline struct hlist_head *dlm_lockres_hash(struct dlm_ctxt *dlm, unsigned
  * called functions that cannot be directly called from the
  * net message handlers for some reason, usually because
  * they need to send net messages of their own. */
-void dlm_dispatch_work(struct work_struct *work);
+void dlm_dispatch_work(kapi_work_struct_t *work);
 
 struct dlm_lock_resource;
 struct dlm_work_item;
diff --git a/fs/ocfs2/dlm/dlmdomain.c b/fs/ocfs2/dlm/dlmdomain.c
index 6954565..10b3e60 100644
--- a/fs/ocfs2/dlm/dlmdomain.c
+++ b/fs/ocfs2/dlm/dlmdomain.c
@@ -1435,7 +1435,7 @@ static struct dlm_ctxt *dlm_alloc_ctxt(const char *domain,
 
 	spin_lock_init(&dlm->work_lock);
 	INIT_LIST_HEAD(&dlm->work_list);
-	INIT_WORK(&dlm->dispatched_work, dlm_dispatch_work);
+	KAPI_INIT_WORK(&dlm->dispatched_work, dlm_dispatch_work, dlm);
 
 	kref_init(&dlm->dlm_refs);
 	dlm->dlm_state = DLM_CTXT_NEW;
diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
index a2c3316..3cf4f49 100644
--- a/fs/ocfs2/dlm/dlmrecovery.c
+++ b/fs/ocfs2/dlm/dlmrecovery.c
@@ -153,7 +153,7 @@ static inline void dlm_reset_recovery(struct dlm_ctxt *dlm)
 }
 
 /* Worker function used during recovery. */
-void dlm_dispatch_work(struct work_struct *work)
+void dlm_dispatch_work(kapi_work_struct_t *work)
 {
 	struct dlm_ctxt *dlm =
 		container_of(work, struct dlm_ctxt, dispatched_work);
diff --git a/fs/ocfs2/dlm/userdlm.c b/fs/ocfs2/dlm/userdlm.c
index 7d2f578..2f6deb1 100644
--- a/fs/ocfs2/dlm/userdlm.c
+++ b/fs/ocfs2/dlm/userdlm.c
@@ -171,14 +171,14 @@ static inline void user_dlm_grab_inode_ref(struct user_lock_res *lockres)
 		BUG();
 }
 
-static void user_dlm_unblock_lock(struct work_struct *work);
+static void user_dlm_unblock_lock(kapi_work_struct_t *work);
 
 static void __user_dlm_queue_lockres(struct user_lock_res *lockres)
 {
 	if (!(lockres->l_flags & USER_LOCK_QUEUED)) {
 		user_dlm_grab_inode_ref(lockres);
 
-		INIT_WORK(&lockres->l_work, user_dlm_unblock_lock);
+		KAPI_INIT_WORK(&lockres->l_work, user_dlm_unblock_lock, lockres);
 
 		queue_work(user_dlm_worker, &lockres->l_work);
 		lockres->l_flags |= USER_LOCK_QUEUED;
@@ -278,11 +278,11 @@ static inline void user_dlm_drop_inode_ref(struct user_lock_res *lockres)
 	iput(inode);
 }
 
-static void user_dlm_unblock_lock(struct work_struct *work)
+static void user_dlm_unblock_lock(kapi_work_struct_t *work)
 {
 	int new_level, status;
 	struct user_lock_res *lockres =
-		container_of(work, struct user_lock_res, l_work);
+		kapi_container_of(work, struct user_lock_res, l_work);
 	struct dlm_ctxt *dlm = dlm_ctxt_from_user_lockres(lockres);
 
 	mlog(0, "processing lockres %.*s\n", lockres->l_namelen,
diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index f9d01e2..b94208f 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -715,11 +715,11 @@ struct ocfs2_la_recovery_item {
  * NOTE: This function can and will sleep on recovery of other nodes
  * during cluster locking, just like any other ocfs2 process.
  */
-void ocfs2_complete_recovery(struct work_struct *work)
+void ocfs2_complete_recovery(kapi_work_struct_t *work)
 {
 	int ret;
 	struct ocfs2_journal *journal =
-		container_of(work, struct ocfs2_journal, j_recovery_work);
+		kapi_container_of(work, struct ocfs2_journal, j_recovery_work);
 	struct ocfs2_super *osb = journal->j_osb;
 	struct ocfs2_dinode *la_dinode, *tl_dinode;
 	struct ocfs2_la_recovery_item *item, *n;
diff --git a/fs/ocfs2/journal.h b/fs/ocfs2/journal.h
index 4b32e09..548d6af 100644
--- a/fs/ocfs2/journal.h
+++ b/fs/ocfs2/journal.h
@@ -133,7 +133,7 @@ static inline void ocfs2_inode_set_new(struct ocfs2_super *osb,
 }
 
 /* Exported only for the journal struct init code in super.c. Do not call. */
-void ocfs2_complete_recovery(struct work_struct *work);
+void ocfs2_complete_recovery(kapi_work_struct_t *work);
 
 /*
  *  Journal Control:
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 0e2a1b4..a8f90a2 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1465,7 +1465,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
 	spin_lock_init(&journal->j_lock);
 	journal->j_trans_id = (unsigned long) 1;
 	INIT_LIST_HEAD(&journal->j_la_cleanups);
-	INIT_WORK(&journal->j_recovery_work, ocfs2_complete_recovery);
+	KAPI_INIT_WORK(&journal->j_recovery_work, ocfs2_complete_recovery, journal);
 	journal->j_state = OCFS2_JOURNAL_FREE;
 
 	/* get some pseudo constants for clustersize bits */
diff --git a/kapi-compat/include/workqueue.h b/kapi-compat/include/workqueue.h
new file mode 100644
index 0000000..26dfbdf
--- /dev/null
+++ b/kapi-compat/include/workqueue.h
@@ -0,0 +1,17 @@
+#ifndef KAPI_WORKQUEUE_H
+#define KAPI_WORKQUEUE_H
+
+#ifndef DELAYED_WORK_DEFINED
+# define delayed_work				work_struct
+typedef void kapi_work_struct_t;
+# define kapi_container_of(a, b, c)		(a)
+# define KAPI_INIT_WORK(a, b, c)		INIT_WORK(a, b, c)
+# define KAPI_INIT_DELAYED_WORK(a, b, c)	INIT_WORK(a, b, c)
+#else
+typedef struct work_struct kapi_work_struct_t;
+# define kapi_container_of(a, b, c)		container_of(a, b, c)
+# define KAPI_INIT_WORK(a, b, c)		INIT_WORK(a, b)
+# define KAPI_INIT_DELAYED_WORK(a, b, c)	INIT_DELAYED_WORK(a, b)
+#endif
+
+#endif
-- 
1.5.2.5
