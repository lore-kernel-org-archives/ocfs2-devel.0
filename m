From: David Howells <dhowells@redhat.com>
Date: Wed, 13 May 2020 14:24:26 +0100
Subject: [Ocfs2-devel] [PATCH 20/33] ipv4: add ip_sock_set_recverr
In-Reply-To: <20200513062649.2100053-21-hch@lst.de>
References: <20200513062649.2100053-21-hch@lst.de>
	<20200513062649.2100053-1-hch@lst.de>
Message-ID: <3124489.1589376266@warthog.procyon.org.uk>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch@lst.de>
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org, dhowells@redhat.com, linux-sctp@vger.kernel.org, target-devel@vger.kernel.org, linux-afs@lists.infradead.org, linux-cifs@vger.kernel.org, rds-devel@oss.oracle.com, linux-rdma@vger.kernel.org, cluster-devel@redhat.com, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, linux-block@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>, drbd-dev@tron.linbit.com, ceph-devel@vger.kernel.org, linux-nfs@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, netdev@vger.kernel.org, Vlad Yasevich <vyasevich@gmail.com>, Eric Dumazet <edumazet@google.com>, Jon Maloy <jmaloy@redhat.com>, Ying Xue <ying.xue@windriver.com>, "David S. Miller" <davem@davemloft.net>, ocfs2-devel@oss.oracle.com

Christoph Hellwig <hch@lst.de> wrote:

> Add a helper to directly set the IP_RECVERR sockopt from kernel space
> without going through a fake uaccess.

It looks like if this is an AF_INET6 socket, it will just pass the message
straight through to AF_INET4, so:

Reviewed-by: David Howells <dhowells@redhat.com>
