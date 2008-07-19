From: Geoffrey Pan <cheetaweb@gmail.com>
Date: Sat, 19 Jul 2008 17:08:27 +0100
Subject: [Ocfs2-devel] EIP in ocfs2 on spin_lock / inode_lock_full
Message-ID: <22efb4930807190908u272c26bbxf764d291ea96e63a@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

I replicated this on 2.6.26-rc9 and release 2.6.26 - showing up on console
screen. Once it starts it just spews on the screen and server becomes
unusable.

Geoff

EIP:0060:[<c0607856>] EFLAGS: 00000297 CPU: 0
EIP is at _spin_lock+0x10/0x15
EAX: f5962c00 EBX: 00000000 ECX: 00000000 EDX: 0000acab
ESI: f44413d0 EDI: f44413d0 EBP: d2e8e000 ESP: d2e88ee2c
DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
CR0: 80050033 CR2: 00357cb0 CR3: 287ee000 CR4: 000006f0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400

[<f8bfee69>] ocfs_inode_lock_full+0x33/0x96d [ocfs2]
[<c0485e75>] mntput_no_expire+0x13/0xd6
[<f8c1e3f0>] ocfs2_statfs+0xbb/0x248d [ocfs2]
[<c0472db8>] vfs_statfs+0x43/0x5b
[<c0472de0>] vfs_statfs64+0x10/0x21
[<c0472e95>] sys_statfs64+0x44/0x7b
[<c044c41a>] audit_syscall_entry+0x102/0x12c
[<c044c6e5>] audit_syscall_exit+0x2a1/0x2bd
[<c0409008>] do_syscall_trace+0x121/0x165
[<c0403882>] syscall_call+0x7/0xb


EAX: f5962c84 EBX: 00000000 ECX: 00000000 EDX: 0000adab
ESI: f5962c00 EDI: f44435d0 EBP: f546af04 ESP: f546adf4
DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
CR0: 80050033 CR2: 0822d548 CR3: 35530000 CR4: 000006f0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400

[<f8bfee69>] ocfs_inode_lock_full+0x33/0x96d [ocfs2]
[<f8c06549>] ocfs2_permission+0x0/0xce [ocfs2]
[<f8c0655b>] ocfs2_permission+0x12/0xce [ocfs2]
[<f8c06549>] ocfs2_permission+0x0/0xce [ocfs2]
[<c047990d>] permission+0xa3/0xef
[<c047b0f9>] __link_path_walk+0x11b/0xb02
[<f885179b>] do_get_write_access+0x32d/0x366 [jbd]
[<c047bb17>] path_walk+0x37/0x70
[<c047bdc6>] do_path_lookup+0x122/0x184
[<c047c623>] __user_walk_fd+0x29/0x3a
[<c047677f>] vfs_stat_fd+0x15/0x3c
[<c0461119>] handle_mm_fault+0x709/0x78f
[<c047685b>] sys_stat64+0xf
[<c044c41a>] audit_syscall_entry+0x102/0x12c
[<c044c6e5>] audit_syscall_exit+0x2a1/0x2bd
[<c0409008>] do_syscall_trace+0x121/0x165
[<c0403882>] syscall_call+0x7/0xb
-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20080719/5370d428/attachment.html 
