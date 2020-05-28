From: Christoph Hellwig <hch@lst.de>
Date: Thu, 28 May 2020 07:12:15 +0200
Subject: [Ocfs2-devel] [PATCH 07/28] net: add sock_set_keepalive
In-Reply-To: <20200528051236.620353-1-hch@lst.de>
References: <20200528051236.620353-1-hch@lst.de>
Message-ID: <20200528051236.620353-8-hch@lst.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>
Cc: Eric Dumazet <edumazet@google.com>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, Jon Maloy <jmaloy@redhat.com>, Ying Xue <ying.xue@windriver.com>, drbd-dev@lists.linbit.com, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, linux-nvme@lists.infradead.org, target-devel@vger.kernel.org, linux-afs@lists.infradead.org, linux-cifs@vger.kernel.org, cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com, netdev@vger.kernel.org, ceph-devel@vger.kernel.org, rds-devel@oss.oracle.com, linux-nfs@vger.kernel.org, tipc-discussion@lists.sourceforge.net

Add a helper to directly set the SO_KEEPALIVE sockopt from kernel space
without going through a fake uaccess.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/dlm/lowcomms.c     |  6 +-----
 include/net/sock.h    |  1 +
 net/core/sock.c       | 10 ++++++++++
 net/rds/tcp_listen.c  |  6 +-----
 net/sunrpc/xprtsock.c |  4 +---
 5 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/fs/dlm/lowcomms.c b/fs/dlm/lowcomms.c
index b4d491122814b..138009c6a2ee1 100644
--- a/fs/dlm/lowcomms.c
+++ b/fs/dlm/lowcomms.c
@@ -1259,11 +1259,7 @@ static struct socket *tcp_create_listen_sock(struct connection *con,
 		con->sock = NULL;
 		goto create_out;
 	}
-	result = kernel_setsockopt(sock, SOL_SOCKET, SO_KEEPALIVE,
-				 (char *)&one, sizeof(one));
-	if (result < 0) {
-		log_print("Set keepalive failed: %d", result);
-	}
+	sock_set_keepalive(sock->sk);
 
 	result = sock->ops->listen(sock, 5);
 	if (result < 0) {
diff --git a/include/net/sock.h b/include/net/sock.h
index 99ef43508d2b5..dc08c176238fd 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2691,6 +2691,7 @@ void sock_def_readable(struct sock *sk);
 int sock_bindtoindex(struct sock *sk, int ifindex);
 void sock_enable_timestamps(struct sock *sk);
 void sock_no_linger(struct sock *sk);
+void sock_set_keepalive(struct sock *sk);
 void sock_set_priority(struct sock *sk, u32 priority);
 void sock_set_reuseaddr(struct sock *sk);
 void sock_set_sndtimeo(struct sock *sk, s64 secs);
diff --git a/net/core/sock.c b/net/core/sock.c
index e4a4dd2b3d8b3..728f5fb156a0c 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -779,6 +779,16 @@ void sock_enable_timestamps(struct sock *sk)
 }
 EXPORT_SYMBOL(sock_enable_timestamps);
 
+void sock_set_keepalive(struct sock *sk)
+{
+	lock_sock(sk);
+	if (sk->sk_prot->keepalive)
+		sk->sk_prot->keepalive(sk, true);
+	sock_valbool_flag(sk, SOCK_KEEPOPEN, true);
+	release_sock(sk);
+}
+EXPORT_SYMBOL(sock_set_keepalive);
+
 /*
  *	This is meant for all protocols to use and covers goings on
  *	at the socket level. Everything here is generic.
diff --git a/net/rds/tcp_listen.c b/net/rds/tcp_listen.c
index bbb31b9c0b391..d8bd132769594 100644
--- a/net/rds/tcp_listen.c
+++ b/net/rds/tcp_listen.c
@@ -43,13 +43,9 @@ int rds_tcp_keepalive(struct socket *sock)
 	/* values below based on xs_udp_default_timeout */
 	int keepidle = 5; /* send a probe 'keepidle' secs after last data */
 	int keepcnt = 5; /* number of unack'ed probes before declaring dead */
-	int keepalive = 1;
 	int ret = 0;
 
-	ret = kernel_setsockopt(sock, SOL_SOCKET, SO_KEEPALIVE,
-				(char *)&keepalive, sizeof(keepalive));
-	if (ret < 0)
-		goto bail;
+	sock_set_keepalive(sock->sk);
 
 	ret = kernel_setsockopt(sock, IPPROTO_TCP, TCP_KEEPCNT,
 				(char *)&keepcnt, sizeof(keepcnt));
diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index 845d0be805ece..30082cd039960 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -2110,7 +2110,6 @@ static void xs_tcp_set_socket_timeouts(struct rpc_xprt *xprt,
 	struct sock_xprt *transport = container_of(xprt, struct sock_xprt, xprt);
 	unsigned int keepidle;
 	unsigned int keepcnt;
-	unsigned int opt_on = 1;
 	unsigned int timeo;
 
 	spin_lock(&xprt->transport_lock);
@@ -2122,8 +2121,7 @@ static void xs_tcp_set_socket_timeouts(struct rpc_xprt *xprt,
 	spin_unlock(&xprt->transport_lock);
 
 	/* TCP Keepalive options */
-	kernel_setsockopt(sock, SOL_SOCKET, SO_KEEPALIVE,
-			(char *)&opt_on, sizeof(opt_on));
+	sock_set_keepalive(sock->sk);
 	kernel_setsockopt(sock, SOL_TCP, TCP_KEEPIDLE,
 			(char *)&keepidle, sizeof(keepidle));
 	kernel_setsockopt(sock, SOL_TCP, TCP_KEEPINTVL,
-- 
2.26.2
