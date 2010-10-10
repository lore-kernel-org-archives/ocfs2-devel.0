From: Joel Becker <Joel.Becker@oracle.com>
Date: Sun, 10 Oct 2010 12:47:04 -0700
Subject: [Ocfs2-devel] [PATCH 2/2] Ocfs2: Handle O_DIRECT writes with
 coherency option.
In-Reply-To: <4CB1C318.5080301@oracle.com>
References: <1286623602-7559-1-git-send-email-tristan.ye@oracle.com>
	<1286623602-7559-2-git-send-email-tristan.ye@oracle.com>
	<20101010105948.GT13876@mail.oracle.com>
	<4CB1C318.5080301@oracle.com>
Message-ID: <20101010194704.GU13876@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Sun, Oct 10, 2010 at 09:43:52PM +0800, Tao Ma wrote:
> ? 2010-10-10 18:59, Joel Becker wrote:
> >On Sat, Oct 09, 2010 at 07:26:42PM +0800, Tristan Ye wrote:
> >	if (direct_io&&  full_coherency) {
> >		/*
> >		 * We need to take and drop the inode lock to force
> >		 * other nodes to drop their caches.  Buffered I/O
> >		 * already does this in write_begin().
> >		 */
> >
> >>+		ret = ocfs2_inode_lock(inode, NULL, 1);
> >>+		if (ret<  0) {
> >>+			mlog_errno(ret);
> >>+			goto out_sems;
> >>+		}
> >>+		
> >>+		/*
> >>+		 * Safe to drop the inode_lock immediately since we're just
> >>+		 * telling other nodes to flush their cache.
> >>+		 */
> >	And you don't need this comment.
> I also have another concern. Do we really need the exclusive lock? I
> think a PR lock should
> let others to flush the cache for us.

	If they already have a PR, they're not going to drop it just
because we take a PR.  They're going to stay at PR and keep their cached
data, which is the right thing for them to do from a performance
standpoint.

Joel

-- 

"There is a country in Europe where multiple-choice tests are
 illegal."
        - Sigfried Hulzer

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
