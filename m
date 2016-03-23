From: akpm at linux-foundation.org <akpm@linux-foundation.org>
Date: Wed, 23 Mar 2016 13:12:17 -0700
Subject: [Ocfs2-devel] [patch 12/25] ocfs2: fix a deadlock issue in
 ocfs2_dio_end_io_write()
Message-ID: <56f2f8a1.WYrg+i2acWyEdmJ5%akpm@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Ryan Ding <ryan.ding@oracle.com>
Subject: ocfs2: fix a deadlock issue in ocfs2_dio_end_io_write()

Should call ocfs2_free_alloc_context() to free meta_ac & data_ac before
calling ocfs2_run_deallocs().  Because ocfs2_run_deallocs() will acquire
the system inode's i_mutex hold by meta_ac.  So try to release the lock
before ocfs2_run_deallocs().

Fixes: af1310367f41 ("ocfs2: fix sparse file & data ordering issue in direct io.")
Signed-off-by: Ryan Ding <ryan.ding@oracle.com>
Acked-by: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <joseph.qi@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/aops.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff -puN fs/ocfs2/aops.c~ocfs2-fix-a-deadlock-issue-in-ocfs2_dio_end_io_write fs/ocfs2/aops.c
--- a/fs/ocfs2/aops.c~ocfs2-fix-a-deadlock-issue-in-ocfs2_dio_end_io_write
+++ a/fs/ocfs2/aops.c
@@ -2341,6 +2341,10 @@ static void ocfs2_dio_end_io_write(struc
 
 	ret = ocfs2_lock_allocators(inode, &et, 0, dwc->dw_zero_count*2,
 				    &data_ac, &meta_ac);
+	if (ret) {
+		mlog_errno(ret);
+		goto unlock;
+	}
 
 	credits = ocfs2_calc_extend_credits(inode->i_sb, &di->id2.i_list);
 
@@ -2380,14 +2384,14 @@ unlock:
 	ocfs2_inode_unlock(inode, 1);
 	brelse(di_bh);
 out:
-	ocfs2_run_deallocs(osb, &dealloc);
-	if (locked)
-		mutex_unlock(&inode->i_mutex);
-	ocfs2_dio_free_write_ctx(inode, dwc);
 	if (data_ac)
 		ocfs2_free_alloc_context(data_ac);
 	if (meta_ac)
 		ocfs2_free_alloc_context(meta_ac);
+	ocfs2_run_deallocs(osb, &dealloc);
+	if (locked)
+		mutex_unlock(&inode->i_mutex);
+	ocfs2_dio_free_write_ctx(inode, dwc);
 }
 
 /*
_
