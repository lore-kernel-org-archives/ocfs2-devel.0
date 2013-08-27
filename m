From: Joseph Qi <joseph.qi@huawei.com>
Date: Tue, 27 Aug 2013 15:06:10 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: cleanup unused variable ip in
	dlmfs_get_root_inode()
Message-ID: <521C4FE2.4080009@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Variable ip in dlmfs_get_root_inode() is defined but not used.
So clean it up.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
---
 fs/ocfs2/dlmfs/dlmfs.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/ocfs2/dlmfs/dlmfs.c b/fs/ocfs2/dlmfs/dlmfs.c
index 12bafb7..efa2b3d 100644
--- a/fs/ocfs2/dlmfs/dlmfs.c
+++ b/fs/ocfs2/dlmfs/dlmfs.c
@@ -401,11 +401,8 @@ static struct inode *dlmfs_get_root_inode(struct super_block *sb)
 {
 	struct inode *inode = new_inode(sb);
 	umode_t mode = S_IFDIR | 0755;
-	struct dlmfs_inode_private *ip;
 
 	if (inode) {
-		ip = DLMFS_I(inode);
-
 		inode->i_ino = get_next_ino();
 		inode_init_owner(inode, NULL, mode);
 		inode->i_mapping->backing_dev_info = &dlmfs_backing_dev_info;
-- 
1.7.9.7
