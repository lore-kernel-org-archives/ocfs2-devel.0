From: =?UTF-8?Q?Marek_Kr=C3=B3likowski?= <admin@wset.edu.pl>
Date: Wed, 15 Aug 2012 20:43:55 +0200
Subject: [Ocfs2-devel] ocfs2 + quota next oops - Mayby help with diagnose
	problem
In-Reply-To: <CAEeiSHVFXGQtixne6qNdi3wP4qxk=H3kdhTUvVSaWZAFp5m0JQ@mail.gmail.com>
References: <5029B1E5.4030509@huawei.com><CAEeiSHVJc6pnTcQ8MrLBvQ+GhZ=5P6uG-sBg0VcvK0LWxBjpuA@mail.gmail.com><502B4193.5040608@huawei.com>
	<CAEeiSHVFXGQtixne6qNdi3wP4qxk=H3kdhTUvVSaWZAFp5m0JQ@mail.gmail.com>
Message-ID: <8B13DF70D08C4EFA8B0F2194D584FF5E@SERWER>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hello Guys
I create on my VMware two virtual machine connected via FC to EMC storage 
with ocfs2.
After few hours cp, rm, mv, du ?sh, quota ?v root and other command on this 
file system i get oops mayby that help You guys with diagnose problem:
If You need i can give You access to both this server via SSH.

