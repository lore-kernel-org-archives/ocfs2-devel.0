From: Jeff Mahoney <jeffm@suse.com>
Date: Tue Oct 18 16:52:26 2005
Subject: [Ocfs2-devel] [RFC] Integration with external clustering
Message-ID: <43556F8B.3060105@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1


Hey all -

We're interested in using OCFS2 with an external, userspace clustering
solution. Specifically, the heartbeat2 project from linux-ha.org.
Obviously, the internal cluster manager would still be available for
users with no interest in deploying and configuring a full cluster
manager just to use the file system.  I'd like to attempt to make the
interface as consistent as possible between the two.

The obvious mapping to an external cluster manager is to map one file
system to one cluster resource, to be managed individually. The user
space cluster manager will take over most of the cluster management
infrastructure supplied now by o2cb, including heartbeat, fencing, etc.
The node manager would still be used to coordinate DLM operations, which
would be left in-kernel. The o2cb code is pretty well structured for
this kind of integration without a lot of hacking, but there are a few
sticking points. The good news is that the infrastructure for fixing
most of them is already in place, just waiting to be used.

The existing code has a notion of one global cluster with each node
owning a particular node number and a single IP address/port. This node
number is mapped 1:1 to file system slots and DLM domain node numbers,
regardless of how many nodes are actually involved in mounting any
particular file system. A large cluster may deploy a cluster-global file
system, but also many smaller file systems to small subsets of nodes.
The smaller file systems, even though they are deployed on a small
number of nodes, still require slots for every member of the larger
cluster. If separate network connectivity is desired for the smaller
file systems, separate node numbers must be allocated in order to
utilize the alternate network, making the problem worse.

The one-cluster notion appears to be rooted in o2net, where the
assumption of a 1:1 IP Address:Node mapping is made. The node manager is
aware of multiple clusters, and even has to provide an interface to fake
the single cluster membership. o2net itself even understands that an
internode connection will be used for multiple virtual connections.

And, one of the larger issues for integration with a userspace cluster
manager is how nodes are organized and exported to userspace. Currently,
there is only one instance of a node. If a heartbeat down event is
triggered for a particular node, all file systems are told about it,
even if they don't care. What we need to integrate a userspace cluster
manager is more fine grained configuration of node membership.

I'd like to address these issues in my proposal:

Individual file systems should be represented individually, with
resources and connectivity assignable independently to each.

I'll start with an idea of what I'd like to see the configfs space look
like, since I think it will probably illustrate it best:

/config/cluster/ocfs2/<fs uuid>/<node>/
                                       ip address
                                       port
                                       fs slot
                                       local
                                       active (for userspace)
                                       heartbeat/ (for kernelspace)
                                                 block_bytes
                                                 blocks
                                                 dev
                                                 start_block

Rather than having one global cluster, each file system would be its own
cluster. Nodes would be created and destroyed as needed on a per file
system basis. The current o2net concept of a node would be replaced by
something that is specific to connectivity. The current implemention of
one connection per ip/port would stay, but rather than assume a
particular connection-node mapping at accept time, it would broker
messages later once the key has been observed in the message.

Since heartbeat and node management would end up having similar trees
with different attributes, the node and heartbeat attributes would be
unified under a single fs instance.

Obviously, modifications to the o2cb userspace tools would be required
to make this work. I think that the changes required for cluster.conf
could be minimal -- just keep the existing format and add overrides for
 file systems that want to use different slots/networks/etc.

I'm volunteering to code all this up, I just didn't want to post code
that nobody wanted.

Opinions?

- -Jeff

- --
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://enigmail.mozdev.org

iD8DBQFDVW+KLPWxlyuTD7IRAv5SAJ4yUID/gnGslfhu0JZzNiF+1f0OYQCfUQei
2eeyWWd6lfe9Ae8NzV8tXSI=
=xI1V
-----END PGP SIGNATURE-----
