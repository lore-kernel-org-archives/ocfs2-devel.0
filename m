From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Tue, 14 Dec 2010 14:14:29 -0800
Subject: [Ocfs2-devel] [PATCH 3/5] ocfs2/cluster: Pin/unpin o2hb regions
In-Reply-To: <1292364871-18461-1-git-send-email-sunil.mushran@oracle.com>
References: <1292364871-18461-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1292364871-18461-4-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This patch adds support for pinning o2hb regions in configfs. Pinning disallows
a region to be cleanly stopped as long as it has an active dependent user
(read o2dlm).

In local heartbeat mode, the region uuid matching the domain name is pinned as
long as the o2dlm domain is active.

In global heartbeat mode, all regions are pinned as long as there is atleast
one dependent user and the region count is 3 or less. All regions are unpinned
if the number of dependent users is zero or region count is greater than 3.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/cluster/heartbeat.c |  216 ++++++++++++++++++++++++++++++++++--------
 fs/ocfs2/dlm/dlmdomain.c     |    8 +-
 2 files changed, 182 insertions(+), 42 deletions(-)

diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index 9f21dd7..1f5afa6 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -132,6 +132,33 @@ char *o2hb_heartbeat_mode_desc[O2HB_HEARTBEAT_NUM_MODES] = {
 unsigned int o2hb_dead_threshold = O2HB_DEFAULT_DEAD_THRESHOLD;
 unsigned int o2hb_heartbeat_mode = O2HB_HEARTBEAT_LOCAL;
 
+/*
+ * o2hb_dependent_users tracks the number of registered callbacks that depend
+ * on heartbeat. o2net and o2dlm are two entities that register this callback.
+ * However only o2dlm depends on the heartbeat. It does not want the heartbeat
+ * to stop while a dlm domain is still active.
+ */
+unsigned int o2hb_dependent_users;
+
+/*
+ * In global heartbeat mode, all regions are pinned if there are one or more
+ * dependent users and the quorum region count is <= O2HB_PIN_CUT_OFF. All
+ * regions are unpinned if the region count exceeds the cut off or the number
+ * of dependent users falls to zero.
+ */
+#define O2HB_PIN_CUT_OFF		3
+
+/*
+ * In local heartbeat mode, we assume the dlm domain name to be the same as
+ * region uuid. This is true for domains created for the file system but not
+ * necessarily true for userdlm domains. This is a known limitation.
+ *
+ * In global heartbeat mode, we pin/unpin all o2hb regions. This solution
+ * works for both file system and userdlm domains.
+ */
+static int o2hb_region_pin(const char *region_uuid);
+static void o2hb_region_unpin(const char *region_uuid);
+
 /* Only sets a new threshold if there are no active regions.
  *
  * No locking or otherwise interesting code is required for reading
@@ -186,7 +213,9 @@ struct o2hb_region {
 	struct config_item	hr_item;
 
 	struct list_head	hr_all_item;
-	unsigned		hr_unclean_stop:1;
+	unsigned		hr_unclean_stop:1,
+				hr_item_pinned:1,
+				hr_item_dropped:1;
 
 	/* protected by the hr_callback_sem */
 	struct task_struct 	*hr_task;
@@ -702,6 +731,14 @@ static void o2hb_set_quorum_device(struct o2hb_region *reg,
 	       config_item_name(&reg->hr_item));
 
 	set_bit(reg->hr_region_num, o2hb_quorum_region_bitmap);
+
+	/*
+	 * If global heartbeat active, unpin all regions if the
+	 * region count > CUT_OFF
+	 */
+	if (o2hb_pop_count(&o2hb_quorum_region_bitmap,
+			   O2NM_MAX_REGIONS) > O2HB_PIN_CUT_OFF)
+		o2hb_region_unpin(NULL);
 }
 
 static int o2hb_check_slot(struct o2hb_region *reg,
@@ -1316,6 +1353,8 @@ int o2hb_init(void)
 	memset(o2hb_quorum_region_bitmap, 0, sizeof(o2hb_quorum_region_bitmap));
 	memset(o2hb_failed_region_bitmap, 0, sizeof(o2hb_failed_region_bitmap));
 
+	o2hb_dependent_users = 0;
+
 	return o2hb_debug_init();
 }
 
