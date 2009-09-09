From: Coly Li <coly.li@suse.de>
Date: Thu, 10 Sep 2009 04:07:00 +0800
Subject: [Ocfs2-devel] dlm stress test hangs OCFS2
In-Reply-To: <4A9FEDAC.50704@oracle.com>
References: <4A8B0083.8030400@suse.de> <4A8B6C29.30802@oracle.com>
	<4A9EA759.5090906@suse.de> <4A9EEB26.2080204@oracle.com>
	<4A9FEDA8.3080108@suse.de> <4A9FEDAC.50704@oracle.com>
Message-ID: <4AA80AE4.9090105@suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



Sunil Mushran Wrote:
> You will have to trace thru process_blocked_lock() to make sense of this.
> 
I try to trace process_blocked_lock(), the result is quite complex. I attach the
modified fs/ocfs2 code (ocfs2-trace.tar.bz2) in this email, since it's not
latest upstream ocfs2 code.

Then I run the bash script to create zero byte file, when the blocking happens,
I dump the dmesg output from all nodes.

The printk message is quite long, therefore, I try to divide the printk messages
into several mod (up to 11, see printk-mods.txt), and try to replace the printk
messages by a symbol (M1, M2, ... M11). If there is a symbol continuous
repeated, I only keep one and followed with its repeat number.

Then I get a much short printk message dump file, I past the content here:
--------------------------------------------
M1
M2 (1505)
M3
M4
M2 (1848)
w_level: 0x0
ocfs2_unblock_lock:3281 ctl->unblock_action: 0.
ocfs2_unblock_lock:3297 ctl->requeue = 0
ocfs2_unblock_lock:3299 LOCK_TYPE_USES_LVB.
ocfs2_prepare_downconvert:3069 lock M0000000000000000085e0200000000,
lockres->l_level:3, new_level: 0
ocfs2_unblock_lock:3320 gen: 0x7a4ec, ret: 0x0
ocfs2_unblock_lock:3322 lockres->l_flags: 0x157
	<<<exit ocfs2_unblock_lock after leave.
ocfs2_process_blocked_lock:3707 call lockres_clear_flags LOCK_QEUED(l_flags:
0x157, ctl{unblock_action:0, requeue:0})
<<<exit ocfs2_process_blocked_lock
M2 (286)
ocfs2_mknod:246 (0xffff880017b835e8, 0xffff880017b653c0, 33188, 0, 'x1_2872_722')
ocfs2_mknod:252 call ocfs2_inode_lock
M6
M11
M5 (276)
ocfs2_mknod:246 (0xffff880017b835e8, 0xffff88000781a8a0, 33188, 0, 'x1_2860_733')
ocfs2_mknod:252 call ocfs2_inode_lock
M7
M1
M2 (274)
M3
M4
ocfs2_mknod:246 (0xffff880017b835e8, 0xffff88000781a2f0, 33188, 0, 'x1_2872_725')
ocfs2_mknod:252 call ocfs2_inode_lock
M1
M5 (295)
M6
M7
M1
M2
ocfs2_mknod:246 (0xffff880017b835e8, 0xffff88000781a700, 33188, 0, 'x1_2860_734')
ocfs2_mknod:252 call ocfs2_inode_lock
M1
M5 (455)
M11
M5 (275)
M11
M5 (275)
M6
M7
M1
M2
ocfs2_mknod:246 (0xffff880017b835e8, 0xffff880017b65080, 33188, 0, 'x1_2860_735')
ocfs2_mknod:252 call ocfs2_inode_lock
M1
M5 (204)
M11
M5 (696)
{unblock_action:0, requeue:0})
<<<exit ocfs2_process_blocked_lock
M5 (229)
M11
M5 (275)
M11
M5 (275)
M11
M5 (275)
M11
M5 (275)
b=1.
ocfs2_prepare_downconvert:3069 lock M0000000000000000085e0200000000,
lockres->l_level:5, new_level: 0
ocfs2_unblock_lock:3320 gen: 0x8945b, ret: 0x0
ocfs2_unblock_lock:3322 lockres->l_flags: 0x157
	<<<exit ocfs2_unblock_lock after leave.
