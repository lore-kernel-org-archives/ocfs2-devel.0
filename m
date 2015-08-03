From: Joseph Qi <joseph.qi@huawei.com>
Date: Mon, 3 Aug 2015 18:21:51 +0800
Subject: [Ocfs2-devel] Do you know this issue? thanks
In-Reply-To: <55BFA4A6020000F900010B18@relay2.provo.novell.com>
References: <55AFBD47020000F90000F7DF@relay2.provo.novell.com>
	<55B0536C.8020603@huawei.com>
	<55B104E6020000F90000F9E8@relay2.provo.novell.com>
	<55BFA4A6020000F900010B18@relay2.provo.novell.com>
Message-ID: <55BF40BF.70701@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Gang,
On 2015/8/3 17:28, Gang He wrote:
> Hello guys,
> 
> I went through OCFS2 journal and JBD2 code, I just have one question as below,
> If there are some nodes which are running, one node (node A) suddenly crashes, one another node (node B) will recover node A's journal records. But here looks a problem, if node B ever changed one file, and node A also changed this same file, then node B will replay these changed meta buffers, JBD2 recovery code will memcpy the journal meta buffer to the node B's memory, this inode's meta buffer will be replaced by node A's journal record, but this inode structure in memory will not be reflected, this will cause this kind of issue? I feel that my guess should be wrong, since this problem looks too obvious, but who can help to figure out how to solve this problem when a running node try to recover a crashed node's journal.
> 
Please note that nodes can update the same inode only after it has got
the cluster lock. And if the lock level is not compatible, it will
downcovert first, which will do the checkpoint.
So I don't think the issue you described really exists.

