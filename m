From: Eric Ren <zren@suse.com>
Date: Tue, 13 Sep 2016 16:23:52 +0800
Subject: [Ocfs2-devel] [Ocfs2-users] ocf2 mount point hangs
In-Reply-To: <CABeLS8OKT1Vd1y+u_oxnh9Q7mvKJ1k940YmXwi9BH1FyqmmMxg@mail.gmail.com>
References: <CABeLS8OKT1Vd1y+u_oxnh9Q7mvKJ1k940YmXwi9BH1FyqmmMxg@mail.gmail.com>
Message-ID: <c862b3b7-b53b-7641-8366-28c3bfeda3b9@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,

On 09/13/2016 03:16 PM, Ishmael Tsoaela wrote:
> Hi All,
>
> I have an ocfs2  mount point of 3 ceph cluster nodes and suddenly I
> cannot read and write to the mount point although the cluster is clean
> and showing no errors.
1. What is your ocfs2 shared disk? I mean it's a shared disk exported by iscsi target, or a 
ceph rbd device?
2. Did you check if ocfs2 works well before any read/write? and how?
3. Could you elaborating more details how the ceph nodes use ocfs2?
4. Please provide the output of:
        #sudo debugfs.ocfs2 -R stats /dev/sda
>
>
> Are the any other logs I can check?
All log messages should go to /var/log/messages, could you attach the whole log file?

