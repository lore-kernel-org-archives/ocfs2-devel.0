From: Daniel Phillips <phillips@google.com>
Date: Thu, 25 May 2006 14:35:43 -0700
Subject: [Ocfs2-devel] Fencing in OCFS2
In-Reply-To: <c04850370605170720g2ce8d0cayd5328712104fcb21@mail.gmail.com>
References: <c04850370605170720g2ce8d0cayd5328712104fcb21@mail.gmail.com>
Message-ID: <4476232F.2070700@google.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Sum Sha wrote:
> --------------
> Q05     How long does the quorum process take?
> A05     First a node will realize that it doesn't have connectivity with
>         another node.  This can happen immediately if the connection is closed
>         but can take a maximum of 10 seconds of idle time.  Then the node
>         must wait long enough to give heartbeating a chance to declare the
>         node dead.  It does this by waiting two iterations longer than
>         the number of iterations needed to consider a node dead (see Q03 in
>         the Heartbeat section of this FAQ).  The current default of 7
>         iterations of 2 seconds results in waiting for 9 iterations or 18
>         seconds.  By default, then, a maximum of 28 seconds can pass from the
>         time a network fault occurs until a node fences itself.
> --------------
> 
> I don't understand why are we giving heartbeating extra 2 iterations
> to declare a node dead in case of split brain? What I think is, if we
> are already missing disk heartbeat for a node, then it's missed
> heartbeat counter has already been started and we would declare that
> node dead after 7 iterations. How do we include these extra 2
> iterations?

While working on the fencing harness RFC I realized why that extra wait
is necessary.  Heartbeat will continue pinging a node some number of
periods even while it receives no responses from the node.  The trouble
is, the remote node may be receiving the pings and answering them, but
the answers are getting lost somewhere along the route back.  So the
remote node does not yet know it is incommunicado.  Then heartbeat
gives up and stops pinging.  It is only at this point that the
remote node is sure to start its watchdog count.

Given:

   A = number of missed answers before heartbeat stops pinging
   B = number of missed pings before watchdog triggers
   H = heartbeat period
   L = maximum network latency within some confidence factor
   W = maximum latency between watchdog trigger and shutdown

the time to declare a node dead is:

   P(A + B) + 2L

so with:

   A = 2
   B = 2
   H = 2 seconds
   L = .5 seconds
   W = 10 seconds

we have:

   8 + 1 + 10 = 19 seconds

Network latency includes the maximum time to notice a ping and respond to
it, and the time required for heartbeat to notice the answer.  There is no
need to incorporate a safety factor because allowing more than one missed
ping is already a safety factor.

Did I miss anything in my bookkeeping?  I did not check to see if OCFS2's
heartbeat obeys this formula.

Unfortunately, it is difficult to establish dependable bounds for network
latency, so heartbeating is really a game of probabilities.  We should set
the safety factor high enough so that false positives do not cost more
downtime than would be saved by shorter timeouts.

Now, if we use a storage-side fencing method instead of a watchdog we can
set B and W to zero, giving 5 seconds using the example above.  This is
three times better and shows why we need a proper fencing harness sooner
rather than later.

Regards,

Daniel
