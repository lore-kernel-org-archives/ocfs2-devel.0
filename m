From: Jeff Liu <jeff.liu@oracle.com>
Date: Wed, 22 Aug 2012 17:38:58 +0800
Subject: [Ocfs2-devel] [PATCH 4/4] ocfs2: trivial fix the switch..case
	syntax at o2net_state_change()
Message-ID: <5034A8B2.20608@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Syntax adjustment, I have to fix printk to pr_info(), or else, checkpatch.pl will alert me.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>

---
 fs/ocfs2/cluster/tcp.c |   28 ++++++++++++++--------------
 1 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/fs/ocfs2/cluster/tcp.c b/fs/ocfs2/cluster/tcp.c
index 1bfe880..4ad7350 100644
--- a/fs/ocfs2/cluster/tcp.c
+++ b/fs/ocfs2/cluster/tcp.c
@@ -635,20 +635,20 @@ static void o2net_state_change(struct sock *sk)
 
 	state_change = sc->sc_state_change;
 
-	switch(sk->sk_state) {
-		/* ignore connecting sockets as they make progress */
-		case TCP_SYN_SENT:
-		case TCP_SYN_RECV:
-			break;
-		case TCP_ESTABLISHED:
-			o2net_sc_queue_work(sc, &sc->sc_connect_work);
-			break;
-		default:
-			printk(KERN_INFO "o2net: Connection to " SC_NODEF_FMT
-			      " shutdown, state %d\n",
-			      SC_NODEF_ARGS(sc), sk->sk_state);
-			o2net_sc_queue_work(sc, &sc->sc_shutdown_work);
-			break;
+	switch (sk->sk_state) {
+	/* ignore connecting sockets as they make progress */
+	case TCP_SYN_SENT:
+	case TCP_SYN_RECV:
+		break;
+	case TCP_ESTABLISHED:
+		o2net_sc_queue_work(sc, &sc->sc_connect_work);
+		break;
+	default:
+		pr_info("o2net: Connection to " SC_NODEF_FMT
+			" shutdown, state %d\n",
+			SC_NODEF_ARGS(sc), sk->sk_state);
+		o2net_sc_queue_work(sc, &sc->sc_shutdown_work);
+		break;
 	}
 out:
 	read_unlock(&sk->sk_callback_lock);
-- 
1.7.4.1
