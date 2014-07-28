From: Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 28 Jul 2014 16:40:12 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix journal commit deadlock
In-Reply-To: <1406192280-6643-1-git-send-email-junxiao.bi@oracle.com>
References: <1406192280-6643-1-git-send-email-junxiao.bi@oracle.com>
Message-ID: <20140728164012.e4c201a4b8c1512468909eaa@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, 24 Jul 2014 16:58:00 +0800 Junxiao Bi <junxiao.bi@oracle.com> wrote:

> For buffer write, page lock will be got in write_begin and released
> in write_end, in ocfs2_write_end_nolock(), before it unlock the page
> in ocfs2_free_write_ctxt(), it calls ocfs2_run_deallocs(), this will
> ask for the read lock of journal->j_trans_barrier. Holding page lock
> and ask for journal->j_trans_barrier breaks the locking order.
> 
> This will cause a deadlock with journal commit threads, ocfs2cmt will
> get write lock of journal->j_trans_barrier first, then it wakes up
> kjournald2 to do the commit work, at last it waits until done. To
> commit journal, kjournald2 needs flushing data first, it needs get
> the cache page lock.
> 
> Since some ocfs2 cluster locks are holding by write process, this
> deadlock may hung the whole cluster.
> 
> unlock pages before ocfs2_run_deallocs() can fix the locking order,
> also put unlock before ocfs2_commit_trans() to make page lock is
> unlocked before j_trans_barrier to preserve unlocking order.

This conflicts with
http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-call-ocfs2_journal_access_di-before-ocfs2_journal_dirty-in-ocfs2_write_end_nolock.patch
in ways which I am not confident in resolving.  Could you please redo
the patch against linux-next and retest?
