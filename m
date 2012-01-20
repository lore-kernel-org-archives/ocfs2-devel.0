From: Akinobu Mita <akinobu.mita@gmail.com>
Date: Fri, 20 Jan 2012 15:15:26 -0000
Subject: [Ocfs2-devel] [PATCH] ocfs2: use bitmap_weight()
In-Reply-To: <1327072528-8479-1-git-send-email-akinobu.mita@gmail.com>
References: <1327072528-8479-1-git-send-email-akinobu.mita@gmail.com>
Message-ID: <1327072528-8479-3-git-send-email-akinobu.mita@gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>, ocfs2-devel@oss.oracle.com

Use bitmap_weight instead of reinventing the wheel.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: ocfs2-devel at oss.oracle.com
---
 fs/ocfs2/cluster/heartbeat.c |   22 +++++++---------------
 1 files changed, 7 insertions(+), 15 deletions(-)

diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index 120fad9..7542566 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -35,6 +35,7 @@
 #include <linux/time.h>
 #include <linux/debugfs.h>
 #include <linux/slab.h>
+#include <linux/bitmap.h>
 
 #include "heartbeat.h"
 #include "tcp.h"
@@ -282,15 +283,6 @@ struct o2hb_bio_wait_ctxt {
 	int               wc_error;
 };
 
-static int o2hb_pop_count(void *map, int count)
-{
-	int i = -1, pop = 0;
-
-	while ((i = find_next_bit(map, count, i + 1)) < count)
-		pop++;
-	return pop;
-}
-
 static void o2hb_write_timeout(struct work_struct *work)
 {
 	int failed, quorum;
@@ -307,9 +299,9 @@ static void o2hb_write_timeout(struct work_struct *work)
 		spin_lock_irqsave(&o2hb_live_lock, flags);
 		if (test_bit(reg->hr_region_num, o2hb_quorum_region_bitmap))
 			set_bit(reg->hr_region_num, o2hb_failed_region_bitmap);
-		failed = o2hb_pop_count(&o2hb_failed_region_bitmap,
+		failed = bitmap_weight(o2hb_failed_region_bitmap,
 					O2NM_MAX_REGIONS);
-		quorum = o2hb_pop_count(&o2hb_quorum_region_bitmap,
+		quorum = bitmap_weight(o2hb_quorum_region_bitmap,
 					O2NM_MAX_REGIONS);
 		spin_unlock_irqrestore(&o2hb_live_lock, flags);
 
@@ -771,7 +763,7 @@ static void o2hb_set_quorum_device(struct o2hb_region *reg)
 	 * If global heartbeat active, unpin all regions if the
 	 * region count > CUT_OFF
 	 */
-	if (o2hb_pop_count(&o2hb_quorum_region_bitmap,
+	if (bitmap_weight(o2hb_quorum_region_bitmap,
 			   O2NM_MAX_REGIONS) > O2HB_PIN_CUT_OFF)
 		o2hb_region_unpin(NULL);
 unlock:
@@ -1813,7 +1805,7 @@ static ssize_t o2hb_region_dev_write(struct o2hb_region *reg,
 	live_threshold = O2HB_LIVE_THRESHOLD;
 	if (o2hb_global_heartbeat_active()) {
 		spin_lock(&o2hb_live_lock);
-		if (o2hb_pop_count(&o2hb_region_bitmap, O2NM_MAX_REGIONS) == 1)
+		if (bitmap_weight(o2hb_region_bitmap, O2NM_MAX_REGIONS) == 1)
 			live_threshold <<= 1;
 		spin_unlock(&o2hb_live_lock);
 	}
@@ -2164,7 +2156,7 @@ static void o2hb_heartbeat_group_drop_item(struct config_group *group,
 	if (!o2hb_dependent_users)
 		goto unlock;
 
-	if (o2hb_pop_count(&o2hb_quorum_region_bitmap,
+	if (bitmap_weight(o2hb_quorum_region_bitmap,
 			   O2NM_MAX_REGIONS) <= O2HB_PIN_CUT_OFF)
 		o2hb_region_pin(NULL);
 
@@ -2458,7 +2450,7 @@ static int o2hb_region_inc_user(const char *region_uuid)
 	if (o2hb_dependent_users > 1)
 		goto unlock;
 
-	if (o2hb_pop_count(&o2hb_quorum_region_bitmap,
+	if (bitmap_weight(o2hb_quorum_region_bitmap,
 			   O2NM_MAX_REGIONS) <= O2HB_PIN_CUT_OFF)
 		ret = o2hb_region_pin(NULL);
 
-- 
1.7.4.4
