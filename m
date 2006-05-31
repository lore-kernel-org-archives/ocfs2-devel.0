From: Lars Marowsky-Bree <lmb@suse.de>
Date: Wed, 31 May 2006 02:19:25 +0200
Subject: [Ocfs2-devel] [RFC] Fencing harness for OCFS2
In-Reply-To: <447CA7D7.4090803@google.com>
References: <44767695.7000203@google.com>
	<20060530193848.GP17040@marowsky-bree.de>
	<447CA02C.30308@suse.com> <447CA7D7.4090803@google.com>
Message-ID: <20060531001925.GQ17040@marowsky-bree.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 2006-05-30T13:15:19, Daniel Phillips <phillips@google.com> wrote:

> As I would expect.  To be sure, I am interested in hooking up Linux-HA
> properly to OCFS2, but what we need to do is to place the core of fencing
> in the kernel where it is easiest to implement anti-deadlock measures,

This is not sufficient, though. The piece making the policy decision to
fence also needs to be protected, as you note later:

> then export an API to Linux-HA.  This will be easy with the module-based
> API I have proposed, in fact I would be happy to prototype a module to do
> it.
> 
> But fencing is only part of the story.  The whole list of cluster manager
> components that can execute in the block writeout path and therefore need
> to obey memory deadlock rules is:
> 
>   * Heartbeat
>   * Fencing
>   * Membership and node status events
>   * Service takeover for essential services (including DLM recovery)
>   * Node addressing and messaging required for the above
> 
> I think that is the whole list, if I have missed anything somebody please
> shout.  Each of these components needs to get a treatment similar to what
> I have proposed for fencing.  For example, we need a pluggable API for
> service takeover, which I am drafting now.  If anybody really doesn't
> like my proposal for a fencing harness, please speak up now because the
> proposal for service takeover will be very similar.

You can't really wish to place all of these into kernel space. This is
exactly what we're moving away from.

I've not been very good at following the list. How do you protect
against memory inversion - reliably? It's hard enough _within_ the
kernel.

Many parts of heartbeat do, in fact, take great pains to not cause any
paging etc, yet it's very hard to guarantee this for the entire stack
from low-level networking up to high-level policy decisions.

It's not as much of a problem if you're not trying to run / on a CFS,
though, or if at least you have local swap (to which, in theory, you
could swap out writes ultimately destined for the CFS). And, of course,
if one node deadlocks on memory inversion, the others are going to fence
it from the outside.

I know we've had this discussion for years, but I don't remember _ever_
seeing a solution.


Sincerely,
    Lars Marowsky-Br?e

-- 
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX Products GmbH - A Novell Business	 -- Charles Darwin
"Ignorance more frequently begets confidence than does knowledge"
