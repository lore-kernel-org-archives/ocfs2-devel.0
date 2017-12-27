From: piaojun <piaojun@huawei.com>
Date: Wed, 27 Dec 2017 10:18:34 +0800
Subject: [Ocfs2-devel] [PATCH v3] ocfs2: return -EROFS to mount.ocfs2 if
 inode block is invalid
Message-ID: <5A4302FA.2010606@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

If metadata is corrupted such as 'invalid inode block', we will get
failed by calling 'mount()' and then set filesystem readonly as below:

ocfs2_mount
  ocfs2_initialize_super
    ocfs2_init_global_system_inodes
      ocfs2_iget
        ocfs2_read_locked_inode
          ocfs2_validate_inode_block
	    ocfs2_error
	      ocfs2_handle_error
	        ocfs2_set_ro_flag(osb, 0);  // set readonly

In this situation we need return -EROFS to 'mount.ocfs2', so that user
can fix it by fsck. And then mount again. In addition, 'mount.ocfs2'
should be updated correspondingly as it only return 1 for all errno.
And I will post a patch for 'mount.ocfs2' too.

Signed-off-by: Jun Piao <piaojun@huawei.com>
Reviewed-by: Alex Chen <alex.chen@huawei.com>
Reviewed-by: Joseph Qi <jiangqi903@gmail.com>
Reviewed-by: Changwei Ge <ge.changwei@h3c.com>
Reviewed-by: Gang He <ghe@suse.com>
---
 fs/ocfs2/super.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 040bbb6..4e4bb27 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -474,9 +474,8 @@ static int ocfs2_init_global_system_inodes(struct ocfs2_super *osb)
 		new = ocfs2_get_system_file_inode(osb, i, osb->slot_num);
 		if (!new) {
 			ocfs2_release_system_inodes(osb);
-			status = -EINVAL;
+			status = ocfs2_is_soft_readonly(osb) ? -EROFS : -EINVAL;
 			mlog_errno(status);
-			/* FIXME: Should ERROR_RO_FS */
 			mlog(ML_ERROR, "Unable to load system inode %d, "
 			     "possibly corrupt fs?", i);
 			goto bail;
@@ -505,7 +504,7 @@ static int ocfs2_init_local_system_inodes(struct ocfs2_super *osb)
 		new = ocfs2_get_system_file_inode(osb, i, osb->slot_num);
 		if (!new) {
 			ocfs2_release_system_inodes(osb);
-			status = -EINVAL;
+			status = ocfs2_is_soft_readonly(osb) ? -EROFS : -EINVAL;
 			mlog(ML_ERROR, "status=%d, sysfile=%d, slot=%d\n",
 			     status, i, osb->slot_num);
 			goto bail;
-- 
