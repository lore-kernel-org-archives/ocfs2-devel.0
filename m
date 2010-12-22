From: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
Date: Wed, 22 Dec 2010 07:38:32 -0000
Subject: [Ocfs2-devel] 2.6.36 OCFS unstable
In-Reply-To: <20101209021047.GA7618@laptop.jp.oracle.com>
References: <20101112190432.GB2364@nik-comp.lan>
	<20101209021047.GA7618@laptop.jp.oracle.com>
Message-ID: <20101222073818.GG3873@pcnci.linuxbox.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Dec 09, 2010 at 10:10:47AM +0800, Wengang Wang wrote:
> what's the output for:
> echo "stats" |debugfs.ocfs2 </dev/xxx>
> 
Hello Wengang,
I'm sorry but I already had to deploy the cluster, so due to stability problems,
I was forced to replace OCFS2 on it, as well as on other two our clusters :(
So I'm afraid I'll not be of much help with OCFS2 anymore..
Regarding DLM problems, Joel already said he'll have a look at this. I'll ask him if
he's had some progress..
Thanks
regards
nik

> thanks,
> wengang.
> On 10-11-12 20:04, Nikola Ciprich wrote:
> > Hello,
> > I've done some testing with OCFS2 in 2.6.36 and found few problems:
> > my first problem is general protection fault at configfs lockspace removal..
> > it's maybe not OCFS related, but I'm getting those crashes only with OCFS, 
> > not with other configfs using stuff (like CLVMD)
> > bugzilla:
> > https://bugzilla.kernel.org/show_bug.cgi?id=22782
> > 
> > second problem seems clearly OCFS related, I just got GPF while trying
> > to mount OCFS volume:
> > 
> > [ 1347.188412] general protection fault: 0000 [#1] PREEMPT SMP 
> > [ 1347.188594] last sysfs file: /sys/kernel/dlm/30D118C784964730BDAF2115299250CD/event_done
> > [ 1347.188733] CPU 0 
> > [ 1347.188767] Modules linked in: ocfs2 ocfs2_nodemanager ocfs2_stack_user ocfs2_stackglue dlm configfs drbd lru_cache cn nfs nfs_acl auth_rpcgss ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT xt_tcpudp iptable_filter ip_tables x_tables ipv6 autofs4 lockd sunrpc bridge stp llc ext3 jbd sbs sbshc fan battery ac kvm_intel kvm ppdev i3200_edac e1000e sg edac_core shpchp video parport_pc parport backlight processor pci_hotplug pcspkr cdc_acm i2c_i801 i2c_core iTCO_wdt thermal button container output thermal_sys sd_mod crc_t10dif raid1 dm_snapshot dm_zero dm_mirror dm_region_hash dm_log dm_mod ext4 jbd2 crc32 crc16 uhci_hcd ohci_hcd ehci_hcd ahci libahci libata scsi_mod [last unloaded: ocfs2_nodemanager]
> > [ 1347.191957] 
> > [ 1347.192037] Pid: 11015, comm: mount.ocfs2 Not tainted 2.6.36lb.00_01_PRE12.debug #1 X7SBA/X7SBA
> > [ 1347.192179] RIP: 0010:[<ffffffff81110e35>]  [<ffffffff81110e35>] __kmalloc+0x95/0x250
> > [ 1347.192351] RSP: 0018:ffff8800cf867ad8  EFLAGS: 00010086
> > [ 1347.192384] RAX: 0000000000000000 RBX: ffffffff816666a0 RCX: 0000000000000001
> > [ 1347.192384] RDX: ffff88000220fd60 RSI: 00000000000006a5 RDI: ffffffff81110e16
> > [ 1347.192384] RBP: ffff8800cf867b18 R08: ffff8800cf867b3c R09: 0000000000000000
> > [ 1347.192384] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000202
> > [ 1347.192384] R13: fe16f3f89bcfe06f R14: 00000000000080d0 R15: 00000000000080d0
> > [ 1347.192384] FS:  00007f6d723dd700(0000) GS:ffff880002200000(0000) knlGS:0000000000000000
> > [ 1347.192384] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> > [ 1347.192384] CR2: 0000000002444770 CR3: 00000000cf845000 CR4: 00000000000406f0
> > [ 1347.192384] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > [ 1347.192384] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> > [ 1347.192384] Process mount.ocfs2 (pid: 11015, threadinfo ffff8800cf866000, task ffff8800cfb0a760)
> > [ 1347.192384] Stack:
> > [ 1347.192384]  ffff8800cf867af8 0000000000000010 ffffffffa0745455 0000000000000000
> > [ 1347.192384] <0> ffff8800be08f000 ffff8800be08f000 0000000000000000 0000000000000000
> > [ 1347.192384] <0> ffff8800cf867b68 ffffffffa0745455 0000000000000020 0000000000000000
> > [ 1347.192384] Call Trace:
> > [ 1347.192384]  [<ffffffffa0745455>] ? ocfs2_compute_replay_slots+0x55/0x180 [ocfs2]
> > [ 1347.192384]  [<ffffffffa0745455>] ocfs2_compute_replay_slots+0x55/0x180 [ocfs2]
> > [ 1347.192384]  [<ffffffffa077c2d5>] ocfs2_check_volume+0x105/0x8c0 [ocfs2]
> > [ 1347.192384]  [<ffffffffa077cdfd>] ocfs2_mount_volume+0x36d/0x910 [ocfs2]
> > [ 1347.192384]  [<ffffffff81199928>] ? debugfs_create_file+0x138/0x260
> > [ 1347.192384]  [<ffffffffa0780cfb>] ocfs2_fill_super+0x119b/0x30d0 [ocfs2]
> > [ 1347.192384]  [<ffffffff8107bcdd>] ? trace_hardirqs_on+0xd/0x10
> > [ 1347.192384]  [<ffffffff8107bcdd>] ? trace_hardirqs_on+0xd/0x10
> > [ 1347.192384]  [<ffffffff811219d6>] get_sb_bdev+0x186/0x1b0
> > [ 1347.192384]  [<ffffffffa077fb60>] ? ocfs2_fill_super+0x0/0x30d0 [ocfs2]
> > [ 1347.192384]  [<ffffffffa077a683>] ocfs2_get_sb+0x13/0x20 [ocfs2]
> > [ 1347.192384]  [<ffffffff81120da9>] vfs_kern_mount+0x89/0x1e0
> > [ 1347.192384]  [<ffffffff81120f6e>] do_kern_mount+0x4e/0x110
> > [ 1347.192384]  [<ffffffff8113a8d5>] do_mount+0x505/0x7b0
> > [ 1347.192384]  [<ffffffff810dab22>] ? __get_free_pages+0x12/0x50
> > [ 1347.192384]  [<ffffffff8113ac0a>] sys_mount+0x8a/0xd0
> > [ 1347.192384]  [<ffffffff813790e9>] ? trace_hardirqs_on_thunk+0x3a/0x3f
> > [ 1347.192384]  [<ffffffff810023eb>] system_call_fastpath+0x16/0x1b
> > [ 1347.192384] Code: 00 00 00 9c 41 5c fa e8 2a 8e f6 ff 65 48 8b 14 25 58 d4 00 00 48 8b 03 48 01 c2 4c 8b 2a 4d 85 ed 0f 84 81 01 00 00 48 63 43 18 <4a> 8b 04 28 48 89 02 41 f7 c4 00 02 00 00 75 40 41 54 9d e8 f3 
> > [ 1347.192384] RIP  [<ffffffff81110e35>] __kmalloc+0x95/0x250
> > [ 1347.192384]  RSP <ffff8800cf867ad8>
> > [ 1347.192384] ---[ end trace 33209c73f85ddf7f ]---
> > 
> > If I can help to debug those problems, I'll gladly do it, but I'll certainly need somebody
> > to advise me a bit...
> > with best regards
> > nik
> > 
> > 
> > -- 
> > -------------------------------------
> > Ing. Nikola CIPRICH
> > LinuxBox.cz, s.r.o.
> > 28. rijna 168, 709 01 Ostrava
> > 
> > tel.:   +420 596 603 142
> > fax:    +420 596 621 273
> > mobil:  +420 777 093 799
> > 
> > www.linuxbox.cz
> > 
> > mobil servis: +420 737 238 656
> > email servis: servis at linuxbox.cz
> > -------------------------------------
> > 
> > _______________________________________________
> > Ocfs2-devel mailing list
> > Ocfs2-devel at oss.oracle.com
> > http://oss.oracle.com/mailman/listinfo/ocfs2-devel

-- 
-------------------------------------
Ing. Nikola CIPRICH
LinuxBox.cz, s.r.o.
28. rijna 168, 709 01 Ostrava

tel.:   +420 596 603 142
fax:    +420 596 621 273
mobil:  +420 777 093 799
www.linuxbox.cz

mobil servis: +420 737 238 656
email servis: servis at linuxbox.cz
-------------------------------------
-------------- next part --------------
A non-text attachment was scrubbed...
Name: not available
Type: application/pgp-signature
Size: 198 bytes
Desc: not available
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20101222/a20d6b70/attachment-0001.bin 
