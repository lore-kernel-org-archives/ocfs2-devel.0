From: Daniel Phillips <phillips@google.com>
Date: Thu, 25 May 2006 20:31:33 -0700
Subject: [Ocfs2-devel] [RFC] Fencing harness for OCFS2
Message-ID: <44767695.7000203@google.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Goals:
    - Lightweight, kernel based fencing harness
    - Support pluggable fencing methods
    - Pluggable methods take policy out of kernel
    - No reinvented wheels, use kernel modules
    - Also accomodate user space fencing methods
    - Divide work appropriately between kernel and user space
    - Obey memory deadlock prevention rules
    - Obey safe module unload rules
    - Handle multiple clusters per node

Fencing is the act of preventing an incommunicado node from accessing shared
cluster storage.   Currently, what OCFS2 calls fencing is really a watchdog
that panics an incommunicado node after a predetermined number of missed
heartbeats.  This does prevent the incommunicado node from accessing shared
storage, but as a fencing scheme it has disadvantages:

   1) The remaining nodes must wait at least as long as the watchdog timeout
      before recovering any of the parted nodes locks.

   2) Panicking annoys cluster administrators, may take nodes offline for
      unreasonably long periods, and is prone to endless panic cycles.

We can think of the existing watchdog scheme as one particular fencing method.
Most cluster configurations can support much better fencing methods.  For
example, a storage network may support switch or sever based IP address
banning.  This proposal describes a modular framework that can accomodate
a wide variety of fencing schemes in a simple, robust and extensible way.

Relationship to Existing Watchdog
---------------------------------

The proposed fencing harness is independent of the existing watchdog, which
can continue to exist in its current form, though confusion would be
reduced by renaming it more accurately at this point.  Eventually we
will want to parameterize the watchdog similarly to fencing, so that for
example an IP-banning fencing method can be paired with a watchdog method
that does not panic in the event of a network split.  Even without
generalizing the watchdog methods we will still see an immediate benefit
from the new fencing harness in that the cluster will be able to recover
locks faster than the panic-based watchdog method.

To capture exactly the behavior of the existing watchdog, we may provide a
fencing method, call it "watchdog", that simply waits a predetermined time,
then reports success.  During this wait the target node is presumed to have
fenced itself by panicking or otherwise.  We might wish to implement a
"manual" fencing method, which might send a network message to some
administration address and wait to receive a reply.  Since it is always
possible to implement an OCFS2-style watchdog and the limitations of
the watchdog method do not render it completely useless, we could make
the watchdog method the default if no other method is specified.

Registering a Fencing Method
----------------------------

Each fencing method is defined in a kernel module.  A single module may
define more than one fencing method.  In the module init, one or more
fencing methods will be registered with the OCFS2 cluster stack, giving
the name of the method, a function entry to invoke the method and the
module owner.

Something like:

    err = node_register_fence_method(name, fn, owner);

Providing that no method of the same name is already registered, the method
will be added to a static list of available methods.  We need to remember
the owner module so that the module can be locked into the kernel whenever
the fencing method could possibly be invoked.

Normally, each node of an OCFS2 cluster will load the same fencing methods.
We could in theory relax this if we do not require every node to be able to
carry out fencing.  For now it is simpler to assume every node can possibly
fence other nodes.

Associating Nodes with Fencing Methods
--------------------------------------

The user space tools have available a global configuration file that
enumerates all the nodes that can possibly join the cluster.  For each
node we supply a configuration line that states the name of the fencing
method to be used for that node.  We may also state other details such as
the period to allow for a watchdog method.

The user space tools parse the configuration file into a digestable form
for the kernel components and pass it to the kernel in what whatever
format the userspace tools and fencing methods agree between themselves.
This information will be available internally to fencing methods that
need to know how to perform configuration-specific actions.  For the
time being we do not need to worry about stabilizing this format because
we can require that the user tools exactly match the kernel module used.

The node manger checks that every fencing method mentioned in the
configuration file is already registered, otherwise the node might not
be able to fullfill its duty if it is called upon to fence another node.
If the node cannot handle every fencing method used by any node, the
join attempt will fail.

Up to this point, there is no requirement to obey memory deadlock rules
because no cluster filesystem can yet be mounted.  This means that the
above steps can be executed in user space if we wish, with the exception
of filling in the kernel node structures.   However, there is not very
much code required and a user space linkage might well outweigh any
kernel code savings.  For now it is easiest to do in kernel.

After the node has joined the cluster it will begin to receive membership
events to inform it which other nodes belong to the cluster.  For each
other node in the cluster the node manager creates a node structure and
fills in the node's fencing method entry point by looking up the named
fencing method in the list of registered fencing methods.  We can at
this point also add a pointer to any configuration details specified on
the node's fence configuration line.

As soon as our node has fully joined the cluster a mount could possibly
take place, so memory deadlock rules come into play.

Note: my description of node join events may not match exactly the way
OCFS2 does it at this point.

Invoking a Fencing Method
----------------------------

For sanity's sake, only one node on the cluster will have the duty of
initiating fencing.  For simplicity, we can let that be the heartbeat
node, or in OCFS2 terms, the lowest numbered node in the cluster.
Heartbeat reports to the node manager that a node needs to be fenced.
The node manager invokes fencing with a call like:

    err = target_node->fence->initiate(target_node);

A zero error result means that fencing has been initiated.  The fence
method reports completion asynchronously by sending a message to the mode
manager, something like:

      write(thisnode->nodeman->socket, {FENCED, thisnode, errno, errmsg}, len);

A zero errno means that fencing was successful and the errmsg is empty.

As long as there are any fencing operations in progress the module that
owns the method may not be removed.  An easy way to implement this is to
prevent the node from leaving the cluster until outstanding fencing
operations have completed.  This in turn is accomplished by incrementing
a counter before fencing is initiated and decrementing it when the fence
result message is received or if initiating fails.  After the node
leaves the cluster it decrements the module count for every fence method
that it orginally incremented, allowing the module to be unloaded if no
other cluster is using any of the fence methods.

User Space Fencing Methods
--------------------------

Fencing may be implemented in userspace, however a module must be
written to implement the linkage.  Most likely, user space fencing will
take the form of a memlocked daemon that communicates with the kernel
module using a socket, which would be opened at module initialization
time or alternatively (and with some additional kernel support) at
node bringup time.  Userspace fencing methods must obey memory deadlock
prevention rules.  This is hard, so maybe we should get the kernel
based methods working first.

Regards,

Daniel
