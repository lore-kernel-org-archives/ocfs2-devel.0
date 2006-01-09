From: Jeff Mahoney <jeffm@suse.com>
Date: Mon, 9 Jan 2006 17:39:42 -0500
Subject: [Ocfs2-devel] [PATCH 06/11] ocfs2: allow per-resource callbacks
Message-ID: <20060109223942.GA8792@locomotive.unixthugs.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


 The following patch adds a heartbeat resource pointer to callbacks and
 events, allowing users to specify on a per-callback function basis whether
 to listen to a specific heartbeat resource or receive events for any
 resource.

 This functionality is not used by this patch, but will be with the next patch.
 fs/ocfs2/cluster/heartbeat.c |   14 +++++++++-----
 fs/ocfs2/cluster/heartbeat.h |    4 +++-
 fs/ocfs2/cluster/quorum.c    |    8 ++++----
 fs/ocfs2/cluster/tcp.c       |    4 ++--
 fs/ocfs2/dlm/dlmdomain.c     |    5 +++--
 fs/ocfs2/heartbeat.c         |    5 +++--
 6 files changed, 24 insertions(+), 16 deletions(-)

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
diff -ruNpX dontdiff linux-2.6.15-staging1/fs/ocfs2/cluster/heartbeat.c linux-2.6.15-staging2/fs/ocfs2/cluster/heartbeat.c
--- linux-2.6.15-staging1/fs/ocfs2/cluster/heartbeat.c	2006-01-08 19:05:00.901952568 -0500
+++ linux-2.6.15-staging2/fs/ocfs2/cluster/heartbeat.c	2006-01-08 19:05:34.200890360 -0500
@@ -68,16 +68,18 @@ static struct o2hb_callback {
 static struct o2hb_callback *hbcall_from_type(enum o2hb_callback_type type);
 
 static void o2hb_fire_callbacks(struct o2hb_callback *hbcall,
-				struct o2nm_node *node,
-				int idx)
+                                struct o2hb_node_event *event)
 {
 	struct list_head *iter;
 	struct o2hb_callback_func *f;
+	struct o2nm_node *node = event->hn_node;
+	int idx = event->hn_node_num;
 
 	list_for_each(iter, &hbcall->list) {
 		f = list_entry(iter, struct o2hb_callback_func, hc_item);
 		mlog(ML_HEARTBEAT, "calling funcs %p\n", f);
-		(f->hc_func)(node, idx, f->hc_data);
+		if (f->hc_res == NULL || f->hc_res == event->hn_res)
+			(f->hc_func)(node, idx, f->hc_data);
 	}
 }
 
@@ -119,7 +121,7 @@ void o2hb_run_event_list(struct o2hb_nod
 		 * to recover from. */
 		BUG_ON(IS_ERR(hbcall));
 
-		o2hb_fire_callbacks(hbcall, event->hn_node, event->hn_node_num);
+		o2hb_fire_callbacks(hbcall, event);
 
 		spin_lock(&o2hb_live_lock);
 	}
@@ -269,7 +271,8 @@ void o2hb_setup_callback(struct o2hb_cal
 			 enum o2hb_callback_type type,
 			 o2hb_cb_func *func,
 			 void *data,
-			 int priority)
+			 int priority,
+			 struct o2hb_heartbeat_resource *res)
 {
 	INIT_LIST_HEAD(&hc->hc_item);
 	hc->hc_func = func;
@@ -277,6 +280,7 @@ void o2hb_setup_callback(struct o2hb_cal
 	hc->hc_priority = priority;
 	hc->hc_type = type;
 	hc->hc_magic = O2HB_CB_MAGIC;
+	hc->hc_res = res;
 }
 EXPORT_SYMBOL_GPL(o2hb_setup_callback);
 
diff -ruNpX dontdiff linux-2.6.15-staging1/fs/ocfs2/cluster/heartbeat.h linux-2.6.15-staging2/fs/ocfs2/cluster/heartbeat.h
--- linux-2.6.15-staging1/fs/ocfs2/cluster/heartbeat.h	2006-01-08 19:05:00.902952416 -0500
+++ linux-2.6.15-staging2/fs/ocfs2/cluster/heartbeat.h	2006-01-08 19:05:34.200890360 -0500
@@ -70,6 +70,7 @@ struct o2hb_callback_func {
 	void			*hc_data;
 	int			hc_priority;
 	enum o2hb_callback_type hc_type;
+	struct o2hb_heartbeat_resource *hc_res;
 };
 
 struct o2hb_node_event {
@@ -77,6 +78,7 @@ struct o2hb_node_event {
 	enum o2hb_callback_type hn_event_type;
 	struct o2nm_node        *hn_node;
 	int                     hn_node_num;
+	struct o2hb_heartbeat_resource *hn_res;
 };
 void o2hb_queue_node_event(struct o2hb_node_event *event,
                            enum o2hb_callback_type type,
@@ -93,7 +95,7 @@ void o2hb_setup_callback(struct o2hb_cal
 			 enum o2hb_callback_type type,
 			 o2hb_cb_func *func,
 			 void *data,
-			 int priority);
+			 int priority, struct o2hb_heartbeat_resource *res);
 int o2hb_register_callback(struct o2hb_callback_func *hc);
 int o2hb_unregister_callback(struct o2hb_callback_func *hc);
 void o2hb_fill_node_map(unsigned long *map,
diff -ruNpX dontdiff linux-2.6.15-staging1/fs/ocfs2/cluster/quorum.c linux-2.6.15-staging2/fs/ocfs2/cluster/quorum.c
--- linux-2.6.15-staging1/fs/ocfs2/cluster/quorum.c	2006-01-08 19:05:00.903952264 -0500
+++ linux-2.6.15-staging2/fs/ocfs2/cluster/quorum.c	2006-01-08 19:05:34.201890208 -0500
@@ -348,13 +348,13 @@ static int o2quo_register_hb_callbacks(v
 	int ret;
 
 	o2hb_setup_callback(&o2quo_hb_down_cb, O2HB_NODE_DOWN_CB,
-	                    o2quo_hb_down, NULL, O2QUO_HB_PRI);
+	                    o2quo_hb_down, NULL, O2QUO_HB_PRI, NULL);
 	o2hb_setup_callback(&o2quo_hb_up_cb, O2HB_NODE_UP_CB,
-	                    o2quo_hb_up, NULL, O2QUO_HB_PRI);
+	                    o2quo_hb_up, NULL, O2QUO_HB_PRI, NULL);
 	o2hb_setup_callback(&o2quo_hb_conn_down, O2HB_CONN_DOWN_CB,
-	                    o2quo_conn_err, NULL, O2QUO_HB_PRI);
+	                    o2quo_conn_err, NULL, O2QUO_HB_PRI, NULL);
 	o2hb_setup_callback(&o2quo_hb_conn_up, O2HB_CONN_UP_CB,
-	                    o2quo_conn_up, NULL, O2QUO_HB_PRI);
+	                    o2quo_conn_up, NULL, O2QUO_HB_PRI, NULL);
 
 	ret = o2hb_register_callback(&o2quo_hb_up_cb);
 	if (ret == 0)
