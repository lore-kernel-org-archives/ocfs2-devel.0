From: Christoph Hellwig <hch@lst.de>
Date: Thu, 28 May 2020 07:12:28 +0200
Subject: [Ocfs2-devel] [PATCH 20/28] ipv4: add ip_sock_set_recverr
In-Reply-To: <20200528051236.620353-1-hch@lst.de>
References: <20200528051236.620353-1-hch@lst.de>
Message-ID: <20200528051236.620353-21-hch@lst.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>
Cc: Eric Dumazet <edumazet@google.com>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, Jon Maloy <jmaloy@redhat.com>, Ying Xue <ying.xue@windriver.com>, drbd-dev@lists.linbit.com, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, linux-nvme@lists.infradead.org, target-devel@vger.kernel.org, linux-afs@lists.infradead.org, linux-cifs@vger.kernel.org, cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com, netdev@vger.kernel.org, ceph-devel@vger.kernel.org, rds-devel@oss.oracle.com, linux-nfs@vger.kernel.org, tipc-discussion@lists.sourceforge.net, David Howells <dhowells@redhat.com>

Add a helper to directly set the IP_RECVERR sockopt from kernel space
without going through a fake uaccess.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: David Howells <dhowells@redhat.com>
---
 include/net/ip.h         | 1 +
 net/ipv4/ip_sockglue.c   | 8 ++++++++
 net/rxrpc/local_object.c | 8 +-------
 3 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/include/net/ip.h b/include/net/ip.h
index 5f5d8226b6abc..f063a491b9063 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -766,6 +766,7 @@ static inline bool inetdev_valid_mtu(unsigned int mtu)
 }
 
 void ip_sock_set_freebind(struct sock *sk);
+void ip_sock_set_recverr(struct sock *sk);
 void ip_sock_set_tos(struct sock *sk, int val);
 
 #endif	/* _IP_H */
diff --git a/net/ipv4/ip_sockglue.c b/net/ipv4/ip_sockglue.c
index 767838d2030d8..aca6b81da9bae 100644
--- a/net/ipv4/ip_sockglue.c
+++ b/net/ipv4/ip_sockglue.c
@@ -589,6 +589,14 @@ void ip_sock_set_freebind(struct sock *sk)
 }
 EXPORT_SYMBOL(ip_sock_set_freebind);
 
+void ip_sock_set_recverr(struct sock *sk)
+{
+	lock_sock(sk);
+	inet_sk(sk)->recverr = true;
+	release_sock(sk);
+}
+EXPORT_SYMBOL(ip_sock_set_recverr);
+
 /*
  *	Socket option code for IP. This is the end of the line after any
  *	TCP,UDP etc options on an IP socket.
diff --git a/net/rxrpc/local_object.c b/net/rxrpc/local_object.c
index 5ea2bd01fdd59..4c0e8fe5ec1fb 100644
--- a/net/rxrpc/local_object.c
+++ b/net/rxrpc/local_object.c
@@ -171,13 +171,7 @@ static int rxrpc_open_socket(struct rxrpc_local *local, struct net *net)
 		/* Fall through */
 	case AF_INET:
 		/* we want to receive ICMP errors */
-		opt = 1;
-		ret = kernel_setsockopt(local->socket, SOL_IP, IP_RECVERR,
-					(char *) &opt, sizeof(opt));
-		if (ret < 0) {
-			_debug("setsockopt failed");
-			goto error;
-		}
+		ip_sock_set_recverr(local->socket->sk);
 
 		/* we want to set the don't fragment bit */
 		opt = IP_PMTUDISC_DO;
-- 
2.26.2
