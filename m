From: Smart Weblications GmbH - Florian Wiessner <f.wiessner@smart-weblications.de>
Date: Thu, 07 Feb 2013 02:05:10 -0000
Subject: [Ocfs2-devel] problem with ocfs2 in 3.7.6 and 3.6.11
Message-ID: <51130BAB.9080305@smart-weblications.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com, LKML <linux-kernel@vger.kernel.org>
Cc: mfasheh@suse.com, joel.becker@oracle.com

Hi All,


Today i found a problem in linux 3.7.6 with ocfs2 when using ocfs2 from inside a
chroot or linux-vserver guest. This problem also exists at least in 3.6.11.

how to reproduce:

node:~# cat /etc/debian_version
6.0.6

node:~# rbd showmapped
id pool image snap device
1  rbd  ocfs2 -    /dev/rbd1

mounted ocfs2 fs on rdb device on /ocfs2:
/dev/rbd1 on /ocfs2 type ocfs2 (rw,_netdev,noatime,data=writeback,heartbeat=local)


mount --bind /ocfs2 /var/lib/vservers/www/ocfs2
chroot /var/lib/vservers/www


www:/# cat /etc/debian_version
5.0.10

DocumentRoots for apache are on ocfs2

/etc/init.d/apache2 start


Then apache hangs and i have to reboot, see trace (annotated with addr2line
where available):

[  225.548824] general protection fault: 0000[#1] PREEMPT SMP
[  225.549067] Modules linked in: ipt_REJECT xt_multiport arpt_mangle
arptable_filter arp_tables ip6table_filter ip6_tables iptable_filter ip_tables
ebtable_nat ebtables x_tables cpufreq_userspace cpufreq_powersave
cpufreq_ondemand cpufreq_conservative ocfs2_stack_o2cb bridge stp llc bonding
fuse ocfs2_dlm ocfs2_dlmfs dlm sctp ocfs2 ocfs2_nodemanager ocfs2_stackglue
configfs rbd acpi_cpufreq mperf coretemp kvm_intel kvm psmouse serio_raw lpc_ich
mfd_core i2c_i801 evdev i2c_core btrfs lzo_compress
[  225.551698] CPU 1
[  225.551755] Pid: 5888, comm: apache2 Not tainted 3.7.6 #1 Supermicro
X9SCI/X9SCA/X9SCI/X9SCA
[  225.551913] RIP: 0010:[<ffffffff81299f30>] [<ffffffff81299f30>]
strnlen+0x10/0x19    /lib/string.c:405
[  225.552059] RSP: 0018:ffff8808160a3b80  EFLAGS: 00010216
[  225.552135] RAX: e8894402000000a5 RBX: e8894402000000a5 RCX: 000000000063ea4c
[  225.552215] RDX: 000000000063ea4c RSI: 0000000000000f3f RDI: e8894402000000a5
[  225.552294] RBP: ffffea00170650b8 R08: ffffffff810b8c7e R09: 0000000000000000
[  225.552374] R10: ffff880816b50100 R11: ffff880816b50100 R12: ffff8806974afbf8
[  225.552450] R13: 00000000000200da R14: 00000000000201da R15: 0000000000000000
[  225.552530] FS:  00007eff6d9e2750(0000) GS:ffff88083fc40000(0000)
knlGS:0000000000000000
[  225.552625] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  225.552701] CR2: 00007fa71e7fbd40 CR3: 00000007f7849000 CR4: 00000000000407e0
[  225.552778] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  225.552858] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  225.552938] Process apache2 (pid: 5888, threadinfo ffff8808160a2000, task
ffff880816b50100)
[  225.553032] Stack:
[  225.553103]  ffffffffa06d7d27 ffffea00170650b8 ffff8806974afd38 ffffea00170650b8
[  225.553408]  ffffffff810b8c7e 0000000000000000 ffff8806974afd38 ffffea00170650b8
[  225.553711]  ffffffff810b8ddd ffff8808160a3ca8 ffffffffa06d7c20 ffff8806974d2440
[  225.554016] Call Trace:
[  225.554098] [<ffffffffa06d7d27>] ?
ocfs2_fast_symlink_readpage+0x107/0x1a0[ocfs2]   ??:0
[  225.554194] [<ffffffff810b8c7e>] ? add_to_page_cache_lru+0x2c/0x36
        /include/linux/swap.h:253
[  225.554272] [<ffffffff810b8ddd>] ? do_read_cache_page+0x8f/0x132
        /mm/filemap.c:1802
