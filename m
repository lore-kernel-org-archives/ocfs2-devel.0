From: Larry Chen <lchen@suse.com>
Date: Sun, 2 Sep 2018 17:09:56 +0800
Subject: [Ocfs2-devel] [PATCH] fix dead lock caused by
	ocfs2_defrag_extent
In-Reply-To: <a51bc2c7-1350-5218-916b-7c1893d0e926@suse.com>
References: <20180827080121.31145-1-lchen@suse.com>
	<HK0PR06MB2561A612E5A95B60E7F8E22FD50A0@HK0PR06MB2561.apcprd06.prod.outlook.com>
	<4265c81b-26bf-fb54-e911-59773c40f788@suse.com>
	<HK0PR06MB2561632790BCD8DCD5936F47D5080@HK0PR06MB2561.apcprd06.prod.outlook.com>
	<42f7fbf5-9b7c-966e-887d-3b5ae51511e8@suse.com>
	<HK0PR06MB256185E6D7A3330541D5D3E2D5080@HK0PR06MB2561.apcprd06.prod.outlook.com>
	<a51bc2c7-1350-5218-916b-7c1893d0e926@suse.com>
Message-ID: <78a34aa0-09a5-9c0d-9154-ff646d2dacb8@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Changwei,

>>>
>>> Another way is to add an new argument for __ocfs2_flush_truncate which
>>> indicates whether global bitmap is needed to be locked.
>>
>> Sounds a feasible way :)
> 

I tried this way, but it still causes dead lock. Here is the back trace.
The root cause is that ocfs2 sometimes relies on work queue to flush 
truncate log.

The worker who process the work queue is ocfs2_truncate_log_worker,
which directly call ocfs2_flush_truncate_log. And its lock order
is truncate_log and then global bitmap, which conflicts with 
ocfs2_defrag_extent.


  #0 [ffffb6c000a03c50] __schedule at ffffffff966c47bf
  #1 [ffffb6c000a03ce0] schedule at ffffffff966c4e08
  #2 [ffffb6c000a03ce8] rwsem_down_write_failed at ffffffff966c82b3
  #3 [ffffb6c000a03d80] schedule at ffffffff966c4e08
  #4 [ffffb6c000a03d88] call_rwsem_down_write_failed at ffffffff963a6e03
  #5 [ffffb6c000a03dc8] down_write at ffffffff966c7410
		try global bit map
  #6 [ffffb6c000a03dd0] __ocfs2_flush_truncate_log at ffffffffc0749145 
[ocfs2]
  		got truncate log
  #7 [ffffb6c000a03e68] ocfs2_flush_truncate_log at ffffffffc0749afd [ocfs2]
  #8 [ffffb6c000a03e80] ocfs2_truncate_log_worker at ffffffffc0749b29 
[ocfs2]
  #9 [ffffb6c000a03e98] process_one_work at ffffffff9609e64a
#10 [ffffb6c000a03ed8] worker_thread at ffffffff9609e88b
#11 [ffffb6c000a03f10] kthread at ffffffff960a470a
#12 [ffffb6c000a03f50] ret_from_fork at ffffffff96800235



[<ffffffff963a6e03>] call_rwsem_down_write_failed+0x13/0x20
         try truncate log
	got global bm
[<ffffffffc07906f3>] ocfs2_defrag_extent+0x1d3/0x680 [ocfs2] 

[<ffffffffc07919f9>] ocfs2_move_extents+0x329/0x740 [ocfs2] 

[<ffffffffc0791f43>] ocfs2_ioctl_move_extents+0x133/0x2d0 [ocfs2] 

[<ffffffffc0773a83>] ocfs2_ioctl+0x253/0x640 [ocfs2] 

[<ffffffff96256480>] do_vfs_ioctl+0x90/0x5f0 

[<ffffffff96256a54>] SyS_ioctl+0x74/0x80 

[<ffffffff96003ae4>] do_syscall_64+0x74/0x140 

[<ffffffff9680009a>] entry_SYSCALL_64_after_hwframe+0x3d/0xa2 

[<ffffffffffffffff>] 0xffffffffffffffff
