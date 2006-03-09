From: Andi Kleen <ak@suse.de>
Date: Thu, 9 Mar 2006 05:19:36 +0100
Subject: [Ocfs2-devel] Ocfs2 performance bugs of doom
In-Reply-To: <440FDC8E.9060907@yahoo.com.au>
References: <4408C2E8.4010600@google.com> <440FCA81.7090608@google.com>
	<440FDC8E.9060907@yahoo.com.au>
Message-ID: <200603090519.37801.ak@suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Daniel Phillips <phillips@google.com>, Mark Fasheh <mark.fasheh@oracle.com>, Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

On Thursday 09 March 2006 08:43, Nick Piggin wrote:
 
> Just interested: do the locks have any sort of locality of lookup?
> If so, then have you tried moving hot (ie. the one you've just found,
> or newly inserted) hash entries to the head of the hash list?
> 
> In applications with really good locality you can sometimes get away
> with small hash tables (10s even 100s of collisions on average) without
> taking too big a hit this way, because your entries basically get sorted
> LRU for you.

LRU hashes have really bad cache behaviour though if that is not the case
because you possibily need to bounce around the hash heads as DIRTY 
cache lines instead of keeping them in SHARED state.
My feeling would be that scalability is more important for this, which would
discourage this.

-Andi
