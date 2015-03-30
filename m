From: alex chen <alex.chen@huawei.com>
Date: Mon, 30 Mar 2015 11:22:13 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: check if the ocfs2 lock resource be
 initialized before calling ocfs2_dlm_lock
Message-ID: <5518C165.10106@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

If ocfs2 lockres has not been initialized before calling ocfs2_dlm_lock,
the lock won't be dropped and then will lead umount hung. The case is
described below:

ocfs2_mknod
    ocfs2_mknod_locked
        __ocfs2_mknod_locked
            ocfs2_journal_access_di
            Failed because of -ENOMEM or other reasons, the inode lockres
            has not been initialized yet.

    iput(inode)
        ocfs2_evict_inode
            ocfs2_delete_inode
                ocfs2_inode_lock
                    ocfs2_inode_lock_full_nested
                        __ocfs2_cluster_lock
                        Succeeds and allocates a new dlm lockres.
            ocfs2_clear_inode
                ocfs2_open_unlock
                    ocfs2_drop_inode_locks
                        ocfs2_drop_lock
                        Since lockres has not been initialized, the lock
                        can't be dropped and the lockres can't be
                        migrated, thus umount will hang forever.

Signed-off-by: Alex Chen <alex.chen@huawei.com>
Reviewed-by: Joseph Qi <joseph.qi@huawei.com>
Reviewed-by: joyce.xue <xuejiufei@huawei.com>

---
 fs/ocfs2/dlmglue.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 11849a4..8b23aa2 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -1391,6 +1391,11 @@ static int __ocfs2_cluster_lock(struct ocfs2_super *osb,
 	int noqueue_attempted = 0;
 	int dlm_locked = 0;

+	if (!(lockres->l_flags & OCFS2_LOCK_INITIALIZED)) {
+		mlog_errno(-EINVAL);
+		return -EINVAL;
+	}
+
 	ocfs2_init_mask_waiter(&mw);

 	if (lockres->l_ops->flags & LOCK_TYPE_USES_LVB)
-- 
1.8.4.3
