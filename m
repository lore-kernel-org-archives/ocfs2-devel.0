From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Fri, 23 Jul 2010 16:55:22 -0700
Subject: [Ocfs2-devel] [PATCH 8/8] ocfs2/dlm: Add message DLM_QUERY_NODEINFO
In-Reply-To: <1279929322-9276-1-git-send-email-sunil.mushran@oracle.com>
References: <1279929322-9276-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1279929322-9276-9-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/dlm/dlmcommon.h |   17 ++++
 fs/ocfs2/dlm/dlmdomain.c |  188 +++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 204 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmcommon.h b/fs/ocfs2/dlm/dlmcommon.h
index 2c05138..34d9cd8 100644
--- a/fs/ocfs2/dlm/dlmcommon.h
+++ b/fs/ocfs2/dlm/dlmcommon.h
@@ -447,6 +447,7 @@ enum {
 	DLM_BEGIN_RECO_MSG,	 /* 517 */
 	DLM_FINALIZE_RECO_MSG,	 /* 518 */
 	DLM_QUERY_HBREGION,	 /* 519 */
+	DLM_QUERY_NODEINFO,	 /* 520 */
 };
 
 struct dlm_reco_node_data
@@ -737,6 +738,22 @@ struct dlm_query_hbregion {
 	u8 qhb_hbregions[O2HB_MAX_REGION_NAME_LEN * O2NM_MAX_HBREGIONS];
 };
 
