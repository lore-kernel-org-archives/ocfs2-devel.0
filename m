From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Wed, 22 Dec 2010 12:39:42 -0800
Subject: [Ocfs2-devel] [PATCH 6/6] ocfs2/cluster: Show o2net timing
	statistics
In-Reply-To: <1293050382-3636-1-git-send-email-sunil.mushran@oracle.com>
References: <1293050382-3636-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1293050382-3636-7-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Adds debugfs dentry o2net/stats to show the o2net timing statistics.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/cluster/netdebug.c |  211 ++++++++++++++++++++++++++++++++-----------
 1 files changed, 157 insertions(+), 54 deletions(-)

diff --git a/fs/ocfs2/cluster/netdebug.c b/fs/ocfs2/cluster/netdebug.c
index 536a93d..68f75b3 100644
--- a/fs/ocfs2/cluster/netdebug.c
+++ b/fs/ocfs2/cluster/netdebug.c
@@ -46,10 +46,15 @@
 #define O2NET_DEBUG_DIR		"o2net"
 #define SC_DEBUG_NAME		"sock_containers"
 #define NST_DEBUG_NAME		"send_tracking"
+#define STATS_DEBUG_NAME	"stats"
+
+#define SHOW_SOCK_CONTAINERS	0
+#define SHOW_SOCK_STATS		1
 
 static struct dentry *o2net_dentry;
 static struct dentry *sc_dentry;
 static struct dentry *nst_dentry;
+static struct dentry *stats_dentry;
 
 static DEFINE_SPINLOCK(o2net_debug_lock);
 
@@ -232,6 +237,11 @@ void o2net_debug_del_sc(struct o2net_sock_container *sc)
 	spin_unlock(&o2net_debug_lock);
 }
 
