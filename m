From: Sum Sha <sumsha.matrixreloaded@gmail.com>
Date: Thu, 18 May 2006 20:16:47 +0530
Subject: [Ocfs2-devel] Fencing in OCFS2
In-Reply-To: <c04850370605170720g2ce8d0cayd5328712104fcb21@mail.gmail.com>
References: <c04850370605170720g2ce8d0cayd5328712104fcb21@mail.gmail.com>
Message-ID: <c04850370605180746l531fceb4x3ca1c7d76fef740a@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

With some experiments and going through OCFS2's quorum code, I am sure
that in case of serial split-brain, quorum algorithm will surely break
and will cause complete cluster shutdown. It will cause all the
subcluster nodes to panic themselves. Please correct me if I am
wrong...

o2quo_make_decision() function, which is responsible for taking the
final decision during hb_up and hb_down, makes lots of assumptions
(which may fail) and it may take wrong decision in serial split brain
cases.

Probably this problem will be resolved once "we have some more
rational approach that is driven from userspace" as mentioned in
quorum.c

Thanks.
Sumsha.

On 5/17/06, Sum Sha <sumsha.matrixreloaded@gmail.com> wrote:
> Hi,
> Just wanted to understand how OCFS2 fencing works. Sorry if this has
> already been discussed...
> (1)
> --------------
> A node has quorum when:
>         * it sees an odd number of heartbeating nodes and has network
>           connectivity to more than half of them.
>                 or
>         * it sees an even number of heartbeating nodes and has network
>           connectivity to at least half of them *and* has connectivity to
>           the heartbeating node with the lowest node number.
> --------------
> Now, Think about a case where there are 5 nodes in an OCFS2 cluster.
> Consider that split-brain happens and it's divided into 2 subclusters
> of 3-node and 2-node. In this case, this algorithm will work fine and
> the cluster with 3-node sub cluster will win the race. But think about
> the case, where there is a serial split-brain and you have 2-node,
> 2-node and 1-node (3 sub-clusters) after 2 split-brains at the same
> time. In this case, this algorithm will fail and all sub-clusters will
> be paniced, because on each sub cluster, none of the nodes has
> connectivity to more than (5/2 = 2) nodes, while each node can get
> disk hearbeat from 5 nodes.
>
> This may be the case with any cluster configuration, if there are
> serial split-brains. Has the algorithm been designed for handling
> serial split-brains? If yes, then how?
> Is there anything else which is to be considered?
>
> (2) In ocfs2_faq I read that for quorum process to get stabilzed it
> may take 28 seconds.
> --------------
> Q05     How long does the quorum process take?
> A05     First a node will realize that it doesn't have connectivity with
>         another node.  This can happen immediately if the connection is
> closed
>         but can take a maximum of 10 seconds of idle time.  Then the node
>         must wait long enough to give heartbeating a chance to declare the
>         node dead.  It does this by waiting two iterations longer than
>         the number of iterations needed to consider a node dead (see Q03 in
>         the Heartbeat section of this FAQ).  The current default of 7
>         iterations of 2 seconds results in waiting for 9 iterations or 18
>         seconds.  By default, then, a maximum of 28 seconds can pass from
> the
>         time a network fault occurs until a node fences itself.
> --------------
>
> I don't understand why are we giving heartbeating extra 2 iterations
> to declare a node dead in case of split brain? What I think is, if we
> are already missing disk heartbeat for a node, then it's missed
> heartbeat counter has already been started and we would declare that
> node dead after 7 iterations. How do we include these extra 2
> iterations?
>
> What I want to say here is, after 10 seconds of TCP idle timeout for a
> node, we believe that we will start missing disk heartbeats for that
> node and we allow 9 iterations of such missed heartbeats, but how do
> you inform the other thread, which is already doing this missed
> heartbeat calculation (because we are missing disk hearbeats), that it
> needs to wait for 2 more iterations before declaring the node dead. If
> you don't inform that thread about this, then it will declare the
> other node dead after 7 iterations only. So how this extra 2
> iterations concept will come into picture?
>
> Thanks.
> Sumsha.
>
