From: Jia Guo <guojia12@huawei.com>
Date: Fri, 25 Jan 2019 14:05:51 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix a panic problem caused by o2cb_ctl
Message-ID: <00174f72-6e5f-e049-2144-d0bb177e24a5@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In the process of creating a node, it will cause NULL pointer reference
in kernel if o2cb_ctl failed in the interval
(mkdir, o2cb_set_node_attribute(node_num)] in function o2cb_add_node.

The node num is initialized to 0 in function o2nm_node_group_make_item,
o2nm_node_group_drop_item will mistake the node number 0 for a
valid node number when we delete the node before the node number is set
correctly. If the local node number of the current host happens to be 0,
cluster->cl_local_node will be set to O2NM_INVALID_NODE_NUM while
o2hb_thread still running. The panic stack is generated as follows:

o2hb_thread
    \-o2hb_do_disk_heartbeat
        \-o2hb_check_own_slot
            |-slot = &reg->hr_slots[o2nm_this_node()];
            //o2nm_this_node() return O2NM_INVALID_NODE_NUM

We need to check whether the node number is set when we delete the node.

Signed-off-by: Jia Guo <guojia12@huawei.com>
---
 fs/ocfs2/cluster/nodemanager.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/cluster/nodemanager.c b/fs/ocfs2/cluster/nodemanager.c
index 0e4166c..992ccc0 100644
--- a/fs/ocfs2/cluster/nodemanager.c
+++ b/fs/ocfs2/cluster/nodemanager.c
@@ -620,10 +620,16 @@ static void o2nm_node_group_drop_item(struct config_group *group,
 {
 	struct o2nm_node *node = to_o2nm_node(item);
 	struct o2nm_cluster *cluster = to_o2nm_cluster(group->cg_item.ci_parent);
+	int nd_num_set = 0;

-	o2net_disconnect_node(node);
+	/* nd_num might be 0 if the node number hasn't been set.. */
+	if (cluster->cl_nodes[node->nd_num] == node) {
+		nd_num_set = 1;
+
+	if (nd_num_set)
+		o2net_disconnect_node(node);

-	if (cluster->cl_has_local &&
+	if (nd_num_set && cluster->cl_has_local &&
 	    (cluster->cl_local_node == node->nd_num)) {
 		cluster->cl_has_local = 0;
 		cluster->cl_local_node = O2NM_INVALID_NODE_NUM;
@@ -638,8 +644,7 @@ static void o2nm_node_group_drop_item(struct config_group *group,
 	if (node->nd_ipv4_address)
 		rb_erase(&node->nd_ip_node, &cluster->cl_node_ip_tree);

-	/* nd_num might be 0 if the node number hasn't been set.. */
-	if (cluster->cl_nodes[node->nd_num] == node) {
+	if (nd_num_set) {
 		cluster->cl_nodes[node->nd_num] = NULL;
 		clear_bit(node->nd_num, cluster->cl_nodes_bitmap);
 	}
