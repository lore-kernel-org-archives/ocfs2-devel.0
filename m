From: Ling, Xiaofeng <xiaofeng.ling@intel.com>
Date: Wed Apr 21 00:41:09 2004
Subject: [Ocfs2-devel] Patches to fix the OCFS2 bug 54, which cause
	crashin the second mount under kernel 2.6.
Message-ID: <3ACA40606221794F80A5670F0AF15F8404151384@PDSMSX403.ccr.corp.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

although simple mount and remount is ok, But there still have oops when =
running my test on 2.6.
That seems happened when unload module after some read/write.
see below dmesg:
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
ocfs2: hostname is xling
lockres: lockid=3D1482752.0, this=3D0, master=3D0, locktype=3D8, =
flags=3D40004001, ronode=3D-1, romap=3D00000000
kjournald starting.  Commit interval 5 seconds
ocfs2: Mounting device (3,4) on xling (node 0)
ocfs2: Unmounting device (3,4) on xling (node 0)
lockres: lockid=3D1482752.0, this=3D0, master=3D0, locktype=3D8, =
flags=3D40004001, ronode=3D-1, romap=3D00000000
kjournald starting.  Commit interval 5 seconds
ocfs2: Mounting device (3,4) on xling (node 0)
ocfs2: Unmounting device (3,4) on xling (node 0)
Unloaded OCFS Driver module
Oracle Cluster FileSystem x y (build z)
ocfs2: hostname is xling
lockres: lockid=3D512.0, this=3D0, master=3D-1, locktype=3D0, =
flags=3D40002001, ronode=3D-1, romap=3D00000000
lockres: lockid=3D512.0, this=3D0, master=3D0, locktype=3D0, =
flags=3D40000401, ronode=3D-1, romap=3D00000000
lockres: lockid=3D1024.0, this=3D0, master=3D-1, locktype=3D0, =
flags=3D40002000, ronode=3D-1, romap=3D00000000
lockres: lockid=3D1417216.0, this=3D0, master=3D0, locktype=3D0, =
flags=3D40000401, ronode=3D-1, romap=3D00000000
lockres: lockid=3D1024.0, this=3D0, master=3D0, locktype=3D0, =
flags=3D40000400, ronode=3D-1, romap=3D00000000
lockres: lockid=3D1024.0, this=3D0, master=3D0, locktype=3D0, =
flags=3D40000400, ronode=3D-1, romap=3D00000000
lockres: lockid=3D1417216.0, this=3D0, master=3D0, locktype=3D8, =
flags=3D40004001, ronode=3D-1, romap=3D00000000
lockres: lockid=3D1417216.0, this=3D0, master=3D0, locktype=3D8, =
flags=3D40004001, ronode=3D-1, romap=3D00000000
lockres: lockid=3D1417216.0, this=3D0, master=3D0, locktype=3D8, =
flags=3D40004001, ronode=3D-1, romap=3D00000000
lockres: lockid=3D1417216.0, this=3D0, master=3D0, locktype=3D8, =
flags=3D40004001, ronode=3D-1, romap=3D00000000
lockres: lockid=3D1417216.0, this=3D0, master=3D0, locktype=3D8, =
flags=3D40004001, ronode=3D-1, romap=3D00000000
lockres: lockid=3D1417216.0, this=3D0, master=3D0, locktype=3D8, =
flags=3D40004001, ronode=3D-1, romap=3D00000000
lockres: lockid=3D1417216.0, this=3D0, master=3D0, locktype=3D8, =
flags=3D40004001, ronode=3D-1, romap=3D00000000
lockres: lockid=3D1417216.0, this=3D0, master=3D0, locktype=3D8, =
flags=3D40004001, ronode=3D-1, romap=3D00000000
lockres: lockid=3D1024.0, this=3D0, master=3D0, locktype=3D0, =
flags=3D40000400, ronode=3D-1, romap=3D00000000
lockres: lockid=3D1417216.0, this=3D0, master=3D0, locktype=3D8, =
flags=3D40004001, ronode=3D-1, romap=3D00000000
lockres: lockid=3D1417216.0, this=3D0, master=3D0, locktype=3D8, =
flags=3D40004001, ronode=3D-1, romap=3D00000000
lockres: lockid=3D1417216.0, this=3D0, master=3D0, locktype=3D8, =
flags=3D40004001, ronode=3D-1, romap=3D00000000
lockres: lockid=3D1417216.0, this=3D0, master=3D0, locktype=3D8, =
flags=3D40004001, ronode=3D-1, romap=3D00000000
lockres: lockid=3D1417216.0, this=3D0, master=3D0, locktype=3D8, =
flags=3D40004001, ronode=3D-1, romap=3D00000000
lockres: lockid=3D1417216.0, this=3D0, master=3D0, locktype=3D8, =
flags=3D40004001, ronode=3D-1, romap=3D00000000
lockres: lockid=3D1417216.0, this=3D0, master=3D0, locktype=3D8, =
flags=3D40004001, ronode=3D-1, romap=3D00000000
lockres: lockid=3D1417216.0, this=3D0, master=3D0, locktype=3D8, =
flags=3D40004001, ronode=3D-1, romap=3D00000000
lockres: lockid=3D1417216.0, this=3D0, master=3D0, locktype=3D8, =
flags=3D40004001, ronode=3D-1, romap=3D00000000
lockres: lockid=3D1417216.0, this=3D0, master=3D0, locktype=3D8, =
flags=3D40004001, ronode=3D-1, romap=3D00000000
lockres: lockid=3D1417216.0, this=3D0, master=3D0, locktype=3D8, =
flags=3D40004001, ronode=3D-1, romap=3D00000000
lockres: lockid=3D1417216.0, this=3D0, master=3D0, locktype=3D8, =
flags=3D40004001, ronode=3D-1, romap=3D00000000
lockres: lockid=3D1417216.0, this=3D0, master=3D0, locktype=3D8, =
flags=3D40004001, ronode=3D-1, romap=3D00000000
lockres: lockid=3D1417216.0, this=3D0, master=3D0, locktype=3D8, =
flags=3D40004001, ronode=3D-1, romap=3D00000000
lockres: lockid=3D1417216.0, this=3D0, master=3D0, locktype=3D8, =
flags=3D40004001, ronode=3D-1, romap=3D00000000
lockres: lockid=3D1417216.0, this=3D0, master=3D0, locktype=3D8, =
flags=3D40004001, ronode=3D-1, romap=3D00000000
lockres: lockid=3D1024.0, this=3D0, master=3D0, locktype=3D0, =
flags=3D40000400, ronode=3D-1, romap=3D00000000
lockres: lockid=3D1417216.0, this=3D0, master=3D0, locktype=3D8, =
flags=3D40004001, ronode=3D-1, romap=3D00000000
lockres: lockid=3D1417216.0, this=3D0, master=3D0, locktype=3D8, =
flags=3D40004001, ronode=3D-1, romap=3D00000000
lockres: lockid=3D1417216.0, this=3D0, master=3D0, locktype=3D8, =
flags=3D40004001, ronode=3D-1, romap=3D00000000
lockres: lockid=3D1417216.0, this=3D0, master=3D0, locktype=3D8, =
flags=3D40004001, ronode=3D-1, romap=3D00000000
lockres: lockid=3D1417216.0, this=3D0, master=3D0, locktype=3D8, =
flags=3D40004001, ronode=3D-1, romap=3D00000000
lockres: lockid=3D1417216.0, this=3D0, master=3D0, locktype=3D8, =
flags=3D40004001, ronode=3D-1, romap=3D00000000
lockres: lockid=3D1417216.0, this=3D0, master=3D0, locktype=3D8, =
flags=3D40004001, ronode=3D-1, romap=3D00000000
lockres: lockid=3D1417216.0, this=3D0, master=3D0, locktype=3D8, =
flags=3D40004001, ronode=3D-1, romap=3D00000000
lockres: lockid=3D1482752.0, this=3D0, master=3D0, locktype=3D0, =
flags=3D40000401, ronode=3D-1, romap=3D00000000
lockres: lockid=3D1024.0, this=3D0, master=3D0, locktype=3D0, =
flags=3D40000400, ronode=3D-1, romap=3D00000000
ocfs2: Old journal type found, converting to new style. You will no =
longer be able to mount with ocfs version 1.
kjournald starting.  Commit interval 5 seconds
ocfs2: Mounting device (3,4) on xling (node 0)
lockres: lockid=3D2416640.0, this=3D0, master=3D-1, locktype=3D0, =
flags=3D60003000, ronode=3D-1, romap=3D00000000
lockres: lockid=3D2416640.0, this=3D0, master=3D0, locktype=3D8, =
flags=3D40005001, ronode=3D0, romap=3D00000000
lockres: lockid=3D2417152.0, this=3D0, master=3D0, locktype=3D8, =
flags=3D40004002, ronode=3D-1, romap=3D00000000
lockres: lockid=3D1024.0, this=3D0, master=3D0, locktype=3D0, =
flags=3D40000400, ronode=3D-1, romap=3D00000000
lockres: lockid=3D2416640.0, this=3D0, master=3D0, locktype=3D8, =
flags=3D40005001, ronode=3D0, romap=3D00000000
lockres: lockid=3D2417664.0, this=3D0, master=3D0, locktype=3D8, =
flags=3D40004002, ronode=3D-1, romap=3D00000000
VFS: Busy inodes after unmount. Self-destruct in 5 seconds.  Have a nice =
day...
slab error in kmem_cache_destroy(): cache `ocfs2_inode': Can't free all =
objects
Call Trace:
 [<c01396eb>] kmem_cache_destroy+0x99/0x11b
 [<e09dedce>] ocfs_free_mem_lists+0x1e/0xd9 [ocfs2]
 [<e09f09d7>] ocfs_driver_exit+0x235/0x2ef [ocfs2]
 [<c012da25>] sys_delete_module+0x167/0x1be
 [<c0141da2>] do_munmap+0x12d/0x16f
 [<c0109121>] sysenter_past_esp+0x52/0x71

slab error in kmem_cache_destroy(): cache `ocfs2_lockres': Can't free =
all objects
Call Trace:
 [<c01396eb>] kmem_cache_destroy+0x99/0x11b
 [<e09dee1f>] ocfs_free_mem_lists+0x6f/0xd9 [ocfs2]
 [<e09f09d7>] ocfs_driver_exit+0x235/0x2ef [ocfs2]
 [<c012da25>] sys_delete_module+0x167/0x1be
 [<c0141da2>] do_munmap+0x12d/0x16f
 [<c0109121>] sysenter_past_esp+0x52/0x71

