From: akpm at linux-foundation.org <akpm@linux-foundation.org>
Date: Wed, 04 Feb 2015 16:00:47 -0800
Subject: [Ocfs2-devel] [patch 1/4] ocfs2: prune the dcache before deleting
	the dentry of directory
Message-ID: <54d2b2af.vngP6L5LZDv1pKQH%akpm@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: alex chen <alex.chen@huawei.com>
Subject: ocfs2: prune the dcache before deleting the dentry of directory

In ocfs2_dentry_convert_worker, we should prune the dcache before deleting
the dentry of directory, otherwise, in the following cases the inode of
directory will still remain in orphan directory until the device being
umounted.

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
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlmglue.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN fs/ocfs2/dlmglue.c~ocfs2-prune-the-dcache-before-deleting-the-dentry-of-directory fs/ocfs2/dlmglue.c
--- a/fs/ocfs2/dlmglue.c~ocfs2-prune-the-dcache-before-deleting-the-dentry-of-directory
+++ a/fs/ocfs2/dlmglue.c
@@ -3750,6 +3750,9 @@ static int ocfs2_dentry_convert_worker(s
 			break;
 		spin_unlock(&dentry_attach_lock);
 
+		if (S_ISDIR(dl->dl_inode->i_mode))
+			shrink_dcache_parent(dentry);
+
 		mlog(0, "d_delete(%pd);\n", dentry);
 
 		/*
_
