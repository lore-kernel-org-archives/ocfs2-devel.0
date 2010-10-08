From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu,  7 Oct 2010 17:15:26 -0700
Subject: [Ocfs2-devel] [PATCH 12/22] ocfs2/cluster: Reorganize o2hb debugfs
	init
In-Reply-To: <1286496936-17072-1-git-send-email-sunil.mushran@oracle.com>
References: <1286496936-17072-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1286496936-17072-13-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

o2hb debugfs handling is reorganized to allow for easy expansion.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/cluster/heartbeat.c |  101 ++++++++++++++++++++++++++++++++----------
 1 files changed, 78 insertions(+), 23 deletions(-)

diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index a8f1064..16e4976 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -62,8 +62,19 @@ static unsigned long o2hb_live_node_bitmap[BITS_TO_LONGS(O2NM_MAX_NODES)];
 static LIST_HEAD(o2hb_node_events);
 static DECLARE_WAIT_QUEUE_HEAD(o2hb_steady_queue);
 
+#define O2HB_DB_TYPE_LIVENODES		0
+struct o2hb_debug_buf {
+	int db_type;
+	int db_size;
+	int db_len;
+	void *db_data;
+};
+
+static struct o2hb_debug_buf *o2hb_db_livenodes;
+
 #define O2HB_DEBUG_DIR			"o2hb"
 #define O2HB_DEBUG_LIVENODES		"livenodes"
+
 static struct dentry *o2hb_debug_dir;
 static struct dentry *o2hb_debug_livenodes;
 
@@ -969,21 +980,35 @@ static int o2hb_thread(void *data)
 #ifdef CONFIG_DEBUG_FS
 static int o2hb_debug_open(struct inode *inode, struct file *file)
 {
+	struct o2hb_debug_buf *db = inode->i_private;
 	unsigned long map[BITS_TO_LONGS(O2NM_MAX_NODES)];
 	char *buf = NULL;
 	int i = -1;
 	int out = 0;
 
+	/* max_nodes should be the largest bitmap we pass here */
+	BUG_ON(sizeof(map) < db->db_size);
+
 	buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!buf)
 		goto bail;
 
-	o2hb_fill_node_map(map, sizeof(map));
+	switch (db->db_type) {
+	case O2HB_DB_TYPE_LIVENODES:
+		spin_lock(&o2hb_live_lock);
+		memcpy(map, db->db_data, db->db_size);
+		spin_unlock(&o2hb_live_lock);
+		break;
+
+	default:
+		goto done;
+	}
 
-	while ((i = find_next_bit(map, O2NM_MAX_NODES, i + 1)) < O2NM_MAX_NODES)
+	while ((i = find_next_bit(map, db->db_len, i + 1)) < db->db_len)
 		out += snprintf(buf + out, PAGE_SIZE - out, "%d ", i);
 	out += snprintf(buf + out, PAGE_SIZE - out, "\n");
 
+done:
 	i_size_write(inode, out);
 
 	file->private_data = buf;
@@ -1030,10 +1055,56 @@ static const struct file_operations o2hb_debug_fops = {
 
 void o2hb_exit(void)
 {
-	if (o2hb_debug_livenodes)
-		debugfs_remove(o2hb_debug_livenodes);
-	if (o2hb_debug_dir)
-		debugfs_remove(o2hb_debug_dir);
+	kfree(o2hb_db_livenodes);
+	debugfs_remove(o2hb_debug_livenodes);
+	debugfs_remove(o2hb_debug_dir);
+}
+
+static struct dentry *o2hb_debug_create(const char *name, struct dentry *dir,
+					struct o2hb_debug_buf **db, int db_len,
+					int type, int size, int len, void *data)
+{
+	*db = kmalloc(db_len, GFP_KERNEL);
+	if (!*db)
+		return NULL;
+
+	(*db)->db_type = type;
+	(*db)->db_size = size;
+	(*db)->db_len = len;
+	(*db)->db_data = data;
+
+	return debugfs_create_file(name, S_IFREG|S_IRUSR, dir, *db,
+				   &o2hb_debug_fops);
+}
+
+static int o2hb_debug_init(void)
+{
+	int ret = -ENOMEM;
+
+	o2hb_debug_dir = debugfs_create_dir(O2HB_DEBUG_DIR, NULL);
+	if (!o2hb_debug_dir) {
+		mlog_errno(ret);
+		goto bail;
+	}
+
+	o2hb_debug_livenodes = o2hb_debug_create(O2HB_DEBUG_LIVENODES,
+						 o2hb_debug_dir,
+						 &o2hb_db_livenodes,
+						 sizeof(*o2hb_db_livenodes),
+						 O2HB_DB_TYPE_LIVENODES,
+						 sizeof(o2hb_live_node_bitmap),
+						 O2NM_MAX_NODES,
+						 o2hb_live_node_bitmap);
+	if (!o2hb_debug_livenodes) {
+		mlog_errno(ret);
+		goto bail;
+	}
+	ret = 0;
+bail:
+	if (ret)
+		o2hb_exit();
+
+	return ret;
 }
 
 int o2hb_init(void)
@@ -1050,23 +1121,7 @@ int o2hb_init(void)
 
 	memset(o2hb_live_node_bitmap, 0, sizeof(o2hb_live_node_bitmap));
 
-	o2hb_debug_dir = debugfs_create_dir(O2HB_DEBUG_DIR, NULL);
-	if (!o2hb_debug_dir) {
-		mlog_errno(-ENOMEM);
-		return -ENOMEM;
-	}
-
-	o2hb_debug_livenodes = debugfs_create_file(O2HB_DEBUG_LIVENODES,
-						   S_IFREG|S_IRUSR,
-						   o2hb_debug_dir, NULL,
-						   &o2hb_debug_fops);
-	if (!o2hb_debug_livenodes) {
-		mlog_errno(-ENOMEM);
-		debugfs_remove(o2hb_debug_dir);
-		return -ENOMEM;
-	}
-
-	return 0;
+	return o2hb_debug_init();
 }
 
 /* if we're already in a callback then we're already serialized by the sem */
-- 
1.7.0.4
