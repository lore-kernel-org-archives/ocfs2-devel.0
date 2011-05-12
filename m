From: Goldwyn Rodrigues <rgoldwyn@gmail.com>
Date: Wed, 11 May 2011 21:13:14 -0500
Subject: [Ocfs2-devel] ocfs2 crashes on xfstest 013
Message-ID: <BANLkTi=VjeRc_6t-4vmCxpvwRAxCYjB_KA@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,

While running xfstest number 013 on an ocfs2 partition, it crashes with
the following message:

[  463.874451] (fsstress,2615,0):ocfs2_unlink:953 ERROR: status = -39
[  463.876197] (fsstress,2615,0):ocfs2_unlink:953 ERROR: status = -39
[  463.983814] (fsstress,2619,1):ocfs2_unlink:953 ERROR: status = -39
[  464.025495] (fsstress,2630,0):ocfs2_unlink:953 ERROR: status = -39
[  464.401278] ------------[ cut here ]------------
[  464.401291] kernel BUG at fs/ocfs2/alloc.c:5507!
[  464.401304] invalid opcode: 0000 [#1] PREEMPT SMP
[  464.401317] last sysfs file:
/sys/devices/pci0000:00/0000:00:0e.0/host0/target0:0:0/0:0:0:0/block/sda/dev
[  464.401332] Modules linked in: ocfs2 ocfs2_nodemanager configfs
ocfs2_stackglue quota_tree snd_pcm_oss snd_mixer_oss snd_seq
snd_seq_device edd microcode dm_mod snd_hda_codec_realtek snd_hda_intel
snd_hda_codec snd_hwdep snd_pcm snd_timer sr_mod sg cdrom i2c_nforce2
pcspkr serio_raw snd wmi r8169 soundcore snd_page_alloc ext4 jbd2 crc16
nouveau ttm drm_kms_helper drm i2c_algo_bit video button fan processor
ata_generic pata_amd thermal thermal_sys
[  464.401403]
[  464.401408] Pid: 2626, comm: fsstress Not tainted 2.6.39-rc7-up+ #1
eMachines ET1810/EMCP73VT-PM
[  464.401419] EIP: 0060:[<f7ec8930>] EFLAGS: 00210293 CPU: 0
[  464.401463] EIP is at ocfs2_remove_extent+0xba0/0xbb0 [ocfs2]
[  464.401470] EAX: 00000043 EBX: 00000129 ECX: 00000000 EDX: edff30c0
[  464.401476] ESI: 00000043 EDI: 00000000 EBP: f2321ce0 ESP: f2321c4c
[  464.401482]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[  464.401488] Process fsstress (pid: 2626, ti=f2320000 task=f231ede0
task.ti=f2320000)
[  464.401495] Stack:
[  464.401498]  c02674b0 f2321c50 f2321c50 00200082 efccfc88 efd00be4
efccfc88 f2321c70
[  464.401510]  f7ef357b f2321c78 f7f43920 00000043 efd00be4 00000001
00000000 000ee000
[  464.401522]  00000129 0000002b edff30c0 000ee000 f1ea02c0 f2321de0
0000003b c03673eb
[  464.401533] Call Trace:
[  464.401547]  [<c02674b0>] ? autoremove_wake_function+0x40/0x40
[  464.401577]  [<f7ef357b>] ? ocfs2_inode_cache_io_unlock+0xb/0x10
[ocfs2]
[  464.401615]  [<f7f43920>] ? ocfs2_metadata_cache_io_unlock+0x10/0x20
[ocfs2]
[  464.401627]  [<c03673eb>] ? __dquot_free_space+0x3b/0x2f0
[  464.401654]  [<f7efa2ca>] ? ocfs2_journal_access_di+0x1a/0x20 [ocfs2]
[  464.401679]  [<f7ec9028>] ocfs2_remove_btree_range+0x6e8/0xa20
[ocfs2]
[  464.401690]  [<c0311546>] ? kmem_cache_alloc_trace+0x156/0x160
[  464.401716]  [<f7efa050>] ? ocfs2_commit_trans+0xf0/0x110 [ocfs2]
[  464.401744]  [<f7eee449>] __ocfs2_change_file_space+0x1199/0x19f0
[ocfs2]
[  464.401753]  [<c032a941>] ? acl_permission_check+0x21/0xb0
[  464.401780]  [<f7efa2b0>] ? ocfs2_extend_trans+0x240/0x240 [ocfs2]
[  464.401808]  [<f7ef1962>] ocfs2_change_file_space+0xb2/0xc0 [ocfs2]
[  464.401836]  [<f7ef8169>] ocfs2_ioctl+0x319/0x6f0 [ocfs2]
[  464.401844]  [<c032ab75>] ? path_put+0x15/0x20
[  464.401868]  [<f7ee3efa>] ? ocfs2_inode_unlock+0x4a/0xa0 [ocfs2]
[  464.401893]  [<f7ee3efa>] ? ocfs2_inode_unlock+0x4a/0xa0 [ocfs2]
[  464.401904]  [<c040e92e>] ? copy_to_user+0x2e/0x50
[  464.401911]  [<c0325a5c>] ? cp_new_stat64+0xdc/0xf0
[  464.401937]  [<f7ef7e50>] ? ocfs2_info_handle+0x80/0x80 [ocfs2]
[  464.401945]  [<c03315bd>] do_vfs_ioctl+0x43d/0x5b0
[  464.401952]  [<c03261f2>] ? sys_fstat64+0x22/0x30
[  464.401958]  [<c03317af>] sys_ioctl+0x7f/0x90
[  464.401967]  [<c0683998>] sysenter_do_call+0x12/0x28
[  464.401973] Code: 0c bb e2 ff ff ff 89 7c 24 14 89 74 24 10 c7 44 24
08 30 b6 f6 f7 c7 44 24 04 03 03 f6 f7 89 04 24 e8 45 9e 07 00 e9 00 f8
ff ff <0f> 0b 8d b4 26 00 00 00 00 8d bc 27 00 00 00 00 55 89 e5 57 56
[  464.402024] EIP: [<f7ec8930>] ocfs2_remove_extent+0xba0/0xbb0 [ocfs2]
SS:ESP 0068:f2321c4c
[  464.402436] ---[ end trace 51ce626abe09c6ef ]---
[  464.435066] (fsstress,2625,0):ocfs2_unlink:953 ERROR: status = -39
[  464.435162] (fsstress,2631,1):ocfs2_unlink:953 ERROR: status = -39
[  464.435316] (fsstress,2621,1):ocfs2_unlink:953 ERROR: status = -39
[  464.436405] (fsstress,2634,0):ocfs2_unlink:953 ERROR: status = -39
[  464.436443] (fsstress,2634,0):ocfs2_unlink:953 ERROR: status = -39

This is reproducible always, and even on a local mount.
The kernel I used is the Linus's latest git tree, or version 2.6.39-rc7

Let me know if you need more information.

-- 
Goldwyn
