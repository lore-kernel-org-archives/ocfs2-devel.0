From: David Laight <David.Laight@ACULAB.COM>
Date: Thu, 21 May 2020 10:46:33 +0000
Subject: [Ocfs2-devel] remove kernel_setsockopt and kernel_getsockopt v2
In-Reply-To: <20200521091150.GA8401@lst.de>
References: <20200520195509.2215098-1-hch@lst.de>
	<138a17dfff244c089b95f129e4ea2f66@AcuMS.aculab.com>
	<20200521091150.GA8401@lst.de>
Message-ID: <b7c7cf98999f4167b821f4425896e4e8@AcuMS.aculab.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: 'Christoph Hellwig' <hch@lst.de>
Cc: "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, Eric Dumazet <edumazet@google.com>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Jon Maloy <jmaloy@redhat.com>, Ying Xue <ying.xue@windriver.com>, "drbd-dev@lists.linbit.com" <drbd-dev@lists.linbit.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "linux-afs@lists.infradead.org" <linux-afs@lists.infradead.org>

From: 'Christoph Hellwig'
> Sent: 21 May 2020 10:12
...
> > I worried about whether getsockopt() should read the entire
> > user buffer first. SCTP needs the some of it often (including a
> > sockaddr_storage in one case), TCP needs it once.
> > However the cost of reading a few words is small, and a big
> > buffer probably needs setting to avoid leaking kernel
> > memory if the structure has holes or fields that don't get set.
> > Reading from userspace solves both issues.
> 
> As mention in the thread on the last series:  That was my first idea, but
> we have way to many sockopts, especially in obscure protocols that just
> hard code the size.  The chance of breaking userspace in a way that can't
> be fixed without going back to passing user pointers to get/setsockopt
> is way to high to commit to such a change unfortunately.

Right the syscall stubs probably can't do it.
But the per-protocol ones can for the main protocols.

I posted a patch for SCTP yesterday that removes 800 lines
of source and 8k of object code.
Even that needs a horrid bodge for one request where the
length returned has to be less than the data copied!

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)
