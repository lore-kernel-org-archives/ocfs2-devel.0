From: Jie Liu <jeff.liu@oracle.com>
Date: Mon, 15 Oct 2012 12:44:00 +0800
Subject: [Ocfs2-devel] New OOPS from OCFS2 + QUOTA
In-Reply-To: <C5528440F17E47518726330A59DA0AC3@SERWER>
References: <506FE92F.2000609@gmail.com> <20121013161951.GC19899@infradead.org>
	<C5528440F17E47518726330A59DA0AC3@SERWER>
Message-ID: <507B9490.2070806@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Marek,

Thanks for the reporting!

On 10/15/12 01:49, Marek Kr?likowski wrote:
> Hello
> Today i get interesting oops on my OCFS2 FS - please take a look - mayby 
> that`s help resolve problem with OCFS2 + QUOTA
Looks there are some processes performing cross-path renaming at that
time, however, the demsg was truncated
due to cycle buffer was filled up maybe.

What's your kernel version?

Thanks,
-Jeff
>
>
> INFO: task courier-pop3d:25955 blocked for more than 120 seconds.
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> courier-pop3d   D ffff88107f213280     0 25955      1 0x00000000
> ffff880e274bd7d0 0000000000000082 ffffffff81a0d020 0000000000013280
> ffff88066d265fd8 0000000000013280 0000000000013280 0000000000013280
> ffff88066d264000 0000000000013280 ffff88066d265fd8 0000000000013280
> Call Trace:
> [<ffffffff814bb881>] ? __mutex_lock_slowpath+0xd1/0x140
> [<ffffffff8115287c>] ? do_path_lookup+0x2c/0xd0
> [<ffffffff814bb5e3>] ? mutex_lock+0x23/0x40
> [<ffffffff8114f485>] ? lock_rename+0x35/0xd0
> [<ffffffff81154bd7>] ? sys_renameat+0x157/0x270
> [<ffffffff811181ae>] ? tlb_finish_mmu+0xe/0x50
> [<ffffffff8111f2cb>] ? unmap_region+0x10b/0x150
> [<ffffffff8111f012>] ? remove_vma+0x52/0x70
> [<ffffffff81120396>] ? do_munmap+0x2d6/0x360
> [<ffffffff814c4912>] ? system_call_fastpath+0x16/0x1b
> INFO: task courier-pop3d:26550 blocked for more than 120 seconds.
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> courier-pop3d   D ffff88107f2d3280     0 26550  26548 0x00000000
> ffff880d78a36040 0000000000000086 ffff8810207347d0 0000000000013280
> ffff88021918ffd8 0000000000013280 0000000000013280 0000000000013280
> ffff88021918e000 0000000000013280 ffff88021918ffd8 0000000000013280
> Call Trace:
> [<ffffffff814bb881>] ? __mutex_lock_slowpath+0xd1/0x140
> [<ffffffff8115287c>] ? do_path_lookup+0x2c/0xd0
> [<ffffffff814bb5e3>] ? mutex_lock+0x23/0x40
> [<ffffffff8114f485>] ? lock_rename+0x35/0xd0
> [<ffffffff81154bd7>] ? sys_renameat+0x157/0x270
> [<ffffffff811181ae>] ? tlb_finish_mmu+0xe/0x50
> [<ffffffff8111f2cb>] ? unmap_region+0x10b/0x150
> [<ffffffff8111f012>] ? remove_vma+0x52/0x70
> [<ffffffff81120396>] ? do_munmap+0x2d6/0x360
> [<ffffffff814c4912>] ? system_call_fastpath+0x16/0x1b
> INFO: task courier-imapd:27534 blocked for more than 120 seconds.
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> courier-imapd   D ffff88107f3d3280     0 27534  27533 0x00000000
> ffff880e0dc5e810 0000000000000082 ffff8810200887d0 0000000000013280
> ffff880e0b0c3fd8 0000000000013280 0000000000013280 0000000000013280
> ffff880e0b0c2000 0000000000013280 ffff880e0b0c3fd8 0000000000013280
> Call Trace:
> [<ffffffff814bb881>] ? __mutex_lock_slowpath+0xd1/0x140
> [<ffffffff8115287c>] ? do_path_lookup+0x2c/0xd0
> [<ffffffff814bb5e3>] ? mutex_lock+0x23/0x40
> [<ffffffff8114f485>] ? lock_rename+0x35/0xd0
> [<ffffffff81154bd7>] ? sys_renameat+0x157/0x270
> [<ffffffff814c0498>] ? do_page_fault+0x228/0x4b0
> [<ffffffff8111f012>] ? remove_vma+0x52/0x70
> [<ffffffff81120396>] ? do_munmap+0x2d6/0x360
> [<ffffffff814c4912>] ? system_call_fastpath+0x16/0x1b
> INFO: task courier-pop3d:28301 blocked for more than 120 seconds.
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> courier-pop3d   D ffff88107f253280     0 28301   3404 0x00000000
> ffff880760255040 0000000000000082 ffff88102068a7d0 0000000000013280
> ffff880d100fdfd8 0000000000013280 0000000000013280 0000000000013280
> ffff880d100fc000 0000000000013280 ffff880d100fdfd8 0000000000013280
> Call Trace:
> [<ffffffff814bb881>] ? __mutex_lock_slowpath+0xd1/0x140
> [<ffffffff8115287c>] ? do_path_lookup+0x2c/0xd0
> [<ffffffff814bb5e3>] ? mutex_lock+0x23/0x40
> [<ffffffff8114f485>] ? lock_rename+0x35/0xd0
> [<ffffffff81154bd7>] ? sys_renameat+0x157/0x270
> [<ffffffff814c0498>] ? do_page_fault+0x228/0x4b0
> [<ffffffff8111f012>] ? remove_vma+0x52/0x70
> [<ffffffff81120396>] ? do_munmap+0x2d6/0x360
> [<ffffffff814c4912>] ? system_call_fastpath+0x16/0x1b
> INFO: task courier-pop3d:28392 blocked for more than 120 seconds.
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> courier-pop3d   D ffff88107f213280     0 28392   3404 0x00000000
> ffff880f66ffc040 0000000000000082 ffffffff81a0d020 0000000000013280
> ffff88016d4c3fd8 0000000000013280 0000000000013280 0000000000013280
> ffff88016d4c2000 0000000000013280 ffff88016d4c3fd8 0000000000013280
> Call Trace:
> [<ffffffff814bb881>] ? __mutex_lock_slowpath+0xd1/0x140
> [<ffffffff8115287c>] ? do_path_lookup+0x2c/0xd0
> [<ffffffff814bb5e3>] ? mutex_lock+0x23/0x40
> [<ffffffff8114f485>] ? lock_rename+0x35/0xd0
> [<ffffffff81154bd7>] ? sys_renameat+0x157/0x270
> [<ffffffff814c0498>] ? do_page_fault+0x228/0x4b0
> [<ffffffff8111f012>] ? remove_vma+0x52/0x70
> [<ffffffff81120396>] ? do_munmap+0x2d6/0x360
> [<ffffffff814c4912>] ? system_call_fastpath+0x16/0x1b
> INFO: task courier-imapd:28536 blocked for more than 120 seconds.
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> courier-imapd   D ffff88107f2d3280     0 28536  28535 0x00000000
> ffff8804893dc810 0000000000000086 ffff8810207347d0 0000000000013280
> ffff880e3d0d7fd8 0000000000013280 0000000000013280 0000000000013280
> ffff880e3d0d6000 0000000000013280 ffff880e3d0d7fd8 0000000000013280
> Call Trace:
> [<ffffffff814bb881>] ? __mutex_lock_slowpath+0xd1/0x140
> [<ffffffff8115287c>] ? do_path_lookup+0x2c/0xd0
> [<ffffffff814bb5e3>] ? mutex_lock+0x23/0x40
> [<ffffffff8114f485>] ? lock_rename+0x35/0xd0
> [<ffffffff81154bd7>] ? sys_renameat+0x157/0x270
> [<ffffffff814c0498>] ? do_page_fault+0x228/0x4b0
> [<ffffffff8111f012>] ? remove_vma+0x52/0x70
> [<ffffffff81120396>] ? do_munmap+0x2d6/0x360
> [<ffffffff814c4912>] ? system_call_fastpath+0x16/0x1b
> INFO: task courier-pop3d:28587 blocked for more than 120 seconds.
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> courier-pop3d   D ffff88107f253280     0 28587   3404 0x00000000
> ffff880cdf6d5810 0000000000000086 ffff88102068a7d0 0000000000013280
> ffff88039ab29fd8 0000000000013280 0000000000013280 0000000000013280
> ffff88039ab28000 0000000000013280 ffff88039ab29fd8 0000000000013280
> Call Trace:
> [<ffffffff814bb881>] ? __mutex_lock_slowpath+0xd1/0x140
> [<ffffffff8115287c>] ? do_path_lookup+0x2c/0xd0
> [<ffffffff814bb5e3>] ? mutex_lock+0x23/0x40
> [<ffffffff8114f485>] ? lock_rename+0x35/0xd0
> [<ffffffff81154bd7>] ? sys_renameat+0x157/0x270
> [<ffffffff814c0498>] ? do_page_fault+0x228/0x4b0
> [<ffffffff8111f012>] ? remove_vma+0x52/0x70
> [<ffffffff81120396>] ? do_munmap+0x2d6/0x360
> [<ffffffff814c4912>] ? system_call_fastpath+0x16/0x1b
> INFO: task courier-pop3d:28790 blocked for more than 120 seconds.
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> courier-pop3d   D ffff88107f273280     0 28790   3404 0x00000000
> ffff88099f39f080 0000000000000082 ffff8810206ba040 0000000000013280
> ffff880631f0dfd8 0000000000013280 0000000000013280 0000000000013280
> ffff880631f0c000 0000000000013280 ffff880631f0dfd8 0000000000013280
> Call Trace:
> [<ffffffff814bb881>] ? __mutex_lock_slowpath+0xd1/0x140
> [<ffffffff8115287c>] ? do_path_lookup+0x2c/0xd0
> [<ffffffff814bb5e3>] ? mutex_lock+0x23/0x40
> [<ffffffff8114f485>] ? lock_rename+0x35/0xd0
> [<ffffffff81154bd7>] ? sys_renameat+0x157/0x270
> [<ffffffff814c0498>] ? do_page_fault+0x228/0x4b0
> [<ffffffff8111f012>] ? remove_vma+0x52/0x70
> [<ffffffff81120396>] ? do_munmap+0x2d6/0x360
> [<ffffffff814c4912>] ? system_call_fastpath+0x16/0x1b
> INFO: task courier-pop3d:29041 blocked for more than 120 seconds.
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> courier-pop3d   D ffff88107f273280     0 29041   3404 0x00000000
> ffff88020210a810 0000000000000082 ffff8810206ba040 0000000000013280
> ffff8802e4437fd8 0000000000013280 0000000000013280 0000000000013280
> ffff8802e4436000 0000000000013280 ffff8802e4437fd8 0000000000013280
> Call Trace:
> [<ffffffff814bb881>] ? __mutex_lock_slowpath+0xd1/0x140
> [<ffffffff8115287c>] ? do_path_lookup+0x2c/0xd0
> [<ffffffff814bb5e3>] ? mutex_lock+0x23/0x40
> [<ffffffff8114f485>] ? lock_rename+0x35/0xd0
> [<ffffffff81154bd7>] ? sys_renameat+0x157/0x270
> [<ffffffff814c0498>] ? do_page_fault+0x228/0x4b0
> [<ffffffff8111f012>] ? remove_vma+0x52/0x70
> [<ffffffff81120396>] ? do_munmap+0x2d6/0x360
> [<ffffffff814c4912>] ? system_call_fastpath+0x16/0x1b
> INFO: task courier-pop3d:29086 blocked for more than 120 seconds.
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> courier-pop3d   D ffff88107f233280     0 29086      1 0x00000000
> ffff88041485c810 0000000000000086 ffff88102060c080 0000000000013280
> ffff880a527e3fd8 0000000000013280 0000000000013280 0000000000013280
> ffff880a527e2000 0000000000013280 ffff880a527e3fd8 0000000000013280
> Call Trace:
> [<ffffffff814bb881>] ? __mutex_lock_slowpath+0xd1/0x140
> [<ffffffff8115287c>] ? do_path_lookup+0x2c/0xd0
> [<ffffffff814bb5e3>] ? mutex_lock+0x23/0x40
> [<ffffffff8114f485>] ? lock_rename+0x35/0xd0
> [<ffffffff81154bd7>] ? sys_renameat+0x157/0x270
> [<ffffffffa0ad3a27>] ? ocfs2_read_inode_block_full+0x37/0x60 [ocfs2]
> [<ffffffff814c0498>] ? do_page_fault+0x228/0x4b0
> [<ffffffffa0ac08c4>] ? ocfs2_lock_res_free+0x64/0x480 [ocfs2]
> [<ffffffffa0ac15db>] ? ocfs2_simple_drop_lockres+0x2b/0xd0 [ocfs2]
> [<ffffffff8115ab3a>] ? dput+0x2a/0x280
> [<ffffffff8114687a>] ? __fput+0x15a/0x240
> [<ffffffff814c4912>] ? system_call_fastpath+0x16/0x1b 
>
>
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
