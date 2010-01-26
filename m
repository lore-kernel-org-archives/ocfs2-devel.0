From: David Teigland <teigland@redhat.com>
Date: Tue, 26 Jan 2010 13:53:05 -0600
Subject: [Ocfs2-devel] dlmglue fixes
In-Reply-To: <4B5F400A.9080909@oracle.com>
References: <1264099803-16680-1-git-send-email-sunil.mushran@oracle.com>
	<20100126123325.GB3845@mail.oracle.com>
	<20100126163749.GA17656@redhat.com> <4B5F400A.9080909@oracle.com>
Message-ID: <20100126195305.GB17656@redhat.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Jan 26, 2010 at 11:18:34AM -0800, Sunil Mushran wrote:
> Thanks for running the test. Did this happen on all three nodes?

First time it was 2 of 3, second time it was 1 of 3.

> Also, was there another message like the following?
> 
>                mlog(ML_ERROR, "lockres->l_level (%d) <= new_level (%d)\n",
>                     lockres->l_level, new_level);

Oops, yeah, I missed copying that:

Jan 26 10:08:31 bull-02 kernel: (1995,1):ocfs2_prepare_downconvert:3280 ERROR: lockres->l_level (0) <= new_level (0)
Jan 26 10:08:31 bull-02 kernel: ------------[ cut here ]------------
Jan 26 10:08:31 bull-02 kernel: kernel BUG@fs/ocfs2/dlmglue.c:3281!
Jan 26 10:08:31 bull-02 kernel: invalid opcode: 0000 [#1] SMP 
Jan 26 10:08:31 bull-02 kernel: last sysfs file: /sys/devices/pci0000:00/0000:00:0d.0/0000:03:00.0/irq
Jan 26 10:08:31 bull-02 kernel: CPU 1 
Jan 26 10:08:31 bull-02 kernel: Modules linked in: ocfs2_stack_user dlm ocfs2 ocfs2_nodemanager configfs ocfs2_stackglue sunrpc ipv6 cpufreq_
ondemand powernow_k8 freq_table dm_multipath amd64_edac_mod i2c_nforce2 tg3 shpchp serio_raw edac_core i2c_core k8temp qla2xxx mptspi mptscsi
h ata_generic scsi_transport_fc pata_acpi mptbase sata_nv scsi_transport_spi pata_amd scsi_tgt [last unloaded: scsi_wait_scan]
Jan 26 10:08:31 bull-02 kernel: Pid: 1995, comm: ocfs2dc Not tainted 2.6.32.3 #2 ProLiant DL145 G2
Jan 26 10:08:31 bull-02 kernel: RIP: 0010:[<ffffffffa020993d>]  [<ffffffffa020993d>] ocfs2_prepare_downconvert+0x93/0x11c [ocfs2]
Jan 26 10:08:31 bull-02 kernel: RSP: 0018:ffff88007aa37d90  EFLAGS: 00010082
Jan 26 10:08:31 bull-02 kernel: RAX: 000000000000005b RBX: ffff88013bf4f1d0 RCX: 0000000000000aa6
Jan 26 10:08:31 bull-02 kernel: RDX: 0000000000000000 RSI: 0000000000000046 RDI: 0000000000000046
Jan 26 10:08:31 bull-02 kernel: RBP: ffff88007aa37db0 R08: ffff88007aa37cd0 R09: 0000000000000000
Jan 26 10:08:31 bull-02 kernel: R10: 0000000000000000 R11: 000000107ce1fc00 R12: 0000000000000000
Jan 26 10:08:31 bull-02 kernel: R13: ffff88007cc55000 R14: 0000000000000293 R15: ffff88013bf4f1e8
Jan 26 10:08:31 bull-02 kernel: FS:  00007fe27c39b700(0000) GS:ffff880028300000(0000) knlGS:0000000000000000
Jan 26 10:08:31 bull-02 kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Jan 26 10:08:31 bull-02 kernel: CR2: 0000000000bb3000 CR3: 00000001382f1000 CR4: 00000000000006e0
Jan 26 10:08:31 bull-02 kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Jan 26 10:08:31 bull-02 kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Jan 26 10:08:31 bull-02 kernel: Process ocfs2dc (pid: 1995, threadinfo ffff88007aa36000, task ffff88007a6b1740)
Jan 26 10:08:31 bull-02 kernel: Stack:
Jan 26 10:08:31 bull-02 kernel: ffff880000000000 ffff88013bf4f1d0 ffff88013bf4f1d0 0000000000000000
Jan 26 10:08:31 bull-02 kernel: <0> ffff88007aa37ee0 ffffffffa020ce98 00ff880000000000 ffff88007a6b1bf8
Jan 26 10:08:31 bull-02 kernel: <0> ffff88007df81740 ffff88007aa37e80 ffff88007aa37e10 ffffffff00000000
Jan 26 10:08:31 bull-02 kernel: Call Trace:
Jan 26 10:08:31 bull-02 kernel: [<ffffffffa020ce98>] ocfs2_downconvert_thread+0x5cf/0x930 [ocfs2]
Jan 26 10:08:31 bull-02 kernel: [<ffffffff81074f6b>] ? autoremove_wake_function+0x0/0x39
Jan 26 10:08:31 bull-02 kernel: [<ffffffffa020c8c9>] ? ocfs2_downconvert_thread+0x0/0x930 [ocfs2]
Jan 26 10:08:31 bull-02 kernel: [<ffffffff81074c7e>] kthread+0x7f/0x87
Jan 26 10:08:31 bull-02 kernel: [<ffffffff81012cea>] child_rip+0xa/0x20
Jan 26 10:08:31 bull-02 kernel: [<ffffffff81074bff>] ? kthread+0x0/0x87
Jan 26 10:08:31 bull-02 kernel: [<ffffffff81012ce0>] ? child_rip+0x0/0x20
Jan 26 10:08:31 bull-02 kernel: Code: 00 41 b8 d0 0c 00 00 48 c7 c1 f0 ef 25 a0 65 8b 14 25 68 e3 00 00 48 c7 c7 b6 66 26 a0 48 63 d2 31 c0 4
4 89 24 24 e8 b6 73 22 e1 <0f> 0b eb fe f6 05 fa 29 fb ff 08 74 4a f6 05 f9 29 fb ff 08 75 
Jan 26 10:08:31 bull-02 kernel: RIP  [<ffffffffa020993d>] ocfs2_prepare_downconvert+0x93/0x11c [ocfs2]
Jan 26 10:08:31 bull-02 kernel: RSP <ffff88007aa37d90>
Jan 26 10:08:31 bull-02 kernel: ---[ end trace 9e720f5422312a43 ]---

Jan 26 10:33:35 bull-02 kernel: (2523,1):ocfs2_prepare_downconvert:3280 ERROR: lockres->l_level (0) <= new_level (0)
Jan 26 10:33:35 bull-02 kernel: ------------[ cut here ]------------
Jan 26 10:33:35 bull-02 kernel: kernel BUG@fs/ocfs2/dlmglue.c:3281!
Jan 26 10:33:35 bull-02 kernel: invalid opcode: 0000 [#1] SMP 
Jan 26 10:33:35 bull-02 kernel: last sysfs file: /sys/devices/pci0000:80/0000:80:02.0/0000:86:01.0/local_cpus
Jan 26 10:33:35 bull-02 kernel: CPU 1 
Jan 26 10:33:35 bull-02 kernel: Modules linked in: ocfs2_stack_user dlm ocfs2 ocfs2_nodemanager configfs ocfs2_stackglue sunrpc ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath shpchp amd64_edac_mod edac_core serio_raw tg3 i2c_nforce2 k8temp i2c_core qla2xxx mptspi mptscsih scsi_transport_fc ata_generic mptbase pata_acpi scsi_tgt scsi_transport_spi sata_nv pata_amd [last unloaded: scsi_wait_scan]
Jan 26 10:33:35 bull-02 kernel: Pid: 2523, comm: ocfs2dc Not tainted 2.6.32.3 #2 ProLiant DL145 G2
Jan 26 10:33:35 bull-02 kernel: RIP: 0010:[<ffffffffa020593d>]  [<ffffffffa020593d>] ocfs2_prepare_downconvert+0x93/0x11c [ocfs2]
Jan 26 10:33:35 bull-02 kernel: RSP: 0018:ffff88007cd89d90  EFLAGS: 00010082
Jan 26 10:33:35 bull-02 kernel: RAX: 000000000000005b RBX: ffff88007c5ccc50 RCX: 0000000000000aef
Jan 26 10:33:35 bull-02 kernel: RDX: 0000000000000000 RSI: 0000000000000046 RDI: 0000000000000046
Jan 26 10:33:35 bull-02 kernel: RBP: ffff88007cd89db0 R08: ffff88007cd89cd0 R09: 0000000000000000
Jan 26 10:33:35 bull-02 kernel: R10: 0000000000000000 R11: 000000000006db00 R12: 0000000000000000
Jan 26 10:33:35 bull-02 kernel: R13: ffff88007cc20000 R14: 0000000000000293 R15: ffff88007c5ccc68
Jan 26 10:33:35 bull-02 kernel: FS:  00007f77b5a4e700(0000) GS:ffff880028300000(0000) knlGS:0000000000000000
Jan 26 10:33:35 bull-02 kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Jan 26 10:33:35 bull-02 kernel: CR2: 00000000011d8178 CR3: 000000013cee0000 CR4: 00000000000006e0
Jan 26 10:33:35 bull-02 kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Jan 26 10:33:35 bull-02 kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Jan 26 10:33:35 bull-02 kernel: Process ocfs2dc (pid: 2523, threadinfo ffff88007cd88000, task ffff880037d00000)
Jan 26 10:33:35 bull-02 kernel: Stack:
Jan 26 10:33:35 bull-02 kernel: ffff880000000000 ffff88007c5ccc50 ffff88007c5ccc50 0000000000000000
Jan 26 10:33:35 bull-02 kernel: <0> ffff88007cd89ee0 ffffffffa0208e98 00ff880000000000 ffff880037d004b8
Jan 26 10:33:35 bull-02 kernel: <0> ffff88007df99740 ffff88007cd89e80 ffff88007cd89e10 ffffffff00000000
Jan 26 10:33:35 bull-02 kernel: Call Trace:
Jan 26 10:33:35 bull-02 kernel: [<ffffffffa0208e98>] ocfs2_downconvert_thread+0x5cf/0x930 [ocfs2]
Jan 26 10:33:35 bull-02 kernel: [<ffffffff81074f6b>] ? autoremove_wake_function+0x0/0x39
Jan 26 10:33:35 bull-02 kernel: [<ffffffffa02088c9>] ? ocfs2_downconvert_thread+0x0/0x930 [ocfs2]
Jan 26 10:33:35 bull-02 kernel: [<ffffffff81074c7e>] kthread+0x7f/0x87
Jan 26 10:33:35 bull-02 kernel: [<ffffffff81012cea>] child_rip+0xa/0x20
Jan 26 10:33:35 bull-02 kernel: [<ffffffff81074bff>] ? kthread+0x0/0x87
Jan 26 10:33:35 bull-02 kernel: [<ffffffff81012ce0>] ? child_rip+0x0/0x20
Jan 26 10:33:35 bull-02 kernel: Code: 00 41 b8 d0 0c 00 00 48 c7 c1 f0 af 25 a0 65 8b 14 25 68 e3 00 00 48 c7 c7 b6 26 26 a0 48 63 d2 31 c0 44 89 24 24 e8 b6 b3 22 e1 <0f> 0b eb fe f6 05 fa 29 fb ff 08 74 4a f6 05 f9 29 fb ff 08 75 
Jan 26 10:33:35 bull-02 kernel: RIP  [<ffffffffa020593d>] ocfs2_prepare_downconvert+0x93/0x11c [ocfs2]
Jan 26 10:33:35 bull-02 kernel: RSP <ffff88007cd89d90>
Jan 26 10:33:35 bull-02 kernel: ---[ end trace 9d3da64f968ed95a ]---

Jan 26 10:08:31 bull-04 kernel: (2047,3):ocfs2_prepare_downconvert:3280 ERROR: lockres->l_level (0) <= new_level (0)
Jan 26 10:08:31 bull-04 kernel: ------------[ cut here ]------------
Jan 26 10:08:31 bull-04 kernel: kernel BUG@fs/ocfs2/dlmglue.c:3281!
Jan 26 10:08:31 bull-04 kernel: invalid opcode: 0000 [#1] SMP
Jan 26 10:08:31 bull-04 kernel: last sysfs file: /sys/devices/pci0000:00/0000:00:0d.0/0000:03:00.0/irq
Jan 26 10:08:31 bull-04 kernel: CPU 3
Jan 26 10:08:31 bull-04 kernel: Modules linked in: ocfs2_stack_user dlm ocfs2 ocfs2_nodemanager configfs ocfs2_stackglue sunrpc ipv6 cpufreq_
ondemand powernow_k8 freq_table dm_multipath amd64_edac_mod edac_core tg3 i2c_nforce2 k8temp shpchp i2c_core serio_raw qla2xxx mptspi ata_gen
eric scsi_transport_fc pata_acpi mptscsih mptbase scsi_transport_spi scsi_tgt sata_nv pata_amd [last unloaded: scsi_wait_scan]
Jan 26 10:08:31 bull-04 kernel: Pid: 2047, comm: ocfs2dc Not tainted 2.6.32.3 #2 ProLiant DL145 G2
Jan 26 10:08:31 bull-04 kernel: RIP: 0010:[<ffffffffa020693d>]  [<ffffffffa020693d>] ocfs2_prepare_downconvert+0x93/0x11c [ocfs2]
Jan 26 10:08:31 bull-04 kernel: RSP: 0018:ffff88007d301d90  EFLAGS: 00010082
Jan 26 10:08:31 bull-04 kernel: RAX: 000000000000005b RBX: ffff88007ada17d0 RCX: 0000000000000a4a
Jan 26 10:08:31 bull-04 kernel: RDX: 0000000000000000 RSI: 0000000000000046 RDI: 0000000000000046
Jan 26 10:08:31 bull-04 kernel: RBP: ffff88007d301db0 R08: ffff88007d301cd0 R09: 0000000000000000
Jan 26 10:08:31 bull-04 kernel: R10: 0000000000000000 R11: ffff88013a730400 R12: 0000000000000000
Jan 26 10:08:31 bull-04 kernel: R13: ffff88013a40d000 R14: 0000000000000293 R15: ffff88007ada17e8
Jan 26 10:08:31 bull-04 kernel: FS:  00007f5e323db700(0000) GS:ffff880082100000(0000) knlGS:0000000000000000
Jan 26 10:08:31 bull-04 kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Jan 26 10:08:31 bull-04 kernel: CR2: 0000000000e074b0 CR3: 0000000139db7000 CR4: 00000000000006e0
Jan 26 10:08:31 bull-04 kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Jan 26 10:08:31 bull-04 kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Jan 26 10:08:31 bull-04 kernel: Process ocfs2dc (pid: 2047, threadinfo ffff88007d300000, task ffff88007ab3c5c0)
Jan 26 10:08:31 bull-04 kernel: Stack:
Jan 26 10:08:31 bull-04 kernel: ffff880100000000 ffff88007ada17d0 ffff88007ada17d0 0000000000000000
Jan 26 10:08:31 bull-04 kernel: <0> ffff88007d301ee0 ffffffffa0209e98 0000000000000000 ffff88007ab3ca78
Jan 26 10:08:31 bull-04 kernel: <0> ffffffff816861f0 ffff88007d301e80 ffff88007d301e10 ffffffff00000000
Jan 26 10:08:31 bull-04 kernel: Call Trace:
Jan 26 10:08:31 bull-04 kernel: [<ffffffffa0209e98>] ocfs2_downconvert_thread+0x5cf/0x930 [ocfs2]
Jan 26 10:08:31 bull-04 kernel: [<ffffffff81074f6b>] ? autoremove_wake_function+0x0/0x39
Jan 26 10:08:31 bull-04 kernel: [<ffffffffa02098c9>] ? ocfs2_downconvert_thread+0x0/0x930 [ocfs2]
Jan 26 10:08:31 bull-04 kernel: [<ffffffff81074c7e>] kthread+0x7f/0x87
Jan 26 10:08:31 bull-04 kernel: [<ffffffff81012cea>] child_rip+0xa/0x20
Jan 26 10:08:31 bull-04 kernel: [<ffffffff81074bff>] ? kthread+0x0/0x87
Jan 26 10:08:31 bull-04 kernel: [<ffffffff81012ce0>] ? child_rip+0x0/0x20
Jan 26 10:08:31 bull-04 kernel: Code: 00 41 b8 d0 0c 00 00 48 c7 c1 f0 bf 25 a0 65 8b 14 25 68 e3 00 00 48 c7 c7 b6 36 26 a0 48 63 d2 31 c0 4
4 89 24 24 e8 b6 a3 22 e1 <0f> 0b eb fe f6 05 fa 29 fb ff 08 74 4a f6 05 f9 29 fb ff 08 75
Jan 26 10:08:31 bull-04 kernel: RIP  [<ffffffffa020693d>] ocfs2_prepare_downconvert+0x93/0x11c [ocfs2]
Jan 26 10:08:31 bull-04 kernel: RSP <ffff88007d301d90>
Jan 26 10:08:31 bull-04 kernel: ---[ end trace 930397e8616715ba ]---


> Wondering if you build with CONFIG_OCFS2_DEBUG_MASKLOG.

Yes I am.

Dave
