From: richard -rw- weinberger <richard.weinberger@gmail.com>
Date: Fri, 1 Mar 2013 22:25:37 +0100
Subject: [Ocfs2-devel] [OCFS2] Crash at o2net_shutdown_sc()
Message-ID: <CAFLxGvzUqQhbxpp4jAGW68-7GCc6jw8b4BFU7p_5H1utFxdkQQ@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com
Cc: ocfs2-users@oss.oracle.com, linux-fsdevel <linux-fsdevel@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, mfasheh@suse.com, jlbec@evilplan.org

Hi!

Using 3.8.1 OCFS2 crashes while joining nodes to the cluster.
The cluster consists of 10 nodes, while node3 joins the kernel on node3 crashes.
(Somtimes later...)
See dmesg below.
Is this a known issue? I didn't test older kernels so far.

node1:
[ 1471.881922] o2dlm: Joining domain 1352E2692E704EEB8040E5B8FF560997
( 0 ) 1 nodes
[ 1471.919522] JBD2: Ignoring recovery information on journal
[ 1471.947027] ocfs2: Mounting device (253,16) on (node 0, slot 0)
with ordered data mode.
[ 1475.802497] o2net: Accepted connection from node node2 (num 1) at
192.168.66.2:7777
[ 1481.814048] o2net: Connection to node node2 (num 1) at
192.168.66.2:7777 shutdown, state 8
[ 1481.814955] o2net: No longer connected to node node2 (num 1) at
192.168.66.2:7777
[ 1482.468827] o2net: Accepted connection from node node3 (num 2) at
192.168.66.3:7777
[ 1511.904100] o2net: No connection established with node 1 after 30.0
seconds, giving up.
[ 1514.472995] o2net: Connection to node node3 (num 2) at
192.168.66.3:7777 shutdown, state 8
[ 1514.473960] o2net: No longer connected to node node3 (num 2) at
192.168.66.3:7777
[ 1516.076044] o2net: Accepted connection from node node2 (num 1) at
192.168.66.2:7777
[ 1520.181430] o2dlm: Node 1 joins domain
1352E2692E704EEB8040E5B8FF560997 ( 0 1 ) 2 nodes
[ 1544.544030] o2net: No connection established with node 2 after 30.0
seconds, giving up.
[ 1574.624029] o2net: No connection established with node 2 after 30.0
seconds, giving up.

node2:
[ 1475.613170] o2net: Connected to node node1 (num 0) at 192.168.66.1:7777
[ 1481.620253] o2hb: Unable to stabilize heartbeart on region
1352E2692E704EEB8040E5B8FF560997 (vdb)
[ 1481.622489] o2net: No longer connected to node node1 (num 0) at
192.168.66.1:7777
[ 1515.886605] o2net: Connected to node node1 (num 0) at 192.168.66.1:7777
[ 1519.992766] o2dlm: Joining domain 1352E2692E704EEB8040E5B8FF560997
( 0 1 ) 2 nodes
[ 1520.017054] JBD2: Ignoring recovery information on journal
[ 1520.078888] ocfs2: Mounting device (253,16) on (node 1, slot 1)
with ordered data mode.
[ 1520.159590] mount.ocfs2 (2186) used greatest stack depth: 2568 bytes left

