From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Wed Mar  5 12:39:04 2008
Subject: [Ocfs2-devel] Re: [PATCH] Dynamic lockres hash table
In-Reply-To: <20080305192752.GK799@ca-server1.us.oracle.com>
References: <20080304102448.GB24335@duck.suse.cz> <47CE065F.6080707@oracle.com>
	<20080305184021.GT9349@ca-server1.us.oracle.com>
	<20080305192752.GK799@ca-server1.us.oracle.com>
Message-ID: <20080305203837.GU9349@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Mar 05, 2008 at 11:27:53AM -0800, Joel Becker wrote:
> On Wed, Mar 05, 2008 at 10:40:21AM -0800, Mark Fasheh wrote:
> > On Tue, Mar 04, 2008 at 06:33:03PM -0800, Sunil Mushran wrote:
> > > My main problem with a mount option is that it is not dynamic.
> > >
> > > I was thinking along lines of having a sysfs param that will
> > > allow users to dynamically resize the number of pages alloted
> > > to the hash. This will definitely require us running tests to see
> > > how long it takes to rehash with 500K lockres under the
> > > dlm_spinlock.
> > 
> > I like the idea of being able to change it on the fly, but I'm wondering
> > about how useful that ability will be for customers versus just being able
> > to set it at mount time.
> 
> <snip>
> 
> > Please, can we solve this everywhere instead of having some ocfs2 1.4
> > specific hack.
> 
> [Warning, a long email]
> 
> 	Sunil and I discussed this a bit yesterday, and our basic
> thought was that a mount-time option was a hack.  A customer doesn't
> want to have to stop everything and remount to get this to work,

If the dlm supports dynamic resizing, neither approach requires the user to
"stop everything". "mount -oremount" is just as unobtrusive to the running
file system as echoing to a sysfs file.

Btw, if this is the direction we all want to go, can I revert the
"localalloc=" mount option patches before 2.6.25 gets released? It strikes
me as similarly hacky (seriously) and we already have a plan for dynamic
local alloc sizing.


> they have a live filesystem with live problems they'd like to alleviate.

Can you be more specific? How often do we think people will expect to change
this on a live file system? What sort of situations have we run into, or
expect to run into where the user needs to change the hash size, and can't
do it without unmounting the file system first, couldn't have reasonably
anticipiated a hash size to begin with, or a dynamically picked default
might fail?

Btw, just so we're all clear - any hash sizing scheme would pretty much
involve information known only to the local node. So we're not talking about
offlining the cluster here - just unmounting a node.


> In the short-term world of stopgaps, a mount option works sure, but then
> we have to support it for a long time, whereas a default size we don't
> even have to tell people about is hidden and changeable. But either way
> both are interim solutions.

In the sense of supporting "ABI", a sysfs file and a mount option are
equally inflexible - look at the business with /sys/o2cb as an example. Once
it's "published", we'll have a hard time taking it away from folks.


> 	We discussed some approaches of varying complexity.  Sunil
> suggested hanging an rbtree off of each hash bucket - if you have long
> chains, the lookup is now logN.  But that's complex.  I wondered if
> maybe we should just remove the hasn and do a single rbtree.  Sure, for
> small amounts of locks you might degrade the best case, but the worst
> case is now ameliorated.  Full disclosure: I suspect that a hash+rbtree
> will be faster than the full rbtree - the question is whether the
> complexity trade-off is worth it.  
> 	In the end, though, we really need numbers.  It'd be awesome to
> get latencies of lookups and be able to know how each scheme handles
> 10K locks and 500K locks (current hash, larger (32 page?) hash,
> hash + rbtree, single rbtree).  We may be surprised.
> 	Once we have instrumentation of latencies, though, we can just
> go ahead and automate it.  We'll probably find that the current hash is
> best for 10K locks and a larger hash is best for 500K locks.  So we
> could easily have tunables in sysfs for "min_lock_hash_size",
> "max_lock_hash_size", and "latency_threshold_to_grow_hash".  Those are
> tunables we could live with for a long time.

Ok, ignoring how it's done and who does it, I completely agree that it'd be
neat for the dlm to respond automatically to demand. There's a question in
my mind of how much of our time such a feature is worth though, and honestly
- when we'd actually get around to doing it. o2dlm is a pretty known
quantity at this point, and our direction has moved more towards fsdlm.


Hmm, maybe this would be a nice patch to give them :) They're actually worse
off with respect to hash sizing than any of what we've discussed now -
there's a global sysfs file which governs the default for lockspaces.


To recap, and make sure we're on the same page - AFAICT, the questions being
raised are:

1) Should the default dlm hash size be updated somehow?

2) Should the user be allowed to change the (default?) hash size?
  - If so, how would the user change this?

3) Should the dlm be changed to allow dynamic resizing of the hash?
  - Should it resize automatically depending on workload, or should the user
    initiate such resizing via whichever method is picked in (2)?


Make sense?
	--Mark

--
Mark Fasheh
Principal Software Developer, Oracle
mark.fasheh@oracle.com