slab error in kmem_cache_destroy(): cache `ocfs2_extent': Can't free all =
objects
Call Trace:
 [<c01396eb>] kmem_cache_destroy+0x99/0x11b
 [<e09dee3a>] ocfs_free_mem_lists+0x8a/0xd9 [ocfs2]
 [<e09f09d7>] ocfs_driver_exit+0x235/0x2ef [ocfs2]
 [<c012da25>] sys_delete_module+0x167/0x1be
 [<c0141da2>] do_munmap+0x12d/0x16f
 [<c0109121>] sysenter_past_esp+0x52/0x71

slab error in kmem_cache_destroy(): cache `ocfs2_inum': Can't free all =
objects
Call Trace:
 [<c01396eb>] kmem_cache_destroy+0x99/0x11b
 [<e09dee70>] ocfs_free_mem_lists+0xc0/0xd9 [ocfs2]
 [<e09f09d7>] ocfs_driver_exit+0x235/0x2ef [ocfs2]
 [<c012da25>] sys_delete_module+0x167/0x1be
 [<c0141da2>] do_munmap+0x12d/0x16f
 [<c0109121>] sysenter_past_esp+0x52/0x71

Unloaded OCFS Driver module
Unable to handle kernel paging request at virtual address e09cc231
 printing eip:
