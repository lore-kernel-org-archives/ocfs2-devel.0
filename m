From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Thu, 24 Jul 2014 16:58:00 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix journal commit deadlock
Message-ID: <1406192280-6643-1-git-send-email-junxiao.bi@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

For buffer write, page lock will be got in write_begin and released
in write_end, in ocfs2_write_end_nolock(), before it unlock the page
in ocfs2_free_write_ctxt(), it calls ocfs2_run_deallocs(), this will
ask for the read lock of journal->j_trans_barrier. Holding page lock
and ask for journal->j_trans_barrier breaks the locking order.

This will cause a deadlock with journal commit threads, ocfs2cmt will
get write lock of journal->j_trans_barrier first, then it wakes up
kjournald2 to do the commit work, at last it waits until done. To
commit journal, kjournald2 needs flushing data first, it needs get
the cache page lock.

Since some ocfs2 cluster locks are holding by write process, this
deadlock may hung the whole cluster.

unlock pages before ocfs2_run_deallocs() can fix the locking order,
also put unlock before ocfs2_commit_trans() to make page lock is
unlocked before j_trans_barrier to preserve unlocking order.

Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
Cc: <stable@vger.kernel.org>
Reviewed-by: Wengang Wang <wen.gang.wang@oracle.com>
---
 fs/ocfs2/aops.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 4a231a1..c04183b 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -894,7 +894,7 @@ void ocfs2_unlock_and_free_pages(struct page **pages, int num_pages)
 	}
 }
 
-static void ocfs2_free_write_ctxt(struct ocfs2_write_ctxt *wc)
+static void ocfs2_unlock_pages(struct ocfs2_write_ctxt *wc)
 {
 	int i;
 
@@ -915,7 +915,11 @@ static void ocfs2_free_write_ctxt(struct ocfs2_write_ctxt *wc)
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
 	ocfs2_update_inode_fsync_trans(handle, inode, 1);
 	ocfs2_journal_dirty(handle, wc->w_di_bh);
 
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
-- 
1.7.9.5
