From: Guozhonghua <guozhonghua@h3c.com>
Date: Thu, 27 Dec 2012 05:29:15 +0000
Subject: [Ocfs2-devel] Hi, is it an ocfs2 issue,
 would you have some good ideas? Thanks.  ( Part I )
Message-ID: <71604351584F6A4EBAE558C676F37CA417BC770F@H3CMLB02-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi, everyone,

I setup seven nodes to test ocfs2 performance and its stabilities.
I use the Ubuntu 12.04, the version of the kernel is 3.2.0.

The ocfs2.conf file is as below:
cluster:
        node_count = 8
        name = ServerPool
node:
        number = 7
        cluster = ServerPool
        ip_port = 7100
        ip_address = 192.168.20.12
        name = Server12
node:
        number = 1
        cluster = ServerPool
        ip_port = 7100
        ip_address = 192.168.20.13
        name = server13
node:
        number = 4
        cluster = ServerPool
        ip_port = 7100
        ip_address = 192.168.20.14
        name = server14
node:
        number = 2
        cluster = ServerPool
        ip_port = 7100
        ip_address = 192.168.20.15
        name = Server15
node:
        number = 9
        cluster = ServerPool
        ip_port = 7100
        ip_address = 192.168.20.16
        name = Server16
node:
        number = 3
        cluster = ServerPool
        ip_port = 7100
        ip_address = 192.168.20.17
        name = Server17
node:
        number = 5
        cluster = ServerPool
        ip_port = 7100
        ip_address = 192.168.20.18
        name = Server18
node:
        number = 8
        cluster = ServerPool
        ip_port = 7100
        ip_address = 192.168.20.21
        name = Server21

The server12 is powered off directly and removed away.

When the Server16 running, there are some error logs in the syslog file, as below:

