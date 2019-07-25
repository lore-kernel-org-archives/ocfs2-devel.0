From: Gang He <GHe@suse.com>
Date: Thu, 25 Jul 2019 08:47:08 +0000
Subject: [Ocfs2-devel] [EXT] RE: OCFS2 triggered kernel BUG in 4.19.37
In-Reply-To: <AM6PR04MB560502E22BBDF1675B76BCABEDC10@AM6PR04MB5605.eurprd04.prod.outlook.com>
References: <AM6PR04MB560502E22BBDF1675B76BCABEDC10@AM6PR04MB5605.eurprd04.prod.outlook.com>
Message-ID: <BY5PR18MB3202BDF7CEAFFC528BDEFA02CFC10@BY5PR18MB3202.namprd18.prod.outlook.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Daniel,

Please see my comments inline.


From: Daniel Sobe [mailto:daniel.sobe at nxp.com]
Sent: 2019?7?25? 15:29
To: ocfs2-devel at oss.oracle.com; Gang He <GHe@suse.com>
Subject: RE: [EXT] RE: OCFS2 triggered kernel BUG in 4.19.37

Hi Gang,

I?m using o2cb.

It is the first time ever that I see this problem. I was using OCFS2 for years while on kernel 3.16 where this issue never appeared. I only switched to kernel 4.19 a couple of months ago.

During recovery I found a data inconsistency on one of the DRBD volumes that the OCFS2 is operating on. Not sure if it could be a cause for this problem, or a consequence of the crash. The volume in question was sync?ed recently, so I doubt it became inconsistent over such a short time though.

I do not think DRDB is suitable for ocfs2 case, although DRDB supports two-primary mode. I feel DRDB is suitable Primary-salve user case.

The commit you refer to explicitly excludes o2cb, which looks like it was done on purpose. I don?t know whether enabling the special handling for o2cb also will help.

At that moment, Huawei people (o2cb stack based main developers) told us that o2cb stack hasn?t such problem, then  we only made this code change was effective for pmck stack.
From your description, I feel DRDB data consistency in two primary mode is not enough for ocfs2, this maybe the root cause.

Thanks
Gang

Regards,

Daniel

From: Gang He <GHe at suse.com<mailto:GHe@suse.com>>
Sent: Donnerstag, 25. Juli 2019 04:14
To: Daniel Sobe <daniel.sobe at nxp.com<mailto:daniel.sobe@nxp.com>>; ocfs2-devel at oss.oracle.com<mailto:ocfs2-devel@oss.oracle.com>
Subject: [EXT] RE: OCFS2 triggered kernel BUG in 4.19.37


Caution: EXT Email
Hi Daniel,

Which ocfs2 stack did you use? o2cb or pmck.
In the past, we met the similar crash, then we submitted a patch to fix that bug only for pmck stack (not sure if o2cb stack has the similar problem).
Please see the commit,
commit e7ee2c089e94067d68475990bdeed211c8852917
Author: Eric Ren <zren at suse.com<mailto:zren@suse.com>>
Date:   Tue Jan 10 16:57:33 2017 -0800

    ocfs2: fix crash caused by stale lvb with fsdlm plugin

    The crash happens rather often when we reset some cluster nodes while
nodes contend fiercely to do truncate and append.


Thanks
Gang

From: ocfs2-devel-bounces@oss.oracle.com<mailto:ocfs2-devel-bounces@oss.oracle.com> [mailto:ocfs2-devel-bounces at oss.oracle.com] On Behalf Of Daniel Sobe
Sent: 2019?7?24? 20:42
To: ocfs2-devel at oss.oracle.com<mailto:ocfs2-devel@oss.oracle.com>
Subject: [Ocfs2-devel] OCFS2 triggered kernel BUG in 4.19.37

Hi,

yesterday I had a new kernel BUG appear, almost simultaneously on both machines in the cluster. I attach the logs below. I could not find any similar recent occurrences by a simple Google search. Maybe somebody on the list can help me.

Regards,

Daniel

