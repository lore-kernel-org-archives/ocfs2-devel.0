From: Joseph Qi <joseph.qi@huawei.com>
Date: Fri, 22 Jan 2016 18:11:08 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2/cluster: fix memory leak in
	o2hb_region_release
Message-ID: <56A2003C.70405@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

o2hb_region_release currently doesn't free o2hb_debug_buf
hr_db_elapsed_time and hr_db_pinned malloced in o2hb_debug_create.
Also we should call debugfs_remove before freeing its data, to prevent
the risk accessing debugfs rightly after its data has been freed.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Reviewed-by: Jiufei Xue <xuejiufei@huawei.com>
---
 fs/ocfs2/cluster/heartbeat.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index 709fbbd..428683b 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -1254,15 +1254,15 @@ static const struct file_operations o2hb_debug_fops = {

 void o2hb_exit(void)
 {
-	kfree(o2hb_db_livenodes);
-	kfree(o2hb_db_liveregions);
-	kfree(o2hb_db_quorumregions);
-	kfree(o2hb_db_failedregions);
 	debugfs_remove(o2hb_debug_failedregions);
 	debugfs_remove(o2hb_debug_quorumregions);
 	debugfs_remove(o2hb_debug_liveregions);
 	debugfs_remove(o2hb_debug_livenodes);
 	debugfs_remove(o2hb_debug_dir);
+	kfree(o2hb_db_livenodes);
+	kfree(o2hb_db_liveregions);
+	kfree(o2hb_db_quorumregions);
+	kfree(o2hb_db_failedregions);
 }

 static struct dentry *o2hb_debug_create(const char *name, struct dentry *dir,
@@ -1438,13 +1438,15 @@ static void o2hb_region_release(struct config_item *item)

 	kfree(reg->hr_slots);

-	kfree(reg->hr_db_regnum);
-	kfree(reg->hr_db_livenodes);
 	debugfs_remove(reg->hr_debug_livenodes);
 	debugfs_remove(reg->hr_debug_regnum);
 	debugfs_remove(reg->hr_debug_elapsed_time);
 	debugfs_remove(reg->hr_debug_pinned);
 	debugfs_remove(reg->hr_debug_dir);
+	kfree(reg->hr_db_livenodes);
+	kfree(reg->hr_db_regnum);
+	kfree(reg->hr_debug_elapsed_time);
+	kfree(reg->hr_debug_pinned);

 	spin_lock(&o2hb_live_lock);
 	list_del(&reg->hr_all_item);
-- 
1.8.4.3
