From: Eugene Istomin <E.Istomin@edss.ee>
Date: Tue, 19 Feb 2013 14:37:30 +0200
Subject: [Ocfs2-devel] kernel BUG at
	kernel-xen-3.7.9/linux-3.7/fs/buffer.c:2952
Message-ID: <10987997.csxPHvlQTV@eistomin.users.edss.local>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hello,

we have a bug on any xen kernel > 3.4 like this:


 kernel BUG at /home/abuild/rpmbuild/BUILD/kernel-
xen-3.7.9/linux-3.7/fs/buffer.c:2952!
[  628.054552] invalid opcode: 0000 [#1] SMP 
[  628.054557] Modules linked in: bridge stp llc iptable_filter ip_tables 
x_tables nbd blktap2 pciback usbbk xen_scsibk openvswitch blkbk 
blkback_pagemap netbk xenbus_be gntdev evtchn ocfs2_dlmfs ocfs2_stack_o2cb 
ocfs2_dlm bonding af_packet edd ocfs2 ocfs2_nodemanager configfs 
ocfs2_stackglue quota_tree coretemp domctl crc32c_intel ghash_clmulni_intel 
joydev iTCO_wdt aesni_intel iTCO_vendor_support ablk_helper cryptd lrw 
aes_x86_64 hid_generic gpio_ich xts gf128mul 8250_core pcspkr serio_raw igb 
ixgbe lpc_ich mfd_core i2c_i801 serial_core usbhid sg i7core_edac ioatdma ptp 
pps_core edac_core hid mdio ses enclosure button uhci_hcd mgag200 ttm 
drm_kms_helper drm i2c_algo_bit sysimgblt sysfillrect i2c_core syscopyarea 
ehci_hcd usbcore usb_common processor thermal_sys hwmon scsi_dh_alua 
scsi_dh_hp_sw scsi_dh_emc scsi_dh_rdac scsi_dh xenblk cdrom xennet ata_generic 
ata_piix megaraid_sas
[  628.054664] CPU 2 
[  628.054669] Pid: 5601, comm: mc Not tainted 3.7.9-27-xen #1 Supermicro 
X8DTN+-F/X8DTN+-F
[  628.054674] RIP: e030:[<ffffffff801646da>]  [<ffffffff801646da>] 
submit_bh+0x14a/0x1d0
[  628.054686] RSP: e02b:ffff8800ed483c88  EFLAGS: 00010246
[  628.054690] RAX: 4000000001000004 RBX: ffff8800fd3d8260 RCX: 00000003ffffffff
[  628.054694] RDX: 0000000000000001 RSI: ffff8800fd3d8260 RDI: 0000000000000000
[  628.054698] RBP: ffff8800fd3d8260 R08: 0000000000000000 R09: ffffffffa04c3420
[  628.054702] R10: 00000000000009e7 R11: 0000000000000000 R12: 00000003ffffffff
[  628.054705] R13: 4000000000000001 R14: 4000000000000001 R15: ffff8800fd3d8260
[  628.054715] FS:  00007f1a9c764700(0000) GS:ffff8800fbd00000(0000) 
knlGS:0000000000000000
[  628.054719] CS:  e033 DS: 0000 ES: 0000 CR0: 0000000080050033
[  628.054722] CR2: 00007f1a9e199000 CR3: 00000000f340b000 CR4: 
0000000000002660
[  628.054727] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[  628.054733] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  628.054738] Process mc (pid: 5601, threadinfo ffff8800ed482000, task 
ffff8800f346a040)
[  628.054742] Stack:
[  628.054744]  0000000000000001 ffff8800fd3d8260 0000000000000001 00000003ffffffff
[  628.054751]  4000000000000001 ffffffffa04a5d62 ffff8800f346a040 ffffffff808e5a00
[  628.054758]  0000001000000000 0000000000000000 0000000000000000 
ffff8800d7e6bc90
[  628.054765] Call Trace:
[  628.054799]  [<ffffffffa04a5d62>] ocfs2_read_blocks+0x1a2/0x690 [ocfs2]
[  628.054847]  [<ffffffffa04c66d4>] ocfs2_read_inode_block_full+0x34/0x60 [ocfs2]
[  628.054909]  [<ffffffffa051382f>] ocfs2_fast_symlink_readpage+0x2f/0x170 
[ocfs2]
[  628.055006]  [<ffffffff800e6df6>] do_read_cache_page+0x86/0x180
[  628.055015]  [<ffffffff800e6f49>] read_cache_page+0x9/0x20
[  628.055023]  [<ffffffff8013d014>] page_getlink.isra.11+0x24/0x80
[  628.055030]  [<ffffffff8013d08f>] page_follow_link_light+0x1f/0x40
[  628.055037]  [<ffffffff8013cdb8>] generic_readlink+0x48/0xc0
[  628.055045]  [<ffffffff80138134>] sys_readlinkat+0xb4/0xd0
[  628.055055]  [<ffffffff8050b20b>] system_call_fastpath+0x1a/0x1f
[  628.055066]  [<00007f1a9d19c907>] 0x7f1a9d19c906
[  628.055070] Code: a1 89 e8 5d 41 5c 41 5d c3 0f 1f 84 00 00 00 00 00 40 f6 
c7 01 0f 84 1e ff ff ff f0 80 66 01 f7 e9 14 ff ff ff 0f 0b 0f 0b 0f 0b <0f> 0b 0f 
0b 48 8b 53 70 c1 e0 09 41 f6 c4 01 89 43 30 89 42 08 
[  628.055123] RIP  [<ffffffff801646da>] submit_bh+0x14a/0x1d0
[  628.055130]  RSP <ffff8800ed483c88>
[  628.191338] ---[ end trace 84ac243a6201452a ]---
[  643.145963] BUG: Bad page state in process sshd  pfn:36a55
[  643.145973] page:ffff8800fd3d8298 count:0 mapcount:0 mapping:          (null) 
index:0x2
[  643.145978] page flags: 0xffffffff80164b90(dirty|slab|owner_priv_1|arch_1|
private|head|mappedtodisk|reclaim|unevictable)
[  643.145993] Modules linked in: bridge stp llc iptable_filter ip_tables 
x_tables nbd blktap2 pciback usbbk xen_scsibk openvswitch blkbk 
blkback_pagemap netbk xenbus_be gntdev evtchn ocfs2_dlmfs ocfs2_stack_o2cb 
ocfs2_dlm bonding af_packet edd ocfs2 ocfs2_nodemanager configfs 
ocfs2_stackglue quota_tree coretemp domctl crc32c_intel ghash_clmulni_intel 
joydev iTCO_wdt aesni_intel iTCO_vendor_support ablk_helper cryptd lrw 
aes_x86_64 hid_generic gpio_ich xts gf128mul 8250_core pcspkr serio_raw igb 
ixgbe lpc_ich mfd_core i2c_i801 serial_core usbhid sg i7core_edac ioatdma ptp 
pps_core edac_core hid mdio ses enclosure button uhci_hcd mgag200 ttm 
drm_kms_helper drm i2c_algo_bit sysimgblt sysfillrect i2c_core syscopyarea 
ehci_hcd usbcore usb_common processor thermal_sys hwmon scsi_dh_alua 
scsi_dh_hp_sw scsi_dh_emc scsi_dh_rdac scsi_dh xenblk cdrom xennet ata_generic 
ata_piix megaraid_sas
[  643.146109] Pid: 5651, comm: sshd Tainted: G      D      3.7.9-27-xen #1
[  643.146114] Call Trace:
[  643.146129]  [<ffffffff80008ad5>] dump_trace+0x85/0x1c0
[  643.146138]  [<ffffffff804f8949>] dump_stack+0x69/0x6f
[  643.146146]  [<ffffffff804fac88>] bad_page+0xe7/0xfb
[  643.146155]  [<ffffffff800edf4a>] get_page_from_freelist+0x63a/0x750
[  643.146164]  [<ffffffff800ee1da>] __alloc_pages_nodemask+0x17a/0x950
[  643.146172]  [<ffffffff8010e17b>] handle_pte_fault+0x41b/0x7d0
[  643.146182]  [<ffffffff80506ece>] __do_page_fault+0x19e/0x540
[  643.146190]  [<ffffffff80503c98>] page_fault+0x28/0x30
[  643.146200]  [<00007fd2d8a9961b>] 0x7fd2d8a9961a


linux-3.7/fs/buffer.c:2952 ->   BUG_ON(!bh->b_end_io);

What is the nature of this bug?

-- 
Best regards,
Eugene Istomin
-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20130219/9d30aa71/attachment.html 
