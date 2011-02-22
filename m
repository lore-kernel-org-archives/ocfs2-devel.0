From: Kui Zhang <kuizhang@gmail.com>
Date: Tue, 22 Feb 2011 11:36:13 -0800
Subject: [Ocfs2-devel] ocfs2 1.6 kernel blocking error
Message-ID: <AANLkTinzmQx+ohUEZi1iHRH0uu2bHL_QXVwxTZAFOaDy@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hello

New to ocfs2, I hope I got all the info to post here.

2x opteron 246 2 Ghz
16GB RAM

Hardware raid
Driver Version = 2.26.02.014
Model = 9550SX-8LP
Available Memory = 112MB
Firmware Version = FE9X 3.08.00.029

Debian squeeze fresh install

packages from sid
linux-image-2.6.37-1-amd64
ocfs2-tools 1.6.3-1

mkfs options used

 -T mail
--fs-feature-level max-features

fstab
/dev/sda4	/media/ocfs2_testvol	ocfs2	rw,barrier=0,data=writeback,errors=remount-ro,noatime	0
      0

file system is mounted on 1 node only.

test data 2.5-3 million variable size files range from few k to few
hundred mb, in various sub directories.

initial copy from remote box. no problems

load test:

rsync copy1 copy2
cp -a copy1 copy3

waiting period

rm -rf copy2
copy copy2 copy4

io rate dropped as expected.

few hours later. I started to get these kernel errors. Did I miss
anything or is it a bug?