[  225.554359] [<ffffffffa06d7c20>] ? ocfs2_osb_debug_open+0x670/0x670[ocfs2]
       ??:0
[  225.554442] [<ffffffff810b8ebf>] ? read_cache_page+0x9/0x12
        /mm/filemap.c:1921
[  225.554521] [<ffffffff8110d1e1>] ? page_getlink+0x25/0x86
        /fs/namei.c:3956
[  225.554598] [<ffffffff8110d25d>] ? page_follow_link_light+0x1b/0x2c
        /include/linux/namei.h:88
[  225.554675] [<ffffffff8110e90c>] ? link_path_walk+0x400/0x7c5
        /fs/namei.c:851
[  225.554751] [<ffffffff8110f133>] ? path_lookupat+0x52/0x6cf
        /fs/namei.c:1983
[  225.554835] [<ffffffff8110f7d0>] ? filename_lookup+0x20/0x92
        /fs/namei.c:2024
[  225.554922] [<ffffffff81111a78>] ? getname_flags+0x70/0x146
        /fs/namei.c:159
[  225.554997] [<ffffffff81112376>] ? user_path_at_empty+0x49/0x7d
        /fs/namei.c:2172
[  225.555077] [<ffffffff8104dbee>] ? autoremove_wake_function+0x2a/0x2a
        /kernel/wait.c:174
[  225.555155] [<ffffffff811093d4>] ? cp_new_stat+0x10d/0x11f
        /fs/stat.c:241
[  225.555231] [<ffffffff811095d1>] ? vfs_fstatat+0x39/0x66
        /fs/stat.c:89
[  225.555314] [<ffffffff811096c8>] ? sys_newstat+0x11/0x2d
        /fs/stat.c:248
[  225.555402] [<ffffffff81542dd2>] ? system_call_fastpath+0x16/0x1b
        /arch/x86/kernel/entry_64.S:645
[  225.555480] Code: f6 82 30 a9 58 81 20 75 f1 c3 48 89 f8 eb 03 48 ff c0 80 38
00 75 f8 48 29 f8 c3 48 89 f8 eb 03 48 ff c0 48 85 f6 74 08 48 ff ce <80> 38 00
75 f0 48 29 f8 c3 31 c0 eb 14 44 38 c1 74 0c 48 ff c2
[  225.559020] RIP [<ffffffff81299f30>] strnlen+0x10/0x19
        /lib/string.c:405
[  225.559143]  RSP <ffff8808160a3b80>
[  225.559254] ---[ end trace 10bd8a6b280d52b1 ]---

-- 

Mit freundlichen Gr??en,

Florian Wiessner

Smart Weblications GmbH
Martinsberger Str. 1
D-95119 Naila

fon.: +49 9282 9638 200
fax.: +49 9282 9638 205
24/7: +49 900 144 000 00 - 0,99 EUR/Min*
http://www.smart-weblications.de

