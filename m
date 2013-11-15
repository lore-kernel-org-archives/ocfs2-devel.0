From: Tariq Saeed <tariq.x.saeed@oracle.com>
Date: Thu, 14 Nov 2013 18:00:54 -0800
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2/o2net: incorrect to terminate
	accepting connections loop upon rejecting an ivalid one
	Orabug: 17489469
Message-ID: <1384480854-28925-1-git-send-email-tariq.x.saeed@oracle.com>
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
---
 fs/ocfs2/cluster/tcp.c |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/cluster/tcp.c b/fs/ocfs2/cluster/tcp.c
index b9cb50d..58e071a 100644
--- a/fs/ocfs2/cluster/tcp.c
+++ b/fs/ocfs2/cluster/tcp.c
@@ -1830,7 +1830,7 @@ int o2net_register_hb_callbacks(void)
 
 /* ------------------------------------------------------------ */
 
-static int o2net_accept_one(struct socket *sock)
+static int o2net_accept_one(struct socket *sock, int *more)
 {
 	int ret, slen;
 	struct sockaddr_in sin;
@@ -1841,6 +1841,7 @@ static int o2net_accept_one(struct socket *sock)
 	struct o2net_node *nn;
 
 	BUG_ON(sock == NULL);
+	*more = 0;
 	ret = sock_create_lite(sock->sk->sk_family, sock->sk->sk_type,
 			       sock->sk->sk_protocol, &new_sock);
 	if (ret)
@@ -1852,6 +1853,7 @@ static int o2net_accept_one(struct socket *sock)
 	if (ret < 0)
 		goto out;
 
+	*more = 1;
 	new_sock->sk->sk_allocation = GFP_ATOMIC;
 
 	ret = o2net_set_nodelay(new_sock);
@@ -1949,8 +1951,15 @@ out:
 static void o2net_accept_many(struct work_struct *work)
 {
 	struct socket *sock = o2net_listen_sock;
-	while (o2net_accept_one(sock) == 0)
+	int	more;
+	int	err;
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
