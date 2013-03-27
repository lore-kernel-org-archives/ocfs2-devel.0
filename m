From: Guozhonghua <guozhonghua@h3c.com>
Date: Wed, 27 Mar 2013 03:30:47 +0000
Subject: [Ocfs2-devel] OCFS2 issues reports, any ideads or patches, Thanks
Message-ID: <71604351584F6A4EBAE558C676F37CA417BC9297@H3CMLB02-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


Mar 27 10:54:08 cvk-7 kernel: [  361.374376] INFO: task kworker/u:1:73 blocked for more than 120 seconds.
Mar 27 10:54:08 cvk-7 kernel: [  361.374383] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Mar 27 10:54:08 cvk-7 kernel: [  361.374389] kworker/u:1     D ffffffff81806240     0    73      2 0x00000000
Mar 27 10:54:08 cvk-7 kernel: [  361.374395]  ffff880405883ba0 0000000000000046 0000000000000600 ffff880404839548
Mar 27 10:54:08 cvk-7 kernel: [  361.374401]  ffff880405883fd8 ffff880405883fd8 ffff880405883fd8 0000000000013780
Mar 27 10:54:08 cvk-7 kernel: [  361.374406]  ffff880405f316f0 ffff880405888000 ffff880405883bb0 ffff880405b59000
Mar 27 10:54:08 cvk-7 kernel: [  361.374412] Call Trace:
Mar 27 10:54:08 cvk-7 kernel: [  361.374420]  [<ffffffff8165a55f>] schedule+0x3f/0x60
Mar 27 10:54:08 cvk-7 kernel: [  361.374457]  [<ffffffffa056bd9d>] ocfs2_wait_for_recovery+0x5d/0x90 [ocfs2]
Mar 27 10:54:08 cvk-7 kernel: [  361.374464]  [<ffffffff8108aec0>] ? add_wait_queue+0x60/0x60
Mar 27 10:54:08 cvk-7 kernel: [  361.374484]  [<ffffffffa0556768>] ocfs2_inode_lock_full_nested+0x1d8/0xa90 [ocfs2]
Mar 27 10:54:08 cvk-7 kernel: [  361.374508]  [<ffffffffa0570120>] ocfs2_complete_local_alloc_recovery+0x70/0x3e0 [ocfs2]
Mar 27 10:54:08 cvk-7 kernel: [  361.374531]  [<ffffffffa056bf54>] ocfs2_complete_recovery+0x184/0xb20 [ocfs2]
Mar 27 10:54:08 cvk-7 kernel: [  361.374555]  [<ffffffffa056bdd0>] ? ocfs2_wait_for_recovery+0x90/0x90 [ocfs2]
Mar 27 10:54:08 cvk-7 kernel: [  361.374561]  [<ffffffff81084e2a>] process_one_work+0x11a/0x480
Mar 27 10:54:08 cvk-7 kernel: [  361.374565]  [<ffffffff81085bd4>] worker_thread+0x164/0x370
Mar 27 10:54:08 cvk-7 kernel: [  361.374570]  [<ffffffff81085a70>] ? manage_workers.isra.29+0x130/0x130
Mar 27 10:54:08 cvk-7 kernel: [  361.374574]  [<ffffffff8108a42c>] kthread+0x8c/0xa0
Mar 27 10:54:08 cvk-7 kernel: [  361.374579]  [<ffffffff81666bf4>] kernel_thread_helper+0x4/0x10
Mar 27 10:54:08 cvk-7 kernel: [  361.374583]  [<ffffffff8108a3a0>] ? flush_kthread_worker+0xa0/0xa0
Mar 27 10:54:08 cvk-7 kernel: [  361.374587]  [<ffffffff81666bf0>] ? gs_change+0x13/0x13
Mar 27 10:54:08 cvk-7 kernel: [  361.374610] INFO: task libvirtd:3302 blocked for more than 120 seconds.
Mar 27 10:54:08 cvk-7 kernel: [  361.374614] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Mar 27 10:54:08 cvk-7 kernel: [  361.374619] libvirtd        D ffffffff81806240     0  3302      1 0x00000000
Mar 27 10:54:08 cvk-7 kernel: [  361.374624]  ffff880803117b88 0000000000000082 ffff880803117b38 ffffffff81314079
Mar 27 10:54:08 cvk-7 kernel: [  361.374630]  ffff880803117fd8 ffff880803117fd8 ffff880803117fd8 0000000000013780
Mar 27 10:54:08 cvk-7 kernel: [  361.374635]  ffff880405f144d0 ffff8807ed18c4d0 ffff880803117b98 ffff880405b59000
Mar 27 10:54:08 cvk-7 kernel: [  361.374640] Call Trace:
Mar 27 10:54:08 cvk-7 kernel: [  361.374646]  [<ffffffff81314079>] ? put_dec+0x59/0x60
Mar 27 10:54:08 cvk-7 kernel: [  361.374649]  [<ffffffff8165a55f>] schedule+0x3f/0x60
Mar 27 10:54:08 cvk-7 kernel: [  361.374672]  [<ffffffffa056bd9d>] ocfs2_wait_for_recovery+0x5d/0x90 [ocfs2]
Mar 27 10:54:08 cvk-7 kernel: [  361.374676]  [<ffffffff8108aec0>] ? add_wait_queue+0x60/0x60
Mar 27 10:54:08 cvk-7 kernel: [  361.374696]  [<ffffffffa0556768>] ocfs2_inode_lock_full_nested+0x1d8/0xa90 [ocfs2]
Mar 27 10:54:08 cvk-7 kernel: [  361.374701]  [<ffffffff81182f67>] ? __follow_mount_rcu.isra.12+0x37/0xd0
Mar 27 10:54:08 cvk-7 kernel: [  361.374722]  [<ffffffffa055cbd8>] ocfs2_permission+0x38/0x100 [ocfs2]
Mar 27 10:54:08 cvk-7 kernel: [  361.374726]  [<ffffffff811835c6>] inode_permission+0xa6/0x110
Mar 27 10:54:08 cvk-7 kernel: [  361.374730]  [<ffffffff81184162>] ? complete_walk+0x92/0x120
Mar 27 10:54:08 cvk-7 kernel: [  361.374734]  [<ffffffff811836a5>] may_open+0x75/0x120
Mar 27 10:54:08 cvk-7 kernel: [  361.374737]  [<ffffffff81185b5b>] do_last+0x1ab/0x730
Mar 27 10:54:08 cvk-7 kernel: [  361.374741]  [<ffffffff81187481>] path_openat+0xd1/0x3f0
Mar 27 10:54:08 cvk-7 kernel: [  361.374745]  [<ffffffff811878c2>] do_filp_open+0x42/0xa0
Mar 27 10:54:08 cvk-7 kernel: [  361.374751]  [<ffffffff81318ce1>] ? strncpy_from_user+0x31/0x40
Mar 27 10:54:08 cvk-7 kernel: [  361.374755]  [<ffffffff81182c0a>] ? do_getname+0x10a/0x180
Mar 27 10:54:08 cvk-7 kernel: [  361.374759]  [<ffffffff8165c46e>] ? _raw_spin_lock+0xe/0x20
Mar 27 10:54:08 cvk-7 kernel: [  361.374764]  [<ffffffff81194b67>] ? alloc_fd+0xf7/0x150
Mar 27 10:54:08 cvk-7 kernel: [  361.374769]  [<ffffffff81176f6d>] do_sys_open+0xed/0x220
Mar 27 10:54:08 cvk-7 kernel: [  361.374773]  [<ffffffff81179175>] ? fput+0x25/0x30
Mar 27 10:54:08 cvk-7 kernel: [  361.374776]  [<ffffffff811770e1>] sys_openat+0x11/0x20
Mar 27 10:54:08 cvk-7 kernel: [  361.374780]  [<ffffffff81664a82>] system_call_fastpath+0x16/0x1b
Mar 27 10:55:01 cvk-7 CRON[5165]: (root) CMD (command -v debian-sa1 > /dev/null && debian-sa1 1 1)
Mar 27 10:55:01 cvk-7 CRON[5166]: (root) CMD (   /opt/bin/ocfs2_iscsi_conf_chg_timer.sh)
Mar 27 10:55:01 cvk-7 CRON[5167]: (root) CMD (   /opt/bin/ha_cleanup.sh)
Mar 27 10:56:01 cvk-7 CRON[5404]: (root) CMD (   /opt/bin/ocfs2_iscsi_conf_chg_timer.sh)
Mar 27 10:56:01 cvk-7 CRON[5405]: (root) CMD (   /opt/bin/ha_check_resource.sh)
Mar 27 10:56:08 cvk-7 kernel: [  481.175441] INFO: task kworker/u:1:73 blocked for more than 120 seconds.
Mar 27 10:56:08 cvk-7 kernel: [  481.175447] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Mar 27 10:56:08 cvk-7 kernel: [  481.175453] kworker/u:1     D ffffffff81806240     0    73      2 0x00000000
Mar 27 10:56:08 cvk-7 kernel: [  481.175458]  ffff880405883ba0 0000000000000046 0000000000000600 ffff880404839548
Mar 27 10:56:08 cvk-7 kernel: [  481.175465]  ffff880405883fd8 ffff880405883fd8 ffff880405883fd8 0000000000013780
Mar 27 10:56:08 cvk-7 kernel: [  481.175470]  ffff880405f316f0 ffff880405888000 ffff880405883bb0 ffff880405b59000
Mar 27 10:56:08 cvk-7 kernel: [  481.175476] Call Trace:
Mar 27 10:56:08 cvk-7 kernel: [  481.175484]  [<ffffffff8165a55f>] schedule+0x3f/0x60
Mar 27 10:56:08 cvk-7 kernel: [  481.175519]  [<ffffffffa056bd9d>] ocfs2_wait_for_recovery+0x5d/0x90 [ocfs2]
Mar 27 10:56:08 cvk-7 kernel: [  481.175526]  [<ffffffff8108aec0>] ? add_wait_queue+0x60/0x60
Mar 27 10:56:08 cvk-7 kernel: [  481.175546]  [<ffffffffa0556768>] ocfs2_inode_lock_full_nested+0x1d8/0xa90 [ocfs2]
Mar 27 10:56:08 cvk-7 kernel: [  481.175570]  [<ffffffffa0570120>] ocfs2_complete_local_alloc_recovery+0x70/0x3e0 [ocfs2]
Mar 27 10:56:08 cvk-7 kernel: [  481.175593]  [<ffffffffa056bf54>] ocfs2_complete_recovery+0x184/0xb20 [ocfs2]
Mar 27 10:56:08 cvk-7 kernel: [  481.175617]  [<ffffffffa056bdd0>] ? ocfs2_wait_for_recovery+0x90/0x90 [ocfs2]
Mar 27 10:56:08 cvk-7 kernel: [  481.175623]  [<ffffffff81084e2a>] process_one_work+0x11a/0x480
Mar 27 10:56:08 cvk-7 kernel: [  481.175627]  [<ffffffff81085bd4>] worker_thread+0x164/0x370
Mar 27 10:56:08 cvk-7 kernel: [  481.175632]  [<ffffffff81085a70>] ? manage_workers.isra.29+0x130/0x130
Mar 27 10:56:08 cvk-7 kernel: [  481.175636]  [<ffffffff8108a42c>] kthread+0x8c/0xa0
Mar 27 10:56:08 cvk-7 kernel: [  481.175641]  [<ffffffff81666bf4>] kernel_thread_helper+0x4/0x10
Mar 27 10:56:08 cvk-7 kernel: [  481.175645]  [<ffffffff8108a3a0>] ? flush_kthread_worker+0xa0/0xa0
Mar 27 10:56:08 cvk-7 kernel: [  481.175649]  [<ffffffff81666bf0>] ? gs_change+0x13/0x13
Mar 27 10:56:08 cvk-7 kernel: [  481.175673] INFO: task libvirtd:3302 blocked for more than 120 seconds.
Mar 27 10:56:08 cvk-7 kernel: [  481.175677] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Mar 27 10:56:08 cvk-7 kernel: [  481.175682] libvirtd        D ffffffff81806240     0  3302      1 0x00000000
Mar 27 10:56:08 cvk-7 kernel: [  481.175687]  ffff880803117b88 0000000000000082 ffff880803117b38 ffffffff81314079
Mar 27 10:56:08 cvk-7 kernel: [  481.175692]  ffff880803117fd8 ffff880803117fd8 ffff880803117fd8 0000000000013780
Mar 27 10:56:08 cvk-7 kernel: [  481.175697]  ffff880405f144d0 ffff8807ed18c4d0 ffff880803117b98 ffff880405b59000
Mar 27 10:56:08 cvk-7 kernel: [  481.175703] Call Trace:
Mar 27 10:56:08 cvk-7 kernel: [  481.175708]  [<ffffffff81314079>] ? put_dec+0x59/0x60
Mar 27 10:56:08 cvk-7 kernel: [  481.175712]  [<ffffffff8165a55f>] schedule+0x3f/0x60
Mar 27 10:56:08 cvk-7 kernel: [  481.175735]  [<ffffffffa056bd9d>] ocfs2_wait_for_recovery+0x5d/0x90 [ocfs2]
Mar 27 10:56:08 cvk-7 kernel: [  481.175739]  [<ffffffff8108aec0>] ? add_wait_queue+0x60/0x60
Mar 27 10:56:08 cvk-7 kernel: [  481.175759]  [<ffffffffa0556768>] ocfs2_inode_lock_full_nested+0x1d8/0xa90 [ocfs2]
Mar 27 10:56:08 cvk-7 kernel: [  481.175764]  [<ffffffff81182f67>] ? __follow_mount_rcu.isra.12+0x37/0xd0
Mar 27 10:56:08 cvk-7 kernel: [  481.175785]  [<ffffffffa055cbd8>] ocfs2_permission+0x38/0x100 [ocfs2]
Mar 27 10:56:08 cvk-7 kernel: [  481.175789]  [<ffffffff811835c6>] inode_permission+0xa6/0x110
Mar 27 10:56:08 cvk-7 kernel: [  481.175793]  [<ffffffff81184162>] ? complete_walk+0x92/0x120
Mar 27 10:56:08 cvk-7 kernel: [  481.175796]  [<ffffffff811836a5>] may_open+0x75/0x120
Mar 27 10:56:08 cvk-7 kernel: [  481.175800]  [<ffffffff81185b5b>] do_last+0x1ab/0x730
Mar 27 10:56:08 cvk-7 kernel: [  481.175804]  [<ffffffff81187481>] path_openat+0xd1/0x3f0
Mar 27 10:56:08 cvk-7 kernel: [  481.175808]  [<ffffffff811878c2>] do_filp_open+0x42/0xa0
Mar 27 10:56:08 cvk-7 kernel: [  481.175814]  [<ffffffff81318ce1>] ? strncpy_from_user+0x31/0x40
Mar 27 10:56:08 cvk-7 kernel: [  481.175817]  [<ffffffff81182c0a>] ? do_getname+0x10a/0x180
Mar 27 10:56:08 cvk-7 kernel: [  481.175822]  [<ffffffff8165c46e>] ? _raw_spin_lock+0xe/0x20
Mar 27 10:56:08 cvk-7 kernel: [  481.175827]  [<ffffffff81194b67>] ? alloc_fd+0xf7/0x150
Mar 27 10:56:08 cvk-7 kernel: [  481.175831]  [<ffffffff81176f6d>] do_sys_open+0xed/0x220
Mar 27 10:56:08 cvk-7 kernel: [  481.175835]  [<ffffffff81179175>] ? fput+0x25/0x30
Mar 27 10:56:08 cvk-7 kernel: [  481.175839]  [<ffffffff811770e1>] sys_openat+0x11/0x20
Mar 27 10:56:08 cvk-7 kernel: [  481.175843]  [<ffffffff81664a82>] system_call_fastpath+0x16/0x1b
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
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20130327/6ab98423/attachment-0001.html 
