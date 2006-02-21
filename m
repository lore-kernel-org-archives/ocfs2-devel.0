From: Jeff Mahoney <jeffm@suse.com>
Date: Tue, 21 Feb 2006 11:57:31 -0500
Subject: [Ocfs2-devel] [PATCH 10/14] ocfs2: only disconnect tcp connections
	when the last reference is dropped
Message-ID: <20060221165731.GA11937@locomotive.unixthugs.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


 Since o2net wants all events from any resource, by default it will drop the
 TCP connection when a single resource fails.

 This patch waits until all listeners have been dropped to drop the
 connection.

 fs/ocfs2/cluster/nodemanager.h |    1 +
 fs/ocfs2/cluster/tcp.c         |    7 +++++--
 2 files changed, 6 insertions(+), 2 deletions(-)

Signed-off-by: Jeff Mahoney <jeffm@suse.com>

diff -ruNpX ../dontdiff linux-2.6.16-rc4.ocfs2-staging1/fs/ocfs2/cluster/nodemanager.h linux-2.6.16-rc4.ocfs2-staging2/fs/ocfs2/cluster/nodemanager.h
--- linux-2.6.16-rc4.ocfs2-staging1/fs/ocfs2/cluster/nodemanager.h	2006-02-21 11:44:46.000000000 -0500
+++ linux-2.6.16-rc4.ocfs2-staging2/fs/ocfs2/cluster/nodemanager.h	2006-02-21 11:44:46.000000000 -0500
@@ -51,6 +51,7 @@ struct o2nm_node {
 	int			nd_local;
 
 	unsigned long		nd_set_attributes;
+	atomic_t		nd_count;
 };
 
 struct o2nm_cluster {
diff -ruNpX ../dontdiff linux-2.6.16-rc4.ocfs2-staging1/fs/ocfs2/cluster/tcp.c linux-2.6.16-rc4.ocfs2-staging2/fs/ocfs2/cluster/tcp.c
--- linux-2.6.16-rc4.ocfs2-staging1/fs/ocfs2/cluster/tcp.c	2006-02-21 11:44:46.000000000 -0500
+++ linux-2.6.16-rc4.ocfs2-staging2/fs/ocfs2/cluster/tcp.c	2006-02-21 11:44:46.000000000 -0500
@@ -1471,8 +1471,10 @@ void o2net_disconnect_node(struct o2nm_n
 static void o2net_hb_node_down_cb(struct o2nm_node *node, int node_num,
 				  void *data)
 {
-	if (node_num != o2nm_this_node())
-		o2net_disconnect_node(node);
+	if (node_num != o2nm_this_node()) {
+		if (atomic_dec_and_test(&node->nd_count))
+			o2net_disconnect_node(node);
+	}
 }
 
 static void o2net_hb_node_up_cb(struct o2nm_node *node, int node_num,
@@ -1485,6 +1487,7 @@ static void o2net_hb_node_up_cb(struct o
 		(msecs_to_jiffies(O2NET_RECONNECT_DELAY_MS) + 1);
 
 	if (node_num != o2nm_this_node()) {
+		atomic_inc(&node->nd_count);
 		/* heartbeat doesn't work unless a local node number is
 		 * configured and doing so brings up the o2net_wq, so we can
 		 * use it.. */
