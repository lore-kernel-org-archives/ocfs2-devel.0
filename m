From: Mark Fasheh <mfasheh@suse.com>
Date: Fri, 19 Mar 2010 14:35:31 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: Make ocfs2_journal_dirty() void.
In-Reply-To: <20100319211747.GB15539@mail.oracle.com>
References: <20100319211747.GB15539@mail.oracle.com>
Message-ID: <20100319213531.GG11402@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Mar 19, 2010 at 02:17:47PM -0700, Joel Becker wrote:
> jbd[2]_journal_dirty_metadata() only returns 0.  It's been returning 0
> since before the kernel moved to git.  There is no point in checking
> this error.
> 
> ocfs2_journal_dirty() has been faithfully returning the status since the
> beginning.  All over ocfs2, we have blocks of code checking this can't
> fail status.  In the past few years, we've tried to avoid adding these
> checks, because they are pointless.  But anyone who looks at our code
> assumes they are needed.
> 
> Finally, ocfs2_journal_dirty() is made a void function.  All error
> checking is removed from other files.  We'll BUG_ON() the status of
> jbd2_journal_dirty_metadata() just in case they change it someday.  They
> won't.
> 
> Signed-off-by: Joel Becker <joel.becker@oracle.com>
> ---
>  fs/ocfs2/alloc.c        |  162 ++++++++++-------------------------------------
>  fs/ocfs2/dir.c          |   48 +++-----------
>  fs/ocfs2/file.c         |   19 +-----
>  fs/ocfs2/inode.c        |   14 +----
>  fs/ocfs2/journal.c      |   11 +---
>  fs/ocfs2/journal.h      |    3 +-
>  fs/ocfs2/localalloc.c   |   23 +------
>  fs/ocfs2/namei.c        |   62 +++---------------
>  fs/ocfs2/quota_global.c |    4 +-
>  fs/ocfs2/quota_local.c  |   50 ++++-----------
>  fs/ocfs2/refcounttree.c |   20 +-----
>  fs/ocfs2/resize.c       |   13 +---
>  fs/ocfs2/suballoc.c     |   64 +++----------------
>  fs/ocfs2/xattr.c        |   38 ++---------
>  14 files changed, 101 insertions(+), 430 deletions(-)

Nice diffstat  ;)

Acked-by: Mark Fasheh <mfasheh@suse.com>
	--A-Happy-Mark

--
Mark Fasheh
