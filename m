From: Daniel Phillips <phillips@google.com>
Date: Thu, 08 Jun 2006 20:06:40 -0700
Subject: [Ocfs2-devel] [RFC] Senority based Quorum Formation
Message-ID: <4488E5C0.4080002@google.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Goals:
   * Fast algorithm for cluster formation and seniority takeover
   * Minimize nondeterminism of cluster management algorithms
   * Stick to tried and true network protocols: tcp and udp
   * Recovery time from node failure as short as possible
   * Simple and suitable for kernel implementation
   * Support pluggable heartbeating and quorum calculation
   * Also support user space plugin methods

Cluster quorum formation is a notoriously difficult process, prone to races
and deadlock.  I present a simple algorithm to do the job with a pleasant
balance of simplicity, generality, reliability and speed.  To accomplish
this, I generalize the notion of heartbeating and integrate heartbeating
with the quorum formation and recovery algorithm.  I define the notion of
a senior node which is the final arbiter of cluster decisions, while
taking care to ensure that this senior node does not become a bottleneck
or a single point of failure.  I define a line of succession of senority so
that if a senior node fails its duties can be taken over deterministically
by the next node in line of senority, with minimal or no loss of cluster
availability.

The plan is to confine nondeterministic elements of cluster management
entirely to the algorithm described here, so that higher lever cluster
algorithms such as lock recovery and service failover are able to operate
deterministically.  This should allow the removal of a considerable amount
of code now in OCFS2 that is dedicated to coping with nondeterminism.

The algorithm described here is surprisingly simple considering what it
accomplishes and can be described in terms of one type of event source and
three event handlers.  Senior node failover requires less than two
heartbeat periods and typically should not cause any loss of cluster
availability.

Senior node
-----------

The senior node of a cluster is the final arbiter of global synchronization
decisions.  Most cluster decisions can in fact be delegated, leaving the
only truly global decision as, which node to delegate to.  The availability
of a senior node allows alows such a decision to be computed quickly
by a single authority, the senior node.  The process of appointing a senior
node is nondeterministic but runs in bounded time.

Each node in the cluster has a tcp connection to the senior node used to
communicate membership and other cluster events, and is also a factor in
determining relative node seniority.

It is possible for a senior node to lose communication with its members,
in which case the cluster may be unable to carry out certain actions
such as fencing or membership changes until a new senior is appointed.
So it is important to appoint a new senior quickly to avoid service
interruptions.

In a large cluster the senior node might delegate some cluster functions to
other nodes while retaining the authority to reassign such functions.  In
a simplified cluster the senior node will perform a number of
administrative functions itself:

   * Heartbest
   * Fencing
   * DLM recovery master
   * Membership

Each of these functions is performed efficiently so that in moderately
sized clusters these duties do not create a significant extra load on the
senior node in addition to the the workload of a normal cluster member.

Line of Succession
------------------

If the senior node of a cluster fails, the next node in line of succession
takes over its duties.  Line of succession is determined by the order of
members in the membership list, where the senior node is always at the head
of the list and new cluster members join at the tail of the list.

Note: other criteria for determining seniority are certainly possible, but
it is not clear that any alternative provides a better combination of
simplicity and stability.  In particular, node number might be used to
determine senority, but then:

   * If a new, lower numbered node joins the cluster, senority would
     need to be handed over to it, an unnecessary disruption

   * The configuration file order dependency would introduce unnecessary
     restrictions on online updating of the configuration file

So for the time being, line of succession of seniority is the order in
which nodes joined the cluster.

One can imagine situations in which an administrator might wish to modify
the line of succession of a running cluster.  Such a feature is easily
implemented but is not discussed here.

Relative seniority
------------------

Relative seniority is used to accelerate the process of forming a new
quorate cluster and in recovering from failure of a senior node.

Relative seniority of two nodes is affected by whether the two nodes are
now or were members of a quorum, their relative positions in line of
succession of seniority, and their relative positions in a global
configuration file.  (Note: the notion of global configuration will be
pluggable too, at some point.)

Node A is more senior than node B if:

   - A is a member of a quorum and B is not

   - A was a member of a quorum and B was not

   - Both A and B are members of a quorum and A is ahead of B in
     line of succession

   - Both A and B were members of a quorum and A is ahead of B in
     line of succession

   - Neither A nor B are or were members of a quorum and A is
     listed before B in the global cluster configuration file

Quorum
------

The senior node determines whether it has a quorum on the basis of nodes
connected to itself to which it has successfully downloaded a membership
list, and which are live according to heartbeat responses.  The details of
the quorum calculation should be configurable, however for now they are
not.  The cluster formation algorithm below does not rely on any such
details.

The senior node may only fence a nonresponsive node if it has quorum.  This
rule prevents nonquorate groups from fencing each other.

When a senior node achieves quorum it sends a quorum event to each of its
members, which is material to the algorithm below.  Future quorum events
such as losing or regaining quorum are not material to the algorithm
below, though some other cluster services may be able to make use of this
information.  Note that the notion of quorum is inherently racy and
algorithms that rely on it are likely to inherit this raciness.  The
notion of senior node as defined here however is not racy: there can never
be two senior nodes with quorum at the same time, or if there can be then I
made a mistake in the algorithm.

Member Modes
------------

If a node is not a senior node and does not currently have a tcp connection
to a senior node then it is in one of two modes:

    1) Cluster Formation mode: has never been a member of a quorum
    2) Senior Takeover mode: senior node of its quorum has failed

