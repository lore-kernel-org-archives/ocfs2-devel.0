From: David Howells <dhowells@redhat.com>
Date: Fri, 15 May 2020 16:15:24 +0100
Subject: [Ocfs2-devel] [PATCH 21/33] ipv4: add ip_sock_set_mtu_discover
In-Reply-To: <20200514062622.GA8564@lst.de>
References: <20200514062622.GA8564@lst.de>
	<20200513062649.2100053-22-hch@lst.de>
	<20200513062649.2100053-1-hch@lst.de>
	<3123898.1589375861@warthog.procyon.org.uk>
Message-ID: <128700.1589555724@warthog.procyon.org.uk>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch@lst.de>
Cc: dhowells@redhat.com, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Eric Dumazet <edumazet@google.com>, linux-nvme@lists.infradead.org, linux-sctp@vger.kernel.org, target-devel@vger.kernel.org, linux-afs@lists.infradead.org, drbd-dev@lists.linbit.com, linux-cifs@vger.kernel.org, rds-devel@oss.oracle.com, linux-rdma@vger.kernel.org, cluster-devel@redhat.com, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, linux-block@vger.kernel.org, ceph-devel@vger.kernel.org, linux-nfs@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, netdev@vger.kernel.org, Vlad Yasevich <vyasevich@gmail.com>, linux-kernel@vger.kernel.org, Jon Maloy <jmaloy@redhat.com>, Ying Xue <ying>

Christoph Hellwig <hch@lst.de> wrote:

> > > +		ip_sock_set_mtu_discover(conn->params.local->socket->sk,
> > > +				IP_PMTUDISC_DONT);
> > 
> > Um... The socket in question could be an AF_INET6 socket, not an AF_INET4
> > socket - I presume it will work in that case.  If so:
> 
> Yes, the implementation of that sockopt, including the inet_sock
> structure where these options are set is shared between ipv4 and ipv6.

Great!  Could you note that either in the patch description or in the
kerneldoc attached to the function?

Thanks,
David
