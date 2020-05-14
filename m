From: David Miller <davem@davemloft.net>
Date: Thu, 14 May 2020 13:03:57 -0700 (PDT)
Subject: [Ocfs2-devel] remove kernel_setsockopt and kernel_getsockopt
In-Reply-To: <a76440f7305c4653877ff2abff499f4e@AcuMS.aculab.com>
References: <756758e8f0e34e2e97db470609f5fbba@AcuMS.aculab.com>
	<20200514101838.GA12548@lst.de>
	<a76440f7305c4653877ff2abff499f4e@AcuMS.aculab.com>
Message-ID: <20200514.130357.1683454520750761365.davem@davemloft.net>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David.Laight-ZS65k/vG3HxXrIkS9f7CXA@public.gmane.org
Cc: hch-jcswGhMUV9g@public.gmane.org, joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org, kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, kuznet-v/Mj1YrvjDBInbfyfbPRSQ@public.gmane.org, yoshfuji-VfPWfsRibaP+Ru+s062T9g@public.gmane.org, vyasevich-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org, marcelo.leitner-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, jmaloy-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ying.xue-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-afs-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cluster-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ocfs2-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sctp-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ceph-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rds-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

From: David Laight <David.Laight@ACULAB.COM>
Date: Thu, 14 May 2020 10:26:41 +0000

> I doubt we are the one company with out-of-tree drivers
> that use the kernel_socket interface.

Not our problem.
