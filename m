From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 12 Dec 2008 16:20:22 -0800
Subject: [Ocfs2-devel] lockdep on latest mainline
Message-ID: <20081213002022.GC15241@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Lockdep fired this on my ppc during an untar.  This tree has my
xattr/metaecc changes, but afaict this doesn't get affected by them.

=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.28-rc7-metaecc #6
-------------------------------------------------------
tar/7232 is trying to acquire lock:
 (&oi->ip_alloc_sem){--..}, at: [<d000000000853c14>]
.ocfs2_extend_dir+0x644/0x1560 [ocfs2]

but task is already holding lock:
 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#2){--..}, at:
[<d000000000878860>] .ocfs2_reserve_local_alloc_bits+0xa0/0x5e0 [ocfs2]

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#2){--..}:
       [<c000000000098b90>] .__lock_acquire+0x360/0xa40
       [<c0000000000992c4>] .lock_acquire+0x54/0x80
       [<c00000000056d760>] .mutex_lock_nested+0xf0/0x430
       [<d000000000878860>] .ocfs2_reserve_local_alloc_bits+0xa0/0x5e0
[ocfs2]
       [<d000000000889c94>]
.ocfs2_reserve_clusters_with_limit+0xb4/0x2d0 [ocfs2]
       [<d00000000088b2a0>] .ocfs2_lock_allocators+0x250/0x2d0 [ocfs2]
       [<d00000000084d288>] .ocfs2_write_begin_nolock+0x3c8/0x1190
[ocfs2]
       [<d00000000084fa64>] .ocfs2_write_begin+0x144/0x2e0 [ocfs2]
       [<c0000000000b68dc>] .generic_file_buffered_write+0x14c/0x370
       [<c0000000000b70b0>] .__generic_file_aio_write_nolock+0x2f0/0x430
       [<c0000000000b7398>] .generic_file_aio_write_nolock+0x48/0xf0
       [<d000000000869bdc>] .ocfs2_file_aio_write+0x47c/0x620 [ocfs2]
       [<c0000000000f2e94>] .do_sync_write+0xd4/0x170
       [<c0000000000f3798>] .vfs_write+0xe8/0x1b0
       [<c0000000000f414c>] .sys_write+0x4c/0x90
       [<c0000000000084d4>] syscall_exit+0x0/0x40

-> #0 (&oi->ip_alloc_sem){--..}:
       [<c000000000098b90>] .__lock_acquire+0x360/0xa40
       [<c0000000000992c4>] .lock_acquire+0x54/0x80
       [<c00000000056e304>] .down_write+0x54/0xb0
       [<d000000000853c14>] .ocfs2_extend_dir+0x644/0x1560 [ocfs2]
       [<d000000000857654>] .ocfs2_prepare_dir_for_insert+0x884/0xa20
[ocfs2]
       [<d00000000087c170>] .ocfs2_mknod+0x3f0/0xe40 [ocfs2]
       [<d00000000087cd7c>] .ocfs2_create+0x6c/0x150 [ocfs2]
       [<c0000000000ffa70>] .vfs_create+0x110/0x1a0
       [<c000000000103c78>] .do_filp_open+0x7e8/0x8d0
       [<c0000000000f0aa8>] .do_sys_open+0x88/0x160
       [<c00000000013e344>] .compat_sys_open+0x24/0x40
       [<c0000000000084d4>] syscall_exit+0x0/0x40

other info that might help us debug this:

2 locks held by tar/7232:
 #0:  (&sb->s_type->i_mutex_key#14){--..}, at: [<c000000000103778>]
.do_filp_open+0x2e8/0x8d0
 #1:  (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#2){--..}, at:
[<d000000000878860>] .ocfs2_reserve_local_alloc_bits+0xa0/0x5e0 [ocfs2]

stack backtrace:
Call Trace:
[c00000009a63b170] [c0000000000116dc] .show_stack+0x5c/0x1b0
(unreliable)
[c00000009a63b220] [c00000000009770c] .print_circular_bug_tail+0x9c/0xf0
[c00000009a63b2f0] [c000000000097f20] .validate_chain+0x7c0/0x10d0
[c00000009a63b3c0] [c000000000098b90] .__lock_acquire+0x360/0xa40
[c00000009a63b4c0] [c0000000000992c4] .lock_acquire+0x54/0x80
[c00000009a63b550] [c00000000056e304] .down_write+0x54/0xb0
[c00000009a63b5f0] [d000000000853c14] .ocfs2_extend_dir+0x644/0x1560
[ocfs2]
[c00000009a63b7b0] [d000000000857654]
.ocfs2_prepare_dir_for_insert+0x884/0xa20 [ocfs2]
[c00000009a63b8d0] [d00000000087c170] .ocfs2_mknod+0x3f0/0xe40 [ocfs2]
[c00000009a63ba20] [d00000000087cd7c] .ocfs2_create+0x6c/0x150 [ocfs2]
[c00000009a63bad0] [c0000000000ffa70] .vfs_create+0x110/0x1a0
[c00000009a63bb70] [c000000000103c78] .do_filp_open+0x7e8/0x8d0
[c00000009a63bd00] [c0000000000f0aa8] .do_sys_open+0x88/0x160
[c00000009a63bdb0] [c00000000013e344] .compat_sys_open+0x24/0x40
[c00000009a63be30] [c0000000000084d4] syscall_exit+0x0/0x40


-- 

"Here's something to think about:  How come you never see a headline
 like ``Psychic Wins Lottery''?"
	- Jay Leno

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
