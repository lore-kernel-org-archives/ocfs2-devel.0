From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Tue, 14 Sep 2010 15:50:41 -0700
Subject: [Ocfs2-devel] [PATCH 05/20] ocfs2/cluster: Get all heartbeat regions
In-Reply-To: <1284504656-2434-1-git-send-email-sunil.mushran@oracle.com>
References: <1284504656-2434-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1284504656-2434-6-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Export function in o2hb to get a list of heartbeat regions. It also adds an
upper limit to the length of the heartbeat region name.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/cluster/heartbeat.c |   34 ++++++++++++++++++++++++++++++++++
 fs/ocfs2/cluster/heartbeat.h |    4 ++++
 2 files changed, 38 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index 57cc715..cec9d4c 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -1623,6 +1623,9 @@ static struct config_item *o2hb_heartbeat_group_make_item(struct config_group *g
 	if (reg == NULL)
 		return ERR_PTR(-ENOMEM);
 
+	if (strlen(name) > O2HB_MAX_REGION_NAME_LEN)
+		return ERR_PTR(-ENAMETOOLONG);
+
 	config_item_init_type_name(&reg->hr_item, name, &o2hb_region_type);
 
 	spin_lock(&o2hb_live_lock);
@@ -2033,3 +2036,34 @@ void o2hb_stop_all_regions(void)
 	spin_unlock(&o2hb_live_lock);
 }
 EXPORT_SYMBOL_GPL(o2hb_stop_all_regions);
+
+int o2hb_get_all_regions(char *region_uuids, u8 max_regions)
+{
+	struct o2hb_region *reg;
+	int numregs = 0;
+	char *p;
+
+	spin_lock(&o2hb_live_lock);
+
+	p = region_uuids;
+	list_for_each_entry(reg, &o2hb_all_regions, hr_all_item) {
+		mlog(0, "Region: %s\n", config_item_name(&reg->hr_item));
+		if (numregs < max_regions) {
+			memcpy(p, config_item_name(&reg->hr_item),
+			       O2HB_MAX_REGION_NAME_LEN);
+			p += O2HB_MAX_REGION_NAME_LEN;
+		}
+		numregs++;
+	}
+
+	spin_unlock(&o2hb_live_lock);
+
+	return numregs;
+}
+EXPORT_SYMBOL_GPL(o2hb_get_all_regions);
+
+int o2hb_global_heartbeat_active(void)
+{
+	return (o2hb_heartbeat_mode == O2HB_HEARTBEAT_GLOBAL);
+}
+EXPORT_SYMBOL(o2hb_global_heartbeat_active);
diff --git a/fs/ocfs2/cluster/heartbeat.h b/fs/ocfs2/cluster/heartbeat.h
index 2f16492..00ad8e8 100644
--- a/fs/ocfs2/cluster/heartbeat.h
+++ b/fs/ocfs2/cluster/heartbeat.h
@@ -31,6 +31,8 @@
 
 #define O2HB_REGION_TIMEOUT_MS		2000
 
+#define O2HB_MAX_REGION_NAME_LEN	32
+
 /* number of changes to be seen as live */
 #define O2HB_LIVE_THRESHOLD	   2
 /* number of equal samples to be seen as dead */
@@ -81,5 +83,7 @@ int o2hb_check_node_heartbeating(u8 node_num);
 int o2hb_check_node_heartbeating_from_callback(u8 node_num);
 int o2hb_check_local_node_heartbeating(void);
 void o2hb_stop_all_regions(void);
+int o2hb_get_all_regions(char *region_uuids, u8 numregions);
+int o2hb_global_heartbeat_active(void);
 
 #endif /* O2CLUSTER_HEARTBEAT_H */
-- 
1.7.0.4
