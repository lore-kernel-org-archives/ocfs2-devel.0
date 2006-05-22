From: Daniel Phillips <phillips@google.com>
Date: Mon, 22 May 2006 12:18:39 -0700
Subject: [Ocfs2-devel] OCFS2 features RFC
In-Reply-To: <20060520061137.GA21588@ca-server1.us.oracle.com>
References: <20060425183553.GB10524@ca-server1.us.oracle.com>
	<446398D3.7010508@suse.com>
	<20060517014419.GS21588@ca-server1.us.oracle.com>
	<446BBCF5.7040903@google.com>
	<20060518024638.GY21588@ca-server1.us.oracle.com>
	<446D12CF.2080501@google.com>
	<20060520061137.GA21588@ca-server1.us.oracle.com>
Message-ID: <44720E8F.2000602@google.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mark Fasheh wrote:
> On Thu, May 18, 2006 at 05:35:27PM -0700, Daniel Phillips wrote:
>>Ok, I just figured out how to be really lazy and do cluster-consistent
>>NFS locking across clustered NFS servers without doing much work.  In the
>>duh category, only one node will actually run lockd and all other NFS
>>server nodes will just port-forward the NLM traffic to/from it.  Sure,
>>you can bottleneck this scheme with a little effort, but to be honest we
>>aren't that interested in NFS locking performance, we are more interested
>>in actual file operations.
> 
> Out of curiousity, how will a failure on the lockd node be handled? Or is
> this something that you're not worried about.

Of course I'm worried about it!  Luckily, normal NFS reboot semantics can
be repurposed to provide failover.  Client lockds are notified of a server
failure via NSM/statd.  Our cluster manager invokes a failover method (this
harness yet to be designed) that activates a new lockd on some other node
and updates the NLM port forward addresses on all other nodes.  When all is
ready, the new server announces via NLM that it is up and clients retake
their locks as they would for a server reboot.

I don't think this part of it is new, anybody who has attempted nfs serving
from a cluster must have noticed it.  The port forwarding idea may be new,
I did not notice anybody mention it out there.

>>>call_usermodehelper()?
>>Like the Red Hat framework?  Ahem.  Maybe not.  For one thing, they never
>>even got close to figuring out how to avoid memory deadlock.  For another,
>>it's a rambling bloated pig with lots of bogus factoring.  Honestly, what
>>you have now is a much better starting point,
> 
> Well, I should've said "multiple existing frameworks" - so people could run
> whatever fits their needs the best. So folks could pick the feature sets
> that suit their needs the best. Besides, I think you're being somewhat
> unfair to the Red Hat framework. It does _alot_ more than the OCFS2 stack
> can even dream of handling right now.

In a reasonable way?  I think not.  The only bit you might lust after is the
range locking, and that was never tested to any great extent.  I still think
you have a better, more sensible base to work from, and what's more, it's
attached to a relatively stable, in-tree cluster filesystem.

Curious... have you tried the Red Hat cluster stack?  Which version(s)?

> And we haven't even talked about Linux-HA yet.

And we should, briefly.  Linux-HA looks great to me but it can't be directly
used by OCFS2 because it is in userspace with no thought at all invested
in dealing with memory deadlock.  You might be able to interface with
Linux-HA one day in order to unify the handling of membership and failover,
however I doubt that the easiest path there is to try to fix up the Linux-HA
internals to avoid memory pitfalls.  Much better to fix your much smaller
in-kernel framework, and then evolve it in the direction of interfacing to
Linux-HA.  Note that fencing, membership, heartbeat and failover all lie in
the block IO path, so they all have to obey rigorous rules that Linux-HA
knows nothing about.  What has to be done here is adapt Linux-HA's structure
to expose the OCFS2 implementation, so for example Linux-HA would not
directly send heartbeats, but would receive your stack's up/down messages.

But this is getting way ahead of things.  First, OCFS2 needs to establish
itself as a filesystem, before projects like Linux-HA can look at how to do
the grand unification.

>>No, the filesystem never calls fencing, only the cluster manager does.
>>As I understand it, what happens is:
>>
>>   1) Somebody (heartbeat) reports a dead node to cluster manager
>>   2) Cluster manager issues a fence request for the dead node
>>   3) Cluster manager receives confirmation that the node was fenced
>>   4) Cluster manager sends out dead node messages to cluster managers
>>      on other nodes
>>   5) Some cluster manager receives dead node message, notifies DLM
>>   6) DLM receives dead node message, initiates lock recovery
> 
> That sounds alot closer to how it should happen, IMHO.
> 
> Fencing plugins by the way can tend to do a variety of things, ranging from
> direct device access, to being able to telnet or ssh into a switch. The
> plugin system therefore needs to be fairly generic, to the level of
> running a binary that could be written in perl, C, etc.

Then you would implement a kernel fencing method that interfaces to user
space, and cross your fingers.  Fencing lies in the block IO path so it
has to obey anti-memory deadlock rules.  Perl and bash certainly will not,
so if somebody insists on writing their fence scripts that way, then they
will need to run them on a separate node that does not mount the OCFS2
filesystem, or inside a resource sandbox, for example a UML instance that
has all its resources pre-allocated.  By the time you have done all the
setup required for that, you would have gotten the job done faster and
better by rewriting the script in C.  Then you still have to do memlocking,
and run syscalls like connect in PF_MEMALLOC mode, but you would need that
for the UML sandbox anyway, with rather more work to do to audit all the
call paths.

The practical approach is to do kernel implementations of the fencing
methods that can be implemented there (including mine!) and offload any
messy userspace ones to a non-filesystem node.

>>So let's just do something really minimal that gives us a plugin
>>interface and move on to harder problems. If you do eventually figure out
>>how to move the whole cluster manager to userspace then you replace the
>>module scheme in favor of a dso scheme.
> 
> Well, I'm wondering how we're going to support all the different fencing
> methods using kernel modules ;)

Choose your poison:

   1) A kernel fencing method sends messages to a dedicated fencing node
   that does not mount the filesystem.  This may waste a node and needs some
   additional mechanism to avoid becoming a single point of failure.

   2) A kernel fencing method sends messages to a userspace program written
   in C, memlocked, and running in (slight kernel hack here) PF_MEMALLOC mode.
   This might require a little more work than a Perl script, but then real men
   enjoy work.

   3) A kernel fencing method sends messages to a userspace program running
   in a resource sandbox (e.g. UML or XEN) that does whatever it wants to.
   This is really buzzword compatible, really wasteful, and a great use of
   administration time.

   4) You may find that you can implement in-kernel all of the fencing modules
   you need easier and better than any of the above.  This is the case with me.

The thing we can't do is go on pretending that we can just shell to bash and
run anything we want.  That way lies deadlock.

Regards,

Daniel
