From: Vincent ETIENNE <vetienne@aprogsys.com>
Date: Fri, 27 Jul 2012 22:18:38 -0000
Subject: [Ocfs2-devel] kernel BUG at fs/buffer.c:2886! Linux 3.5.0
Message-ID: <501313B6.70801@aprogsys.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, ocfs2-devel@oss.oracle.com

Hello

Get this on first write made ( by deliver sending mail to inform of the
restart of services  )
Home partition (the one receiving the mail) is based on ocfs2 created
from drbd block device in primary/primary mode
These drbd devices are based on lvm.

system is running linux-3.5.0, identical symptom with linux 3.3 and 3.2
but working with linux 3.0 kernel

reproduced on two machines ( so different hardware involved on this one
software md raid on SATA, on second one areca hardware raid card )
but the 2 machines are the one sharing this partition ( so share the
same data )


Jul 27 23:41:41 jupiter2 postfix/qmgr[4400]: D12661C487:
from=<root@aprogsys.com>, size=388, nrcpt=1 (queue active)
Jul 27 23:41:41 jupiter2 postfix/qmgr[4400]: D0AEE1C01F:
from=<root@aprogsys.com>, size=401, nrcpt=1 (queue active)
Jul 27 23:41:41 jupiter2 postfix/qmgr[4400]: DD5D91BFE9:
from=<root@aprogsys.com>, size=393, nrcpt=1 (queue active)
Jul 27 23:41:41 jupiter2 postfix/qmgr[4400]: A705B1BFDC:
from=<root@aprogsys.com>, size=395, nrcpt=1 (queue active)
Jul 27 23:41:41 jupiter2 postfix/qmgr[4400]: B6AB41C48C:
from=<root@aprogsys.com>, size=388, nrcpt=1 (queue active)
Jul 27 23:41:41 jupiter2 postfix/qmgr[4400]: 8DAE11C48F:
from=<root@aprogsys.com>, size=382, nrcpt=1 (queue active)
Jul 27 23:41:41 jupiter2 postfix/qmgr[4400]: 715241C489:
from=<root@aprogsys.com>, size=380, nrcpt=1 (queue active)
Jul 27 23:41:41 jupiter2 postfix/qmgr[4400]: F18601C024:
from=<root@aprogsys.com>, size=401, nrcpt=1 (queue active)
Jul 27 23:41:41 jupiter2 kernel: [  351.169213] ------------[ cut here
]------------
Jul 27 23:41:41 jupiter2 kernel: [  351.169261] kernel BUG at
fs/buffer.c:2886!
Jul 27 23:41:41 jupiter2 kernel: [  351.169303] invalid opcode: 0000
[#1] SMP
Jul 27 23:41:41 jupiter2 kernel: [  351.169409] CPU 1
Jul 27 23:41:41 jupiter2 kernel: [  351.169446] Modules linked in: drbd
lru_cache
Jul 27 23:41:41 jupiter2 kernel: [  351.169620]
Jul 27 23:41:41 jupiter2 kernel: [  351.169655] Pid: 5783, comm: deliver
Not tainted 3.5.0-gentoo #2 HP ProLiant ML150 G3/ML150 G3
Jul 27 23:41:41 jupiter2 kernel: [  351.169803] RIP:
0010:[<ffffffff81180862>]  [<ffffffff81180862>] submit_bh+0x112/0x120
Jul 27 23:41:41 jupiter2 kernel: [  351.169889] RSP:
0018:ffff8800574c7b38  EFLAGS: 00010246
Jul 27 23:41:41 jupiter2 kernel: [  351.169932] RAX: 4000000001000004
RBX: ffffea0001791ac0 RCX: 00000003ffffffff
Jul 27 23:41:41 jupiter2 kernel: [  351.169978] RDX: 0000000000000001
RSI: ffffea0001791ac0 RDI: 0000000000000000
Jul 27 23:41:41 jupiter2 kernel: [  351.170003] RBP: 0000000000000000
R08: 0000000000000000 R09: ffffffff81346ad0
Jul 27 23:41:41 jupiter2 kernel: [  351.170003] R10: dead000000200200
R11: 0000000000000000 R12: 0000000004cc4789
Jul 27 23:41:41 jupiter2 kernel: [  351.170003] R13: 00000003ffffffff
R14: 0000000000000000 R15: 0000000000000000
Jul 27 23:41:41 jupiter2 kernel: [  351.170003] FS: 
00007ff70e943700(0000) GS:ffff88007fd00000(0000) knlGS:0000000000000000
Jul 27 23:41:41 jupiter2 kernel: [  351.170003] CS:  0010 DS: 0000 ES:
0000 CR0: 000000008005003b
Jul 27 23:41:41 jupiter2 kernel: [  351.170003] CR2: 00007fb4968f6b6c
CR3: 000000005fe8a000 CR4: 00000000000007e0
Jul 27 23:41:41 jupiter2 kernel: [  351.170003] DR0: 0000000000000000
DR1: 0000000000000000 DR2: 0000000000000000
Jul 27 23:41:41 jupiter2 kernel: [  351.170003] DR3: 0000000000000000
DR6: 00000000ffff0ff0 DR7: 0000000000000400
Jul 27 23:41:41 jupiter2 kernel: [  351.170003] Process deliver (pid:
5783, threadinfo ffff8800574c6000, task ffff88007b8fad00)
Jul 27 23:41:41 jupiter2 kernel: [  351.170003] Stack:
Jul 27 23:41:41 jupiter2 kernel: [  351.170003]  ffffea0001791ac0
0000000000000001 0000000004cc4789 ffffffff81327546
Jul 27 23:41:41 jupiter2 kernel: [  351.170003]  000000005893c5b8
ffffffff8114e541 ffff88007b8fb368 ffff8800574c7c10
Jul 27 23:41:41 jupiter2 kernel: [  351.170003]  0000000000000000
0000000100000000 ffff8800589236f0 ffff88005bac4000
Jul 27 23:41:41 jupiter2 kernel: [  351.170003] Call Trace:
Jul 27 23:41:41 jupiter2 kernel: [  351.170003]  [<ffffffff81327546>] ?
ocfs2_read_blocks+0x176/0x6c0
Jul 27 23:41:41 jupiter2 kernel: [  351.170003]  [<ffffffff8114e541>] ?
T.1552+0x91/0x2b0
Jul 27 23:41:41 jupiter2 kernel: [  351.170003]  [<ffffffff81346ad0>] ?
ocfs2_find_actor+0x120/0x120
Jul 27 23:41:41 jupiter2 kernel: [  351.170003]  [<ffffffff813464f7>] ?
ocfs2_read_inode_block_full+0x37/0x60
Jul 27 23:41:41 jupiter2 kernel: [  351.170003]  [<ffffffff813964ff>] ?
ocfs2_fast_symlink_readpage+0x2f/0x160
Jul 27 23:41:41 jupiter2 kernel: [  351.170003]  [<ffffffff81111585>] ?
do_read_cache_page+0x85/0x180
Jul 27 23:41:41 jupiter2 kernel: [  351.170003]  [<ffffffff813964d0>] ?
ocfs2_fill_super+0x2500/0x2500
Jul 27 23:41:41 jupiter2 kernel: [  351.170003]  [<ffffffff811116d9>] ?
read_cache_page+0x9/0x20
Jul 27 23:41:41 jupiter2 kernel: [  351.170003]  [<ffffffff8115c705>] ?
page_getlink+0x25/0x80
Jul 27 23:41:41 jupiter2 kernel: [  351.170003]  [<ffffffff8115c77b>] ?
page_follow_link_light+0x1b/0x30
Jul 27 23:41:41 jupiter2 kernel: [  351.170003]  [<ffffffff8116099b>] ?
path_lookupat+0x38b/0x720
Jul 27 23:41:41 jupiter2 kernel: [  351.170003]  [<ffffffff81160d5c>] ?
do_path_lookup+0x2c/0xd0
Jul 27 23:41:41 jupiter2 kernel: [  351.170003]  [<ffffffff81346f31>] ?
ocfs2_inode_revalidate+0x71/0x160
Jul 27 23:41:41 jupiter2 kernel: [  351.170003]  [<ffffffff81161c0c>] ?
user_path_at_empty+0x5c/0xb0
Jul 27 23:41:41 jupiter2 kernel: [  351.170003]  [<ffffffff8106714a>] ?
do_page_fault+0x1aa/0x3c0
Jul 27 23:41:41 jupiter2 kernel: [  351.170003]  [<ffffffff81156f2d>] ?
cp_new_stat+0x10d/0x120
Jul 27 23:41:41 jupiter2 kernel: [  351.170003]  [<ffffffff81157021>] ?
vfs_fstatat+0x41/0x80
Jul 27 23:41:41 jupiter2 kernel: [  351.170003]  [<ffffffff8115715f>] ?
sys_newstat+0x1f/0x50
Jul 27 23:41:41 jupiter2 kernel: [  351.170003]  [<ffffffff817ecee2>] ?
system_call_fastpath+0x16/0x1b
Jul 27 23:41:41 jupiter2 kernel: [  351.170003] Code: b6 44 24 18 4c 89
e7 83 e0 80 3c 01 19 db e8 76 3f 00 00 f7 d3 83 e3 a1 89 d8 5b 5d 41 5c
c3 0f 0b eb fe 0f 0b eb fe 0f 0$
Jul 27 23:41:41 jupiter2 kernel: [  351.170003] RIP 
[<ffffffff81180862>] submit_bh+0x112/0x120
Jul 27 23:41:41 jupiter2 kernel: [  351.170003]  RSP <ffff8800574c7b38>
Jul 27 23:41:41 jupiter2 kernel: [  351.177405] ---[ end trace
e1e88bdf12146104 ]---
Jul 27 23:41:41 jupiter2 kernel: [  351.177868] deliver (5783) used
greatest stack depth: 3032 bytes left

Regards,

    Vincent ETIENNE
