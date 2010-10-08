From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu,  7 Oct 2010 17:15:20 -0700
Subject: [Ocfs2-devel] [PATCH 06/22] ocfs2/dlm: Add message DLM_QUERY_REGION
In-Reply-To: <1286496936-17072-1-git-send-email-sunil.mushran@oracle.com>
References: <1286496936-17072-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1286496936-17072-7-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Adds new dlm message DLM_QUERY_REGION that sends the names of all active
heartbeat regions. This message is only sent in the global heartbeat
mode. If the regions in the joining node do not fully match the ones in
the active nodes, the join domain request is rejected.

The dlm_protocol is bumped upto 1.1.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/cluster/ocfs2_nodemanager.h |    6 +
 fs/ocfs2/dlm/dlmcommon.h             |   12 ++-
 fs/ocfs2/dlm/dlmdomain.c             |  218 ++++++++++++++++++++++++++++++++++
 3 files changed, 235 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/cluster/ocfs2_nodemanager.h b/fs/ocfs2/cluster/ocfs2_nodemanager.h
index 5b9854b..49b5943 100644
--- a/fs/ocfs2/cluster/ocfs2_nodemanager.h
+++ b/fs/ocfs2/cluster/ocfs2_nodemanager.h
@@ -36,4 +36,10 @@
 /* host name, group name, cluster name all 64 bytes */
 #define O2NM_MAX_NAME_LEN        64    // __NEW_UTS_LEN
 
+/*
+ * Maximum number of global heartbeat regions allowed.
+ * **CAUTION**  Changing this number will break dlm compatibility.
+ */
+#define O2NM_MAX_REGIONS	32
+
 #endif /* _OCFS2_NODEMANAGER_H */
diff --git a/fs/ocfs2/dlm/dlmcommon.h b/fs/ocfs2/dlm/dlmcommon.h
index 7652989..aa506d3 100644
--- a/fs/ocfs2/dlm/dlmcommon.h
+++ b/fs/ocfs2/dlm/dlmcommon.h
@@ -445,7 +445,8 @@ enum {
 	DLM_LOCK_REQUEST_MSG,	 /* 515 */
 	DLM_RECO_DATA_DONE_MSG,	 /* 516 */
 	DLM_BEGIN_RECO_MSG,	 /* 517 */
-	DLM_FINALIZE_RECO_MSG	 /* 518 */
+	DLM_FINALIZE_RECO_MSG,	 /* 518 */
+	DLM_QUERY_REGION,	 /* 519 */
 };
 
 struct dlm_reco_node_data
@@ -727,6 +728,15 @@ struct dlm_cancel_join
 	u8 domain[O2NM_MAX_NAME_LEN];
 };
 
