From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Date: Fri, 17 Jul 2015 18:27:09 +0200
Subject: [Ocfs2-devel] [PATCH] ocfs2: Do not log twice error messages
Message-ID: <1437150429-26443-1-git-send-email-christophe.jaillet@wanadoo.fr>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: mfasheh@suse.com, jlbec@evilplan.org
Cc: ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org, Christophe JAILLET <christophe.jaillet@wanadoo.fr>

'o2hb_map_slot_data' and 'o2hb_populate_slot_data' are called from
only one place, in 'o2hb_region_dev_write'.
Return value is checked and 'mlog_errno' is called to log a message if
it is not 0.
So, there is no need to call 'mlog_errno' directly within these functions.
This would result on logging the message twice.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 fs/ocfs2/cluster/heartbeat.c | 20 +++++---------------
 1 file changed, 5 insertions(+), 15 deletions(-)

diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index 79f335d..a20d490 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -1583,17 +1583,13 @@ static int o2hb_map_slot_data(struct o2hb_region *reg)
 	struct o2hb_disk_slot *slot;
 
 	reg->hr_tmp_block = kmalloc(reg->hr_block_bytes, GFP_KERNEL);
-	if (reg->hr_tmp_block == NULL) {
-		mlog_errno(-ENOMEM);
+	if (reg->hr_tmp_block == NULL)
 		return -ENOMEM;
-	}
 
 	reg->hr_slots = kcalloc(reg->hr_blocks,
 				sizeof(struct o2hb_disk_slot), GFP_KERNEL);
-	if (reg->hr_slots == NULL) {
-		mlog_errno(-ENOMEM);
+	if (reg->hr_slots == NULL)
 		return -ENOMEM;
-	}
 
 	for(i = 0; i < reg->hr_blocks; i++) {
 		slot = &reg->hr_slots[i];
@@ -1609,17 +1605,13 @@ static int o2hb_map_slot_data(struct o2hb_region *reg)
 
 	reg->hr_slot_data = kcalloc(reg->hr_num_pages, sizeof(struct page *),
 				    GFP_KERNEL);
-	if (!reg->hr_slot_data) {
-		mlog_errno(-ENOMEM);
+	if (!reg->hr_slot_data)
 		return -ENOMEM;
-	}
 
 	for(i = 0; i < reg->hr_num_pages; i++) {
 		page = alloc_page(GFP_KERNEL);
-		if (!page) {
-			mlog_errno(-ENOMEM);
+		if (!page)
 			return -ENOMEM;
-		}
 
 		reg->hr_slot_data[i] = page;
 
@@ -1651,10 +1643,8 @@ static int o2hb_populate_slot_data(struct o2hb_region *reg)
 	struct o2hb_disk_heartbeat_block *hb_block;
 
 	ret = o2hb_read_slots(reg, reg->hr_blocks);
-	if (ret) {
-		mlog_errno(ret);
+	if (ret)
 		goto out;
-	}
 
 	/* We only want to get an idea of the values initially in each
 	 * slot, so we do no verification - o2hb_check_slot will
-- 
2.1.4
