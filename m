From: Lars Marowsky-Bree <lmb@suse.de>
Date: Thu, 1 Jun 2006 12:13:36 +0200
Subject: [Ocfs2-devel] [RFC] Fencing harness for OCFS2
In-Reply-To: <447E3B88.1010108@google.com>
References: <44767695.7000203@google.com>
	<20060530193848.GP17040@marowsky-bree.de>
	<447CA02C.30308@suse.com> <447CA7D7.4090803@google.com>
	<20060531001925.GQ17040@marowsky-bree.de>
	<447DE28F.9090308@google.com>
	<20060531230302.GB4265@marowsky-bree.de>
	<447E3B88.1010108@google.com>
Message-ID: <20060601101336.GC4265@marowsky-bree.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 2006-05-31T17:57:44, Daniel Phillips <phillips@google.com> wrote:

>   * Heartbeat
>   * Membership and node status events
>   * Node addressing and messaging required for the above
> 
> and for completeness, the two others that need to be in kernel but aren't
> involved in the decision to fence are:
> 
>   * Fencing
>   * Service takeover for essential services (including DLM recovery)
> 
> Deciding whether a node needs to be fenced is pretty easy.  If it missed X
> heartbeats, fence it.

That is too simplistic.

For example, _you_ think it missed the heartbeats. What do the other
nodes think? Did they hear it? Maybe it is you who should be fenced
instead?  You need to arrive at a concensus on what the cluster should
look like, and (heuristically) compute the largest fully connected set.

And before fencing, you need to ensure you (still) have the required
quorum.

And, what if you, locally, can't talk to the fencing device necessary to
reset said node and the request has to be forwarded to another node?

To be sure, this can be done within the kernel, but it rains over the
parade as "it's so easy". ;-)

(The Concensus Cluster Membership layer alone in heartbeat is roughly
25kLoC (including comments and stuff, though.) That's not to say it
couldn't be cleaned up and done in 15kLoC, but it's definitely more than
a couple of hundred. In particular if you then have to deal with mixed
versions and so on.)

> I remember it well, I also kept my mouth shut as far as possible flights of
> fancy involving virtual filesystems and other metamagical wondery floated
> around in the crack pipe induced haze.  To be sure, there were some sensible
> suggestions put forth also, but that wasn't one of them.

Ah. Right. That must have been the reason.

> >Fencing needs to talk to all sorts of nasty devices, something really
> >well handled by user-space and some expect scripts.
> 
> If fencing itself can deadlock, it does not meet my definition of
> "well handled".  Now suppose you have a device that really does
> require more code than anyone in good conscience would write in a
> kernel module, or that device absolutely must be fenced by a
> combination of bash and perl for some unfathomable reason.  Then
> (copying from an earlier post) your options are:
> 
>   1) A kernel fencing method sends messages to a dedicated fencing
>   node that does not mount the filesystem.  This may waste a node and
>   needs some additional mechanism to avoid becoming a single point of
>   failure.
> 
>   2) A kernel fencing method sends messages to a userspace program
>   written in C, memlocked, and running in (slight kernel hack here)
>   PF_MEMALLOC mode.  This might require a little more work than a Perl
>   script, but then real men enjoy work.

But, our (as far as we can tell, appropriately protected) user-space
membership and fencing layer already does that. Why would you want to
move it back to the kernel?

>   3) A kernel fencing method sends messages to a userspace program running
>   in a resource sandbox (e.g. UML or XEN) that does whatever it wants to.
>   This is really buzzword compatible, really wasteful, and a great use of
>   administration time.

Heh, yeah, people have brought this up to isolate things like iSCSI
initiators and servers etc. Really quite painful. OTOH, the idead of
compartmentalizing processes from eachother, down to the kernel level,
does have some merit (in particular in this context).

But, if you go to that length, you can already encapsulate the
user-space clustering layer there, and don't need to move it into the
kernel either. ;-)

