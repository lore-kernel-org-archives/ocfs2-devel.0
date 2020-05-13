From: Christoph Hellwig <hch@lst.de>
Date: Wed, 13 May 2020 08:26:36 +0200
Subject: [Ocfs2-devel] [PATCH 21/33] ipv4: add ip_sock_set_mtu_discover
In-Reply-To: <20200513062649.2100053-1-hch@lst.de>
References: <20200513062649.2100053-1-hch@lst.de>
Message-ID: <20200513062649.2100053-22-hch@lst.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>
Cc: Eric Dumazet <edumazet@google.com>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Jon Maloy <jmaloy@redhat.com>, Ying Xue <ying.xue@windriver.com>, drbd-dev@lists.linbit.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, linux-nvme@lists.infradead.org, target-devel@vger.kernel.org, linux-afs@lists.infradead.org, linux-cifs@vger.kernel.org, cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com, netdev@vger.kernel.org, linux-sctp@vger.kernel.org, ceph-devel@vger.kernel.org, rds-devel@oss.oracle.com, linux-nfs@vger.kernel.org

Add a helper to directly set the IP_MTU_DISCOVER sockopt from kernel
space without going through a fake uaccess.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/net/ip.h         |  2 ++
 net/ipv4/ip_sockglue.c   | 22 ++++++++++++++++++++++
 net/rxrpc/local_object.c |  8 +-------
 net/rxrpc/output.c       | 14 +++++---------
 net/sunrpc/svcsock.c     |  5 ++---
 5 files changed, 32 insertions(+), 19 deletions(-)

diff --git a/include/net/ip.h b/include/net/ip.h
index 7ab8140b54429..536eaffec59f0 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -768,5 +768,7 @@ static inline bool inetdev_valid_mtu(unsigned int mtu)
 void ip_sock_set_tos(struct sock *sk, int val);
 void ip_sock_set_freebind(struct sock *sk, bool val);
 void ip_sock_set_recverr(struct sock *sk, bool val);
+int ip_sock_set_mtu_discover(struct sock *sk, int val);
+void ip_sock_set_pktinfo(struct sock *sk, bool val);
 
 #endif	/* _IP_H */
diff --git a/net/ipv4/ip_sockglue.c b/net/ipv4/ip_sockglue.c
index 9abecc3195520..df6ce0a7b0e3d 100644
--- a/net/ipv4/ip_sockglue.c
+++ b/net/ipv4/ip_sockglue.c
@@ -599,6 +599,28 @@ void ip_sock_set_recverr(struct sock *sk, bool val)
 }
 EXPORT_SYMBOL(ip_sock_set_recverr);
 
+int ip_sock_set_mtu_discover(struct sock *sk, int val)
+{
+	if (val < IP_PMTUDISC_DONT || val > IP_PMTUDISC_OMIT)
+		return -EINVAL;
+	lock_sock(sk);
+	inet_sk(sk)->pmtudisc = val;
+	release_sock(sk);
+	return 0;
+}
+EXPORT_SYMBOL(ip_sock_set_mtu_discover);
+
+void ip_sock_set_pktinfo(struct sock *sk, bool val)
+{
+	lock_sock(sk);
+	if (val)
+		inet_sk(sk)->cmsg_flags |= IP_CMSG_PKTINFO;
+	else
+		inet_sk(sk)->cmsg_flags &= ~IP_CMSG_PKTINFO;
+	release_sock(sk);
+}
+EXPORT_SYMBOL(ip_sock_set_pktinfo);
+
 /*
  *	Socket option code for IP. This is the end of the line after any
  *	TCP,UDP etc options on an IP socket.
diff --git a/net/rxrpc/local_object.c b/net/rxrpc/local_object.c
index 1b87b8a9ff725..20236ddecd2ef 100644
--- a/net/rxrpc/local_object.c
+++ b/net/rxrpc/local_object.c
@@ -174,13 +174,7 @@ static int rxrpc_open_socket(struct rxrpc_local *local, struct net *net)
 		ip_sock_set_recverr(local->socket->sk, true);
 
 		/* we want to set the don't fragment bit */
-		opt = IP_PMTUDISC_DO;
-		ret = kernel_setsockopt(local->socket, SOL_IP, IP_MTU_DISCOVER,
-					(char *) &opt, sizeof(opt));
-		if (ret < 0) {
-			_debug("setsockopt failed");
-			goto error;
-		}
+		ip_sock_set_mtu_discover(local->socket->sk, IP_PMTUDISC_DO);
 
 		/* We want receive timestamps. */
 		sock_set_timestamps(local->socket->sk, true, false, true);
diff --git a/net/rxrpc/output.c b/net/rxrpc/output.c
index 90e263c6aa69e..ad0234e1e1713 100644
--- a/net/rxrpc/output.c
+++ b/net/rxrpc/output.c
@@ -321,7 +321,7 @@ int rxrpc_send_data_packet(struct rxrpc_call *call, struct sk_buff *skb,
 	struct kvec iov[2];
 	rxrpc_serial_t serial;
 	size_t len;
-	int ret, opt;
+	int ret;
 
 	_enter(",{%d}", skb->len);
 
@@ -476,18 +476,14 @@ int rxrpc_send_data_packet(struct rxrpc_call *call, struct sk_buff *skb,
 	switch (conn->params.local->srx.transport.family) {
 	case AF_INET6:
 	case AF_INET:
-		opt = IP_PMTUDISC_DONT;
-		kernel_setsockopt(conn->params.local->socket,
-				  SOL_IP, IP_MTU_DISCOVER,
-				  (char *)&opt, sizeof(opt));
+		ip_sock_set_mtu_discover(conn->params.local->socket->sk,
+				IP_PMTUDISC_DONT);
 		ret = kernel_sendmsg(conn->params.local->socket, &msg,
 				     iov, 2, len);
 		conn->params.peer->last_tx_at = ktime_get_seconds();
 
-		opt = IP_PMTUDISC_DO;
-		kernel_setsockopt(conn->params.local->socket,
-				  SOL_IP, IP_MTU_DISCOVER,
-				  (char *)&opt, sizeof(opt));
+		ip_sock_set_mtu_discover(conn->params.local->socket->sk,
+				IP_PMTUDISC_DO);
 		break;
 
 	default:
diff --git a/net/sunrpc/svcsock.c b/net/sunrpc/svcsock.c
index 0f6b78d0e6170..7a4f01c79e0f1 100644
--- a/net/sunrpc/svcsock.c
+++ b/net/sunrpc/svcsock.c
@@ -616,9 +616,8 @@ static void svc_udp_init(struct svc_sock *svsk, struct svc_serv *serv)
 	/* make sure we get destination address info */
 	switch (svsk->sk_sk->sk_family) {
 	case AF_INET:
-		level = SOL_IP;
-		optname = IP_PKTINFO;
-		break;
+		ip_sock_set_pktinfo(svsk->sk_sock->sk, true);
+		return;
 	case AF_INET6:
 		level = SOL_IPV6;
 		optname = IPV6_RECVPKTINFO;
-- 
2.26.2
