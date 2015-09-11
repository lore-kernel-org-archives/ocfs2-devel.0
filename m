From: Joseph Qi <joseph.qi@huawei.com>
Date: Fri, 11 Sep 2015 09:11:18 +0800
Subject: [Ocfs2-devel] [Ocfs2-users] ocfs2-related kernel panic with
	Linux 4.1.6 kernels
In-Reply-To: <1639611.1xGLS1q6kR@skynet.simkin.ca>
References: <1639611.1xGLS1q6kR@skynet.simkin.ca>
Message-ID: <55F22A36.7070407@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Alan,
It is caused by unlocking rw lock twice during dio.
I think it is the same bug fixed by commit aa1057b3dec4 ("ocfs2: direct
write will call ocfs2_rw_unlock() twice when doing aio+dio").


On 2015/9/11 1:15, Alan Hodgson wrote:
> I have a couple of 2-node clusters running a bunch of KVM guests, they run 
> DRBD active/active with OCFS2 as a cluster filesystem.
> 
> All the hosts run Gentoo Hardened.
> 
> I recently updated one of the hosts in the "test" cluster to kernel 4.1.6, 
> first to the Gentoo Hardened sources, and when that crashed, I've just tried 
> the equivalent gentoo-sources 4.1.6. 
> 
> The panic trace seems to point to OCFS2 - both kernels crash immediately as 
> soon as a single KVM guest starts to mount its root, with the following:
> 
> Sep 10 09:59:05 hades kernel: ------------[ cut here ]------------
> Sep 10 09:59:05 hades kernel: kernel BUG at fs/ocfs2/dlmglue.c:775!
> Sep 10 09:59:05 hades kernel: invalid opcode: 0000 [#1] SMP 
> Sep 10 09:59:05 hades kernel: Modules linked in: vhost_net vhost macvtap 
> macvlan tun drbd lru_cache ip6t_REJECT nf_reject_ipv6 ipt_REJECT 
> nf_reject_ipv4 nf_conntrack_ipv6 nf_defrag_ipv6 xt_conntrack xt_tcpudp bridge 
> ip6table_filter 8021q garp stp mrp llc ip6_tables iptable_filter 
> nf_conntrack_ftp nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack ip_tables 
> x_tables osst ch st ipv6 dm_zero dm_thin_pool dm_persistent_data dm_bio_prison 
> dm_round_robin dm_multipath scsi_dh virtio_pci virtio_balloon virtio_ring 
> virtio xts gf128mul aes_x86_64 cbc sha512_generic sha256_generic sha1_generic 
> scsi_transport_iscsi nfs lockd grace sunrpc multipath linear raid10 raid1 
> raid0 dm_raid raid456 async_raid6_recov async_memcpy async_pq async_xor xor 
> async_tx raid6_pq dm_snapshot dm_bufio dm_crypt dm_mirror dm_region_hash dm_log 
> dm_mod hid_sunplus
> Sep 10 09:59:05 hades kernel:  hid_sony led_class hid_samsung hid_pl 
> hid_petalynx hid_gyration sl811_hcd xhci_pci xhci_hcd ohci_pci ohci_hcd 
> usb_storage megaraid_sas megaraid_mbox megaraid_mm mptsas mptfc 
> scsi_transport_fc mptspi scsi_transport_spi mptscsih mptbase sg pdc_adma 
> sata_inic162x sata_mv ahci libahci sata_qstor sata_vsc sata_uli sata_sis 
> sata_sx4 sata_nv sata_via sata_svw sata_sil24 sata_sil sata_promise 
> pata_sl82c105 pata_via pata_marvell pata_sis pata_netcell pata_pdc202xx_old 
> pata_triflex pata_atiixp pata_opti pata_amd pata_ali pata_it8213 pata_ns87415 
> pata_ns87410 pata_serverworks pata_artop pata_it821x pata_optidma pata_hpt3x2n 
> pata_hpt3x3 pata_hpt37x pata_hpt366 pata_cmd64x pata_efar pata_rz1000 
> pata_sil680 pata_radisys pata_pdc2027x pata_mpiix joydev usbhid uhci_hcd 
> coretemp kvm_intel kvm crc32c_intel
> Sep 10 09:59:05 hades kernel:  microcode pcspkr pata_acpi ehci_pci ehci_hcd 
> ixgbe ata_piix pata_jmicron arcmsr mdio i2c_i801 libata igb usbcore mpt2sas 
> ptp usb_common raid_class pps_core i2c_algo_bit scsi_transport_sas ioatdma 
> i2c_core dca button acpi_cpufreq processor thermal_sys
> Sep 10 09:59:05 hades kernel: CPU: 0 PID: 5363 Comm: drbd_a_drbd0 Tainted: G          
> I     4.1.6-gentoo #1
> Sep 10 09:59:05 hades kernel: Hardware name: Supermicro X8DAH/X8DAH, BIOS 2.0     
> 06/01/2010
> Sep 10 09:59:05 hades kernel: task: ffff88180cfe8050 ti: ffff88180bb58000 task.ti: 
> ffff88180bb58000
> Sep 10 09:59:05 hades kernel: RIP: 0010:[<ffffffff81227ab7>]  [<ffffffff81227ab7>] 
> __ocfs2_cluster_unlock.isra.43+0x40/0x9e
> Sep 10 09:59:05 hades kernel: RSP: 0018:ffff88180bb5bb88  EFLAGS: 00010046
> Sep 10 09:59:05 hades kernel: RAX: 0000000000000000 RBX: ffff88180ef3a108 RCX: 
> 00000000000000a4
> Sep 10 09:59:05 hades kernel: RDX: 000000000000a4a4 RSI: ffff88180ef3a108 RDI: 
> ffff88180ef3a174
> Sep 10 09:59:05 hades kernel: RBP: ffff88180bb5bbb8 R08: ffffffff81211f6f R09: 
> 0000000000000001
> Sep 10 09:59:05 hades kernel: R10: 0000000000000000 R11: 000000000000d2e0 R12: 
> ffff88180ef3a174
> Sep 10 09:59:05 hades kernel: R13: 0000000000000005 R14: ffff88180c6d5000 R15: 
> 0000000000000246
> Sep 10 09:59:05 hades kernel: FS:  0000000000000000(0000) 
> GS:ffff880c3fc00000(0000) knlGS:0000000000000000
> Sep 10 09:59:05 hades kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 
> 000000008005003b
> Sep 10 09:59:05 hades kernel: CR2: 0000000000509b2f CR3: 000000000161f000 CR4: 
> 00000000000026f0
> Sep 10 09:59:05 hades kernel: Stack:
> Sep 10 09:59:05 hades kernel:  0000000000000000 0000000000000005 
> ffff88180ef3a508 ffff88180c6d5000
> Sep 10 09:59:05 hades kernel:  0000000af8310400 0000000000000001 
> ffff88180bb5bbf8 ffffffff81229141
> Sep 10 09:59:05 hades kernel:  000000000000000a ffff880c0ea43f40 ffff880c0eedeb40 
> ffff880c035cf040
> Sep 10 09:59:05 hades kernel: Call Trace:
> Sep 10 09:59:05 hades kernel:  [<ffffffff81229141>] ocfs2_rw_unlock+0xbc/0xc7
> Sep 10 09:59:05 hades kernel:  [<ffffffff81211fc8>] ocfs2_dio_end_io+0x59/0x5e
> Sep 10 09:59:05 hades kernel:  [<ffffffff81113bc4>] dio_complete+0x92/0x150
> Sep 10 09:59:05 hades kernel:  [<ffffffff81113d43>] dio_bio_end_aio+0xc1/0xca
> Sep 10 09:59:05 hades kernel:  [<ffffffff812c0bc5>] bio_endio+0x61/0x68
> Sep 10 09:59:05 hades kernel:  [<ffffffffa1538ef4>] complete_master_bio+0x1f/0x145 
> [drbd]
> Sep 10 09:59:05 hades kernel:  [<ffffffffa1533368>] 
> validate_req_change_req_state+0xca/0xdb [drbd]
> Sep 10 09:59:05 hades kernel:  [<ffffffffa1533623>] got_BlockAck+0x113/0x130 
> [drbd]
> Sep 10 09:59:05 hades kernel:  [<ffffffffa1537ff9>] drbd_asender+0x58b/0x6c3 [drbd]
> Sep 10 09:59:05 hades kernel:  [<ffffffffa153ed22>] ? 
> drbd_destroy_connection+0xaf/0xaf [drbd]
> Sep 10 09:59:05 hades kernel:  [<ffffffffa153ed68>] drbd_thread_setup+0x46/0x114 
> [drbd]
> Sep 10 09:59:05 hades kernel:  [<ffffffffa153ed22>] ? 
> drbd_destroy_connection+0xaf/0xaf [drbd]
> Sep 10 09:59:05 hades kernel:  [<ffffffff81050497>] kthread+0xcd/0xd5
> Sep 10 09:59:05 hades kernel:  [<ffffffff810503ca>] ? 
> kthread_create_on_node+0x16c/0x16c
> Sep 10 09:59:05 hades kernel:  [<ffffffff81490b92>] ret_from_fork+0x42/0x70
> Sep 10 09:59:05 hades kernel:  [<ffffffff810503ca>] ? 
> kthread_create_on_node+0x16c/0x16c
> Sep 10 09:59:05 hades kernel: Code: 6c 53 4c 89 e7 48 89 f3 51 e8 9e 89 26 00 
> 48 85 db 75 02 0f 0b 41 83 fd 03 49 89 c7 74 16 41 83 fd 05 75 20 8b 43 5c 85 
> c0 75 02 <0f> 0b ff c8 89 43 5c eb 12 8b 53 58 85 d2 75 02 0f 0b ff ca 89 
> Sep 10 09:59:05 hades kernel: RIP  [<ffffffff81227ab7>] 
> __ocfs2_cluster_unlock.isra.43+0x40/0x9e
> Sep 10 09:59:05 hades kernel:  RSP <ffff88180bb5bb88>
> Sep 10 09:59:05 hades kernel: ---[ end trace 42d7ee8da6efb352 ]---
> 
> These hosts have all run 3.18.9 for the last 5 months with no issues, and 
> previous 3.x kernels also with no problems since installation about a year 
> ago.
> 
> If anyone has a clue what I'm doing wrong, I'd love to hear from you ... 
> thanks for any help.
> 
> _______________________________________________
> Ocfs2-users mailing list
> Ocfs2-users at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-users
> 
> .
> 
