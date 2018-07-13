From: Larry Chen <lchen@suse.com>
Date: Fri, 13 Jul 2018 18:06:41 +0800
Subject: [Ocfs2-devel] OCFS2 BUG with 2 different kernels
In-Reply-To: <09ea1b7f-00e0-cbd7-e484-22e6bb956ddd@suse.com>
References: <HE1PR0401MB25389DFE7BFEC86453C3CB21EDBE0@HE1PR0401MB2538.eurprd04.prod.outlook.com>
	<HE1PR0401MB2538AC4F7C387503A082235FEDBD0@HE1PR0401MB2538.eurprd04.prod.outlook.com>
	<cded7750-a411-3bd8-9728-c86e41d37295@suse.com>
	<HE1PR0401MB2538C6A144D96B2B567B1710EDBD0@HE1PR0401MB2538.eurprd04.prod.outlook.com>
	<7a6b0949-d564-8443-c232-b3b76c86b193@suse.com>
	<HE1PR0401MB2538E747C7443019BF22F0FCEDBD0@HE1PR0401MB2538.eurprd04.prod.outlook.com>
	<17d70b73-14d9-ea07-229a-89d17c97df88@suse.com>
	<HE1PR0401MB2538950D0996DD98740B5620EDBC0@HE1PR0401MB2538.eurprd04.prod.outlook.com>
	<8c66f7cd-2de3-ad9e-8ec5-dc6ab934f16a@suse.com>
	<HE1PR0401MB2538AE0195A130AD527C2B31EDBC0@HE1PR0401MB2538.eurprd04.prod.outlook.com>
	<dcd88f8c-7f0f-f232-3c3b-19290128be26@suse.com>
	<DB6PR0402MB2902049BE3B855B334E2DB65ED590@DB6PR0402MB2902.eurprd04.prod.outlook.com>
	<09ea1b7f-00e0-cbd7-e484-22e6bb956ddd@suse.com>
Message-ID: <dd52de0c-013c-8dc9-e1ff-9a6c7b999a9a@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi list,

Some mistake on my previous analysis.

