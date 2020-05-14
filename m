From: David Laight <David.Laight@ACULAB.COM>
Date: Thu, 14 May 2020 09:51:00 +0000
Subject: [Ocfs2-devel] [PATCH 32/33] sctp: add sctp_sock_get_primary_addr
In-Reply-To: <20200513180302.GC2491@localhost.localdomain>
References: <20200513062649.2100053-1-hch@lst.de>
	<20200513062649.2100053-33-hch@lst.de>
	<20200513180302.GC2491@localhost.localdomain>
Message-ID: <d112e18bfbdd40dfb219ed2c1f2082d4@AcuMS.aculab.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: 'Marcelo Ricardo Leitner' <marcelo.leitner@gmail.com>, Christoph Hellwig <hch@lst.de>
Cc: "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, Eric Dumazet <edumazet@google.com>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Jon Maloy <jmaloy@redhat.com>, Ying Xue <ying.xue@windriver.com>, "drbd-dev@lists.linbit.com" <drbd-dev@lists.linbit.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "linux-afs@lists.infradead.org" <linux-afs@lists.infradead.org>

From: Marcelo Ricardo Leitner
> Sent: 13 May 2020 19:03
> 
> On Wed, May 13, 2020 at 08:26:47AM +0200, Christoph Hellwig wrote:
> > Add a helper to directly get the SCTP_PRIMARY_ADDR sockopt from kernel
> > space without going through a fake uaccess.
> 
> Same comment as on the other dlm/sctp patch.

Wouldn't it be best to write sctp_[gs]etsockotp() that
use a kernel buffer and then implement the user-space
calls using a wrapper that does the copies to an on-stack
(or malloced if big) buffer.

That will also simplify the code be removing all the copies
and -EFAULT returns.
Only the size checks will be needed and the code can assume
the buffer is at least the size of the on-stack buffer.

Our SCTP code uses SO_REUSADDR, SCTP_EVENTS, SCTP_NODELAY,
SCTP_STATUS, SCTP_INITMSG, IPV6_ONLY, SCTP_SOCKOPT_BINDX_ADD
and SO_LINGER.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)
