From: Christoph Hellwig <hch@lst.de>
Date: Wed, 13 May 2020 08:26:46 +0200
Subject: [Ocfs2-devel] [PATCH 31/33] net: remove kernel_setsockopt
In-Reply-To: <20200513062649.2100053-1-hch@lst.de>
References: <20200513062649.2100053-1-hch@lst.de>
Message-ID: <20200513062649.2100053-32-hch@lst.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>
Cc: Eric Dumazet <edumazet@google.com>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Jon Maloy <jmaloy@redhat.com>, Ying Xue <ying.xue@windriver.com>, drbd-dev@lists.linbit.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, linux-nvme@lists.infradead.org, target-devel@vger.kernel.org, linux-afs@lists.infradead.org, linux-cifs@vger.kernel.org, cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com, netdev@vger.kernel.org, linux-sctp@vger.kernel.org, ceph-devel@vger.kernel.org, rds-devel@oss.oracle.com, linux-nfs@vger.kernel.org

No users left.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/net.h |  2 --
 net/socket.c        | 31 -------------------------------
 2 files changed, 33 deletions(-)

diff --git a/include/linux/net.h b/include/linux/net.h
index 6451425e828f5..ece7513326293 100644
--- a/include/linux/net.h
+++ b/include/linux/net.h
@@ -305,8 +305,6 @@ int kernel_getsockname(struct socket *sock, struct sockaddr *addr);
 int kernel_getpeername(struct socket *sock, struct sockaddr *addr);
 int kernel_getsockopt(struct socket *sock, int level, int optname, char *optval,
 		      int *optlen);
-int kernel_setsockopt(struct socket *sock, int level, int optname, char *optval,
-		      unsigned int optlen);
 int kernel_sendpage(struct socket *sock, struct page *page, int offset,
 		    size_t size, int flags);
 int kernel_sendpage_locked(struct sock *sk, struct page *page, int offset,
diff --git a/net/socket.c b/net/socket.c
index 1c9a7260a41de..f37c3ef508691 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -3749,37 +3749,6 @@ int kernel_getsockopt(struct socket *sock, int level, int optname,
 }
 EXPORT_SYMBOL(kernel_getsockopt);
 
-/**
- *	kernel_setsockopt - set a socket option (kernel space)
- *	@sock: socket
- *	@level: API level (SOL_SOCKET, ...)
- *	@optname: option tag
- *	@optval: option value
- *	@optlen: option length
- *
- *	Returns 0 or an error.
- */
-
-int kernel_setsockopt(struct socket *sock, int level, int optname,
-			char *optval, unsigned int optlen)
-{
-	mm_segment_t oldfs = get_fs();
-	char __user *uoptval;
-	int err;
-
-	uoptval = (char __user __force *) optval;
-
-	set_fs(KERNEL_DS);
-	if (level == SOL_SOCKET)
-		err = sock_setsockopt(sock, level, optname, uoptval, optlen);
-	else
-		err = sock->ops->setsockopt(sock, level, optname, uoptval,
-					    optlen);
-	set_fs(oldfs);
-	return err;
-}
-EXPORT_SYMBOL(kernel_setsockopt);
-
 /**
  *	kernel_sendpage - send a &page through a socket (kernel space)
  *	@sock: socket
-- 
2.26.2
