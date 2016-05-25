From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Wed, 25 May 2016 09:44:23 +0800
Subject: [Ocfs2-devel] [patch 1/6] ocfs2: o2hb: add negotiate timer
In-Reply-To: <20160524223557.GQ7633@wotan.suse.de>
References: <57437b24.EEEpYkPZSJqHbkjn%akpm@linux-foundation.org>
	<20160524223557.GQ7633@wotan.suse.de>
Message-ID: <57450377.10509@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 05/25/2016 06:35 AM, Mark Fasheh wrote:
> On Mon, May 23, 2016 at 02:50:28PM -0700, Andrew Morton wrote:
>> From: Junxiao Bi <junxiao.bi@oracle.com>
>> Subject: ocfs2: o2hb: add negotiate timer
> 
> Thank you for the well written patch description by the way.
> 
> 
>> This series of patches is to fix the issue that when storage down, all
>> nodes will fence self due to write timeout.
>>
>> With this patch set, all nodes will keep going until storage back online,
>> except if the following issue happens, then all nodes will do as before to
>> fence self.
>>
>> 1. io error got
>> 2. network between nodes down
>> 3. nodes panic
>>
>> This patch (of 6):
>>
>> When storage down, all nodes will fence self due to write timeout.  The
>> negotiate timer is designed to avoid this, with it node will wait until
>> storage up again.
>>
>> Negotiate timer working in the following way:
>>
>> 1. The timer expires before write timeout timer, its timeout is half
>>    of write timeout now.  It is re-queued along with write timeout timer.
>>    If expires, it will send NEGO_TIMEOUT message to master node(node with
>>    lowest node number).  This message does nothing but marks a bit in a
>>    bitmap recording which nodes are negotiating timeout on master node.
> 
> I went through the patch series, and generally feel that the code
> is well written and straight forward. I have two issues regarding
> how this operates. Otherwise, I like the general direction this
> is taking.
> 
> The first is easy - we're updating the o2cb network protocol and
> need to bump the protocol version otherwise a node that doesn't
> speak these new messages could mount and even be selected as the
> 'master' without actually being able to participate in this scheme.
Right. Will add this.
> 
> 
> My other concern is whether the notion of 'lowest node' can
> change if one comes online while the cluster is negotiating this
> timeout. Obviously in the case where all the disks are unplugged
> this couldn't happen because a new node couldn't begin to
> heartbeat.
Yes.
> 
> What about a situation where only some nodes are negotiating this
> timeout? On the ones which have no disk access, lowest node
> number still won't change since they can't read the new
> heartbeats. On those with stable access though, can't this value
> change? How does that effect this algorithm?
The lowest node can change for good nodes, but didn't affect the
algorithm. Because only bad nodes sent NEGO_TIMEOUT message while good
nodes not, so the original lowest node will never receive NEGO_TIMEOUT
messages from all nodes, then it will not approve the timeout, at last
bad nodes will fence self and good nodes keep alive.

Thanks,
Junxiao.
> 
> Thanks,
> 	--Mark
> 
> --
> Mark Fasheh
> 
