From: Christoph Hellwig <hch@lst.de>
Date: Wed, 20 May 2020 21:54:40 +0200
Subject: [Ocfs2-devel] [PATCH 04/33] net: add sock_no_linger
In-Reply-To: <20200520195509.2215098-1-hch@lst.de>
References: <20200520195509.2215098-1-hch@lst.de>
Message-ID: <20200520195509.2215098-5-hch@lst.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Marcelo Ricardo Leitner <marcelo.leitner-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-sctp-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-afs-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rds-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cluster-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Alexey Kuznetsov <kuznet-v/Mj1YrvjDBInbfyfbPRSQ@public.gmane.org>, ceph-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Neil Horman <nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org>, Hideaki YOSHIFUJI <yoshfuji-VfPWfsRibaP+Ru+s062T9g@public.gmane.org>, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vlad Yasevich <vyasevich-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jon Maloy <jmaloy-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ying Xue <ying.xue-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>, ocfs2-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org

Add a helper to directly set the SO_LINGER sockopt from kernel space
with onoff set to true and a linger time of 0 without going through a
fake uaccess.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Sagi Grimberg <sagi@grimberg.me>
---
 drivers/nvme/host/tcp.c   |  9 +--------
 drivers/nvme/target/tcp.c |  6 +-----
 include/net/sock.h        |  1 +
 net/core/sock.c           |  9 +++++++++
 net/rds/tcp.h             |  1 -
 net/rds/tcp_connect.c     |  2 +-
 net/rds/tcp_listen.c      | 13 +------------
 net/sunrpc/svcsock.c      | 12 ++----------
 8 files changed, 16 insertions(+), 37 deletions(-)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index c15a92163c1f7..e72d87482eb78 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -1313,7 +1313,6 @@ static int nvme_tcp_alloc_queue(struct nvme_ctrl *nctrl,
 {
 	struct nvme_tcp_ctrl *ctrl = to_tcp_ctrl(nctrl);
 	struct nvme_tcp_queue *queue = &ctrl->queues[qid];
-	struct linger sol = { .l_onoff = 1, .l_linger = 0 };
 	int ret, opt, rcv_pdu_size;
 
 	queue->ctrl = ctrl;
@@ -1361,13 +1360,7 @@ static int nvme_tcp_alloc_queue(struct nvme_ctrl *nctrl,
 	 * close. This is done to prevent stale data from being sent should
 	 * the network connection be restored before TCP times out.
 	 */
-	ret = kernel_setsockopt(queue->sock, SOL_SOCKET, SO_LINGER,
-			(char *)&sol, sizeof(sol));
-	if (ret) {
-		dev_err(nctrl->device,
-			"failed to set SO_LINGER sock opt %d\n", ret);
-		goto err_sock;
-	}
+	sock_no_linger(queue->sock->sk);
 
 	if (so_priority > 0) {
 		ret = kernel_setsockopt(queue->sock, SOL_SOCKET, SO_PRIORITY,
diff --git a/drivers/nvme/target/tcp.c b/drivers/nvme/target/tcp.c
index 40757a63f4553..e0801494b097f 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -1429,7 +1429,6 @@ static int nvmet_tcp_set_queue_sock(struct nvmet_tcp_queue *queue)
 {
 	struct socket *sock = queue->sock;
 	struct inet_sock *inet = inet_sk(sock->sk);
-	struct linger sol = { .l_onoff = 1, .l_linger = 0 };
 	int ret;
 
 	ret = kernel_getsockname(sock,
@@ -1447,10 +1446,7 @@ static int nvmet_tcp_set_queue_sock(struct nvmet_tcp_queue *queue)
 	 * close. This is done to prevent stale data from being sent should
 	 * the network connection be restored before TCP times out.
 	 */
-	ret = kernel_setsockopt(sock, SOL_SOCKET, SO_LINGER,
-			(char *)&sol, sizeof(sol));
-	if (ret)
-		return ret;
+	sock_no_linger(sock->sk);
 
 	if (so_priority > 0) {
 		ret = kernel_setsockopt(sock, SOL_SOCKET, SO_PRIORITY,
diff --git a/include/net/sock.h b/include/net/sock.h
index 2ec085044790c..6ed00bf009bbe 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2688,6 +2688,7 @@ static inline bool sk_dev_equal_l3scope(struct sock *sk, int dif)
 
 void sock_def_readable(struct sock *sk);
 
+void sock_no_linger(struct sock *sk);
 void sock_set_reuseaddr(struct sock *sk);
 
 #endif	/* _SOCK_H */
diff --git a/net/core/sock.c b/net/core/sock.c
index 18eb84fdf5fbe..f0f09524911c8 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -720,6 +720,15 @@ void sock_set_reuseaddr(struct sock *sk)
 }
 EXPORT_SYMBOL(sock_set_reuseaddr);
 
+void sock_no_linger(struct sock *sk)
+{
+	lock_sock(sk);
+	sk->sk_lingertime = 0;
+	sock_set_flag(sk, SOCK_LINGER);
+	release_sock(sk);
+}
+EXPORT_SYMBOL(sock_no_linger);
+
 /*
  *	This is meant for all protocols to use and covers goings on
  *	at the socket level. Everything here is generic.
diff --git a/net/rds/tcp.h b/net/rds/tcp.h
index 3c69361d21c73..d640e210b97b6 100644
--- a/net/rds/tcp.h
+++ b/net/rds/tcp.h
@@ -73,7 +73,6 @@ void rds_tcp_listen_data_ready(struct sock *sk);
 int rds_tcp_accept_one(struct socket *sock);
 int rds_tcp_keepalive(struct socket *sock);
 void *rds_tcp_listen_sock_def_readable(struct net *net);
-void rds_tcp_set_linger(struct socket *sock);
 
 /* tcp_recv.c */
 int rds_tcp_recv_init(void);
diff --git a/net/rds/tcp_connect.c b/net/rds/tcp_connect.c
index 008f50fb25dd2..4e64598176b05 100644
--- a/net/rds/tcp_connect.c
+++ b/net/rds/tcp_connect.c
@@ -207,7 +207,7 @@ void rds_tcp_conn_path_shutdown(struct rds_conn_path *cp)
 
 	if (sock) {
 		if (rds_destroy_pending(cp->cp_conn))
-			rds_tcp_set_linger(sock);
+			sock_no_linger(sock->sk);
 		sock->ops->shutdown(sock, RCV_SHUTDOWN | SEND_SHUTDOWN);
 		lock_sock(sock->sk);
 		rds_tcp_restore_callbacks(sock, tc); /* tc->tc_sock = NULL */
diff --git a/net/rds/tcp_listen.c b/net/rds/tcp_listen.c
index 810a3a49e9474..bbb31b9c0b391 100644
--- a/net/rds/tcp_listen.c
+++ b/net/rds/tcp_listen.c
@@ -111,17 +111,6 @@ struct rds_tcp_connection *rds_tcp_accept_one_path(struct rds_connection *conn)
 	return NULL;
 }
 
-void rds_tcp_set_linger(struct socket *sock)
-{
-	struct linger no_linger = {
-		.l_onoff = 1,
-		.l_linger = 0,
-	};
-
-	kernel_setsockopt(sock, SOL_SOCKET, SO_LINGER,
-			  (char *)&no_linger, sizeof(no_linger));
-}
-
 int rds_tcp_accept_one(struct socket *sock)
 {
 	struct socket *new_sock = NULL;
@@ -241,7 +230,7 @@ int rds_tcp_accept_one(struct socket *sock)
 	 * be pending on it. By setting linger, we achieve the side-effect
 	 * of avoiding TIME_WAIT state on new_sock.
 	 */
-	rds_tcp_set_linger(new_sock);
+	sock_no_linger(new_sock->sk);
 	kernel_sock_shutdown(new_sock, SHUT_RDWR);
 	ret = 0;
 out:
diff --git a/net/sunrpc/svcsock.c b/net/sunrpc/svcsock.c
index 023514e392b31..6773dacc64d8e 100644
--- a/net/sunrpc/svcsock.c
+++ b/net/sunrpc/svcsock.c
@@ -323,17 +323,9 @@ static int svc_tcp_has_wspace(struct svc_xprt *xprt)
 
 static void svc_tcp_kill_temp_xprt(struct svc_xprt *xprt)
 {
-	struct svc_sock *svsk;
-	struct socket *sock;
-	struct linger no_linger = {
-		.l_onoff = 1,
-		.l_linger = 0,
-	};
+	struct svc_sock *svsk = container_of(xprt, struct svc_sock, sk_xprt);
 
-	svsk = container_of(xprt, struct svc_sock, sk_xprt);
-	sock = svsk->sk_sock;
-	kernel_setsockopt(sock, SOL_SOCKET, SO_LINGER,
-			  (char *)&no_linger, sizeof(no_linger));
+	sock_no_linger(svsk->sk_sock->sk);
 }
 
 /*
-- 
2.26.2
