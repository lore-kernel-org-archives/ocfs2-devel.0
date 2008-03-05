From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed Mar  5 11:28:47 2008
Subject: [Ocfs2-devel] Re: [PATCH] Dynamic lockres hash table
In-Reply-To: <20080305184021.GT9349@ca-server1.us.oracle.com>
References: <20080304102448.GB24335@duck.suse.cz> <47CE065F.6080707@oracle.com>
	<20080305184021.GT9349@ca-server1.us.oracle.com>
Message-ID: <20080305192752.GK799@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Mar 05, 2008 at 10:40:21AM -0800, Mark Fasheh wrote:
> On Tue, Mar 04, 2008 at 06:33:03PM -0800, Sunil Mushran wrote:
> > My main problem with a mount option is that it is not dynamic.
> >
> > I was thinking along lines of having a sysfs param that will
> > allow users to dynamically resize the number of pages alloted
> > to the hash. This will definitely require us running tests to see
> > how long it takes to rehash with 500K lockres under the
> > dlm_spinlock.
> 
> I like the idea of being able to change it on the fly, but I'm wondering
> about how useful that ability will be for customers versus just being able
> to set it at mount time.

<snip>

> Please, can we solve this everywhere instead of having some ocfs2 1.4
> specific hack.

[Warning, a long email]

	Sunil and I discussed this a bit yesterday, and our basic
thought was that a mount-time option was a hack.  A customer doesn't
want to have to stop everything and remount to get this to work, they
have a live filesystem with live problems they'd like to alleviate.  In
the short-term world of stopgaps, a mount option works sure, but then we
have to support it for a long time, whereas a default size we don't even
have to tell people about is hidden and changeable.  But either way both
are interim solutions.
	We discussed some approaches of varying complexity.  Sunil
suggested hanging an rbtree off of each hash bucket - if you have long
chains, the lookup is now logN.  But that's complex.  I wondered if
maybe we should just remove the hasn and do a single rbtree.  Sure, for
small amounts of locks you might degrade the best case, but the worst
case is now ameliorated.  Full disclosure: I suspect that a hash+rbtree
will be faster than the full rbtree - the question is whether the
complexity trade-off is worth it.  
	In the end, though, we really need numbers.  It'd be awesome to
get latencies of lookups and be able to know how each scheme handles
10K locks and 500K locks (current hash, larger (32 page?) hash,
hash + rbtree, single rbtree).  We may be surprised.
	Once we have instrumentation of latencies, though, we can just
go ahead and automate it.  We'll probably find that the current hash is
best for 10K locks and a larger hash is best for 500K locks.  So we
could easily have tunables in sysfs for "min_lock_hash_size",
"max_lock_hash_size", and "latency_threshold_to_grow_hash".  Those are
tunables we could live with for a long time.

Joel

-- 

"What do you take me for, an idiot?"  
        - General Charles de Gaulle, when a journalist asked him
          if he was happy.

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
