From: piaojun <piaojun@huawei.com>
Date: Thu, 25 Oct 2018 18:32:26 +0800
Subject: [Ocfs2-devel] [PATCH 1/5] ocfs2/cluster: add configfs attributes
 for IPv6 address and port
Message-ID: <5BD19BBA.5000707@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

IPv6 address is not compatibile with IPv4, so add configfs attributes for
IPv6 configure.

Signed-off-by: Jun Piao <piaojun@huawei.com>
---
 fs/ocfs2/cluster/nodemanager.c | 45 ++++++++++++++++++++++++++++++++++--------
 fs/ocfs2/cluster/nodemanager.h |  3 +++
 2 files changed, 40 insertions(+), 8 deletions(-)

diff --git a/fs/ocfs2/cluster/nodemanager.c b/fs/ocfs2/cluster/nodemanager.c
index da64c3a..a3c4e61 100644
--- a/fs/ocfs2/cluster/nodemanager.c
+++ b/fs/ocfs2/cluster/nodemanager.c
@@ -192,8 +192,10 @@ static struct o2nm_cluster *to_o2nm_cluster_from_node(struct o2nm_node *node)

 enum {
 	O2NM_NODE_ATTR_NUM = 0,
-	O2NM_NODE_ATTR_PORT,
-	O2NM_NODE_ATTR_ADDRESS,
+	O2NM_NODE_ATTR_IPV4_PORT,
+	O2NM_NODE_ATTR_IPV6_PORT,
+	O2NM_NODE_ATTR_IPV4_ADDRESS,
+	O2NM_NODE_ATTR_IPV6_ADDRESS,
 };

 static ssize_t o2nm_node_num_store(struct config_item *item, const char *page,
@@ -216,8 +218,8 @@ static ssize_t o2nm_node_num_store(struct config_item *item, const char *page,
 	 * node number and try to use our address and port attributes
 	 * to connect to this node.. make sure that they've been set
 	 * before writing the node attribute? */
-	if (!test_bit(O2NM_NODE_ATTR_ADDRESS, &node->nd_set_attributes) ||
-	    !test_bit(O2NM_NODE_ATTR_PORT, &node->nd_set_attributes))
+	if (!test_bit(O2NM_NODE_ATTR_IPV4_ADDRESS, &node->nd_set_attributes) ||
+	    !test_bit(O2NM_NODE_ATTR_IPV4_PORT, &node->nd_set_attributes))
 		return -EINVAL; /* XXX */

 	o2nm_lock_subsystem();
@@ -267,7 +269,7 @@ static ssize_t o2nm_node_ipv4_port_store(struct config_item *item,
 	if (tmp >= (u16)-1)
 		return -ERANGE;

-	if (test_and_set_bit(O2NM_NODE_ATTR_PORT, &node->nd_set_attributes))
+	if (test_and_set_bit(O2NM_NODE_ATTR_IPV4_PORT, &node->nd_set_attributes))
 		return -EBUSY;
 	node->nd_ipv4_port = htons(tmp);

@@ -312,7 +314,7 @@ static ssize_t o2nm_node_ipv4_address_store(struct config_item *item,
 	write_lock(&cluster->cl_nodes_lock);
 	if (o2nm_node_ip_tree_lookup(cluster, ipv4_addr, &p, &parent))
 		ret = -EEXIST;
-	else if (test_and_set_bit(O2NM_NODE_ATTR_ADDRESS,
+	else if (test_and_set_bit(O2NM_NODE_ATTR_IPV4_ADDRESS,
 			&node->nd_set_attributes))
 		ret = -EBUSY;
 	else {
@@ -330,6 +332,29 @@ static ssize_t o2nm_node_ipv4_address_store(struct config_item *item,
 	return count;
 }

+static ssize_t o2nm_node_ipv6_port_show(struct config_item *item, char *page)
+{
+	return 0;
+}
+
+static ssize_t o2nm_node_ipv6_port_store(struct config_item *item,
+					 const char *page, size_t count)
+{
+	return 0;
+}
+
+static ssize_t o2nm_node_ipv6_address_show(struct config_item *item, char *page)
+{
+	return 0;
+}
+
+static ssize_t o2nm_node_ipv6_address_store(struct config_item *item,
+					    const char *page,
+					    size_t count)
+{
+	return 0;
+}
+
 static ssize_t o2nm_node_local_show(struct config_item *item, char *page)
 {
 	return sprintf(page, "%d\n", to_o2nm_node(item)->nd_local);
@@ -352,9 +377,9 @@ static ssize_t o2nm_node_local_store(struct config_item *item, const char *page,

 	/* setting local turns on networking rx for now so we require having
 	 * set everything else first */
-	if (!test_bit(O2NM_NODE_ATTR_ADDRESS, &node->nd_set_attributes) ||
+	if (!test_bit(O2NM_NODE_ATTR_IPV4_ADDRESS, &node->nd_set_attributes) ||
 	    !test_bit(O2NM_NODE_ATTR_NUM, &node->nd_set_attributes) ||
-	    !test_bit(O2NM_NODE_ATTR_PORT, &node->nd_set_attributes))
+	    !test_bit(O2NM_NODE_ATTR_IPV4_PORT, &node->nd_set_attributes))
 		return -EINVAL; /* XXX */

 	o2nm_lock_subsystem();
@@ -400,13 +425,17 @@ static ssize_t o2nm_node_local_store(struct config_item *item, const char *page,

 CONFIGFS_ATTR(o2nm_node_, num);
 CONFIGFS_ATTR(o2nm_node_, ipv4_port);
+CONFIGFS_ATTR(o2nm_node_, ipv6_port);
 CONFIGFS_ATTR(o2nm_node_, ipv4_address);
+CONFIGFS_ATTR(o2nm_node_, ipv6_address);
 CONFIGFS_ATTR(o2nm_node_, local);

 static struct configfs_attribute *o2nm_node_attrs[] = {
 	&o2nm_node_attr_num,
 	&o2nm_node_attr_ipv4_port,
+	&o2nm_node_attr_ipv6_port,
 	&o2nm_node_attr_ipv4_address,
+	&o2nm_node_attr_ipv6_address,
 	&o2nm_node_attr_local,
 	NULL,
 };
diff --git a/fs/ocfs2/cluster/nodemanager.h b/fs/ocfs2/cluster/nodemanager.h
index 09ea2d3..55fdb81 100644
--- a/fs/ocfs2/cluster/nodemanager.h
+++ b/fs/ocfs2/cluster/nodemanager.h
@@ -45,8 +45,11 @@ struct o2nm_node {
 	char			nd_name[O2NM_MAX_NAME_LEN+1]; /* replace? */
 	__u8			nd_num;
 	/* only one address per node, as attributes, for now. */
+	unsigned			nd_ipnet_type:1;  /* 0-ipv4, 1-ipv6 */
 	__be32			nd_ipv4_address;
+	__u8			nd_ipv6_address[16];
 	__be16			nd_ipv4_port;
+	__be16			nd_ipv6_port;
 	struct rb_node		nd_ip_node;
 	/* there can be only one local node for now */
 	int			nd_local;
-- 
