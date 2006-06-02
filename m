From: Daniel Phillips <phillips@google.com>
Date: Thu, 01 Jun 2006 19:03:53 -0700
Subject: [Ocfs2-devel] [RFC] Service Master Takeover harness for OCFS2
In-Reply-To: <20060601172932615.00000001732@khackel-us>
References: <20060601172932615.00000001732@khackel-us>
Message-ID: <447F9C89.1050407@google.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Kurt Hackel wrote:
> Hi Daniel,
> 
> Well that's nice, but you haven't really proposed anything yet that we
> wouldn't already do if we had the one item that is glossed over here:
> proper quorum.

That is nice to know because I'm trying not to reinvent anything here.  But
I think you forgot to mention the registration part of the proposal.

> What you've come up with here is just a rule for choosing
> a "service master", which could just as well be lowest-node-number
> or nodename-sounds-most-like-foo.

I'm glad you like it.  I was thinking of making that rule pluggable in case
somebody really hates the oldest node rule.  I don't like "lowest-node-number"
very much just because it is easy for a new node with a lower node number than
the incumbent senior node to come in and then you have to do something special
to accomodate that.  Oldest node also introduces a pleasant queueing behavior,
giving nodes some extra time to settle down as they work their way up the
queue towards a potential takeover position.

I think we can agree that nodename-sounds-most-like-foo is not a particularly
desireable ordering criterion.

But anyway, the rule is a minor part, the main part of that proposal is the
harness.

> The critical part (and the part with the handwaving) is this:

Handwaving?  I just haven't gotten to the membership RFC yet.  Expect it
next thursday.  The membership RFC includes a specific proposal for
handling quorum.  Arguably, the notion of quorum should be pluggable, but
for now I favor the current simple idea of fixing quorum to more than half
of the configured nodes, with a special hack (please no votes!) to handle
the even number case and another special hack to support editing the
global configuration file while the cluster is up.

>>When a quorum (less one) of nodes have replied the senior node 
>>then invokes each service master takeover method with a call like:
>>
>>    err = thisnode->master->takeover(thisnode);
> 
> The complexity is in determining that "quorum", not in picking the
> resulting master.  In addition, the quorum set may change while the
> messaging is in progress, for instance if some topological change
> occurs such that the oldest node is now no longer part of the  largest
> set of connected nodes.  This needs to be taken into  consideration by
> possibly making the takeover process itself  interruptible.

Agreed on all points, except that I do not think that the takeover process
needs to be interruptible.  It must handle failures because it might attempt
to message a node that has been fenced, but it does not have to fail in that
case unless it loses quorum.  I do not think it needs any more protocol than
that.

This idea is already quite tolerant of topology changes.  (Note: here we
encounter a nice property of the oldest member enumeration.  New members
always join at the end of the list, so any set of messages that has to work
through every member exactly once can operate in order of senority and just
keep going until it hits the end of the list.  In fact this property is so
attractive that perhaps we should just decide right now that the oldest
node enumeration is the one true enumeration.)

Anyway, where did that "start stop finish" idea come from?  I am curious,
you could call it fascination with the bizarre.

> So while I agree that it would be good to eventually structure the code
>  in a clearer way such as this, I think we need to first focus on quorum
>  algorithms, and more critically on where this quorum determination will
> take place, user or kernel.  If it will be done in user, we'll need to
> know how each userspace driven membership event will affect the takeover,
> how this will occur without deadlocking, etc.

While I expect Lars will swear on a bible that user space is the one true
place to calculate quorum, I have in mind a simple kernel-based algorithm.
Once again, if somebody really hates it then we can make it pluggable, but
I personally do not think there is a lot to hate about it.

In case you can't stand the suspense, the key enabler is to have that
senior node available to arbitrate the process of joining connected subsets
together into an eventual quorum group.  Think about it: in every subset of
nodes you can determine a senior node, sometimes needing to break a tie of
course.  The senior nodes of two subsets can negotiate which is the new
senior, the new senior then imposes an ordering on the subgroups to form
a larger group and so we go until we have a quorum.  Senior nodes need a
way to broadcasting their availability for cluster formation, add a few
details on messaging, shake, stir, bake and we're done.

Regards,

Daniel
