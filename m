From: Joseph Qi <joseph.qi@huawei.com>
Date: Sat, 27 Jul 2013 18:03:33 +0800
Subject: [Ocfs2-devel] Null Pointer issue
In-Reply-To: <71604351584F6A4EBAE558C676F37CA417BDD898@H3CMLB02-EX.srv.huawei-3com.com>
References: <71604351584F6A4EBAE558C676F37CA417BDD898@H3CMLB02-EX.srv.huawei-3com.com>
Message-ID: <51F39AF5.1030905@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This bug has been resolved by Sunil on Nov, 2011.
Please refer the below link for details.
https://oss.oracle.com/pipermail/ocfs2-devel/2011-November/008428.html

On 2013/7/27 17:29, Guozhonghua wrote:
> Hi everyone,
> 
>  
> 
> The is an null pointer issue, sometime may cause the host blocked.
> 
>  
> 
> The diff file is as below:
> 
> --- /ocfs2-ko-3.2/cluster/tcp.c
> 
> +++ /ocfs2-ko-3.2/cluster/tcp.c
> 
> @@ -1700,13 +1700,14 @@
> 
>               ret = 0;
> 
>  out:
> 
> -       if (ret) {
> 
> -               printk(KERN_NOTICE "o2net: Connect attempt to " SC_NODEF_FMT
> 
> -                      " failed with errno %d\n", SC_NODEF_ARGS(sc), ret);
> 
> +      if (ret) {          
> 
>               /* 0 err so that another will be queued and attempted
> 
>                * from set_nn_state */
> 
> -               if (sc)
> 
> +              if (sc) {
> 
> +            printk(KERN_NOTICE "o2net: Connect attempt to " SC_NODEF_FMT
> 
> +                     " failed with errno %d\n", SC_NODEF_ARGS(sc), ret);
> 
>                       o2net_ensure_shutdown(nn, sc, 0);
> 
> +        }
> 
>       }
> 
>       if (sc)
> 
>               sc_put(sc);
> 
>  
> 
>  
> 
> As we test it, the back trace log of this issue is as below:
> 
>  
> 
> Jul 24 10:14:01 Server20 CRON[30615]: (root) CMD (  
> /opt/bin/tomcat_check.sh)
> 
> Jul 24 10:14:57 Server20 kernel: [70163.969110]
> (kworker/u:2,18202,0):sc_alloc:446 ERROR: status = -2
> 
> Jul 24 10:14:57 Server20 kernel: [70163.969133] BUG: unable to handle
> kernel NULL pointer dereference at 0000000000000010
> 
> Jul 24 10:14:57 Server20 kernel: [70163.969141] IP: [<ffffffffa0570658>]
> o2net_start_connect+0x1c8/0x500 [ocfs2_nodemanager]
> 
> Jul 24 10:14:57 Server20 kernel: [70163.969156] PGD 0
> 
> Jul 24 10:14:57 Server20 kernel: [70163.969160] Oops: 0000 [#1] SMP
> 
> Jul 24 10:14:57 Server20 kernel: [70163.969164] CPU 0
> 
> Jul 24 10:14:57 Server20 kernel: [70163.969166] Modules linked in:
> ocfs2(O) quota_tree ocfs2_dlmfs(O) ocfs2_stack_o2cb(O) ocfs2_dlm(O)
> ocfs2_nodemanager(O) ocfs2_stackglue(O) configfs ib_iser rdma_cm ib_cm
> iw_cm ib_sa ib_mad ib_core ib_addr iscsi_tcp libiscsi_tcp libiscsi
> scsi_transport_iscsi drbd lru_cache ip6table_filter ip6_tables
> iptable_filter ip_tables ebtable_nat ebtables x_tables 8021q garp stp
> kvm_intel kvm openvswitch_mod(O) vesafb nfsd nfs lockd fscache
> auth_rpcgss nfs_acl radeon sunrpc ttm drm_kms_helper psmouse drm
> serio_raw joydev i2c_algo_bit i7core_edac dm_multipath mac_hid edac_core
> hpilo acpi_power_meter lp parport usbhid hid qla2xxx scsi_transport_fc
> scsi_tgt bnx2 be2net hpsa [last unloaded: scsi_transport_iscsi]
> 
> Jul 24 10:14:57 Server20 kernel: [70163.969246]
> 
> Jul 24 10:14:57 Server20 kernel: [70163.969250] Pid: 18202, comm:
> kworker/u:2 Tainted: G           O 3.2.0-23-generic #36-Ubuntu HP
> ProLiant DL360 G7
> 
> Jul 24 10:14:57 Server20 kernel: [70163.969258] RIP:
> 0010:[<ffffffffa0570658>]  [<ffffffffa0570658>]
> o2net_start_connect+0x1c8/0x500 [ocfs2_nodemanager]
> 
> Jul 24 10:14:57 Server20 kernel: [70163.969270] RSP:
> 0018:ffff8803ddccdd60  EFLAGS: 00010246
> 
> Jul 24 10:14:57 Server20 kernel: [70163.969275] RAX: 0000000000000000
> RBX: ffffffffa057a828 RCX: 00000000000f5956
> 
> Jul 24 10:14:57 Server20 kernel: [70163.969281] RDX: 00000000000f5955
> RSI: 0000000000016660 RDI: ffff88040f802a00
> 
> Jul 24 10:14:57 Server20 kernel: [70163.969286] RBP: ffff8803ddccde00
> R08: ffffea00100ed700 R09: ffffffffa0570340
> 
> Jul 24 10:14:57 Server20 kernel: [70163.969291] R10: 00000000fffffff4
> R11: 0000000000000000 R12: ffff8808045e0400
> 
> Jul 24 10:14:57 Server20 kernel: [70163.969296] R13: ffff8808045e1400
> R14: ffffffffa057a7c0 R15: 0000000000000000
> 
> Jul 24 10:14:57 Server20 kernel: [70163.969302] FS: 
> 0000000000000000(0000) GS:ffff88040fc00000(0000) knlGS:0000000000000000
> 
> Jul 24 10:14:57 Server20 kernel: [70163.969309] CS:  0010 DS: 0000 ES:
> 0000 CR0: 000000008005003b
> 
> Jul 24 10:14:57 Server20 kernel: [70163.969314] CR2: 0000000000000010
> CR3: 0000000001c05000 CR4: 00000000000006f0
> 
> Jul 24 10:14:57 Server20 kernel: [70163.969319] DR0: 0000000000000000
> DR1: 0000000000000000 DR2: 0000000000000000
> 
> Jul 24 10:14:57 Server20 kernel: [70163.969324] DR3: 0000000000000000
> DR6: 00000000ffff0ff0 DR7: 0000000000000400
> 
> Jul 24 10:14:57 Server20 kernel: [70163.969330] Process kworker/u:2
> (pid: 18202, threadinfo ffff8803ddccc000, task ffff8804052f8000)
> 
> Jul 24 10:14:57 Server20 kernel: [70163.969336] Stack:
> 
> Jul 24 10:14:57 Server20 kernel: [70163.969339]  ffff8803ddccdda0
> 00000001010b3279 ffff8803ddccddd0 ffffffff810126e5
> 
> Jul 24 10:14:57 Server20 kernel: [70163.969349]  ffff8803ddccdd90
> ffffffff8165c46e 0000000000000000 0000000000000000
> 
> Jul 24 10:14:57 Server20 kernel: [70163.969359]  ffff8803ddccddd0
> 0000000000000000 0000000000000000 0000000000000000
> 
> Jul 24 10:14:57 Server20 kernel: [70163.969368] Call Trace:
> 
> Jul 24 10:14:57 Server20 kernel: [70163.969377]  [<ffffffff810126e5>] ?
> __switch_to+0xf5/0x360
> 
> Jul 24 10:14:57 Server20 kernel: [70163.969385]  [<ffffffff8165c46e>] ?
> _raw_spin_lock+0xe/0x20
> 
> Jul 24 10:14:57 Server20 kernel: [70163.969396]  [<ffffffffa0570490>] ?
> sc_alloc+0x2a0/0x2a0 [ocfs2_nodemanager]
> 
> Jul 24 10:14:57 Server20 kernel: [70163.969404]  [<ffffffff81084e2a>]
> process_one_work+0x11a/0x480
> 
> Jul 24 10:14:57 Server20 kernel: [70163.969411]  [<ffffffff81085bd4>]
> worker_thread+0x164/0x370
> 
> Jul 24 10:14:57 Server20 kernel: [70163.969418]  [<ffffffff81085a70>] ?
> manage_workers.isra.29+0x130/0x130
> 
> Jul 24 10:14:57 Server20 kernel: [70163.969425]  [<ffffffff8108a42c>]
> kthread+0x8c/0xa0
> 
> Jul 24 10:14:57 Server20 kernel: [70163.969432]  [<ffffffff81666bf4>]
> kernel_thread_helper+0x4/0x10
> 
> Jul 24 10:14:57 Server20 kernel: [70163.969439]  [<ffffffff8108a3a0>] ?
> flush_kthread_worker+0xa0/0xa0
> 
> Jul 24 10:14:57 Server20 kernel: [70163.969445]  [<ffffffff81666bf0>] ?
> gs_change+0x13/0x13
> 
> Jul 24 10:14:57 Server20 kernel: [70163.969449] Code: 8f 01 00 00 48 b8
> 01 00 00 00 00 00 00 10 48 85 05 7e 7d 00 00 74 14 48 85 05 b5 9c 00 00
> 0f 84 e1 02 00 00 0f 1f 80 00 00 00 00 <49> 8b 77 10 31 c0 45 89 d1 48
> c7 c7 b0 69 57 a0 44 0f b7 86 a0
> 
> Jul 24 10:14:57 Server20 kernel: [70163.969498] RIP 
> [<ffffffffa0570658>] o2net_start_connect+0x1c8/0x500 [ocfs2_nodemanager]
> 
> Jul 24 10:14:57 Server20 kernel: [70163.969510]  RSP <ffff8803ddccdd60>
> 
> Jul 24 10:14:57 Server20 kernel: [70163.969513] CR2: 0000000000000010
> 
> Jul 24 10:14:57 Server20 kernel: [70163.981144] ---[ end trace
> 8f56ad2a8a729411 ]---
> 
> Jul 24 10:14:57 Server20 kernel: [70163.981178] BUG: unable to handle
> kernel paging request at fffffffffffffff8
> 
> Jul 24 10:14:57 Server20 kernel: [70163.981189] IP: [<ffffffff8108a8c1>]
> kthread_data+0x11/0x20
> 
> Jul 24 10:14:57 Server20 kernel: [70163.981200] PGD 1c07067 PUD 1c08067
> PMD 0
> 
> Jul 24 10:14:57 Server20 kernel: [70163.981210] Oops: 0000 [#2] SMP
> 
> Jul 24 10:14:57 Server20 kernel: [70163.981218] CPU 0
> 
> Jul 24 10:14:57 Server20 kernel: [70163.981222] Modules linked in:
> ocfs2(O) quota_tree ocfs2_dlmfs(O) ocfs2_stack_o2cb(O) ocfs2_dlm(O)
> ocfs2_nodemanager(O) ocfs2_stackglue(O) configfs ib_iser rdma_cm ib_cm
> iw_cm ib_sa ib_mad ib_core ib_addr iscsi_tcp libiscsi_tcp libiscsi
> scsi_transport_iscsi drbd lru_cache ip6table_filter ip6_tables
> iptable_filter ip_tables ebtable_nat ebtables x_tables 8021q garp stp
> kvm_intel kvm openvswitch_mod(O) vesafb nfsd nfs lockd fscache
> auth_rpcgss nfs_acl radeon sunrpc ttm drm_kms_helper psmouse drm
> serio_raw joydev i2c_algo_bit i7core_edac dm_multipath mac_hid edac_core
> hpilo acpi_power_meter lp parport usbhid hid qla2xxx scsi_transport_fc
> scsi_tgt bnx2 be2net hpsa [last unloaded: scsi_transport_iscsi]
> 
> Jul 24 10:14:57 Server20 kernel: [70163.981374]
> 
> Jul 24 10:14:57 Server20 kernel: [70163.981379] Pid: 18202, comm:
> kworker/u:2 Tainted: G      D    O 3.2.0-23-generic #36-Ubuntu HP
> ProLiant DL360 G7
> 
> Jul 24 10:14:57 Server20 kernel: [70163.981393] RIP:
> 0010:[<ffffffff8108a8c1>]  [<ffffffff8108a8c1>] kthread_data+0x11/0x20
> 
> Jul 24 10:14:57 Server20 kernel: [70163.981405] RSP:
> 0018:ffff8803ddccd9b0  EFLAGS: 00010096
> 
> Jul 24 10:14:57 Server20 kernel: [70163.981413] RAX: 0000000000000000
> RBX: 0000000000000000 RCX: 0000000000000000
> 
> Jul 24 10:14:57 Server20 kernel: [70163.981421] RDX: 0000000000000000
> RSI: 0000000000000000 RDI: ffff8804052f8000
> 
> Jul 24 10:14:57 Server20 kernel: [70163.981429] RBP: ffff8803ddccd9c8
> R08: 0000000000989680 R09: 0000000000000000
> 
> Jul 24 10:14:57 Server20 kernel: [70163.981437] R10: 0000000000000000
> R11: 0000000000000000 R12: 0000000000000000
> 
> Jul 24 10:14:57 Server20 kernel: [70163.981445] R13: ffff8804052f83c8
> R14: 0000000000000000 R15: 0000000000000246
> 
> Jul 24 10:14:57 Server20 kernel: [70163.981453] FS: 
> 0000000000000000(0000) GS:ffff88040fc00000(0000) knlGS:0000000000000000
> 
> Jul 24 10:14:57 Server20 kernel: [70163.981463] CS:  0010 DS: 0000 ES:
> 0000 CR0: 000000008005003b
> 
> Jul 24 10:14:57 Server20 kernel: [70163.981470] CR2: fffffffffffffff8
> CR3: 0000000001c05000 CR4: 00000000000006f0
> 
> Jul 24 10:14:57 Server20 kernel: [70163.981478] DR0: 0000000000000000
> DR1: 0000000000000000 DR2: 0000000000000000
> 
> Jul 24 10:14:57 Server20 kernel: [70163.981486] DR3: 0000000000000000
> DR6: 00000000ffff0ff0 DR7: 0000000000000400
> 
> Jul 24 10:14:57 Server20 kernel: [70163.981494] Process kworker/u:2
> (pid: 18202, threadinfo ffff8803ddccc000, task ffff8804052f8000)
> 
> Jul 24 10:14:57 Server20 kernel: [70163.981504] Stack:
> 
> Jul 24 10:14:57 Server20 kernel: [70163.981508]  ffffffff81086135
> ffff8803ddccd9c8 ffff88040fc13780 ffff8803ddccda48
> 
> Jul 24 10:14:57 Server20 kernel: [70163.981527]  ffffffff8165a117
> ffff8803ddccda08 ffff8804052f8000 ffff8803ddccdfd8
> 
> Jul 24 10:14:57 Server20 kernel: [70163.981545]  ffff8803ddccdfd8
> ffff8803ddccdfd8 0000000000013780 ffff8803ddccda38
> 
> Jul 24 10:14:57 Server20 kernel: [70163.981563] Call Trace:
> 
> Jul 24 10:14:57 Server20 kernel: [70163.981571]  [<ffffffff81086135>] ?
> wq_worker_sleeping+0x15/0xa0
> 
> Jul 24 10:14:57 Server20 kernel: [70163.981582]  [<ffffffff8165a117>]
> __schedule+0x5d7/0x6f0
> 
> Jul 24 10:14:57 Server20 kernel: [70163.981590]  [<ffffffff8165a55f>]
> schedule+0x3f/0x60
> 
> Jul 24 10:14:57 Server20 kernel: [70163.981601]  [<ffffffff8106bafb>]
> do_exit+0x26b/0x420
> 
> Jul 24 10:14:57 Server20 kernel: [70163.981611]  [<ffffffff8165d620>]
> oops_end+0xb0/0xf0
> 
> Jul 24 10:14:57 Server20 kernel: [70163.981621]  [<ffffffff81642ebd>]
> no_context+0x150/0x15d
> 
> Jul 24 10:14:57 Server20 kernel: [70163.981630]  [<ffffffff81643093>]
> __bad_area_nosemaphore+0x1c9/0x1e8
> 
> Jul 24 10:14:57 Server20 kernel: [70163.981640]  [<ffffffff8103dbb9>] ?
> default_spin_lock_flags+0x9/0x10
> 
> Jul 24 10:14:57 Server20 kernel: [70163.981650]  [<ffffffff816430c5>]
> bad_area_nosemaphore+0x13/0x15
> 
> Jul 24 10:14:57 Server20 kernel: [70163.981661]  [<ffffffff81660276>]
> do_page_fault+0x426/0x520
> 
> Jul 24 10:14:57 Server20 kernel: [70163.981671]  [<ffffffff81067a05>] ?
> console_unlock+0x135/0x180
> 
> Jul 24 10:14:57 Server20 kernel: [70163.981682]  [<ffffffff811971e5>] ?
> mntput_no_expire+0xa5/0xf0
> 
> Jul 24 10:14:57 Server20 kernel: [70163.981688]  [<ffffffff8165cbf5>]
> page_fault+0x25/0x30
> 
> Jul 24 10:14:57 Server20 kernel: [70163.981699]  [<ffffffffa0570340>] ?
> sc_alloc+0x150/0x2a0 [ocfs2_nodemanager]
> 
> Jul 24 10:14:57 Server20 kernel: [70163.981709]  [<ffffffffa0570658>] ?
> o2net_start_connect+0x1c8/0x500 [ocfs2_nodemanager]
> 
> Jul 24 10:14:57 Server20 kernel: [70163.981718]  [<ffffffff810126e5>] ?
> __switch_to+0xf5/0x360
> 
> Jul 24 10:14:57 Server20 kernel: [70163.981724]  [<ffffffff8165c46e>] ?
> _raw_spin_lock+0xe/0x20
> 
> Jul 24 10:14:57 Server20 kernel: [70163.981734]  [<ffffffffa0570490>] ?
> sc_alloc+0x2a0/0x2a0 [ocfs2_nodemanager]
> 
> Jul 24 10:14:57 Server20 kernel: [70163.981741]  [<ffffffff81084e2a>]
> process_one_work+0x11a/0x480
> 
> Jul 24 10:14:57 Server20 kernel: [70163.981748]  [<ffffffff81085bd4>]
> worker_thread+0x164/0x370
> 
> Jul 24 10:14:57 Server20 kernel: [70163.981754]  [<ffffffff81085a70>] ?
> manage_workers.isra.29+0x130/0x130
> 
> Jul 24 10:14:57 Server20 kernel: [70163.981761]  [<ffffffff8108a42c>]
> kthread+0x8c/0xa0
> 
> Jul 24 10:14:57 Server20 kernel: [70163.981767]  [<ffffffff81666bf4>]
> kernel_thread_helper+0x4/0x10
> 
> Jul 24 10:14:57 Server20 kernel: [70163.981773]  [<ffffffff8108a3a0>] ?
> flush_kthread_worker+0xa0/0xa0
> 
> Jul 24 10:14:57 Server20 kernel: [70163.981780]  [<ffffffff81666bf0>] ?
> gs_change+0x13/0x13
> 
> Jul 24 10:14:57 Server20 kernel: [70163.981783] Code: 41 5f 5d c3 be 3e
> 01 00 00 48 c7 c7 80 9a a0 81 e8 c5 c8 fd ff e9 74 fe ff ff 55 48 89 e5
> 66 66 66 66 90 48 8b 87 70 03 00 00 5d <48> 8b 40 f8 c3 66 2e 0f 1f 84
> 00 00 00 00 00 55 48 89 e5 66 66
> 
> Jul 24 10:14:57 Server20 kernel: [70163.981832] RIP 
> [<ffffffff8108a8c1>] kthread_data+0x11/0x20
> 
> Jul 24 10:14:57 Server20 kernel: [70163.981839]  RSP <ffff8803ddccd9b0>
> 
> Jul 24 10:14:57 Server20 kernel: [70163.981842] CR2: fffffffffffffff8
> 
> Jul 24 10:14:57 Server20 kernel: [70163.981846] ---[ end trace
> 8f56ad2a8a729412 ]---
> 
> Jul 24 10:14:57 Server20 kernel: [70163.981849] Fixing recursive fault
> but reboot is needed!
> 
>  
> 
> -------------------------------------------------------------------------------------------------------------------------------------
> ????????????????????????????????????
> ????
> ???????????????????????????????????
> ?????
> ????????????????????????????????????
> ????
> ???
> This e-mail and its attachments contain confidential information from
> H3C, which is
> intended only for the person or entity whose address is listed above.
> Any use of the
> information contained herein in any way (including, but not limited to,
> total or partial
> disclosure, reproduction, or dissemination) by persons other than the
> intended
> recipient(s) is prohibited. If you receive this e-mail in error, please
> notify the sender
> by phone or email immediately and delete it!
> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
> 