Eric
>
> There are some log in kern.log about
>
>
> kern.log
>
> Sep 13 08:10:18 nodeB kernel: [1104431.300882] kernel BUG at
> /build/linux-lts-wily-Vv6Eyd/linux-lts-wily-4.2.0/fs/ocfs2/suballoc.c:2419!
> Sep 13 08:10:18 nodeB kernel: [1104431.345504] invalid opcode: 0000 [#1] SMP
> Sep 13 08:10:18 nodeB kernel: [1104431.370081] Modules linked in:
> vhost_net vhost macvtap macvlan ocfs2 quota_tree rbd libceph ipmi_si
> mpt3sas mpt2sas raid_class scsi_transport_sas mptctl mptbase
> xt_CHECKSUM iptable_mangle ipt_MASQUERADE nf_nat_masquerade_ipv4
> iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv4 nf_defrag_ipv4
> xt_conntrack nf_conntrack ipt_REJECT nf_reject_ipv4 xt_tcpudp
> ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter
> ip_tables x_tables dell_rbu ocfs2_dlmfs ocfs2_stack_o2cb ocfs2_dlm
> ocfs2_nodemanager ocfs2_stackglue configfs bridge stp llc binfmt_misc
> ipmi_devintf kvm_amd dcdbas kvm input_leds joydev amd64_edac_mod
> crct10dif_pclmul edac_core shpchp i2c_piix4 fam15h_power crc32_pclmul
> edac_mce_amd ipmi_ssif k10temp aesni_intel aes_x86_64 lrw gf128mul
> 8250_fintek glue_helper acpi_power_meter mac_hid serio_raw ablk_helper
> cryptd ipmi_msghandler xfs libcrc32c lp parport ixgbe dca hid_generic
> uas usbhid vxlan usb_storage ip6_udp_tunnel hid udp_tunnel ptp psmouse
> bnx2 pps_core megaraid_sas mdio [last unloaded: ipmi_si]
> Sep 13 08:10:18 nodeB kernel: [1104431.898986] CPU: 10 PID: 65016
> Comm: cp Not tainted 4.2.0-27-generic #32~14.04.1-Ubuntu
> Sep 13 08:10:18 nodeB kernel: [1104432.012469] Hardware name: Dell
> Inc. PowerEdge R515/0RMRF7, BIOS 2.0.2 10/22/2012
> Sep 13 08:10:18 nodeB kernel: [1104432.134659] task: ffff880a61dca940
> ti: ffff88084a5ac000 task.ti: ffff88084a5ac000
> Sep 13 08:10:18 nodeB kernel: [1104432.265260] RIP:
> 0010:[<ffffffffc062026b>]  [<ffffffffc062026b>]
> _ocfs2_free_suballoc_bits+0x4db/0x4e0 [ocfs2]
> Sep 13 08:10:18 nodeB kernel: [1104432.406559] RSP:
> 0018:ffff88084a5af798  EFLAGS: 00010246
> Sep 13 08:10:18 nodeB kernel: [1104432.479958] RAX: 0000000000000000
> RBX: ffff881acebcb000 RCX: ffff881fcd372e00
> Sep 13 08:10:18 nodeB kernel: [1104432.630768] RDX: ffff881fd0d4dc30
> RSI: ffff88197e351bc8 RDI: ffff880fd127b2b0
> Sep 13 08:10:18 nodeB kernel: [1104432.789688] RBP: ffff88084a5af818
> R08: 0000000000000002 R09: 0000000000007e00
> Sep 13 08:10:18 nodeB kernel: [1104432.950053] R10: ffff880d39a21020
> R11: ffff88084a5af550 R12: 00000000000000fa
> Sep 13 08:10:18 nodeB kernel: [1104433.113014] R13: 0000000000005ab1
> R14: 0000000000000000 R15: ffff880fb2d43000
> Sep 13 08:10:18 nodeB kernel: [1104433.276484] FS:
> 00007fcc68373840(0000) GS:ffff881fdde80000(0000)
> knlGS:0000000000000000
> Sep 13 08:10:18 nodeB kernel: [1104433.440016] CS:  0010 DS: 0000 ES:
> 0000 CR0: 000000008005003b
> Sep 13 08:10:18 nodeB kernel: [1104433.521496] CR2: 00005647b2ee6d80
> CR3: 0000000198b93000 CR4: 00000000000406e0
> Sep 13 08:10:18 nodeB kernel: [1104433.681357] Stack:
> Sep 13 08:10:18 nodeB kernel: [1104433.758498]  0000000000000000
> ffff880fd127b2e8 ffff881fc6655f08 00005bab00000000
> Sep 13 08:10:18 nodeB kernel: [1104433.913655]  ffff881fd0c51d80
> ffff88197e351bc8 ffff880fd127b330 ffff880e9eaa6000
> Sep 13 08:10:18 nodeB kernel: [1104434.068609]  ffff88197e351bc8
> ffffffff817ba6d6 0000000000000001 000000001ac592b1
> Sep 13 08:10:18 nodeB kernel: [1104434.223347] Call Trace:
> Sep 13 08:10:18 nodeB kernel: [1104434.298560]  [<ffffffff817ba6d6>] ?
> mutex_lock+0x16/0x37
> Sep 13 08:10:18 nodeB kernel: [1104434.374183]  [<ffffffffc0621bca>]
> _ocfs2_free_clusters+0xea/0x200 [ocfs2]
> Sep 13 08:10:18 nodeB kernel: [1104434.449628]  [<ffffffffc061ecb0>] ?
> ocfs2_put_slot+0xe0/0xe0 [ocfs2]
> Sep 13 08:10:18 nodeB kernel: [1104434.523971]  [<ffffffffc061ecb0>] ?
> ocfs2_put_slot+0xe0/0xe0 [ocfs2]
> Sep 13 08:10:18 nodeB kernel: [1104434.595803]  [<ffffffffc06234e5>]
> ocfs2_free_clusters+0x15/0x20 [ocfs2]
> Sep 13 08:10:18 nodeB kernel: [1104434.666614]  [<ffffffffc05d6037>]
> __ocfs2_flush_truncate_log+0x247/0x560 [ocfs2]
> Sep 13 08:10:18 nodeB kernel: [1104434.806017]  [<ffffffffc05d25a6>] ?
> ocfs2_num_free_extents+0x56/0x120 [ocfs2]
> Sep 13 08:10:18 nodeB kernel: [1104434.946141]  [<ffffffffc05db258>]
> ocfs2_remove_btree_range+0x4e8/0x760 [ocfs2]
> Sep 13 08:10:18 nodeB kernel: [1104435.086490]  [<ffffffffc05dc720>]
> ocfs2_commit_truncate+0x180/0x590 [ocfs2]
> Sep 13 08:10:18 nodeB kernel: [1104435.158189]  [<ffffffffc06022b0>] ?
> ocfs2_allocate_extend_trans+0x130/0x130 [ocfs2]
> Sep 13 08:10:18 nodeB kernel: [1104435.297235]  [<ffffffffc05f7e2c>]
> ocfs2_truncate_file+0x39c/0x610 [ocfs2]
> Sep 13 08:10:18 nodeB kernel: [1104435.368060]  [<ffffffffc05fe650>] ?
> ocfs2_read_inode_block+0x10/0x20 [ocfs2]
> Sep 13 08:10:18 nodeB kernel: [1104435.505117]  [<ffffffffc05fa2d7>]
> ocfs2_setattr+0x4b7/0xa50 [ocfs2]
> Sep 13 08:10:18 nodeB kernel: [1104435.574617]  [<ffffffffc064c4fd>] ?
> ocfs2_xattr_get+0x9d/0x130 [ocfs2]
> Sep 13 08:10:18 nodeB kernel: [1104435.643722]  [<ffffffff8120705e>]
> notify_change+0x1ae/0x380
> Sep 13 08:10:18 nodeB kernel: [1104435.712037]  [<ffffffff811e8436>]
> do_truncate+0x66/0xa0
> Sep 13 08:10:18 nodeB kernel: [1104435.778685]  [<ffffffff811f8527>]
> path_openat+0x277/0x1330
> Sep 13 08:10:18 nodeB kernel: [1104435.845776]  [<ffffffffc05f2bed>] ?
> __ocfs2_cluster_unlock.isra.36+0x7d/0xb0 [ocfs2]
> Sep 13 08:10:18 nodeB kernel: [1104435.977677]  [<ffffffff811fae8a>]
> do_filp_open+0x7a/0xd0
> Sep 13 08:10:18 nodeB kernel: [1104436.043693]  [<ffffffff811f9f8f>] ?
> getname_flags+0x4f/0x1f0
> Sep 13 08:10:18 nodeB kernel: [1104436.108385]  [<ffffffff81208006>] ?
> __alloc_fd+0x46/0x110
> Sep 13 08:10:18 nodeB kernel: [1104436.171504]  [<ffffffff811ea509>]
> do_sys_open+0x129/0x260
> Sep 13 08:10:18 nodeB kernel: [1104436.232889]  [<ffffffff811ea65e>]
> SyS_open+0x1e/0x20
> Sep 13 08:10:18 nodeB kernel: [1104436.294292]  [<ffffffff817bc3b2>]
> entry_SYSCALL_64_fastpath+0x16/0x75
> Sep 13 08:10:18 nodeB kernel: [1104436.356257] Code: 65 c0 48 c7 c6 e0
> 44 65 c0 41 b6 e2 48 8d 5d c8 48 8b 78 28 44 89 24 24 31 c0 49 c7 c4
> e2 ff ff ff e8 9a 8d 01 00 e9 c4 fd ff ff <0f> 0b 0f 0b 90 0f 1f 44 00
> 00 55 48 89 e5 41 57 41 89 cf b9 01
> Sep 13 08:10:18 nodeB kernel: [1104436.549534] RIP
> [<ffffffffc062026b>] _ocfs2_free_suballoc_bits+0x4db/0x4e0 [ocfs2]
> Sep 13 08:10:18 nodeB kernel: [1104436.681076]  RSP <ffff88084a5af798>
> Sep 13 08:10:18 nodeB kernel: [1104436.834529] ---[ end trace
> 5f4b84ac539ed56c ]---
>
> _______________________________________________
> Ocfs2-users mailing list
> Ocfs2-users at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-users
>
