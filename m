From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Thu,  3 Dec 2015 16:50:03 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: dlm: fix deadlock due to nested lock
Message-ID: <1449132603-4918-1-git-send-email-junxiao.bi@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

DLM allows nested cluster locking. One node X can acquire a cluster lock
two times before release it. But between these two acquiring, if another
node Y asks for the same lock and is blocked, then a bast will be sent to
node X and OCFS2_LOCK_BLOCKED will be set in that lock's lockres. In this
case, the second acquiring of that lock in node X will cause a deadlock.
Not block for nested locking can fix this.

Use ocfs2-test multiple reflink test can reproduce this on v4.3 kernel,
the whole cluster hung, and get the following call trace.

 INFO: task multi_reflink_t:10118 blocked for more than 120 seconds.
       Tainted: G           OE   4.3.0 #1
 "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
 multi_reflink_t D ffff88003e816980     0 10118  10117 0x00000080
  ffff880005b735f8 0000000000000082 ffffffff81a25500 ffff88003e750000
  ffff880005b735c8 ffffffff8117992f ffffea0000929f80 ffff88003e816980
  7fffffffffffffff 0000000000000000 0000000000000001 ffffea0000929f80
 Call Trace:
  [<ffffffff8117992f>] ? find_get_entry+0x2f/0xc0
  [<ffffffff816a68fe>] schedule+0x3e/0x80
  [<ffffffff816a9358>] schedule_timeout+0x1c8/0x220
  [<ffffffffa067eee4>] ? ocfs2_inode_cache_unlock+0x14/0x20 [ocfs2]
  [<ffffffffa06bb1e9>] ? ocfs2_metadata_cache_unlock+0x19/0x30 [ocfs2]
  [<ffffffffa06bb399>] ? ocfs2_buffer_cached+0x99/0x170 [ocfs2]
  [<ffffffffa067eee4>] ? ocfs2_inode_cache_unlock+0x14/0x20 [ocfs2]
  [<ffffffffa06bb1e9>] ? ocfs2_metadata_cache_unlock+0x19/0x30 [ocfs2]
  [<ffffffff810c5f41>] ? __raw_callee_save___pv_queued_spin_unlock+0x11/0x20
  [<ffffffff816a78ae>] wait_for_completion+0xde/0x110
  [<ffffffff810a81b0>] ? try_to_wake_up+0x240/0x240
  [<ffffffffa066f65d>] __ocfs2_cluster_lock+0x20d/0x720 [ocfs2]
  [<ffffffff810c5f41>] ? __raw_callee_save___pv_queued_spin_unlock+0x11/0x20
  [<ffffffffa0674841>] ocfs2_inode_lock_full_nested+0x181/0x400 [ocfs2]
  [<ffffffffa06d0db3>] ? ocfs2_iop_get_acl+0x53/0x113 [ocfs2]
  [<ffffffff81210cd2>] ? igrab+0x42/0x70
  [<ffffffffa06d0db3>] ocfs2_iop_get_acl+0x53/0x113 [ocfs2]
  [<ffffffff81254583>] get_acl+0x53/0x70
  [<ffffffff81254923>] posix_acl_create+0x73/0x130
  [<ffffffffa068f0bf>] ocfs2_mknod+0x7cf/0x1140 [ocfs2]
  [<ffffffffa068fba2>] ocfs2_create+0x62/0x110 [ocfs2]
  [<ffffffff8120be25>] ? __d_alloc+0x65/0x190
  [<ffffffff81201b3e>] ? __inode_permission+0x4e/0xd0
  [<ffffffff81202cf5>] vfs_create+0xd5/0x100
  [<ffffffff812009ed>] ? lookup_real+0x1d/0x60
  [<ffffffff81203a03>] lookup_open+0x173/0x1a0
  [<ffffffff810c59c6>] ? percpu_down_read+0x16/0x70
  [<ffffffff81205fea>] do_last+0x31a/0x830
  [<ffffffff81201b3e>] ? __inode_permission+0x4e/0xd0
  [<ffffffff81201bd8>] ? inode_permission+0x18/0x50
  [<ffffffff812046b0>] ? link_path_walk+0x290/0x550
  [<ffffffff8120657c>] path_openat+0x7c/0x140
  [<ffffffff812066c5>] do_filp_open+0x85/0xe0
  [<ffffffff8120190f>] ? getname_flags+0x7f/0x1f0
  [<ffffffff811f613a>] do_sys_open+0x11a/0x220
  [<ffffffff8100374b>] ? syscall_trace_enter_phase1+0x15b/0x170
  [<ffffffff811f627e>] SyS_open+0x1e/0x20
  [<ffffffff816aa2ae>] entry_SYSCALL_64_fastpath+0x12/0x71

commit 743b5f1434f5 ("ocfs2: take inode lock in ocfs2_iop_set/get_acl()")
add a nested locking to ocfs2_mknod() which exports this deadlock, but
indeed this is a common issue, it can be triggered in other place.

Cc: <stable@vger.kernel.org>
Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
---
 fs/ocfs2/dlmglue.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 1c91103..5b7d9d4 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -1295,7 +1295,9 @@ static inline int ocfs2_may_continue_on_blocked_lock(struct ocfs2_lock_res *lock
 {
 	BUG_ON(!(lockres->l_flags & OCFS2_LOCK_BLOCKED));
 
-	return wanted <= ocfs2_highest_compat_lock_level(lockres->l_blocking);
+	/* allow nested lock request go to avoid deadlock. */
+	return wanted <= ocfs2_highest_compat_lock_level(lockres->l_blocking)
+		|| lockres->l_ro_holders || lockres->l_ex_holders;
 }
 
 static void ocfs2_init_mask_waiter(struct ocfs2_mask_waiter *mw)
-- 
1.7.9.5
