From: Guozhonghua <guozhonghua@h3c.com>
Date: Sun, 28 Apr 2013 10:54:16 +0000
Subject: [Ocfs2-devel] Is it one issue. Do you have some good ideas,
	thanks a lot.
Message-ID: <71604351584F6A4EBAE558C676F37CA417BD75FE@H3CMLB02-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi, everyone

I have some questions with the OCFS2 when using it as vm-store.

With Ubuntu 1204, kernel version is 3.2.40, and ocfs2-tools version is 1.6.4.

As the network configure change, there are some issues as the log below.

Why is there the information of "Node 255 (he) is the Recovery Master for the dead node 255" in the syslog?
Why the host ZHJD-VM6 is blocked until it reboot one day time later, and what is it wait for still?

Thanks a lot.


Apr 27 17:35:59 ZHJD-VM6 kernel: [ 3734.057330] o2net: Connection to node ZHJD-VM5 (num 5) at 185.200.1.16:7100 has been idle for 30.100 secs, shutting it down.
Apr 27 17:35:59 ZHJD-VM6 kernel: [ 3734.057359] o2net: No longer connected to node ZHJD-VM5 (num 5) at 185.200.1.16:7100
Apr 27 17:35:59 ZHJD-VM6 kernel: [ 3734.058212] o2net: Connected to node ZHJD-VM5 (num 5) at 185.200.1.16:7100
Apr 27 17:36:01 ZHJD-VM6 CRON[17869]: (root) CMD (   /opt/bin/ocfs2_iscsi_conf_chg_timer.sh)
Apr 27 17:36:01 ZHJD-VM6 CRON[17868]: (root) CMD (   /opt/bin/libvirtd_check.sh)
Apr 27 17:37:01 ZHJD-VM6 CRON[18199]: (root) CMD (   /opt/bin/libvirtd_check.sh)
Apr 27 17:37:01 ZHJD-VM6 CRON[18198]: (root) CMD (   /opt/bin/ocfs2_iscsi_conf_chg_timer.sh)
Apr 27 17:38:01 ZHJD-VM6 CRON[18536]: (root) CMD (   /opt/bin/libvirtd_check.sh)
Apr 27 17:38:01 ZHJD-VM6 CRON[18535]: (root) CMD (   /opt/bin/ocfs2_iscsi_conf_chg_timer.sh)
Apr 27 17:39:01 ZHJD-VM6 CRON[18798]: (root) CMD (   /opt/bin/ocfs2_iscsi_conf_chg_timer.sh)
Apr 27 17:39:01 ZHJD-VM6 CRON[18799]: (root) CMD (   /opt/bin/libvirtd_check.sh)
Apr 27 17:39:45 ZHJD-VM6 kernel: [ 3959.123993] INFO: task kworker/u:0:5 blocked for more than 120 seconds.
Apr 27 17:39:45 ZHJD-VM6 kernel: [ 3959.124000] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Apr 27 17:39:45 ZHJD-VM6 kernel: [ 3959.124006] kworker/u:0     D ffffffff81806240     0     5      2 0x00000000
Apr 27 17:39:45 ZHJD-VM6 kernel: [ 3959.124011]  ffff8805f792ba70 0000000000000046 ffff8805f792ba60 ffff8805d7cf5000
Apr 27 17:39:45 ZHJD-VM6 kernel: [ 3959.124017]  ffff8805f792bfd8 ffff8805f792bfd8 ffff8805f792bfd8 0000000000013780
Apr 27 17:39:45 ZHJD-VM6 kernel: [ 3959.124022]  ffff8805f74696f0 ffff8805f7905bc0 ffff8805f2a25200 7fffffffffffffff
Apr 27 17:39:45 ZHJD-VM6 kernel: [ 3959.124027] Call Trace:
Apr 27 17:39:45 ZHJD-VM6 kernel: [ 3959.124035]  [<ffffffff8165a55f>] schedule+0x3f/0x60
Apr 27 17:39:45 ZHJD-VM6 kernel: [ 3959.124039]  [<ffffffff8165aba5>] schedule_timeout+0x2a5/0x320
Apr 27 17:39:45 ZHJD-VM6 kernel: [ 3959.124046]  [<ffffffffa036e020>] ? o2dlm_lock_ast_wrapper+0x20/0x20 [ocfs2_stack_o2cb]
Apr 27 17:39:45 ZHJD-VM6 kernel: [ 3959.124051]  [<ffffffff8158346a>] ? do_tcp_sendpages+0x5ba/0x6e0
Apr 27 17:39:45 ZHJD-VM6 kernel: [ 3959.124055]  [<ffffffff8165a39f>] wait_for_common+0xdf/0x180
Apr 27 17:39:45 ZHJD-VM6 kernel: [ 3959.124061]  [<ffffffff8105f990>] ? try_to_wake_up+0x200/0x200
Apr 27 17:39:45 ZHJD-VM6 kernel: [ 3959.124065]  [<ffffffff8165a51d>] wait_for_completion+0x1d/0x20
Apr 27 17:39:45 ZHJD-VM6 kernel: [ 3959.124092]  [<ffffffffa053beb3>] __ocfs2_cluster_lock.isra.34+0x1f3/0x810 [ocfs2]
Apr 27 17:39:45 ZHJD-VM6 kernel: [ 3959.124116]  [<ffffffffa05543e0>] ? ocfs2_queue_orphan_scan+0x270/0x270 [ocfs2]
Apr 27 17:39:45 ZHJD-VM6 kernel: [ 3959.124136]  [<ffffffffa053d0a9>] ocfs2_orphan_scan_lock+0x99/0xf0 [ocfs2]
Apr 27 17:39:45 ZHJD-VM6 kernel: [ 3959.124159]  [<ffffffffa05543e0>] ? ocfs2_queue_orphan_scan+0x270/0x270 [ocfs2]
Apr 27 17:39:45 ZHJD-VM6 kernel: [ 3959.124181]  [<ffffffffa05541c5>] ocfs2_queue_orphan_scan+0x55/0x270 [ocfs2]
Apr 27 17:39:45 ZHJD-VM6 kernel: [ 3959.124204]  [<ffffffffa05543e0>] ? ocfs2_queue_orphan_scan+0x270/0x270 [ocfs2]
Apr 27 17:39:45 ZHJD-VM6 kernel: [ 3959.124226]  [<ffffffffa055441a>] ocfs2_orphan_scan_work+0x3a/0xb0 [ocfs2]
Apr 27 17:39:45 ZHJD-VM6 kernel: [ 3959.124232]  [<ffffffff81084e2a>] process_one_work+0x11a/0x480
Apr 27 17:39:45 ZHJD-VM6 kernel: [ 3959.124236]  [<ffffffff81085bd4>] worker_thread+0x164/0x370
Apr 27 17:39:45 ZHJD-VM6 kernel: [ 3959.124241]  [<ffffffff81085a70>] ? manage_workers.isra.29+0x130/0x130
Apr 27 17:39:45 ZHJD-VM6 kernel: [ 3959.124246]  [<ffffffff8108a42c>] kthread+0x8c/0xa0
Apr 27 17:39:45 ZHJD-VM6 kernel: [ 3959.124251]  [<ffffffff81666bf4>] kernel_thread_helper+0x4/0x10
Apr 27 17:39:45 ZHJD-VM6 kernel: [ 3959.124255]  [<ffffffff8108a3a0>] ? flush_kthread_worker+0xa0/0xa0
Apr 27 17:39:45 ZHJD-VM6 kernel: [ 3959.124259]  [<ffffffff81666bf0>] ? gs_change+0x13/0x13
Apr 27 17:40:01 ZHJD-VM6 CRON[19062]: (root) CMD (   /opt/bin/ha_check_resource.sh)
Apr 27 17:40:01 ZHJD-VM6 CRON[19061]: (root) CMD (   /opt/bin/libvirtd_check.sh)
Apr 27 17:40:01 ZHJD-VM6 CRON[19063]: (root) CMD (   /opt/bin/ha_cleanup.sh)
Apr 27 17:40:01 ZHJD-VM6 CRON[19064]: (root) CMD (   /opt/bin/ocfs2_iscsi_conf_chg_timer.sh)
Apr 27 17:41:01 ZHJD-VM6 CRON[19360]: (root) CMD (   /opt/bin/libvirtd_check.sh)
Apr 27 17:41:01 ZHJD-VM6 CRON[19359]: (root) CMD (   /opt/bin/ocfs2_iscsi_conf_chg_timer.sh)
Apr 27 17:41:45 ZHJD-VM6 kernel: [ 4079.065702] INFO: task kworker/u:0:5 blocked for more than 120 seconds.
Apr 27 17:41:45 ZHJD-VM6 kernel: [ 4079.065709] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Apr 27 17:41:45 ZHJD-VM6 kernel: [ 4079.065715] kworker/u:0     D ffffffff81806240     0     5      2 0x00000000
Apr 27 17:41:45 ZHJD-VM6 kernel: [ 4079.065720]  ffff8805f792ba70 0000000000000046 ffff8805f792ba60 ffff8805d7cf5000
Apr 27 17:41:45 ZHJD-VM6 kernel: [ 4079.065726]  ffff8805f792bfd8 ffff8805f792bfd8 ffff8805f792bfd8 0000000000013780
Apr 27 17:41:45 ZHJD-VM6 kernel: [ 4079.065731]  ffff8805f74696f0 ffff8805f7905bc0 ffff8805f2a25200 7fffffffffffffff
Apr 27 17:41:45 ZHJD-VM6 kernel: [ 4079.065736] Call Trace:
Apr 27 17:41:45 ZHJD-VM6 kernel: [ 4079.065744]  [<ffffffff8165a55f>] schedule+0x3f/0x60
Apr 27 17:41:45 ZHJD-VM6 kernel: [ 4079.065748]  [<ffffffff8165aba5>] schedule_timeout+0x2a5/0x320
Apr 27 17:41:45 ZHJD-VM6 kernel: [ 4079.065755]  [<ffffffffa036e020>] ? o2dlm_lock_ast_wrapper+0x20/0x20 [ocfs2_stack_o2cb]
Apr 27 17:41:45 ZHJD-VM6 kernel: [ 4079.065761]  [<ffffffff8158346a>] ? do_tcp_sendpages+0x5ba/0x6e0
Apr 27 17:41:45 ZHJD-VM6 kernel: [ 4079.065764]  [<ffffffff8165a39f>] wait_for_common+0xdf/0x180
Apr 27 17:41:45 ZHJD-VM6 kernel: [ 4079.065770]  [<ffffffff8105f990>] ? try_to_wake_up+0x200/0x200
Apr 27 17:41:45 ZHJD-VM6 kernel: [ 4079.065774]  [<ffffffff8165a51d>] wait_for_completion+0x1d/0x20
Apr 27 17:41:45 ZHJD-VM6 kernel: [ 4079.065800]  [<ffffffffa053beb3>] __ocfs2_cluster_lock.isra.34+0x1f3/0x810 [ocfs2]
Apr 27 17:41:45 ZHJD-VM6 kernel: [ 4079.065824]  [<ffffffffa05543e0>] ? ocfs2_queue_orphan_scan+0x270/0x270 [ocfs2]
Apr 27 17:41:45 ZHJD-VM6 kernel: [ 4079.065845]  [<ffffffffa053d0a9>] ocfs2_orphan_scan_lock+0x99/0xf0 [ocfs2]
Apr 27 17:41:45 ZHJD-VM6 kernel: [ 4079.065867]  [<ffffffffa05543e0>] ? ocfs2_queue_orphan_scan+0x270/0x270 [ocfs2]
Apr 27 17:41:45 ZHJD-VM6 kernel: [ 4079.065890]  [<ffffffffa05541c5>] ocfs2_queue_orphan_scan+0x55/0x270 [ocfs2]
Apr 27 17:41:45 ZHJD-VM6 kernel: [ 4079.065913]  [<ffffffffa05543e0>] ? ocfs2_queue_orphan_scan+0x270/0x270 [ocfs2]
Apr 27 17:41:45 ZHJD-VM6 kernel: [ 4079.065935]  [<ffffffffa055441a>] ocfs2_orphan_scan_work+0x3a/0xb0 [ocfs2]
Apr 27 17:41:45 ZHJD-VM6 kernel: [ 4079.065941]  [<ffffffff81084e2a>] process_one_work+0x11a/0x480
Apr 27 17:41:45 ZHJD-VM6 kernel: [ 4079.065945]  [<ffffffff81085bd4>] worker_thread+0x164/0x370
Apr 27 17:41:45 ZHJD-VM6 kernel: [ 4079.065949]  [<ffffffff81085a70>] ? manage_workers.isra.29+0x130/0x130
Apr 27 17:41:45 ZHJD-VM6 kernel: [ 4079.065954]  [<ffffffff8108a42c>] kthread+0x8c/0xa0
Apr 27 17:41:45 ZHJD-VM6 kernel: [ 4079.065960]  [<ffffffff81666bf4>] kernel_thread_helper+0x4/0x10
Apr 27 17:41:45 ZHJD-VM6 kernel: [ 4079.065963]  [<ffffffff8108a3a0>] ? flush_kthread_worker+0xa0/0xa0
Apr 27 17:41:45 ZHJD-VM6 kernel: [ 4079.065967]  [<ffffffff81666bf0>] ? gs_change+0x13/0x13
Apr 27 17:42:01 ZHJD-VM6 CRON[19620]: (root) CMD (   /opt/bin/libvirtd_check.sh)
Apr 27 17:42:01 ZHJD-VM6 CRON[19621]: (root) CMD (   /opt/bin/ocfs2_iscsi_conf_chg_timer.sh)
Apr 27 17:43:01 ZHJD-VM6 CRON[19881]: (root) CMD (   /opt/bin/libvirtd_check.sh)
Apr 27 17:43:01 ZHJD-VM6 CRON[19882]: (root) CMD (   /opt/bin/ocfs2_iscsi_conf_chg_timer.sh)
Apr 27 17:43:32 ZHJD-VM6 kernel: [ 4186.125655] o2net: Connection to node 2013-SRV06 (num 1) at 185.200.1.13:7100 has been idle for 30.60 secs, shutting it down.
Apr 27 17:43:32 ZHJD-VM6 kernel: [ 4186.125688] o2net: No longer connected to node 2013-SRV06 (num 1) at 185.200.1.13:7100
Apr 27 17:43:41 ZHJD-VM6 kernel: [ 4195.912900] o2net: Connection to node 2013-SRV09 (num 2) at 185.200.1.14:7100 has been idle for 30.81 secs, shutting it down.
Apr 27 17:43:41 ZHJD-VM6 kernel: [ 4195.912937] o2net: No longer connected to node 2013-SRV09 (num 2) at 185.200.1.14:7100
Apr 27 17:43:45 ZHJD-VM6 kernel: [ 4199.007406] INFO: task kworker/u:0:5 blocked for more than 120 seconds.
Apr 27 17:43:45 ZHJD-VM6 kernel: [ 4199.007412] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Apr 27 17:43:45 ZHJD-VM6 kernel: [ 4199.007418] kworker/u:0     D ffffffff81806240     0     5      2 0x00000000
Apr 27 17:43:45 ZHJD-VM6 kernel: [ 4199.007423]  ffff8805f792ba70 0000000000000046 ffff8805f792ba60 ffff8805d7cf5000
Apr 27 17:43:45 ZHJD-VM6 kernel: [ 4199.007429]  ffff8805f792bfd8 ffff8805f792bfd8 ffff8805f792bfd8 0000000000013780
Apr 27 17:43:45 ZHJD-VM6 kernel: [ 4199.007434]  ffff8805f74696f0 ffff8805f7905bc0 ffff8805f2a25200 7fffffffffffffff
Apr 27 17:43:45 ZHJD-VM6 kernel: [ 4199.007439] Call Trace:
Apr 27 17:43:45 ZHJD-VM6 kernel: [ 4199.007447]  [<ffffffff8165a55f>] schedule+0x3f/0x60
Apr 27 17:43:45 ZHJD-VM6 kernel: [ 4199.007451]  [<ffffffff8165aba5>] schedule_timeout+0x2a5/0x320
Apr 27 17:43:45 ZHJD-VM6 kernel: [ 4199.007457]  [<ffffffffa036e020>] ? o2dlm_lock_ast_wrapper+0x20/0x20 [ocfs2_stack_o2cb]
Apr 27 17:43:45 ZHJD-VM6 kernel: [ 4199.007463]  [<ffffffff8158346a>] ? do_tcp_sendpages+0x5ba/0x6e0
Apr 27 17:43:45 ZHJD-VM6 kernel: [ 4199.007466]  [<ffffffff8165a39f>] wait_for_common+0xdf/0x180
Apr 27 17:43:45 ZHJD-VM6 kernel: [ 4199.007473]  [<ffffffff8105f990>] ? try_to_wake_up+0x200/0x200
Apr 27 17:43:45 ZHJD-VM6 kernel: [ 4199.007476]  [<ffffffff8165a51d>] wait_for_completion+0x1d/0x20
Apr 27 17:43:45 ZHJD-VM6 kernel: [ 4199.007503]  [<ffffffffa053beb3>] __ocfs2_cluster_lock.isra.34+0x1f3/0x810 [ocfs2]
Apr 27 17:43:45 ZHJD-VM6 kernel: [ 4199.007527]  [<ffffffffa05543e0>] ? ocfs2_queue_orphan_scan+0x270/0x270 [ocfs2]
Apr 27 17:43:45 ZHJD-VM6 kernel: [ 4199.007547]  [<ffffffffa053d0a9>] ocfs2_orphan_scan_lock+0x99/0xf0 [ocfs2]
Apr 27 17:43:45 ZHJD-VM6 kernel: [ 4199.007570]  [<ffffffffa05543e0>] ? ocfs2_queue_orphan_scan+0x270/0x270 [ocfs2]
Apr 27 17:43:45 ZHJD-VM6 kernel: [ 4199.007593]  [<ffffffffa05541c5>] ocfs2_queue_orphan_scan+0x55/0x270 [ocfs2]
Apr 27 17:43:45 ZHJD-VM6 kernel: [ 4199.007615]  [<ffffffffa05543e0>] ? ocfs2_queue_orphan_scan+0x270/0x270 [ocfs2]
Apr 27 17:43:45 ZHJD-VM6 kernel: [ 4199.007638]  [<ffffffffa055441a>] ocfs2_orphan_scan_work+0x3a/0xb0 [ocfs2]
Apr 27 17:43:45 ZHJD-VM6 kernel: [ 4199.007644]  [<ffffffff81084e2a>] process_one_work+0x11a/0x480
Apr 27 17:43:45 ZHJD-VM6 kernel: [ 4199.007648]  [<ffffffff81085bd4>] worker_thread+0x164/0x370
Apr 27 17:43:45 ZHJD-VM6 kernel: [ 4199.007652]  [<ffffffff81085a70>] ? manage_workers.isra.29+0x130/0x130
Apr 27 17:43:45 ZHJD-VM6 kernel: [ 4199.007657]  [<ffffffff8108a42c>] kthread+0x8c/0xa0
Apr 27 17:43:45 ZHJD-VM6 kernel: [ 4199.007662]  [<ffffffff81666bf4>] kernel_thread_helper+0x4/0x10
Apr 27 17:43:45 ZHJD-VM6 kernel: [ 4199.007666]  [<ffffffff8108a3a0>] ? flush_kthread_worker+0xa0/0xa0
Apr 27 17:43:45 ZHJD-VM6 kernel: [ 4199.007670]  [<ffffffff81666bf0>] ? gs_change+0x13/0x13
Apr 27 17:43:47 ZHJD-VM6 kernel: [ 4201.925965] o2net: Connection to node 2013-SRV10 (num 3) at 185.200.1.15:7100 has been idle for 30.109 secs, shutting it down.
Apr 27 17:43:47 ZHJD-VM6 kernel: [ 4201.926000] o2net: No longer connected to node 2013-SRV10 (num 3) at 185.200.1.15:7100
Apr 27 17:43:50 ZHJD-VM6 kernel: [ 4204.140932] o2net: Connection to node 2013-SRV06 (num 1) at 185.200.1.13:7100 shutdown, state 7
Apr 27 17:43:53 ZHJD-VM6 kernel: [ 4207.139488] o2net: Connection to node 2013-SRV06 (num 1) at 185.200.1.13:7100 shutdown, state 7
Apr 27 17:43:56 ZHJD-VM6 kernel: [ 4210.138028] o2net: Connection to node 2013-SRV06 (num 1) at 185.200.1.13:7100 shutdown, state 7
Apr 27 17:43:59 ZHJD-VM6 kernel: [ 4213.136565] o2net: Connection to node 2013-SRV06 (num 1) at 185.200.1.13:7100 shutdown, state 7
Apr 27 17:43:59 ZHJD-VM6 kernel: [ 4213.928171] o2net: Connection to node 2013-SRV09 (num 2) at 185.200.1.14:7100 shutdown, state 7
Apr 27 17:44:01 ZHJD-VM6 CRON[20049]: (root) CMD (   /opt/bin/ocfs2_iscsi_conf_chg_timer.sh)
Apr 27 17:44:01 ZHJD-VM6 CRON[20050]: (root) CMD (   /opt/bin/libvirtd_check.sh)
Apr 27 17:44:02 ZHJD-VM6 kernel: [ 4216.127082] o2net: No connection established with node 1 after 30.0 seconds, giving up.
Apr 27 17:44:02 ZHJD-VM6 kernel: [ 4216.135116] o2net: Connection to node 2013-SRV06 (num 1) at 185.200.1.13:7100 shutdown, state 7
Apr 27 17:44:02 ZHJD-VM6 kernel: [ 4216.926731] o2net: Connection to node 2013-SRV09 (num 2) at 185.200.1.14:7100 shutdown, state 7
Apr 27 17:44:05 ZHJD-VM6 kernel: [ 4219.925271] o2net: Connection to node 2013-SRV09 (num 2) at 185.200.1.14:7100 shutdown, state 7
Apr 27 17:44:05 ZHJD-VM6 kernel: [ 4219.941252] o2net: Connection to node 2013-SRV10 (num 3) at 185.200.1.15:7100 shutdown, state 7
Apr 27 17:44:07 ZHJD-VM6 kernel: [ 4221.101584] o2cb: o2dlm has evicted node 1 from domain AB92EF420A5A475ABD6C139B0C7DDD1C
Apr 27 17:44:07 ZHJD-VM6 kernel: [ 4221.101891] o2cb: o2dlm has evicted node 1 from domain AE16636E1B83497A88D6A50178172ECA
Apr 27 17:44:08 ZHJD-VM6 kernel: [ 4222.400030] o2dlm: Begin recovery on domain AE16636E1B83497A88D6A50178172ECA for node 1
Apr 27 17:44:08 ZHJD-VM6 kernel: [ 4222.923814] o2net: Connection to node 2013-SRV09 (num 2) at 185.200.1.14:7100 shutdown, state 7
Apr 27 17:44:08 ZHJD-VM6 kernel: [ 4222.939801] o2net: Connection to node 2013-SRV10 (num 3) at 185.200.1.15:7100 shutdown, state 7
Apr 27 17:44:09 ZHJD-VM6 kernel: [ 4222.959757] o2dlm: Begin recovery on domain AB92EF420A5A475ABD6C139B0C7DDD1C for node 1
Apr 27 17:44:11 ZHJD-VM6 kernel: [ 4225.922350] o2net: Connection to node 2013-SRV09 (num 2) at 185.200.1.14:7100 shutdown, state 7
Apr 27 17:44:11 ZHJD-VM6 kernel: [ 4225.938346] o2net: Connection to node 2013-SRV10 (num 3) at 185.200.1.15:7100 shutdown, state 7
Apr 27 17:44:12 ZHJD-VM6 kernel: [ 4225.978308] o2net: No connection established with node 2 after 30.0 seconds, giving up.
Apr 27 17:44:12 ZHJD-VM6 kernel: [ 4225.978415] (dlm_reco_thread,13736,2):dlm_do_master_requery:1656 ERROR: Error -107 when sending message 514 (key 0xe00bcbbe) to node 2
Apr 27 17:44:12 ZHJD-VM6 kernel: [ 4225.978427] (dlm_reco_thread,14227,1):dlm_do_master_requery:1656 ERROR: Error -107 when sending message 514 (key 0x77c0b1d1) to node 2
Apr 27 17:44:12 ZHJD-VM6 kernel: [ 4225.978434] (dlm_reco_thread,14227,1):dlm_pre_master_reco_lockres:2151 ERROR: status = -107
Apr 27 17:44:12 ZHJD-VM6 kernel: [ 4225.978441] (dlm_reco_thread,13736,2):dlm_pre_master_reco_lockres:2151 ERROR: status = -107
Apr 27 17:44:14 ZHJD-VM6 kernel: [ 4228.920883] o2net: Connection to node 2013-SRV09 (num 2) at 185.200.1.14:7100 shutdown, state 7
Apr 27 17:44:14 ZHJD-VM6 kernel: [ 4228.936893] o2net: Connection to node 2013-SRV10 (num 3) at 185.200.1.15:7100 shutdown, state 7
Apr 27 17:44:15 ZHJD-VM6 kernel: [ 4229.113560] o2cb: o2dlm has evicted node 2 from domain AB92EF420A5A475ABD6C139B0C7DDD1C
Apr 27 17:44:15 ZHJD-VM6 kernel: [ 4229.113700] o2cb: o2dlm has evicted node 2 from domain AE16636E1B83497A88D6A50178172ECA
Apr 27 17:44:17 ZHJD-VM6 kernel: [ 4231.935407] o2net: Connection to node 2013-SRV10 (num 3) at 185.200.1.15:7100 shutdown, state 7
Apr 27 17:44:18 ZHJD-VM6 kernel: [ 4231.991421] o2net: No connection established with node 3 after 30.0 seconds, giving up.
Apr 27 17:44:18 ZHJD-VM6 kernel: [ 4231.991522] (dlm_reco_thread,13736,2):dlm_do_master_requery:1656 ERROR: Error -107 when sending message 514 (key 0xe00bcbbe) to node 3
Apr 27 17:44:18 ZHJD-VM6 kernel: [ 4231.991534] (dlm_reco_thread,14227,3):dlm_do_master_requery:1656 ERROR: Error -107 when sending message 514 (key 0x77c0b1d1) to node 3
Apr 27 17:44:18 ZHJD-VM6 kernel: [ 4231.991541] (dlm_reco_thread,13736,2):dlm_pre_master_reco_lockres:2151 ERROR: status = -107
Apr 27 17:44:18 ZHJD-VM6 kernel: [ 4231.991549] (dlm_reco_thread,14227,3):dlm_pre_master_reco_lockres:2151 ERROR: status = -107
Apr 27 17:44:18 ZHJD-VM6 kernel: [ 4231.992415] (dlm_reco_thread,13736,2):dlm_do_master_request:1332 ERROR: link to 2 went down!
Apr 27 17:44:18 ZHJD-VM6 kernel: [ 4231.992425] (dlm_reco_thread,13736,2):dlm_get_lock_resource:917 ERROR: status = -107
Apr 27 17:44:18 ZHJD-VM6 kernel: [ 4231.992433] (dlm_reco_thread,13736,2):dlm_do_master_request:1332 ERROR: link to 3 went down!
Apr 27 17:44:18 ZHJD-VM6 kernel: [ 4231.992440] (dlm_reco_thread,13736,2):dlm_get_lock_resource:917 ERROR: status = -107
Apr 27 17:44:18 ZHJD-VM6 kernel: [ 4231.992472] (dlm_reco_thread,14227,3):dlm_do_master_request:1332 ERROR: link to 2 went down!
Apr 27 17:44:18 ZHJD-VM6 kernel: [ 4231.992482] (dlm_reco_thread,14227,3):dlm_get_lock_resource:917 ERROR: status = -107
Apr 27 17:44:18 ZHJD-VM6 kernel: [ 4231.992489] (dlm_reco_thread,14227,3):dlm_do_master_request:1332 ERROR: link to 3 went down!
Apr 27 17:44:18 ZHJD-VM6 kernel: [ 4231.992497] (dlm_reco_thread,14227,3):dlm_get_lock_resource:917 ERROR: status = -107
Apr 27 17:44:18 ZHJD-VM6 kernel: [ 4231.993204] (dlm_reco_thread,13736,2):dlm_restart_lock_mastery:1221 ERROR: node down! 2
Apr 27 17:44:18 ZHJD-VM6 kernel: [ 4231.993214] (dlm_reco_thread,13736,2):dlm_wait_for_lock_mastery:1038 ERROR: status = -11
Apr 27 17:44:18 ZHJD-VM6 kernel: [ 4231.993223] (dlm_reco_thread,13736,2):dlm_do_master_requery:1656 ERROR: Error -107 when sending message 514 (key 0xe00bcbbe) to node 3
Apr 27 17:44:18 ZHJD-VM6 kernel: [ 4231.993232] (dlm_reco_thread,13736,2):dlm_pre_master_reco_lockres:2151 ERROR: status = -107
Apr 27 17:44:18 ZHJD-VM6 kernel: [ 4231.993258] (dlm_reco_thread,14227,3):dlm_restart_lock_mastery:1221 ERROR: node down! 2
Apr 27 17:44:18 ZHJD-VM6 kernel: [ 4231.993273] (dlm_reco_thread,14227,3):dlm_wait_for_lock_mastery:1038 ERROR: status = -11
Apr 27 17:44:18 ZHJD-VM6 kernel: [ 4231.993283] (dlm_reco_thread,14227,3):dlm_do_master_requery:1656 ERROR: Error -107 when sending message 514 (key 0x77c0b1d1) to node 3
Apr 27 17:44:18 ZHJD-VM6 kernel: [ 4231.993291] (dlm_reco_thread,14227,3):dlm_pre_master_reco_lockres:2151 ERROR: status = -107
Apr 27 17:44:18 ZHJD-VM6 kernel: [ 4231.993876] (dlm_reco_thread,13736,2):dlm_do_master_request:1332 ERROR: link to 3 went down!
Apr 27 17:44:18 ZHJD-VM6 kernel: [ 4231.993885] (dlm_reco_thread,13736,2):dlm_get_lock_resource:917 ERROR: status = -107
Apr 27 17:44:18 ZHJD-VM6 kernel: [ 4231.993901] (dlm_reco_thread,14227,3):dlm_do_master_request:1332 ERROR: link to 3 went down!
Apr 27 17:44:18 ZHJD-VM6 kernel: [ 4231.993910] (dlm_reco_thread,14227,3):dlm_get_lock_resource:917 ERROR: status = -107
Apr 27 17:44:20 ZHJD-VM6 kernel: [ 4234.933965] o2net: Connection to node 2013-SRV10 (num 3) at 185.200.1.15:7100 shutdown, state 7
Apr 27 17:44:22 ZHJD-VM6 kernel: [ 4236.214606] o2cb: o2dlm has evicted node 1 from domain AB92EF420A5A475ABD6C139B0C7DDD1C
Apr 27 17:44:22 ZHJD-VM6 kernel: [ 4236.214613] (kworker/u:2,19288,6):dlm_begin_reco_handler:2728 AB92EF420A5A475ABD6C139B0C7DDD1C: dead_node previously set to 1, node 4 changing it to 1
Apr 27 17:44:22 ZHJD-VM6 kernel: [ 4236.317544] o2dlm: Node 4 (he) is the Recovery Master for the dead node 1 in domain AB92EF420A5A475ABD6C139B0C7DDD1C
Apr 27 17:44:22 ZHJD-VM6 kernel: [ 4236.317548] o2dlm: End recovery on domain AB92EF420A5A475ABD6C139B0C7DDD1C
Apr 27 17:44:22 ZHJD-VM6 kernel: [ 4236.739293] o2cb: o2dlm has evicted node 1 from domain AE16636E1B83497A88D6A50178172ECA
Apr 27 17:44:22 ZHJD-VM6 kernel: [ 4236.739300] (kworker/u:2,19288,6):dlm_begin_reco_handler:2728 AE16636E1B83497A88D6A50178172ECA: dead_node previously set to 1, node 4 changing it to 1
Apr 27 17:44:22 ZHJD-VM6 kernel: [ 4236.760743] o2cb: o2dlm has evicted node 2 from domain AE16636E1B83497A88D6A50178172ECA
Apr 27 17:44:22 ZHJD-VM6 kernel: [ 4236.790445] o2cb: o2dlm has evicted node 3 from domain AE16636E1B83497A88D6A50178172ECA
Apr 27 17:44:22 ZHJD-VM6 kernel: [ 4236.833635] o2dlm: Node 255 (he) is the Recovery Master for the dead node 255 in domain AE16636E1B83497A88D6A50178172ECA
Apr 27 17:44:22 ZHJD-VM6 kernel: [ 4236.833639] o2dlm: End recovery on domain AE16636E1B83497A88D6A50178172ECA
Apr 27 17:44:23 ZHJD-VM6 kernel: [ 4237.125780] o2cb: o2dlm has evicted node 3 from domain AB92EF420A5A475ABD6C139B0C7DDD1C
Apr 27 17:44:27 ZHJD-VM6 kernel: [ 4241.314898] o2dlm: Begin recovery on domain AB92EF420A5A475ABD6C139B0C7DDD1C for node 2
Apr 27 17:44:27 ZHJD-VM6 kernel: [ 4241.319727] o2cb: o2dlm has evicted node 2 from domain AB92EF420A5A475ABD6C139B0C7DDD1C
Apr 27 17:44:27 ZHJD-VM6 kernel: [ 4241.319734] (kworker/u:3,14232,0):dlm_begin_reco_handler:2728 AB92EF420A5A475ABD6C139B0C7DDD1C: dead_node previously set to 2, node 5 changing it to 2
Apr 27 17:44:27 ZHJD-VM6 kernel: [ 4241.319793] o2dlm: Node 5 (he) is the Recovery Master for the dead node 2 in domain AB92EF420A5A475ABD6C139B0C7DDD1C
Apr 27 17:44:27 ZHJD-VM6 kernel: [ 4241.319797] o2dlm: End recovery on domain AB92EF420A5A475ABD6C139B0C7DDD1C
Apr 27 17:44:27 ZHJD-VM6 kernel: [ 4241.544905] o2cb: o2dlm has evicted node 2 from domain AB92EF420A5A475ABD6C139B0C7DDD1C
Apr 27 17:44:27 ZHJD-VM6 kernel: [ 4241.544912] (kworker/u:3,14232,0):dlm_begin_reco_handler:2728 AB92EF420A5A475ABD6C139B0C7DDD1C: dead_node previously set to 2, node 7 changing it to 2
Apr 27 17:44:32 ZHJD-VM6 kernel: [ 4246.316421] o2dlm: Begin recovery on domain AB92EF420A5A475ABD6C139B0C7DDD1C for node 2
Apr 27 17:44:32 ZHJD-VM6 kernel: [ 4246.316426] o2dlm: Node 7 (he) is the Recovery Master for the dead node 2 in domain AB92EF420A5A475ABD6C139B0C7DDD1C
Apr 27 17:44:32 ZHJD-VM6 kernel: [ 4246.316429] o2dlm: End recovery on domain AB92EF420A5A475ABD6C139B0C7DDD1C
Apr 27 17:44:37 ZHJD-VM6 kernel: [ 4251.313976] o2dlm: Begin recovery on domain AB92EF420A5A475ABD6C139B0C7DDD1C for node 2
Apr 27 17:44:37 ZHJD-VM6 kernel: [ 4251.313980] o2dlm: Node 7 (he) is the Recovery Master for the dead node 2 in domain AB92EF420A5A475ABD6C139B0C7DDD1C
Apr 27 17:44:37 ZHJD-VM6 kernel: [ 4251.313982] o2dlm: End recovery on domain AB92EF420A5A475ABD6C139B0C7DDD1C
Apr 27 17:44:42 ZHJD-VM6 kernel: [ 4256.311550] o2dlm: Begin recovery on domain AB92EF420A5A475ABD6C139B0C7DDD1C for node 2
Apr 27 17:44:42 ZHJD-VM6 kernel: [ 4256.311555] o2dlm: Node 7 (he) is the Recovery Master for the dead node 2 in domain AB92EF420A5A475ABD6C139B0C7DDD1C
Apr 27 17:44:42 ZHJD-VM6 kernel: [ 4256.311558] o2dlm: End recovery on domain AB92EF420A5A475ABD6C139B0C7DDD1C
Apr 27 17:44:47 ZHJD-VM6 kernel: [ 4261.309120] o2dlm: Begin recovery on domain AB92EF420A5A475ABD6C139B0C7DDD1C for node 2
Apr 27 17:44:47 ZHJD-VM6 kernel: [ 4261.309125] o2dlm: Node 7 (he) is the Recovery Master for the dead node 2 in domain AB92EF420A5A475ABD6C139B0C7DDD1C
Apr 27 17:44:47 ZHJD-VM6 kernel: [ 4261.309128] o2dlm: End recovery on domain AB92EF420A5A475ABD6C139B0C7DDD1C
Apr 27 17:44:52 ZHJD-VM6 kernel: [ 4266.306711] o2dlm: Begin recovery on domain AB92EF420A5A475ABD6C139B0C7DDD1C for node 2
Apr 27 17:44:52 ZHJD-VM6 kernel: [ 4266.306715] o2dlm: Node 7 (he) is the Recovery Master for the dead node 2 in domain AB92EF420A5A475ABD6C139B0C7DDD1C
Apr 27 17:44:52 ZHJD-VM6 kernel: [ 4266.306719] o2dlm: End recovery on domain AB92EF420A5A475ABD6C139B0C7DDD1C
Apr 28 10:49:45 ZHJD-VM6 kernel: imklog 5.8.6, log source = /proc/kmsg started.
Apr 28 10:49:45 ZHJD-VM6 rsyslogd: [origin software="rsyslogd" swVersion="5.8.6" x-pid="1313" x-info="http://www.rsyslog.com"] start
Apr 28 10:49:45 ZHJD-VM6 rsyslogd: rsyslogd's groupid changed to 103
Apr 28 10:49:45 ZHJD-VM6 rsyslogd: rsyslogd's userid changed to 101
Apr 28 10:49:45 ZHJD-VM6 rsyslogd-2039: Could not open output pipe '/dev/xconsole' [try http://www.rsyslog.com/e/2039 ]
Apr 28 10:49:45 ZHJD-VM6 kernel: [    0.000000] Initializing cgroup subsys cpuset
Apr 28 10:49:45 ZHJD-VM6 kernel: [    0.000000] Initializing cgroup subsys cpu
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
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20130428/85bd674e/attachment-0001.html 
