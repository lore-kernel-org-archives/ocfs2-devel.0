From: akpm at linux-foundation.org <akpm@linux-foundation.org>
Date: Tue, 27 Aug 2013 14:05:14 -0700
Subject: [Ocfs2-devel] [patch 20/22] ocfs2: avoid possible NULL pointer
	dereference in o2net_accept_one()
Message-ID: <20130827210514.AE12131C129@corp2gmr1-1.hot.corp.google.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Joseph Qi <joseph.qi@huawei.com>
Subject: ocfs2: avoid possible NULL pointer dereference in o2net_accept_one()

Since o2nm_get_node_by_num() may return NULL, we add this check in
o2net_accept_one() to avoid possible NULL pointer dereference.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/cluster/tcp.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff -puN fs/ocfs2/cluster/tcp.c~ocfs2-avoid-possible-null-pointer-dereference-in-o2net_accept_one fs/ocfs2/cluster/tcp.c
--- a/fs/ocfs2/cluster/tcp.c~ocfs2-avoid-possible-null-pointer-dereference-in-o2net_accept_one
+++ a/fs/ocfs2/cluster/tcp.c
@@ -1873,12 +1873,16 @@ static int o2net_accept_one(struct socke
 
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
_
