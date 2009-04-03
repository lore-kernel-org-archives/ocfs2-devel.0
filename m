From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 03 Apr 2009 19:20:28 -0000
Subject: [Ocfs2-devel] [git patches] Ocfs2 updates for 2.6.30
In-Reply-To: <alpine.LFD.2.00.0904031208490.4015@localhost.localdomain>
References: <20090403184605.GC14571@wotan.suse.de>
	<alpine.LFD.2.00.0904031208490.4015@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0904031214260.4015@localhost.localdomain>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mark Fasheh <mfasheh@suse.com>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>, Andrew Morton <akpm@linux-foundation.org>



On Fri, 3 Apr 2009, Linus Torvalds wrote:
>
> Are they likely? Probably not. But that's not the point. The point is that 
> you barely had time to compile that thing, much less give it any testing.

Gaah. I pulled it anyway. Today, I just can't find it in me to care about 
ocfs2 testing.

But please - keep this in mind. Even if the commit is old, when you rebase 
it, you really do move it into a whole new world order. And yes, it 
_usually_ works just fine. 

But to make sure, please do spend some time after setting up the tree to 
make sure that what I get really is something that you know is what I want 
to get.

		Linus
