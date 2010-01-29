From: Srinivas Eeda <srinivas.eeda@ORACLE.COM>
Date: Thu, 28 Jan 2010 20:51:11 -0800
Subject: [Ocfs2-devel] [PATCH 3/3] o2net: correct keepalive message protocol
In-Reply-To: <1264740671-908-1-git-send-email-srinivas.eeda@oracle.com>
References: <1264740671-908-1-git-send-email-srinivas.eeda@oracle.com>
Message-ID: <1264740671-908-4-git-send-email-srinivas.eeda@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Currently keepalive packet is sent to another node if a message is not heard
from the other node for O2NET_KEEPALIVE_DELAY_MS seconds. The message is not
resent again till the other node sends a message.

The functionality described above works as we rely on TCP protocol which
guarantees message delivery. However the intention of this feature was to send
a keepalive message every timeout seconds. This patch corrects the
functionality. Now since each node sends a message for every keepalive time
interval, there is no need for a response for the keepalive message.

Signed-off-by: Srinivas Eeda <srinivas.eeda@oracle.com>
---
 fs/ocfs2/cluster/tcp.c |   16 ++++++++++------
 1 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/fs/ocfs2/cluster/tcp.c b/fs/ocfs2/cluster/tcp.c
index 0bbd47b..8a999ec 100644
--- a/fs/ocfs2/cluster/tcp.c
+++ b/fs/ocfs2/cluster/tcp.c
@@ -1160,8 +1160,9 @@ static int o2net_process_message(struct o2net_sock_container *sc,
 					   be32_to_cpu(hdr->status));
 			goto out;
 		case O2NET_MSG_KEEP_REQ_MAGIC:
-			o2net_sendpage(sc, o2net_keep_resp,
-				       sizeof(*o2net_keep_resp));
+			/* Each node now sends keepalive message every
+			 * keepalive time interval. Hence no need for response
+			 */
 			goto out;
 		case O2NET_MSG_KEEP_RESP_MAGIC:
 			goto out;
@@ -1285,6 +1286,8 @@ static int o2net_check_handshake(struct o2net_sock_container *sc)
 	/* set valid and queue the idle timers only if it hasn't been
 	 * shut down already */
 	if (nn->nn_sc == sc) {
+		o2net_sc_queue_delayed_work(sc, &sc->sc_keepalive_work,
+				msecs_to_jiffies(o2net_keepalive_delay()));
 		o2net_sc_reset_idle_timer(sc);
 		o2net_set_nn_state(nn, sc, 1, 0);
 	}
@@ -1473,7 +1476,11 @@ static void o2net_sc_send_keep_req(struct work_struct *work)
 		container_of(work, struct o2net_sock_container,
 			     sc_keepalive_work.work);
 
-	o2net_sendpage(sc, o2net_keep_req, sizeof(*o2net_keep_req));
+	if (timer_pending(&sc->sc_idle_timeout)) {
+		o2net_sendpage(sc, o2net_keep_req, sizeof(*o2net_keep_req));
+		o2net_sc_queue_delayed_work(sc, &sc->sc_keepalive_work,
+				msecs_to_jiffies(o2net_keepalive_delay()));
+	}
 	sc_put(sc);
 }
 
@@ -1511,9 +1518,6 @@ static void o2net_idle_timer(unsigned long data)
 
 static void o2net_sc_reset_idle_timer(struct o2net_sock_container *sc)
 {
-	o2net_sc_cancel_delayed_work(sc, &sc->sc_keepalive_work);
-	o2net_sc_queue_delayed_work(sc, &sc->sc_keepalive_work,
-		      msecs_to_jiffies(o2net_keepalive_delay()));
 	do_gettimeofday(&sc->sc_tv_timer);
 	mod_timer(&sc->sc_idle_timeout,
 	       jiffies + msecs_to_jiffies(o2net_idle_timeout()));
-- 
1.5.6.5
