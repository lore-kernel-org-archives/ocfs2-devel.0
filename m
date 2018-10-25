From: piaojun <piaojun@huawei.com>
Date: Thu, 25 Oct 2018 18:34:11 +0800
Subject: [Ocfs2-devel] [PATCH 2/5] ocfs2/cluster: implement show & store
 method for IPv6 attribute
Message-ID: <5BD19C23.4000405@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Implement o2nm_node_ipv6_port_show(), o2nm_node_ipv6_port_store(),
o2nm_node_ipv6_address_show and o2nm_node_ipv6_address_store which used
for configuring IPv6 node information.

Signed-off-by: Jun Piao <piaojun@huawei.com>
---
 fs/ocfs2/cluster/nodemanager.c | 108 ++++++++++++++++++++++++++++++++++-------
 fs/ocfs2/cluster/nodemanager.h |   6 +++
 2 files changed, 96 insertions(+), 18 deletions(-)

diff --git a/fs/ocfs2/cluster/nodemanager.c b/fs/ocfs2/cluster/nodemanager.c
index a3c4e61..292f5dd 100644
--- a/fs/ocfs2/cluster/nodemanager.c
+++ b/fs/ocfs2/cluster/nodemanager.c
@@ -78,7 +78,7 @@ int o2nm_configured_node_map(unsigned long *map, unsigned bytes)
 EXPORT_SYMBOL_GPL(o2nm_configured_node_map);

 static struct o2nm_node *o2nm_node_ip_tree_lookup(struct o2nm_cluster *cluster,
-						  __be32 ip_needle,
+						  u8 ip_needle[],
 						  struct rb_node ***ret_p,
 						  struct rb_node **ret_parent)
 {
@@ -91,9 +91,12 @@ static struct o2nm_node *o2nm_node_ip_tree_lookup(struct o2nm_cluster *cluster,

 		parent = *p;
 		node = rb_entry(parent, struct o2nm_node, nd_ip_node);
-
-		cmp = memcmp(&ip_needle, &node->nd_ipv4_address,
-				sizeof(ip_needle));
+		if (node->nd_ipnet_type == IPV4_TYPE)
+			cmp = memcmp(ip_needle, &node->nd_ipv4_address,
+					sizeof(node->nd_ipv4_address));
+		else
+			cmp = memcmp(ip_needle, node->nd_ipv6_address,
+					sizeof(node->nd_ipv6_address));
 		if (cmp < 0)
 			p = &(*p)->rb_left;
 		else if (cmp > 0)
@@ -121,7 +124,7 @@ struct o2nm_node *o2nm_get_node_by_ip(__be32 addr)
 		goto out;

 	read_lock(&cluster->cl_nodes_lock);
-	node = o2nm_node_ip_tree_lookup(cluster, addr, NULL, NULL);
+	node = o2nm_node_ip_tree_lookup(cluster, (u8 *)&addr, NULL, NULL);
 	if (node)
 		config_item_get(&node->nd_item);
 	read_unlock(&cluster->cl_nodes_lock);
@@ -218,9 +221,14 @@ static ssize_t o2nm_node_num_store(struct config_item *item, const char *page,
 	 * node number and try to use our address and port attributes
 	 * to connect to this node.. make sure that they've been set
 	 * before writing the node attribute? */
-	if (!test_bit(O2NM_NODE_ATTR_IPV4_ADDRESS, &node->nd_set_attributes) ||
-	    !test_bit(O2NM_NODE_ATTR_IPV4_PORT, &node->nd_set_attributes))
-		return -EINVAL; /* XXX */
+	if ((node->nd_ipnet_type == IPV4_TYPE) &&
+	    (!test_bit(O2NM_NODE_ATTR_IPV4_ADDRESS, &node->nd_set_attributes) ||
+	    !test_bit(O2NM_NODE_ATTR_IPV4_PORT, &node->nd_set_attributes)))
+		return -EINVAL;
+	else if ((node->nd_ipnet_type == IPV6_TYPE) &&
+	    (!test_bit(O2NM_NODE_ATTR_IPV6_ADDRESS, &node->nd_set_attributes) ||
+	    !test_bit(O2NM_NODE_ATTR_IPV6_PORT, &node->nd_set_attributes)))
+		return -EINVAL;

 	o2nm_lock_subsystem();
 	cluster = to_o2nm_cluster_from_node(node);
@@ -312,7 +320,7 @@ static ssize_t o2nm_node_ipv4_address_store(struct config_item *item,

 	ret = 0;
 	write_lock(&cluster->cl_nodes_lock);
-	if (o2nm_node_ip_tree_lookup(cluster, ipv4_addr, &p, &parent))
+	if (o2nm_node_ip_tree_lookup(cluster, (u8 *)&ipv4_addr, &p, &parent))
 		ret = -EEXIST;
 	else if (test_and_set_bit(O2NM_NODE_ATTR_IPV4_ADDRESS,
 			&node->nd_set_attributes))
@@ -328,31 +336,86 @@ static ssize_t o2nm_node_ipv4_address_store(struct config_item *item,
 		return ret;

 	memcpy(&node->nd_ipv4_address, &ipv4_addr, sizeof(ipv4_addr));
+	node->nd_ipnet_type = IPV4_TYPE;

 	return count;
 }

 static ssize_t o2nm_node_ipv6_port_show(struct config_item *item, char *page)
 {
-	return 0;
+	return sprintf(page, "%u\n", ntohs(to_o2nm_node(item)->nd_ipv6_port));
 }

 static ssize_t o2nm_node_ipv6_port_store(struct config_item *item,
 					 const char *page, size_t count)
 {
-	return 0;
+	struct o2nm_node *node = to_o2nm_node(item);
+	unsigned long tmp;
+	char *p = (char *)page;
+
+	tmp = simple_strtoul(p, &p, 0);
+	if (!p || (*p && (*p != '\n')))
+		return -EINVAL;
+
+	if (tmp == 0)
+		return -EINVAL;
+	if (tmp >= (u16)-1)
+		return -ERANGE;
+
+	if (test_and_set_bit(O2NM_NODE_ATTR_IPV6_PORT, &node->nd_set_attributes))
+		return -EBUSY;
+	node->nd_ipv6_port = htons(tmp);
+
+	return count;
 }

 static ssize_t o2nm_node_ipv6_address_show(struct config_item *item, char *page)
 {
-	return 0;
+	return sprintf(page, "%pI6\n", to_o2nm_node(item)->nd_ipv6_address);
 }

 static ssize_t o2nm_node_ipv6_address_store(struct config_item *item,
 					    const char *page,
 					    size_t count)
 {
-	return 0;
+	struct o2nm_node *node = to_o2nm_node(item);
+	struct o2nm_cluster *cluster;
+	int ret;
+	struct rb_node **p, *parent;
+	u8 ipv6_addr[16] = {0};
+
+	ret = in6_pton((const char *)page, count, ipv6_addr, -1, NULL);
+	if (ret != 1)
+		return -EINVAL;
+
+	o2nm_lock_subsystem();
+	cluster = to_o2nm_cluster_from_node(node);
+	if (!cluster) {
+		o2nm_unlock_subsystem();
+		return -EINVAL;
+	}
+
+	ret = 0;
+	write_lock(&cluster->cl_nodes_lock);
+	if (o2nm_node_ip_tree_lookup(cluster, ipv6_addr, &p, &parent))
+		ret = -EEXIST;
+	else if (test_and_set_bit(O2NM_NODE_ATTR_IPV6_ADDRESS,
+			&node->nd_set_attributes))
+		ret = -EBUSY;
+	else {
+		rb_link_node(&node->nd_ip_node, parent, p);
+		rb_insert_color(&node->nd_ip_node, &cluster->cl_node_ip_tree);
+	}
+	write_unlock(&cluster->cl_nodes_lock);
+	o2nm_unlock_subsystem();
+
+	if (ret)
+		return ret;
+
+	memcpy(node->nd_ipv6_address, ipv6_addr, sizeof(ipv6_addr));
+	node->nd_ipnet_type = IPV6_TYPE;
+
+	return count;
 }

 static ssize_t o2nm_node_local_show(struct config_item *item, char *page)
@@ -377,10 +440,16 @@ static ssize_t o2nm_node_local_store(struct config_item *item, const char *page,

 	/* setting local turns on networking rx for now so we require having
 	 * set everything else first */
-	if (!test_bit(O2NM_NODE_ATTR_IPV4_ADDRESS, &node->nd_set_attributes) ||
-	    !test_bit(O2NM_NODE_ATTR_NUM, &node->nd_set_attributes) ||
-	    !test_bit(O2NM_NODE_ATTR_IPV4_PORT, &node->nd_set_attributes))
-		return -EINVAL; /* XXX */
+	if (!test_bit(O2NM_NODE_ATTR_NUM, &node->nd_set_attributes))
+		return -EINVAL;
+	if ((node->nd_ipnet_type == IPV4_TYPE) &&
+	    (!test_bit(O2NM_NODE_ATTR_IPV4_ADDRESS, &node->nd_set_attributes) ||
+	    !test_bit(O2NM_NODE_ATTR_IPV4_PORT, &node->nd_set_attributes)))
+		return -EINVAL;
+	else if ((node->nd_ipnet_type == IPV6_TYPE) &&
+	    (!test_bit(O2NM_NODE_ATTR_IPV6_ADDRESS, &node->nd_set_attributes) ||
+	    !test_bit(O2NM_NODE_ATTR_IPV6_PORT, &node->nd_set_attributes)))
+		return -EINVAL;

 	o2nm_lock_subsystem();
 	cluster = to_o2nm_cluster_from_node(node);
@@ -649,6 +718,7 @@ static void o2nm_node_group_drop_item(struct config_group *group,
 {
 	struct o2nm_node *node = to_o2nm_node(item);
 	struct o2nm_cluster *cluster = to_o2nm_cluster(group->cg_item.ci_parent);
+	u8 ipv6_addr[16] = {0};

 	o2net_disconnect_node(node);

@@ -664,7 +734,9 @@ static void o2nm_node_group_drop_item(struct config_group *group,
 	write_lock(&cluster->cl_nodes_lock);

 	/* XXX sloppy */
-	if (node->nd_ipv4_address)
+	if ((node->nd_ipnet_type == IPV4_TYPE && node->nd_ipv4_address) ||
+			(node->nd_ipnet_type == IPV6_TYPE &&
+			memcmp(ipv6_addr, node->nd_ipv6_address, sizeof(ipv6_addr))))
 		rb_erase(&node->nd_ip_node, &cluster->cl_node_ip_tree);

 	/* nd_num might be 0 if the node number hasn't been set.. */
diff --git a/fs/ocfs2/cluster/nodemanager.h b/fs/ocfs2/cluster/nodemanager.h
index 55fdb81..1f3cfc5 100644
--- a/fs/ocfs2/cluster/nodemanager.h
+++ b/fs/ocfs2/cluster/nodemanager.h
@@ -39,6 +39,12 @@ enum o2nm_fence_method {
 	O2NM_FENCE_METHODS,	/* Number of fence methods */
 };

+enum ipnet_type {
+	IPV4_TYPE = 0,
+	IPV6_TYPE,
+	INVALID_IPNET_TYPE,
+};
+
 struct o2nm_node {
 	spinlock_t		nd_lock;
 	struct config_item	nd_item;
-- 