node3:
[ 1482.836865] o2net: Connected to node node1 (num 0) at 192.168.66.1:7777
[ 1482.837542] o2net: Connection to node node2 (num 1) at
192.168.66.2:7777 shutdown, state 7
[ 1484.840952] o2net: Connection to node node2 (num 1) at
192.168.66.2:7777 shutdown, state 7
[ 1486.844994] o2net: Connection to node node2 (num 1) at
192.168.66.2:7777 shutdown, state 7
[ 1488.848952] o2net: Connection to node node2 (num 1) at
192.168.66.2:7777 shutdown, state 7
[ 1490.853052] o2net: Connection to node node2 (num 1) at
192.168.66.2:7777 shutdown, state 7
[ 1492.857046] o2net: Connection to node node2 (num 1) at
192.168.66.2:7777 shutdown, state 7
[ 1494.861042] o2net: Connection to node node2 (num 1) at
192.168.66.2:7777 shutdown, state 7
[ 1496.865024] o2net: Connection to node node2 (num 1) at
192.168.66.2:7777 shutdown, state 7
[ 1498.869021] o2net: Connection to node node2 (num 1) at
192.168.66.2:7777 shutdown, state 7
[ 1500.873016] o2net: Connection to node node2 (num 1) at
192.168.66.2:7777 shutdown, state 7
[ 1502.877056] o2net: Connection to node node2 (num 1) at
192.168.66.2:7777 shutdown, state 7
[ 1504.881042] o2net: Connection to node node2 (num 1) at
192.168.66.2:7777 shutdown, state 7
[ 1506.885040] o2net: Connection to node node2 (num 1) at
192.168.66.2:7777 shutdown, state 7
[ 1508.888991] o2net: Connection to node node2 (num 1) at
192.168.66.2:7777 shutdown, state 7
[ 1510.893077] o2net: Connection to node node2 (num 1) at
192.168.66.2:7777 shutdown, state 7
[ 1512.843172] (mount.ocfs2,2179,0):dlm_request_join:1477 ERROR: Error
-107 when sending message 510 (key 0x666c6172) to node 1
[ 1512.845580] (mount.ocfs2,2179,0):dlm_try_to_join_domain:1653 ERROR:
status = -107
[ 1512.847778] (mount.ocfs2,2179,0):dlm_join_domain:1955 ERROR: status = -107
[ 1512.849334] (mount.ocfs2,2179,0):dlm_register_domain:2214 ERROR:
status = -107
[ 1512.850921] (mount.ocfs2,2179,0):o2cb_cluster_connect:368 ERROR:
status = -107
[ 1512.852511] (mount.ocfs2,2179,0):ocfs2_dlm_init:3004 ERROR: status = -107
[ 1512.854090] (mount.ocfs2,2179,0):ocfs2_mount_volume:1881 ERROR: status = -107
[ 1512.855476] ocfs2: Unmounting device (253,16) on (node 0)
[ 1512.855915] (mount.ocfs2,2179,0):ocfs2_fill_super:1230 ERROR: status = -107
[ 1514.839138] o2net: No longer connected to node node1 (num 0) at
192.168.66.1:7777
[ 1514.840690] BUG: unable to handle kernel NULL pointer dereference
at 0000000000000028
[ 1514.841627] IP: [<ffffffff816ce840>] kernel_sock_ioctl+0x50/0x50
[ 1514.841627] PGD 1d980067 PUD 1db0c067 PMD 0
[ 1514.841627] Oops: 0000 [#1] PREEMPT SMP
[ 1514.841627] Modules linked in:
[ 1514.841627] CPU 0
[ 1514.841627] Pid: 6, comm: kworker/u:0 Not tainted 3.8.1+ #8 Bochs Bochs
[ 1514.841627] RIP: 0010:[<ffffffff816ce840>]  [<ffffffff816ce840>]
kernel_sock_ioctl+0x50/0x50
[ 1514.841627] RSP: 0018:ffff88001f949d40  EFLAGS: 00010292
[ 1514.841627] RAX: ffff88001e6e9c01 RBX: ffff88001e6e9000 RCX: 0000000180080006
[ 1514.841627] RDX: 0000000180080007 RSI: 0000000000000002 RDI: 0000000000000000
[ 1514.841627] RBP: ffff88001f949dc8 R08: 0000000000016090 R09: 0000000000000001
[ 1514.841627] R10: ffffea000079ba40 R11: ffffffff81321207 R12: ffff88001db69440
[ 1514.841627] R13: ffffffff8204c760 R14: ffff88001db695a8 R15: ffff88001e6e9058
[ 1514.841627] FS:  0000000000000000(0000) GS:ffff88001fc00000(0000)
knlGS:0000000000000000
[ 1514.841627] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1514.841627] CR2: 0000000000000028 CR3: 000000001c009000 CR4: 00000000000006f0
[ 1514.841627] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 1514.841627] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 1514.841627] Process kworker/u:0 (pid: 6, threadinfo
ffff88001f948000, task ffff88001f90a670)
[ 1514.841627] Stack:
[ 1514.841627]  ffffffff81323776 ffff88001fad2e20 0000000000010500
ffff88001f949d98
[ 1514.841627]  ffffffff810013fa ffff88001f949d78 ffffffff818a5c22
ffff88001f949da8
[ 1514.841627]  ffffffff81069d26 0000000000012900 0000000000012900
0000000000000000
[ 1514.841627] Call Trace:
[ 1514.841627]  [<ffffffff81323776>] ? o2net_shutdown_sc+0x106/0x1e0
[ 1514.841627]  [<ffffffff810013fa>] ? __switch_to+0x2a/0x4a0
[ 1514.841627]  [<ffffffff818a5c22>] ? _raw_spin_unlock_irq+0x12/0x40
[ 1514.841627]  [<ffffffff81069d26>] ? finish_task_switch+0x56/0xc0
[ 1514.841627]  [<ffffffff81056eb3>] process_one_work+0x133/0x510
[ 1514.841627]  [<ffffffff81323670>] ? o2net_sc_connect_completed+0xf0/0xf0
[ 1514.841627]  [<ffffffff810585ed>] worker_thread+0x15d/0x450
[ 1514.841627]  [<ffffffff81058490>] ? busy_worker_rebind_fn+0x100/0x100
[ 1514.841627]  [<ffffffff8105e10b>] kthread+0xbb/0xc0
[ 1514.841627]  [<ffffffff818a0000>] ? e1000_regdump+0x262/0x3be
[ 1514.841627]  [<ffffffff8105e050>] ? kthread_create_on_node+0x130/0x130
[ 1514.841627]  [<ffffffff818accac>] ret_from_fork+0x7c/0xb0
[ 1514.841627]  [<ffffffff8105e050>] ? kthread_create_on_node+0x130/0x130
[ 1514.841627] Code: ff ff ff ff ff ff 48 8b 47 28 ff 50 48 4c 89 a3
48 e0 ff ff 48 8b 5d f0 4c 8b 65 f8 c9 c3 66 66 66 66 2e 0f 1f 84 00
00 00 00 00 <48> 8b 47 28 55 48 89 e5 ff 50 60 5d c3 0f 1f 00 55 41 b8
4b 43
[ 1514.841627] RIP  [<ffffffff816ce840>] kernel_sock_ioctl+0x50/0x50
[ 1514.841627]  RSP <ffff88001f949d40>
[ 1514.841627] CR2: 0000000000000028
[ 1514.867242] ---[ end trace 36ffe9378168cdc2 ]---
[ 1514.867619] BUG: unable to handle kernel paging request at ffffffffffffffd8
[ 1514.868007] IP: [<ffffffff8105e3cb>] kthread_data+0xb/0x20
[ 1514.868007] PGD 1e0d067 PUD 1e0e067 PMD 0
[ 1514.868007] Oops: 0000 [#2] PREEMPT SMP
[ 1514.868007] Modules linked in:
[ 1514.868007] CPU 0
[ 1514.868007] Pid: 6, comm: kworker/u:0 Tainted: G      D      3.8.1+
#8 Bochs Bochs
[ 1514.868007] RIP: 0010:[<ffffffff8105e3cb>]  [<ffffffff8105e3cb>]
kthread_data+0xb/0x20
[ 1514.868007] RSP: 0018:ffff88001f949928  EFLAGS: 00010092
[ 1514.868007] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000006
[ 1514.868007] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff88001f90a670
[ 1514.868007] RBP: ffff88001f949928 R08: 0000000000000001 R09: 0000000000000196
[ 1514.868007] R10: ffff88001f9116a0 R11: 0000000000000004 R12: ffff88001f90aa40
[ 1514.868007] R13: 0000000000000000 R14: ffff88001f90a660 R15: ffff88001f90a670
[ 1514.868007] FS:  0000000000000000(0000) GS:ffff88001fc00000(0000)
knlGS:0000000000000000
[ 1514.868007] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1514.868007] CR2: ffffffffffffffd8 CR3: 000000001d83d000 CR4: 00000000000006f0
[ 1514.868007] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 1514.868007] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 1514.868007] Process kworker/u:0 (pid: 6, threadinfo
ffff88001f948000, task ffff88001f90a670)
[ 1514.868007] Stack:
[ 1514.868007]  ffff88001f949948 ffffffff81059980 ffff88001f949948
ffff88001fc12900
[ 1514.868007]  ffff88001f9499c8 ffffffff818a4c48 ffff88001f949978
0000000000000000
[ 1514.868007]  ffff88001f949fd8 ffff88001f90a670 ffff88001f949fd8
ffff88001f949fd8
[ 1514.868007] Call Trace:
[ 1514.868007]  [<ffffffff81059980>] wq_worker_sleeping+0x10/0xc0
[ 1514.868007]  [<ffffffff818a4c48>] __schedule+0x528/0x770
[ 1514.868007]  [<ffffffff818a4fa4>] schedule+0x24/0x70
[ 1514.868007]  [<ffffffff81040c72>] do_exit+0x702/0xad0
[ 1514.868007]  [<ffffffff818a7071>] oops_end+0x91/0xe0
[ 1514.868007]  [<ffffffff8189a00d>] no_context+0x24e/0x279
[ 1514.868007]  [<ffffffff817436f8>] ? tcp_rearm_rto+0xa8/0xd0
[ 1514.868007]  [<ffffffff8189a1ed>] __bad_area_nosemaphore+0x1b5/0x1d4
[ 1514.868007]  [<ffffffff8189a21a>] bad_area_nosemaphore+0xe/0x10
[ 1514.868007]  [<ffffffff818a90b6>] __do_page_fault+0x296/0x490
[ 1514.868007]  [<ffffffff816ce8ce>] ? sock_destroy_inode+0x2e/0x40
[ 1514.868007]  [<ffffffff8114e787>] ? destroy_inode+0x37/0x60
[ 1514.868007]  [<ffffffff8114e8ca>] ? evict+0x11a/0x1b0
[ 1514.868007]  [<ffffffff81321207>] ? sc_kref_release+0x77/0x160
[ 1514.868007]  [<ffffffff8112d421>] ? kfree+0x121/0x160
[ 1514.868007]  [<ffffffff81321207>] ? sc_kref_release+0x77/0x160
[ 1514.868007]  [<ffffffff818a92b9>] do_page_fault+0x9/0x10
[ 1514.868007]  [<ffffffff818a65e2>] page_fault+0x22/0x30
[ 1514.868007]  [<ffffffff81321207>] ? sc_kref_release+0x77/0x160
[ 1514.868007]  [<ffffffff816ce840>] ? kernel_sock_ioctl+0x50/0x50
[ 1514.868007]  [<ffffffff81323776>] ? o2net_shutdown_sc+0x106/0x1e0
[ 1514.868007]  [<ffffffff810013fa>] ? __switch_to+0x2a/0x4a0
[ 1514.868007]  [<ffffffff818a5c22>] ? _raw_spin_unlock_irq+0x12/0x40
[ 1514.868007]  [<ffffffff81069d26>] ? finish_task_switch+0x56/0xc0
[ 1514.868007]  [<ffffffff81056eb3>] process_one_work+0x133/0x510
[ 1514.868007]  [<ffffffff81323670>] ? o2net_sc_connect_completed+0xf0/0xf0
[ 1514.868007]  [<ffffffff810585ed>] worker_thread+0x15d/0x450
[ 1514.868007]  [<ffffffff81058490>] ? busy_worker_rebind_fn+0x100/0x100
[ 1514.868007]  [<ffffffff8105e10b>] kthread+0xbb/0xc0
[ 1514.868007]  [<ffffffff818a0000>] ? e1000_regdump+0x262/0x3be
[ 1514.868007]  [<ffffffff8105e050>] ? kthread_create_on_node+0x130/0x130
[ 1514.868007]  [<ffffffff818accac>] ret_from_fork+0x7c/0xb0
[ 1514.868007]  [<ffffffff8105e050>] ? kthread_create_on_node+0x130/0x130
[ 1514.868007] Code: 00 48 89 e5 5d 48 8b 40 c8 48 c1 e8 02 83 e0 01
c3 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 48 8b 87 78 03 00 00
55 48 89 e5 <48> 8b 40 d8 5d c3 66 66 66 66 66 66 2e 0f 1f 84 00 00 00
00 00
[ 1514.868007] RIP  [<ffffffff8105e3cb>] kthread_data+0xb/0x20
[ 1514.868007]  RSP <ffff88001f949928>
[ 1514.868007] CR2: ffffffffffffffd8
[ 1514.868007] ---[ end trace 36ffe9378168cdc3 ]---
[ 1514.868007] Fixing recursive fault but reboot is needed!

-- 
Thanks,
//richard
