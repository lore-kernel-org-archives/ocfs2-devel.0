From: Larry Chen <lchen@suse.com>
Date: Wed, 11 Apr 2018 18:43:17 +0800
Subject: [Ocfs2-devel] OCFS2 BUG with 2 different kernels
In-Reply-To: <HE1PR0401MB2538AC4F7C387503A082235FEDBD0@HE1PR0401MB2538.eurprd04.prod.outlook.com>
References: <HE1PR0401MB25389DFE7BFEC86453C3CB21EDBE0@HE1PR0401MB2538.eurprd04.prod.outlook.com>
	<HE1PR0401MB2538AC4F7C387503A082235FEDBD0@HE1PR0401MB2538.eurprd04.prod.outlook.com>
Message-ID: <cded7750-a411-3bd8-9728-c86e41d37295@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Daniel,
If you execute mkfs and mount that fs on only one node,
and then share the mount to several namespaces, will the
issue recur?

And could you please show us how you shared the mount to
other namespaces?

Thanks
Larry

On 04/11/2018 05:45 PM, Daniel Sobe wrote:
>
> Hi,
>
> having used OCFS2 successfully for a while using Debian 8 with its 
> default kernel ?3.16.0-5-amd64 #1 SMP Debian 3.16.51-3+deb8u1 
> (2018-01-08)?, I?m now facing issues trying to accomplish the same 
> with newer kernels and Debian 9. Below are the problems that occur, 
> they seem to be the same although the kernel is different.
>
> One trace is from the stock kernel of Debian 9 (at that time), the 
> other is from a very fresh kernel (4.16-rc6). In the latter case, the 
> OOM killer was triggered ?shortly? before the bug appeared ? it maybe 
> related. The call trace is appended below.
>
> In both cases, only one machine was active. The cluster is configured 
> for 2 machines, but the cluster is not even configured yet at the 2^nd 
> system. Only one OCFS2 file system was mounted, and the mount shared 
> to several namespaces (using LXC). Although the mount was R/W, the 
> users/containers just read from this file system.
>
> Please let me know what I can do to get rid of this issue. I can 
> provide more information about my use case if required.
>
> I already posted to ocfs2-users, only then I saw that it is now 
> recommended to post bugs on ocfs2-devel.
>
> Regards,
>
> Daniel
>
> Mar 22 19:26:55 drs1s005 kernel: [ 7545.707568] ------------[ cut here 
> ]------------
>
> Mar 22 19:26:55 drs1s005 kernel: [ 7545.707600] kernel BUG at 
> /build/linux-YDazDa/linux-4.9.82/fs/ocfs2/dlmglue.c:825!
>
> Mar 22 19:26:55 drs1s005 kernel: [ 7545.707635] invalid opcode: 0000 
> [#1] SMP
>
> Mar 22 19:26:55 drs1s005 kernel: [ 7545.707654] Modules linked in: 
> appletalk ax25 ipx p8023 p8022 psnap veth ocfs2_dlmfs ocfs2_stack_o2cb 
> ocfs2_dlm ocfs2 ocfs2_nodemanager configfs ocfs2_stackglue quota_tree 
> nls_ut
>
> f8 cifs sha256_ssse3 cmac md4 des_generic arc4 dns_resolver fscache 
> iptable_filter bridge stp llc bonding fuse intel_rapl sb_edac 
> edac_core x86_pkg_temp_thermal intel_powerclamp coretemp iTCO_wdt 
> iTCO_vendor_suppor
>
> t kvm_intel kvm irqbypass crct10dif_pclmul crc32_pclmul 
> ghash_clmulni_intel nls_ascii nls_cp437 vfat fat intel_cstate 
> intel_uncore intel_rapl_perf efi_pstore efivars pcspkr mgag200 ttm sg 
> drm_kms_helper lpc_ich mfd
>
> _core drm i2c_algo_bit hpwdt hpilo ioatdma evdev dca shpchp wmi 
> ipmi_si acpi_power_meter ipmi_msghandler pcc_cpufreq button drbd 
> lru_cache libcrc32c efivarfs ip_tables x_tables autofs4 uas usb_storage
>
> Mar 22 19:26:55 drs1s005 kernel: [ 7545.708060]? ext4 crc16 jbd2 
> crc32c_generic fscrypto ecb mbcache dm_mod sd_mod crc32c_intel 
> aesni_intel aes_x86_64 glue_helper lrw gf128mul ablk_helper cryptd 
> xhci_pci uhci_hcd e
>
> hci_pci xhci_hcd ehci_hcd i2c_i801 i2c_smbus i40e tg3 hpsa usbcore ptp 
> scsi_transport_sas usb_common pps_core libphy scsi_mod [last unloaded: 
> configfs]
>
> Mar 22 19:26:55 drs1s005 kernel: [ 7545.708231] CPU: 24 PID: 64700 
> Comm: perl Not tainted 4.9.0-6-amd64 #1 Debian 4.9.82-1+deb9u3
>
> Mar 22 19:26:55 drs1s005 kernel: [ 7545.708268] Hardware name: HP 
> ProLiant DL380 Gen9/ProLiant DL380 Gen9, BIOS P89 01/22/2018
>
> Mar 22 19:26:55 drs1s005 kernel: [ 7545.708304] task: ffff990fda6ef100 
> task.stack: ffffb62f36464000
>
> Mar 22 19:26:55 drs1s005 kernel: [ 7545.708331] RIP: 
> 0010:[<ffffffffc0b1180d>]? [<ffffffffc0b1180d>] 
> __ocfs2_cluster_unlock.isra.36+0x9d/0xb0 [ocfs2]
>
> Mar 22 19:26:55 drs1s005 kernel: [ 7545.708422] RSP: 
> 0018:ffffb62f36467b38? EFLAGS: 00010046
>
> Mar 22 19:26:55 drs1s005 kernel: [ 7545.708447] RAX: 0000000000000292 
> RBX: ffff990fda6c5618 RCX: 0000000000000001
>
> Mar 22 19:26:55 drs1s005 kernel: [ 7545.708479] RDX: 0000000000000000 
> RSI: 0000000000000001 RDI: ffff990fda6c5694
>
> Mar 22 19:26:55 drs1s005 kernel: [ 7545.708510] RBP: 0000000000000003 
> R08: 0000000000000101 R09: 0000000000000000
>
> Mar 22 19:26:55 drs1s005 kernel: [ 7545.708541] R10: 0000000000000038 
> R11: 000000000000007c R12: ffff990fda6c5694
>
> Mar 22 19:26:55 drs1s005 kernel: [ 7545.708572] R13: ffff991bb0f76000 
> R14: 0000000000000000 R15: ffffffffc0ba5080
>
> Mar 22 19:26:55 drs1s005 kernel: [ 7545.708604] FS: 
> 0000000000000000(0000) GS:ffff991bbea80000(0063) knlGS:00000000f7462700
>
> Mar 22 19:26:55 drs1s005 kernel: [ 7545.708640] CS:? 0010 DS: 002b ES: 
> 002b CR0: 0000000080050033
>
> Mar 22 19:26:55 drs1s005 kernel: [ 7545.708666] CR2: ffffffffff600000 
> CR3: 000000341a7b6000 CR4: 0000000000360670
>
> Mar 22 19:26:55 drs1s005 kernel: [ 7545.708697] DR0: 0000000000000000 
> DR1: 0000000000000000 DR2: 0000000000000000
>
> Mar 22 19:26:55 drs1s005 kernel: [ 7545.708728] DR3: 0000000000000000 
> DR6: 00000000fffe0ff0 DR7: 0000000000000400
>
> Mar 22 19:26:55 drs1s005 kernel: [ 7545.708759] Stack:
>
> Mar 22 19:26:55 drs1s005 kernel: [ 7545.708771]? ffffffffc0b12b45 
> 0000000000000000 ffff99101a537300 ffff99101a51c4c8
>
> Mar 22 19:26:55 drs1s005 kernel: [ 7545.708812]? ffff990fda6c5e00 
> ffffffffc0b02274 ffff99101a537180 ffff99101a4e04c8
>
> Mar 22 19:26:55 drs1s005 kernel: [ 7545.708849]? 0000000000000000 
> ffff99101a537300 dad51186f40d61bf ffff99101a4e04c8
>
> Mar 22 19:26:55 drs1s005 kernel: [ 7545.708886] Call Trace:
>
> Mar 22 19:26:55 drs1s005 kernel: [ 7545.708919] [<ffffffffc0b12b45>] ? 
> ocfs2_dentry_unlock+0x35/0x80 [ocfs2]
>
> Mar 22 19:26:55 drs1s005 kernel: [ 7545.708964] [<ffffffffc0b02274>] ? 
> ocfs2_dentry_attach_lock+0x2d4/0x430 [ocfs2]
>
> Mar 22 19:26:55 drs1s005 kernel: [ 7545.709014] [<ffffffffc0b2b6f1>] ? 
> ocfs2_lookup+0x1a1/0x2e0 [ocfs2]
>
> Mar 22 19:26:55 drs1s005 kernel: [ 7545.709046] [<ffffffff8861eb56>] ? 
> d_invalidate+0xb6/0x120
>
> Mar 22 19:26:55 drs1s005 kernel: [ 7545.710690] [<ffffffff88611a79>] ? 
> lookup_slow+0xa9/0x170
>
> Mar 22 19:26:55 drs1s005 kernel: [ 7545.713068] [<ffffffff88612199>] ? 
> walk_component+0x1f9/0x330
>
> Mar 22 19:26:55 drs1s005 kernel: [ 7545.717146] [<ffffffff88612d62>] ? 
> link_path_walk+0x1b2/0x670
>
> Mar 22 19:26:55 drs1s005 kernel: [ 7545.718276] [<ffffffff88613326>] ? 
> path_lookupat+0x86/0x120
>
> Mar 22 19:26:55 drs1s005 kernel: [ 7545.720158] [<ffffffff88615d81>] ? 
> filename_lookup+0xb1/0x180
>
> Mar 22 19:26:55 drs1s005 kernel: [ 7545.721266] [<ffffffff886018da>] ? 
> __check_object_size+0xfa/0x1d8
>
> Mar 22 19:26:55 drs1s005 kernel: [ 7545.722799] [<ffffffff8875c678>] ? 
> strncpy_from_user+0x48/0x160
>
> Mar 22 19:26:55 drs1s005 kernel: [ 7545.725064] [<ffffffff886159ba>] ? 
> getname_flags+0x6a/0x1e0
>
> Mar 22 19:26:55 drs1s005 kernel: [ 7545.729544] [<ffffffff8860a899>] ? 
> vfs_fstatat+0x59/0xb0
>
> Mar 22 19:26:55 drs1s005 kernel: [ 7545.732126] [<ffffffff8846ccc5>] ? 
> sys32_stat64+0x25/0x60
>
> Mar 22 19:26:55 drs1s005 kernel: [ 7545.733194] [<ffffffff884033e7>] ? 
> syscall_trace_enter+0x117/0x2c0
>
> Mar 22 19:26:55 drs1s005 kernel: [ 7545.734247] [<ffffffff88403d5c>] ? 
> do_fast_syscall_32+0xac/0x180
>
> Mar 22 19:26:55 drs1s005 kernel: [ 7545.737170] [<ffffffff88a12cdf>] ? 
> entry_SYSENTER_compat+0x6f/0x7e
>
> Mar 22 19:26:55 drs1s005 kernel: [ 7545.739819] Code: 89 c6 5b 5d 41 
> 5c 41 5d e9 61 f7 ef c7 0f 0b 8b 53 68 85 d2 74 15 83 ea 01 89 53 68 
> eb af 8b 53 6c 85 d2 74 c3 eb d1 0f 0b 0f 0b <0f> 0b 0f 0b 0f 1f 44 00 
> 00 66
>
> 2e 0f 1f 84 00 00 00 00 00 0f 1f
>
> Mar 22 19:26:55 drs1s005 kernel: [ 7545.742738] RIP 
> [<ffffffffc0b1180d>] __ocfs2_cluster_unlock.isra.36+0x9d/0xb0 [ocfs2]
>
> Mar 22 19:26:55 drs1s005 kernel: [ 7545.745017]? RSP <ffffb62f36467b38>
>
> Mar 22 19:26:55 drs1s005 kernel: [ 7545.753445] ---[ end trace 
> 9a87ef237c626c21 ]---
>
> Apr 10 13:01:13 drs1s006 kernel: [338194.523354] ------------[ cut 
> here ]------------
> Apr 10 13:01:13 drs1s006 kernel: [338194.523358] kernel BUG at 
> /build/linux-sEiGsi/linux-4.16~rc6/fs/ocfs2/dlmglue.c:848!
> Apr 10 13:01:13 drs1s006 kernel: [338194.533415] invalid opcode: 0000 
> [#1] SMP NOPTI
> Apr 10 13:01:13 drs1s006 kernel: [338194.538568] Modules linked in: 
> nfnetlink_log nfnetlink cmac arc4 md4 nls_utf8 cifs ccm dns_resolver 
> fscache appletalk ax25 ipx(C) p8023 p8022 psnap veth ocfs2 quota_tree 
> btrfs zstd_decompress zstd_compress xxhash xor raid6_pq ufs qnx4 
> hfsplus hfs minix ntfs msdos jfs xfs ocfs2_dlmfs ocfs2_stack_o2cb 
> ocfs2_dlm ocfs2_nodemanager ocfs2_stackglue configfs iptable_filter 
> bridge stp llc joydev hid_generic usbhid hid fuse nls_ascii nls_cp437 
> vfat fat uas usb_storage kvm mgag200 ttm drm_kms_helper irqbypass drm 
> efi_pstore crct10dif_pclmul crc32_pclmul pcspkr efivars evdev sg 
> ghash_clmulni_intel ccp(+) hpilo i2c_algo_bit k10temp hpwdt rng_core 
> sp5100_tco shpchp ipmi_si wmi ipmi_devintf ipmi_msghandler 
> acpi_cpufreq button drbd lru_cache libcrc32c efivarfs ip_tables 
> x_tables autofs4 ext4 crc16 mbcache jbd2
> Apr 10 13:01:13 drs1s006 kernel: [338194.613006]? crc32c_generic 
> fscrypto ecb dm_mod ses sd_mod enclosure crc32c_intel aesni_intel 
> aes_x86_64 crypto_simd cryptd glue_helper xhci_pci ehci_pci smartpqi 
> xhci_hcd ehci_hcd scsi_transport_sas scsi_mod tg3 usbcore i2c_piix4 
> usb_common i40e libphy
> Apr 10 13:01:13 drs1s006 kernel: [338194.637598] CPU: 24 PID: 53861 
> Comm: java Tainted: G???????? C?????? 4.16.0-rc6-amd64 #1 Debian 
> 4.16~rc6-1~exp1
> Apr 10 13:01:13 drs1s006 kernel: [338194.648582] Hardware name: HPE 
> ProLiant DL385 Gen10/ProLiant DL385 Gen10, BIOS A40 12/12/2017
> Apr 10 13:01:13 drs1s006 kernel: [338194.659815] RIP: 
> 0010:__ocfs2_cluster_unlock.isra.36+0x9c/0xb0 [ocfs2]
> Apr 10 13:01:13 drs1s006 kernel: [338194.667246] RSP: 
> 0018:ffffb25924153ac8 EFLAGS: 00010046
> Apr 10 13:01:13 drs1s006 kernel: [338194.673320] RAX: 0000000000000292 
> RBX: ffff9b1220245e18 RCX: 0000000000000001
> Apr 10 13:01:13 drs1s006 kernel: [338194.682963] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff9b1220245e94
> Apr 10 13:01:13 drs1s006 kernel: [338194.692527] RBP: ffff9b1220245e94 R08: 0000000000000101 R09: 0000000000000000
> Apr 10 13:01:13 drs1s006 kernel: [338194.700939] R10: ffffb25924153ab0 R11: 0000000000000073 R12: 0000000000000003
> Apr 10 13:01:13 drs1s006 kernel: [338194.709376] R13: ffff9b181850b000 
> R14: 0000000000000000 R15: ffffffffc1157900
> Apr 10 13:01:13 drs1s006 kernel: [338194.717571] FS:? 
> 00007f3f3f3f6700(0000) GS:ffff9af81fa00000(0000) knlGS:0000000000000000
> Apr 10 13:01:13 drs1s006 kernel: [338194.726842] CS:? 0010 DS: 0000 
> ES: 0000 CR0: 0000000080050033
> Apr 10 13:01:13 drs1s006 kernel: [338194.735192] CR2: 00007f3f9aa9e330 
> CR3: 00000003483c0000 CR4: 00000000003406e0
> Apr 10 13:01:13 drs1s006 kernel: [338194.747998] Call Trace:
> Apr 10 13:01:13 drs1s006 kernel: [338194.754363]? ? 
> ocfs2_dentry_unlock+0x35/0x80 [ocfs2]
> Apr 10 13:01:13 drs1s006 kernel: [338194.763538]? 
> ocfs2_dentry_attach_lock+0x245/0x420 [ocfs2]
> Apr 10 13:01:13 drs1s006 kernel: [338194.771745]? 
> ocfs2_lookup+0x233/0x2c0 [ocfs2]
> Apr 10 13:01:13 drs1s006 kernel: [338194.778048]? lookup_slow+0xa9/0x170
> Apr 10 13:01:13 drs1s006 kernel: [338194.782898]? 
> walk_component+0x1c4/0x470
> Apr 10 13:01:13 drs1s006 kernel: [338194.788000]? ? 
> inode_permission+0xbe/0x180
> Apr 10 13:01:13 drs1s006 kernel: [338194.793238]? 
> link_path_walk+0x2a6/0x510
> Apr 10 13:01:13 drs1s006 kernel: [338194.799117]? ? path_init+0x177/0x2f0
> Apr 10 13:01:13 drs1s006 kernel: [338194.804087]? path_lookupat+0x56/0x1f0
> Apr 10 13:01:13 drs1s006 kernel: [338194.808830]? ? 
> page_cache_tree_insert+0xe0/0xe0
> Apr 10 13:01:13 drs1s006 kernel: [338194.814529]? 
> filename_lookup+0xb6/0x190
> Apr 10 13:01:13 drs1s006 kernel: [338194.819516]? ? 
> filemap_map_pages+0x228/0x340
> Apr 10 13:01:13 drs1s006 kernel: [338194.824993]? ? 
> seccomp_run_filters+0x59/0xc0
> Apr 10 13:01:13 drs1s006 kernel: [338194.830396]? ? 
> __check_object_size+0xa7/0x1a0
> Apr 10 13:01:13 drs1s006 kernel: [338194.836156]? ? 
> strncpy_from_user+0x48/0x160
> Apr 10 13:01:13 drs1s006 kernel: [338194.841458]? ? getname_flags+0x6a/0x1e0
> Apr 10 13:01:13 drs1s006 kernel: [338194.846457]? ? vfs_statx+0x73/0xe0
> Apr 10 13:01:13 drs1s006 kernel: [338194.851105]? vfs_statx+0x73/0xe0
> Apr 10 13:01:13 drs1s006 kernel: [338194.855426]? SYSC_newstat+0x39/0x70
> Apr 10 13:01:13 drs1s006 kernel: [338194.860227]? ? 
> syscall_trace_enter+0x145/0x2e0
> Apr 10 13:01:13 drs1s006 kernel: [338194.865909]? do_syscall_64+0x6c/0x130
> Apr 10 13:01:13 drs1s006 kernel: [338194.870977]? 
> entry_SYSCALL_64_after_hwframe+0x3d/0xa2
> Apr 10 13:01:13 drs1s006 kernel: [338194.877075] RIP: 0033:0x7f3f9b54a4c5
> Apr 10 13:01:13 drs1s006 kernel: [338194.882556] RSP: 
> 002b:00007f3f3f3f50c8 EFLAGS: 00000246 ORIG_RAX: 0000000000000004
> Apr 10 13:01:13 drs1s006 kernel: [338194.892712] RAX: ffffffffffffffda 
> RBX: 00007f3f945fb9e0 RCX: 00007f3f9b54a4c5
> Apr 10 13:01:13 drs1s006 kernel: [338194.901419] RDX: 00007f3f3f3f50d0 
> RSI: 00007f3f3f3f50d0 RDI: 00007f3f300491e0
> Apr 10 13:01:13 drs1s006 kernel: [338194.909732] RBP: 00007f3f3f3f5190 
> R08: 00007f3f300491e0 R09: 0000000000000028
> Apr 10 13:01:13 drs1s006 kernel: [338194.918291] R10: 00007f3f85052380 
> R11: 0000000000000246 R12: 0000000000000000
> Apr 10 13:01:13 drs1s006 kernel: [338194.926582] R13: 00007f3f300491e0 
> R14: 00007f3f30000a30 R15: 00007f3f945fb800
> Apr 10 13:01:13 drs1s006 kernel: [338194.935371] Code: 48 89 ef 48 89 c6 5b 5d 41 5c 41 5d e9 be 9c e1 d4 8b 53 68 85 d2 74 13 83 ea 01 89 53 68 eb b1 8b 53 6c 85 d2 74 c5 eb d3 0f 0b <0f> 0b 0f 0b 0f 0b 0f 0b 66 90 66 2e 0f 1f 84 00 00 00 00 00 0f
> Apr 10 13:01:13 drs1s006 kernel: [338194.957500] RIP: 
> __ocfs2_cluster_unlock.isra.36+0x9c/0xb0 [ocfs2] RSP: ffffb25924153ac8
> Apr 10 13:01:13 drs1s006 kernel: [338194.967146] ---[ end trace 
> 3743be945c8eeed8 ]---
>
> Apr 10 12:59:47 drs1s006 kernel: [338109.416347] Call Trace:
> Apr 10 12:59:47 drs1s006 kernel: [338109.416358]? dump_stack+0x5c/0x85
> Apr 10 12:59:47 drs1s006 kernel: [338109.416363]? dump_header+0x6b/0x289
> Apr 10 12:59:47 drs1s006 kernel: [338109.416367]? ? 
> apparmor_capable+0xa4/0xe0
> Apr 10 12:59:47 drs1s006 kernel: [338109.416369]? 
> oom_kill_process+0x228/0x470
> Apr 10 12:59:47 drs1s006 kernel: [338109.416372]? 
> out_of_memory+0x2ab/0x4b0
> Apr 10 12:59:47 drs1s006 kernel: [338109.416374]? 
> __alloc_pages_slowpath+0x9f5/0xd80
> Apr 10 12:59:47 drs1s006 kernel: [338109.416376]? 
> __alloc_pages_nodemask+0x236/0x250
> Apr 10 12:59:47 drs1s006 kernel: [338109.416378]? 
> filemap_fault+0x206/0x650
> Apr 10 12:59:47 drs1s006 kernel: [338109.416382]? ? 
> recalc_sigpending+0x17/0x50
> Apr 10 12:59:47 drs1s006 kernel: [338109.416384]? ? 
> __set_task_blocked+0x38/0x90
> Apr 10 12:59:47 drs1s006 kernel: [338109.416385]? ? 
> __set_current_blocked+0x3d/0x60
> Apr 10 12:59:47 drs1s006 kernel: [338109.416426]? 
> ocfs2_fault+0x39/0xe0 [ocfs2]
> Apr 10 12:59:47 drs1s006 kernel: [338109.416431]? __do_fault+0x1f/0xb0
> Apr 10 12:59:47 drs1s006 kernel: [338109.416433]? 
> __handle_mm_fault+0xca6/0x1220
> Apr 10 12:59:47 drs1s006 kernel: [338109.416436]? 
> handle_mm_fault+0xdc/0x210
> Apr 10 12:59:47 drs1s006 kernel: [338109.416438]? 
> __do_page_fault+0x256/0x4e0
> Apr 10 12:59:47 drs1s006 kernel: [338109.416442]? ? page_fault+0x2f/0x50
> Apr 10 12:59:47 drs1s006 kernel: [338109.416444]? page_fault+0x45/0x50
> Apr 10 12:59:47 drs1s006 kernel: [338109.416446] RIP: 
> 2dc42c40:0x7fc528cc4401
> Apr 10 12:59:47 drs1s006 kernel: [338109.416447] RSP: 28009490:00007fc4eb3f28e0 EFLAGS: 7fc528cc4400
> Apr 10 12:59:47 drs1s006 kernel: [338109.416449] Mem-Info:
> Apr 10 12:59:47 drs1s006 kernel: [338109.416475] active_anon:7327303 
> inactive_anon:201509 isolated_anon:0
> Apr 10 12:59:47 drs1s006 kernel: [338109.416475]? active_file:24608843 
> inactive_file:24653281 isolated_file:0
> Apr 10 12:59:47 drs1s006 kernel: [338109.416475]? unevictable:0 
> dirty:5 writeback:0 unstable:0
> Apr 10 12:59:47 drs1s006 kernel: [338109.416475]? 
> slab_reclaimable:3415816 slab_unreclaimable:1736671
> Apr 10 12:59:47 drs1s006 kernel: [338109.416475]? mapped:210421 
> shmem:211438 pagetables:30887 bounce:0
> Apr 10 12:59:47 drs1s006 kernel: [338109.416475]? free:3783897 
> free_pcp:100 free_cma:0
>
> Daniel Sobe
>
> Engineer
>
> BL Car Infotainment & Driver Assistance
>
> NXP Semiconductors Germany GmbH
>
> Am Waldschl?sschen 1, 01099 Dresden, Germany
>
> Tel: +49? 351 32023 504, Fax: +49 351 32023 760
>
> eMail: daniel.sobe at nxp.com <mailto:daniel.sobe@nxp.com>, 
> https://urldefense.proofpoint.com/v2/url?u=http-3A__www.nxp.com&d=DwID-g&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=C7gAd4uDxlAvTdc0vmU6X8CMk6L2iDY8-HD0qT6Fo7Y&m=L68db-3hNCWXl26oxvvE7vhivv2Gs_N-P4cBV7Xi_8w&s=iVywZhnhHiOja7uILOA5ESjMt6zUOtc28DU7ntRN3zU&e= 
> <https://urldefense.proofpoint.com/v2/url?u=http-3A__www.nxp.com_&d=DwMFAw&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=C7gAd4uDxlAvTdc0vmU6X8CMk6L2iDY8-HD0qT6Fo7Y&m=Q30Z8J9hmQC7gxk63OxdHtyQv73UXHlOrqxod0srOwA&s=5KhvIKFT5ft-iBtSDc9Jxs0VltXYXylYJ2cnnj_9dQ0&e=>
>
> Gesch?ftsf?hrung: Ruediger Stroh (Vors.), Kurt Sievers, Torsten 
> Spinty, Michael Hoffmann / Aufsichtsratsvorsitzender: Gernot Fiedler / 
> Sitz: Hamburg / Registergericht: Hamburg HRB 84 865
>
>
> You can also find us on:
>
> cid:image002.png at 01CCCA30.7EED3EA0 
> <https://urldefense.proofpoint.com/v2/url?u=http-3A__twitter.com_-23-21_NXP&d=DwMFAw&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=C7gAd4uDxlAvTdc0vmU6X8CMk6L2iDY8-HD0qT6Fo7Y&m=Q30Z8J9hmQC7gxk63OxdHtyQv73UXHlOrqxod0srOwA&s=z9hK7j4HK_34HpeTQ6FKHD9rueEIq8cpwl7nZM-eoqs&e=>cid:image003.png at 01CCCA30.7EED3EA0 
> <https://urldefense.proofpoint.com/v2/url?u=http-3A__www.youtube.com_user_NXPSemiconductors&d=DwMFAw&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=C7gAd4uDxlAvTdc0vmU6X8CMk6L2iDY8-HD0qT6Fo7Y&m=Q30Z8J9hmQC7gxk63OxdHtyQv73UXHlOrqxod0srOwA&s=yitF8gfDg32ikjnN5K3vk_l0iX1VVAwAzVDU_waa-gs&e=>cid:image004.png at 01CCCA30.7EED3EA0 
> <https://urldefense.proofpoint.com/v2/url?u=http-3A__www.facebook.com_pages_NXP-2DSemiconductors_172907906413&d=DwMFAw&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=C7gAd4uDxlAvTdc0vmU6X8CMk6L2iDY8-HD0qT6Fo7Y&m=Q30Z8J9hmQC7gxk63OxdHtyQv73UXHlOrqxod0srOwA&s=rPV59SQpmf1sGbMk7XriP7GIzn4JUL8rKFREqZ2kpnA&e=>cid:image005.png at 01CCCA30.7EED3EA0 
> <https://urldefense.proofpoint.com/v2/url?u=https-3A__plus.google.com_112031734932782342682_posts&d=DwMFAw&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=C7gAd4uDxlAvTdc0vmU6X8CMk6L2iDY8-HD0qT6Fo7Y&m=Q30Z8J9hmQC7gxk63OxdHtyQv73UXHlOrqxod0srOwA&s=VPJTIilh4hEEcbNg9Z0u_i3M0hJ3u3kooxo1KwTjZKg&e=>cid:image006.png at 01CCCA30.7EED3EA0 
> <https://urldefense.proofpoint.com/v2/url?u=http-3A__www.linkedin.com_groups-3Fgid-3D671067&d=DwMFAw&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=C7gAd4uDxlAvTdc0vmU6X8CMk6L2iDY8-HD0qT6Fo7Y&m=Q30Z8J9hmQC7gxk63OxdHtyQv73UXHlOrqxod0srOwA&s=HnIffnO-GfeNo--T9bDr3XesM_lNcydll8hfcJgW5Vo&e=>cid:image007.png at 01CCCA30.7EED3EA0 
> <https://urldefense.proofpoint.com/v2/url?u=http-3A__weibo.com_nxpsemiconductors&d=DwMFAw&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=C7gAd4uDxlAvTdc0vmU6X8CMk6L2iDY8-HD0qT6Fo7Y&m=Q30Z8J9hmQC7gxk63OxdHtyQv73UXHlOrqxod0srOwA&s=stPkqaGv8HSZKZwJAkN6Z5EJc8L_rLarWz3ouN0rDLY&e=>_
> _
> The information contained in this message is confidential and may be 
> legally privileged. The message is intended solely for the 
> addressee(s). If you are not the intended recipient, you are hereby 
> notified that any use, dissemination, or reproduction is strictly 
> prohibited and may be unlawful. If you are not the intended recipient, 
> please contact the sender by return e-mail and destroy all copies of 
> the original message.
>
> Unless otherwise recorded in a written agreement, all sales 
> transactions by NXP Semiconductors are subject to our general terms 
> and conditions of commercial sale. These are published at: 
> www.nxp.com/profile/terms/index.html 
> <https://urldefense.proofpoint.com/v2/url?u=http-3A__www.nxp.com_profile_terms_index.html&d=DwMFAw&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=C7gAd4uDxlAvTdc0vmU6X8CMk6L2iDY8-HD0qT6Fo7Y&m=Q30Z8J9hmQC7gxk63OxdHtyQv73UXHlOrqxod0srOwA&s=wUJAX3H8pEbFPrJdGwnCGdtB6q2Qir9GywAIsTDwFQw&e=>__
>
>
>
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
