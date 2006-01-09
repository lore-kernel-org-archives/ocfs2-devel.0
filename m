From: Jeff Mahoney <jeffm@suse.com>
Date: Mon, 9 Jan 2006 17:39:43 -0500
Subject: [Ocfs2-devel] [PATCH 10/11] ocfs2: add the ability to switch
	between heartbeat group modes
Message-ID: <20060109223943.GA8836@locomotive.unixthugs.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


 This patch allows the user to switch heartbeat modes by writing the desired
 mode into /sys/o2cb/heartbeat_mode.

 The mode cannot be switched when another is in use. This means that
 <configfs>/cluster/ must be empty.

 fs/ocfs2/cluster/heartbeat.h |    3 +++
 fs/ocfs2/cluster/sys.c       |   15 +++++++++++++++
 2 files changed, 18 insertions(+)

Signed-off-by: Jeff Mahoney <jeffm@suse.com>

diff -ruNpX dontdiff linux-2.6.15-staging1/fs/ocfs2/cluster/heartbeat.h linux-2.6.15-staging2/fs/ocfs2/cluster/heartbeat.h
--- linux-2.6.15-staging1/fs/ocfs2/cluster/heartbeat.h	2006-01-08 20:11:12.799132416 -0500
+++ linux-2.6.15-staging2/fs/ocfs2/cluster/heartbeat.h	2006-01-08 20:05:01.787534752 -0500
@@ -110,6 +110,9 @@ int o2hb_check_local_node_heartbeating(c
 void o2hb_notify(enum o2hb_callback_type type, struct o2nm_node *node,
                  int node_num);
 
+const char *o2hb_heartbeat_mode(void);
+int o2hb_set_heartbeat_mode(const char *type, size_t count);
+
 struct o2hb_heartbeat_resource *o2hb_heartbeat_resource_get_by_name(const char * name);
 
 static inline struct o2hb_heartbeat_group *to_o2hb_heartbeat_group(struct config_group *group)
diff -ruNpX dontdiff linux-2.6.15-staging1/fs/ocfs2/cluster/sys.c linux-2.6.15-staging2/fs/ocfs2/cluster/sys.c
--- linux-2.6.15-staging1/fs/ocfs2/cluster/sys.c	2006-01-08 19:23:29.343443848 -0500
+++ linux-2.6.15-staging2/fs/ocfs2/cluster/sys.c	2006-01-08 19:52:16.793831472 -0500
@@ -29,6 +29,7 @@
 #include <linux/kobject.h>
 #include <linux/sysfs.h>
 
+#include "heartbeat.h"
 #include "ocfs2_nodemanager.h"
 #include "masklog.h"
 #include "sys.h"
@@ -52,8 +53,22 @@ static ssize_t o2cb_interface_revision_s
 
 static O2CB_ATTR(interface_revision, S_IFREG | S_IRUGO, o2cb_interface_revision_show, NULL);
 
+static ssize_t o2cb_heartbeat_mode_show(char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "%s\n", o2hb_heartbeat_mode());
+}
+
+static ssize_t o2cb_heartbeat_mode_store(const char * buffer, size_t count)
+{
+	return o2hb_set_heartbeat_mode(buffer, count);
+}
+
+static O2CB_ATTR(heartbeat_mode, S_IFREG | S_IRUGO | S_IWUSR,
+                 o2cb_heartbeat_mode_show, o2cb_heartbeat_mode_store);
+
 static struct attribute *o2cb_attrs[] = {
 	&o2cb_attr_interface_revision.attr,
+	&o2cb_attr_heartbeat_mode.attr,
 	NULL,
 };
 
