From: Christoph Hellwig <hch@lst.de>
Date: Wed, 13 May 2020 08:26:37 +0200
Subject: [Ocfs2-devel] [PATCH 22/33] ipv6: add ip6_sock_set_v6only
In-Reply-To: <20200513062649.2100053-1-hch@lst.de>
References: <20200513062649.2100053-1-hch@lst.de>
Message-ID: <20200513062649.2100053-23-hch@lst.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>
Cc: Eric Dumazet <edumazet@google.com>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Jon Maloy <jmaloy@redhat.com>, Ying Xue <ying.xue@windriver.com>, drbd-dev@lists.linbit.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, linux-nvme@lists.infradead.org, target-devel@vger.kernel.org, linux-afs@lists.infradead.org, linux-cifs@vger.kernel.org, cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com, netdev@vger.kernel.org, linux-sctp@vger.kernel.org, ceph-devel@vger.kernel.org, rds-devel@oss.oracle.com, linux-nfs@vger.kernel.org

Add a helper to directly set the IPV6_V6ONLY sockopt from kernel space
without going through a fake uaccess.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/net/ipv6.h        |  3 +++
 net/ipv6/ip6_udp_tunnel.c |  5 +----
 net/ipv6/ipv6_sockglue.c  | 11 +++++++++++
 net/sunrpc/svcsock.c      |  8 ++------
 4 files changed, 17 insertions(+), 10 deletions(-)

diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index 955badd1e8ffc..e24b59201a00d 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -1174,4 +1174,7 @@ int ipv6_sock_mc_join_ssm(struct sock *sk, int ifindex,
 			  const struct in6_addr *addr, unsigned int mode);
 int ipv6_sock_mc_drop(struct sock *sk, int ifindex,
 		      const struct in6_addr *addr);
+
+int ip6_sock_set_v6only(struct sock *sk, bool val);
+
 #endif /* _NET_IPV6_H */
diff --git a/net/ipv6/ip6_udp_tunnel.c b/net/ipv6/ip6_udp_tunnel.c
index 6523609516d25..bc4ee5cb14c8b 100644
--- a/net/ipv6/ip6_udp_tunnel.c
+++ b/net/ipv6/ip6_udp_tunnel.c
@@ -25,10 +25,7 @@ int udp_sock_create6(struct net *net, struct udp_port_cfg *cfg,
 		goto error;
 
 	if (cfg->ipv6_v6only) {
-		int val = 1;
-
-		err = kernel_setsockopt(sock, IPPROTO_IPV6, IPV6_V6ONLY,
-					(char *) &val, sizeof(val));
+		err = ip6_sock_set_v6only(sock->sk, true);
 		if (err < 0)
 			goto error;
 	}
diff --git a/net/ipv6/ipv6_sockglue.c b/net/ipv6/ipv6_sockglue.c
index 18d05403d3b52..f26224bb3e098 100644
--- a/net/ipv6/ipv6_sockglue.c
+++ b/net/ipv6/ipv6_sockglue.c
@@ -136,6 +136,17 @@ static bool setsockopt_needs_rtnl(int optname)
 	return false;
 }
 
+int ip6_sock_set_v6only(struct sock *sk, bool val)
+{
+	if (inet_sk(sk)->inet_num)
+		return -EINVAL;
+	lock_sock(sk);
+	sk->sk_ipv6only = val;
+	release_sock(sk);
+	return 0;
+}
+EXPORT_SYMBOL(ip6_sock_set_v6only);
+
 static int do_ipv6_setsockopt(struct sock *sk, int level, int optname,
 		    char __user *optval, unsigned int optlen)
 {
diff --git a/net/sunrpc/svcsock.c b/net/sunrpc/svcsock.c
index 7a4f01c79e0f1..7fa7fedec3c5a 100644
--- a/net/sunrpc/svcsock.c
+++ b/net/sunrpc/svcsock.c
@@ -1328,7 +1328,6 @@ static struct svc_xprt *svc_create_socket(struct svc_serv *serv,
 	struct sockaddr *newsin = (struct sockaddr *)&addr;
 	int		newlen;
 	int		family;
-	int		val;
 	RPC_IFDEBUG(char buf[RPC_MAX_ADDRBUFLEN]);
 
 	dprintk("svc: svc_create_socket(%s, %d, %s)\n",
@@ -1364,11 +1363,8 @@ static struct svc_xprt *svc_create_socket(struct svc_serv *serv,
 	 * getting requests from IPv4 remotes.  Those should
 	 * be shunted to a PF_INET listener via rpcbind.
 	 */
-	val = 1;
-	if (family == PF_INET6)
-		kernel_setsockopt(sock, SOL_IPV6, IPV6_V6ONLY,
-					(char *)&val, sizeof(val));
-
+	if (family == PF_INET6 && IS_REACHABLE(CONFIG_IPV6))
+		ip6_sock_set_v6only(sock->sk, true);
 	if (type == SOCK_STREAM)
 		sock->sk->sk_reuse = SK_CAN_REUSE; /* allow address reuse */
 	error = kernel_bind(sock, sin, len);
-- 
2.26.2
