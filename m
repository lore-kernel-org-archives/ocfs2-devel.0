From: Daniel Phillips <phillips@google.com>
Date: Thu, 01 Jun 2006 11:57:38 -0700
Subject: [Ocfs2-devel] [RFC] Fencing harness for OCFS2
In-Reply-To: <20060601101336.GC4265@marowsky-bree.de>
References: <44767695.7000203@google.com>
	<20060530193848.GP17040@marowsky-bree.de>
	<447CA02C.30308@suse.com> <447CA7D7.4090803@google.com>
	<20060531001925.GQ17040@marowsky-bree.de>
	<447DE28F.9090308@google.com>
	<20060531230302.GB4265@marowsky-bree.de>
	<447E3B88.1010108@google.com>
	<20060601101336.GC4265@marowsky-bree.de>
Message-ID: <447F38A2.3090208@google.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Lars Marowsky-Bree wrote:
> On 2006-05-31T17:57:44, I wrote:
>>Deciding whether a node needs to be fenced is pretty easy.  If it missed X
>>heartbeats, fence it.
> 
> That is too simplistic.
> 
> For example, _you_ think it missed the heartbeats. What do the other
> nodes think? Did they hear it? Maybe it is you who should be fenced
> instead?  You need to arrive at a concensus on what the cluster should
> look like, and (heuristically) compute the largest fully connected set.

The node doing the fencing has quorum by definition.  None of the nodes
in the quorum have missed X heartbeats by definition.  So our node is
perfectly within its rights to fence any node that has missed X
heartbeats.  Duh.

> And before fencing, you need to ensure you (still) have the required
> quorum.

See, you are not far off grokking all this, you probably just need another
cup of coffee.

> And, what if you, locally, can't talk to the fencing device necessary to
> reset said node and the request has to be forwarded to another node?

Asymmetric fencing capability is covered by my earlier RFC, you will need
different methods on nodes with and without fencing capability.  Setting
this up is handled entirely by user space.  There is no special kernel
support for this because none is needed.

> To be sure, this can be done within the kernel, but it rains over the
> parade as "it's so easy". ;-)

Good thing I brought my simplicity umbrella with me today.

> (The Concensus Cluster Membership layer alone in heartbeat is roughly
> 25kLoC (including comments and stuff, though.) That's not to say it
> couldn't be cleaned up and done in 15kLoC, but it's definitely more than
> a couple of hundred. In particular if you then have to deal with mixed
> versions and so on.)

I hold to my prediction of a 3 digit number of lines of kernel code needed
for the cluster stack, including basic methods to emulate OCFS2's  current
behavior.  Interesting to hear I will compete with a solution an order of
magnitude more bloated, and I bet, harder to audit and less performant.

Since I still intend to convince you of the yummy goodness of driving your
code via core events that come from kernel, much of your 15K lines of code
will still be useful with this arrangement.  I do not doubt that you have
a much longer requirements list than the kernel code does and I agree that
the bulk of the code must be in user space.

> But, our (as far as we can tell, appropriately protected) user-space
> membership and fencing layer already does that. Why would you want to
> move it back to the kernel?

It is already in kernel, I am not moving it anywhere, I am just evolving
it in a natural direction.

