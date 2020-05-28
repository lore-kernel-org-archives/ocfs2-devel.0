From: David Miller <davem@davemloft.net>
Date: Thu, 28 May 2020 11:12:05 -0700 (PDT)
Subject: [Ocfs2-devel] remove most callers of kernel_setsockopt v3
In-Reply-To: <20200528051236.620353-1-hch@lst.de>
References: <20200528051236.620353-1-hch@lst.de>
Message-ID: <20200528.111205.608949763790224771.davem@davemloft.net>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: hch@lst.de
Cc: kuba@kernel.org, edumazet@google.com, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, jmaloy@redhat.com, ying.xue@windriver.com, drbd-dev@lists.linbit.com, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, linux-nvme@lists.infradead.org, target-devel@vger.kernel.org, linux-afs@lists.infradead.org, linux-cifs@vger.kernel.org, cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com, netdev@vger.kernel.org, ceph-devel@vger.kernel.org, rds-devel@oss.oracle.com, linux-nfs@vger.kernel.org, tipc-discussion@lists.sourceforge.net

From: Christoph Hellwig <hch@lst.de>
Date: Thu, 28 May 2020 07:12:08 +0200

> this series removes most callers of the kernel_setsockopt functions, and
> instead switches their users to small functions that implement setting a
> sockopt directly using a normal kernel function call with type safety and
> all the other benefits of not having a function call.
> 
> In some cases these functions seem pretty heavy handed as they do
> a lock_sock even for just setting a single variable, but this mirrors
> the real setsockopt implementation unlike a few drivers that just set
> set the fields directly.
 ...

Series applied, thanks Christoph.