+struct dlm_node_info {
+	u8 ni_nodenum;
+	u8 pad1;
+	u16 ni_ipv4_port;
+	u32 ni_ipv4_address;
+};
+
+struct dlm_query_nodeinfo {
+	u8 qn_nodenum;
+	u8 qn_numnodes;
+	u8 qn_namelen;
+	u8 pad1;
+	u8 qn_domain[O2NM_MAX_NAME_LEN];
+	struct dlm_node_info qn_nodes[O2NM_MAX_NODES];
+};
+
 struct dlm_exit_domain
 {
 	u8 node_idx;
diff --git a/fs/ocfs2/dlm/dlmdomain.c b/fs/ocfs2/dlm/dlmdomain.c
index 3521a00..2325087 100644
--- a/fs/ocfs2/dlm/dlmdomain.c
+++ b/fs/ocfs2/dlm/dlmdomain.c
@@ -131,6 +131,7 @@ static DECLARE_WAIT_QUEUE_HEAD(dlm_domain_events);
  *
  * New in version 1.1:
  *	- Message DLM_QUERY_HBREGION added to support global heartbeat
+ *	- Message DLM_QUERY_NODEINFO added to allow online node removes
  */
 static const struct dlm_protocol_version dlm_protocol = {
 	.pv_major = 1,
@@ -1122,6 +1123,179 @@ bail:
 	return status;
 }
 
+static int dlm_match_nodes(struct dlm_ctxt *dlm, struct dlm_query_nodeinfo *qn)
+{
+	struct o2nm_node *local;
+	struct dlm_node_info *remote;
+	int i, j;
+	int status = 0;
+
+	for (j = 0; j < qn->qn_numnodes; ++j)
+		mlog(ML_NOTICE, "Node %3d, %u.%u.%u.%u:%u\n",
+		     qn->qn_nodes[j].ni_nodenum,
+		     NIPQUAD(qn->qn_nodes[j].ni_ipv4_address),
+		     ntohs(qn->qn_nodes[j].ni_ipv4_port));
+
+	for (i = 0; i < O2NM_MAX_NODES && !status; ++i) {
+		local = o2nm_get_node_by_num(i);
+		remote = NULL;
+		for (j = 0; j < qn->qn_numnodes; ++j) {
+			if (qn->qn_nodes[j].ni_nodenum == i) {
+				remote = &(qn->qn_nodes[j]);
+				break;
+			}
+		}
+
+		if (!local && !remote)
+			continue;
+
+		if ((local && !remote) || (!local && remote))
+			status = -EINVAL;
+
+		if (!status &&
+		    ((remote->ni_nodenum != local->nd_num) ||
+		     (remote->ni_ipv4_port != local->nd_ipv4_port) ||
+		     (remote->ni_ipv4_address != local->nd_ipv4_address)))
+			status = -EINVAL;
+
+		if (status) {
+			if (remote && !local)
+				mlog(ML_ERROR, "Domain %s: Node %d "
+				     "(%u.%u.%u.%u:%u) registered in joining "
+				     "node %d but not in local node %d\n",
+				     qn->qn_domain, remote->ni_nodenum,
+				     NIPQUAD(remote->ni_ipv4_address),
+				     ntohs(remote->ni_ipv4_port),
+				     qn->qn_nodenum, dlm->node_num);
+			if (local && !remote)
+				mlog(ML_ERROR, "Domain %s: Node %d "
+				     "(%u.%u.%u.%u:%u) registered in local "
+				     "node %d but not in joining node %d\n",
+				     qn->qn_domain, local->nd_num,
+				     NIPQUAD(local->nd_ipv4_address),
+				     ntohs(local->nd_ipv4_port),
+				     dlm->node_num, qn->qn_nodenum);
+			BUG_ON((!local && !remote));
+		}
+
+		if (local)
+			o2nm_node_put(local);
+	}
+
+	return status;
+}
+
+static int dlm_send_nodeinfo(struct dlm_ctxt *dlm, unsigned long *node_map)
+{
+	struct dlm_query_nodeinfo *qn = NULL;
+	struct o2nm_node *node;
+	int ret = 0, status, count, i;
+
+	if (find_next_bit(node_map, O2NM_MAX_NODES, 0) >= O2NM_MAX_NODES)
+		goto bail;
+
+	qn = kmalloc(sizeof(struct dlm_query_nodeinfo), GFP_KERNEL);
+	if (!qn) {
+		ret = -ENOMEM;
+		mlog_errno(ret);
+		goto bail;
+	}
+
+	memset(qn, 0, sizeof(struct dlm_query_nodeinfo));
+
+	for (i = 0, count = 0; i < O2NM_MAX_NODES; ++i) {
+		node = o2nm_get_node_by_num(i);
+		if (!node)
+			continue;
+		qn->qn_nodes[count].ni_nodenum = node->nd_num;
+		qn->qn_nodes[count].ni_ipv4_port = node->nd_ipv4_port;
+		qn->qn_nodes[count].ni_ipv4_address = node->nd_ipv4_address;
+		mlog(ML_NOTICE, "Node %3d, %u.%u.%u.%u:%u\n", node->nd_num,
+		     NIPQUAD(node->nd_ipv4_address), ntohs(node->nd_ipv4_port));
+		++count;
+		o2nm_node_put(node);
+	}
+
+	qn->qn_nodenum = dlm->node_num;
+	qn->qn_numnodes = count;
+	qn->qn_namelen = strlen(dlm->name);
+	memcpy(qn->qn_domain, dlm->name, qn->qn_namelen);
+
+	i = -1;
+	while ((i = find_next_bit(node_map, O2NM_MAX_NODES,
+				  i + 1)) < O2NM_MAX_NODES) {
+		if (i == dlm->node_num)
+			continue;
+
+		mlog(ML_NOTICE, "Sending nodeinfo to node %d\n", i);
+
+		ret = o2net_send_message(DLM_QUERY_NODEINFO, DLM_MOD_KEY,
+					 qn, sizeof(struct dlm_query_nodeinfo),
+					 i, &status);
+		if (ret >= 0)
+			ret = status;
+		if (ret) {
+			mlog(ML_ERROR, "node mismatch %d, node %d\n", ret, i);
+			break;
+		}
+	}
+
+bail:
+	kfree(qn);
+	return ret;
+}
+
+static int dlm_query_nodeinfo_handler(struct o2net_msg *msg, u32 len,
+				      void *data, void **ret_data)
+{
+	struct dlm_query_nodeinfo *qn;
+	struct dlm_ctxt *dlm = NULL;
+	int locked = 0, status = 0;
+
+	qn = (struct dlm_query_nodeinfo *) msg->buf;
+
+	mlog(ML_NOTICE, "Node %u queries nodes on domain %s\n",
+	     qn->qn_nodenum, qn->qn_domain);
+
+	status = -EINVAL;
+
+	spin_lock(&dlm_domain_lock);
+	dlm = __dlm_lookup_domain_full(qn->qn_domain, qn->qn_namelen);
+	if (!dlm) {
+		mlog(ML_ERROR, "Node %d queried nodes on domain %s before "
+		     "join domain\n", qn->qn_nodenum, qn->qn_domain);
+		goto bail;
+	}
+
+	spin_lock(&dlm->spinlock);
+	locked = 1;
+	if (dlm->joining_node != qn->qn_nodenum) {
+		mlog(ML_ERROR, "Node %d queried nodes on domain %s but "
+		     "joining node is %d\n", qn->qn_nodenum, qn->qn_domain,
+		     dlm->joining_node);
+		goto bail;
+	}
+
+	/* Support for node query was added in 1.1 */
+	if (dlm->dlm_locking_proto.pv_major == 1 &&
+	    dlm->dlm_locking_proto.pv_minor == 0) {
+		mlog(ML_ERROR, "Node %d queried nodes on domain %s "
+		     "but active dlm protocol is %d.%d\n", qn->qn_nodenum,
+		     qn->qn_domain, dlm->dlm_locking_proto.pv_major,
+		     dlm->dlm_locking_proto.pv_minor);
+		goto bail;
+	}
+
+	status = dlm_match_nodes(dlm, qn);
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
@@ -1437,8 +1611,13 @@ static int dlm_try_to_join_domain(struct dlm_ctxt *dlm)
 	set_bit(dlm->node_num, dlm->domain_map);
 	spin_unlock(&dlm->spinlock);
 
-	/* Support for global heartbeat was added in 1.1 */
+	/* Support for global heartbeat and node info was added in 1.1 */
 	if (dlm_protocol.pv_major >= 1 && dlm_protocol.pv_minor > 0) {
+		status = dlm_send_nodeinfo(dlm, ctxt->yes_resp_map);
+		if (status) {
+			mlog_errno(status);
+			goto bail;
+		}
 		status = dlm_send_hbregions(dlm, ctxt->yes_resp_map);
 		if (status) {
 			mlog_errno(status);
@@ -2020,6 +2199,13 @@ static int dlm_register_net_handlers(void)
 					dlm_query_hbregion_handler,
 					NULL, NULL, &dlm_join_handlers);
 
+	if (status)
+		goto bail;
+
+	status = o2net_register_handler(DLM_QUERY_NODEINFO, DLM_MOD_KEY,
+					sizeof(struct dlm_query_nodeinfo),
+					dlm_query_nodeinfo_handler,
+					NULL, NULL, &dlm_join_handlers);
 bail:
 	if (status < 0)
 		dlm_unregister_net_handlers();
-- 
1.7.0.4