e09cc231
*pde =3D 015ef067
*pte =3D 00000000
Oops: 0000 [#1]
CPU:    0
EIP:    0060:[<e09cc231>]    Not tainted
EFLAGS: 00010296
EIP is at 0xe09cc231
eax: 00000000   ebx: da197000   ecx: 00000000   edx: 00000000
esi: 00000020   edi: da172000   ebp: 00000024   esp: da173ef4
ds: 007b   es: 007b   ss: 0068
Process ocfs2nm-0 (pid: 5007, threadinfo=3Dda172000 task=3Dd7c97900)
Stack: d8848354 00000019 00000000 00004800 00000000 dfc9f880 00000000 =
00000000=20
       c0000000 d8272700 da172000 da172000 d8724bfc da172000 da1976e8 =
002aca3b=20
       00000011 00000001 00000000 ffffffff 00000020 00000046 da33f900 =
c011c3f9=20
Call Trace:
 [<c011c3f9>] exit_notify+0x25d/0x773
 [<c011cbd9>] do_exit+0x2ca/0x352
 [<c0109086>] ret_from_fork+0x6/0x14
 [<c0107289>] kernel_thread_helper+0x5/0xb

Code:  Bad EIP value.
 <6>Oracle Cluster FileSystem x y (build z)
ocfs2: hostname is xling
kmem_cache_create: duplicate cache ocfs2_inode
------------[ cut here ]------------
kernel BUG at /usr/src/linux-2.6.3/mm/slab.c:1269!
invalid operand: 0000 [#2]
CPU:    0
EIP:    0060:[<c0139466>]    Not tainted
EFLAGS: 00010202
EIP is at kmem_cache_create+0x3ba/0x48b
eax: 0000002f   ebx: dfcc4f04   ecx: c04660e8   edx: 00008cb0
esi: e09f4630   edi: e09f4630   ebp: dfcc4c54   esp: d9795f24
ds: 007b   es: 007b   ss: 0068
Process insmod (pid: 5324, threadinfo=3Dd9794000 task=3Ddb61e6a0)
Stack: c03640e0 e09f4624 00003000 d9795f40 dfcc4c90 c0000000 ffffff80 =
00000080=20
       c03adda1 00000000 e0a1f9c0 00000000 e09debe6 e09f4624 00000100 =
00000080=20
       00003000 00000000 00000000 e085052b e0a1c208 00000000 e0a03010 =
e0a032ec=20
Call Trace:
 [<e09debe6>] ocfs_initialize_mem_lists+0x45/0x20f [ocfs2]
 [<e085052b>] ocfs_driver_entry+0x52b/0x6cd [ocfs2]
 [<e09f074d>] _GLOBAL__I___divdi3GCOV+0xf/0x64 [ocfs2]
 [<c029ae46>] do_global_ctors+0x81/0xaf
 [<c012f3f0>] sys_init_module+0x148/0x268
 [<c0109121>] sysenter_past_esp+0x52/0x71

Code: 0f 0b f5 04 c0 40 36 c0 8b 0b e9 76 ff ff ff 8b 47 34 c7 04=20
 ------------[ cut here ]------------
kernel BUG at /usr/src/linux-2.6.3/fs/buffer.c:2660!
invalid operand: 0000 [#3]
CPU:    0
EIP:    0060:[<c0150be6>]    Not tainted
EFLAGS: 00010202
EIP is at submit_bh+0x1c9/0x1e3
eax: 00000010   ebx: d7c52000   ecx: 00000286   edx: 00000000
esi: d7c5f1b4   edi: dfc9f7d4   ebp: d7c5f1b4   esp: d7d83d78
ds: 007b   es: 007b   ss: 0068
Process kjournald (pid: 5012, threadinfo=3Dd7d82000 task=3Dd7c96080)
Stack: c17ef900 00000003 00000000 00000000 c0466e18 c01179a6 c17eddb4 =
00000001=20
       d7c52000 d7c5f1b4 dfc9f7d4 00000000 c0150ce0 00000001 d7c5f1b4 =
c014e8c3=20
       c13b6cd0 d7c52000 dfc9f780 c0193817 d7c5f1b4 d76023f0 db1e9aa4 =
d7c5f1b4=20
Call Trace:
 [<c01179a6>] __wake_up_common+0x31/0x50
 [<c0150ce0>] sync_dirty_buffer+0x5c/0xb8
 [<c014e8c3>] mark_buffer_dirty+0x34/0x4c
 [<c0193817>] journal_update_superblock+0x60/0xa1
 [<c0190aeb>] journal_commit_transaction+0x1000/0x1005
 [<c0135f55>] mempool_free+0x33/0x6a
 [<c0227dc9>] freed_request+0xb2/0xba
 [<c0229297>] end_that_request_last+0x58/0xa0
 [<c0225fc8>] elv_queue_empty+0x1f/0x21
 [<c023d2e9>] ide_do_request+0x54/0x32b
 [<c01169ac>] recalc_task_prio+0xb2/0x1ea
 [<c01179a6>] __wake_up_common+0x31/0x50
 [<c011776a>] schedule+0x324/0x51d
 [<c01179a6>] __wake_up_common+0x31/0x50
 [<c0192a6f>] kjournald+0xb1/0x1f1
 [<c0118c6b>] autoremove_wake_function+0x0/0x4f
 [<c0118c6b>] autoremove_wake_function+0x0/0x4f
 [<c0109086>] ret_from_fork+0x6/0x14
 [<c01929b4>] commit_timeout+0x0/0x9
 [<c01929be>] kjournald+0x0/0x1f1
 [<c0107289>] kernel_thread_helper+0x5/0xb

Code: 0f 0b 64 0a e0 53 36 c0 e9 5b fe ff ff 0f 0b 63 0a e0 53 36=20
=20


> -----Original Message-----
> From: Mark Fasheh [mailto:mark.fasheh@oracle.com]=20
> Sent: 2004=C4=EA4=D4=C221=C8=D5 1:56
> To: Ling, Xiaofeng
> Cc: Zhang, Sonic; Ocfs2-Devel
> Subject: Re: [Ocfs2-devel] Patches to fix the OCFS2 bug 54,=20
> which cause crashin the second mount under kernel 2.6.
>=20
>=20
> On Tue, Apr 20, 2004 at 01:07:53PM +0800, Ling, Xiaofeng wrote:
> > On 2.6.3 kernel, there are compiling errors. After resolve it, the=20
> > mount and remount is ok.
> Ahh excellent. Hopefully that's the last bit of 2.6 stuff I=20
> messed up :)
> 	--Mark
>=20
> --
> Mark Fasheh
> Software Developer, Oracle Corp
> mark.fasheh@oracle.com
>=20
