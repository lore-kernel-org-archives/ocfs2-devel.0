From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Tue, 14 Sep 2010 15:50:50 -0700
Subject: [Ocfs2-devel] [PATCH 14/20] ocfs2/cluster: Track bitmap of live
	heartbeat regions
In-Reply-To: <1284504656-2434-1-git-send-email-sunil.mushran@oracle.com>
References: <1284504656-2434-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1284504656-2434-15-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

A heartbeat region becomes live (or active) after a fixed number of (steady)
iterations.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/cluster/heartbeat.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index 57c906b..9339c82 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -65,8 +65,10 @@ static DECLARE_WAIT_QUEUE_HEAD(o2hb_steady_queue);
 /*
  * In global heartbeat, we maintain a series of region bitmaps.
  * 	- o2hb_region_bitmap allows us to limit the region number to max region.
+ * 	- o2hb_live_region_bitmap tracks live regions (seen steady iterations).
  */
 static unsigned long o2hb_region_bitmap[BITS_TO_LONGS(O2NM_MAX_REGIONS)];
+static unsigned long o2hb_live_region_bitmap[BITS_TO_LONGS(O2NM_MAX_REGIONS)];
 
 #define O2HB_DB_TYPE_LIVENODES		0
 struct o2hb_debug_buf {
@@ -1135,6 +1137,7 @@ int o2hb_init(void)
 
 	memset(o2hb_live_node_bitmap, 0, sizeof(o2hb_live_node_bitmap));
 	memset(o2hb_region_bitmap, 0, sizeof(o2hb_region_bitmap));
+	memset(o2hb_live_region_bitmap, 0, sizeof(o2hb_live_region_bitmap));
 
 	return o2hb_debug_init();
 }
@@ -1563,6 +1566,8 @@ static ssize_t o2hb_region_dev_write(struct o2hb_region *reg,
 	/* Ok, we were woken.  Make sure it wasn't by drop_item() */
 	spin_lock(&o2hb_live_lock);
 	hb_task = reg->hr_task;
+	if (o2hb_global_heartbeat_active())
+		set_bit(reg->hr_region_num, o2hb_live_region_bitmap);
 	spin_unlock(&o2hb_live_lock);
 
 	if (hb_task)
@@ -1751,8 +1756,10 @@ static void o2hb_heartbeat_group_drop_item(struct config_group *group,
 
 	/* stop the thread when the user removes the region dir */
 	spin_lock(&o2hb_live_lock);
-	if (o2hb_global_heartbeat_active())
+	if (o2hb_global_heartbeat_active()) {
 		clear_bit(reg->hr_region_num, o2hb_region_bitmap);
+		clear_bit(reg->hr_region_num, o2hb_live_region_bitmap);
+	}
 	hb_task = reg->hr_task;
 	reg->hr_task = NULL;
 	spin_unlock(&o2hb_live_lock);
-- 
1.7.0.4
