From: Villalovos, John L <john.l.villalovos@intel.com>
Date: Mon Feb  2 13:53:59 2004
Subject: [Ocfs2-devel] RE: [Ocfs2-users] RE: Playing with OCFS2
Message-ID: <50D19C3AC815734C9E19FE4C4F6128A602A5686A@orsmsx403.jf.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

So I am playing with OCFS2 and this is what happens when I attempt to
mount a parition:


First load the driver:
Feb  2 11:43:43 linuxjohn2 kernel: Oracle Cluster FileSystem
1.9.9-UNSTABLE Thu Jan 29 14:13:02 PST 2004 (build
b806b510b69ae78da50b3aba40b3e052)
Feb  2 11:43:43 linuxjohn2 kernel: ocfs2: hostname is
linuxjohn2.co.intel.com

I did a rescan-scsi-bus here:
Feb  2 11:44:30 linuxjohn2  -- root[2835]: ROOT LOGIN ON tty2
Feb  2 11:44:49 linuxjohn2 kernel: scsi singledevice 0 0 1 0
Feb  2 11:44:49 linuxjohn2 kernel: scsi singledevice 0 0 2 0
Feb  2 11:44:49 linuxjohn2 kernel: scsi singledevice 0 0 3 0
Feb  2 11:44:49 linuxjohn2 kernel: scsi singledevice 0 0 4 0
Feb  2 11:44:49 linuxjohn2 kernel: scsi singledevice 0 0 5 0
Feb  2 11:44:49 linuxjohn2 kernel: scsi singledevice 0 0 6 0
Feb  2 11:44:49 linuxjohn2 kernel: scsi singledevice 0 0 7 0
Feb  2 11:44:49 linuxjohn2 kernel: scsi singledevice 1 0 0 0
Feb  2 11:44:49 linuxjohn2 kernel: blk: queue ccba4614, I/O limit 4095Mb
(mask 0xffffffff)
Feb  2 11:44:49 linuxjohn2 kernel:   Vendor: Maxtor    Model: OneTouch
Rev: 0200
Feb  2 11:44:49 linuxjohn2 kernel:   Type:   Direct-Access
ANSI SCSI revision: 06
Feb  2 11:44:49 linuxjohn2 kernel: blk: queue ccba4414, I/O limit 4095Mb
(mask 0xffffffff)
Feb  2 11:44:49 linuxjohn2 kernel: Attached scsi disk sda at scsi1,
channel 0, id 0, lun 0
Feb  2 11:44:49 linuxjohn2 kernel: SCSI device sda: 398295040 512-byte
hdwr sectors (203927 MB)
Feb  2 11:44:49 linuxjohn2 kernel:  sda: sda1
Feb  2 11:44:49 linuxjohn2 kernel: scsi singledevice 1 0 1 0
Feb  2 11:44:49 linuxjohn2 kernel: scsi singledevice 1 0 2 0
Feb  2 11:44:49 linuxjohn2 kernel: scsi singledevice 1 0 3 0
Feb  2 11:44:49 linuxjohn2 kernel: scsi singledevice 1 0 4 0
Feb  2 11:44:49 linuxjohn2 kernel: scsi singledevice 1 0 5 0
Feb  2 11:44:49 linuxjohn2 kernel: scsi singledevice 1 0 6 0
Feb  2 11:44:49 linuxjohn2 kernel: scsi singledevice 1 0 7 0

