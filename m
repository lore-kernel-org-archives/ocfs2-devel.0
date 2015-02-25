From: Joseph Qi <joseph.qi@huawei.com>
Date: Wed, 25 Feb 2015 17:30:16 +0800
Subject: [Ocfs2-devel] [PATCH 2/4] ocfs2: no need get dinode bh when zeroing
	extend
Message-ID: <54ED9628.4070606@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Since di_bh won't be used when zeroing extend, set it to NULL.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
---
 fs/ocfs2/aops.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 0c2848a..2a618dd 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -706,7 +706,7 @@ static ssize_t ocfs2_direct_IO_write(struct kiocb *iocb,
 	}

 	if (append_write) {
-		ret = ocfs2_inode_lock(inode, &di_bh, 1);
+		ret = ocfs2_inode_lock(inode, NULL, 1);
 		if (ret < 0) {
 			mlog_errno(ret);
 			goto clean_orphan;
@@ -720,7 +720,6 @@ static ssize_t ocfs2_direct_IO_write(struct kiocb *iocb,
 		if (ret < 0) {
 			mlog_errno(ret);
 			ocfs2_inode_unlock(inode, 1);
-			brelse(di_bh);
 			goto clean_orphan;
 		}

@@ -728,13 +727,10 @@ static ssize_t ocfs2_direct_IO_write(struct kiocb *iocb,
 		if (is_overwrite < 0) {
 			mlog_errno(is_overwrite);
 			ocfs2_inode_unlock(inode, 1);
-			brelse(di_bh);
 			goto clean_orphan;
 		}

 		ocfs2_inode_unlock(inode, 1);
-		brelse(di_bh);
-		di_bh = NULL;
 	}

 	written = __blockdev_direct_IO(WRITE, iocb, inode, inode->i_sb->s_bdev,
-- 
1.8.4.3