On 07/13/2018 05:48 PM, Larry Chen wrote:
> Hi Daniel,
> 
> Thanks for your effort to reproduce the bug.
> I can confirm that there exist more than one bug.
> I'll focus on this interesting issue.
> 
> 
> On 07/12/2018 10:24 PM, Daniel Sobe wrote:
>> Hi Larry,
>>
>> sorry for not responding any earlier. It took me quite a while to reproduce the issue on a "playground" installation. Here's todays kernel BUG log:
>>
>> Jul 12 15:29:08 drs1p001 kernel: [1300619.423826] ------------[ cut here ]------------
>> Jul 12 15:29:08 drs1p001 kernel: [1300619.423827] kernel BUG at /build/linux-6BBPzq/linux-4.16.5/fs/ocfs2/dlmglue.c:848!
>> Jul 12 15:29:08 drs1p001 kernel: [1300619.423835] invalid opcode: 0000 [#1] SMP PTI
>> Jul 12 15:29:08 drs1p001 kernel: [1300619.423836] Modules linked in: btrfs zstd_compress zstd_decompress xxhash xor raid6_pq ufs qnx4 hfsplus hfs minix ntfs vfat msdos fat jfs xfs tcp_diag inet_diag unix_diag appletalk ax25 ipx(C) p8023 p8022 psnap veth ocfs2 quota_tree ocfs2_dlmfs ocfs2_stack_o2cb ocfs2_dlm ocfs2_nodemanager ocfs2_stackglue configfs bridge stp llc iptable_filter fuse snd_hda_codec_hdmi rfkill intel_rapl x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel snd_hda_codec_realtek snd_hda_codec_generic kvm snd_hda_intel dell_wmi dell_smbios sparse_keymap irqbypass snd_hda_codec wmi_bmof dell_wmi_descriptor crct10dif_pclmul evdev crc32_pclmul i915 dcdbas snd_hda_core ghash_clmulni_intel intel_cstate snd_hwdep drm_kms_helper snd_pcm intel_uncore intel_rapl_perf snd_timer drm snd serio_raw pcspkr mei_me iTCO_wdt i2c_algo_bit
>> Jul 12 15:29:08 drs1p001 kernel: [1300619.423870]  soundcore iTCO_vendor_support mei shpchp sg intel_pch_thermal wmi video acpi_pad button drbd lru_cache libcrc32c ip_tables x_tables autofs4 ext4 crc16 mbcache jbd2 crc32c_generic fscrypto ecb dm_mod sr_mod cdrom sd_mod crc32c_intel aesni_intel aes_x86_64 crypto_simd cryptd glue_helper psmouse ahci libahci xhci_pci libata e1000e xhci_hcd i2c_i801 e1000 scsi_mod usbcore usb_common fan thermal [last unloaded: configfs]
>> Jul 12 15:29:08 drs1p001 kernel: [1300619.423892] CPU: 2 PID: 13603 Comm: cc1 Tainted: G         C       4.16.0-0.bpo.1-amd64 #1 Debian 4.16.5-1~bpo9+1
>> Jul 12 15:29:08 drs1p001 kernel: [1300619.423894] Hardware name: Dell Inc. OptiPlex 5040/0R790T, BIOS 1.2.7 01/15/2016
>> Jul 12 15:29:08 drs1p001 kernel: [1300619.423923] RIP: 0010:__ocfs2_cluster_unlock.isra.36+0x9d/0xb0 [ocfs2]
>> Jul 12 15:29:08 drs1p001 kernel: [1300619.423925] RSP: 0018:ffffb14b4a133b10 EFLAGS: 00010046
>> Jul 12 15:29:08 drs1p001 kernel: [1300619.423927] RAX: 0000000000000282 RBX: ffff9d269d990018 RCX: 0000000000000000
>> Jul 12 15:29:08 drs1p001 kernel: [1300619.423929] RDX: 0000000000000000 RSI: ffff9d269d990018 RDI: ffff9d269d990094
>> Jul 12 15:29:08 drs1p001 kernel: [1300619.423931] RBP: 0000000000000003 R08: 000062d940000000 R09: 000000000000036a
>> Jul 12 15:29:08 drs1p001 kernel: [1300619.423933] R10: ffffb14b4a133af8 R11: 0000000000000068 R12: ffff9d269d990094
>> Jul 12 15:29:08 drs1p001 kernel: [1300619.423934] R13: ffff9d2882baa000 R14: 0000000000000000 R15: ffffffffc0bf3940
>> Jul 12 15:29:08 drs1p001 kernel: [1300619.423936] FS:  0000000000000000(0000) GS:ffff9d2899d00000(0063) knlGS:00000000f7c99d00
>> Jul 12 15:29:08 drs1p001 kernel: [1300619.423938] CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
>> Jul 12 15:29:08 drs1p001 kernel: [1300619.423940] CR2: 00007ff9c7f3e8dc CR3: 00000001725f0002 CR4: 00000000003606e0
>> Jul 12 15:29:08 drs1p001 kernel: [1300619.423942] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> Jul 12 15:29:08 drs1p001 kernel: [1300619.423944] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>> Jul 12 15:29:08 drs1p001 kernel: [1300619.423945] Call Trace:
>> Jul 12 15:29:08 drs1p001 kernel: [1300619.423958]  ? ocfs2_dentry_unlock+0x35/0x80 [ocfs2]
>> Jul 12 15:29:08 drs1p001 kernel: [1300619.423969]  ocfs2_dentry_attach_lock+0x2cb/0x420 [ocfs2]
> 
> Here is caused by ocfs2_dentry_lock failed.
> I'll fix it by prevent ocfs2 from calling ocfs2_dentry_unlock on the
> failure of ocfs2_dentry_lock.
> 
Here maybe ocfs2_dentry_lock has counter-leaking bug.
I'll review the logic of source code.

Regards,
Larry
> But why it failed still confuses me.
> 
> 
>> Jul 12 15:29:08 drs1p001 kernel: [1300619.423981]  ocfs2_lookup+0x199/0x2e0 [ocfs2]
>> Jul 12 15:29:08 drs1p001 kernel: [1300619.423986]  ? _cond_resched+0x16/0x40
>> Jul 12 15:29:08 drs1p001 kernel: [1300619.423989]  lookup_slow+0xa9/0x170
>> Jul 12 15:29:08 drs1p001 kernel: [1300619.423991]  walk_component+0x1c6/0x350
>> Jul 12 15:29:08 drs1p001 kernel: [1300619.423993]  ? path_init+0x1bd/0x300
>> Jul 12 15:29:08 drs1p001 kernel: [1300619.423995]  path_lookupat+0x73/0x220
>> Jul 12 15:29:08 drs1p001 kernel: [1300619.423998]  ? ___bpf_prog_run+0xba7/0x1260
>> Jul 12 15:29:08 drs1p001 kernel: [1300619.424000]  filename_lookup+0xb8/0x1a0
>> Jul 12 15:29:08 drs1p001 kernel: [1300619.424003]  ? seccomp_run_filters+0x58/0xb0
>> Jul 12 15:29:08 drs1p001 kernel: [1300619.424005]  ? __check_object_size+0x98/0x1a0
>> Jul 12 15:29:08 drs1p001 kernel: [1300619.424008]  ? strncpy_from_user+0x48/0x160
>> Jul 12 15:29:08 drs1p001 kernel: [1300619.424010]  ? vfs_statx+0x73/0xe0
>> Jul 12 15:29:08 drs1p001 kernel: [1300619.424012]  vfs_statx+0x73/0xe0
>> Jul 12 15:29:08 drs1p001 kernel: [1300619.424015]  C_SYSC_x86_stat64+0x39/0x70
>> Jul 12 15:29:08 drs1p001 kernel: [1300619.424018]  ? syscall_trace_enter+0x117/0x2c0
>> Jul 12 15:29:08 drs1p001 kernel: [1300619.424020]  do_fast_syscall_32+0xab/0x1f0
>> Jul 12 15:29:08 drs1p001 kernel: [1300619.424022]  entry_SYSENTER_compat+0x7f/0x8e
>> Jul 12 15:29:08 drs1p001 kernel: [1300619.424025] Code: 89 c6 5b 5d 41 5c 41 5d e9 a1 77 78 db 0f 0b 8b 53 68 85 d2 74 15 83 ea 01 89 53 68 eb af 8b 53 6c 85 d2 74 c3 eb d1 0f 0b 0f 0b <0f> 0b 0f 0b 0f 1f 44 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f
>> Jul 12 15:29:08 drs1p001 kernel: [1300619.424055] RIP: __ocfs2_cluster_unlock.isra.36+0x9d/0xb0 [ocfs2] RSP: ffffb14b4a133b10
>> Jul 12 15:29:08 drs1p001 kernel: [1300619.424057] ---[ end trace aea789961795b75f ]---
>> Jul 12 15:29:08 drs1p001 kernel: [1300628.967649] ------------[ cut here ]------------
>>
>> As this occurred while compiling C code with "-j" I think we were on the wrong track, it is not about mount sharing, but rather a multicore issue. That would be in line with the other report that I found (I referenced it when I was reporting my issue), who claimed the issue went away after he restricted to 1 active CPU core.
>>
>> Unfortunately I could not do much with the machine afterwards. Probably the OCFS2 mechanism to reboot the node if the local heartbeat isn't updated anymore kicked in, so there was no way I could have SSHed in and run some debugging.
>>
>> I have now updated to the kernel Debian package of 4.16.16 backported for Debian 9. I guess I will hit the bug again and let you know.
>>
>> Regards,
>>
>> Daniel
>>
>>
>> -----Original Message-----
>> From: Larry Chen [mailto:lchen at suse.com]
>> Sent: Freitag, 11. Mai 2018 09:01
>> To: Daniel Sobe <daniel.sobe@nxp.com>; ocfs2-devel at oss.oracle.com
>> Subject: Re: [Ocfs2-devel] OCFS2 BUG with 2 different kernels
>>
>> Hi Daniel,
>>
>> On 04/12/2018 08:20 PM, Daniel Sobe wrote:
>>> Hi Larry,
>>>
>>> this is, in a nutshell, what I do to create a LXC container as "ordinary user":
>>>
>>> * Install the LXC packages from the distribution
>>> * run the command "lxc-create -n test1 -t download"
>>> ** first run might prompt you to generate a ~/.config/lxc/default.conf
>>> to define UID mappings
>>> ** in a corporate environment it might be tricky to set the http_proxy
>>> (and maybe even https_proxy) environment variables correctly
>>> ** once the list of images is shown, select for instance "debian" "jessie" "amd64"
>>> * the container downloads to ~/.local/share/lxc/
>>> * adapt the "config" file in that directory to add the shared ocfs2
>>> mount like in my example below
>>> * if you're lucky, then "lxc-start -d -n test1" already works, which you can confirm by "lxc-ls --fancy", and attach to the container with "lxc-attach -n test1"
>>> ** if you want to finally enable networking, most distributions
>>> arrange a dedicated bridge (lxcbr0) which you can configure similar to
>>> my example below
>>> ** in my case I had to install cgroup related tools and reboot to have
>>> all cgroups available, and to allow use of lxcbr0 bridge in
>>> /etc/lxc/lxc-usernet
>>>
>>> Now if you access the mount-shared OCFS2 file system from with several containers, the bug will (hopefully) trigger on your side as well. I don't know the conditions under which this will occur, unfortunately.
>>>
>>> Regards,
>>>
>>> Daniel
>>>
>>>
>>> -----Original Message-----
>>> From: Larry Chen [mailto:lchen at suse.com]
>>> Sent: Donnerstag, 12. April 2018 11:20
>>> To: Daniel Sobe <daniel.sobe@nxp.com>
>>> Subject: Re: [Ocfs2-devel] OCFS2 BUG with 2 different kernels
>>>
>>> Hi Daniel,
>>>
>>> Quite an interesting issue.
>>>
>>> I'm not familiar with lxc tools, so it may take some time to reproduce it.
>>>
>>> Do you have a script to build up your lxc environment?
>>> Because I want to make sure that my environment is quite the same as yours.
>>>
>>> Thanks,
>>> Larry
>>>
>>>
>>> On 04/12/2018 03:45 PM, Daniel Sobe wrote:
>>>> Hi Larry,
>>>>
>>>> not sure if it helps, the issue wasn't there with Debian 8 and kernel
>>>> 3.16 - but that's a long history. Unfortunately, the only machine
>>>> where I could try to bisect, does not run any kernel < 4.16 without
>>>> other issues ?
>>>>
>>>> Regards,
>>>>
>>>> Daniel
>>>>
>>>>
>>>> -----Original Message-----
>>>> From: Larry Chen [mailto:lchen at suse.com]
>>>> Sent: Donnerstag, 12. April 2018 05:17
>>>> To: Daniel Sobe <daniel.sobe@nxp.com>; ocfs2-devel at oss.oracle.com
>>>> Subject: Re: [Ocfs2-devel] OCFS2 BUG with 2 different kernels
>>>>
>>>> Hi Daniel,
>>>>
>>>> Thanks for your report.
>>>> I'll try to reproduce this bug as you did.
>>>>
>>>> I'm afraid there may be some bugs on the collaboration of cgroups and ocfs2.
>>>>
>>>> Thanks
>>>> Larry
>>>>
>>>>
>>>> On 04/11/2018 08:24 PM, Daniel Sobe wrote:
>>>>> Hi Larry,
>>>>>
>>>>> below is an example config file like I use it for LXC containers. I followed the instructions (https://urldefense.proofpoint.com/v2/url?u=https-3A__emea01.safelinks.protection.outlook.com_-3Furl-3Dhttps-253A-252F-252Fwiki.debian.org-252FLXC-26data-3D02-257C01-257Cdaniel.sobe-2540nxp.com-257C11fd4f062e694faa287a08d5a023f22b-257C686ea1d3bc2b4c6fa92cd99c5c301635-257C0-257C0-257C636590998614059943-26sdata-3DZSqSTx3Vjxy-252FbfKrXdIVGvUqieRFxVl4FFnr-252FPTGAhc-253D-26reserved-3D0&d=DwIDaQ&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=C7gAd4uDxlAvTdc0vmU6X8CMk6L2iDY8-HD0qT6Fo7Y&m=ZyZJHyS-hpOt5cG5HUXWP4DMTlWsFjNC24kNNJrQP7Y&s=p6IBQtAwi0mNcKsq2KQH96D2xRdWu7HXtgXDOtDYq28&e=) and downloaded a Debian 8 container as user (unprivileged) and adapted the config file. Several of those containers run on one host and share the OCFS2 directory as you can see at the "lxc.mount.entry" line.
>>>>>
>>>>> Meanwhile I'm trying whether the problem can be reproduced with shared mounts in one namespace, as you suggested. So far with no success, will report once anything happens.
>>>>>
>>>>> Regards,
>>>>>
>>>>> Daniel
>>>>>
>>>>> ----
>>>>>
>>>>> # Distribution configuration
>>>>> lxc.include = /usr/share/lxc/config/debian.common.conf
>>>>> lxc.include = /usr/share/lxc/config/debian.userns.conf
>>>>> lxc.arch = x86_64
>>>>>
>>>>> # Container specific configuration
>>>>> lxc.id_map = u 0 624288 65536
>>>>> lxc.id_map = g 0 624288 65536
>>>>>
>>>>> lxc.utsname = container1
>>>>> lxc.rootfs = /storage/uvirtuals/unpriv/container1/rootfs
>>>>>
>>>>> lxc.network.type = veth
>>>>> lxc.network.flags = up
>>>>> lxc.network.link = bridge1
>>>>> lxc.network.name = eth0
>>>>> lxc.network.veth.pair = aabbccddeeff
>>>>> lxc.network.ipv4 = XX.XX.XX.XX/YY
>>>>> lxc.network.ipv4.gateway = ZZ.ZZ.ZZ.ZZ
>>>>>
>>>>> lxc.cgroup.cpuset.cpus = 63-86
>>>>>
>>>>> lxc.mount.entry = /storage/ocfs2/sw            sw            none bind 0 0
>>>>>
>>>>> lxc.cgroup.memory.limit_in_bytes       = 240G
>>>>> lxc.cgroup.memory.memsw.limit_in_bytes = 240G
>>>>>
>>>>> lxc.include = /usr/share/lxc/config/common.conf.d/00-lxcfs.conf
>>>>>
>>>>> ----
>>>>>
>>>>>
>>>>>
>>>>>
>>>>> -----Original Message-----
>>>>> From: Larry Chen [mailto:lchen at suse.com]
>>>>> Sent: Mittwoch, 11. April 2018 13:31
>>>>> To: Daniel Sobe <daniel.sobe@nxp.com>; ocfs2-devel at oss.oracle.com
>>>>> Subject: Re: [Ocfs2-devel] OCFS2 BUG with 2 different kernels
>>>>>
>>>>>
>>>>>
>>>>> On 04/11/2018 07:17 PM, Daniel Sobe wrote:
>>>>>> Hi Larry,
>>>>>>
>>>>>> this is what I was doing. The 2nd node, while being "declared" in the cluster.conf, does not exist yet, and thus everything was happening on one node only.
>>>>>>
>>>>>> I do not know in detail how LXC does the mount sharing, but I assume it simply calls "mount --bind /original/mount/point /new/mount/point" in a separate namespace (or, somehow unshares the mount from the original namespace afterwards).
>>>>> I thought of there is a way to share a directory between host and docker container, like
>>>>>       ?? docker run -v /host/directory:/container/directory -other -options image_name command_to_run That's different from yours.
>>>>>
>>>>> How did you setup your lxc or container?
>>>>>
>>>>> If you could, show me the procedure, I'll try to reproduce it.
>>>>>
>>>>> And by the way, if you get rid of lxc, and just mount ocfs2 on several different mount point of local host, will the problem recur?
>>>>>
>>>>> Regards,
>>>>> Larry
>>>>>> Regards,
>>>>>>
>>>>>> Daniel
>>>>>>
>>
>> Sorry for this delayed reply.
>>
>> I tried with lxc + ocfs2 in your mount-shared way.
>>
>> But I can not reproduce your bugs.
>>
>> What I use is opensuse tumbleweed.
>>
>> The procedure I try to reproduce your bugs:
>> 0. set-up ha cluster stack and mount ocfs2 fs on host's /mnt with command
>>    ?? mount /dev/xxx /mnt
>>    ?? then it shows
>>    ?? 207 65 254:16 / /mnt rw,relatime shared:94
>>    ?? I think this *shared* is what you want. And this mount point will be shared within multiple namespaces.
>>
>> 1. Start Virtual Machine Manager.
>> 2. add a local LXC connection by clicking File ? Add Connection.
>>    ?? Select LXC (Linux Containers) as the hypervisor and click Connect.
>> 3. Select the localhost (LXC) connection and click File New Virtual Machine menu.
>> 4. Activate Application container and click Forward.
>>    ?? Set the path to the application to be launched. As an example, the field is filled with /bin/sh, which is fine to create a first container.
>> Click Forward.
>> 5. Choose the maximum amount of memory and CPUs to allocate to the container. Click Forward.
>> 6. Type in a name for the container. This name will be used for all virsh commands on the container.
>>    ?? Click Advanced options. Select the network to connect the container to and click Finish. The container will be created and started. A console will be opened automatically.
>>
>> If possible, could you please provide a shell script to show what you did with you mount point.
>>
>> Thanks
>> Larry
>>
> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
> 
