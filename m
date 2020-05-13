From: Christoph Hellwig <hch@lst.de>
Date: Wed, 13 May 2020 08:26:32 +0200
Subject: [Ocfs2-devel] [PATCH 17/33] tcp: add tcp_sock_set_keepcnt
In-Reply-To: <20200513062649.2100053-1-hch@lst.de>
References: <20200513062649.2100053-1-hch@lst.de>
Message-ID: <20200513062649.2100053-18-hch@lst.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>
Cc: Eric Dumazet <edumazet@google.com>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Jon Maloy <jmaloy@redhat.com>, Ying Xue <ying.xue@windriver.com>, drbd-dev@lists.linbit.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, linux-nvme@lists.infradead.org, target-devel@vger.kernel.org, linux-afs@lists.infradead.org, linux-cifs@vger.kernel.org, cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com, netdev@vger.kernel.org, linux-sctp@vger.kernel.org, ceph-devel@vger.kernel.org, rds-devel@oss.oracle.com, linux-nfs@vger.kernel.org

Add a helper to directly set the TCP_KEEPCNT sockopt from kernel space
without going through a fake uaccess.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/tcp.h   |  1 +
 net/ipv4/tcp.c        | 12 ++++++++++++
 net/rds/tcp.h         |  2 +-
 net/rds/tcp_listen.c  | 17 +++--------------
 net/sunrpc/xprtsock.c |  3 +--
 5 files changed, 18 insertions(+), 17 deletions(-)

diff --git a/include/linux/tcp.h b/include/linux/tcp.h
index dad18ca361c01..ff2aa165b5c02 100644
--- a/include/linux/tcp.h
+++ b/include/linux/tcp.h
@@ -501,5 +501,6 @@ int tcp_sock_set_syncnt(struct sock *sk, int val);
 void tcp_sock_set_user_timeout(struct sock *sk, u32 val);
 int tcp_sock_set_keepidle(struct sock *sk, int val);
 int tcp_sock_set_keepintvl(struct sock *sk, int val);
+int tcp_sock_set_keepcnt(struct sock *sk, int val);
 
 #endif	/* _LINUX_TCP_H */
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index b714f2b2fa54e..a0406df42ef39 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2935,6 +2935,18 @@ int tcp_sock_set_keepintvl(struct sock *sk, int val)
 }
 EXPORT_SYMBOL(tcp_sock_set_keepintvl);
 
+int tcp_sock_set_keepcnt(struct sock *sk, int val)
+{
+	if (val < 1 || val > MAX_TCP_KEEPCNT)
+		return -EINVAL;
+
+	lock_sock(sk);
+	tcp_sk(sk)->keepalive_probes = val;
+	release_sock(sk);
+	return 0;
+}
+EXPORT_SYMBOL(tcp_sock_set_keepcnt);
+
 /*
  *	Socket option code for TCP.
  */
diff --git a/net/rds/tcp.h b/net/rds/tcp.h
index 39ac666d09c6c..ae18568bce233 100644
--- a/net/rds/tcp.h
+++ b/net/rds/tcp.h
@@ -70,7 +70,7 @@ struct socket *rds_tcp_listen_init(struct net *net, bool isv6);
 void rds_tcp_listen_stop(struct socket *sock, struct work_struct *acceptor);
 void rds_tcp_listen_data_ready(struct sock *sk);
 int rds_tcp_accept_one(struct socket *sock);
-int rds_tcp_keepalive(struct socket *sock);
+void rds_tcp_keepalive(struct socket *sock);
 void *rds_tcp_listen_sock_def_readable(struct net *net);
 void rds_tcp_set_linger(struct socket *sock);
 
diff --git a/net/rds/tcp_listen.c b/net/rds/tcp_listen.c
index a5db2f8bb7339..f6d2b4c9f445a 100644
--- a/net/rds/tcp_listen.c
+++ b/net/rds/tcp_listen.c
@@ -38,27 +38,19 @@
 #include "rds.h"
 #include "tcp.h"
 
-int rds_tcp_keepalive(struct socket *sock)
+void rds_tcp_keepalive(struct socket *sock)
 {
 	/* values below based on xs_udp_default_timeout */
 	int keepidle = 5; /* send a probe 'keepidle' secs after last data */
 	int keepcnt = 5; /* number of unack'ed probes before declaring dead */
-	int ret = 0;
 
 	sock_set_keepalive(sock->sk, true);
-
-	ret = kernel_setsockopt(sock, IPPROTO_TCP, TCP_KEEPCNT,
-				(char *)&keepcnt, sizeof(keepcnt));
-	if (ret < 0)
-		goto bail;
-
+	tcp_sock_set_keepcnt(sock->sk, keepcnt);
 	tcp_sock_set_keepidle(sock->sk, keepidle);
 	/* KEEPINTVL is the interval between successive probes. We follow
 	 * the model in xs_tcp_finish_connecting() and re-use keepidle.
 	 */
 	tcp_sock_set_keepintvl(sock->sk, keepidle);
-bail:
-	return ret;
 }
 
 /* rds_tcp_accept_one_path(): if accepting on cp_index > 0, make sure the
@@ -145,10 +137,7 @@ int rds_tcp_accept_one(struct socket *sock)
 	new_sock->ops = sock->ops;
 	__module_get(new_sock->ops->owner);
 
-	ret = rds_tcp_keepalive(new_sock);
-	if (ret < 0)
-		goto out;
-
+	rds_tcp_keepalive(new_sock);
 	rds_tcp_tune(new_sock);
 
 	inet = inet_sk(new_sock->sk);
diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index e20de4a52edb7..88aa198456858 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -2109,8 +2109,7 @@ static void xs_tcp_set_socket_timeouts(struct rpc_xprt *xprt,
 	sock_set_keepalive(sock->sk, 1);
 	tcp_sock_set_keepidle(sock->sk, keepidle);
 	tcp_sock_set_keepintvl(sock->sk, keepidle);
-	kernel_setsockopt(sock, SOL_TCP, TCP_KEEPCNT,
-			(char *)&keepcnt, sizeof(keepcnt));
+	tcp_sock_set_keepcnt(sock->sk, keepcnt);
 
 	/* TCP user timeout (see RFC5482) */
 	tcp_sock_set_user_timeout(sock->sk, timeo);
-- 
2.26.2