+struct o2net_sock_debug {
+	int dbg_ctxt;
+	struct o2net_sock_container *dbg_sock;
+};
+
 static struct o2net_sock_container
 			*next_sc(struct o2net_sock_container *sc_start)
 {
@@ -257,7 +267,8 @@ static struct o2net_sock_container
 
 static void *sc_seq_start(struct seq_file *seq, loff_t *pos)
 {
-	struct o2net_sock_container *sc, *dummy_sc = seq->private;
+	struct o2net_sock_debug *sd = seq->private;
+	struct o2net_sock_container *sc, *dummy_sc = sd->dbg_sock;
 
 	spin_lock(&o2net_debug_lock);
 	sc = next_sc(dummy_sc);
@@ -268,7 +279,8 @@ static void *sc_seq_start(struct seq_file *seq, loff_t *pos)
 
 static void *sc_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 {
-	struct o2net_sock_container *sc, *dummy_sc = seq->private;
+	struct o2net_sock_debug *sd = seq->private;
+	struct o2net_sock_container *sc, *dummy_sc = sd->dbg_sock;
 
 	spin_lock(&o2net_debug_lock);
 	sc = next_sc(dummy_sc);
@@ -280,63 +292,107 @@ static void *sc_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 	return sc; /* unused, just needs to be null when done */
 }
 
-static int sc_seq_show(struct seq_file *seq, void *v)
+#ifdef CONFIG_OCFS2_FS_STATS
+# define sc_send_count(_s)		((_s)->sc_send_count)
+# define sc_recv_count(_s)		((_s)->sc_recv_count)
+# define sc_tv_acquiry_total_ns(_s)	(ktime_to_ns((_s)->sc_tv_acquiry_total))
+# define sc_tv_send_total_ns(_s)	(ktime_to_ns((_s)->sc_tv_send_total))
+# define sc_tv_status_total_ns(_s)	(ktime_to_ns((_s)->sc_tv_status_total))
+# define sc_tv_process_total_ns(_s)	(ktime_to_ns((_s)->sc_tv_process_total))
+#else
+# define sc_send_count(_s)		(0U)
+# define sc_recv_count(_s)		(0U)
+# define sc_tv_acquiry_total_ns(_s)	(0LL)
+# define sc_tv_send_total_ns(_s)	(0LL)
+# define sc_tv_status_total_ns(_s)	(0LL)
+# define sc_tv_process_total_ns(_s)	(0LL)
+#endif
+
+/* So that debugfs.ocfs2 can determine which format is being used */
+#define O2NET_STATS_STR_VERSION		1
+static void sc_show_sock_stats(struct seq_file *seq,
+			       struct o2net_sock_container *sc)
 {
-	struct o2net_sock_container *sc, *dummy_sc = seq->private;
+	if (!sc)
+		return;
+
+	seq_printf(seq, "%d,%u,%lu,%lld,%lld,%lld,%lu,%lld\n", O2NET_STATS_STR_VERSION,
+		   sc->sc_node->nd_num, (unsigned long)sc_send_count(sc),
+		   (long long)sc_tv_acquiry_total_ns(sc),
+		   (long long)sc_tv_send_total_ns(sc),
+		   (long long)sc_tv_status_total_ns(sc),
+		   (unsigned long)sc_recv_count(sc),
+		   (long long)sc_tv_process_total_ns(sc));
+}
 
-	spin_lock(&o2net_debug_lock);
-	sc = next_sc(dummy_sc);
+static void sc_show_sock_container(struct seq_file *seq,
+				   struct o2net_sock_container *sc)
+{
+	struct inet_sock *inet = NULL;
+	__be32 saddr = 0, daddr = 0;
+	__be16 sport = 0, dport = 0;
+
+	if (!sc)
+		return;
+
+	if (sc->sc_sock) {
+		inet = inet_sk(sc->sc_sock->sk);
+		/* the stack's structs aren't sparse endian clean */
+		saddr = (__force __be32)inet->inet_saddr;
+		daddr = (__force __be32)inet->inet_daddr;
+		sport = (__force __be16)inet->inet_sport;
+		dport = (__force __be16)inet->inet_dport;
+	}
 
-	if (sc != NULL) {
-		struct inet_sock *inet = NULL;
+	/* XXX sigh, inet-> doesn't have sparse annotation so any
+	 * use of it here generates a warning with -Wbitwise */
+	seq_printf(seq, "%p:\n"
+		   "  krefs:           %d\n"
+		   "  sock:            %pI4:%u -> "
+				      "%pI4:%u\n"
+		   "  remote node:     %s\n"
+		   "  page off:        %zu\n"
+		   "  handshake ok:    %u\n"
+		   "  timer:           %lld usecs\n"
+		   "  data ready:      %lld usecs\n"
+		   "  advance start:   %lld usecs\n"
+		   "  advance stop:    %lld usecs\n"
+		   "  func start:      %lld usecs\n"
+		   "  func stop:       %lld usecs\n"
+		   "  func key:        0x%08x\n"
+		   "  func type:       %u\n",
+		   sc,
+		   atomic_read(&sc->sc_kref.refcount),
+		   &saddr, inet ? ntohs(sport) : 0,
+		   &daddr, inet ? ntohs(dport) : 0,
+		   sc->sc_node->nd_name,
+		   sc->sc_page_off,
+		   sc->sc_handshake_ok,
+		   (long long)ktime_to_us(sc->sc_tv_timer),
+		   (long long)ktime_to_us(sc->sc_tv_data_ready),
+		   (long long)ktime_to_us(sc->sc_tv_advance_start),
+		   (long long)ktime_to_us(sc->sc_tv_advance_stop),
+		   (long long)ktime_to_us(sc->sc_tv_func_start),
+		   (long long)ktime_to_us(sc->sc_tv_func_stop),
+		   sc->sc_msg_key,
+		   sc->sc_msg_type);
+}
 
-		__be32 saddr = 0, daddr = 0;
-		__be16 sport = 0, dport = 0;
+static int sc_seq_show(struct seq_file *seq, void *v)
+{
+	struct o2net_sock_debug *sd = seq->private;
+	struct o2net_sock_container *sc, *dummy_sc = sd->dbg_sock;
 
-		if (sc->sc_sock) {
-			inet = inet_sk(sc->sc_sock->sk);
-			/* the stack's structs aren't sparse endian clean */
-			saddr = (__force __be32)inet->inet_saddr;
-			daddr = (__force __be32)inet->inet_daddr;
-			sport = (__force __be16)inet->inet_sport;
-			dport = (__force __be16)inet->inet_dport;
-		}
+	spin_lock(&o2net_debug_lock);
+	sc = next_sc(dummy_sc);
 
-		/* XXX sigh, inet-> doesn't have sparse annotation so any
-		 * use of it here generates a warning with -Wbitwise */
-		seq_printf(seq, "%p:\n"
-			   "  krefs:           %d\n"
-			   "  sock:            %pI4:%u -> "
-					      "%pI4:%u\n"
-			   "  remote node:     %s\n"
-			   "  page off:        %zu\n"
-			   "  handshake ok:    %u\n"
-			   "  timer:           %lld usecs\n"
-			   "  data ready:      %lld usecs\n"
-			   "  advance start:   %lld usecs\n"
-			   "  advance stop:    %lld usecs\n"
-			   "  func start:      %lld usecs\n"
-			   "  func stop:       %lld usecs\n"
-			   "  func key:        0x%08x\n"
-			   "  func type:       %u\n",
-			   sc,
-			   atomic_read(&sc->sc_kref.refcount),
-			   &saddr, inet ? ntohs(sport) : 0,
-			   &daddr, inet ? ntohs(dport) : 0,
-			   sc->sc_node->nd_name,
-			   sc->sc_page_off,
-			   sc->sc_handshake_ok,
-			   (long long)ktime_to_us(sc->sc_tv_timer),
-			   (long long)ktime_to_us(sc->sc_tv_data_ready),
-			   (long long)ktime_to_us(sc->sc_tv_advance_start),
-			   (long long)ktime_to_us(sc->sc_tv_advance_stop),
-			   (long long)ktime_to_us(sc->sc_tv_func_start),
-			   (long long)ktime_to_us(sc->sc_tv_func_stop),
-			   sc->sc_msg_key,
-			   sc->sc_msg_type);
+	if (sc) {
+		if (sd->dbg_ctxt == SHOW_SOCK_CONTAINERS)
+			sc_show_sock_container(seq, sc);
+		else
+			sc_show_sock_stats(seq, sc);
 	}
 
-
 	spin_unlock(&o2net_debug_lock);
 
 	return 0;
@@ -353,7 +409,7 @@ static const struct seq_operations sc_seq_ops = {
 	.show = sc_seq_show,
 };
 
-static int sc_fop_open(struct inode *inode, struct file *file)
+static int sc_common_open(struct file *file, struct o2net_sock_debug *sd)
 {
 	struct o2net_sock_container *dummy_sc;
 	struct seq_file *seq;
@@ -371,7 +427,8 @@ static int sc_fop_open(struct inode *inode, struct file *file)
 		goto out;
 
 	seq = file->private_data;
-	seq->private = dummy_sc;
+	seq->private = sd;
+	sd->dbg_sock = dummy_sc;
 	o2net_debug_add_sc(dummy_sc);
 
 	dummy_sc = NULL;
@@ -384,12 +441,48 @@ out:
 static int sc_fop_release(struct inode *inode, struct file *file)
 {
 	struct seq_file *seq = file->private_data;
-	struct o2net_sock_container *dummy_sc = seq->private;
+	struct o2net_sock_debug *sd = seq->private;
+	struct o2net_sock_container *dummy_sc = sd->dbg_sock;
 
 	o2net_debug_del_sc(dummy_sc);
 	return seq_release_private(inode, file);
 }
 
+static int stats_fop_open(struct inode *inode, struct file *file)
+{
+	struct o2net_sock_debug *sd;
+
+	sd = kmalloc(sizeof(struct o2net_sock_debug), GFP_KERNEL);
+	if (sd == NULL)
+		return -ENOMEM;
+
+	sd->dbg_ctxt = SHOW_SOCK_STATS;
+	sd->dbg_sock = NULL;
+
+	return sc_common_open(file, sd);
+}
+
+static struct file_operations stats_seq_fops = {
+	.open = stats_fop_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = sc_fop_release,
+};
+
+static int sc_fop_open(struct inode *inode, struct file *file)
+{
+	struct o2net_sock_debug *sd;
+
+	sd = kmalloc(sizeof(struct o2net_sock_debug), GFP_KERNEL);
+	if (sd == NULL)
+		return -ENOMEM;
+
+	sd->dbg_ctxt = SHOW_SOCK_CONTAINERS;
+	sd->dbg_sock = NULL;
+
+	return sc_common_open(file, sd);
+}
+
 static const struct file_operations sc_seq_fops = {
 	.open = sc_fop_open,
 	.read = seq_read,
@@ -421,8 +514,17 @@ int o2net_debugfs_init(void)
 		goto bail;
 	}
 
+	stats_dentry = debugfs_create_file(STATS_DEBUG_NAME, S_IFREG|S_IRUSR,
+					   o2net_dentry, NULL,
+					   &stats_seq_fops);
+	if (!stats_dentry) {
+		mlog_errno(-ENOMEM);
+		goto bail;
+	}
+
 	return 0;
 bail:
+	debugfs_remove(stats_dentry);
 	debugfs_remove(sc_dentry);
 	debugfs_remove(nst_dentry);
 	debugfs_remove(o2net_dentry);
@@ -431,6 +533,7 @@ bail:
 
 void o2net_debugfs_exit(void)
 {
+	debugfs_remove(stats_dentry);
 	debugfs_remove(sc_dentry);
 	debugfs_remove(nst_dentry);
 	debugfs_remove(o2net_dentry);
-- 
1.7.1
