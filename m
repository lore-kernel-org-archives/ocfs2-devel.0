From: David Laight <David.Laight@ACULAB.COM>
Date: Thu, 21 May 2020 08:01:33 +0000
Subject: [Ocfs2-devel] remove kernel_setsockopt and kernel_getsockopt v2
In-Reply-To: <20200520195509.2215098-1-hch@lst.de>
References: <20200520195509.2215098-1-hch@lst.de>
Message-ID: <138a17dfff244c089b95f129e4ea2f66@AcuMS.aculab.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: 'Christoph Hellwig' <hch@lst.de>, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>
Cc: Eric Dumazet <edumazet@google.com>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Jon Maloy <jmaloy@redhat.com>, Ying Xue <ying.xue@windriver.com>, "drbd-dev@lists.linbit.com" <drbd-dev@lists.linbit.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "linux-afs@lists.infradead.org" <linux-afs@lists.infradead.org>, "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>, cluster-devel@redhat.co

From: Christoph Hellwig
> Sent: 20 May 2020 20:55
> 
> this series removes the kernel_setsockopt and kernel_getsockopt
> functions, and instead switches their users to small functions that
> implement setting (or in one case getting) a sockopt directly using
> a normal kernel function call with type safety and all the other
> benefits of not having a function call.
> 
> In some cases these functions seem pretty heavy handed as they do
> a lock_sock even for just setting a single variable, but this mirrors
> the real setsockopt implementation unlike a few drivers that just set
> set the fields directly.

How much does this increase the kernel code by?

You are also replicating a lot of code making it more
difficult to maintain.

I don't think the performance of an socket option code
really matters - it is usually done once when a socket
is initialised and the other costs of establishing a
connection will dominate.

Pulling the user copies outside the [gs]etsocksopt switch
statement not only reduces the code size (source and object)
and trivially allows kernel_[sg]sockopt() to me added to
the list of socket calls.

It probably isn't possible to pull the usercopies right
out into the syscall wrapper because of some broken
requests.

I worried about whether getsockopt() should read the entire
user buffer first. SCTP needs the some of it often (including a
sockaddr_storage in one case), TCP needs it once.
However the cost of reading a few words is small, and a big
buffer probably needs setting to avoid leaking kernel
memory if the structure has holes or fields that don't get set.
Reading from userspace solves both issues.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)
