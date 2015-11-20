From: Ryan Ding <ryan.ding@oracle.com>
Date: Fri, 20 Nov 2015 16:23:19 +0800
Subject: [Ocfs2-devel] [PATCH 4/4] ocfs2: Fix a deadlock issue in
	ocfs2_dio_end_io_write()
In-Reply-To: <1448007799-10914-1-git-send-email-ryan.ding@oracle.com>
References: <1448007799-10914-1-git-send-email-ryan.ding@oracle.com>
Message-ID: <1448007799-10914-4-git-send-email-ryan.ding@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Should call ocfs2_free_alloc_context() to free meta_ac & data_ac before calling
ocfs2_run_deallocs(). Because ocfs2_run_deallocs() will acquire the system
inode's i_mutex hold by meta_ac. So try to release the lock before
ocfs2_run_deallocs().

Fixes: af1310367f41 ("ocfs2: fix sparse file & data ordering issue in direct io.")
Signed-off-by: Ryan Ding <ryan.ding@oracle.com>
---
 fs/ocfs2/aops.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index f33cfe4..182f754 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -2341,6 +2341,10 @@ static void ocfs2_dio_end_io_write(struct inode *inode,
 
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
-- 
1.7.1
