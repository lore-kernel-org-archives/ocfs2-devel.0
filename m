From: Joseph Qi <joseph.qi@huawei.com>
Date: Wed, 3 Dec 2014 15:23:30 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix brelse warning if
	ocfs2_direct_IO_get_blocks failed
Message-ID: <547EBA72.3000900@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In ocfs2_direct_IO_write, if ocfs2_direct_IO_get_blocks failed, the
di_bh will be used again in unlikely branch, and this will hit a warning
"VFS: brelse: Trying to free free buffer" when jbd2 do checkpoint.
Fix this issue by setting di_bh to NULL after brelse.

Reported-by: alex chen <alex.chen@huawei.com>
Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Reviewed-by: joyce.xue <xuejiufei@huawei.com>
---
 fs/ocfs2/aops.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 38e5a9f..cf4be6a 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -731,6 +731,7 @@ static ssize_t ocfs2_direct_IO_write(struct kiocb *iocb,

 		ocfs2_inode_unlock(inode, 1);
 		brelse(di_bh);
+		di_bh = NULL;
 	}

 	written = __blockdev_direct_IO(WRITE, iocb, inode, inode->i_sb->s_bdev,
-- 
1.8.4.3
