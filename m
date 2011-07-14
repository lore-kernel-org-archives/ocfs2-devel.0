From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu, 14 Jul 2011 15:50:23 -0700
Subject: [Ocfs2-devel] [PATCH 12/16] ocfs2/cluster: Add new function
	o2net_fill_node_map()
In-Reply-To: <1310683827-19157-1-git-send-email-sunil.mushran@oracle.com>
References: <1310683827-19157-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1310683827-19157-13-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Patch adds function o2net_fill_node_map() to return the bitmap of nodes that
it is connected to. This bitmap is also accessible by the user via the debugfs
file, /sys/kernel/debug/o2net/connected_nodes.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/cluster/netdebug.c |  102 +++++++++++++++++++++++++++++--------------
 fs/ocfs2/cluster/tcp.c      |   19 ++++++++
 fs/ocfs2/cluster/tcp.h      |    2 +
 3 files changed, 90 insertions(+), 33 deletions(-)

diff --git a/fs/ocfs2/cluster/netdebug.c b/fs/ocfs2/cluster/netdebug.c
index 3a58359..dc45deb 100644
--- a/fs/ocfs2/cluster/netdebug.c
+++ b/fs/ocfs2/cluster/netdebug.c
@@ -47,6 +47,7 @@
 #define SC_DEBUG_NAME		"sock_containers"
 #define NST_DEBUG_NAME		"send_tracking"
 #define STATS_DEBUG_NAME	"stats"
+#define NODES_DEBUG_NAME	"connected_nodes"
 
 #define SHOW_SOCK_CONTAINERS	0
 #define SHOW_SOCK_STATS		1
@@ -55,6 +56,7 @@ static struct dentry *o2net_dentry;
 static struct dentry *sc_dentry;
 static struct dentry *nst_dentry;
 static struct dentry *stats_dentry;
+static struct dentry *nodes_dentry;
 
 static DEFINE_SPINLOCK(o2net_debug_lock);
 
@@ -491,53 +493,87 @@ static const struct file_operations sc_seq_fops = {
 	.release = sc_fop_release,
 };
 
-int o2net_debugfs_init(void)
+static int o2net_fill_bitmap(char *buf, int len)
 {
-	o2net_dentry = debugfs_create_dir(O2NET_DEBUG_DIR, NULL);
-	if (!o2net_dentry) {
-		mlog_errno(-ENOMEM);
-		goto bail;
-	}
+	unsigned long map[BITS_TO_LONGS(O2NM_MAX_NODES)];
+	int i = -1, out = 0;
 
-	nst_dentry = debugfs_create_file(NST_DEBUG_NAME, S_IFREG|S_IRUSR,
-					 o2net_dentry, NULL,
-					 &nst_seq_fops);
-	if (!nst_dentry) {
-		mlog_errno(-ENOMEM);
-		goto bail;
-	}
+	o2net_fill_node_map(map, sizeof(map));
 
-	sc_dentry = debugfs_create_file(SC_DEBUG_NAME, S_IFREG|S_IRUSR,
-					o2net_dentry, NULL,
-					&sc_seq_fops);
-	if (!sc_dentry) {
-		mlog_errno(-ENOMEM);
-		goto bail;
-	}
+	while ((i = find_next_bit(map, O2NM_MAX_NODES, i + 1)) < O2NM_MAX_NODES)
+		out += snprintf(buf + out, PAGE_SIZE - out, "%d ", i);
+	out += snprintf(buf + out, PAGE_SIZE - out, "\n");
 
-	stats_dentry = debugfs_create_file(STATS_DEBUG_NAME, S_IFREG|S_IRUSR,
-					   o2net_dentry, NULL,
-					   &stats_seq_fops);
-	if (!stats_dentry) {
-		mlog_errno(-ENOMEM);
-		goto bail;
-	}
+	return out;
+}
+
+static int nodes_fop_open(struct inode *inode, struct file *file)
+{
+	char *buf;
+
+	buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	i_size_write(inode, o2net_fill_bitmap(buf, PAGE_SIZE));
+
+	file->private_data = buf;
 
 	return 0;
-bail:
-	debugfs_remove(stats_dentry);
-	debugfs_remove(sc_dentry);
-	debugfs_remove(nst_dentry);
-	debugfs_remove(o2net_dentry);
-	return -ENOMEM;
 }
 
