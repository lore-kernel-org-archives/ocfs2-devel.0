From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Tue, 26 Jan 2010 11:18:34 -0800
Subject: [Ocfs2-devel] dlmglue fixes
In-Reply-To: <20100126163749.GA17656@redhat.com>
References: <1264099803-16680-1-git-send-email-sunil.mushran@oracle.com>
	<20100126123325.GB3845@mail.oracle.com>
	<20100126163749.GA17656@redhat.com>
Message-ID: <4B5F400A.9080909@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

David Teigland wrote:
> On Tue, Jan 26, 2010 at 04:33:26AM -0800, Joel Becker wrote:
>   
>> On Thu, Jan 21, 2010 at 10:50:01AM -0800, Sunil Mushran wrote:
>>     
>>> So here are the two patches. Remove all patches that you have and apply
>>> these.
>>>       
>
> I ran http://people.redhat.com/~teigland/make_panic on three nodes for 15
> minutes without any problem, so that's a big improvement.
>
> Then I tried another little test on three nodes which quickly triggered a
> BUG, http://people.redhat.com/~teigland/alternate.c
>
> node1: alternate test 0 0 3
> node2: alternate test 0 1 3
> node3: alternate test 0 2 3
>
> ------------[ cut here ]------------
> kernel BUG at fs/ocfs2/dlmglue.c:3281!
> invalid opcode: 0000 [#1] SMP
> last sysfs file: /sys/devices/pci0000:80/0000:80:02.0/0000:86:01.0/local_cpus
> CPU 1
> Modules linked in: ocfs2_stack_user dlm ocfs2 ocfs2_nodemanager configfs ocfs2_stackglue sunrpc ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath shpchp amd64_edac_mod edac_core serio_raw tg3 i2c_nforce2 k8temp i2c_core qla2xxx mptspi mptscsih scsi_transport_fc ata_generic mptbase pata_acpi scsi_tgt scsi_transport_spi sata_nv pata_amd [last unloaded: scsi_wait_scan]
> Pid: 2523, comm: ocfs2dc Not tainted 2.6.32.3 #2 ProLiant DL145 G2
> RIP: 0010:[<ffffffffa020593d>]  [<ffffffffa020593d>] ocfs2_prepare_downconvert+0x93/0x11c [ocfs2]
> RSP: 0018:ffff88007cd89d90  EFLAGS: 00010082
> RAX: 000000000000005b RBX: ffff88007c5ccc50 RCX: 0000000000000aef
> RDX: 0000000000000000 RSI: 0000000000000046 RDI: 0000000000000046
> RBP: ffff88007cd89db0 R08: ffff88007cd89cd0 R09: 0000000000000000
> R10: 0000000000000000 R11: 000000000006db00 R12: 0000000000000000
> R13: ffff88007cc20000 R14: 0000000000000293 R15: ffff88007c5ccc68
> FS:  00007f77b5a4e700(0000) GS:ffff880028300000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> CR2: 00000000011d8178 CR3: 000000013cee0000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process ocfs2dc (pid: 2523, threadinfo ffff88007cd88000, task ffff880037d00000)
> Stack:
>  ffff880000000000 ffff88007c5ccc50 ffff88007c5ccc50 0000000000000000
> <0> ffff88007cd89ee0 ffffffffa0208e98 00ff880000000000 ffff880037d004b8
> <0> ffff88007df99740 ffff88007cd89e80 ffff88007cd89e10 ffffffff00000000
> Call Trace:
>  [<ffffffffa0208e98>] ocfs2_downconvert_thread+0x5cf/0x930 [ocfs2]
>  [<ffffffff81074f6b>] ? autoremove_wake_function+0x0/0x39
>  [<ffffffffa02088c9>] ? ocfs2_downconvert_thread+0x0/0x930 [ocfs2]
>  [<ffffffff81074c7e>] kthread+0x7f/0x87
>  [<ffffffff81012cea>] child_rip+0xa/0x20
>  [<ffffffff81074bff>] ? kthread+0x0/0x87
>  [<ffffffff81012ce0>] ? child_rip+0x0/0x20
> Code: 00 41 b8 d0 0c 00 00 48 c7 c1 f0 af 25 a0 65 8b 14 25 68 e3 00 00 48 c7 c7 b6 26 26 a0 48 63 d2 31 c0 44 89 24 24 e8 b6 b3 22 e1 <0f> 0b eb fe f6 05 fa 29 fb ff 08 74 4a f6 05 f9 29 fb ff 08 75
> RIP  [<ffffffffa020593d>] ocfs2_prepare_downconvert+0x93/0x11c [ocfs2]
>  RSP <ffff88007cd89d90>
> ---[ end trace 9d3da64f968ed95a ]---
>   

David,

Thanks for running the test. Did this happen on all three nodes?
Also, was there another message like the following?

                mlog(ML_ERROR, "lockres->l_level (%d) <= new_level (%d)\n",
                     lockres->l_level, new_level);

Wondering if you build with CONFIG_OCFS2_DEBUG_MASKLOG.

Sunil
