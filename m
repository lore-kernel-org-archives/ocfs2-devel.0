From: Joseph Qi <joseph.qi@huawei.com>
Date: Thu, 17 Mar 2016 17:22:15 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: o2hb: fix double free bug
In-Reply-To: <1458201042-11783-1-git-send-email-junxiao.bi@oracle.com>
References: <1458201042-11783-1-git-send-email-junxiao.bi@oracle.com>
Message-ID: <56EA7747.5050805@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Junxiao,
Thanks for pointing out this. I meant to free hr_db_*, which leaked.
Sorry for my mistake.

Reviewed-by: Joseph Qi <joseph.qi@huawei.com>

On 2016/3/17 15:50, Junxiao Bi wrote:
> This is a regression issue and caused the following kernel panic
> when do ocfs2 multiple test.
> 
> [  254.604228] BUG: unable to handle kernel paging request at
> 00000002000800c0
> [  254.605013] IP: [<ffffffff81192978>] kmem_cache_alloc+0x78/0x160
> [  254.605013] PGD 7bbe5067 PUD 0
> [  254.605013] Oops: 0000 [#1] SMP
> [  254.605013] Modules linked in: ocfs2_dlmfs ocfs2_stack_o2cb ocfs2_dlm
> ocfs2_nodemanager ocfs2_stackglue iscsi_tcp libiscsi_tcp libiscsi
> scsi_transport_iscsi xen_kbdfront xen_netfront xen_fbfront xen_blkfront
> [  254.605013] CPU: 2 PID: 4044 Comm: mpirun Not tainted
> 4.5.0-rc5-next-20160225 #1
> [  254.605013] Hardware name: Xen HVM domU, BIOS 4.3.1OVM 05/14/2014
> [  254.605013] task: ffff88007a521a80 ti: ffff88007aed0000 task.ti:
> ffff88007aed0000
> [  254.605013] RIP: 0010:[<ffffffff81192978>]  [<ffffffff81192978>]
> kmem_cache_alloc+0x78/0x160
> [  254.605013] RSP: 0018:ffff88007aed3a48  EFLAGS: 00010282
> [  254.605013] RAX: 0000000000000000 RBX: 0000000000000000 RCX:
> 0000000000001991
> [  254.605013] RDX: 0000000000001990 RSI: 00000000024000c0 RDI:
> 000000000001b330
> [  254.605013] RBP: ffff88007aed3a98 R08: ffff88007d29b330 R09:
> 00000002000800c0
> [  254.605013] R10: 0000000c51376d87 R11: ffff8800792cac38 R12:
> ffff88007cc30f00
> [  254.605013] R13: 00000000024000c0 R14: ffffffff811b053f R15:
> ffff88007aed3ce7
> [  254.605013] FS:  0000000000000000(0000) GS:ffff88007d280000(0000)
> knlGS:0000000000000000
> [  254.605013] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  254.605013] CR2: 00000002000800c0 CR3: 000000007aeb2000 CR4:
> 00000000000406e0
> [  254.605013] Stack:
> [  254.605013]  0000000013082000 ffff88007aed3d28 0000007900000000
> 0000000000000001
> [  254.605013]  2f2f2f2f00000000 ffff8800792cac00 ffff88007aed3d38
> 0000000000000101
> [  254.605013]  ffff88007a5e2000 ffff88007aed3ce7 ffff88007aed3b08
> ffffffff811b053f
> [  254.605013] Call Trace:
> [  254.605013]  [<ffffffff811b053f>] __d_alloc+0x2f/0x1a0
> [  254.605013]  [<ffffffff811a58f2>] ? unlazy_walk+0xe2/0x160
> [  254.605013]  [<ffffffff811b1c67>] d_alloc+0x17/0x80
> [  254.605013]  [<ffffffff811a5b0a>] lookup_dcache+0x8a/0xc0
> [  254.605013]  [<ffffffff81143e63>] ? __alloc_pages_nodemask+0x173/0xeb0
> [  254.605013]  [<ffffffff811aa523>] path_openat+0x3c3/0x1210
> [  254.605013]  [<ffffffff81354eb3>] ? radix_tree_lookup_slot+0x13/0x30
> [  254.605013]  [<ffffffff81139002>] ? find_get_entry+0x32/0xc0
> [  254.605013]  [<ffffffff811b4065>] ? atime_needs_update+0x55/0xe0
> [  254.605013]  [<ffffffff8113b7a1>] ? filemap_fault+0xd1/0x4b0
> [  254.605013]  [<ffffffff81168296>] ? do_set_pte+0xb6/0x140
> [  254.605013]  [<ffffffff811ab3f0>] do_filp_open+0x80/0xe0
> [  254.605013]  [<ffffffff811b7c48>] ? __alloc_fd+0x48/0x1a0
> [  254.605013]  [<ffffffff811a60aa>] ? getname_flags+0x7a/0x1e0
> [  254.605013]  [<ffffffff8119a2d0>] do_sys_open+0x110/0x200
> [  254.605013]  [<ffffffff8119a3f9>] SyS_open+0x19/0x20
> [  254.605013]  [<ffffffff81003ec2>] do_syscall_64+0x72/0x230
> [  254.605013]  [<ffffffff8105fc37>] ? __do_page_fault+0x177/0x430
> [  254.605013]  [<ffffffff8193bc61>] entry_SYSCALL64_slow_path+0x25/0x25
> [  254.605013] Code: 05 e6 77 e7 7e 4d 8b 08 49 8b 40 10 4d 85 c9 0f 84
> dd 00 00 00 48 85 c0 0f 84 d4 00 00 00 49 63 44 24 20 49 8b 3c 24 48 8d
> 4a 01 <49> 8b 1c 01 4c 89 c8 65 48 0f c7 0f 0f 94 c0 3c 01 75 b6 49 63
> [  254.605013] RIP  [<ffffffff81192978>] kmem_cache_alloc+0x78/0x160
> [  254.605013]  RSP <ffff88007aed3a48>
> [  254.605013] CR2: 00000002000800c0
> [  254.792273] ---[ end trace 823969e602e4aaac ]---
> 
> Fixes: a4a1dfa4bb8b("ocfs2/cluster: fix memory leak in o2hb_region_release")
> Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
> ---
>  fs/ocfs2/cluster/heartbeat.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
> index ef6a2ec494de..bd15929b5f92 100644
> --- a/fs/ocfs2/cluster/heartbeat.c
> +++ b/fs/ocfs2/cluster/heartbeat.c
> @@ -1444,8 +1444,8 @@ static void o2hb_region_release(struct config_item *item)
>  	debugfs_remove(reg->hr_debug_dir);
>  	kfree(reg->hr_db_livenodes);
>  	kfree(reg->hr_db_regnum);
> -	kfree(reg->hr_debug_elapsed_time);
> -	kfree(reg->hr_debug_pinned);
> +	kfree(reg->hr_db_elapsed_time);
> +	kfree(reg->hr_db_pinned);
>  
>  	spin_lock(&o2hb_live_lock);
>  	list_del(&reg->hr_all_item);
> 
