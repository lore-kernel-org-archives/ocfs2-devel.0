From: Nick Piggin <nickpiggin@yahoo.com.au>
Date: Thu, 09 Mar 2006 23:30:32 +1100
Subject: [Ocfs2-devel] Ocfs2 performance bugs of doom
In-Reply-To: <200603090519.37801.ak@suse.de>
References: <4408C2E8.4010600@google.com> <440FCA81.7090608@google.com>
	<440FDC8E.9060907@yahoo.com.au> <200603090519.37801.ak@suse.de>
Message-ID: <44101FE8.9050105@yahoo.com.au>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andi Kleen <ak@suse.de>
Cc: Daniel Phillips <phillips@google.com>, Mark Fasheh <mark.fasheh@oracle.com>, Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

Andi Kleen wrote:
> On Thursday 09 March 2006 08:43, Nick Piggin wrote:
>  
> 
>>Just interested: do the locks have any sort of locality of lookup?
>>If so, then have you tried moving hot (ie. the one you've just found,
>>or newly inserted) hash entries to the head of the hash list?
>>
>>In applications with really good locality you can sometimes get away
>>with small hash tables (10s even 100s of collisions on average) without
>>taking too big a hit this way, because your entries basically get sorted
>>LRU for you.
> 
> 
> LRU hashes have really bad cache behaviour though if that is not the case
> because you possibily need to bounce around the hash heads as DIRTY 
> cache lines instead of keeping them in SHARED state.
> My feeling would be that scalability is more important for this, which would
> discourage this.
> 

That's true, it would have to have very good locality of reference to
be of use. In that case it is not always going to dirty the cachelines
because you now only have to make your hash table size appropriate for
your _working set_ rather than the entire set - if the working set is
small enough and you make your hash say 4 times bigger than it, then
you might expect to often hit the right lock at the head of the list.

The other thing is: if the alternative is a 1MB hash, then that may
result in more capacity cache misses than invalidate misses. Not to
mention TLB misses if it is vmalloced :(

Anyway you're absolutely right -- this is only going to work under
select types of hash loads, so lots of testing would be required.

-- 
SUSE Labs, Novell Inc.
Send instant messages to your online friends http://au.messenger.yahoo.com 
