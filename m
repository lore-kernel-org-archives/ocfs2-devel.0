From: Xue jiufei <xuejiufei@huawei.com>
Date: Wed, 26 Mar 2014 15:23:13 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: __ocfs2_mknod_locked should return
 error when ocfs2_create_new_inode_locks() failed
Message-ID: <53328061.30804@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

When ocfs2_create_new_inode_locks() return error, inode open lock may
not be obtainted for this inode. So other nodes can remove this file
and free dinode when inode still remain in memory on this node,
which is not correct and may trigger BUG. So __ocfs2_mknod_locked
should return error when ocfs2_create_new_inode_locks() failed.

              Node_1                              Node_2
create fileA, call ocfs2_mknod()
  -> ocfs2_get_init_inode(), allocate inodeA
  -> ocfs2_claim_new_inode(), claim dinode(dinodeA)
  -> call ocfs2_create_new_inode_locks(),
     create open lock failed, return error
  -> __ocfs2_mknod_locked return success
            
                                                unlink fileA
                                                try open lock succeed,
                                                and free dinodeA

create another file, call ocfs2_mknod()
  -> ocfs2_get_init_inode(), allocate inodeB
  -> ocfs2_claim_new_inode(), as Node_2 had freed dinodeA,
     so claim dinodeA and update generation for dinodeA

call __ocfs2_drop_dl_inodes()->ocfs2_delete_inode()
to free inodeA, and finally triggers BUG
on(inode->i_generation != le32_to_cpu(fe->i_generation))
in function ocfs2_inode_lock_update().

Signed-off-by: joyce.xue <xuejiufei@huawei.com>
---
 fs/ocfs2/namei.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 3683643..63f9692 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -576,9 +576,6 @@ static int __ocfs2_mknod_locked(struct inode *dir,
 			mlog_errno(status);
 	}
 
-	status = 0; /* error in ocfs2_create_new_inode_locks is not
-		     * critical */
-
 leave:
 	if (status < 0) {
 		if (*new_fe_bh) {
-- 
1.8.4.3
