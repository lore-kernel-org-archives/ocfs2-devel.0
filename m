From: Daniel Phillips <phillips@google.com>
Date: Wed, 31 May 2006 17:57:44 -0700
Subject: [Ocfs2-devel] [RFC] Fencing harness for OCFS2
In-Reply-To: <20060531230302.GB4265@marowsky-bree.de>
References: <44767695.7000203@google.com>
	<20060530193848.GP17040@marowsky-bree.de>
	<447CA02C.30308@suse.com> <447CA7D7.4090803@google.com>
	<20060531001925.GQ17040@marowsky-bree.de>
	<447DE28F.9090308@google.com>
	<20060531230302.GB4265@marowsky-bree.de>
Message-ID: <447E3B88.1010108@google.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Lars Marowsky-Bree wrote:
> I meant to say that having the fencing alone in the kernel isn't
> sufficient; you also need to have the processes which ultimately
> conclude that fencing of node(s) $foo is required protected.

Yes.  From my earlier post, those processes are:

   * Heartbeat
   * Membership and node status events
   * Node addressing and messaging required for the above

and for completeness, the two others that need to be in kernel but aren't
involved in the decision to fence are:

   * Fencing
   * Service takeover for essential services (including DLM recovery)

Deciding whether a node needs to be fenced is pretty easy.  If it missed X
heartbeats, fence it.

>>Who is moving away from?  OCFS2 team guys have toyed with the idea but
>>hopefully understand why it's a bad idea by now.  If not then maybe I
>>need to adjust the violence setting on my larting tool.
> 
> It's what's been discussed at all the events I've went to in the last
> couple of years, one or two even organized by you, as I recall ;-)

I remember it well, I also kept my mouth shut as far as possible flights of
fancy involving virtual filesystems and other metamagical wondery floated
around in the crack pipe induced haze.  To be sure, there were some sensible
suggestions put forth also, but that wasn't one of them.

> Fencing needs to talk to all sorts of nasty devices, something really
> well handled by user-space and some expect scripts.

If fencing itself can deadlock, it does not meet my definition of "well
handled".  Now suppose you have a device that really does require more code
than anyone in good conscience would write in a kernel module, or that
device absolutely must be fenced by a combination of bash and perl for some
unfathomable reason.  Then (copying from an earlier post) your options are:

   1) A kernel fencing method sends messages to a dedicated fencing node
   that does not mount the filesystem.  This may waste a node and needs some
   additional mechanism to avoid becoming a single point of failure.

   2) A kernel fencing method sends messages to a userspace program written
   in C, memlocked, and running in (slight kernel hack here) PF_MEMALLOC mode.
   This might require a little more work than a Perl script, but then real men
   enjoy work.

   3) A kernel fencing method sends messages to a userspace program running
   in a resource sandbox (e.g. UML or XEN) that does whatever it wants to.
   This is really buzzword compatible, really wasteful, and a great use of
   administration time.

And using the fencing harness I described we can write one generic kernel
module that is parameterized so that it can invoke any possible userspace
fencing method.  See how hard I work for you?  Sometimes it seems this
effort just goes unappreciated.

>>Anyway, I erred in not mentioning above that only a small core of each
>>service has to stay in kernel or otherwise implement memory deadlock
>>avoidance measures.  Most of the bulky code can indeed go to userspace
>>without any special measures, just not anything that has to execute
>>in the block write path.
> 
> That much is true, but aren't the things which provide (policy) input to
> the block write path also crucial? What does it help you that, in
> theory, you could fence, but never reach that conclusion?

How much policy is involved in "missed X heartbeats => fence it"?  I see
exactly two policy inflection points: the value of X and the period of a
heartbeat.  These are both to be supplied as parameters from user space
at node bringup time.  To be fair I haven't described the heartbeat harness
yet.  But it will look a lot like the fencing harness, including having
pluggable heartbeat methods, so you can easily plug in your userspace
heartbeat instead of kernel heartbeat if you want to.

>>So yes, I intend to place all of the above in kernel space.  OCFS2 has
>>them there now anyway, though not in a sufficiently general form.  I
>>promise that by the time I am done OCFS2's kernel cluster stack code
>>will be significantly smaller and more general at the same time, and
>>you will be able to do all the fancy things you're doing now, except
>>drive those essential services from user space.
> 
> The problem is your intent is to keep membership and heartbeating and
> quorum computation within the kernel. I don't think that's a good idea.
> They can be readily performed in user-space, and even quite protected
> against memory deadlocks. Same for fencing. Except for the bits which
> require in-kernel memory from user-space, but as you say, they can be
> protected with PF_MEMALLOC.

