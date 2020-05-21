From: 'Christoph Hellwig' <hch@lst.de>
Date: Thu, 21 May 2020 11:11:50 +0200
Subject: [Ocfs2-devel] remove kernel_setsockopt and kernel_getsockopt v2
In-Reply-To: <138a17dfff244c089b95f129e4ea2f66@AcuMS.aculab.com>
References: <20200520195509.2215098-1-hch@lst.de>
	<138a17dfff244c089b95f129e4ea2f66@AcuMS.aculab.com>
Message-ID: <20200521091150.GA8401@lst.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Laight <David.Laight-ZS65k/vG3HxXrIkS9f7CXA@public.gmane.org>
Cc: Marcelo Ricardo Leitner <marcelo.leitner-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-sctp-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-sctp-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-afs-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-afs-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org" <drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>, "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "rds-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org" <rds-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, 'Christoph Hellwig' <hch-jcswGhMUV9g@public.gmane.org>, "cluster-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <cluster-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alexey Kuznetsov <kuznet-v/Mj1YrvjDBInbfyfbPRSQ@public.gmane.org>, Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "ceph-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <ceph-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Neil Horman <nhorman@tuxdriv>

On Thu, May 21, 2020 at 08:01:33AM +0000, David Laight wrote:
> How much does this increase the kernel code by?

 44 files changed, 660 insertions(+), 843 deletions(-)


> You are also replicating a lot of code making it more
> difficult to maintain.

No, I specifically don't.

> I don't think the performance of an socket option code
> really matters - it is usually done once when a socket
> is initialised and the other costs of establishing a
> connection will dominate.
> 
> Pulling the user copies outside the [gs]etsocksopt switch
> statement not only reduces the code size (source and object)
> and trivially allows kernel_[sg]sockopt() to me added to
> the list of socket calls.
> 
> It probably isn't possible to pull the usercopies right
> out into the syscall wrapper because of some broken
> requests.

Please read through the previous discussion of the rationale and the
options.  We've been there before.

> I worried about whether getsockopt() should read the entire
> user buffer first. SCTP needs the some of it often (including a
> sockaddr_storage in one case), TCP needs it once.
> However the cost of reading a few words is small, and a big
> buffer probably needs setting to avoid leaking kernel
> memory if the structure has holes or fields that don't get set.
> Reading from userspace solves both issues.

As mention in the thread on the last series:  That was my first idea, but
we have way to many sockopts, especially in obscure protocols that just
hard code the size.  The chance of breaking userspace in a way that can't
be fixed without going back to passing user pointers to get/setsockopt
is way to high to commit to such a change unfortunately.
