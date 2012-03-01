From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu,  1 Mar 2012 11:34:15 -0800
Subject: [Ocfs2-devel] [PATCH 1/9] ocfs2/cluster: Fix possible null pointer
	dereference
Message-ID: <1330630463-30305-1-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Patch fixes some possible null pointer dereferences that were detected by the
static code analyser, smatch.

Reported-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/cluster/tcp.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/ocfs2/cluster/tcp.c b/fs/ocfs2/cluster/tcp.c
index 044e7b5..bf9494d 100644
--- a/fs/ocfs2/cluster/tcp.c
+++ b/fs/ocfs2/cluster/tcp.c
@@ -546,8 +546,9 @@ static void o2net_set_nn_state(struct o2net_node *nn,
 	}
 
 	if (was_valid && !valid) {
-		printk(KERN_NOTICE "o2net: No longer connected to "
-		       SC_NODEF_FMT "\n", SC_NODEF_ARGS(old_sc));
+		if (old_sc)
+			printk(KERN_NOTICE "o2net: No longer connected to "
+			       SC_NODEF_FMT "\n", SC_NODEF_ARGS(old_sc));
 		o2net_complete_nodes_nsw(nn);
 	}
 
@@ -1700,13 +1701,12 @@ static void o2net_start_connect(struct work_struct *work)
 		ret = 0;
 
 out:
-	if (ret) {
+	if (ret && sc) {
 		printk(KERN_NOTICE "o2net: Connect attempt to " SC_NODEF_FMT
 		       " failed with errno %d\n", SC_NODEF_ARGS(sc), ret);
 		/* 0 err so that another will be queued and attempted
 		 * from set_nn_state */
-		if (sc)
-			o2net_ensure_shutdown(nn, sc, 0);
+		o2net_ensure_shutdown(nn, sc, 0);
 	}
 	if (sc)
 		sc_put(sc);
-- 
1.7.7.6