diff -ruNpX dontdiff linux-2.6.15-staging1/fs/ocfs2/cluster/tcp.c linux-2.6.15-staging2/fs/ocfs2/cluster/tcp.c
--- linux-2.6.15-staging1/fs/ocfs2/cluster/tcp.c	2006-01-08 18:34:37.725117576 -0500
+++ linux-2.6.15-staging2/fs/ocfs2/cluster/tcp.c	2006-01-08 19:05:34.202890056 -0500
@@ -1499,9 +1499,9 @@ int o2net_register_hb_callbacks(void)
 	int ret;
 
 	o2hb_setup_callback(&o2net_hb_down, O2HB_NODE_DOWN_CB,
-			    o2net_hb_node_down_cb, NULL, O2NET_HB_PRI);
+			    o2net_hb_node_down_cb, NULL, O2NET_HB_PRI, NULL);
 	o2hb_setup_callback(&o2net_hb_up, O2HB_NODE_UP_CB,
-			    o2net_hb_node_up_cb, NULL, O2NET_HB_PRI);
+			    o2net_hb_node_up_cb, NULL, O2NET_HB_PRI, NULL);
 
 	ret = o2hb_register_callback(&o2net_hb_up);
 	if (ret == 0)
diff -ruNpX dontdiff linux-2.6.15-staging1/fs/ocfs2/dlm/dlmdomain.c linux-2.6.15-staging2/fs/ocfs2/dlm/dlmdomain.c
--- linux-2.6.15-staging1/fs/ocfs2/dlm/dlmdomain.c	2006-01-08 18:34:09.767367800 -0500
+++ linux-2.6.15-staging2/fs/ocfs2/dlm/dlmdomain.c	2006-01-08 19:05:34.203889904 -0500
@@ -968,13 +968,14 @@ static int dlm_register_domain_handlers(
 	mlog(0, "registering handlers.\n");
 
 	o2hb_setup_callback(&dlm->dlm_hb_down, O2HB_NODE_DOWN_CB,
-			    dlm_hb_node_down_cb, dlm, DLM_HB_NODE_DOWN_PRI);
+			    dlm_hb_node_down_cb, dlm,
+			    DLM_HB_NODE_DOWN_PRI, NULL);
 	status = o2hb_register_callback(&dlm->dlm_hb_down);
 	if (status)
 		goto bail;
 
 	o2hb_setup_callback(&dlm->dlm_hb_up, O2HB_NODE_UP_CB,
-			    dlm_hb_node_up_cb, dlm, DLM_HB_NODE_UP_PRI);
+			    dlm_hb_node_up_cb, dlm, DLM_HB_NODE_UP_PRI, NULL);
 	status = o2hb_register_callback(&dlm->dlm_hb_up);
 	if (status)
 		goto bail;
diff -ruNpX dontdiff linux-2.6.15-staging1/fs/ocfs2/heartbeat.c linux-2.6.15-staging2/fs/ocfs2/heartbeat.c
--- linux-2.6.15-staging1/fs/ocfs2/heartbeat.c	2006-01-08 18:34:09.785365064 -0500
+++ linux-2.6.15-staging2/fs/ocfs2/heartbeat.c	2006-01-08 19:05:34.203889904 -0500
@@ -136,10 +136,11 @@ void ocfs2_setup_hb_callbacks(struct ocf
 {
 	o2hb_setup_callback(&osb->osb_hb_down, O2HB_NODE_DOWN_CB,
 			    ocfs2_hb_node_down_cb, osb,
-			    OCFS2_HB_NODE_DOWN_PRI);
+			    OCFS2_HB_NODE_DOWN_PRI, NULL);
 
 	o2hb_setup_callback(&osb->osb_hb_up, O2HB_NODE_UP_CB,
-			    ocfs2_hb_node_up_cb, osb, OCFS2_HB_NODE_UP_PRI);
+			    ocfs2_hb_node_up_cb, osb,
+			    OCFS2_HB_NODE_UP_PRI, NULL);
 
 	/* Not exactly a heartbeat callback, but leads to essentially
 	 * the same path so we set it up here. */
