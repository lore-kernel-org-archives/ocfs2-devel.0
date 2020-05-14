From: Matthew Wilcox <willy@infradead.org>
Date: Thu, 14 May 2020 12:35:27 -0700
Subject: [Ocfs2-devel] remove kernel_setsockopt and kernel_getsockopt
In-Reply-To: <c2034daa0a23454abb5e5c5714807735@AcuMS.aculab.com>
References: <20200513062649.2100053-1-hch@lst.de>
	<ecc165c33962d964d518c80de605af632eee0474.camel@perches.com>
	<756758e8f0e34e2e97db470609f5fbba@AcuMS.aculab.com>
	<20200514101838.GA12548@lst.de>
	<a76440f7305c4653877ff2abff499f4e@AcuMS.aculab.com>
	<20200514103450.GA12901@lst.de>
	<c2034daa0a23454abb5e5c5714807735@AcuMS.aculab.com>
Message-ID: <20200514193527.GB16070@bombadil.infradead.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Laight <David.Laight@aculab.com>
Cc: 'Christoph Hellwig' <hch@lst.de>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, Eric Dumazet <edumazet@google.com>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "linux-afs@lists.infradead.org" <linux-afs@lists.infradead.org>, "drbd-dev@lists.linbit.com" <drbd-dev@lists.linbit.com>, "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>, "rds-devel@oss.oracle.com" <rds-devel@oss.oracle.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "cluster-devel@redhat.com" <cluster-devel@redhat.com>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, 'Joe Perches' <joe@perches.com>, Jakub Kicinski <kuba@kernel.org>, cep

On Thu, May 14, 2020 at 11:11:34AM +0000, David Laight wrote:
> From: 'Christoph Hellwig'
> > Sent: 14 May 2020 11:35
> > On Thu, May 14, 2020 at 10:26:41AM +0000, David Laight wrote:
> > > From: Christoph Hellwig
> > > > Only for those were we have users, and all those are covered.
> > >
> > > What do we tell all our users when our kernel SCTP code
> > > no longer works?
> > 
> > We only care about in-tree modules, just like for every other interface
> > in the kernel.
> 
> Even if our management agreed to release the code and the code
> layout matched the kernel guidelines you still wouldn't want
> two large drivers that implement telephony functionality
> for hardware that very few people actually have.

Oh, good point, we'll change the policy for all modules and make every
interface in the kernel stable from now on to cater to your special case.
