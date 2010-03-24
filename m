From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 24 Mar 2010 15:01:39 -0700
Subject: [Ocfs2-devel] lockdep warning in ocfs2 quota
Message-ID: <20100324220138.GA14310@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Jan,
	I got this on an ocfs2 filesystem with quota features enabled
(but quota enforcement not turned on).  Non-clustered ocfs2.  Fresh
mkfs.  Untarring a kernel tree.

Joel

=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.34-rc1-kvm #179
-------------------------------------------------------
tar/2546 is trying to acquire lock:
 (&s->s_dquot.dqio_mutex){+.+...}, at: [<c10e980f>]
dquot_commit+0x26/0xc8

but task is already holding lock:
 (&s->s_dquot.dqptr_sem){++++..}, at: [<c10ec9a4>]
dquot_alloc_inode+0x63/0x133

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #3 (&s->s_dquot.dqptr_sem){++++..}:
       [<c10574f2>] __lock_acquire+0x10ad/0x139e
       [<c105787a>] lock_acquire+0x97/0xbb
       [<c1226f90>] down_read+0x31/0x45
       [<c10ec9a4>] dquot_alloc_inode+0x63/0x133
       [<db4bfaec>] ocfs2_mknod+0x728/0xd8c [ocfs2]
       [<db4c01c7>] ocfs2_mkdir+0x77/0xcd [ocfs2]
       [<c10c07a0>] vfs_mkdir+0x66/0xc9
       [<c10c2622>] sys_mkdirat+0x7f/0xba
       [<c10c2672>] sys_mkdir+0x15/0x17
       [<c1228035>] syscall_call+0x7/0xb

-> #2 (jbd2_handle){+.+...}:
       [<c10574f2>] __lock_acquire+0x10ad/0x139e
       [<c105787a>] lock_acquire+0x97/0xbb
       [<dae858fb>] start_this_handle+0x370/0x38f [jbd2]
       [<dae85a8c>] jbd2_journal_start+0xa5/0xd1 [jbd2]
       [<db4b78b5>] ocfs2_start_trans+0xa5/0x178 [ocfs2]
       [<db4dcb5f>] ocfs2_modify_bh+0x2e/0x207 [ocfs2]
       [<db4df044>] ocfs2_local_read_info+0x608/0x72c [ocfs2]
       [<c10eb9ff>] vfs_load_quota_inode+0x2a7/0x497
       [<c10ebe22>] vfs_quota_enable+0xdb/0xe8
       [<db4d64be>] ocfs2_enable_quotas+0x82/0x146 [ocfs2]
       [<db4dab18>] ocfs2_fill_super+0x149f/0x1759 [ocfs2]
       [<c10bb071>] get_sb_bdev+0xf3/0x130
       [<db4d5d31>] ocfs2_get_sb+0x18/0x1a [ocfs2]
       [<c10ba0f2>] vfs_kern_mount+0x53/0xb4
       [<c10ba1a2>] do_kern_mount+0x38/0xc2
       [<c10cd3f9>] do_mount+0x66c/0x6cb
       [<c10cd4be>] sys_mount+0x66/0x94
       [<c1228035>] syscall_call+0x7/0xb

-> #1 (&journal->j_trans_barrier){.+.+..}:
       [<c10574f2>] __lock_acquire+0x10ad/0x139e
       [<c105787a>] lock_acquire+0x97/0xbb
       [<c1226f90>] down_read+0x31/0x45
       [<db4b78ab>] ocfs2_start_trans+0x9b/0x178 [ocfs2]
       [<db4e10b1>] ocfs2_global_read_dquot+0x163/0x265 [ocfs2]
       [<db4dda2b>] ocfs2_local_read_dquot+0x73/0xb42 [ocfs2]
       [<c10e99a4>] dquot_acquire+0x51/0xde
       [<db4e1949>] ocfs2_acquire_dquot+0x8c/0xee [ocfs2]
       [<c10eb1e9>] dqget+0x293/0x2cb
       [<c10eb67f>] __dquot_initialize+0x7c/0x155
       [<c10ebed4>] dquot_initialize+0x10/0x12
       [<db4bee9a>] ocfs2_get_init_inode+0xdf/0xe9 [ocfs2]
       [<db4bf71c>] ocfs2_mknod+0x358/0xd8c [ocfs2]
       [<db4c01c7>] ocfs2_mkdir+0x77/0xcd [ocfs2]
       [<c10c07a0>] vfs_mkdir+0x66/0xc9
       [<c10c2622>] sys_mkdirat+0x7f/0xba
       [<c10c2672>] sys_mkdir+0x15/0x17
       [<c1228035>] syscall_call+0x7/0xb

