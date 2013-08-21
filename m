From: Joseph Qi <joseph.qi@huawei.com>
Date: Wed, 21 Aug 2013 15:02:26 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: avoid possible NULL pointer
	dereference in o2net_accept_one()
Message-ID: <52146602.1040905@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Since o2nm_get_node_by_num() may return NULL, we add this check in
o2net_accept_one() to avoid possible NULL pointer dereference.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
---
 fs/ocfs2/cluster/tcp.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/fs/ocfs2/cluster/tcp.c b/fs/ocfs2/cluster/tcp.c
index aa88bd8..ec2696f 100644
--- a/fs/ocfs2/cluster/tcp.c
+++ b/fs/ocfs2/cluster/tcp.c
@@ -1870,12 +1870,16 @@ static int o2net_accept_one(struct socket *sock)
 
 	if (o2nm_this_node() >= node->nd_num) {
 		local_node = o2nm_get_node_by_num(o2nm_this_node());
-		printk(KERN_NOTICE "o2net: Unexpected connect attempt seen "
-		       "at node '%s' (%u, %pI4:%d) from node '%s' (%u, "
-		       "%pI4:%d)\n", local_node->nd_name, local_node->nd_num,
-		       &(local_node->nd_ipv4_address),
-		       ntohs(local_node->nd_ipv4_port), node->nd_name,
-		       node->nd_num, &sin.sin_addr.s_addr, ntohs(sin.sin_port));
+		if (local_node)
+			printk(KERN_NOTICE "o2net: Unexpected connect attempt "
+					"seen at node '%s' (%u, %pI4:%d) from "
+					"node '%s' (%u, %pI4:%d)\n",
+					local_node->nd_name, local_node->nd_num,
+					&(local_node->nd_ipv4_address),
+					ntohs(local_node->nd_ipv4_port),
+					node->nd_name,
+					node->nd_num, &sin.sin_addr.s_addr,
+					ntohs(sin.sin_port));
 		ret = -EINVAL;
 		goto out;
 	}
-- 
1.7.9.7
