From: Eric Ren <zren@suse.com>
Date: Thu, 24 Nov 2016 14:23:09 +0800
Subject: [Ocfs2-devel] [Bug Report] multiple node reflink: kernel BUG at
 ../fs/ocfs2/suballoc.c:1989!
Message-ID: <b0c4c27c-b482-6330-4f2c-3d73ac304834@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi all,

FYI,

Reflink testcase in multiple nodes mode failed with the backtrace below:

---
2016-11-02T16:43:41.862247+08:00 ocfs2cts2 kernel: [25429.622914] ------------[ cut here ]------------
2016-11-02T16:43:41.862273+08:00 ocfs2cts2 kernel: [25429.622979] kernel BUG at ../fs/ocfs2/suballoc.c:1989!
2016-11-02T16:43:41.862274+08:00 ocfs2cts2 kernel: [25429.623024] invalid opcode: 0000 [#1] SMP
2016-11-02T16:43:41.862276+08:00 ocfs2cts2 kernel: [25429.623064] Modules linked in: ocfs2_stack_user ocfs2 ocfs2_nodemanager ocfs2_stackglue jbd2 quota_tree dlm configfs softdog sd_mod iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi af_packet iscsi_ibft iscsi_boot_sysfs ppdev acpi_cpufreq pvpanic virtio_net parport_pc joydev serio_raw i2c_piix4 pcspkr parport button virtio_balloon processor btrfs ata_generic xor raid6_pq ata_piix ahci libahci cirrus virtio_blk drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops ttm uhci_hcd libata ehci_hcd usbcore drm virtio_pci floppy virtio_ring usb_common virtio sg dm_multipath dm_mod scsi_dh_rdac scsi_dh_emc scsi_dh_alua scsi_mod autofs4
2016-11-02T16:43:41.862277+08:00 ocfs2cts2 kernel: [25429.623590] Supported: Yes
2016-11-02T16:43:41.862278+08:00 ocfs2cts2 kernel: [25429.623624] CPU: 0 PID: 1923 Comm: multi_reflink_t Not tainted 4.4.21-69-default #1
2016-11-02T16:43:41.862279+08:00 ocfs2cts2 kernel: [25429.623684] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
2016-11-02T16:43:41.862280+08:00 ocfs2cts2 kernel: [25429.623744] task: ffff880080010480 ti: ffff8800806cc000 task.ti: ffff8800806cc000
2016-11-02T16:43:41.862281+08:00 ocfs2cts2 kernel: [25429.623801] RIP: 0010:[<ffffffffa056d898>]  [<ffffffffa056d898>] ocfs2_claim_metadata+0x148/0x150 [ocfs2]
2016-11-02T16:43:41.862282+08:00 ocfs2cts2 kernel: [25429.623961] RSP: 0018:ffff8800806cf838  EFLAGS: 00010297
2016-11-02T16:43:41.862282+08:00 ocfs2cts2 kernel: [25429.624010] RAX: 0000000000000003 RBX: ffff88008989f4c0 RCX: ffff8800806cf8b0
2016-11-02T16:43:41.862284+08:00 ocfs2cts2 kernel: [25429.624064] RDX: 0000000000000001 RSI: ffff88008989f4c0 RDI: ffff88006e2313b8
2016-11-02T16:43:41.862284+08:00 ocfs2cts2 kernel: [25429.624119] RBP: 0000000000000000 R08: ffff8800806cf8aa R09: ffff8800806cf8ac
2016-11-02T16:43:41.862285+08:00 ocfs2cts2 kernel: [25429.624173] R10: 000000000001d5e0 R11: ffff88011f9912c0 R12: ffff88008076e000
2016-11-02T16:43:41.862286+08:00 ocfs2cts2 kernel: [25429.624226] R13: ffff88006e2313b8 R14: ffff88003693cae8 R15: ffff88008989f4c0
2016-11-02T16:43:41.862287+08:00 ocfs2cts2 kernel: [25429.624281] FS:  00007f6a35621740(0000) GS:ffff88013fc00000(0000) knlGS:0000000000000000
2016-11-02T16:43:41.862288+08:00 ocfs2cts2 kernel: [25429.624342] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
2016-11-02T16:43:41.862289+08:00 ocfs2cts2 kernel: [25429.624389] CR2: 000000000114e000 CR3: 0000000053597000 CR4: 00000000000006f0
2016-11-02T16:43:41.862297+08:00 ocfs2cts2 kernel: [25429.624448] Stack:
2016-11-02T16:43:41.862299+08:00 ocfs2cts2 kernel: [25429.624476]  ffffffff810b7a80 0000000000000000 0000000000000000 0000000000000000
2016-11-02T16:43:41.862300+08:00 ocfs2cts2 kernel: [25429.624534]  0000000000000000 0000000000000001 0000000000000000 ffff88008076e000
2016-11-02T16:43:41.862301+08:00 ocfs2cts2 kernel: [25429.624592]  ffff88006e2313b8 ffff88003693cae8 ffffffffa051bcb9 ffff8800806cf8b8
2016-11-02T16:43:41.862302+08:00 ocfs2cts2 kernel: [25429.624649] Call Trace:
2016-11-02T16:43:41.862303+08:00 ocfs2cts2 kernel: [25429.624719]  [<ffffffffa051bcb9>] ocfs2_create_new_meta_bhs.isra.49+0x69/0x330 [ocfs2]
2016-11-02T16:43:41.862304+08:00 ocfs2cts2 kernel: [25429.624797]  [<ffffffffa051d3fd>] ocfs2_add_branch+0x1fd/0x830 [ocfs2]
2016-11-02T16:43:41.862306+08:00 ocfs2cts2 kernel: [25429.624878]  [<ffffffffa051dd80>] ocfs2_grow_tree+0x350/0x710 [ocfs2]
2016-11-02T16:43:41.862307+08:00 ocfs2cts2 kernel: [25429.624943]  [<ffffffffa051fde1>] ocfs2_split_and_insert+0x2e1/0x450 [ocfs2]
2016-11-02T16:43:41.862308+08:00 ocfs2cts2 kernel: [25429.625012]  [<ffffffffa0525ec4>] ocfs2_split_extent+0x3e4/0x540 [ocfs2]
2016-11-02T16:43:41.862309+08:00 ocfs2cts2 kernel: [25429.625082]  [<ffffffffa055c2b9>] ocfs2_clear_ext_refcount+0x1c9/0x2b0 [ocfs2]
2016-11-02T16:43:41.862310+08:00 ocfs2cts2 kernel: [25429.625155]  [<ffffffffa0562f68>] ocfs2_make_clusters_writable+0x3b8/0x8d0 [ocfs2]
2016-11-02T16:43:41.862311+08:00 ocfs2cts2 kernel: [25429.625229]  [<ffffffffa0563507>] ocfs2_replace_cow+0x87/0x1c0 [ocfs2]
2016-11-02T16:43:41.862312+08:00 ocfs2cts2 kernel: [25429.626825]  [<ffffffffa0563a2a>] ocfs2_refcount_cow+0x3ea/0x4f0 [ocfs2]
2016-11-02T16:43:41.862314+08:00 ocfs2cts2 kernel: [25429.626825]  [<ffffffffa054730b>] ocfs2_file_write_iter+0xb8b/0xdf0 [ocfs2]
2016-11-02T16:43:41.862315+08:00 ocfs2cts2 kernel: [25429.626825]  [<ffffffff811fa659>] __vfs_write+0xa9/0xf0
2016-11-02T16:43:41.862316+08:00 ocfs2cts2 kernel: [25429.626825]  [<ffffffff811fac4d>] vfs_write+0x9d/0x190
2016-11-02T16:43:41.862317+08:00 ocfs2cts2 kernel: [25429.626825]  [<ffffffff811fba62>] SyS_pwrite64+0x62/0x90
2016-11-02T16:43:41.862318+08:00 ocfs2cts2 kernel: [25429.626825]  [<ffffffff815e142e>] entry_SYSCALL_64_fastpath+0x12/0x6d
2016-11-02T16:43:41.862319+08:00 ocfs2cts2 kernel: [25429.626825] DWARF2 unwinder stuck at entry_SYSCALL_64_fastpath+0x12/0x6d
2016-11-02T16:43:41.862322+08:00 ocfs2cts2 kernel: [25429.626825]
2016-11-02T16:43:41.862323+08:00 ocfs2cts2 kernel: [25429.626825] Leftover inexact backtrace:
2016-11-02T16:43:41.862324+08:00 ocfs2cts2 kernel: [25429.626825]
2016-11-02T16:43:41.862325+08:00 ocfs2cts2 kernel: [25429.626825] Code: 49 89 d8 48 c7 c1 79 3d 5a a0 48 89 04 24 ba db 07 00 00 48 c7 c6 60 14 5a a0 48 89 e7 31 c0 e8 3f fb f6 ff e9 77 ff ff ff 0f 0b <0f> 0b 0f 0b 0f 1f 40 00 0f 1f 44 00 00 41 57 41 56 41 55 41 54
2016-11-02T16:43:41.862326+08:00 ocfs2cts2 kernel: [25429.626825] RIP  [<ffffffffa056d898>] ocfs2_claim_metadata+0x148/0x150 [ocfs2]
2016-11-02T16:43:41.862327+08:00 ocfs2cts2 kernel: [25429.626825]  RSP <ffff8800806cf838>
2016-11-02T16:43:41.862328+08:00 ocfs2cts2 kernel: [25429.654747] ---[ end trace 770682cce700fea4 ]---
---

Eric
