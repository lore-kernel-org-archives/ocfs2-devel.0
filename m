From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Tue, 14 Sep 2010 15:50:49 -0700
Subject: [Ocfs2-devel] [PATCH 13/20] ocfs2/cluster: Track number of global
	heartbeat regions
In-Reply-To: <1284504656-2434-1-git-send-email-sunil.mushran@oracle.com>
References: <1284504656-2434-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1284504656-2434-14-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In global heartbeat mode, we have a upper limit for the number of active regions.
This patch adds the facility to track the number of active global heartbeat
regions and fails to start heartbeat if the number exceeds the maximum.

Signed-of-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/cluster/heartbeat.c |   24 ++++++++++++++++++++++--
 1 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index 29b5c70..57c906b 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -62,6 +62,12 @@ static unsigned long o2hb_live_node_bitmap[BITS_TO_LONGS(O2NM_MAX_NODES)];
 static LIST_HEAD(o2hb_node_events);
 static DECLARE_WAIT_QUEUE_HEAD(o2hb_steady_queue);
 
+/*
+ * In global heartbeat, we maintain a series of region bitmaps.
+ * 	- o2hb_region_bitmap allows us to limit the region number to max region.
+ */
+static unsigned long o2hb_region_bitmap[BITS_TO_LONGS(O2NM_MAX_REGIONS)];
+
 #define O2HB_DB_TYPE_LIVENODES		0
 struct o2hb_debug_buf {
 	int db_type;
@@ -176,6 +182,7 @@ struct o2hb_region {
 
 	/* live node map of this region */
 	unsigned long		hr_live_node_bitmap[BITS_TO_LONGS(O2NM_MAX_NODES)];
+	unsigned int		hr_region_num;
 
 	/* let the person setting up hb wait for it to return until it
 	 * has reached a 'steady' state.  This will be fixed when we have
@@ -1127,6 +1134,7 @@ int o2hb_init(void)
 	INIT_LIST_HEAD(&o2hb_node_events);
 
 	memset(o2hb_live_node_bitmap, 0, sizeof(o2hb_live_node_bitmap));
+	memset(o2hb_region_bitmap, 0, sizeof(o2hb_region_bitmap));
 
 	return o2hb_debug_init();
 }
@@ -1716,12 +1724,22 @@ static struct config_item *o2hb_heartbeat_group_make_item(struct config_group *g
 	if (strlen(name) > O2HB_MAX_REGION_NAME_LEN)
 		return ERR_PTR(-ENAMETOOLONG);
 
-	config_item_init_type_name(&reg->hr_item, name, &o2hb_region_type);
-
 	spin_lock(&o2hb_live_lock);
+	reg->hr_region_num = 0;
+	if (o2hb_global_heartbeat_active()) {
+		reg->hr_region_num = find_first_zero_bit(o2hb_region_bitmap,
+							 O2NM_MAX_REGIONS);
+		if (reg->hr_region_num >= O2NM_MAX_REGIONS) {
+			spin_unlock(&o2hb_live_lock);
+			return ERR_PTR(-EFBIG);
+		}
+		set_bit(reg->hr_region_num, o2hb_region_bitmap);
+	}
 	list_add_tail(&reg->hr_all_item, &o2hb_all_regions);
 	spin_unlock(&o2hb_live_lock);
 
+	config_item_init_type_name(&reg->hr_item, name, &o2hb_region_type);
+
 	return &reg->hr_item;
 }
 
@@ -1733,6 +1751,8 @@ static void o2hb_heartbeat_group_drop_item(struct config_group *group,
 
 	/* stop the thread when the user removes the region dir */
 	spin_lock(&o2hb_live_lock);
+	if (o2hb_global_heartbeat_active())
+		clear_bit(reg->hr_region_num, o2hb_region_bitmap);
 	hb_task = reg->hr_task;
 	reg->hr_task = NULL;
 	spin_unlock(&o2hb_live_lock);
-- 
1.7.0.4
