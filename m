From: Ling, Xiaofeng <xiaofeng.ling@intel.com>
Date: Tue Aug 24 20:04:43 2004
Subject: [Ocfs2-devel] [PATCH] fix big 116 -- umount cause crash after
	some operation
Message-ID: <3ACA40606221794F80A5670F0AF15F840547781F@pdsmsx403>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

>Do you have a kernel stack trace? I want to make sure we're 
>talking about
>the same bug (s) here. The 1st one I dealt with was only that 
>commit thread
>was trying to release the locks with a signal pending which 
>caused the code
>in dlm.c to freak out. I removed signal handling from it 
>altogether and just
>use our ocfs_wait function instead. This seemed to alleviate 
>that problem.
>Issue #2 I see during umount is that occasionally the ocfs2 nm 
>thread will 
>crash in __make_request:
So what we see is not the same. 
The bug 116 is easy to reproduce, just do a command line as
root#mkdir /ocfs/aaa;umount /ocfs
follow the umount to mkdir tightly.


============================================
 call dismount now
(4577) ENTRY: ocfs_put_super(0xdb40ba00)
(4577) TRACE: ocfs_put_super() put super... do nothing!  DONE!!!!
(4577) EXIT : ocfs_put_super()
VFS: Busy inodes after unmount. Self-destruct in 5 seconds.  Have a nice
day...
------------[ cut here ]------------
kernel BUG at fs/buffer.c:2703!
invalid operand: 0000 [#2]
CPU:    0
EIP:    0060:[<c014bb80>]    Not tainted
EFLAGS: 00010202   (2.6.6kdb)
EIP is at submit_bh+0x153/0x16d
eax: 00000010   ebx: 00000008   ecx: d5811ea0   edx: d5811ea0
esi: d5811ea0   edi: 00001000   ebp: 00000000   esp: d75cbe48
ds: 007b   es: 007b   ss: 0068
Process ocfs2nm-0 (pid: 4572, threadinfo=d75ca000 task=dfb21230)
Stack: c0373a72 d75cbe9c 00000046 df45dc00 df45dc00 d5811820 00000000
00000008
       d5811ea0 00001000 00000000 e09dc3e6 00000000 d5811ea0 000000d8
3f5f0e04
       00003c26 dfb213d8 03ecda38 d75cbeb0 d75ca000 d75ca000 d75ca000
d75ca000
Call Trace:
 [<c0373a72>] schedule+0x30e/0x50c
 [<e09dc3e6>] ocfs_read_bhs+0x6e3/0x849 [ocfs2]
 [<e09f5c16>] ocfs_volume_thread+0x2a6/0x75c [ocfs2]
 [<c0118f21>] exit_notify+0x2b0/0x772
 [<c01196a8>] do_exit+0x2c5/0x34d
 [<c01197cf>] do_group_exit+0x52/0x72
 [<c0105d4a>] ret_from_fork+0x6/0x14
 [<e09f5970>] ocfs_volume_thread+0x0/0x75c [ocfs2]
 [<e09f5970>] ocfs_volume_thread+0x0/0x75c [ocfs2]
 [<c0104291>] kernel_thread_helper+0x5/0xb

Code: 0f 0b 8f 0a 99 6d 39 c0 e9 cb fe ff ff 0f 0b 8e 0a 99 6d 39

ds: 007b   es: 007b   ss: 0068
Process ocfs2cmt-0 (pid: 4575, threadinfo=dd0a4000 task=df2c01b0)
Stack: 00000000 dd0a5d94 00000282 40016863 00000000 d8064d80 d941a924
db8cb000
       d3044888 0000010d d8064d80 c014bc7a 00000001 d3044888 db8cb000
dfbcd354
       db8cb000 dfbcd354 c018fd2f d3044888 d941a924 c018d92e d3044888
0000000b
Call Trace:
 [<c014bc7a>] sync_dirty_buffer+0x5c/0xaf
 [<c018fd2f>] journal_update_superblock+0x60/0xa1
 [<c018d92e>] __try_to_free_cp_buf+0x46/0x4d
 [<c018de05>] cleanup_journal_tail+0x7a/0xe1
 [<c018dcec>] log_do_checkpoint+0xd6/0x175
 [<c0131ba6>] buffered_rmqueue+0xc4/0x15c
 [<c0131cdc>] __alloc_pages+0x9e/0x316
 [<c013ab73>] do_anonymous_page+0xdc/0x190
 [<c013ac8c>] do_no_page+0x65/0x2d9
 [<c018a605>] journal_lock_updates+0xbd/0xcf
 [<c0115671>] autoremove_wake_function+0x0/0x4f
 [<c01904f5>] journal_flush+0x1c3/0x1f0
 [<c0373a72>] schedule+0x30e/0x50c
 [<e09ea42f>] ocfs_commit_cache+0x1ab/0x51b [ocfs2]
 [<c01188de>] daemonize+0xd5/0xda
 [<e09eef8b>] ocfs_commit_thread+0x117/0x46f [ocfs2]
 [<c0114708>] default_wake_function+0x0/0x26
 [<c0114708>] default_wake_function+0x0/0x26
 [<c0114708>] default_wake_function+0x0/0x26
 [<c0114708>] default_wake_function+0x0/0x26
 [<e0a002ed>] ocfs_timeout_func+0x0/0x1e [ocfs2]
 [<c0118f21>] exit_notify+0x2b0/0x772
 [<c0373796>] schedule+0x32/0x50c
 [<c01196a8>] do_exit+0x2c5/0x34d
 [<c0105e8e>] work_resched+0x5/0x16
 [<e09eee74>] ocfs_commit_thread+0x0/0x46f [ocfs2]
 [<e09eee74>] ocfs_commit_thread+0x0/0x46f [ocfs2]
 [<c0104291>] kernel_thread_helper+0x5/0xb

Code: 0f 0b 8f 0a 99 6d 39 c0 e9 cb fe ff ff 0f 0b 8e 0a 99 6d 39

 ------------[ cut here ]------------
kernel BUG at fs/buffer.c:2703!
invalid operand: 0000 [#3]
CPU:    0
EIP:    0060:[<c014bb80>]    Not tainted
EFLAGS: 00010202   (2.6.6kdb)
EIP is at submit_bh+0x153/0x16d
eax: 00000010   ebx: db8cb000   ecx: d3044888   edx: d3044888
esi: d3044888   edi: 0000010d   ebp: d8064d80   esp: dd0a5c4c
