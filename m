From: Christoph Hellwig <hch@lst.de>
Date: Thu, 28 May 2020 07:12:27 +0200
Subject: [Ocfs2-devel] [PATCH 19/28] ipv4: add ip_sock_set_freebind
In-Reply-To: <20200528051236.620353-1-hch@lst.de>
References: <20200528051236.620353-1-hch@lst.de>
Message-ID: <20200528051236.620353-20-hch@lst.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Alexey Kuznetsov <kuznet-v/Mj1YrvjDBInbfyfbPRSQ@public.gmane.org>, Hideaki YOSHIFUJI <yoshfuji-VfPWfsRibaP+Ru+s062T9g@public.gmane.org>, Jon Maloy <jmaloy-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ying Xue <ying.xue-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-afs-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cluster-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ocfs2-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ceph-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rds-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tipc-discussion-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org

Add a helper to directly set the IP_FREEBIND sockopt from kernel space
without going through a fake uaccess.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/target/iscsi/iscsi_target_login.c | 13 +++----------
 include/net/ip.h                          |  1 +
 net/ipv4/ip_sockglue.c                    |  8 ++++++++
 3 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
index b561b07a869a0..85748e3388582 100644
--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -15,6 +15,7 @@
 #include <linux/sched/signal.h>
 #include <linux/idr.h>
 #include <linux/tcp.h>        /* TCP_NODELAY */
+#include <net/ip.h>
 #include <net/ipv6.h>         /* ipv6_addr_v4mapped() */
 #include <scsi/iscsi_proto.h>
 #include <target/target_core_base.h>
@@ -855,7 +856,7 @@ int iscsit_setup_np(
 	struct sockaddr_storage *sockaddr)
 {
 	struct socket *sock = NULL;
-	int backlog = ISCSIT_TCP_BACKLOG, ret, opt = 0, len;
+	int backlog = ISCSIT_TCP_BACKLOG, ret, len;
 
 	switch (np->np_network_transport) {
 	case ISCSI_TCP:
@@ -900,15 +901,7 @@ int iscsit_setup_np(
 	if (np->np_network_transport == ISCSI_TCP)
 		tcp_sock_set_nodelay(sock->sk);
 	sock_set_reuseaddr(sock->sk);
-
-	opt = 1;
-	ret = kernel_setsockopt(sock, IPPROTO_IP, IP_FREEBIND,
-			(char *)&opt, sizeof(opt));
-	if (ret < 0) {
-		pr_err("kernel_setsockopt() for IP_FREEBIND"
-			" failed\n");
-		goto fail;
-	}
+	ip_sock_set_freebind(sock->sk);
 
 	ret = kernel_bind(sock, (struct sockaddr *)&np->np_sockaddr, len);
 	if (ret < 0) {
diff --git a/include/net/ip.h b/include/net/ip.h
index 2fc52e26fa88b..5f5d8226b6abc 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -765,6 +765,7 @@ static inline bool inetdev_valid_mtu(unsigned int mtu)
 	return likely(mtu >= IPV4_MIN_MTU);
 }
 
+void ip_sock_set_freebind(struct sock *sk);
 void ip_sock_set_tos(struct sock *sk, int val);
 
 #endif	/* _IP_H */
diff --git a/net/ipv4/ip_sockglue.c b/net/ipv4/ip_sockglue.c
index b43a29e11f4a5..767838d2030d8 100644
--- a/net/ipv4/ip_sockglue.c
+++ b/net/ipv4/ip_sockglue.c
@@ -581,6 +581,14 @@ void ip_sock_set_tos(struct sock *sk, int val)
 }
 EXPORT_SYMBOL(ip_sock_set_tos);
 
+void ip_sock_set_freebind(struct sock *sk)
+{
+	lock_sock(sk);
+	inet_sk(sk)->freebind = true;
+	release_sock(sk);
+}
+EXPORT_SYMBOL(ip_sock_set_freebind);
+
 /*
  *	Socket option code for IP. This is the end of the line after any
  *	TCP,UDP etc options on an IP socket.
-- 
2.26.2
