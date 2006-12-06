From: Zhen Wei <zwei@novell.com>
Date: Wed Dec  6 18:57:22 2006
Subject: [Ocfs2-devel] [patch 1/2]OCFS2: allow the ocfs2 heartbeat thread to
	prioritize I/O
Message-ID: <457818DB0200000400262C00@lucius.provo.novell.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Zhen Wei <zwei@novell.com>
Subject: allow the ocfs2 heartbeat thread to prioritize I/O
Patch-mainline: 2.6.19

The patch allows the ocfs2 heartbeat thread to prioritize I/O which may
help cut down on spurious fencing. Most of this will be in the tools -
we can have a pid configfs attribute and let userspace (ocfs2_hb_ctl)
calls the ioprio_set syscall after starting heartbeat, but only cfq
scheduler supports I/O priorities now.

Signed-off-by: Zhen Wei <zwei@novell.com>

zhen wei
zwei@novell.com
+86 10 65339225
Novell, Inc.

-------------- next part --------------
diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index 305cba3..8b8ce0f 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -1445,6 +1445,15 @@ out:
 	return ret;
 }
 
+static ssize_t o2hb_region_pid_read(struct o2hb_region *reg,
+                                      char *page)
+{
+	if (!reg->hr_task)
+		return 0;
+
+	return sprintf(page, "%u\n", reg->hr_task->pid);
+}
+
 struct o2hb_region_attribute {
 	struct configfs_attribute attr;
 	ssize_t (*show)(struct o2hb_region *, char *);
@@ -1483,11 +1492,19 @@ static struct o2hb_region_attribute o2hb
 	.store	= o2hb_region_dev_write,
 };
 
+static struct o2hb_region_attribute o2hb_region_attr_pid = {
+       .attr   = { .ca_owner = THIS_MODULE,
+                   .ca_name = "pid",
+                   .ca_mode = S_IRUGO | S_IRUSR },
+       .show   = o2hb_region_pid_read,
+};
+
 static struct configfs_attribute *o2hb_region_attrs[] = {
 	&o2hb_region_attr_block_bytes.attr,
 	&o2hb_region_attr_start_block.attr,
 	&o2hb_region_attr_blocks.attr,
 	&o2hb_region_attr_dev.attr,
+	&o2hb_region_attr_pid.attr,
 	NULL,
 };
 
