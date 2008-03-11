From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Tue Mar 11 16:32:25 2008
Subject: [Ocfs2-devel] [PATCH 18/18] ocfs2: Fix NULL pointer dereferences in
	o2net
In-Reply-To: <1205278329-11111-1-git-send-email-sunil.mushran@oracle.com>
References: <1205278329-11111-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1205278329-11111-19-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mainline commit cdef59a94c2fc962ada379d4240d556db7b56d55
Author: Tao Ma <tao.ma@oracle.com>
Date: Wed, 5 Mar 2008 15:49:55 +0800

In some situations, ocfs2_set_nn_state might get called with sc = NULL and
valid = 0. If sc = NULL, we can't dereference it to get the o2nm_node
member. Instead, do what o2net_initialize_handshake does and use NULL when
calling o2net_reconnect_delay and o2net_idle_timeout.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
---
 fs/ocfs2/cluster/tcp.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/ocfs2/cluster/tcp.c b/fs/ocfs2/cluster/tcp.c
index 6dbdee0..090018a 100644
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
@@ -1583,12 +1583,11 @@ static void o2net_connect_expired(kapi_work_struct_t *work)
 
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
1.5.3.4
