From: abeekhof@suse.de <abeekhof@suse.de>
Date: Thu Nov 30 10:22:33 2006
Subject: [Ocfs2-devel] [patch 2/3] ocfs2-configurable-timeout.patch
References: <20061130181128.860671000@suse.de>
Message-ID: <20061130182219.484839000@suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


From: Jeff Mahoney <jeffm@suse.de>
Subject: [patch 2/3] OCFS2 Configurable timeouts

Allow configuration of OCFS2 timeouts from userspace via configfs 

Signed-off-by: Andrew Beekhof <abeekhof@suse.de>
---
 fs/ocfs2/cluster/nodemanager.c  |  161 ++++++++++++++++++++++++++++++++++++++++
 fs/ocfs2/cluster/nodemanager.h  |    3 
 fs/ocfs2/cluster/tcp.c          |   60 +++++++++++---
 fs/ocfs2/cluster/tcp.h          |    7 +
 fs/ocfs2/cluster/tcp_internal.h |    6 -
 5 files changed, 219 insertions(+), 18 deletions(-)





Index: fs/ocfs2/cluster/nodemanager.c
===================================================================
--- fs/ocfs2/cluster/nodemanager.c.orig	2006-11-30 18:49:35.000000000 +0100
+++ fs/ocfs2/cluster/nodemanager.c	2006-11-30 18:56:02.000000000 +0100
@@ -532,6 +532,161 @@ static struct o2nm_node_group *to_o2nm_n
 }
 #endif
 
