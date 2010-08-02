From: Jan Kara <jack@suse.cz>
Date: Mon,  2 Aug 2010 15:04:35 +0200
Subject: [Ocfs2-devel] [PATCH 1/2 v2] ocfs2: Flush drive's caches on
	fdatasync
Message-ID: <1280754276-6741-1-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

We have to issue a cache flush during fdatasync even if inode doesn't have
I_DIRTY_DATASYNC set because we still have to get written *data* to disk to
observe fdatasync() guarantees.

Acked-by: Tao Ma <tao.ma@oracle.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ocfs2/file.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

  Joel, would you merge this and the following patch please? Thanks.

								Honza

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 2b10b36..3ed8efd 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -36,6 +36,7 @@
 #include <linux/writeback.h>
 #include <linux/falloc.h>
 #include <linux/quotaops.h>
+#include <linux/blkdev.h>
 
 #define MLOG_MASK_PREFIX ML_INODE
 #include <cluster/masklog.h>
@@ -190,8 +191,16 @@ static int ocfs2_sync_file(struct file *file, int datasync)
 	if (err)
 		goto bail;
 
-	if (datasync && !(inode->i_state & I_DIRTY_DATASYNC))
+	if (datasync && !(inode->i_state & I_DIRTY_DATASYNC)) {
+		/*
+		 * We still have to flush drive's caches to get data to the
+		 * platter
+		 */
+		if (osb->s_mount_opt & OCFS2_MOUNT_BARRIER)
+			blkdev_issue_flush(inode->i_sb->s_bdev, GFP_KERNEL,
+					   NULL, BLKDEV_IFL_WAIT);
 		goto bail;
+	}
 
 	journal = osb->journal->j_journal;
 	err = jbd2_journal_force_commit(journal);
-- 
1.6.4.2
