From: Joel Becker <jlbec@evilplan.org>
Date: Mon, 1 Jul 2013 15:57:47 -0700
Subject: [Ocfs2-devel] [PATCH V3] ocfs2: xattr: fix inlined xattr reflink
In-Reply-To: <1372388183-6378-1-git-send-email-junxiao.bi@oracle.com>
References: <1372388183-6378-1-git-send-email-junxiao.bi@oracle.com>
Message-ID: <20130701225746.GC965@localhost>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Jun 28, 2013 at 10:56:23AM +0800, Junxiao Bi wrote:
> Inlined xattr shared free space of inode block with inlined data
> or data extent record, so the size of the later two should be
> adjusted when inlined xattr is enabled. See ocfs2_xattr_ibody_init().
> But this isn't done well when reflink. For inode with inlined data,
> its max inlined data size is adjusted in ocfs2_duplicate_inline_data(),
> no problem. But for inode with data extent record, its record count isn't
> adjusted. Fix it, or data extent record and inlined xattr may overwrite
> each other, then cause data corruption or xattr failure.
> 
> One panic caused by this bug in our test environment is the following:
> 
> kernel BUG at fs/ocfs2/xattr.c:1435!
> invalid opcode: 0000 [#1] SMP
> CPU 0
> Modules linked in: ocfs2 jbd2 ocfs2_dlmfs ocfs2_stack_o2cb ocfs2_dlm
> ocfs2_nodemanager ocfs2_stackglue configfs sunrpc parport_pc lp parport
> snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device
> snd_pcm_oss snd_mixer_oss snd_pcm snd_timer snd soundcore snd_page_alloc
> pcspkr xen_netfront dm_snapshot dm_zero dm_mirror dm_region_hash dm_log
> dm_mod xen_blkfront ext3 jbd mbcache [last unloaded: configfs]
> 
> Pid: 10871, comm: multi_reflink_t Not tainted 2.6.39-300.17.1.el5uek #1
> RIP: e030:[<ffffffffa04cd197>]  [<ffffffffa04cd197>]
> ocfs2_xa_offset_pointer+0x17/0x20 [ocfs2]
> RSP: e02b:ffff88007a587948  EFLAGS: 00010283
> RAX: 0000000000000000 RBX: 0000000000000010 RCX: 00000000000051e4
> RDX: ffff880057092060 RSI: 0000000000000f80 RDI: ffff88007a587a68
> RBP: ffff88007a587948 R08: 00000000000062f4 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000010
> R13: ffff88007a587a68 R14: 0000000000000001 R15: ffff88007a587c68
> FS:  00007fccff7f06e0(0000) GS:ffff88007fc00000(0000) knlGS:0000000000000000
> CS:  e033 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 00000000015cf000 CR3: 000000007aa76000 CR4: 0000000000000660
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process multi_reflink_t (pid: 10871, threadinfo ffff88007a586000, task
> ffff88007911c380)
> Stack:
> ffff88007a5879a8 ffffffffa04d0a60 ffff88007a587998 ffffffffa04cd514
> ffff88007a587c38 ffffffffa04cc125 000000007a587998 ffff88007a587a68
> ffff88007a587c68 0000000000000000 00000000000003c2 ffff88007a587c38
> Call Trace:
> [<ffffffffa04d0a60>] ocfs2_xa_reuse_entry+0x60/0x280 [ocfs2]
> [<ffffffffa04cd514>] ? ocfs2_xa_block_check_space+0x84/0xa0 [ocfs2]
> [<ffffffffa04cc125>] ? namevalue_size_xi+0x15/0x20 [ocfs2]
> [<ffffffffa04d0dfe>] ocfs2_xa_prepare_entry+0x17e/0x2a0 [ocfs2]
> [<ffffffffa04da55c>] ocfs2_xa_set+0xcc/0x250 [ocfs2]
> [<ffffffffa04daf58>] ocfs2_xattr_ibody_set+0x98/0x230 [ocfs2]
> [<ffffffff8115ac4b>] ? kmem_cache_alloc+0xab/0x190
> [<ffffffffa04db13f>] __ocfs2_xattr_set_handle+0x4f/0x700 [ocfs2]
> [<ffffffffa014ad03>] ? jbd2_journal_start+0x13/0x20 [jbd2]
> [<ffffffffa04dbeb6>] ocfs2_xattr_set+0x6c6/0x890 [ocfs2]
> [<ffffffffa04dc0c6>] ocfs2_xattr_user_set+0x46/0x50 [ocfs2]
> [<ffffffff81190960>] generic_setxattr+0x70/0x90
> [<ffffffff81191670>] __vfs_setxattr_noperm+0x80/0x1a0
> [<ffffffff81191839>] vfs_setxattr+0xa9/0xb0
> [<ffffffff81191903>] setxattr+0xc3/0x120
> [<ffffffff81061c40>] ? finish_task_switch+0x70/0xe0
> [<ffffffff81505a54>] ? __schedule+0x364/0x6d0
> [<ffffffff81191a08>] sys_fsetxattr+0xa8/0xd0
> [<ffffffff81510642>] system_call_fastpath+0x16/0x1b
> Code: 0f 1f 40 00 eb ae 0f 0b eb fe 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5
> 66 66 66 66 90 39 77 10 7e 09 48 8b 47 28 ff 50 10 c9 c3 <0f> 0b eb fe 0f 1f
> 44 00 00 55 48 89 e5 53 48 83 ec 08 66 66 66
> RIP  [<ffffffffa04cd197>] ocfs2_xa_offset_pointer+0x17/0x20 [ocfs2]
> RSP <ffff88007a587948>
> ---[ end trace 33461d2444bd1e5e ]---
> 
> Cc: <stable@kernel.org>
> Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
> Reviewed-by: Jie Liu <jeff.liu@oracle.com>
> ---
>  fs/ocfs2/xattr.c |   10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
> index 2e3ea30..5b8d944 100644
> --- a/fs/ocfs2/xattr.c
> +++ b/fs/ocfs2/xattr.c
> @@ -6499,6 +6499,16 @@ static int ocfs2_reflink_xattr_inline(struct ocfs2_xattr_reflink *args)
>  	}
>  
>  	new_oi = OCFS2_I(args->new_inode);
> +	/*
> +	 * Adjust extent record count to reserve space for extended attribute.
> +	 * Inline data count had been adjusted in ocfs2_duplicate_inline_data().
> +	 */
> +	if (!(new_oi->ip_dyn_features & OCFS2_INLINE_DATA_FL) &&
> +	    !(ocfs2_inode_is_fast_symlink(args->new_inode))) {
> +		struct ocfs2_extent_list *el = &new_di->id2.i_list;
> +		le16_add_cpu(&el->l_count, -(inline_size /
> +					sizeof(struct ocfs2_extent_rec)));
> +	}

Why are you referencing the inode before taking the lock?

Joel

>  	spin_lock(&new_oi->ip_lock);
>  	new_oi->ip_dyn_features |= OCFS2_HAS_XATTR_FL | OCFS2_INLINE_XATTR_FL;
>  	new_di->i_dyn_features = cpu_to_le16(new_oi->ip_dyn_features);
> -- 
> 1.7.9.5
> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel

-- 

 The herd instinct among economists makes sheep look like
 independant thinkers.

			http://www.jlbec.org/
			jlbec at evilplan.org
