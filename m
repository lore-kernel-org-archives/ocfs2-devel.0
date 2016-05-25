From: Mark Fasheh <mfasheh@suse.de>
Date: Wed, 25 May 2016 16:26:19 -0700
Subject: [Ocfs2-devel] [patch 1/6] ocfs2: o2hb: add negotiate timer
In-Reply-To: <57450377.10509@oracle.com>
References: <57437b24.EEEpYkPZSJqHbkjn%akpm@linux-foundation.org>
	<20160524223557.GQ7633@wotan.suse.de> <57450377.10509@oracle.com>
Message-ID: <20160525232619.GS7633@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, May 25, 2016 at 09:44:23AM +0800, Junxiao Bi wrote:
> On 05/25/2016 06:35 AM, Mark Fasheh wrote:
> > I went through the patch series, and generally feel that the code
> > is well written and straight forward. I have two issues regarding
> > how this operates. Otherwise, I like the general direction this
> > is taking.
> > 
> > The first is easy - we're updating the o2cb network protocol and
> > need to bump the protocol version otherwise a node that doesn't
> > speak these new messages could mount and even be selected as the
> > 'master' without actually being able to participate in this scheme.
> Right. Will add this.

Great, thanks!


> > 
> > 
> > My other concern is whether the notion of 'lowest node' can
> > change if one comes online while the cluster is negotiating this
> > timeout. Obviously in the case where all the disks are unplugged
> > this couldn't happen because a new node couldn't begin to
> > heartbeat.
> Yes.
> > 
> > What about a situation where only some nodes are negotiating this
> > timeout? On the ones which have no disk access, lowest node
> > number still won't change since they can't read the new
> > heartbeats. On those with stable access though, can't this value
> > change? How does that effect this algorithm?
> The lowest node can change for good nodes, but didn't affect the
> algorithm. Because only bad nodes sent NEGO_TIMEOUT message while good
> nodes not, so the original lowest node will never receive NEGO_TIMEOUT
> messages from all nodes, then it will not approve the timeout, at last
> bad nodes will fence self and good nodes keep alive.

Ok, in that case you can put:

Reviewed-by: Mark Fasheh <mfasheh@suse.de>

on the patches I've seen (this series). We don't want it to go upstream
until your patch to bump the protocol version though so please cc me on
that patch and the others.

Thanks,
	--Mark

--
Mark Fasheh
