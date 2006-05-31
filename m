From: Lars Marowsky-Bree <lmb@suse.de>
Date: Thu, 1 Jun 2006 01:03:02 +0200
Subject: [Ocfs2-devel] [RFC] Fencing harness for OCFS2
In-Reply-To: <447DE28F.9090308@google.com>
References: <44767695.7000203@google.com>
	<20060530193848.GP17040@marowsky-bree.de>
	<447CA02C.30308@suse.com> <447CA7D7.4090803@google.com>
	<20060531001925.GQ17040@marowsky-bree.de>
	<447DE28F.9090308@google.com>
Message-ID: <20060531230302.GB4265@marowsky-bree.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 2006-05-31T11:38:07, Daniel Phillips <phillips@google.com> wrote:

> >>As I would expect.  To be sure, I am interested in hooking up Linux-HA
> >>properly to OCFS2, but what we need to do is to place the core of fencing
> >>in the kernel where it is easiest to implement anti-deadlock measures,
> > This is not sufficient, though. The piece making the policy decision to
> > fence also needs to be protected, as you note later:
> That is not quite accurate.  Fencing modules as I define them do not
> encapsulate policy, they provide mechanism through which the cluster
> administrator or user space tools can implement policy.  Policy is
> implemented by plugging in the correct methods and paramaterizing the
> methods.
> 
> So my fencing harness proposal does _not_ put policy in kernel, only
> mechanism.

That is not an accurate interpretation of what I said, or at least, what
I meant to say ;-)

I meant to say that having the fencing alone in the kernel isn't
sufficient; you also need to have the processes which ultimately
conclude that fencing of node(s) $foo is required protected.

> Who is moving away from?  OCFS2 team guys have toyed with the idea but
> hopefully understand why it's a bad idea by now.  If not then maybe I
> need to adjust the violence setting on my larting tool.

It's what's been discussed at all the events I've went to in the last
couple of years, one or two even organized by you, as I recall ;-)

Fencing needs to talk to all sorts of nasty devices, something really
well handled by user-space and some expect scripts.

> Anyway, I erred in not mentioning above that only a small core of each
> service has to stay in kernel or otherwise implement memory deadlock
> avoidance measures.  Most of the bulky code can indeed go to userspace
> without any special measures, just not anything that has to execute
> in the block write path.

That much is true, but aren't the things which provide (policy) input to
the block write path also crucial? What does it help you that, in
theory, you could fence, but never reach that conclusion?

> So yes, I intend to place all of the above in kernel space.  OCFS2 has
> them there now anyway, though not in a sufficiently general form.  I
> promise that by the time I am done OCFS2's kernel cluster stack code
> will be significantly smaller and more general at the same time, and
> you will be able to do all the fancy things you're doing now, except
> drive those essential services from user space.

The problem is your intent is to keep membership and heartbeating and
quorum computation within the kernel. I don't think that's a good idea.
They can be readily performed in user-space, and even quite protected
against memory deadlocks. Same for fencing. Except for the bits which
require in-kernel memory from user-space, but as you say, they can be
protected with PF_MEMALLOC.

However, the more processes we gain digging into PF_MEMALLOC means this
reserve becomes more precious too, and they can interfere with
eachother, if they all need their memory at the same time.

(I thought the idea of per-process-mempools has been discussed in the
past, but was met with lots of "You do it!" remarks.)

Another key point to keep in mind is that, looking at the larger
picture, too many things _already_ have been moved out of the kernel
(and are unlikely to go back) to make it feasible to solve the problem
only there. 

Think MPIO, which is driven via sysfs and other things with a user-space
daemon; if you're under memory pressure, the system won't be able to
recover the paths to your cluster filesystem, what good does it do you
that your CFS fencing works? How about iscsi?

> If you think you can solve the problem accurately with less kernel
> code then please please show me how, but don't forget that _all_
> fencing code that can execute in the block write path must obey the
> memory deadlock rules.

Well, the heartbeat fencing modules ain't called from the block write
path; after we've fenced a node, we signal this to the kernel (by
cleaning up the links to it in OCFS2's configfs directory).

Now of course, if we're deadlocked, we might never get that far. Sigh.
Life sucks.

> To write a userspace daemon capable of executing reliably in the block
> writeout path:
> 
>     1. Preallocate all working memory for the daemon including stack, then
>        memlock everything
> 
>     2. Must not load any libraries, exec any program or script, or
>        otherwise do anything that can't be statically analyzed for bounded
>        memory usage
> 
>     3. Must throttle service traffic so that a static bound can be placed
>        on memory usage (special case of 1.).
> 
>     4. Do all of this not only for nodes actually running services for
>        the cluster filesystem, but also for any cluster filesystem node
>        the service can fail over to.
> 
>     5. Audit all syscalls to ensure no memory is used.  Since this is
>        generally impossible, we need a special hack to run the user
>        space daemon in PF_ALLOC mode (yes this works)

Right, heartbeat does most of that. We've got that down pretty well, I
hope. Non-blocking bounded IPC for our processes, non-blocking logging
(syslog is a bitch!) etc...

> > It's not as much of a problem if you're not trying to run / on a CFS,
> > though, or if at least you have local swap (to which, in theory, you
> > could swap out writes ultimately destined for the CFS). And, of course,
> > if one node deadlocks on memory inversion, the others are going to fence
> > it from the outside.
> As with pregnancy, there is no such thing as a little bit deadlocked.
> You can hit the memory deadlock even on a non-root partition.  All you
> have to do is write to it, swapping will trigger it more easily but
> writing can still trigger it.

Ah, you didn't read what I wrote. Read again. When we can free up memory
for our "dirty" user-space stack by pushing out writes destined to the
CFS to the local swap, so we can fence etc and all that. That's an idea
I've been toying around with lately.

Of course, when we're out of virtual memory too, that won't work
either.

But, I remain convinced that what we need is a general solution for the
user-space side, because we're so badly dependend on it already, instead
of trying to hold together the dam inside the kernel ;-)


Sincerely,
    Lars Marowsky-Br?e

-- 
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX Products GmbH - A Novell Business	 -- Charles Darwin
"Ignorance more frequently begets confidence than does knowledge"
