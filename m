From: Robert Wipfel <rawipfel@novell.com>
Date: Fri Jun  8 09:06:31 2007
Subject: [Ocfs2-devel] Clustered Samba/CTDB on ocfs2 ?
In-Reply-To: <18022.36219.942944.408630@samba.org>
References: <17976.62685.567183.915000@samba.org>
	<20070502204508.GM21982@ca-server1.us.oracle.com>
	<17976.65193.79079.299940@samba.org>
	<20070502212930.GN21982@ca-server1.us.oracle.com>
	<18019.47337.745002.756250@samba.org> <4663DFCF.C5C7.00CF.0@novell.com>
	<18022.36219.942944.408630@samba.org>
Message-ID: <46692A11.C5C7.00CF.0@novell.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

>>> On Wed, Jun 6, 2007 at  4:33 AM, in message
<18022.36219.942944.408630@samba.org>, <tridge@samba.org> wrote: 
> Robert,
> 
>  > Would Samba work with something like the
>  > cluster iptables load sharing stuff? 
>  > http://lists.community.tummy.com/pipermail/linux- ha/2007- May/025390.html
>  > (guess the point is to create a single system
>  > image file server cluster)
> 
> Samba+ctdb has IP failover and load sharing builtin. It also has smart
> stuff to handle startup/monitoring of any system service, so it will
> do things like:

Thanks Tridge, sounds really interesting, just fwiw, and as a reminder,
it's possible to build OCFS2 clusters using iSCSI and FireWire storage,
incase anyone was concerned about the hardware requirements of building
a (Samba) cluster... ;-)

Couple of other things worth mentioning perhaps, regarding managability
of open source clusters and storage solutions:

Free commercial quality product doc for Heartbeat2:
http://lists.community.tummy.com/pipermail/linux-ha/2007-June/025566.html

Open source Linux Storage Resource Management software:
http://dev.eclipse.org/mhonarc/lists/aperi-dev/msg00485.html

>  -  if the link status of the public network interface goes down, then
>    the public IP of that node gets moved to a different node within a
>    few seconds, and moved back when the link status is OK again

Interested in how this works, I need to find time to read your Wiki... (e.g. 
binding IP addresses this could be supported by OCFS2 dlmfs, if not using
Heartbeat2...:-)

>  -  ctdb does all the gratuitous arp stuff, plus does TCP 'tickle' acks

Nice :-)

>    on failover, ensuring absolutely minimum failover time without
>    relying on (slow!) tcp keepalives. We run tests with windows boxes
>    copying files, then pull the plug on the node that windows is
>    connected to. The xcopy hardly pauses at all as it continues with
>    another cluster node.
> 
> Have a look at http://samba.org/~tridge/ctdb/config/ to see the
> standard config stuff in ctdb. I'm afraid the ctdb wiki is down right
> now, but when it comes back there is a lot more info there.
> 
> For load sharing, we use round- robin DNS, and round- robin WINS. All
> cluster nodes behave the same, so you have one name for all the
> nodes. If you have the money, a load balancing switch is also a good
> choice.
> 
> We eventually want to do dynamic load balancing, where Samba migrates
> live connections between nodes according to demand. At the moment we
> only do load balancing at connect time, which is OK, but not ideal.

Sounds really interesting/fun, thanks for the info, 

Robert
