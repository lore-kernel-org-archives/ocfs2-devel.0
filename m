From: Christoph Hellwig <hch@lst.de>
Date: Wed, 13 May 2020 08:26:27 +0200
Subject: [Ocfs2-devel] [PATCH 12/33] tcp: add tcp_sock_set_quickack
In-Reply-To: <20200513062649.2100053-1-hch@lst.de>
References: <20200513062649.2100053-1-hch@lst.de>
Message-ID: <20200513062649.2100053-13-hch@lst.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>
Cc: Eric Dumazet <edumazet@google.com>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Jon Maloy <jmaloy@redhat.com>, Ying Xue <ying.xue@windriver.com>, drbd-dev@lists.linbit.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, linux-nvme@lists.infradead.org, target-devel@vger.kernel.org, linux-afs@lists.infradead.org, linux-cifs@vger.kernel.org, cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com, netdev@vger.kernel.org, linux-sctp@vger.kernel.org, ceph-devel@vger.kernel.org, rds-devel@oss.oracle.com, linux-nfs@vger.kernel.org

Add a helper to directly set the TCP_QUICKACK sockopt from kernel space
without going through a fake uaccess.  Cleanup the callers to avoid
pointless wrappers now that this is a simple function call.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/drbd/drbd_int.h      |  7 ------
 drivers/block/drbd/drbd_receiver.c |  5 ++--
 include/linux/tcp.h                |  1 +
 net/ipv4/tcp.c                     | 39 ++++++++++++++++++++----------
 4 files changed, 29 insertions(+), 23 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index e24bba87c8e02..14345a87c7cc5 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -1570,13 +1570,6 @@ extern void drbd_set_recv_tcq(struct drbd_device *device, int tcq_enabled);
 extern void _drbd_clear_done_ee(struct drbd_device *device, struct list_head *to_be_freed);
 extern int drbd_connected(struct drbd_peer_device *);
 
-static inline void drbd_tcp_quickack(struct socket *sock)
-{
-	int val = 2;
-	(void) kernel_setsockopt(sock, SOL_TCP, TCP_QUICKACK,
-			(char*)&val, sizeof(val));
-}
-
 /* sets the number of 512 byte sectors of our virtual device */
 void drbd_set_my_capacity(struct drbd_device *device, sector_t size);
 
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index da5a9ee896a43..cdd317ae97021 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -1223,7 +1223,7 @@ static int drbd_recv_header_maybe_unplug(struct drbd_connection *connection, str
 		 * quickly as possible, and let remote TCP know what we have
 		 * received so far. */
 		if (err == -EAGAIN) {
-			drbd_tcp_quickack(connection->data.socket);
+			tcp_sock_set_quickack(connection->data.socket->sk, 2);
 			drbd_unplug_all_devices(connection);
 		}
 		if (err > 0) {
@@ -4959,8 +4959,7 @@ static int receive_UnplugRemote(struct drbd_connection *connection, struct packe
 {
 	/* Make sure we've acked all the TCP data associated
 	 * with the data requests being unplugged */
-	drbd_tcp_quickack(connection->data.socket);
-
+	tcp_sock_set_quickack(connection->data.socket->sk, 2);
 	return 0;
 }
 
diff --git a/include/linux/tcp.h b/include/linux/tcp.h
index 533610b6ae420..e7ab6da5111b5 100644
--- a/include/linux/tcp.h
+++ b/include/linux/tcp.h
@@ -496,5 +496,6 @@ int tcp_skb_shift(struct sk_buff *to, struct sk_buff *from, int pcount,
 
 void tcp_sock_set_cork(struct sock *sk, bool on);
 void tcp_sock_set_nodelay(struct sock *sk, bool on);
+void tcp_sock_set_quickack(struct sock *sk, int val);
 
 #endif	/* _LINUX_TCP_H */
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 300ce622607d8..c681f43f0bb85 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2845,6 +2845,31 @@ void tcp_sock_set_nodelay(struct sock *sk, bool on)
 }
 EXPORT_SYMBOL(tcp_sock_set_nodelay);
 
+static void __tcp_sock_set_quickack(struct sock *sk, int val)
+{
+	if (!val) {
+		inet_csk_enter_pingpong_mode(sk);
+		return;
+	}
+
+	inet_csk_exit_pingpong_mode(sk);
+	if ((1 << sk->sk_state) & (TCPF_ESTABLISHED | TCPF_CLOSE_WAIT) &&
+	    inet_csk_ack_scheduled(sk)) {
+		inet_csk(sk)->icsk_ack.pending |= ICSK_ACK_PUSHED;
+		tcp_cleanup_rbuf(sk, 1);
+		if (!(val & 1))
+			inet_csk_enter_pingpong_mode(sk);
+	}
+}
+
+void tcp_sock_set_quickack(struct sock *sk, int val)
+{
+	lock_sock(sk);
+	__tcp_sock_set_quickack(sk, val);
+	release_sock(sk);
+}
+EXPORT_SYMBOL(tcp_sock_set_quickack);
+
 /*
  *	Socket option code for TCP.
  */
@@ -3085,19 +3110,7 @@ static int do_tcp_setsockopt(struct sock *sk, int level,
 		break;
 
 	case TCP_QUICKACK:
-		if (!val) {
-			inet_csk_enter_pingpong_mode(sk);
-		} else {
-			inet_csk_exit_pingpong_mode(sk);
-			if ((1 << sk->sk_state) &
-			    (TCPF_ESTABLISHED | TCPF_CLOSE_WAIT) &&
-			    inet_csk_ack_scheduled(sk)) {
-				icsk->icsk_ack.pending |= ICSK_ACK_PUSHED;
-				tcp_cleanup_rbuf(sk, 1);
-				if (!(val & 1))
-					inet_csk_enter_pingpong_mode(sk);
-			}
-		}
+		__tcp_sock_set_quickack(sk, val);
 		break;
 
 #ifdef CONFIG_TCP_MD5SIG
-- 
2.26.2
