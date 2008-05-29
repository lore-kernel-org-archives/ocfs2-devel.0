From: Eric Sesterhenn <snakebyte@gmx.de>
Date: Thu, 29 May 2008 13:18:33 -0000
Subject: [Ocfs2-devel] Filesystem fuzzing
In-Reply-To: <483CC391.9000607@oracle.com>
References: <20080519100737.GA7764@alice> <48345A30.9030004@oracle.com>
	<20080527080052.GA9193@alice> <483CC391.9000607@oracle.com>
Message-ID: <20080529131731.GB9702@alice>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sunil Mushran <Sunil.Mushran@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com

* Sunil Mushran (Sunil.Mushran at oracle.com) wrote:
> Eric,
>
> Thanks. I've filed few bugzillas for tracking them.
> I'll need to think about this.
>
> http://oss.oracle.com/bugzilla/show_bug.cgi?id=970
> http://oss.oracle.com/bugzilla/show_bug.cgi?id=971


hi,

i just hit the following on current -git

[13643.111621] ocfs2: Unmounting device (7,1) on (node local)
[13645.520545] JBD: Ignoring recovery information on journal
[13645.535059] kjournald starting.  Commit interval 5 seconds
[13645.541779] ocfs2: Mounting device (7,2) on (node local, slot 0) with
ordered data mode.
[13646.555938] 
[13646.555945] =======================================================
[13646.556168] [ INFO: possible circular locking dependency detected ]
[13646.556272] 2.6.26-rc4-00027-g0a2ce2f #4
[13646.556352] -------------------------------------------------------
[13646.556352] rm/16437 is trying to acquire lock:
[13646.556352]  (&oi->ip_alloc_sem){----}, at: [<c03a89b7>]
ocfs2_bread+0xa7/0x220
[13646.556352] 
[13646.556352] but task is already holding lock:
[13646.556352]  (jbd_handle){--..}, at: [<c022175a>]
journal_start+0xaa/0x100
[13646.556352] 
[13646.556352] which lock already depends on the new lock.
[13646.556352] 
[13646.556352] 
[13646.556352] the existing dependency chain (in reverse order) is:
[13646.556352] 
[13646.556352] -> #3 (jbd_handle){--..}:
[13646.556352]        [<c0147f18>] __lock_acquire+0xc58/0x1100
[13646.556352]        [<c0148440>] lock_acquire+0x80/0xa0
[13646.556352]        [<c022177e>] journal_start+0xce/0x100
[13646.556352]        [<c03aca7d>] ocfs2_start_trans+0x12d/0x260
[13646.556352]        [<c03b80f4>] ocfs2_mknod+0x224/0xd80
[13646.556352]        [<c03b9319>] ocfs2_create+0x49/0x180
[13646.556352]        [<c0192e01>] vfs_create+0xc1/0x150
[13646.556352]        [<c0195706>] do_filp_open+0x556/0x7a0
[13646.556352]        [<c0187f29>] do_sys_open+0x49/0xd0
[13646.556352]        [<c0188019>] sys_open+0x29/0x40
[13646.556352]        [<c0103d6d>] sysenter_past_esp+0x6a/0xb1
[13646.556352]        [<ffffffff>] 0xffffffff
[13646.556352] 
[13646.556352] -> #2 (&journal->j_trans_barrier){..--}:
[13646.556352]        [<c0147f18>] __lock_acquire+0xc58/0x1100
[13646.556352]        [<c0148440>] lock_acquire+0x80/0xa0
[13646.556352]        [<c06d9a7e>] down_read+0x3e/0x80
[13646.556352]        [<c03aca72>] ocfs2_start_trans+0x122/0x260
[13646.556352]        [<c03b80f4>] ocfs2_mknod+0x224/0xd80
[13646.556352]        [<c03b9199>] ocfs2_mkdir+0x49/0x180
[13646.556352]        [<c0192907>] vfs_mkdir+0xb7/0x140
[13646.556352]        [<c0194a55>] sys_mkdirat+0xd5/0xf0
[13646.556352]        [<c0194a90>] sys_mkdir+0x20/0x30
[13646.556352]     [<c0103d6d>] sysenter_past_esp+0x6a/0xb1
[13646.556352]        [<ffffffff>] 0xffffffff
[13646.556352] 
[13646.556352] -> #1
(&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#3){--..}:
[13646.556352]        [<c0147f18>] __lock_acquire+0xc58/0x1100
[13646.556352]       lock_acquire+0x80/0xa0
[13646.556352]       mutex_lock_nested+0x8e/0x2a0
[13646.556352]      [<c03c87a5>] ocfs2_reserve_suballoc_bits+0x65/0x730
[13646.556352]       ocfs2_reserve_cluster_bitmap_bits+0x30/0x140
[13646.556352]      [<c03c91f9>] ocfs2_reserve_clusters+0x249/0x560
[13646.556352]     [<c039bac3>] ocfs2_lock_allocators+0x203/0x410
[13646.556352]      [<c0380b04>] ocfs2_write_begin_nolock+0x214/0x1450
[13646.556352]     [<c0384425>] ocfs2_write_begin+0x155/0x2d0
[13646.556352]       generic_file_buffered_write+0xf4/0x5e0
[13646.556352]       __generic_file_aio_write_nolock+0x265/0x520
[13646.556352]      [<c01652e6>] generic_file_aio_write_nolock+0x46/0xb0
[13646.556352]      [<c03a3b54>] ocfs2_file_aio_write+0x3b4/0x700
[13646.556352]     [<c0189acc>] do_sync_write+0xcc/0x110
[13646.556352]      vfs_write+0x99/0x130
[13646.556352]      [<c018a8ed>] sys_write+0x3d/0x70
[13646.556352]       sysenter_past_esp+0x6a/0xb1
[13646.556352]       0xffffffff
[13646.556352] 
[13646.556352] -> #0 (&oi->ip_alloc_sem){----}:
[13646.556352]      [<c0147d20>] __lock_acquire+0xa60/0x1100
[13646.556352]      [<c0148440>] lock_acquire+0x80/0xa0
[13646.556352]      down_read+0x3e/0x80
[13646.556352]       ocfs2_bread+0xa7/0x220
[13646.556352]      [<c03899ff>] ocfs2_find_entry+0x26f/0x940
[13646.556352]     [<c03be835>] ocfs2_orphan_del+0x75/0x700
[13646.556352]       ocfs2_remove_inode+0xac/0x730
[13646.556352]       ocfs2_wipe_inode+0x123/0xbb0
[13646.556352]     [<c03a9630>] ocfs2_delete_inode+0x730/0xcc0
[13646.556352]      [<c019e3b0>] generic_delete_inode+0x90/0x110
[13646.556352]       generic_drop_inode+0x119/0x160
[13646.556352]       ocfs2_drop_inode+0x87/0x210
[13646.556352]        iput+0x47/0x50
[13646.556352]     [<c019478f>] do_unlinkat+0xdf/0x160
[13646.556352]       sys_unlinkat+0x30/0x40
[13646.556352]       sysenter_past_esp+0x6a/0xb1
[13646.556352]   [13646.556352]  [<c0145013>]
print_circular_bug_entry+0x43/0x50
[13646.556352]  [<c0147d20>] __lock_acquire+0xa60/0x1100
[13646.556352]  [<c0109727>] ? native_sched_clock+0x77/0xb0
[13646.556352]  [<c0109727>] ? native_sched_clock+0x77/0xb0
[13646.556352]  [<c0148440>] lock_acquire+0x80/0xa0
[13646.556352]  [<c03a89b7>] ? ocfs2_bread+0xa7/0x220
[13646.556352]  [<c06d9a7e>] down_read+0x3e/0x80
[13646.556352]  [<c03a89b7>] ? ocfs2_bread+0xa7/0x220
[13646.556352]  [<c03a89b7>] ocfs2_bread+0xa7/0x220
[13646.556352]  [<c03899ff>] ocfs2_find_entry+0x26f/0x940
[13646.556352]  [<c04463f7>] ? vsnprintf+0x2d7/0x5e0
[13646.556352]  [<c044679d>] ? snprintf+0x1d/0x20
[13646.556352]  [<c03b6a53>] ? ocfs2_blkno_stringify+0x53/0x400
[13646.556352]  [<c022175a>] ? journal_start+0xaa/0x100
[13646.556352]  [<c03be835>] ocfs2_orphan_del+0x75/0x700
[13646.556352]  [<c022175a>] ? journal_start+0xaa/0x100
[13646.556352]  [<c03aca7d>] ? ocfs2_start_trans+0x12d/0x260
[13646.556352]  [<c03a4aec>] ocfs2_remove_inode+0xac/0x730
[13646.556352]  [<c03a5293>] ocfs2_wipe_inode+0x123/0xbb0
[13646.556352]  [<c014483d>] ? put_lock_stats+0xd/0x30
[13646.556352]  [<c016cdba>] ? truncate_inode_pages+0x1a/0x20
[13646.556352]  [<c03a4269>] ? ocfs2_inode_is_valid_to_delete+0x89/0x320
[13646.556352]  [<c03a9630>] ocfs2_delete_inode+0x730/0xcc0
[13646.556352]  [<c0147584>] ? __lock_acquire+0x2c4/0x1100
[13646.556352]  [<c0147584>] ? __lock_acquire+0x2c4/0x1100
[13646.556352]  [<c0109727>] ? native_sched_clock+0x77/0xb0
[13646.556352]  [<c014483d>] ? put_lock_stats+0xd/0x30
[13646.556352]  [<c03a8f00>] ? ocfs2_delete_inode+0x0/0xcc0
[13646.556352]  [<c019e3b0>] generic_delete_inode+0x90/0x110
[13646.556352]  [<c019e549>] generic_drop_inode+0x119/0x160
[13646.556352]  [<c03a8787>] ocfs2_drop_inode+0x87/0x210
[13646.556352]  [<c0440ab8>] ? _atomic_dec_and_lock+0x18/0x40
[13646.556352]  [<c06da99c>] ? _spin_lock+0x5c/0x70
[13646.556352]  [<c0440ab8>] ? _atomic_dec_and_lock+0x18/0x40
[13646.556352]  [<c019d9a7>] iput+0x47/0x50
[13646.556352]  [<c019478f>] do_unlinkat+0xdf/0x160
[13646.556352]  [<c01182b7>] ? do_page_fault+0x2c7/0x640
[13646.556352]  [<c0103e57>] ? restore_nocheck+0x12/0x15
[13646.556352]  [<c0117ff0>] ? do_page_fault+0x0/0x640
[13646.556352]  [<c0146dfd>] ? trace_hardirqs_on+0xbd/0x140
[13646.556352]  [<c0194950>] sys_unlinkat+0x30/0x40
[13646.556352]  [<c0103d6d>] sysenter_past_esp+0x6a/0xb1
[13646.556352]  =======================
[13661.614478] ocfs2: Unmounting device (7,2) on (node local)


Greetings, Eric
