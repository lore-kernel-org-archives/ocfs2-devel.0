From: Mark Fasheh <mfasheh@suse.com>
Date: Tue, 17 Mar 2009 13:00:51 -0700
Subject: [Ocfs2-devel] [PATCH 01/32] ocfs2/hb: Expose the list of
	heartbeating nodes via debugfs
In-Reply-To: <1237320082-12921-1-git-send-email-mfasheh@suse.com>
References: <1237320082-12921-1-git-send-email-mfasheh@suse.com>
Message-ID: <1237320082-12921-2-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>, Sunil Mushran <sunil.mushran@oracle.com>, Mark Fasheh <mfasheh@suse.com>

From: Sunil Mushran <sunil.mushran@oracle.com>

This patch creates a debugfs file, o2hb/livesnodes, which exposes the
aggregate list of heartbeating node across all heartbeat regions.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/cluster/heartbeat.c   |   96 +++++++++++++++++++++++++++++++++++++++-
 fs/ocfs2/cluster/heartbeat.h   |    3 +-
 fs/ocfs2/cluster/nodemanager.c |    9 +++-
 3 files changed, 104 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index 04697ba..4f85ece 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -33,6 +33,7 @@
 #include <linux/random.h>
 #include <linux/crc32.h>
 #include <linux/time.h>
+#include <linux/debugfs.h>
 
 #include "heartbeat.h"
 #include "tcp.h"
@@ -60,6 +61,11 @@ static unsigned long o2hb_live_node_bitmap[BITS_TO_LONGS(O2NM_MAX_NODES)];
 static LIST_HEAD(o2hb_node_events);
 static DECLARE_WAIT_QUEUE_HEAD(o2hb_steady_queue);
 
+#define O2HB_DEBUG_DIR			"o2hb"
+#define O2HB_DEBUG_LIVENODES		"livenodes"
+static struct dentry *o2hb_debug_dir;
+static struct dentry *o2hb_debug_livenodes;
+
 static LIST_HEAD(o2hb_all_regions);
 
 static struct o2hb_callback {
@@ -905,7 +911,77 @@ static int o2hb_thread(void *data)
 	return 0;
 }
 
-void o2hb_init(void)
+#ifdef CONFIG_DEBUG_FS
+static int o2hb_debug_open(struct inode *inode, struct file *file)
+{
+	unsigned long map[BITS_TO_LONGS(O2NM_MAX_NODES)];
+	char *buf = NULL;
+	int i = -1;
+	int out = 0;
+
+	buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
+	if (!buf)
+		goto bail;
+
+	o2hb_fill_node_map(map, sizeof(map));
+
+	while ((i = find_next_bit(map, O2NM_MAX_NODES, i + 1)) < O2NM_MAX_NODES)
+		out += snprintf(buf + out, PAGE_SIZE - out, "%d ", i);
+	out += snprintf(buf + out, PAGE_SIZE - out, "\n");
+
+	i_size_write(inode, out);
+
+	file->private_data = buf;
+
+	return 0;
+bail:
+	return -ENOMEM;
+}
+
+static int o2hb_debug_release(struct inode *inode, struct file *file)
+{
+	kfree(file->private_data);
+	return 0;
+}
+
+static ssize_t o2hb_debug_read(struct file *file, char __user *buf,
+				 size_t nbytes, loff_t *ppos)
+{
+	return simple_read_from_buffer(buf, nbytes, ppos, file->private_data,
+				       i_size_read(file->f_mapping->host));
+}
+#else
+static int o2hb_debug_open(struct inode *inode, struct file *file)
+{
+	return 0;
+}
+static int o2hb_debug_release(struct inode *inode, struct file *file)
+{
+	return 0;
+}
+static ssize_t o2hb_debug_read(struct file *file, char __user *buf,
+			       size_t nbytes, loff_t *ppos)
+{
+	return 0;
+}
+#endif  /* CONFIG_DEBUG_FS */
+
+static struct file_operations o2hb_debug_fops = {
+	.open =		o2hb_debug_open,
+	.release =	o2hb_debug_release,
+	.read =		o2hb_debug_read,
+	.llseek =	generic_file_llseek,
+};
+
+void o2hb_exit(void)
+{
+	if (o2hb_debug_livenodes)
+		debugfs_remove(o2hb_debug_livenodes);
+	if (o2hb_debug_dir)
+		debugfs_remove(o2hb_debug_dir);
+}
+
+int o2hb_init(void)
 {
 	int i;
 
@@ -918,6 +994,24 @@ void o2hb_init(void)
 	INIT_LIST_HEAD(&o2hb_node_events);
 
 	memset(o2hb_live_node_bitmap, 0, sizeof(o2hb_live_node_bitmap));
+
+	o2hb_debug_dir = debugfs_create_dir(O2HB_DEBUG_DIR, NULL);
+	if (!o2hb_debug_dir) {
+		mlog_errno(-ENOMEM);
+		return -ENOMEM;
+	}
+
+	o2hb_debug_livenodes = debugfs_create_file(O2HB_DEBUG_LIVENODES,
+						   S_IFREG|S_IRUSR,
+						   o2hb_debug_dir, NULL,
+						   &o2hb_debug_fops);
+	if (!o2hb_debug_livenodes) {
+		mlog_errno(-ENOMEM);
+		debugfs_remove(o2hb_debug_dir);
+		return -ENOMEM;
+	}
+
+	return 0;
 }
 
 /* if we're already in a callback then we're already serialized by the sem */
diff --git a/fs/ocfs2/cluster/heartbeat.h b/fs/ocfs2/cluster/heartbeat.h
index e511339..2f16492 100644
--- a/fs/ocfs2/cluster/heartbeat.h
+++ b/fs/ocfs2/cluster/heartbeat.h
@@ -75,7 +75,8 @@ void o2hb_unregister_callback(const char *region_uuid,
 			      struct o2hb_callback_func *hc);
 void o2hb_fill_node_map(unsigned long *map,
 			unsigned bytes);
-void o2hb_init(void);
+void o2hb_exit(void);
+int o2hb_init(void);
 int o2hb_check_node_heartbeating(u8 node_num);
 int o2hb_check_node_heartbeating_from_callback(u8 node_num);
 int o2hb_check_local_node_heartbeating(void);
diff --git a/fs/ocfs2/cluster/nodemanager.c b/fs/ocfs2/cluster/nodemanager.c
index 70e8fa9..7ee6188 100644
--- a/fs/ocfs2/cluster/nodemanager.c
+++ b/fs/ocfs2/cluster/nodemanager.c
@@ -881,6 +881,7 @@ static void __exit exit_o2nm(void)
 	o2cb_sys_shutdown();
 
 	o2net_exit();
+	o2hb_exit();
 }
 
 static int __init init_o2nm(void)
@@ -889,11 +890,13 @@ static int __init init_o2nm(void)
 
 	cluster_print_version();
 
-	o2hb_init();
+	ret = o2hb_init();
+	if (ret)
+		goto out;
 
 	ret = o2net_init();
 	if (ret)
-		goto out;
+		goto out_o2hb;
 
 	ret = o2net_register_hb_callbacks();
 	if (ret)
@@ -916,6 +919,8 @@ out_callbacks:
 	o2net_unregister_hb_callbacks();
 out_o2net:
 	o2net_exit();
+out_o2hb:
+	o2hb_exit();
 out:
 	return ret;
 }
-- 
1.5.6