Dec 25 18:02:01 Server16 kernel: [ 8277.483257] INFO: task bash:30770 blocked for more than 120 seconds.
Dec 25 18:02:01 Server16 kernel: [ 8277.490659] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Dec 25 18:02:01 Server16 kernel: [ 8277.498572] bash            D ffffffff81806240     0 30770      1 0x00000004
Dec 25 18:02:01 Server16 kernel: [ 8277.498577]  ffff8802b4871a88 0000000000000082 0000000000000000 ffff8802f4a48680
Dec 25 18:02:01 Server16 kernel: [ 8277.498586]  ffff8802b4871fd8 ffff8802b4871fd8 ffff8802b4871fd8 0000000000013780
Dec 25 18:02:01 Server16 kernel: [ 8277.498599]  ffff8802f6df96f0 ffff8802f2c88000 ffff8802f49e6548 7fffffffffffffff
Dec 25 18:02:01 Server16 kernel: [ 8277.498610] Call Trace:
Dec 25 18:02:01 Server16 kernel: [ 8277.498620]  [<ffffffff8165a55f>] schedule+0x3f/0x60
Dec 25 18:02:01 Server16 kernel: [ 8277.498627]  [<ffffffff8165aba5>] schedule_timeout+0x2a5/0x320
Dec 25 18:02:01 Server16 kernel: [ 8277.498635]  [<ffffffff8123b73f>] ? __ext4_ext_check+0xaf/0x160
Dec 25 18:02:01 Server16 kernel: [ 8277.498644]  [<ffffffff812152f3>] ? __ext4_get_inode_loc+0x113/0x410
Dec 25 18:02:01 Server16 kernel: [ 8277.498653]  [<ffffffff81190deb>] ? inode_sb_list_add+0x5b/0x70
Dec 25 18:02:01 Server16 kernel: [ 8277.498660]  [<ffffffff8108aa97>] ? bit_waitqueue+0x17/0xc0
Dec 25 18:02:01 Server16 kernel: [ 8277.498666]  [<ffffffff8165a39f>] wait_for_common+0xdf/0x180
Dec 25 18:02:01 Server16 kernel: [ 8277.498673]  [<ffffffff81182f67>] ? __follow_mount_rcu.isra.12+0x37/0xd0
Dec 25 18:02:01 Server16 kernel: [ 8277.498681]  [<ffffffff8105f990>] ? try_to_wake_up+0x200/0x200
Dec 25 18:02:01 Server16 kernel: [ 8277.498687]  [<ffffffff8165a51d>] wait_for_completion+0x1d/0x20
Dec 25 18:02:01 Server16 kernel: [ 8277.498717]  [<ffffffffa0438eb3>] __ocfs2_cluster_lock.isra.34+0x1f3/0x810 [ocfs2]
Dec 25 18:02:01 Server16 kernel: [ 8277.498725]  [<ffffffff81182f67>] ? __follow_mount_rcu.isra.12+0x37/0xd0
Dec 25 18:02:01 Server16 kernel: [ 8277.498731]  [<ffffffff81184162>] ? complete_walk+0x92/0x120
Dec 25 18:02:01 Server16 kernel: [ 8277.498755]  [<ffffffffa043a6ae>] ocfs2_inode_lock_full_nested+0x13e/0xa90 [ocfs2]
Dec 25 18:02:01 Server16 kernel: [ 8277.498780]  [<ffffffffa044870d>] ocfs2_inode_revalidate+0x7d/0x1b0 [ocfs2]
Dec 25 18:02:01 Server16 kernel: [ 8277.498803]  [<ffffffffa0440cb8>] ocfs2_getattr+0x38/0x100 [ocfs2]
Dec 25 18:02:01 Server16 kernel: [ 8277.498811]  [<ffffffff8117c86e>] vfs_getattr+0x4e/0x80
Dec 25 18:02:01 Server16 kernel: [ 8277.498818]  [<ffffffff8117c8ee>] vfs_fstatat+0x4e/0x70
Dec 25 18:02:01 Server16 kernel: [ 8277.498824]  [<ffffffff8117c94b>] vfs_stat+0x1b/0x20
Dec 25 18:02:01 Server16 kernel: [ 8277.498831]  [<ffffffff8117ca8a>] sys_newstat+0x1a/0x40
Dec 25 18:02:01 Server16 kernel: [ 8277.498839]  [<ffffffff81664a82>] system_call_fastpath+0x16/0x1b
Dec 25 18:02:01 Server16 kernel: [ 8277.498844] INFO: task ls:30774 blocked for more than 120 seconds.
Dec 25 18:02:01 Server16 kernel: [ 8277.503219] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Dec 25 18:02:01 Server16 kernel: [ 8277.512113] ls              D 0000000000000006     0 30774  30681 0x00000004
Dec 25 18:02:01 Server16 kernel: [ 8277.512118]  ffff8802f3bf7a88 0000000000000086 000000000000001f ffff8802f28d6200
Dec 25 18:02:01 Server16 kernel: [ 8277.512123]  ffff8802f3bf7fd8 ffff8802f3bf7fd8 ffff8802f3bf7fd8 0000000000013780
Dec 25 18:02:01 Server16 kernel: [ 8277.512129]  ffff8802f1e6dbc0 ffff8802b49b5bc0 000000010bffae00 7fffffffffffffff
Dec 25 18:02:01 Server16 kernel: [ 8277.512134] Call Trace:
Dec 25 18:02:01 Server16 kernel: [ 8277.512138]  [<ffffffff8165a55f>] schedule+0x3f/0x60
Dec 25 18:02:01 Server16 kernel: [ 8277.512142]  [<ffffffff8165aba5>] schedule_timeout+0x2a5/0x320
Dec 25 18:02:01 Server16 kernel: [ 8277.512146]  [<ffffffff8165a39f>] wait_for_common+0xdf/0x180
Dec 25 18:02:01 Server16 kernel: [ 8277.512150]  [<ffffffff81182f67>] ? __follow_mount_rcu.isra.12+0x37/0xd0
Dec 25 18:02:01 Server16 kernel: [ 8277.512154]  [<ffffffff8105f990>] ? try_to_wake_up+0x200/0x200
Dec 25 18:02:01 Server16 kernel: [ 8277.512158]  [<ffffffff8165a51d>] wait_for_completion+0x1d/0x20
Dec 25 18:02:01 Server16 kernel: [ 8277.512178]  [<ffffffffa0438eb3>] __ocfs2_cluster_lock.isra.34+0x1f3/0x810 [ocfs2]
Dec 25 18:02:01 Server16 kernel: [ 8277.512183]  [<ffffffff81182f67>] ? __follow_mount_rcu.isra.12+0x37/0xd0
Dec 25 18:02:01 Server16 kernel: [ 8277.512187]  [<ffffffff81184162>] ? complete_walk+0x92/0x120
Dec 25 18:02:01 Server16 kernel: [ 8277.512207]  [<ffffffffa043a6ae>] ocfs2_inode_lock_full_nested+0x13e/0xa90 [ocfs2]
Dec 25 18:02:01 Server16 kernel: [ 8277.512229]  [<ffffffffa044870d>] ocfs2_inode_revalidate+0x7d/0x1b0 [ocfs2]
Dec 25 18:02:01 Server16 kernel: [ 8277.512250]  [<ffffffffa0440cb8>] ocfs2_getattr+0x38/0x100 [ocfs2]
Dec 25 18:02:01 Server16 kernel: [ 8277.512254]  [<ffffffff8117c86e>] vfs_getattr+0x4e/0x80
Dec 25 18:02:01 Server16 kernel: [ 8277.512258]  [<ffffffff8117c8ee>] vfs_fstatat+0x4e/0x70
Dec 25 18:02:01 Server16 kernel: [ 8277.512262]  [<ffffffff8117c92e>] vfs_lstat+0x1e/0x20
Dec 25 18:02:01 Server16 kernel: [ 8277.512266]  [<ffffffff8117caca>] sys_newlstat+0x1a/0x40
Dec 25 18:02:01 Server16 kernel: [ 8277.512270]  [<ffffffff81664a82>] system_call_fastpath+0x16/0x1b
..............................other cron logs....................................................................................................
Dec 25 18:04:01 Server16 kernel: [ 8397.452959] INFO: task bash:30770 blocked for more than 120 seconds.
Dec 25 18:04:01 Server16 kernel: [ 8397.457700] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Dec 25 18:04:01 Server16 kernel: [ 8397.467084] bash            D ffffffff81806240     0 30770      1 0x00000004
Dec 25 18:04:01 Server16 kernel: [ 8397.467090]  ffff8802b4871a88 0000000000000082 0000000000000000 ffff8802f4a48680
Dec 25 18:04:01 Server16 kernel: [ 8397.467102]  ffff8802b4871fd8 ffff8802b4871fd8 ffff8802b4871fd8 0000000000013780
Dec 25 18:04:01 Server16 kernel: [ 8397.467114]  ffff8802f6df96f0 ffff8802f2c88000 ffff8802f49e6548 7fffffffffffffff
Dec 25 18:04:01 Server16 kernel: [ 8397.467125] Call Trace:
Dec 25 18:04:01 Server16 kernel: [ 8397.467135]  [<ffffffff8165a55f>] schedule+0x3f/0x60
Dec 25 18:04:01 Server16 kernel: [ 8397.467142]  [<ffffffff8165aba5>] schedule_timeout+0x2a5/0x320
Dec 25 18:04:01 Server16 kernel: [ 8397.467151]  [<ffffffff8123b73f>] ? __ext4_ext_check+0xaf/0x160
Dec 25 18:04:01 Server16 kernel: [ 8397.467160]  [<ffffffff812152f3>] ? __ext4_get_inode_loc+0x113/0x410
Dec 25 18:04:01 Server16 kernel: [ 8397.467169]  [<ffffffff81190deb>] ? inode_sb_list_add+0x5b/0x70
Dec 25 18:04:01 Server16 kernel: [ 8397.467177]  [<ffffffff8108aa97>] ? bit_waitqueue+0x17/0xc0
Dec 25 18:04:01 Server16 kernel: [ 8397.467184]  [<ffffffff8165a39f>] wait_for_common+0xdf/0x180
Dec 25 18:04:01 Server16 kernel: [ 8397.467191]  [<ffffffff81182f67>] ? __follow_mount_rcu.isra.12+0x37/0xd0
Dec 25 18:04:01 Server16 kernel: [ 8397.467201]  [<ffffffff8105f990>] ? try_to_wake_up+0x200/0x200
Dec 25 18:04:01 Server16 kernel: [ 8397.467207]  [<ffffffff8165a51d>] wait_for_completion+0x1d/0x20
Dec 25 18:04:01 Server16 kernel: [ 8397.467239]  [<ffffffffa0438eb3>] __ocfs2_cluster_lock.isra.34+0x1f3/0x810 [ocfs2]
Dec 25 18:04:01 Server16 kernel: [ 8397.467247]  [<ffffffff81182f67>] ? __follow_mount_rcu.isra.12+0x37/0xd0
Dec 25 18:04:01 Server16 kernel: [ 8397.467254]  [<ffffffff81184162>] ? complete_walk+0x92/0x120
Dec 25 18:04:01 Server16 kernel: [ 8397.467278]  [<ffffffffa043a6ae>] ocfs2_inode_lock_full_nested+0x13e/0xa90 [ocfs2]
Dec 25 18:04:01 Server16 kernel: [ 8397.467303]  [<ffffffffa044870d>] ocfs2_inode_revalidate+0x7d/0x1b0 [ocfs2]
Dec 25 18:04:01 Server16 kernel: [ 8397.467327]  [<ffffffffa0440cb8>] ocfs2_getattr+0x38/0x100 [ocfs2]
Dec 25 18:04:01 Server16 kernel: [ 8397.467336]  [<ffffffff8117c86e>] vfs_getattr+0x4e/0x80
Dec 25 18:04:01 Server16 kernel: [ 8397.467343]  [<ffffffff8117c8ee>] vfs_fstatat+0x4e/0x70
Dec 25 18:04:01 Server16 kernel: [ 8397.467350]  [<ffffffff8117c94b>] vfs_stat+0x1b/0x20
Dec 25 18:04:01 Server16 kernel: [ 8397.467357]  [<ffffffff8117ca8a>] sys_newstat+0x1a/0x40
Dec 25 18:04:01 Server16 kernel: [ 8397.467364]  [<ffffffff81664a82>] system_call_fastpath+0x16/0x1b
Dec 25 18:04:01 Server16 kernel: [ 8397.467370] INFO: task ls:30774 blocked for more than 120 seconds.
Dec 25 18:04:01 Server16 kernel: [ 8397.472390] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Dec 25 18:04:01 Server16 kernel: [ 8397.482943] ls              D 0000000000000006     0 30774  30681 0x00000004
Dec 25 18:04:01 Server16 kernel: [ 8397.482948]  ffff8802f3bf7a88 0000000000000086 000000000000001f ffff8802f28d6200
Dec 25 18:04:01 Server16 kernel: [ 8397.482958]  ffff8802f3bf7fd8 ffff8802f3bf7fd8 ffff8802f3bf7fd8 0000000000013780
Dec 25 18:04:01 Server16 kernel: [ 8397.482970]  ffff8802f1e6dbc0 ffff8802b49b5bc0 000000010bffae00 7fffffffffffffff
Dec 25 18:04:01 Server16 kernel: [ 8397.482981] Call Trace:
Dec 25 18:04:01 Server16 kernel: [ 8397.482988]  [<ffffffff8165a55f>] schedule+0x3f/0x60
Dec 25 18:04:01 Server16 kernel: [ 8397.482994]  [<ffffffff8165aba5>] schedule_timeout+0x2a5/0x320
Dec 25 18:04:01 Server16 kernel: [ 8397.483000]  [<ffffffff8165a39f>] wait_for_common+0xdf/0x180
Dec 25 18:04:01 Server16 kernel: [ 8397.483007]  [<ffffffff81182f67>] ? __follow_mount_rcu.isra.12+0x37/0xd0
Dec 25 18:04:01 Server16 kernel: [ 8397.483014]  [<ffffffff8105f990>] ? try_to_wake_up+0x200/0x200
Dec 25 18:04:01 Server16 kernel: [ 8397.483021]  [<ffffffff8165a51d>] wait_for_completion+0x1d/0x20
Dec 25 18:04:01 Server16 kernel: [ 8397.483044]  [<ffffffffa0438eb3>] __ocfs2_cluster_lock.isra.34+0x1f3/0x810 [ocfs2]
Dec 25 18:04:01 Server16 kernel: [ 8397.483051]  [<ffffffff81182f67>] ? __follow_mount_rcu.isra.12+0x37/0xd0
Dec 25 18:04:01 Server16 kernel: [ 8397.483058]  [<ffffffff81184162>] ? complete_walk+0x92/0x120
Dec 25 18:04:01 Server16 kernel: [ 8397.483081]  [<ffffffffa043a6ae>] ocfs2_inode_lock_full_nested+0x13e/0xa90 [ocfs2]
Dec 25 18:04:01 Server16 kernel: [ 8397.483105]  [<ffffffffa044870d>] ocfs2_inode_revalidate+0x7d/0x1b0 [ocfs2]
Dec 25 18:04:01 Server16 kernel: [ 8397.483129]  [<ffffffffa0440cb8>] ocfs2_getattr+0x38/0x100 [ocfs2]
Dec 25 18:04:01 Server16 kernel: [ 8397.483136]  [<ffffffff8117c86e>] vfs_getattr+0x4e/0x80
Dec 25 18:04:01 Server16 kernel: [ 8397.483142]  [<ffffffff8117c8ee>] vfs_fstatat+0x4e/0x70
Dec 25 18:04:01 Server16 kernel: [ 8397.483148]  [<ffffffff8117c92e>] vfs_lstat+0x1e/0x20
Dec 25 18:04:01 Server16 kernel: [ 8397.483155]  [<ffffffff8117caca>] sys_newlstat+0x1a/0x40
Dec 25 18:04:01 Server16 kernel: [ 8397.483161]  [<ffffffff81664a82>] system_call_fastpath+0x16/0x1b
..............................other cron logs....................................................................................................
Dec 25 18:05:01 Server16 CRON[1035]: (root) CMD (command -v debian-sa1 > /dev/null && debian-sa1 1 1)
Dec 25 18:06:01 Server16 kernel: [ 8517.422710] INFO: task bash:30770 blocked for more than 120 seconds.
Dec 25 18:06:01 Server16 kernel: [ 8517.428322] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Dec 25 18:06:01 Server16 kernel: [ 8517.439530] bash            D ffffffff81806240     0 30770      1 0x00000004
Dec 25 18:06:01 Server16 kernel: [ 8517.439535]  ffff8802b4871a88 0000000000000082 0000000000000000 ffff8802f4a48680
Dec 25 18:06:01 Server16 kernel: [ 8517.439544]  ffff8802b4871fd8 ffff8802b4871fd8 ffff8802b4871fd8 0000000000013780
Dec 25 18:06:01 Server16 kernel: [ 8517.439556]  ffff8802f6df96f0 ffff8802f2c88000 ffff8802f49e6548 7fffffffffffffff
Dec 25 18:06:01 Server16 kernel: [ 8517.439567] Call Trace:
Dec 25 18:06:01 Server16 kernel: [ 8517.439577]  [<ffffffff8165a55f>] schedule+0x3f/0x60
Dec 25 18:06:01 Server16 kernel: [ 8517.439584]  [<ffffffff8165aba5>] schedule_timeout+0x2a5/0x320
Dec 25 18:06:01 Server16 kernel: [ 8517.439592]  [<ffffffff8123b73f>] ? __ext4_ext_check+0xaf/0x160
Dec 25 18:06:01 Server16 kernel: [ 8517.439601]  [<ffffffff812152f3>] ? __ext4_get_inode_loc+0x113/0x410
Dec 25 18:06:01 Server16 kernel: [ 8517.439610]  [<ffffffff81190deb>] ? inode_sb_list_add+0x5b/0x70
Dec 25 18:06:01 Server16 kernel: [ 8517.439617]  [<ffffffff8108aa97>] ? bit_waitqueue+0x17/0xc0
Dec 25 18:06:01 Server16 kernel: [ 8517.439624]  [<ffffffff8165a39f>] wait_for_common+0xdf/0x180
Dec 25 18:06:01 Server16 kernel: [ 8517.439631]  [<ffffffff81182f67>] ? __follow_mount_rcu.isra.12+0x37/0xd0
Dec 25 18:06:01 Server16 kernel: [ 8517.439639]  [<ffffffff8105f990>] ? try_to_wake_up+0x200/0x200
Dec 25 18:06:01 Server16 kernel: [ 8517.439646]  [<ffffffff8165a51d>] wait_for_completion+0x1d/0x20
Dec 25 18:06:01 Server16 kernel: [ 8517.439675]  [<ffffffffa0438eb3>] __ocfs2_cluster_lock.isra.34+0x1f3/0x810 [ocfs2]
Dec 25 18:06:01 Server16 kernel: [ 8517.439682]  [<ffffffff81182f67>] ? __follow_mount_rcu.isra.12+0x37/0xd0
Dec 25 18:06:01 Server16 kernel: [ 8517.439689]  [<ffffffff81184162>] ? complete_walk+0x92/0x120
Dec 25 18:06:01 Server16 kernel: [ 8517.439712]  [<ffffffffa043a6ae>] ocfs2_inode_lock_full_nested+0x13e/0xa90 [ocfs2]
Dec 25 18:06:01 Server16 kernel: [ 8517.439737]  [<ffffffffa044870d>] ocfs2_inode_revalidate+0x7d/0x1b0 [ocfs2]
Dec 25 18:06:01 Server16 kernel: [ 8517.439761]  [<ffffffffa0440cb8>] ocfs2_getattr+0x38/0x100 [ocfs2]
Dec 25 18:06:01 Server16 kernel: [ 8517.439769]  [<ffffffff8117c86e>] vfs_getattr+0x4e/0x80
Dec 25 18:06:01 Server16 kernel: [ 8517.439775]  [<ffffffff8117c8ee>] vfs_fstatat+0x4e/0x70
Dec 25 18:06:01 Server16 kernel: [ 8517.439782]  [<ffffffff8117c94b>] vfs_stat+0x1b/0x20
Dec 25 18:06:01 Server16 kernel: [ 8517.439788]  [<ffffffff8117ca8a>] sys_newstat+0x1a/0x40
Dec 25 18:06:01 Server16 kernel: [ 8517.439796]  [<ffffffff81664a82>] system_call_fastpath+0x16/0x1b
Dec 25 18:06:01 Server16 kernel: [ 8517.439801] INFO: task ls:30774 blocked for more than 120 seconds.
Dec 25 18:06:01 Server16 kernel: [ 8517.445890] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Dec 25 18:06:01 Server16 kernel: [ 8517.458492] ls              D 0000000000000006     0 30774  30681 0x00000004
Dec 25 18:06:01 Server16 kernel: [ 8517.458497]  ffff8802f3bf7a88 0000000000000086 000000000000001f ffff8802f28d6200
Dec 25 18:06:01 Server16 kernel: [ 8517.458504]  ffff8802f3bf7fd8 ffff8802f3bf7fd8 ffff8802f3bf7fd8 0000000000013780
Dec 25 18:06:01 Server16 kernel: [ 8517.458515]  ffff8802f1e6dbc0 ffff8802b49b5bc0 000000010bffae00 7fffffffffffffff
Dec 25 18:06:01 Server16 kernel: [ 8517.458526] Call Trace:
Dec 25 18:06:01 Server16 kernel: [ 8517.458533]  [<ffffffff8165a55f>] schedule+0x3f/0x60
Dec 25 18:06:01 Server16 kernel: [ 8517.458538]  [<ffffffff8165aba5>] schedule_timeout+0x2a5/0x320
Dec 25 18:06:01 Server16 kernel: [ 8517.458545]  [<ffffffff8165a39f>] wait_for_common+0xdf/0x180
Dec 25 18:06:01 Server16 kernel: [ 8517.458551]  [<ffffffff81182f67>] ? __follow_mount_rcu.isra.12+0x37/0xd0
Dec 25 18:06:01 Server16 kernel: [ 8517.458558]  [<ffffffff8105f990>] ? try_to_wake_up+0x200/0x200
Dec 25 18:06:01 Server16 kernel: [ 8517.458565]  [<ffffffff8165a51d>] wait_for_completion+0x1d/0x20
Dec 25 18:06:01 Server16 kernel: [ 8517.458588]  [<ffffffffa0438eb3>] __ocfs2_cluster_lock.isra.34+0x1f3/0x810 [ocfs2]
Dec 25 18:06:01 Server16 kernel: [ 8517.458600]  [<ffffffff81182f67>] ? __follow_mount_rcu.isra.12+0x37/0xd0
Dec 25 18:06:01 Server16 kernel: [ 8517.458604]  [<ffffffff81184162>] ? complete_walk+0x92/0x120
Dec 25 18:06:01 Server16 kernel: [ 8517.458626]  [<ffffffffa043a6ae>] ocfs2_inode_lock_full_nested+0x13e/0xa90 [ocfs2]
Dec 25 18:06:01 Server16 kernel: [ 8517.458651]  [<ffffffffa044870d>] ocfs2_inode_revalidate+0x7d/0x1b0 [ocfs2]
Dec 25 18:06:01 Server16 kernel: [ 8517.458675]  [<ffffffffa0440cb8>] ocfs2_getattr+0x38/0x100 [ocfs2]
Dec 25 18:06:01 Server16 kernel: [ 8517.458682]  [<ffffffff8117c86e>] vfs_getattr+0x4e/0x80
Dec 25 18:06:01 Server16 kernel: [ 8517.458688]  [<ffffffff8117c8ee>] vfs_fstatat+0x4e/0x70
Dec 25 18:06:01 Server16 kernel: [ 8517.458694]  [<ffffffff8117c92e>] vfs_lstat+0x1e/0x20
Dec 25 18:06:01 Server16 kernel: [ 8517.458700]  [<ffffffff8117caca>] sys_newlstat+0x1a/0x40
Dec 25 18:06:01 Server16 kernel: [ 8517.458707]  [<ffffffff81664a82>] system_call_fastpath+0x16/0x1b
..............................other cron logs....................................................................................................
Dec 25 18:08:01 Server16 kernel: [ 8637.400442] INFO: task bash:30770 blocked for more than 120 seconds.
Dec 25 18:08:01 Server16 kernel: [ 8637.407211] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Dec 25 18:08:01 Server16 kernel: [ 8637.420778] bash            D ffffffff81806240     0 30770      1 0x00000004
Dec 25 18:08:01 Server16 kernel: [ 8637.420784]  ffff8802b4871a88 0000000000000082 0000000000000000 ffff8802f4a48680
Dec 25 18:08:01 Server16 kernel: [ 8637.420793]  ffff8802b4871fd8 ffff8802b4871fd8 ffff8802b4871fd8 0000000000013780
Dec 25 18:08:01 Server16 kernel: [ 8637.420805]  ffff8802f6df96f0 ffff8802f2c88000 ffff8802f49e6548 7fffffffffffffff
Dec 25 18:08:01 Server16 kernel: [ 8637.420816] Call Trace:
Dec 25 18:08:01 Server16 kernel: [ 8637.420827]  [<ffffffff8165a55f>] schedule+0x3f/0x60
Dec 25 18:08:01 Server16 kernel: [ 8637.420833]  [<ffffffff8165aba5>] schedule_timeout+0x2a5/0x320
Dec 25 18:08:01 Server16 kernel: [ 8637.420842]  [<ffffffff8123b73f>] ? __ext4_ext_check+0xaf/0x160
Dec 25 18:08:01 Server16 kernel: [ 8637.420851]  [<ffffffff812152f3>] ? __ext4_get_inode_loc+0x113/0x410
Dec 25 18:08:01 Server16 kernel: [ 8637.420859]  [<ffffffff81190deb>] ? inode_sb_list_add+0x5b/0x70
Dec 25 18:08:01 Server16 kernel: [ 8637.420867]  [<ffffffff8108aa97>] ? bit_waitqueue+0x17/0xc0
Dec 25 18:08:01 Server16 kernel: [ 8637.420873]  [<ffffffff8165a39f>] wait_for_common+0xdf/0x180
Dec 25 18:08:01 Server16 kernel: [ 8637.420880]  [<ffffffff81182f67>] ? __follow_mount_rcu.isra.12+0x37/0xd0
Dec 25 18:08:01 Server16 kernel: [ 8637.420888]  [<ffffffff8105f990>] ? try_to_wake_up+0x200/0x200
Dec 25 18:08:01 Server16 kernel: [ 8637.420895]  [<ffffffff8165a51d>] wait_for_completion+0x1d/0x20
Dec 25 18:08:01 Server16 kernel: [ 8637.420924]  [<ffffffffa0438eb3>] __ocfs2_cluster_lock.isra.34+0x1f3/0x810 [ocfs2]
Dec 25 18:08:01 Server16 kernel: [ 8637.420932]  [<ffffffff81182f67>] ? __follow_mount_rcu.isra.12+0x37/0xd0
Dec 25 18:08:01 Server16 kernel: [ 8637.420939]  [<ffffffff81184162>] ? complete_walk+0x92/0x120
Dec 25 18:08:01 Server16 kernel: [ 8637.420962]  [<ffffffffa043a6ae>] ocfs2_inode_lock_full_nested+0x13e/0xa90 [ocfs2]
Dec 25 18:08:01 Server16 kernel: [ 8637.420987]  [<ffffffffa044870d>] ocfs2_inode_revalidate+0x7d/0x1b0 [ocfs2]
Dec 25 18:08:01 Server16 kernel: [ 8637.421010]  [<ffffffffa0440cb8>] ocfs2_getattr+0x38/0x100 [ocfs2]
Dec 25 18:08:01 Server16 kernel: [ 8637.421018]  [<ffffffff8117c86e>] vfs_getattr+0x4e/0x80
Dec 25 18:08:01 Server16 kernel: [ 8637.421024]  [<ffffffff8117c8ee>] vfs_fstatat+0x4e/0x70
Dec 25 18:08:01 Server16 kernel: [ 8637.421030]  [<ffffffff8117c94b>] vfs_stat+0x1b/0x20
Dec 25 18:08:01 Server16 kernel: [ 8637.421036]  [<ffffffff8117ca8a>] sys_newstat+0x1a/0x40
Dec 25 18:08:01 Server16 kernel: [ 8637.421044]  [<ffffffff81664a82>] system_call_fastpath+0x16/0x1b
Dec 25 18:08:01 Server16 kernel: [ 8637.421049] INFO: task ls:30774 blocked for more than 120 seconds.
Dec 25 18:08:01 Server16 kernel: [ 8637.428196] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Dec 25 18:08:01 Server16 kernel: [ 8637.442883] ls              D 0000000000000006     0 30774  30681 0x00000004
Dec 25 18:08:01 Server16 kernel: [ 8637.442888]  ffff8802f3bf7a88 0000000000000086 000000000000001f ffff8802f28d6200
Dec 25 18:08:01 Server16 kernel: [ 8637.442894]  ffff8802f3bf7fd8 ffff8802f3bf7fd8 ffff8802f3bf7fd8 0000000000013780
Dec 25 18:08:01 Server16 kernel: [ 8637.442905]  ffff8802f1e6dbc0 ffff8802b49b5bc0 000000010bffae00 7fffffffffffffff
Dec 25 18:08:01 Server16 kernel: [ 8637.442916] Call Trace:
Dec 25 18:08:01 Server16 kernel: [ 8637.442922]  [<ffffffff8165a55f>] schedule+0x3f/0x60
Dec 25 18:08:01 Server16 kernel: [ 8637.442928]  [<ffffffff8165aba5>] schedule_timeout+0x2a5/0x320
Dec 25 18:08:01 Server16 kernel: [ 8637.442935]  [<ffffffff8165a39f>] wait_for_common+0xdf/0x180
Dec 25 18:08:01 Server16 kernel: [ 8637.442941]  [<ffffffff81182f67>] ? __follow_mount_rcu.isra.12+0x37/0xd0
Dec 25 18:08:01 Server16 kernel: [ 8637.442948]  [<ffffffff8105f990>] ? try_to_wake_up+0x200/0x200
Dec 25 18:08:01 Server16 kernel: [ 8637.442955]  [<ffffffff8165a51d>] wait_for_completion+0x1d/0x20
Dec 25 18:08:01 Server16 kernel: [ 8637.442977]  [<ffffffffa0438eb3>] __ocfs2_cluster_lock.isra.34+0x1f3/0x810 [ocfs2]
Dec 25 18:08:01 Server16 kernel: [ 8637.442985]  [<ffffffff81182f67>] ? __follow_mount_rcu.isra.12+0x37/0xd0
Dec 25 18:08:01 Server16 kernel: [ 8637.442991]  [<ffffffff81184162>] ? complete_walk+0x92/0x120
Dec 25 18:08:01 Server16 kernel: [ 8637.443014]  [<ffffffffa043a6ae>] ocfs2_inode_lock_full_nested+0x13e/0xa90 [ocfs2]
Dec 25 18:08:01 Server16 kernel: [ 8637.443039]  [<ffffffffa044870d>] ocfs2_inode_revalidate+0x7d/0x1b0 [ocfs2]
Dec 25 18:08:01 Server16 kernel: [ 8637.443062]  [<ffffffffa0440cb8>] ocfs2_getattr+0x38/0x100 [ocfs2]
Dec 25 18:08:01 Server16 kernel: [ 8637.443069]  [<ffffffff8117c86e>] vfs_getattr+0x4e/0x80
Dec 25 18:08:01 Server16 kernel: [ 8637.443075]  [<ffffffff8117c8ee>] vfs_fstatat+0x4e/0x70
Dec 25 18:08:01 Server16 kernel: [ 8637.443081]  [<ffffffff8117c92e>] vfs_lstat+0x1e/0x20
Dec 25 18:08:01 Server16 kernel: [ 8637.443088]  [<ffffffff8117caca>] sys_newlstat+0x1a/0x40
Dec 25 18:08:01 Server16 kernel: [ 8637.443094]  [<ffffffff81664a82>] system_call_fastpath+0x16/0x1b
Dec 25 18:08:01 Server16 CRON[1823]: (root) CMD (   /opt/bin/ocfs2_iscsi_conf_chg_timer.sh)
Dec 25 18:08:01 Server16 CRON[1822]: (root) CMD (   /opt/bin/libvirtd_check.sh)
Dec 25 18:08:01 Server16 CRON[1824]: (root) CMD (   /opt/bin/ha_check_resource.sh)
Dec 25 18:09:01 Server16 CRON[2191]: (root) CMD (   /opt/bin/ocfs2_iscsi_conf_chg_timer.sh)
Dec 25 18:09:01 Server16 CRON[2192]: (root) CMD (   /opt/bin/libvirtd_check.sh)
Dec 25 18:10:01 Server16 kernel: [ 8757.382160] INFO: task bash:30770 blocked for more than 120 seconds.
Dec 25 18:10:01 Server16 kernel: [ 8757.389900] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Dec 25 18:10:01 Server16 kernel: [ 8757.405898] bash            D ffffffff81806240     0 30770      1 0x00000004
Dec 25 18:10:01 Server16 kernel: [ 8757.405904]  ffff8802b4871a88 0000000000000082 0000000000000000 ffff8802f4a48680
Dec 25 18:10:01 Server16 kernel: [ 8757.405910]  ffff8802b4871fd8 ffff8802b4871fd8 ffff8802b4871fd8 0000000000013780
Dec 25 18:10:01 Server16 kernel: [ 8757.405915]  ffff8802f6df96f0 ffff8802f2c88000 ffff8802f49e6548 7fffffffffffffff
Dec 25 18:10:01 Server16 kernel: [ 8757.405921] Call Trace:
Dec 25 18:10:01 Server16 kernel: [ 8757.405929]  [<ffffffff8165a55f>] schedule+0x3f/0x60
Dec 25 18:10:01 Server16 kernel: [ 8757.405933]  [<ffffffff8165aba5>] schedule_timeout+0x2a5/0x320
Dec 25 18:10:01 Server16 kernel: [ 8757.405939]  [<ffffffff8123b73f>] ? __ext4_ext_check+0xaf/0x160
Dec 25 18:10:01 Server16 kernel: [ 8757.405945]  [<ffffffff812152f3>] ? __ext4_get_inode_loc+0x113/0x410
Dec 25 18:10:01 Server16 kernel: [ 8757.405951]  [<ffffffff81190deb>] ? inode_sb_list_add+0x5b/0x70
Dec 25 18:10:01 Server16 kernel: [ 8757.405956]  [<ffffffff8108aa97>] ? bit_waitqueue+0x17/0xc0
Dec 25 18:10:01 Server16 kernel: [ 8757.405960]  [<ffffffff8165a39f>] wait_for_common+0xdf/0x180
Dec 25 18:10:01 Server16 kernel: [ 8757.405964]  [<ffffffff81182f67>] ? __follow_mount_rcu.isra.12+0x37/0xd0
Dec 25 18:10:01 Server16 kernel: [ 8757.405970]  [<ffffffff8105f990>] ? try_to_wake_up+0x200/0x200
Dec 25 18:10:01 Server16 kernel: [ 8757.405974]  [<ffffffff8165a51d>] wait_for_completion+0x1d/0x20
Dec 25 18:10:01 Server16 kernel: [ 8757.406002]  [<ffffffffa0438eb3>] __ocfs2_cluster_lock.isra.34+0x1f3/0x810 [ocfs2]
Dec 25 18:10:01 Server16 kernel: [ 8757.406006]  [<ffffffff81182f67>] ? __follow_mount_rcu.isra.12+0x37/0xd0
Dec 25 18:10:01 Server16 kernel: [ 8757.406010]  [<ffffffff81184162>] ? complete_walk+0x92/0x120
Dec 25 18:10:01 Server16 kernel: [ 8757.406031]  [<ffffffffa043a6ae>] ocfs2_inode_lock_full_nested+0x13e/0xa90 [ocfs2]
Dec 25 18:10:01 Server16 kernel: [ 8757.406163]  [<ffffffffa044870d>] ocfs2_inode_revalidate+0x7d/0x1b0 [ocfs2]
Dec 25 18:10:01 Server16 kernel: [ 8757.406188]  [<ffffffffa0440cb8>] ocfs2_getattr+0x38/0x100 [ocfs2]
Dec 25 18:10:01 Server16 kernel: [ 8757.406196]  [<ffffffff8117c86e>] vfs_getattr+0x4e/0x80
Dec 25 18:10:01 Server16 kernel: [ 8757.406203]  [<ffffffff8117c8ee>] vfs_fstatat+0x4e/0x70
Dec 25 18:10:01 Server16 kernel: [ 8757.406209]  [<ffffffff8117c94b>] vfs_stat+0x1b/0x20
Dec 25 18:10:01 Server16 kernel: [ 8757.406215]  [<ffffffff8117ca8a>] sys_newstat+0x1a/0x40
Dec 25 18:10:01 Server16 kernel: [ 8757.406223]  [<ffffffff81664a82>] system_call_fastpath+0x16/0x1b
Dec 25 18:10:01 Server16 kernel: [ 8757.406229] INFO: task ls:30774 blocked for more than 120 seconds.
Dec 25 18:10:01 Server16 kernel: [ 8757.414752] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Dec 25 18:10:01 Server16 kernel: [ 8757.431397] ls              D 0000000000000006     0 30774  30681 0x00000004
Dec 25 18:10:01 Server16 kernel: [ 8757.431402]  ffff8802f3bf7a88 0000000000000086 000000000000001f ffff8802f28d6200
Dec 25 18:10:01 Server16 kernel: [ 8757.431408]  ffff8802f3bf7fd8 ffff8802f3bf7fd8 ffff8802f3bf7fd8 0000000000013780
Dec 25 18:10:01 Server16 kernel: [ 8757.431413]  ffff8802f1e6dbc0 ffff8802b49b5bc0 000000010bffae00 7fffffffffffffff
Dec 25 18:10:01 Server16 kernel: [ 8757.431418] Call Trace:
Dec 25 18:10:01 Server16 kernel: [ 8757.431422]  [<ffffffff8165a55f>] schedule+0x3f/0x60
Dec 25 18:10:01 Server16 kernel: [ 8757.431426]  [<ffffffff8165aba5>] schedule_timeout+0x2a5/0x320
Dec 25 18:10:01 Server16 kernel: [ 8757.431430]  [<ffffffff8165a39f>] wait_for_common+0xdf/0x180
Dec 25 18:10:01 Server16 kernel: [ 8757.431434]  [<ffffffff81182f67>] ? __follow_mount_rcu.isra.12+0x37/0xd0
Dec 25 18:10:01 Server16 kernel: [ 8757.431439]  [<ffffffff8105f990>] ? try_to_wake_up+0x200/0x200
Dec 25 18:10:01 Server16 kernel: [ 8757.431442]  [<ffffffff8165a51d>] wait_for_completion+0x1d/0x20
Dec 25 18:10:01 Server16 kernel: [ 8757.431462]  [<ffffffffa0438eb3>] __ocfs2_cluster_lock.isra.34+0x1f3/0x810 [ocfs2]
Dec 25 18:10:01 Server16 kernel: [ 8757.431467]  [<ffffffff81182f67>] ? __follow_mount_rcu.isra.12+0x37/0xd0
Dec 25 18:10:01 Server16 kernel: [ 8757.431471]  [<ffffffff81184162>] ? complete_walk+0x92/0x120
Dec 25 18:10:01 Server16 kernel: [ 8757.431491]  [<ffffffffa043a6ae>] ocfs2_inode_lock_full_nested+0x13e/0xa90 [ocfs2]
Dec 25 18:10:01 Server16 kernel: [ 8757.431513]  [<ffffffffa044870d>] ocfs2_inode_revalidate+0x7d/0x1b0 [ocfs2]
Dec 25 18:10:01 Server16 kernel: [ 8757.431534]  [<ffffffffa0440cb8>] ocfs2_getattr+0x38/0x100 [ocfs2]
Dec 25 18:10:01 Server16 kernel: [ 8757.431538]  [<ffffffff8117c86e>] vfs_getattr+0x4e/0x80
Dec 25 18:10:01 Server16 kernel: [ 8757.431542]  [<ffffffff8117c8ee>] vfs_fstatat+0x4e/0x70
Dec 25 18:10:01 Server16 kernel: [ 8757.431546]  [<ffffffff8117c92e>] vfs_lstat+0x1e/0x20
Dec 25 18:10:01 Server16 kernel: [ 8757.431550]  [<ffffffff8117caca>] sys_newlstat+0x1a/0x40
Dec 25 18:10:01 Server16 kernel: [ 8757.431554]  [<ffffffff81664a82>] system_call_fastpath+0x16/0x1b
-------------------------------------------------------------------------------------------------------------------------------------
????????????????????????????????????????
????????????????????????????????????????
????????????????????????????????????????
???
This e-mail and its attachments contain confidential information from H3C, which is
intended only for the person or entity whose address is listed above. Any use of the
information contained herein in any way (including, but not limited to, total or partial
disclosure, reproduction, or dissemination) by persons other than the intended
recipient(s) is prohibited. If you receive this e-mail in error, please notify the sender
by phone or email immediately and delete it!
-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20121227/789a91e4/attachment-0001.html 
