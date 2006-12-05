From: Zhen Wei <zwei@novell.com>
Date: Tue Dec  5 05:48:48 2006
Subject: [Ocfs2-devel] [patch 1/1]OCFS2: allow the ocfs2 heartbeat thread to
	prioritize I/O
Message-ID: <4576135A02000004002629E9@lucius.provo.novell.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Zhen Wei <zwei@novell.com>
Subject: allow the ocfs2 heartbeat thread to prioritize I/O
Patch-mainline: 2.6.19

To prioritize ocfs2 heartbeat thread I/O may help cut down on spurious
fencing, 
so the patch sets the heartbeat thread to real time I/O priority after
thread starting,
user also can change the I/O priorities via configfs without knowing the
thread pid, 
but only cfq scheduler supports I/O priorities now.

Signed-off-by: Zhen Wei <zwei@novell.com>

zhen wei
zwei@novell.com
+86 10 65339225
Novell, Inc.

-------------- next part --------------
From: Zhen Wei <zwei@novell.com>
Subject: allow the ocfs2 heartbeat thread to prioritize I/O
Patch-mainline: 2.6.19

    To prioritize ocfs2 heartbeat thread I/O may help cut down on spurious fencing,
    so the patch set the heartbeat thread to real time I/O level after thread starting,
    user also can change the I/O priorities via configfs without knowing the thread
    pid, but only cfq scheduler supports I/O priorities now.

Signed-off-by: Zhen Wei <zwei@novell.com>

diff --git a/fs/ioprio.c b/fs/ioprio.c
index 89e8da1..ce8a7c0 100644
--- a/fs/ioprio.c
+++ b/fs/ioprio.c
@@ -26,7 +26,7 @@
 #include <linux/syscalls.h>
 #include <linux/security.h>
 
-static int set_task_ioprio(struct task_struct *task, int ioprio)
+int set_task_ioprio(struct task_struct *task, int ioprio)
 {
 	int err;
 	struct io_context *ioc;
@@ -225,3 +225,4 @@ asmlinkage long sys_ioprio_get(int which
 	return ret;
 }
 
+EXPORT_SYMBOL_GPL(set_task_ioprio);
diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index 305cba3..3f0944d 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -33,6 +33,7 @@
 #include <linux/random.h>
 #include <linux/crc32.h>
 #include <linux/time.h>
+#include <linux/ioprio.h>
 
 #include "heartbeat.h"
 #include "tcp.h"
@@ -137,6 +138,8 @@ struct o2hb_region {
 
 	unsigned int		hr_timeout_ms;
 
+	unsigned int		hr_io_prio;
+
 	/* randomized as the region goes up and down so that a node
 	 * recognizes a node going up and down in one iteration */
 	u64			hr_generation;
@@ -1206,16 +1209,50 @@ static ssize_t o2hb_region_dev_read(stru
 	return ret;
 }
 
+static ssize_t o2hb_region_io_prio_read(struct o2hb_region *reg,
+				       char *page)
+{
+	return sprintf(page, "%d\n", reg->hr_io_prio);
+}
+
+static ssize_t o2hb_region_io_prio_write(struct o2hb_region *reg,
+					const char *page,
+					size_t count)
+{
+	int prio, ret;
+	char *p = (char*)page;
+
+	prio = simple_strtol(p, &p, 0);
+	if (!p || (*p && (*p != '\n')))
+		return -EINVAL;
+
+	if (prio < IOPRIO_CLASS_NONE || prio > IOPRIO_CLASS_IDLE)
+		return -ERANGE;
+
+	if (!reg->hr_task)
+		return -EINVAL;
+
+	ret = set_task_ioprio (reg->hr_task, prio);
+	if (ret != 0)
+		mlog (ML_ERROR, "set_task_ioprio failed, return %d\n", ret);
+	else
+		reg->hr_io_prio = prio;
+
+	return count;
+}
+
 static void o2hb_init_region_params(struct o2hb_region *reg)
 {
 	reg->hr_slots_per_page = PAGE_CACHE_SIZE >> reg->hr_block_bits;
 	reg->hr_timeout_ms = O2HB_REGION_TIMEOUT_MS;
+	reg->hr_io_prio = IOPRIO_CLASS_RT;
 
 	mlog(ML_HEARTBEAT, "hr_start_block = %llu, hr_blocks = %u\n",
 	     reg->hr_start_block, reg->hr_blocks);
 	mlog(ML_HEARTBEAT, "hr_block_bytes = %u, hr_block_bits = %u\n",
 	     reg->hr_block_bytes, reg->hr_block_bits);
 	mlog(ML_HEARTBEAT, "hr_timeout_ms = %u\n", reg->hr_timeout_ms);
+	mlog(ML_HEARTBEAT, "hr_io_prio = %u\n", reg->hr_io_prio);
 	mlog(ML_HEARTBEAT, "dead threshold = %u\n", o2hb_dead_threshold);
 }
 
@@ -1422,6 +1459,12 @@ static ssize_t o2hb_region_dev_write(str
 		goto out;
 	}
 
+	ret = set_task_ioprio (reg->hr_task, reg->hr_io_prio);
+	if (ret != 0) {
+		reg->hr_io_prio = IOPRIO_CLASS_NONE;
+		mlog (ML_ERROR, "set_task_ioprio failed, return %d\n", ret);
+	}
+
 	ret = wait_event_interruptible(o2hb_steady_queue,
 				atomic_read(&reg->hr_steady_iterations) == 0);
 	if (ret) {
@@ -1483,11 +1526,20 @@ static struct o2hb_region_attribute o2hb
 	.store	= o2hb_region_dev_write,
 };
 
+static struct o2hb_region_attribute o2hb_region_attr_io_prio = {
+	.attr	= { .ca_owner = THIS_MODULE,
+		    .ca_name = "io_prio",
+		    .ca_mode = S_IRUGO | S_IWUSR },
+	.show	= o2hb_region_io_prio_read,
+	.store	= o2hb_region_io_prio_write,
+};
+
 static struct configfs_attribute *o2hb_region_attrs[] = {
 	&o2hb_region_attr_block_bytes.attr,
 	&o2hb_region_attr_start_block.attr,
 	&o2hb_region_attr_blocks.attr,
 	&o2hb_region_attr_dev.attr,
+	&o2hb_region_attr_io_prio.attr,
 	NULL,
 };
 
diff --git a/include/linux/ioprio.h b/include/linux/ioprio.h
index 8e2042b..3474fcd 100644
--- a/include/linux/ioprio.h
+++ b/include/linux/ioprio.h
@@ -61,4 +61,5 @@ static inline int task_nice_ioprio(struc
  */
 extern int ioprio_best(unsigned short aprio, unsigned short bprio);
 
+extern int set_task_ioprio(struct task_struct *task, int ioprio);
 #endif
