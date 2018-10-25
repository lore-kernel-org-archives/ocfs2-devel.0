From: piaojun <piaojun@huawei.com>
Date: Thu, 25 Oct 2018 18:35:50 +0800
Subject: [Ocfs2-devel] [PATCH 4/5] ocfs2/dlm: modify DLM_QUERY_NODEINFO
 message to adapt IPv6 node
Message-ID: <5BD19C86.1090805@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Add IPv6 node info to dlm_query_nodeinfo, and distinguish with IPv4 by
qn_ipnet_type. DLM_QUERY_NODEINFO message is compitibile with the old
version.

Signed-off-by: Jun Piao <piaojun@huawei.com>
---
 fs/ocfs2/cluster/tcp.c   |  6 ++--
 fs/ocfs2/cluster/tcp.h   |  2 +-
 fs/ocfs2/dlm/dlmcommon.h | 12 +++++--
 fs/ocfs2/dlm/dlmdomain.c | 93 ++++++++++++++++++++++++++++++++++--------------
 4 files changed, 80 insertions(+), 33 deletions(-)

diff --git a/fs/ocfs2/cluster/tcp.c b/fs/ocfs2/cluster/tcp.c
index 82fa8da..31157a8 100644
--- a/fs/ocfs2/cluster/tcp.c
+++ b/fs/ocfs2/cluster/tcp.c
@@ -409,7 +409,7 @@ static void sc_kref_release(struct kref *kref)
 	o2net_debug_del_sc(sc);

 	if (sc->sc_page)
-		__free_page(sc->sc_page);
+		__free_pages(sc->sc_page, 1);
 	kfree(sc);
 }

@@ -429,7 +429,7 @@ static struct o2net_sock_container *sc_alloc(struct o2nm_node *node)
 	struct page *page = NULL;
 	int status = 0;

-	page = alloc_page(GFP_NOFS);
+	page = alloc_pages(GFP_NOFS, 1);
 	sc = kzalloc(sizeof(*sc), GFP_NOFS);
 	if (sc == NULL || page == NULL)
 		goto out;
@@ -462,7 +462,7 @@ static struct o2net_sock_container *sc_alloc(struct o2nm_node *node)

 out:
 	if (page)
-		__free_page(page);
+		__free_pages(page, 1);
 	kfree(sc);

 	return ret;
