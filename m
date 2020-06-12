From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Thu, 11 Jun 2020 18:36:40 -0700
Subject: [Ocfs2-devel] NFS clients crash OCFS2 nodes (general protection
 fault: 0000 [#1] SMP PTI)
In-Reply-To: <3873cb24-9db7-cc20-550a-ab82568464ca@oracle.com>
References: <19bc32c6-a84e-8416-119c-9a1279bfd968@qsdf.org>
	<d662254a-894a-b864-4ce8-b5a827ea0a50@oracle.com>
	<75e2aedb-de1c-b21b-0d32-6c370ba209b8@qsdf.org>
	<3873cb24-9db7-cc20-550a-ab82568464ca@oracle.com>
Message-ID: <4d33adf5-edaa-d71b-2114-e8645ccf5214@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Pierre,

Please try the 3 patches i just post to the mail list. It may fix your 
issue.

Thanks,

Junxiao.

On 6/2/20 8:56 AM, herbert.van.den.bergh at oracle.com wrote:
> Hi Pierre,
>
> This is tracked in an internal bug tracking system, which is not
> available to the public or to customers. We'll make sure to post an
> announcement to this list when the bug is fixed.
>
> Thanks,
> Herbert.
>
> On 6/2/20 3:10 AM, Pierre Dinh-van wrote:
>> Hi Herbert,
>>
>> Is there somewhere a Bugtracker for it ? Or are the bugs @oracle not
>> public anymore ?
>>
>> Browsing/searching bugzilla don't show me any bug :
>> https://bugzilla.oracle.com/bugzilla/describecomponents.cgi
>>
>> Cheers
>>
>> Pierre
>>
>> On 5/21/20 12:01 AM, herbert.van.den.bergh at oracle.com wrote:
>>> Pierre,
>>>
>>> A similar if not identical bug was reported against Oracle Linux. The
>>> fix is still being developed. I will update that bug to reference this
>>> thread, and ask the developer to submit the fix upstream and/or to the
>>> ocfs2-devel list once it's ready.
>>>
>>> Thanks,
>>> Herbert.
>>>
>>> On 5/19/20 3:48 AM, Pierre Dinh-van wrote:
>>> Hi,
>>>
>>> I'm experiencing quite reproducable crashs on my OCFS2 cluster the last
>>> weeks, and I think I found out part of the Problem. But before I make a
>>> bug report (I'm not sure where), I though I could post my research here
>>> in case someone understands it better than I.
>>>
>>> When it happens, the kernel is giving me a 'general protection fault:
>>> 0000 [#1] SMP PTI' or ' BUG: unable to handle page fault for address:'
>>> message, local access to the OCFS2 volumes are all hanging forever, and
>>> the load is getting so high that only a hard reset "solves" the problem.
>>> It happened the same way on both nodes (always on the active node
>>> serving NFS). It happens when both nodes are up, or when only one is
>>> active.
>>>
>>> First, a few words about my setup :
>>>
>>> - storage is Fiberchannel LUNs served by a EMC VNX5200 (4x 5TB).
>>>
>>> - LUNs are encrypted with LUKS
>>>
>>> - LUKS volumes are formated with OCFS2
>>>
>>> - heartbeat=local
>>>
>>> - The OCFS2 cluster is communicating on a dedictated IP over InfinyBand
>>> direct link (actually a fail-over bonding of the 2 ib interfaces).
>>>
>>> - nodes are 2 debian buster hardware servers (24 cores, 128GB RAM).
>>>
>>> - I use corosync for cluster management, but I don't think it's related
>>>
>>> - The cluster serves 4 NFS exports (3 are NFSv3, and one is NFSv4 with
>>> kerberos) and samba shares
>>>
>>> - The samba shares are served in parallel by the 2 nodes managed by
>>> ctdb
>>>
>>> - The NFS exports are served by one of the node having the dedicated IP
>>> for this export.
>>>
>>> - When corosync is moving the IP of a NFS export to the other node, it
>>> restarts nfsd to issue a grace time of 10s on the new active node.
>>>
>>> - The bug appeared with default debian buster kernel 4.19.0-9-amd64 and
>>> with the backported kernel 5.5.0-0.bpo.2-amd64 as well
>>>
>>>
>>> My cluster went live a few weeks ago, and it first worked with both
>>> nodes active. During some maintenance work where the active NFS node had
>>> to switch, I had a a bug, that I was able to reproduce against my will
>>> at least 20 times in the last nights :
>>>
>>> 1) around 100 NFS clients are connected with the exports and happy
>>> working with it
>>>
>>> 2) The IPs of the NFS shares are switching from nodeA to nodeB
>>>
>>> 3) nodeB's kernel says "general protection fault: 0000 [#1] SMP PTI"
>>>
>>> 4) nodeB's load is getting high
>>>
>>> 5) access to the OCFS2 is hanging (clean reboot never end, system cannot
>>> unmount OCFS volumes)
>>>
>>> 6) I power cycle nodeB
>>>
>>> 7) I start nodeA again
>>>
>>> 8) nodeA give the same symptoms, as soon as some NFS clients do some
>>> special requests
>>>
>>>
>>> Most of the time, when the IP jumps to the other node, I get some of
>>> this messages :
>>>
>>>
>>> [  501.707566] (nfsd,2133,14):ocfs2_test_inode_bit:2841 ERROR: unable to
>>> get alloc inode in slot 65535
>>> [  501.716660] (nfsd,2133,14):ocfs2_test_inode_bit:2867 ERROR: status
>>> = -22
>>> [  501.726585] (nfsd,2133,6):ocfs2_test_inode_bit:2841 ERROR: unable to
>>> get alloc inode in slot 65535
>>> [  501.735579] (nfsd,2133,6):ocfs2_test_inode_bit:2867 ERROR: status =
>>> -22
>>>
>>> But it also happens when the node is not crashing, so I think it's
>>> another Problem.
>>>
>>> Last night, I saved a few of the kernel output while the servers where
>>> crashing one after the other like in a ping-pong game :
>>>
>>>
>>> -----8< on nodeB  8<-----
>>>
>>> [  502.070431] nfsd: nfsv4 idmapping failing: has idmapd not been
>>> started?
>>> [  502.475747] general protection fault: 0000 [#1] SMP PTI
>>> [  502.481027] CPU: 6 PID: 2104 Comm: nfsd Not tainted
>>> 5.5.0-0.bpo.2-amd64 #1 Debian 5.5.17-1~bpo10+1
>>> [  502.490016] Hardware name: IBM System x3650 M3
>>> -[7945UHV]-/94Y7614     , BIOS -[D6E150CUS-1.11]- 02/08/2011
>>> [  502.499821] RIP: 0010:_raw_spin_lock+0xc/0x20
>>> [  502.504206] Code: 66 90 66 66 90 31 c0 ba ff 00 00 00 f0 0f b1 17 75
>>> 05 48 89 d8 5b c3 e8 12 5f 91 ff eb f4 66 66 66 66 90 31 c0 ba 01 00 00
>>> 00 <f0> 0f b1 17 75 01 c3 89 c6 e8 76 46 91 ff 66 90 c3 0f 1f 00 66 66
>>> [  502.523018] RSP: 0018:ffffa5af4838bac0 EFLAGS: 00010246
>>> [  502.528277] RAX: 0000000000000000 RBX: 0fdbbeded053c1d6 RCX:
>>> 0000000000000000
>>> [  502.535433] RDX: 0000000000000001 RSI: 0000000000000009 RDI:
>>> 0fdbbeded053c25e
>>> [  502.542588] RBP: 0fdbbeded053c25e R08: ffff9672ffa73068 R09:
>>> 000000000002c340
>>> [  502.549743] R10: 00000184d03a2115 R11: 0000000000000000 R12:
>>> ffff9672eff43fd0
>>> [  502.556899] R13: ffff9672fff66bc0 R14: 000000000000ffff R15:
>>> ffff9672fff660c8
>>> [  502.564055] FS:  0000000000000000(0000) GS:ffff968203a80000(0000)
>>> knlGS:0000000000000000
>>> [  502.572166] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>> [  502.577928] CR2: 00007f0a4bb5df50 CR3: 0000001e4169a004 CR4:
>>> 00000000000206e0
>>> [  502.585082] Call Trace:
>>> [  502.587546]  igrab+0x19/0x50
>>> [  502.590484]  ocfs2_get_system_file_inode+0x65/0x2c0 [ocfs2]
>>> [  502.596094]  ? ocfs2_read_blocks_sync+0x159/0x330 [ocfs2]
>>> [  502.601534]  ocfs2_test_inode_bit+0xe8/0x900 [ocfs2]
>>> [  502.606536]  ? ocfs2_free_dir_lookup_result+0x24/0x50 [ocfs2]
>>> [  502.612321]  ocfs2_get_parent+0xa3/0x300 [ocfs2]
>>> [  502.616960]  reconnect_path+0xa1/0x2c0
>>> [  502.620742]  ? nfsd_proc_setattr+0x1b0/0x1b0 [nfsd]
>>> [  502.625636]  exportfs_decode_fh+0x111/0x2d0
>>> [  502.629844]  ? exp_find_key+0xcd/0x160 [nfsd]
>>> [  502.634218]  ? __kmalloc+0x180/0x270
>>> [  502.637810]  ? security_prepare_creds+0x6f/0xa0
>>> [  502.642356]  ? tomoyo_write_self+0x1b0/0x1b0
>>> [  502.646642]  ? security_prepare_creds+0x49/0xa0
>>> [  502.651995]  fh_verify+0x3e5/0x5f0 [nfsd]
>>> [  502.656737]  nfsd3_proc_getattr+0x6b/0x100 [nfsd]
>>> [  502.662152]  nfsd_dispatch+0x9e/0x210 [nfsd]
>>> [  502.667136]  svc_process_common+0x386/0x6f0 [sunrpc]
>>> [  502.672791]  ? svc_sock_secure_port+0x12/0x30 [sunrpc]
>>> [  502.678628]  ? svc_recv+0x2ff/0x9c0 [sunrpc]
>>> [  502.683597]  ? nfsd_svc+0x2c0/0x2c0 [nfsd]
>>> [  502.688395]  ? nfsd_destroy+0x50/0x50 [nfsd]
>>> [  502.693377]  svc_process+0xd1/0x110 [sunrpc]
>>> [  502.698361]  nfsd+0xe3/0x140 [nfsd]
>>> [  502.702561]  kthread+0x112/0x130
>>> [  502.706504]  ? kthread_park+0x80/0x80
>>> [  502.710886]  ret_from_fork+0x35/0x40
>>> [  502.715181] Modules linked in: rpcsec_gss_krb5 nfsd nfs_acl lockd
>>> grace ocfs2 quota_tree sctp libcrc32c nft_counter ipt_REJECT
>>> nf_reject_ipv4 xt_tcpudp nft_compat nf_tables nfnetlink binfmt_misc
>>> ocfs2_dlmfs ocfs2_stack_o2cb ocfs2_dlm ocfs2_nodemanager
>>> cpufreq_userspace ocfs2_stackglue cpufreq_powersave cpufreq_conservative
>>> configfs bonding dm_round_robin dm_multipath scsi_dh_rdac scsi_dh_emc
>>> scsi_dh_alua intel_powerclamp coretemp kvm_intel ipmi_ssif kvm cdc_ether
>>> irqbypass usbnet mii tpm_tis intel_cstate tpm_tis_core intel_uncore
>>> joydev tpm ipmi_si ioatdma sg iTCO_wdt ib_mthca iTCO_vendor_support
>>> watchdog dca pcspkr ipmi_devintf rng_core ib_uverbs ipmi_msghandler
>>> i5500_temp i7core_edac evdev ib_umad ib_ipoib ib_cm ib_core auth_rpcgss
>>> sunrpc ip_tables x_tables autofs4 algif_skcipher af_alg ext4 crc16
>>> mbcache jbd2 crc32c_generic dm_crypt dm_mod sd_mod hid_generic usbhid
>>> hid sr_mod cdrom crct10dif_pclmul crc32_pclmul crc32c_intel
>>> ghash_clmulni_intel mgag200 drm_vram_helper drm_ttm_helper
>>> [  502.715218]  i2c_algo_bit ttm qla2xxx drm_kms_helper drm ata_generic
>>> ata_piix aesni_intel libata nvme_fc ehci_pci uhci_hcd crypto_simd
>>> ehci_hcd nvme_fabrics cryptd glue_helper lpc_ich nvme_core megaraid_sas
>>> mfd_core usbcore scsi_transport_fc e1000e scsi_mod i2c_i801 usb_common
>>> ptp pps_core bnx2 button
>>> [  502.837917] ---[ end trace 6e1a8e507ac30d8d ]---
>>> [  502.843379] RIP: 0010:_raw_spin_lock+0xc/0x20
>>> [  502.848584] Code: 66 90 66 66 90 31 c0 ba ff 00 00 00 f0 0f b1 17 75
>>> 05 48 89 d8 5b c3 e8 12 5f 91 ff eb f4 66 66 66 66 90 31 c0 ba 01 00 00
>>> 00 <f0> 0f b1 17 75 01 c3 89 c6 e8 76 46 91 ff 66 90 c3 0f 1f 00 66 66
>>> [  502.869295] RSP: 0018:ffffa5af4838bac0 EFLAGS: 00010246
>>> [  502.875404] RAX: 0000000000000000 RBX: 0fdbbeded053c1d6 RCX:
>>> 0000000000000000
>>> [  502.883423] RDX: 0000000000000001 RSI: 0000000000000009 RDI:
>>> 0fdbbeded053c25e
>>> [  502.891436] RBP: 0fdbbeded053c25e R08: ffff9672ffa73068 R09:
>>> 000000000002c340
>>> [  502.899446] R10: 00000184d03a2115 R11: 0000000000000000 R12:
>>> ffff9672eff43fd0
>>> [  502.907455] R13: ffff9672fff66bc0 R14: 000000000000ffff R15:
>>> ffff9672fff660c8
>>> [  502.915473] FS:  0000000000000000(0000) GS:ffff968203a80000(0000)
>>> knlGS:0000000000000000
>>> [  502.924496] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>> [  502.931147] CR2: 00007f0a4bb5df50 CR3: 0000001e4169a004 CR4:
>>> 00000000000206e0
>>>
>>> -----8< cut here 8<-----
>>>
>>>
>>> shortly after when trying to start nodeA while nodeB was down :
>>>
>>> -----8< nodeA 8<-----
>>>
>>> [  728.927750] general protection fault: 0000 [#1] SMP PTI
>>> [  728.934647] CPU: 8 PID: 12156 Comm: nfsd Not tainted
>>> 5.5.0-0.bpo.2-amd64 #1 Debian 5.5.17-1~bpo10+1
>>> [  728.944800] Hardware name: IBM System x3650 M3 -[7945H2G]-/69Y4438,
>>> BIOS -[D6E158AUS-1.16]- 11/26/2012
>>> [  728.955176] RIP: 0010:_raw_spin_lock+0xc/0x20
>>> [  728.960595] Code: 66 90 66 66 90 31 c0 ba ff 00 00 00 f0 0f b1 17 75
>>> 05 48 89 d8 5b c3 e8 12 5f 91 ff eb f4 66 66 66 66 90 31 c0 ba 01 00 00
>>> 00 <f0> 0f b1 17 75 01 c3 89 c6 e8 76 46 91 ff 66 90 c3 0f 1f 00 66 66
>>> [  728.981559] RSP: 0018:ffffa24d09187ac0 EFLAGS: 00010246
>>> [  728.987885] RAX: 0000000000000000 RBX: 625f656369766564 RCX:
>>> 0000000000000000
>>> [  728.996135] RDX: 0000000000000001 RSI: 0000000000000009 RDI:
>>> 625f6563697665ec
>>> [  729.004384] RBP: 625f6563697665ec R08: ffff91f1272e3680 R09:
>>> 000000000002c340
>>> [  729.012628] R10: 000002114c00d22b R11: 0000000000000000 R12:
>>> ffff91e13858bbd0
>>> [  729.020877] R13: ffff91f13c03bbc0 R14: 000000000000ffff R15:
>>> ffff91f13c03b0c8
>>> [  729.029108] FS:  0000000000000000(0000) GS:ffff91f13fa80000(0000)
>>> knlGS:0000000000000000
>>> [  729.038308] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>> [  729.045161] CR2: 000055fe95d1d9a8 CR3: 0000001c8420a003 CR4:
>>> 00000000000206e0
>>> [  729.053415] Call Trace:
>>> [  729.056978]  igrab+0x19/0x50
>>> [  729.061023]  ocfs2_get_system_file_inode+0x65/0x2c0 [ocfs2]
>>> [  729.067736]  ? ocfs2_read_blocks_sync+0x159/0x330 [ocfs2]
>>> [  729.074284]  ocfs2_test_inode_bit+0xe8/0x900 [ocfs2]
>>> [  729.080386]  ? ocfs2_free_dir_lookup_result+0x24/0x50 [ocfs2]
>>> [  729.087268]  ocfs2_get_parent+0xa3/0x300 [ocfs2]
>>> [  729.092995]  reconnect_path+0xa1/0x2c0
>>> [  729.097863]  ? nfsd_proc_setattr+0x1b0/0x1b0 [nfsd]
>>> [  729.103840]  exportfs_decode_fh+0x111/0x2d0
>>> [  729.109133]  ? exp_find_key+0xcd/0x160 [nfsd]
>>> [  729.114574]  ? dbs_update_util_handler+0x16/0x90
>>> [  729.120273]  ? __kmalloc+0x180/0x270
>>> [  729.124920]  ? security_prepare_creds+0x6f/0xa0
>>> [  729.130521]  ? tomoyo_write_self+0x1b0/0x1b0
>>> [  729.135858]  ? security_prepare_creds+0x49/0xa0
>>> [  729.141464]  fh_verify+0x3e5/0x5f0 [nfsd]
>>> [  729.146536]  nfsd3_proc_getattr+0x6b/0x100 [nfsd]
>>> [  729.152297]  nfsd_dispatch+0x9e/0x210 [nfsd]
>>> [  729.157647]  svc_process_common+0x386/0x6f0 [sunrpc]
>>> [  729.163675]  ? svc_sock_secure_port+0x12/0x30 [sunrpc]
>>> [  729.169873]  ? svc_recv+0x2ff/0x9c0 [sunrpc]
>>> [  729.175190]  ? nfsd_svc+0x2c0/0x2c0 [nfsd]
>>> [  729.180323]  ? nfsd_destroy+0x50/0x50 [nfsd]
>>> [  729.185631]  svc_process+0xd1/0x110 [sunrpc]
>>> [  729.190925]  nfsd+0xe3/0x140 [nfsd]
>>> [  729.195421]  kthread+0x112/0x130
>>> [  729.199636]  ? kthread_park+0x80/0x80
>>> [  729.204279]  ret_from_fork+0x35/0x40
>>> [  729.208818] Modules linked in: ocfs2 quota_tree dm_crypt crypto_simd
>>> cryptd glue_helper algif_skcipher af_alg nfsd nfs_acl lockd grace sctp
>>> libcrc32c nft_counter xt_tcpudp nft_compat nf_tables nfnetlink
>>> binfmt_misc ocfs2_dlmfs ocfs2_stack_o2cb ocfs2_dlm ocfs2_nodemanager
>>> ocfs2_stackglue configfs bonding dm_round_robin dm_multipath
>>> scsi_dh_rdac scsi_dh_emc scsi_dh_alua intel_powerclamp ipmi_ssif
>>> coretemp kvm_intel kvm irqbypass cdc_ether intel_cstate usbnet ib_mthca
>>> mii joydev intel_uncore ib_uverbs iTCO_wdt sg ioatdma
>>> iTCO_vendor_support i7core_edac watchdog i5500_temp pcspkr ipmi_si
>>> tpm_tis tpm_tis_core tpm ipmi_devintf ipmi_msghandler rng_core evdev
>>> acpi_cpufreq ib_umad auth_rpcgss ib_ipoib ib_cm sunrpc ib_core ip_tables
>>> x_tables autofs4 ext4 crc16 mbcache jbd2 crc32c_generic dm_mod
>>> hid_generic sd_mod usbhid hid sr_mod cdrom uas usb_storage mgag200
>>> drm_vram_helper drm_ttm_helper qla2xxx ata_generic i2c_algo_bit ttm
>>> nvme_fc ixgbe nvme_fabrics ata_piix xfrm_algo ehci_pci uhci_hcd
>>> [  729.208868]  drm_kms_helper nvme_core ehci_hcd dca libata
>>> megaraid_sas scsi_transport_fc libphy ptp drm usbcore scsi_mod
>>> crc32c_intel lpc_ich i2c_i801 pps_core mfd_core usb_common bnx2 mdio
>>> button
>>> [  729.323900] ---[ end trace 212cefe75207e17f ]---
>>> [  729.329644] RIP: 0010:_raw_spin_lock+0xc/0x20
>>> [  729.335121] Code: 66 90 66 66 90 31 c0 ba ff 00 00 00 f0 0f b1 17 75
>>> 05 48 89 d8 5b c3 e8 12 5f 91 ff eb f4 66 66 66 66 90 31 c0 ba 01 00 00
>>> 00 <f0> 0f b1 17 75 01 c3 89 c6 e8 76 46 91 ff 66 90 c3 0f 1f 00 66 66
>>> [  729.356192] RSP: 0018:ffffa24d09187ac0 EFLAGS: 00010246
>>> [  729.362584] RAX: 0000000000000000 RBX: 625f656369766564 RCX:
>>> 0000000000000000
>>> [  729.370889] RDX: 0000000000000001 RSI: 0000000000000009 RDI:
>>> 625f6563697665ec
>>> [  729.379184] RBP: 625f6563697665ec R08: ffff91f1272e3680 R09:
>>> 000000000002c340
>>> [  729.387475] R10: 000002114c00d22b R11: 0000000000000000 R12:
>>> ffff91e13858bbd0
>>> [  729.395767] R13: ffff91f13c03bbc0 R14: 000000000000ffff R15:
>>> ffff91f13c03b0c8
>>> [  729.404066] FS:  0000000000000000(0000) GS:ffff91f13fa80000(0000)
>>> knlGS:0000000000000000
>>> [  729.413336] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>> [  729.420262] CR2: 000055fe95d1d9a8 CR3: 0000001c8420a003 CR4:
>>> 00000000000206e0
>>>
>>> -----8< cut here 8<-----
>>>
>>> Since the backtrace is speaking about nfsd, I tried to isolate the
>>> Problem by droping all NFS packet entering to the active node before
>>> starting the services :
>>>
>>> iptables -I INPUT -p tcp --dport 2049 -j DROP
>>>
>>> Everything fine, access over samba were doing fine.
>>>
>>> I started to allow NFS for part of my network with iptables, until the
>>> crash occurs.
>>>
>>> On this one, the crash occured after allowing only a NFSv3 client.
>>>
>>> -----8< nodeB 8<-----
>>>
>>> [ 2494.893697] BUG: unable to handle page fault for address:
>>> 00000000000fab7d
>>> [ 2494.900626] #PF: supervisor write access in kernel mode
>>> [ 2494.905873] #PF: error_code(0x0002) - not-present page
>>> [ 2494.911042] PGD 0 P4D 0
>>> [ 2494.913596] Oops: 0002 [#1] SMP PTI
>>> [ 2494.917106] CPU: 11 PID: 21342 Comm: nfsd Not tainted
>>> 5.5.0-0.bpo.2-amd64 #1 Debian 5.5.17-1~bpo10+1
>>> [ 2494.926285] Hardware name: IBM System x3650 M3
>>> -[7945UHV]-/94Y7614     , BIOS -[D6E150CUS-1.11]- 02/08/2011
>>> [ 2494.936077] RIP: 0010:_raw_spin_lock+0xc/0x20
>>> [ 2494.940461] Code: 66 90 66 66 90 31 c0 ba ff 00 00 00 f0 0f b1 17 75
>>> 05 48 89 d8 5b c3 e8 12 5f 91 ff eb f4 66 66 66 66 90 31 c0 ba 01 00 00
>>> 00 <f0> 0f b1 17 75 01 c3 89 c6 e8 76 46 91 ff 66 90 c3 0f 1f 00 66 66
>>> [ 2494.959269] RSP: 0018:ffffb949cca7fac0 EFLAGS: 00010246
>>> [ 2494.964511] RAX: 0000000000000000 RBX: 00000000000faaf5 RCX:
>>> 0000000000000000
>>> [ 2494.971664] RDX: 0000000000000001 RSI: 0000000000000009 RDI:
>>> 00000000000fab7d
>>> [ 2494.978815] RBP: 00000000000fab7d R08: ffff99c8f12737b8 R09:
>>> 000000000002c340
>>> [ 2494.985968] R10: 000005dc16e333d8 R11: 0000000000000000 R12:
>>> ffff99c903066bd0
>>> [ 2494.993119] R13: ffff99c9014c7bc0 R14: 000000000000ffff R15:
>>> ffff99c9014c70c8
>>> [ 2495.000271] FS:  0000000000000000(0000) GS:ffff99ba03bc0000(0000)
>>> knlGS:0000000000000000
>>> [ 2495.008382] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>> [ 2495.014141] CR2: 00000000000fab7d CR3: 0000000f38df2002 CR4:
>>> 00000000000206e0
>>> [ 2495.021291] Call Trace:
>>> [ 2495.023753]  igrab+0x19/0x50
>>> [ 2495.026693]  ocfs2_get_system_file_inode+0x65/0x2c0 [ocfs2]
>>> [ 2495.032301]  ? ocfs2_read_blocks_sync+0x159/0x330 [ocfs2]
>>> [ 2495.037741]  ocfs2_test_inode_bit+0xe8/0x900 [ocfs2]
>>> [ 2495.042742]  ? ocfs2_free_dir_lookup_result+0x24/0x50 [ocfs2]
>>> [ 2495.048525]  ocfs2_get_parent+0xa3/0x300 [ocfs2]
>>> [ 2495.053163]  reconnect_path+0xa1/0x2c0
>>> [ 2495.056943]  ? nfsd_proc_setattr+0x1b0/0x1b0 [nfsd]
>>> [ 2495.061838]  exportfs_decode_fh+0x111/0x2d0
>>> [ 2495.066042]  ? exp_find_key+0xcd/0x160 [nfsd]
>>> [ 2495.070417]  ? __kmalloc+0x180/0x270
>>> [ 2495.074007]  ? security_prepare_creds+0x6f/0xa0
>>> [ 2495.078551]  ? tomoyo_write_self+0x1b0/0x1b0
>>> [ 2495.082834]  ? security_prepare_creds+0x49/0xa0
>>> [ 2495.087387]  fh_verify+0x3e5/0x5f0 [nfsd]
>>> [ 2495.092125]  nfsd3_proc_getattr+0x6b/0x100 [nfsd]
>>> [ 2495.097517]  nfsd_dispatch+0x9e/0x210 [nfsd]
>>> [ 2495.102489]  svc_process_common+0x386/0x6f0 [sunrpc]
>>> [ 2495.108134]  ? svc_sock_secure_port+0x12/0x30 [sunrpc]
>>> [ 2495.113946]  ? svc_recv+0x2ff/0x9c0 [sunrpc]
>>> [ 2495.118883]  ? nfsd_svc+0x2c0/0x2c0 [nfsd]
>>> [ 2495.123651]  ? nfsd_destroy+0x50/0x50 [nfsd]
>>> [ 2495.128604]  svc_process+0xd1/0x110 [sunrpc]
>>> [ 2495.133563]  nfsd+0xe3/0x140 [nfsd]
>>> [ 2495.137733]  kthread+0x112/0x130
>>> [ 2495.141643]  ? kthread_park+0x80/0x80
>>> [ 2495.145993]  ret_from_fork+0x35/0x40
>>> [ 2495.150262] Modules linked in: ocfs2 quota_tree nfsd nfs_acl lockd
>>> grace sctp libcrc32c nft_counter xt_tcpudp nft_compat nf_tables
>>> nfnetlink binfmt_misc ocfs2_dlmfs ocfs2_stack_o2cb ocfs2_dlm
>>> ocfs2_nodemanager ocfs2_stackglue cpufreq_userspace cpufreq_powersave
>>> cpufreq_conservative configfs bonding dm_round_robin dm_multipath
>>> scsi_dh_rdac scsi_dh_emc scsi_dh_alua intel_powerclamp coretemp
>>> kvm_intel kvm ipmi_ssif irqbypass cdc_ether usbnet intel_cstate mii
>>> ib_mthca intel_uncore evdev iTCO_wdt joydev ipmi_si tpm_tis sg
>>> tpm_tis_core tpm ipmi_devintf iTCO_vendor_support ib_uverbs pcspkr
>>> watchdog ioatdma rng_core i7core_edac dca i5500_temp ipmi_msghandler
>>> ib_umad ib_ipoib auth_rpcgss ib_cm sunrpc ib_core ip_tables x_tables
>>> autofs4 algif_skcipher af_alg ext4 crc16 mbcache jbd2 crc32c_generic
>>> dm_crypt dm_mod sr_mod cdrom sd_mod hid_generic usbhid hid
>>> crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel mgag200
>>> drm_vram_helper drm_ttm_helper i2c_algo_bit ttm qla2xxx drm_kms_helper
>>> [ 2495.150298]  ata_generic drm ata_piix aesni_intel libata nvme_fc
>>> uhci_hcd crypto_simd nvme_fabrics ehci_pci ehci_hcd megaraid_sas cryptd
>>> nvme_core glue_helper usbcore scsi_transport_fc lpc_ich mfd_core e1000e
>>> scsi_mod i2c_i801 usb_common bnx2 ptp pps_core button
>>> [ 2495.269073] CR2: 00000000000fab7d
>>> [ 2495.273205] ---[ end trace 44f000505f987296 ]---
>>> [ 2495.278647] RIP: 0010:_raw_spin_lock+0xc/0x20
>>> [ 2495.283825] Code: 66 90 66 66 90 31 c0 ba ff 00 00 00 f0 0f b1 17 75
>>> 05 48 89 d8 5b c3 e8 12 5f 91 ff eb f4 66 66 66 66 90 31 c0 ba 01 00 00
>>> 00 <f0> 0f b1 17 75 01 c3 89 c6 e8 76 46 91 ff 66 90 c3 0f 1f 00 66 66
>>> [ 2495.304287] RSP: 0018:ffffb949cca7fac0 EFLAGS: 00010246
>>> [ 2495.310368] RAX: 0000000000000000 RBX: 00000000000faaf5 RCX:
>>> 0000000000000000
>>> [ 2495.318358] RDX: 0000000000000001 RSI: 0000000000000009 RDI:
>>> 00000000000fab7d
>>> [ 2495.326339] RBP: 00000000000fab7d R08: ffff99c8f12737b8 R09:
>>> 000000000002c340
>>> [ 2495.334314] R10: 000005dc16e333d8 R11: 0000000000000000 R12:
>>> ffff99c903066bd0
>>> [ 2495.342297] R13: ffff99c9014c7bc0 R14: 000000000000ffff R15:
>>> ffff99c9014c70c8
>>> [ 2495.350279] FS:  0000000000000000(0000) GS:ffff99ba03bc0000(0000)
>>> knlGS:0000000000000000
>>> [ 2495.359224] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>> [ 2495.365825] CR2: 00000000000fab7d CR3: 0000000f38df2002 CR4:
>>> 00000000000206e0
>>>
>>> -----8< cut here 8<-----
>>>
>>>
>>> I also made some record of NFS traffic with tcpdump when the crashs are
>>> occuring, but I didn't had time to analyse it. I can provide them if it
>>> helps (but I might have to clean them up first to avoid some data
>>> leaks :)
>>>
>>> After this happening a few times, I had one case where one of the few
>>> NFSv4 client was involved, and I took as aworkaround to migrate the
>>> NFSv4 share to XFS since I though it could be NFSv4 related. Now that I
>>> looked at the kernel dumps, I think it's also NFSv3 related.
>>>
>>> Is it a kernel bug or am I missing something ?
>>>
>>> For now, I will switch back to XFS with a failover setup of my cluster,
>>> cause I cannot afford this kind of crashes of a central file server.
>>>
>>>
>>>
>>> Cheers
>>>
>>>
>>> Pierre
>>>
>>>
>>> PS : I'll try to update with what I found in the PCAP files in some days
>>>
>>>
>>>
>>>> _______________________________________________
>>>> Ocfs2-devel mailing list
>>>> Ocfs2-devel at oss.oracle.com
>>>> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
