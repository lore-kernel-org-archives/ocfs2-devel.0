From: Joel Becker <joel.becker@oracle.com>
Date: Thu Jun 14 21:53:51 2007
Subject: [Ocfs2-devel] [PATCH 2/2] ocfs2: Depend on configfs heartbeat items.
In-Reply-To: <20070615044046.GA17382@tasint.org>
References: <20070615044046.GA17382@tasint.org>
Message-ID: <E1Hz3of-0004n6-OG@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com

ocfs2 mounts require a heartbeat region.  Use the new configfs_depend_item()
facility to actually depend on them so they can't go away from under us.

First, teach cluster/nodemanager.c to depend an item on the o2cb subsystem.
Then teach o2hb_register_callbacks to take a UUID and depend on the
appropriate region.  Finally, teach all users of o2hb to pass a UUID or
NULL if they don't require a pin.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/cluster/heartbeat.c   |   64 +++++++++++++++++++++++++++++++++++++++-
 fs/ocfs2/cluster/heartbeat.h   |    6 +++-
 fs/ocfs2/cluster/nodemanager.c |   10 ++++++
 fs/ocfs2/cluster/nodemanager.h |    3 ++
 fs/ocfs2/cluster/tcp.c         |    8 +++--
 fs/ocfs2/dlm/dlmdomain.c       |    8 +++--
 fs/ocfs2/heartbeat.c           |   10 +++---
 7 files changed, 92 insertions(+), 17 deletions(-)

diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index 9791134..e331f4c 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -1665,7 +1665,56 @@ void o2hb_setup_callback(struct o2hb_cal
 }
 EXPORT_SYMBOL_GPL(o2hb_setup_callback);
 
-int o2hb_register_callback(struct o2hb_callback_func *hc)
+static struct o2hb_region *o2hb_find_region(const char *region_uuid)
+{
+	struct o2hb_region *p, *reg = NULL;
+
+	assert_spin_locked(&o2hb_live_lock);
+
+	list_for_each_entry(p, &o2hb_all_regions, hr_all_item) {
+		if (!strcmp(region_uuid, config_item_name(&p->hr_item))) {
+			reg = p;
+			break;
+		}
+	}
+
+	return reg;
+}
+
+static int o2hb_region_get(const char *region_uuid)
+{
+	int ret = 0;
+	struct o2hb_region *reg;
+
+	spin_lock(&o2hb_live_lock);
+
+	reg = o2hb_find_region(region_uuid);
+	if (!reg)
+		ret = -ENOENT;
+	spin_unlock(&o2hb_live_lock);
+
+	if (!ret)
+		ret = o2nm_depend_item(&reg->hr_item);
+
+	return ret;
+}
+
+static void o2hb_region_put(const char *region_uuid)
+{
+	struct o2hb_region *reg;
+
+	spin_lock(&o2hb_live_lock);
+
+	reg = o2hb_find_region(region_uuid);
+
+	spin_unlock(&o2hb_live_lock);
+
+	if (reg)
+		o2nm_undepend_item(&reg->hr_item);
+}
+
+int o2hb_register_callback(const char *region_uuid,
+			   struct o2hb_callback_func *hc)
 {
 	struct o2hb_callback_func *tmp;
 	struct list_head *iter;
@@ -1681,6 +1730,12 @@ int o2hb_register_callback(struct o2hb_c
 		goto out;
 	}
 
+	if (region_uuid) {
+		ret = o2hb_region_get(region_uuid);
+		if (ret)
+			goto out;
+	}
+
 	down_write(&o2hb_callback_sem);
 
 	list_for_each(iter, &hbcall->list) {
@@ -1702,16 +1757,21 @@ out:
 }
 EXPORT_SYMBOL_GPL(o2hb_register_callback);
 
-void o2hb_unregister_callback(struct o2hb_callback_func *hc)
+void o2hb_unregister_callback(const char *region_uuid,
+			      struct o2hb_callback_func *hc)
 {
 	BUG_ON(hc->hc_magic != O2HB_CB_MAGIC);
 
 	mlog(ML_HEARTBEAT, "on behalf of %p for funcs %p\n",
 	     __builtin_return_address(0), hc);
 
+	/* XXX Can this happen _with_ a region reference? */
 	if (list_empty(&hc->hc_item))
 		return;
 
+	if (region_uuid)
+		o2hb_region_put(region_uuid);
+
 	down_write(&o2hb_callback_sem);
 
 	list_del_init(&hc->hc_item);
diff --git a/fs/ocfs2/cluster/heartbeat.h b/fs/ocfs2/cluster/heartbeat.h
index cc6d40b..35397dd 100644
--- a/fs/ocfs2/cluster/heartbeat.h
+++ b/fs/ocfs2/cluster/heartbeat.h
@@ -69,8 +69,10 @@ void o2hb_setup_callback(struct o2hb_cal
 			 o2hb_cb_func *func,
 			 void *data,
 			 int priority);
-int o2hb_register_callback(struct o2hb_callback_func *hc);
-void o2hb_unregister_callback(struct o2hb_callback_func *hc);
+int o2hb_register_callback(const char *region_uuid,
+			   struct o2hb_callback_func *hc);
+void o2hb_unregister_callback(const char *region_uuid,
+			      struct o2hb_callback_func *hc);
 void o2hb_fill_node_map(unsigned long *map,
 			unsigned bytes);
 void o2hb_init(void);
diff --git a/fs/ocfs2/cluster/nodemanager.c b/fs/ocfs2/cluster/nodemanager.c
index 9f5ad0f..50a0524 100644
--- a/fs/ocfs2/cluster/nodemanager.c
+++ b/fs/ocfs2/cluster/nodemanager.c
@@ -900,6 +900,16 @@ static struct o2nm_cluster_group o2nm_cl
 	},
 };
 
