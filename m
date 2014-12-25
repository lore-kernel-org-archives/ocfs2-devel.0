From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Thu, 25 Dec 2014 13:52:17 +0800
Subject: [Ocfs2-devel] [PATCH 2/2] ocfs2: fix wrong comment
In-Reply-To: <1419486737-16102-1-git-send-email-junxiao.bi@oracle.com>
References: <1419486737-16102-1-git-send-email-junxiao.bi@oracle.com>
Message-ID: <1419486737-16102-2-git-send-email-junxiao.bi@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

O2NET_CONN_IDLE_DELAY is not defined, connection attempts will not be
canceled due to timeout.

Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
---
 fs/ocfs2/cluster/tcp_internal.h |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/ocfs2/cluster/tcp_internal.h b/fs/ocfs2/cluster/tcp_internal.h
index dc02436..b95e7df 100644
--- a/fs/ocfs2/cluster/tcp_internal.h
+++ b/fs/ocfs2/cluster/tcp_internal.h
@@ -107,12 +107,12 @@ struct o2net_node {
 	struct list_head		nn_status_list;
 
 	/* connects are attempted from when heartbeat comes up until either hb
-	 * goes down, the node is unconfigured, no connect attempts succeed
-	 * before O2NET_CONN_IDLE_DELAY, or a connect succeeds.  connect_work
-	 * is queued from set_nn_state both from hb up and from itself if a
-	 * connect attempt fails and so can be self-arming.  shutdown is
-	 * careful to first mark the nn such that no connects will be attempted
-	 * before canceling delayed connect work and flushing the queue. */
+	 * goes down, the node is unconfigured, or a connect succeeds.
+	 * connect_work is queued from set_nn_state both from hb up and from
+	 * itself if a connect attempt fails and so can be self-arming.
+	 * shutdown is careful to first mark the nn such that no connects will
+	 * be attempted before canceling delayed connect work and flushing the
+	 * queue. */
 	struct delayed_work		nn_connect_work;
 	unsigned long			nn_last_connect_attempt;
 
-- 
1.7.9.5
