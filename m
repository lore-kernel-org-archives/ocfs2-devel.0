From: Zhen Wei <zwei@novell.com>
Date: Thu Aug 24 19:42:24 2006
Subject: [Ocfs2-devel] =?utf-8?b?562U5aSN77yaIGtlcm5lbCBjcmFzaCBvbiBvY2Zz?=
	=?utf-8?q?2?=
Message-ID: <44EEF020020000040025D1CB@lucius.provo.novell.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

I run ocfs2 on xen by using iSCSI, when I mount the shared partition and
touch a file, kernel crash.
uname -a : 
linux-crow 2.6.16.21-0.8-xen #1 SMP Mon Jul 3 18:25:39 UTC 2006 i686
i686 i386 GNU/Linux
ocfs2 ver: 1.2.1
kernel config is attached



kernel BUG at fs/ocfs2/dir.c:539!
invalid opcode: 0000 [#1]
SMP
last sysfs file: /class/net/lo/address
Modules linked in: ocfs2 jbd ocfs2_dlmfs ocfs2_dlm ocfs2_nodemanager
configfs iscsi_trgt crc32c libcrc32c ipv6 af_packet loop dm_mod reiserfs
xenblk xennet
CPU:    0
EIP:    0061:[<d133748f>]    Not tainted VLI
EFLAGS: 00010206   (2.6.16.21-0.8-xen #1)
EIP is at ocfs2_prepare_dir_for_insert+0xadf/0xe40 [ocfs2]
eax: 00003000   ebx: 00000000   ecx: 00001000   edx: 00003000
esi: 00002000   edi: 00000000   ebp: ca55ccc8   esp: c529bdc4
ds: 007b   es: 007b   ss: 0069
Process touch (pid: 1863, threadinfo=c529a000 task=c0532130)
Stack: <0>00000001 cd0669c4 00000000 c529be90 ca400140 ca55ccc8 00000000
ca55cac8
       ca55cac0 ca55ce24 ca767f74 ca55e800 cbb0d9f0 000081a4 d13364fb
c529be24
       000081a4 c0150ae5 ca55e800 00008000 ca55e800 d134f7c5 d109682a
00000000
Call Trace:
 [<d13364fb>] ocfs2_check_dir_for_entry+0x4b/0x130 [ocfs2]
 [<c0150ae5>] kzalloc+0x15/0x50
 [<d134f7c5>] ocfs2_alloc_handle+0x15/0xd0 [ocfs2]
 [<d109682a>] do_journal_end+0x19a/0xd60 [reiserfs]
 [<d135ab05>] ocfs2_mknod+0x3d5/0xf40 [ocfs2]
 [<d133637d>] ocfs2_find_files_on_disk+0x5d/0x190 [ocfs2]
 [<c0177931>] link_path_walk+0x71/0xf0
 [<d133a38a>] ocfs2_meta_unlock+0x16a/0x1b0 [ocfs2]
 [<c017ef92>] d_rehash+0x52/0x70
 [<d135bc96>] ocfs2_create+0x46/0x110 [ocfs2]
 [<c0162db7>] kmem_cache_alloc+0xa7/0xb0
 [<c0175450>] permission+0xa0/0xd0
 [<c0175ab7>] vfs_create+0xc7/0x140
 [<c0178fc6>] open_namei+0x5d6/0x670
 [<c016553e>] do_filp_open+0x2e/0x60
 [<c0165210>] get_unused_fd+0x50/0xb0
 [<c01655ba>] do_sys_open+0x4a/0xe0
 [<c016568c>] sys_open+0x1c/0x20
 [<c0104f25>] syscall_call+0x7/0xb
Code: 00 e0 ff ff c1 f8 1f 21 e2 89 5c 24 14 89 44 24 18 c7 44 24 10 e2
01 00 00 e9 8e fe ff ff c7 44 24 5c fe ff ff ff e9 3e fc ff ff <0f> 0b
1b 02 71 bf 37 d1 e9 b9 f5 ff ff 0f 0b 19 02 71 bf 37 d1
 Segmentation fault

-------------- next part --------------
A non-text attachment was scrubbed...
Name: config.gz
Type: application/octet-stream
Size: 16494 bytes
Desc: not available
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20060824/04111965/config.obj