I will buy your argument if the required kernel code is more than a few
hundred lines, otherwise I don't agree, it's more important to be obviously
correct.

> However, the more processes we gain digging into PF_MEMALLOC means this
> reserve becomes more precious too, and they can interfere with
> eachother, if they all need their memory at the same time.

Fortunately I anticipated that.  You will see in the anti memory deadlock
patches I posted this summer there is a mechanism for resizing the
PF_MEMALLOC reserve as necessary, suitable for use at module init and exit
time.

> (I thought the idea of per-process-mempools has been discussed in the
> past, but was met with lots of "You do it!" remarks.)

I considered using mempools for this but I didn't like the way the code got
ugly fast.  Using the PF_MEMALLOC reserve has the nice feature that it just
works for userspace, provided the userspace code is properly throttled of
course.

> Another key point to keep in mind is that, looking at the larger
> picture, too many things _already_ have been moved out of the kernel
> (and are unlikely to go back) to make it feasible to solve the problem
> only there. 

I think I know what you're talking about, you think that there will be no
nice interface from the kernel cluster components to userspace.  Rest
assured that there will be one of those and it will be a nice one, and
simple too.  Furthermore, because you have that pluggable harness, you can
just invent your own and plug it in.

> Think MPIO, which is driven via sysfs and other things with a user-space
> daemon; if you're under memory pressure, the system won't be able to
> recover the paths to your cluster filesystem, what good does it do you
> that your CFS fencing works? How about iscsi?

I am not going to lose a whole lot of sleep over MPIO wankery.  If you need
it, plug it in.  Maybe one day we will get around to re-engineering it so
it works properly.

>>If you think you can solve the problem accurately with less kernel
>>code then please please show me how, but don't forget that _all_
>>fencing code that can execute in the block write path must obey the
>>memory deadlock rules.
> 
> Well, the heartbeat fencing modules ain't called from the block write
> path; after we've fenced a node, we signal this to the kernel (by
> cleaning up the links to it in OCFS2's configfs directory).
> 
> Now of course, if we're deadlocked, we might never get that far. Sigh.
> Life sucks.

Exactly.  I never said "called from", I said "executes in the path of".
Fencing executes in path of block IO in the sense that if the fencing
doesn't happen then the block IO can't continue, therefore fencing needs
to obey anti memory deadlock rules.  Simple.

>>>It's not as much of a problem if you're not trying to run / on a CFS,
>>>though, or if at least you have local swap (to which, in theory, you
>>>could swap out writes ultimately destined for the CFS). And, of course,
>>>if one node deadlocks on memory inversion, the others are going to fence
>>>it from the outside.
>>
>>As with pregnancy, there is no such thing as a little bit deadlocked.
>>You can hit the memory deadlock even on a non-root partition.  All you
>>have to do is write to it, swapping will trigger it more easily but
>>writing can still trigger it.
> 
> 
> Ah, you didn't read what I wrote. Read again. When we can free up memory
> for our "dirty" user-space stack by pushing out writes destined to the
> CFS to the local swap, so we can fence etc and all that. That's an idea
> I've been toying around with lately.
> 
> Of course, when we're out of virtual memory too, that won't work
> either.

I was going to mention that.

> But, I remain convinced that what we need is a general solution for the
> user-space side, because we're so badly dependend on it already, instead
> of trying to hold together the dam inside the kernel ;-)

Your solution needs to be obviously non-deadlocking.  It is considerably
easier to do that analysis in kernel space.  It is _possible_ to do it
in user space but in the end what do you get?  A more fragile, complex
solution with the speedy interfaces on the wrong side of the kernel
boundary and more kernel glue than you saved by taking the critical bits
out of the kernel.  But suit yourself, art is in the eye of the beholder.

Note that I do plan a nice, tight little interface to userspace methods,
which I promise will be able to interface with little effort to the work
you described above.  I am pretty sure your code will get smaller too, or
it would if you didn't need to keep the old cruft around to support
prehistoric kernels.  So if the kernel gets smaller and userspace gets
smaller and it all gets faster and more obviously correct, What is the
problem again?

Regards,

Daniel
