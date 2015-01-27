From: alex chen <alex.chen@huawei.com>
Date: Tue, 27 Jan 2015 11:03:27 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: prune the dcache before deleting the
	dentry of directory
Message-ID: <54C6FFFF.4070903@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In ocfs2_dentry_convert_worker, we should prune the dcache before
deleting the dentry of directory, otherwise, in the following cases the
inode of directory will still remain in orphan directory until the
device being umounted.

Mount point: /mnt/ocfs2
Node A                              Node B
mkdir /mnt/ocfs2/testdir
  ocfs2_mkdir
  ->ocfs2_mknod
  ->ocfs2_dentry_attach_lock
  ->ocfs2_dentry_lock(dentry, 0)
  ... ...
touch /mnt/ocfs2/testdir/testfile
                                    unlink /mnt/test/testdir/testfile
                                    rmdir /mnt/ocfs2/testdir
                                      ocfs2_unlink
                                      ->ocfs2_remote_dentry_delete
                                      ->ocfs2_dentry_lock(dentry, 1)
                                      ... ...
... ...
ocfs2_downconvert_thread
->ocfs2_unblock_lock
->ocfs2_dentry_convert_worker
->ocfs2_find_local_alias
  ->dget_dlock
->d_delete
Here the dentry can not be
released because the children's
dentry is negative but still exist.
Finally, this inode will still remain
in orphan directory until its children
are destroyed.

So before deleting dentry of directory, we should prune the dcache to
remove unused children of the parent dentry by shrink_dcache_parent().

Signed-off-by: Alex Chen <alex.chen@huawei.com>
Reviewed-by: Joseph Qi <joseph.qi@huawei.com>
Reviewed-by: joyce.xue <xuejiufei@huawei.com>
---
 fs/ocfs2/dlmglue.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 1c423af..11849a4 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -3750,6 +3750,9 @@ static int ocfs2_dentry_convert_worker(struct ocfs2_lock_res *lockres,
 			break;
 		spin_unlock(&dentry_attach_lock);

+		if (S_ISDIR(dl->dl_inode->i_mode))
+			shrink_dcache_parent(dentry);
+
 		mlog(0, "d_delete(%pd);\n", dentry);

 		/*
-- 1.8.4.3
