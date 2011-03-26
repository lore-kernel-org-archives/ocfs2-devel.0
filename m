From: Joel Becker <jlbec@evilplan.org>
Date: Sat, 26 Mar 2011 15:48:10 -0700
Subject: [Ocfs2-devel] [PATCH] Treat writes as new when holes span
 across page boundaries
In-Reply-To: <AANLkTi=pEu5y4=kjG1YoLR+YCd7Ak21QaFQz=AR3dffX@mail.gmail.com>
References: <AANLkTi=pEu5y4=kjG1YoLR+YCd7Ak21QaFQz=AR3dffX@mail.gmail.com>
Message-ID: <20110326224810.GC8837@noexit>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Feb 17, 2011 at 09:44:40AM -0600, Goldwyn Rodrigues wrote:
> When a hole spans across page boundaries, the next write forces
> a read of the block. This could end up reading existing garbage
> data from the disk in ocfs2_map_page_blocks. This leads to
> non-zero holes. In order to avoid this, mark the writes as new
> when the holes span across page boundaries.
> 
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.de>

This patch is now part of the merge-window branch of ocfs2.git.

I'm still not sure this is the final fix.  I worry that it papers over
our expectations of our new block/page/cluster code.  But we have more
than report of the problem, and this seems to alleviate those reports.
I can't see any way it breaks existing operation.  So I think it should
go in while we later revisit whether it is the end of the discussion.

Joel

-- 

"Behind every successful man there's a lot of unsuccessful years."
        - Bob Brown

			http://www.jlbec.org/
			jlbec at evilplan.org
