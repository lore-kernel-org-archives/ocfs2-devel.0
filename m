From: David Laight <David.Laight@ACULAB.COM>
Date: Thu, 14 May 2020 11:11:34 +0000
Subject: [Ocfs2-devel] remove kernel_setsockopt and kernel_getsockopt
In-Reply-To: <20200514103450.GA12901@lst.de>
References: <20200513062649.2100053-1-hch@lst.de>
	<ecc165c33962d964d518c80de605af632eee0474.camel@perches.com>
	<756758e8f0e34e2e97db470609f5fbba@AcuMS.aculab.com>
	<20200514101838.GA12548@lst.de>
	<a76440f7305c4653877ff2abff499f4e@AcuMS.aculab.com>
	<20200514103450.GA12901@lst.de>
Message-ID: <c2034daa0a23454abb5e5c5714807735@AcuMS.aculab.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: 'Christoph Hellwig' <hch@lst.de>
Cc: 'Joe Perches' <joe@perches.com>, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, Eric Dumazet <edumazet@google.com>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Jon Maloy <jmaloy@redhat.com>, Ying Xue <ying.xue@windriver.com>, "drbd-dev@lists.linbit.com" <drbd-dev@lists.linbit.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "target-devel@vger.kernel.org" <targ>

From: 'Christoph Hellwig'
> Sent: 14 May 2020 11:35
> On Thu, May 14, 2020 at 10:26:41AM +0000, David Laight wrote:
> > From: Christoph Hellwig
> > > Only for those were we have users, and all those are covered.
> >
> > What do we tell all our users when our kernel SCTP code
> > no longer works?
> 
> We only care about in-tree modules, just like for every other interface
> in the kernel.

Even if our management agreed to release the code and the code
layout matched the kernel guidelines you still wouldn't want
two large drivers that implement telephony functionality
for hardware that very few people actually have.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)