> How much policy is involved in "missed X heartbeats => fence it"?  I see
> exactly two policy inflection points: the value of X and the period of a
> heartbeat. 

See above.

> I will buy your argument if the required kernel code is more than a few
> hundred lines, otherwise I don't agree, it's more important to be obviously
> correct.

I don't know how to say that, but the last time I found you were
obviously correct has been awhile ;-)
> 
> >However, the more processes we gain digging into PF_MEMALLOC means
> >this reserve becomes more precious too, and they can interfere with
> >eachother, if they all need their memory at the same time.
> Fortunately I anticipated that.  You will see in the anti memory
> deadlock patches I posted this summer there is a mechanism for
> resizing the PF_MEMALLOC reserve as necessary, suitable for use at
> module init and exit time.

Have they been merged yet? If not, why? (I'm not asking to be annoying,
but because LKML etc is a big place and I missed the discussion. And,
"this summer" has been mostly winter so far in Germany, so I'm not sure
which summer you're refering to ;-)

If we can resize the PF_MEMALLOC space and have authorized user-space
dig into it, did you not just cause the need for this to be implemented
in kernel to go away?

> >Another key point to keep in mind is that, looking at the larger
> >picture, too many things _already_ have been moved out of the kernel
> >(and are unlikely to go back) to make it feasible to solve the problem
> >only there. 
> I think I know what you're talking about, you think that there will be no
> nice interface from the kernel cluster components to userspace.

No, actually I'm saying that we've already got so many critical piece
outside kernel-space that we really need a solution - ie, giving them
access to PF_MEMALLOC, priorizing their network communication above
others, and if the PF_MEMALLOC reserve (or some other resource) becomes
a point of contention among this privileged group, arbitate as sanely as
possible.

> I am not going to lose a whole lot of sleep over MPIO wankery.  If you need
> it, plug it in.  Maybe one day we will get around to re-engineering it so
> it works properly.

But, if you want to work really hard and be appreciated, you should put
more work towards helping solving the user-space problem, because then
your solution will be general.

(Not just by OCFS2, but by iSCSI, GFS, MPIO, (dare I say it:) FUSE ...)

> >Ah, you didn't read what I wrote. Read again. When we can free up memory
> >for our "dirty" user-space stack by pushing out writes destined to the
> >CFS to the local swap, so we can fence etc and all that. That's an idea
> >I've been toying around with lately.
> >
> >Of course, when we're out of virtual memory too, that won't work
> >either.
> 
> I was going to mention that.

If you're completely out of virtual memory, dude, better take that
suicide pill. ;-) And, as you mention above, the critical bits get
access to the PF_MEMALLOC reserve.

> Your solution needs to be obviously non-deadlocking.  It is considerably
> easier to do that analysis in kernel space.  It is _possible_ to do it
> in user space but in the end what do you get?  A more fragile, complex
> solution with the speedy interfaces on the wrong side of the kernel
> boundary and more kernel glue than you saved by taking the critical bits
> out of the kernel.  But suit yourself, art is in the eye of the beholder.

Well, there is the political question about how you're going to get this
actually _into_ the kernel when people seem to be convinced it can be
handled in user-space. Many a solution has hit the wall at this stage,
and I'd recommend at least giving this argument some thought, because it
will come up.

> Note that I do plan a nice, tight little interface to userspace methods,
> which I promise will be able to interface with little effort to the work
> you described above.  I am pretty sure your code will get smaller too, or
> it would if you didn't need to keep the old cruft around to support
> prehistoric kernels.  So if the kernel gets smaller and userspace gets
> smaller and it all gets faster and more obviously correct, What is the
> problem again?

Well, if that is indeed the combined result, we shall certainly all be
delighted. What's your timeline for the first useable pilot?



Sincerely,
    Lars Marowsky-Br?e

-- 
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX Products GmbH - A Novell Business	 -- Charles Darwin
"Ignorance more frequently begets confidence than does knowledge"
