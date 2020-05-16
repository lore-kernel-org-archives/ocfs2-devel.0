From: David Laight <David.Laight@ACULAB.COM>
Date: Sat, 16 May 2020 15:11:40 +0000
Subject: [Ocfs2-devel] [PATCH 27/33] sctp: export sctp_setsockopt_bindx
In-Reply-To: <129070.1589556002@warthog.procyon.org.uk>
References: <20200514062820.GC8564@lst.de>
	<20200513062649.2100053-1-hch@lst.de>
	<20200513062649.2100053-28-hch@lst.de>
	<20200513180058.GB2491@localhost.localdomain>
	<129070.1589556002@warthog.procyon.org.uk>
Message-ID: <05d946ae948946158dbfcbc07939b799@AcuMS.aculab.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: 'David Howells' <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Marcelo Ricardo Leitner <marcelo.leitner-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-sctp-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-sctp-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-afs-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-afs-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org" <drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>, "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "rds-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org" <rds-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "cluster-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <cluster-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alexey Kuznetsov <kuznet-v/Mj1YrvjDBInbfyfbPRSQ@public.gmane.org>, "linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, ceph-devel-u79uwXL29TY@public.gmane.org

From: David Howells
> Sent: 15 May 2020 16:20
> Christoph Hellwig <hch@lst.de> wrote:
> 
> > > The advantage on using kernel_setsockopt here is that sctp module will
> > > only be loaded if dlm actually creates a SCTP socket.  With this
> > > change, sctp will be loaded on setups that may not be actually using
> > > it. It's a quite big module and might expose the system.
> >
> > True.  Not that the intent is to kill kernel space callers of setsockopt,
> > as I plan to remove the set_fs address space override used for it.
> 
> For getsockopt, does it make sense to have the core kernel load optval/optlen
> into a buffer before calling the protocol driver?  Then the driver need not
> see the userspace pointer at all.
> 
> Similar could be done for setsockopt - allocate a buffer of the size requested
> by the user inside the kernel and pass it into the driver, then copy the data
> back afterwards.

Yes, it also simplifies all the compat code.
And there is a BPF test in setsockopt that also wants to
pass on a kernel buffer.

I'm willing to sit and write the patch.
Quoting from a post I made later on Friday.

Basically:

This patch sequence (to be written) does the following:

Patch 1: Change __sys_setsockopt() to allocate a kernel buffer,
         copy the data into it then call set_fs(KERNEL_DS).
         An on-stack buffer (say 64 bytes) will be used for
         small transfers.

Patch 2: The same for __sys_getsockopt().

Patch 3: Compat setsockopt.

Patch 4: Compat getsockopt.

Patch 5: Remove the user copies from the global socket options code.

Patches 6 to n-1; Remove the user copies from the per-protocol code.

Patch n: Remove the set_fs(KERNEL_DS) from the entry points.

This should be bisectable.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)
