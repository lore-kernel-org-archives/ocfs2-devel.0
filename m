From: Tao Ma <tao.ma@oracle.com>
Date: Tue,  7 Sep 2010 13:30:05 +0800
Subject: [Ocfs2-devel] [PATCH 1/2] ocfs2/lockdep: Move ip_xattr_sem out of
	ocfs2_xattr_get_nolock.
In-Reply-To: <4C85CD9F.2080501@oracle.com>
References: <4C85CD9F.2080501@oracle.com>
Message-ID: <1283837406-15685-1-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

As the name shows, we shouldn't have any lock in
ocfs2_xattr_get_nolock. so lift ip_xattr_sem to the caller.
This should be safe for us since the only 2 callers are:
1. ocfs2_xattr_get which will lock the resources.
2. ocfs2_mknod which don't need this locking.

And this also resolves the following lockdep warning.

=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.35+ #5
-------------------------------------------------------
reflink/30027 is trying to acquire lock:
 (&oi->ip_alloc_sem){+.+.+.}, at: [<ffffffffa0673b67>] ocfs2_reflink_ioctl+0x69a/0x1226 [ocfs2]

but task is already holding lock:
 (&oi->ip_xattr_sem){++++..}, at: [<ffffffffa0673b58>] ocfs2_reflink_ioctl+0x68b/0x1226 [ocfs2]

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #3 (&oi->ip_xattr_sem){++++..}:
       [<ffffffff82064d6d>] __lock_acquire+0x79a/0x7f1
       [<ffffffff82065a81>] lock_acquire+0xc6/0xed
       [<ffffffff82339650>] down_read+0x34/0x47
       [<ffffffffa0691cb8>] ocfs2_xattr_get_nolock+0xa0/0x4e6 [ocfs2]
       [<ffffffffa069d64f>] ocfs2_get_acl_nolock+0x5c/0x132 [ocfs2]
       [<ffffffffa069d9c7>] ocfs2_init_acl+0x60/0x243 [ocfs2]
       [<ffffffffa066499d>] ocfs2_mknod+0xae8/0xfea [ocfs2]
       [<ffffffffa0665041>] ocfs2_create+0x9d/0x105 [ocfs2]
       [<ffffffff820e1c83>] vfs_create+0x9b/0xf4
       [<ffffffff820e20bb>] do_last+0x2fd/0x5be
       [<ffffffff820e31c0>] do_filp_open+0x1fb/0x572
       [<ffffffff820d6cf6>] do_sys_open+0x5a/0xe7
       [<ffffffff820d6dac>] sys_open+0x1b/0x1d
       [<ffffffff8200296b>] system_call_fastpath+0x16/0x1b

-> #2 (jbd2_handle){+.+...}:
       [<ffffffff82064d6d>] __lock_acquire+0x79a/0x7f1
       [<ffffffff82065a81>] lock_acquire+0xc6/0xed
       [<ffffffffa0604ff8>] start_this_handle+0x4a3/0x4bc [jbd2]
       [<ffffffffa06051d6>] jbd2__journal_start+0xba/0xee [jbd2]
       [<ffffffffa0605218>] jbd2_journal_start+0xe/0x10 [jbd2]
       [<ffffffffa065ca34>] ocfs2_start_trans+0xb7/0x19b [ocfs2]
       [<ffffffffa06645f3>] ocfs2_mknod+0x73e/0xfea [ocfs2]
       [<ffffffffa0665041>] ocfs2_create+0x9d/0x105 [ocfs2]
       [<ffffffff820e1c83>] vfs_create+0x9b/0xf4
       [<ffffffff820e20bb>] do_last+0x2fd/0x5be
       [<ffffffff820e31c0>] do_filp_open+0x1fb/0x572
       [<ffffffff820d6cf6>] do_sys_open+0x5a/0xe7
       [<ffffffff820d6dac>] sys_open+0x1b/0x1d
       [<ffffffff8200296b>] system_call_fastpath+0x16/0x1b

-> #1 (&journal->j_trans_barrier){.+.+..}:
       [<ffffffff82064d6d>] __lock_acquire+0x79a/0x7f1
       [<ffffffff82064fa9>] lock_release_non_nested+0x1e5/0x24b
       [<ffffffff82065999>] lock_release+0x158/0x17a
       [<ffffffff823389f6>] __mutex_unlock_slowpath+0xbf/0x11b
       [<ffffffff82338a5b>] mutex_unlock+0x9/0xb
       [<ffffffffa0679673>] ocfs2_free_ac_resource+0x31/0x67 [ocfs2]
       [<ffffffffa067c6bc>] ocfs2_free_alloc_context+0x11/0x1d [ocfs2]
       [<ffffffffa0633de0>] ocfs2_write_begin_nolock+0x141e/0x159b [ocfs2]
       [<ffffffffa0635523>] ocfs2_write_begin+0x11e/0x1e7 [ocfs2]
       [<ffffffff820a1297>] generic_file_buffered_write+0x10c/0x210
       [<ffffffffa0653624>] ocfs2_file_aio_write+0x4cc/0x6d3 [ocfs2]
       [<ffffffff820d822d>] do_sync_write+0xc2/0x106
       [<ffffffff820d897b>] vfs_write+0xae/0x131
       [<ffffffff820d8e55>] sys_write+0x47/0x6f
       [<ffffffff8200296b>] system_call_fastpath+0x16/0x1b

-> #0 (&oi->ip_alloc_sem){+.+.+.}:
       [<ffffffff82063f92>] validate_chain+0x727/0xd68
       [<ffffffff82064d6d>] __lock_acquire+0x79a/0x7f1
       [<ffffffff82065a81>] lock_acquire+0xc6/0xed
       [<ffffffff82339694>] down_write+0x31/0x52
       [<ffffffffa0673b67>] ocfs2_reflink_ioctl+0x69a/0x1226 [ocfs2]
       [<ffffffffa06599f6>] ocfs2_ioctl+0x61a/0x656 [ocfs2]
       [<ffffffff820e53ac>] vfs_ioctl+0x2a/0x9d
       [<ffffffff820e5903>] do_vfs_ioctl+0x45d/0x4ae
       [<ffffffff820e59ab>] sys_ioctl+0x57/0x7a
       [<ffffffff8200296b>] system_call_fastpath+0x16/0x1b

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/xattr.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index d03469f..06fa5e7 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -1286,13 +1286,11 @@ int ocfs2_xattr_get_nolock(struct inode *inode,
 	xis.inode_bh = xbs.inode_bh = di_bh;
 	di = (struct ocfs2_dinode *)di_bh->b_data;
 
-	down_read(&oi->ip_xattr_sem);
 	ret = ocfs2_xattr_ibody_get(inode, name_index, name, buffer,
 				    buffer_size, &xis);
 	if (ret == -ENODATA && di->i_xattr_loc)
 		ret = ocfs2_xattr_block_get(inode, name_index, name, buffer,
 					    buffer_size, &xbs);
-	up_read(&oi->ip_xattr_sem);
 
 	return ret;
 }
@@ -1316,8 +1314,10 @@ static int ocfs2_xattr_get(struct inode *inode,
 		mlog_errno(ret);
 		return ret;
 	}
+	down_read(&OCFS2_I(inode)->ip_xattr_sem);
 	ret = ocfs2_xattr_get_nolock(inode, di_bh, name_index,
 				     name, buffer, buffer_size);
+	up_read(&OCFS2_I(inode)->ip_xattr_sem);
 
 	ocfs2_inode_unlock(inode, 0);
 
-- 
1.7.1.GIT
