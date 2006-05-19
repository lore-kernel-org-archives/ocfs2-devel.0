From: Daniel Phillips <phillips@google.com>
Date: Thu, 18 May 2006 17:35:27 -0700
Subject: [Ocfs2-devel] OCFS2 features RFC
In-Reply-To: <20060518024638.GY21588@ca-server1.us.oracle.com>
References: <20060425183553.GB10524@ca-server1.us.oracle.com>
	<446398D3.7010508@suse.com>
	<20060517014419.GS21588@ca-server1.us.oracle.com>
	<446BBCF5.7040903@google.com>
	<20060518024638.GY21588@ca-server1.us.oracle.com>
Message-ID: <446D12CF.2080501@google.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

(a dialog between Mark and me that inadvertently became private)

Mark Fasheh wrote:
> On Wed, May 17, 2006 at 05:16:53PM -0700, Daniel Phillips wrote:
>>Does clustered NFS count as software we're going to worry about right now?
>>The impact is, if OCFS2 does provide cluster-aware fcntl locking then the
>>cluster locking hacks lockd needs can possibly be smaller.  Otherwise,
>>lockd must do the job itself, and as a consequence, any applications running
>>on the (clustered) NFS server nodes will not see locks held by NFS clients.
> 
> Clustered NFS is definitely something we care about. We have people using it
> today, with the caveat that file locking won't be cluster aware. It's
> actually pretty interesting how far people get with that. We'd love to
> support the whole thing of course. As far as NFS with file locking though, I
> have to admit that we've heard many more requests from people wanting to do
> things like apache, sendmail, etc on OCFS2.

Ok, I just figured out how to be really lazy and do cluster-consistent
NFS locking across clustered NFS servers without doing much work.  In the
duh category, only one node will actually run lockd and all other NFS
server nodes will just port-forward the NLM traffic to/from it.  Sure,
you can bottleneck this scheme with a little effort, but to be honest we
aren't that interested in NFS locking performance, we are more interested
in actual file operations.

So strike NFS serving off the list of applications that care about cluster
fcntl locking.

>>Unless I have missed something major, fcntl locking does not have any
>>overlap with your existing DLM, so you can implement it with a separate
>>mechanism.  Does that help?
> 
> Eh, unfortunately not that much... It's still a large amount of work :/
> Doing it outside a dlm would just mean one has to reproduce existing
> mechanisms (such as determining lock mastery for instance).

You don't have to distribute the fcntl locking, you can instead manage it
with a single server active on just one node at a time.  So go ahead and
distribute it if you really enjoy futzing with the DLM, but going for the
server approach should reduce your stress considerably.  As a fringe
benefit, you are then forced to consider how to accomodate classic server
failover within the cluster manager framework, which should not be very
hard and is absolutely necessary.

>>Starting with one obvious requirement, the cluster stack needs to be able
>>to handle different kinds of fencing methods or even mixed fencing methods.
>>If the stack stays in kernel, what is the instancing framework?  Modules?
>>I do believe we can make that work.
> 
> call_usermodehelper()?

Bad idea, this gets you back into memory deadlock zone.  Avoiding memory
deadlock is considerably easier in kernel and is nigh on impossible with
call_usermodehelper.

Sure, it's totally possible to do all that in kernel.
> 
> But we're getting ahead of ourselves - I don't want to implement yet another
> cluster stack - I'd rather fit the file system into an existing framework -
> one which already has all the fencing methods work out for instance.

Like the Red Hat framework?  Ahem.  Maybe not.  For one thing, they never
even got close to figuring out how to avoid memory deadlock.  For another,
it's a rambling bloated pig with lots of bogus factoring.  Honestly, what
you have now is a much better starting point, you should be thinking about
how to evolve it in the direction it needs to go rather than cutting over
to an existing framework, that was designed with the mindset of usermode
cluster apps, not the more stringent requirements of a cluster filesystem.

>>Consider this: if we define the fencing interface entirely in terms of
>>messages over sockets then the cluster stack does not need to know or care
>>whether the other end lives in kernel or userland.  Comments?
> 
> Interesting, and I'll have to think about whether I can poke holes in that
> or not. Of course, I'm not sure the file system ever has to call out to
> fencing directly, so maybe it's something it never has to worry about.

No, the filesystem never calls fencing, only the cluster manager does.
As I understand it, what happens is:

    1) Somebody (heartbeat) reports a dead node to cluster manager
    2) Cluster manager issues a fence request for the dead node
    3) Cluster manager receives confirmation that the node was fenced
    4) Cluster manager sends out dead node messages to cluster managers
       on other nodes
    5) Some cluster manager receives dead node message, notifies DLM
    6) DLM receives dead node message, initiates lock recovery

Step (2) is where we need plugins, where each plugin registers a fencing
and somehow each node becomes associated with a particular fencing method
(setting up this association is an excellent example of a component that
can and should be in userspace because this part never executes in the
block IO path).  The right interface to initiate fencing is probably a
direct (kernel-to-kernel) call, there is actually no good reason to use
a socket interface here.  However, the fencing confirmation is an
asynchronous event and might as well come in over a socket.  There are
alternatives (e.g., linked list event queue) but the socket is most
natural because the cluster manager already needs one to receive events
from other sources.

Actually, fencing has no divine right to be a separate subsystem and is
properly part of the cluster manager.  It's better to think of it that
way.  As such, the cluster manager <=> fencing api is internal, there is
no need to get into interminable discussions of how to standardize it.  So
let's just do something really minimal that gives us a plugin interface
and move on to harder problems.  If you do eventually figure out how to
move the whole cluster manager to userspace then you replace the module
scheme in favor of a dso scheme.

Anyway, assuming both bits are in-kernel then initiating fencing should
just be a method on the (in-kernel) node object and confirmation of
fencing is just an event sent to the node manager's event pipe.  Simple,
no?

In summary, I retract my point about using the socket to abstract away
the question of whether fencing lives in kernel or userspace and
instead assert that the fencing harness should live wherever the cluster
manager lives, which is in kernel right now and ought to stay there for
the time being.  Socket is still the right way to receive messages from
a fencing module, but a method call is a better way to initiate fencing.

Regards,

Daniel
