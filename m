From: akpm at linux-foundation.org <akpm@linux-foundation.org>
Date: Fri, 24 Jan 2014 12:47:02 -0800
Subject: [Ocfs2-devel] [patch 03/11] ocfs2/o2net: incorrect to terminate
	accepting connections loop upon rejecting an invalid one
Message-ID: <20140124204702.9871031C2C7@corp2gmr1-1.hot.corp.google.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Tariq Saeed <tariq.x.saeed@oracle.com>
Subject: ocfs2/o2net: incorrect to terminate accepting connections loop upon rejecting an invalid one

When o2net-accept-one() rejects an illegal connection, it terminates the
loop picking up the remaining queued connections.  This fix will continue
accepting connections till the queue is emtpy.

Addresses Orabug 17489469.

Signed-off-by: Tariq Saseed <tariq.x.saeed@oracle.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/cluster/tcp.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff -puN fs/ocfs2/cluster/tcp.c~ocfs2-o2net-incorrect-to-terminate-accepting-connections-loop-upon-rejecting-an-invalid-one fs/ocfs2/cluster/tcp.c
--- a/fs/ocfs2/cluster/tcp.c~ocfs2-o2net-incorrect-to-terminate-accepting-connections-loop-upon-rejecting-an-invalid-one
+++ a/fs/ocfs2/cluster/tcp.c
@@ -1826,7 +1826,7 @@ int o2net_register_hb_callbacks(void)
 
 /* ------------------------------------------------------------ */
 
-static int o2net_accept_one(struct socket *sock)
+static int o2net_accept_one(struct socket *sock, int *more)
 {
 	int ret, slen;
 	struct sockaddr_in sin;
@@ -1837,6 +1837,7 @@ static int o2net_accept_one(struct socke
 	struct o2net_node *nn;
 
 	BUG_ON(sock == NULL);
+	*more = 0;
 	ret = sock_create_lite(sock->sk->sk_family, sock->sk->sk_type,
 			       sock->sk->sk_protocol, &new_sock);
 	if (ret)
@@ -1848,6 +1849,7 @@ static int o2net_accept_one(struct socke
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
_