diff --git a/fs/ocfs2/cluster/tcp.h b/fs/ocfs2/cluster/tcp.h
index c571e84..002b267 100644
--- a/fs/ocfs2/cluster/tcp.h
+++ b/fs/ocfs2/cluster/tcp.h
@@ -55,7 +55,7 @@ typedef int (o2net_msg_handler_func)(struct o2net_msg *msg, u32 len, void *data,
 typedef void (o2net_post_msg_handler_func)(int status, void *data,
 					   void *ret_data);

-#define O2NET_MAX_PAYLOAD_BYTES  (4096 - sizeof(struct o2net_msg))
+#define O2NET_MAX_PAYLOAD_BYTES  (4096 * 2 - sizeof(struct o2net_msg))

 /* same as hb delay, we're waiting for another node to recognize our hb */
 #define O2NET_RECONNECT_DELAY_MS_DEFAULT	2000
diff --git a/fs/ocfs2/dlm/dlmcommon.h b/fs/ocfs2/dlm/dlmcommon.h
index d06e27e..ba391ec 100644
--- a/fs/ocfs2/dlm/dlmcommon.h
+++ b/fs/ocfs2/dlm/dlmcommon.h
@@ -747,15 +747,21 @@ struct dlm_query_region {
 struct dlm_node_info {
 	u8 ni_nodenum;
 	u8 pad1;
-	__be16 ni_ipv4_port;
-	__be32 ni_ipv4_address;
+	union {
+		__be16 ni_ipv4_port;
+		__be16 ni_ipv6_port;
+	} ip_port;
+	union {
+		__be32 ni_ipv4_address;
+		u8 ni_ipv6_address[16];
+	} ip_addr;
 };

 struct dlm_query_nodeinfo {
 	u8 qn_nodenum;
 	u8 qn_numnodes;
 	u8 qn_namelen;
-	u8 pad1;
+	u8 qn_ipnet_type;  /* 0-IPv4, 1-IPv6 */
 	u8 qn_domain[O2NM_MAX_NAME_LEN];
 	struct dlm_node_info qn_nodes[O2NM_MAX_NODES];
 };
diff --git a/fs/ocfs2/dlm/dlmdomain.c b/fs/ocfs2/dlm/dlmdomain.c
index 2acd58b..49d60a9 100644
--- a/fs/ocfs2/dlm/dlmdomain.c
+++ b/fs/ocfs2/dlm/dlmdomain.c
@@ -1176,10 +1176,16 @@ static int dlm_match_nodes(struct dlm_ctxt *dlm, struct dlm_query_nodeinfo *qn)
 	int i, j;
 	int status = 0;

-	for (j = 0; j < qn->qn_numnodes; ++j)
-		mlog(0, "Node %3d, %pI4:%u\n", qn->qn_nodes[j].ni_nodenum,
-		     &(qn->qn_nodes[j].ni_ipv4_address),
-		     ntohs(qn->qn_nodes[j].ni_ipv4_port));
+	if (qn->qn_ipnet_type == IPV4_TYPE)
+		for (j = 0; j < qn->qn_numnodes; ++j)
+			mlog(0, "Node %3d, %pI4:%u\n", qn->qn_nodes[j].ni_nodenum,
+			     &(qn->qn_nodes[j].ip_addr.ni_ipv4_address),
+			     ntohs(qn->qn_nodes[j].ip_port.ni_ipv4_port));
+	else
+		for (j = 0; j < qn->qn_numnodes; ++j)
+			mlog(0, "Node %3d, %pI6:%u\n", qn->qn_nodes[j].ni_nodenum,
+			     qn->qn_nodes[j].ip_addr.ni_ipv6_address,
+			     ntohs(qn->qn_nodes[j].ip_port.ni_ipv6_port));

 	for (i = 0; i < O2NM_MAX_NODES && !status; ++i) {
 		local = o2nm_get_node_by_num(i);
@@ -1198,27 +1204,53 @@ static int dlm_match_nodes(struct dlm_ctxt *dlm, struct dlm_query_nodeinfo *qn)
 			status = -EINVAL;

 		if (!status &&
-		    ((remote->ni_nodenum != local->nd_num) ||
-		     (remote->ni_ipv4_port != local->nd_ipv4_port) ||
-		     (remote->ni_ipv4_address != local->nd_ipv4_address)))
+		    (remote->ni_nodenum != local->nd_num))
+			status = -EINVAL;
+
+		if (!status && (local->nd_ipnet_type == IPV4_TYPE) &&
+		    ((remote->ip_port.ni_ipv4_port != local->nd_ipv4_port) ||
+		     (remote->ip_addr.ni_ipv4_address != local->nd_ipv4_address)))
+			status = -EINVAL;
+		else if (!status && (local->nd_ipnet_type == IPV6_TYPE) &&
+		    ((remote->ip_port.ni_ipv6_port != local->nd_ipv6_port) ||
+		    memcmp(remote->ip_addr.ni_ipv6_address, local->nd_ipv6_address,
+		    sizeof(local->nd_ipv6_address))))
 			status = -EINVAL;

 		if (status) {
-			if (remote && !local)
-				mlog(ML_ERROR, "Domain %s: Node %d (%pI4:%u) "
-				     "registered in joining node %d but not in "
-				     "local node %d\n", qn->qn_domain,
-				     remote->ni_nodenum,
-				     &(remote->ni_ipv4_address),
-				     ntohs(remote->ni_ipv4_port),
-				     qn->qn_nodenum, dlm->node_num);
-			if (local && !remote)
-				mlog(ML_ERROR, "Domain %s: Node %d (%pI4:%u) "
-				     "registered in local node %d but not in "
-				     "joining node %d\n", qn->qn_domain,
-				     local->nd_num, &(local->nd_ipv4_address),
-				     ntohs(local->nd_ipv4_port),
-				     dlm->node_num, qn->qn_nodenum);
+			if (local->nd_ipnet_type == IPV4_TYPE) {
+				if (remote && !local)
+					mlog(ML_ERROR, "Domain %s: Node %d (%pI4:%u) "
+					     "registered in joining node %d but not in "
+					     "local node %d\n", qn->qn_domain,
+					     remote->ni_nodenum,
+					     &(remote->ip_addr.ni_ipv4_address),
+					     ntohs(remote->ip_port.ni_ipv4_port),
+					     qn->qn_nodenum, dlm->node_num);
+				if (local && !remote)
+					mlog(ML_ERROR, "Domain %s: Node %d (%pI4:%u) "
+					     "registered in local node %d but not in "
+					     "joining node %d\n", qn->qn_domain,
+					     local->nd_num, &(local->nd_ipv4_address),
+					     ntohs(local->nd_ipv4_port),
+					     dlm->node_num, qn->qn_nodenum);
+			} else {
+				if (remote && !local)
+					mlog(ML_ERROR, "Domain %s: Node %d (%pI6:%u) "
+					     "registered in joining node %d but not in "
+					     "local node %d\n", qn->qn_domain,
+					     remote->ni_nodenum,
+					     remote->ip_addr.ni_ipv6_address,
+					     ntohs(remote->ip_port.ni_ipv6_port),
+					     qn->qn_nodenum, dlm->node_num);
+				if (local && !remote)
+					mlog(ML_ERROR, "Domain %s: Node %d (%pI6:%u) "
+					     "registered in local node %d but not in "
+					     "joining node %d\n", qn->qn_domain,
+					     local->nd_num, local->nd_ipv6_address,
+					     ntohs(local->nd_ipv6_port),
+					     dlm->node_num, qn->qn_nodenum);
+			}
 			BUG_ON((!local && !remote));
 		}

@@ -1249,11 +1281,20 @@ static int dlm_send_nodeinfo(struct dlm_ctxt *dlm, unsigned long *node_map)
 		node = o2nm_get_node_by_num(i);
 		if (!node)
 			continue;
+		qn->qn_ipnet_type = node->nd_ipnet_type;
 		qn->qn_nodes[count].ni_nodenum = node->nd_num;
-		qn->qn_nodes[count].ni_ipv4_port = node->nd_ipv4_port;
-		qn->qn_nodes[count].ni_ipv4_address = node->nd_ipv4_address;
-		mlog(0, "Node %3d, %pI4:%u\n", node->nd_num,
-		     &(node->nd_ipv4_address), ntohs(node->nd_ipv4_port));
+		if (qn->qn_ipnet_type == IPV4_TYPE) {
+			qn->qn_nodes[count].ip_port.ni_ipv4_port = node->nd_ipv4_port;
+			qn->qn_nodes[count].ip_addr.ni_ipv4_address = node->nd_ipv4_address;
+			mlog(0, "Node %3d, %pI4:%u\n", node->nd_num,
+			     &(node->nd_ipv4_address), ntohs(node->nd_ipv4_port));
+		} else {
+			qn->qn_nodes[count].ip_port.ni_ipv6_port = node->nd_ipv6_port;
+			memcpy(qn->qn_nodes[count].ip_addr.ni_ipv6_address,
+					node->nd_ipv6_address, sizeof(node->nd_ipv6_address));
+			mlog(0, "Node %3d, %pI6:%u\n", node->nd_num,
+			     node->nd_ipv6_address, ntohs(node->nd_ipv6_port));
+		}
 		++count;
 		o2nm_node_put(node);
 	}
-- 