Thanks
Joseph
> 
> Thanks
> Gang 
> 
> 
>>>>
>> Hi All,
>>
>> >From the message on node2 (before ocfs2 kernel panic), I found that the node2 
>> just fenced the node1, next the node2 replayed the journal for the node1.
>> Maybe the journal replay process modified the related inode buffer, make the 
>> inode in memory not inconsitent with the inode disk buffer? 
>>
>> The detailed log:
>> Jul 15 08:32:20 ruh1kepapp2 sbd: [13905]: info: Message successfully 
>> delivered.
>> Jul 15 08:32:21 ruh1kepapp2 stonith-ng[4331]:   notice: log_operation: 
>> Operation 'reboot' [13894] (call 3 from crmd.4335) for host 'ruh1kepapp1' 
>> with device 'stonith-sbd' returned: 0 (OK)
>> Jul 15 08:32:21 ruh1kepapp2 stonith-ng[4331]:   notice: remote_op_done: 
>> Operation reboot of ruh1kepapp1 by ruh1kepapp2 for 
>> crmd.4335 at ruh1kepapp2.77c17f26: OK
>> Jul 15 08:32:21 ruh1kepapp2 crmd[4335]:   notice: tengine_stonith_callback: 
>> Stonith operation 3/59:90:0:5868c9e9-69dd-46ee-a7dc-6caea229882d: OK (0)
>> Jul 15 08:32:21 ruh1kepapp2 crmd[4335]:   notice: tengine_stonith_notify: 
>> Peer ruh1kepapp1 was terminated (reboot) by ruh1kepapp2 for ruh1kepapp2: OK 
>> (ref=77c17f26-d1c6-4de8-94b3-842bf8ff71b5) by client crmd.4335
>> Jul 15 08:32:22 ruh1kepapp2 cluster-dlm[4699]: fence_node_time: Node 
>> 1084766062/ruh1kepapp1 was last shot 'now'
>> Jul 15 08:32:22 ruh1kepapp2 cluster-dlm[4699]: check_fencing_done: 
>> 969E8438425C45E484D7AB283185E731 check_fencing 1084766062 done add 1436879638 
>> fail 1436938320 last 1436938342
>> Jul 15 08:32:22 ruh1kepapp2 cluster-dlm[4699]: check_fencing_done: 
>> 969E8438425C45E484D7AB283185E731 check_fencing done
>> Jul 15 08:32:22 ruh1kepapp2 cluster-dlm[4699]: check_quorum_done: 
>> 969E8438425C45E484D7AB283185E731 check_quorum disabled
>> Jul 15 08:32:22 ruh1kepapp2 cluster-dlm[4699]: check_fs_done: 
>> 969E8438425C45E484D7AB283185E731 check_fs nodeid 1084766062 clear
>> Jul 15 08:32:22 ruh1kepapp2 cluster-dlm[4699]: check_fs_done: 
>> 969E8438425C45E484D7AB283185E731 check_fs done
>> Jul 15 08:32:22 ruh1kepapp2 cluster-dlm[4699]: send_info: 
>> 969E8438425C45E484D7AB283185E731 send_start cg 3 flags 2 data2 0 counts 2 1 0 
>> 1 1
>> Jul 15 08:32:22 ruh1kepapp2 cluster-dlm[4699]: fence_node_time: Node 
>> 1084766062/ruh1kepapp1 was last shot 'now'
>> Jul 15 08:32:22 ruh1kepapp2 cluster-dlm[4699]: check_fencing_done: 
>> 165E3E4A04FB4BC28C50684293325854 check_fencing 1084766062 done add 1436879638 
>> fail 1436938320 last 1436938342
>> Jul 15 08:32:22 ruh1kepapp2 cluster-dlm[4699]: check_fencing_done: 
>> 165E3E4A04FB4BC28C50684293325854 check_fencing done
>> Jul 15 08:32:22 ruh1kepapp2 cluster-dlm[4699]: check_quorum_done: 
>> 165E3E4A04FB4BC28C50684293325854 check_quorum disabled
>> Jul 15 08:32:22 ruh1kepapp2 cluster-dlm[4699]: check_fs_done: 
>> 165E3E4A04FB4BC28C50684293325854 check_fs nodeid 1084766062 clear
>> Jul 15 08:32:22 ruh1kepapp2 cluster-dlm[4699]: check_fs_done: 
>> 165E3E4A04FB4BC28C50684293325854 check_fs done
>> Jul 15 08:32:22 ruh1kepapp2 cluster-dlm[4699]: send_info: 
>> 165E3E4A04FB4BC28C50684293325854 send_start cg 3 flags 2 data2 0 counts 2 1 0 
>> 1 1
>> Jul 15 08:32:22 ruh1kepapp2 cluster-dlm[4699]: receive_start: 
>> 969E8438425C45E484D7AB283185E731 receive_start 1084766063:3 len 76
>> Jul 15 08:32:22 ruh1kepapp2 cluster-dlm[4699]: match_change: 
>> 969E8438425C45E484D7AB283185E731 match_change 1084766063:3 matches cg 3
>> Jul 15 08:32:22 ruh1kepapp2 cluster-dlm[4699]: wait_messages_done: 
>> 969E8438425C45E484D7AB283185E731 wait_messages cg 3 got all 1
>> Jul 15 08:32:22 ruh1kepapp2 cluster-dlm[4699]: start_kernel: 
>> 969E8438425C45E484D7AB283185E731 start_kernel cg 3 member_count 1
>> Jul 15 08:32:22 ruh1kepapp2 cluster-dlm[4699]: update_dir_members: dir_member 
>> 1084766062
>> Jul 15 08:32:22 ruh1kepapp2 cluster-dlm[4699]: update_dir_members: dir_member 
>> 1084766063
>> Jul 15 08:32:22 ruh1kepapp2 cluster-dlm[4699]: set_configfs_members: 
>> set_members rmdir 
>> "/sys/kernel/config/dlm/cluster/spaces/969E8438425C45E484D7AB283185E731/nodes
>> /1084766062"
>> Jul 15 08:32:22 ruh1kepapp2 cluster-dlm[4699]: do_sysfs: write "1" to 
>> "/sys/kernel/dlm/969E8438425C45E484D7AB283185E731/control"
>> Jul 15 08:32:22 ruh1kepapp2 cluster-dlm[4699]: receive_start: 
>> 165E3E4A04FB4BC28C50684293325854 receive_start 1084766063:3 len 76
>> Jul 15 08:32:22 ruh1kepapp2 cluster-dlm[4699]: match_change: 
>> 165E3E4A04FB4BC28C50684293325854 match_change 1084766063:3 matches cg 3
>> Jul 15 08:32:22 ruh1kepapp2 cluster-dlm[4699]: wait_messages_done: 
>> 165E3E4A04FB4BC28C50684293325854 wait_messages cg 3 got all 1
>> Jul 15 08:32:22 ruh1kepapp2 cluster-dlm[4699]: start_kernel: 
>> 165E3E4A04FB4BC28C50684293325854 start_kernel cg 3 member_count 1
>> Jul 15 08:32:22 ruh1kepapp2 cluster-dlm[4699]: update_dir_members: dir_member 
>> 1084766062
>> Jul 15 08:32:22 ruh1kepapp2 cluster-dlm[4699]: update_dir_members: dir_member 
>> 1084766063
>> Jul 15 08:32:22 ruh1kepapp2 cluster-dlm[4699]: set_configfs_members: 
>> set_members rmdir 
>> "/sys/kernel/config/dlm/cluster/spaces/165E3E4A04FB4BC28C50684293325854/nodes
>> /1084766062"
>> Jul 15 08:32:22 ruh1kepapp2 cluster-dlm[4699]: do_sysfs: write "1" to 
>> "/sys/kernel/dlm/165E3E4A04FB4BC28C50684293325854/control"
>> Jul 15 08:32:22 ruh1kepapp2 kernel: [61880.467934] 
>> (ocfs2rec,13862,6):ocfs2_replay_journal:1549 Recovering node 1084766062 from 
>> slot 1 on device (8,49)
>> Jul 15 08:32:22 ruh1kepapp2 kernel: [61880.506685] 
>> (ocfs2rec,13861,9):ocfs2_replay_journal:1549 Recovering node 1084766062 from 
>> slot 1 on device (8,33)
>> Jul 15 08:32:25 ruh1kepapp2 kernel: [61883.232721] 
>> (ocfs2rec,13862,0):ocfs2_begin_quota_recovery:407 Beginning quota recovery in 
>> slot 1
>> Jul 15 08:32:25 ruh1kepapp2 kernel: [61883.380880] 
>> (ocfs2rec,13861,6):ocfs2_begin_quota_recovery:407 Beginning quota recovery in 
>> slot 1
>> Jul 15 08:32:25 ruh1kepapp2 kernel: [61883.389531] 
>> (kworker/u:3,11960,0):ocfs2_finish_quota_recovery:599 Finishing quota 
>> recovery in slot 1
>> Jul 15 08:32:25 ruh1kepapp2 kernel: [61883.392216] 
>> (kworker/u:3,11960,1):ocfs2_finish_quota_recovery:599 Finishing quota 
>> recovery in slot 1
>> Jul 15 08:32:25 ruh1kepapp2 SAPInstance(D60)[13863]: INFO: Stopping SAP 
>> Instance KEP-D60:  15.07.2015 08:32:25 Stop OK
>> Jul 15 08:32:53 ruh1kepapp2 SAPKEP_60[13261]: Q41 Monitoring: Snapshot 1 
>> created
>>
>> Thanks
>> Gang
>>
>>
>>>>>
>>> I have never seen this bug.
>>> From the bug expression, it is caused by inode in memory and disk
>>> mismatch. Previously we found jbd2_journal_restart is not called
>>> correctly in ocfs2 and will cause inconsistent. I am not sure if it has
>>> relations.
>>> So could you check if there is any error occurred before (like storage
>>> link down)?
>>>
>>> On 2015/7/22 15:56, Gang He wrote:
>>>> Hello Joseph and Junxiao,
>>>>
>>>> I know you guys worked on OCFS2 for a few years.
>>>> Here, the customer reported a bug when they were running Pacemaker+OCFS2+SAP 
>>
>>> application on SLES11SP3 two nodes.
>>>> But they did not provided the core dump file, or reproduce steps (seemed 
>>> that they encountered this issue two times occasionally), 
>>>> then I want to know if you saw the similar issue in the past, very thanks.
>>>> The panic backtrace is as below (looks that inode size does not match disk 
>>> inode's size, then trigger a bug()),
>>>>
>>>> Jul 15 08:35:03 ruh1kepapp2 kernel: [62041.157139] 
>>> (sapstart,15094,6):ocfs2_truncate_file:466 ERROR: bug expression: 
>>> le64_to_cpu(fe->i_size) != i_size_read(inode)
>>>> Jul 15 08:35:03 ruh1kepapp2 kernel: [62041.157148] 
>>> (sapstart,15094,6):ocfs2_truncate_file:466 ERROR: Inode 293533, inode i_size 
>>
>>> = 853 != di i_size = 827, i_flags = 0x1
>>>> Jul 15 08:35:03 ruh1kepapp2 kernel: [62041.157186] ------------[ cut here ]------------
>>>> Jul 15 08:35:03 ruh1kepapp2 kernel: [62041.157197] kernel BUG at 
>>> /usr/src/packages/BUILD/ocfs2-1.6/default/ocfs2/file.c:466!
>>>> Jul 15 08:35:03 ruh1kepapp2 kernel: [62041.157204] invalid opcode: 0000 [#1] 
>>
>>> SMP
>>>> Jul 15 08:35:03 ruh1kepapp2 kernel: [62041.157210] CPU 6
>>>> Jul 15 08:35:03 ruh1kepapp2 kernel: [62041.157213] Modules linked in: 
>>> af_packet ocfs2 jbd2 ocfs2_nodemanager quota_tree ocfs2_stack_user 
>>> ocfs2_stackglue dlm sctp crc32c libcrc32c configfs hpwdt iTCO_wdt 
>>> iTCO_vendor_support i6300esb ib700wdt advantechwdt acquirewdt pcwd_usb 
>>> usbcore usb_common wdt_pci pcwd_pci autofs4 edd nfs lockd fscache 
>> auth_rpcgss 
>>> nfs_acl sunrpc mperf microcode fuse loop dm_mod ppdev parport_pc parport 
>>> floppy ipv6 ipv6_lib vmw_balloon(X) mptctl pciehp sg serio_raw intel_agp 
>>> pcspkr vmxnet3 sr_mod intel_gtt cdrom shpchp rtc_cmos ac i2c_piix4 container 
>>
>>> i2c_core pci_hotplug button ext3 jbd mbcache sd_mod crc_t10dif processor 
>>> thermal_sys hwmon scsi_dh_hp_sw scsi_dh_rdac scsi_dh_emc scsi_dh_alua 
>> scsi_dh 
>>> ata_generic ata_piix libata mptspi mptscsih mptbase scsi_transport_spi 
>>> scsi_mod
>>>> Jul 15 08:35:03 ruh1kepapp2 kernel: [62041.157318] Supported: Yes, External
>>>> Jul 15 08:35:03 ruh1kepapp2 kernel: [62041.157322]
>>>> Jul 15 08:35:03 ruh1kepapp2 kernel: [62041.157327] Pid: 15094, comm: 
>>> sapstart Tainted: G             X 3.0.101-0.47.52-default #1 VMware, Inc. 
>>> VMware Virtual Platform/440BX Desktop Reference Platform
>>>> Jul 15 08:35:03 ruh1kepapp2 kernel: [62041.157340] RIP: 
>>> 0010:[<ffffffffa058cb85>]  [<ffffffffa058cb85>] ocfs2_truncate_file+0xa5/0x490 
>>> [ocfs2]
>>>> Jul 15 08:35:03 ruh1kepapp2 kernel: [62041.157391] RSP: 
>>> 0018:ffff88082a3b5b68  EFLAGS: 00010296
>>>> Jul 15 08:35:03 ruh1kepapp2 kernel: [62041.157396] RAX: 000000000000008a 
>>> RBX: ffff88085c0cc580 RCX: 0000000000005457
>>>> Jul 15 08:35:03 ruh1kepapp2 kernel: [62041.157402] RDX: 0000000000000000 
>>> RSI: 0000000000000003 RDI: 0000000000000246
>>>> Jul 15 08:35:03 ruh1kepapp2 kernel: [62041.157407] RBP: 1000000000000000 
>>> R08: ffffffff81d9fac0 R09: 0000000000000000
>>>> Jul 15 08:35:03 ruh1kepapp2 kernel: [62041.157413] R10: 0000000000000003 
>>> R11: 00000000ffffffff R12: ffff8808ce63b4f8
>>>> Jul 15 08:35:03 ruh1kepapp2 kernel: [62041.157419] R13: ffff88085c0ccbc8 
>>> R14: ffff8808f61ee000 R15: 0000000000000355
>>>> Jul 15 08:35:03 ruh1kepapp2 kernel: [62041.157425] FS:  
>>> 00007f66e8272720(0000) GS:ffff88123fc00000(0000) knlGS:0000000000000000
>>>> Jul 15 08:35:03 ruh1kepapp2 kernel: [62041.157431] CS:  0010 DS: 0000 ES: 
>>> 0000 CR0: 000000008005003b
>>>> Jul 15 08:35:03 ruh1kepapp2 kernel: [62041.157436] CR2: 00007fd0ac029000 
>>> CR3: 000000081cda6000 CR4: 00000000000407e0
>>>> Jul 15 08:35:03 ruh1kepapp2 kernel: [62041.157501] DR0: 0000000000000000 
>>> DR1: 0000000000000000 DR2: 0000000000000000
>>>> Jul 15 08:35:03 ruh1kepapp2 kernel: [62041.157539] DR3: 0000000000000000 
>>> DR6: 00000000ffff0ff0 DR7: 0000000000000400
>>>> Jul 15 08:35:03 ruh1kepapp2 kernel: [62041.157545] Process sapstart (pid: 
>>> 15094, threadinfo ffff88082a3b4000, task ffff88085c0cc580)
>>>> Jul 15 08:35:03 ruh1kepapp2 kernel: [62041.157551] Stack:
>>>> Jul 15 08:35:03 ruh1kepapp2 kernel: [62041.157554]  0000000000047a9d 
>>> 0000000000000355 000000000000033b ffff880800000001
>>>> Jul 15 08:35:03 ruh1kepapp2 kernel: [62041.157564]  ffff8808fb5ab748 
>>> ffff8812052d3000 ffff8808ce63b080 0000000000000000
>>>> Jul 15 08:35:03 ruh1kepapp2 kernel: [62041.157572]  ffff8808fb7f2c00 
>>> 0000000000000001 0000000000047a9d 000000000000000c
>>>> Jul 15 08:35:03 ruh1kepapp2 kernel: [62041.157581] Call Trace:
>>>> Jul 15 08:35:03 ruh1kepapp2 kernel: [62041.157666]  [<ffffffffa058f426>] 
>>> ocfs2_setattr+0x276/0xa90 [ocfs2]
>>>> Jul 15 08:35:03 ruh1kepapp2 kernel: [62041.157710]  [<ffffffff81177b6f>] 
>>> notify_change+0x19f/0x2f0
>>>> Jul 15 08:35:03 ruh1kepapp2 kernel: [62041.157724]  [<ffffffff8115c217>] 
>>> do_truncate+0x57/0x80
>>>> Jul 15 08:35:03 ruh1kepapp2 kernel: [62041.157737]  [<ffffffff8116abe3>] 
>>> do_last+0x603/0x800
>>>> Jul 15 08:35:03 ruh1kepapp2 kernel: [62041.157747]  [<ffffffff8116ba49>] 
>>> path_openat+0xd9/0x420
>>>> Jul 15 08:35:03 ruh1kepapp2 kernel: [62041.157757]  [<ffffffff8116becc>] 
>>> do_filp_open+0x4c/0xc0
>>>> Jul 15 08:35:03 ruh1kepapp2 kernel: [62041.157765]  [<ffffffff8115cb5f>] 
>>> do_sys_open+0x17f/0x250
>>>> Jul 15 08:35:03 ruh1kepapp2 kernel: [62041.157776]  [<ffffffff8146cb92>] 
>>> system_call_fastpath+0x16/0x1b
>>>> Jul 15 08:35:03 ruh1kepapp2 kernel: [62041.157795]  [<00007f66e7025790>] 
>>> 0x7f66e702578f
>>>> Jul 15 08:35:03 ruh1kepapp2 kernel: [62041.157799] Code: 6e 20 4d 8b bc 24 
>>> d0 00 00 00 49 39 ef 74 20 48 bd 00 00 00 00 00 00 00 10 48 85 2d 46 b8 f7 
>> ff 
>>> 74 09 48 85 2d 7d d7 f7 ff 74 74 <0f> 0b eb fe 49 39 ed 0f 86 6c 01 00 00 8b 
>> 05 
>>> 30 b2 0a 00 85 c0
>>>> Jul 15 08:35:03 ruh1kepapp2 kernel: [62041.157848] RIP  [<ffffffffa058cb85>] 
>>> ocfs2_truncate_file+0xa5/0x490 [ocfs2]
>>>> Jul 15 08:35:03 ruh1kepapp2 kernel: [62041.157879]  RSP <ffff88082a3b5b68>
>>>> Jul 15 08:35:03 ruh1kepapp2 kernel: [62041.157886] ---[ end trace 
>>> fb7a3c1bdf30e68e ]---
>>>> Jul 15 08:35:05 ruh1kepapp2 SAPInstance(ERS51)[14667]: INFO: SAP Instance 
>>> KEP-ERS51 stopped:  15.07.2015 08:35:05 WaitforStopped OK
>>>> Jul 15 08:35:05 ruh1kepapp2 crmd[4335]:   notice: process_lrm_event: LRM 
>>> operation ERS51_stop_0 (call=105, rc=0, cib-update=492, confirmed=true) ok
>>>>
>>>> Thanks
>>>> Gang
>>>>
>>>> .
>>>>
>>
>> _______________________________________________
>> Ocfs2-devel mailing list
>> Ocfs2-devel at oss.oracle.com 
>> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
> 
> .
> 
