From: Joseph Qi <joseph.qi@huawei.com>
Date: Thu, 23 Jul 2015 10:37:32 +0800
Subject: [Ocfs2-devel] Do you know this issue? thanks
In-Reply-To: <55AFBD47020000F90000F7DF@relay2.provo.novell.com>
References: <55AFBD47020000F90000F7DF@relay2.provo.novell.com>
Message-ID: <55B0536C.8020603@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

I have never seen this bug.
From the bug expression, it is caused by inode in memory and disk
mismatch. Previously we found jbd2_journal_restart is not called
correctly in ocfs2 and will cause inconsistent. I am not sure if it has
relations.
So could you check if there is any error occurred before (like storage
link down)?

On 2015/7/22 15:56, Gang He wrote:
> Hello Joseph and Junxiao,
> 
> I know you guys worked on OCFS2 for a few years.
> Here, the customer reported a bug when they were running Pacemaker+OCFS2+SAP application on SLES11SP3 two nodes.
> But they did not provided the core dump file, or reproduce steps (seemed that they encountered this issue two times occasionally), 
> then I want to know if you saw the similar issue in the past, very thanks.
> The panic backtrace is as below (looks that inode size does not match disk inode's size, then trigger a bug()),
> 
> Jul 15 08:35:03 ruh1kepapp2 kernel: [62041.157139] (sapstart,15094,6):ocfs2_truncate_file:466 ERROR: bug expression: le64_to_cpu(fe->i_size) != i_size_read(inode)
> Jul 15 08:35:03 ruh1kepapp2 kernel: [62041.157148] (sapstart,15094,6):ocfs2_truncate_file:466 ERROR: Inode 293533, inode i_size = 853 != di i_size = 827, i_flags = 0x1
> Jul 15 08:35:03 ruh1kepapp2 kernel: [62041.157186] ------------[ cut here ]------------
> Jul 15 08:35:03 ruh1kepapp2 kernel: [62041.157197] kernel BUG at /usr/src/packages/BUILD/ocfs2-1.6/default/ocfs2/file.c:466!
> Jul 15 08:35:03 ruh1kepapp2 kernel: [62041.157204] invalid opcode: 0000 [#1] SMP
> Jul 15 08:35:03 ruh1kepapp2 kernel: [62041.157210] CPU 6
> Jul 15 08:35:03 ruh1kepapp2 kernel: [62041.157213] Modules linked in: af_packet ocfs2 jbd2 ocfs2_nodemanager quota_tree ocfs2_stack_user ocfs2_stackglue dlm sctp crc32c libcrc32c configfs hpwdt iTCO_wdt iTCO_vendor_support i6300esb ib700wdt advantechwdt acquirewdt pcwd_usb usbcore usb_common wdt_pci pcwd_pci autofs4 edd nfs lockd fscache auth_rpcgss nfs_acl sunrpc mperf microcode fuse loop dm_mod ppdev parport_pc parport floppy ipv6 ipv6_lib vmw_balloon(X) mptctl pciehp sg serio_raw intel_agp pcspkr vmxnet3 sr_mod intel_gtt cdrom shpchp rtc_cmos ac i2c_piix4 container i2c_core pci_hotplug button ext3 jbd mbcache sd_mod crc_t10dif processor thermal_sys hwmon scsi_dh_hp_sw scsi_dh_rdac scsi_dh_emc scsi_dh_alua scsi_dh ata_generic ata_piix libata mptspi mptscsih mptbase scsi_transport_spi scsi_mod
> Jul 15 08:35:03 ruh1kepapp2 kernel: [62041.157318] Supported: Yes, External
> Jul 15 08:35:03 ruh1kepapp2 kernel: [62041.157322]
> Jul 15 08:35:03 ruh1kepapp2 kernel: [62041.157327] Pid: 15094, comm: sapstart Tainted: G             X 3.0.101-0.47.52-default #1 VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform
> Jul 15 08:35:03 ruh1kepapp2 kernel: [62041.157340] RIP: 0010:[<ffffffffa058cb85>]  [<ffffffffa058cb85>] ocfs2_truncate_file+0xa5/0x490 [ocfs2]
> Jul 15 08:35:03 ruh1kepapp2 kernel: [62041.157391] RSP: 0018:ffff88082a3b5b68  EFLAGS: 00010296
> Jul 15 08:35:03 ruh1kepapp2 kernel: [62041.157396] RAX: 000000000000008a RBX: ffff88085c0cc580 RCX: 0000000000005457
> Jul 15 08:35:03 ruh1kepapp2 kernel: [62041.157402] RDX: 0000000000000000 RSI: 0000000000000003 RDI: 0000000000000246
> Jul 15 08:35:03 ruh1kepapp2 kernel: [62041.157407] RBP: 1000000000000000 R08: ffffffff81d9fac0 R09: 0000000000000000
> Jul 15 08:35:03 ruh1kepapp2 kernel: [62041.157413] R10: 0000000000000003 R11: 00000000ffffffff R12: ffff8808ce63b4f8
> Jul 15 08:35:03 ruh1kepapp2 kernel: [62041.157419] R13: ffff88085c0ccbc8 R14: ffff8808f61ee000 R15: 0000000000000355
> Jul 15 08:35:03 ruh1kepapp2 kernel: [62041.157425] FS:  00007f66e8272720(0000) GS:ffff88123fc00000(0000) knlGS:0000000000000000
> Jul 15 08:35:03 ruh1kepapp2 kernel: [62041.157431] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> Jul 15 08:35:03 ruh1kepapp2 kernel: [62041.157436] CR2: 00007fd0ac029000 CR3: 000000081cda6000 CR4: 00000000000407e0
> Jul 15 08:35:03 ruh1kepapp2 kernel: [62041.157501] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> Jul 15 08:35:03 ruh1kepapp2 kernel: [62041.157539] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Jul 15 08:35:03 ruh1kepapp2 kernel: [62041.157545] Process sapstart (pid: 15094, threadinfo ffff88082a3b4000, task ffff88085c0cc580)
> Jul 15 08:35:03 ruh1kepapp2 kernel: [62041.157551] Stack:
> Jul 15 08:35:03 ruh1kepapp2 kernel: [62041.157554]  0000000000047a9d 0000000000000355 000000000000033b ffff880800000001
> Jul 15 08:35:03 ruh1kepapp2 kernel: [62041.157564]  ffff8808fb5ab748 ffff8812052d3000 ffff8808ce63b080 0000000000000000
> Jul 15 08:35:03 ruh1kepapp2 kernel: [62041.157572]  ffff8808fb7f2c00 0000000000000001 0000000000047a9d 000000000000000c
> Jul 15 08:35:03 ruh1kepapp2 kernel: [62041.157581] Call Trace:
> Jul 15 08:35:03 ruh1kepapp2 kernel: [62041.157666]  [<ffffffffa058f426>] ocfs2_setattr+0x276/0xa90 [ocfs2]
> Jul 15 08:35:03 ruh1kepapp2 kernel: [62041.157710]  [<ffffffff81177b6f>] notify_change+0x19f/0x2f0
> Jul 15 08:35:03 ruh1kepapp2 kernel: [62041.157724]  [<ffffffff8115c217>] do_truncate+0x57/0x80
> Jul 15 08:35:03 ruh1kepapp2 kernel: [62041.157737]  [<ffffffff8116abe3>] do_last+0x603/0x800
> Jul 15 08:35:03 ruh1kepapp2 kernel: [62041.157747]  [<ffffffff8116ba49>] path_openat+0xd9/0x420
> Jul 15 08:35:03 ruh1kepapp2 kernel: [62041.157757]  [<ffffffff8116becc>] do_filp_open+0x4c/0xc0
> Jul 15 08:35:03 ruh1kepapp2 kernel: [62041.157765]  [<ffffffff8115cb5f>] do_sys_open+0x17f/0x250
> Jul 15 08:35:03 ruh1kepapp2 kernel: [62041.157776]  [<ffffffff8146cb92>] system_call_fastpath+0x16/0x1b
> Jul 15 08:35:03 ruh1kepapp2 kernel: [62041.157795]  [<00007f66e7025790>] 0x7f66e702578f
> Jul 15 08:35:03 ruh1kepapp2 kernel: [62041.157799] Code: 6e 20 4d 8b bc 24 d0 00 00 00 49 39 ef 74 20 48 bd 00 00 00 00 00 00 00 10 48 85 2d 46 b8 f7 ff 74 09 48 85 2d 7d d7 f7 ff 74 74 <0f> 0b eb fe 49 39 ed 0f 86 6c 01 00 00 8b 05 30 b2 0a 00 85 c0
> Jul 15 08:35:03 ruh1kepapp2 kernel: [62041.157848] RIP  [<ffffffffa058cb85>] ocfs2_truncate_file+0xa5/0x490 [ocfs2]
> Jul 15 08:35:03 ruh1kepapp2 kernel: [62041.157879]  RSP <ffff88082a3b5b68>
> Jul 15 08:35:03 ruh1kepapp2 kernel: [62041.157886] ---[ end trace fb7a3c1bdf30e68e ]---
> Jul 15 08:35:05 ruh1kepapp2 SAPInstance(ERS51)[14667]: INFO: SAP Instance KEP-ERS51 stopped:  15.07.2015 08:35:05 WaitforStopped OK
> Jul 15 08:35:05 ruh1kepapp2 crmd[4335]:   notice: process_lrm_event: LRM operation ERS51_stop_0 (call=105, rc=0, cib-update=492, confirmed=true) ok
> 
> Thanks
> Gang
> 
> .
> 
