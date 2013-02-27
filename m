From: Srinivas Eeda <srinivas.eeda@oracle.com>
Date: Tue, 26 Feb 2013 20:07:20 -0800
Subject: [Ocfs2-devel] ocfs2 bug reports, any advices? thanks
In-Reply-To: <71604351584F6A4EBAE558C676F37CA417BC85F5@H3CMLB02-EX.srv.huawei-3com.com>
References: <71604351584F6A4EBAE558C676F37CA417BC85F5@H3CMLB02-EX.srv.huawei-3com.com>
Message-ID: <512D8678.8060205@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This looks similar to what the following patch is trying to address.

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=3278bb748d2437eb1464765f36429e5d6aa91c38

On 02/26/2013 07:43 PM, Guozhonghua wrote:
>
> Hi,
>
> I setup two nodes, 192.168.20.20, and 192.168.20.21,
>
> The os is Ubuntu1204 with Kernel version 3.0:
>
> root at Server21:~# uname -a
>
> Linux Server21 3.2.0-23-generic #36-Ubuntu SMP Tue Apr 10 20:39:51 UTC 
> 2012 x86_64 x86_64 x86_64 GNU/Linux
>
> Server20 reboot for the disconnection with iSCSI SAN, so Server20 
> recovery resource locks for Server21.
>
> Server20:
>
> Feb 27 09:29:31 Server20 kernel: [424826.197532] o2net: No longer 
> connected to node Server21 (num 2) at 192.168.20.21:7100
>
> Feb 27 09:29:31 Server20 kernel: [424826.197633] o2cb: o2dlm has 
> evicted node 2 from domain C5FDF4DB054B49B587DF8D4848443259
>
> Feb 27 09:29:35 Server20 kernel: [424830.079130] o2dlm: Begin recovery 
> on domain C5FDF4DB054B49B587DF8D4848443259 for node 2
>
> Feb 27 09:29:35 Server20 kernel: [424830.079156] o2dlm: Node 1 (me) is 
> the Recovery Master for the dead node 2 in domain 
> C5FDF4DB054B49B587DF8D4848443259
>
> Feb 27 09:29:35 Server20 kernel: [424830.079262] o2dlm: End recovery 
> on domain C5FDF4DB054B49B587DF8D4848443259
>
> But the Server21 can't remount the same domain disk on the storage 
> again, as syslog below:
>
> Feb 27 09:50:59 Server21 kernel: [ 1199.751256] "echo 0 > 
> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>
> Feb 27 09:50:59 Server21 kernel: [ 1199.751262] mount.ocfs2     D 
> ffffffff81806240     0 12194  12193 0x00000000
>
> Feb 27 09:50:59 Server21 kernel: [ 1199.751268]  ffff8807e581b908 
> 0000000000000086 ffff8807e581b8c8 ffffffffa04c056b
>
> Feb 27 09:50:59 Server21 kernel: [ 1199.751276]  ffff8807e581bfd8 
> ffff8807e581bfd8 ffff8807e581bfd8 0000000000013780
>
> Feb 27 09:50:59 Server21 kernel: [ 1199.751281]  ffff880405cbc4d0 
> ffff8807e50996f0 ffff8807e581b908 7fffffffffffffff
>
> Feb 27 09:50:59 Server21 kernel: [ 1199.751288] Call Trace:
>
> Feb 27 09:50:59 Server21 kernel: [ 1199.751303]  [<ffffffffa04c056b>] 
> ? dlm_kick_thread+0x7b/0x90 [ocfs2_dlm]
>
> Feb 27 09:50:59 Server21 kernel: [ 1199.751311]  [<ffffffff8165a55f>] 
> schedule+0x3f/0x60
>
> Feb 27 09:50:59 Server21 kernel: [ 1199.751315]  [<ffffffff8165aba5>] 
> schedule_timeout+0x2a5/0x320
>
> Feb 27 09:50:59 Server21 kernel: [ 1199.751319]  [<ffffffff8165a39f>] 
> wait_for_common+0xdf/0x180
>
> Feb 27 09:50:59 Server21 kernel: [ 1199.751327]  [<ffffffff8105f990>] 
> ? try_to_wake_up+0x200/0x200
>
> Feb 27 09:50:59 Server21 kernel: [ 1199.751331]  [<ffffffff8165a51d>] 
> wait_for_completion+0x1d/0x20
>
> Feb 27 09:50:59 Server21 kernel: [ 1199.751357]  [<ffffffffa05d7eb3>] 
> __ocfs2_cluster_lock.isra.34+0x1f3/0x810 [ocfs2]
>
> Feb 27 09:50:59 Server21 kernel: [ 1199.751364]  [<ffffffff813162a1>] 
> ? vsnprintf+0x461/0x600
>
> Feb 27 09:50:59 Server21 kernel: [ 1199.751369]  [<ffffffffa017c3bf>] 
> ? o2cb_cluster_connect+0x1af/0x2e0 [ocfs2_stack_o2cb]
>
> Feb 27 09:50:59 Server21 kernel: [ 1199.751374]  [<ffffffff813164e4>] 
> ? snprintf+0x34/0x40
>
> Feb 27 09:50:59 Server21 kernel: [ 1199.751395]  [<ffffffffa05d8d7b>] 
> ocfs2_super_lock+0xab/0x320 [ocfs2]
>
> Feb 27 09:50:59 Server21 kernel: [ 1199.751422]  [<ffffffffa0635a5b>] 
> ocfs2_fill_super+0x154b/0x2540 [ocfs2]
>
> Feb 27 09:50:59 Server21 kernel: [ 1199.751426]  [<ffffffff81316059>] 
> ? vsnprintf+0x219/0x600
>
> Feb 27 09:50:59 Server21 kernel: [ 1199.751433]  [<ffffffff8117aa46>] 
> mount_bdev+0x1c6/0x210
>
> Feb 27 09:50:59 Server21 kernel: [ 1199.751460]  [<ffffffffa0634510>] 
> ? ocfs2_initialize_super.isra.208+0x1440/0x1440 [ocfs2]
>
> Feb 27 09:50:59 Server21 kernel: [ 1199.751487]  [<ffffffffa0624615>] 
> ocfs2_mount+0x15/0x20 [ocfs2]
>
> Feb 27 09:50:59 Server21 kernel: [ 1199.751491]  [<ffffffff8117b5d3>] 
> mount_fs+0x43/0x1b0
>
> Feb 27 09:50:59 Server21 kernel: [ 1199.751497]  [<ffffffff81195e1a>] 
> vfs_kern_mount+0x6a/0xc0
>
> Feb 27 09:50:59 Server21 kernel: [ 1199.751502]  [<ffffffff81197324>] 
> do_kern_mount+0x54/0x110
>
> Feb 27 09:50:59 Server21 kernel: [ 1199.751506]  [<ffffffff81198e74>] 
> do_mount+0x1a4/0x260
>
> Feb 27 09:50:59 Server21 kernel: [ 1199.751511]  [<ffffffff81199350>] 
> sys_mount+0x90/0xe0
>
> Feb 27 09:50:59 Server21 kernel: [ 1199.751516]  [<ffffffff81664a82>] 
> system_call_fastpath+0x16/0x1b
>
> Feb 27 09:51:01 Server21 CRON[14164]: (root) CMD (   
> /opt/bin/tomcat_check.sh)
>
> Feb 27 09:51:01 Server21 CRON[14165]: (root) CMD (   
> /opt/bin/libvirtd_check.sh)
>
> Feb 27 09:51:01 Server21 CRON[14166]: (root) CMD ( 
> /opt/bin/ocfs2_iscsi_conf_chg_timer.sh)
>
> Feb 27 09:52:01 Server21 CRON[14788]: (root) CMD (   
> /opt/bin/tomcat_check.sh)
>
> Feb 27 09:52:01 Server21 CRON[14789]: (root) CMD (   
> /opt/bin/libvirtd_check.sh)
>
> Feb 27 09:52:01 Server21 CRON[14790]: (root) CMD ( 
> /opt/bin/ocfs2_iscsi_conf_chg_timer.sh)
>
> Feb 27 09:52:01 Server21 CRON[14791]: (root) CMD (   
> /opt/bin/ha_check_resource.sh)
>
> Feb 27 09:52:59 Server21 kernel: [ 1319.442926] INFO: task 
> mount.ocfs2:12194 blocked for more than 120 seconds.
>
> Feb 27 09:52:59 Server21 kernel: [ 1319.442933] "echo 0 > 
> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>
> Feb 27 09:52:59 Server21 kernel: [ 1319.442939] mount.ocfs2     D 
> ffffffff81806240     0 12194  12193 0x00000000
>
> Feb 27 09:52:59 Server21 kernel: [ 1319.442945]  ffff8807e581b908 
> 0000000000000086 ffff8807e581b8c8 ffffffffa04c056b
>
> Feb 27 09:52:59 Server21 kernel: [ 1319.442952]  ffff8807e581bfd8 
> ffff8807e581bfd8 ffff8807e581bfd8 0000000000013780
>
> Feb 27 09:52:59 Server21 kernel: [ 1319.442958]  ffff880405cbc4d0 
> ffff8807e50996f0 ffff8807e581b908 7fffffffffffffff
>
> Feb 27 09:52:59 Server21 kernel: [ 1319.442964] Call Trace:
>
> Feb 27 09:52:59 Server21 kernel: [ 1319.442980]  [<ffffffffa04c056b>] 
> ? dlm_kick_thread+0x7b/0x90 [ocfs2_dlm]
>
> Feb 27 09:52:59 Server21 kernel: [ 1319.442988]  [<ffffffff8165a55f>] 
> schedule+0x3f/0x60
>
> Feb 27 09:52:59 Server21 kernel: [ 1319.442992]  [<ffffffff8165aba5>] 
> schedule_timeout+0x2a5/0x320
>
> Feb 27 09:52:59 Server21 kernel: [ 1319.442996]  [<ffffffff8165a39f>] 
> wait_for_common+0xdf/0x180
>
> Feb 27 09:52:59 Server21 kernel: [ 1319.443004]  [<ffffffff8105f990>] 
> ? try_to_wake_up+0x200/0x200
>
> Feb 27 09:52:59 Server21 kernel: [ 1319.443007]  [<ffffffff8165a51d>] 
> wait_for_completion+0x1d/0x20
>
> Feb 27 09:52:59 Server21 kernel: [ 1319.443034]  [<ffffffffa05d7eb3>] 
> __ocfs2_cluster_lock.isra.34+0x1f3/0x810 [ocfs2]
>
> Feb 27 09:52:59 Server21 kernel: [ 1319.443041]  [<ffffffff813162a1>] 
> ? vsnprintf+0x461/0x600
>
> Feb 27 09:52:59 Server21 kernel: [ 1319.443046]  [<ffffffffa017c3bf>] 
> ? o2cb_cluster_connect+0x1af/0x2e0 [ocfs2_stack_o2cb]
>
> Feb 27 09:52:59 Server21 kernel: [ 1319.443051]  [<ffffffff813164e4>] 
> ? snprintf+0x34/0x40
>
> Feb 27 09:52:59 Server21 kernel: [ 1319.443072]  [<ffffffffa05d8d7b>] 
> ocfs2_super_lock+0xab/0x320 [ocfs2]
>
> Feb 27 09:52:59 Server21 kernel: [ 1319.443099]  [<ffffffffa0635a5b>] 
> ocfs2_fill_super+0x154b/0x2540 [ocfs2]
>
> Feb 27 09:52:59 Server21 kernel: [ 1319.443103]  [<ffffffff81316059>] 
> ? vsnprintf+0x219/0x600
>
> Feb 27 09:52:59 Server21 kernel: [ 1319.443110]  [<ffffffff8117aa46>] 
> mount_bdev+0x1c6/0x210
>
> Feb 27 09:52:59 Server21 kernel: [ 1319.443137]  [<ffffffffa0634510>] 
> ? ocfs2_initialize_super.isra.208+0x1440/0x1440 [ocfs2]
>
> Feb 27 09:52:59 Server21 kernel: [ 1319.443163]  [<ffffffffa0624615>] 
> ocfs2_mount+0x15/0x20 [ocfs2]
>
> Feb 27 09:52:59 Server21 kernel: [ 1319.443168]  [<ffffffff8117b5d3>] 
> mount_fs+0x43/0x1b0
>
> Feb 27 09:52:59 Server21 kernel: [ 1319.443174]  [<ffffffff81195e1a>] 
> vfs_kern_mount+0x6a/0xc0
>
> Feb 27 09:52:59 Server21 kernel: [ 1319.443179]  [<ffffffff81197324>] 
> do_kern_mount+0x54/0x110
>
> Feb 27 09:52:59 Server21 kernel: [ 1319.443183]  [<ffffffff81198e74>] 
> do_mount+0x1a4/0x260
>
> Feb 27 09:52:59 Server21 kernel: [ 1319.443187]  [<ffffffff81199350>] 
> sys_mount+0x90/0xe0
>
> Feb 27 09:52:59 Server21 kernel: [ 1319.443193]  [<ffffffff81664a82>] 
> system_call_fastpath+0x16/0x1b
>
> Feb 27 09:53:01 Server21 CRON[15276]: (root) CMD (   
> /opt/bin/tomcat_check.sh)
>
> Feb 27 09:53:01 Server21 CRON[15277]: (root) CMD (   
> /opt/bin/libvirtd_check.sh)
>
> Feb 27 09:53:01 Server21 CRON[15278]: (root) CMD ( 
> /opt/bin/ocfs2_iscsi_conf_chg_timer.sh)
>
> Feb 27 09:53:16 Server21 kernel: [ 1335.561166] qla2xxx 
> [0000:06:00.1]-5009:2: LIP occurred (f7f7).
>
> Feb 27 09:53:21 Server21 kernel: [ 1340.535613] qla2xxx 
> [0000:06:00.1]-500c:2: LIP reset occurred (f7ef).
>
> Feb 27 09:54:01 Server21 CRON[15723]: (root) CMD (   
> /opt/bin/tomcat_check.sh)
>
> Feb 27 09:54:01 Server21 CRON[15725]: (root) CMD (   
> /opt/bin/ha_check_resource.sh)
>
> Feb 27 09:54:01 Server21 CRON[15724]: (root) CMD ( 
> /opt/bin/ocfs2_iscsi_conf_chg_timer.sh)
>
> Feb 27 09:54:01 Server21 CRON[15726]: (root) CMD (   
> /opt/bin/libvirtd_check.sh)
>
> Feb 27 09:54:59 Server21 kernel: [ 1439.134659] INFO: task 
> mount.ocfs2:12194 blocked for more than 120 seconds.
>
> Feb 27 09:54:59 Server21 kernel: [ 1439.134665] "echo 0 > 
> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>
> Feb 27 09:54:59 Server21 kernel: [ 1439.134673] mount.ocfs2     D 
> ffffffff81806240     0 12194  12193 0x00000000
>
> Feb 27 09:54:59 Server21 kernel: [ 1439.134679]  ffff8807e581b908 
> 0000000000000086 ffff8807e581b8c8 ffffffffa04c056b
>
> Feb 27 09:54:59 Server21 kernel: [ 1439.134686]  ffff8807e581bfd8 
> ffff8807e581bfd8 ffff8807e581bfd8 0000000000013780
>
> Feb 27 09:54:59 Server21 kernel: [ 1439.134692]  ffff880405cbc4d0 
> ffff8807e50996f0 ffff8807e581b908 7fffffffffffffff
>
> Feb 27 09:54:59 Server21 kernel: [ 1439.134698] Call Trace:
>
> Feb 27 09:54:59 Server21 kernel: [ 1439.134714]  [<ffffffffa04c056b>] 
> ? dlm_kick_thread+0x7b/0x90 [ocfs2_dlm]
>
> Feb 27 09:54:59 Server21 kernel: [ 1439.134722]  [<ffffffff8165a55f>] 
> schedule+0x3f/0x60
>
> Feb 27 09:54:59 Server21 kernel: [ 1439.134726]  [<ffffffff8165aba5>] 
> schedule_timeout+0x2a5/0x320
>
> Feb 27 09:54:59 Server21 kernel: [ 1439.134730]  [<ffffffff8165a39f>] 
> wait_for_common+0xdf/0x180
>
> Feb 27 09:54:59 Server21 kernel: [ 1439.134737]  [<ffffffff8105f990>] 
> ? try_to_wake_up+0x200/0x200
>
> Feb 27 09:54:59 Server21 kernel: [ 1439.134741]  [<ffffffff8165a51d>] 
> wait_for_completion+0x1d/0x20
>
> Feb 27 09:54:59 Server21 kernel: [ 1439.134768]  [<ffffffffa05d7eb3>] 
> __ocfs2_cluster_lock.isra.34+0x1f3/0x810 [ocfs2]
>
> Feb 27 09:54:59 Server21 kernel: [ 1439.134775]  [<ffffffff813162a1>] 
> ? vsnprintf+0x461/0x600
>
> Feb 27 09:54:59 Server21 kernel: [ 1439.134781]  [<ffffffffa017c3bf>] 
> ? o2cb_cluster_connect+0x1af/0x2e0 [ocfs2_stack_o2cb]
>
> Feb 27 09:54:59 Server21 kernel: [ 1439.134785]  [<ffffffff813164e4>] 
> ? snprintf+0x34/0x40
>
> Feb 27 09:54:59 Server21 kernel: [ 1439.134806]  [<ffffffffa05d8d7b>] 
> ocfs2_super_lock+0xab/0x320 [ocfs2]
>
> Feb 27 09:54:59 Server21 kernel: [ 1439.134833]  [<ffffffffa0635a5b>] 
> ocfs2_fill_super+0x154b/0x2540 [ocfs2]
>
> Feb 27 09:54:59 Server21 kernel: [ 1439.134837]  [<ffffffff81316059>] 
> ? vsnprintf+0x219/0x600
>
> Feb 27 09:54:59 Server21 kernel: [ 1439.134844]  [<ffffffff8117aa46>] 
> mount_bdev+0x1c6/0x210
>
> Feb 27 09:54:59 Server21 kernel: [ 1439.134871]  [<ffffffffa0634510>] 
> ? ocfs2_initialize_super.isra.208+0x1440/0x1440 [ocfs2]
>
> Feb 27 09:54:59 Server21 kernel: [ 1439.134898]  [<ffffffffa0624615>] 
> ocfs2_mount+0x15/0x20 [ocfs2]
>
> Feb 27 09:54:59 Server21 kernel: [ 1439.134902]  [<ffffffff8117b5d3>] 
> mount_fs+0x43/0x1b0
>
> Feb 27 09:54:59 Server21 kernel: [ 1439.134909]  [<ffffffff81195e1a>] 
> vfs_kern_mount+0x6a/0xc0
>
> Feb 27 09:54:59 Server21 kernel: [ 1439.134913]  [<ffffffff81197324>] 
> do_kern_mount+0x54/0x110
>
> Feb 27 09:54:59 Server21 kernel: [ 1439.134918]  [<ffffffff81198e74>] 
> do_mount+0x1a4/0x260
>
> Feb 27 09:54:59 Server21 kernel: [ 1439.134922]  [<ffffffff81199350>] 
> sys_mount+0x90/0xe0
>
> Feb 27 09:54:59 Server21 kernel: [ 1439.134927]  [<ffffffff81664a82>] 
> system_call_fastpath+0x16/0x1b
>
> -------------------------------------------------------------------------------------------------------------------------------------
> ??????????????????????????,?????????????
> ?????????????????????(??????????????????
> ???)?????????????????,??????????????????
> ??!
> This e-mail and its attachments contain confidential information from 
> H3C, which is
> intended only for the person or entity whose address is listed above. 
> Any use of the
> information contained herein in any way (including, but not limited 
> to, total or partial
> disclosure, reproduction, or dissemination) by persons other than the 
> intended
> recipient(s) is prohibited. If you receive this e-mail in error, 
> please notify the sender
> by phone or email immediately and delete it!
>
>
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel

-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20130226/be7e9ee4/attachment-0001.html 
