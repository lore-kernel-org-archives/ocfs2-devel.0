From: Ben Nagy <ben@iagu.net>
Date: Mon, 04 Apr 2011 12:15:46 -0000
Subject: [Ocfs2-devel] ocfs2 1.6.3 kernel bug w/ 2.6.38-8
Message-ID: <BANLkTikA+gL-cioQavgi-6HPBO_kqvyPtw@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,

I'm running a 48-core AMD box under KVM load, and working through a
lot of scalability issues, one of which is that ocfs2 seems to
collapse intermittently under load (although the IO should not be that
high)

Here's the syslog output:


Apr  4 16:06:52 eax kernel: [ 2685.328494] ------------[ cut here ]------------
Apr  4 16:06:52 eax kernel: [ 2685.328518] kernel BUG at
/home/fuzzadmin/src/natty/source/fs/jbd2/journal.c:1610!
Apr  4 16:06:52 eax kernel: [ 2685.328539] invalid opcode: 0000 [#1] SMP
Apr  4 16:06:52 eax kernel: [ 2685.328572] last sysfs file:
/sys/devices/system/cpu/cpu47/cache/index2/shared_cpu_map
Apr  4 16:06:52 eax kernel: [ 2685.328590] CPU 42
Apr  4 16:06:52 eax kernel: [ 2685.328608] Modules linked in: ocfs2
quota_tree ip6table_filter ip6_tables w83627ehf hwmon_vid
ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4
xt_state nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle xt_tcpudp
iptable_filter ip_tables x_tables bridge stp joydev ipmi_si
ipmi_msghandler ocfs2_dlmfs ocfs2_stack_o2cb ib_srp ocfs2_dlm
scsi_transport_srp scsi_tgt ocfs2_nodemanager ocfs2_stackglue ib_ipoib
ib_iser ib_umad configfs iscsi_tcp rdma_ucm psmouse rdma_cm
libiscsi_tcp libiscsi ib_cm iw_cm scsi_transport_iscsi ib_addr ib_sa
ib_uverbs mlx4_ib ib_mad ib_core vhost_net sp5100_tco ghes kvm_amd
i2c_piix4 hed amd64_edac_mod edac_core serio_raw edac_mce_amd k10temp
kvm usbhid lp hid parport usb_storage uas ahci igb pata_atiixp libahci
mlx4_core dca
Apr  4 16:06:52 eax kernel: [ 2685.329045]
Apr  4 16:06:52 eax kernel: [ 2685.329054] Pid: 1739, comm: ocfs2cmt
Not tainted 2.6.38-8-server #40 Supermicro H8QG6/H8QG6
Apr  4 16:06:52 eax kernel: [ 2685.329102] RIP:
0010:[<ffffffff8124923a>]  [<ffffffff8124923a>]
jbd2_journal_flush+0x17a/0x190
Apr  4 16:06:52 eax kernel: [ 2685.329169] RSP: 0018:ffff880407775dc0
EFLAGS: 00010286
Apr  4 16:06:52 eax kernel: [ 2685.329217] RAX: 0000000000000029 RBX:
ffff880404b23000 RCX: 000000000000001e
Apr  4 16:06:52 eax kernel: [ 2685.329271] RDX: 00000000fffffffb RSI:
ffff880407775cd0 RDI: ffff880404b23024
Apr  4 16:06:52 eax kernel: [ 2685.329325] RBP: ffff880407775df0 R08:
ffff880407774000 R09: 0000000000000000
Apr  4 16:06:52 eax kernel: [ 2685.329378] R10: 0000000000000000 R11:
0000000000000001 R12: 0000000000001150
Apr  4 16:06:52 eax kernel: [ 2685.329432] R13: ffff880404b2339c R14:
ffff880404b23024 R15: 0000000000000000
Apr  4 16:06:52 eax kernel: [ 2685.329486] FS:  00007f3e2aa1b7a0(0000)
GS:ffff881827c00000(0000) knlGS:0000000000000000
Apr  4 16:06:52 eax kernel: [ 2685.329569] CS:  0010 DS: 0000 ES: 0000
CR0: 000000008005003b
Apr  4 16:06:52 eax kernel: [ 2685.329618] CR2: 000000007ca3f62d CR3:
0000000eb88bd000 CR4: 00000000000006e0
Apr  4 16:06:52 eax kernel: [ 2685.329672] DR0: 00000000000000a0 DR1:
0000000000000000 DR2: 0000000000000003
Apr  4 16:06:52 eax kernel: [ 2685.329726] DR3: 00000000000000b0 DR6:
00000000ffff0ff0 DR7: 0000000000000400
Apr  4 16:06:52 eax kernel: [ 2685.329780] Process ocfs2cmt (pid:
1739, threadinfo ffff880407774000, task ffff8803f88416e0)
Apr  4 16:06:52 eax kernel: [ 2685.329863] Stack:
Apr  4 16:06:52 eax kernel: [ 2685.329899]  0000000000000100
ffff8804077ae240 ffff8804077ae278 ffff8803f88416e0
Apr  4 16:06:52 eax kernel: [ 2685.329988]  ffff8803f5e4c000
ffff8803f5e4c160 ffff880407775e40 ffffffffa0421f12
Apr  4 16:06:52 eax kernel: [ 2685.330104]  0000000000000286
0000000000000286 ffffffffffffff04 ffff8804077ae268
Apr  4 16:06:52 eax kernel: [ 2685.330194] Call Trace:
Apr  4 16:06:52 eax kernel: [ 2685.330270]  [<ffffffffa0421f12>]
ocfs2_commit_cache+0xc2/0x330 [ocfs2]
Apr  4 16:06:52 eax kernel: [ 2685.330336]  [<ffffffffa04221e1>]
ocfs2_commit_thread+0x61/0x210 [ocfs2]
Apr  4 16:06:52 eax kernel: [ 2685.330394]  [<ffffffff81087950>] ?
autoremove_wake_function+0x0/0x40
Apr  4 16:06:52 eax kernel: [ 2685.330456]  [<ffffffffa0422180>] ?
ocfs2_commit_thread+0x0/0x210 [ocfs2]
Apr  4 16:06:52 eax kernel: [ 2685.330511]  [<ffffffff81087206>]
kthread+0x96/0xa0
Apr  4 16:06:52 eax kernel: [ 2685.330561]  [<ffffffff8100cde4>]
kernel_thread_helper+0x4/0x10
Apr  4 16:06:52 eax kernel: [ 2685.330612]  [<ffffffff81087170>] ?
kthread+0x0/0xa0
Apr  4 16:06:52 eax kernel: [ 2685.330561]  [<ffffffff8100cde4>]
kernel_thread_helper+0x4/0x10
Apr  4 16:06:52 eax kernel: [ 2685.330612]  [<ffffffff81087170>] ?
kthread+0x0/0xa0
Apr  4 16:06:52 eax kernel: [ 2685.330660]  [<ffffffff8100cde0>] ?
kernel_thread_helper+0x0/0x10
Apr  4 16:06:52 eax kernel: [ 2685.330709] Code: c0 5b 41 5c 41 5d 41
5e 41 5f c9 c3 0f 1f 44 00 00 4c 8b 63 58 4d 85 e4 0f 85 d2 fe ff ff
f0 81 43 24 00 00 00 01 e9 da fe ff ff <0f> 0b 0f 0b 0f 0b 0f 0b 0f 0b
66 66 66 2e 0f 1f 84 00 00 00 00
Apr  4 16:06:52 eax kernel: [ 2685.331030] RIP  [<ffffffff8124923a>]
jbd2_journal_flush+0x17a/0x190
Apr  4 16:06:52 eax kernel: [ 2685.331083]  RSP <ffff880407775dc0>
Apr  4 16:06:52 eax kernel: [ 2685.331517] ---[ end trace c386c7bbf4ee2fe3 ]---

uname: Linux eax 2.6.38-8-server #40 SMP Mon Apr 4 15:10:33 SGT 2011
x86_64 x86_64 x86_64 GNU/Linux
(tracking git on the Natty kernel, also contains a patch to
posix-timers.c to fix a KVM issue)
ocfs version I believe is 1.6.3-1ubuntu2

Any more information you would like, or troubleshooting you'd like me
to do just let me know.

By the way, we ran exactly the same workload on a local ext4 partition
and didn't see the fault.

Many thanks for any help or tips for further troubleshooting...

Cheers,

ben
