From: David Weber <wb@munzinger.de>
Date: Mon, 09 Sep 2013 11:47:03 +0200
Subject: [Ocfs2-devel] kernel BUG at fs/ocfs2/extent_map.c:475
Message-ID: <13260022.NHuOIcl04o@o3-3>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,

we use OCFS2 as VM Storage and ran into a problem yesterday. The host reported 
the following:

[Sun Sep  8 10:08:38 2013] ------------[ cut here ]------------
[Sun Sep  8 10:08:38 2013] kernel BUG at fs/ocfs2/extent_map.c:475!
[Sun Sep  8 10:08:38 2013] invalid opcode: 0000 [#1] SMP 
[Sun Sep  8 10:08:38 2013] Modules linked in: vhost_net vhost macvtap macvlan 
tun ebtable_nat ebtables ocfs2_stack_o2cb bridge stp llc w83795 coretemp 
kvm_intel kvm drbd lru_cache dlm sctp libcrc32c ocfs2_dlm ocfs2_dlmfs ocfs2 
ocfs2_stackglue ocfs2_nodemanager configfs e1000e ixgbe mdio
[Sun Sep  8 10:08:38 2013] CPU: 18 PID: 19181 Comm: qemu-system-x86 Not 
tainted 3.11.0-rc7 #3
[Sun Sep  8 10:08:38 2013] Hardware name: Supermicro X8DT6/X8DT6, BIOS 2.0b    
08/30/2011
[Sun Sep  8 10:08:38 2013] task: ffff882dc9dbbd80 ti: ffff882c71ba4000 task.ti: 
ffff882c71ba4000
[Sun Sep  8 10:08:38 2013] RIP: 0010:[<ffffffffa0157d2a>]  [<ffffffffa0157d2a>] 
ocfs2_get_clusters_nocache.isra.11+0x48a/0x510 [ocfs2]
[Sun Sep  8 10:08:38 2013] RSP: 0018:ffff882c71ba5728  EFLAGS: 00010297
[Sun Sep  8 10:08:38 2013] RAX: 0000000000000034 RBX: ffff882ce2bed030 RCX: 
0000000000006021
[Sun Sep  8 10:08:38 2013] RDX: ffff882ce2bed380 RSI: 0000000000006021 RDI: 
ffff882ce2bed030
[Sun Sep  8 10:08:38 2013] RBP: ffff882c71ba5798 R08: 0000000000006022 R09: 
0000000000000000
[Sun Sep  8 10:08:38 2013] R10: 000000000003fa1e R11: ffff882ce2bed000 R12: 
ffff882c71ba57d8
[Sun Sep  8 10:08:38 2013] R13: 0000000000006021 R14: ffff882e5c5a2000 R15: 
0000000000000000
[Sun Sep  8 10:08:38 2013] FS:  00007fb8cffff700(0000) GS:ffff88303fcc0000(0000) 
knlGS:0000000000000000
[Sun Sep  8 10:08:38 2013] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[Sun Sep  8 10:08:38 2013] CR2: 00000000c2e80000 CR3: 0000002b9d1c3000 CR4: 
00000000000027e0
[Sun Sep  8 10:08:38 2013] DR0: 0000000000000001 DR1: 0000000000000002 DR2: 
0000000000000001
[Sun Sep  8 10:08:38 2013] DR3: 000000000000000a DR6: 00000000ffff0ff0 DR7: 
0000000000000400
[Sun Sep  8 10:08:38 2013] Stack:
[Sun Sep  8 10:08:38 2013]  ffff882c71ba5828 ffff882c71ba57d0 ffff882ce2bed000 
ffff882c71ba57cc
[Sun Sep  8 10:08:38 2013]  ffff882cb2fb8a98 000000010060214a ffff882fd2d144e0 
ffffffffa0163346
[Sun Sep  8 10:08:38 2013]  0000000000000002 0000000000006021 ffff882cb2fb8a98 
ffff882c71ba58c4
[Sun Sep  8 10:08:38 2013] Call Trace:
[Sun Sep  8 10:08:38 2013]  [<ffffffffa0163346>] ? 
ocfs2_read_inode_block_full+0x36/0x60 [ocfs2]
[Sun Sep  8 10:08:38 2013]  [<ffffffffa01582b1>] ocfs2_get_clusters+0x221/0x390 
[ocfs2]
[Sun Sep  8 10:08:38 2013]  [<ffffffffa0158472>] 
ocfs2_extent_map_get_blocks+0x52/0x180 [ocfs2]
[Sun Sep  8 10:08:38 2013]  [<ffffffffa013c4a1>] 
ocfs2_direct_IO_get_blocks+0x51/0x140 [ocfs2]
[Sun Sep  8 10:08:38 2013]  [<ffffffff8117858e>] 
do_blockdev_direct_IO+0x118e/0x1fa0
[Sun Sep  8 10:08:38 2013]  [<ffffffff810f5b50>] ? pagevec_lookup_tag+0x20/0x30
[Sun Sep  8 10:08:38 2013]  [<ffffffffa013c450>] ? ocfs2_dio_end_io+0x100/0x100 
[ocfs2]
[Sun Sep  8 10:08:38 2013]  [<ffffffff811793f0>] __blockdev_direct_IO+0x50/0x60
[Sun Sep  8 10:08:38 2013]  [<ffffffffa013c450>] ? ocfs2_dio_end_io+0x100/0x100 
[ocfs2]
[Sun Sep  8 10:08:38 2013]  [<ffffffffa013c350>] ? ocfs2_direct_IO+0x80/0x80 
[ocfs2]
[Sun Sep  8 10:08:38 2013]  [<ffffffffa013c343>] ocfs2_direct_IO+0x73/0x80 [ocfs2]
[Sun Sep  8 10:08:38 2013]  [<ffffffffa013c450>] ? ocfs2_dio_end_io+0x100/0x100 
[ocfs2]
[Sun Sep  8 10:08:38 2013]  [<ffffffffa013c350>] ? ocfs2_direct_IO+0x80/0x80 
[ocfs2]
[Sun Sep  8 10:08:38 2013]  [<ffffffff810eb974>] generic_file_aio_read+0x664/0x6c0
[Sun Sep  8 10:08:38 2013]  [<ffffffffa015ae48>] ? 
ocfs2_should_update_atime+0x68/0x150 [ocfs2]
[Sun Sep  8 10:08:39 2013]  [<ffffffffa015160b>] ? 
__ocfs2_cluster_unlock.isra.40+0x9b/0xd0 [ocfs2]
[Sun Sep  8 10:08:39 2013]  [<ffffffffa015198a>] ? ocfs2_inode_unlock+0xaa/0x120 
[ocfs2]
[Sun Sep  8 10:08:39 2013]  [<ffffffffa015aaed>] ocfs2_file_aio_read+0xad/0x3a0 
[ocfs2]
[Sun Sep  8 10:08:39 2013]  [<ffffffff81029050>] ? 
native_smp_send_reschedule+0x40/0x60
[Sun Sep  8 10:08:39 2013]  [<ffffffff8113ef2e>] do_sync_readv_writev+0x6e/0xa0
[Sun Sep  8 10:08:39 2013]  [<ffffffff811402af>] do_readv_writev+0xcf/0x2b0
[Sun Sep  8 10:08:39 2013]  [<ffffffff8114051d>] vfs_readv+0x2d/0x50
[Sun Sep  8 10:08:39 2013]  [<ffffffff81140782>] SyS_preadv+0xc2/0xe0
[Sun Sep  8 10:08:39 2013]  [<ffffffff816b5ed2>] system_call_fastpath+0x16/0x1b
[Sun Sep  8 10:08:39 2013] Code: 00 02 00 00 49 c7 c0 30 27 1c a0 48 c7 c7 28 
ef 1c a0 31 c0 e8 5e b9 54 e1 e9 1e fd ff ff 0f 1f 00 bb 01 00 00 00 e9 78 fe ff 
ff <0f> 0b 48 8b 55 b0 48 c7 c6 50 27 1c a0 bb e2 ff ff ff 4c 8b 47 
[Sun Sep  8 10:08:39 2013] RIP  [<ffffffffa0157d2a>] 
ocfs2_get_clusters_nocache.isra.11+0x48a/0x510 [ocfs2]
[Sun Sep  8 10:08:39 2013]  RSP <ffff882c71ba5728>
[Sun Sep  8 10:08:39 2013] ---[ end trace aa04b37eb9874cc8 ]---

Unformatted:
https://gist.github.com/David-Weber/c16e34cca09b1cfe9b10

Starting at this point, the guest had many read and write problems but not all 
of them failed. Restarting the process resolved the problem. The guest is a 
simple Windows Server 2003 which shouldn't do any fancy IO-operations.

This only happens once so far, so I don't have a simple reproducer.

Cheers,
David
