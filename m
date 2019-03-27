From: Wengang <wen.gang.wang@oracle.com>
Date: Wed, 27 Mar 2019 11:17:50 -0700
Subject: [Ocfs2-devel] OCFS2 BUG with 2 different kernels
In-Reply-To: <AM6PR04MB56055FC3821310CC2428EE32ED580@AM6PR04MB5605.eurprd04.prod.outlook.com>
References: <HE1PR0401MB25389DFE7BFEC86453C3CB21EDBE0@HE1PR0401MB2538.eurprd04.prod.outlook.com>
	<09ea1b7f-00e0-cbd7-e484-22e6bb956ddd@suse.com>
	<DB6PR0402MB29022E09E4A2C8F24CB97554ED580@DB6PR0402MB2902.eurprd04.prod.outlook.com>
	<DB6PR0402MB2902763397E62C60288E34B8ED5D0@DB6PR0402MB2902.eurprd04.prod.outlook.com>
	<a1383ec0-a140-4de3-432b-da3044e038c7@suse.com>
	<DB6PR0402MB29028D4B17AC047C684A58D5ED5C0@DB6PR0402MB2902.eurprd04.prod.outlook.com>
	<5315fa90-0f6c-5e4a-0d3b-41ddf90a594d@suse.com>
	<DB6PR0402MB2902AA63F2CCA6B873D859A3ED040@DB6PR0402MB2902.eurprd04.prod.outlook.com>
	<AM6PR04MB56050DFB2F16A310C998B41AED7D0@AM6PR04MB5605.eurprd04.prod.outlook.com>
	<6c354f37-e251-85f1-f85e-1b9003400a53@oracle.com>
	<DB8PR04MB56122AD3950F48E3EEEE1E1CED5F0@DB8PR04MB5612.eurprd04.prod.outlook.com>
	<201c92ac-648a-9ca3-1afb-ef41933a29a2@oracle.com>
	<AM6PR04MB56055FC3821310CC2428EE32ED580@AM6PR04MB5605.eurprd04.prod.outlook.com>
Message-ID: <cc3ae5a3-6758-8963-cd58-59578d016e5b@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

BUG() would panic the kernel, dumping the callback trace on console, and 
then usually reboot the machine.

Kexec (when kdump is installed and configured properly) would, when 
production kernel panic,? start a new kernel (dump kernel) from a 
reserved block of memory and keep the other memory untouched. when dump 
kernel booted up, it performs memory collecting procedure against the 
untouched memory and save it to disk file (usually called "vmcore"). 
then reboot to product kernel again after the collecting work finished. 
So, yes, vmcore is a image file with kernel memory inside.

Here is an example regarding kdump configuration:

https://fedoraproject.org/wiki/How_to_use_kdump_to_debug_kernel_crashes

