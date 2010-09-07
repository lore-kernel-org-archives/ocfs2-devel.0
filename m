From: Tao Ma <tao.ma@oracle.com>
Date: Tue,  7 Sep 2010 13:30:06 +0800
Subject: [Ocfs2-devel] [PATCH 2/2] ocfs2: Fix lockdep warning in reflink.
In-Reply-To: <4C85CD9F.2080501@oracle.com>
References: <4C85CD9F.2080501@oracle.com>
Message-ID: <1283837406-15685-2-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This patch change mutex_lock to a new subclass and
add a new inode lock subclass for the target inode
which caused this lockdep warning.

=============================================
[ INFO: possible recursive locking detected ]
2.6.35+ #5
---------------------------------------------
reflink/11086 is trying to acquire lock:
 (Meta){+++++.}, at: [<ffffffffa06f9d65>] ocfs2_reflink_ioctl+0x898/0x1229 [ocfs2]

but task is already holding lock:
 (Meta){+++++.}, at: [<ffffffffa06f9aa0>] ocfs2_reflink_ioctl+0x5d3/0x1229 [ocfs2]

other info that might help us debug this:
6 locks held by reflink/11086:
 #0:  (&sb->s_type->i_mutex_key#15/1){+.+.+.}, at: [<ffffffff820e09ec>] lookup_create+0x26/0x97
 #1:  (&sb->s_type->i_mutex_key#15){+.+.+.}, at: [<ffffffffa06f99a0>] ocfs2_reflink_ioctl+0x4d3/0x1229 [ocfs2]
 #2:  (Meta){+++++.}, at: [<ffffffffa06f9aa0>] ocfs2_reflink_ioctl+0x5d3/0x1229 [ocfs2]
 #3:  (&oi->ip_xattr_sem){+.+.+.}, at: [<ffffffffa06f9b58>] ocfs2_reflink_ioctl+0x68b/0x1229 [ocfs2]
 #4:  (&oi->ip_alloc_sem){+.+.+.}, at: [<ffffffffa06f9b67>] ocfs2_reflink_ioctl+0x69a/0x1229 [ocfs2]
 #5:  (&sb->s_type->i_mutex_key#15/2){+.+...}, at: [<ffffffffa06f9d4f>] ocfs2_reflink_ioctl+0x882/0x1229 [ocfs2]

stack backtrace:
Pid: 11086, comm: reflink Not tainted 2.6.35+ #5
Call Trace:
 [<ffffffff82063dd9>] validate_chain+0x56e/0xd68
 [<ffffffff82062275>] ? mark_held_locks+0x49/0x69
 [<ffffffff82064d6d>] __lock_acquire+0x79a/0x7f1
 [<ffffffff82065a81>] lock_acquire+0xc6/0xed
 [<ffffffffa06f9d65>] ? ocfs2_reflink_ioctl+0x898/0x1229 [ocfs2]
 [<ffffffffa06c9ade>] __ocfs2_cluster_lock+0x975/0xa0d [ocfs2]
 [<ffffffffa06f9d65>] ? ocfs2_reflink_ioctl+0x898/0x1229 [ocfs2]
 [<ffffffffa06e107b>] ? ocfs2_wait_for_recovery+0x15/0x8a [ocfs2]
 [<ffffffffa06cb6ea>] ocfs2_inode_lock_full_nested+0x1ac/0xdc5 [ocfs2]
 [<ffffffffa06f9d65>] ? ocfs2_reflink_ioctl+0x898/0x1229 [ocfs2]
 [<ffffffff820623a0>] ? trace_hardirqs_on_caller+0x10b/0x12f
 [<ffffffff82060193>] ? debug_mutex_free_waiter+0x4f/0x53
 [<ffffffffa06f9d65>] ocfs2_reflink_ioctl+0x898/0x1229 [ocfs2]
 [<ffffffffa06ce24a>] ? ocfs2_file_lock_res_init+0x66/0x78 [ocfs2]
 [<ffffffff820bb2d2>] ? might_fault+0x40/0x8d
 [<ffffffffa06df9f6>] ocfs2_ioctl+0x61a/0x656 [ocfs2]
 [<ffffffff820ee5d3>] ? mntput_no_expire+0x1d/0xb0
 [<ffffffff820e07b3>] ? path_put+0x2c/0x31
 [<ffffffff820e53ac>] vfs_ioctl+0x2a/0x9d
 [<ffffffff820e5903>] do_vfs_ioctl+0x45d/0x4ae
 [<ffffffff8233a7f6>] ? _raw_spin_unlock+0x26/0x2a
 [<ffffffff8200299c>] ? sysret_check+0x27/0x62
 [<ffffffff820e59ab>] sys_ioctl+0x57/0x7a
 [<ffffffff8200296b>] system_call_fastpath+0x16/0x1b

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/dlmglue.h      |    1 +
 fs/ocfs2/refcounttree.c |    5 +++--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/dlmglue.h b/fs/ocfs2/dlmglue.h
index d1ce48e..1d596d8 100644
--- a/fs/ocfs2/dlmglue.h
+++ b/fs/ocfs2/dlmglue.h
@@ -84,6 +84,7 @@ enum {
 	OI_LS_PARENT,
 	OI_LS_RENAME1,
 	OI_LS_RENAME2,
+	OI_LS_REFLINK_TARGET,
 };
 
 int ocfs2_dlm_init(struct ocfs2_super *osb);
diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index 73a11cc..588cacd 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -4200,8 +4200,9 @@ static int __ocfs2_reflink(struct dentry *old_dentry,
 		goto out;
 	}
 
-	mutex_lock(&new_inode->i_mutex);
-	ret = ocfs2_inode_lock(new_inode, &new_bh, 1);
+	mutex_lock_nested(&new_inode->i_mutex, I_MUTEX_CHILD);
+	ret = ocfs2_inode_lock_nested(new_inode, &new_bh, 1,
+				      OI_LS_REFLINK_TARGET);
 	if (ret) {
 		mlog_errno(ret);
 		goto out_unlock;
-- 
1.7.1.GIT
