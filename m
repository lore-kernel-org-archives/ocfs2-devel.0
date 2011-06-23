From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu, 23 Jun 2011 15:31:07 -0700
Subject: [Ocfs2-devel] [PATCH 13/13] ocfs2/cluster: Cluster up now includes
	network connections too
In-Reply-To: <1308868267-5981-1-git-send-email-sunil.mushran@oracle.com>
References: <1308868267-5981-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1308868267-5981-14-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The cluster up check only checks to see if the node is heartbeating or not.
If yes it continues assuming that the node is connected to all the nodes. But
if that is not the case, the cluster join aborts with a stack of errors that
are not easy to comprehend.

This patch adds the network connect check upfront and prints the nodes that
the node is not yet connected to, before aborting.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/dlm/dlmdomain.c |    7 ------
 fs/ocfs2/stack_o2cb.c    |   55 +++++++++++++++++++++++++++++++++++++++++----
 2 files changed, 50 insertions(+), 12 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmdomain.c b/fs/ocfs2/dlm/dlmdomain.c
index 200d988..92f2ead 100644
--- a/fs/ocfs2/dlm/dlmdomain.c
+++ b/fs/ocfs2/dlm/dlmdomain.c
@@ -2138,13 +2138,6 @@ struct dlm_ctxt * dlm_register_domain(const char *domain,
 		goto leave;
 	}
 
-	if (!o2hb_check_local_node_heartbeating()) {
-		mlog(ML_ERROR, "the local node has not been configured, or is "
-		     "not heartbeating\n");
-		ret = -EPROTO;
-		goto leave;
-	}
-
 	mlog(0, "register called for domain \"%s\"\n", domain);
 
 retry:
diff --git a/fs/ocfs2/stack_o2cb.c b/fs/ocfs2/stack_o2cb.c
index be935d8..4dca464 100644
--- a/fs/ocfs2/stack_o2cb.c
+++ b/fs/ocfs2/stack_o2cb.c
@@ -28,6 +28,7 @@
 #include "cluster/masklog.h"
 #include "cluster/nodemanager.h"
 #include "cluster/heartbeat.h"
+#include "cluster/tcp.h"
 
 #include "stackglue.h"
 
@@ -256,6 +257,51 @@ static void o2cb_dump_lksb(struct ocfs2_dlm_lksb *lksb)
 }
 
 /*
+ * Check if this node is heartbeating and is connected to all other
+ * heartbeating nodes. Return 1 if true, else 0.
+ */
+static int o2cb_cluster_check(void)
+{
+	u8 node_num;
+	int i;
+	unsigned long hbmap[BITS_TO_LONGS(O2NM_MAX_NODES)];
+	unsigned long netmap[BITS_TO_LONGS(O2NM_MAX_NODES)];
+
+	node_num = o2nm_this_node();
+	if (node_num == O2NM_MAX_NODES) {
+		printk(KERN_ERR "o2cb: This node has not been configured.\n");
+		return 0;
+	}
+
+	o2hb_fill_node_map(hbmap, sizeof(hbmap));
+	if (!test_bit(node_num, hbmap)) {
+		printk(KERN_ERR "o2cb: %s heartbeat has not been started.\n",
+		       (o2hb_global_heartbeat_active() ? "Global" : "Local"));
+		return 0;
+	}
+
+	/*
+	 * As o2net does not make a loopback connection, the bit for this node
+	 * is not set. Force set it before comparing it to hbmap.
+	 */
+	o2net_fill_node_map(netmap, sizeof(netmap));
+	set_bit(node_num, netmap);
+	if (!memcmp(hbmap, netmap, sizeof(hbmap)))
+		return 1;
+
+	printk(KERN_ERR "o2cb: This node is not connected to nodes:");
+	i = -1;
+	while ((i = find_next_bit(hbmap, O2NM_MAX_NODES,
+				  i + 1)) < O2NM_MAX_NODES) {
+		if (!test_bit(i, netmap))
+			printk(" %u", i);
+	}
+	printk(".\n");
+
+	return 0;
+}
+
+/*
  * Called from the dlm when it's about to evict a node. This is how the
  * classic stack signals node death.
  */
@@ -280,11 +326,10 @@ static int o2cb_cluster_connect(struct ocfs2_cluster_connection *conn)
 	BUG_ON(conn == NULL);
 	BUG_ON(conn->cc_proto == NULL);
 
-	/* for now we only have one cluster/node, make sure we see it
-	 * in the heartbeat universe */
-	if (!o2hb_check_local_node_heartbeating()) {
-		if (o2hb_global_heartbeat_active())
-			mlog(ML_ERROR, "Global heartbeat not started\n");
+	/* Ensure cluster stack is up and all nodes are connected */
+	if (!o2cb_cluster_check()) {
+		printk(KERN_ERR "o2cb: Cluster check failed. Fix errors "
+		       "before retrying.\n");
 		rc = -EINVAL;
 		goto out;
 	}
-- 
1.7.4.1
