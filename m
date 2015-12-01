From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Tue, 1 Dec 2015 10:55:19 +0800
Subject: [Ocfs2-devel] [ocfs2-test] all nodes hung when run multiple
 reflink test for v4.3
In-Reply-To: <565D7BCB020000F90002076A@relay2.provo.novell.com>
References: <565CFFE9.1040904@oracle.com>
	<565D7BCB020000F90002076A@relay2.provo.novell.com>
Message-ID: <565D0C17.8060308@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 12/01/2015 10:51 AM, Gang He wrote:
> Hello Junxiao,
> 
> Could you share which Linux distribution your test cases was ran on? the kernel looks very new.
I am using Oracle Linux 6. The kernel is built by me.

Thanks,
Junxiao.
> 
> 
> Thanks
> Gang
> 
> 
> 
> 
>>>>
>> Hi,
>>
>> When run a full ocfs2-test to kernel v4.3, all nodes hung at
>> multiple-reflink test. Does anybody ever saw this? If anybody is
>> interested in it, please let me know, i have vmcores for them.
>>
>> Node 1:
>> ======================
>> [79321.329122] INFO: task multi_reflink_t:24205 blocked for more than
>> 120 seconds.
>> [79321.335057]       Tainted: G           OE   4.3.0 #3
>> [79321.345968] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
>> disables this message.
>> [79321.357346] multi_reflink_t D ffff88007f416980     0 24205  24199
>> 0x00000080
>> [79321.363623]  ffff88003ffdb868 0000000000000086 ffffffff81a25500
>> ffff88007c6bab00
>> [79321.371393]  ffff88006a2bcc6c ffff88007af5b370 ffff88007af5b2c0
>> ffff880071885a80
>> [79321.376586]  ffff88003ffdb848 ffffffffa057a89d ffff88007af5b2c0
>> 0000000000000000
>> [79321.380613] Call Trace:
>> [79321.381942]  [<ffffffffa057a89d>] ? dlm_kick_thread+0x7d/0xa0 [ocfs2_dlm]
>> [79321.385431]  [<ffffffff816a6d1e>] schedule+0x3e/0x80
>> [79321.388026]  [<ffffffff816a9778>] schedule_timeout+0x1c8/0x220
>> [79321.391093]  [<ffffffffa058ceda>] ? dlmlock+0x9a/0x8b0 [ocfs2_dlm]
>> [79321.394258]  [<ffffffff810c5f41>] ?
>> __raw_callee_save___pv_queued_spin_unlock+0x11/0x20
>> [79321.398390]  [<ffffffff816a7cce>] wait_for_completion+0xde/0x110
>> [79321.401481]  [<ffffffff810a81b0>] ? try_to_wake_up+0x240/0x240
>> [79321.405127]  [<ffffffffa066f65d>] __ocfs2_cluster_lock+0x20d/0x720
>> [ocfs2]
>> [79321.409042]  [<ffffffff8112e8f7>] ? delayacct_end+0x67/0x80
>> [79321.412046]  [<ffffffff810c5f41>] ?
>> __raw_callee_save___pv_queued_spin_unlock+0x11/0x20
>> [79321.416241]  [<ffffffffa0674841>]
>> ocfs2_inode_lock_full_nested+0x181/0x400 [ocfs2]
>> [79321.420159]  [<ffffffffa068b24f>] ?
>> ocfs2_mv_orphaned_inode_to_new+0xbf/0x7c0 [ocfs2]
>> [79321.424161]  [<ffffffffa068b24f>]
>> ocfs2_mv_orphaned_inode_to_new+0xbf/0x7c0 [ocfs2]
>> [79321.428021]  [<ffffffffa0674153>] ? ocfs2_rw_unlock+0x123/0x160 [ocfs2]
>> [79321.431353]  [<ffffffffa069aef2>] ocfs2_reflink+0x1b2/0x480 [ocfs2]
>> [79321.434551]  [<ffffffffa069b305>] ocfs2_vfs_reflink+0x145/0x1e0 [ocfs2]
>> [79321.437988]  [<ffffffffa069b4f3>] ocfs2_reflink_ioctl+0x153/0x1b0 [ocfs2]
>> [79321.441549]  [<ffffffff810c5f41>] ?
>> __raw_callee_save___pv_queued_spin_unlock+0x11/0x20
>> [79321.445733]  [<ffffffffa06817a8>] ocfs2_ioctl+0x1f8/0x400 [ocfs2]
>> [79321.449014]  [<ffffffff812066d9>] ? do_filp_open+0x99/0xe0
>> [79321.451962]  [<ffffffff81212d62>] ? __fd_install+0x32/0xf0
>> [79321.454811]  [<ffffffff81209083>] do_vfs_ioctl+0x73/0x380
>> [79321.457601]  [<ffffffff81003596>] ? do_audit_syscall_entry+0x66/0x70
>> [79321.460838]  [<ffffffff81209422>] SyS_ioctl+0x92/0xa0
>> [79321.463489]  [<ffffffff816aa6ee>] entry_SYSCALL_64_fastpath+0x12/0x71
>> [79321.466827] INFO: task multi_reflink_t:24206 blocked for more than
>> 120 seconds.
>> [79321.470759]       Tainted: G           OE   4.3.0 #3
>> [79321.473627] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
>> disables this message.
>> [79321.478804] multi_reflink_t D ffff88007f456980     0 24206  24199
>> 0x00000080
>> [79321.483813]  ffff88007afe3bf8 0000000000000086 ffff88007c502b00
>> ffff880037b02b00
>> [79321.488384]  ffff88007afe3ca8 ffffffff81204b00 ffff88007afe3d68
>> 000000007afe3c18
>> [79321.493049]  0000000000000000 0000000000000000 ffff880037b02b00
>> ffff8800174c3042
>> [79321.497531] Call Trace:
>> [79321.498830]  [<ffffffff81204b00>] ? filename_parentat+0x100/0x170
>> [79321.501924]  [<ffffffff816a6d1e>] schedule+0x3e/0x80
>> [79321.504452]  [<ffffffff816a6f4e>] schedule_preempt_disabled+0xe/0x10
>> [79321.507794]  [<ffffffff816a889c>] __mutex_lock_slowpath+0x8c/0x100
>> [79321.511024]  [<ffffffff816a8933>] mutex_lock+0x23/0x40
>> [79321.513752]  [<ffffffff81204bed>] filename_create+0x7d/0x150
>> [79321.516747]  [<ffffffff81204d44>] user_path_create+0x34/0x50
>> [79321.519687]  [<ffffffffa069b476>] ocfs2_reflink_ioctl+0xd6/0x1b0 [ocfs2]
>> [79321.523162]  [<ffffffff810c5f41>] ?
>> __raw_callee_save___pv_queued_spin_unlock+0x11/0x20
>> [79321.527211]  [<ffffffffa06817a8>] ocfs2_ioctl+0x1f8/0x400 [ocfs2]
>> [79321.530377]  [<ffffffff812066d9>] ? do_filp_open+0x99/0xe0
>> [79321.533197]  [<ffffffff81212d62>] ? __fd_install+0x32/0xf0
>> [79321.536018]  [<ffffffff81209083>] do_vfs_ioctl+0x73/0x380
>> [79321.538928]  [<ffffffff81003596>] ? do_audit_syscall_entry+0x66/0x70
>> [79321.542737]  [<ffffffff81209422>] SyS_ioctl+0x92/0xa0
>> [79321.545395]  [<ffffffff816aa6ee>] entry_SYSCALL_64_fastpath+0x12/0x71
>>
>> =====================================================
>>
>> Node 2:
>> =====================================================
>> [79682.381129] INFO: task multi_reflink_t:11279 blocked for more than
>> 120 seconds.
>> [79682.387929]       Tainted: G           OE   4.3.0 #1
>> [79682.393352] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
>> disables this message.
>> [79682.400733] multi_reflink_t D ffff88003fc16980     0 11279  11278
>> 0x00000080
>> [79682.408206]  ffff88003ba475f8 0000000000000086 ffffffff81a25500
>> ffff88003c8d4080
>> [79682.417174]  ffff88003ba475c8 ffffffff8117992f ffffea00004b9cc0
>> ffff88003fc16980
>> [79682.422624]  7fffffffffffffff 0000000000000000 0000000000000001
>> ffffea00004b9cc0
>> [79682.427041] Call Trace:
>> [79682.428426]  [<ffffffff8117992f>] ? find_get_entry+0x2f/0xc0
>> [79682.433074]  [<ffffffff816a68fe>] schedule+0x3e/0x80
>> [79682.437402]  [<ffffffff816a9358>] schedule_timeout+0x1c8/0x220
>> [79682.444401]  [<ffffffffa067eee4>] ?
>> ocfs2_inode_cache_unlock+0x14/0x20 [ocfs2]
>> [79682.450495]  [<ffffffffa06bb1e9>] ?
>> ocfs2_metadata_cache_unlock+0x19/0x30 [ocfs2]
>> [79682.455303]  [<ffffffffa06bb399>] ? ocfs2_buffer_cached+0x99/0x170
>> [ocfs2]
>> [79682.459708]  [<ffffffffa067eee4>] ?
>> ocfs2_inode_cache_unlock+0x14/0x20 [ocfs2]
>> [79682.464037]  [<ffffffffa06bb1e9>] ?
>> ocfs2_metadata_cache_unlock+0x19/0x30 [ocfs2]
>> [79682.468109]  [<ffffffff810c5f41>] ?
>> __raw_callee_save___pv_queued_spin_unlock+0x11/0x20
>> [79682.472386]  [<ffffffff816a78ae>] wait_for_completion+0xde/0x110
>> [79682.475510]  [<ffffffff810a81b0>] ? try_to_wake_up+0x240/0x240
>> [79682.478685]  [<ffffffffa066f65d>] __ocfs2_cluster_lock+0x20d/0x720
>> [ocfs2]
>> [79682.482821]  [<ffffffff810c5f41>] ?
>> __raw_callee_save___pv_queued_spin_unlock+0x11/0x20
>> [79682.487010]  [<ffffffffa0674841>]
>> ocfs2_inode_lock_full_nested+0x181/0x400 [ocfs2]
>> [79682.490913]  [<ffffffffa06d0db3>] ? ocfs2_iop_get_acl+0x53/0x113 [ocfs2]
>> [79682.494435]  [<ffffffff81210cd2>] ? igrab+0x42/0x70
>> [79682.496977]  [<ffffffffa06d0db3>] ocfs2_iop_get_acl+0x53/0x113 [ocfs2]
>> [79682.500353]  [<ffffffff81254583>] get_acl+0x53/0x70
>> [79682.502912]  [<ffffffff81254923>] posix_acl_create+0x73/0x130
>> [79682.505869]  [<ffffffffa068f0bf>] ocfs2_mknod+0x7cf/0x1140 [ocfs2]
>> [79682.509043]  [<ffffffffa068fba2>] ocfs2_create+0x62/0x110 [ocfs2]
>> [79682.512160]  [<ffffffff8120be25>] ? __d_alloc+0x65/0x190
>> [79682.514878]  [<ffffffff81201b3e>] ? __inode_permission+0x4e/0xd0
>> [79682.517933]  [<ffffffff81202cf5>] vfs_create+0xd5/0x100
>> [79682.520641]  [<ffffffff812009ed>] ? lookup_real+0x1d/0x60
>> [79682.523421]  [<ffffffff81203a03>] lookup_open+0x173/0x1a0
>> [79682.526202]  [<ffffffff810c59c6>] ? percpu_down_read+0x16/0x70
>> [79682.529199]  [<ffffffff81205fea>] do_last+0x31a/0x830
>> [79682.531813]  [<ffffffff81201b3e>] ? __inode_permission+0x4e/0xd0
>> [79682.534926]  [<ffffffff81201bd8>] ? inode_permission+0x18/0x50
>> [79682.538376]  [<ffffffff812046b0>] ? link_path_walk+0x290/0x550
>> [79682.541724]  [<ffffffff8120657c>] path_openat+0x7c/0x140
>> [79682.544699]  [<ffffffff812066c5>] do_filp_open+0x85/0xe0
>> [79682.547536]  [<ffffffff8120190f>] ? getname_flags+0x7f/0x1f0
>> [79682.550459]  [<ffffffff811f613a>] do_sys_open+0x11a/0x220
>> [79682.553238]  [<ffffffff8100374b>] ?
>> syscall_trace_enter_phase1+0x15b/0x170
>> [79682.556745]  [<ffffffff811f627e>] SyS_open+0x1e/0x20
>> [79682.559317]  [<ffffffff816aa2ae>] entry_SYSCALL_64_fastpath+0x12/0x71
>>
>> ============================================
>>
>> Node 3:
>> ============================================
>>
>> [79682.135120] INFO: task multi_reflink_t:11263 blocked for more than
>> 120 seconds.
>> [79682.141115]       Tainted: G           OE   4.3.0 #1
>> [79682.147279] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
>> disables this message.
>> [79682.164553] multi_reflink_t D ffff88003ec16980     0 11263  11262
>> 0x00000080
>> [79682.180223]  ffff88003c2db698 0000000000000082 ffffffff81a25500
>> ffff88003b8fc080
>> [79682.190947]  ffff88003c2db668 ffffffff810c0a73 ffffffffa025de04
>> ffff88003c2f92c0
>> [79682.199118]  ffff88003b9d3f00 ffff88003c2db6b0 ffff88003c2f9370
>> 0000000000000000
>> [79682.207337] Call Trace:
>> [79682.209986]  [<ffffffff810c0a73>] ? __wake_up+0x53/0x70
>> [79682.215598]  [<ffffffffa025de04>] ?
>> o2net_send_message_vec+0x154/0x900 [ocfs2_nodemanager]
>> [79682.224433]  [<ffffffff816a68fe>] schedule+0x3e/0x80
>> [79682.229756]  [<ffffffff816a9358>] schedule_timeout+0x1c8/0x220
>> [79682.236005]  [<ffffffffa058ceda>] ? dlmlock+0x9a/0x8b0 [ocfs2_dlm]
>> [79682.242615]  [<ffffffff810a677a>] ? finish_task_switch+0x7a/0x200
>> [79682.249146]  [<ffffffff810c5f41>] ?
>> __raw_callee_save___pv_queued_spin_unlock+0x11/0x20
>> [79682.257676]  [<ffffffffa025de04>] ?
>> o2net_send_message_vec+0x154/0x900 [ocfs2_nodemanager]
>> [79682.266506]  [<ffffffff816a78ae>] wait_for_completion+0xde/0x110
>> [79682.272914]  [<ffffffff810a81b0>] ? try_to_wake_up+0x240/0x240
>> [79682.279173]  [<ffffffffa066f65d>] __ocfs2_cluster_lock+0x20d/0x720
>> [ocfs2]
>> [79682.286557]  [<ffffffff816a68fe>] ? schedule+0x3e/0x80
>> [79682.292054]  [<ffffffff810c5f41>] ?
>> __raw_callee_save___pv_queued_spin_unlock+0x11/0x20
>> [79682.300603]  [<ffffffffa0674841>]
>> ocfs2_inode_lock_full_nested+0x181/0x400 [ocfs2]
>> [79682.308835]  [<ffffffffa068eafe>] ? ocfs2_mknod+0x20e/0x1140 [ocfs2]
>> [79682.315667]  [<ffffffffa068eafe>] ocfs2_mknod+0x20e/0x1140 [ocfs2]
>> [79682.322302]  [<ffffffffa068fba2>] ocfs2_create+0x62/0x110 [ocfs2]
>> [79682.328885]  [<ffffffff8120be25>] ? __d_alloc+0x65/0x190
>> [79682.334580]  [<ffffffff81201b3e>] ? __inode_permission+0x4e/0xd0
>> [79682.340972]  [<ffffffff81202cf5>] vfs_create+0xd5/0x100
>> [79682.346595]  [<ffffffff812009ed>] ? lookup_real+0x1d/0x60
>> [79682.352381]  [<ffffffff81203a03>] lookup_open+0x173/0x1a0
>> [79682.358183]  [<ffffffff810c59c6>] ? percpu_down_read+0x16/0x70
>> [79682.364433]  [<ffffffff81205fea>] do_last+0x31a/0x830
>> [79682.369837]  [<ffffffff81201b3e>] ? __inode_permission+0x4e/0xd0
>> [79682.376324]  [<ffffffff81201bd8>] ? inode_permission+0x18/0x50
>> [79682.382610]  [<ffffffff812046b0>] ? link_path_walk+0x290/0x550
>> [79682.388855]  [<ffffffff8120657c>] path_openat+0x7c/0x140
>> [79682.394539]  [<ffffffff812066c5>] do_filp_open+0x85/0xe0
>> [79682.400226]  [<ffffffff8120190f>] ? getname_flags+0x7f/0x1f0
>> [79682.406273]  [<ffffffff811f613a>] do_sys_open+0x11a/0x220
>> [79682.412060]  [<ffffffff8100374b>] ?
>> syscall_trace_enter_phase1+0x15b/0x170
>> [79682.419401]  [<ffffffff811f627e>] SyS_open+0x1e/0x20
>> [79682.424729]  [<ffffffff816aa2ae>] entry_SYSCALL_64_fastpath+0x12/0x71
>>
>> =======================================================
>>
>> Thanks,
>> Junxiao.
>>
>> _______________________________________________
>> Ocfs2-devel mailing list
>> Ocfs2-devel at oss.oracle.com 
>> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
