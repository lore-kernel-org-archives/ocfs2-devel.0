From: David Teigland <teigland@redhat.com>
Date: Fri, 5 Feb 2010 10:24:26 -0600
Subject: [Ocfs2-devel] [PATCH] ocfs2: Plugs race between the dc thread
	and an unlock ast message
In-Reply-To: <4B6B21BE.10708@oracle.com>
References: <1265221014-10591-1-git-send-email-sunil.mushran@oracle.com>
	<20100204102729.GA4339@laptop.oracle.com>
	<4B6B21BE.10708@oracle.com>
Message-ID: <20100205162426.GA27004@redhat.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Feb 04, 2010 at 11:36:30AM -0800, Sunil Mushran wrote:
> Wengang Wang wrote:
> >By "unlock ast message", do you meant
> >ocfs2_locking_ast()->ocfs2_generic_handle_downconvert_action()?
> >
> >If yes, 
> >if l_blocking did not changed before 
> >ocfs2_generic_handle_downconvert_action(),
> >when l_level is set with a lower value, l_blocking must change.
> >So why we need to check l_level?
> 
> I meant ocfs2_unlock_ast. Specifically cancel convert. That is one case
> that does not change l_blocking directly.
> 
> However, that does not change the l_level too. So I am unsure what sequence
> of asts and basts (multiple ofcourse) can lead to this situation.
> 
> But the patch looks reasonable even if I cannot state the precise scenario
> that leads to it.
> 
> David is rerunning the test. We'll know the results by tomorrow.

Got this after about 10 hours (and I believe before updatedb would have
started running):

Feb  4 21:50:23 bull-05 kernel: (8034,2,ocfs2dc):ocfs2_prepare_downconvert:3280
ERROR: lockres->l_level (-1) <= new_level (0)
Feb  4 21:50:23 bull-05 kernel: kernel BUG at fs/ocfs2/dlmglue.c:3281!

kernel BUG@fs/ocfs2/dlmglue.c:3281!
invalid opcode: 0000 [#1] SMP
last sysfs file: /sys/devices/pci0000:00/0000:00:0d.0/0000:03:00.0/irq
CPU 2
Modules linked in: ocfs2_stack_user dlm ocfs2 ocfs2_nodemanager configfs ocfs2_stackglue sunrpc ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath shpchp amd64_edac_mod edac_core i2c_nforce2 i2c_core k8temp tg3 serio_raw qla2xxx mptspi mptscsih ata_generic scsi_transport_fc pata_acpi mptbase scsi_transport_spi scsi_tgt sata_nv pata_amd [last unloaded: scsi_wait_scan]
Pid: 8034, comm: ocfs2dc Not tainted 2.6.32.3 #2 ProLiant DL145 G2
RIP: 0010:[<ffffffffa01df58f>]  [<ffffffffa01df58f>] ocfs2_prepare_downconvert+0x9c/0x131 [ocfs2]
RSP: 0018:ffff88007ceffda0  EFLAGS: 00010082
RAX: 0000000000000064 RBX: ffff8800505808d0 RCX: 00000000000023a6
RDX: 0000000000000000 RSI: 0000000000000046 RDI: 0000000000000046
RBP: ffff88007ceffdd0 R08: ffff88007ceffca0 R09: 0000000000000000
R10: 0000000000000000 R11: 000000107aa1fc00 R12: 0000000000000000
R13: 0000000000000293 R14: ffff880139fcd000 R15: ffff8800505808e8
FS:  00007f1627c76700(0000) GS:ffff880082000000(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 00007fffe0020f08 CR3: 0000000139fb3000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process ocfs2dc (pid: 8034, threadinfo ffff88007cefe000, task ffff88007cf3dd00)
Stack:
 ffff8800ffffffff 0000000000000000 ffff88007ceffe80 ffff8800505808d0
<0> ffff8800505808d0 0000000000000000 ffff88007ceffee0 ffffffffa01e2e27
<0> ffff88007ceffe10 ffffffff8104e867 ffff88007d372d80 0000000000000000
Call Trace:
 [<ffffffffa01e2e27>] ocfs2_downconvert_thread+0x674/0xa0e [ocfs2]
 [<ffffffff8104e867>] ? finish_task_switch+0x58/0x77
 [<ffffffff81074f6b>] ? autoremove_wake_function+0x0/0x39
 [<ffffffffa01e27b3>] ? ocfs2_downconvert_thread+0x0/0xa0e [ocfs2]
 [<ffffffff81074c7e>] kthread+0x7f/0x87
 [<ffffffff81012cea>] child_rip+0xa/0x20
 [<ffffffff81074bff>] ? kthread+0x0/0x87
 [<ffffffff81012ce0>] ? child_rip+0x0/0x20
Code: 65 8b 14 25 68 e3 00 00 41 b9 d0 0c 00 00 48 63 d2 49 c7 c0 70 99 23 a0 48 c7 c7 25 12 24 a0 31 c0 44 89 64 24 08 e8 64 17 25 e1 <0f> 0b eb fe f6 05 48 95 fb ff 08 74 56 f6 05 47 95 fb ff 08 75
RIP  [<ffffffffa01df58f>] ocfs2_prepare_downconvert+0x9c/0x131 [ocfs2]
 RSP <ffff88007ceffda0>
