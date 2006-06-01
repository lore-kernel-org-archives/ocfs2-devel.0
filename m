From: Daniel Phillips <phillips@google.com>
Date: Thu, 01 Jun 2006 16:13:56 -0700
Subject: [Ocfs2-devel] [RFC] Service Master Takeover harness for OCFS2
Message-ID: <447F74B4.4060704@google.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Goals:
    - Lightweight, kernel based service master takeover harness
    - Pluggable takeover methods take policy out of kernel
    - No reinvented wheels, use kernel modules
    - Accomodate user space takeover methods
    - Divide work appropriately between kernel and user space
    - Obey memory deadlock prevention rules
    - Obey safe module unload rules
    - Handle multiple clusters per node

Service Masters and Line of Succession
--------------------------------------

Arguably, nobody has ever come up with a cluster services and resource
balancing model that satisfies everybody, and quite possibly nobody ever
will.  A big part of the problem is representing service interdepencies so
that a cluster manager can automatically ensure the right services are
available to support other services, all the way up to and including cluster
applications.  This is really hard.  Fortunately, it is also unncessary to
to handle this in the block IO path.  Most of the hard work just needs to be
done at node bringup and teardown time.  This allows us to factor the problem
in such a way that only one small part of a service management framework
actually needs to obey memory deadlock rules, and the rest can be
implemented outside the kernel.

Definition: a "service master" is the final arbiter of any decisions about
which services will execute on which nodes, and is also responsible for
ensuring that all nodes know how to contact those services.  Service master
takeover is the act of moving the service master role from one node to
another, normally because an old service master node has failed.  Service
master takeover is the one essential component of a service management
framework that needs to follow the stringent anti deadlock rules, and
therefore is best implemented in the kernel.

Sevice master takeover is very small job in terms of amount of work that
needs to be done, but it is a crucially important job.  For this purpose,
OCFS2 currently uses a system for nominating service masters only when
needed, via a nondeterministic competition.  This is a bad idea both
because it is inherently unstable and because it introduces unnecessary
latency in the failover path.  So I propose a simple mechanism whereby a
cluster always has a deterministic means of appointing new masters as
necessary.  Instead of holding an election, we simply define a line of
succession of service masters so that when one fails its job is
immediately taken over by the next in line.  The line of succession is
simple seniority: the oldest node in the cluster is the service master.

Because service master takeover is implemented via pluggable methods, it
is not incompatible with election algorithms or other fanciful schemes
for assigning cluster duties.  In other words, a service master method
might for some ungodly reason decide to hold an election.  More usefully,
a service master might wish to use a cluster resource map to help it
pick a "good" node for some service function.  Or a service master might
appoint some other node to run an election, consult a resource map, or
whatever.  The point is that we always have the ability to make certain
critical decisions at exactly one place in the cluster.  This eliminates
entire classes of latency, code fluff and potential raciness.

By analogy, when it comes to crunch time our cluster should act more like
an army and less like a mob.  An army has a well defined chain of command
and a good plan of action in case a leader becomes a casualty.  More often
than not, a mob will just panic.

Note: some services are distributed cluster wide, others need only a single
instance on one node, and others need a few instances including hot spares.
These various arrangements have one thing in common: each requires a
single service master to make certain critical decisions for it and we can
handle all of these topologies using one simple service master takeover
harness.

Registering Service Master Methods
----------------------------------

Service master methods are registered the same way as fencing methods,
something like:

    err = node_register_master_method(name, fn, owner);

Like fencing methods, service master methods are defined in kernel modules.
Multiple master methods may be defined simultaneously, to handle multiple
services.  Typically, service masters will not need to interact during
failover.  The services themselves may well interact, including during
failover, but the service master harness need not concern itself with that;
if service interaction is required then it is the responsibility of the
methods or of the services controlled by the service master methods.

Normally, each node of a cluster will load the same service master methods
so that every cluster node is capable of mastering any cluster service.
We could relax this in asymmetric clusters by defining a separate line of
succession for each separate service, but for the time being this extra
complication is unnecessary.

Associating Nodes with Service Master Methods
---------------------------------------------

Like fencing methods, service master methods are defined in a global
configuration file.  At node bringup time the node manager checks that all
service master methods specified for the cluster are in fact registered,
and fills in the method pointers.  This code does not have to obey memory
deadlock rules so it may easily be implemented in user space, except for
filling in the method pointers.

Service Master Takeover
-----------------------

For simplicity, service master takeover methods will always be executed by
the senior node in the cluster, where senority is defined by some stable
scheme such as how long a node has been a member of the cluster.  This
gives a simple, stable, easy to maintain and (probably) race free method
for defining order of succession.  Note that this in no way implies that
all cluster services will run on the senior node, or that all locks will
be mastered by the senior node.  It only specifices a means of making
certain critical promptly and unbambigously.

 From time to time the senior node of the cluster will leave, either
voluntarily or otherwise.  The next node in line of succession becomes the
senior node.  To verify that all nodes agree with this new appointment,
the node manager sends a message to each cluster node indicating that it
is now the new service master.  When a quorum (less one) of nodes have
replied the senior node then invokes each service master takeover method
with a call like:

    err = thisnode->master->takeover(thisnode);

Nonzero error only means that takeover has been successfully initiated.  To
allow takeover of separate services to proceed in parallel, the takeover
method reports success via a message, something like:

    write(thisnode->nodeman->socket, {MASTERED, thisnode, errno, errmsg}, len);

where error messaging is the same as for fencing.

Note: messaging all node members on takeover as described above is not
strictly necessary since we already have the quorum guarantee and every
node already knows which node will become the new senior node in case of
failure.  I am not sure it accomplishes anything useful, but we can wait
to see actual code before deciding whether this bit deserves to live.
It does seem wise to ensure that all cluster nodes know about the new
service master and don't sit around waiting for answers from the old
one, before the service master continues with other cluster business,
but perhaps there is a quicker way to accomplish this.

Note: it should be apparent that this new service master failover scheme
is inherently much faster than the incumbent one.

User Space Service Master Methods
---------------------------------

A service master takeover method might simply send a message to a
(memlocked) user space daemon that can do whatever it wants.  Or the
takeover method might message some server running on another node.  In
other words, nothing special needs to be done to allow this simple
harness to support arbitrary userspace service takeover methods.
