From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Fri, 13 Jun 2014 09:48:24 +0800
Subject: [Ocfs2-devel] [PATCH 3/3] ocfs2: quorum: add a log for node not
	fenced
In-Reply-To: <1402624104-17841-1-git-send-email-junxiao.bi@oracle.com>
References: <1402624104-17841-1-git-send-email-junxiao.bi@oracle.com>
Message-ID: <1402624104-17841-4-git-send-email-junxiao.bi@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

For debug use, we can see from the log whether the fence decision
is made and why it is not fenced.

Reviewed-by: Srinivas Eeda <srinivas.eeda@oracle.com>
Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
---
 fs/ocfs2/cluster/quorum.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/cluster/quorum.c b/fs/ocfs2/cluster/quorum.c
index 1ec141e..62e8ec6 100644
--- a/fs/ocfs2/cluster/quorum.c
+++ b/fs/ocfs2/cluster/quorum.c
@@ -160,9 +160,18 @@ static void o2quo_make_decision(struct work_struct *work)
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
-- 
1.7.9.5
