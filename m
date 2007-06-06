From: tridge@samba.org <tridge@samba.org>
Date: Wed Jun  6 03:32:45 2007
Subject: [Ocfs2-devel] Clustered Samba/CTDB on ocfs2 ?
In-Reply-To: <4663DFCF.C5C7.00CF.0@novell.com>
References: <17976.62685.567183.915000@samba.org>
	<20070502204508.GM21982@ca-server1.us.oracle.com>
	<17976.65193.79079.299940@samba.org>
	<20070502212930.GN21982@ca-server1.us.oracle.com>
	<18019.47337.745002.756250@samba.org>
	<4663DFCF.C5C7.00CF.0@novell.com>
Message-ID: <18022.36219.942944.408630@samba.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Robert,

 > Would Samba work with something like the
 > cluster iptables load sharing stuff? 
 > http://lists.community.tummy.com/pipermail/linux-ha/2007-May/025390.html
 > (guess the point is to create a single system
 > image file server cluster)

Samba+ctdb has IP failover and load sharing builtin. It also has smart
stuff to handle startup/monitoring of any system service, so it will
do things like:

 - if the link status of the public network interface goes down, then
   the public IP of that node gets moved to a different node within a
   few seconds, and moved back when the link status is OK again

 - if an admin screws up the Samba smb.conf and ctdb is managing
   Samba, then the IP is moved. Same with if the admin stops
   portmapper and NFS etc etc.

 - ctdb does all the gratuitous arp stuff, plus does TCP 'tickle' acks
   on failover, ensuring absolutely minimum failover time without
   relying on (slow!) tcp keepalives. We run tests with windows boxes
   copying files, then pull the plug on the node that windows is
   connected to. The xcopy hardly pauses at all as it continues with
   another cluster node.

Have a look at http://samba.org/~tridge/ctdb/config/ to see the
standard config stuff in ctdb. I'm afraid the ctdb wiki is down right
now, but when it comes back there is a lot more info there.

For load sharing, we use round-robin DNS, and round-robin WINS. All
cluster nodes behave the same, so you have one name for all the
nodes. If you have the money, a load balancing switch is also a good
choice.

We eventually want to do dynamic load balancing, where Samba migrates
live connections between nodes according to demand. At the moment we
only do load balancing at connect time, which is OK, but not ideal.

Cheers, Tridge
