From: Zhangguanghui <zhang.guanghui@h3c.com>
Date: Thu, 14 Jan 2016 12:16:05 +0000
Subject: [Ocfs2-devel] Ocfs2 clients hang, an bad slot_num for the journal,
 dlm_deref_lockres_handler trigger BUG
Message-ID: <2016011420160406708544@h3c.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Thanks for everyone

res M0000000000000000000268e0ecb551 ----- 616 ----- journal:0000.
ocfs2_journal_init:860 ERROR: Could not get lock on journal!
the real causes may be an bad slot_num for the journal while mounting a Vol.
But I didn't have a good solution to fix it now.

A detailed log is described below.
----------------------------------------------------------------------

Message: 1
Date: Mon, 28 Dec 2015 14:49:35 +0800
From: Joseph Qi <joseph.qi@huawei.com>
Subject: Re: [Ocfs2-devel] [Ocfs2-users] Ocfs2 clients hang
To: Zhangguanghui <zhang.guanghui@h3c.com>
Cc: Siva Sokkumuthu <sivakumar@zohocorp.com>,   ocfs2-devel
        <ocfs2-devel@oss.oracle.com>
Message-ID: <5680DB7F.3090409@huawei.com>
Content-Type: text/plain; charset="UTF-8"

dlm_deref_lockres_handler may return EINVAL or ENOMEM which will lead
to sender BUG. So simply removing the BUG is not a fair way to resolve
this issue.
And I don't think the log you pasted can actually refer to its node.
Node 3 is indeed the deref handler because it is owner but not node 1.
BTW, if you want others to do the review and give you more suggestions,
you'd better follow the way described in Documentation/SubmittingPatches.

Thanks,
Joseph

On 2015/12/28 12:00, Zhangguanghui wrote:
> A similar problem is described below.
> There is a race window to triger BUG in dlm_drop_lockres_ref.
> all nodes will hang in the futhure.
>
> Node 1                                                                                          Node 3
>    mount.ocfs2  vol1 and create node lock,                                     reboot
>        waiting for Node 3                                                                         Node 3 mount.ocfs2 vol1
>             fail to mount vol1, do not get lock on journal                                      fail to mount vol1, Local alloc hasn't been recovered!
>                dlm_drop_lockres_ref and lockres don't exsit,
>                return Error -22 and triger BUG.
> I think the BUG should be removed for the case.
> But i can't say for sure what will come and remove the BUG?  Thanks for your reply .
>
> dlm_drop_lockres_ref
> --- dlmmaster.c 2015-10-12 02:09:45.000000000 +0800
> +++ /root/dlmmaster.c 2015-12-28 11:39:14.560429513 +0800
> @@ -2275,7 +2275,6 @@
> mlog(ML_ERROR, "%s: res %.*s, DEREF to node %u got %d\n",
> dlm->name, namelen, lockname, res->owner, r);
> dlm_print_one_lock_resource(res);
> - BUG();
> }
> return ret;
> }


