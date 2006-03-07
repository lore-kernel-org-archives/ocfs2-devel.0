From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Mon, 6 Mar 2006 20:58:35 -0800
Subject: [Ocfs2-devel] Ocfs2 performance bugs of doom
In-Reply-To: <p733bhvgc7f.fsf@verdi.suse.de>
References: <4408C2E8.4010600@google.com>
	<20060303233617.51718c8e.akpm@osdl.org>
	<440B9035.1070404@google.com>
	<20060306025800.GA27280@ca-server1.us.oracle.com>
	<440BC1C6.1000606@google.com>
	<20060306195135.GB27280@ca-server1.us.oracle.com>
	<p733bhvgc7f.fsf@verdi.suse.de>
Message-ID: <20060307045835.GF27280@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

On Tue, Mar 07, 2006 at 04:34:12AM +0100, Andi Kleen wrote:
> Did you actually do some statistics how long the hash chains are? 
> Just increasing hash tables blindly has other bad side effects, like
> increasing cache misses.
Yep, the gory details are at:

http://oss.oracle.com/~mfasheh/lock_distribution.csv

This measure was taken about 18,000 locks into a kernel untar. The only
change was that I switched things to only hash the last 18 characters of
lock resource names.

In short things aren't so bad that a larger hash table wouldn't help. We've
definitely got some peaks however. Our in-house laboratory of mathematicians
(read: Bill Irwin) is checking out methods by which we can smooth things out
a bit more :)
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh at oracle.com
