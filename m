From: Christoph Hellwig <hch@lst.de>
Date: Thu, 28 May 2020 07:12:23 +0200
Subject: [Ocfs2-devel] [PATCH 15/28] tcp: add tcp_sock_set_keepidle
In-Reply-To: <20200528051236.620353-1-hch@lst.de>
References: <20200528051236.620353-1-hch@lst.de>
Message-ID: <20200528051236.620353-16-hch@lst.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Alexey Kuznetsov <kuznet-v/Mj1YrvjDBInbfyfbPRSQ@public.gmane.org>, Hideaki YOSHIFUJI <yoshfuji-VfPWfsRibaP+Ru+s062T9g@public.gmane.org>, Jon Maloy <jmaloy-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ying Xue <ying.xue-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-afs-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cluster-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ocfs2-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ceph-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rds-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tipc-discussion-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org

Add a helper to directly set the TCP_KEEP_IDLE sockopt from kernel
space without going through a fake uaccess.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/tcp.h   |  1 +
 net/ipv4/tcp.c        | 49 ++++++++++++++++++++++++++++++-------------
 net/rds/tcp_listen.c  |  5 +----
 net/sunrpc/xprtsock.c |  3 +--
 4 files changed, 37 insertions(+), 21 deletions(-)

diff --git a/include/linux/tcp.h b/include/linux/tcp.h
index de682143efe4d..5724dd84a85ed 100644
--- a/include/linux/tcp.h
+++ b/include/linux/tcp.h
@@ -498,6 +498,7 @@ int tcp_skb_shift(struct sk_buff *to, struct sk_buff *from, int pcount,
 		  int shiftlen);
 
 void tcp_sock_set_cork(struct sock *sk, bool on);
+int tcp_sock_set_keepidle(struct sock *sk, int val);
 void tcp_sock_set_nodelay(struct sock *sk);
 void tcp_sock_set_quickack(struct sock *sk, int val);
 int tcp_sock_set_syncnt(struct sock *sk, int val);
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 0004bd9ae7b0a..bdf0ff9333514 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2901,6 +2901,39 @@ void tcp_sock_set_user_timeout(struct sock *sk, u32 val)
 }
 EXPORT_SYMBOL(tcp_sock_set_user_timeout);
 
+static int __tcp_sock_set_keepidle(struct sock *sk, int val)
+{
+	struct tcp_sock *tp = tcp_sk(sk);
+
+	if (val < 1 || val > MAX_TCP_KEEPIDLE)
+		return -EINVAL;
+
+	tp->keepalive_time = val * HZ;
+	if (sock_flag(sk, SOCK_KEEPOPEN) &&
+	    !((1 << sk->sk_state) & (TCPF_CLOSE | TCPF_LISTEN))) {
+		u32 elapsed = keepalive_time_elapsed(tp);
+
+		if (tp->keepalive_time > elapsed)
+			elapsed = tp->keepalive_time - elapsed;
+		else
+			elapsed = 0;
+		inet_csk_reset_keepalive_timer(sk, elapsed);
+	}
+
+	return 0;
+}
+
+int tcp_sock_set_keepidle(struct sock *sk, int val)
+{
+	int err;
+
+	lock_sock(sk);
+	err = __tcp_sock_set_keepidle(sk, val);
+	release_sock(sk);
+	return err;
+}
+EXPORT_SYMBOL(tcp_sock_set_keepidle);
+
 /*
  *	Socket option code for TCP.
  */
@@ -3070,21 +3103,7 @@ static int do_tcp_setsockopt(struct sock *sk, int level,
 		break;
 
 	case TCP_KEEPIDLE:
-		if (val < 1 || val > MAX_TCP_KEEPIDLE)
-			err = -EINVAL;
-		else {
-			tp->keepalive_time = val * HZ;
-			if (sock_flag(sk, SOCK_KEEPOPEN) &&
-			    !((1 << sk->sk_state) &
-			      (TCPF_CLOSE | TCPF_LISTEN))) {
-				u32 elapsed = keepalive_time_elapsed(tp);
-				if (tp->keepalive_time > elapsed)
-					elapsed = tp->keepalive_time - elapsed;
-				else
-					elapsed = 0;
-				inet_csk_reset_keepalive_timer(sk, elapsed);
-			}
-		}
+		err = __tcp_sock_set_keepidle(sk, val);
 		break;
 	case TCP_KEEPINTVL:
 		if (val < 1 || val > MAX_TCP_KEEPINTVL)
diff --git a/net/rds/tcp_listen.c b/net/rds/tcp_listen.c
index 6f90ea077adcd..79f9adc008114 100644
--- a/net/rds/tcp_listen.c
+++ b/net/rds/tcp_listen.c
@@ -52,10 +52,7 @@ int rds_tcp_keepalive(struct socket *sock)
 	if (ret < 0)
 		goto bail;
 
-	ret = kernel_setsockopt(sock, IPPROTO_TCP, TCP_KEEPIDLE,
-				(char *)&keepidle, sizeof(keepidle));
-	if (ret < 0)
-		goto bail;
+	tcp_sock_set_keepidle(sock->sk, keepidle);
 
 	/* KEEPINTVL is the interval between successive probes. We follow
 	 * the model in xs_tcp_finish_connecting() and re-use keepidle.
diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index 231fd6162f68d..473290f7c5c0a 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -2107,8 +2107,7 @@ static void xs_tcp_set_socket_timeouts(struct rpc_xprt *xprt,
 
 	/* TCP Keepalive options */
 	sock_set_keepalive(sock->sk);
-	kernel_setsockopt(sock, SOL_TCP, TCP_KEEPIDLE,
-			(char *)&keepidle, sizeof(keepidle));
+	tcp_sock_set_keepidle(sock->sk, keepidle);
 	kernel_setsockopt(sock, SOL_TCP, TCP_KEEPINTVL,
 			(char *)&keepidle, sizeof(keepidle));
 	kernel_setsockopt(sock, SOL_TCP, TCP_KEEPCNT,
-- 
2.26.2
