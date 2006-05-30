From: Daniel Phillips <phillips@google.com>
Date: Tue, 30 May 2006 13:15:19 -0700
Subject: [Ocfs2-devel] [RFC] Fencing harness for OCFS2
In-Reply-To: <447CA02C.30308@suse.com>
References: <44767695.7000203@google.com>
	<20060530193848.GP17040@marowsky-bree.de> <447CA02C.30308@suse.com>
Message-ID: <447CA7D7.4090803@google.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Jeff Mahoney wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Lars Marowsky-Bree wrote:
> 
>>On 2006-05-25T20:31:33, Daniel Phillips <phillips@google.com> wrote:
>>
>>>Goals:
>>>    - Lightweight, kernel based fencing harness
>>>    - Support pluggable fencing methods
>>>    - Pluggable methods take policy out of kernel
>>>    - No reinvented wheels, use kernel modules
>>>    - Also accomodate user space fencing methods
>>>    - Divide work appropriately between kernel and user space
>>>    - Obey memory deadlock prevention rules
>>>    - Obey safe module unload rules
>>>    - Handle multiple clusters per node
>>
>>Sorry we're chiming in so late, but with Jeff's user-space membership
>>patches, we have user-space driven fencing working with heartbeat 2.
> 
> It works, but the "Obey memory deadlock prevention rules" line item is
> still an issue.

As I would expect.  To be sure, I am interested in hooking up Linux-HA
properly to OCFS2, but what we need to do is to place the core of fencing
in the kernel where it is easiest to implement anti-deadlock measures,
then export an API to Linux-HA.  This will be easy with the module-based
API I have proposed, in fact I would be happy to prototype a module to do
it.

But fencing is only part of the story.  The whole list of cluster manager
components that can execute in the block writeout path and therefore need
to obey memory deadlock rules is:

   * Heartbeat
   * Fencing
   * Membership and node status events
   * Service takeover for essential services (including DLM recovery)
   * Node addressing and messaging required for the above

I think that is the whole list, if I have missed anything somebody please
shout.  Each of these components needs to get a treatment similar to what
I have proposed for fencing.  For example, we need a pluggable API for
service takeover, which I am drafting now.  If anybody really doesn't
like my proposal for a fencing harness, please speak up now because the
proposal for service takeover will be very similar.

Regards,

Daniel