-> #0 (&s->s_dquot.dqio_mutex){+.+...}:
       [<c1057241>] __lock_acquire+0xdfc/0x139e
       [<c105787a>] lock_acquire+0x97/0xbb
       [<c1226ad7>] mutex_lock_nested+0x3f/0x275
       [<c10e980f>] dquot_commit+0x26/0xc8
       [<db4e085c>] ocfs2_write_dquot+0x108/0x167 [ocfs2]
       [<db4e1523>] ocfs2_mark_dquot_dirty+0xc4/0x28f [ocfs2]
       [<c10eca34>] dquot_alloc_inode+0xf3/0x133
       [<db4bfaec>] ocfs2_mknod+0x728/0xd8c [ocfs2]
       [<db4c01c7>] ocfs2_mkdir+0x77/0xcd [ocfs2]
       [<c10c07a0>] vfs_mkdir+0x66/0xc9
       [<c10c2622>] sys_mkdirat+0x7f/0xba
       [<c10c2672>] sys_mkdir+0x15/0x17
       [<c1228035>] syscall_call+0x7/0xb

other info that might help us debug this:

7 locks held by tar/2546:
 #0:  (&sb->s_type->i_mutex_key#13/1){+.+.+.}, at: [<c10bffd4>]
lookup_create+0x23/0x7f
 #1:  (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#2){+.+.+.}, at:
[<db4d43e9>] ocfs2_reserve_suballoc_bits+0x102/0xe09 [ocfs2]
 #2:  (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#5){+.+.+.}, at:
[<db4d43e9>] ocfs2_reserve_suballoc_bits+0x102/0xe09 [ocfs2]
 #3:  (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#6){+.+...}, at:
[<db4b86d6>] ocfs2_reserve_local_alloc_bits+0x100/0xe49 [ocfs2]
 #4:  (&journal->j_trans_barrier){.+.+..}, at: [<db4b78ab>]
ocfs2_start_trans+0x9b/0x178 [ocfs2]
 #5:  (jbd2_handle){+.+...}, at: [<dae858b8>]
start_this_handle+0x32d/0x38f [jbd2]
 #6:  (&s->s_dquot.dqptr_sem){++++..}, at: [<c10ec9a4>]
dquot_alloc_inode+0x63/0x133

stack backtrace:
Pid: 2546, comm: tar Not tainted 2.6.34-rc1-kvm #179
Call Trace:
 [<c122540b>] ? printk+0x14/0x19
 [<c1056000>] print_circular_bug+0x90/0x9c
 [<c1057241>] __lock_acquire+0xdfc/0x139e
 [<db4b7845>] ? ocfs2_start_trans+0x35/0x178 [ocfs2]
 [<c105787a>] lock_acquire+0x97/0xbb
 [<c10e980f>] ? dquot_commit+0x26/0xc8
 [<c1226ad7>] mutex_lock_nested+0x3f/0x275
 [<c10e980f>] ? dquot_commit+0x26/0xc8
 [<c10e980f>] dquot_commit+0x26/0xc8
 [<db4e085c>] ocfs2_write_dquot+0x108/0x167 [ocfs2]
 [<db4e1523>] ocfs2_mark_dquot_dirty+0xc4/0x28f [ocfs2]
 [<c10eca34>] dquot_alloc_inode+0xf3/0x133
 [<db4bfaec>] ocfs2_mknod+0x728/0xd8c [ocfs2]
 [<db4c01c7>] ocfs2_mkdir+0x77/0xcd [ocfs2]
 [<c10c07a0>] vfs_mkdir+0x66/0xc9
 [<db4c0150>] ? ocfs2_mkdir+0x0/0xcd [ocfs2]
 [<c10c2622>] sys_mkdirat+0x7f/0xba
 [<c10a51ac>] ? handle_mm_fault+0x56a/0x57d
 [<c1049bb6>] ? up_read+0x1b/0x31
 [<c122806e>] ? restore_all_notrace+0x0/0x18
 [<c10c2672>] sys_mkdir+0x15/0x17
 [<c1228035>] syscall_call+0x7/0xb


-- 

"All alone at the end of the evening
 When the bright lights have faded to blue.
 I was thinking about a woman who had loved me
 And I never knew"

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
