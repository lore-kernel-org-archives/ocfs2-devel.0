From: Guozhonghua <guozhonghua@h3c.com>
Date: Thu, 21 Aug 2014 01:07:24 +0000
Subject: [Ocfs2-devel] Cluster blocked,
 so as to reboot all nodes to avoid it. Is there any patchs for it?
 Thanks.
Message-ID: <71604351584F6A4EBAE558C676F37CA42EC6360C@H3CMLB14-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi, everyone

And we have the blocked cluster several times, and the log is always, we have to reboot all the node of the cluster to avoid it.
Is there any patch that had fix this bug?
[<ffffffff817539a5>] schedule_timeout+0x1e5/0x250
[<ffffffff81755a77>] wait_for_completion+0xa7/0x160
[<ffffffff8109c9b0>] ? try_to_wake_up+0x2c0/0x2c0
[<ffffffffa0564063>] __ocfs2_cluster_lock.isra.30+0x1f3/0x820 [ocfs2]


As we test with a lot of node in one cluster, may be ten or twenty nodes, the cluster is always blocked, and the log is below,
The kernel version is 3.13.6.


Aug 20 10:05:43 server211 kernel: [82025.281828]       Tainted: GF       W  O 3.13.6 #5
Aug 20 10:05:43 server211 kernel: [82025.281830] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Aug 20 10:05:43 server211 kernel: [82025.281833] mount.ocfs2     D 0000000000000000     0 57890  57889 0x00000000
Aug 20 10:05:43 server211 kernel: [82025.281838]  ffff880427e03888 0000000000000002 ffff880427e03828 ffffffff8101cba3
Aug 20 10:05:43 server211 kernel: [82025.281842]  ffff8804270a1810 0000000000014440 ffff880427e03fd8 0000000000014440
Aug 20 10:05:43 server211 kernel: [82025.281845]  ffff88042958e040 ffff8804270a1810 ffff8804270a1810 ffff880427e03a60
Aug 20 10:05:43 server211 kernel: [82025.281849] Call Trace:
Aug 20 10:05:43 server211 kernel: [82025.281862]  [<ffffffff8101cba3>] ? native_sched_clock+0x13/0x80
Aug 20 10:05:43 server211 kernel: [82025.281867]  [<ffffffff817547d9>] schedule+0x29/0x70
Aug 20 10:05:43 server211 kernel: [82025.281870]  [<ffffffff817539a5>] schedule_timeout+0x1e5/0x250
Aug 20 10:05:43 server211 kernel: [82025.281874]  [<ffffffff81755a77>] wait_for_completion+0xa7/0x160
Aug 20 10:05:43 server211 kernel: [82025.281879]  [<ffffffff8109c9b0>] ? try_to_wake_up+0x2c0/0x2c0
Aug 20 10:05:43 server211 kernel: [82025.281907]  [<ffffffffa0564063>] __ocfs2_cluster_lock.isra.30+0x1f3/0x820 [ocfs2]
Aug 20 10:05:43 server211 kernel: [82025.281910]  [<ffffffff8175501c>] ? out_of_line_wait_on_bit+0x7c/0x90
Aug 20 10:05:43 server211 kernel: [82025.281922]  [<ffffffffa0562493>] ? ocfs2_inode_lock_res_init+0x73/0x160 [ocfs2]
Aug 20 10:05:43 server211 kernel: [82025.281934]  [<ffffffffa05658ca>] ocfs2_inode_lock_full_nested+0x13a/0xb80 [ocfs2]
Aug 20 10:05:43 server211 kernel: [82025.281958]  [<ffffffffa0576571>] ? ocfs2_iget+0x121/0x7d0 [ocfs2]
Aug 20 10:05:43 server211 kernel: [82025.281971]  [<ffffffffa057a9f2>] ocfs2_journal_init+0x92/0x480 [ocfs2]
Aug 20 10:05:43 server211 kernel: [82025.281986]  [<ffffffffa05bc3f1>] ocfs2_fill_super+0x15a1/0x25a0 [ocfs2]
Aug 20 10:05:43 server211 kernel: [82025.281992]  [<ffffffff81394e49>] ? vsnprintf+0x309/0x600
Aug 20 10:05:43 server211 kernel: [82025.281998]  [<ffffffff811c4c99>] mount_bdev+0x1b9/0x200
Aug 20 10:05:43 server211 kernel: [82025.282011]  [<ffffffffa05bae50>] ? ocfs2_initialize_super.isra.208+0x1470/0x1470 [ocfs2]
Aug 20 10:05:43 server211 kernel: [82025.282022]  [<ffffffffa05adbe5>] ocfs2_mount+0x15/0x20 [ocfs2]
Aug 20 10:05:43 server211 kernel: [82025.282025]  [<ffffffff811c58c3>] mount_fs+0x43/0x1b0
Aug 20 10:05:43 server211 kernel: [82025.282029]  [<ffffffff811e0ab6>] vfs_kern_mount+0x76/0x130
Aug 20 10:05:43 server211 kernel: [82025.282032]  [<ffffffff811e2d47>] do_mount+0x237/0xa90
Aug 20 10:05:43 server211 kernel: [82025.282037]  [<ffffffff8115800e>] ? __get_free_pages+0xe/0x40
Aug 20 10:05:43 server211 kernel: [82025.282040]  [<ffffffff811e297a>] ? copy_mount_options+0x3a/0x180
Aug 20 10:05:43 server211 kernel: [82025.282043]  [<ffffffff811e3920>] SyS_mount+0x90/0xe0
Aug 20 10:05:43 server211 kernel: [82025.282048]  [<ffffffff81760fbf>] tracesys+0xe1/0xe6
Aug 20 10:06:01 server211 CRON[803]: (root) CMD (   /opt/bin/tomcat_check.sh)



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
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20140821/e0cb6dc9/attachment.html 