+struct dlm_query_region {
+	u8 qr_node;
+	u8 qr_numregions;
+	u8 qr_namelen;
+	u8 pad1;
+	u8 qr_domain[O2NM_MAX_NAME_LEN];
+	u8 qr_regions[O2HB_MAX_REGION_NAME_LEN * O2NM_MAX_REGIONS];
+};
+
 struct dlm_exit_domain
 {
 	u8 node_idx;
diff --git a/fs/ocfs2/dlm/dlmdomain.c b/fs/ocfs2/dlm/dlmdomain.c
index 11a5c87..4965075 100644
--- a/fs/ocfs2/dlm/dlmdomain.c
+++ b/fs/ocfs2/dlm/dlmdomain.c
@@ -128,6 +128,9 @@ static DECLARE_WAIT_QUEUE_HEAD(dlm_domain_events);
  * will have a negotiated version with the same major number and a minor
  * number equal or smaller.  The dlm_ctxt->dlm_locking_proto field should
  * be used to determine what a running domain is actually using.
+ *
+ * New in version 1.1:
+ *	- Message DLM_QUERY_REGION added to support global heartbeat
  */
 static const struct dlm_protocol_version dlm_protocol = {
 	.pv_major = 1,
@@ -142,6 +145,8 @@ static int dlm_assert_joined_handler(struct o2net_msg *msg, u32 len, void *data,
 				     void **ret_data);
 static int dlm_cancel_join_handler(struct o2net_msg *msg, u32 len, void *data,
 				   void **ret_data);
+static int dlm_query_region_handler(struct o2net_msg *msg, u32 len,
+				    void *data, void **ret_data);
 static int dlm_exit_domain_handler(struct o2net_msg *msg, u32 len, void *data,
 				   void **ret_data);
 static int dlm_protocol_compare(struct dlm_protocol_version *existing,
@@ -921,6 +926,203 @@ static int dlm_assert_joined_handler(struct o2net_msg *msg, u32 len, void *data,
 	return 0;
 }
 
+static int dlm_match_regions(struct dlm_ctxt *dlm,
+			     struct dlm_query_region *qr)
+{
+	char *local = NULL, *remote = qr->qr_regions;
+	char *l, *r;
+	int localnr, i, j, foundit;
+	int status = 0;
+
+	if (!o2hb_global_heartbeat_active()) {
+		if (qr->qr_numregions) {
+			mlog(ML_ERROR, "Domain %s: Joining node %d has global "
+			     "heartbeat enabled but local node %d does not\n",
+			     qr->qr_domain, qr->qr_node, dlm->node_num);
+			status = -EINVAL;
+		}
+		goto bail;
+	}
+
+	if (o2hb_global_heartbeat_active() && !qr->qr_numregions) {
+		mlog(ML_ERROR, "Domain %s: Local node %d has global "
+		     "heartbeat enabled but joining node %d does not\n",
+		     qr->qr_domain, dlm->node_num, qr->qr_node);
+		status = -EINVAL;
+		goto bail;
+	}
+
+	r = remote;
+	for (i = 0; i < qr->qr_numregions; ++i) {
+		mlog(0, "Region %.*s\n", O2HB_MAX_REGION_NAME_LEN, r);
+		r += O2HB_MAX_REGION_NAME_LEN;
+	}
+
+	local = kmalloc(sizeof(qr->qr_regions), GFP_KERNEL);
+	if (!local) {
+		status = -ENOMEM;
+		goto bail;
+	}
+
+	localnr = o2hb_get_all_regions(local, O2NM_MAX_REGIONS);
+
+	/* compare local regions with remote */
+	l = local;
+	for (i = 0; i < localnr; ++i) {
+		foundit = 0;
+		r = remote;
+		for (j = 0; j <= qr->qr_numregions; ++j) {
+			if (!memcmp(l, r, O2HB_MAX_REGION_NAME_LEN)) {
+				foundit = 1;
+				break;
+			}
+			r += O2HB_MAX_REGION_NAME_LEN;
+		}
+		if (!foundit) {
+			status = -EINVAL;
+			mlog(ML_ERROR, "Domain %s: Region '%.*s' registered "
+			     "in local node %d but not in joining node %d\n",
+			     qr->qr_domain, O2HB_MAX_REGION_NAME_LEN, l,
+			     dlm->node_num, qr->qr_node);
+			goto bail;
+		}
+		l += O2HB_MAX_REGION_NAME_LEN;
+	}
+
+	/* compare remote with local regions */
+	r = remote;
+	for (i = 0; i < qr->qr_numregions; ++i) {
+		foundit = 0;
+		l = local;
+		for (j = 0; j < localnr; ++j) {
+			if (!memcmp(r, l, O2HB_MAX_REGION_NAME_LEN)) {
+				foundit = 1;
+				break;
+			}
+			l += O2HB_MAX_REGION_NAME_LEN;
+		}
+		if (!foundit) {
+			status = -EINVAL;
+			mlog(ML_ERROR, "Domain %s: Region '%.*s' registered "
+			     "in joining node %d but not in local node %d\n",
+			     qr->qr_domain, O2HB_MAX_REGION_NAME_LEN, r,
+			     qr->qr_node, dlm->node_num);
+			goto bail;
+		}
+		r += O2HB_MAX_REGION_NAME_LEN;
+	}
+
+bail:
+	kfree(local);
+
+	return status;
+}
+
+static int dlm_send_regions(struct dlm_ctxt *dlm, unsigned long *node_map)
+{
+	struct dlm_query_region *qr = NULL;
+	int status, ret = 0, i;
+	char *p;
+
+	if (find_next_bit(node_map, O2NM_MAX_NODES, 0) >= O2NM_MAX_NODES)
+		goto bail;
+
+	qr = kzalloc(sizeof(struct dlm_query_region), GFP_KERNEL);
+	if (!qr) {
+		ret = -ENOMEM;
+		mlog_errno(ret);
+		goto bail;
+	}
+
+	qr->qr_node = dlm->node_num;
+	qr->qr_namelen = strlen(dlm->name);
+	memcpy(qr->qr_domain, dlm->name, qr->qr_namelen);
+	/* if local hb, the numregions will be zero */
+	if (o2hb_global_heartbeat_active())
+		qr->qr_numregions = o2hb_get_all_regions(qr->qr_regions,
+							 O2NM_MAX_REGIONS);
+
+	p = qr->qr_regions;
+	for (i = 0; i < qr->qr_numregions; ++i, p += O2HB_MAX_REGION_NAME_LEN)
+		mlog(0, "Region %.*s\n", O2HB_MAX_REGION_NAME_LEN, p);
+
+	i = -1;
+	while ((i = find_next_bit(node_map, O2NM_MAX_NODES,
+				  i + 1)) < O2NM_MAX_NODES) {
+		if (i == dlm->node_num)
+			continue;
+
+		mlog(0, "Sending regions to node %d\n", i);
+
+		ret = o2net_send_message(DLM_QUERY_REGION, DLM_MOD_KEY, qr,
+					 sizeof(struct dlm_query_region),
+					 i, &status);
+		if (ret >= 0)
+			ret = status;
+		if (ret) {
+			mlog(ML_ERROR, "Region mismatch %d, node %d\n",
+			     ret, i);
+			break;
+		}
+	}
+
+bail:
+	kfree(qr);
+	return ret;
+}
+
+static int dlm_query_region_handler(struct o2net_msg *msg, u32 len,
+				    void *data, void **ret_data)
+{
+	struct dlm_query_region *qr;
+	struct dlm_ctxt *dlm = NULL;
+	int status = 0;
+	int locked = 0;
+
+	qr = (struct dlm_query_region *) msg->buf;
+
+	mlog(0, "Node %u queries hb regions on domain %s\n", qr->qr_node,
+	     qr->qr_domain);
+
+	status = -EINVAL;
+
+	spin_lock(&dlm_domain_lock);
+	dlm = __dlm_lookup_domain_full(qr->qr_domain, qr->qr_namelen);
+	if (!dlm) {
+		mlog(ML_ERROR, "Node %d queried hb regions on domain %s "
+		     "before join domain\n", qr->qr_node, qr->qr_domain);
+		goto bail;
+	}
+
+	spin_lock(&dlm->spinlock);
+	locked = 1;
+	if (dlm->joining_node != qr->qr_node) {
+		mlog(ML_ERROR, "Node %d queried hb regions on domain %s "
+		     "but joining node is %d\n", qr->qr_node, qr->qr_domain,
+		     dlm->joining_node);
+		goto bail;
+	}
+
+	/* Support for global heartbeat was added in 1.1 */
+	if (dlm->dlm_locking_proto.pv_major == 1 &&
+	    dlm->dlm_locking_proto.pv_minor == 0) {
+		mlog(ML_ERROR, "Node %d queried hb regions on domain %s "
+		     "but active dlm protocol is %d.%d\n", qr->qr_node,
+		     qr->qr_domain, dlm->dlm_locking_proto.pv_major,
+		     dlm->dlm_locking_proto.pv_minor);
+		goto bail;
+	}
+
+	status = dlm_match_regions(dlm, qr);
+
+bail:
+	if (locked)
+		spin_unlock(&dlm->spinlock);
+	spin_unlock(&dlm_domain_lock);
+
+	return status;
+}
+
 static int dlm_cancel_join_handler(struct o2net_msg *msg, u32 len, void *data,
 				   void **ret_data)
 {
@@ -1241,6 +1443,15 @@ static int dlm_try_to_join_domain(struct dlm_ctxt *dlm)
 	set_bit(dlm->node_num, dlm->domain_map);
 	spin_unlock(&dlm->spinlock);
 
+	/* Support for global heartbeat was added in 1.1 */
+	if (dlm_protocol.pv_major > 1 || dlm_protocol.pv_minor > 0) {
+		status = dlm_send_regions(dlm, ctxt->yes_resp_map);
+		if (status) {
+			mlog_errno(status);
+			goto bail;
+		}
+	}
+
 	dlm_send_join_asserts(dlm, ctxt->yes_resp_map);
 
 	/* Joined state *must* be set before the joining node
@@ -1807,6 +2018,13 @@ static int dlm_register_net_handlers(void)
 					sizeof(struct dlm_cancel_join),
 					dlm_cancel_join_handler,
 					NULL, NULL, &dlm_join_handlers);
+	if (status)
+		goto bail;
+
+	status = o2net_register_handler(DLM_QUERY_REGION, DLM_MOD_KEY,
+					sizeof(struct dlm_query_region),
+					dlm_query_region_handler,
+					NULL, NULL, &dlm_join_handlers);
 
 bail:
 	if (status < 0)
-- 
1.7.0.4