NODE 1
------------[ cut here ]------------
kernel BUG at fs/ocfs2/buffer_head_io.c:343!
invalid opcode: 0000 [#1] SMP
CPU 2
Modules linked in: ocfs2_stack_o2cb ip_tables tcp_diag inet_diag ipv6 dlm 
ocfs2_dlm ocfs2 ocfs2_dlmfs ocfs2_stackglue ocfs2_nodemanager configfs 
dm_multipath snd_pcm snd_timer snd soundcore ppdev parport_pc vmw_balloon 
floppy snd_page_alloc i2c_piix4 pcspkr i2c_core sha256_generic iscsi_tcp 
libiscsi_tcp libiscsi scsi_transport_iscsi tg3 e1000 fuse xfs exportfs nfs 
nfs_acl auth_rpcgss fscache lockd sunrpc reiserfs btrfs libcrc32c 
zlib_deflate ext4 jbd2 ext3 jbd ext2 mbcache raid10 raid456 
async_raid6_recov async_memcpy async_pq async_xor xor async_tx raid6_pq 
raid1 raid0 dm_snapshot dm_crypt dm_mirror dm_region_hash dm_log dm_mod 
scsi_wait_scan sl811_hcd usb_storage mpt2sas raid_class aic94xx libsas lpfc 
qla2xxx megaraid_sas megaraid_mbox megaraid_mm aacraid sx8 hpsa cciss 
3w_9xxx 3w_xxxx mptsas scsi_transport_sas mptfc scsi_transport_fc scsi_tgt 
mptspi mptscsih mptbase imm parport sym53c8xx initio arcmsr aic7xxx aic79xx 
scsi_transport_spi sr_mod cdrom sg sd_mod crc_t10dif pdc_adma sata_inic162x 
sata_mv ata_piix ahci libahci sata_qstor sata_vsc sata_uli sata_sis sata_sx4 
sata_nv sata_via sata_svw sata_sil24 sata_sil sata_promise pata_via 
pata_jmicron pata_marvell pata_sis pata_netcell pata_pdc202xx_old 
pata_atiixp pata_amd pata_ali pata_it8213 pata_pcmcia pata_serverworks 
pata_oldpiix pata_artop pata_it821x pata_hpt3x2n pata_hpt3x3 pata_hpt37x 
pata_hpt366 pata_cmd64x pata_sil680 pata_pdc2027x

Pid: 12394, comm: cp Not tainted 3.2.27 #1 VMware, Inc. VMware Virtual 
Platform/440BX Desktop Reference Platform
RIP: 0010:[<ffffffffa093ce33>]  [<ffffffffa093ce33>] 
ocfs2_read_blocks+0x6c3/0x6d0 [ocfs2]
RSP: 0018:ffff8802bb097a48  EFLAGS: 00010202
RAX: 00000000008c4029 RBX: ffff8802bb097af0 RCX: ffff8802f66a3610
RDX: 00000000008c4029 RSI: ffff8802f66a3610 RDI: ffff8803e4064bf0
RBP: 0000000000000000 R08: 0000000000000000 R09: ffffffffa095bb40
R10: 0000000000000001 R11: 0000000000000000 R12: ffff8802f66a3610
R13: 0000000000000000 R14: ffff8802bb097af0 R15: 0000000000000000
FS:  00007fa4d9dbc700(0000) GS:ffff88043fd00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007f0bd077ce9c CR3: 0000000382d77000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process cp (pid: 12394, threadinfo ffff8802bb096000, task ffff88041ad7f7d0)
Stack:
ffff88041ad7fc18 000000000000005a ffff880200000000 0000000181066369
0000000100000000 ffff8803e4064bf0 ffff8804192d8c00 000000000099e1c4
ffffffffa095bb40 0000000000000000 ffff8802bb097af0 00000000a094b552
Call Trace:
[<ffffffffa095bb40>] ? ocfs2_find_actor+0x140/0x140 [ocfs2]
[<ffffffffa095e9d7>] ? ocfs2_read_inode_block_full+0x37/0x60 [ocfs2]
[<ffffffffa094e2c8>] ? ocfs2_inode_lock_full_nested+0x408/0x520 [ocfs2]
[<ffffffffa093b211>] ? ocfs2_write_begin+0x61/0x240 [ocfs2]
[<ffffffffa094b552>] ? ocfs2_inode_lock_update+0xa2/0x4c0 [ocfs2]
[<ffffffff810f6159>] ? generic_perform_write+0xc9/0x210
[<ffffffffa095a428>] ? ocfs2_prepare_inode_for_write+0x108/0x5a0 [ocfs2]
[<ffffffff810f6301>] ? generic_file_buffered_write+0x61/0xa0
[<ffffffffa095b4a6>] ? ocfs2_file_aio_write+0x886/0x920 [ocfs2]
[<ffffffffa094b552>] ? ocfs2_inode_lock_update+0xa2/0x4c0 [ocfs2]
[<ffffffff81144257>] ? do_sync_write+0xc7/0x100
[<ffffffff811d99fc>] ? selinux_file_permission+0xdc/0x150
[<ffffffff811d3174>] ? security_file_permission+0x24/0xc0
[<ffffffff81144b26>] ? vfs_write+0xc6/0x180
[<ffffffff81144e3e>] ? sys_write+0x4e/0x90
[<ffffffff814c3c52>] ? system_call_fastpath+0x16/0x1b
Code: 24 44 8b 6c 24 48 66 90 48 8b 7b 08 48 83 c3 10 45 89 e8 44 89 e1 48 
89 ea 4c 89 f6 ff d0 48 8b 03 48 85 c0 75 e2 e9 80 f9 ff ff <0f> 0b 66 66 2e 
0f 1f 84 00 00 00 00 00 48 83 ec 38 48 89 5c 24
RIP  [<ffffffffa093ce33>] ocfs2_read_blocks+0x6c3/0x6d0 [ocfs2]
RSP <ffff8802bb097a48>
---[ end trace 51e452787a23b620 ]---




NODE 2
INFO: task du:12394 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
du              D ffff88043fc93280     0 12394  11620 0x00000000
ffff88041a49b080 0000000000000082 ffff880427110080 0000000000013280
ffff880073babfd8 0000000000013280 0000000000013280 0000000000013280
ffff880073baa000 0000000000013280 ffff880073babfd8 0000000000013280
Call Trace:
[<ffffffff814ba52d>] ? schedule_timeout+0x1ed/0x2e0
[<ffffffff8104a563>] ? __wake_up+0x43/0x70
[<ffffffffa0a8d1b8>] ? dlmlock+0x88/0xd70 [ocfs2_dlm]
[<ffffffff8104a563>] ? __wake_up+0x43/0x70
[<ffffffff814b9e5a>] ? wait_for_common+0x13a/0x190
[<ffffffff81057e10>] ? try_to_wake_up+0x280/0x280
[<ffffffffa094d898>] ? __ocfs2_cluster_lock.clone.20+0x1d8/0x800 [ocfs2]
[<ffffffff8101b815>] ? read_tsc+0x5/0x20
[<ffffffff8108c1e1>] ? ktime_get+0x61/0xf0
[<ffffffffa094dff9>] ? ocfs2_inode_lock_full_nested+0x139/0x520 [ocfs2]
[<ffffffffa095eda1>] ? ocfs2_read_locked_inode+0x3a1/0x630 [ocfs2]
[<ffffffff8115ce1e>] ? inode_sb_list_add+0x2e/0x40
[<ffffffffa095f19b>] ? ocfs2_iget+0x16b/0x2b0 [ocfs2]
[<ffffffffa096a542>] ? ocfs2_lookup+0xe2/0x300 [ocfs2]
[<ffffffff8115b70f>] ? __d_alloc+0x11f/0x180
[<ffffffff8114efdc>] ? d_alloc_and_lookup+0x3c/0x90
[<ffffffff8115bd3e>] ? d_lookup+0x2e/0x60
[<ffffffff81151483>] ? do_lookup+0x293/0x390
[<ffffffff8115041a>] ? path_init+0x28a/0x3a0
[<ffffffff81151fc5>] ? path_lookupat+0x135/0x730
[<ffffffffa09ae03b>] ? ocfs2_set_buffer_uptodate+0x2b/0x130 [ocfs2]
[<ffffffffa093ca7c>] ? ocfs2_read_blocks+0x30c/0x6d0 [ocfs2]
[<ffffffff811525ec>] ? do_path_lookup+0x2c/0xd0
[<ffffffff8114f432>] ? getname_flags+0x52/0xf0
[<ffffffff81153f9c>] ? user_path_at_empty+0x5c/0xb0
[<ffffffffa0944892>] ? ocfs2_dir_foreach_blk_id+0x72/0x250 [ocfs2]
[<ffffffff811569b0>] ? filldir64+0x100/0x100
[<ffffffffa094cf0d>] ? __ocfs2_cluster_unlock.clone.19+0x2d/0xe0 [ocfs2]
[<ffffffff8114943e>] ? vfs_fstatat+0x3e/0x90
[<ffffffff811496df>] ? sys_newfstatat+0x1f/0x50
[<ffffffff8118145b>] ? fsnotify_find_inode_mark+0x2b/0x40
[<ffffffff811823b4>] ? dnotify_flush+0x54/0x110
[<ffffffff8114274f>] ? filp_close+0x5f/0x90
[<ffffffff8114280d>] ? sys_close+0x8d/0xe0
[<ffffffff814c3c52>] ? system_call_fastpath+0x16/0x1b
INFO: task du:12394 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
du              D ffff88043fc93280     0 12394  11620 0x00000000
ffff88041a49b080 0000000000000082 ffff880427110080 0000000000013280
ffff880073babfd8 0000000000013280 0000000000013280 0000000000013280
ffff880073baa000 0000000000013280 ffff880073babfd8 0000000000013280
Call Trace:
[<ffffffff814ba52d>] ? schedule_timeout+0x1ed/0x2e0
[<ffffffff8104a563>] ? __wake_up+0x43/0x70
[<ffffffffa0a8d1b8>] ? dlmlock+0x88/0xd70 [ocfs2_dlm]
[<ffffffff8104a563>] ? __wake_up+0x43/0x70
[<ffffffff814b9e5a>] ? wait_for_common+0x13a/0x190
[<ffffffff81057e10>] ? try_to_wake_up+0x280/0x280
[<ffffffffa094d898>] ? __ocfs2_cluster_lock.clone.20+0x1d8/0x800 [ocfs2]
[<ffffffff8101b815>] ? read_tsc+0x5/0x20
[<ffffffff8108c1e1>] ? ktime_get+0x61/0xf0
[<ffffffffa094dff9>] ? ocfs2_inode_lock_full_nested+0x139/0x520 [ocfs2]
[<ffffffffa095eda1>] ? ocfs2_read_locked_inode+0x3a1/0x630 [ocfs2]
[<ffffffff8115ce1e>] ? inode_sb_list_add+0x2e/0x40
[<ffffffffa095f19b>] ? ocfs2_iget+0x16b/0x2b0 [ocfs2]
[<ffffffffa096a542>] ? ocfs2_lookup+0xe2/0x300 [ocfs2]
[<ffffffff8115b70f>] ? __d_alloc+0x11f/0x180
[<ffffffff8114efdc>] ? d_alloc_and_lookup+0x3c/0x90
[<ffffffff8115bd3e>] ? d_lookup+0x2e/0x60
[<ffffffff81151483>] ? do_lookup+0x293/0x390
[<ffffffff8115041a>] ? path_init+0x28a/0x3a0
[<ffffffff81151fc5>] ? path_lookupat+0x135/0x730
[<ffffffffa09ae03b>] ? ocfs2_set_buffer_uptodate+0x2b/0x130 [ocfs2]
[<ffffffffa093ca7c>] ? ocfs2_read_blocks+0x30c/0x6d0 [ocfs2]
[<ffffffff811525ec>] ? do_path_lookup+0x2c/0xd0
[<ffffffff8114f432>] ? getname_flags+0x52/0xf0
[<ffffffff81153f9c>] ? user_path_at_empty+0x5c/0xb0
[<ffffffffa0944892>] ? ocfs2_dir_foreach_blk_id+0x72/0x250 [ocfs2]
[<ffffffff811569b0>] ? filldir64+0x100/0x100
[<ffffffffa094cf0d>] ? __ocfs2_cluster_unlock.clone.19+0x2d/0xe0 [ocfs2]
[<ffffffff8114943e>] ? vfs_fstatat+0x3e/0x90
[<ffffffff811496df>] ? sys_newfstatat+0x1f/0x50
[<ffffffff8118145b>] ? fsnotify_find_inode_mark+0x2b/0x40
[<ffffffff811823b4>] ? dnotify_flush+0x54/0x110
[<ffffffff8114274f>] ? filp_close+0x5f/0x90
[<ffffffff8114280d>] ? sys_close+0x8d/0xe0
[<ffffffff814c3c52>] ? system_call_fastpath+0x16/0x1b
INFO: task du:12394 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
du              D ffff88043fc93280     0 12394  11620 0x00000000
ffff88041a49b080 0000000000000082 ffff880427110080 0000000000013280
ffff880073babfd8 0000000000013280 0000000000013280 0000000000013280
ffff880073baa000 0000000000013280 ffff880073babfd8 0000000000013280
Call Trace:
[<ffffffff814ba52d>] ? schedule_timeout+0x1ed/0x2e0
[<ffffffff8104a563>] ? __wake_up+0x43/0x70
[<ffffffffa0a8d1b8>] ? dlmlock+0x88/0xd70 [ocfs2_dlm]
[<ffffffff8104a563>] ? __wake_up+0x43/0x70
[<ffffffff814b9e5a>] ? wait_for_common+0x13a/0x190
[<ffffffff81057e10>] ? try_to_wake_up+0x280/0x280
[<ffffffffa094d898>] ? __ocfs2_cluster_lock.clone.20+0x1d8/0x800 [ocfs2]
[<ffffffff8101b815>] ? read_tsc+0x5/0x20
[<ffffffff8108c1e1>] ? ktime_get+0x61/0xf0
[<ffffffffa094dff9>] ? ocfs2_inode_lock_full_nested+0x139/0x520 [ocfs2]
[<ffffffffa095eda1>] ? ocfs2_read_locked_inode+0x3a1/0x630 [ocfs2]
[<ffffffff8115ce1e>] ? inode_sb_list_add+0x2e/0x40
[<ffffffffa095f19b>] ? ocfs2_iget+0x16b/0x2b0 [ocfs2]
[<ffffffffa096a542>] ? ocfs2_lookup+0xe2/0x300 [ocfs2]
[<ffffffff8115b70f>] ? __d_alloc+0x11f/0x180
[<ffffffff8114efdc>] ? d_alloc_and_lookup+0x3c/0x90
[<ffffffff8115bd3e>] ? d_lookup+0x2e/0x60
[<ffffffff81151483>] ? do_lookup+0x293/0x390
[<ffffffff8115041a>] ? path_init+0x28a/0x3a0
[<ffffffff81151fc5>] ? path_lookupat+0x135/0x730
[<ffffffffa09ae03b>] ? ocfs2_set_buffer_uptodate+0x2b/0x130 [ocfs2]
[<ffffffffa093ca7c>] ? ocfs2_read_blocks+0x30c/0x6d0 [ocfs2]
[<ffffffff811525ec>] ? do_path_lookup+0x2c/0xd0
[<ffffffff8114f432>] ? getname_flags+0x52/0xf0
[<ffffffff81153f9c>] ? user_path_at_empty+0x5c/0xb0
[<ffffffffa0944892>] ? ocfs2_dir_foreach_blk_id+0x72/0x250 [ocfs2]
[<ffffffff811569b0>] ? filldir64+0x100/0x100
[<ffffffffa094cf0d>] ? __ocfs2_cluster_unlock.clone.19+0x2d/0xe0 [ocfs2]
[<ffffffff8114943e>] ? vfs_fstatat+0x3e/0x90
[<ffffffff811496df>] ? sys_newfstatat+0x1f/0x50
[<ffffffff8118145b>] ? fsnotify_find_inode_mark+0x2b/0x40
[<ffffffff811823b4>] ? dnotify_flush+0x54/0x110
[<ffffffff8114274f>] ? filp_close+0x5f/0x90
[<ffffffff8114280d>] ? sys_close+0x8d/0xe0
[<ffffffff814c3c52>] ? system_call_fastpath+0x16/0x1b
INFO: task du:12394 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
du              D ffff88043fc93280     0 12394  11620 0x00000000
ffff88041a49b080 0000000000000082 ffff880427110080 0000000000013280
ffff880073babfd8 0000000000013280 0000000000013280 0000000000013280
ffff880073baa000 0000000000013280 ffff880073babfd8 0000000000013280
Call Trace:
[<ffffffff814ba52d>] ? schedule_timeout+0x1ed/0x2e0
[<ffffffff8104a563>] ? __wake_up+0x43/0x70
[<ffffffffa0a8d1b8>] ? dlmlock+0x88/0xd70 [ocfs2_dlm]
[<ffffffff8104a563>] ? __wake_up+0x43/0x70
[<ffffffff814b9e5a>] ? wait_for_common+0x13a/0x190
[<ffffffff81057e10>] ? try_to_wake_up+0x280/0x280
[<ffffffffa094d898>] ? __ocfs2_cluster_lock.clone.20+0x1d8/0x800 [ocfs2]
[<ffffffff8101b815>] ? read_tsc+0x5/0x20
[<ffffffff8108c1e1>] ? ktime_get+0x61/0xf0
[<ffffffffa094dff9>] ? ocfs2_inode_lock_full_nested+0x139/0x520 [ocfs2]
[<ffffffffa095eda1>] ? ocfs2_read_locked_inode+0x3a1/0x630 [ocfs2]
[<ffffffff8115ce1e>] ? inode_sb_list_add+0x2e/0x40
[<ffffffffa095f19b>] ? ocfs2_iget+0x16b/0x2b0 [ocfs2]
[<ffffffffa096a542>] ? ocfs2_lookup+0xe2/0x300 [ocfs2]
[<ffffffff8115b70f>] ? __d_alloc+0x11f/0x180
[<ffffffff8114efdc>] ? d_alloc_and_lookup+0x3c/0x90
[<ffffffff8115bd3e>] ? d_lookup+0x2e/0x60
[<ffffffff81151483>] ? do_lookup+0x293/0x390
[<ffffffff8115041a>] ? path_init+0x28a/0x3a0
[<ffffffff81151fc5>] ? path_lookupat+0x135/0x730
[<ffffffffa09ae03b>] ? ocfs2_set_buffer_uptodate+0x2b/0x130 [ocfs2]
[<ffffffffa093ca7c>] ? ocfs2_read_blocks+0x30c/0x6d0 [ocfs2]
[<ffffffff811525ec>] ? do_path_lookup+0x2c/0xd0
[<ffffffff8114f432>] ? getname_flags+0x52/0xf0
[<ffffffff81153f9c>] ? user_path_at_empty+0x5c/0xb0
[<ffffffffa0944892>] ? ocfs2_dir_foreach_blk_id+0x72/0x250 [ocfs2]
[<ffffffff811569b0>] ? filldir64+0x100/0x100
[<ffffffffa094cf0d>] ? __ocfs2_cluster_unlock.clone.19+0x2d/0xe0 [ocfs2]
[<ffffffff8114943e>] ? vfs_fstatat+0x3e/0x90
[<ffffffff811496df>] ? sys_newfstatat+0x1f/0x50
[<ffffffff8118145b>] ? fsnotify_find_inode_mark+0x2b/0x40
[<ffffffff811823b4>] ? dnotify_flush+0x54/0x110
[<ffffffff8114274f>] ? filp_close+0x5f/0x90
[<ffffffff8114280d>] ? sys_close+0x8d/0xe0
[<ffffffff814c3c52>] ? system_call_fastpath+0x16/0x1b
INFO: task du:12394 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
du              D ffff88043fc93280     0 12394  11620 0x00000000
ffff88041a49b080 0000000000000082 ffff880427110080 0000000000013280
ffff880073babfd8 0000000000013280 0000000000013280 0000000000013280
ffff880073baa000 0000000000013280 ffff880073babfd8 0000000000013280
Call Trace:
[<ffffffff814ba52d>] ? schedule_timeout+0x1ed/0x2e0
[<ffffffff8104a563>] ? __wake_up+0x43/0x70
[<ffffffffa0a8d1b8>] ? dlmlock+0x88/0xd70 [ocfs2_dlm]
[<ffffffff8104a563>] ? __wake_up+0x43/0x70
[<ffffffff814b9e5a>] ? wait_for_common+0x13a/0x190
[<ffffffff81057e10>] ? try_to_wake_up+0x280/0x280
[<ffffffffa094d898>] ? __ocfs2_cluster_lock.clone.20+0x1d8/0x800 [ocfs2]
[<ffffffff8101b815>] ? read_tsc+0x5/0x20
[<ffffffff8108c1e1>] ? ktime_get+0x61/0xf0
[<ffffffffa094dff9>] ? ocfs2_inode_lock_full_nested+0x139/0x520 [ocfs2]
[<ffffffffa095eda1>] ? ocfs2_read_locked_inode+0x3a1/0x630 [ocfs2]
[<ffffffff8115ce1e>] ? inode_sb_list_add+0x2e/0x40
[<ffffffffa095f19b>] ? ocfs2_iget+0x16b/0x2b0 [ocfs2]
[<ffffffffa096a542>] ? ocfs2_lookup+0xe2/0x300 [ocfs2]
[<ffffffff8115b70f>] ? __d_alloc+0x11f/0x180
[<ffffffff8114efdc>] ? d_alloc_and_lookup+0x3c/0x90
[<ffffffff8115bd3e>] ? d_lookup+0x2e/0x60
[<ffffffff81151483>] ? do_lookup+0x293/0x390
[<ffffffff8115041a>] ? path_init+0x28a/0x3a0
[<ffffffff81151fc5>] ? path_lookupat+0x135/0x730
[<ffffffffa09ae03b>] ? ocfs2_set_buffer_uptodate+0x2b/0x130 [ocfs2]
[<ffffffffa093ca7c>] ? ocfs2_read_blocks+0x30c/0x6d0 [ocfs2]
[<ffffffff811525ec>] ? do_path_lookup+0x2c/0xd0
[<ffffffff8114f432>] ? getname_flags+0x52/0xf0
[<ffffffff81153f9c>] ? user_path_at_empty+0x5c/0xb0
[<ffffffffa0944892>] ? ocfs2_dir_foreach_blk_id+0x72/0x250 [ocfs2]
[<ffffffff811569b0>] ? filldir64+0x100/0x100
[<ffffffffa094cf0d>] ? __ocfs2_cluster_unlock.clone.19+0x2d/0xe0 [ocfs2]
[<ffffffff8114943e>] ? vfs_fstatat+0x3e/0x90
[<ffffffff811496df>] ? sys_newfstatat+0x1f/0x50
[<ffffffff8118145b>] ? fsnotify_find_inode_mark+0x2b/0x40
[<ffffffff811823b4>] ? dnotify_flush+0x54/0x110
[<ffffffff8114274f>] ? filp_close+0x5f/0x90
[<ffffffff8114280d>] ? sys_close+0x8d/0xe0
[<ffffffff814c3c52>] ? system_call_fastpath+0x16/0x1b
INFO: task du:12394 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
du              D ffff88043fc93280     0 12394  11620 0x00000000
ffff88041a49b080 0000000000000082 ffff880427110080 0000000000013280
ffff880073babfd8 0000000000013280 0000000000013280 0000000000013280
ffff880073baa000 0000000000013280 ffff880073babfd8 0000000000013280
Call Trace:
[<ffffffff814ba52d>] ? schedule_timeout+0x1ed/0x2e0
[<ffffffff8104a563>] ? __wake_up+0x43/0x70
[<ffffffffa0a8d1b8>] ? dlmlock+0x88/0xd70 [ocfs2_dlm]
[<ffffffff8104a563>] ? __wake_up+0x43/0x70
[<ffffffff814b9e5a>] ? wait_for_common+0x13a/0x190
[<ffffffff81057e10>] ? try_to_wake_up+0x280/0x280
[<ffffffffa094d898>] ? __ocfs2_cluster_lock.clone.20+0x1d8/0x800 [ocfs2]
[<ffffffff8101b815>] ? read_tsc+0x5/0x20
[<ffffffff8108c1e1>] ? ktime_get+0x61/0xf0
[<ffffffffa094dff9>] ? ocfs2_inode_lock_full_nested+0x139/0x520 [ocfs2]
[<ffffffffa095eda1>] ? ocfs2_read_locked_inode+0x3a1/0x630 [ocfs2]
[<ffffffff8115ce1e>] ? inode_sb_list_add+0x2e/0x40
[<ffffffffa095f19b>] ? ocfs2_iget+0x16b/0x2b0 [ocfs2]
[<ffffffffa096a542>] ? ocfs2_lookup+0xe2/0x300 [ocfs2]
[<ffffffff8115b70f>] ? __d_alloc+0x11f/0x180
[<ffffffff8114efdc>] ? d_alloc_and_lookup+0x3c/0x90
[<ffffffff8115bd3e>] ? d_lookup+0x2e/0x60
[<ffffffff81151483>] ? do_lookup+0x293/0x390
[<ffffffff8115041a>] ? path_init+0x28a/0x3a0
[<ffffffff81151fc5>] ? path_lookupat+0x135/0x730
[<ffffffffa09ae03b>] ? ocfs2_set_buffer_uptodate+0x2b/0x130 [ocfs2]
[<ffffffffa093ca7c>] ? ocfs2_read_blocks+0x30c/0x6d0 [ocfs2]
[<ffffffff811525ec>] ? do_path_lookup+0x2c/0xd0
[<ffffffff8114f432>] ? getname_flags+0x52/0xf0
[<ffffffff81153f9c>] ? user_path_at_empty+0x5c/0xb0
[<ffffffffa0944892>] ? ocfs2_dir_foreach_blk_id+0x72/0x250 [ocfs2]
[<ffffffff811569b0>] ? filldir64+0x100/0x100
[<ffffffffa094cf0d>] ? __ocfs2_cluster_unlock.clone.19+0x2d/0xe0 [ocfs2]
[<ffffffff8114943e>] ? vfs_fstatat+0x3e/0x90
[<ffffffff811496df>] ? sys_newfstatat+0x1f/0x50
[<ffffffff8118145b>] ? fsnotify_find_inode_mark+0x2b/0x40
[<ffffffff811823b4>] ? dnotify_flush+0x54/0x110
[<ffffffff8114274f>] ? filp_close+0x5f/0x90
[<ffffffff8114280d>] ? sys_close+0x8d/0xe0
[<ffffffff814c3c52>] ? system_call_fastpath+0x16/0x1b
INFO: task du:12394 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
du              D ffff88043fc93280     0 12394  11620 0x00000000
ffff88041a49b080 0000000000000082 ffff880427110080 0000000000013280
ffff880073babfd8 0000000000013280 0000000000013280 0000000000013280
ffff880073baa000 0000000000013280 ffff880073babfd8 0000000000013280
Call Trace:
[<ffffffff814ba52d>] ? schedule_timeout+0x1ed/0x2e0
[<ffffffff8104a563>] ? __wake_up+0x43/0x70
[<ffffffffa0a8d1b8>] ? dlmlock+0x88/0xd70 [ocfs2_dlm]
[<ffffffff8104a563>] ? __wake_up+0x43/0x70
[<ffffffff814b9e5a>] ? wait_for_common+0x13a/0x190
[<ffffffff81057e10>] ? try_to_wake_up+0x280/0x280
[<ffffffffa094d898>] ? __ocfs2_cluster_lock.clone.20+0x1d8/0x800 [ocfs2]
[<ffffffff8101b815>] ? read_tsc+0x5/0x20
[<ffffffff8108c1e1>] ? ktime_get+0x61/0xf0
[<ffffffffa094dff9>] ? ocfs2_inode_lock_full_nested+0x139/0x520 [ocfs2]
[<ffffffffa095eda1>] ? ocfs2_read_locked_inode+0x3a1/0x630 [ocfs2]
[<ffffffff8115ce1e>] ? inode_sb_list_add+0x2e/0x40
[<ffffffffa095f19b>] ? ocfs2_iget+0x16b/0x2b0 [ocfs2]
[<ffffffffa096a542>] ? ocfs2_lookup+0xe2/0x300 [ocfs2]
[<ffffffff8115b70f>] ? __d_alloc+0x11f/0x180
[<ffffffff8114efdc>] ? d_alloc_and_lookup+0x3c/0x90
[<ffffffff8115bd3e>] ? d_lookup+0x2e/0x60
[<ffffffff81151483>] ? do_lookup+0x293/0x390
[<ffffffff8115041a>] ? path_init+0x28a/0x3a0
[<ffffffff81151fc5>] ? path_lookupat+0x135/0x730
[<ffffffffa09ae03b>] ? ocfs2_set_buffer_uptodate+0x2b/0x130 [ocfs2]
[<ffffffffa093ca7c>] ? ocfs2_read_blocks+0x30c/0x6d0 [ocfs2]
[<ffffffff811525ec>] ? do_path_lookup+0x2c/0xd0
[<ffffffff8114f432>] ? getname_flags+0x52/0xf0
[<ffffffff81153f9c>] ? user_path_at_empty+0x5c/0xb0
[<ffffffffa0944892>] ? ocfs2_dir_foreach_blk_id+0x72/0x250 [ocfs2]
[<ffffffff811569b0>] ? filldir64+0x100/0x100
[<ffffffffa094cf0d>] ? __ocfs2_cluster_unlock.clone.19+0x2d/0xe0 [ocfs2]
[<ffffffff8114943e>] ? vfs_fstatat+0x3e/0x90
[<ffffffff811496df>] ? sys_newfstatat+0x1f/0x50
[<ffffffff8118145b>] ? fsnotify_find_inode_mark+0x2b/0x40
[<ffffffff811823b4>] ? dnotify_flush+0x54/0x110
[<ffffffff8114274f>] ? filp_close+0x5f/0x90
[<ffffffff8114280d>] ? sys_close+0x8d/0xe0
[<ffffffff814c3c52>] ? system_call_fastpath+0x16/0x1b
INFO: task du:12394 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
du              D ffff88043fc93280     0 12394  11620 0x00000000
ffff88041a49b080 0000000000000082 ffff880427110080 0000000000013280
ffff880073babfd8 0000000000013280 0000000000013280 0000000000013280
ffff880073baa000 0000000000013280 ffff880073babfd8 0000000000013280
Call Trace:
[<ffffffff814ba52d>] ? schedule_timeout+0x1ed/0x2e0
[<ffffffff8104a563>] ? __wake_up+0x43/0x70
[<ffffffffa0a8d1b8>] ? dlmlock+0x88/0xd70 [ocfs2_dlm]
[<ffffffff8104a563>] ? __wake_up+0x43/0x70
[<ffffffff814b9e5a>] ? wait_for_common+0x13a/0x190
[<ffffffff81057e10>] ? try_to_wake_up+0x280/0x280
[<ffffffffa094d898>] ? __ocfs2_cluster_lock.clone.20+0x1d8/0x800 [ocfs2]
[<ffffffff8101b815>] ? read_tsc+0x5/0x20
[<ffffffff8108c1e1>] ? ktime_get+0x61/0xf0
[<ffffffffa094dff9>] ? ocfs2_inode_lock_full_nested+0x139/0x520 [ocfs2]
[<ffffffffa095eda1>] ? ocfs2_read_locked_inode+0x3a1/0x630 [ocfs2]
[<ffffffff8115ce1e>] ? inode_sb_list_add+0x2e/0x40
[<ffffffffa095f19b>] ? ocfs2_iget+0x16b/0x2b0 [ocfs2]
[<ffffffffa096a542>] ? ocfs2_lookup+0xe2/0x300 [ocfs2]
[<ffffffff8115b70f>] ? __d_alloc+0x11f/0x180
[<ffffffff8114efdc>] ? d_alloc_and_lookup+0x3c/0x90
[<ffffffff8115bd3e>] ? d_lookup+0x2e/0x60
[<ffffffff81151483>] ? do_lookup+0x293/0x390
[<ffffffff8115041a>] ? path_init+0x28a/0x3a0
[<ffffffff81151fc5>] ? path_lookupat+0x135/0x730
[<ffffffffa09ae03b>] ? ocfs2_set_buffer_uptodate+0x2b/0x130 [ocfs2]
[<ffffffffa093ca7c>] ? ocfs2_read_blocks+0x30c/0x6d0 [ocfs2]
[<ffffffff811525ec>] ? do_path_lookup+0x2c/0xd0
[<ffffffff8114f432>] ? getname_flags+0x52/0xf0
[<ffffffff81153f9c>] ? user_path_at_empty+0x5c/0xb0
[<ffffffffa0944892>] ? ocfs2_dir_foreach_blk_id+0x72/0x250 [ocfs2]
[<ffffffff811569b0>] ? filldir64+0x100/0x100
[<ffffffffa094cf0d>] ? __ocfs2_cluster_unlock.clone.19+0x2d/0xe0 [ocfs2]
[<ffffffff8114943e>] ? vfs_fstatat+0x3e/0x90
[<ffffffff811496df>] ? sys_newfstatat+0x1f/0x50
[<ffffffff8118145b>] ? fsnotify_find_inode_mark+0x2b/0x40
[<ffffffff811823b4>] ? dnotify_flush+0x54/0x110
[<ffffffff8114274f>] ? filp_close+0x5f/0x90
[<ffffffff8114280d>] ? sys_close+0x8d/0xe0
[<ffffffff814c3c52>] ? system_call_fastpath+0x16/0x1b
INFO: task du:12394 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
du              D ffff88043fc93280     0 12394  11620 0x00000000
ffff88041a49b080 0000000000000082 ffff880427110080 0000000000013280
ffff880073babfd8 0000000000013280 0000000000013280 0000000000013280
ffff880073baa000 0000000000013280 ffff880073babfd8 0000000000013280
Call Trace:
[<ffffffff814ba52d>] ? schedule_timeout+0x1ed/0x2e0
[<ffffffff8104a563>] ? __wake_up+0x43/0x70
[<ffffffffa0a8d1b8>] ? dlmlock+0x88/0xd70 [ocfs2_dlm]
[<ffffffff8104a563>] ? __wake_up+0x43/0x70
[<ffffffff814b9e5a>] ? wait_for_common+0x13a/0x190
[<ffffffff81057e10>] ? try_to_wake_up+0x280/0x280
[<ffffffffa094d898>] ? __ocfs2_cluster_lock.clone.20+0x1d8/0x800 [ocfs2]
[<ffffffff8101b815>] ? read_tsc+0x5/0x20
[<ffffffff8108c1e1>] ? ktime_get+0x61/0xf0
[<ffffffffa094dff9>] ? ocfs2_inode_lock_full_nested+0x139/0x520 [ocfs2]
[<ffffffffa095eda1>] ? ocfs2_read_locked_inode+0x3a1/0x630 [ocfs2]
[<ffffffff8115ce1e>] ? inode_sb_list_add+0x2e/0x40
[<ffffffffa095f19b>] ? ocfs2_iget+0x16b/0x2b0 [ocfs2]
[<ffffffffa096a542>] ? ocfs2_lookup+0xe2/0x300 [ocfs2]
[<ffffffff8115b70f>] ? __d_alloc+0x11f/0x180
[<ffffffff8114efdc>] ? d_alloc_and_lookup+0x3c/0x90
[<ffffffff8115bd3e>] ? d_lookup+0x2e/0x60
[<ffffffff81151483>] ? do_lookup+0x293/0x390
[<ffffffff8115041a>] ? path_init+0x28a/0x3a0
[<ffffffff81151fc5>] ? path_lookupat+0x135/0x730
[<ffffffffa09ae03b>] ? ocfs2_set_buffer_uptodate+0x2b/0x130 [ocfs2]
[<ffffffffa093ca7c>] ? ocfs2_read_blocks+0x30c/0x6d0 [ocfs2]
[<ffffffff811525ec>] ? do_path_lookup+0x2c/0xd0
[<ffffffff8114f432>] ? getname_flags+0x52/0xf0
[<ffffffff81153f9c>] ? user_path_at_empty+0x5c/0xb0
[<ffffffffa0944892>] ? ocfs2_dir_foreach_blk_id+0x72/0x250 [ocfs2]
[<ffffffff811569b0>] ? filldir64+0x100/0x100
[<ffffffffa094cf0d>] ? __ocfs2_cluster_unlock.clone.19+0x2d/0xe0 [ocfs2]
[<ffffffff8114943e>] ? vfs_fstatat+0x3e/0x90
[<ffffffff811496df>] ? sys_newfstatat+0x1f/0x50
[<ffffffff8118145b>] ? fsnotify_find_inode_mark+0x2b/0x40
[<ffffffff811823b4>] ? dnotify_flush+0x54/0x110
[<ffffffff8114274f>] ? filp_close+0x5f/0x90
[<ffffffff8114280d>] ? sys_close+0x8d/0xe0
[<ffffffff814c3c52>] ? system_call_fastpath+0x16/0x1b
INFO: task du:12394 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
du              D ffff88043fc93280     0 12394  11620 0x00000000
ffff88041a49b080 0000000000000082 ffff880427110080 0000000000013280
ffff880073babfd8 0000000000013280 0000000000013280 0000000000013280
ffff880073baa000 0000000000013280 ffff880073babfd8 0000000000013280
Call Trace:
[<ffffffff814ba52d>] ? schedule_timeout+0x1ed/0x2e0
[<ffffffff8104a563>] ? __wake_up+0x43/0x70
[<ffffffffa0a8d1b8>] ? dlmlock+0x88/0xd70 [ocfs2_dlm]
[<ffffffff8104a563>] ? __wake_up+0x43/0x70
[<ffffffff814b9e5a>] ? wait_for_common+0x13a/0x190
[<ffffffff81057e10>] ? try_to_wake_up+0x280/0x280
[<ffffffffa094d898>] ? __ocfs2_cluster_lock.clone.20+0x1d8/0x800 [ocfs2]
[<ffffffff8101b815>] ? read_tsc+0x5/0x20
[<ffffffff8108c1e1>] ? ktime_get+0x61/0xf0
[<ffffffffa094dff9>] ? ocfs2_inode_lock_full_nested+0x139/0x520 [ocfs2]
[<ffffffffa095eda1>] ? ocfs2_read_locked_inode+0x3a1/0x630 [ocfs2]
[<ffffffff8115ce1e>] ? inode_sb_list_add+0x2e/0x40
[<ffffffffa095f19b>] ? ocfs2_iget+0x16b/0x2b0 [ocfs2]
[<ffffffffa096a542>] ? ocfs2_lookup+0xe2/0x300 [ocfs2]
[<ffffffff8115b70f>] ? __d_alloc+0x11f/0x180
[<ffffffff8114efdc>] ? d_alloc_and_lookup+0x3c/0x90
[<ffffffff8115bd3e>] ? d_lookup+0x2e/0x60
[<ffffffff81151483>] ? do_lookup+0x293/0x390
[<ffffffff8115041a>] ? path_init+0x28a/0x3a0
[<ffffffff81151fc5>] ? path_lookupat+0x135/0x730
[<ffffffffa09ae03b>] ? ocfs2_set_buffer_uptodate+0x2b/0x130 [ocfs2]
[<ffffffffa093ca7c>] ? ocfs2_read_blocks+0x30c/0x6d0 [ocfs2]
[<ffffffff811525ec>] ? do_path_lookup+0x2c/0xd0
[<ffffffff8114f432>] ? getname_flags+0x52/0xf0
[<ffffffff81153f9c>] ? user_path_at_empty+0x5c/0xb0
[<ffffffffa0944892>] ? ocfs2_dir_foreach_blk_id+0x72/0x250 [ocfs2]
[<ffffffff811569b0>] ? filldir64+0x100/0x100
[<ffffffffa094cf0d>] ? __ocfs2_cluster_unlock.clone.19+0x2d/0xe0 [ocfs2]
[<ffffffff8114943e>] ? vfs_fstatat+0x3e/0x90
[<ffffffff811496df>] ? sys_newfstatat+0x1f/0x50
[<ffffffff8118145b>] ? fsnotify_find_inode_mark+0x2b/0x40
[<ffffffff811823b4>] ? dnotify_flush+0x54/0x110
[<ffffffff8114274f>] ? filp_close+0x5f/0x90
[<ffffffff8114280d>] ? sys_close+0x8d/0xe0
[<ffffffff814c3c52>] ? system_call_fastpath+0x16/0x1b


Thanks
Marek 
