From: Tariq Saeed <tariq.x.saeed@oracle.com>
Date: Fri, 20 Dec 2013 12:22:01 -0800
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2/o2net: o2net_listen_data_ready
	should do nothing if socket state is not TCP_LISTEN Orabug: 17330860
Message-ID: <1387570921-3489-1-git-send-email-tariq.x.saeed@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

When accepting an incomming connection o2net_accept_one clones a child
data socket from the parent listening socket. It then proceeds to setup
the child with callback o2net_data_ready() and sk_user_data to NULL. If data arrives
in this window, o2net_listen_data_ready will be called with some non-deterministic
value in sk_user_data (not inherited). We panic when we page fault on
sk_user_data -- in parent it is  sock_def_readable(). The fix is to recognize
that this is a data socket being set up by looking at the socket state and
do nothing.

Signed-off-by: Tariq Saseed <tariq.x.saeed@oracle.com>
Signed-off-by: Srinivas Eeda <srinivas.eeda@oracle.com>
---
 fs/ocfs2/cluster/tcp.c |   22 +++++++++++++++++-----
 1 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/fs/ocfs2/cluster/tcp.c b/fs/ocfs2/cluster/tcp.c
index d644dc6..bae96a1 100644
--- a/fs/ocfs2/cluster/tcp.c
+++ b/fs/ocfs2/cluster/tcp.c
@@ -1960,18 +1960,30 @@ static void o2net_listen_data_ready(struct sock *sk, int bytes)
 		goto out;
 	}
 
-	/* ->sk_data_ready is also called for a newly established child socket
-	 * before it has been accepted and the acceptor has set up their
-	 * data_ready.. we only want to queue listen work for our listening
-	 * socket */
+	/* This callback may called twice when a new connection
+	 * is  being established as a child socket inherits everything
+	 * from a parent LISTEN socket, including the data_ready cb of
+	 * the parent. This leads to a hazard. In o2net_accept_one()
+	 * we are still initializing the child socket but have not
+	 * changed the inherited data_ready callback yet when
+	 * data starts arriving.
+	 * We avoid this hazard by checking the state.
+	 * For the listening socket,  the state will be TCP_LISTEN; for the new
+	 * socket, will be  TCP_ESTABLISHED. Also, in this case,
+	 * sk->sk_user_data is not a valid function pointer.
+	 */
+
 	if (sk->sk_state == TCP_LISTEN) {
 		mlog(ML_TCP, "bytes: %d\n", bytes);
 		queue_work(o2net_wq, &o2net_listen_work);
+	} else {
+		ready = NULL;
 	}
 
 out:
 	read_unlock(&sk->sk_callback_lock);
-	ready(sk, bytes);
+	if (ready != NULL)
+		ready(sk, bytes);
 }
 
 static int o2net_open_listening_sock(__be32 addr, __be16 port)
-- 
1.7.1
