From: Daniel Phillips <phillips@google.com>
Date: Fri, 10 Mar 2006 02:27:01 -0800
Subject: [Ocfs2-devel] Ocfs2 performance bugs of doom
In-Reply-To: <20060310023305.GB28722@fieldses.org>
References: <4408C2E8.4010600@google.com>
	<20060303233617.51718c8e.akpm@osdl.org>
	<440B9035.1070404@google.com>
	<20060306025800.GA27280@ca-server1.us.oracle.com>
	<440BC1C6.1000606@google.com>
	<20060306195135.GB27280@ca-server1.us.oracle.com>
	<p733bhvgc7f.fsf@verdi.suse.de>
	<20060307045835.GF27280@ca-server1.us.oracle.com>
	<440FCA81.7090608@google.com> <20060310023305.GB28722@fieldses.org>
Message-ID: <44115475.7040804@google.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Mark Fasheh <mark.fasheh@oracle.com>, Andrew Morton <akpm@osdl.org>, Andi Kleen <ak@suse.de>, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org

J. Bruce Fields wrote:
> On Wed, Mar 08, 2006 at 10:26:09PM -0800, Daniel Phillips wrote:
>>A poor distribution as you already noticed[1].
> 
> How did you decide that?

I looked at it and jumped to the wrong conclusion :-)

When I actually simulated it I found that the distribution is in fact
not much different from what I get from rand.  So much for trying to
pin the blame on the hash function.  Next lets try to pin the blame
on vmalloc.  (Spoiler: it's not vmalloc's fault either.)

Regards,

Daniel
