From: David Laight <David.Laight@ACULAB.COM>
Date: Thu, 14 May 2020 08:29:30 +0000
Subject: [Ocfs2-devel] remove kernel_setsockopt and kernel_getsockopt
In-Reply-To: <ecc165c33962d964d518c80de605af632eee0474.camel@perches.com>
References: <20200513062649.2100053-1-hch@lst.de>
	<ecc165c33962d964d518c80de605af632eee0474.camel@perches.com>
Message-ID: <756758e8f0e34e2e97db470609f5fbba@AcuMS.aculab.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: 'Joe Perches' <joe@perches.com>, Christoph Hellwig <hch@lst.de>, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>
Cc: Eric Dumazet <edumazet@google.com>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Jon Maloy <jmaloy@redhat.com>, Ying Xue <ying.xue@windriver.com>, "drbd-dev@lists.linbit.com" <drbd-dev@lists.linbit.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "linux-afs@lists.infradead.org" <linux-afs@lists.infradead.org>, linux-cifs@vger.kerne

From: Joe Perches
> Sent: 13 May 2020 18:39
> On Wed, 2020-05-13 at 08:26 +0200, Christoph Hellwig wrote:
> > this series removes the kernel_setsockopt and kernel_getsockopt
> > functions, and instead switches their users to small functions that
> > implement setting (or in one case getting) a sockopt directly using
> > a normal kernel function call with type safety and all the other
> > benefits of not having a function call.
> >
> > In some cases these functions seem pretty heavy handed as they do
> > a lock_sock even for just setting a single variable, but this mirrors
> > the real setsockopt implementation - counter to that a few kernel
> > drivers just set the fields directly already.
> >
> > Nevertheless the diffstat looks quite promising:
> >
> >  42 files changed, 721 insertions(+), 799 deletions(-)

I missed this patch going through.
Massive NACK.

You need to export functions that do most of the socket options
for all protocols.
As well as REUSADDR and NODELAY SCTP has loads because a lot
of stuff that should have been extra system calls got piled
into setsockopt.

An alternate solution would be to move the copy_to/from_user()
into a wrapper function so that the kernel_[sg]etsockopt()
functions would bypass them completely.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)