>>...You will see in the anti memory
>>deadlock patches I posted [last] summer there is a mechanism for
>>resizing the PF_MEMALLOC reserve as necessary, suitable for use at
>>module init and exit time.
> 
> Have they been merged yet? If not, why? (I'm not asking to be annoying,
> but because LKML etc is a big place and I missed the discussion. And,
> "this summer" has been mostly winter so far in Germany, so I'm not sure
> which summer you're refering to ;-)

Excuse me, I meant last summer, posted and discussed on netdev.  Notice how
that topic dropped from issue number one at last year's KS to not even on
the agenda this year.  That is because the interesting bit of the problem
is done, though somebody (me) still has to get busy and prepare the patch
for merging.  This will arrive along with my NBD server rewrite, which lets
me set up a nice test case for it.

> If we can resize the PF_MEMALLOC space and have authorized user-space
> dig into it, did you not just cause the need for this to be implemented
> in kernel to go away?

One of the needs, yes.  Other needs include keeping the code small and easy
to audit, and keeping short lines of communication to the kernel cluster
filesystem, which is by far the heaviest user.

>>I think I know what you're talking about, you think that there will be no
>>nice interface from the kernel cluster components to userspace.
> 
> No, actually I'm saying that we've already got so many critical piece
> outside kernel-space

So far you only mentioned MPIO, an out of kernel patch that still seems
far from sanity.

> ...we really need a solution - ie, giving them
> access to PF_MEMALLOC, priorizing their network communication above
> others, and if the PF_MEMALLOC reserve (or some other resource) becomes
> a point of contention among this privileged group, arbitate as sanely as
> possible.

I agree, you need a solution.  The main bit you don't have right now is
a syscall or ioctl for setting/clearing PF_MEMALLOC.  How about we float
a really awful patch for that on lkml and wait for the hive mind to come
up with something palatable?

> But, if you want to work really hard and be appreciated, you should put
> more work towards helping solving the user-space problem, because then
> your solution will be general.
> 
> (Not just by OCFS2, but by iSCSI, GFS, MPIO, (dare I say it:) FUSE ...)

I need to stay focussed on my own work at the moment, that includes fixing
the in-kernel network deadlock, fixing NBD to support local use of exports,
finishing up my cluster block devices, and patching OCFS2's cluster stack
to be general enough to support those cluster block devices.  That means
I won't be taking side trips into FUSE and MPIO for a while.  You are
welcome to of course, and I will code a (really lousy) userspace interface
for PF_MEMALLOC for you if you like.

>>>Ah, you didn't read what I wrote. Read again. When we can free up memory
>>>for our "dirty" user-space stack by pushing out writes destined to the
>>>CFS to the local swap, so we can fence etc and all that. That's an idea
>>>I've been toying around with lately.
>>>
>>>Of course, when we're out of virtual memory too, that won't work
>>>either.
>>
>>I was going to mention that.
> 
> If you're completely out of virtual memory, dude, better take that
> suicide pill. ;-)

Sorry, you got that wrong once again.  You can fill up all of swap just
doing normal writes to a file.  Try to find a mechanism in the VMM that
prevents that, you won't, because that is how Linux works.  By introducing
swap you don't change the fundamental problem at all, just push it around
a little.

> Well, there is the political question about how you're going to get this
> actually _into_ the kernel when people seem to be convinced it can be
> handled in user-space.

Those people have probably not even thought about the deadlock problem,
not to mention other valid reasons.  Anyway, like I keep saying, it is
_already_ in kernel, I am just improving it, and shrinking it too I expect.

> Many a solution has hit the wall at this stage,
> and I'd recommend at least giving this argument some thought, because it
> will come up.

It has come up.  The protests are getting weaker.  Those protesting
generally are not writing a lot of code which doesn't help their protests
much.

>>Note that I do plan a nice, tight little interface to userspace methods,
>>which I promise will be able to interface with little effort to the work
>>you described above.  I am pretty sure your code will get smaller too, or
>>it would if you didn't need to keep the old cruft around to support
>>prehistoric kernels.  So if the kernel gets smaller and userspace gets
>>smaller and it all gets faster and more obviously correct, What is the
>>problem again?
> 
> Well, if that is indeed the combined result, we shall certainly all be
> delighted. What's your timeline for the first useable pilot?

"When it is ready".  The next item on the agenda is an RFC for a pluggable
service master takeover harness along similar lines to the fencing harness.
I need this in order to integrate my block devices and I think it will also
be a pretty big improvement over OCFS2's existing dlm_pick_recovery_master
which is pretty scary as was discussed yesterday.  I will offer a patch for
those two to kick around before moving on to membership events.

Regards,

Daniel
