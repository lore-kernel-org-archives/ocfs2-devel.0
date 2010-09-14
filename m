From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Tue, 14 Sep 2010 15:50:52 -0700
Subject: [Ocfs2-devel] [PATCH 16/20] ocfs2/cluster: Maintain bitmap of
	failed regions
In-Reply-To: <1284504656-2434-1-git-send-email-sunil.mushran@oracle.com>
References: <1284504656-2434-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1284504656-2434-17-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In global heartbeat mode, we track the bitmap of regions that have seen
heartbeat timeouts. We fence if the number of such regions is greater than
or equal to half the number of quorum regions.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/cluster/heartbeat.c |   41 +++++++++++++++++++++++++++++++++++++++++
 1 files changed, 41 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index 5e8e1ae..6be817b 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -68,10 +68,12 @@ static DECLARE_WAIT_QUEUE_HEAD(o2hb_steady_queue);
  * 	- o2hb_live_region_bitmap tracks live regions (seen steady iterations).
  * 	- o2hb_quorum_region_bitmap tracks live regions that have seen all nodes
  * 		heartbeat on it.
+ * 	- o2hb_failed_region_bitmap tracks the regions that have seen io timeouts.
  */
 static unsigned long o2hb_region_bitmap[BITS_TO_LONGS(O2NM_MAX_REGIONS)];
 static unsigned long o2hb_live_region_bitmap[BITS_TO_LONGS(O2NM_MAX_REGIONS)];
 static unsigned long o2hb_quorum_region_bitmap[BITS_TO_LONGS(O2NM_MAX_REGIONS)];
+static unsigned long o2hb_failed_region_bitmap[BITS_TO_LONGS(O2NM_MAX_REGIONS)];
 
 #define O2HB_DB_TYPE_LIVENODES		0
 struct o2hb_debug_buf {
@@ -217,8 +219,19 @@ struct o2hb_bio_wait_ctxt {
 	int               wc_error;
 };
 
+static int o2hb_pop_count(void *map, int count)
+{
+	int i = -1, pop = 0;
+
+	while((i = find_next_bit(map, count, i + 1)) < count)
+		pop++;
+	return pop;
+}
+
 static void o2hb_write_timeout(struct work_struct *work)
 {
+	int failed, quorum;
+	unsigned long flags;
 	struct o2hb_region *reg =
 		container_of(work, struct o2hb_region,
 			     hr_write_timeout_work.work);
@@ -226,6 +239,28 @@ static void o2hb_write_timeout(struct work_struct *work)
 	mlog(ML_ERROR, "Heartbeat write timeout to device %s after %u "
 	     "milliseconds\n", reg->hr_dev_name,
 	     jiffies_to_msecs(jiffies - reg->hr_last_timeout_start));
+
+	if (o2hb_global_heartbeat_active()) {
+		spin_lock_irqsave(&o2hb_live_lock, flags);
+		if (test_bit(reg->hr_region_num, o2hb_quorum_region_bitmap))
+			set_bit(reg->hr_region_num, o2hb_failed_region_bitmap);
+		failed = o2hb_pop_count(&o2hb_failed_region_bitmap,
+					O2NM_MAX_REGIONS);
+		quorum = o2hb_pop_count(&o2hb_quorum_region_bitmap,
+					O2NM_MAX_REGIONS);
+		spin_unlock_irqrestore(&o2hb_live_lock, flags);
+
+		printk(KERN_NOTICE "Number of regions %d, failed regions %d\n",
+		       quorum, failed);
+
+		/*
+		 * Fence if the number of failed regions >= half the number
+		 * of  quorum regions
+		 */
+		if ((failed << 1) < quorum)
+			return;
+	}
+
 	o2quo_disk_timeout();
 }
 
@@ -234,6 +269,11 @@ static void o2hb_arm_write_timeout(struct o2hb_region *reg)
 	mlog(ML_HEARTBEAT, "Queue write timeout for %u ms\n",
 	     O2HB_MAX_WRITE_TIMEOUT_MS);
 
+	if (o2hb_global_heartbeat_active()) {
+		spin_lock(&o2hb_live_lock);
+		clear_bit(reg->hr_region_num, o2hb_failed_region_bitmap);
+		spin_unlock(&o2hb_live_lock);
+	}
 	cancel_delayed_work(&reg->hr_write_timeout_work);
 	reg->hr_last_timeout_start = jiffies;
 	schedule_delayed_work(&reg->hr_write_timeout_work,
@@ -1173,6 +1213,7 @@ int o2hb_init(void)
 	memset(o2hb_region_bitmap, 0, sizeof(o2hb_region_bitmap));
 	memset(o2hb_live_region_bitmap, 0, sizeof(o2hb_live_region_bitmap));
 	memset(o2hb_quorum_region_bitmap, 0, sizeof(o2hb_quorum_region_bitmap));
+	memset(o2hb_failed_region_bitmap, 0, sizeof(o2hb_failed_region_bitmap));
 
 	return o2hb_debug_init();
 }
-- 
1.7.0.4