Dec 26 23:26:33 cvknode55 kernel: [ 7521.728030] o2dlm: End recovery on domain E496D3D3799A46E6AC4251B4F7FBFFDF
Dec 26 23:26:33 cvknode55 kernel: [ 7521.728037] (mount.ocfs2,6023,3):dlm_do_master_request:1415 ERROR: link to 3 went down!
Dec 26 23:26:33 cvknode55 kernel: [ 7521.728043] (mount.ocfs2,6023,3):dlm_get_lock_resource:981 ERROR: status = -107
Dec 26 23:26:33 cvknode55 kernel: [ 7521.728046] (mount.ocfs2,6023,3):dlm_restart_lock_mastery:1304 ERROR: node down! 3
Dec 26 23:26:33 cvknode55 kernel: [ 7521.728048] (mount.ocfs2,6023,3):dlm_restart_lock_mastery:1297 node 4 up while restarting
Dec 26 23:26:33 cvknode55 kernel: [ 7521.728050] (mount.ocfs2,6023,3):dlm_wait_for_lock_mastery:1104 ERROR: status = -11
Dec 26 23:26:33 cvknode55 kernel: [ 7521.728053] (mount.ocfs2,6023,3):dlm_get_lock_resource:1003 E496D3D3799A46E6AC4251B4F7FBFFDF: res M0000000000000000000268e0ecb551, Node map changed, redo the master request now, blocked=0
Dec 26 23:26:33 cvknode55 kernel: [ 7521.728055] (mount.ocfs2,6023,3):dlm_do_master_request:1415 ERROR: link to 4 went down!
Dec 26 23:26:33 cvknode55 kernel: [ 7521.728058] (mount.ocfs2,6023,3):dlm_get_lock_resource:981 ERROR: status = -107
Dec 26 23:26:33 cvknode55 kernel: [ 7521.728060] (mount.ocfs2,6023,3):dlm_restart_lock_mastery:1304 ERROR: node down! 4
Dec 26 23:26:33 cvknode55 kernel: [ 7521.728063] (mount.ocfs2,6023,3):dlm_wait_for_lock_mastery:1104 ERROR: status = -11
Dec 26 23:26:33 cvknode55 kernel: [ 7521.728066] (mount.ocfs2,6023,3):dlm_get_lock_resource:1003 E496D3D3799A46E6AC4251B4F7FBFFDF: res M0000000000000000000268e0ecb551, Node map changed, redo the master request now, blocked=0
Dec 26 23:26:33 cvknode55 kernel: [ 7521.728070] (mount.ocfs2,6023,3):dlm_send_remote_lock_request:332 ERROR: E496D3D3799A46E6AC4251B4F7FBFFDF: res M0000000000000000000268e0ecb551, Error -107 send CREATE LOCK to node 3
Dec 26 23:26:33 cvknode55 kernel: [ 7521.831078] (mount.ocfs2,6023,3):dlm_send_remote_lock_request:332 ERROR: E496D3D3799A46E6AC4251B4F7FBFFDF: res M0000000000000000000268e0ecb551, Error -107 send CREATE LOCK to node 3
Dec 26 23:26:33 cvknode55 kernel: [ 7521.935123] (mount.ocfs2,6023,3):dlm_send_remote_lock_request:332 ERROR: E496D3D3799A46E6AC4251B4F7FBFFDF: res M0000000000000000000268e0ecb551, Error -107 send CREATE LOCK to node 3
Dec 26 23:26:33 cvknode55 kernel: [ 7522.039182] (mount.ocfs2,6023,3):dlm_send_remote_lock_request:332 ERROR: E496D3D3799A46E6AC4251B4F7FBFFDF: res M0000000000000000000268e0ecb551, Error -107 send CREATE LOCK to node 3
Dec 26 23:26:33 cvknode55 kernel: [ 7522.143227] (mount.ocfs2,6023,3):dlm_send_remote_lock_request:332 ERROR: E496D3D3799A46E6AC4251B4F7FBFFDF: res M0000000000000000000268e0ecb551, Error -107 send CREATE LOCK to node 3
Dec 26 23:26:33 cvknode55 kernel: [ 7522.247286] (mount.ocfs2,6023,3):dlm_send_remote_lock_request:332 ERROR: E496D3D3799A46E6AC4251B4F7FBFFDF: res M0000000000000000000268e0ecb551, Error -107 send CREATE LOCK to node 3
Dec 26 23:26:33 cvknode55 kernel: [ 7522.351346] (mount.ocfs2,6023,3):dlm_send_remote_lock_request:332 ERROR: E496D3D3799A46E6AC4251B4F7FBFFDF: res M0000000000000000000268e0ecb551, Error -107 send CREATE LOCK to node 3
Dec 26 23:26:33 cvknode55 kernel: [ 7522.455393] (mount.ocfs2,6023,3):dlm_send_remote_lock_request:332 ERROR: E496D3D3799A46E6AC4251B4F7FBFFDF: res M0000000000000000000268e0ecb551, Error -107 send CREATE LOCK to node 3
Dec 26 23:26:34 cvknode55 kernel: [ 7522.559445] (mount.ocfs2,6023,3):dlm_send_remote_lock_request:332 ERROR: E496D3D3799A46E6AC4251B4F7FBFFDF: res M0000000000000000000268e0ecb551, Error -107 send CREATE LOCK to node 3
Dec 26 23:26:34 cvknode55 kernel: [ 7522.663503] (mount.ocfs2,6023,3):dlm_send_remote_lock_request:332 ERROR: E496D3D3799A46E6AC4251B4F7FBFFDF: res M0000000000000000000268e0ecb551, Error -107 send CREATE LOCK to node 3
Dec 26 23:26:34 cvknode55 kernel: [ 7522.767628] (mount.ocfs2,6023,4):dlm_send_remote_lock_request:332 ERROR: E496D3D3799A46E6AC4251B4F7FBFFDF: res M0000000000000000000268e0ecb551, Error -107 send CREATE LOCK to node 3
Dec 26 23:26:34 cvknode55 kernel: [ 7522.871613] (mount.ocfs2,6023,4):dlm_send_remote_lock_request:332 ERROR: E496D3D3799A46E6AC4251B4F7FBFFDF: res M0000000000000000000268e0ecb551, Error -107 send CREATE LOCK to node 3
Dec 26 23:26:34 cvknode55 kernel: [ 7522.975669] (mount.ocfs2,6023,4):dlm_send_remote_lock_request:332 ERROR: E496D3D3799A46E6AC4251B4F7FBFFDF: res M0000000000000000000268e0ecb551, Error -107 send CREATE LOCK to node 3
Dec 26 23:26:34 cvknode55 kernel: [ 7523.079719] (mount.ocfs2,6023,4):dlm_send_remote_lock_request:332 ERROR: E496D3D3799A46E6AC4251B4F7FBFFDF: res M0000000000000000000268e0ecb551, Error -107 send CREATE LOCK to node 3
Dec 26 23:26:34 cvknode55 kernel: [ 7523.183778] (mount.ocfs2,6023,4):dlm_send_remote_lock_request:332 ERROR: E496D3D3799A46E6AC4251B4F7FBFFDF: res M0000000000000000000268e0ecb551, Error -107 send CREATE LOCK to node 3

