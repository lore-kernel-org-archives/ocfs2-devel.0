From: Daniel Phillips <phillips@google.com>
Date: Mon, 06 Mar 2006 22:56:46 -0800
Subject: [Ocfs2-devel] Ocfs2 performance bugs of doom
In-Reply-To: <20060307045835.GF27280@ca-server1.us.oracle.com>
References: <4408C2E8.4010600@google.com>	<20060303233617.51718c8e.akpm@osdl.org>	<440B9035.1070404@google.com>	<20060306025800.GA27280@ca-server1.us.oracle.com>	<440BC1C6.1000606@google.com>	<20060306195135.GB27280@ca-server1.us.oracle.com>	<p733bhvgc7f.fsf@verdi.suse.de>
	<20060307045835.GF27280@ca-server1.us.oracle.com>
Message-ID: <440D2EAE.3080806@google.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mark Fasheh <mark.fasheh@oracle.com>
Cc: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

Mark Fasheh wrote:
> On Tue, Mar 07, 2006 at 04:34:12AM +0100, Andi Kleen wrote:
> 
>>Did you actually do some statistics how long the hash chains are? 
>>Just increasing hash tables blindly has other bad side effects, like
>>increasing cache misses.
> 
> Yep, the gory details are at:
> 
> http://oss.oracle.com/~mfasheh/lock_distribution.csv
> 
> This measure was taken about 18,000 locks into a kernel untar. The only
> change was that I switched things to only hash the last 18 characters of
> lock resource names.

Eventually you will realize how much those bloated lock resource names cost
in CPU and change them to a binary encoding.

> In short things aren't so bad that a larger hash table wouldn't help. We've
> definitely got some peaks however. Our in-house laboratory of mathematicians
> (read: Bill Irwin) is checking out methods by which we can smooth things out
> a bit more :)

Twould be a shame to invest a lot of effort hashing those horrible strings
before finally realizing the strings themselves should be gotten rid of, and
have to optimize the hash all over again.

Since the hash table won't fit in cache except on the beefiest of machines,
the right hash chain length to aim for is one.  That requires both good a
hash function and big hash table.  A sane resource encoding would also help.

Chestnut for the day: don't get too obsessed about optimizing for the light
load case.  A cluster filesystem is supposed to be a beast of burden.  It
needs big feet.

Regards,

Daniel
