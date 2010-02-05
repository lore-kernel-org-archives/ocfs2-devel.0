From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Fri,  5 Feb 2010 15:41:23 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2/cluster: Make o2net connect messages
	KERN_NOTICE
Message-ID: <1265413284-17330-1-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Connect and disconnect messages are more than informational as they are required
during root cause analysis for failures. This patch changes them from KERN_INFO
to KERN_NOTICE.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/cluster/tcp.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/cluster/tcp.c b/fs/ocfs2/cluster/tcp.c
index 4b8279e..b70be4c 100644
--- a/fs/ocfs2/cluster/tcp.c
+++ b/fs/ocfs2/cluster/tcp.c
@@ -486,7 +486,7 @@ static void o2net_set_nn_state(struct o2net_node *nn,
 	}
 
 	if (was_valid && !valid) {
-		printk(KERN_INFO "o2net: no longer connected to "
+		printk(KERN_NOTICE "o2net: no longer connected to "
 		       SC_NODEF_FMT "\n", SC_NODEF_ARGS(old_sc));
 		o2net_complete_nodes_nsw(nn);
 	}
@@ -494,7 +494,7 @@ static void o2net_set_nn_state(struct o2net_node *nn,
 	if (!was_valid && valid) {
 		o2quo_conn_up(o2net_num_from_nn(nn));
 		cancel_delayed_work(&nn->nn_connect_expired);
-		printk(KERN_INFO "o2net: %s " SC_NODEF_FMT "\n",
+		printk(KERN_NOTICE "o2net: %s " SC_NODEF_FMT "\n",
 		       o2nm_this_node() > sc->sc_node->nd_num ?
 		       		"connected to" : "accepted connection from",
 		       SC_NODEF_ARGS(sc));
@@ -1477,7 +1477,7 @@ static void o2net_idle_timer(unsigned long data)
 
 	do_gettimeofday(&now);
 
-	printk(KERN_INFO "o2net: connection to " SC_NODEF_FMT " has been idle for %u.%u "
+	printk(KERN_NOTICE "o2net: connection to " SC_NODEF_FMT " has been idle for %u.%u "
 	     "seconds, shutting it down.\n", SC_NODEF_ARGS(sc),
 		     o2net_idle_timeout() / 1000,
 		     o2net_idle_timeout() % 1000);
-- 
1.6.3.3
