From: admin at wset.edu.pl <admin@wset.edu.pl>
Date: Tue, 19 Mar 2013 11:37:47 +0100
Subject: [Ocfs2-devel] OEL 6.4 + OCFS 1.8 - Kernel Panic!!
In-Reply-To: <8559D8CB453B48549C1F80A7E405A159@tktelekom.net>
References: <FAD1D0B76E0B47DF8196B6FCEA20EF7D@tktelekom.net>
	<8559D8CB453B48549C1F80A7E405A159@tktelekom.net>
Message-ID: <485E381CE72B46DC8E9DA24AC7274FE1@tktelekom.net>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Ok i got log from kernel panic - how to reproduce:
Install fresh OEL 6.4

[root at OCFS2-1 ~]# mkfs.ocfs2 -N 2 -L MAIL --fs-feature-level=max-features /dev/sdb1
mkfs.ocfs2 1.8.0
Cluster stack: classic o2cb
Overwriting existing ocfs2 partition.
Proceed (y/N): Y
Label: MAIL
Features: sparse extended-slotmap backup-super unwritten inline-data strict-journal-super metaecc xattr indexed-dirs usrquota grpquota refcount discontig-bg
Block size: 4096 (12 bits)
Cluster size: 4096 (12 bits)
Volume size: 17179836416 (4194296 clusters) (4194296 blocks)
Cluster groups: 131 (tail covers 1016 clusters, rest cover 32256 clusters)
Extent allocator size: 12582912 (3 groups)
Journal size: 107372544
Node slots: 2
Creating bitmaps: done
Initializing superblock: done
Writing system files: done
Writing superblock: done
Writing backup superblock: 2 block(s)
Formatting Journals: done
Growing extent allocator: done
Formatting slot map: done
Formatting quota files: done
Writing lost+found: done
mkfs.ocfs2 successful

[root at OCFS2-1 ~]# cat /etc/fstab
/dev/sdb1               /home        ocfs2           _netdev,defaults,usrquota,noatime,data=writeback,commit=30      0 0

[root at OCFS2-1 ~]# cat /proc/mounts
/dev/sdb1 /home ocfs2 rw,seclabel,noatime,_netdev,heartbeat=local,nointr,data=writeback,errors=remount-ro,commit=30,usrquota,coherency=full,user_xattr,acl 0 0

i create and run own terror script on both servers in cluster to check stability of ocfs2:
[root at OCFS2-2 ~]# cat terror.sh
#!/bin/bash
while true
do
rm -rf /home/1
mkdir /home/1
cp -r /usr /home/1
rm -rf /home/1
done

[root at OCFS2-2 ~]# cat terror2.sh
#!/bin/bash
while true
do
du -sh /home/1
find /home/1
sleep 30
done;

[root at OCFS2-2 ~]# cat terror3.sh
#!/bin/bash
while true
do
quota -v root
sleep 30
done;

After few minutes get kernel panic this is log:
Mar 19 11:33:01 (rm,2184,0):ocfs2_unlink:951 ERROR: status = -2
Mar 19 11:33:01 (rm,2304,3):ocfs2_unlink:951 ERROR: status = -39
Mar 19 11:33:01 (cp,2312,1):ocfs2_check_dir_for_entry:2119 ERROR: status = -17
Mar 19 11:33:01 (cp,2312,1):ocfs2_mknod:459 ERROR: status = -17
Mar 19 11:33:01 (cp,2312,1):ocfs2_create:629 ERROR: status = ?17
Mar 19 11:33:02 OCFS2-1 kernel: (updatedb,3121,1):o2net_send_tcp_msg:961 ERROR: sendmsg returned -13 instead of 96
Mar 19 11:33:02 OCFS2-1 kernel: (updatedb,3121,1):dlm_do_master_request:1326 ERROR: status = -13
Mar 19 11:33:02 OCFS2-1 kernel: (updatedb,3121,1):dlm_do_master_request:1327 ERROR: unhandled error!
Mar 19 11:33:02 OCFS2-1 kernel: ------------[ cut here ]------------
Mar 19 11:33:02 OCFS2-1 kernel: kernel BUG at fs/ocfs2/dlm/dlmmaster.c:1328!

