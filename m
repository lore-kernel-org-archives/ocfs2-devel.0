From: Srinivas Eeda <srinivas.eeda@oracle.com>
Date: Tue,  2 Nov 2010 13:17:59 -0700
Subject: [Ocfs2-devel] [PATCH 1/2] ocfs2/cluster: Create debugfs dir for
	heartbeat regions
In-Reply-To: <1288729080-1962-1-git-send-email-srinivas.eeda@oracle.com>
References: <1288729080-1962-1-git-send-email-srinivas.eeda@oracle.com>
Message-ID: <1288729080-1962-2-git-send-email-srinivas.eeda@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Sunil Mushran <sunil.mushran@oracle.com>

Mainline 0841ed580fe8a3e51ba9dbb133dafc787cce428f
Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/cluster/heartbeat.c |   27 +++++++++++++++++++--------
 1 files changed, 19 insertions(+), 8 deletions(-)

diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index 55e8718..8580e66 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -134,6 +134,8 @@ struct o2hb_region {
 	struct block_device	*hr_bdev;
 	struct o2hb_disk_slot	*hr_slots;
 
+	struct dentry		*hr_debug_dir;
+
 	/* let the person setting up hb wait for it to return until it
 	 * has reached a 'steady' state.  This will be fixed when we have
 	 * a more complete api that doesn't lead to this sort of fragility. */
@@ -1085,6 +1087,8 @@ static void o2hb_region_release(struct config_item *item)
 	if (reg->hr_slots)
 		kfree(reg->hr_slots);
 
+	debugfs_remove(reg->hr_debug_dir);
+
 	spin_lock(&o2hb_live_lock);
 	list_del(&reg->hr_all_item);
 	spin_unlock(&o2hb_live_lock);
@@ -1597,24 +1601,31 @@ static struct config_item *o2hb_heartbeat_group_make_item(struct config_group *g
 							  const char *name)
 {
 	struct o2hb_region *reg = NULL;
-	struct config_item *ret = NULL;
 
 	reg = kzalloc(sizeof(struct o2hb_region), GFP_KERNEL);
-	if (reg == NULL)
-		goto out; /* ENOMEM */
+	if (reg == NULL) {
+		mlog_errno(-ENOMEM);
+		goto out;
+	}
 
 	config_item_init_type_name(&reg->hr_item, name, &o2hb_region_type);
 
-	ret = &reg->hr_item;
+	reg->hr_debug_dir =
+		debugfs_create_dir(config_item_name(&reg->hr_item), o2hb_debug_dir);
+	if (!reg->hr_debug_dir) {
+		mlog_errno(-ENOMEM);
+		goto out;
+	}
 
 	spin_lock(&o2hb_live_lock);
 	list_add_tail(&reg->hr_all_item, &o2hb_all_regions);
 	spin_unlock(&o2hb_live_lock);
-out:
-	if (ret == NULL)
-		kfree(reg);
 
-	return ret;
+	return &reg->hr_item;
+
+out:
+	kfree(reg);
+	return NULL;
 }
 
 static void o2hb_heartbeat_group_drop_item(struct config_group *group,
-- 
1.5.6.5
