From: Joseph Qi <joseph.qi@linux.alibaba.com>
Date: Mon, 8 Jun 2020 09:33:10 +0800
Subject: [Ocfs2-devel] [PATCH] Fix build failure of OCFS2 when TCP/IP is
	disabled
In-Reply-To: <20200606190827.23954-1-tseewald@gmail.com>
References: <20200606190827.23954-1-tseewald@gmail.com>
Message-ID: <731b13e0-2e7c-5a2b-658a-407318c74921@linux.alibaba.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tom Seewald <tseewald@gmail.com>, linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@lst.de>, netdev@vger.kernel.org, ocfs2-devel@oss.oracle.com, Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>



On 2020/6/7 03:08, Tom Seewald wrote:
> After commit 12abc5ee7873 ("tcp: add tcp_sock_set_nodelay") and
> commit c488aeadcbd0 ("tcp: add tcp_sock_set_user_timeout"), building the
> kernel with OCFS2_FS=y but without INET=y causes it to fail with:
> 
> ld: fs/ocfs2/cluster/tcp.o: in function `o2net_accept_many':
> tcp.c:(.text+0x21b1): undefined reference to `tcp_sock_set_nodelay'
> ld: tcp.c:(.text+0x21c1): undefined reference to `tcp_sock_set_user_timeout
> '
> ld: fs/ocfs2/cluster/tcp.o: in function `o2net_start_connect':
> tcp.c:(.text+0x2633): undefined reference to `tcp_sock_set_nodelay'
> ld: tcp.c:(.text+0x2643): undefined reference to `tcp_sock_set_user_timeout
> '
> 
> This is due to tcp_sock_set_nodelay() and tcp_sock_set_user_timeout() being
> declared in linux/tcp.h and defined in net/ipv4/tcp.c, which depend on
> TCP/IP being enabled.
> 
> To fix this, make OCFS2_FS depend on INET=y which already requires NET=y.
> 
> Signed-off-by: Tom Seewald <tseewald@gmail.com>

Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
>  fs/ocfs2/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/Kconfig b/fs/ocfs2/Kconfig
> index 1177c33df895..aca16624b370 100644
> --- a/fs/ocfs2/Kconfig
> +++ b/fs/ocfs2/Kconfig
> @@ -1,7 +1,7 @@
>  # SPDX-License-Identifier: GPL-2.0-only
>  config OCFS2_FS
>  	tristate "OCFS2 file system support"
> -	depends on NET && SYSFS && CONFIGFS_FS
> +	depends on INET && SYSFS && CONFIGFS_FS
>  	select JBD2
>  	select CRC32
>  	select QUOTA
> 
