From: Christoph Hellwig <hch@lst.de>
Date: Wed, 20 May 2020 21:55:08 +0200
Subject: [Ocfs2-devel] [PATCH 32/33] net: add a new bind_add method
In-Reply-To: <20200520195509.2215098-1-hch@lst.de>
References: <20200520195509.2215098-1-hch@lst.de>
Message-ID: <20200520195509.2215098-33-hch@lst.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>
Cc: Eric Dumazet <edumazet@google.com>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Jon Maloy <jmaloy@redhat.com>, Ying Xue <ying.xue@windriver.com>, drbd-dev@lists.linbit.com, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, linux-nvme@lists.infradead.org, target-devel@vger.kernel.org, linux-afs@lists.infradead.org, linux-cifs@vger.kernel.org, cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com, netdev@vger.kernel.org, linux-sctp@vger.kernel.org, ceph-devel@vger.kernel.org, rds-devel@oss.oracle.com, linux-nfs@vger.kernel.org

The SCTP protocol allows to bind multiple address to a socket.  That
feature is currently only exposed as a socket option.  Add a bind_add
method struct proto that allows to bind additional addresses, and
switch the dlm code to use the method instead of going through the
socket option from kernel space.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/dlm/lowcomms.c  |  9 +++------
 include/net/sock.h |  6 +++++-
 net/core/sock.c    |  8 ++++++++
 net/sctp/socket.c  | 23 +++++++++++++++++++++++
 4 files changed, 39 insertions(+), 7 deletions(-)

diff --git a/fs/dlm/lowcomms.c b/fs/dlm/lowcomms.c
index 9f1c3cdc9d653..3543a8fec9075 100644
--- a/fs/dlm/lowcomms.c
+++ b/fs/dlm/lowcomms.c
@@ -882,6 +882,7 @@ static void writequeue_entry_complete(struct writequeue_entry *e, int completed)
 static int sctp_bind_addrs(struct connection *con, uint16_t port)
 {
 	struct sockaddr_storage localaddr;
+	struct sockaddr *addr = (struct sockaddr *)&localaddr;
 	int i, addr_len, result = 0;
 
 	for (i = 0; i < dlm_local_count; i++) {
@@ -889,13 +890,9 @@ static int sctp_bind_addrs(struct connection *con, uint16_t port)
 		make_sockaddr(&localaddr, port, &addr_len);
 
 		if (!i)
-			result = kernel_bind(con->sock,
-					     (struct sockaddr *)&localaddr,
-					     addr_len);
+			result = kernel_bind(con->sock, addr, addr_len);
 		else
-			result = kernel_setsockopt(con->sock, SOL_SCTP,
-						   SCTP_SOCKOPT_BINDX_ADD,
-						   (char *)&localaddr, addr_len);
+			result = sock_bind_add(con->sock->sk, addr, addr_len);
 
 		if (result < 0) {
 			log_print("Can't bind to %d addr number %d, %d.\n",
diff --git a/include/net/sock.h b/include/net/sock.h
index d994daa418ec2..6e9f713a78607 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1156,7 +1156,9 @@ struct proto {
 	int			(*sendpage)(struct sock *sk, struct page *page,
 					int offset, size_t size, int flags);
 	int			(*bind)(struct sock *sk,
-					struct sockaddr *uaddr, int addr_len);
+					struct sockaddr *addr, int addr_len);
+	int			(*bind_add)(struct sock *sk,
+					struct sockaddr *addr, int addr_len);
 
 	int			(*backlog_rcv) (struct sock *sk,
 						struct sk_buff *skb);
@@ -2698,4 +2700,6 @@ void sock_set_reuseaddr(struct sock *sk);
 void sock_set_reuseport(struct sock *sk);
 void sock_set_sndtimeo(struct sock *sk, s64 secs);
 
+int sock_bind_add(struct sock *sk, struct sockaddr *addr, int addr_len);
+
 #endif	/* _SOCK_H */
diff --git a/net/core/sock.c b/net/core/sock.c
index 2ca3425b519c0..61ec573221a60 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -3712,3 +3712,11 @@ bool sk_busy_loop_end(void *p, unsigned long start_time)
 }
 EXPORT_SYMBOL(sk_busy_loop_end);
 #endif /* CONFIG_NET_RX_BUSY_POLL */
+
+int sock_bind_add(struct sock *sk, struct sockaddr *addr, int addr_len)
+{
+	if (!sk->sk_prot->bind_add)
+		return -EOPNOTSUPP;
+	return sk->sk_prot->bind_add(sk, addr, addr_len);
+}
+EXPORT_SYMBOL(sock_bind_add);
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 827a9903ee288..8a0b9258f65c0 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -1057,6 +1057,27 @@ static int sctp_setsockopt_bindx(struct sock *sk,
 	return err;
 }
 
+static int sctp_bind_add(struct sock *sk, struct sockaddr *addr,
+		int addrlen)
+{
+	struct sctp_af *af = sctp_get_af_specific(addr->sa_family);
+	int err;
+
+	if (!af || af->sockaddr_len > addrlen)
+		return -EINVAL;
+	err = security_sctp_bind_connect(sk, SCTP_SOCKOPT_BINDX_ADD, addr,
+			addrlen);
+	if (err)
+		return err;
+
+	lock_sock(sk);
+	err = sctp_do_bind(sk, (union sctp_addr *)addr, af->sockaddr_len);
+	if (!err)
+		err = sctp_send_asconf_add_ip(sk, addr, 1);
+	release_sock(sk);
+	return err;
+}
+
 static int sctp_connect_new_asoc(struct sctp_endpoint *ep,
 				 const union sctp_addr *daddr,
 				 const struct sctp_initmsg *init,
@@ -9625,6 +9646,7 @@ struct proto sctp_prot = {
 	.sendmsg     =	sctp_sendmsg,
 	.recvmsg     =	sctp_recvmsg,
 	.bind        =	sctp_bind,
+	.bind_add    =  sctp_bind_add,
 	.backlog_rcv =	sctp_backlog_rcv,
 	.hash        =	sctp_hash,
 	.unhash      =	sctp_unhash,
@@ -9667,6 +9689,7 @@ struct proto sctpv6_prot = {
 	.sendmsg	= sctp_sendmsg,
 	.recvmsg	= sctp_recvmsg,
 	.bind		= sctp_bind,
+	.bind_add	= sctp_bind_add,
 	.backlog_rcv	= sctp_backlog_rcv,
 	.hash		= sctp_hash,
 	.unhash		= sctp_unhash,
-- 
2.26.2
