From: David Teigland <teigland@redhat.com>
Date: Mon, 1 Feb 2010 14:19:30 -0600
Subject: [Ocfs2-devel] [PATCH] ocfs2: Do not downconvert if the lock
	level is already compatible
In-Reply-To: <4B637A67.6070007@oracle.com>
References: <4B632024.1090102@oracle.com> <20100129222102.GC16606@redhat.com>
	<4B637A67.6070007@oracle.com>
Message-ID: <20100201201930.GA25885@redhat.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Jan 29, 2010 at 04:16:39PM -0800, Sunil Mushran wrote:
> David Teigland wrote:
> >With this patch I ran alternate and make_panic for about 2.5 hours, and
> >then one node hit this BUG.  /var/log/messages didn't catch any of it, so
> >no additional info this time.
> >
> >kernel BUG at fs/ocfs2/dlmglue.c:3395
> 
> David,
> 
> Please could you re-run with this debug patch.
> 
> http://oss.oracle.com/~smushran/.dlmglue/0001-ocfs2-Patch-to-debug-hang-in-dlmglue-when-running-dl.patch

I'm working to compress the full logs, but until then here is what
appeared just before the oops on the second node:


Feb  1 13:25:28 bull-02 kernel: (7072000003f00400000000, level 3, inc holders, ex 0, ro 1
Feb  1 13:25:28 bull-02 kernel: (70000003f00400000000, level 3, inc holders, ex 0, ro 1
Feb  1 13:25:28 bull-02 kernel: (7072,3,000003f00400000000, level 3, inc holders, ex 0, ro 1
Feb  1 13:25:28 bull-02 kernel: (7072,3,000003f00400000000, level 3, inc holders, ex 0, ro 1
Feb  1 13:25:28 bull-02 kernel: (7072,3,al000003f00400000000, level 3, inc holders, ex 0, ro 1
Feb  1 13:25:28 bull-02 kernel: (707000003f00400000000, level 3, inc holders, ex 0, ro 1
Feb  1 13:25:28 bull-02 kernel: (7072,3,000003f00400000000, level 3, inc holders, ex 0, ro 1000003f00400000000, level 3, inc holders, ex 0, ro 1
Feb  1 13:25:28 bull-02 kernel: (7072,3,alter000003f00400000000, level 3, inc holders, ex 0, ro 1
Feb  1 13:25:28 bull-02 kernel: (7072,3,000003f00400000000, level 3, inc holders, ex 0, ro 1
Feb  1 13:25:28 bull-02 kernel: (7072,3,alter000003f00400000000, level 3, inc holders, ex 0, ro 1
Feb  1 13:25:28 bull-02 kernel: (7072,3,alte000003f00400000000, level 3, inc holders, ex 0, ro 1
Feb  1 13:25:28 bull-02 kernel: (7072,3,a000003f00400000000, level 3, inc holders, ex 0, ro 1
Feb  1 13:25:28 bull-02 kernel: (7072,3,alter000003f00400000000, level 3, inc holders, ex 0, ro 1
Feb  1 13:25:28 bull-02 kernel: (7072,000003f00400000000, level 3, inc holders, ex 0, ro 1
Feb  1 13:25:28 bull-02 kernel: (70000003f00400000000, level 3, inc holders, ex 0, ro 1
Feb  1 13:25:28 bull-02 kernel: (7072,3,000003f00400000000, level 3, inc holders, ex 0, ro 1
Feb  1 13:25:28 bull-02 kernel: <5000003f00400000000, level 3, inc holders, ex 0, ro 1
Feb  1 13:25:28 bull-02 kernel: (7072,3,000003f00400000000, level 3, inc holders, ex 0, ro 1
Feb  1 13:25:28 bull-02 kernel: (7072,3,al000003f00400000000, level 3, inc holders, ex 0, ro 1
Feb  1 13:25:28 bull-02 kernel: (707000003f00400000000, level 3, inc holders, ex 0, ro 1
Feb  1 13:25:28 bull-02 kernel: (7072,3,000003f00400000000, level 3, inc holders, ex 0, ro 1
Feb  1 13:25:28 bull-02 kernel: (70000003f00400000000, level 3, inc holders, ex 0, ro 1
Feb  1 13:25:28 bull-02 kernel: (7072,3,000003f00400000000, level 3, inc holders, ex 0, ro 1
Feb  1 13:25:28 bull-02 kernel: (7072,3000003f00400000000, level 3, inc holders, ex 0, ro 1
Feb  1 13:25:28 bull-02 kernel: (7072,3,alt000003f00400000000, level 3, inc holders, ex 0, ro 1
Feb  1 13:25:28 bull-02 kernel: (7072,3,000003f00400000000, level 3, inc holders, ex 0, ro 1
Feb  1 13:25:28 bull-02 kernel: (7072,000003f00400000000, level 3, inc holders, ex 0, ro 1
Feb  1 13:25:28 bull-02 kernel: (7072,3,al000003f00400000000, level 3, inc holders, ex 0000003f00400000000, level 3, inc holders, ex 0, ro 1
Feb  1 13:25:28 bull-02 kernel: (7072000003f00400000000, level 3, inc holders, ex 0, ro 1
Feb  1 13:25:28 bull-02 kernel: (7072,3,al000003f00400000000, level 3, inc holders, ex 0, ro 1
Feb  1 13:25:28 bull-02 kernel: (7072,3,al000003f00400000000, level 3, inc holders, ex 0, ro 1
Feb  1 13:25:28 bull-02 kernel: (7072,3,al000003f00400000000, level 3, inc holders, ex 0, ro 1
Feb  1 13:25:28 bull-02 kernel: (7072,3,al000003f00400000000, level 3, inc holders, ex 0, ro 1
Feb  1 13:25:28 bull-02 kernel: (7072,3,al000003f00400000000, level 3, inc holders, ex 0, ro 1
Feb  1 13:25:28 bull-02 kernel: (7072,3,al000003f00400000000, level 3, inc holders, ex 0, ro 1
Feb  1 13:25:28 bull-02 kernel: (7072,3,al000003f00400000000, level 3, inc holders, ex 0, ro 1
Feb  1 13:25:28 bull-02 kernel: (7072,3,al000003f00400000000, level 3, inc holders, ex 0, ro 1
Feb  1 13:25:28 bull-02 kernel: (7072,3,al000003f00400000000, level 3, inc holders, ex 0, ro 1
Feb  1 13:25:28 bull-02 kernel: (7072,3,al000003f00400000000, level 3, inc holders, ex 0, ro 1
Feb  1 13:25:28 bull-02 kernel: (7072,3,al000003f00400000000, level 3, inc holders, ex 0, ro 1
Feb  1 13:25:28 bull-02 kernel: (7072,3,a000003f00400000000, level 3, inc holders, ex 0, ro 1
Feb  1 13:25:28 bull-02 kernel: (7072,3,al000003f00400000000, level 3, inc holders, ex 0, ro 1
Feb  1 13:25:28 bull-02 kernel: (7072,3,al000003f00400000000, level 3, inc holders, ex 0, ro 1
Feb  1 13:25:28 bull-02 kernel: (7072,3,al000003f00400000000, level 3, inc holders, ex 0, ro 1
Feb  1 13:25:28 bull-02 kernel: (7072,3,al000003f00400000000, level 3, inc holders, ex 0, ro 1
Feb  1 13:25:28 bull-02 kernel: (7072,3,al000003f00400000000, level 3, inc holders, ex 0, ro 1
Feb  1 13:25:28 bull-02 kernel: (7072,3,al000003f00400000000, level 3, inc holders, ex 0, ro 1
Feb  1 13:25:28 bull-02 kernel: (7072,3,al000003f00400000000, level 3, inc holders, ex 0, ro 1
Feb  1 13:25:28 bull-02 kernel: (7072,3,al000003f00400000000, level 3, inc holders, ex 0, ro 1
Feb  1 13:25:28 bull-02 kernel: (7072,3,al000003f00400000000, level 3, inc holders, ex 0, ro 1
Feb  1 13:25:28 bull-02 kernel: (7072,3,a000003f00400000000, level 3, inc holders, ex 0, ro 1
Feb  1 13:25:28 bull-02 kernel: (7072,3,al000003f00400000000, level 3, inc holders, ex 0, ro 1
Feb  1 13:25:28 bull-02 kernel: (7072,3,altern000003f00400000000, level 3, inc holders, ex 0, ro 1
Feb  1 13:25:28 bull-02 kernel: (7072,3,a000003f00400000000, level 3, inc holders, ex 0, ro 1
Feb  1 13:25:28 bull-02 kernel: (7072,3,al000003f00400000000, level 3, inc holders, ex 0, ro 1
Feb  1 13:25:28 bull-02 kernel: (7072,3,al000003f00400000000, level 3, inc holders, ex 0, ro 1
Feb  1 13:25:28 bull-02 kernel: (7072,3,al000003f00400000000, level 3, inc holders, ex 0, ro 1
Feb  1 13:25:28 bull-02 kernel: (7072,3,000003f00400000000, level 3, inc holders, ex 0, ro 1
Feb  1 13:25:28 bull-02 kernel: (7072,3,al000003f00400000000, level 3, inc holders, ex 0, ro 1
Feb  1 13:25:28 bull-02 kernel: (7072,3,alt000003f00400000000, level 3, inc holders, ex 0, ro 1
Feb  1 13:25:28 bull-02 kernel: (7072,3,al000003f00400000000, level 3, inc holders, ex 0, ro 1
Feb  1 13:25:28 bull-02 kernel: (7072,3,al000003f00400000000, level 3, inc holders, ex 0, ro 1
Feb  1 13:25:28 bull-02 kernel: (7072,3,al000003f00400000000, level 3, inc holders, ex 0, ro 1
Feb  1 13:25:28 bull-02 kernel: (7072,3,a000003f00400000000, level 3, inc holders, ex 0, ro 1
Feb  1 13:25:28 bull-02 kernel: (7072,3,al000003f00400000000, level 3, inc holders, ex 0, ro 1
Feb  1 13:25:28 bull-02 kernel: (7072,3,a000003f00400000000, level 3, inc holders, ex 0, ro 1
Feb  1 13:25:28 bull-02 kernel: (7072,3,al000003f00400000000, level 3, inc holders, ex 0, ro 1
Feb  1 13:25:28 bull-02 kernel: (7072,3,al000003f00400000000, level 3, inc holders, ex 0, ro 1
Feb  1 13:25:28 bull-02 kernel: (7072,3,al000003f00400000000, level 3, inc holders, ex 0, ro 1
Feb  1 13:25:28 bull-02 kernel: (7072,3,al000003f00400000000, level 3, inc holders, ex 0, ro 1
Feb  1 13:25:28 bull-02 kernel: (7072,3,alt000003f00400000000, level 3, inc holders, ex 0, ro 1
Feb  1 13:25:28 bull-02 kernel: (70000003f00400000000, level 3, inc holders, ex 0, ro 1
Feb  1 13:25:28 bull-02 kernel: (7072,3000003f00400000000, level 3, inc holders,

kernel BUG@fs/ocfs2/dlmglue.c:3420!
invalid opcode: 0000 [#1] SMP
last sysfs file: /sys/devices/pci0000:80/0000:80:02.0/0000:86:01.0/local_cpus
CPU 3
Modules linked in: ocfs2_stack_user dlm ocfs2 ocfs2_nodemanager configfs ocfs2_stackglue sunrpc ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core shpchp tg3 k8temp serio_raw edac_core qla2xxx mptspi mptscsih ata_generic scsi_transport_fc pata_acpi mptbase scsi_transport_spi scsi_tgt sata_nv pata_amd [last unloaded: scsi_wait_scan]
Pid: 7077, comm: ocfs2dc Not tainted 2.6.32.3 #2 ProLiant DL145 G2
RIP: 0010:[<ffffffffa01eae36>]  [<ffffffffa01eae36>] ocfs2_downconvert_thread+0x4cb/0xdad [ocfs2]
RSP: 0018:ffff88007ce91d90  EFLAGS: 00010046
RAX: 00000000000000b8 RBX: ffff88007c222e50 RCX: 0000000000002784
RDX: 0000000000000000 RSI: 0000000000000046 RDI: 0000000000000046
RBP: ffff88007ce91ee0 R08: 00000000ffffffff R09: 0000000000000000
R10: 0000000000000003 R11: 000000107ce91900 R12: 0000000000000282
R13: 0000000000000000 R14: ffff88007bb15000 R15: ffff88007c222e68
FS:  00007ffabdf1a700(0000) GS:ffff880082100000(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 00007fe3e403b1c8 CR3: 000000013cd84000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process ocfs2dc (pid: 7077, threadinfo ffff88007ce90000, task ffff8800365b1740)
Stack:
 ffff88007c222e98 ffffffff00000000 ffff880000000001 ffffffff00000001
<0> 0000000000000000 0000000000000041 0000000000000000 ffff880000000000
<0> ffffffff00000000 ffff880000000000 ffff880000000000 ffffffff00000000
Call Trace:
 [<ffffffff81074f6b>] ? autoremove_wake_function+0x0/0x39
 [<ffffffffa01ea96b>] ? ocfs2_downconvert_thread+0x0/0xdad [ocfs2]
 [<ffffffff81074c7e>] kthread+0x7f/0x87
 [<ffffffff81012cea>] child_rip+0xa/0x20
 [<ffffffff81074bff>] ? kthread+0x0/0x87
 [<ffffffff81012ce0>] ? child_rip+0x0/0x20
Code: 24 10 8b 43 68 89 44 24 08 48 8d 43 48 48 89 04 24 31 c0 e8 d0 5e 24 e1 f6 43 40 04 74 0d 4c 8d 63 48 c7 45 8c 00 00 00 00 eb 04 <0f> 0b eb fe 48 8b 4b 40 f6 c1 02 0f 84 2d 01 00 00 80 e5 04 74
RIP  [<ffffffffa01eae36>] ocfs2_downconvert_thread+0x4cb/0xdad [ocfs2]
 RSP <ffff88007ce91d90>
