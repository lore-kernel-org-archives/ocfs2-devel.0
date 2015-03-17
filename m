From: Joseph Qi <joseph.qi@huawei.com>
Date: Tue, 17 Mar 2015 12:05:20 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: use ENOENT instead of EEXIST when get
 system file fails
Message-ID: <5507A800.4060509@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

When ocfs2_get_system_file_inode fails, it is obscure to set the return
value to -EEXIST. So change it to -ENOENT.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
---
 fs/ocfs2/inode.c | 4 ++--
 fs/ocfs2/namei.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 7ff422d..8773ffa 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -624,7 +624,7 @@ static int ocfs2_remove_inode(struct inode *inode,
 		ocfs2_get_system_file_inode(osb, INODE_ALLOC_SYSTEM_INODE,
 					    le16_to_cpu(di->i_suballoc_slot));
 	if (!inode_alloc_inode) {
-		status = -EEXIST;
+		status = -ENOENT;
 		mlog_errno(status);
 		goto bail;
 	}
@@ -742,7 +742,7 @@ static int ocfs2_wipe_inode(struct inode *inode,
 							       ORPHAN_DIR_SYSTEM_INODE,
 							       orphaned_slot);
 		if (!orphan_dir_inode) {
-			status = -EEXIST;
+			status = -ENOENT;
 			mlog_errno(status);
 			goto bail;
 		}
diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 4983740..09f90cb 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -2808,7 +2808,7 @@ int ocfs2_mv_orphaned_inode_to_new(struct inode *dir,
 						       ORPHAN_DIR_SYSTEM_INODE,
 						       osb->slot_num);
 	if (!orphan_dir_inode) {
-		status = -EEXIST;
+		status = -ENOENT;
 		mlog_errno(status);
 		goto leave;
 	}
-- 
1.8.4.3
