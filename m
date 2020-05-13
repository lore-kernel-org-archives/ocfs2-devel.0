From: Christoph Hellwig <hch@lst.de>
Date: Wed, 13 May 2020 08:26:45 +0200
Subject: [Ocfs2-devel] [PATCH 30/33] tipc: call tsk_set_importance from
	tipc_topsrv_create_listener
In-Reply-To: <20200513062649.2100053-1-hch@lst.de>
References: <20200513062649.2100053-1-hch@lst.de>
Message-ID: <20200513062649.2100053-31-hch@lst.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Eric Dumazet <edumazet@google.com>, linux-nvme@lists.infradead.org, linux-sctp@vger.kernel.org, target-devel@vger.kernel.org, linux-afs@lists.infradead.org, linux-cifs@vger.kernel.org, rds-devel@oss.oracle.com, linux-rdma@vger.kernel.org, cluster-devel@redhat.com, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, linux-block@vger.kernel.org, drbd-dev@tron.linbit.com, ceph-devel@vger.kernel.org, linux-nfs@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, netdev@vger.kernel.org, Vlad Yasevich <vyasevich@gmail.com>, linux-kernel@vger.kernel.org, Jon Maloy <jmaloy@redhat.com>, Ying Xue <ying.xue@windriver.com>, ocfs2-devel@oss.oracle.com

Avoid using kernel_setsockopt for the TIPC_IMPORTANCE option when we can
just use the internal helper.  The only change needed is to pass a struct
sock instead of tipc_sock, which is private to socket.c

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 net/tipc/socket.c | 18 +++++++++---------
 net/tipc/socket.h |  2 ++
 net/tipc/topsrv.c |  6 +++---
 3 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/net/tipc/socket.c b/net/tipc/socket.c
index 87466607097f1..f2e10fbfb03df 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -191,17 +191,17 @@ static int tsk_importance(struct tipc_sock *tsk)
 	return msg_importance(&tsk->phdr);
 }
 
-static int tsk_set_importance(struct tipc_sock *tsk, int imp)
+static struct tipc_sock *tipc_sk(const struct sock *sk)
 {
-	if (imp > TIPC_CRITICAL_IMPORTANCE)
-		return -EINVAL;
-	msg_set_importance(&tsk->phdr, (u32)imp);
-	return 0;
+	return container_of(sk, struct tipc_sock, sk);
 }
 
-static struct tipc_sock *tipc_sk(const struct sock *sk)
+int tsk_set_importance(struct sock *sk, int imp)
 {
-	return container_of(sk, struct tipc_sock, sk);
+	if (imp > TIPC_CRITICAL_IMPORTANCE)
+		return -EINVAL;
+	msg_set_importance(&tipc_sk(sk)->phdr, (u32)imp);
+	return 0;
 }
 
 static bool tsk_conn_cong(struct tipc_sock *tsk)
@@ -2661,7 +2661,7 @@ static int tipc_accept(struct socket *sock, struct socket *new_sock, int flags,
 	/* Connect new socket to it's peer */
 	tipc_sk_finish_conn(new_tsock, msg_origport(msg), msg_orignode(msg));
 
-	tsk_set_importance(new_tsock, msg_importance(msg));
+	tsk_set_importance(new_sk, msg_importance(msg));
 	if (msg_named(msg)) {
 		new_tsock->conn_type = msg_nametype(msg);
 		new_tsock->conn_instance = msg_nameinst(msg);
@@ -3079,7 +3079,7 @@ static int tipc_setsockopt(struct socket *sock, int lvl, int opt,
 
 	switch (opt) {
 	case TIPC_IMPORTANCE:
-		res = tsk_set_importance(tsk, value);
+		res = tsk_set_importance(sk, value);
 		break;
 	case TIPC_SRC_DROPPABLE:
 		if (sock->type != SOCK_STREAM)
diff --git a/net/tipc/socket.h b/net/tipc/socket.h
index 235b9679acee4..b11575afc66fe 100644
--- a/net/tipc/socket.h
+++ b/net/tipc/socket.h
@@ -75,4 +75,6 @@ u32 tipc_sock_get_portid(struct sock *sk);
 bool tipc_sk_overlimit1(struct sock *sk, struct sk_buff *skb);
 bool tipc_sk_overlimit2(struct sock *sk, struct sk_buff *skb);
 
+int tsk_set_importance(struct sock *sk, int imp);
+
 #endif
diff --git a/net/tipc/topsrv.c b/net/tipc/topsrv.c
index 73dbed0c4b6b8..a0d50649f71c2 100644
--- a/net/tipc/topsrv.c
+++ b/net/tipc/topsrv.c
@@ -494,7 +494,6 @@ static void tipc_topsrv_listener_data_ready(struct sock *sk)
 
 static int tipc_topsrv_create_listener(struct tipc_topsrv *srv)
 {
-	int imp = TIPC_CRITICAL_IMPORTANCE;
 	struct socket *lsock = NULL;
 	struct sockaddr_tipc saddr;
 	struct sock *sk;
@@ -511,8 +510,9 @@ static int tipc_topsrv_create_listener(struct tipc_topsrv *srv)
 	sk->sk_user_data = srv;
 	write_unlock_bh(&sk->sk_callback_lock);
 
-	rc = kernel_setsockopt(lsock, SOL_TIPC, TIPC_IMPORTANCE,
-			       (char *)&imp, sizeof(imp));
+	lock_sock(sk);
+	rc = tsk_set_importance(sk, TIPC_CRITICAL_IMPORTANCE);
+	release_sock(sk);
 	if (rc < 0)
 		goto err;
 
-- 
2.26.2
