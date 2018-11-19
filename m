From: piaojun <piaojun@huawei.com>
Date: Mon, 19 Nov 2018 08:54:46 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix panic due to unrecovered local
 alloc
In-Reply-To: <20181116073335.5045-1-junxiao.bi@oracle.com>
References: <20181116073335.5045-1-junxiao.bi@oracle.com>
Message-ID: <5BF209D6.6040900@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Junxiao,

On 2018/11/16 15:33, Junxiao Bi wrote:
> mount.ocfs2 ignore the inconsistent error that journal is clean but
> local alloc is unrecovered. After mount, local alloc not empty, then
> reserver cluster didn't alloc a new local alloc window, reserveration
> map is empty(ocfs2_reservation_map.m_bitmap_len = 0), that triggered
> the following panic.
> 
> This issue was ever reported at https://oss.oracle.com/pipermail/ocfs2-devel/2015-May/010854.html
> and was advised to fixed during mount. But this is a very unusual
> inconsistent state, usually journal dirty flag should be cleared
> at the last stage of umount until every other things go right.
> We may need do further debug to check that. Any way to avoid
> possible futher corruption, mount should be abort and fsck
> should be run.
> 
> [   44.760372] (mount.ocfs2,1765,1):ocfs2_load_local_alloc:353 ERROR: Local alloc hasn't been recovered!
>                found = 6518, set = 6518, taken = 8192, off = 15912372
> [   44.780879] ocfs2: Mounting device (202,64) on (node 0, slot 3) with ordered data mode.
> [   44.872435] o2dlm: Joining domain 89CEAC63CC4F4D03AC185B44E0EE0F3F ( 0 1 2 3 4 5 6 8 ) 8 nodes
> [   44.902414] ocfs2: Mounting device (202,80) on (node 0, slot 3) with ordered data mode.
> [   46.066444] o2hb: Region 89CEAC63CC4F4D03AC185B44E0EE0F3F (xvdf) is now a quorum device
> [  178.576454] o2net: Accepted connection from node yvwsoa17p (num 7) at 172.22.77.88:7777
> [  191.175670] o2dlm: Node 7 joins domain 64FE421C8C984E6D96ED12C55FEE2435 ( 0 1 2 3 4 5 6 7 8 ) 9 nodes
> [  191.318225] o2dlm: Node 7 joins domain 89CEAC63CC4F4D03AC185B44E0EE0F3F ( 0 1 2 3 4 5 6 7 8 ) 9 nodes
> [  838.049923] ------------[ cut here ]------------
> [  838.050005] kernel BUG at fs/ocfs2/reservations.c:507!
> [  838.050005] invalid opcode: 0000 [#1] SMP
> [  838.050005] Modules linked in: ocfs2 rpcsec_gss_krb5 auth_rpcgss nfsv4 nfs fscache lockd grace ocfs2_dlmfs ocfs2_stack_o2cb ocfs2_dlm ocfs2_nodemanager ocfs2_stackglue configfs sunrpc ipt_REJECT nf_reject_ipv4 nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables ip6t_REJECT nf_reject_ipv6 nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables ib_ipoib rdma_ucm ib_ucm ib_uverbs ib_umad rdma_cm ib_cm iw_cm ib_sa ib_mad ib_core ib_addr ipv6 ovmapi ppdev parport_pc parport xen_netfront fb_sys_fops sysimgblt sysfillrect syscopyarea acpi_cpufreq pcspkr i2c_piix4 i2c_core sg ext4 jbd2 mbcache2 sr_mod cdrom xen_blkfront pata_acpi ata_generic ata_piix floppy dm_mirror dm_region_hash dm_log dm_mod
> [  838.050005] CPU: 0 PID: 4349 Comm: startWebLogic.s Not tainted 4.1.12-124.19.2.el6uek.x86_64 #2
> [  838.050005] Hardware name: Xen HVM domU, BIOS 4.4.4OVM 09/06/2018
> [  838.050005] task: ffff8803fb04e200 ti: ffff8800ea4d8000 task.ti: ffff8800ea4d8000
> [  838.050005] RIP: 0010:[<ffffffffa05e96a8>]  [<ffffffffa05e96a8>] __ocfs2_resv_find_window+0x498/0x760 [ocfs2]
> [  838.050005] RSP: 0018:ffff8800ea4db668  EFLAGS: 00010246
> [  838.050005] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
> [  838.050005] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> [  838.050005] RBP: ffff8800ea4db708 R08: 0000000000000000 R09: ffff8800ea4db6d0
> [  838.050005] R10: ffff8803f5c74030 R11: 0000000000000000 R12: 0000000000000000
> [  838.050005] R13: 0000000000000000 R14: ffff8800ea4db801 R15: ffff8800eab9c000
> [  838.050005] FS:  00007f1e92306700(0000) GS:ffff8803ff200000(0000) knlGS:0000000000000000
> [  838.050005] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  838.050005] CR2: 00000000018e5fbc CR3: 00000003f63d4000 CR4: 0000000000160670
> [  838.050005] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  838.050005] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [  838.050005] Stack:
> [  838.050005]  ffff8800ea4db6d4 ffff8803f5fd3070 ffff8803f5c74030 ffff8803fba5e7b8
> [  838.050005]  ffffffffa064b4f0 ffff8803fb9ef0f8 ffff8800eb638ee8 ffff8803f5fd3070
> [  838.050005]  ffff8800ea4db718 ffff8800eab9c230 ffff880000000010 0000000000000000
> [  838.050005] Call Trace:
> [  838.050005]  [<ffffffffa05e9c4d>] ocfs2_resmap_resv_bits+0x10d/0x400 [ocfs2]
> [  838.050005]  [<ffffffffa05c98c2>] ? ocfs2_journal_dirty+0x32/0xa0 [ocfs2]
> [  838.050005]  [<ffffffffa060e880>] ? olq_update_info+0x50/0x50 [ocfs2]
> [  838.050005]  [<ffffffffa05cf3f0>] ocfs2_claim_local_alloc_bits+0xd0/0x640 [ocfs2]
> [  838.050005]  [<ffffffffa05f3f38>] __ocfs2_claim_clusters+0x178/0x360 [ocfs2]
> [  838.050005]  [<ffffffffa05f687f>] ocfs2_claim_clusters+0x1f/0x30 [ocfs2]
> [  838.050005]  [<ffffffffa05980e4>] ocfs2_convert_inline_data_to_extents+0x634/0xa60 [ocfs2]
> [  838.050005]  [<ffffffffa060cf14>] ? ocfs2_buffer_cached.isra.6+0xb4/0x230 [ocfs2]
> [  838.050005]  [<ffffffffa060d965>] ? ocfs2_set_buffer_uptodate+0x25/0x600 [ocfs2]
> [  838.050005]  [<ffffffff81241f44>] ? __find_get_block+0xc4/0x140
> [  838.050005]  [<ffffffff811eabe6>] ? kmem_cache_alloc_trace+0x246/0x280
> [  838.050005]  [<ffffffffa059d436>] ocfs2_write_begin_nolock+0x1c6/0x1da0 [ocfs2]
> [  838.050005]  [<ffffffffa05c0f60>] ? ocfs2_inode_cache_io_unlock+0x20/0x20 [ocfs2]
> [  838.050005]  [<ffffffffa05b548b>] ? ocfs2_inode_lock_full_nested+0x2eb/0x520 [ocfs2]
> [  838.050005]  [<ffffffffa0624f16>] ? ocfs2_xattr_get+0xa6/0x150 [ocfs2]
> [  838.050005]  [<ffffffffa059f14e>] ocfs2_write_begin+0x13e/0x230 [ocfs2]
> [  838.050005]  [<ffffffff8118c49f>] generic_perform_write+0xbf/0x1c0
> [  838.050005]  [<ffffffff812282fe>] ? dentry_needs_remove_privs.part.11+0x1e/0x30
> [  838.050005]  [<ffffffff8118e79c>] __generic_file_write_iter+0x19c/0x1d0
> [  838.050005]  [<ffffffffa05b5119>] ? ocfs2_inode_unlock+0xa9/0x130 [ocfs2]
> [  838.050005]  [<ffffffffa05bfba9>] ocfs2_file_write_iter+0x589/0x1360 [ocfs2]
> [  838.050005]  [<ffffffff811bbd35>] ? do_wp_page+0x265/0x680
> [  838.050005]  [<ffffffff8124d534>] ? fsnotify+0x384/0x530
> [  838.050005]  [<ffffffff8120af08>] __vfs_write+0xb8/0x110
> [  838.050005]  [<ffffffff8120b5d9>] vfs_write+0xa9/0x1b0
> [  838.050005]  [<ffffffff816ee4a6>] ? mutex_lock+0x16/0x40
> [  838.050005]  [<ffffffff8120c3e6>] SyS_write+0x46/0xb0
> [  838.050005]  [<ffffffff816f13df>] ? system_call_after_swapgs+0xe9/0x190
> [  838.050005]  [<ffffffff816f13d8>] ? system_call_after_swapgs+0xe2/0x190
> [  838.050005]  [<ffffffff816f13d1>] ? system_call_after_swapgs+0xdb/0x190
> [  838.050005]  [<ffffffff816f149e>] system_call_fastpath+0x18/0xd7
> [  838.050005] Code: ff ff 8b 75 b8 39 75 b0 8b 45 c8 89 45 98 0f 84 e5 fe ff ff 45 8b 74 24 18 41 8b 54 24 1c e9 56 fc ff ff 85 c0 0f 85 48 ff ff ff <0f> 0b 48 8b 05 cf c3 de ff 48 ba 00 00 00 00 00 00 00 10 48 85
> [  838.050005] RIP  [<ffffffffa05e96a8>] __ocfs2_resv_find_window+0x498/0x760 [ocfs2]
> [  838.050005]  RSP <ffff8800ea4db668>
> [  838.202227] ---[ end trace 566f07529f2edf3c ]---
> [  838.204664] Kernel panic - not syncing: Fatal exception
> [  838.205656] Kernel Offset: disabled
> 
> Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
> ---
>  fs/ocfs2/localalloc.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
> index 7642b6712c39..755ec2aa2db0 100644
> --- a/fs/ocfs2/localalloc.c
> +++ b/fs/ocfs2/localalloc.c
> @@ -345,13 +345,18 @@ int ocfs2_load_local_alloc(struct ocfs2_super *osb)
>  	if (num_used
>  	    || alloc->id1.bitmap1.i_used
>  	    || alloc->id1.bitmap1.i_total
> -	    || la->la_bm_off)
> -		mlog(ML_ERROR, "Local alloc hasn't been recovered!\n"
> +	    || la->la_bm_off) {
> +		mlog(ML_ERROR, "inconsistent detected, clean journal with"
> +		     "unrecovered local alloc, please run fsck.ocfs2!\n"
>  		     "found = %u, set = %u, taken = %u, off = %u\n",
>  		     num_used, le32_to_cpu(alloc->id1.bitmap1.i_used),
>  		     le32_to_cpu(alloc->id1.bitmap1.i_total),
>  		     OCFS2_LOCAL_ALLOC(alloc)->la_bm_off);
>  
Could we try to recover local alloc with
ocfs2_begin_local_alloc_recovery() automatically if it's dirty? And fsck
seems a little heavy.

Thanks,
Jun

> +		status = -EINVAL;
> +		goto bail;
> +	}
> +
>  	osb->local_alloc_bh = alloc_bh;
>  	osb->local_alloc_state = OCFS2_LA_ENABLED;
>  
> 
