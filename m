From: David Laight <David.Laight@ACULAB.COM>
Date: Thu, 14 May 2020 13:27:46 +0000
Subject: [Ocfs2-devel] [PATCH 32/33] sctp: add sctp_sock_get_primary_addr
In-Reply-To: <c66e0309572345f5b0f32d078701f2d7@AcuMS.aculab.com>
References: <20200513062649.2100053-1-hch@lst.de>
	<20200513062649.2100053-33-hch@lst.de>
	<20200513180302.GC2491@localhost.localdomain>
	<d112e18bfbdd40dfb219ed2c1f2082d4@AcuMS.aculab.com>
	<c66e0309572345f5b0f32d078701f2d7@AcuMS.aculab.com>
Message-ID: <aff8f5ec8d6d44dbace63825af197086@AcuMS.aculab.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: 'Marcelo Ricardo Leitner' <marcelo.leitner@gmail.com>, 'Christoph Hellwig' <hch@lst.de>
Cc: "'David S. Miller'" <davem@davemloft.net>, 'Jakub Kicinski' <kuba@kernel.org>, 'Eric Dumazet' <edumazet@google.com>, 'Alexey Kuznetsov' <kuznet@ms2.inr.ac.ru>, 'Hideaki YOSHIFUJI' <yoshfuji@linux-ipv6.org>, 'Vlad Yasevich' <vyasevich@gmail.com>, 'Neil Horman' <nhorman@tuxdriver.com>, 'Jon Maloy' <jmaloy@redhat.com>, 'Ying Xue' <ying.xue@windriver.com>, "'drbd-dev@lists.linbit.com'" <drbd-dev@lists.linbit.com>, "'linux-block@vger.kernel.org'" <linux-block@vger.kernel.org>, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, "'linux-rdma@vger.kernel.org'" <linux-rdma@vger.kernel.org>, "'linux-nvme@lists.infradead.org'" <linux-nvme@lists.infradead.org>, "'target-devel@vger.kernel.org'" <target-devel@vger.kernel.org>

From: David Laight
> Sent: 14 May 2020 13:30
> Subject: RE: [PATCH 32/33] sctp: add sctp_sock_get_primary_addr
> 
> From: David Laight
> > Sent: 14 May 2020 10:51
> > From: Marcelo Ricardo Leitner
> > > Sent: 13 May 2020 19:03
> > >
> > > On Wed, May 13, 2020 at 08:26:47AM +0200, Christoph Hellwig wrote:
> > > > Add a helper to directly get the SCTP_PRIMARY_ADDR sockopt from kernel
> > > > space without going through a fake uaccess.
> > >
> > > Same comment as on the other dlm/sctp patch.
> >
> > Wouldn't it be best to write sctp_[gs]etsockotp() that
> > use a kernel buffer and then implement the user-space
> > calls using a wrapper that does the copies to an on-stack
> > (or malloced if big) buffer.
> 
> Actually looking at __sys_setsockopt() it calls
> BPF_CGROUP_RUN_PROG_SETSOCKOPT() which (by the look of it)
> can copy the user buffer into malloc()ed memory and
> cause set_fs(KERNEL_DS) be called.
> 
> The only way to get rid of that set_fs() is to always
> have the buffer in kernel memory when the underlying
> setsockopt() code is called.

And having started to try coding __sys_setsockopt()
and then found the compat code I suspect that would
be a whole lot more sane if the buffer was in kernel
and it knew that at least (say) 64 bytes were allocated.

The whole compat_alloc_user_space() 'crap' could probably go.

Actually it looks like an application can avoid whatever
checks BPF_CGROUP_RUN_PROG_SETSOCKOPT() is trying to do
by using the 32bit compat ioctls.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)
