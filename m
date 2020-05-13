From: Christoph Hellwig <hch@lst.de>
Date: Wed, 13 May 2020 08:26:40 +0200
Subject: [Ocfs2-devel] [PATCH 25/33] ipv6: add ip6_sock_set_recvpktinfo
In-Reply-To: <20200513062649.2100053-1-hch@lst.de>
References: <20200513062649.2100053-1-hch@lst.de>
Message-ID: <20200513062649.2100053-26-hch@lst.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Eric Dumazet <edumazet@google.com>, linux-nvme@lists.infradead.org, linux-sctp@vger.kernel.org, target-devel@vger.kernel.org, linux-afs@lists.infradead.org, linux-cifs@vger.kernel.org, rds-devel@oss.oracle.com, linux-rdma@vger.kernel.org, cluster-devel@redhat.com, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, linux-block@vger.kernel.org, drbd-dev@tron.linbit.com, ceph-devel@vger.kernel.org, linux-nfs@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, netdev@vger.kernel.org, Vlad Yasevich <vyasevich@gmail.com>, linux-kernel@vger.kernel.org, Jon Maloy <jmaloy@redhat.com>, Ying Xue <ying.xue@windriver.com>, ocfs2-devel@oss.oracle.com

Add a helper to directly set the IPV6_RECVPKTINFO sockopt from kernel
space without going through a fake uaccess.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/net/ipv6.h       |  1 +
 net/ipv6/ipv6_sockglue.c |  8 ++++++++
 net/sunrpc/svcsock.c     | 11 +++--------
 3 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index 04b2bc1935054..170872bc4e960 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -1178,5 +1178,6 @@ int ipv6_sock_mc_drop(struct sock *sk, int ifindex,
 int ip6_sock_set_v6only(struct sock *sk, bool val);
 void ip6_sock_set_recverr(struct sock *sk, bool val);
 int ip6_sock_set_addr_preferences(struct sock *sk, bool val);
+void ip6_sock_set_recvpktinfo(struct sock *sk, bool val);
 
 #endif /* _NET_IPV6_H */
diff --git a/net/ipv6/ipv6_sockglue.c b/net/ipv6/ipv6_sockglue.c
index c23d42e809d7e..d60adb018d71c 100644
--- a/net/ipv6/ipv6_sockglue.c
+++ b/net/ipv6/ipv6_sockglue.c
@@ -225,6 +225,14 @@ int ip6_sock_set_addr_preferences(struct sock *sk, bool val)
 }
 EXPORT_SYMBOL(ip6_sock_set_addr_preferences);
 
+void ip6_sock_set_recvpktinfo(struct sock *sk, bool val)
+{
+	lock_sock(sk);
+	inet6_sk(sk)->rxopt.bits.rxinfo = val;
+	release_sock(sk);
+}
+EXPORT_SYMBOL(ip6_sock_set_recvpktinfo);
+
 static int do_ipv6_setsockopt(struct sock *sk, int level, int optname,
 		    char __user *optval, unsigned int optlen)
 {
diff --git a/net/sunrpc/svcsock.c b/net/sunrpc/svcsock.c
index 7fa7fedec3c5a..7cf8389b6f46f 100644
--- a/net/sunrpc/svcsock.c
+++ b/net/sunrpc/svcsock.c
@@ -595,8 +595,6 @@ static struct svc_xprt_class svc_udp_class = {
 
 static void svc_udp_init(struct svc_sock *svsk, struct svc_serv *serv)
 {
-	int err, level, optname, one = 1;
-
 	svc_xprt_init(sock_net(svsk->sk_sock->sk), &svc_udp_class,
 		      &svsk->sk_xprt, serv);
 	clear_bit(XPT_CACHE_AUTH, &svsk->sk_xprt.xpt_flags);
@@ -617,17 +615,14 @@ static void svc_udp_init(struct svc_sock *svsk, struct svc_serv *serv)
 	switch (svsk->sk_sk->sk_family) {
 	case AF_INET:
 		ip_sock_set_pktinfo(svsk->sk_sock->sk, true);
-		return;
+		break;
 	case AF_INET6:
-		level = SOL_IPV6;
-		optname = IPV6_RECVPKTINFO;
+		if (IS_REACHABLE(CONFIG_IPV6))
+			ip6_sock_set_recvpktinfo(svsk->sk_sock->sk, true);
 		break;
 	default:
 		BUG();
 	}
-	err = kernel_setsockopt(svsk->sk_sock, level, optname,
-					(char *)&one, sizeof(one));
-	dprintk("svc: kernel_setsockopt returned %d\n", err);
 }
 
 /*
-- 
2.26.2
