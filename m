From: WeiWei Wang <wangww631@huawei.com>
Date: Sat, 11 Oct 2014 20:31:04 +0800
Subject: [Ocfs2-devel] [PATCH 6/7 v4] ocfs2: do not fallback to buffer I/O
 write if appending
Message-ID: <54392308.5050605@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Now we can do direct io and do not fallback to buffered IO any more
in case of append O_DIRECT write.

Signed-off-by: Weiwei Wang <wangww631@huawei.com>
Reviewed-by: Joseph Qi <joseph.qi@huawei.com>
---
 fs/ocfs2/file.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 964d442..19e372f 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -2110,6 +2110,9 @@ static int ocfs2_prepare_inode_for_write(struct file *file,
 	struct dentry *dentry = file->f_path.dentry;
 	struct inode *inode = dentry->d_inode;
 	loff_t saved_pos = 0, end;
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	int full_coherency = !(osb->s_mount_opt &
+			OCFS2_MOUNT_COHERENCY_BUFFERED);

 	/*
 	 * We start with a read level meta lock and only jump to an ex
@@ -2198,7 +2201,7 @@ static int ocfs2_prepare_inode_for_write(struct file *file,
 		 * one node could wind up truncating another
 		 * nodes writes.
 		 */
-		if (end > i_size_read(inode)) {
+		if (end > i_size_read(inode) && !full_coherency) {
 			*direct_io = 0;
 			break;
 		}
-- 
1.8.4.3
