From: Tao Ma <tao.ma@oracle.com>
Date: Tue Mar  4 23:50:22 2008
Subject: [Ocfs2-devel] [PATCH 1/2] Fix NULL pointer dereference in o2net.
In-Reply-To: <20080305065452.GA26424@tma-pc1.cn.oracle.com>
Message-ID: <20080305074955.GA26597@tma-pc1.cn.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In some situation, we may call ocfs2_set_nn_state with
sc = NULL and vaild = 0 and the connect work will be queued
in these situations. While as sc = NULL, we can't trust
it to get the o2nm_node. So put NULL into o2net_reconnect_delay
as o2net_initialize_handshake does.
Another similar scenario is in o2net_connect_expired where
o2net_idle_timeout also should use NULL.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/cluster/tcp.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/ocfs2/cluster/tcp.c b/fs/ocfs2/cluster/tcp.c
index ee50c96..b8057c5 100644
--- a/fs/ocfs2/cluster/tcp.c
+++ b/fs/ocfs2/cluster/tcp.c
@@ -451,9 +451,9 @@ static void o2net_set_nn_state(struct o2net_node *nn,
 		/* delay if we're withing a RECONNECT_DELAY of the
 		 * last attempt */
 		delay = (nn->nn_last_connect_attempt +
-			 msecs_to_jiffies(o2net_reconnect_delay(sc->sc_node)))
+			 msecs_to_jiffies(o2net_reconnect_delay(NULL)))
 			- jiffies;
-		if (delay > msecs_to_jiffies(o2net_reconnect_delay(sc->sc_node)))
+		if (delay > msecs_to_jiffies(o2net_reconnect_delay(NULL)))
 			delay = 0;
 		mlog(ML_CONN, "queueing conn attempt in %lu jiffies\n", delay);
 		queue_delayed_work(o2net_wq, &nn->nn_connect_work, delay);
@@ -1552,12 +1552,11 @@ static void o2net_connect_expired(struct work_struct *work)
 
 	spin_lock(&nn->nn_lock);
 	if (!nn->nn_sc_valid) {
-		struct o2nm_node *node = nn->nn_sc->sc_node;
 		mlog(ML_ERROR, "no connection established with node %u after "
 		     "%u.%u seconds, giving up and returning errors.\n",
 		     o2net_num_from_nn(nn),
-		     o2net_idle_timeout(node) / 1000,
-		     o2net_idle_timeout(node) % 1000);
+		     o2net_idle_timeout(NULL) / 1000,
+		     o2net_idle_timeout(NULL) % 1000);
 
 		o2net_set_nn_state(nn, NULL, 0, -ENOTCONN);
 	}
-- 
1.5.3.GIT
