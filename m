From: Lars Marowsky-Bree <lmb@suse.de>
Date: Thu Oct 20 07:39:45 2005
Subject: [Ocfs2-devel] [RFC] Integration with external clustering
In-Reply-To: <4356CC69.50706@suse.com>
References: <43556F8B.3060105@suse.com>
	<20051018221849.GN11488@ca-server1.us.oracle.com>
	<20051018230323.GE2813@marowsky-bree.de>
	<20051018232752.GO11488@ca-server1.us.oracle.com>
	<20051019132624.GI24589@marowsky-bree.de>
	<20051019174905.GQ11488@ca-server1.us.oracle.com>
	<4356CC69.50706@suse.com>
Message-ID: <20051020123943.GI11726@marowsky-bree.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 2005-10-19T18:44:57, Jeff Mahoney <jeffm@suse.com> wrote:

> So, how about the following:
> 
> The existing heartbeat directory structure can stay as it is. It will
> only be available when o2cb is active.
> 
> /configfs/<cluster>/<uuid>/<node>/
>                                   ip address
>                                   port
>                                   local
>                                   fs slot
>                                   node number
> 
> The user space heartbeat will create and remove the <node> directory on
> up/down events. OCFS2 will take appropriate action as expected with the
> current heartbeat implementation. I intend to simply queue the events as
> they are now and use the existing callback infrastructure to distribute
> them.

That's a good direction to move into, and right for OCFS2/DLM.

Two things, though:

1. DLM should be decoupled from the filesystem. The DLM should be
useable without OCFS2.

2. I'd encapsulate the network details somehow because in the future
this might support more than just plain TCP, maybe SCTP or several
links. How about:

	/configfs/<cluster>/<uuid>/<node>/link{0,1,...}/{ip,port,proto}

?

> I totally agree that mkfs;mount should work. It's what users expect to
> work for a file system, and we don't want OCFS2 to be special cased so
> much that nobody wants to deal with it. Users with more advanced
> topologies can handle the additional configuration load.

Well, conceded. The question seems to now focus on how to hook this up
with the cluster stack. I still like the idea of modifying mount(8)
better than changing mount(2), though I might be convinced.


Sincerely,
    Lars Marowsky-Br?e <lmb@suse.de>

-- 
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX Products GmbH - A Novell Business	 -- Charles Darwin
"Ignorance more frequently begets confidence than does knowledge"