+static int o2net_debug_release(struct inode *inode, struct file *file)
+{
+	kfree(file->private_data);
+	return 0;
+}
+
+static ssize_t o2net_debug_read(struct file *file, char __user *buf,
+				size_t nbytes, loff_t *ppos)
+{
+	return simple_read_from_buffer(buf, nbytes, ppos, file->private_data,
+				       i_size_read(file->f_mapping->host));
+}
+
+static const struct file_operations nodes_fops = {
+	.open		= nodes_fop_open,
+	.release	= o2net_debug_release,
+	.read		= o2net_debug_read,
+	.llseek		= generic_file_llseek,
+};
+
 void o2net_debugfs_exit(void)
 {
+	debugfs_remove(nodes_dentry);
 	debugfs_remove(stats_dentry);
 	debugfs_remove(sc_dentry);
 	debugfs_remove(nst_dentry);
 	debugfs_remove(o2net_dentry);
 }
 
+int o2net_debugfs_init(void)
+{
+	mode_t mode = S_IFREG|S_IRUSR;
+
+	o2net_dentry = debugfs_create_dir(O2NET_DEBUG_DIR, NULL);
+	if (o2net_dentry)
+		nst_dentry = debugfs_create_file(NST_DEBUG_NAME, mode,
+					o2net_dentry, NULL, &nst_seq_fops);
+	if (nst_dentry)
+		sc_dentry = debugfs_create_file(SC_DEBUG_NAME, mode,
+					o2net_dentry, NULL, &sc_seq_fops);
+	if (sc_dentry)
+		stats_dentry = debugfs_create_file(STATS_DEBUG_NAME, mode,
+					o2net_dentry, NULL, &stats_seq_fops);
+	if (stats_dentry)
+		nodes_dentry = debugfs_create_file(NODES_DEBUG_NAME, mode,
+					o2net_dentry, NULL, &nodes_fops);
+	if (nodes_dentry)
+		return 0;
+
+	o2net_debugfs_exit();
+	mlog_errno(-ENOMEM);
+	return -ENOMEM;
+}
+
 #endif	/* CONFIG_DEBUG_FS */
diff --git a/fs/ocfs2/cluster/tcp.c b/fs/ocfs2/cluster/tcp.c
index 6e97895..ae13d5c 100644
--- a/fs/ocfs2/cluster/tcp.c
+++ b/fs/ocfs2/cluster/tcp.c
@@ -1034,6 +1034,25 @@ static int o2net_tx_can_proceed(struct o2net_node *nn,
 	return ret;
 }
 
+/* Get a map of all nodes to which this node is currently connected to */
+void o2net_fill_node_map(unsigned long *map, unsigned bytes)
+{
+	struct o2net_sock_container *sc;
+	int node, ret;
+
+	BUG_ON(bytes < (BITS_TO_LONGS(O2NM_MAX_NODES) * sizeof(unsigned long)));
+
+	memset(map, 0, bytes);
+	for (node = 0; node < O2NM_MAX_NODES; ++node) {
+		o2net_tx_can_proceed(o2net_nn_from_num(node), &sc, &ret);
+		if (!ret) {
+			set_bit(node, map);
+			sc_put(sc);
+		}
+	}
+}
+EXPORT_SYMBOL_GPL(o2net_fill_node_map);
+
 int o2net_send_message_vec(u32 msg_type, u32 key, struct kvec *caller_vec,
 			   size_t caller_veclen, u8 target_node, int *status)
 {
diff --git a/fs/ocfs2/cluster/tcp.h b/fs/ocfs2/cluster/tcp.h
index fd6179e..5bada2a 100644
--- a/fs/ocfs2/cluster/tcp.h
+++ b/fs/ocfs2/cluster/tcp.h
@@ -106,6 +106,8 @@ int o2net_register_handler(u32 msg_type, u32 key, u32 max_len,
 			   struct list_head *unreg_list);
 void o2net_unregister_handler_list(struct list_head *list);
 
+void o2net_fill_node_map(unsigned long *map, unsigned bytes);
+
 struct o2nm_node;
 int o2net_register_hb_callbacks(void);
 void o2net_unregister_hb_callbacks(void);
-- 
1.7.4.1
