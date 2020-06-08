From: Christoph Hellwig <hch@lst.de>
Date: Mon, 8 Jun 2020 08:14:05 +0200
Subject: [Ocfs2-devel] [PATCH] Fix build failure of OCFS2 when TCP/IP is
	disabled
In-Reply-To: <20200606190827.23954-1-tseewald@gmail.com>
References: <20200606190827.23954-1-tseewald@gmail.com>
Message-ID: <20200608061405.GA17366@lst.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tom Seewald <tseewald@gmail.com>
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, netdev@vger.kernel.org, ocfs2-devel@oss.oracle.com, Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>

On Sat, Jun 06, 2020 at 02:08:26PM -0500, Tom Seewald wrote:
> After commit 12abc5ee7873 ("tcp: add tcp_sock_set_nodelay") and
> commit c488aeadcbd0 ("tcp: add tcp_sock_set_user_timeout"), building the
> kernel with OCFS2_FS=y but without INET=y causes it to fail with:
> 
> ld: fs/ocfs2/cluster/tcp.o: in function `o2net_accept_many':
> tcp.c:(.text+0x21b1): undefined reference to `tcp_sock_set_nodelay'
> ld: tcp.c:(.text+0x21c1): undefined reference to `tcp_sock_set_user_timeout
> '
> ld: fs/ocfs2/cluster/tcp.o: in function `o2net_start_connect':
> tcp.c:(.text+0x2633): undefined reference to `tcp_sock_set_nodelay'
> ld: tcp.c:(.text+0x2643): undefined reference to `tcp_sock_set_user_timeout
> '
> 
> This is due to tcp_sock_set_nodelay() and tcp_sock_set_user_timeout() being
> declared in linux/tcp.h and defined in net/ipv4/tcp.c, which depend on
> TCP/IP being enabled.
> 
> To fix this, make OCFS2_FS depend on INET=y which already requires NET=y.
> 
> Signed-off-by: Tom Seewald <tseewald@gmail.com>

Looks good, and this is the same that I did for nfsd:

Acked-by: Christoph Hellwig <hch@lst.de>