@@ -2003,16 +2042,20 @@ static void o2hb_heartbeat_group_drop_item(struct config_group *group,
 {
 	struct task_struct *hb_task;
 	struct o2hb_region *reg = to_o2hb_region(item);
+	int quorum_region = 0;
 
 	/* stop the thread when the user removes the region dir */
 	spin_lock(&o2hb_live_lock);
 	if (o2hb_global_heartbeat_active()) {
 		clear_bit(reg->hr_region_num, o2hb_region_bitmap);
 		clear_bit(reg->hr_region_num, o2hb_live_region_bitmap);
+		if (test_bit(reg->hr_region_num, o2hb_quorum_region_bitmap))
+			quorum_region = 1;
 		clear_bit(reg->hr_region_num, o2hb_quorum_region_bitmap);
 	}
 	hb_task = reg->hr_task;
 	reg->hr_task = NULL;
+	reg->hr_item_dropped = 1;
 	spin_unlock(&o2hb_live_lock);
 
 	if (hb_task)
@@ -2030,7 +2073,27 @@ static void o2hb_heartbeat_group_drop_item(struct config_group *group,
 	if (o2hb_global_heartbeat_active())
 		printk(KERN_NOTICE "o2hb: Heartbeat stopped on region %s\n",
 		       config_item_name(&reg->hr_item));
+
 	config_item_put(item);
+
+	if (!o2hb_global_heartbeat_active() || !quorum_region)
+		return;
+
+	/*
+	 * If global heartbeat active and there are dependent users,
+	 * pin all regions if quorum region count <= CUT_OFF
+	 */
+	spin_lock(&o2hb_live_lock);
+
+	if (!o2hb_dependent_users)
+		goto unlock;
+
+	if (o2hb_pop_count(&o2hb_quorum_region_bitmap,
+			   O2NM_MAX_REGIONS) <= O2HB_PIN_CUT_OFF)
+		o2hb_region_pin(NULL);
+
+unlock:
+	spin_unlock(&o2hb_live_lock);
 }
 
 struct o2hb_heartbeat_group_attribute {
@@ -2216,63 +2279,138 @@ void o2hb_setup_callback(struct o2hb_callback_func *hc,
 }
 EXPORT_SYMBOL_GPL(o2hb_setup_callback);
 
-static struct o2hb_region *o2hb_find_region(const char *region_uuid)
+/*
+ * In local heartbeat mode, region_uuid passed matches the dlm domain name.
+ * In global heartbeat mode, region_uuid passed is NULL.
+ *
+ * In local, we only pin the matching region. In global we pin all the active
+ * regions.
+ */
+static int o2hb_region_pin(const char *region_uuid)
 {
-	struct o2hb_region *p, *reg = NULL;
+	int ret = 0, found = 0;
+	struct o2hb_region *reg;
+	char *uuid;
 
 	assert_spin_locked(&o2hb_live_lock);
 
-	list_for_each_entry(p, &o2hb_all_regions, hr_all_item) {
-		if (!strcmp(region_uuid, config_item_name(&p->hr_item))) {
-			reg = p;
-			break;
+	list_for_each_entry(reg, &o2hb_all_regions, hr_all_item) {
+		uuid = config_item_name(&reg->hr_item);
+
+		/* local heartbeat */
+		if (region_uuid) {
+			if (strcmp(region_uuid, uuid))
+				continue;
+			found = 1;
 		}
+
+		if (reg->hr_item_pinned || reg->hr_item_dropped)
+			goto skip_pin;
+
+		/* Ignore ENOENT only for local hb (userdlm domain) */
+		ret = o2nm_depend_item(&reg->hr_item);
+		if (!ret) {
+			mlog(ML_CLUSTER, "Pin region %s\n", uuid);
+			reg->hr_item_pinned = 1;
+		} else {
+			if (ret == -ENOENT && found)
+				ret = 0;
+			else {
+				mlog(ML_ERROR, "Pin region %s fails with %d\n",
+				     uuid, ret);
+				break;
+			}
+		}
+skip_pin:
+		if (found)
+			break;
 	}
 
-	return reg;
+	return ret;
+}
+
+/*
+ * In local heartbeat mode, region_uuid passed matches the dlm domain name.
+ * In global heartbeat mode, region_uuid passed is NULL.
+ *
+ * In local, we only unpin the matching region. In global we unpin all the
+ * active regions.
+ */
+static void o2hb_region_unpin(const char *region_uuid)
+{
+	struct o2hb_region *reg;
+	char *uuid;
+	int found = 0;
+
+	assert_spin_locked(&o2hb_live_lock);
+
+	list_for_each_entry(reg, &o2hb_all_regions, hr_all_item) {
+		uuid = config_item_name(&reg->hr_item);
+		if (region_uuid) {
+			if (strcmp(region_uuid, uuid))
+				continue;
+			found = 1;
+		}
+
+		if (reg->hr_item_pinned) {
+			mlog(ML_CLUSTER, "Unpin region %s\n", uuid);
+			o2nm_undepend_item(&reg->hr_item);
+			reg->hr_item_pinned = 0;
+		}
+		if (found)
+			break;
+	}
 }
 
-static int o2hb_region_get(const char *region_uuid)
+static int o2hb_region_inc_user(const char *region_uuid)
 {
 	int ret = 0;
-	struct o2hb_region *reg;
 
 	spin_lock(&o2hb_live_lock);
 
-	reg = o2hb_find_region(region_uuid);
-	if (!reg)
-		ret = -ENOENT;
-	spin_unlock(&o2hb_live_lock);
-
-	if (ret)
-		goto out;
+	/* local heartbeat */
+	if (!o2hb_global_heartbeat_active()) {
+	    ret = o2hb_region_pin(region_uuid);
+	    goto unlock;
+	}
 
-	ret = o2nm_depend_this_node();
-	if (ret)
-		goto out;
+	/*
+	 * if global heartbeat active and this is the first dependent user,
+	 * pin all regions if quorum region count <= CUT_OFF
+	 */
+	o2hb_dependent_users++;
+	if (o2hb_dependent_users > 1)
+		goto unlock;
 
-	ret = o2nm_depend_item(&reg->hr_item);
-	if (ret)
-		o2nm_undepend_this_node();
+	if (o2hb_pop_count(&o2hb_quorum_region_bitmap,
+			   O2NM_MAX_REGIONS) <= O2HB_PIN_CUT_OFF)
+		ret = o2hb_region_pin(NULL);
 
-out:
+unlock:
+	spin_unlock(&o2hb_live_lock);
 	return ret;
 }
 
-static void o2hb_region_put(const char *region_uuid)
+void o2hb_region_dec_user(const char *region_uuid)
 {
-	struct o2hb_region *reg;
-
 	spin_lock(&o2hb_live_lock);
 
-	reg = o2hb_find_region(region_uuid);
+	/* local heartbeat */
+	if (!o2hb_global_heartbeat_active()) {
+	    o2hb_region_unpin(region_uuid);
+	    goto unlock;
+	}
 
+	/*
+	 * if global heartbeat active and there are no dependent users,
+	 * unpin all quorum regions
+	 */
+	o2hb_dependent_users--;
+	if (!o2hb_dependent_users)
+		o2hb_region_unpin(NULL);
+	
+unlock:
 	spin_unlock(&o2hb_live_lock);
-
-	if (reg) {
-		o2nm_undepend_item(&reg->hr_item);
-		o2nm_undepend_this_node();
-	}
 }
 
 int o2hb_register_callback(const char *region_uuid,
@@ -2293,9 +2431,11 @@ int o2hb_register_callback(const char *region_uuid,
 	}
 
 	if (region_uuid) {
-		ret = o2hb_region_get(region_uuid);
-		if (ret)
+		ret = o2hb_region_inc_user(region_uuid);
+		if (ret) {
+			mlog_errno(ret);
 			goto out;
+		}
 	}
 
 	down_write(&o2hb_callback_sem);
@@ -2313,7 +2453,7 @@ int o2hb_register_callback(const char *region_uuid,
 	up_write(&o2hb_callback_sem);
 	ret = 0;
 out:
-	mlog(ML_HEARTBEAT, "returning %d on behalf of %p for funcs %p\n",
+	mlog(ML_CLUSTER, "returning %d on behalf of %p for funcs %p\n",
 	     ret, __builtin_return_address(0), hc);
 	return ret;
 }
@@ -2324,7 +2464,7 @@ void o2hb_unregister_callback(const char *region_uuid,
 {
 	BUG_ON(hc->hc_magic != O2HB_CB_MAGIC);
 
-	mlog(ML_HEARTBEAT, "on behalf of %p for funcs %p\n",
+	mlog(ML_CLUSTER, "on behalf of %p for funcs %p\n",
 	     __builtin_return_address(0), hc);
 
 	/* XXX Can this happen _with_ a region reference? */
@@ -2332,7 +2472,7 @@ void o2hb_unregister_callback(const char *region_uuid,
 		return;
 
 	if (region_uuid)
-		o2hb_region_put(region_uuid);
+		o2hb_region_dec_user(region_uuid);
 
 	down_write(&o2hb_callback_sem);
 
diff --git a/fs/ocfs2/dlm/dlmdomain.c b/fs/ocfs2/dlm/dlmdomain.c
index fcc40c3..7e38a07 100644
--- a/fs/ocfs2/dlm/dlmdomain.c
+++ b/fs/ocfs2/dlm/dlmdomain.c
@@ -1659,8 +1659,8 @@ bail:
 
 static void dlm_unregister_domain_handlers(struct dlm_ctxt *dlm)
 {
-	o2hb_unregister_callback(NULL, &dlm->dlm_hb_up);
-	o2hb_unregister_callback(NULL, &dlm->dlm_hb_down);
+	o2hb_unregister_callback(dlm->name, &dlm->dlm_hb_up);
+	o2hb_unregister_callback(dlm->name, &dlm->dlm_hb_down);
 	o2net_unregister_handler_list(&dlm->dlm_domain_handlers);
 }
 
@@ -1672,13 +1672,13 @@ static int dlm_register_domain_handlers(struct dlm_ctxt *dlm)
 
 	o2hb_setup_callback(&dlm->dlm_hb_down, O2HB_NODE_DOWN_CB,
 			    dlm_hb_node_down_cb, dlm, DLM_HB_NODE_DOWN_PRI);
-	status = o2hb_register_callback(NULL, &dlm->dlm_hb_down);
+	status = o2hb_register_callback(dlm->name, &dlm->dlm_hb_down);
 	if (status)
 		goto bail;
 
 	o2hb_setup_callback(&dlm->dlm_hb_up, O2HB_NODE_UP_CB,
 			    dlm_hb_node_up_cb, dlm, DLM_HB_NODE_UP_PRI);
-	status = o2hb_register_callback(NULL, &dlm->dlm_hb_up);
+	status = o2hb_register_callback(dlm->name, &dlm->dlm_hb_up);
 	if (status)
 		goto bail;
 
-- 
1.7.1
