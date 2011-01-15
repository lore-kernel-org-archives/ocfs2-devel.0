From: Nick Piggin <npiggin@gmail.com>
Date: Sun, 16 Jan 2011 05:16:40 +1100
Subject: [Ocfs2-devel] vfs-scale, nd->inode after __do_follow_link()
In-Reply-To: <4D30F66A.7060007@kernel.org>
References: <7352.1294971049@jrobl>
	<AANLkTinXPOSxHPtffqe3m5MWppDfr6kFVMsd6k7-dkic@mail.gmail.com>
	<20110114052813.GZ19804@ZenIV.linux.org.uk>
	<AANLkTi=pzFGHyFDYM_qvabODdKn8gDvRjjo_nbPfcT=q@mail.gmail.com>
	<AANLkTik=7x9o3s_TeVAACjNachLE7zyrbqyOeBBiE-v5@mail.gmail.com>
	<4D30DD6C.4010507@kernel.org> <4D30F66A.7060007@kernel.org>
Message-ID: <AANLkTin+FM6BHPkjneno59PzWdOg6jcSeD4TWYP+F=6v@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Sat, Jan 15, 2011 at 12:20 PM, J.H. <warthog9@kernel.org> wrote:
> Nick,
>
> Just thought I'd let you know - with, or without, the vfs-scale code
> that you've got I'm getting this:
>
> [ ?472.666054] ------------[ cut here ]------------
> [ ?472.670724] kernel BUG at fs/dcache.c:1358!
> [ ?472.674944] invalid opcode: 0000 [#1] SMP
> [ ?472.679112] last sysfs file:
> /sys/devices/system/cpu/cpu15/cache/index2/shared_cpu_map
> [ ?472.687105] last /proc..net open: ?/proc/7687/net/route
> [ ?472.695829] last /proc..net close: /proc/7687/net/route
> [ ?472.704490] CPU 0
> [ ?472.706361] Modules linked in: ocfs2 mptctl mptbase ipmi_devintf drbd
> lru_cache nfsd lockd nfs_acl auth_rpcgss sunrpc ocfs2_dlmfs
> ocfs2_stack_o2cb ocfs2_dlm ocfs2_nodemanager ocfs2_stackglue configfs
> 8021q garp stp llc ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6
> ip6table_filter ip6_tables ipv6 xfs exportfs serio_raw iTCO_wdt bnx2
> microcode hpwdt iTCO_vendor_support ipmi_si power_meter ipmi_msghandler
> pcspkr hpilo i7core_edac edac_core shpchp hpsa radeon ttm drm_kms_helper
> drm i2c_algo_bit i2c_core [last unloaded: speedstep_lib]
> [ ?472.776643]
> [ ?472.782039] Pid: 2716, comm: httpd Tainted: G ? ? ? ?W ? 2.6.37+ #4
> /ProLiant DL380 G6
> [ ?472.793922] RIP: 0010:[<ffffffff8113ed85>] ?[<ffffffff8113ed85>]
> d_set_d_op+0x13/0x5e
> [ ?472.793931] RSP: 0018:ffff8807d4f87c08 ?EFLAGS: 00010282
> [ ?472.793933] RAX: 0000000000000000 RBX: 0000000000000000 RCX:
> 0000000000000000
> [ ?472.793936] RDX: 0000000000000246 RSI: ffffffffa04dc880 RDI:
> ffff8803cf7bcbd0
> [ ?472.793939] RBP: ffff8807d4f87c08 R08: ffffffffa0491049 R09:
> 0000000000000001
> [ ?472.793942] R10: ffff8803fc70c778 R11: ffff880700000000 R12:
> ffff8803cf737000
> [ ?472.793945] R13: ffff8803cb822120 R14: ffff8803cb821460 R15:
> ffff8803cf7bcbd0
> [ ?472.793949] FS: ?00002b86adeee660(0000) GS:ffff8800dd400000(0000)
> knlGS:0000000000000000
> [ ?472.793952] CS: ?0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ ?472.793955] CR2: 00002b86ad2c4888 CR3: 00000007d4f75000 CR4:
> 00000000000006f0
> [ ?472.793958] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> 0000000000000000
> [ ?472.793961] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
> 0000000000000400
> [ ?472.793964] Process httpd (pid: 2716, threadinfo ffff8807d4f86000,
> task ffff8807d4e723b0)
> [ ?472.793967] Stack:
> [ ?472.793968] ?ffff8807d4f87d28 ffffffffa04aac62 ffff8803ddabfe30
> ffff8803cb820e78
> [ ?472.793973] ?ffff8803fbc38000 ffff8803cb820ee8 00000000a0491177
> ffff8803f36cd000
> [ ?472.793978] ?00008000d4f87c98 ffff8803fbc38000 ffff8803cf727d90
> 0000000000000000
> [ ?472.793983] Call Trace:
> [ ?472.794010] ?[<ffffffffa04aac62>] ocfs2_mknod+0xb0f/0xd3e [ocfs2]
> [ ?472.794032] ?[<ffffffffa04aaeb9>] ocfs2_create+0x13/0x15 [ocfs2]
> [ ?472.794036] ?[<ffffffff811392b7>] vfs_create+0x70/0x92
> [ ?472.794041] ?[<ffffffff81139fdc>] do_last+0x163/0x2e0
> [ ?472.794045] ?[<ffffffff8113a460>] do_filp_open+0x307/0x6f1
> [ ?472.794050] ?[<ffffffff81145394>] ? alloc_fd+0x3b/0x193
> [ ?472.794055] ?[<ffffffff81082e33>] ? lock_release+0x19a/0x1a6
> [ ?472.794059] ?[<ffffffff811454da>] ? alloc_fd+0x181/0x193
> [ ?472.794063] ?[<ffffffff8112d1f6>] do_sys_open+0x60/0xf2
> [ ?472.794068] ?[<ffffffff814a7aef>] ? trace_hardirqs_on_thunk+0x3a/0x3f
> [ ?472.794072] ?[<ffffffff8112d2a8>] sys_open+0x20/0x22
> [ ?472.794077] ?[<ffffffff8100ac42>] system_call_fastpath+0x16/0x1b
> [ ?472.794079] Code: a9 ff 03 00 00 74 08 81 0b 80 00 00 00 eb 06 81 23
> 7f ff ff ff 5b c9 c3 55 48 89 e5 0f 1f 44 00 00 48 83 bf a8 00 00 00 00
> 74 02 <0f> 0b 8b 07 f6 c4 f0 74 02 0f 0b 48 85 f6 48 89 b7 a8 00 00 00
> [ ?472.794112] RIP ?[<ffffffff8113ed85>] d_set_d_op+0x13/0x5e
> [ ?472.794116] ?RSP <ffff8807d4f87c08>
> [ ?472.794387] ---[ end trace 04b2ab2cb7dc3150 ]---
>
> I only mention this as the ocfs2 folks suggested running your code might
> solve that problem. ?That said I'm going to punt this back over to the
> ocfs2 folks for further review, as the bug makes ocfs2 completely
> unusable on 2.6.37+

Oh this is the d_set_d_op thing again. Linus has changed that to a
WARN_ON_ONCE upstream now rather than BUG_ON now (which
in hindsight is how it should have first looked). So that will get you
going again. Thanks for testing and reporting it.

The underlying problem is not a new one, but race is very slim, so
a warning rather than BUG is appropriate.
