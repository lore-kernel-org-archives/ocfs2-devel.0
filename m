From: akpm at linux-foundation.org <akpm@linux-foundation.org>
Date: Mon, 15 Dec 2014 14:51:09 -0800
Subject: [Ocfs2-devel] [patch 07/15] ocfs2: fix journal commit deadlock
Message-ID: <548f65dd.p6iIKNzwu5PVSHMt%akpm@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Junxiao Bi <junxiao.bi@oracle.com>
Subject: ocfs2: fix journal commit deadlock

For buffer write, page lock will be got in write_begin and released in
write_end, in ocfs2_write_end_nolock(), before it unlock the page in
ocfs2_free_write_ctxt(), it calls ocfs2_run_deallocs(), this will ask for
the read lock of journal->j_trans_barrier.  Holding page lock and ask for
journal->j_trans_barrier breaks the locking order.

This will cause a deadlock with journal commit threads, ocfs2cmt will get
write lock of journal->j_trans_barrier first, then it wakes up kjournald2
to do the commit work, at last it waits until done.  To commit journal,
kjournald2 needs flushing data first, it needs get the cache page lock.

Since some ocfs2 cluster locks are holding by write process, this
deadlock may hung the whole cluster.

unlock pages before ocfs2_run_deallocs() can fix the locking order, also
put unlock before ocfs2_commit_trans() to make page lock is unlocked
before j_trans_barrier to preserve unlocking order.

Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
Reviewed-by: Wengang Wang <wen.gang.wang@oracle.com>
Cc: <stable@vger.kernel.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/aops.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff -puN fs/ocfs2/aops.c~ocfs2-fix-journal-commit-deadlock fs/ocfs2/aops.c
--- a/fs/ocfs2/aops.c~ocfs2-fix-journal-commit-deadlock
+++ a/fs/ocfs2/aops.c
@@ -894,7 +894,7 @@ void ocfs2_unlock_and_free_pages(struct
 	}
 }
 
-static void ocfs2_free_write_ctxt(struct ocfs2_write_ctxt *wc)
+static void ocfs2_unlock_pages(struct ocfs2_write_ctxt *wc)
 {
 	int i;
 
@@ -915,7 +915,11 @@ static void ocfs2_free_write_ctxt(struct
 		page_cache_release(wc->w_target_page);
 	}
 	ocfs2_unlock_and_free_pages(wc->w_pages, wc->w_num_pages);
+}
 
+static void ocfs2_free_write_ctxt(struct ocfs2_write_ctxt *wc)
+{
+	ocfs2_unlock_pages(wc);
 	brelse(wc->w_di_bh);
 	kfree(wc);
 }
@@ -2041,11 +2045,19 @@ out_write_size:
 	ocfs2_journal_dirty(handle, wc->w_di_bh);
 
 out:
+	/* unlock pages before dealloc since it needs acquiring j_trans_barrier
+	 * lock, or it will cause a deadlock since journal commit threads holds
+	 * this lock and will ask for the page lock when flushing the data.
+	 * put it here to preserve the unlock order.
+	 */
+	ocfs2_unlock_pages(wc);
+
 	ocfs2_commit_trans(osb, handle);
 
 	ocfs2_run_deallocs(osb, &wc->w_dealloc);
 
-	ocfs2_free_write_ctxt(wc);
+	brelse(wc->w_di_bh);
+	kfree(wc);
 
 	return copied;
 }
_
