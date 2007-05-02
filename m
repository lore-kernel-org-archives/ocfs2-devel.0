From: tridge@samba.org <tridge@samba.org>
Date: Wed May  2 14:46:14 2007
Subject: [Ocfs2-devel] Clustered Samba/CTDB on ocfs2 ?
In-Reply-To: <20070502212930.GN21982@ca-server1.us.oracle.com>
References: <17976.62685.567183.915000@samba.org>
	<20070502204508.GM21982@ca-server1.us.oracle.com>
	<17976.65193.79079.299940@samba.org>
	<20070502212930.GN21982@ca-server1.us.oracle.com>
Message-ID: <17977.1747.673366.638199@samba.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mark,

 > Ok - understood. Out of curiousity, where is this stuff in its lifetime
 > (i.e., alpha, aeta, post release, etc). Once we verify that things are
 > working with Ocfs2 as expected, we could start pointing people asking about
 > Samba to the CTDB stuff.

It ran for the first time on a real cluster (running GPFS) at SambaXP
in Germany last week. It is progressing very rapidly though, and we
hope there will be real deployments soon.

So I guess you'd call it alpha. It doesn't yet do auto-recovery after
a node crash. We're working on that now. We want it to the point that
you can pull the power on a node in the cluster and the other nodes
continue with no data loss (that takes some fancy footwork, as we
deliberately do not replicate all the meta data between nodes in the
cluster, so we need a smart recovery system).

 > Yeah - we handle data coherency between nodes. O_DIRECT gets you around some
 > of those guarantees, so mixing it with buffered I/O is generally discouraged.
 > 	--Mark

we never use O_DIRECT, so that sounds good.

Cheers, Tridge
