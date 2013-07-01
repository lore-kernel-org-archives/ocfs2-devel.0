From: Eugene Istomin <e.istomin@edss.ee>
Date: Mon, 01 Jul 2013 11:03:17 +0300
Subject: [Ocfs2-devel] BUG: soft lockup - CPU#0 stuck for 22s!
	[kworker/u:2:28128]
Message-ID: <5971516.iLF9thbIGR@eistomin.edss.local>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hello,

i have CPU lockup after scheduling a reflink script:

[452296.152056] BUG: soft lockup - CPU#2 stuck for 22s! [kworker/u:2:28128]
[452296.155270] Modules linked in: dm_mod xt_tcpudp xt_pkttype xt_LOG xt_limit ocfs2_dlmfs ocfs2_stack_o2cb ocfs2_dlm af_packet nbd blktap blktap2 pciback usbbk xen_scsibk blkbk blkback_pagemap netbk xenbus_be gntdev evtchn ipt_REJECT xt_conntrack iptable_raw xt_CT iptable_filter nf_conntrack_netbios_ns nf_conntrack_broadcast nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 ip_tables ip6_tables x_tables openvswitch ocfs2 ocfs2_nodemanager configfs ocfs2_stackglue quota_tree joydev coretemp domctl crc32c_intel ghash_clmulni_intel aesni_intel cryptd aes_x86_64 pcspkr serio_raw usbhid hid i2c_i801 ses enclosure sg iTCO_wdt i2c_core iTCO_vendor_support mlx4_core 8250_pnp i7core_edac ixgbe edac_core ioatdma igb mdio 8250 serial_core button edd autofs4 uhci_hcd ehci_hcd usbcore usb_common processor thermal_sys hwmon scsi_dh_emc scsi_dh_rdac scsi_dh_hp_sw scsi_dh_alua scsi_dh xenblk cdrom xennet ata_generic ata_piix megaraid_sas
[452296.155321] CPU 2 
[452296.155321] Modules linked in: dm_mod xt_tcpudp xt_pkttype xt_LOG xt_limit ocfs2_dlmfs ocfs2_stack_o2cb ocfs2_dlm af_packet nbd blktap blktap2 pciback usbbk xen_scsibk blkbk blkback_pagemap netbk xenbus_be gntdev evtchn ipt_REJECT xt_conntrack iptable_raw xt_CT iptable_filter nf_conntrack_netbios_ns nf_conntrack_broadcast nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 ip_tables ip6_tables x_tables openvswitch ocfs2 ocfs2_nodemanager configfs ocfs2_stackglue quota_tree joydev coretemp domctl crc32c_intel ghash_clmulni_intel aesni_intel cryptd aes_x86_64 pcspkr serio_raw usbhid hid i2c_i801 ses enclosure sg iTCO_wdt i2c_core iTCO_vendor_support mlx4_core 8250_pnp i7core_edac ixgbe edac_core ioatdma igb mdio 8250 serial_core button edd autofs4 uhci_hcd ehci_hcd usbcore usb_common processor thermal_sys hwmon scsi_dh_emc scsi_dh_rdac scsi_dh_hp_sw scsi_dh_alua scsi_dh xenblk cdrom xennet ata_generic ata_piix megaraid_sas
[452296.155355] 
[452296.155357] Pid: 28128, comm: kworker/u:2 Not tainted 3.4.50-1.g59c41dc-xen #1 Supermicro X8DTN+-F/X8DTN+-F
[452296.155360] RIP: e030:[<ffffffff8020acdd>]  [<ffffffff8020acdd>] do_get_write_access+0x7d/0x470
[452296.155370] RSP: e02b:ffff88004b989a20  EFLAGS: 00000246
[452296.155372] RAX: 0000000000000000 RBX: ffff88004d1446d8 RCX: ffff88004ba161c0
[452296.155373] RDX: ffff88004b989a58 RSI: ffff88004d1446d8 RDI: ffff88000ab5f420
[452296.155375] RBP: ffff88003371e7c0 R08: 0000000000000001 R09: 0000000000000000
[452296.155376] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
[452296.155377] R13: ffff88000ab5f420 R14: 0000000000b6bd6c R15: ffff88004ef460c8
[452296.155383] FS:  00007f5c22aff700(0000) GS:ffff8800fbd00000(0000) knlGS:0000000000000000
[452296.155385] CS:  e033 DS: 0000 ES: 0000 CR0: 000000008005003b
[452296.155386] CR2: 00007fa4e3dc6000 CR3: 00000000e8780000 CR4: 0000000000002660
[452296.155388] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[452296.155389] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[452296.155391] Process kworker/u:2 (pid: 28128, threadinfo ffff88004b988000, task ffff88004ba161c0)
[452296.155393] Stack:
[452296.155394]  ffff8800639420d0 ffff88004b989a58 ffff88004b989a68 ffff8800f45f9800
[452296.155396]  00000000b653e640 ffff88004ba161c0 0000000000000000 ffff88004ba161c0
[452296.155398]  0000000000000000 ffff88004ba161c0 000000504b989c68 ffff88000ab5f420
[452296.155401] Call Trace:
[452296.155410]  [<ffffffff8020b219>] jbd2_journal_get_write_access+0x29/0x50
[452296.155439]  [<ffffffffa03529ed>] __ocfs2_journal_access+0x1ad/0x360 [ocfs2]
[452296.155480]  [<ffffffffa0324ca0>] ocfs2_remove_btree_range+0x220/0x9b0 [ocfs2]
[452296.155495]  [<ffffffffa0328452>] ocfs2_commit_truncate+0x142/0x520 [ocfs2]
[452296.155513]  [<ffffffffa034e298>] ocfs2_wipe_inode+0x1b8/0xf10 [ocfs2]
[452296.155543]  [<ffffffffa034f1f6>] ocfs2_evict_inode+0x206/0x750 [ocfs2]
[452296.155564]  [<ffffffff8013f87d>] evict+0xbd/0x1d0
[452296.155576]  [<ffffffffa032f594>] __ocfs2_drop_dl_inodes.isra.1+0x54/0xa0 [ocfs2]
[452296.155593]  [<ffffffffa0330063>] ocfs2_drop_dl_inodes+0x23/0xd0 [ocfs2]
[452296.155605]  [<ffffffff800497bc>] process_one_work+0x14c/0x410
[452296.155608]  [<ffffffff80049e3d>] worker_thread+0x12d/0x360
[452296.155613]  [<ffffffff8004e545>] kthread+0x85/0x90
[452296.155619]  [<ffffffff8050ce84>] kernel_thread_helper+0x4/0x10
[452296.155621] Code: 4c 24 28 48 83 c0 10 48 89 44 24 10 66 90 4c 8b 3b f0 41 0f ba 2f 02 19 c0 85 c0 74 08 4c 89 ff e8 b9 a8 f4 ff f0 41 0f ba 2f 14 <19> c0 85 c0 0f 85 60 03 00 00 49 8b 07 a8 02 74 55 48 8b 43 28 
[452296.155641] Call Trace:
[452296.155644]  [<ffffffff8020b219>] jbd2_journal_get_write_access+0x29/0x50
[452296.155657]  [<ffffffffa03529ed>] __ocfs2_journal_access+0x1ad/0x360 [ocfs2]
[452296.155686]  [<ffffffffa0324ca0>] ocfs2_remove_btree_range+0x220/0x9b0 [ocfs2]
[452296.155701]  [<ffffffffa0328452>] ocfs2_commit_truncate+0x142/0x520 [ocfs2]
[452296.155718]  [<ffffffffa034e298>] ocfs2_wipe_inode+0x1b8/0xf10 [ocfs2]
[452296.155748]  [<ffffffffa034f1f6>] ocfs2_evict_inode+0x206/0x750 [ocfs2]
[452296.155768]  [<ffffffff8013f87d>] evict+0xbd/0x1d0
[452296.155779]  [<ffffffffa032f594>] __ocfs2_drop_dl_inodes.isra.1+0x54/0xa0 [ocfs2]
[452296.155796]  [<ffffffffa0330063>] ocfs2_drop_dl_inodes+0x23/0xd0 [ocfs2]
[452296.155806]  [<ffffffff800497bc>] process_one_work+0x14c/0x410
[452296.155809]  [<ffffffff80049e3d>] worker_thread+0x12d/0x360
[452296.155811]  [<ffffffff8004e545>] kthread+0x85/0x90
[452296.155815]  [<ffffffff8050ce84>] kernel_thread_helper+0x4/0x10

Can you help me to resolve this problem?

-- 
*/Best regards,/*
/Eugene Istomin/

-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20130701/d0820ac9/attachment-0001.html 
