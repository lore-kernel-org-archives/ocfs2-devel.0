From: Alexandre DERUMIER <aderumier@odiso.com>
Date: Mon, 26 Jun 2017 10:24:39 +0200 (CEST)
Subject: [Ocfs2-devel] kernel 4.11 crash (kernel BUG /fs/ocfs2/dlmglue.c:826
	)
In-Reply-To: <159235645.14575829.1498308325648.JavaMail.zimbra@oxygem.tv>
References: <159235645.14575829.1498308325648.JavaMail.zimbra@oxygem.tv>
Message-ID: <1820738559.14612034.1498465479584.JavaMail.zimbra@oxygem.tv>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


Hi, 

I still have a lot of crash with ocfs2 hosting php applications. 

Last stable kernel for my was 3.16. 
I have tested kernels 4.1,4.2,4.4,4.7, 4.8, 4.9 && 4.11 , 
and they all crash in some minutes or some days. 

Here a trace with 4.11 kernel. (this was with a magento2 ecommerce php application). 
I can easily reproduce it (In this example, the server just crash some seconds after boot, because of a php cron) 




Jun 22 12:22:43 myserver kernel: [ 11.659945] o2dlm: Joining domain 62FEBEC41DE54774A3DEA08F56CEF4E2 
Jun 22 12:22:43 myserver kernel: [ 11.659947] ( 
Jun 22 12:22:43 myserver kernel: [ 11.659948] 0 
Jun 22 12:22:43 myserver kernel: [ 11.659948] 1 
Jun 22 12:22:43 myserver kernel: [ 11.659948] 2 
Jun 22 12:22:43 myserver kernel: [ 11.659952] 3 
Jun 22 12:22:43 myserver kernel: [ 11.659953] 4 
Jun 22 12:22:43 myserver kernel: [ 11.659953] 5 
Jun 22 12:22:43 myserver kernel: [ 11.659954] ) 6 nodes 
Jun 22 12:22:43 myserver kernel: [ 11.699696] ocfs2: Mounting device (8,16) on (node 5, slot 5) with ordered data mode. 
Jun 22 12:23:03 myserver kernel: [ 31.950054] ------------[ cut here ]------------ 
Jun 22 12:23:03 myserver kernel: [ 31.950090] kernel BUG at /build/linux-C5oXKu/linux-4.11.6/fs/ocfs2/dlmglue.c:826! 
Jun 22 12:23:03 myserver kernel: [ 31.950124] invalid opcode: 0000 [#1] SMP 
Jun 22 12:23:03 myserver kernel: [ 31.950143] Modules linked in: binfmt_misc ocfs2_dlmfs ocfs2_stack_o2cb ocfs2_dlm nfsd auth_rpcgss oid_registry nfs_acl nfs lockd grace ocfs2 ocfs2_nodemanager configfs ocfs2_stackglue jbd2 fscache sunrpc quota_tree hid_generic usbhid ppdev hid virtio_console evdev joydev virtio_balloon cirrus ttm drm_kms_helper drm shpchp i2c_piix4 serio_raw parport_pc parport pcspkr button loop autofs4 xfs crc32c_generic libcrc32c sg sr_mod cdrom sd_mod ata_generic virtio_net virtio_scsi ata_piix libata psmouse uhci_hcd ehci_hcd virtio_pci scsi_mod virtio_ring usbcore virtio usb_common floppy 
Jun 22 12:23:03 myserver kernel: [ 31.950372] CPU: 2 PID: 1168 Comm: php Not tainted 4.11.0-1-amd64 #1 Debian 4.11.6-1 
Jun 22 12:23:03 myserver kernel: [ 31.950404] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.9.3-0-ge2fc41e-prebuilt.qemu-project.org 04/01/2014 
Jun 22 12:23:03 myserver kernel: [ 31.950453] task: ffff8da2b3758380 task.stack: ffffb245c2cd0000 
Jun 22 12:23:03 myserver kernel: [ 31.950535] RIP: 0010:__ocfs2_cluster_unlock.isra.38+0x9d/0xb0 [ocfs2] 
Jun 22 12:23:03 myserver kernel: [ 31.950565] RSP: 0018:ffffb245c2cd3b00 EFLAGS: 00010046 
Jun 22 12:23:03 myserver kernel: [ 31.950588] RAX: 0000000000000286 RBX: ffff8da4b4efd018 RCX: 000000000009d5c1 
Jun 22 12:23:03 myserver kernel: [ 31.950618] RDX: 0000000000000000 RSI: ffff8da4b4efd018 RDI: ffff8da4b4efd094 
Jun 22 12:23:03 myserver kernel: [ 31.950648] RBP: 0000000000000003 R08: 0000000e5cebdabc R09: 000000000000001f 
Jun 22 12:23:03 myserver kernel: [ 31.950678] R10: ffffb245c2cd3ae8 R11: 0000000000000000 R12: ffff8da4b4efd094 
Jun 22 12:23:03 myserver kernel: [ 31.950708] R13: ffff8da2b4ea7000 R14: 0000000000000000 R15: ffffffffc09400c0 
Jun 22 12:23:03 myserver kernel: [ 31.950738] FS: 00007fdf5f586700(0000) GS:ffff8da2b7880000(0000) knlGS:0000000000000000 
Jun 22 12:23:03 myserver kernel: [ 31.950772] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033 
Jun 22 12:23:03 myserver kernel: [ 31.950796] CR2: 000055d268e87000 CR3: 0000000435f85000 CR4: 00000000000006e0 
Jun 22 12:23:03 myserver kernel: [ 31.950829] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000 
Jun 22 12:23:03 myserver kernel: [ 31.950860] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400 
Jun 22 12:23:03 myserver kernel: [ 31.950889] Call Trace: 
Jun 22 12:23:03 myserver kernel: [ 31.950915] ? ocfs2_dentry_unlock+0x4a/0x80 [ocfs2] 
Jun 22 12:23:03 myserver kernel: [ 31.950954] ? ocfs2_dentry_attach_lock+0x2c7/0x420 [ocfs2] 
Jun 22 12:23:03 myserver kernel: [ 31.950994] ? ocfs2_lookup+0x196/0x2d0 [ocfs2] 
Jun 22 12:23:03 myserver kernel: [ 31.951018] ? lookup_slow+0xa3/0x170 
Jun 22 12:23:03 myserver kernel: [ 31.951036] ? walk_component+0x1c0/0x350 
Jun 22 12:23:03 myserver kernel: [ 31.951055] ? link_path_walk+0x1b2/0x640 
Jun 22 12:23:03 myserver kernel: [ 31.951074] ? path_init+0x1c3/0x320 
Jun 22 12:23:03 myserver kernel: [ 31.951092] ? path_lookupat+0x6c/0x100 
Jun 22 12:23:03 myserver kernel: [ 31.951110] ? filename_lookup+0xb8/0x1a0 
Jun 22 12:23:03 myserver kernel: [ 31.951140] ? ocfs2_mark_lockres_freeing+0x17d/0x260 [ocfs2] 
Jun 22 12:23:03 myserver kernel: [ 31.951175] ? ocfs2_read_inode_block_full+0x46/0x80 [ocfs2] 
Jun 22 12:23:03 myserver kernel: [ 31.951201] ? __check_object_size+0xfb/0x196 
Jun 22 12:23:03 myserver kernel: [ 31.951221] ? strncpy_from_user+0x48/0x160 
Jun 22 12:23:03 myserver kernel: [ 31.951242] ? vfs_statx+0x73/0xe0 
Jun 22 12:23:03 myserver kernel: [ 31.951258] ? vfs_statx+0x73/0xe0 
Jun 22 12:23:03 myserver kernel: [ 31.951274] ? dput+0x38/0x250 
Jun 22 12:23:03 myserver kernel: [ 31.951289] ? SYSC_newstat+0x39/0x70 
Jun 22 12:23:03 myserver kernel: [ 31.951308] ? task_work_run+0x7e/0xa0 
Jun 22 12:23:03 myserver kernel: [ 31.951327] ? exit_to_usermode_loop+0x8c/0xb0 
Jun 22 12:23:03 myserver kernel: [ 31.951349] ? system_call_fast_compare_end+0xc/0x9b 
Jun 22 12:23:03 myserver kernel: [ 31.952246] Code: 89 c6 5b 5d 41 5c 41 5d e9 21 e0 39 fe 0f 0b 8b 53 68 85 d2 74 15 83 ea 01 89 53 68 eb af 8b 53 6c 85 d2 74 c3 eb d1 0f 0b 0f 0b <0f> 0b 0f 0b 0f 1f 44 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 
Jun 22 12:23:03 myserver kernel: [ 31.954142] RIP: __ocfs2_cluster_unlock.isra.38+0x9d/0xb0 [ocfs2] RSP: ffffb245c2cd3b00 
Jun 22 12:23:03 myserver kernel: [ 31.955077] ---[ end trace b153a3ae721a67d4 ]--- 
