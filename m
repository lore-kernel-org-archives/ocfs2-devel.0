From: Christoph Hellwig <hch@lst.de>
Date: Wed, 13 May 2020 08:26:29 +0200
Subject: [Ocfs2-devel] [PATCH 14/33] tcp: add tcp_sock_set_user_timeout
In-Reply-To: <20200513062649.2100053-1-hch@lst.de>
References: <20200513062649.2100053-1-hch@lst.de>
Message-ID: <20200513062649.2100053-15-hch@lst.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Marcelo Ricardo Leitner <marcelo.leitner-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-sctp-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-afs-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rds-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cluster-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Alexey Kuznetsov <kuznet-v/Mj1YrvjDBInbfyfbPRSQ@public.gmane.org>, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ceph-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Neil Horman <nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org>, Hideaki YOSHIFUJI <yoshfuji-VfPWfsRibaP+Ru+s062T9g@public.gmane.org>, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vlad Yasevich <vyasevich-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jon Maloy <jmaloy-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ying Xue <ying.xue-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>, ocfs2-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org

Add a helper to directly set the TCP_USER_TIMEOUT sockopt from kernel
space without going through a fake uaccess.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/ocfs2/cluster/tcp.c | 22 ++--------------------
 include/linux/tcp.h    |  1 +
 net/ipv4/tcp.c         |  8 ++++++++
 net/sunrpc/xprtsock.c  |  3 +--
 4 files changed, 12 insertions(+), 22 deletions(-)

diff --git a/fs/ocfs2/cluster/tcp.c b/fs/ocfs2/cluster/tcp.c
index 7936e22e39f34..5776df10d11f9 100644
--- a/fs/ocfs2/cluster/tcp.c
+++ b/fs/ocfs2/cluster/tcp.c
@@ -1441,14 +1441,6 @@ static void o2net_rx_until_empty(struct work_struct *work)
 	sc_put(sc);
 }
 
-static int o2net_set_usertimeout(struct socket *sock)
-{
-	int user_timeout = O2NET_TCP_USER_TIMEOUT;
-
-	return kernel_setsockopt(sock, SOL_TCP, TCP_USER_TIMEOUT,
-				(void *)&user_timeout, sizeof(user_timeout));
-}
-
 static void o2net_initialize_handshake(void)
 {
 	o2net_hand->o2hb_heartbeat_timeout_ms = cpu_to_be32(
@@ -1629,12 +1621,7 @@ static void o2net_start_connect(struct work_struct *work)
 	}
 
 	tcp_sock_set_nodelay(sc->sc_sock->sk, true);
-
-	ret = o2net_set_usertimeout(sock);
-	if (ret) {
-		mlog(ML_ERROR, "set TCP_USER_TIMEOUT failed with %d\n", ret);
-		goto out;
-	}
+	tcp_sock_set_user_timeout(sock->sk, O2NET_TCP_USER_TIMEOUT);
 
 	o2net_register_callbacks(sc->sc_sock->sk, sc);
 
@@ -1821,12 +1808,7 @@ static int o2net_accept_one(struct socket *sock, int *more)
 	new_sock->sk->sk_allocation = GFP_ATOMIC;
 
 	tcp_sock_set_nodelay(new_sock->sk, true);
-
-	ret = o2net_set_usertimeout(new_sock);
-	if (ret) {
-		mlog(ML_ERROR, "set TCP_USER_TIMEOUT failed with %d\n", ret);
-		goto out;
-	}
+	tcp_sock_set_user_timeout(new_sock->sk, O2NET_TCP_USER_TIMEOUT);
 
 	ret = new_sock->ops->getname(new_sock, (struct sockaddr *) &sin, 1);
 	if (ret < 0)
diff --git a/include/linux/tcp.h b/include/linux/tcp.h
index 77b832acf3398..69c988f84a184 100644
--- a/include/linux/tcp.h
+++ b/include/linux/tcp.h
@@ -498,5 +498,6 @@ void tcp_sock_set_cork(struct sock *sk, bool on);
 void tcp_sock_set_nodelay(struct sock *sk, bool on);
 void tcp_sock_set_quickack(struct sock *sk, int val);
 int tcp_sock_set_syncnt(struct sock *sk, int val);
+void tcp_sock_set_user_timeout(struct sock *sk, u32 val);
 
 #endif	/* _LINUX_TCP_H */
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 773b5cd366ab7..9a8d062b17a48 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2882,6 +2882,14 @@ int tcp_sock_set_syncnt(struct sock *sk, int val)
 }
 EXPORT_SYMBOL(tcp_sock_set_syncnt);
 
+void tcp_sock_set_user_timeout(struct sock *sk, u32 val)
+{
+	lock_sock(sk);
+	inet_csk(sk)->icsk_user_timeout = val;
+	release_sock(sk);
+}
+EXPORT_SYMBOL(tcp_sock_set_user_timeout);
+
 /*
  *	Socket option code for TCP.
  */
diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index 3dc2d52371a0e..30d4c4fcd3e38 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -2115,8 +2115,7 @@ static void xs_tcp_set_socket_timeouts(struct rpc_xprt *xprt,
 			(char *)&keepcnt, sizeof(keepcnt));
 
 	/* TCP user timeout (see RFC5482) */
-	kernel_setsockopt(sock, SOL_TCP, TCP_USER_TIMEOUT,
-			(char *)&timeo, sizeof(timeo));
+	tcp_sock_set_user_timeout(sock->sk, timeo);
 }
 
 static void xs_tcp_set_connect_timeout(struct rpc_xprt *xprt,
-- 
2.26.2
