From: Christoph Hellwig <hch@lst.de>
Date: Wed, 13 May 2020 08:26:18 +0200
Subject: [Ocfs2-devel] [PATCH 03/33] net: add sock_set_priority
In-Reply-To: <20200513062649.2100053-1-hch@lst.de>
References: <20200513062649.2100053-1-hch@lst.de>
Message-ID: <20200513062649.2100053-4-hch@lst.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>
Cc: Eric Dumazet <edumazet@google.com>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Jon Maloy <jmaloy@redhat.com>, Ying Xue <ying.xue@windriver.com>, drbd-dev@lists.linbit.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, linux-nvme@lists.infradead.org, target-devel@vger.kernel.org, linux-afs@lists.infradead.org, linux-cifs@vger.kernel.org, cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com, netdev@vger.kernel.org, linux-sctp@vger.kernel.org, ceph-devel@vger.kernel.org, rds-devel@oss.oracle.com, linux-nfs@vger.kernel.org

Add a helper to directly set the SO_PRIORITY sockopt from kernel space
without going through a fake uaccess.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/nvme/host/tcp.c   | 12 ++----------
 drivers/nvme/target/tcp.c | 18 ++++--------------
 include/net/sock.h        |  1 +
 net/core/sock.c           |  8 ++++++++
 4 files changed, 15 insertions(+), 24 deletions(-)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index 5cacb61c73229..cd6a8fc14a139 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -1362,16 +1362,8 @@ static int nvme_tcp_alloc_queue(struct nvme_ctrl *nctrl,
 	 */
 	sock_set_linger(queue->sock->sk, true, 0);
 
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
index 87aba417189d2..778c1ce3137b7 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -1448,12 +1448,8 @@ static int nvmet_tcp_set_queue_sock(struct nvmet_tcp_queue *queue)
 	 */
 	sock_set_linger(sock->sk, true, 0);
 
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
index 60890fb47fbc0..cce11782dc295 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2689,5 +2689,6 @@ static inline bool sk_dev_equal_l3scope(struct sock *sk, int dif)
 void sock_def_readable(struct sock *sk);
 void sock_set_reuseaddr(struct sock *sk, unsigned char reuse);
 void sock_set_linger(struct sock *sk, bool onoff, unsigned int linger);
+void sock_set_priority(struct sock *sk, u32 priority);
 
 #endif	/* _SOCK_H */
diff --git a/net/core/sock.c b/net/core/sock.c
index cbc5104ca3515..e9f1e2247b004 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -744,6 +744,14 @@ void sock_set_linger(struct sock *sk, bool onoff, unsigned int linger)
 }
 EXPORT_SYMBOL(sock_set_linger);
 
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
