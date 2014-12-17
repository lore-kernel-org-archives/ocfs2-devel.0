From: Mark Fasheh <mfasheh@suse.de>
Date: Wed, 17 Dec 2014 13:01:07 -0800
Subject: [Ocfs2-devel] [patch 07/15] ocfs2: fix journal commit deadlock
In-Reply-To: <548f65dd.p6iIKNzwu5PVSHMt%akpm@linux-foundation.org>
References: <548f65dd.p6iIKNzwu5PVSHMt%akpm@linux-foundation.org>
Message-ID: <20141217210107.GR7238@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Dec 15, 2014 at 02:51:09PM -0800, Andrew Morton wrote:
> From: Junxiao Bi <junxiao.bi@oracle.com>
> Subject: ocfs2: fix journal commit deadlock
> 
> For buffer write, page lock will be got in write_begin and released in
> write_end, in ocfs2_write_end_nolock(), before it unlock the page in
> ocfs2_free_write_ctxt(), it calls ocfs2_run_deallocs(), this will ask for
> the read lock of journal->j_trans_barrier.  Holding page lock and ask for
> journal->j_trans_barrier breaks the locking order.
> 
> This will cause a deadlock with journal commit threads, ocfs2cmt will get
> write lock of journal->j_trans_barrier first, then it wakes up kjournald2
> to do the commit work, at last it waits until done.  To commit journal,
> kjournald2 needs flushing data first, it needs get the cache page lock.
> 
> Since some ocfs2 cluster locks are holding by write process, this
> deadlock may hung the whole cluster.
> 
> unlock pages before ocfs2_run_deallocs() can fix the locking order, also
> put unlock before ocfs2_commit_trans() to make page lock is unlocked
> before j_trans_barrier to preserve unlocking order.
> 
> Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
> Reviewed-by: Wengang Wang <wen.gang.wang@oracle.com>
> Cc: <stable@vger.kernel.org>
> Cc: Mark Fasheh <mfasheh@suse.com>
> Cc: Joel Becker <jlbec@evilplan.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Reviewed-by: Mark Fasheh <mfasheh@suse.de>
	--Mark

--
Mark Fasheh