Jul 23 17:41:40 drs1s002 kernel: [1590728.642834] (MATLAB,43198,19):ocfs2_truncate_file:472 ERROR: bug expression: le64_to_cpu(fe->i_size) != i_size_read(inode)
Jul 23 17:41:40 drs1s002 kernel: [1590728.656803] (MATLAB,43198,19):ocfs2_truncate_file:472 ERROR: Inode 2439693, inode i_size = 8103 != di i_size = 8102, i_flags = 0x1
Jul 23 17:41:40 drs1s002 kernel: [1590728.671366] ------------[ cut here ]------------
Jul 23 17:41:40 drs1s002 kernel: [1590728.671367] kernel BUG at /kernelbuild/linux-4.19.37/fs/ocfs2/file.c:472!
Jul 23 17:41:40 drs1s002 kernel: [1590728.679736] invalid opcode: 0000 [#1] SMP PTI
Jul 23 17:41:41 drs1s002 kernel: [1590728.685409] CPU: 19 PID: 43198 Comm: MATLAB Tainted: G            E     4.19.0-0.bpo.5-amd64 #1 Debian 4.19.37-3~bpo9+2
Jul 23 17:41:41 drs1s002 kernel: [1590728.698156] Hardware name: HP ProLiant DL380 Gen9/ProLiant DL380 Gen9, BIOS P89 03/25/2019
Jul 23 17:41:41 drs1s002 kernel: [1590728.708206] RIP: 0010:ocfs2_truncate_file+0x6ea/0x700 [ocfs2]
Jul 23 17:41:41 drs1s002 kernel: [1590728.715450] Code: 01 00 00 48 c7 c6 50 a8 dc c0 8b 41 2c 50 ff 71 20 48 c7 c1 38 3c dd c0 4d 8b 4c 24 50 4d 8b 84 24 40 fb ff ff e8 16 87 98 ff <0f> 0b e8 df 24 11 c1 0f 1f 44 00 00 66 2e 0f 1f 84 00 00 00 00 00
Jul 23 17:41:41 drs1s002 kernel: [1590728.738846] RSP: 0018:ffffb31f69dabac0 EFLAGS: 00010246
Jul 23 17:41:41 drs1s002 kernel: [1590728.745930] RAX: 0000000000000000 RBX: 1000000000000000 RCX: 0000000000000000
Jul 23 17:41:41 drs1s002 kernel: [1590728.755136] RDX: 0000000000000000 RSI: ffff93ac3f7d66b8 RDI: ffff93ac3f7d66b8
Jul 23 17:41:41 drs1s002 kernel: [1590728.764332] RBP: ffffb31f69dabb30 R08: 0000000000000000 R09: 00000000000022e7
Jul 23 17:41:41 drs1s002 kernel: [1590728.773547] R10: ffffb31f69daba48 R11: ffff938c2356ae90 R12: ffff93909f7bca80
Jul 23 17:41:41 drs1s002 kernel: [1590728.782771] R13: 0000000000001fa6 R14: 0000000000001fa7 R15: 0000000000000000
Jul 23 17:41:41 drs1s002 kernel: [1590728.792011] FS:  00007f29f78e2700(0000) GS:ffff93ac3f7c0000(0000) knlGS:0000000000000000
Jul 23 17:41:41 drs1s002 kernel: [1590728.802329] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Jul 23 17:41:41 drs1s002 kernel: [1590728.810082] CR2: 00007f29f78ccf38 CR3: 00000015aadfc004 CR4: 00000000001606e0
Jul 23 17:41:41 drs1s002 kernel: [1590728.819407] Call Trace:
Jul 23 17:41:41 drs1s002 kernel: [1590728.823596]  ocfs2_setattr+0x654/0xca0 [ocfs2]
Jul 23 17:41:41 drs1s002 kernel: [1590728.829981]  ? ocfs2_xattr_get+0xc3/0x140 [ocfs2]
Jul 23 17:41:41 drs1s002 kernel: [1590728.836619]  ? profile_path_perm.part.7+0x81/0xb0
Jul 23 17:41:41 drs1s002 kernel: [1590728.843264]  ? notify_change+0x2f4/0x420
Jul 23 17:41:41 drs1s002 kernel: [1590728.849069]  ? ocfs2_extend_no_holes+0x160/0x160 [ocfs2]
Jul 23 17:41:41 drs1s002 kernel: [1590728.856183]  notify_change+0x2f4/0x420
Jul 23 17:41:41 drs1s002 kernel: [1590728.861358]  do_truncate+0x75/0xc0
Jul 23 17:41:41 drs1s002 kernel: [1590728.866155]  path_openat+0x6b0/0x13e0
Jul 23 17:41:41 drs1s002 kernel: [1590728.871250]  ? ocfs2_inode_lock_full_nested+0x173/0x8e0 [ocfs2]
Jul 23 17:41:41 drs1s002 kernel: [1590728.878809]  do_filp_open+0x99/0x110
Jul 23 17:41:41 drs1s002 kernel: [1590728.883738]  ? strncpy_from_user+0x48/0x160
Jul 23 17:41:41 drs1s002 kernel: [1590728.889346]  ? __check_object_size+0x161/0x1a0
Jul 23 17:41:41 drs1s002 kernel: [1590728.895222]  ? do_sys_open+0x12e/0x210
Jul 23 17:41:41 drs1s002 kernel: [1590728.900308]  do_sys_open+0x12e/0x210
Jul 23 17:41:41 drs1s002 kernel: [1590728.905179]  do_syscall_64+0x55/0x120
Jul 23 17:41:41 drs1s002 kernel: [1590728.910142]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
Jul 23 17:41:41 drs1s002 kernel: [1590728.916635] RIP: 0033:0x7f3ba670985d
Jul 23 17:41:41 drs1s002 kernel: [1590728.921505] Code: bb 20 00 00 75 10 b8 02 00 00 00 0f 05 48 3d 01 f0 ff ff 73 31 c3 48 83 ec 08 e8 1e f6 ff ff 48 89 04 24 b8 02 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 67 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
Jul 23 17:41:41 drs1s002 kernel: [1590728.943869] RSP: 002b:00007f29f78e1350 EFLAGS: 00000293 ORIG_RAX: 0000000000000002
Jul 23 17:41:41 drs1s002 kernel: [1590728.953157] RAX: ffffffffffffffda RBX: 00000000000001b6 RCX: 00007f3ba670985d
Jul 23 17:41:41 drs1s002 kernel: [1590728.961985] RDX: 00000000000001b6 RSI: 0000000000000241 RDI: 00007f2980001930
Jul 23 17:41:41 drs1s002 kernel: [1590728.970777] RBP: 00007f29f78e1410 R08: 000000000000fef0 R09: 0000000000000030
Jul 23 17:41:41 drs1s002 kernel: [1590728.979778] R10: 00007f3b7d042080 R11: 0000000000000293 R12: 00007f2980001930
Jul 23 17:41:41 drs1s002 kernel: [1590728.988557] R13: 00007f2980001930 R14: 0000000000000241 R15: 00007f29f78e1528
Jul 23 17:41:41 drs1s002 kernel: [1590728.997317] Modules linked in: dm_snapshot(E) dm_bufio(E) udp_diag(E) tcp_diag(E) inet_diag(E) unix_diag(E) sha512_ssse3(E) sha512_generic(E) cmac(E) arc4(E) md4(E) nls_utf8(E) cifs(E) ccm(E) dns_resolver(E) fscache(E) ocfs2(E) quota_tree(E) veth(E) ocfs2_dlmfs(E) ocfs2_stack_o2cb(E) ocfs2_dlm(E) ocfs2_nodemanager(E) ocfs2_stackglue(E) configfs(E) iptable_filter(E) bridge(E) stp(E) llc(E) bonding(E) fuse(E) ipmi_ssif(E) intel_rapl(E) sb_edac(E) x86_pkg_temp_thermal(E) iTCO_wdt(E) intel_powerclamp(E) iTCO_vendor_support(E) coretemp(E) kvm_intel(E) kvm(E) irqbypass(E) crct10dif_pclmul(E) crc32_pclmul(E) ghash_clmulni_intel(E) intel_cstate(E) intel_uncore(E) nls_ascii(E) nls_cp437(E) vfat(E) fat(E) mgag200(E) intel_rapl_perf(E) ttm(E) efi_pstore(E) drm_kms_helper(E) efivars(E) pcspkr(E) drm(E) evdev(E)
Jul 23 17:41:41 drs1s002 kernel: [1590729.080648]  lpc_ich(E) i2c_algo_bit(E) hpilo(E) hpwdt(E) ioatdma(E) sg(E) wmi(E) ipmi_si(E) ipmi_devintf(E) ipmi_msghandler(E) acpi_tad(E) acpi_power_meter(E) pcc_cpufreq(E) button(E) drbd(E) lru_cache(E) libcrc32c(E) efivarfs(E) ip_tables(E) x_tables(E) autofs4(E) ext4(E) crc16(E) mbcache(E) jbd2(E) crc32c_generic(E) fscrypto(E) ecb(E) uas(E) usb_storage(E) dm_mod(E) sd_mod(E) crc32c_intel(E) aesni_intel(E) aes_x86_64(E) crypto_simd(E) cryptd(E) glue_helper(E) hpsa(E) xhci_pci(E) uhci_hcd(E) ehci_pci(E) xhci_hcd(E) ehci_hcd(E) scsi_transport_sas(E) tg3(E) ixgbe(E) i2c_i801(E) usbcore(E) dca(E) usb_common(E) libphy(E) scsi_mod(E) mdio(E)
Jul 23 17:41:41 drs1s002 kernel: [1590729.148164] ---[ end trace 6e8410bb0ab6f09f ]---

Jul 23 18:01:01 drs1s001 kernel: [1590965.813889] (clipit,27305,32):ocfs2_truncate_file:472 ERROR: bug expression: le64_to_cpu(fe->i_size) != i_size_read(inode)
Jul 23 18:01:01 drs1s001 kernel: [1590965.827039] (clipit,27305,32):ocfs2_truncate_file:472 ERROR: Inode 2439567, inode i_size = 3095 != di i_size = 3555, i_flags = 0x1
Jul 23 18:01:01 drs1s001 kernel: [1590965.841360] ------------[ cut here ]------------
Jul 23 18:01:01 drs1s001 kernel: [1590965.841361] kernel BUG at /kernelbuild/linux-4.19.37/fs/ocfs2/file.c:472!
Jul 23 18:01:01 drs1s001 kernel: [1590965.849639] invalid opcode: 0000 [#1] SMP PTI
Jul 23 18:01:01 drs1s001 kernel: [1590965.855234] CPU: 32 PID: 27305 Comm: clipit Tainted: G            E     4.19.0-0.bpo.5-amd64 #1 Debian 4.19.37-3~bpo9+2
Jul 23 18:01:01 drs1s001 kernel: [1590965.868638] Hardware name: HP ProLiant DL380 Gen9/ProLiant DL380 Gen9, BIOS P89 03/25/2019
Jul 23 18:01:01 drs1s001 kernel: [1590965.879100] RIP: 0010:ocfs2_truncate_file+0x6ea/0x700 [ocfs2]
Jul 23 18:01:01 drs1s001 kernel: [1590965.886746] Code: 01 00 00 48 c7 c6 50 d8 e3 c0 8b 41 2c 50 ff 71 20 48 c7 c1 38 6c e4 c0 4d 8b 4c 24 50 4d 8b 84 24 40 fb ff ff e8 16 37 b5 ff <0f> 0b e8 df f4 69 cf 0f 1f 44 00 00 66 2e 0f 1f 84 00 00 00 00 00
Jul 23 18:01:01 drs1s001 kernel: [1590965.909916] RSP: 0018:ffffa03ee3ac7ac0 EFLAGS: 00010246
Jul 23 18:01:01 drs1s001 kernel: [1590965.916950] RAX: 0000000000000000 RBX: 1000000000000000 RCX: 0000000000000000
Jul 23 18:01:01 drs1s001 kernel: [1590965.926312] RDX: 0000000000000000 RSI: ffff92797f8966b8 RDI: ffff92797f8966b8
Jul 23 18:01:01 drs1s001 kernel: [1590965.935687] RBP: ffffa03ee3ac7b30 R08: 0000000000000000 R09: 000000000000216b
Jul 23 18:01:01 drs1s001 kernel: [1590965.945096] R10: ffffa03ee3ac7a48 R11: ffff927977d2e150 R12: ffff926a8b1b9c00
Jul 23 18:01:01 drs1s001 kernel: [1590965.954508] R13: 0000000000000de3 R14: 0000000000000c17 R15: 0000000000000000
Jul 23 18:01:01 drs1s001 kernel: [1590965.963943] FS:  00007f37bd92f9c0(0000) GS:ffff92797f880000(0000) knlGS:0000000000000000
Jul 23 18:01:01 drs1s001 kernel: [1590965.974469] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Jul 23 18:01:01 drs1s001 kernel: [1590965.982449] CR2: 000055723d1b27c0 CR3: 000000117d30a004 CR4: 00000000001606e0
Jul 23 18:01:01 drs1s001 kernel: [1590965.991686] Call Trace:
Jul 23 18:01:01 drs1s001 kernel: [1590965.995514]  ocfs2_setattr+0x654/0xca0 [ocfs2]
Jul 23 18:01:01 drs1s001 kernel: [1590966.001536]  ? ocfs2_xattr_get+0xc3/0x140 [ocfs2]
Jul 23 18:01:01 drs1s001 kernel: [1590966.007836]  ? profile_path_perm.part.7+0x81/0xb0
Jul 23 18:01:01 drs1s001 kernel: [1590966.014134]  ? notify_change+0x2f4/0x420
Jul 23 18:01:01 drs1s001 kernel: [1590966.019599]  ? ocfs2_extend_no_holes+0x160/0x160 [ocfs2]
Jul 23 18:01:01 drs1s001 kernel: [1590966.026592]  notify_change+0x2f4/0x420
Jul 23 18:01:01 drs1s001 kernel: [1590966.031868]  do_truncate+0x75/0xc0
Jul 23 18:01:01 drs1s001 kernel: [1590966.036766]  path_openat+0x6b0/0x13e0
Jul 23 18:01:01 drs1s001 kernel: [1590966.041983]  ? ocfs2_inode_lock_full_nested+0x173/0x8e0 [ocfs2]
Jul 23 18:01:01 drs1s001 kernel: [1590966.049678]  do_filp_open+0x99/0x110
Jul 23 18:01:01 drs1s001 kernel: [1590966.054776]  ? strncpy_from_user+0x48/0x160
Jul 23 18:01:01 drs1s001 kernel: [1590966.060522]  ? __check_object_size+0x161/0x1a0
Jul 23 18:01:01 drs1s001 kernel: [1590966.066552]  ? do_sys_open+0x12e/0x210
Jul 23 18:01:01 drs1s001 kernel: [1590966.071814]  do_sys_open+0x12e/0x210
Jul 23 18:01:01 drs1s001 kernel: [1590966.076870]  do_syscall_64+0x55/0x120
Jul 23 18:01:01 drs1s001 kernel: [1590966.082010]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
Jul 23 18:01:01 drs1s001 kernel: [1590966.088681] RIP: 0033:0x7f37bc0cd70d
Jul 23 18:01:01 drs1s001 kernel: [1590966.093729] Code: 30 2c 00 00 75 10 b8 02 00 00 00 0f 05 48 3d 01 f0 ff ff 73 31 c3 48 83 ec 08 e8 fe 9d 01 00 48 89 04 24 b8 02 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 47 9e 01 00 48 89 d0 48 83 c4 08 48 3d 01
Jul 23 18:01:01 drs1s001 kernel: [1590966.116961] RSP: 002b:00007ffed8219f50 EFLAGS: 00000293 ORIG_RAX: 0000000000000002
Jul 23 18:01:01 drs1s001 kernel: [1590966.126462] RAX: ffffffffffffffda RBX: 000055723d1d4ce0 RCX: 00007f37bc0cd70d
Jul 23 18:01:01 drs1s001 kernel: [1590966.135484] RDX: 00000000000001b6 RSI: 0000000000000241 RDI: 000055723d1d4ba0
Jul 23 18:01:01 drs1s001 kernel: [1590966.144500] RBP: 0000000000000004 R08: 0000000000000004 R09: 0000000000000001
Jul 23 18:01:01 drs1s001 kernel: [1590966.153495] R10: 0000000000000240 R11: 0000000000000293 R12: 000055723b532794
Jul 23 18:01:01 drs1s001 kernel: [1590966.162473] R13: 0000000000000001 R14: 000055723d068930 R15: 00007f37bc928110
Jul 23 18:01:01 drs1s001 kernel: [1590966.171442] Modules linked in: unix_diag(E) binfmt_misc(E) sha512_ssse3(E) sha512_generic(E) cmac(E) arc4(E) md4(E) nls_utf8(E) cifs(E) ccm(E) dns_resolver(E) fscache(E) veth(E) btrfs(E) zstd_compress(E) zstd_decompress(E) xxhash(E) xor(E) raid6_pq(E) ufs(E) qnx4(E) hfsplus(E) hfs(E) minix(E) msdos(E) jfs(E) xfs(E) ocfs2_dlmfs(E) ocfs2_stack_o2cb(E) ocfs2_dlm(E) ocfs2(E) ocfs2_nodemanager(E) configfs(E) ocfs2_stackglue(E) quota_tree(E) dm_snapshot(E) dm_bufio(E) udp_diag(E) tcp_diag(E) inet_diag(E) iptable_filter(E) bridge(E) stp(E) llc(E) bonding(E) fuse(E) nls_ascii(E) nls_cp437(E) vfat(E) fat(E) ipmi_ssif(E) intel_rapl(E) iTCO_wdt(E) iTCO_vendor_support(E) sb_edac(E) x86_pkg_temp_thermal(E) intel_powerclamp(E) coretemp(E) kvm_intel(E) kvm(E) irqbypass(E) crct10dif_pclmul(E) crc32_pclmul(E) ghash_clmulni_intel(E)
Jul 23 18:01:01 drs1s001 kernel: [1590966.258368]  intel_cstate(E) intel_uncore(E) intel_rapl_perf(E) efi_pstore(E) pcspkr(E) efivars(E) mgag200(E) ttm(E) drm_kms_helper(E) joydev(E) lpc_ich(E) drm(E) i2c_algo_bit(E) hpilo(E) hpwdt(E) ioatdma(E) evdev(E) sg(E) wmi(E) ipmi_si(E) ipmi_devintf(E) ipmi_msghandler(E) acpi_tad(E) acpi_power_meter(E) pcc_cpufreq(E) button(E) drbd(E) lru_cache(E) libcrc32c(E) efivarfs(E) ip_tables(E) x_tables(E) autofs4(E) ext4(E) crc16(E) mbcache(E) jbd2(E) crc32c_generic(E) fscrypto(E) ecb(E) uas(E) usb_storage(E) hid_generic(E) usbhid(E) hid(E) dm_mod(E) sd_mod(E) crc32c_intel(E) aesni_intel(E) aes_x86_64(E) crypto_simd(E) cryptd(E) glue_helper(E) xhci_pci(E) ehci_pci(E) uhci_hcd(E) xhci_hcd(E) ehci_hcd(E) hpsa(E) ixgbe(E) tg3(E) i2c_i801(E) usbcore(E) scsi_transport_sas(E) dca(E) usb_common(E) mdio(E) libphy(E)
Jul 23 18:01:01 drs1s001 kernel: [1590966.344255]  scsi_mod(E) [last unloaded: configfs]
Jul 23 18:01:01 drs1s001 kernel: [1590966.350821] ---[ end trace 7db650644ae16c2c ]---

-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20190725/9087ade8/attachment-0001.html 
