From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Tue, 14 Sep 2010 15:50:37 -0700
Subject: [Ocfs2-devel] [PATCH 01/20] ocfs2/cluster: Add heartbeat mode
	configfs parameter
In-Reply-To: <1284504656-2434-1-git-send-email-sunil.mushran@oracle.com>
References: <1284504656-2434-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1284504656-2434-2-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Add heartbeat mode parameter to the configfs tree. This will be used
to set/show the heartbeat mode. The user is free to toggle the mode
between local and global as long as there is no active heartbeat region.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/cluster/heartbeat.c |   70 ++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 70 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index 41d5f1f..57cc715 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -77,7 +77,19 @@ static struct o2hb_callback *hbcall_from_type(enum o2hb_callback_type type);
 
 #define O2HB_DEFAULT_BLOCK_BITS       9
 
+enum o2hb_heartbeat_modes {
+	O2HB_HEARTBEAT_LOCAL		= 0,
+	O2HB_HEARTBEAT_GLOBAL,
+	O2HB_HEARTBEAT_NUM_MODES,
+};
+
+char *o2hb_heartbeat_mode_desc[O2HB_HEARTBEAT_NUM_MODES] = {
+		"local",	/* O2HB_HEARTBEAT_LOCAL */
+		"global",	/* O2HB_HEARTBEAT_GLOBAL */
+};
+
 unsigned int o2hb_dead_threshold = O2HB_DEFAULT_DEAD_THRESHOLD;
+unsigned int o2hb_heartbeat_mode = O2HB_HEARTBEAT_LOCAL;
 
 /* Only sets a new threshold if there are no active regions.
  *
@@ -94,6 +106,22 @@ static void o2hb_dead_threshold_set(unsigned int threshold)
 	}
 }
 
+static int o2hb_global_hearbeat_mode_set(unsigned int hb_mode)
+{
+	int ret = -1;
+
+	if (hb_mode < O2HB_HEARTBEAT_NUM_MODES) {
+		spin_lock(&o2hb_live_lock);
+		if (list_empty(&o2hb_all_regions)) {
+			o2hb_heartbeat_mode = hb_mode;
+			ret = 0;
+		}
+		spin_unlock(&o2hb_live_lock);
+	}
+
+	return ret;
+}
+
 struct o2hb_node_event {
 	struct list_head        hn_item;
 	enum o2hb_callback_type hn_event_type;
@@ -1688,6 +1716,39 @@ static ssize_t o2hb_heartbeat_group_threshold_store(struct o2hb_heartbeat_group
 	return count;
 }
 
+static
+ssize_t o2hb_heartbeat_group_mode_show(struct o2hb_heartbeat_group *group,
+				       char *page)
+{
+	return sprintf(page, "%s\n",
+		       o2hb_heartbeat_mode_desc[o2hb_heartbeat_mode]);
+}
+
+static
+ssize_t o2hb_heartbeat_group_mode_store(struct o2hb_heartbeat_group *group,
+					const char *page, size_t count)
+{
+	unsigned int i;
+	int ret;
+	size_t len;
+
+	len = (page[count - 1] == '\n') ? count - 1 : count;
+
+	for (i = 0; i < O2HB_HEARTBEAT_NUM_MODES; ++i) {
+		if (strnicmp(page, o2hb_heartbeat_mode_desc[i], len))
+			continue;
+
+		ret = o2hb_global_hearbeat_mode_set(i);
+		if (!ret)
+			printk(KERN_NOTICE "ocfs2: Heartbeat mode set to %s\n",
+			       o2hb_heartbeat_mode_desc[i]);
+		return count;
+	}
+
+	return -EINVAL;
+
+}
+
 static struct o2hb_heartbeat_group_attribute o2hb_heartbeat_group_attr_threshold = {
 	.attr	= { .ca_owner = THIS_MODULE,
 		    .ca_name = "dead_threshold",
@@ -1696,8 +1757,17 @@ static struct o2hb_heartbeat_group_attribute o2hb_heartbeat_group_attr_threshold
 	.store	= o2hb_heartbeat_group_threshold_store,
 };
 
+static struct o2hb_heartbeat_group_attribute o2hb_heartbeat_group_attr_mode = {
+	.attr   = { .ca_owner = THIS_MODULE,
+		.ca_name = "mode",
+		.ca_mode = S_IRUGO | S_IWUSR },
+	.show   = o2hb_heartbeat_group_mode_show,
+	.store  = o2hb_heartbeat_group_mode_store,
+};
+
 static struct configfs_attribute *o2hb_heartbeat_group_attrs[] = {
 	&o2hb_heartbeat_group_attr_threshold.attr,
+	&o2hb_heartbeat_group_attr_mode.attr,
 	NULL,
 };
 
-- 
1.7.0.4
