From: David Laight <David.Laight@ACULAB.COM>
Date: Thu, 21 May 2020 09:06:19 +0000
Subject: [Ocfs2-devel] [PATCH 31/33] sctp: add sctp_sock_set_nodelay
In-Reply-To: <20200521083442.GA7771@lst.de>
References: <20200520195509.2215098-1-hch@lst.de>
	<20200520195509.2215098-32-hch@lst.de>
	<20200520231001.GU2491@localhost.localdomain>
	<20200520.162355.2212209708127373208.davem@davemloft.net>
	<20200520233913.GV2491@localhost.localdomain>
	<20200521083442.GA7771@lst.de>
Message-ID: <0a6839ab0ba04fcf9b9c92784c9564aa@AcuMS.aculab.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: 'Christoph Hellwig' <hch-jcswGhMUV9g@public.gmane.org>, Marcelo Ricardo Leitner <marcelo.leitner-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, "kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org" <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "kuznet-v/Mj1YrvjDBInbfyfbPRSQ@public.gmane.org" <kuznet-v/Mj1YrvjDBInbfyfbPRSQ@public.gmane.org>, "yoshfuji-VfPWfsRibaP+Ru+s062T9g@public.gmane.org" <yoshfuji-VfPWfsRibaP+Ru+s062T9g@public.gmane.org>, "vyasevich-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <vyasevich-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org" <nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org>, "jmaloy-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <jmaloy-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "ying.xue-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org" <ying.xue-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>, "drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org" <drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-afs-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-afs-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>

From: Christoph Hellwig
> Sent: 21 May 2020 09:35
> On Wed, May 20, 2020 at 08:39:13PM -0300, Marcelo Ricardo Leitner wrote:
> > On Wed, May 20, 2020 at 04:23:55PM -0700, David Miller wrote:
> > > From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> > > Date: Wed, 20 May 2020 20:10:01 -0300
> > >
> > > > The duplication with sctp_setsockopt_nodelay() is quite silly/bad.
> > > > Also, why have the 'true' hardcoded? It's what dlm uses, yes, but the
> > > > API could be a bit more complete than that.
> > >
> > > The APIs are being designed based upon what in-tree users actually
> > > make use of.  We can expand things later if necessary.
> >
> > Sometimes expanding things later can be though, thus why the worry.
> > But ok, I get it. Thanks.
> >
> > The comment still applies, though. (re the duplication)
> 
> Where do you see duplication?

The whole thing just doesn't scale.

As soon as you get to the slightly more complex requests
like SCTP_INITMSG (which should probably be called to
set the required number of data streams) you've either
got replicated code or nested wrappers.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)
