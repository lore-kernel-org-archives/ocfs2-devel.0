From: Daniel Phillips <phillips@google.com>
Date: Wed, 31 May 2006 11:38:07 -0700
Subject: [Ocfs2-devel] [RFC] Fencing harness for OCFS2
In-Reply-To: <20060531001925.GQ17040@marowsky-bree.de>
References: <44767695.7000203@google.com>
	<20060530193848.GP17040@marowsky-bree.de>
	<447CA02C.30308@suse.com> <447CA7D7.4090803@google.com>
	<20060531001925.GQ17040@marowsky-bree.de>
Message-ID: <447DE28F.9090308@google.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Lars Marowsky-Bree wrote:
> On 2006-05-30T13:15:19, Daniel Phillips <phillips@google.com> wrote:
> 
>>As I would expect.  To be sure, I am interested in hooking up Linux-HA
>>properly to OCFS2, but what we need to do is to place the core of fencing
>>in the kernel where it is easiest to implement anti-deadlock measures,
> 
> This is not sufficient, though. The piece making the policy decision to
> fence also needs to be protected, as you note later:

That is not quite accurate.  Fencing modules as I define them do not
encapsulate policy, they provide mechanism through which the cluster
administrator or user space tools can implement policy.  Policy is
implemented by plugging in the correct methods and paramaterizing the
methods.

So my fencing harness proposal does _not_ put policy in kernel, only
mechanism.

>>But fencing is only part of the story.  The whole list of cluster manager
>>components that can execute in the block writeout path and therefore need
>>to obey memory deadlock rules is:
>>
>>  * Heartbeat
>>  * Fencing
>>  * Membership and node status events
>>  * Service takeover for essential services (including DLM recovery)
>>  * Node addressing and messaging required for the above
>>
>>I think that is the whole list, if I have missed anything somebody please
>>shout.  Each of these components needs to get a treatment similar to what
>>I have proposed for fencing.  For example, we need a pluggable API for
>>service takeover, which I am drafting now.  If anybody really doesn't
>>like my proposal for a fencing harness, please speak up now because the
>>proposal for service takeover will be very similar.
>
> You can't really wish to place all of these into kernel space. This is
> exactly what we're moving away from.

Who is moving away from?  OCFS2 team guys have toyed with the idea but
hopefully understand why it's a bad idea by now.  If not then maybe I
need to adjust the violence setting on my larting tool.

Anyway, I erred in not mentioning above that only a small core of each
service has to stay in kernel or otherwise implement memory deadlock
avoidance measures.  Most of the bulky code can indeed go to userspace
without any special measures, just not anything that has to execute
in the block write path.

So yes, I intend to place all of the above in kernel space.  OCFS2 has
them there now anyway, though not in a sufficiently general form.  I
promise that by the time I am done OCFS2's kernel cluster stack code
will be significantly smaller and more general at the same time, and
you will be able to do all the fancy things you're doing now, except
drive those essential services from user space.

If you think you can solve the problem accurately with less kernel
code then please please show me how, but don't forget that _all_
fencing code that can execute in the block write path must obey the
memory deadlock rules.

> I've not been very good at following the list. How do you protect
> against memory inversion - reliably? It's hard enough _within_ the
> kernel.

To write a userspace daemon capable of executing reliably in the block
writeout path:

    1. Preallocate all working memory for the daemon including stack, then
       memlock everything

    2. Must not load any libraries, exec any program or script, or
       otherwise do anything that can't be statically analyzed for bounded
       memory usage

    3. Must throttle service traffic so that a static bound can be placed
       on memory usage (special case of 1.).

    4. Do all of this not only for nodes actually running services for
       the cluster filesystem, but also for any cluster filesystem node
       the service can fail over to.

    5. Audit all syscalls to ensure no memory is used.  Since this is
       generally impossible, we need a special hack to run the user
       space daemon in PF_ALLOC mode (yes this works)

> Many parts of heartbeat do, in fact, take great pains to not cause any
> paging etc, yet it's very hard to guarantee this for the entire stack
> from low-level networking up to high-level policy decisions.

Yes.  Much easier to code the bits the block IO path actually needs in
kernel.  You can in theory accomplish this in user space as above, but
why anybody would want to go through that pain to end up with a fragile,
bulky and arguably unmaintainable solution is not clear to me.

> It's not as much of a problem if you're not trying to run / on a CFS,
> though, or if at least you have local swap (to which, in theory, you
> could swap out writes ultimately destined for the CFS). And, of course,
> if one node deadlocks on memory inversion, the others are going to fence
> it from the outside.

As with pregnancy, there is no such thing as a little bit deadlocked.
You can hit the memory deadlock even on a non-root partition.  All you
have to do is write to it, swapping will trigger it more easily but
writing can still trigger it.

> I know we've had this discussion for years, but I don't remember _ever_
> seeing a solution.

I never got around to spelling out the easy bits, just the hard part
involving receiving network packets.

See here, and the series of improved patches that followed:

    http://lwn.net/Articles/146061/?format=printable

Avoiding the deadlock in kernel (except for the network receive) is
generally pretty easy.  Just make sure that any kernel daemon that can
execute in the block write path runs in PF_ALLOC mode and is accurately
throttled, a subset of the user space requirements.

Regards,

Daniel