--
Sitz der Gesellschaft: Naila
Gesch?ftsf?hrer: Florian Wiessner
HRB-Nr.: HRB 3840 Amtsgericht Hof
*aus dem dt. Festnetz, ggf. abweichende Preise aus dem Mobilfunknetz
-------------- next part --------------
[  225.548824] general protection fault: 0000[#1] PREEMPT SMP
[  225.549067] Modules linked in: ipt_REJECT xt_multiport arpt_mangle arptable_filter arp_tables ip6table_filter ip6_tables iptable_filter ip_tables ebtable_nat ebtables x_tables cpufreq_userspace cpufreq_powersave cpufreq_ondemand cpufreq_conservative ocfs2_stack_o2cb bridge stp llc bonding fuse ocfs2_dlm ocfs2_dlmfs dlm sctp ocfs2 ocfs2_nodemanager ocfs2_stackglue configfs rbd acpi_cpufreq mperf coretemp kvm_intel kvm psmouse serio_raw lpc_ich mfd_core i2c_i801 evdev i2c_core btrfs lzo_compress
[  225.551698] CPU 1
[  225.551755] Pid: 5888, comm: apache2 Not tainted 3.7.6 #1 Supermicro X9SCI/X9SCA/X9SCI/X9SCA
[  225.551913] RIP: 0010:[<ffffffff81299f30>] [<ffffffff81299f30>] strnlen+0x10/0x19    /lib/string.c:405
[  225.552059] RSP: 0018:ffff8808160a3b80  EFLAGS: 00010216
[  225.552135] RAX: e8894402000000a5 RBX: e8894402000000a5 RCX: 000000000063ea4c
[  225.552215] RDX: 000000000063ea4c RSI: 0000000000000f3f RDI: e8894402000000a5
[  225.552294] RBP: ffffea00170650b8 R08: ffffffff810b8c7e R09: 0000000000000000
[  225.552374] R10: ffff880816b50100 R11: ffff880816b50100 R12: ffff8806974afbf8
[  225.552450] R13: 00000000000200da R14: 00000000000201da R15: 0000000000000000
[  225.552530] FS:  00007eff6d9e2750(0000) GS:ffff88083fc40000(0000) knlGS:0000000000000000
[  225.552625] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  225.552701] CR2: 00007fa71e7fbd40 CR3: 00000007f7849000 CR4: 00000000000407e0
[  225.552778] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  225.552858] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  225.552938] Process apache2 (pid: 5888, threadinfo ffff8808160a2000, task ffff880816b50100)
[  225.553032] Stack:
[  225.553103]  ffffffffa06d7d27 ffffea00170650b8 ffff8806974afd38 ffffea00170650b8
[  225.553408]  ffffffff810b8c7e 0000000000000000 ffff8806974afd38 ffffea00170650b8
[  225.553711]  ffffffff810b8ddd ffff8808160a3ca8 ffffffffa06d7c20 ffff8806974d2440
[  225.554016] Call Trace:
[  225.554098] [<ffffffffa06d7d27>] ? ocfs2_fast_symlink_readpage+0x107/0x1a0[ocfs2]   ??:0         
[  225.554194] [<ffffffff810b8c7e>] ? add_to_page_cache_lru+0x2c/0x36                   /include/linux/swap.h:253
[  225.554272] [<ffffffff810b8ddd>] ? do_read_cache_page+0x8f/0x132                     /mm/filemap.c:1802
[  225.554359] [<ffffffffa06d7c20>] ? ocfs2_osb_debug_open+0x670/0x670[ocfs2]          ??:0
[  225.554442] [<ffffffff810b8ebf>] ? read_cache_page+0x9/0x12                          /mm/filemap.c:1921
[  225.554521] [<ffffffff8110d1e1>] ? page_getlink+0x25/0x86                            /fs/namei.c:3956
[  225.554598] [<ffffffff8110d25d>] ? page_follow_link_light+0x1b/0x2c                  /include/linux/namei.h:88
[  225.554675] [<ffffffff8110e90c>] ? link_path_walk+0x400/0x7c5                        /fs/namei.c:851
[  225.554751] [<ffffffff8110f133>] ? path_lookupat+0x52/0x6cf                          /fs/namei.c:1983
[  225.554835] [<ffffffff8110f7d0>] ? filename_lookup+0x20/0x92                         /fs/namei.c:2024
[  225.554922] [<ffffffff81111a78>] ? getname_flags+0x70/0x146                          /fs/namei.c:159
[  225.554997] [<ffffffff81112376>] ? user_path_at_empty+0x49/0x7d                      /fs/namei.c:2172
[  225.555077] [<ffffffff8104dbee>] ? autoremove_wake_function+0x2a/0x2a                /kernel/wait.c:174
[  225.555155] [<ffffffff811093d4>] ? cp_new_stat+0x10d/0x11f                           /fs/stat.c:241
[  225.555231] [<ffffffff811095d1>] ? vfs_fstatat+0x39/0x66                             /fs/stat.c:89
[  225.555314] [<ffffffff811096c8>] ? sys_newstat+0x11/0x2d                             /fs/stat.c:248
[  225.555402] [<ffffffff81542dd2>] ? system_call_fastpath+0x16/0x1b                    /arch/x86/kernel/entry_64.S:645
[  225.555480] Code: f6 82 30 a9 58 81 20 75 f1 c3 48 89 f8 eb 03 48 ff c0 80 38 00 75 f8 48 29 f8 c3 48 89 f8 eb 03 48 ff c0 48 85 f6 74 08 48 ff ce <80> 38 00 75 f0 48 29 f8 c3 31 c0 eb 14 44 38 c1 74 0c 48 ff c2
[  225.559020] RIP [<ffffffff81299f30>] strnlen+0x10/0x19                               /lib/string.c:405
[  225.559143]  RSP <ffff8808160a3b80>
[  225.559254] ---[ end trace 10bd8a6b280d52b1 ]---