+int o2nm_depend_item(struct config_item *item)
+{
+	return configfs_depend_item(&o2nm_cluster_group.cs_subsys, item);
+}
+
+void o2nm_undepend_item(struct config_item *item)
+{
+	configfs_undepend_item(&o2nm_cluster_group.cs_subsys, item);
+}
+
 static void __exit exit_o2nm(void)
 {
 	if (ocfs2_table_header)
diff --git a/fs/ocfs2/cluster/nodemanager.h b/fs/ocfs2/cluster/nodemanager.h
index 0705221..55ae1a0 100644
--- a/fs/ocfs2/cluster/nodemanager.h
+++ b/fs/ocfs2/cluster/nodemanager.h
@@ -77,4 +77,7 @@ struct o2nm_node *o2nm_get_node_by_ip(__
 void o2nm_node_get(struct o2nm_node *node);
 void o2nm_node_put(struct o2nm_node *node);
 
+int o2nm_depend_item(struct config_item *item);
+void o2nm_undepend_item(struct config_item *item);
+
 #endif /* O2CLUSTER_NODEMANAGER_H */
diff --git a/fs/ocfs2/cluster/tcp.c b/fs/ocfs2/cluster/tcp.c
index 0b229a9..d58c7dd 100644
--- a/fs/ocfs2/cluster/tcp.c
+++ b/fs/ocfs2/cluster/tcp.c
@@ -1638,8 +1638,8 @@ static void o2net_hb_node_up_cb(struct o
 
 void o2net_unregister_hb_callbacks(void)
 {
-	o2hb_unregister_callback(&o2net_hb_up);
-	o2hb_unregister_callback(&o2net_hb_down);
+	o2hb_unregister_callback(NULL, &o2net_hb_up);
+	o2hb_unregister_callback(NULL, &o2net_hb_down);
 }
 
 int o2net_register_hb_callbacks(void)
@@ -1651,9 +1651,9 @@ int o2net_register_hb_callbacks(void)
 	o2hb_setup_callback(&o2net_hb_up, O2HB_NODE_UP_CB,
 			    o2net_hb_node_up_cb, NULL, O2NET_HB_PRI);
 
-	ret = o2hb_register_callback(&o2net_hb_up);
+	ret = o2hb_register_callback(NULL, &o2net_hb_up);
 	if (ret == 0)
-		ret = o2hb_register_callback(&o2net_hb_down);
+		ret = o2hb_register_callback(NULL, &o2net_hb_down);
 
 	if (ret)
 		o2net_unregister_hb_callbacks();
diff --git a/fs/ocfs2/dlm/dlmdomain.c b/fs/ocfs2/dlm/dlmdomain.c
index d836b98..6954565 100644
--- a/fs/ocfs2/dlm/dlmdomain.c
+++ b/fs/ocfs2/dlm/dlmdomain.c
@@ -1128,8 +1128,8 @@ bail:
 
 static void dlm_unregister_domain_handlers(struct dlm_ctxt *dlm)
 {
-	o2hb_unregister_callback(&dlm->dlm_hb_up);
-	o2hb_unregister_callback(&dlm->dlm_hb_down);
+	o2hb_unregister_callback(NULL, &dlm->dlm_hb_up);
+	o2hb_unregister_callback(NULL, &dlm->dlm_hb_down);
 	o2net_unregister_handler_list(&dlm->dlm_domain_handlers);
 }
 
@@ -1141,13 +1141,13 @@ static int dlm_register_domain_handlers(
 
 	o2hb_setup_callback(&dlm->dlm_hb_down, O2HB_NODE_DOWN_CB,
 			    dlm_hb_node_down_cb, dlm, DLM_HB_NODE_DOWN_PRI);
-	status = o2hb_register_callback(&dlm->dlm_hb_down);
+	status = o2hb_register_callback(NULL, &dlm->dlm_hb_down);
 	if (status)
 		goto bail;
 
 	o2hb_setup_callback(&dlm->dlm_hb_up, O2HB_NODE_UP_CB,
 			    dlm_hb_node_up_cb, dlm, DLM_HB_NODE_UP_PRI);
-	status = o2hb_register_callback(&dlm->dlm_hb_up);
+	status = o2hb_register_callback(NULL, &dlm->dlm_hb_up);
 	if (status)
 		goto bail;
 
diff --git a/fs/ocfs2/heartbeat.c b/fs/ocfs2/heartbeat.c
index b25ef63..352eb4a 100644
--- a/fs/ocfs2/heartbeat.c
+++ b/fs/ocfs2/heartbeat.c
@@ -157,16 +157,16 @@ int ocfs2_register_hb_callbacks(struct o
 	if (ocfs2_mount_local(osb))
 		return 0;
 
-	status = o2hb_register_callback(&osb->osb_hb_down);
+	status = o2hb_register_callback(osb->uuid_str, &osb->osb_hb_down);
 	if (status < 0) {
 		mlog_errno(status);
 		goto bail;
 	}
 
-	status = o2hb_register_callback(&osb->osb_hb_up);
+	status = o2hb_register_callback(osb->uuid_str, &osb->osb_hb_up);
 	if (status < 0) {
 		mlog_errno(status);
-		o2hb_unregister_callback(&osb->osb_hb_down);
+		o2hb_unregister_callback(osb->uuid_str, &osb->osb_hb_down);
 	}
 
 bail:
@@ -178,8 +178,8 @@ void ocfs2_clear_hb_callbacks(struct ocf
 	if (ocfs2_mount_local(osb))
 		return;
 
-	o2hb_unregister_callback(&osb->osb_hb_down);
-	o2hb_unregister_callback(&osb->osb_hb_up);
+	o2hb_unregister_callback(osb->uuid_str, &osb->osb_hb_down);
+	o2hb_unregister_callback(osb->uuid_str, &osb->osb_hb_up);
 }
 
 void ocfs2_stop_heartbeat(struct ocfs2_super *osb)
-- 
1.4.2.3
