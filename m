From: Andi Kleen <ak@suse.de>
Date: 07 Mar 2006 04:34:12 +0100
Subject: [Ocfs2-devel] Ocfs2 performance bugs of doom
In-Reply-To: <20060306195135.GB27280@ca-server1.us.oracle.com>
References: <4408C2E8.4010600@google.com>
	<20060303233617.51718c8e.akpm@osdl.org> <440B9035.1070404@google.com>
	<20060306025800.GA27280@ca-server1.us.oracle.com>
	<440BC1C6.1000606@google.com>
	<20060306195135.GB27280@ca-server1.us.oracle.com>
Message-ID: <p733bhvgc7f.fsf@verdi.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mark Fasheh <mark.fasheh@oracle.com>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

Mark Fasheh <mark.fasheh@oracle.com> writes:

> On Sun, Mar 05, 2006 at 08:59:50PM -0800, Daniel Phillips wrote:
> > So that hack apparently improves the bucket distribution quite a bit, but
> > look, the bad old linear systime creep is still very obvious.  For that
> > there is no substitute for lots of buckets.
> Yes, I think the way to go right now is to allocate an array of pages and
> index into that. We can make the array size a mount option so that the
> default can be something reasonable ;)

Did you actually do some statistics how long the hash chains are? 
Just increasing hash tables blindly has other bad side effects, like
increasing cache misses.

-Andi