Message from syslogd at OCFS2-1 at Mar 19 11:33:02 ...
kernel:------------[ cut here ]------------
Mar 19 11:33:02 OCFS2-1 kernel: invalid opcode: 0000 [#1] SMP
Mar 19 11:33:02 OCFS2-1 kernel: CPU 1
Mar 19 11:33:02 OCFS2-1 kernel: Modules linked in: ocfs2 autofs4 ocfs2_dlmfs ocfs2_stack_o2cb ocfs2_dlm ocfs2_nodemanager ocfs2_stackglue configfs sunrpc ipv6 ppdev e1000 microcode vmw_balloon parport_pc parport pcspkr sg i2c_piix4 i2c_core shpchp ext4 mbcache jbd2 sd_mod crc_t10dif sr_mod cdrom mptspi mptscsih mptbase scsi_transport_spi pata_acpi ata_generic ata_piix floppy dm_mirror dm_region_hash dm_log dm_mod [last unloaded: speedstep_lib]
Mar 19 11:33:02 OCFS2-1 kernel:

Message from syslogd at OCFS2-1 at Mar 19 11:33:02 ...
kernel:invalid opcode: 0000 [#1] SMP
Mar 19 11:33:02 OCFS2-1 kernel: Pid: 3121, comm: updatedb Not tainted 2.6.39-400.17.2.el6uek.x86_64 #1 VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform
Mar 19 11:33:02 OCFS2-1 kernel: RIP: 0010:[<ffffffffa02f9e4b>]  [<ffffffffa02f9e4b>] dlm_do_master_request+0x4bb/0x6f0 [ocfs2_dlm]
Mar 19 11:33:02 OCFS2-1 kernel: RSP: 0018:ffff8801095015b8  EFLAGS: 00010292
Mar 19 11:33:02 OCFS2-1 kernel: RAX: 000000000000004a RBX: fffffffffffffff3 RCX: 0000000000000000
Mar 19 11:33:02 OCFS2-1 kernel: RDX: 0000000000000000 RSI: 0000000000000082 RDI: 0000000000000246
Mar 19 11:33:02 OCFS2-1 kernel: RBP: ffff8801095016f8 R08: 0000000000000000 R09: ffffffff815649a0
Mar 19 11:33:02 OCFS2-1 kernel: R10: 656c646e61686e75 R11: 0000000000000001 R12: 0000000000000001
Mar 19 11:33:02 OCFS2-1 kernel: R13: ffff88006465e540 R14: ffff880133dda800 R15: ffff88006465e5d8
Mar 19 11:33:02 OCFS2-1 kernel: FS:  00007f4e44beb700(0000) GS:ffff88013fc80000(0000) knlGS:0000000000000000
Mar 19 11:33:02 OCFS2-1 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Mar 19 11:33:02 OCFS2-1 kernel: CR2: 00007f4e44bf4000 CR3: 0000000128445000 CR4: 00000000000006e0
Mar 19 11:33:02 OCFS2-1 kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Mar 19 11:33:02 OCFS2-1 kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Mar 19 11:33:02 OCFS2-1 kernel: Process updatedb (pid: 3121, threadinfo ffff880109500000, task ffff880134e7a540)
Mar 19 11:33:02 OCFS2-1 kernel: Stack:
Mar 19 11:33:02 OCFS2-1 kernel: fffffffffffffff3 ffffffff8105b3c0 ffff88013707e348 ffff880134e7a540
Mar 19 11:33:02 OCFS2-1 kernel: ffff880109501638 ffff880109501678 ffff88013707e348 ffff880134e7ab88
Mar 19 11:33:02 OCFS2-1 kernel: ffff880134e7a540 ffff880134e7ab88 ffff880134e7a540 ffff880134e7ab88
Mar 19 11:33:02 OCFS2-1 kernel: Call Trace:
Mar 19 11:33:02 OCFS2-1 kernel: [<ffffffff8105b3c0>] ? __dequeue_entity+0x30/0x50
Mar 19 11:33:02 OCFS2-1 kernel: [<ffffffffa02ff19f>] dlm_get_lock_resource+0x77f/0xe30 [ocfs2_dlm]
Mar 19 11:33:02 OCFS2-1 kernel: [<ffffffff81116cda>] ? __rmqueue+0xba/0x4f0

Message from syslogd at OCFS2-1 at Mar 19 11:33:02 ...
kernel:Stack:

Message from syslogd at OCFS2-1 at Mar 19 11:33:02 ...
kernel:Call Trace:
Mar 19 11:33:02 OCFS2-1 kernel: [<ffffffff8115c371>] ? __kmalloc+0x1f1/0x200
Mar 19 11:33:02 OCFS2-1 kernel: [<ffffffffa0304334>] ? dlm_new_lock+0xd4/0x150 [ocfs2_dlm]
Mar 19 11:33:02 OCFS2-1 kernel: [<ffffffffa0305824>] dlmlock+0x4b4/0xcc0 [ocfs2_dlm]
Mar 19 11:33:02 OCFS2-1 kernel: [<ffffffff8136dc20>] ? scsi_dma_map+0x90/0xc0
Mar 19 11:33:02 OCFS2-1 kernel: [<ffffffffa016d225>] o2cb_dlm_lock+0x65/0x90 [ocfs2_stack_o2cb]
Mar 19 11:33:02 OCFS2-1 kernel: [<ffffffffa016d000>] ? 0xffffffffa016cfff
Mar 19 11:33:02 OCFS2-1 kernel: [<ffffffffa016d020>] ? o2dlm_lock_ast_wrapper+0x20/0x20 [ocfs2_stack_o2cb]
Mar 19 11:33:02 OCFS2-1 kernel: [<ffffffffa0187422>] ocfs2_dlm_lock+0x42/0x50 [ocfs2_stackglue]
Mar 19 11:33:02 OCFS2-1 kernel: [<ffffffffa035cdbb>] __ocfs2_cluster_lock+0x4eb/0x7d0 [ocfs2]
Mar 19 11:33:02 OCFS2-1 kernel: [<ffffffff81262a0f>] ? string+0x4f/0xf0
Mar 19 11:33:02 OCFS2-1 kernel: [<ffffffffa035e8fc>] ocfs2_open_lock+0xcc/0x1a0 [ocfs2]
Mar 19 11:33:02 OCFS2-1 kernel: [<ffffffffa036f8d6>] ? ocfs2_read_locked_inode+0x266/0x5e0 [ocfs2]
Mar 19 11:33:02 OCFS2-1 kernel: [<ffffffff812026ee>] ? security_inode_alloc+0x1e/0x20
Mar 19 11:33:02 OCFS2-1 kernel: [<ffffffffa036f8d6>] ocfs2_read_locked_inode+0x266/0x5e0 [ocfs2]
Mar 19 11:33:02 OCFS2-1 kernel: [<ffffffffa036fe03>] ocfs2_iget+0x1b3/0x2b0 [ocfs2]
Mar 19 11:33:02 OCFS2-1 kernel: [<ffffffffa03591ab>] ? ocfs2_lookup_ino_from_name+0x4b/0x60 [ocfs2]
Mar 19 11:33:02 OCFS2-1 kernel: [<ffffffffa037ad88>] ocfs2_lookup+0xc8/0x340 [ocfs2]
Mar 19 11:33:02 OCFS2-1 kernel: [<ffffffff8117c485>] d_alloc_and_lookup+0x45/0x90
Mar 19 11:33:02 OCFS2-1 kernel: [<ffffffff81187ce5>] ? d_lookup+0x35/0x60
Mar 19 11:33:02 OCFS2-1 kernel: [<ffffffff8117e2d0>] do_lookup+0x2e0/0x330
Mar 19 11:33:02 OCFS2-1 kernel: [<ffffffff81180724>] path_lookupat+0x134/0x680
Mar 19 11:33:02 OCFS2-1 kernel: [<ffffffff81205a6a>] ? avc_has_perm_flags+0x7a/0xa0
Mar 19 11:33:02 OCFS2-1 kernel: [<ffffffff81180ca1>] do_path_lookup+0x31/0xc0
Mar 19 11:33:02 OCFS2-1 kernel: [<ffffffff81181979>] user_path_at_empty+0x59/0xa0
Mar 19 11:33:02 OCFS2-1 kernel: [<ffffffff81206576>] ? selinux_inode_getattr+0x36/0x40
Mar 19 11:33:02 OCFS2-1 kernel: [<ffffffff81176318>] ? cp_new_stat+0xf8/0x110
Mar 19 11:33:02 OCFS2-1 kernel: [<ffffffff811819d1>] user_path_at+0x11/0x20
Mar 19 11:33:02 OCFS2-1 kernel: [<ffffffff811763fc>] vfs_fstatat+0x4c/0x90
Mar 19 11:33:02 OCFS2-1 kernel: [<ffffffff811764ae>] vfs_lstat+0x1e/0x20
Mar 19 11:33:02 OCFS2-1 kernel: [<ffffffff811764d4>] sys_newlstat+0x24/0x50
Mar 19 11:33:02 OCFS2-1 kernel: [<ffffffff810cfc47>] ? audit_syscall_entry+0x1d7/0x200
Mar 19 11:33:02 OCFS2-1 kernel: [<ffffffff810cf98b>] ? audit_syscall_exit+0x25b/0x290
Mar 19 11:33:02 OCFS2-1 kernel: [<ffffffff81517082>] system_call_fastpath+0x16/0x1b
Mar 19 11:33:02 OCFS2-1 kernel: Code: 74 70 81 fb 00 fe ff ff 74 68 83 fb e4 74 63 48 b8 40 02 00 00 00 00 00 10 48 85 05 e0 c9 fb ff 74 09 48 85 05 f7 e8 fb ff 74 04 <0f> 0b eb fe 65 48 8b 34 25 00 c4 00 00 8b 96 94 04 00 00 48 63
Mar 19 11:33:02 OCFS2-1 kernel: RIP  [<ffffffffa02f9e4b>] dlm_do_master_request+0x4bb/0x6f0 [ocfs2_dlm]
Mar 19 11:33:02 OCFS2-1 kernel: RSP <ffff8801095015b8>
Mar 19 11:33:02 OCFS2-1 kernel: ---[ end trace 28004c7608480bce ]---
Mar 19 11:33:02 OCFS2-1 kernel: Kernel panic - not syncing: Fatal exception

Message from syslogd at OCFS2-1 at Mar 19 11:33:02 ...
kernel:Code: 74 70 81 fb 00 fe ff ff 74 68 83 fb e4 74 63 48 b8 40 02 00 00 00 00 00 10 48 85 05 e0 c9 fb ff 74 09 48 85 05 f7 e8 fb ff 74 04 <0f> 0b eb fe 65 48 8b 34 25 00 c4 00 00 8b 96 94 04 00 00 48 63

Message from syslogd at OCFS2-1 at Mar 19 11:33:02 ...
kernel:Kernel panic - not syncing: Fatal exception
Mar 19 11:33:02 OCFS2-1 kernel: Pid: 3121, comm: updatedb Tainted: G      D     2.6.39-400.17.2.el6uek.x86_64 #1
Mar 19 11:33:02 OCFS2-1 kernel: Call Trace:
Mar 19 11:33:02 OCFS2-1 kernel: [<ffffffff8150bd0b>] panic+0x91/0x1a8
Mar 19 11:33:02 OCFS2-1 kernel: [<ffffffff8150fe1c>] oops_end+0xdc/0xf0
Mar 19 11:33:02 OCFS2-1 kernel: [<ffffffff8101870b>] die+0x5b/0x90
Mar 19 11:33:02 OCFS2-1 kernel: [<ffffffff8150f984>] do_trap+0xc4/0x170
Mar 19 11:33:02 OCFS2-1 kernel: [<ffffffff81016665>] do_invalid_op+0x95/0xb0
Mar 19 11:33:02 OCFS2-1 kernel: [<ffffffffa02f9e4b>] ? dlm_do_master_request+0x4bb/0x6f0 [ocfs2_dlm]
Mar 19 11:33:02 OCFS2-1 kernel: [<ffffffff8151803b>] invalid_op+0x1b/0x20
Mar 19 11:33:02 OCFS2-1 kernel: [<ffffffffa02f9e4b>] ? dlm_do_master_request+0x4bb/0x6f0 [ocfs2_dlm]
Mar 19 11:33:02 OCFS2-1 kernel: [<ffffffffa02f9eea>] ? dlm_do_master_request+0x55a/0x6f0 [ocfs2_dlm]
Mar 19 11:33:02 OCFS2-1 kernel: [<ffffffff8105b3c0>] ? __dequeue_entity+0x30/0x50
Mar 19 11:33:02 OCFS2-1 kernel: [<ffffffffa02ff19f>] dlm_get_lock_resource+0x77f/0xe30 [ocfs2_dlm]
Mar 19 11:33:02 OCFS2-1 kernel: [<ffffffff81116cda>] ? __rmqueue+0xba/0x4f0
Mar 19 11:33:02 OCFS2-1 kernel: [<ffffffff8115c371>] ? __kmalloc+0x1f1/0x200
Mar 19 11:33:02 OCFS2-1 kernel: [<ffffffffa0304334>] ? dlm_new_lock+0xd4/0x150 [ocfs2_dlm]
Mar 19 11:33:02 OCFS2-1 kernel: [<ffffffffa0305824>] dlmlock+0x4b4/0xcc0 [ocfs2_dlm]
Mar 19 11:33:02 OCFS2-1 kernel: [<ffffffff8136dc20>] ? scsi_dma_map+0x90/0xc0
Mar 19 11:33:02 OCFS2-1 kernel: [<ffffffffa016d225>] o2cb_dlm_lock+0x65/0x90 [ocfs2_stack_o2cb]
Mar 19 11:33:02 OCFS2-1 kernel: [<ffffffffa016d000>] ? 0xffffffffa016cfff
Mar 19 11:33:02 OCFS2-1 kernel: [<ffffffffa016d020>] ? o2dlm_lock_ast_wrapper+0x20/0x20 [ocfs2_stack_o2cb]
Mar 19 11:33:02 OCFS2-1 kernel: [<ffffffffa0187422>] ocfs2_dlm_lock+0x42/0x50 [ocfs2_stackglue]
Mar 19 11:33:02 OCFS2-1 kernel: [<ffffffffa035cdbb>] __ocfs2_cluster_lock+0x4eb/0x7d0 [ocfs2]
Mar 19 11:33:02 OCFS2-1 kernel: [<ffffffff81262a0f>] ? string+0x4f/0xf0
Mar 19 11:33:02 OCFS2-1 kernel: [<ffffffffa035e8fc>] ocfs2_open_lock+0xcc/0x1a0 [ocfs2]
Mar 19 11:33:02 OCFS2-1 kernel: [<ffffffffa036f8d6>] ? ocfs2_read_locked_inode+0x266/0x5e0 [ocfs2]
Mar 19 11:33:02 OCFS2-1 kernel: [<ffffffff812026ee>] ? security_inode_alloc+0x1e/0x20
Mar 19 11:33:02 OCFS2-1 kernel: [<ffffffffa036f8d6>] ocfs2_read_locked_inode+0x266/0x5e0 [ocfs2]
-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20130319/7f7628d1/attachment-0001.html 
