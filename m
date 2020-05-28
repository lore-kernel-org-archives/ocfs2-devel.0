From: Christoph Hellwig <hch@lst.de>
Date: Thu, 28 May 2020 07:12:11 +0200
Subject: [Ocfs2-devel] [PATCH 03/28] net: add sock_set_priority
In-Reply-To: <20200528051236.620353-1-hch@lst.de>
References: <20200528051236.620353-1-hch@lst.de>
Message-ID: <20200528051236.620353-4-hch@lst.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>
Cc: Eric Dumazet <edumazet@google.com>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, Jon Maloy <jmaloy@redhat.com>, Ying Xue <ying.xue@windriver.com>, drbd-dev@lists.linbit.com, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, linux-nvme@lists.infradead.org, target-devel@vger.kernel.org, linux-afs@lists.infradead.org, linux-cifs@vger.kernel.org, cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com, netdev@vger.kernel.org, ceph-devel@vger.kernel.org, rds-devel@oss.oracle.com, linux-nfs@vger.kernel.org, tipc-discussion@lists.sourceforge.net, Sagi Grimberg <sagi@grimberg.me>

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