[24120.588044] INFO: task kswapd1:52 blocked for more than 120 seconds.
[24120.588268] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[24120.588505] kswapd1       D ffff8801f6651440     0    52      2 0x00000000
[24120.588511]  ffff8801f6651440 0000000000000046 ffff8803f599b168
ffff8801f62b9440
[24120.588517]  00000000000136c0 ffff8801f665ffd8 00000000000136c0
00000000000136c0
[24120.588521]  ffff8801f6651718 ffff8801f6651720 ffff8801f6651440
00000000000136c0
[24120.588526] Call Trace:
[24120.588534]  [<ffffffff810395c6>] ? __wake_up+0x35/0x46
[24120.588556]  [<ffffffffa0531c86>] ? ocfs2_clear_inode+0x2df/0xa18 [ocfs2]
[24120.588563]  [<ffffffff81060491>] ? autoremove_wake_function+0x0/0x2a
[24120.588575]  [<ffffffffa0533968>] ? ocfs2_evict_inode+0x15a9/0x15de [ocfs2]
[24120.588580]  [<ffffffff810bdd4c>] ? pagevec_lookup+0x15/0x1c
[24120.588583]  [<ffffffff810be946>] ? invalidate_mapping_pages+0xc4/0xe4
[24120.588589]  [<ffffffff811054af>] ? evict+0x1a/0x89
[24120.588593]  [<ffffffff8110554e>] ? dispose_list+0x30/0xb9
[24120.588597]  [<ffffffff81105c89>] ? shrink_icache_memory+0x243/0x285
[24120.588602]  [<ffffffff810c1899>] ? shrink_slab+0xd3/0x145
[24120.588606]  [<ffffffff810c2ffa>] ? balance_pgdat+0x2ad/0x4c2
[24120.588610]  [<ffffffff810c34b2>] ? kswapd+0x2a3/0x2e3
[24120.588614]  [<ffffffff81060491>] ? autoremove_wake_function+0x0/0x2a
[24120.588618]  [<ffffffff810c320f>] ? kswapd+0x0/0x2e3
[24120.588621]  [<ffffffff810c320f>] ? kswapd+0x0/0x2e3
[24120.588625]  [<ffffffff8106003f>] ? kthread+0x7a/0x82
[24120.588630]  [<ffffffff8100a824>] ? kernel_thread_helper+0x4/0x10
[24120.588634]  [<ffffffff8105ffc5>] ? kthread+0x0/0x82
[24120.588637]  [<ffffffff8100a820>] ? kernel_thread_helper+0x0/0x10
[24120.588649] INFO: task rsync:1584 blocked for more than 120 seconds.
[24120.588798] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[24120.589035] rsync         D ffff8803f58ebcc0     0  1584   1583 0x00000000
[24120.589040]  ffff8803f58ebcc0 0000000000000082 0000000000000000
ffff8803f7854a40
[24120.589045]  00000000000136c0 ffff8802ea90ffd8 00000000000136c0
00000000000136c0
[24120.589049]  ffff8803f58ebf98 ffff8803f58ebfa0 ffff8803f58ebcc0
00000000000136c0
[24120.589054] Call Trace:
[24120.589058]  [<ffffffff810636a6>] ? hrtimer_try_to_cancel+0x3b/0x45
[24120.589064]  [<ffffffff8131e964>] ? rwsem_down_failed_common+0xda/0x10e
[24120.589070]  [<ffffffff811a0d64>] ? call_rwsem_down_read_failed+0x14/0x30
[24120.589074]  [<ffffffff8131e2b3>] ? down_read+0x17/0x19
[24120.589086]  [<ffffffffa053a9c3>] ? ocfs2_start_trans+0xa0/0x18e [ocfs2]
[24120.589095]  [<ffffffffa051181e>] ?
ocfs2_write_begin_nolock+0xed2/0x160a [ocfs2]
[24120.589106]  [<ffffffffa0531149>] ?
ocfs2_validate_inode_block+0x0/0x1c3 [ocfs2]
[24120.589118]  [<ffffffffa0530cc1>] ?
ocfs2_read_inode_block_full+0x37/0x4d [ocfs2]
[24120.589130]  [<ffffffffa053a4cf>] ? ocfs2_journal_access_di+0x0/0x14 [ocfs2]
[24120.589140]  [<ffffffffa052005e>] ?
ocfs2_should_refresh_lock_res+0xa3/0x1b6 [ocfs2]
[24120.589150]  [<ffffffffa0512092>] ? ocfs2_write_begin+0x13c/0x206 [ocfs2]
[24120.589155]  [<ffffffff810b50b7>] ? generic_file_buffered_write+0x105/0x24c
[24120.589166]  [<ffffffffa0526c26>] ? ocfs2_rw_lock+0x188/0x265 [ocfs2]
[24120.589177]  [<ffffffffa052b363>] ? ocfs2_file_aio_write+0x576/0x75b [ocfs2]
[24120.589182]  [<ffffffff812598ad>] ? __sock_recvmsg_nosec+0x29/0x69
[24120.589187]  [<ffffffff810f33b7>] ? do_sync_write+0xb1/0xea
[24120.589191]  [<ffffffff8111ce4f>] ? fsnotify+0x78/0x278
[24120.589195]  [<ffffffff8103bbe3>] ? pick_next_task_fair+0xea/0xf9
[24120.589199]  [<ffffffff8131d68b>] ? schedule+0x58b/0x5cb
[24120.589204]  [<ffffffff8115b5de>] ? security_file_permission+0x18/0x2d
[24120.589207]  [<ffffffff810f3905>] ? vfs_write+0xa4/0x100
[24120.589211]  [<ffffffff810f3a14>] ? sys_write+0x45/0x6b
[24120.589214]  [<ffffffff81009a12>] ? system_call_fastpath+0x16/0x1b
[24120.589218] INFO: task cp:1906 blocked for more than 120 seconds.
[24120.589363] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[24120.589601] cp            D ffff8803f58e9440     0  1906   1739 0x00000000
[24120.589605]  ffff8803f58e9440 0000000000000082 0000000000000000
ffffffff8160b020
[24120.589610]  00000000000136c0 ffff88006e53bfd8 00000000000136c0
00000000000136c0
[24120.589614]  ffff8803f58e9718 ffff8803f58e9720 ffff8803f58e9440
00000000000136c0
[24120.589618] Call Trace:
[24120.589622]  [<ffffffff8131deb5>] ? __mutex_lock_common+0x127/0x193
[24120.589634]  [<ffffffffa056242b>] ?
ocfs2_set_buffer_uptodate+0x15/0x5d7 [ocfs2]
[24120.589638]  [<ffffffff8131dfed>] ? mutex_lock+0x1a/0x33
[24120.589648]  [<ffffffffa053c9a8>] ?
ocfs2_reserve_local_alloc_bits+0x10f/0xe80 [ocfs2]
[24120.589659]  [<ffffffffa055917c>] ?
ocfs2_reserve_clusters_with_limit+0x7b/0x2ab [ocfs2]
[24120.589670]  [<ffffffffa053b47e>] ?
ocfs2_alloc_should_use_local+0x1c/0xba [ocfs2]
[24120.589681]  [<ffffffffa0559227>] ?
ocfs2_reserve_clusters_with_limit+0x126/0x2ab [ocfs2]
[24120.589692]  [<ffffffffa055b21d>] ? ocfs2_lock_allocators+0x190/0x237 [ocfs2]
[24120.589701]  [<ffffffffa0511665>] ?
ocfs2_write_begin_nolock+0xd19/0x160a [ocfs2]
[24120.589712]  [<ffffffffa0531149>] ?
ocfs2_validate_inode_block+0x0/0x1c3 [ocfs2]
[24120.589723]  [<ffffffffa0530cc1>] ?
ocfs2_read_inode_block_full+0x37/0x4d [ocfs2]
[24120.589735]  [<ffffffffa053a4cf>] ? ocfs2_journal_access_di+0x0/0x14 [ocfs2]
[24120.589745]  [<ffffffffa052005e>] ?
ocfs2_should_refresh_lock_res+0xa3/0x1b6 [ocfs2]
[24120.589755]  [<ffffffffa0512092>] ? ocfs2_write_begin+0x13c/0x206 [ocfs2]
[24120.589759]  [<ffffffff810b50b7>] ? generic_file_buffered_write+0x105/0x24c
[24120.589770]  [<ffffffffa0526c26>] ? ocfs2_rw_lock+0x188/0x265 [ocfs2]
[24120.589781]  [<ffffffffa052b363>] ? ocfs2_file_aio_write+0x576/0x75b [ocfs2]
[24120.589792]  [<ffffffffa05316ac>] ?
ocfs2_inode_revalidate+0x160/0x254 [ocfs2]
[24120.589796]  [<ffffffff810f33b7>] ? do_sync_write+0xb1/0xea
[24120.589806]  [<ffffffffa051e866>] ? ocfs2_inode_unlock+0x138/0x1a7 [ocfs2]
[24120.589811]  [<ffffffff8115b5de>] ? security_file_permission+0x18/0x2d
[24120.589814]  [<ffffffff810f3905>] ? vfs_write+0xa4/0x100
[24120.589818]  [<ffffffff810f3bef>] ? sys_read+0x4a/0x6b
[24120.589821]  [<ffffffff810f3a14>] ? sys_write+0x45/0x6b
[24120.589824]  [<ffffffff81009a12>] ? system_call_fastpath+0x16/0x1b
[24120.589829] INFO: task kworker/1:0:1965 blocked for more than 120 seconds.
[24120.589983] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[24120.590221] kworker/1:0   D ffff8803f5a28d80     0  1965      2 0x00000000
[24120.590225]  ffff8803f5a28d80 0000000000000046 ffff880300000000
ffff8803f7854a40
[24120.590230]  00000000000136c0 ffff88029fd23fd8 00000000000136c0
00000000000136c0
[24120.590234]  ffff8803f5a29058 ffff8803f5a29060 ffff8803f5a28d80
00000000000136c0
[24120.590238] Call Trace:
[24120.590242]  [<ffffffff8131e964>] ? rwsem_down_failed_common+0xda/0x10e
[24120.590253]  [<ffffffffa0525f26>] ?
ocfs2_inode_lock_full_nested+0x9c9/0xb99 [ocfs2]
[24120.590258]  [<ffffffff811a0d64>] ? call_rwsem_down_read_failed+0x14/0x30
[24120.590262]  [<ffffffff8131e2b3>] ? down_read+0x17/0x19
[24120.590273]  [<ffffffffa053a9c3>] ? ocfs2_start_trans+0xa0/0x18e [ocfs2]
[24120.590283]  [<ffffffffa05674c8>] ? ocfs2_lock_global_qf+0xa3/0xba [ocfs2]
[24120.590293]  [<ffffffffa0568739>] ?
ocfs2_sync_dquot_helper+0xe5/0x31e [ocfs2]
[24120.590303]  [<ffffffffa0568654>] ? ocfs2_sync_dquot_helper+0x0/0x31e [ocfs2]
[24120.590309]  [<ffffffff8113476c>] ? dquot_scan_active+0x7f/0xec
[24120.590319]  [<ffffffffa0567356>] ? qsync_work_fn+0x0/0x42 [ocfs2]
[24120.590328]  [<ffffffffa056737a>] ? qsync_work_fn+0x24/0x42 [ocfs2]
[24120.590332]  [<ffffffff8105b75c>] ? process_one_work+0x1d1/0x2ee
[24120.590337]  [<ffffffff8105d181>] ? worker_thread+0x12d/0x247
[24120.590340]  [<ffffffff8105d054>] ? worker_thread+0x0/0x247
[24120.590344]  [<ffffffff8105d054>] ? worker_thread+0x0/0x247
[24120.590348]  [<ffffffff8106003f>] ? kthread+0x7a/0x82
[24120.590351]  [<ffffffff8100a824>] ? kernel_thread_helper+0x4/0x10
[24120.590356]  [<ffffffff8105ffc5>] ? kthread+0x0/0x82
[24120.590359]  [<ffffffff8100a820>] ? kernel_thread_helper+0x0/0x10
[28200.588100] INFO: task kswapd0:51 blocked for more than 120 seconds.
[28200.588252] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[28200.588490] kswapd0       D ffff8801f6650d80     0    51      2 0x00000000
[28200.588495]  ffff8801f6650d80 0000000000000046 ffff8803f599b168
ffff8801f62bc380
[28200.588501]  00000000000136c0 ffff8801f665dfd8 00000000000136c0
00000000000136c0
[28200.588505]  ffff8801f6651058 ffff8801f6651060 ffff8801f6650d80
00000000000136c0
[28200.588510] Call Trace:
[28200.588518]  [<ffffffff810395c6>] ? __wake_up+0x35/0x46
[28200.588538]  [<ffffffffa0531c86>] ? ocfs2_clear_inode+0x2df/0xa18 [ocfs2]
[28200.588545]  [<ffffffff81060491>] ? autoremove_wake_function+0x0/0x2a
[28200.588556]  [<ffffffffa0533968>] ? ocfs2_evict_inode+0x15a9/0x15de [ocfs2]
[28200.588561]  [<ffffffff810bdd4c>] ? pagevec_lookup+0x15/0x1c
[28200.588565]  [<ffffffff810be946>] ? invalidate_mapping_pages+0xc4/0xe4
[28200.588570]  [<ffffffff810ea3db>] ? add_partial+0x12/0x54
[28200.588574]  [<ffffffff810ebef8>] ? __slab_free+0x1e/0x106
[28200.588579]  [<ffffffff811054af>] ? evict+0x1a/0x89
[28200.588583]  [<ffffffff8110554e>] ? dispose_list+0x30/0xb9
[28200.588587]  [<ffffffff81105c89>] ? shrink_icache_memory+0x243/0x285
[28200.588591]  [<ffffffff810c1899>] ? shrink_slab+0xd3/0x145
[28200.588595]  [<ffffffff810c2ffa>] ? balance_pgdat+0x2ad/0x4c2
[28200.588600]  [<ffffffff810c34b2>] ? kswapd+0x2a3/0x2e3
[28200.588604]  [<ffffffff81060491>] ? autoremove_wake_function+0x0/0x2a
[28200.588608]  [<ffffffff810c320f>] ? kswapd+0x0/0x2e3
[28200.588611]  [<ffffffff810c320f>] ? kswapd+0x0/0x2e3
[28200.588615]  [<ffffffff8106003f>] ? kthread+0x7a/0x82
[28200.588619]  [<ffffffff8100a824>] ? kernel_thread_helper+0x4/0x10
[28200.588624]  [<ffffffff8105ffc5>] ? kthread+0x0/0x82
[28200.588627]  [<ffffffff8100a820>] ? kernel_thread_helper+0x0/0x10
[28200.588639] INFO: task rsync:1584 blocked for more than 120 seconds.
[28200.588788] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[28200.589025] rsync         D ffff8803ffc136c0     0  1584   1583 0x00000000
[28200.589030]  ffff8803f58ebcc0 0000000000000082 ffffffffa0531149
ffff8803f58e9b00
[28200.589034]  00000000000136c0 ffff8802ea90ffd8 00000000000136c0
00000000000136c0
[28200.589039]  ffff8803f58ebf98 ffff8803f58ebfa0 ffff8803f58ebcc0
00000000000136c0
[28200.589043] Call Trace:
[28200.589054]  [<ffffffffa0531149>] ?
ocfs2_validate_inode_block+0x0/0x1c3 [ocfs2]
[28200.589066]  [<ffffffffa0530cc1>] ?
ocfs2_read_inode_block_full+0x37/0x4d [ocfs2]
[28200.589072]  [<ffffffff8131deb5>] ? __mutex_lock_common+0x127/0x193
[28200.589076]  [<ffffffff8131dfed>] ? mutex_lock+0x1a/0x33
[28200.589087]  [<ffffffffa053c9a8>] ?
ocfs2_reserve_local_alloc_bits+0x10f/0xe80 [ocfs2]
[28200.589098]  [<ffffffffa055917c>] ?
ocfs2_reserve_clusters_with_limit+0x7b/0x2ab [ocfs2]
[28200.589109]  [<ffffffffa053b47e>] ?
ocfs2_alloc_should_use_local+0x1c/0xba [ocfs2]
[28200.589120]  [<ffffffffa0559227>] ?
ocfs2_reserve_clusters_with_limit+0x126/0x2ab [ocfs2]
[28200.589131]  [<ffffffffa0542b89>] ? ocfs2_mknod+0x668/0xfa7 [ocfs2]
[28200.589142]  [<ffffffffa054365e>] ? ocfs2_create+0x98/0xfe [ocfs2]
[28200.589146]  [<ffffffff810fc0fa>] ? inode_permission+0x82/0x9e
[28200.589150]  [<ffffffff810fc491>] ? vfs_create+0x66/0x88
[28200.589153]  [<ffffffff810fb9e5>] ? d_alloc_and_lookup+0x4a/0x67
[28200.589157]  [<ffffffff810fce44>] ? do_last+0x268/0x53a
[28200.589160]  [<ffffffff810fea89>] ? do_filp_open+0x1e2/0x538
[28200.589164]  [<ffffffff810f33b7>] ? do_sync_write+0xb1/0xea
[28200.589169]  [<ffffffff810f1f6c>] ? do_sys_open+0x56/0xde
[28200.589172]  [<ffffffff81009a12>] ? system_call_fastpath+0x16/0x1b
[28200.589176] INFO: task cp:1906 blocked for more than 120 seconds.
[28200.589322] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[28200.589559] cp            D ffff8803f58e9440     0  1906   1739 0x00000000
[28200.589564]  ffff8803f58e9440 0000000000000082 0000000000000000
ffff8803f7854a40
[28200.589568]  00000000000136c0 ffff88006e53bfd8 00000000000136c0
00000000000136c0
[28200.589573]  ffff8803f58e9718 ffff8803f58e9720 ffff8803f58e9440
00000000000136c0
[28200.589577] Call Trace:
[28200.589581]  [<ffffffff8131e964>] ? rwsem_down_failed_common+0xda/0x10e
[28200.589587]  [<ffffffff811a0d64>] ? call_rwsem_down_read_failed+0x14/0x30
[28200.589591]  [<ffffffff8131e2b3>] ? down_read+0x17/0x19
[28200.589602]  [<ffffffffa053a9c3>] ? ocfs2_start_trans+0xa0/0x18e [ocfs2]
[28200.589612]  [<ffffffffa051181e>] ?
ocfs2_write_begin_nolock+0xed2/0x160a [ocfs2]
[28200.589623]  [<ffffffffa0531149>] ?
ocfs2_validate_inode_block+0x0/0x1c3 [ocfs2]
[28200.589634]  [<ffffffffa0530cc1>] ?
ocfs2_read_inode_block_full+0x37/0x4d [ocfs2]
[28200.589646]  [<ffffffffa053a4cf>] ? ocfs2_journal_access_di+0x0/0x14 [ocfs2]
[28200.589650]  [<ffffffff810eb33e>] ? virt_to_head_page+0x9/0x2d
[28200.589659]  [<ffffffffa0512092>] ? ocfs2_write_begin+0x13c/0x206 [ocfs2]
[28200.589664]  [<ffffffff810b50b7>] ? generic_file_buffered_write+0x105/0x24c
[28200.589676]  [<ffffffffa052b363>] ? ocfs2_file_aio_write+0x576/0x75b [ocfs2]
[28200.589681]  [<ffffffff8131ef0e>] ? common_interrupt+0xe/0x13
[28200.589684]  [<ffffffff810f33b7>] ? do_sync_write+0xb1/0xea
[28200.589689]  [<ffffffff8115b5de>] ? security_file_permission+0x18/0x2d
[28200.589693]  [<ffffffff810f3905>] ? vfs_write+0xa4/0x100
[28200.589696]  [<ffffffff810f3a14>] ? sys_write+0x45/0x6b
[28200.589700]  [<ffffffff81009a12>] ? system_call_fastpath+0x16/0x1b
[28200.589704] INFO: task kworker/1:0:1991 blocked for more than 120 seconds.
[28200.589859] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[28200.590096] kworker/1:0   D ffff8803f5a28d80     0  1991      2 0x00000000
[28200.590101]  ffff8803f5a28d80 0000000000000046 ffff880300000000
ffff8803f7854a40
[28200.590105]  00000000000136c0 ffff8801a8855fd8 00000000000136c0
00000000000136c0
[28200.590109]  ffff8803f5a29058 ffff8803f5a29060 ffff8803f5a28d80
00000000000136c0
[28200.590114] Call Trace:
[28200.590118]  [<ffffffff8131e964>] ? rwsem_down_failed_common+0xda/0x10e
[28200.590129]  [<ffffffffa0525f26>] ?
ocfs2_inode_lock_full_nested+0x9c9/0xb99 [ocfs2]
[28200.590133]  [<ffffffff811a0d64>] ? call_rwsem_down_read_failed+0x14/0x30
[28200.590137]  [<ffffffff8131e2b3>] ? down_read+0x17/0x19
[28200.590148]  [<ffffffffa053a9c3>] ? ocfs2_start_trans+0xa0/0x18e [ocfs2]
[28200.590158]  [<ffffffffa05674c8>] ? ocfs2_lock_global_qf+0xa3/0xba [ocfs2]
[28200.590168]  [<ffffffffa0568739>] ?
ocfs2_sync_dquot_helper+0xe5/0x31e [ocfs2]
[28200.590173]  [<ffffffff81053a1e>] ? __mod_timer+0x145/0x157
[28200.590183]  [<ffffffffa0568654>] ? ocfs2_sync_dquot_helper+0x0/0x31e [ocfs2]
[28200.590188]  [<ffffffff8113476c>] ? dquot_scan_active+0x7f/0xec
[28200.590198]  [<ffffffffa0567356>] ? qsync_work_fn+0x0/0x42 [ocfs2]
[28200.590208]  [<ffffffffa056737a>] ? qsync_work_fn+0x24/0x42 [ocfs2]
[28200.590212]  [<ffffffff8105b75c>] ? process_one_work+0x1d1/0x2ee
[28200.590216]  [<ffffffff8105d181>] ? worker_thread+0x12d/0x247
[28200.590220]  [<ffffffff8105d054>] ? worker_thread+0x0/0x247
[28200.590223]  [<ffffffff8105d054>] ? worker_thread+0x0/0x247
[28200.590227]  [<ffffffff8106003f>] ? kthread+0x7a/0x82
[28200.590231]  [<ffffffff8100a824>] ? kernel_thread_helper+0x4/0x10
[28200.590235]  [<ffffffff8105ffc5>] ? kthread+0x0/0x82
[28200.590239]  [<ffffffff8100a820>] ? kernel_thread_helper+0x0/0x10
[29280.588090] INFO: task kswapd0:51 blocked for more than 120 seconds.
[29280.588243] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[29280.588481] kswapd0       D ffff8800f7c136c0     0    51      2 0x00000000
[29280.588486]  ffff8801f6650d80 0000000000000046 ffff8803f599b168
ffff8803f58e9440
[29280.588491]  00000000000136c0 ffff8801f665dfd8 00000000000136c0
00000000000136c0
[29280.588496]  ffff8801f6651058 ffff8801f6651060 ffff8801f6650d80
00000000000136c0
[29280.588500] Call Trace:
[29280.588509]  [<ffffffff810395c6>] ? __wake_up+0x35/0x46
[29280.588529]  [<ffffffffa0531c86>] ? ocfs2_clear_inode+0x2df/0xa18 [ocfs2]
[29280.588535]  [<ffffffff81060491>] ? autoremove_wake_function+0x0/0x2a
[29280.588547]  [<ffffffffa0533968>] ? ocfs2_evict_inode+0x15a9/0x15de [ocfs2]
[29280.588552]  [<ffffffff810bdd4c>] ? pagevec_lookup+0x15/0x1c
[29280.588556]  [<ffffffff810be946>] ? invalidate_mapping_pages+0xc4/0xe4
[29280.588560]  [<ffffffff810ea3db>] ? add_partial+0x12/0x54
[29280.588564]  [<ffffffff810ebef8>] ? __slab_free+0x1e/0x106
[29280.588569]  [<ffffffff811054af>] ? evict+0x1a/0x89
[29280.588573]  [<ffffffff8110554e>] ? dispose_list+0x30/0xb9
[29280.588577]  [<ffffffff81105c89>] ? shrink_icache_memory+0x243/0x285
[29280.588582]  [<ffffffff810c1899>] ? shrink_slab+0xd3/0x145
[29280.588586]  [<ffffffff810c2ffa>] ? balance_pgdat+0x2ad/0x4c2
[29280.588590]  [<ffffffff810c34b2>] ? kswapd+0x2a3/0x2e3
[29280.588594]  [<ffffffff81060491>] ? autoremove_wake_function+0x0/0x2a
[29280.588598]  [<ffffffff810c320f>] ? kswapd+0x0/0x2e3
[29280.588602]  [<ffffffff810c320f>] ? kswapd+0x0/0x2e3
[29280.588605]  [<ffffffff8106003f>] ? kthread+0x7a/0x82
[29280.588610]  [<ffffffff8100a824>] ? kernel_thread_helper+0x4/0x10
[29280.588614]  [<ffffffff8105ffc5>] ? kthread+0x0/0x82
[29280.588617]  [<ffffffff8100a820>] ? kernel_thread_helper+0x0/0x10
[29280.588629] INFO: task rsync:1584 blocked for more than 120 seconds.
[29280.588778] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[29280.589015] rsync         D ffff8803f58ebcc0     0  1584   1583 0x00000000
[29280.589020]  ffff8803f58ebcc0 0000000000000082 0000000000000000
ffffffff8160b020
[29280.589024]  00000000000136c0 ffff8802ea90ffd8 00000000000136c0
00000000000136c0
[29280.589029]  ffff8803f58ebf98 ffff8803f58ebfa0 ffff8803f58ebcc0
00000000000136c0
[29280.589033] Call Trace:
[29280.589039]  [<ffffffff8131e964>] ? rwsem_down_failed_common+0xda/0x10e
[29280.589044]  [<ffffffff811a0d64>] ? call_rwsem_down_read_failed+0x14/0x30
[29280.589048]  [<ffffffff8131e2b3>] ? down_read+0x17/0x19
[29280.589060]  [<ffffffffa053a9c3>] ? ocfs2_start_trans+0xa0/0x18e [ocfs2]
[29280.589070]  [<ffffffffa051181e>] ?
ocfs2_write_begin_nolock+0xed2/0x160a [ocfs2]
[29280.589081]  [<ffffffffa0531149>] ?
ocfs2_validate_inode_block+0x0/0x1c3 [ocfs2]
[29280.589092]  [<ffffffffa0530cc1>] ?
ocfs2_read_inode_block_full+0x37/0x4d [ocfs2]
[29280.589104]  [<ffffffffa053a4cf>] ? ocfs2_journal_access_di+0x0/0x14 [ocfs2]
[29280.589114]  [<ffffffffa0512092>] ? ocfs2_write_begin+0x13c/0x206 [ocfs2]
[29280.589119]  [<ffffffff810b50b7>] ? generic_file_buffered_write+0x105/0x24c
[29280.589130]  [<ffffffffa052b363>] ? ocfs2_file_aio_write+0x576/0x75b [ocfs2]
[29280.589135]  [<ffffffff812598ad>] ? __sock_recvmsg_nosec+0x29/0x69
[29280.589140]  [<ffffffff810f33b7>] ? do_sync_write+0xb1/0xea
[29280.589145]  [<ffffffff8115b5de>] ? security_file_permission+0x18/0x2d
[29280.589148]  [<ffffffff810f3905>] ? vfs_write+0xa4/0x100
[29280.589152]  [<ffffffff810f3a14>] ? sys_write+0x45/0x6b
[29280.589156]  [<ffffffff81009a12>] ? system_call_fastpath+0x16/0x1b


Thanks
KuiZ
