From: Kurt Hackel <kurt.hackel@oracle.com>
Date: Thu, 1 Jun 2006 17:29:32 -0700
Subject: [Ocfs2-devel] [RFC] Service Master Takeover harness for OCFS2
In-Reply-To: <447F74B4.4060704@google.com>
Message-ID: <20060601172932615.00000001732@khackel-us>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Daniel,

Well that's nice, but you haven't really proposed anything yet that we wouldn't already do if we had the one item that is glossed over here: proper quorum.  What you've come up with here is just a rule for choosing a "service master", which could just as well be lowest-node-number or nodename-sounds-most-like-foo.

The critical part (and the part with the handwaving) is this:

> When a quorum (less one) of nodes have replied the senior node 
> then invokes each service master takeover method with a call like:
> 
>     err = thisnode->master->takeover(thisnode);
> 

The complexity is in determining that "quorum", not in picking the resulting master.  In addition, the quorum set may change while the messaging is in progress, for instance if some topological change occurs such that the oldest node is now no longer part of the largest set of connected nodes.  This needs to be taken into consideration by possibly making the takeover process itself interruptible.

So while I agree that it would be good to eventually structure the code in a clearer way such as this, I think we need to first focus on quorum algorithms, and more critically on where this quorum determination will take place, user or kernel.  If it will be done in user, we'll need to know how each userspace driven membership event will affect the takeover, how this will occur without deadlocking, etc.

-kurt
