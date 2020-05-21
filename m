From: Christoph Hellwig <hch@lst.de>
Date: Thu, 21 May 2020 10:42:24 +0200
Subject: [Ocfs2-devel] [PATCH 32/33] net: add a new bind_add method
In-Reply-To: <20200520230025.GT2491@localhost.localdomain>
References: <20200520195509.2215098-1-hch@lst.de>
	<20200520195509.2215098-33-hch@lst.de>
	<20200520230025.GT2491@localhost.localdomain>
Message-ID: <20200521084224.GA7859@lst.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marcelo Ricardo Leitner <marcelo.leitner-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-sctp-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-afs-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rds-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, cluster-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Alexey Kuznetsov <kuznet-v/Mj1YrvjDBInbfyfbPRSQ@public.gmane.org>, Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, ceph-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Neil Horman <nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org>, Hideaki YOSHIFUJI <yoshfuji-VfPWfsRibaP+Ru+s062T9g@public.gmane.org>, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vlad Yasevich <vyasevich-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jon Maloy <jmaloy-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ying Xue <ying.xue-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, ocfs2-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org

On Wed, May 20, 2020 at 08:00:25PM -0300, Marcelo Ricardo Leitner wrote:
> > +	if (err)
> > +		return err;
> > +
> > +	lock_sock(sk);
> > +	err = sctp_do_bind(sk, (union sctp_addr *)addr, af->sockaddr_len);
> > +	if (!err)
> > +		err = sctp_send_asconf_add_ip(sk, addr, 1);
> 
> Some problems here.
> - addr may contain a list of addresses
> - the addresses, then, are not being validated
> - sctp_do_bind may fail, on which it requires some undoing
>   (like sctp_bindx_add does)
> - code duplication with sctp_setsockopt_bindx.

sctp_do_bind and thus this function only support a single address, as
that is the only thing that the DLM code requires.  I could move the
user copy out of sctp_setsockopt_bindx and reuse that, but it is a
rather rcane API.

> 
> This patch will conflict with David's one,
> [PATCH net-next] sctp: Pull the user copies out of the individual sockopt functions.

Do you have a link?  A quick google search just finds your mail that
I'm replying to.

> (I'll finish reviewing it in the sequence)
> 
> AFAICT, this patch could reuse/build on his work in there. The goal is
> pretty much the same and would avoid the issues above.
> 
> This patch could, then, point the new bind_add proto op to the updated
> sctp_setsockopt_bindx almost directly.
> 
> Question then is: dlm never removes an addr from the bind list. Do we
> want to add ops for both? Or one that handles both operations?
> Anyhow, having the add operation but not the del seems very weird to
> me.

We generally only add operations for things that we actually use.
bind_del is another logical op, but we can trivially add that when we
need it.
