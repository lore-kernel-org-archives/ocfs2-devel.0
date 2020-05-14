From: Christoph Hellwig <hch@lst.de>
Date: Thu, 14 May 2020 08:26:22 +0200
Subject: [Ocfs2-devel] [PATCH 21/33] ipv4: add ip_sock_set_mtu_discover
In-Reply-To: <3123898.1589375861@warthog.procyon.org.uk>
References: <20200513062649.2100053-22-hch@lst.de>
	<20200513062649.2100053-1-hch@lst.de>
	<3123898.1589375861@warthog.procyon.org.uk>
Message-ID: <20200514062622.GA8564@lst.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Marcelo Ricardo Leitner <marcelo.leitner-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sctp-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-afs-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rds-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, cluster-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Alexey Kuznetsov <kuznet-v/Mj1YrvjDBInbfyfbPRSQ@public.gmane.org>, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, ceph-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Neil Horman <nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org>, Hideaki YOSHIFUJI <yoshfuji-VfPWfsRibaP+Ru+s062T9g@public.gmane.org>, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vlad Yasevich <vyasevich-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jon Maloy <jmaloy-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ying Xue <ying.xue-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, ocfs2-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org

On Wed, May 13, 2020 at 02:17:41PM +0100, David Howells wrote:
> Christoph Hellwig <hch@lst.de> wrote:
> 
> > +		ip_sock_set_mtu_discover(conn->params.local->socket->sk,
> > +				IP_PMTUDISC_DONT);
> 
> Um... The socket in question could be an AF_INET6 socket, not an AF_INET4
> socket - I presume it will work in that case.  If so:

Yes, the implementation of that sockopt, including the inet_sock
structure where these options are set is shared between ipv4 and ipv6.
