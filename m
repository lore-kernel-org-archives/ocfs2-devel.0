From: David Laight <David.Laight@ACULAB.COM>
Date: Sat, 16 May 2020 15:21:15 +0000
Subject: [Ocfs2-devel] [PATCH 27/33] sctp: export sctp_setsockopt_bindx
In-Reply-To: <20200515152459.GA28995@lst.de>
References: <20200514062820.GC8564@lst.de>
	<20200513062649.2100053-1-hch@lst.de>
	<20200513062649.2100053-28-hch@lst.de>
	<20200513180058.GB2491@localhost.localdomain>
	<129070.1589556002@warthog.procyon.org.uk>
	<20200515152459.GA28995@lst.de>
Message-ID: <c23030de384747ae83c6c0813bd4f1c0@AcuMS.aculab.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: 'Christoph Hellwig' <hch@lst.de>, David Howells <dhowells@redhat.com>
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Eric Dumazet <edumazet@google.com>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "linux-afs@lists.infradead.org" <linux-afs@lists.infradead.org>, "drbd-dev@lists.linbit.com" <drbd-dev@lists.linbit.com>, "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>, "rds-devel@oss.oracle.com" <rds-devel@oss.oracle.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "cluster-devel@redhat.com" <cluster-devel@redhat.com>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Jakub Kicinski <kuba@kernel.org>, ceph-devel@vger.ker

From: Christoph Hellwig
> Sent: 15 May 2020 16:25
> On Fri, May 15, 2020 at 04:20:02PM +0100, David Howells wrote:
> > Christoph Hellwig <hch@lst.de> wrote:
> >
> > > > The advantage on using kernel_setsockopt here is that sctp module will
> > > > only be loaded if dlm actually creates a SCTP socket.  With this
> > > > change, sctp will be loaded on setups that may not be actually using
> > > > it. It's a quite big module and might expose the system.
> > >
> > > True.  Not that the intent is to kill kernel space callers of setsockopt,
> > > as I plan to remove the set_fs address space override used for it.
> >
> > For getsockopt, does it make sense to have the core kernel load optval/optlen
> > into a buffer before calling the protocol driver?  Then the driver need not
> > see the userspace pointer at all.
> >
> > Similar could be done for setsockopt - allocate a buffer of the size requested
> > by the user inside the kernel and pass it into the driver, then copy the data
> > back afterwards.
> 
> I did look into that initially.  The problem is that tons of sockopts
> entirely ignore optlen and just use a fixed size.  So I fear that there
> could be tons of breakage if we suddently respect it.  Otherwise that
> would be a pretty nice way to handle the situation.

I'd guess that most application use the correct size for setsockopt().
(Well, apart from using 4 instead of 1.)

It is certainly possible to always try to read in 64 bytes
regardless of the supplied length, but handle the EFAULT case
by shortening the buffer.

Historically getsockopt() only wrote the length back.
Treating 0 and garbage as (say) 4k and letting the protocol
code set a shorten the copy to user might work.
All short transfers would want to use an on-stack buffer,
so slight oversizes could also be allowed for.

OTOH if i did a getsockopt() with too short a length I wouldn't
want the kernel to trash my program memory.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)
