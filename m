From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Sat, 27 Sep 2014 14:52:58 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix null handle in
	ocfs2_write_zero_page
Message-ID: <1411800778-21594-1-git-send-email-junxiao.bi@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

ocfs2_zero_start_ordered_transaction() will return NULL handle
in data writeback mode, this should be checked and bypass journal
ops, or kernel panic will be triggered.

Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Alex Chen <alex.chen@huawei.com>
---
 fs/ocfs2/file.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index c534cb0..682732f 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -833,14 +833,17 @@ static int ocfs2_write_zero_page(struct inode *inode, u64 abs_from,
 	di->i_mtime = di->i_ctime = cpu_to_le64(inode->i_mtime.tv_sec);
 	di->i_ctime_nsec = cpu_to_le32(inode->i_mtime.tv_nsec);
 	di->i_mtime_nsec = di->i_ctime_nsec;
-	ocfs2_journal_dirty(handle, di_bh);
-	ocfs2_update_inode_fsync_trans(handle, inode, 1);
+	if (handle) {
+		ocfs2_journal_dirty(handle, di_bh);
+		ocfs2_update_inode_fsync_trans(handle, inode, 1);
+	}
 
 out_unlock:
 	unlock_page(page);
 	page_cache_release(page);
 out_commit_trans:
-	ocfs2_commit_trans(OCFS2_SB(inode->i_sb), handle);
+	if (handle)
+		ocfs2_commit_trans(OCFS2_SB(inode->i_sb), handle);
 out:
 	return ret;
 }
-- 
1.7.9.5