thanks,
wengang
On 03/27/2019 12:57 AM, Daniel Sobe wrote:
> In my setup, the system is still responsive (at least for a couple of minutes) after the BUG. Do I understand it correctly that you want me to setup "kdump" and provoke a crash manually after this BUG occurred, in order to receive an image file with all kernel memory inside?
>
> Sorry for the stupid question, but I'm new to this.
>
> Regards,
>
> Daniel
>
> -----Original Message-----
> From: Wengang Wang <wen.gang.wang@oracle.com>
> Sent: Dienstag, 26. M?rz 2019 22:24
> To: Daniel Sobe <daniel.sobe@nxp.com>; 'ocfs2-devel at oss.oracle.com' <ocfs2-devel@oss.oracle.com>
> Subject: Re: [Ocfs2-devel] OCFS2 BUG with 2 different kernels
>
> Thank you, Daniel.
>
> Wengang
>
> On 2019/3/26 5:27, Daniel Sobe wrote:
>> Hi Wengang,
>>
>> Thanks for confirming that this bug is reproducible! Long time I was under the impression that I'm the only one facing this issue.
>>
>> Unfortunately, I do not know what a "vmcore" is. Let me google it and then check whether I can reproduce the bug again easily and provide what you request.
>>
>> Regards,
>>
>> Daniel
>>
>> -----Original Message-----
>> From: ocfs2-devel-bounces at oss.oracle.com
>> <ocfs2-devel-bounces@oss.oracle.com> On Behalf Of Wengang
>> Sent: Montag, 18. M?rz 2019 18:46
>> To: ocfs2-devel at oss.oracle.com
>> Subject: Re: [Ocfs2-devel] OCFS2 BUG with 2 different kernels
>>
>> Hi,
>>
>> I also see this problem on a lower version at 4.1.12.xxx.
>>
>> The l_ro_holders is changed in ocfs2 layer, not DLM layer. And another thing is that the dentry lock is just used to get notification for file remote deleting. So the code is requesting PR lock and then releasing the it after PR is granted.? I am not sure, but I feel this is not a DLM issue, but a memory issue on the ocfs2_lock_res.? Do you have a vmcore available for this problem?
>>
>> Thanks,
>> Wengang
>>
>>
>> On 02/20/2019 12:48 AM, Daniel Sobe wrote:
>>> Hi Larry,
>>>
>>> The issue still happens with 4.19 as well, but it took quite a while to trigger it:
>>>
>>> Feb 20 09:37:56 drs1p001 kernel: ------------[ cut here ]------------
>>> Feb 20 09:37:56 drs1p001 kernel: kernel BUG at /build/linux-Ut6wTa/linux-4.19.12/fs/ocfs2/dlmglue.c:849!
>>> Feb 20 09:37:56 drs1p001 kernel: invalid opcode: 0000 [#1] SMP PTI
>>> Feb
>>> 20 09:37:56 drs1p001 kernel: CPU: 1 PID: 24018 Comm: git Not tainted
>>> 4.19.0-0.bpo.1-amd64 #1 Debian 4.19.12-1~bpo9+1 Feb 20 09:37:56
>>> drs1p001 kernel: Hardware name: Dell Inc. OptiPlex 5040/0R790T, BIOS
>>> 1.2.7 01/15/2016 Feb 20 09:37:56 drs1p001 kernel: RIP:
>>> 0010:__ocfs2_cluster_unlock.isra.38+0x9d/0xb0 [ocfs2] Feb 20 09:37:56
>>> drs1p001 kernel: Code: c6 5b 5d 41 5c 41 5d e9 41 0d ec de 0f 0b 8b
>>> 53
>>> 68 85 d2 74 15 83 ea 01 89 53 68 eb af 8b 53 6c 85 d2 74 c3 eb d1 0f
>>> 0b 0f 0b <0f> 0b 0f 0b 0f 1f 44 00 00 66 2e 0f 1f 84 00 00 00 00 00
>>> 0f 1f 44 Feb 20 09:37:56 drs1p001 kernel: RSP: 0018:ffffaa68c813faf8
>>> EFLAGS: 00010046 Feb 20 09:37:56 drs1p001 kernel: RAX:
>>> 0000000000000292 RBX: ffff95fe8cec9618 RCX: 0000000000000000 Feb 20
>>> 09:37:56 drs1p001 kernel: RDX: 0000000000000000 RSI: ffff95fe8cec9618
>>> RDI: ffff95fe8cec9694 Feb 20 09:37:56 drs1p001 kernel: RBP:
>>> 0000000000000003 R08: 00006a0340000000 R09: 0000000000000153 Feb 20
>>> 09:37:56 drs1p001 kernel: R10: ffffaa68c813fae0 R11: 000000000000000b
>>> R12: ffff95fe8cec9694 Feb 20 09:37:56 drs1p001 kernel: R13:
>>> ffff95fe8a876000 R14: 0000000000000000 R15: ffffffffc0f122c0 Feb 20
>>> 09:37:56 drs1p001 kernel: FS:  00007fc258ff9700(0000)
>>> GS:ffff95fe91a80000(0000) knlGS:0000000000000000 Feb 20 09:37:56
>>> drs1p001 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>> Feb
>>> 20 09:37:56 drs1p001 kernel:  ? d_splice_alias+0x139/0x3f0 Feb 20
>>> 09:37:56 drs1p001 kernel:  ocfs2_lookup+0x199/0x2e0 [ocfs2] Feb 20
>>> 09:37:56 drs1p001 kernel:  ? ocfs2_permission+0x79/0xe0 [ocfs2] Feb
>>> 20
>>> 09:37:56 drs1p001 kernel:  __lookup_slow+0x97/0x150 Feb 20 09:37:56
>>> drs1p001 kernel:  lookup_slow+0x35/0x50 Feb 20 09:37:56 drs1p001
>>> kernel:  walk_component+0x1c6/0x360 Feb 20 09:37:56 drs1p001 kernel:
>>> ? __ocfs2_cluster_lock.isra.37+0x62d/0x7b0 [ocfs2] Feb 20 09:37:56
>>> drs1p001 kernel:  ? __aa_path_perm.part.6+0x6b/0x80 Feb 20 09:37:56
>>> drs1p001 kernel:  path_lookupat+0x67/0x200 Feb 20 09:37:56 drs1p001
>>> kernel:  filename_lookup+0xb8/0x1a0 Feb 20 09:37:56 drs1p001 kernel:
>>> ? seccomp_run_filters+0x58/0xb0 Feb 20 09:37:56 drs1p001 kernel:  ?
>>> __check_object_size+0x9d/0x1a0 Feb 20 09:37:56 drs1p001 kernel:  ?
>>> strncpy_from_user+0x48/0x160 Feb 20 09:37:56 drs1p001 kernel:  ?
>>> getname_flags+0x6a/0x1e0 Feb 20 09:37:56 drs1p001 kernel:  ?
>>> vfs_statx+0x73/0xe0 Feb 20 09:37:56 drs1p001 kernel:
>>> vfs_statx+0x73/0xe0 Feb 20 09:37:56 drs1p001 kernel:
>>> __do_sys_newlstat+0x39/0x70 Feb 20 09:37:56 drs1p001 kernel:  ?
>>> syscall_trace_enter+0x117/0x2c0 Feb 20 09:37:56 drs1p001 kernel:
>>> do_syscall_64+0x55/0x110 Feb 20 09:37:56 drs1p001 kernel:
>>> entry_SYSCALL_64_after_hwframe+0x44/0xa9
>>> Feb 20 09:37:56 drs1p001 kernel: RIP: 0033:0x7fc2622d80f5 Feb 20
>>> 09:37:56 drs1p001 kernel: Code: a9 dd 2b 00 64 c7 00 16 00 00 00 b8
>>> ff ff ff ff c3 0f 1f 40 00 83 ff 01 48 89 f0 77 30 48 89 c7 48 89 d6
>>> b8
>>> 06 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 03 f3 c3 90 48 8b 15 71 dd
>>> 2b
>>> 00 f7 d8 64 89 Feb 20 09:37:56 drs1p001 kernel: RSP:
>>> 002b:00007fc258ff8d08 EFLAGS: 00000246 ORIG_RAX: 0000000000000006 Feb
>>> 20 09:37:56 drs1p001 kernel: RAX: ffffffffffffffda RBX:
>>> 00007fc258ff8e50 RCX: 00007fc2622d80f5 Feb 20 09:37:56 drs1p001
>>> kernel: RDX: 00007fc258ff8d40 RSI: 00007fc258ff8d40 RDI:
>>> 00007fc2300008c0 Feb 20 09:37:56 drs1p001 kernel: RBP:
>>> 0000000000000045 R08: 0000000000000003 R09: 0000000000000000 Feb 20
>>> 09:37:56 drs1p001 kernel: R10: 0000000000000000 R11: 0000000000000246
>>> R12: 0000000000000005 Feb 20 09:37:56 drs1p001 kernel: R13:
>>> 000000000000000d R14: 0000000000000015 R15: 000055ec17f94d58 Feb 20
>>> 09:37:56 drs1p001 kernel: Modules linked in: tcp_diag inet_diag
>>> unix_diag appletalk psnap ax25 veth fuse ocfs2_dlmfs ocfs2_stack_o2cb
>>> ocfs2_dlm ocfs2 ocfs2_nodemanager configfs ocfs2_stackglue quota_tree
>>> dm_mod drbd lru_cache libcrc32c bridge stp llc snd_hda_codec_hdmi
>>> rfkill snd_hda_codec_realtek snd_hda_codec_generic intel_rapl
>>> x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm i915
>>> irqbypass crct10dif_pclmul crc32_pclmul dell_wmi dell_smbios wmi_bmof
>>> sparse_keymap snd_hda_intel dell_wmi_descriptor evdev
>>> ghash_clmulni_intel snd_hda_codec drm_kms_helper intel_cstate
>>> snd_hda_core intel_uncore snd_hwdep dcdbas intel_rapl_perf snd_pcm
>>> drm snd_timer snd mei_me soundcore pcspkr i2c_algo_bit
>>> intel_pch_thermal iTCO_wdt mei serio_raw iTCO_vendor_support sg wmi video button acpi_pad pcc_cpufreq ip_tables x_tables Feb 20 09:37:56 drs1p001 kernel:  autofs4 ext4 crc16 mbcache jbd2 crc32c_generic fscrypto ecb sr_mod cdrom sd_mod crc32c_intel aesni_intel aes_x86_64 crypto_simd cryptd ahci glue_helper libahci e1000 libata xhci_pci psmouse xhci_hcd scsi_mod e1000e usbcore i2c_i801 usb_common thermal fan Feb 20 09:37:56 drs1p001 kernel: ---[ end trace b0fe45be8de9bbe1 ]--- Feb 20 09:37:56 drs1p001 kernel: RIP: 0010:__ocfs2_cluster_unlock.isra.38+0x9d/0xb0 [ocfs2] Feb 20 09:37:56 drs1p001 kernel: Code: c6 5b 5d 41 5c 41 5d e9 41 0d ec de 0f 0b 8b 53 68 85 d2 74 15 83 ea 01 89 53 68 eb af 8b 53 6c 85 d2 74 c3 eb d1 0f 0b 0f 0b <0f> 0b 0f 0b 0f 1f 44 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 Feb 20 09:37:56 drs1p001 kernel: RSP: 0018:ffffaa68c813faf8 EFLAGS: 00010046 Feb 20 09:37:56 drs1p001 kernel: RAX: 0000000000000292 RBX: ffff95fe8cec9618 RCX: 0000000000000000 Feb 20 09:37:56 drs1p001 kernel: RDX: 0000000000000000 RSI: ffff95fe8cec9618 RDI: ffff95fe8cec9694 Feb 20 09:37:56 drs1p001 kernel: RBP: 0000000000000003 R08: 00006a0340000000 R09: 0000000000000153 Feb 20 09:37:56 drs1p001 kernel: R10: ffffaa68c813fae0 R11: 000000000000000b R12: ffff95fe8cec9694 Feb 20 09:37:56 drs1p001 kernel: R13: ffff95fe8a876000 R14: 0000000000000000 R15: ffffffffc0f122c0 Feb 20 09:37:56 drs1p001 kernel: FS:  00007fc258ff9700(0000) GS:ffff95fe91a80000(0000) knlGS:0000000000000000 Feb 20 09:37:56 drs1p001 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033 Feb 20 09:37:56 drs1p001 kernel: CR2: 00007fc224000010 CR3: 00000001617fc002 CR4: 00000000003606e0 Feb 20 09:37:56 drs1p001 kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000 Feb 20 09:37:56 drs1p001 kernel: DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400 Feb 20 09:37:56 drs1p001 kernel: ------------[ cut here ]------------ Feb 20 09:37:56 drs1p001 kernel: kernel BUG at /build/linux-Ut6wTa/linux-4.19.12/fs/ocfs2/dlmglue.c:849!
>>> Feb 20 09:37:56 drs1p001 kernel: invalid opcode: 0000 [#2] SMP PTI
>>> Feb 20 09:37:56 drs1p001 kernel: CPU: 1 PID: 24024 Comm: git Tainted: G      D           4.19.0-0.bpo.1-amd64 #1 Debian 4.19.12-1~bpo9+1
>>> Feb 20 09:37:56 drs1p001 kernel: Hardware name: Dell Inc. OptiPlex
>>> 5040/0R790T, BIOS 1.2.7 01/15/2016 Feb 20 09:37:56 drs1p001 kernel:
>>> RIP: 0010:__ocfs2_cluster_unlock.isra.38+0x9d/0xb0 [ocfs2] Feb 20
>>> 09:37:56 drs1p001 kernel: Code: c6 5b 5d 41 5c 41 5d e9 41 0d ec de
>>> 0f 0b 8b 53 68 85 d2 74 15 83 ea 01 89 53 68 eb af 8b 53 6c 85 d2 74
>>> c3 eb d1 0f 0b 0f 0b <0f> 0b 0f 0b 0f 1f 44 00 00 66 2e 0f 1f 84 00
>>> 00 00
>>> 00 00 0f 1f 44 Feb 20 09:37:56 drs1p001 kernel: RSP:
>>> 0018:ffffaa68c8177af8 EFLAGS: 00010046 Feb 20 09:37:56 drs1p001
>>> kernel: RAX: 0000000000000292 RBX: ffff95fdf3b23418 RCX:
>>> 0000000000000000 Feb 20 09:37:56 drs1p001 kernel: RDX:
>>> 0000000000000000 RSI: ffff95fdf3b23418 RDI: ffff95fdf3b23494 Feb 20
>>> 09:37:56 drs1p001 kernel: RBP: 0000000000000003 R08: ffff95fe91aa2620
>>> R09: 0000000000000089 Feb 20 09:37:56 drs1p001 kernel: R10:
>>> ffffaa68c8177ae0 R11: ffff95fe6e3efb40 R12: ffff95fdf3b23494 Feb 20
>>> 09:37:56 drs1p001 kernel: R13: ffff95fe8a876000 R14: 0000000000000000 R15: ffffffffc0f122c0 Feb 20 09:37:56 drs1p001 kernel: FS:  00007fc24d7fa700(0000) GS:ffff95fe91a80000(0000) knlGS:0000000000000000 Feb 20 09:37:56 drs1p001 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033 Feb 20 09:37:56 drs1p001 kernel: CR2: 00007fc224000010 CR3: 00000001617fc002 CR4: 00000000003606e0 Feb 20 09:37:56 drs1p001 kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000 Feb 20 09:37:56 drs1p001 kernel: DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400 Feb 20 09:37:56 drs1p001 kernel: Call Trace:
>>> Feb 20 09:37:56 drs1p001 kernel:  ? ocfs2_dentry_unlock+0x35/0x80
>>> [ocfs2] Feb 20 09:37:56 drs1p001 kernel:
>>> ocfs2_dentry_attach_lock+0x2cb/0x420 [ocfs2] Feb 20 09:37:56 drs1p001
>>> kernel:  ? d_splice_alias+0x29d/0x3f0 Feb 20 09:37:56 drs1p001 kernel:
>>> ocfs2_lookup+0x199/0x2e0 [ocfs2] Feb 20 09:37:56 drs1p001 kernel:
>>> __lookup_slow+0x97/0x150 Feb 20 09:37:56 drs1p001 kernel:
>>> lookup_slow+0x35/0x50 Feb 20 09:37:56 drs1p001 kernel:
>>> walk_component+0x1c6/0x360 Feb 20 09:37:56 drs1p001 kernel:  ?
>>> __ocfs2_cluster_lock.isra.37+0x62d/0x7b0 [ocfs2] Feb 20 09:37:56
>>> drs1p001 kernel:  ? __aa_path_perm.part.6+0x6b/0x80 Feb 20 09:37:56
>>> drs1p001 kernel:  path_lookupat+0x67/0x200 Feb 20 09:37:56 drs1p001
>>> kernel:  filename_lookup+0xb8/0x1a0 Feb 20 09:37:56 drs1p001 kernel:
>>> ? seccomp_run_filters+0x58/0xb0 Feb 20 09:37:56 drs1p001 kernel:  ?
>>> __check_object_size+0x9d/0x1a0 Feb 20 09:37:56 drs1p001 kernel:  ?
>>> strncpy_from_user+0x48/0x160 Feb 20 09:37:56 drs1p001 kernel:  ?
>>> getname_flags+0x6a/0x1e0 Feb 20 09:37:56 drs1p001 kernel:  ?
>>> vfs_statx+0x73/0xe0 Feb 20 09:37:56 drs1p001 kernel:
>>> vfs_statx+0x73/0xe0 Feb 20 09:37:56 drs1p001 kernel:
>>> __do_sys_newlstat+0x39/0x70 Feb 20 09:37:56 drs1p001 kernel:  ?
>>> syscall_trace_enter+0x117/0x2c0 Feb 20 09:37:56 drs1p001 kernel:
>>> do_syscall_64+0x55/0x110 Feb 20 09:37:56 drs1p001 kernel:
>>> entry_SYSCALL_64_after_hwframe+0x44/0xa9
>>> Feb 20 09:37:56 drs1p001 kernel: RIP: 0033:0x7fc2622d80f5 Feb 20
>>> 09:37:56 drs1p001 kernel: Code: a9 dd 2b 00 64 c7 00 16 00 00 00 b8
>>> ff ff ff ff c3 0f 1f 40 00 83 ff 01 48 89 f0 77 30 48 89 c7 48 89 d6
>>> b8
>>> 06 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 03 f3 c3 90 48 8b 15 71 dd
>>> 2b
>>> 00 f7 d8 64 89 Feb 20 09:37:56 drs1p001 kernel: RSP:
>>> 002b:00007fc24d7f9d08 EFLAGS: 00000246 ORIG_RAX: 0000000000000006 Feb
>>> 20 09:37:56 drs1p001 kernel: RAX: ffffffffffffffda RBX:
>>> 00007fc24d7f9e50 RCX: 00007fc2622d80f5 Feb 20 09:37:56 drs1p001
>>> kernel: RDX: 00007fc24d7f9d40 RSI: 00007fc24d7f9d40 RDI:
>>> 00007fc2100008c0 Feb 20 09:37:56 drs1p001 kernel: RBP:
>>> 0000000000000044 R08: 0000000000000003 R09: 0000000000000000 Feb 20
>>> 09:37:56 drs1p001 kernel: R10: 0000000000000000 R11: 0000000000000246
>>> R12: 0000000000000005 Feb 20 09:37:56 drs1p001 kernel: R13:
>>> 000000000000000f R14: 000000000000001d R15: 000055ec18015008 Feb 20
>>> 09:37:56 drs1p001 kernel: Modules linked in: tcp_diag inet_diag
>>> unix_diag appletalk psnap ax25 veth fuse ocfs2_dlmfs ocfs2_stack_o2cb
>>> ocfs2_dlm ocfs2 ocfs2_nodemanager configfs ocfs2_stackglue quota_tree
>>> dm_mod drbd lru_cache libcrc32c bridge stp llc snd_hda_codec_hdmi
>>> rfkill snd_hda_codec_realtek snd_hda_codec_generic intel_rapl
>>> x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm i915
>>> irqbypass crct10dif_pclmul crc32_pclmul dell_wmi dell_smbios wmi_bmof
>>> sparse_keymap snd_hda_intel dell_wmi_descriptor evdev
>>> ghash_clmulni_intel snd_hda_codec drm_kms_helper intel_cstate
>>> snd_hda_core intel_uncore snd_hwdep dcdbas intel_rapl_perf snd_pcm
>>> drm snd_timer snd mei_me soundcore pcspkr i2c_algo_bit
>>> intel_pch_thermal iTCO_wdt mei serio_raw iTCO_vendor_support sg wmi
>>> video button acpi_pad pcc_cpufreq ip_tables x_tables Feb 20 09:37:56
>>> drs1p001
>>> kernel:  autofs4 ext4 crc16 mbcache jbd2 crc32c_generic fscrypto ecb
>>> sr_mod cdrom sd_mod crc32c_intel aesni_intel aes_x86_64 crypto_simd
>>> cryptd ahci glue_helper libahci e1000 libata xhci_pci psmouse
>>> xhci_hcd scsi_mod e1000e usbcore i2c_i801 usb_common thermal fan Feb
>>> 20
>>> 09:37:56 drs1p001 kernel: ---[ end trace b0fe45be8de9bbe2 ]--- Feb 20
>>> 09:37:56 drs1p001 kernel: RIP:
>>> 0010:__ocfs2_cluster_unlock.isra.38+0x9d/0xb0 [ocfs2] Feb 20 09:37:56
>>> drs1p001 kernel: Code: c6 5b 5d 41 5c 41 5d e9 41 0d ec de 0f 0b 8b
>>> 53
>>> 68 85 d2 74 15 83 ea 01 89 53 68 eb af 8b 53 6c 85 d2 74 c3 eb d1 0f
>>> 0b 0f 0b <0f> 0b 0f 0b 0f 1f 44 00 00 66 2e 0f 1f 84 00 00 00 00 00
>>> 0f 1f 44 Feb 20 09:37:56 drs1p001 kernel: RSP: 0018:ffffaa68c813faf8
>>> EFLAGS: 00010046 Feb 20 09:37:56 drs1p001 kernel: RAX:
>>> 0000000000000292 RBX: ffff95fe8cec9618 RCX: 0000000000000000 Feb 20
>>> 09:37:56 drs1p001 kernel: RDX: 0000000000000000 RSI: ffff95fe8cec9618
>>> RDI: ffff95fe8cec9694 Feb 20 09:37:56 drs1p001 kernel: RBP:
>>> 0000000000000003 R08: 00006a0340000000 R09: 0000000000000153 Feb 20
>>> 09:37:56 drs1p001 kernel: R10: ffffaa68c813fae0 R11: 000000000000000b
>>> R12: ffff95fe8cec9694 Feb 20 09:37:56 drs1p001 kernel: R13:
>>> ffff95fe8a876000 R14: 0000000000000000 R15: ffffffffc0f122c0 Feb 20
>>> 09:37:56 drs1p001 kernel: FS:  00007fc24d7fa700(0000)
>>> GS:ffff95fe91a80000(0000) knlGS:0000000000000000 Feb 20 09:37:56
>>> drs1p001 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>> Feb
>>> 20 09:37:56 drs1p001 kernel: CR2: 00007fc224000010 CR3:
>>> 00000001617fc002 CR4: 00000000003606e0 Feb 20 09:37:56 drs1p001
>>> kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2:
>>> 0000000000000000 Feb 20 09:37:56 drs1p001 kernel: DR3:
>>> 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>>>
>>> Regards,
>>>
>>> Daniel
>>>
>>> -----Original Message-----
>>> From: Daniel Sobe
>>> Sent: Dienstag, 11. September 2018 13:36
>>> To: Larry Chen <lchen@suse.com>; ocfs2-devel at oss.oracle.com
>>> Subject: RE: [Ocfs2-devel] OCFS2 BUG with 2 different kernels
>>>
>>> Hi Larry,
>>>
>>> I tested your script and indeed it does not provoke the error. Meanwhile I used a newer kernel which makes it harder to provoke it, here is the stacktrace:
>>>
>>> Sep 11 13:08:51 drs1p002 kernel: ------------[ cut here ]------------
>>> Sep 11 13:08:51 drs1p002 kernel: kernel BUG at /build/linux-hJelb7/linux-4.18.6/fs/ocfs2/dlmglue.c:847!
>>> Sep 11 13:08:51 drs1p002 kernel: invalid opcode: 0000 [#1] SMP PTI
>>> Sep
>>> 11 13:08:51 drs1p002 kernel: CPU: 0 PID: 21443 Comm: java Not tainted
>>> 4.18.0-1-amd64 #1 Debian 4.18.6-1 Sep 11 13:08:51 drs1p002 kernel:
>>> Hardware name: Dell Inc. OptiPlex 7010/0WR7PY, BIOS A18 04/30/2014
>>> Sep
>>> 11 13:08:51 drs1p002 kernel: RIP:
>>> 0010:__ocfs2_cluster_unlock.isra.39+0x9c/0xb0 [ocfs2] Sep 11 13:08:51
>>> drs1p002 kernel: Code: 89 ef 48 89 c6 5b 5d 41 5c 41 5d e9 6e 12 50
>>> cc 8b 53 68 85 d2 74 13 83 ea 01 89 53 68 eb b1 8b 53 6c 85 d2 74 c5
>>> eb
>>> d3 0f 0b <0f> 0b 0f 0b 0f 0b 0f 0b 66 66 2e 0f 1f 84 00 00 00 00 00
>>> 90 0f 1f Sep 11 13:08:51 drs1p002 kernel: RSP: 0018:ffffb1248eeb3af8
>>> EFLAGS: 00010046 Sep 11 13:08:51 drs1p002 kernel: RAX:
>>> 0000000000000292 RBX: ffff95cdbd985a18 RCX: 0000000000000100 Sep 11
>>> 13:08:51 drs1p002 kernel: RDX: 0000000000000000 RSI: 0000000000000000
>>> RDI: ffff95cdbd985a94 Sep 11 13:08:51 drs1p002 kernel: RBP:
>>> ffff95cdbd985a94 R08: 0000000000000000 R09: 000000000000aa47 Sep 11 13:08:51 drs1p002 kernel: R10: ffffb1248eeb3ae0 R11: 0000000000000002 R12: 0000000000000003 Sep 11 13:08:51 drs1p002 kernel: R13: ffff95ce87dfe000 R14: 0000000000000000 R15: ffffffffc0ab3240 Sep 11 13:08:51 drs1p002 kernel: FS:  00007f2434e21700(0000) GS:ffff95ce9e200000(0000) knlGS:0000000000000000 Sep 11 13:08:51 drs1p002 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033 Sep 11 13:08:51 drs1p002 kernel: CR2: 00007f01eaa48000 CR3: 000000003dd86001 CR4: 00000000001606f0 Sep 11 13:08:51 drs1p002 kernel: Call Trace:
>>> Sep 11 13:08:51 drs1p002 kernel:  ? ocfs2_dentry_unlock+0x35/0x80
>>> [ocfs2] Sep 11 13:08:51 drs1p002 kernel:
>>> ocfs2_dentry_attach_lock+0x245/0x420 [ocfs2] Sep 11 13:08:51 drs1p002
>>> kernel:  ? d_splice_alias+0x299/0x410 Sep 11 13:08:51 drs1p002 kernel:
>>> ocfs2_lookup+0x233/0x2c0 [ocfs2] Sep 11 13:08:51 drs1p002 kernel:
>>> __lookup_slow+0x97/0x150 Sep 11 13:08:51 drs1p002 kernel:
>>> lookup_slow+0x35/0x50 Sep 11 13:08:51 drs1p002 kernel:
>>> walk_component+0x1c4/0x480 Sep 11 13:08:51 drs1p002 kernel:  ?
>>> link_path_walk+0x27c/0x510 Sep 11 13:08:51 drs1p002 kernel:  ?
>>> path_init+0x177/0x2f0 Sep 11 13:08:51 drs1p002 kernel:
>>> path_lookupat+0x84/0x1f0 Sep 11 13:08:51 drs1p002 kernel:
>>> filename_lookup+0xb6/0x190 Sep 11 13:08:51 drs1p002 kernel:  ?
>>> ocfs2_inode_unlock+0xe4/0xf0 [ocfs2] Sep 11 13:08:51 drs1p002 kernel:
>>> ? __check_object_size+0xa7/0x1a0 Sep 11 13:08:51 drs1p002 kernel:  ?
>>> strncpy_from_user+0x48/0x160 Sep 11 13:08:51 drs1p002 kernel:  ?
>>> getname_flags+0x6a/0x1e0 Sep 11 13:08:51 drs1p002 kernel:  ?
>>> vfs_statx+0x73/0xe0 Sep 11 13:08:51 drs1p002 kernel:
>>> vfs_statx+0x73/0xe0 Sep 11 13:08:51 drs1p002 kernel:
>>> __do_sys_newlstat+0x39/0x70 Sep 11 13:08:51 drs1p002 kernel:
>>> do_syscall_64+0x55/0x110 Sep 11 13:08:51 drs1p002 kernel:
>>> entry_SYSCALL_64_after_hwframe+0x44/0xa9
>>> Sep 11 13:08:51 drs1p002 kernel: RIP: 0033:0x7f24b6cc5995 Sep 11
>>> 13:08:51 drs1p002 kernel: Code: f9 e4 0c 00 64 c7 00 16 00 00 00 b8
>>> ff ff ff ff c3 0f 1f 40 00 83 ff 01 48 89 f0 77 30 48 89 c7 48 89 d6
>>> b8
>>> 06 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 03 f3 c3 90 48 8b 15 c1 e4
>>> 0c
>>> 00 f7 d8 64 89 Sep 11 13:08:51 drs1p002 kernel: RSP:
>>> 002b:00007f2434e20388 EFLAGS: 00000246 ORIG_RAX: 0000000000000006 Sep
>>> 11 13:08:51 drs1p002 kernel: RAX: ffffffffffffffda RBX:
>>> 00007f2434e20390 RCX: 00007f24b6cc5995 Sep 11 13:08:51 drs1p002
>>> kernel: RDX: 00007f2434e20390 RSI: 00007f2434e20390 RDI:
>>> 00007f24640dd9d0 Sep 11 13:08:51 drs1p002 kernel: RBP:
>>> 00007f2434e20450 R08: 0000000000000000 R09: 0000000000000800 Sep 11
>>> 13:08:51 drs1p002 kernel: R10: 00007f24a2bcec15 R11: 0000000000000246
>>> R12: 00007f24640dd9d0 Sep 11 13:08:51 drs1p002 kernel: R13:
>>> 00007f24181d29e0 R14: 00007f2434e20468 R15: 00007f24181d2800 Sep 11
>>> 13:08:51 drs1p002 kernel: Modules linked in: tcp_diag inet_diag
>>> unix_diag ocfs2 quota_tree ocfs2_dlmfs ocfs2_stack_o2cb ocfs2_dlm
>>> ocfs2_nodemanager ocfs2_stackglue configfs iptable_filter fuse
>>> snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic
>>> nls_ascii nls_cp437 intel_rapl x86_pkg_temp_thermal intel_powerclamp
>>> vfat coretemp fat kvm_intel iTCO_wdt iTCO_vendor_support evdev kvm
>>> irqbypass crct10dif_pclmul crc32_pclmul i915 snd_hda_intel dcdbas
>>> ghash_clmulni_intel efi_pstore snd_hda_codec intel_cstate
>>> intel_uncore intel_rapl_perf snd_hda_core snd_hwdep snd_pcm mei_me
>>> drm_kms_helper snd_timer snd soundcore pcspkr serio_raw efivars drm
>>> mei lpc_ich i2c_algo_bit sg ie31200_edac video pcc_cpufreq button
>>> drbd lru_cache libcrc32c parport_pc sunrpc ppdev lp parport efivarfs
>>> ip_tables x_tables autofs4 ext4 crc16 Sep 11 13:08:51 drs1p002
>>> kernel:  mbcache
>>> jbd2 crc32c_generic fscrypto ecb crypto_simd cryptd glue_helper
>>> aes_x86_64 dm_mod sr_mod cdrom sd_mod crc32c_intel ahci i2c_i801
>>> libahci xhci_pci ehci_pci libata xhci_hcd ehci_hcd psmouse scsi_mod
>>> usbcore e1000e usb_common thermal Sep 11 13:08:51 drs1p002 kernel:
>>> ---[ end trace feba92ba6e432478 ]--- Sep 11 13:08:51 drs1p002 kernel:
>>> RIP: 0010:__ocfs2_cluster_unlock.isra.39+0x9c/0xb0 [ocfs2] Sep 11
>>> 13:08:51 drs1p002 kernel: Code: 89 ef 48 89 c6 5b 5d 41 5c 41 5d e9
>>> 6e
>>> 12 50 cc 8b 53 68 85 d2 74 13 83 ea 01 89 53 68 eb b1 8b 53 6c 85 d2
>>> 74 c5 eb d3 0f 0b <0f> 0b 0f 0b 0f 0b 0f 0b 66 66 2e 0f 1f 84 00 00
>>> 00
>>> 00 00 90 0f 1f Sep 11 13:08:51 drs1p002 kernel: RSP:
>>> 0018:ffffb1248eeb3af8 EFLAGS: 00010046 Sep 11 13:08:51 drs1p002
>>> kernel: RAX: 0000000000000292 RBX: ffff95cdbd985a18 RCX:
>>> 0000000000000100 Sep 11 13:08:51 drs1p002 kernel: RDX:
>>> 0000000000000000 RSI: 0000000000000000 RDI: ffff95cdbd985a94 Sep 11
>>> 13:08:51 drs1p002 kernel: RBP: ffff95cdbd985a94 R08: 0000000000000000
>>> R09: 000000000000aa47 Sep 11 13:08:51 drs1p002 kernel: R10:
>>> ffffb1248eeb3ae0 R11: 0000000000000002 R12: 0000000000000003 Sep 11
>>> 13:08:51 drs1p002 kernel: R13: ffff95ce87dfe000 R14: 0000000000000000
>>> R15: ffffffffc0ab3240 Sep 11 13:08:51 drs1p002 kernel: FS:
>>> 00007f2434e21700(0000) GS:ffff95ce9e200000(0000)
>>> knlGS:0000000000000000 Sep 11 13:08:51 drs1p002 kernel: CS:  0010 DS:
>>> 0000 ES: 0000 CR0: 0000000080050033 Sep 11 13:08:51 drs1p002 kernel:
>>> CR2: 00007f01eaa48000 CR3: 000000003dd86001 CR4: 00000000001606f0
>>>
>>>
>>> All I can say is that I was excessively using GIT when this happened (In eclipse, synchronizing GIT workspace). It took me around 30 minutes to see the bug again.
>>>
>>> Regards,
>>>
>>> Daniel
>>>
>>> -----Original Message-----
>>> From: Larry Chen <lchen@suse.com>
>>> Sent: Mittwoch, 18. Juli 2018 10:09
>>> To: Daniel Sobe <daniel.sobe@nxp.com>; ocfs2-devel at oss.oracle.com
>>> Subject: Re: [Ocfs2-devel] OCFS2 BUG with 2 different kernels
>>>
>>> Hi Daniel,
>>>
>>> Which stack do you use? dlm or o2cb??
>>>
>>> I tried to reproduce the bug.
>>>
>>> I have set up 2 virtual machines that share one block device(as a qcow2 file on host). And I was using dlm stack instead of o2cb. Kernel version is 4.12.14. I clone linux kernel tree from github and execute the following shell script.
>>>
>>> #! /bin/bash
>>> for i in $(git tag)
>>> do
>>>             echo $i
>>>             git checkout $i
>>> done
>>>
>>> Bug could not be reproduced.
>>>
>>> According to the back trace, I think the bug is caused by the logic of holding a lock.
>>>
>>> If possible, I think the bug will recur, even without drdb, lvm or other components.
>>>
>>> Regards,
>>> Larry
>>>
>>> On 07/17/2018 04:11 PM, Daniel Sobe wrote:
>>>> Hi Larry,
>>>>
>>>> I think that with the most recent crash, I have a pretty simple environment already. All it takes is an OCFS2 formatted /home volume and a GIT repository on that volume, which generates a lot of disk IO upon "git checkout" to switch branches. VMs or containers are no longer involved.
>>>>
>>>> The only additional simplification that I can think of are the layers on top of the SSD. Currently I have:
>>>>
>>>> SSD partition --> LVM2 --> LVM volumes --> DRBD --> OCFS2
>>>>
>>>> I can easily remove the DRBD layer. Removing LVM will be more difficult, but possible. Do you think any of these make sense to try?
>>>>
>>>> Regards,
>>>>
>>>> Daniel
>>>>
>>>>
>>>> -----Original Message-----
>>>> From: Larry Chen [mailto:lchen at suse.com]
>>>> Sent: Dienstag, 17. Juli 2018 04:54
>>>> To: Daniel Sobe <daniel.sobe@nxp.com>; ocfs2-devel at oss.oracle.com
>>>> Subject: Re: [Ocfs2-devel] OCFS2 BUG with 2 different kernels
>>>>
>>>> Hi Daniel,
>>>>
>>>> Could you please simplify your environment?
>>>> Can I use several virtual machines to reproduce the bug??
>>>>
>>>> Thanks
>>>> Larry
>>>>
>>>> On 07/16/2018 07:49 PM, Daniel Sobe wrote:
>>>>> Hi,
>>>>>
>>>>> the same issue happens with 4.17.6 kernel from Debian unstable.
>>>>>
>>>>> This time no namespaces were involved, so it is now confirmed that the issue is not related to namespaces, containers and such.
>>>>>
>>>>> All I did was to again run "git checkout" on a git repository that is placed on an OCFS2 volume.
>>>>>
>>>>> After the issue occurs, I have ~ 2 mins before the system becomes unusable. Anything I can do during that time to aid debugging? I don't know what else to try to help fix this issue.
>>>>>
>>>>> Regards,
>>>>>
>>>>> Daniel
>>>>>
>>>>>
>>>>> Jul 16 13:40:24 drs1p002 kernel: ------------[ cut here
>>>>> ]------------ Jul 16 13:40:24 drs1p002 kernel: kernel BUG at /build/linux-fVnMBb/linux-4.17.6/fs/ocfs2/dlmglue.c:848!
>>>>> Jul 16 13:40:24 drs1p002 kernel: invalid opcode: 0000 [#1] SMP PTI
>>>>> Jul
>>>>> 16 13:40:24 drs1p002 kernel: Modules linked in: tcp_diag inet_diag
>>>>> unix_diag ocfs2 quota_tree ocfs2_dlmfs ocfs2_stack_o2cb ocfs2_dlm
>>>>> ocfs2_nodemanager oc Jul 16 13:40:24 drs1p002 kernel:  jbd2
>>>>> crc32c_generic fscrypto ecb crypto_simd cryptd glue_helper
>>>>> aes_x86_64 dm_mod sr_mod cdrom sd_mod i2c_i801 ahci libahci Jul 16
>>>>> 13:40:24
>>>>> drs1p002 kernel: CPU: 1 PID: 22459 Comm: git Not tainted
>>>>> 4.17.0-1-amd64 #1 Debian 4.17.6-1 Jul 16 13:40:24 drs1p002 kernel:
>>>>> Hardware name: Dell Inc. OptiPlex 7010/0WR7PY, BIOS A18 04/30/2014
>>>>> Jul
>>>>> 16 13:40:24 drs1p002 kernel: RIP:
>>>>> 0010:__ocfs2_cluster_unlock.isra.39+0x9c/0xb0 [ocfs2] Jul 16
>>>>> 13:40:24
>>>>> drs1p002 kernel: RSP: 0018:ffff9e57887dfaf8 EFLAGS: 00010046 Jul 16
>>>>> 13:40:24 drs1p002 kernel: RAX: 0000000000000292 RBX:
>>>>> ffff92559ee9f018
>>>>> RCX: 00000000000501e7 Jul 16 13:40:24 drs1p002 kernel: RDX:
>>>>> 0000000000000000 RSI: ffff92559ee9f018 RDI: ffff92559ee9f094 Jul 16
>>>>> 13:40:24 drs1p002 kernel: RBP: ffff92559ee9f094 R08: 0000000000000000 R09: 0000000000008763 Jul 16 13:40:24 drs1p002 kernel: R10: ffff9e57887dfae0 R11: 0000000000000010 R12: 0000000000000003 Jul 16 13:40:24 drs1p002 kernel: R13: ffff9256127d6000 R14: 0000000000000000 R15: ffffffffc0d35200 Jul 16 13:40:24 drs1p002 kernel: FS:  00007f0ce8ff9700(0000) GS:ffff92561e280000(0000) knlGS:0000000000000000 Jul 16 13:40:24 drs1p002 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033 Jul 16 13:40:24 drs1p002 kernel: CR2: 00007f0cac000010 CR3: 000000009ef52006 CR4: 00000000001606e0 Jul 16 13:40:24 drs1p002 kernel: Call Trace:
>>>>> Jul 16 13:40:24 drs1p002 kernel:  ? ocfs2_dentry_unlock+0x35/0x80
>>>>> [ocfs2] Jul 16 13:40:24 drs1p002 kernel:
>>>>> ocfs2_dentry_attach_lock+0x245/0x420 [ocfs2] Jul 16 13:40:24
>>>>> drs1p002
>>>>> kernel:  ? d_splice_alias+0x2a5/0x410 Jul 16 13:40:24 drs1p002 kernel:
>>>>> ocfs2_lookup+0x233/0x2c0 [ocfs2] Jul 16 13:40:24 drs1p002 kernel:
>>>>> __lookup_slow+0x97/0x150 Jul 16 13:40:24 drs1p002 kernel:
>>>>> lookup_slow+0x35/0x50 Jul 16 13:40:24 drs1p002 kernel:
>>>>> walk_component+0x1c4/0x470 Jul 16 13:40:24 drs1p002 kernel:  ?
>>>>> link_path_walk+0x27c/0x510 Jul 16 13:40:24 drs1p002 kernel:  ?
>>>>> ktime_get+0x3e/0xa0 Jul 16 13:40:24 drs1p002 kernel:
>>>>> path_lookupat+0x84/0x1f0 Jul 16 13:40:24 drs1p002 kernel:
>>>>> filename_lookup+0xb6/0x190 Jul 16 13:40:24 drs1p002 kernel:  ?
>>>>> ocfs2_inode_unlock+0xe4/0xf0 [ocfs2] Jul 16 13:40:24 drs1p002 kernel:
>>>>> ? __check_object_size+0xa7/0x1a0 Jul 16 13:40:24 drs1p002 kernel:  ?
>>>>> strncpy_from_user+0x48/0x160 Jul 16 13:40:24 drs1p002 kernel:  ?
>>>>> getname_flags+0x6a/0x1e0 Jul 16 13:40:24 drs1p002 kernel:  ?
>>>>> vfs_statx+0x73/0xe0 Jul 16 13:40:24 drs1p002 kernel:
>>>>> vfs_statx+0x73/0xe0 Jul 16 13:40:24 drs1p002 kernel:
>>>>> __do_sys_newlstat+0x39/0x70 Jul 16 13:40:24 drs1p002 kernel:
>>>>> do_syscall_64+0x55/0x110 Jul 16 13:40:24 drs1p002 kernel:
>>>>> entry_SYSCALL_64_after_hwframe+0x44/0xa9
>>>>> Jul 16 13:40:24 drs1p002 kernel: RIP: 0033:0x7f0cf43ac995 Jul 16
>>>>> 13:40:24 drs1p002 kernel: RSP: 002b:00007f0ce8ff8cb8 EFLAGS:
>>>>> 00000246
>>>>> ORIG_RAX: 0000000000000006 Jul 16 13:40:24 drs1p002 kernel: RAX:
>>>>> ffffffffffffffda RBX: 00007f0ce8ff8df0 RCX: 00007f0cf43ac995 Jul 16
>>>>> 13:40:24 drs1p002 kernel: RDX: 00007f0ce8ff8ce0 RSI:
>>>>> 00007f0ce8ff8ce0
>>>>> RDI: 00007f0cb0000b20 Jul 16 13:40:24 drs1p002 kernel: RBP:
>>>>> 0000000000000017 R08: 0000000000000003 R09: 0000000000000000 Jul 16
>>>>> 13:40:24 drs1p002 kernel: R10: 0000000000000000 R11:
>>>>> 0000000000000246
>>>>> R12: 00007f0ce8ff8dc4 Jul 16 13:40:24 drs1p002 kernel: R13:
>>>>> 0000000000000008 R14: 00005573fd0aa758 R15: 0000000000000005 Jul 16
>>>>> 13:40:24 drs1p002 kernel: Code: 48 89 ef 48 89 c6 5b 5d 41 5c 41 5d
>>>>> e9 2e 3c a6 dc 8b 53 68 85 d2 74 13 83 ea 01 89 53 68 eb b1 8b 53
>>>>> 6c
>>>>> 85
>>>>> d2 74 c5 e Jul 16 13:40:24 drs1p002 kernel: RIP:
>>>>> __ocfs2_cluster_unlock.isra.39+0x9c/0xb0 [ocfs2] RSP:
>>>>> ffff9e57887dfaf8 Jul 16 13:40:24 drs1p002 kernel: ---[ end trace
>>>>> a5a84fa62e77df42 ]---
>>>>>
>>>>> -----Original Message-----
>>>>> From: ocfs2-devel-bounces at oss.oracle.com
>>>>> [mailto:ocfs2-devel-bounces at oss.oracle.com] On Behalf Of Daniel
>>>>> Sobe
>>>>> Sent: Freitag, 13. Juli 2018 13:56
>>>>> To: Larry Chen <lchen@suse.com>; ocfs2-devel at oss.oracle.com
>>>>> Subject: Re: [Ocfs2-devel] OCFS2 BUG with 2 different kernels
>>>>>
>>>>> Hi Larry,
>>>>>
>>>>> I'm running a playground with 3 Dell PCs with Intel CPUs, standard consumer hardware. All 3 disks are SSD and partitioned with LVM. I have added 2 logical volumes on each system, and set up a 3-way replication using DRBD (on a separate local network). I'm still using DRBB 8 as it is shipped with Debian 9. 2 of those PCs are set up for the "stacked primary" volumes, on which I have created the OCFS2 volumes, as cluster of 2 nodes, using the same private network as DRDB does. Heartbeat is local (I guess since I did not change the default and did not do anything explicitly).
>>>>>
>>>>> Again I was using a LXC container for remote X via X2go. Inside the X session I opened a terminal and was compiling some code with "make -j" on my OCFS2 home directory. The next crash I reported was while doing "git checkout", triggering a lot of change in workspace files.
>>>>>
>>>>> Next I will be using kernel 4.17.6 now as it was recently packed for Debian unstable. Additionally I will work on the PC directly, to exclude that the issue is related to namespaces, control groups and what else that is only present in a container.
>>>>>
>>>>> Regards,
>>>>>
>>>>> Daniel
>>>>>
>>>>> -----Original Message-----
>>>>> From: Larry Chen [mailto:lchen at suse.com]
>>>>> Sent: Freitag, 13. Juli 2018 11:49
>>>>> To: Daniel Sobe <daniel.sobe@nxp.com>; ocfs2-devel at oss.oracle.com
>>>>> Subject: Re: [Ocfs2-devel] OCFS2 BUG with 2 different kernels
>>>>>
>>>>> Hi Daniel,
>>>>>
>>>>> Thanks for your effort to reproduce the bug.
>>>>> I can confirm that there exist more than one bug.
>>>>> I'll focus on this interesting issue.
>>>>>
>>>>>
>>>>> On 07/12/2018 10:24 PM, Daniel Sobe wrote:
>>>>>> Hi Larry,
>>>>>>
>>>>>> sorry for not responding any earlier. It took me quite a while to reproduce the issue on a "playground" installation. Here's todays kernel BUG log:
>>>>>>
>>>>>> Jul 12 15:29:08 drs1p001 kernel: [1300619.423826] ------------[
>>>>>> cut here ]------------ Jul 12 15:29:08 drs1p001 kernel: [1300619.423827] kernel BUG at /build/linux-6BBPzq/linux-4.16.5/fs/ocfs2/dlmglue.c:848!
>>>>>> Jul 12 15:29:08 drs1p001 kernel: [1300619.423835] invalid opcode:
>>>>>> 0000 [#1] SMP PTI Jul 12 15:29:08 drs1p001 kernel:
>>>>>> [1300619.423836] Modules linked in: btrfs zstd_compress zstd_decompress xxhash xor raid6_pq ufs qnx4 hfsplus hfs minix ntfs vfat msdos fat jfs xfs tcp_diag inet_diag unix_diag appletalk ax25 ipx(C) p8023 p8022 psnap veth ocfs2 quota_tree ocfs2_dlmfs ocfs2_stack_o2cb ocfs2_dlm ocfs2_nodemanager ocfs2_stackglue configfs bridge stp llc iptable_filter fuse snd_hda_codec_hdmi rfkill intel_rapl x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel snd_hda_codec_realtek snd_hda_codec_generic kvm snd_hda_intel dell_wmi dell_smbios sparse_keymap irqbypass snd_hda_codec wmi_bmof dell_wmi_descriptor crct10dif_pclmul evdev crc32_pclmul i915 dcdbas snd_hda_core ghash_clmulni_intel intel_cstate snd_hwdep drm_kms_helper snd_pcm intel_uncore intel_rapl_perf snd_timer drm snd serio_raw pcspkr mei_me iTCO_wdt i2c_algo_bit Jul 12 15:29:08 drs1p001 kernel: [1300619.423870]  soundcore iTCO_vendor_support mei shpchp sg intel_pch_thermal wmi video acpi_pad button drbd lru_cache libcrc32c ip_tables x_tables autofs4 ext4 crc16 mbcache jbd2 crc32c_generic fscrypto ecb dm_mod sr_mod cdrom sd_mod crc32c_intel aesni_intel aes_x86_64 crypto_simd cryptd glue_helper psmouse ahci libahci xhci_pci libata e1000e xhci_hcd i2c_i801 e1000 scsi_mod usbcore usb_common fan thermal [last unloaded: configfs]
>>>>>> Jul 12 15:29:08 drs1p001 kernel: [1300619.423892] CPU: 2 PID: 13603 Comm: cc1 Tainted: G         C       4.16.0-0.bpo.1-amd64 #1 Debian 4.16.5-1~bpo9+1
>>>>>> Jul 12 15:29:08 drs1p001 kernel: [1300619.423894] Hardware name:
>>>>>> Dell Inc. OptiPlex 5040/0R790T, BIOS 1.2.7 01/15/2016 Jul 12
>>>>>> 15:29:08
>>>>>> drs1p001 kernel: [1300619.423923] RIP:
>>>>>> 0010:__ocfs2_cluster_unlock.isra.36+0x9d/0xb0 [ocfs2] Jul 12
>>>>>> 15:29:08
>>>>>> drs1p001 kernel: [1300619.423925] RSP: 0018:ffffb14b4a133b10 EFLAGS:
>>>>>> 00010046 Jul 12 15:29:08 drs1p001 kernel: [1300619.423927] RAX:
>>>>>> 0000000000000282 RBX: ffff9d269d990018 RCX: 0000000000000000 Jul
>>>>>> 12
>>>>>> 15:29:08 drs1p001 kernel: [1300619.423929] RDX: 0000000000000000 RSI:
>>>>>> ffff9d269d990018 RDI: ffff9d269d990094 Jul 12 15:29:08 drs1p001
>>>>>> kernel: [1300619.423931] RBP: 0000000000000003 R08:
>>>>>> 000062d940000000
>>>>>> R09: 000000000000036a Jul 12 15:29:08 drs1p001 kernel:
>>>>>> [1300619.423933] R10: ffffb14b4a133af8 R11: 0000000000000068 R12:
>>>>>> ffff9d269d990094 Jul 12 15:29:08 drs1p001 kernel: [1300619.423934]
>>>>>> R13: ffff9d2882baa000 R14: 0000000000000000 R15: ffffffffc0bf3940 Jul 12 15:29:08 drs1p001 kernel: [1300619.423936] FS:  0000000000000000(0000) GS:ffff9d2899d00000(0063) knlGS:00000000f7c99d00 Jul 12 15:29:08 drs1p001 kernel: [1300619.423938] CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033 Jul 12 15:29:08 drs1p001 kernel: [1300619.423940] CR2: 00007ff9c7f3e8dc CR3: 00000001725f0002 CR4: 00000000003606e0 Jul 12 15:29:08 drs1p001 kernel: [1300619.423942] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000 Jul 12 15:29:08 drs1p001 kernel: [1300619.423944] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400 Jul 12 15:29:08 drs1p001 kernel: [1300619.423945] Call Trace:
>>>>>> Jul 12 15:29:08 drs1p001 kernel: [1300619.423958]  ?
>>>>>> ocfs2_dentry_unlock+0x35/0x80 [ocfs2] Jul 12 15:29:08 drs1p001 kernel:
>>>>>> [1300619.423969]  ocfs2_dentry_attach_lock+0x2cb/0x420 [ocfs2]
>>>>> Here is caused by ocfs2_dentry_lock failed.
>>>>> I'll fix it by prevent ocfs2 from calling ocfs2_dentry_unlock on the failure of ocfs2_dentry_lock.
>>>>>
>>>>> But why it failed still confuses me.
>>>>>
>>>>>
>>>>>> Jul 12 15:29:08 drs1p001 kernel: [1300619.423981]
>>>>>> ocfs2_lookup+0x199/0x2e0 [ocfs2] Jul 12 15:29:08 drs1p001 kernel:
>>>>>> [1300619.423986]  ? _cond_resched+0x16/0x40 Jul 12 15:29:08
>>>>>> drs1p001
>>>>>> kernel: [1300619.423989]  lookup_slow+0xa9/0x170 Jul 12 15:29:08
>>>>>> drs1p001 kernel: [1300619.423991]  walk_component+0x1c6/0x350 Jul
>>>>>> 12
>>>>>> 15:29:08 drs1p001 kernel: [1300619.423993]  ?
>>>>>> path_init+0x1bd/0x300 Jul 12 15:29:08 drs1p001 kernel:
>>>>>> [1300619.423995]
>>>>>> path_lookupat+0x73/0x220 Jul 12 15:29:08 drs1p001 kernel:
>>>>>> [1300619.423998]  ? ___bpf_prog_run+0xba7/0x1260 Jul 12 15:29:08
>>>>>> drs1p001 kernel: [1300619.424000]  filename_lookup+0xb8/0x1a0 Jul
>>>>>> 12
>>>>>> 15:29:08 drs1p001 kernel: [1300619.424003]  ?
>>>>>> seccomp_run_filters+0x58/0xb0 Jul 12 15:29:08 drs1p001 kernel:
>>>>>> [1300619.424005]  ? __check_object_size+0x98/0x1a0 Jul 12 15:29:08
>>>>>> drs1p001 kernel: [1300619.424008]  ? strncpy_from_user+0x48/0x160
>>>>>> Jul
>>>>>> 12 15:29:08 drs1p001 kernel: [1300619.424010]  ?
>>>>>> vfs_statx+0x73/0xe0 Jul 12 15:29:08 drs1p001 kernel:
>>>>>> [1300619.424012]
>>>>>> vfs_statx+0x73/0xe0 Jul 12 15:29:08 drs1p001 kernel:
>>>>>> [1300619.424015]
>>>>>> C_SYSC_x86_stat64+0x39/0x70 Jul 12 15:29:08 drs1p001 kernel:
>>>>>> [1300619.424018]  ? syscall_trace_enter+0x117/0x2c0 Jul 12
>>>>>> 15:29:08
>>>>>> drs1p001 kernel: [1300619.424020]  do_fast_syscall_32+0xab/0x1f0
>>>>>> Jul
>>>>>> 12 15:29:08 drs1p001 kernel: [1300619.424022]
>>>>>> entry_SYSENTER_compat+0x7f/0x8e Jul 12 15:29:08 drs1p001 kernel:
>>>>>> [1300619.424025] Code: 89 c6 5b 5d 41 5c 41 5d e9 a1 77 78 db 0f
>>>>>> 0b 8b
>>>>>> 53 68 85 d2 74 15 83 ea 01 89 53 68 eb af 8b 53 6c 85 d2 74 c3 eb
>>>>>> d1 0f 0b 0f 0b <0f> 0b 0f 0b 0f 1f 44 00 00 66 2e 0f 1f 84 00 00
>>>>>> 00
>>>>>> 00
>>>>>> 00 0f 1f Jul 12 15:29:08 drs1p001 kernel: [1300619.424055] RIP:
>>>>>> __ocfs2_cluster_unlock.isra.36+0x9d/0xb0 [ocfs2] RSP:
>>>>>> ffffb14b4a133b10 Jul 12 15:29:08 drs1p001 kernel: [1300619.424057]
>>>>>> ---[ end trace aea789961795b75f ]--- Jul 12 15:29:08 drs1p001 kernel:
>>>>>> [1300628.967649] ------------[ cut here ]------------
>>>>>>
>>>>>> As this occurred while compiling C code with "-j" I think we were on the wrong track, it is not about mount sharing, but rather a multicore issue. That would be in line with the other report that I found (I referenced it when I was reporting my issue), who claimed the issue went away after he restricted to 1 active CPU core.
>>>>>>
>>>>>> Unfortunately I could not do much with the machine afterwards. Probably the OCFS2 mechanism to reboot the node if the local heartbeat isn't updated anymore kicked in, so there was no way I could have SSHed in and run some debugging.
>>>>>>
>>>>>> I have now updated to the kernel Debian package of 4.16.16 backported for Debian 9. I guess I will hit the bug again and let you know.
>>>>>>
>>>>>> Regards,
>>>>>>
>>>>>> Daniel
>>>>>>
>>>>>>
>>>>>> -----Original Message-----
>>>>>> From: Larry Chen [mailto:lchen at suse.com]
>>>>>> Sent: Freitag, 11. Mai 2018 09:01
>>>>>> To: Daniel Sobe <daniel.sobe@nxp.com>; ocfs2-devel at oss.oracle.com
>>>>>> Subject: Re: [Ocfs2-devel] OCFS2 BUG with 2 different kernels
>>>>>>
>>>>>> Hi Daniel,
>>>>>>
>>>>>> On 04/12/2018 08:20 PM, Daniel Sobe wrote:
>>>>>>> Hi Larry,
>>>>>>>
>>>>>>> this is, in a nutshell, what I do to create a LXC container as "ordinary user":
>>>>>>>
>>>>>>> * Install the LXC packages from the distribution
>>>>>>> * run the command "lxc-create -n test1 -t download"
>>>>>>> ** first run might prompt you to generate a
>>>>>>> ~/.config/lxc/default.conf to define UID mappings
>>>>>>> ** in a corporate environment it might be tricky to set the
>>>>>>> http_proxy (and maybe even https_proxy) environment variables
>>>>>>> correctly
>>>>>>> ** once the list of images is shown, select for instance "debian" "jessie" "amd64"
>>>>>>> * the container downloads to ~/.local/share/lxc/
>>>>>>> * adapt the "config" file in that directory to add the shared
>>>>>>> ocfs2 mount like in my example below
>>>>>>> * if you're lucky, then "lxc-start -d -n test1" already works, which you can confirm by "lxc-ls --fancy", and attach to the container with "lxc-attach -n test1"
>>>>>>> ** if you want to finally enable networking, most distributions
>>>>>>> arrange a dedicated bridge (lxcbr0) which you can configure
>>>>>>> similar to my example below
>>>>>>> ** in my case I had to install cgroup related tools and reboot to
>>>>>>> have all cgroups available, and to allow use of lxcbr0 bridge in
>>>>>>> /etc/lxc/lxc-usernet
>>>>>>>
>>>>>>> Now if you access the mount-shared OCFS2 file system from with several containers, the bug will (hopefully) trigger on your side as well. I don't know the conditions under which this will occur, unfortunately.
>>>>>>>
>>>>>>> Regards,
>>>>>>>
>>>>>>> Daniel
>>>>>>>
>>>>>>>
>>>>>>> -----Original Message-----
>>>>>>> From: Larry Chen [mailto:lchen at suse.com]
>>>>>>> Sent: Donnerstag, 12. April 2018 11:20
>>>>>>> To: Daniel Sobe <daniel.sobe@nxp.com>
>>>>>>> Subject: Re: [Ocfs2-devel] OCFS2 BUG with 2 different kernels
>>>>>>>
>>>>>>> Hi Daniel,
>>>>>>>
>>>>>>> Quite an interesting issue.
>>>>>>>
>>>>>>> I'm not familiar with lxc tools, so it may take some time to reproduce it.
>>>>>>>
>>>>>>> Do you have a script to build up your lxc environment?
>>>>>>> Because I want to make sure that my environment is quite the same as yours.
>>>>>>>
>>>>>>> Thanks,
>>>>>>> Larry
>>>>>>>
>>>>>>>
>>>>>>> On 04/12/2018 03:45 PM, Daniel Sobe wrote:
>>>>>>>> Hi Larry,
>>>>>>>>
>>>>>>>> not sure if it helps, the issue wasn't there with Debian 8 and
>>>>>>>> kernel
>>>>>>>> 3.16 - but that's a long history. Unfortunately, the only
>>>>>>>> machine where I could try to bisect, does not run any kernel <
>>>>>>>> 4.16 without other issues ?
>>>>>>>>
>>>>>>>> Regards,
>>>>>>>>
>>>>>>>> Daniel
>>>>>>>>
>>>>>>>>
>>>>>>>> -----Original Message-----
>>>>>>>> From: Larry Chen [mailto:lchen at suse.com]
>>>>>>>> Sent: Donnerstag, 12. April 2018 05:17
>>>>>>>> To: Daniel Sobe <daniel.sobe@nxp.com>;
>>>>>>>> ocfs2-devel at oss.oracle.com
>>>>>>>> Subject: Re: [Ocfs2-devel] OCFS2 BUG with 2 different kernels
>>>>>>>>
>>>>>>>> Hi Daniel,
>>>>>>>>
>>>>>>>> Thanks for your report.
>>>>>>>> I'll try to reproduce this bug as you did.
>>>>>>>>
>>>>>>>> I'm afraid there may be some bugs on the collaboration of cgroups and ocfs2.
>>>>>>>>
>>>>>>>> Thanks
>>>>>>>> Larry
>>>>>>>>
>>>>>>>>
>>>>>>>> On 04/11/2018 08:24 PM, Daniel Sobe wrote:
>>>>>>>>> Hi Larry,
>>>>>>>>>
>>>>>>>>> below is an example config file like I use it for LXC containers. I followed the instructions (https://eur01.safelinks.protection.outlook.com/?url=https%3A%2F%2Furldefense.proofpoint.com%2Fv2%2Furl%3Fu%3Dhttps-3A__emea01.safelinks.protection.outlook.com_-3Furl-3Dhttps-253A-252F-252Fwiki.debian.org-252FLXC-26data-3D02-257C01-257Cdaniel.sobe-2540nxp.com-257C11fd4f062e694faa287a08d5a023f22b-257C686ea1d3bc2b4c6fa92cd99c5c301635-257C0-257C0-257C636590998614059943-26sdata-3DZSqSTx3Vjxy-252FbfKrXdIVGvUqieRFxVl4FFnr-252FPTGAhc-253D-26reserved-3D0%26d%3DDwIGaQ%26c%3DRoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE%26r%3DC7gAd4uDxlAvTdc0vmU6X8CMk6L2iDY8-HD0qT6Fo7Y%26m%3DVTW6gNWhTVlF5KmjZv2fMhm45jgdtPllvAbYDQ0PNYA%26s%3DtGYkPHaAU3tSeeEGrlORRLY9rDQAl6YdYtD0RJ7HBHw%26e&amp;data=02%7C01%7Cdaniel.sobe%40nxp.com%7C2fb7269bdec843a53cf208d6b2316ba1%7C686ea1d3bc2b4c6fa92cd99c5c301635%7C0%7C0%7C636892322672178859&amp;sdata=HDAUYJtjsBxfhYI5XZ8Y8F0daAwFtAn8bMRs4LNc1u4%3D&amp;reserved=0=) and downloaded a Debian 8 container as user (unprivileged) and adapted the config file. Several of those containers run on one host and share the OCFS2 directory as you can see at the "lxc.mount.entry" line.
>>>>>>>>>
>>>>>>>>> Meanwhile I'm trying whether the problem can be reproduced with shared mounts in one namespace, as you suggested. So far with no success, will report once anything happens.
>>>>>>>>>
>>>>>>>>> Regards,
>>>>>>>>>
>>>>>>>>> Daniel
>>>>>>>>>
>>>>>>>>> ----
>>>>>>>>>
>>>>>>>>> # Distribution configuration
>>>>>>>>> lxc.include = /usr/share/lxc/config/debian.common.conf
>>>>>>>>> lxc.include = /usr/share/lxc/config/debian.userns.conf
>>>>>>>>> lxc.arch = x86_64
>>>>>>>>>
>>>>>>>>> # Container specific configuration lxc.id_map = u 0 624288
>>>>>>>>> 65536 lxc.id_map = g 0 624288 65536
>>>>>>>>>
>>>>>>>>> lxc.utsname = container1
>>>>>>>>> lxc.rootfs = /storage/uvirtuals/unpriv/container1/rootfs
>>>>>>>>>
>>>>>>>>> lxc.network.type = veth
>>>>>>>>> lxc.network.flags = up
>>>>>>>>> lxc.network.link = bridge1
>>>>>>>>> lxc.network.name = eth0
>>>>>>>>> lxc.network.veth.pair = aabbccddeeff
>>>>>>>>> lxc.network.ipv4 = XX.XX.XX.XX/YY lxc.network.ipv4.gateway =
>>>>>>>>> ZZ.ZZ.ZZ.ZZ
>>>>>>>>>
>>>>>>>>> lxc.cgroup.cpuset.cpus = 63-86
>>>>>>>>>
>>>>>>>>> lxc.mount.entry = /storage/ocfs2/sw            sw            none bind 0 0
>>>>>>>>>
>>>>>>>>> lxc.cgroup.memory.limit_in_bytes       = 240G
>>>>>>>>> lxc.cgroup.memory.memsw.limit_in_bytes = 240G
>>>>>>>>>
>>>>>>>>> lxc.include = /usr/share/lxc/config/common.conf.d/00-lxcfs.conf
>>>>>>>>>
>>>>>>>>> ----
>>>>>>>>>
>>>>>>>>>
>>>>>>>>>
>>>>>>>>>
>>>>>>>>> -----Original Message-----
>>>>>>>>> From: Larry Chen [mailto:lchen at suse.com]
>>>>>>>>> Sent: Mittwoch, 11. April 2018 13:31
>>>>>>>>> To: Daniel Sobe <daniel.sobe@nxp.com>;
>>>>>>>>> ocfs2-devel at oss.oracle.com
>>>>>>>>> Subject: Re: [Ocfs2-devel] OCFS2 BUG with 2 different kernels
>>>>>>>>>
>>>>>>>>>
>>>>>>>>>
>>>>>>>>> On 04/11/2018 07:17 PM, Daniel Sobe wrote:
>>>>>>>>>> Hi Larry,
>>>>>>>>>>
>>>>>>>>>> this is what I was doing. The 2nd node, while being "declared" in the cluster.conf, does not exist yet, and thus everything was happening on one node only.
>>>>>>>>>>
>>>>>>>>>> I do not know in detail how LXC does the mount sharing, but I assume it simply calls "mount --bind /original/mount/point /new/mount/point" in a separate namespace (or, somehow unshares the mount from the original namespace afterwards).
>>>>>>>>> I thought of there is a way to share a directory between host and docker container, like
>>>>>>>>>           ?? docker run -v /host/directory:/container/directory -other -options image_name command_to_run That's different from yours.
>>>>>>>>>
>>>>>>>>> How did you setup your lxc or container?
>>>>>>>>>
>>>>>>>>> If you could, show me the procedure, I'll try to reproduce it.
>>>>>>>>>
>>>>>>>>> And by the way, if you get rid of lxc, and just mount ocfs2 on several different mount point of local host, will the problem recur?
>>>>>>>>>
>>>>>>>>> Regards,
>>>>>>>>> Larry
>>>>>>>>>> Regards,
>>>>>>>>>>
>>>>>>>>>> Daniel
>>>>>>>>>>
>>>>>> Sorry for this delayed reply.
>>>>>>
>>>>>> I tried with lxc + ocfs2 in your mount-shared way.
>>>>>>
>>>>>> But I can not reproduce your bugs.
>>>>>>
>>>>>> What I use is opensuse tumbleweed.
>>>>>>
>>>>>> The procedure I try to reproduce your bugs:
>>>>>> 0. set-up ha cluster stack and mount ocfs2 fs on host's /mnt with command
>>>>>>        ?? mount /dev/xxx /mnt
>>>>>>        ?? then it shows
>>>>>>        ?? 207 65 254:16 / /mnt rw,relatime shared:94
>>>>>>        ?? I think this *shared* is what you want. And this mount point will be shared within multiple namespaces.
>>>>>>
>>>>>> 1. Start Virtual Machine Manager.
>>>>>> 2. add a local LXC connection by clicking File ? Add Connection.
>>>>>>        ?? Select LXC (Linux Containers) as the hypervisor and click Connect.
>>>>>> 3. Select the localhost (LXC) connection and click File New Virtual Machine menu.
>>>>>> 4. Activate Application container and click Forward.
>>>>>>        ?? Set the path to the application to be launched. As an example, the field is filled with /bin/sh, which is fine to create a first container.
>>>>>> Click Forward.
>>>>>> 5. Choose the maximum amount of memory and CPUs to allocate to the container. Click Forward.
>>>>>> 6. Type in a name for the container. This name will be used for all virsh commands on the container.
>>>>>>        ?? Click Advanced options. Select the network to connect the container to and click Finish. The container will be created and started. A console will be opened automatically.
>>>>>>
>>>>>> If possible, could you please provide a shell script to show what you did with you mount point.
>>>>>>
>>>>>> Thanks
>>>>>> Larry
>>>>>>
>>>>> _______________________________________________
>>>>> Ocfs2-devel mailing list
>>>>> Ocfs2-devel at oss.oracle.com
>>>>> https://eur01.safelinks.protection.outlook.com/?url=https%3A%2F%2Fu
>>>>> r
>>>>> ldefense.proofpoint.com%2Fv2%2Furl%3Fu%3Dhttps-3A__emea01.safelinks.
>>>>> protection.outlook.com_-3Furl-3Dhttps-253A-252F-252Fos%26d%3DDwIGaQ
>>>>> %
>>>>> 26c%3DRoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE%26r%3DC7gAd4uDxlA
>>>>> v
>>>>> Tdc0vmU6X8CMk6L2iDY8-HD0qT6Fo7Y%26m%3DeDT2dYwkSxcLa1NsepzLRIpUZlkC_
>>>>> N
>>>>> ECl_Qk34Foqvo%26s%3DAiHVWnx-sunWZO4cbXP7v6z6Bw5vegbCZBA-wGNCoqA%26e
>>>>> &
>>>>> amp;data=02%7C01%7Cdaniel.sobe%40nxp.com%7C083d3c6f8d5847b9ba2508d6
>>>>> a
>>>>> bc9b8e4%7C686ea1d3bc2b4c6fa92cd99c5c301635%7C0%7C0%7C63688528022415
>>>>> 8
>>>>> 395&amp;sdata=jU%2FI8ickhjrnOfxrg6pDU5fnTgzrOuhQSxqreDkw5V8%3D&amp;
>>>>> r
>>>>> eserved=0=
>>>>> s
>>>>> .oracle.com%2Fmailman%2Flistinfo%2Focfs2-devel&amp;data=02%7C01%7Cd
>>>>> a
>>>>> n
>>>>> i
>>>>> el.sobe%40nxp.com%7C9befd428db39400d656308d5e8b7b97d%7C686ea1d3bc2b
>>>>> 4
>>>>> c
>>>>> 6
>>>>> fa92cd99c5c301635%7C0%7C0%7C636670798149970770&amp;sdata=dc%2BBrbJT
>>>>> p
>>>>> I
>>>>> R
>>>>> AEs8NHtosqLOejDR1auX9%2FaSFXda0TIo%3D&amp;reserved=0
>>>>>
>>> _______________________________________________
>>> Ocfs2-devel mailing list
>>> Ocfs2-devel at oss.oracle.com
>>> https://eur01.safelinks.protection.outlook.com/?url=https%3A%2F%2Foss.
>>> oracle.com%2Fmailman%2Flistinfo%2Focfs2-devel&amp;data=02%7C01%7Cdani
>>> e
>>> l.sobe%40nxp.com%7C083d3c6f8d5847b9ba2508d6abc9b8e4%7C686ea1d3bc2b4c6
>>> f
>>> a92cd99c5c301635%7C0%7C0%7C636885280224158395&amp;sdata=3wHi5VznbDmyn
>>> M
>>> ohhVO5H7mRmkx113SL06BHrfnDIcg%3D&amp;reserved=0
>>
>> _______________________________________________
>> Ocfs2-devel mailing list
>> Ocfs2-devel at oss.oracle.com
>> https://eur01.safelinks.protection.outlook.com/?url=https%3A%2F%2Foss.
>> oracle.com%2Fmailman%2Flistinfo%2Focfs2-devel&amp;data=02%7C01%7Cdanie
>> l.sobe%40nxp.com%7C2fb7269bdec843a53cf208d6b2316ba1%7C686ea1d3bc2b4c6f
>> a92cd99c5c301635%7C0%7C0%7C636892322672188859&amp;sdata=U6zpvh4ISrQDCG
>> LpQuBlQ%2FogBSyiDGmHNSrlVhDc0AY%3D&amp;reserved=0
