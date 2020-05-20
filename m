From: Christoph Hellwig <hch@lst.de>
Date: Wed, 20 May 2020 21:54:43 +0200
Subject: [Ocfs2-devel] [PATCH 07/33] net: add sock_bindtoindex
In-Reply-To: <20200520195509.2215098-1-hch@lst.de>
References: <20200520195509.2215098-1-hch@lst.de>
Message-ID: <20200520195509.2215098-8-hch@lst.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Marcelo Ricardo Leitner <marcelo.leitner-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-sctp-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-afs-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rds-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cluster-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Alexey Kuznetsov <kuznet-v/Mj1YrvjDBInbfyfbPRSQ@public.gmane.org>, ceph-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Neil Horman <nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org>, Hideaki YOSHIFUJI <yoshfuji-VfPWfsRibaP+Ru+s062T9g@public.gmane.org>, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vlad Yasevich <vyasevich-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jon Maloy <jmaloy-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ying Xue <ying.xue-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>, ocfs2-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org

Add a helper to directly set the SO_BINDTOIFINDEX sockopt from kernel
space without going through a fake uaccess.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/net/sock.h        |  1 +
 net/core/sock.c           | 21 +++++++++++++++------
 net/ipv4/udp_tunnel.c     |  4 +---
 net/ipv6/ip6_udp_tunnel.c |  4 +---
 4 files changed, 18 insertions(+), 12 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 9a7b9e98685ac..cdec7bc055d5b 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2688,6 +2688,7 @@ static inline bool sk_dev_equal_l3scope(struct sock *sk, int dif)
 
 void sock_def_readable(struct sock *sk);
 
+int sock_bindtoindex(struct sock *sk, int ifindex);
 void sock_no_linger(struct sock *sk);
 void sock_set_priority(struct sock *sk, u32 priority);
 void sock_set_reuseaddr(struct sock *sk);
diff --git a/net/core/sock.c b/net/core/sock.c
index d3b1d61e4f768..23f80880fbb2c 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -566,7 +566,7 @@ struct dst_entry *sk_dst_check(struct sock *sk, u32 cookie)
 }
 EXPORT_SYMBOL(sk_dst_check);
 
-static int sock_setbindtodevice_locked(struct sock *sk, int ifindex)
+static int sock_bindtoindex_locked(struct sock *sk, int ifindex)
 {
 	int ret = -ENOPROTOOPT;
 #ifdef CONFIG_NETDEVICES
@@ -594,6 +594,18 @@ static int sock_setbindtodevice_locked(struct sock *sk, int ifindex)
 	return ret;
 }
 
+int sock_bindtoindex(struct sock *sk, int ifindex)
+{
+	int ret;
+
+	lock_sock(sk);
+	ret = sock_bindtoindex_locked(sk, ifindex);
+	release_sock(sk);
+
+	return ret;
+}
+EXPORT_SYMBOL(sock_bindtoindex);
+
 static int sock_setbindtodevice(struct sock *sk, char __user *optval,
 				int optlen)
 {
@@ -634,10 +646,7 @@ static int sock_setbindtodevice(struct sock *sk, char __user *optval,
 			goto out;
 	}
 
-	lock_sock(sk);
-	ret = sock_setbindtodevice_locked(sk, index);
-	release_sock(sk);
-
+	return sock_bindtoindex(sk, index);
 out:
 #endif
 
@@ -1216,7 +1225,7 @@ int sock_setsockopt(struct socket *sock, int level, int optname,
 		break;
 
 	case SO_BINDTOIFINDEX:
-		ret = sock_setbindtodevice_locked(sk, val);
+		ret = sock_bindtoindex_locked(sk, val);
 		break;
 
 	default:
diff --git a/net/ipv4/udp_tunnel.c b/net/ipv4/udp_tunnel.c
index 150e6f0fdbf59..2158e8bddf41c 100644
--- a/net/ipv4/udp_tunnel.c
+++ b/net/ipv4/udp_tunnel.c
@@ -22,9 +22,7 @@ int udp_sock_create4(struct net *net, struct udp_port_cfg *cfg,
 		goto error;
 
 	if (cfg->bind_ifindex) {
-		err = kernel_setsockopt(sock, SOL_SOCKET, SO_BINDTOIFINDEX,
-					(void *)&cfg->bind_ifindex,
-					sizeof(cfg->bind_ifindex));
+		err = sock_bindtoindex(sock->sk, cfg->bind_ifindex);
 		if (err < 0)
 			goto error;
 	}
diff --git a/net/ipv6/ip6_udp_tunnel.c b/net/ipv6/ip6_udp_tunnel.c
index 58956a6b66a21..6523609516d25 100644
--- a/net/ipv6/ip6_udp_tunnel.c
+++ b/net/ipv6/ip6_udp_tunnel.c
@@ -33,9 +33,7 @@ int udp_sock_create6(struct net *net, struct udp_port_cfg *cfg,
 			goto error;
 	}
 	if (cfg->bind_ifindex) {
-		err = kernel_setsockopt(sock, SOL_SOCKET, SO_BINDTOIFINDEX,
-					(void *)&cfg->bind_ifindex,
-					sizeof(cfg->bind_ifindex));
+		err = sock_bindtoindex(sock->sk, cfg->bind_ifindex);
 		if (err < 0)
 			goto error;
 	}
-- 
2.26.2
