From: David Weber <wb@munzinger.de>
Date: Mon, 21 Oct 2013 09:53:59 +0200
Subject: [Ocfs2-devel] Kernel BUG in ocfs2_get_clusters_nocache
Message-ID: <2812615.QN6T85VrH8@o3-3>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,

we ran into a BUG() in ocfs2_get_clusters_nocache:

[Fri Oct 18 10:52:28 2013] ------------[ cut here ]------------
[Fri Oct 18 10:52:28 2013] Kernel BUG at ffffffffa028ad5a [verbose debug info 
unavailable]
[Fri Oct 18 10:52:28 2013] invalid opcode: 0000 [#1] SMP 
[Fri Oct 18 10:52:28 2013] Modules linked in: vhost_net vhost macvtap macvlan 
drbd ip6table_filter ip6_tables iptable_filter ip_tables ebtable_nat ebtables 
x_tables ocfs2_stack_o2cb rpcsec_gss_krb5 auth_rpcgss nfsv4 nfs lockd fscache 
sunrpc bridge stp llc w83795 coretemp kvm_intel kvm lru_cache dlm sctp 
libcrc32c ocfs2_dlm ocfs2_dlmfs ocfs2 ocfs2_stackglue ocfs2_nodemanager 
configfs quota_tree snd_pcm e1000e snd_page_alloc snd_timer ixgbe snd joydev 
hid_generic usbmouse usbkbd psmouse usbhid soundcore iTCO_wdt i7core_edac 
ioatdma gpio_ich hid ptp edac_core iTCO_vendor_support i2c_i801 pcspkr mac_hid 
lpc_ich serio_raw ses mdio enclosure pps_core dca [last unloaded: evbug]
[Fri Oct 18 10:52:28 2013] CPU: 3 PID: 16938 Comm: qemu-system-x86 Tainted: G        
W    3.11.4 #1
[Fri Oct 18 10:52:28 2013] Hardware name: Supermicro X8DT6/X8DT6, BIOS 2.0c    
05/15/2012
[Fri Oct 18 10:52:28 2013] task: ffff880c69b62ee0 ti: ffff88130978e000 task.ti: 
ffff88130978e000
[Fri Oct 18 10:52:28 2013] RIP: 0010:[<ffffffffa028ad5a>]  [<ffffffffa028ad5a>] 
ocfs2_get_clusters_nocache.isra.11+0x4aa/0x530 [ocfs2]
[Fri Oct 18 10:52:28 2013] RSP: 0018:ffff88130978f708  EFLAGS: 00010297
[Fri Oct 18 10:52:28 2013] RAX: 00000000000000fa RBX: 0000000000000000 RCX: 
000000000012cbd4
[Fri Oct 18 10:52:28 2013] RDX: ffff880868180fe0 RSI: 000000000012cbd3 RDI: 
ffff880868180030
[Fri Oct 18 10:52:28 2013] RBP: ffff88130978f788 R08: 000000000012cbd4 R09: 
00000000000000fc
[Fri Oct 18 10:52:28 2013] R10: 0000000000000000 R11: 0000000000000000 R12: 
ffff88130978f7c8
[Fri Oct 18 10:52:28 2013] R13: ffff880868180030 R14: ffff88176cc7a000 R15: 
0000000000000000
[Fri Oct 18 10:52:28 2013] FS:  00007f32c4ff9700(0000) GS:ffff8817dfc60000(0000) 
knlGS:0000000000000000
[Fri Oct 18 10:52:28 2013] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[Fri Oct 18 10:52:28 2013] CR2: 00007f34f4074000 CR3: 0000002c5d211000 CR4: 
00000000000027e0
[Fri Oct 18 10:52:28 2013] DR0: 0000000000000001 DR1: 0000000000000002 DR2: 
0000000000000001
[Fri Oct 18 10:52:28 2013] DR3: 000000000000000a DR6: 00000000ffff0ff0 DR7: 
0000000000000400
[Fri Oct 18 10:52:28 2013] Stack:
[Fri Oct 18 10:52:28 2013]  ffff881300000000 0000000000000000 ffff88130978f7e4 
ffff880868180000
[Fri Oct 18 10:52:28 2013]  ffff882fb66ded80 0012cbd300000001 ffff88130978f8d4 
ffff8808ef23f270
[Fri Oct 18 10:52:28 2013]  ffff88130978f778 ffffffffa02969fb ffff8817dfc545b0 
0000000000000000
[Fri Oct 18 10:52:28 2013] Call Trace:
[Fri Oct 18 10:52:28 2013]  [<ffffffffa02969fb>] ? 
ocfs2_read_inode_block_full+0x3b/0x60 [ocfs2]
[Fri Oct 18 10:52:28 2013]  [<ffffffffa028b2be>] ocfs2_get_clusters+0x23e/0x3b0 
[ocfs2]
[Fri Oct 18 10:52:28 2013]  [<ffffffff8109a9ad>] ? sched_clock_cpu+0xbd/0x110
[Fri Oct 18 10:52:28 2013]  [<ffffffffa028b48a>] 
ocfs2_extent_map_get_blocks+0x5a/0x190 [ocfs2]
[Fri Oct 18 10:52:28 2013]  [<ffffffffa026eb3a>] 
ocfs2_direct_IO_get_blocks+0x5a/0x160 [ocfs2]
[Fri Oct 18 10:52:28 2013]  [<ffffffff811c87c1>] ? inode_dio_done+0x31/0x40
[Fri Oct 18 10:52:28 2013]  [<ffffffff811ea90c>] 
do_blockdev_direct_IO+0xdfc/0x1fb0
[Fri Oct 18 10:52:28 2013]  [<ffffffffa026eae0>] ? ocfs2_dio_end_io+0x110/0x110 
[ocfs2]
[Fri Oct 18 10:52:28 2013]  [<ffffffff811ebb15>] __blockdev_direct_IO+0x55/0x60
[Fri Oct 18 10:52:28 2013]  [<ffffffffa026eae0>] ? ocfs2_dio_end_io+0x110/0x110 
[ocfs2]
[Fri Oct 18 10:52:28 2013]  [<ffffffffa026e9d0>] ? ocfs2_direct_IO+0x80/0x80 
[ocfs2]
[Fri Oct 18 10:52:28 2013]  [<ffffffffa026e9c3>] ocfs2_direct_IO+0x73/0x80 [ocfs2]
[Fri Oct 18 10:52:28 2013]  [<ffffffffa026eae0>] ? ocfs2_dio_end_io+0x110/0x110 
[ocfs2]
[Fri Oct 18 10:52:28 2013]  [<ffffffffa026e9d0>] ? ocfs2_direct_IO+0x80/0x80 
[ocfs2]
[Fri Oct 18 10:52:28 2013]  [<ffffffff81146e2b>] generic_file_aio_read+0x6bb/0x720
[Fri Oct 18 10:52:28 2013]  [<ffffffff8172168e>] ? _raw_spin_lock+0xe/0x20
[Fri Oct 18 10:52:28 2013]  [<ffffffffa02843db>] ? 
__ocfs2_cluster_unlock.isra.32+0x9b/0xe0 [ocfs2]
[Fri Oct 18 10:52:28 2013]  [<ffffffffa02847a9>] ? ocfs2_inode_unlock+0xb9/0x130 
[ocfs2]
[Fri Oct 18 10:52:28 2013]  [<ffffffffa028dcf9>] ocfs2_file_aio_read+0xd9/0x3c0 
[ocfs2]
[Fri Oct 18 10:52:28 2013]  [<ffffffff811ae425>] do_sync_readv_writev+0x65/0x90
[Fri Oct 18 10:52:28 2013]  [<ffffffff811afba2>] do_readv_writev+0xd2/0x2b0
[Fri Oct 18 10:52:28 2013]  [<ffffffff811eeda2>] ? fsnotify+0x1d2/0x2b0
[Fri Oct 18 10:52:28 2013]  [<ffffffff811ae500>] ? do_sync_write+0xb0/0xb0
[Fri Oct 18 10:52:28 2013]  [<ffffffff811f8886>] ? eventfd_write+0x1a6/0x210
[Fri Oct 18 10:52:28 2013]  [<ffffffff811afe09>] vfs_readv+0x39/0x50
[Fri Oct 18 10:52:28 2013]  [<ffffffff811b0062>] SyS_preadv+0xc2/0xd0
[Fri Oct 18 10:52:28 2013]  [<ffffffff8172a59d>] system_call_fastpath+0x1a/0x1f
[Fri Oct 18 10:52:28 2013] Code: b9 00 02 00 00 49 c7 c0 f0 8d 2f a0 48 c7 c7 
b8 28 30 a0 e8 82 b1 48 e1 e9 07 fd ff ff 0f 1f 40 00 bb 01 00 00 00 e9 68 fe ff 
ff <0f> 0b 48 8b 55 a0 48 c7 c6 10 8e 2f a0 bb e2 ff ff ff 4c 8b 47 
[Fri Oct 18 10:52:28 2013] RIP  [<ffffffffa028ad5a>] 
ocfs2_get_clusters_nocache.isra.11+0x4aa/0x530 [ocfs2]
[Fri Oct 18 10:52:28 2013]  RSP <ffff88130978f708>
[Fri Oct 18 10:52:28 2013] ---[ end trace 1831bd3aefe19b02 ]---

https://gist.github.com/David-Weber/f3072dd5c44a6ce593b6

(gdb) list *(ocfs2_get_clusters_nocache+0x4aa)
0xa6a is in ocfs2_get_clusters_nocache (fs/ocfs2/extent_map.c:475).
470                     goto out_hole;
471             }
472
473             rec = &el->l_recs[i];
474
475             BUG_ON(v_cluster < le32_to_cpu(rec->e_cpos));
476
477             if (!rec->e_blkno) {
478                     ocfs2_error(inode->i_sb, "Inode %lu has bad extent "
479                                 "record (%u, %u, 0)", inode->i_ino,

This happend the second time but I don't have a reproducer.
It is a KVM host with a dual Primary DRBD/OCFS2 System.
Kernel is 3.11.4

Thanks!

Cheers,
David
