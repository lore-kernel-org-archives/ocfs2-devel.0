From: Christoph Hellwig <hch@lst.de>
Date: Thu, 28 May 2020 07:12:30 +0200
Subject: [Ocfs2-devel] [PATCH 22/28] ipv4: add ip_sock_set_pktinfo
In-Reply-To: <20200528051236.620353-1-hch@lst.de>
References: <20200528051236.620353-1-hch@lst.de>
Message-ID: <20200528051236.620353-23-hch@lst.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>
Cc: linux-cifs@vger.kernel.org, rds-devel@oss.oracle.com, cluster-devel@redhat.com, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, Jon Maloy <jmaloy@redhat.com>, Ying Xue <ying.xue@windriver.com>, Eric Dumazet <edumazet@google.com>, target-devel@vger.kernel.org, tipc-discussion@lists.sourceforge.net, linux-nfs@vger.kernel.org, drbd-dev@tron.linbit.com, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, ceph-devel@vger.kernel.org, linux-afs@lists.infradead.org, ocfs2-devel@oss.oracle.com, linux-rdma@vger.kernel.org

Add a helper to directly set the IP_PKTINFO sockopt from kernel
space without going through a fake uaccess.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/net/ip.h       | 1 +
 net/ipv4/ip_sockglue.c | 8 ++++++++
 net/sunrpc/svcsock.c   | 5 ++---
 3 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/include/net/ip.h b/include/net/ip.h
index d3649c49dd333..04ebe7bf54c6a 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -767,6 +767,7 @@ static inline bool inetdev_valid_mtu(unsigned int mtu)
 
 void ip_sock_set_freebind(struct sock *sk);
 int ip_sock_set_mtu_discover(struct sock *sk, int val);
+void ip_sock_set_pktinfo(struct sock *sk);
 void ip_sock_set_recverr(struct sock *sk);
 void ip_sock_set_tos(struct sock *sk, int val);
 
diff --git a/net/ipv4/ip_sockglue.c b/net/ipv4/ip_sockglue.c
index aa115be11dcfb..84ec3703c9091 100644
--- a/net/ipv4/ip_sockglue.c
+++ b/net/ipv4/ip_sockglue.c
@@ -608,6 +608,14 @@ int ip_sock_set_mtu_discover(struct sock *sk, int val)
 }
 EXPORT_SYMBOL(ip_sock_set_mtu_discover);
 
+void ip_sock_set_pktinfo(struct sock *sk)
+{
+	lock_sock(sk);
+	inet_sk(sk)->cmsg_flags |= IP_CMSG_PKTINFO;
+	release_sock(sk);
+}
+EXPORT_SYMBOL(ip_sock_set_pktinfo);
+
 /*
  *	Socket option code for IP. This is the end of the line after any
  *	TCP,UDP etc options on an IP socket.
diff --git a/net/sunrpc/svcsock.c b/net/sunrpc/svcsock.c
index 6773dacc64d8e..7a805d165689c 100644
--- a/net/sunrpc/svcsock.c
+++ b/net/sunrpc/svcsock.c
@@ -616,9 +616,8 @@ static void svc_udp_init(struct svc_sock *svsk, struct svc_serv *serv)
 	/* make sure we get destination address info */
 	switch (svsk->sk_sk->sk_family) {
 	case AF_INET:
-		level = SOL_IP;
-		optname = IP_PKTINFO;
-		break;
+		ip_sock_set_pktinfo(svsk->sk_sock->sk);
+		return;
 	case AF_INET6:
 		level = SOL_IPV6;
 		optname = IPV6_RECVPKTINFO;
-- 
2.26.2
