From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Fri, 19 May 2006 23:11:37 -0700
Subject: [Ocfs2-devel] OCFS2 features RFC
In-Reply-To: <446D12CF.2080501@google.com>
References: <20060425183553.GB10524@ca-server1.us.oracle.com>
	<446398D3.7010508@suse.com>
	<20060517014419.GS21588@ca-server1.us.oracle.com>
	<446BBCF5.7040903@google.com>
	<20060518024638.GY21588@ca-server1.us.oracle.com>
	<446D12CF.2080501@google.com>
Message-ID: <20060520061137.GA21588@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, May 18, 2006 at 05:35:27PM -0700, Daniel Phillips wrote:
> Ok, I just figured out how to be really lazy and do cluster-consistent
> NFS locking across clustered NFS servers without doing much work.  In the
> duh category, only one node will actually run lockd and all other NFS
> server nodes will just port-forward the NLM traffic to/from it.  Sure,
> you can bottleneck this scheme with a little effort, but to be honest we
> aren't that interested in NFS locking performance, we are more interested
> in actual file operations.
Out of curiousity, how will a failure on the lockd node be handled? Or is
this something that you're not worried about.

> >call_usermodehelper()?
> 
> Bad idea, this gets you back into memory deadlock zone.  Avoiding memory
> deadlock is considerably easier in kernel and is nigh on impossible with
> call_usermodehelper.
Good catch, I threw that out without fully evaluating the implications :)
 
> Like the Red Hat framework?  Ahem.  Maybe not.  For one thing, they never
> even got close to figuring out how to avoid memory deadlock.  For another,
> it's a rambling bloated pig with lots of bogus factoring.  Honestly, what
> you have now is a much better starting point,
Well, I should've said "multiple existing frameworks" - so people could run
whatever fits their needs the best. So folks could pick the feature sets
that suit their needs the best. Besides, I think you're being somewhat
unfair to the Red Hat framework. It does _alot_ more than the OCFS2 stack
can even dream of handling right now. And we haven't even talked about
Linux-HA yet.

> you should be thinking about how to evolve it in the direction it needs to
> go rather than cutting over to an existing framework, that was designed
> with the mindset of usermode cluster apps, not the more stringent
> requirements of a cluster filesystem.
I hear they have this thing called "GFS" ;) 

What we are thinking about right now is how we can reuse code - building on
other people's bug fixes, feature patches, etc. What we have today just
bootstraps our file system into the world of the cluster. Deciding to go the
full blown home grown cluster route path isn't some decision we make based
on one (admittedly difficult) bug or design issue. Nor is it something that
we will undertake without having fully explored all other alternatives.
 
> No, the filesystem never calls fencing, only the cluster manager does.
> As I understand it, what happens is:
> 
>    1) Somebody (heartbeat) reports a dead node to cluster manager
>    2) Cluster manager issues a fence request for the dead node
>    3) Cluster manager receives confirmation that the node was fenced
>    4) Cluster manager sends out dead node messages to cluster managers
>       on other nodes
>    5) Some cluster manager receives dead node message, notifies DLM
>    6) DLM receives dead node message, initiates lock recovery
That sounds alot closer to how it should happen, IMHO.

> Step (2) is where we need plugins, where each plugin registers a fencing
> and somehow each node becomes associated with a particular fencing method
> (setting up this association is an excellent example of a component that
> can and should be in userspace because this part never executes in the
> block IO path).  The right interface to initiate fencing is probably a
> direct (kernel-to-kernel) call, there is actually no good reason to use
> a socket interface here.
Fencing plugins by the way can tend to do a variety of things, ranging from
direct device access, to being able to telnet or ssh into a switch. The
plugin system therefore needs to be fairly generic, to the level of
running a binary that could be written in perl, C, etc.

> However, the fencing confirmation is an asynchronous event and might as
> well come in over a socket. There are alternatives (e.g., linked list
> event queue) but the socket is most natural because the cluster manager
> already needs one to receive events from other sources.
> 
> Actually, fencing has no divine right to be a separate subsystem and is
> properly part of the cluster manager.  It's better to think of it that
> way.  As such, the cluster manager <=> fencing api is internal, there is
> no need to get into interminable discussions of how to standardize it.
Sure.

> So let's just do something really minimal that gives us a plugin
> interface and move on to harder problems. If you do eventually figure out
> how to move the whole cluster manager to userspace then you replace the
> module scheme in favor of a dso scheme.
Well, I'm wondering how we're going to support all the different fencing
methods using kernel modules ;)
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh at oracle.com
