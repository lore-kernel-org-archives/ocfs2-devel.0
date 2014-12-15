From: akpm at linux-foundation.org <akpm@linux-foundation.org>
Date: Mon, 15 Dec 2014 14:51:26 -0800
Subject: [Ocfs2-devel] [patch 13/15] ocfs2: do not fallback to buffer I/O
 write if appending
Message-ID: <548f65ee.9ijltyt3RWGpfvjy%akpm@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Weiwei Wang <wangww631@huawei.com>
Subject: ocfs2: do not fallback to buffer I/O write if appending

Now we can do direct io and do not fallback to buffered IO any more in
case of append O_DIRECT write.

Signed-off-by: Weiwei Wang <wangww631@huawei.com>
Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/file.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN fs/ocfs2/file.c~ocfs2-do-not-fallback-to-buffer-i-o-write-if-appending fs/ocfs2/file.c
--- a/fs/ocfs2/file.c~ocfs2-do-not-fallback-to-buffer-i-o-write-if-appending
+++ a/fs/ocfs2/file.c
@@ -2116,6 +2116,9 @@ static int ocfs2_prepare_inode_for_write
 	struct dentry *dentry = file->f_path.dentry;
 	struct inode *inode = dentry->d_inode;
 	loff_t saved_pos = 0, end;
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	int full_coherency = !(osb->s_mount_opt &
+		OCFS2_MOUNT_COHERENCY_BUFFERED);
 
 	/*
 	 * We start with a read level meta lock and only jump to an ex
@@ -2204,7 +2207,7 @@ static int ocfs2_prepare_inode_for_write
 		 * one node could wind up truncating another
 		 * nodes writes.
 		 */
-		if (end > i_size_read(inode)) {
+		if (end > i_size_read(inode) && !full_coherency) {
 			*direct_io = 0;
 			break;
 		}
_