+struct o2nm_cluster_attribute {
+	struct configfs_attribute attr;
+	ssize_t (*show)(struct o2nm_cluster *, char *);
+	ssize_t (*store)(struct o2nm_cluster *, const char *, size_t);
+};
+
+static ssize_t o2nm_cluster_attr_write(const char *page, ssize_t count,
+                                       unsigned int *val)
+{
+	unsigned long tmp;
+	char *p = (char *)page;
+
+	tmp = simple_strtoul(p, &p, 0);
+	if (!p || (*p && (*p != '\n')))
+		return -EINVAL;
+
+	if (tmp == 0)
+		return -EINVAL;
+	if (tmp >= (u32)-1)
+		return -ERANGE;
+
+	*val = tmp;
+
+	return count;
+}
+
+static ssize_t o2nm_cluster_attr_idle_timeout_ms_read(
+	struct o2nm_cluster *cluster, char *page)
+{
+	return sprintf(page, "%u\n", cluster->cl_idle_timeout_ms);
+}
+
+static ssize_t o2nm_cluster_attr_idle_timeout_ms_write(
+	struct o2nm_cluster *cluster, const char *page, size_t count)
+{
+	ssize_t ret;
+	unsigned int val;
+
+	ret =  o2nm_cluster_attr_write(page, count, &val);
+
+	if (ret > 0) {
+		if (val <= cluster->cl_keepalive_delay_ms) {
+			mlog(ML_NOTICE, "o2net: idle timeout must be larger "
+			     "than keepalive delay\n");
+			return -EINVAL;
+		}
+		cluster->cl_idle_timeout_ms = val;
+	}
+
+	return ret;
+}
+
+static ssize_t o2nm_cluster_attr_keepalive_delay_ms_read(
+	struct o2nm_cluster *cluster, char *page)
+{
+	return sprintf(page, "%u\n", cluster->cl_keepalive_delay_ms);
+}
+
+static ssize_t o2nm_cluster_attr_keepalive_delay_ms_write(
+	struct o2nm_cluster *cluster, const char *page, size_t count)
+{
+	ssize_t ret;
+	unsigned int val;
+
+	ret =  o2nm_cluster_attr_write(page, count, &val);
+
+	if (ret > 0) {
+		if (val >= cluster->cl_idle_timeout_ms) {
+			mlog(ML_NOTICE, "o2net: keepalive delay must be "
+			     "smaller than idle timeout\n");
+			return -EINVAL;
+		}
+		cluster->cl_keepalive_delay_ms = val;
+	}
+
+	return ret;
+}
+
+static ssize_t o2nm_cluster_attr_reconnect_delay_ms_read(
+	struct o2nm_cluster *cluster, char *page)
+{
+	return sprintf(page, "%u\n", cluster->cl_reconnect_delay_ms);
+}
+
+static ssize_t o2nm_cluster_attr_reconnect_delay_ms_write(
+	struct o2nm_cluster *cluster, const char *page, size_t count)
+{
+	return o2nm_cluster_attr_write(page, count,
+	                               &cluster->cl_reconnect_delay_ms);
+}
+static struct o2nm_cluster_attribute o2nm_cluster_attr_idle_timeout_ms = {
+	.attr	= { .ca_owner = THIS_MODULE,
+		    .ca_name = "idle_timeout_ms",
+		    .ca_mode = S_IRUGO | S_IWUSR },
+	.show	= o2nm_cluster_attr_idle_timeout_ms_read,
+	.store	= o2nm_cluster_attr_idle_timeout_ms_write,
+};
+
+static struct o2nm_cluster_attribute o2nm_cluster_attr_keepalive_delay_ms = {
+	.attr	= { .ca_owner = THIS_MODULE,
+		    .ca_name = "keepalive_delay_ms",
+		    .ca_mode = S_IRUGO | S_IWUSR },
+	.show	= o2nm_cluster_attr_keepalive_delay_ms_read,
+	.store	= o2nm_cluster_attr_keepalive_delay_ms_write,
+};
+
+static struct o2nm_cluster_attribute o2nm_cluster_attr_reconnect_delay_ms = {
+	.attr	= { .ca_owner = THIS_MODULE,
+		    .ca_name = "reconnect_delay_ms",
+		    .ca_mode = S_IRUGO | S_IWUSR },
+	.show	= o2nm_cluster_attr_reconnect_delay_ms_read,
+	.store	= o2nm_cluster_attr_reconnect_delay_ms_write,
+};
+
+static struct configfs_attribute *o2nm_cluster_attrs[] = {
+	&o2nm_cluster_attr_idle_timeout_ms.attr,
+	&o2nm_cluster_attr_keepalive_delay_ms.attr,
+	&o2nm_cluster_attr_reconnect_delay_ms.attr,
+	NULL,
+};
+static ssize_t o2nm_cluster_show(struct config_item *item,
+                                 struct configfs_attribute *attr,
+                                 char *page)
+{
+	struct o2nm_cluster *cluster = to_o2nm_cluster(item);
+	struct o2nm_cluster_attribute *o2nm_cluster_attr =
+		container_of(attr, struct o2nm_cluster_attribute, attr);
+	ssize_t ret = 0;
+
+	if (o2nm_cluster_attr->show)
+		ret = o2nm_cluster_attr->show(cluster, page);
+	return ret;
+}
+
+static ssize_t o2nm_cluster_store(struct config_item *item,
+                                  struct configfs_attribute *attr,
+                                  const char *page, size_t count)
+{
+	struct o2nm_cluster *cluster = to_o2nm_cluster(item);
+	struct o2nm_cluster_attribute *o2nm_cluster_attr =
+		container_of(attr, struct o2nm_cluster_attribute, attr);
+	ssize_t ret;
+
+	if (o2nm_cluster_attr->store == NULL) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	ret = o2nm_cluster_attr->store(cluster, page, count);
+	if (ret < count)
+		goto out;
+out:
+	return ret;
+}
+
 static struct config_item *o2nm_node_group_make_item(struct config_group *group,
 						     const char *name)
 {
@@ -613,10 +768,13 @@ static void o2nm_cluster_release(struct 
 
 static struct configfs_item_operations o2nm_cluster_item_ops = {
 	.release	= o2nm_cluster_release,
+	.show_attribute		= o2nm_cluster_show,
+	.store_attribute	= o2nm_cluster_store,
 };
 
 static struct config_item_type o2nm_cluster_type = {
 	.ct_item_ops	= &o2nm_cluster_item_ops,
+	.ct_attrs	= o2nm_cluster_attrs,
 	.ct_owner	= THIS_MODULE,
 };
 
@@ -667,6 +825,9 @@ static struct config_group *o2nm_cluster
 	cluster->cl_group.default_groups[2] = NULL;
 	rwlock_init(&cluster->cl_nodes_lock);
 	cluster->cl_node_ip_tree = RB_ROOT;
+	cluster->cl_reconnect_delay_ms = O2NET_RECONNECT_DELAY_MS_DEFAULT;
+	cluster->cl_idle_timeout_ms    = O2NET_IDLE_TIMEOUT_MS_DEFAULT;
+	cluster->cl_keepalive_delay_ms = O2NET_KEEPALIVE_DELAY_MS_DEFAULT;
 
 	ret = &cluster->cl_group;
 	o2nm_single_cluster = cluster;
Index: fs/ocfs2/cluster/nodemanager.h
===================================================================
--- fs/ocfs2/cluster/nodemanager.h.orig	2006-11-30 18:49:35.000000000 +0100
+++ fs/ocfs2/cluster/nodemanager.h	2006-11-30 18:49:37.000000000 +0100
@@ -60,6 +60,9 @@ struct o2nm_cluster {
 	rwlock_t		cl_nodes_lock;
 	struct o2nm_node  	*cl_nodes[O2NM_MAX_NODES];
 	struct rb_root		cl_node_ip_tree;
+	unsigned int		cl_idle_timeout_ms;
+	unsigned int		cl_keepalive_delay_ms;
+	unsigned int		cl_reconnect_delay_ms;
 
 	/* this bitmap is part of a hack for disk bitmap.. will go eventually. - zab */
 	unsigned long	cl_nodes_bitmap[BITS_TO_LONGS(O2NM_MAX_NODES)];
Index: fs/ocfs2/cluster/tcp.c
===================================================================
--- fs/ocfs2/cluster/tcp.c.orig	2006-11-30 14:54:10.000000000 +0100
+++ fs/ocfs2/cluster/tcp.c	2006-11-30 18:53:24.000000000 +0100
@@ -147,6 +147,28 @@ static void o2net_listen_data_ready(stru
 static void o2net_sc_send_keep_req(void *arg);
 static void o2net_idle_timer(unsigned long data);
 static void o2net_sc_postpone_idle(struct o2net_sock_container *sc);
+static void o2net_sc_reset_idle_timer(struct o2net_sock_container *sc);
+
+/*
+ * FIXME: These should use to_o2nm_cluster_from_node(), but we end up
+ * losing our parent link to the cluster during shutdown. This can be
+ * solved by adding a pre-removal callback to configfs, or passing
+ * around the cluster with the node. -jeffm
+ */
+static inline int o2net_reconnect_delay(struct o2nm_node *node)
+{
+	return o2nm_single_cluster->cl_reconnect_delay_ms;
+}
+
+static inline int o2net_keepalive_delay(struct o2nm_node *node)
+{
+	return o2nm_single_cluster->cl_keepalive_delay_ms;
+}
+
+static inline int o2net_idle_timeout(struct o2nm_node *node)
+{
+	return o2nm_single_cluster->cl_idle_timeout_ms;
+}
 
 static inline int o2net_sys_err_to_errno(enum o2net_system_error err)
 {
@@ -271,6 +293,8 @@ static void sc_kref_release(struct kref 
 {
 	struct o2net_sock_container *sc = container_of(kref,
 					struct o2net_sock_container, sc_kref);
+	BUG_ON(timer_pending(&sc->sc_idle_timeout));
+
 	sclog(sc, "releasing\n");
 
 	if (sc->sc_sock) {
@@ -424,9 +448,9 @@ static void o2net_set_nn_state(struct o2
 		/* delay if we're withing a RECONNECT_DELAY of the
 		 * last attempt */
 		delay = (nn->nn_last_connect_attempt +
-			 msecs_to_jiffies(O2NET_RECONNECT_DELAY_MS))
+			 msecs_to_jiffies(o2net_reconnect_delay(sc->sc_node)))
 			- jiffies;
-		if (delay > msecs_to_jiffies(O2NET_RECONNECT_DELAY_MS))
+		if (delay > msecs_to_jiffies(o2net_reconnect_delay(sc->sc_node)))
 			delay = 0;
 		mlog(ML_CONN, "queueing conn attempt in %lu jiffies\n", delay);
 		queue_delayed_work(o2net_wq, &nn->nn_connect_work, delay);
@@ -1103,7 +1127,7 @@ static int o2net_check_handshake(struct 
 	/* set valid and queue the idle timers only if it hasn't been
 	 * shut down already */
 	if (nn->nn_sc == sc) {
-		o2net_sc_postpone_idle(sc);
+		o2net_sc_reset_idle_timer(sc);
 		o2net_set_nn_state(nn, sc, 1, 0);
 	}
 	spin_unlock(&nn->nn_lock);
@@ -1280,8 +1304,10 @@ static void o2net_idle_timer(unsigned lo
 
 	do_gettimeofday(&now);
 
-	printk(KERN_INFO "o2net: connection to " SC_NODEF_FMT " has been idle for 10 "
-	     "seconds, shutting it down.\n", SC_NODEF_ARGS(sc));
+	printk(KERN_INFO "o2net: connection to " SC_NODEF_FMT " has been idle for %u.%u "
+	     "seconds, shutting it down.\n", SC_NODEF_ARGS(sc),
+		     o2net_idle_timeout(sc->sc_node) / 1000,
+		     o2net_idle_timeout(sc->sc_node) % 1000);
 	mlog(ML_NOTICE, "here are some times that might help debug the "
 	     "situation: (tmr %ld.%ld now %ld.%ld dr %ld.%ld adv "
 	     "%ld.%ld:%ld.%ld func (%08x:%u) %ld.%ld:%ld.%ld)\n",
@@ -1299,14 +1325,21 @@ static void o2net_idle_timer(unsigned lo
 	o2net_sc_queue_work(sc, &sc->sc_shutdown_work);
 }
 
-static void o2net_sc_postpone_idle(struct o2net_sock_container *sc)
+static void o2net_sc_reset_idle_timer(struct o2net_sock_container *sc)
 {
 	o2net_sc_cancel_delayed_work(sc, &sc->sc_keepalive_work);
 	o2net_sc_queue_delayed_work(sc, &sc->sc_keepalive_work,
-				    O2NET_KEEPALIVE_DELAY_SECS * HZ);
+		      msecs_to_jiffies(o2net_keepalive_delay(sc->sc_node)));
 	do_gettimeofday(&sc->sc_tv_timer);
 	mod_timer(&sc->sc_idle_timeout,
-		  jiffies + (O2NET_IDLE_TIMEOUT_SECS * HZ));
+	       jiffies + msecs_to_jiffies(o2net_idle_timeout(sc->sc_node)));
+}
+
+static void o2net_sc_postpone_idle(struct o2net_sock_container *sc)
+{
+	/* Only push out an existing timer */
+	if (timer_pending(&sc->sc_idle_timeout))
+		o2net_sc_reset_idle_timer(sc);
 }
 
 /* this work func is kicked whenever a path sets the nn state which doesn't
@@ -1427,9 +1460,12 @@ static void o2net_connect_expired(void *
 
 	spin_lock(&nn->nn_lock);
 	if (!nn->nn_sc_valid) {
+		struct o2nm_node *node = nn->nn_sc->sc_node;
 		mlog(ML_ERROR, "no connection established with node %u after "
-		     "%u seconds, giving up and returning errors.\n",
-		     o2net_num_from_nn(nn), O2NET_IDLE_TIMEOUT_SECS);
+		     "%u.%u seconds, giving up and returning errors.\n",
+		     o2net_num_from_nn(nn),
+		     o2net_idle_timeout(node) / 1000,
+		     o2net_idle_timeout(node) % 1000);
 
 		o2net_set_nn_state(nn, NULL, 0, -ENOTCONN);
 	}
@@ -1480,14 +1516,14 @@ static void o2net_hb_node_up_cb(struct o
 
 	/* ensure an immediate connect attempt */
 	nn->nn_last_connect_attempt = jiffies -
-		(msecs_to_jiffies(O2NET_RECONNECT_DELAY_MS) + 1);
+		(msecs_to_jiffies(o2net_reconnect_delay(node)) + 1);
 
 	if (node_num != o2nm_this_node()) {
 		/* heartbeat doesn't work unless a local node number is
 		 * configured and doing so brings up the o2net_wq, so we can
 		 * use it.. */
 		queue_delayed_work(o2net_wq, &nn->nn_connect_expired,
-				   O2NET_IDLE_TIMEOUT_SECS * HZ);
+		                   msecs_to_jiffies(o2net_idle_timeout(node)));
 
 		/* believe it or not, accept and node hearbeating testing
 		 * can succeed for this node before we got here.. so
Index: fs/ocfs2/cluster/tcp.h
===================================================================
--- fs/ocfs2/cluster/tcp.h.orig	2006-11-30 14:54:10.000000000 +0100
+++ fs/ocfs2/cluster/tcp.h	2006-11-30 18:56:45.000000000 +0100
@@ -54,6 +54,13 @@ typedef int (o2net_msg_handler_func)(str
 
 #define O2NET_MAX_PAYLOAD_BYTES  (4096 - sizeof(struct o2net_msg))
 
+/* same as hb delay, we're waiting for another node to recognize our hb */
+#define O2NET_RECONNECT_DELAY_MS_DEFAULT	2000
+
+#define O2NET_KEEPALIVE_DELAY_MS_DEFAULT	5000
+#define O2NET_IDLE_TIMEOUT_MS_DEFAULT		10000
+
+
 /* TODO: figure this out.... */
 static inline int o2net_link_down(int err, struct socket *sock)
 {
Index: fs/ocfs2/cluster/tcp_internal.h
===================================================================
--- fs/ocfs2/cluster/tcp_internal.h.orig	2006-11-30 14:54:10.000000000 +0100
+++ fs/ocfs2/cluster/tcp_internal.h	2006-11-30 18:53:24.000000000 +0100
@@ -27,17 +27,11 @@
 #define O2NET_MSG_KEEP_REQ_MAGIC  ((u16)0xfa57)
 #define O2NET_MSG_KEEP_RESP_MAGIC ((u16)0xfa58)
 
-/* same as hb delay, we're waiting for another node to recognize our hb */
-#define O2NET_RECONNECT_DELAY_MS	O2HB_REGION_TIMEOUT_MS
-
 /* we're delaying our quorum decision so that heartbeat will have timed
  * out truly dead nodes by the time we come around to making decisions
  * on their number */
 #define O2NET_QUORUM_DELAY_MS	((o2hb_dead_threshold + 2) * O2HB_REGION_TIMEOUT_MS)
 
-#define O2NET_KEEPALIVE_DELAY_SECS	5
-#define O2NET_IDLE_TIMEOUT_SECS		10
-
 /* 
  * This version number represents quite a lot, unfortunately.  It not
  * only represents the raw network message protocol on the wire but also

--
