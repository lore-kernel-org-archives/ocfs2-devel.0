From: Jeff Liu <jeff.liu@oracle.com>
Date: Sat, 29 Jun 2013 12:01:03 +0800
Subject: [Ocfs2-devel] [RESENT PATCH 2/4] ocfs2: consolidate
 o2hb_global_hearbeat_mode_set() naming convention
Message-ID: <51CE5BFF.7050503@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Jie Liu <jeff.liu@oracle.com>

s/o2hb_global_hearbeat_mode_set/o2hb_global_heartbeat_mode_set/
to make the signature of those routines in a consistent manner
with others for heartbeating.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
Acked-by: Sunil Mushran <sunil.mushran@gmail.com>
---
 fs/ocfs2/cluster/heartbeat.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index f89b46b..956d79d 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -176,7 +176,7 @@ static void o2hb_dead_threshold_set(unsigned int threshold)
 	}
 }
 
-static int o2hb_global_hearbeat_mode_set(unsigned int hb_mode)
+static int o2hb_global_heartbeat_mode_set(unsigned int hb_mode)
 {
 	int ret = -1;
 
@@ -2271,7 +2271,7 @@ ssize_t o2hb_heartbeat_group_mode_store(struct o2hb_heartbeat_group *group,
 		if (strnicmp(page, o2hb_heartbeat_mode_desc[i], len))
 			continue;
 
-		ret = o2hb_global_hearbeat_mode_set(i);
+		ret = o2hb_global_heartbeat_mode_set(i);
 		if (!ret)
 			printk(KERN_NOTICE "o2hb: Heartbeat mode set to %s\n",
 			       o2hb_heartbeat_mode_desc[i]);
@@ -2304,7 +2304,7 @@ static struct configfs_attribute *o2hb_heartbeat_group_attrs[] = {
 	NULL,
 };
 
-static struct configfs_item_operations o2hb_hearbeat_group_item_ops = {
+static struct configfs_item_operations o2hb_heartbeat_group_item_ops = {
 	.show_attribute		= o2hb_heartbeat_group_show,
 	.store_attribute	= o2hb_heartbeat_group_store,
 };
@@ -2316,7 +2316,7 @@ static struct configfs_group_operations o2hb_heartbeat_group_group_ops = {
 
 static struct config_item_type o2hb_heartbeat_group_type = {
 	.ct_group_ops	= &o2hb_heartbeat_group_group_ops,
-	.ct_item_ops	= &o2hb_hearbeat_group_item_ops,
+	.ct_item_ops	= &o2hb_heartbeat_group_item_ops,
 	.ct_attrs	= o2hb_heartbeat_group_attrs,
 	.ct_owner	= THIS_MODULE,
 };
-- 
1.7.9.5
