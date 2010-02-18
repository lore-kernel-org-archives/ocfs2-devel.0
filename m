From: Srinivas Eeda <srinivas.eeda@oracle.com>
Date: Thu, 18 Feb 2010 15:11:49 -0800
Subject: [Ocfs2-devel] [PATCH 3/3] o2net: correct keepalive message protocol
	(revision 2)
Message-ID: <1266534709-6855-1-git-send-email-srinivas.eeda@oracle.com>
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
a keepalive message every timeout seconds. This patch sends a message for
every keepalive time interval.

Signed-off-by: Srinivas Eeda <srinivas.eeda@oracle.com>
---
 fs/ocfs2/cluster/tcp.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/cluster/tcp.c b/fs/ocfs2/cluster/tcp.c
index 0bbd47b..0b68f25 100644
--- a/fs/ocfs2/cluster/tcp.c
+++ b/fs/ocfs2/cluster/tcp.c
@@ -1473,7 +1473,11 @@ static void o2net_sc_send_keep_req(struct work_struct *work)
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
 
-- 
1.5.6.5
