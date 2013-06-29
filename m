From: Jeff Liu <jeff.liu@oracle.com>
Date: Sat, 29 Jun 2013 12:01:19 +0800
Subject: [Ocfs2-devel] [RESENT PATCH 4/4] ocfs2: adjust switch_case syntax
	at o2net_state_change()
Message-ID: <51CE5C0F.8030701@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Jie Liu <jeff.liu@oracle.com>

Adjust switch..case syntax at o2net_state_change to meet
the kernel coding standard.

s/printk/pr_info/.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 fs/ocfs2/cluster/tcp.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/fs/ocfs2/cluster/tcp.c b/fs/ocfs2/cluster/tcp.c
index aa88bd8..db4c465 100644
--- a/fs/ocfs2/cluster/tcp.c
+++ b/fs/ocfs2/cluster/tcp.c
@@ -630,19 +630,19 @@ static void o2net_state_change(struct sock *sk)
 	state_change = sc->sc_state_change;
 
 	switch(sk->sk_state) {
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
+	/* ignore connecting sockets as they make progress */
+	case TCP_SYN_SENT:
+	case TCP_SYN_RECV:
+		break;
+	case TCP_ESTABLISHED:
+		o2net_sc_queue_work(sc, &sc->sc_connect_work);
+		break;
+	default:
+		pr_info(KERN_INFO "o2net: Connection to " SC_NODEF_FMT
+			" shutdown, state %d\n",
+			SC_NODEF_ARGS(sc), sk->sk_state);
+		o2net_sc_queue_work(sc, &sc->sc_shutdown_work);
+		break;
 	}
 out:
 	read_unlock(&sk->sk_callback_lock);
-- 
1.7.9.5
