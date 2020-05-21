From: 'Christoph Hellwig' <hch@lst.de>
Date: Thu, 21 May 2020 11:08:12 +0200
Subject: [Ocfs2-devel] [PATCH 31/33] sctp: add sctp_sock_set_nodelay
In-Reply-To: <0a6839ab0ba04fcf9b9c92784c9564aa@AcuMS.aculab.com>
References: <20200520195509.2215098-1-hch@lst.de>
	<20200520195509.2215098-32-hch@lst.de>
	<20200520231001.GU2491@localhost.localdomain>
	<20200520.162355.2212209708127373208.davem@davemloft.net>
	<20200520233913.GV2491@localhost.localdomain>
	<20200521083442.GA7771@lst.de>
	<0a6839ab0ba04fcf9b9c92784c9564aa@AcuMS.aculab.com>
Message-ID: <20200521090812.GA8330@lst.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Laight <David.Laight-ZS65k/vG3HxXrIkS9f7CXA@public.gmane.org>
Cc: Marcelo Ricardo Leitner <marcelo.leitner-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org" <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-sctp-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-sctp-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-afs-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-afs-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org" <drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>, "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "rds-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org" <rds-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, 'Christoph Hellwig' <hch-jcswGhMUV9g@public.gmane.org>, "cluster-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <cluster-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "kuznet-v/Mj1YrvjDBInbfyfbPRSQ@public.gmane.org" <kuznet-v/Mj1YrvjDBInbfyfbPRSQ@public.gmane.org>, "kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "ceph-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <ceph-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Thu, May 21, 2020 at 09:06:19AM +0000, David Laight wrote:
> > > The comment still applies, though. (re the duplication)
> > 
> > Where do you see duplication?
> 
> The whole thing just doesn't scale.
> 
> As soon as you get to the slightly more complex requests
> like SCTP_INITMSG (which should probably be called to
> set the required number of data streams) you've either
> got replicated code or nested wrappers.

None of that is relevant to setting the nodelay option.  If you actually
read through the series you'd say that whenever there was non-trivial
logic it is shared with getopt.  However sharing just for purpose of
sharing doesn't make sense, so where the kernel API ended up just
setting a flag after taking the sock lock I did not opt for it.
