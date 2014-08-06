From: akpm at linux-foundation.org <akpm@linux-foundation.org>
Date: Wed, 06 Aug 2014 13:32:09 -0700
Subject: [Ocfs2-devel] [patch 05/10] ocfs2: quorum: add a log for node not
	fenced
Message-ID: <53e290c9.EQXL/jgd0x3ijQtm%akpm@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Junxiao Bi <junxiao.bi@oracle.com>
Subject: ocfs2: quorum: add a log for node not fenced

For debug use, we can see from the log whether the fence decision is made
and why it is not fenced.

Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
Reviewed-by: Srinivas Eeda <srinivas.eeda@oracle.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Joseph Qi <joseph.qi@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/cluster/quorum.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff -puN fs/ocfs2/cluster/quorum.c~ocfs2-quorum-add-a-log-for-node-not-fenced fs/ocfs2/cluster/quorum.c
--- a/fs/ocfs2/cluster/quorum.c~ocfs2-quorum-add-a-log-for-node-not-fenced
+++ a/fs/ocfs2/cluster/quorum.c
@@ -160,9 +160,18 @@ static void o2quo_make_decision(struct w
 	}
 
 out:
-	spin_unlock(&qs->qs_lock);
-	if (fence)
+	if (fence) {
+		spin_unlock(&qs->qs_lock);
 		o2quo_fence_self();
+	} else {
+		mlog(ML_NOTICE, "not fencing this node, heartbeating: %d, "
+			"connected: %d, lowest: %d (%sreachable)\n",
+			qs->qs_heartbeating, qs->qs_connected, lowest_hb,
+			lowest_reachable ? "" : "un");
+		spin_unlock(&qs->qs_lock);
+
+	}
+
 }
 
 static void o2quo_set_hold(struct o2quo_state *qs, u8 node)
_
