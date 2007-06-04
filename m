From: Robert Wipfel <rawipfel@novell.com>
Date: Mon Jun  4 08:48:10 2007
Subject: [Ocfs2-devel] Clustered Samba/CTDB on ocfs2 ?
In-Reply-To: <18019.47337.745002.756250@samba.org>
References: <17976.62685.567183.915000@samba.org>
	<20070502204508.GM21982@ca-server1.us.oracle.com>
	<17976.65193.79079.299940@samba.org>
	<20070502212930.GN21982@ca-server1.us.oracle.com>
	<18019.47337.745002.756250@samba.org>
Message-ID: <4663DFCF.C5C7.00CF.0@novell.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

>>> On Mon, Jun 4, 2007 at  1:02 AM, in message
<18019.47337.745002.756250@samba.org>, <tridge@samba.org> wrote: 
> Mark,
> 
>  > Ok -  understood. Out of curiousity, where is this stuff in its lifetime
>  > (i.e., alpha, aeta, post release, etc). Once we verify that things are
>  > working with Ocfs2 as expected, we could start pointing people asking 
> about
>  > Samba to the CTDB stuff.
> 
> The CTDB stuff has come a long way in the last few weeks. If you or
> anyone else on this list wants to do some testing with OCFS2 then I
> think it would be a good time to start.
> 
> See http://ctdb.samba.org/ and
> http://wiki.samba.org/index.php/CTDB_Setup#Managing_Network_Interfaces 
> for some documentation other information.

Would Samba work with something like the
cluster iptables load sharing stuff? 
http://lists.community.tummy.com/pipermail/linux-ha/2007-May/025390.html
(guess the point is to create a single system
image file server cluster)

- Robert
