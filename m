From: Nick Piggin <nickpiggin@yahoo.com.au>
Date: Thu, 09 Mar 2006 18:43:10 +1100
Subject: [Ocfs2-devel] Ocfs2 performance bugs of doom
In-Reply-To: <440FCA81.7090608@google.com>
References: <4408C2E8.4010600@google.com>	<20060303233617.51718c8e.akpm@osdl.org>	<440B9035.1070404@google.com>	<20060306025800.GA27280@ca-server1.us.oracle.com>	<440BC1C6.1000606@google.com>	<20060306195135.GB27280@ca-server1.us.oracle.com>	<p733bhvgc7f.fsf@verdi.suse.de>
	<20060307045835.GF27280@ca-server1.us.oracle.com>
	<440FCA81.7090608@google.com>
Message-ID: <440FDC8E.9060907@yahoo.com.au>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daniel Phillips <phillips@google.com>
Cc: Mark Fasheh <mark.fasheh@oracle.com>, Andi Kleen <ak@suse.de>, Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

Daniel Phillips wrote:

> A poor distribution as you already noticed[1].  Even if it was a great
> distribution, we would still average a little over two nodes per bucket
> twice as many as we should allow unless you believe that people running
> cluster filesystems have too much time on their hands and need to waste
> some of it waiting for the computer to chew its way through millions
> of cold cache lines.
> 

Just interested: do the locks have any sort of locality of lookup?
If so, then have you tried moving hot (ie. the one you've just found,
or newly inserted) hash entries to the head of the hash list?

In applications with really good locality you can sometimes get away
with small hash tables (10s even 100s of collisions on average) without
taking too big a hit this way, because your entries basically get sorted
LRU for you.

-- 
SUSE Labs, Novell Inc.
Send instant messages to your online friends http://au.messenger.yahoo.com 
