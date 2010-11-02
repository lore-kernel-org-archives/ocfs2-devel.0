From: Srinivas Eeda <srinivas.eeda@oracle.com>
Date: Tue,  2 Nov 2010 13:18:00 -0700
Subject: [Ocfs2-devel] [PATCH 2/2] ocfs2/cluster: Add per-region debugfs
	file to show the elapsed time
In-Reply-To: <1288729080-1962-1-git-send-email-srinivas.eeda@oracle.com>
References: <1288729080-1962-1-git-send-email-srinivas.eeda@oracle.com>
Message-ID: <1288729080-1962-3-git-send-email-srinivas.eeda@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Sunil Mushran <sunil.mushran@oracle.com>

Mainline fa16655a622e7c0fda76ca5155db6efc86968c65
A per-region debugfs file, elapsed_time_in_ms, shows the time since the
heartbeat timer was last armed.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/cluster/heartbeat.c |   46 ++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 46 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index 8580e66..0ae0dea 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -63,6 +63,7 @@ static DECLARE_WAIT_QUEUE_HEAD(o2hb_steady_queue);
 
 #define O2HB_DEBUG_DIR			"o2hb"
 #define O2HB_DEBUG_LIVENODES		"livenodes"
+#define O2HB_DEBUG_REGION_ELAPSED_TIME	"elapsed_time_in_ms"
 static struct dentry *o2hb_debug_dir;
 static struct dentry *o2hb_debug_livenodes;
 
@@ -135,6 +136,7 @@ struct o2hb_region {
 	struct o2hb_disk_slot	*hr_slots;
 
 	struct dentry		*hr_debug_dir;
+	struct dentry		*hr_debug_elapsed_time;
 
 	/* let the person setting up hb wait for it to return until it
 	 * has reached a 'steady' state.  This will be fixed when we have
@@ -950,6 +952,29 @@ bail:
 	return -ENOMEM;
 }
 
+static int o2hb_region_debug_open(struct inode *inode, struct file *file)
+{
+	struct o2hb_region *reg = inode->i_private;
+	char *buf = NULL;
+	int out = 0;
+
+	buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
+	if (!buf)
+		goto bail;
+
+	out += snprintf(buf + out, PAGE_SIZE - out, "%u\n",
+			jiffies_to_msecs(jiffies -
+					 reg->hr_last_timeout_start));
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
 static int o2hb_debug_release(struct inode *inode, struct file *file)
 {
 	kfree(file->private_data);
@@ -985,6 +1010,13 @@ static struct file_operations o2hb_debug_fops = {
 	.llseek =	generic_file_llseek,
 };
 
+static struct file_operations o2hb_region_debug_fops = {
+	.open =		o2hb_region_debug_open,
+	.release =	o2hb_debug_release,
+	.read =		o2hb_debug_read,
+	.llseek =	generic_file_llseek,
+};
+
 void o2hb_exit(void)
 {
 	if (o2hb_debug_livenodes)
@@ -1087,6 +1119,7 @@ static void o2hb_region_release(struct config_item *item)
 	if (reg->hr_slots)
 		kfree(reg->hr_slots);
 
+	debugfs_remove(reg->hr_debug_elapsed_time);
 	debugfs_remove(reg->hr_debug_dir);
 
 	spin_lock(&o2hb_live_lock);
@@ -1617,6 +1650,17 @@ static struct config_item *o2hb_heartbeat_group_make_item(struct config_group *g
 		goto out;
 	}
 
+	reg->hr_debug_elapsed_time =
+		debugfs_create_file(O2HB_DEBUG_REGION_ELAPSED_TIME,
+				    S_IFREG|S_IRUSR,
+				    reg->hr_debug_dir,
+				    reg,
+				    &o2hb_region_debug_fops);
+	if (!reg->hr_debug_elapsed_time) {
+		mlog_errno(-ENOMEM);
+		goto out;
+	}
+
 	spin_lock(&o2hb_live_lock);
 	list_add_tail(&reg->hr_all_item, &o2hb_all_regions);
 	spin_unlock(&o2hb_live_lock);
@@ -1624,6 +1668,8 @@ static struct config_item *o2hb_heartbeat_group_make_item(struct config_group *g
 	return &reg->hr_item;
 
 out:
+	if (reg && reg->hr_debug_dir)
+		debugfs_remove(reg->hr_debug_dir);
 	kfree(reg);
 	return NULL;
 }
-- 
1.5.6.5