Here is where I did the: mount -t ocfs2 /dev/sda1 /ocfs/
Feb  2 11:45:02 linuxjohn2 kernel: ------------[ cut here ]------------
Feb  2 11:45:02 linuxjohn2 kernel: kernel BUG at hash.c:1321!
Feb  2 11:45:02 linuxjohn2 kernel: invalid operand: 0000
Feb  2 11:45:02 linuxjohn2 kernel: sd_mod ocfs2 parport_pc lp parport
autofs 3c59x floppy sg sr_mod microcode sbp2 ide-scsi scsi_mod ide-cd
cdrom ohci1394 ieee1394 keybdev mousedev hid input us
Feb  2 11:45:02 linuxjohn2 kernel: CPU:    0
Feb  2 11:45:02 linuxjohn2 kernel: EIP:    0060:[<d097fd8b>]    Not
tainted
Feb  2 11:45:02 linuxjohn2 kernel: EFLAGS: 00010292
Feb  2 11:45:02 linuxjohn2 kernel: 
Feb  2 11:45:02 linuxjohn2 kernel: EIP is at __ocfs_inode_hash_lookup
[ocfs2] 0x1b (2.4.22-1.2149.nptl)
Feb  2 11:45:02 linuxjohn2 kernel: eax: 0024e000   ebx: 00000000   ecx:
c9bd0000   edx: 00000000
Feb  2 11:45:02 linuxjohn2 kernel: esi: ca323a34   edi: 0024e000   ebp:
00000000   esp: c9b4dd08
Feb  2 11:45:02 linuxjohn2 kernel: ds: 0068   es: 0068   ss: 0068
Feb  2 11:45:02 linuxjohn2 kernel: Process mount (pid: 3318,
stackpage=c9b4d000)
Feb  2 11:45:02 linuxjohn2 kernel: Stack: ca2bae80 ca2b2380 00000000
00000000 00000000 00000000 ca323a34 d0980007 
Feb  2 11:45:02 linuxjohn2 kernel:        ca323a34 0024e000 00000000
c9bd0000 c9bd0000 00000000 00000000 00000000 
Feb  2 11:45:02 linuxjohn2 kernel:        0024e000 00000000 ca323008
00000000 00000000 ca323000 ca323008 d099b89b 
Feb  2 11:45:02 linuxjohn2 kernel: Call Trace:   [<d0980007>]
ocfs_inode_hash_insert [ocfs2] 0xc7 (0xc9b4dd24)
Feb  2 11:45:02 linuxjohn2 kernel: [<d099b89b>] ocfs_create_root_oin
[ocfs2] 0x2af (0xc9b4dd64)
Feb  2 11:45:02 linuxjohn2 kernel: [<d09a1629>] ocfs_mount_volume
[ocfs2] 0x4e9 (0xc9b4ddc4)
Feb  2 11:45:02 linuxjohn2 kernel: [<d09a19b6>] ocfs_mount_volume
[ocfs2] 0x876 (0xc9b4ddd4)
Feb  2 11:45:02 linuxjohn2 kernel: [<d099fa7c>] ocfs_del_sem [ocfs2]
0xdc (0xc9b4de48)
Feb  2 11:45:02 linuxjohn2 kernel: [<c0149ffd>] set_blocksize [kernel]
0xfd (0xc9b4de6c)
Feb  2 11:45:02 linuxjohn2 kernel: [<d099fb90>] ocfs_read_super [ocfs2]
0xf4 (0xc9b4de84)
Feb  2 11:45:02 linuxjohn2 kernel: [<c0149743>] get_sb_bdev [kernel]
0x1a3 (0xc9b4deb4)
Feb  2 11:45:02 linuxjohn2 kernel: [<d09b73b0>] ocfs_fs_type [ocfs2] 0x0
(0xc9b4def8)
Feb  2 11:45:02 linuxjohn2 kernel: [<c0149ab1>] do_kern_mount [kernel]
0x121 (0xc9b4df00)
Feb  2 11:45:02 linuxjohn2 kernel: [<d09b73b0>] ocfs_fs_type [ocfs2] 0x0
(0xc9b4df04)
Feb  2 11:45:02 linuxjohn2 kernel: [<c015d053>] do_add_mount [kernel]
0x93 (0xc9b4df24)
Feb  2 11:45:02 linuxjohn2 kernel: [<c015d380>] do_mount [kernel] 0x160
(0xc9b4df44)
Feb  2 11:45:02 linuxjohn2 kernel: [<c015d1c9>] copy_mount_options
[kernel] 0x79 (0xc9b4df74)
Feb  2 11:45:02 linuxjohn2 kernel: [<c015d7a1>] sys_mount [kernel] 0xb1
(0xc9b4df94)
Feb  2 11:45:02 linuxjohn2 kernel: [<c0109747>] system_call [kernel]
0x33 (0xc9b4dfc0)
Feb  2 11:45:02 linuxjohn2 kernel: 
Feb  2 11:45:02 linuxjohn2 kernel: 
Feb  2 11:45:02 linuxjohn2 kernel: Code: 0f 0b 29 05 6d ba 9a d0 8b 06
99 52 89 eb 50 c1 eb 09 89 f9


Thanks,
John