On initial bringup each node node is in formation mode.  After forming a
quorate cluster, if the senior node of the cluster fails then the node
enters takeover mode.  A third mode, the one we hope the node will be in
most of the time, is normal operation.  In normal operation, only the
senior node heartbeats other nodes.  In the other two modes the node's
strategy is to initiate its own heartbeat in order to advertise the fact
that it is available to form a cluster.

Heartbeating
------------

Here, we want the heartbeat process to do more than just help determine
node liveness: we also want to broadcast some state information to be
used by the cluster membership algorithms.  A heartbeating node
therefore sends a record containing at least the following information:

   - Address:port at which the heartbeating node will accept a tcp
     connection from some other node.

   - Node state:
       1) cluster formation
       2) senior of quorum
       3) Senior takeover

OCFS2 currently implements a disk-based heartbeat that seems to be modeled
on a similar scheme implemented in Veritas clusters.  Compared to a
network-based heartbeat this is a bad idea:

   - Average latency of a disk is typically much higher than a network

   - If our shared storage is exported over the network then the
     latency of the disk is added to the latency of the network

   - Typically disk is the bottleneck so a disk based heartbeat must
     use a very slow period in order to avoid generating too much
     extra seeking.

   - Our synchronization logic runs over the network, so how does
     heartbeating the disk tell us the network is live?

   - If we want to know if the disk is unresponsive, our cluster
     nodes can easily report that over the network

There is a case where heartbeating a shared disk is useful, and that is
where the disk is to be treated as a quorum device.  An algorithm similar
to heartbeating must be used to do this accurately.  Note that this
technique is not useful for a distributed storage cluster because the
storage itself may suffer a network split.

What we probably want to do with OCFS2 heartbeating is recast the
algorithm as a quorum method (after inventing a quorum plugin harness) and
switch to simple, udp-based heartbeating.  This will allow the heartbeat
to run much faster and reduce recovery latency.  We should be aiming at
recovery latency in the 500 millisecond range, far less than is practical
today.

All that said, OCFS2's current heartbeat implementation will suffice to
implement the algorithm described here, even though I wrote the rfc as if
the heartbeat were udp.

Cluster formation and Senior Takeover Algorithm
-----------------------------------------------

These two algorithms were initially designed separately.  However they
turned out to be similar enough to become a single algorithm.  The only
difference is the means by which seniority is calculated.  In senior
takeover mode the node knows the line of succession of seniority and
wishes to connect to the next live node in that line of succession.
Otherwise the node is less particular because it does not have any
valuable cluster state to preserve.

When a node first attempts to join a cluster it is in cluster formation
mode.  If a node that is a member of a quorate cluster fails to receive a
heartbeat from its senior node (with network latency and a safety factor
taken into account) then it enters senior takeover mode.

The algorithm can now be described in terms of events:

   - On entering formation or takeover mode a node begins to broadcast
     its own heartbeat, which includes its tcp contact address and port
     and whether or not it is in takeover (former quorum member) mode.

   - When a node receives a heartbeat from a node more senior than
     itself it connects to that node and stops heartbeating.

   - When a node receives a heartbeat from an even more senior node, it
     drops its connection to the former most senior and connects to the
     new most senior node.

   - When a senior node receives a new connection it downloads its
     member list to the connecting node.  This new membership list
     places the former senior node at the end of the list (the old
     senior node is still a member of the cluster because it has not yet
     been fenced).  The connecting node treats the new membership list
     as tentative until quorum is achieved, then it discards the old
     list, otherwise it retains it in order to determine seniority.

During senior takeover all cluster operations can still proceed except
those specific to the senior node, including fencing.  Since fencing is not
possible then lock recovery is not possible.  So it is important that
senior takeover be accomplished as rapidly as possible.  This algorithm
accomplishes takeover in a little more than one heartbeat period, the one
heartbeat being the minimum required to determine that takeover should
begin.

Notes
-----

* In its simplest form this algorithm may be prone to a thundering herd of
heartbeats effect, which in turn might generate excessive connections and
disconnections.  The thundering herd effect is easily avoided at the expense
of introducing a little more latency in some cases: a node in takeover mode
just delays its start of heartbeating by an amount that depends on its
position in line of succession.  This way, the node next in line of
succession will try to take over the senior role first and, except in the
case of multiple node failures, each node will only reconnect once.

* We should accomodate voluntary handover of the senior node role even
faster than takeover, so that a senior node can leave the cluster without
disrupting availability of the services it was providing.  This is detail
is left for later.

* It is important to preserve the invariant that a new cluster cannot be
formed faster than a node can be fenced, otherwise a senior node with
quorum cannot be sure that it is the only senior node with quorum.  This
issue is not addressed here.

Q: Under what conditions does a node respond to a heartbeat?
A: If the heartbeat comes from a senior to which it is connected

Q: What stops an old senior from fencing everybody because it isn't
receiving heartbeat responses?
A: It has lost quorum because some members have disconnected, otherwise
it has every right to fence them.

Q: What if a new quorum is formed?
A: we aren't getting heartbeats from any of the nodes in that new quorum
except the senior, which has quorum state set so all members disconnect
from the nonquorate senior and connect to the quorate senior.

Q: Should a node that has lost senior be able to calculate loss of quorum?
A: What would it use this information for?  It only needs to calculate
quorum if it is senior, and it will tell its member nodes.

Q: In takeover mode does a node need to check for nodes not responding
to pings?
A: Same as above, why should it care.  If it becomes senior then it cares.
