From: Zhang, Sonic <sonic.zhang@intel.com>
Date: Wed Mar  3 03:22:53 2004
Subject: [Ocfs2-devel] Issues when mount/umount a ocfs2 volume
Message-ID: <37FBBA5F3A361C41AB7CE44558C3448E5A30D3@PDSMSX403.ccr.corp.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,

	After rebuilt the 2.6 kernel with CONFIG_RAW_DRIVER on, I
successfully created the OCFS2 volume. 

	I found following issues.
	1. The mount operation completes with error information.
buffer layer error at fs/buffer.c:1260
Call Trace:
[<c015e9b6>] mark_buffer_dirty
[			] journal_create
[			] ocfs_journal_create
[			] ocfs_check_volume
[			] default_wake_function
......

	2. The umount operation halts with error information. 
sleeping function called from invalid context at kernel/sched.c:1751
in_atomic():1, irq_disable():0
Call Trace:
[			] __might_sleep
[			] wait_for_completion
[			] send_sig_info
[			] ocfs_dismount_volume





*********************************************
Sonic Zhang
Software Engineer
Intel China Software Lab
Tel: (086)021-52574545-1667
iNet: 752-1667
********************************************* 
