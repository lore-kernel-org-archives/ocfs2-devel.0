From: akpm at linux-foundation.org <akpm@linux-foundation.org>
Date: Tue, 27 Aug 2013 14:05:01 -0700
Subject: [Ocfs2-devel] [patch 09/22] fs/ocfs2/cluster/tcp.c: fix possible
	null pointer dereferences
Message-ID: <20130827210502.1C1955A42C7@corp2gmr1-2.hot.corp.google.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Sunil Mushran <sunil.mushran@oracle.com>
Subject: fs/ocfs2/cluster/tcp.c: fix possible null pointer dereferences

Fix some possible null pointer dereferences that were detected by the
static code analyser, smatch.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
Reported-by: Dan Carpenter <error27@gmail.com>
Reported-by: Guozhonghua <guozhonghua@h3c.com>
Cc: Sunil Mushran <sunil.mushran@gmail.com>
Cc: Joseph Qi <joseph.qi@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/cluster/tcp.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN fs/ocfs2/cluster/tcp.c~fs-ocfs2-cluster-tcpc-fix-possible-null-pointer-dereferences fs/ocfs2/cluster/tcp.c
--- a/fs/ocfs2/cluster/tcp.c~fs-ocfs2-cluster-tcpc-fix-possible-null-pointer-dereferences
+++ a/fs/ocfs2/cluster/tcp.c
@@ -543,8 +543,9 @@ static void o2net_set_nn_state(struct o2
 	}
 
 	if (was_valid && !valid) {
-		printk(KERN_NOTICE "o2net: No longer connected to "
-		       SC_NODEF_FMT "\n", SC_NODEF_ARGS(old_sc));
+		if (old_sc)
+			printk(KERN_NOTICE "o2net: No longer connected to "
+				SC_NODEF_FMT "\n", SC_NODEF_ARGS(old_sc));
 		o2net_complete_nodes_nsw(nn);
 	}
 
@@ -1695,13 +1696,12 @@ static void o2net_start_connect(struct w
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
_
