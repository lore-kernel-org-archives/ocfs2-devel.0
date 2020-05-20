From: Christoph Hellwig <hch@lst.de>
Date: Wed, 20 May 2020 21:55:09 +0200
Subject: [Ocfs2-devel] [PATCH 33/33] net: remove kernel_setsockopt
In-Reply-To: <20200520195509.2215098-1-hch@lst.de>
References: <20200520195509.2215098-1-hch@lst.de>
Message-ID: <20200520195509.2215098-34-hch@lst.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Eric Dumazet <edumazet@google.com>, linux-nvme@lists.infradead.org, linux-sctp@vger.kernel.org, target-devel@vger.kernel.org, linux-afs@lists.infradead.org, linux-cifs@vger.kernel.org, rds-devel@oss.oracle.com, linux-rdma@vger.kernel.org, cluster-devel@redhat.com, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, drbd-dev@tron.linbit.com, ceph-devel@vger.kernel.org, linux-nfs@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, netdev@vger.kernel.org, Vlad Yasevich <vyasevich@gmail.com>, linux-kernel@vger.kernel.org, Jon Maloy <jmaloy@redhat.com>, Ying Xue <ying.xue@windriver.com>, ocfs2-devel@oss.oracle.com

No users left.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/net.h |  2 --
 net/socket.c        | 31 -------------------------------
 2 files changed, 33 deletions(-)

diff --git a/include/linux/net.h b/include/linux/net.h
index 74ef5d7315f70..e10f378194a59 100644
--- a/include/linux/net.h
+++ b/include/linux/net.h
@@ -303,8 +303,6 @@ int kernel_connect(struct socket *sock, struct sockaddr *addr, int addrlen,
 		   int flags);
 int kernel_getsockname(struct socket *sock, struct sockaddr *addr);
 int kernel_getpeername(struct socket *sock, struct sockaddr *addr);
-int kernel_setsockopt(struct socket *sock, int level, int optname, char *optval,
-		      unsigned int optlen);
 int kernel_sendpage(struct socket *sock, struct page *page, int offset,
 		    size_t size, int flags);
 int kernel_sendpage_locked(struct sock *sk, struct page *page, int offset,
diff --git a/net/socket.c b/net/socket.c
index 81a98b6cbd087..976426d03f099 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -3624,37 +3624,6 @@ int kernel_getpeername(struct socket *sock, struct sockaddr *addr)
 }
 EXPORT_SYMBOL(kernel_getpeername);
 
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
