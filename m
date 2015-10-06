From: Joseph Qi <joseph.qi@huawei.com>
Date: Tue, 6 Oct 2015 14:00:56 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix race between mount and delete
	node/cluster
Message-ID: <56136398.1050001@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

There is a race case between mount and delete node/cluster, which will
lead o2hb_thread to malfunctioning dead loop.

o2hb_thread
{
	o2nm_depend_this_node();
	<<<<<< race window, node may have already been deleted, and then
	       enter the loop, o2hb thread will be malfunctioning
	       because of no configured nodes found.
	while (!kthread_should_stop() &&
		!reg->hr_unclean_stop && !reg->hr_aborted_start) {
}

So check the return value of o2nm_depend_this_node() is needed. If node
has been deleted, do not enter the loop and let mount fail.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
---
 fs/ocfs2/cluster/heartbeat.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index 16eff45..a224cf1 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -219,7 +219,8 @@ struct o2hb_region {
 	unsigned		hr_unclean_stop:1,
 				hr_aborted_start:1,
 				hr_item_pinned:1,
-				hr_item_dropped:1;
+				hr_item_dropped:1,
+				hr_node_deleted:1;

 	/* protected by the hr_callback_sem */
 	struct task_struct 	*hr_task;
@@ -1110,7 +1111,13 @@ static int o2hb_thread(void *data)
 	set_user_nice(current, MIN_NICE);

 	/* Pin node */
-	o2nm_depend_this_node();
+	ret = o2nm_depend_this_node();
+	if (ret) {
+		mlog(ML_ERROR, "Node has been deleted, ret = %d\n", ret);
+		reg->hr_node_deleted = 1;
+		wake_up(&o2hb_steady_queue);
+		return 0;
+	}

 	while (!kthread_should_stop() &&
 	       !reg->hr_unclean_stop && !reg->hr_aborted_start) {
@@ -1829,7 +1836,8 @@ static ssize_t o2hb_region_dev_write(struct o2hb_region *reg,
 	spin_unlock(&o2hb_live_lock);

 	ret = wait_event_interruptible(o2hb_steady_queue,
-				atomic_read(&reg->hr_steady_iterations) == 0);
+				atomic_read(&reg->hr_steady_iterations) == 0 ||
+				reg->hr_node_deleted);
 	if (ret) {
 		atomic_set(&reg->hr_steady_iterations, 0);
 		reg->hr_aborted_start = 1;
@@ -1840,6 +1848,11 @@ static ssize_t o2hb_region_dev_write(struct o2hb_region *reg,
 		goto out3;
 	}

+	if (reg->hr_node_deleted) {
+		ret = -EINVAL;
+		goto out3;
+	}
+
 	/* Ok, we were woken.  Make sure it wasn't by drop_item() */
 	spin_lock(&o2hb_live_lock);
 	hb_task = reg->hr_task;
-- 
1.8.4.3