ocfs2_process_blocked_lock:3707 call lockres_clear_flags LOCK_QEUED(l_flags:
0x157, ctl{unblock_action:0, requeue:0})
<<<exit ocfs2_process_blocked_lock
M5 (272)
ocfs2_mknod:246 (0xffff880017b835e8, 0xffff880017b65490, 33188, 0, 'x1_2860_738')
ocfs2_mknod:252 call ocfs2_inode_lock
M6
M7
M1
M2
ocfs2_mknod:246 (0xffff880017b835e8, 0xffff880017b652f0, 33188, 0, 'x1_2872_730')
ocfs2_mknod:252 call ocfs2_inode_lock
M1
M8
ocfs2_mknod:246 (0xffff880017b835e8, 0xffff880017b65630, 33188, 0, 'x1_2860_739')
ocfs2_mknod:252 call ocfs2_inode_lock
M9 (2)
M10 (110)
nblock_lock:3297 ctl->requeue = 0
ocfs2_unblock_lock:3299 LOCK_TYPE_USES_LVB.
ocfs2_unblock_lock:3301 set_lvb=1.
ocfs2_unblock_lock:3311 call lockres->l_ops->set_lvb
ocfs2_prepare_downconvert:3069 lock M0000000000000000085e0200000000,
lockres->l_level:5, new_level: 3
ocfs2_unblock_lock:3320 gen: 0x8a092, ret: 0x0
ocfs2_unblock_lock:3322 lockres->l_flags: 0x147
	<<<exit ocfs2_unblock_lock after leave.
ocfs2_process_blocked_lock:3707 call lockres_clear_flags LOCK_QEUED(l_flags:
0x147, ctl{unblock_action:0, requeue:0})
<<<exit ocfs2_process_blocked_lock
M10 (260)
nblock_lock:3297 ctl->requeue = 0
ocfs2_unblock_lock:3299 LOCK_TYPE_USES_LVB.
ocfs2_unblock_lock:3301 set_lvb=1.
ocfs2_unblock_lock:3311 call lockres->l_ops->set_lvb
ocfs2_prepare_downconvert:3069 lock M0000000000000000085e0200000000,
lockres->l_level:5, new_level: 3
ocfs2_unblock_lock:3320 gen: 0x8a6c6, ret: 0x0
ocfs2_unblock_lock:3322 lockres->l_flags: 0x147
	<<<exit ocfs2_unblock_lock after leave.
ocfs2_process_blocked_lock:3707 call lockres_clear_flags LOCK_QEUED(l_flags:
0x147, ctl{unblock_action:0, requeue:0})
<<<exit ocfs2_process_blocked_lock
M10 (259)
nblock_lock:3297 ctl->requeue = 0
ocfs2_unblock_lock:3299 LOCK_TYPE_USES_LVB.
ocfs2_unblock_lock:3301 set_lvb=1.
ocfs2_unblock_lock:3311 call lockres->l_ops->set_lvb
ocfs2_prepare_downconvert:3069 lock M0000000000000000085e0200000000,
lockres->l_level:5, new_level: 3
ocfs2_unblock_lock:3320 gen: 0x8bdf8, ret: 0x0
ocfs2_unblock_lock:3322 lockres->l_flags: 0x147
	<<<exit ocfs2_unblock_lock after leave.
ocfs2_process_blocked_lock:3707 call lockres_clear_flags LOCK_QEUED(l_flags:
0x147, ctl{unblock_action:0, requeue:0})
<<<exit ocfs2_process_blocked_lock
M10 (269)
M11
M5 (275)
M11
M5 (275)
M11
M5 (589)
M11
M5 (275)
M11
M5 (275)
M11
M5 (275)
M11
M5 (795)
M11
M5 (247)
M11
M5 (275)
M11
M5 (275)
M11
M5 (463)
--------------------------------------------

There are some incomplete printk messages in the dump file, I don't have idea
yet why part of them are missed. If ignoring the incomplete printk messages, we
can find ocfs2_precess_blocked_lock() execution in mod 2 and 5 happens >99%.
This is an interested result, I can not explain yet.

Another notable thing is, I find in only in mod 1,2,4,5,7,9,10,11, l_ex_holders
and l_ro_holders are all zero. IMHO, if current lockres is PR, there should be
at least 1 l_ro_holder; if current lockres is EX, there should be at least 1
l_ex_holders. Still I can not see my observation is a result of the blocking
issue, or a source of the blocking issue.

I update my current progress, and continue to work on it. If there are any
suggestion from anyone on the list, I am glad to know :-)

Thanks.
-- 
Coly Li
SuSE Labs
-------------- next part --------------
A non-text attachment was scrubbed...
Name: ocfs2-trace.tar.bz2
Type: application/x-bzip
Size: 329239 bytes
Desc: not available
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20090910/169a7f3d/attachment-0001.bin 
-------------- next part --------------
An embedded and charset-unspecified text was scrubbed...
Name: printk-mods.txt
Url: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20090910/169a7f3d/attachment-0001.txt 
