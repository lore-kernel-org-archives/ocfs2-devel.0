From: Tariq Saeed <tariq.x.saeed@oracle.com>
Date: Tue,  8 Apr 2014 15:36:42 -0700
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2/o2net: incorrect to terminate
	accepting connections loop upon rejecting an ivalid one
	Orabug: 17489469
Message-ID: <1396996602-3773-1-git-send-email-tariq.x.saeed@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

When o2net-accept-one() rejects an illegal connection,
it terminates the loop picking up the remaining queued connections.
This fix will continue accepting connections till the queue is
emtpy.

Signed-off-by: Tariq Saseed <tariq.x.saeed@oracle.com>
Signed-off-by: Srinivas Eeda <srinivas.eeda@oracle.com>
---
 fs/ocfs2/cluster/tcp.c |   31 +++++++++++++++++++++++++++++--
 1 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/cluster/tcp.c b/fs/ocfs2/cluster/tcp.c
index 2cd2406..649a651 100644
--- a/fs/ocfs2/cluster/tcp.c
+++ b/fs/ocfs2/cluster/tcp.c
@@ -1826,7 +1826,7 @@ int o2net_register_hb_callbacks(void)
 
 /* ------------------------------------------------------------ */
 
-static int o2net_accept_one(struct socket *sock)
+static int o2net_accept_one(struct socket *sock, int *more)
 {
 	int ret, slen;
 	struct sockaddr_in sin;
@@ -1837,6 +1837,7 @@ static int o2net_accept_one(struct socket *sock)
 	struct o2net_node *nn;
 
 	BUG_ON(sock == NULL);
+	*more = 0;
 	ret = sock_create_lite(sock->sk->sk_family, sock->sk->sk_type,
 			       sock->sk->sk_protocol, &new_sock);
 	if (ret)
@@ -1848,6 +1849,7 @@ static int o2net_accept_one(struct socket *sock)
 	if (ret < 0)
 		goto out;
 
+	*more = 1;
 	new_sock->sk->sk_allocation = GFP_ATOMIC;
 
 	ret = o2net_set_nodelay(new_sock);
@@ -1946,11 +1948,36 @@ out:
 	return ret;
 }
 
+/*
+ * This function is invoked in response to one or more
+ * pending accepts at softIRQ level. We must drain the
+ * entire que before returning.
+ */
+
 static void o2net_accept_many(struct work_struct *work)
 {
 	struct socket *sock = o2net_listen_sock;
-	while (o2net_accept_one(sock) == 0)
+	int	more;
+	int	err;
+
+	/*
+	 * It is critical to note that due to interrupt moderation
+	 * at the network driver level, we can't assume to get a
+	 * softIRQ for every single conn since tcp SYN packets
+	 * can arrive back-to-back, and therefore many pending
+	 * accepts may result in just 1 softIRQ. If we terminate
+	 * the o2net_accept_one() loop upon seeing an err, what happens
+	 * to the rest of the conns in the queue? If no new SYN
+	 * arrives for hours, no softIRQ  will be delivered,
+	 * and the connections will just sit in the queue.
+	 */
+
+	for (;;) {
+		err = o2net_accept_one(sock, &more);
+		if (!more)
+			break;
 		cond_resched();
+	}
 }
 
 static void o2net_listen_data_ready(struct sock *sk, int bytes)
-- 
1.7.1
