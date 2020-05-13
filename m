From: David Miller <davem@davemloft.net>
Date: Wed, 13 May 2020 12:12:10 -0700 (PDT)
Subject: [Ocfs2-devel] remove kernel_setsockopt and kernel_getsockopt
In-Reply-To: <20200513062649.2100053-1-hch@lst.de>
References: <20200513062649.2100053-1-hch@lst.de>
Message-ID: <20200513.121210.1508400748648949138.davem@davemloft.net>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: hch@lst.de
Cc: kuba@kernel.org, edumazet@google.com, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, vyasevich@gmail.com, nhorman@tuxdriver.com, marcelo.leitner@gmail.com, jmaloy@redhat.com, ying.xue@windriver.com, drbd-dev@lists.linbit.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, linux-nvme@lists.infradead.org, target-devel@vger.kernel.org, linux-afs@lists.infradead.org, linux-cifs@vger.kernel.org, cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com, netdev@vger.kernel.org, linux-sctp@vger.kernel.org, ceph-devel@vger.kernel.org, rds-devel@oss.oracle.com, linux-nfs@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>
Date: Wed, 13 May 2020 08:26:15 +0200

> Hi Dave,
> 
> this series removes the kernel_setsockopt and kernel_getsockopt
> functions, and instead switches their users to small functions that
> implement setting (or in one case getting) a sockopt directly using
> a normal kernel function call with type safety and all the other
> benefits of not having a function call.
> 
> In some cases these functions seem pretty heavy handed as they do
> a lock_sock even for just setting a single variable, but this mirrors
> the real setsockopt implementation - counter to that a few kernel
> drivers just set the fields directly already.
> 
> Nevertheless the diffstat looks quite promising:
> 
>  42 files changed, 721 insertions(+), 799 deletions(-)

Overall I'm fine with these changes, but three things need to happen
before I can think about applying this:

1) Address David's feedback about the ip_mtu*() calls that can occur
   on ipv6 sockets too.

2) Handle the feedback about dlm now bringing in sctp even if sctp
   sockets are not even used because of the symbol dependency.

3) Add the rxrpc documentation requested by David.

Thank you.
