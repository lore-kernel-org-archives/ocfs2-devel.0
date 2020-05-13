From: Christoph Hellwig <hch@lst.de>
Date: Wed, 13 May 2020 08:26:38 +0200
Subject: [Ocfs2-devel] [PATCH 23/33] ipv6: add ip6_sock_set_recverr
In-Reply-To: <20200513062649.2100053-1-hch@lst.de>
References: <20200513062649.2100053-1-hch@lst.de>
Message-ID: <20200513062649.2100053-24-hch@lst.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>
Cc: Eric Dumazet <edumazet@google.com>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Jon Maloy <jmaloy@redhat.com>, Ying Xue <ying.xue@windriver.com>, drbd-dev@lists.linbit.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, linux-nvme@lists.infradead.org, target-devel@vger.kernel.org, linux-afs@lists.infradead.org, linux-cifs@vger.kernel.org, cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com, netdev@vger.kernel.org, linux-sctp@vger.kernel.org, ceph-devel@vger.kernel.org, rds-devel@oss.oracle.com, linux-nfs@vger.kernel.org

Add a helper to directly set the IPV6_RECVERR sockopt from kernel space
without going through a fake uaccess.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/net/ipv6.h       |  1 +
 net/ipv6/ipv6_sockglue.c | 10 ++++++++++
 net/rxrpc/local_object.c | 10 ++--------
 3 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index e24b59201a00d..69bc1651aaef8 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -1176,5 +1176,6 @@ int ipv6_sock_mc_drop(struct sock *sk, int ifindex,
 		      const struct in6_addr *addr);
 
 int ip6_sock_set_v6only(struct sock *sk, bool val);
+void ip6_sock_set_recverr(struct sock *sk, bool val);
 
 #endif /* _NET_IPV6_H */
diff --git a/net/ipv6/ipv6_sockglue.c b/net/ipv6/ipv6_sockglue.c
index f26224bb3e098..3c67626b6f5a9 100644
--- a/net/ipv6/ipv6_sockglue.c
+++ b/net/ipv6/ipv6_sockglue.c
@@ -147,6 +147,16 @@ int ip6_sock_set_v6only(struct sock *sk, bool val)
 }
 EXPORT_SYMBOL(ip6_sock_set_v6only);
 
+void ip6_sock_set_recverr(struct sock *sk, bool val)
+{
+	lock_sock(sk);
+	inet6_sk(sk)->recverr = val;
+	if (!val)
+		skb_queue_purge(&sk->sk_error_queue);
+	release_sock(sk);
+}
+EXPORT_SYMBOL(ip6_sock_set_recverr);
+
 static int do_ipv6_setsockopt(struct sock *sk, int level, int optname,
 		    char __user *optval, unsigned int optlen)
 {
diff --git a/net/rxrpc/local_object.c b/net/rxrpc/local_object.c
index 20236ddecd2ef..5e356a63aa791 100644
--- a/net/rxrpc/local_object.c
+++ b/net/rxrpc/local_object.c
@@ -107,7 +107,7 @@ static struct rxrpc_local *rxrpc_alloc_local(struct rxrpc_net *rxnet,
 static int rxrpc_open_socket(struct rxrpc_local *local, struct net *net)
 {
 	struct sock *usk;
-	int ret, opt;
+	int ret;
 
 	_enter("%p{%d,%d}",
 	       local, local->srx.transport_type, local->srx.transport.family);
@@ -157,13 +157,7 @@ static int rxrpc_open_socket(struct rxrpc_local *local, struct net *net)
 	switch (local->srx.transport.family) {
 	case AF_INET6:
 		/* we want to receive ICMPv6 errors */
-		opt = 1;
-		ret = kernel_setsockopt(local->socket, SOL_IPV6, IPV6_RECVERR,
-					(char *) &opt, sizeof(opt));
-		if (ret < 0) {
-			_debug("setsockopt failed");
-			goto error;
-		}
+		ip6_sock_set_recverr(local->socket->sk, true);
 
 		/* Fall through and set IPv4 options too otherwise we don't get
 		 * errors from IPv4 packets sent through the IPv6 socket.
-- 
2.26.2
