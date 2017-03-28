From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Tue, 28 Mar 2017 09:40:45 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: o2hb: revert hb threshold to keep
	compatible
Message-ID: <1490665245-15374-1-git-send-email-junxiao.bi@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Configfs is the interface for ocfs2-tools to set configure to
kernel. Change heartbeat dead threshold name in configfs will
cause compatible issue, so revert it.

Fixes: 45b997737a80 ("ocfs2/cluster: use per-attribute show and store methods")
Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
---
 fs/ocfs2/cluster/heartbeat.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index f6e871760f8d..0da0332725aa 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -2242,13 +2242,13 @@ static void o2hb_heartbeat_group_drop_item(struct config_group *group,
 	spin_unlock(&o2hb_live_lock);
 }
 
-static ssize_t o2hb_heartbeat_group_threshold_show(struct config_item *item,
+static ssize_t o2hb_heartbeat_group_dead_threshold_show(struct config_item *item,
 		char *page)
 {
 	return sprintf(page, "%u\n", o2hb_dead_threshold);
 }
 
-static ssize_t o2hb_heartbeat_group_threshold_store(struct config_item *item,
+static ssize_t o2hb_heartbeat_group_dead_threshold_store(struct config_item *item,
 		const char *page, size_t count)
 {
 	unsigned long tmp;
@@ -2297,11 +2297,11 @@ static ssize_t o2hb_heartbeat_group_mode_store(struct config_item *item,
 
 }
 
-CONFIGFS_ATTR(o2hb_heartbeat_group_, threshold);
+CONFIGFS_ATTR(o2hb_heartbeat_group_, dead_threshold);
 CONFIGFS_ATTR(o2hb_heartbeat_group_, mode);
 
 static struct configfs_attribute *o2hb_heartbeat_group_attrs[] = {
-	&o2hb_heartbeat_group_attr_threshold,
+	&o2hb_heartbeat_group_attr_dead_threshold,
 	&o2hb_heartbeat_group_attr_mode,
 	NULL,
 };
-- 
1.7.9.5