Dec 26 23:29:40 cvknode55 kernel: [ 7709.066019] o2dlm: Node 3 joins domain E496D3D3799A46E6AC4251B4F7FBFFDF ( 1 3 ) 2 nodes
Dec 26 23:29:40 cvknode55 kernel: [ 7709.072285] (mount.ocfs2,6023,1):dlmlock_remote:269 ERROR: dlm status = DLM_IVLOCKID
Dec 26 23:29:40 cvknode55 kernel: [ 7709.072292] (mount.ocfs2,6023,1):dlmlock:743 ERROR: dlm status = DLM_IVLOCKID
Dec 26 23:29:40 cvknode55 kernel: [ 7709.072297] (mount.ocfs2,6023,1):__ocfs2_cluster_lock:1486 ERROR: DLM error -22 while calling ocfs2_dlm_lock on resource M0000000000000000000268e0ecb551
Dec 26 23:29:40 cvknode55 kernel: [ 7709.072302] (mount.ocfs2,6023,1):ocfs2_inode_lock_full_nested:2333 ERROR: status = -22
Dec 26 23:29:40 cvknode55 kernel: [ 7709.072305] (mount.ocfs2,6023,1):ocfs2_journal_init:860 ERROR: Could not get lock on journal!
Dec 26 23:29:40 cvknode55 kernel: [ 7709.072308] (mount.ocfs2,6023,1):ocfs2_check_volume:2433 ERROR: Could not initialize journal!
Dec 26 23:29:40 cvknode55 kernel: [ 7709.072311] (mount.ocfs2,6023,1):ocfs2_check_volume:2510 ERROR: status = -22
Dec 26 23:29:40 cvknode55 kernel: [ 7709.072314] (mount.ocfs2,6023,1):ocfs2_mount_volume:1889 ERROR: status = -22
Dec 26 23:29:40 cvknode55 kernel: [ 7709.212472] (dlm_thread,6313,2):dlm_drop_lockres_ref:2316 ERROR: E496D3D3799A46E6AC4251B4F7FBFFDF: res M0000000000000000000268e0ecb551, DEREF to node 3 got -22
Dec 26 23:29:40 cvknode55 kernel: [ 7709.212479] lockres: M0000000000000000000268e0ecb551, owner=3, state=64
Dec 26 23:29:40 cvknode55 kernel: [ 7709.212480] last used: 4296818545, refcnt: 3, on purge list: yes
Dec 26 23:29:40 cvknode55 kernel: [ 7709.212481] on dirty list: no, on reco list: no, migrating pending: no
Dec 26 23:29:40 cvknode55 kernel: [ 7709.212482] inflight locks: 0, asts reserved: 0
Dec 26 23:29:40 cvknode55 kernel: [ 7709.212483] refmap nodes: [ ], inflight=0
Dec 26 23:29:40 cvknode55 kernel: [ 7709.212484] res lvb:
Dec 26 23:29:40 cvknode55 kernel: [ 7709.212485] granted queue:
Dec 26 23:29:40 cvknode55 kernel: [ 7709.212486] converting queue:
Dec 26 23:29:40 cvknode55 kernel: [ 7709.212487] blocked queue:
Dec 26 23:29:40 cvknode55 kernel: [ 7709.212509] ------------[ cut here ]------------
Dec 26 23:29:40 cvknode55 kernel: [ 7709.212511] Kernel BUG at ffffffffa02f4471 [verbose debug info unavailable]
Dec 26 23:29:40 cvknode55 kernel: [ 7709.212514] invalid opcode: 0000 [#1] SMP
Dec 26 23:29:40 cvknode55 kernel: [ 7709.212516] Modules linked in: ocfs2(OF) quota_tree(F) cls_u32(F) sch_sfq(F) sch_htb(F) drbd(F) lru_cache(F) 8021q(F) mrp(F) garp(F) stp(F) llc(F) vhost_net(F) macvtap(F) macvlan(F) vhost(F) kvm_intel(OF) kvm(OF) dm_round_robin(F) ib_iser(F) rdma_cm(F) ib_cm(F) iw_cm(F) ib_sa(F) ib_mad(F) ib_core(F) ib_addr(F) iscsi_tcp(F) libiscsi_tcp(F) libiscsi(F) scsi_transport_iscsi(F) ocfs2_dlmfs(OF) ocfs2_stack_o2cb(OF) ocfs2_dlm(OF) ocfs2_nodemanager(OF) ocfs2_stackglue(OF) configfs(F) openvswitch(OF) libcrc32c(F) gre(F) nfsd(F) nfs_acl(F) auth_rpcgss(F) nfs(F) fscache(F) lockd(F) sunrpc(F) sb_edac(F) gpio_ich(F) edac_core(F) dm_multipath(F) psmouse(F) lpc_ich(F) mac_hid(F) scsi_dh(F) hpwdt(F) serio_raw(F) hpilo(F) acpi_power_meter(F) ioatdma(F) lp(F) parport(F) ixgbe(F) tg3(F) dca(F) ptp(F) hpsa(F) pps_core(F) mdio(F) nbd(F) [last unloaded: ipmi_si]
Dec 26 23:29:40 cvknode55 kernel: [ 7709.212562] CPU: 2 PID: 6313 Comm: dlm_thread Tainted: GF O 3.13.6 #1
Dec 26 23:29:40 cvknode55 kernel: [ 7709.212564] Hardware name: H3C FlexServer R590, BIOS P77 08/03/2014
Dec 26 23:29:40 cvknode55 kernel: [ 7709.212567] task: ffff881fda1fb020 ti: ffff881fd5e9c000 task.ti: ffff881fd5e9c000
Dec 26 23:29:40 cvknode55 kernel: [ 7709.212569] RIP: 0010:[<ffffffffa02f4471>] [<ffffffffa02f4471>] dlm_drop_lockres_ref+0x191/0x200 [ocfs2_dlm]
Dec 26 23:29:40 cvknode55 kernel: [ 7709.212579] RSP: 0018:ffff881fd5e9dc88 EFLAGS: 00010246
Dec 26 23:29:40 cvknode55 kernel: [ 7709.212581] RAX: 0000000000000000 RBX: ffff881fe3ae4c00 RCX: 0000000000000006
Dec 26 23:29:40 cvknode55 kernel: [ 7709.212583] RDX: 0000000000000007 RSI: 000000001c0e1c0c RDI: ffff880fd2fcc1f0
Dec 26 23:29:40 cvknode55 kernel: [ 7709.212585] RBP: ffff881fd5e9dd48 R08: 000000000000000a R09: 0000000000000000
Dec 26 23:29:40 cvknode55 kernel: [ 7709.212587] R10: 0000000000000f92 R11: 0000000000000f91 R12: 0000000000000000
Dec 26 23:29:40 cvknode55 kernel: [ 7709.212589] R13: ffff880fd2fcc140 R14: 000000000000001f R15: ffff880fe56e4920
Dec 26 23:29:40 cvknode55 kernel: [ 7709.212592] FS: 0000000000000000(0000) GS:ffff880fff640000(0000) knlGS:0000000000000000
Dec 26 23:29:40 cvknode55 kernel: [ 7709.212595] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Dec 26 23:29:40 cvknode55 kernel: [ 7709.212597] CR2: 00007fca26537630 CR3: 0000000001c0d000 CR4: 00000000001407e0
Dec 26 23:29:40 cvknode55 kernel: [ 7709.212599] Stack:
Dec 26 23:29:40 cvknode55 kernel: [ 7709.212600] ffff880fe6e7b980 ffff881f0000001f ffff880fe56e4920 ffffffff00000003
Dec 26 23:29:40 cvknode55 kernel: [ 7709.212605] 00000000ffffffea 0000000000000282 ffff881fd5e9dcd8 ffffffea810ad89a
Dec 26 23:29:40 cvknode55 kernel: [ 7709.212610] 1f01000000000000 303030303030304d 3030303030303030 6538363230303030
Dec 26 23:29:40 cvknode55 kernel: [ 7709.212614] Call Trace:
Dec 26 23:29:40 cvknode55 kernel: [ 7709.212621] [<ffffffffa02e2d58>] dlm_thread+0xef8/0x1810 [ocfs2_dlm]
Dec 26 23:29:40 cvknode55 kernel: [ 7709.212628] [<ffffffff8101cba3>] ? native_sched_clock+0x13/0x80
Dec 26 23:29:40 cvknode55 kernel: [ 7709.212631] [<ffffffff8101cc19>] ? sched_clock+0x9/0x10
Dec 26 23:29:40 cvknode55 kernel: [ 7709.212637] [<ffffffff810adb20>] ? __wake_up_sync+0x20/0x20
Dec 26 23:29:40 cvknode55 kernel: [ 7709.212643] [<ffffffffa02e1e60>] ? __dlm_dirty_lockres+0x130/0x130 [ocfs2_dlm]
Dec 26 23:29:40 cvknode55 kernel: [ 7709.212647] [<ffffffff8108d079>] kthread+0xc9/0xe0
Dec 26 23:29:40 cvknode55 kernel: [ 7709.212651] [<ffffffff8108cfb0>] ? flush_kthread_worker+0xb0/0xb0
Dec 26 23:29:40 cvknode55 kernel: [ 7709.212656] [<ffffffff81760ffc>] ret_from_fork+0x7c/0xb0
Dec 26 23:29:40 cvknode55 kernel: [ 7709.212659] [<ffffffff8108cfb0>] ? flush_kthread_worker+0xb0/0xb0
Dec 26 23:29:40 cvknode55 kernel: [ 7709.212661] Code: ff ff e8 03 46 d7 e0 48 ba 40 02 00 00 00 00 00 10 48 85 15 62 8f f7 ff 74 09 48 85 15 99 ae f7 ff 74 0a 4c 89 ef e8 7f ce fe ff <0f> 0b 45 0f b6 85 d0 00 00 00 48 8b 7b 78 65 8b 0c 25 64 b0 00
Dec 26 23:29:40 cvknode55 kernel: [ 7709.212688] RIP [<ffffffffa02f4471>] dlm_drop_lockres_ref+0x191/0x200 [ocfs2_dlm]
Dec 26 23:29:40 cvknode55 kernel: [ 7709.212694] RSP <ffff881fd5e9dc88>
________________________________
zhangguanghui
-------------------------------------------------------------------------------------------------------------------------------------
????????????????????????????????????????
????????????????????????????????????????
????????????????????????????????????????
???
This e-mail and its attachments contain confidential information from H3C, which is
intended only for the person or entity whose address is listed above. Any use of the
information contained herein in any way (including, but not limited to, total or partial
disclosure, reproduction, or dissemination) by persons other than the intended
recipient(s) is prohibited. If you receive this e-mail in error, please notify the sender
by phone or email immediately and delete it!
-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20160114/ffdbeba4/attachment-0001.html 
