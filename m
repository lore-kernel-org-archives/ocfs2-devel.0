From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Thu Nov 30 21:52:02 2006
Subject: [Ocfs2-devel] [patch 3/3] ocfs2-timeout-protocol.patch
In-Reply-To: <20061130182225.818592000@suse.de>
References: <20061130181128.860671000@suse.de>
	<20061130182225.818592000@suse.de>
Message-ID: <20061201055158.GB19617@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Andrew,
	This patch is much better. The new comments and the removal of
prototype cleanups made it a lot easier to read through too.

I have just one comment below :)

On Thu, Nov 30, 2006 at 07:11:31PM +0100, abeekhof@suse.de wrote:

> Index: fs/ocfs2/cluster/tcp.c
> ===================================================================
> --- fs/ocfs2/cluster/tcp.c.orig	2006-11-30 18:53:24.000000000 +0100
> +++ fs/ocfs2/cluster/tcp.c	2006-11-30 19:02:30.000000000 +0100
> @@ -380,6 +380,13 @@ static void o2net_sc_cancel_delayed_work
>  		sc_put(sc);
>  }
>  
> +atomic_t o2net_connected_peers = ATOMIC_INIT(0);
> +
> +int o2net_num_connected_peers(void)
> +{
> +	return o2net_connected_peers.counter;
> +}
I think maybe you missed the definition of 'atomic_read', which needs to be
used instead of bare access to the counter value. I see a couple places
where you access the counter below - those need to be updated as well.

Thanks,
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh@oracle.com
