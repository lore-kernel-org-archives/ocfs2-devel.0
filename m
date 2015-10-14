From: alex chen <alex.chen@huawei.com>
Date: Wed, 14 Oct 2015 11:23:03 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: should reclaim the inode if
 '__ocfs2_mknod_locked' returns an error
Message-ID: <561DCA97.1010709@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In ocfs2_mknod_locked if '__ocfs2_mknod_locked' returns an error, we
should reclaim the inode successfully claimed above, otherwise, the
inode never be reused. The case is described below:

ocfs2_mknod
    ocfs2_mknod_locked
	ocfs2_claim_new_inode
		Successfully claim the inode
        __ocfs2_mknod_locked
            ocfs2_journal_access_di
            Failed because of -ENOMEM or other reasons, the inode
			lockres has not been initialized yet.

    iput(inode)
        ocfs2_evict_inode
            ocfs2_delete_inode
                ocfs2_inode_lock
                    ocfs2_inode_lock_full_nested
                        __ocfs2_cluster_lock
				Return -EINVAL because of the inode
				lockres has not been initialized.

		So the following operations are not performed
		ocfs2_wipe_inode
			ocfs2_remove_inode
				ocfs2_free_dinode
					ocfs2_free_suballoc_bits

Signed-off-by: Alex Chen <alex.chen@huawei.com>
Reviewed-by: Joseph Qi <joseph.qi@huawei.com>
---
 fs/ocfs2/namei.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 1206392..3b48ac2 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -655,9 +655,18 @@ static int ocfs2_mknod_locked(struct ocfs2_super *osb,
 		return status;
 	}

-	return __ocfs2_mknod_locked(dir, inode, dev, new_fe_bh,
+	status = __ocfs2_mknod_locked(dir, inode, dev, new_fe_bh,
 				    parent_fe_bh, handle, inode_ac,
 				    fe_blkno, suballoc_loc, suballoc_bit);
+	if (status < 0) {
+		u64 bg_blkno = ocfs2_which_suballoc_group(fe_blkno, suballoc_bit);
+		int tmp = ocfs2_free_suballoc_bits(handle, inode_ac->ac_inode,
+				inode_ac->ac_bh, suballoc_bit, bg_blkno, 1);
+		if (tmp)
+			mlog_errno(tmp);
+	}
+
+	return status;
 }

 static int ocfs2_mkdir(struct inode *dir,
-- 
1.8.4.3
