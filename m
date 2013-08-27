From: akpm at linux-foundation.org <akpm@linux-foundation.org>
Date: Tue, 27 Aug 2013 14:05:16 -0700
Subject: [Ocfs2-devel] [patch 22/22] ocfs2: remove unused variable ip in
	dlmfs_get_root_inode()
Message-ID: <20130827210516.E4DC95A4276@corp2gmr1-2.hot.corp.google.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Joseph Qi <joseph.qi@huawei.com>
Subject: ocfs2: remove unused variable ip in dlmfs_get_root_inode()

Variable ip in dlmfs_get_root_inode() is defined but not used.  So clean
it up.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlmfs/dlmfs.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN fs/ocfs2/dlmfs/dlmfs.c~ocfs2-cleanup-unused-variable-ip-in-dlmfs_get_root_inode fs/ocfs2/dlmfs/dlmfs.c
--- a/fs/ocfs2/dlmfs/dlmfs.c~ocfs2-cleanup-unused-variable-ip-in-dlmfs_get_root_inode
+++ a/fs/ocfs2/dlmfs/dlmfs.c
@@ -401,11 +401,8 @@ static struct inode *dlmfs_get_root_inod
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
_
