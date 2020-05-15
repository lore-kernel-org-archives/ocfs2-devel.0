From: David Laight <David.Laight@ACULAB.COM>
Date: Fri, 15 May 2020 08:14:07 +0000
Subject: [Ocfs2-devel] remove kernel_setsockopt and kernel_getsockopt
In-Reply-To: <20200514.130357.1683454520750761365.davem@davemloft.net>
References: <756758e8f0e34e2e97db470609f5fbba@AcuMS.aculab.com>
	<20200514101838.GA12548@lst.de>
	<a76440f7305c4653877ff2abff499f4e@AcuMS.aculab.com>
	<20200514.130357.1683454520750761365.davem@davemloft.net>
Message-ID: <29428bc7a5344412be9f632bced8888d@AcuMS.aculab.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: 'David Miller' <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Cc: "hch-jcswGhMUV9g@public.gmane.org" <hch-jcswGhMUV9g@public.gmane.org>, "joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org" <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>, "kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org" <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "kuznet-v/Mj1YrvjDBInbfyfbPRSQ@public.gmane.org" <kuznet-v/Mj1YrvjDBInbfyfbPRSQ@public.gmane.org>, "yoshfuji-VfPWfsRibaP+Ru+s062T9g@public.gmane.org" <yoshfuji-VfPWfsRibaP+Ru+s062T9g@public.gmane.org>, "vyasevich-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <vyasevich-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org" <nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org>, "marcelo.leitner-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <marcelo.leitner-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "jmaloy-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <jmaloy-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "ying.xue-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org" <ying.xue-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>, "drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org" <drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>, "linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-nvme-IAPFreCvJWNGWvitb5QawA@public.gmane.org>

Looking at __sys_setsockopt() I noticed that the BPF intercept
can also cause set_fs(KERNEL_DS) be set in order to pass a
modified buffer into the actual setsockopt() code.

If that functionality is to be kept then the underlying
protocol specific code needs changing to accept a kernel buffer.

The 32bit compat code would also be a lot simpler if it could
pass an kernel buffer through.
At the moment it copies the modified buffer back out onto the
user stack.

I'm sure there have been suggestions to remove that complete hack.
Fixing the compat code would leave a kernel_[sg]et_sockopt() that
still worked.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)
