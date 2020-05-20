From: Christoph Hellwig <hch@lst.de>
Date: Wed, 20 May 2020 21:54:41 +0200
Subject: [Ocfs2-devel] [PATCH 05/33] net: add sock_set_priority
In-Reply-To: <20200520195509.2215098-1-hch@lst.de>
References: <20200520195509.2215098-1-hch@lst.de>
Message-ID: <20200520195509.2215098-6-hch@lst.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Marcelo Ricardo Leitner <marcelo.leitner-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-sctp-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-afs-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rds-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cluster-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Alexey Kuznetsov <kuznet-v/Mj1YrvjDBInbfyfbPRSQ@public.gmane.org>, ceph-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Neil Horman <nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org>, Hideaki YOSHIFUJI <yoshfuji-VfPWfsRibaP+Ru+s062T9g@public.gmane.org>, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vlad Yasevich <vyasevich-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jon Maloy <jmaloy-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ying Xue <ying.xue-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>, ocfs2-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org

Add a helper to directly set the SO_PRIORITY sockopt from kernel space
without going through a fake uaccess.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Sagi Grimberg <sagi@grimberg.me>
---
 drivers/nvme/host/tcp.c   | 12 ++----------
 drivers/nvme/target/tcp.c | 18 ++++--------------
 include/net/sock.h        |  1 +
 net/core/sock.c           |  8 ++++++++
 4 files changed, 15 insertions(+), 24 deletions(-)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index e72d87482eb78..a307972d33a02 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -1362,16 +1362,8 @@ static int nvme_tcp_alloc_queue(struct nvme_ctrl *nctrl,
 	 */
 	sock_no_linger(queue->sock->sk);
 
-	if (so_priority > 0) {
-		ret = kernel_setsockopt(queue->sock, SOL_SOCKET, SO_PRIORITY,
-				(char *)&so_priority, sizeof(so_priority));
-		if (ret) {
-			dev_err(ctrl->ctrl.device,
-				"failed to set SO_PRIORITY sock opt, ret %d\n",
-				ret);
-			goto err_sock;
-		}
-	}
+	if (so_priority > 0)
+		sock_set_priority(queue->sock->sk, so_priority);
 
 	/* Set socket type of service */
 	if (nctrl->opts->tos >= 0) {
diff --git a/drivers/nvme/target/tcp.c b/drivers/nvme/target/tcp.c
index e0801494b097f..f3088156d01da 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -1448,12 +1448,8 @@ static int nvmet_tcp_set_queue_sock(struct nvmet_tcp_queue *queue)
 	 */
 	sock_no_linger(sock->sk);
 
-	if (so_priority > 0) {
-		ret = kernel_setsockopt(sock, SOL_SOCKET, SO_PRIORITY,
-				(char *)&so_priority, sizeof(so_priority));
-		if (ret)
-			return ret;
-	}
+	if (so_priority > 0)
+		sock_set_priority(sock->sk, so_priority);
 
 	/* Set socket type of service */
 	if (inet->rcv_tos > 0) {
@@ -1638,14 +1634,8 @@ static int nvmet_tcp_add_port(struct nvmet_port *nport)
 		goto err_sock;
 	}
 
-	if (so_priority > 0) {
-		ret = kernel_setsockopt(port->sock, SOL_SOCKET, SO_PRIORITY,
-				(char *)&so_priority, sizeof(so_priority));
-		if (ret) {
-			pr_err("failed to set SO_PRIORITY sock opt %d\n", ret);
-			goto err_sock;
-		}
-	}
+	if (so_priority > 0)
+		sock_set_priority(port->sock->sk, so_priority);
 
 	ret = kernel_bind(port->sock, (struct sockaddr *)&port->addr,
 			sizeof(port->addr));
diff --git a/include/net/sock.h b/include/net/sock.h
index 6ed00bf009bbe..a3a43141a4be2 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2689,6 +2689,7 @@ static inline bool sk_dev_equal_l3scope(struct sock *sk, int dif)
 void sock_def_readable(struct sock *sk);
 
 void sock_no_linger(struct sock *sk);
+void sock_set_priority(struct sock *sk, u32 priority);
 void sock_set_reuseaddr(struct sock *sk);
 
 #endif	/* _SOCK_H */
diff --git a/net/core/sock.c b/net/core/sock.c
index f0f09524911c8..ceda1a9248b3e 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -729,6 +729,14 @@ void sock_no_linger(struct sock *sk)
 }
 EXPORT_SYMBOL(sock_no_linger);
 
+void sock_set_priority(struct sock *sk, u32 priority)
+{
+	lock_sock(sk);
+	sk->sk_priority = priority;
+	release_sock(sk);
+}
+EXPORT_SYMBOL(sock_set_priority);
+
 /*
  *	This is meant for all protocols to use and covers goings on
  *	at the socket level. Everything here is generic.
-- 
2.26.2
