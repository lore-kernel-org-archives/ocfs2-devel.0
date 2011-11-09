From: =?ISO-8859-2?Q?Micha=B3_Miros=B3aw?= <mirqus@gmail.com>
Date: Wed, 9 Nov 2011 19:02:44 +0100
Subject: [Ocfs2-devel] [PATCH 3/4] net: add paged frag destructor
	support to kernel_sendpage.
In-Reply-To: <1320850927-30240-3-git-send-email-ian.campbell@citrix.com>
References: <1320850895.955.172.camel@zakaz.uk.xensource.com>
	<1320850927-30240-3-git-send-email-ian.campbell@citrix.com>
Message-ID: <CAHXqBFKXV14WrKRipaeMJ9_fpWDH_ud_2UjpKYKHKN08t3m-yw@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ian Campbell <ian.campbell@citrix.com>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, "Pekka Savola (ipv6)" <pekkas@netcore.fi>, James Morris <jmorris@namei.org>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, Patrick McHardy <kaber@trash.net>, Trond Myklebust <Trond.Myklebust@netapp.com>, Greg Kroah-Hartman <gregkh@suse.de>, drbd-user@lists.linbit.com, devel@driverdev.osuosl.org, cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com, ceph-devel@vger.kernel.org, rds-devel@oss.oracle.com, linux-nfs@vger.kernel.org

2011/11/9 Ian Campbell <ian.campbell@citrix.com>:
> This requires adding a new argument to various sendpage hooks up and down the
> stack. At the moment this parameter is always NULL.
[...]
> --- a/include/linux/net.h
> +++ b/include/linux/net.h
> @@ -203,6 +204,7 @@ struct proto_ops {
> ? ? ? ?ssize_t ? ? ? ? (*sendpage) ?(struct socket *sock, struct page *page,
> + ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? struct skb_frag_destructor *destroy,
> ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ?int offset, size_t size, int flags);

Maybe you could instead add new op like sendfrag() that would get
already prepared skb_frag_struct? In the end all page data ends up
described in skb_frag_struct, so this would reduce copying this
information all over network stack. This might be a bigger change,
though.

Best Regards,
Micha? Miros?aw
